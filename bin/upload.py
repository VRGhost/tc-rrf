#!/usr/bin/env python3

import argparse
import collections
import os
import sys
import fnmatch
import datetime
import posixpath as pp

import yaml
import duetwebapi


class Action:
    """A single action."""

    typ = None  # 'copy/delete/create_dir'

    def __init__(self, typ, remote_path, local_path, description):
        assert typ in ("copy", "delete", "create_dir")
        self.typ = typ
        self.remote_path = remote_path
        self.local_path = local_path
        self.description = description

    def __repr__(self):
        return f"<{self.__class__.__name__} typ={self.typ} remote_path={self.remote_path!r} local_path={self.local_path!r} ({self.description})>"


class ActionLedger:
    """This object holds all actions to be performed until reviewed and confirmed by the user."""

    create = ()
    copy = ()
    delete = ()

    def delete_remote(self, remote_path, description):
        self.delete += (
            Action("delete", remote_path, local_path=None, description=description),
        )

    def copy_to_remote(self, local_path, remote_path, description):
        self.copy += (Action("copy", remote_path, local_path, description),)

    def create_remote_directory(self, remote_path):
        self.create += (
            Action(
                "create_dir", local_path=None, remote_path=remote_path, description=""
            ),
        )

    def extend(self, other):
        """Extend this ledger with data from another ledger."""
        self.delete += other.delete
        self.copy += other.copy
        self.create += other.create

    def __len__(self):
        # Returns number of actions schedules
        return len(self.create) + len(self.copy) + len(self.delete)

    def __repr__(self):
        return f"<{self.__class__.__name__} copy={self.copy} delete={self.delete} create={self.create}>"


## Helpers

PrinterFile = collections.namedtuple(
    "PrinterFile",
    [
        "is_file",
        "is_directory",
        "name",
        "full_path",
        "parent_directory",
        "date",
        "size",
    ],
)


def get_printer_directory(api, remote_path, recursive):
    """A wrapper around api.get_directory() that provides more Pythonic data objects."""
    raw_out = api.get_directory(remote_path)
    out = [
        PrinterFile(
            is_file=(el["type"] == "f"),
            is_directory=(el["type"] == "d"),
            name=el["name"],
            full_path=pp.join(remote_path, el["name"]),
            parent_directory=remote_path,
            size=int(el["size"]),
            date=datetime.datetime.fromisoformat(el.get("date", "2000-01-01T00:00:00")),
        )
        for el in raw_out
    ]
    if recursive:
        all_dirs = tuple(el for el in out if el.is_directory)
        for dir_el in all_dirs:
            out += get_printer_directory(
                api, remote_path=dir_el.full_path, recursive=recursive
            )
    return out


LocalFile = collections.namedtuple(
    "LocalFile",
    [
        "is_file",
        "is_directory",
        "name",
        "full_path",
        "parent_directory",
        "printer_path",  # Expected printer path
        "stat",
    ],
)


def list_local_files(root, printer_root):
    """List all local files in the `root` dir that are available for sync"""
    out = []
    for (dirpath, dirnames, files) in os.walk(os.path.abspath(root)):
        for name in dirnames:
            full_path = os.path.join(dirpath, name)
            relpath = os.path.relpath(full_path, root)
            out.append(
                LocalFile(
                    is_file=False,
                    is_directory=True,
                    name=name,
                    full_path=full_path,
                    printer_path=pp.join(printer_root, relpath),
                    parent_directory=dirpath,
                    stat=os.stat(full_path),
                )
            )
        for name in files:
            full_path = os.path.join(dirpath, name)
            relpath = os.path.relpath(full_path, root)
            out.append(
                LocalFile(
                    is_file=True,
                    is_directory=False,
                    name=name,
                    full_path=full_path,
                    printer_path=pp.join(printer_root, relpath),
                    parent_directory=dirpath,
                    stat=os.stat(full_path),
                )
            )
    return out


## Upload RRF scripts to the DWC


def create_update_ledger(api, remote_dir, local_files):
    # Returns ActionLedger
    out = ActionLedger()

    remote_list = get_printer_directory(api, remote_dir, recursive=True)
    local_file_dict = dict((el.printer_path, el) for el in local_files)
    remote_file_dict = dict((el.full_path, el) for el in remote_list)
    all_paths = set(local_file_dict.keys()) | set(remote_file_dict.keys())

    for path in all_paths:
        local_rec = local_file_dict.get(path)
        remote_rec = remote_file_dict.get(path)
        if local_rec is None and remote_rec is not None:
            # File present on the remote, but not locally => Delete
            out.delete_remote(
                path, description=f"Deleting {path!r} as it is absent from local store"
            )
        elif local_rec and remote_rec is None:
            if local_rec.is_directory:
                out.create_remote_directory(local_rec.printer_path)
                print(out.create)
            else:
                out.copy_to_remote(
                    local_path=local_rec.full_path,
                    remote_path=local_rec.printer_path,
                    description="",
                )
        elif local_rec and remote_rec:
            # Both exist
            if local_rec.is_directory and remote_rec.is_directory:
                # Both are dirs - ignore
                pass
            elif local_rec.is_file and remote_rec.is_file:
                # Both are files. Update the remote just in case
                out.copy_to_remote(
                    local_path=local_rec.full_path,
                    remote_path=local_rec.printer_path,
                    description="",
                )
            else:
                raise NotImplementedError(f"{local_rec} <=> {remote_rec} ?")
        else:
            raise NotImplementedError(f"{local_rec}, {remote_rec}")
    return out


