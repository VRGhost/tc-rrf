#!/usr/bin/env python3

# Render templates to distributable (uploadable) scripts

import argparse
import os
import glob

import yaml
import jinja2

def render_group(config_el, templates_root):
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
            out[out_fname] = template.render(**input_vars)

    return out

def main(args):
    templates_root = os.path.abspath(args['templates_root'])
    assert os.path.isdir(templates_root), templates_root

    with open(args['index'], 'r') as fin:
        index = yaml.load(fin, Loader=yaml.SafeLoader)

    rendered = {} # Relpath -> text
    for render_el in index['render']:
        render_out = render_group(render_el, templates_root)
        intersection = render_out.keys() & rendered.keys()
        if intersection:
            raise NotImplementedError(f"Multiple sections attempted to return {intersection}")
        rendered.update(render_out)
    print(rendered)

def get_arg_parser():
    PROJ_DIR = os.path.abspath(os.path.join(
        os.path.dirname(__file__),
        os.pardir
    ))
    TEMPLATES_ROOT = os.path.join(PROJ_DIR, 'resources', 'templates')
    parser = argparse.ArgumentParser(description='Renders templates into uploadable scripts')
    parser.add_argument('--templates-root', help='Templates root', default=TEMPLATES_ROOT)
    parser.add_argument('index', help='Input yaml file')
    return parser

if __name__ == '__main__':
    args = get_arg_parser().parse_args()
    main(args.__dict__)