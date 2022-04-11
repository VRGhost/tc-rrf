#!/usr/bin/env python3

# Render templates to distributable (uploadable) scripts

import argparse
import os
import glob
import shutil
import itertools
import logging
import copy
import types

import yaml
import jinja2
from mergedeep import merge


class PyFunctions:
    """Object providing some Python functions to Jinja template."""

    uid = None

    def __init__(self, global_vars):
        self.uid = itertools.count()
        self.global_vars = global_vars

    def unique_var(self, prefix="var"):
        return f"{prefix}_{next(self.uid)}"

    def format_gcode_param_str(self, dict_params=None, **kw_params):
        """Converts dict of {param} -> <val> to a gcode string of <param><val>.

        Creates ':' - separated list if <val> is a list.
        """

        def _map_simple_val(orig_val):
            out = None
            if isinstance(orig_val, float):
                out = "{:0.4f}".format(orig_val)
            elif isinstance(orig_val, int):
                out = str(orig_val)
            elif isinstance(orig_val, str):
                # A string
                out = orig_val
                for doubled_char in ('"', "'"):
                    # All quotation chars have to be doubled when inside a string
                    out = out.replace(doubled_char, doubled_char * 2)
                out = f'"{out}"'
            elif orig_val is None:
                out = None  # Return None (do not map it to a string)
            else:
                raise NotImplementedError(orig_val)
            return out

        params = (dict_params or {}).copy()
        params.update(kw_params)

        out = []
        for key in sorted(params.keys()):
            orig_val = params[key]
            if isinstance(orig_val, (list, tuple)):
                gcode_val = ":".join(_map_simple_val(el) for el in orig_val)
            else:
                gcode_val = _map_simple_val(orig_val)
            if gcode_val is not None:
                # Skip any empty values
                out.append(f"{key}{gcode_val}")
        return " ".join(out)

    def zip(self, *args, **kwargs):
        return zip(*args, **kwargs)

    def floatWithinBoundsCond(
        self, var_name, prev_val=None, cur_val=None, next_val=None
    ):
        """Return duet meta if condition that is true when the float in var_name is _approximatly_ cur_val (boundaries specified by prev & next vals).

        An open boundary is assumed if the prev/next floats are not provided.
        """
        conditions = []
        if cur_val is None:
            assert prev_val is None
            assert next_val is None
        else:
            assert isinstance(cur_val, float)
            if prev_val is not None:
                assert isinstance(prev_val, float)
                real_prev_limit = (cur_val + prev_val) / 2.0
                conditions.append(
                    "{var_name} >= {limit:.5f}".format(
                        var_name=var_name, limit=real_prev_limit
                    )
                )
            if next_val is not None:
                assert isinstance(next_val, float)
                real_next_limit = (cur_val + next_val) / 2.0
                conditions.append(
                    "{var_name} < {limit:.5f}".format(
                        var_name=var_name, limit=real_next_limit
                    )
                )

        if not conditions:
            # Unable to generate boundary conditions
            conditions.append("true")

        return " && ".join("({})".format(el) for el in conditions)  # CNF

    def get_merged_dynamic_overrides(self, tool_id, nozzle_d, filament):
        effective_dict_queue = [{}]

        tool_dict = [
            tool_dict
            for tool_dict in self.global_vars["tools"].values()
            if tool_dict["id"] == tool_id
        ]
        assert len(tool_dict) == 1
        tool_dict = tool_dict[0]

        root_dict = self.global_vars["dynamic_overrides"]

        effective_dict_queue.append(root_dict.get("default", {}))
        effective_dict_queue.append(root_dict["filaments"][filament].get("default", {}))

        extruder_key = "direct" if tool_dict["is_direct"] else "bowden"
        effective_dict_queue.append(
            root_dict["filaments"][filament]["extruders"][extruder_key]
        )

        effective_dict_queue.append(
            root_dict["filaments"][filament]["nozzles"][nozzle_d]
        )

        return merge(*effective_dict_queue)

    @property
    def g(self):
        """Return global vars."""
        return types.SimpleNamespace(**copy.deepcopy(self.global_vars))


