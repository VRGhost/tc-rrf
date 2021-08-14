#!/usr/bin/env python3

# Render templates to distributable (uploadable) scripts

import argparse
import os
import glob
import shutil

import yaml
import jinja2

def render_group(global_vars, config_el, templates_root):
    out = {}

    out_dir = config_el['output']['directory']
    input_dir = config_el['input']['directory']
    input_vars = config_el['variables']

    jinja_env = jinja2.Environment(
        loader=jinja2.FileSystemLoader(templates_root)
    )

    for fname in config_el['input']['files']:
        full_fname = os.path.normpath(
            os.path.join(templates_root, input_dir, fname)
        )
        for glob_item in glob.iglob(full_fname):
            # fname may be a glob pattern
            template = jinja_env.get_template(os.path.relpath(
                glob_item, templates_root
            ))
            out_fname = os.path.join(out_dir, os.path.basename(glob_item))

            render_vars = {
                '__output_file__': out_fname
            }
            render_vars.update(global_vars)
            render_vars.update(input_vars)

            render_out = template.render(**render_vars)
            if not render_out.endswith('\n'):
                # Ensure all outputs terminate with an empty line (just in case)
                render_out += '\n'
            out[out_fname] = render_out

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
    templates_root = os.path.abspath(args['templates_root'])
    assert os.path.isdir(templates_root), templates_root

    global_output_root = os.path.abspath(args['output_root'])
    assert os.path.isdir(global_output_root), global_output_root

    with open(args['index'], 'r') as fin:
        index = yaml.load(fin, Loader=yaml.SafeLoader)

    global_vars = index.get('variables') or {}

    rendered = {} # Relpath -> text
    for render_el in index['render']:
        render_out = render_group(global_vars, render_el, templates_root)
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
    args = get_arg_parser().parse_args()
    main(args.__dict__)