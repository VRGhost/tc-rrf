#!/usr/bin/env python3

import argparse
import sys
import re
import os
import collections

TC = collections.namedtuple('_TC', ['tool', 'extruded'])

class ToolChangeSequence:

    def __init__(self, parsed_tc):
        self.all_tcs = tuple(parsed_tc)
        self.iter_idx = -1

    @property
    def prev_tool(self):
        if self.iter_idx <= 0:
            return TC(tool=None, extruded=0)
        return self.all_tcs[self.iter_idx - 1]

    @property
    def cur_tool(self):
        return self.all_tcs[self.iter_idx]

    @property
    def next_tool(self):
        if self.iter_idx >= len(self.all_tcs) - 1:
            return TC(tool=None, extruded=self.all_tcs[-1].extruded)
        return self.all_tcs[self.iter_idx + 1]

    def totalExtrudeTillNextChange(self):
        """Calculate total length extruded until next (real) TC event."""
        cur_tool = self.cur_tool
        found = None
        for found in self.all_tcs[self.iter_idx+1:]:
            if found.tool != cur_tool:
                break
        if not found:
            assert self.next_tool.tool == None
            return 0
        return found.extruded - cur_tool.extruded


    def next(self):
        self.iter_idx += 1

    def allPastTools(self):
        return frozenset(el.tool for el in self.all_tcs[:self.iter_idx])

    def allFutureTools(self):
        return frozenset(el.tool for el in self.all_tcs[self.iter_idx+1:])

def parse_tool_switch(line):
    TC_re = re.compile(r'^T(\d+)(\s*P\d+)?\s*(;.*)?$')
    match = TC_re.match(line.strip())
    if match:
        return match.group(1)
    else:
        return None

def parse_extrude(line):
    E_re = re.compile(r'\s+E(\d+(\.\d+)?)[\s$]')
    match = E_re.search(line)
    if match:
        return float(match.group(1))
    return None

def parse_tool_changes(input_file):
    total_extrude_dist = 0
    tool_ids = []
    for line in input_file:
        new_tool_id = parse_tool_switch(line)
        if new_tool_id:
            tool_ids.append(TC(tool=new_tool_id, extruded=total_extrude_dist))
        # Try extracting extrude dists
        extra_extrude_dist = parse_extrude(line)
        if extra_extrude_dist:
            total_extrude_dist += extra_extrude_dist
    return tool_ids

TOOL_HEAT_OFF = 'A0'
TOOL_HEAT_STANDBY = 'A1'
TOOL_HEAT_ON = 'A2'

def patch_temp_changes(input_line, tool_change_tracker):
    local_tc_event = parse_tool_switch(input_line)
    if not local_tc_event:
        return (input_line, ) # Return the original line unchanged
    # TC is happening on this line
    tool_change_tracker.next()
    ####
    prev_tool = tool_change_tracker.prev_tool.tool
    exp_tool = tool_change_tracker.cur_tool.tool
    next_tool = tool_change_tracker.next_tool.tool
    assert exp_tool == local_tc_event, (exp_tool, local_tc_event)
    if exp_tool == prev_tool:
        # A virtual TC (on layer switch). Ignore.
        return (input_line, )

    turn_off_prev_tool = all([
        any([
            (next_tool is None),
            (prev_tool != next_tool),
        ]),
        (prev_tool is not None),
        (prev_tool != local_tc_event), # Do not turn off the tool if it is the one that will be used RIGHT NOW
    ])

    will_extrude_now = tool_change_tracker.totalExtrudeTillNextChange()

    next_tool_heat_mode = None
    if next_tool not in tool_change_tracker.allPastTools():
        next_tool_heat_mode = TOOL_HEAT_STANDBY

    if will_extrude_now < 200:
        next_tool_heat_mode = TOOL_HEAT_ON

    if next_tool is None:
        next_tool_heat_mode = None

    return (
        ';;;;; apply_tool_temps.py TOP',
        f'; prev = {prev_tool}, cur = {exp_tool}, next = {next_tool}; E={will_extrude_now}',
        f'M568 P{next_tool} {next_tool_heat_mode}' if next_tool_heat_mode else '',
        ';;;;; END apply_tool_temps.py TOP',
        input_line,
        ';;;;; apply_tool_temps.py BOT',
        # Preheat next tool to standby temp
        #   running the command after TC to override default standby behaviour when next_tool == prev_tool
        f'M568 P{next_tool} {next_tool_heat_mode}' if next_tool_heat_mode else '',
        f'M568 P{prev_tool} A0' if turn_off_prev_tool else '', # Turn off prev tool if required
        ';;;;; END apply_tool_temps.py BOT',
    )


def main(args):
    with open(args['input_gcode'], 'r') as fin:
        tool_changes = parse_tool_changes(fin)

    tool_change_tracker = ToolChangeSequence(tool_changes)

    new_gcode_lines = []
    with open(args['input_gcode'], 'r') as fin:
        for line in fin:
            new_gcode_lines.extend(patch_temp_changes(
                line.rstrip(), tool_change_tracker
            ))

    out_fname = args['out']
    if out_fname is None:
        (pth, ext) = os.path.splitext(args['input_gcode'])
        out_fname = f"{pth}.patched{ext}"

    with open(out_fname, 'w') as fout:
        for line in new_gcode_lines:
            fout.write(line + '\n')
    print(f"Result saved into {out_fname}")

def get_arg_parser():
    parser = argparse.ArgumentParser(description='Override DWC scripts with local copies')
    parser.add_argument('input_gcode', help='Input gcode to patch')
    parser.add_argument('--out', default=None)
    return parser

if __name__ == '__main__':
    args = get_arg_parser().parse_args()
    main(args.__dict__)