def filter_ledger(ledger, create=(), copy=(), delete=()):
    """Return a new ledger with all files mathing the provided patterns REMOVED."""
    filtered_data = {}

    for (name, rm_filters) in [("create", create), ("copy", copy), ("delete", delete)]:
        raw_data = getattr(ledger, name)
        good_data = []
        for raw_el in raw_data:
            if not any(
                fnmatch.fnmatch(raw_el.remote_path, pattern) for pattern in rm_filters
            ):
                good_data.append(raw_el)
        filtered_data[name] = good_data

    out = ActionLedger()
    for (name, val) in filtered_data.items():
        setattr(out, name, tuple(val))
    return out


def sync_sys(api, local_dir):
    assert os.path.isdir(local_dir), local_dir
    local_files = list_local_files(local_dir, printer_root="/sys")
    # override relative path to match printers' absolute one
    raw_ledger = create_update_ledger(
        api,
        remote_dir="/sys",
        local_files=local_files,
    )
    return filter_ledger(
        raw_ledger,
        delete=[
            "/sys/*.bin",
            "/sys/*.json",
            "/sys/*.csv",
            "/sys/logs",
            "/sys/logs/*",  # do not GC the logs
            "/sys/manifest.json.gz",
            "/sys/config-override.g",
        ],
    )


def sync_macros(api, local_dir):
    assert os.path.isdir(local_dir), local_dir
    local_files = list_local_files(local_dir, printer_root="/macros")
    # override relative path to match printers' absolute one
    raw_ledger = create_update_ledger(
        api,
        remote_dir="/macros",
        local_files=local_files,
    )
    return filter_ledger(raw_ledger, delete=["/macros/SETNETWORK*"])


def execute_ledger(printer, ledger):
    # Only asking about deletes as they're where the danger is. Create/copy should be generally safe.
    delete_list = []
    if ledger.delete:
        print("Please confirm following changes:")
        print("DELETE:")
        for el in ledger.delete:
            print(f"\t{el.remote_path!r} :: {el.description}")
        yn = input("Do you agree? [yN] >>>\t")
        if yn.strip().lower() != "y":
            print("Aborting")
            return
        delete_list.extend(el.remote_path for el in ledger.delete)
        # the sort() is a rough way to insure that children are deleted first.
        delete_list.sort(key=lambda el: len(el), reverse=True)

    ### ACTUAL ACTION
    for el in delete_list:
        (dirname, fname) = pp.split(el)
        printer.delete_file(filename=fname, directory=dirname)
    for el in ledger.create:
        if el.typ == "create_dir":
            printer.create_directory(el.remote_path)
        else:
            raise NotImplementedError(el)
    for el in ledger.copy:
        with open(el.local_path, "rb") as fin:
            data = fin.read()
        (dirname, fname) = pp.split(el.remote_path)
        printer.upload_file(data, filename=fname, directory=dirname)


def main(args):
    with open(args["index"], "r") as fin:
        index = yaml.load(fin, Loader=yaml.SafeLoader)

    global_output_root = os.path.abspath(args["output_root"])
    user_output_root = os.path.normpath(
        os.path.join(global_output_root, index["output_root"])
    )

    printer = duetwebapi.DuetWebAPI(args["host"])
    printer.connect(args["password"])
    ledger = ActionLedger()
    try:
        for (dirname, handler) in [
            ("sys", sync_sys),
            ("macros", sync_macros),
        ]:
            user_dir = os.path.join(user_output_root, dirname)
            if os.path.exists(user_dir):
                assert os.path.isdir(user_dir), user_dir
                dir_ledger = handler(printer, user_dir)
                ledger.extend(dir_ledger)
        if ledger:
            execute_ledger(printer, ledger)
            print(f"{len(ledger)} files synchronised.")

    finally:
        printer.disconnect()


def get_arg_parser():
    PROJ_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))

    parser = argparse.ArgumentParser(
        description="Override DWC scripts with local copies"
    )
    parser.add_argument(
        "--output-root", help="Output root", default=os.path.join(PROJ_DIR, "dist")
    )
    parser.add_argument(
        "--host",
        required=True,
        help='Duet Web Console (DWC) url. E.g "http://192.168.242.45"',
    )
    parser.add_argument("--password", default="", help="DWC password")
    parser.add_argument("index", help="Yaml file the files were generated from")
    return parser


if __name__ == "__main__":
    args = get_arg_parser().parse_args()
    main(args.__dict__)