def render_group(global_vars, config_el, templates_root):
    out = {}

    out_dir = config_el["output"]["directory"]
    input_dir = config_el["input"]["directory"]
    input_vars = config_el["variables"]

    jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(templates_root))
    jinja_env.globals.update(
        py=PyFunctions(
            global_vars=global_vars,
        )
    )

    for fname_pair in config_el["input"]["files"]:
        (input_fname, output_fname) = fname_pair.split(":")
        full_fname = os.path.normpath(
            os.path.join(templates_root, input_dir, input_fname)
        )
        assert os.path.isdir(os.path.dirname(full_fname)), full_fname
        for glob_item in glob.iglob(full_fname, recursive=True):
            # fname may be a glob pattern
            if os.path.isdir(glob_item):
                continue  # Skip directories
            template = jinja_env.get_template(
                os.path.relpath(glob_item, templates_root)
            )

            if output_fname == "*":
                new_out_fname = os.path.basename(
                    glob_item
                )  # special case - re-use the original fname on '*'
            elif output_fname == "**":
                new_out_fname = os.path.relpath(glob_item, os.path.dirname(full_fname))
            else:
                new_out_fname = output_fname
            out_full_fname = os.path.join(out_dir, new_out_fname)

            render_vars = {
                "__output_file__": out_full_fname,
            }
            render_vars.update(global_vars)
            render_vars.update(input_vars)
            try:
                render_out = template.render(**render_vars)
            except:
                logging.fatal(f"Error rendering {glob_item!r}")
                raise
            if not render_out.endswith("\n"):
                # Ensure all outputs terminate with an empty line (just in case)
                render_out += "\n"
            out[out_full_fname] = render_out

    return out


def save_output(files, output_root):
    if os.path.exists(output_root):
        shutil.rmtree(output_root)
    os.makedirs(output_root)

    tested_dirs = set()
    for (fname, payload) in files.items():
        out_fname = os.path.join(output_root, fname)
        # Ensure out dir exists
        out_dir = os.path.dirname(out_fname)
        if out_dir not in tested_dirs:
            if not os.path.exists(out_dir):
                os.makedirs(out_dir)
            tested_dirs.add(out_dir)
        with open(out_fname, "wb") as fout:
            fout.write(
                payload.encode("ascii")
            )  # Apologies to the unicode users, but this is safer.


def main(args):
    global_templates_root = os.path.abspath(args["templates_root"])
    assert os.path.isdir(global_templates_root), global_templates_root

    global_output_root = os.path.abspath(args["output_root"])
    assert os.path.isdir(global_output_root), global_output_root

    with open(args["index"], "r") as fin:
        index = yaml.load(fin, Loader=yaml.SafeLoader)

    user_templates_root = os.path.normpath(
        os.path.join(global_templates_root, index["templates_root"])
    )
    assert os.path.isdir(user_templates_root), user_templates_root
    global_vars = index.get("variables") or {}

    rendered = {}  # Relpath -> text
    for render_el in index["render"]:
        render_out = render_group(global_vars, render_el, user_templates_root)
        intersection = render_out.keys() & rendered.keys()
        if intersection:
            raise NotImplementedError(
                f"Multiple sections attempted to return {intersection}"
            )
        rendered.update(render_out)

    user_output_root = os.path.normpath(
        os.path.join(global_output_root, index["output_root"])
    )
    save_output(rendered, user_output_root)
    print(f"Rendered {len(rendered)} files.")


def get_arg_parser():
    PROJ_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))
    TEMPLATES_ROOT = os.path.join(PROJ_DIR, "resources", "templates")
    parser = argparse.ArgumentParser(
        description="Renders templates into uploadable scripts"
    )
    parser.add_argument(
        "--templates-root", help="Templates root", default=TEMPLATES_ROOT
    )
    parser.add_argument(
        "--output-root", help="Output root", default=os.path.join(PROJ_DIR, "dist")
    )
    parser.add_argument("index", help="Input yaml file")
    return parser


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    args = get_arg_parser().parse_args()
    main(args.__dict__)
