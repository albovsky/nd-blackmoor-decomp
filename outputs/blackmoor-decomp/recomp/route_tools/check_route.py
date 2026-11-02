#!/usr/bin/env python3
"""Check the actual headless telescope-prep result, not merely its process exit.

python3 check_route.py RUN_LOG SAVE_FILE
The save must come from this run's normal Load & Save UI. No game state is read
or changed; the checker reads only the recorded observations and save size.
"""
import json
import re
import sys
from pathlib import Path


def flag_scope(text):
    flags = set()
    for part in text.split(','):
        match = re.fullmatch(r'(\d+)(?:-(\d+))?', part)
        if not match:
            raise ValueError('invalid recorded RC_FLAGS range')
        lo = int(match[1])
        hi = int(match[2] or match[1])
        if not 0 <= lo <= hi <= 2250:
            raise ValueError('recorded RC_FLAGS range outside the game event table')
        flags.update(range(lo, hi + 1))
    return flags


def verify(log, save):
    observations = []
    state = None
    scope = set()
    for line in log.splitlines():
        match = re.fullmatch(r'\s*STATE requested_scene=(\d+) art_scene=(\d+) view=(-?\d+) held_item=(-?\d+)', line)
        if match:
            state = tuple(map(int, match.groups()))
            scope = set()
        elif line.startswith('  RC_FLAGS '):
            scope = flag_scope(line.removeprefix('  RC_FLAGS '))
        elif line.startswith('  FLAGS') and state is not None:
            values = {int(k): int(v) for k, v in re.findall(r'(\d+)=(\d+)', line)}
            observations.append((state, scope.copy(), values))
    # The pre-click frame check catches a missed/extra turn before the tripod.
    expected = [(2010, 0), (2014, 0), (2026, 0), (2010, 2)]
    selected = []
    for observation in observations:
        state, scope, flags = observation
        if len(selected) < len(expected) and (state[0], state[2]) == expected[len(selected)]:
            selected.append(observation)
    if len(selected) != len(expected):
        raise ValueError('missing ordered bedroom/tripod/chart/return observations')
    positive = {1834, 1843, 1905, 1949, 1953, 1993}
    negative = {1309, 1906, 1980, 2036, 2037}
    for _, scope, flags in selected[2:]:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required event')
        if any(flags.get(f, 0) != 1 for f in positive):
            raise ValueError('chart/lens/moon prerequisite flag is not 1')
        if any(flags.get(f, 0) != 0 for f in negative):
            raise ValueError('unexpected telescope-loan/install/completion state')
    # The existing harness prints Windows paths without JSON escaping. Inspect
    # only the stop field; do not treat that whole diagnostic line as valid JSON.
    results = [line[7:] for line in log.splitlines() if line.startswith('RESULT ')]
    if len(results) != 1 or not re.match(r'\{\s*"stopped"\s*:\s*"stop requested(?: |")', results[0]):
        raise ValueError('game did not reach a clean requested stop')
    if not re.search(r'FILE open .*\\' + re.escape(save.name) + r'\s+\[virtual \d+ ms\]', log):
        raise ValueError('this run did not open the requested checkpoint save')
    if not save.is_file() or save.stat().st_size != 170770:
        raise ValueError('checkpoint save is missing or has an unexpected length')
    return {'route': 'telescope-prep', 'scene': 2010, 'view': 2,
            'flags_one': sorted(positive), 'flags_zero': sorted(negative),
            'save': save.name, 'telescope_complete': False}


if __name__ == '__main__':
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    try:
        print(json.dumps(verify(Path(sys.argv[1]).read_text(), Path(sys.argv[2])), sort_keys=True))
    except (ValueError, OSError) as error:
        raise SystemExit('route verification failed: ' + str(error))
