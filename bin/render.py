#!/usr/bin/env python3

# Render templates to distributable (uploadable) scripts

import argparse
import os
import glob
import shutil
import itertools
import logging

import yaml
import jinja2

class PyFunctions:
    """Object providing some Python functions to Jinja template."""

    uid = None

    def __init__(self):
        self.uid = itertools.count()

    def unique_var(self, prefix='var'):
        return f"{prefix}_{next(self.uid)}"

    def format_gcode_param_str(self, dict_params=None, **kw_params):
        """Converts dict of {param} -> <val> to a gcode string of <param><val>.

        Creates ':' - separated list if <val> is a list.
        """
        def _map_simple_val(orig_val):
            out = None
            if isinstance(orig_val, float):
                out = '{:0.4f}'.format(orig_val)
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
                out = None # Return None (do not map it to a string)
            else:
                raise NotImplementedError(orig_val)
            return out

        params = (dict_params or {}).copy()
        params.update(kw_params)

        out = []
        for key in sorted(params.keys()):
            orig_val = params[key]
            if isinstance(orig_val, (list, tuple)):
                gcode_val = ':'.join(_map_simple_val(el) for el in orig_val)
            else:
                gcode_val = _map_simple_val(orig_val)
            if gcode_val is not None:
                # Skip any empty values
                out.append(f"{key}{gcode_val}")
        return ' '.join(out)

    def zip(self, *args, **kwargs):
        return zip(*args, **kwargs)

def render_group(global_vars, config_el, templates_root):
    out = {}

    out_dir = config_el['output']['directory']
    input_dir = config_el['input']['directory']
    input_vars = config_el['variables']

    jinja_env = jinja2.Environment(
        loader=jinja2.FileSystemLoader(templates_root)
    )
    jinja_env.globals.update(
        py=PyFunctions()
    )

    for fname_pair in config_el['input']['files']:
        (input_fname, output_fname) = fname_pair.split(':')
        full_fname = os.path.normpath(
            os.path.join(templates_root, input_dir, input_fname)
        )
        assert os.path.isdir(os.path.dirname(full_fname)), full_fname
        for glob_item in glob.iglob(full_fname, recursive=True):
            # fname may be a glob pattern
            if os.path.isdir(glob_item):
                continue # Skip directories
            template = jinja_env.get_template(os.path.relpath(
                glob_item, templates_root
            ))

            if output_fname == '*':
                new_out_fname = os.path.basename(glob_item) # special case - re-use the original fname on '*'
            elif output_fname == '**':
                new_out_fname = os.path.relpath(glob_item, os.path.dirname(full_fname))
            else:
                new_out_fname = output_fname
            out_full_fname = os.path.join(out_dir, new_out_fname)

            render_vars = {
                '__output_file__': out_full_fname,
            }
            render_vars.update(global_vars)
            render_vars.update(input_vars)
            try:
                render_out = template.render(**render_vars)
            except:
                logging.fatal(f"Error rendering {glob_item!r}")
                raise
            if not render_out.endswith('\n'):
                # Ensure all outputs terminate with an empty line (just in case)
                render_out += '\n'
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
        with open(out_fname, 'wb') as fout:
            fout.write(payload.encode('ascii')) # Apologies to the unicode users, but this is safer.

def main(args):
    global_templates_root = os.path.abspath(args['templates_root'])
    assert os.path.isdir(global_templates_root), global_templates_root

    global_output_root = os.path.abspath(args['output_root'])
    assert os.path.isdir(global_output_root), global_output_root

    with open(args['index'], 'r') as fin:
        index = yaml.load(fin, Loader=yaml.SafeLoader)

    user_templates_root = os.path.normpath(os.path.join(global_templates_root, index['templates_root']))
    assert os.path.isdir(user_templates_root), user_templates_root
    global_vars = index.get('variables') or {}

    rendered = {} # Relpath -> text
    for render_el in index['render']:
        render_out = render_group(global_vars, render_el, user_templates_root)
        intersection = render_out.keys() & rendered.keys()
        if intersection:
            raise NotImplementedError(f"Multiple sections attempted to return {intersection}")
        rendered.update(render_out)

    user_output_root = os.path.normpath(os.path.join(global_output_root, index['output_root']))
    save_output(rendered, user_output_root)
    print(f"Rendered {len(rendered)} files.")

def get_arg_parser():
    PROJ_DIR = os.path.abspath(os.path.join(
        os.path.dirname(__file__),
        os.pardir
    ))
    TEMPLATES_ROOT = os.path.join(PROJ_DIR, 'resources', 'templates')
    parser = argparse.ArgumentParser(description='Renders templates into uploadable scripts')
    parser.add_argument('--templates-root', help='Templates root', default=TEMPLATES_ROOT)
    parser.add_argument('--output-root', help='Output root', default=os.path.join(PROJ_DIR, 'dist'))
    parser.add_argument('index', help='Input yaml file')
    return parser

if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    args = get_arg_parser().parse_args()
    main(args.__dict__)