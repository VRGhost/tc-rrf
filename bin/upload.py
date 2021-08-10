#!/usr/bin/env python3

import argparse
import os
import sys

import duetwebapi

## Upload RRF scripts to the DWC

def sync_sys(api, local_dir):
    assert os.path.isdir(local_dir), local_dir
    cur_remote = api.get_directory()

def main(args):
    printer = duetwebapi.DuetWebAPI(args['host'])
    if args['sys']:
        sync_sys(printer, args['sys'])

def get_arg_parser():
    PROJ_DIR = os.path.abspath(os.path.join(
        os.path.dirname(__file__),
        os.pardir
    ))
    RRF_ROOT = os.path.join(PROJ_DIR, 'rrf3.x')
    parser = argparse.ArgumentParser(description='Override DWC scripts with local copies')
    parser.add_argument('--sys', help='Sys dir', default=os.path.join(RRF_ROOT, 'sys'))
    parser.add_argument('--macros', help='Macros dir', default=os.path.join(RRF_ROOT, 'macros'))
    parser.add_argument('--host', required=True, help='Duet Web Console (DWC) url. E.g "http://192.168.242.45"')
    return parser

if __name__ == '__main__':
    args = get_arg_parser().parse_args()
    main(args.__dict__)
