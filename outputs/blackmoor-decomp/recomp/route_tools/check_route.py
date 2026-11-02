#!/usr/bin/env python3
"""Check an observed headless story leg, not merely its process exit.

python3 check_route.py RUN_LOG SAVE_FILE [--route telescope-prep|jane-jigsaw|telescope-use|seedlings|crank-repair|betty-key|venus-column|jupiter-column|moon-key|moon-column]
The caller supplies a checkpoint produced by this run's normal Load & Save UI.
This checks recorded observations, a matching file-open line and save size;
fresh-folder/write provenance and saved contents require separate replay evidence.
No game state is read or changed.
"""
import argparse
import json
import re
from pathlib import Path


# These RC_FLAGS cells overlap the original clock, not story events.
CLOCK_OVERLAP_DIAGNOSTICS = frozenset(range(338, 342))


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
    return flags - CLOCK_OVERLAP_DIAGNOSTICS


def verify(log, save, route='telescope-prep'):
    if route == 'telescope-prep':
        expected = [(2010, 0), (2014, 0), (2026, 0), (2010, 2)]
        positive = {1834, 1843, 1905, 1949, 1953, 1993}
        negative = {1309, 1906, 1980, 2036, 2037}
    elif route == 'jane-jigsaw':
        expected = [(3575, 0), (1234, 0), (3510, 4)]
        positive = {1424, 1567, 1570, 1905, 1980, 1993}
        negative = {1309, 1906, 2036, 2037}
    elif route == 'telescope-use':
        expected = [(3507, 0), (1605, 0), (2078, 0), (2081, 0), (2010, 19)]
        positive = {1424, 1567, 1570, 1574, 1905, 1906, 1980, 1993, 2036, 2037}
        negative = set()
    elif route == 'seedlings':
        expected = [(2348, 0), (2347, 0), (2347, 0)]
        positive = {1535, 1838, 1839, 1968, 2002, 2080,
                    1906, 1980, 1993, 2036, 2037}
        negative = {1160, 1541}
    elif route == 'crank-repair':
        expected = [(2347, 0), (1000, 0), (1089, 0), (2711, 0),
                    (2713, 0), (2702, 0), (2701, 0)]
        positive = {1160, 1541, 1782, 1906, 2002}
        negative = {1963}
    elif route == 'betty-key':
        expected = [(2701, 0), (2702, 0), (2704, 0), (2711, 0),
                    (2711, 0), (2700, 0), (2700, 0)]
        positive = {1160, 1541, 1782, 1906, 1963, 2002}
        negative = set()
    elif route == 'venus-column':
        expected = [(2700, 0), (2605, 16), (2649, 0), (2649, 0),
                    (2686, 0), (2633, 0), (2633, 0)]
        positive = {1160, 1541, 1782, 1892, 1906, 1963, 2000, 2002, 2015}
        negative = {1961, 1999, 2070}
    elif route == 'jupiter-column':
        expected = [(2633, 0), (2605, 8), (2605, 5), (2631, 0),
                    (2631, 0), (2681, 0), (2631, 0), (2631, 0)]
        positive = {1160, 1436, 1541, 1782, 1892, 1906, 1963, 1980, 1981,
                    1993, 2000, 2002, 2015, 2036, 2037}
        negative = {1259, 1597, 1961, 1994, 1996, 1999, 2019, 2070, 2077, 2092}
    elif route == 'moon-key':
        expected = [(2631, 0), (2605, 5), (2605, 0), (3345, 0),
                    (2010, 1), (2010, 3), (2082, 0), (2082, 0),
                    (2083, 0), (2085, 0), (2090, 0), (2087, 0),
                    (2088, 0), (2087, 0), (2087, 0), (2083, 0),
                    (2018, 0), (2010, 3), (2010, 3)]
        positive = {1160, 1259, 1436, 1541, 1782, 1892, 1906, 1963, 1980, 1981,
                    1993, 1996, 2000, 2002, 2015, 2019, 2036, 2037, 2077, 2092}
        negative = {1597, 1961, 1994, 1999, 2070}
    elif route == 'moon-column':
        expected = [(2010, 3), (2605, 5), (2605, 15), (2626, 0),
                    (2626, 0), (2684, 0), (2626, 0), (2626, 0)]
        positive = {1160, 1259, 1436, 1541, 1597, 1782, 1892, 1906, 1963, 1980,
                    1981, 1993, 1994, 1996, 2000, 2002, 2015, 2019, 2036, 2037, 2077, 2092}
        negative = {1961, 1999, 2070}
    else:
        raise ValueError('unknown story route')
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
            values = {int(k): int(v) for k, v in re.findall(r'(\d+)=(\d+)', line)
                      if int(k) not in CLOCK_OVERLAP_DIAGNOSTICS}
            observations.append((state, scope.copy(), values))
    # Include the pre-click frame for the tripod, or the actual puzzle, win
    # conversation and normal room return for Jane's loan.
    held_steps = {'jupiter-column': {4: 6}, 'moon-key': {7: 12, 13: 11},
                  'moon-column': {4: 11}}.get(route, {})
    selected = []
    for observation in observations:
        state, scope, flags = observation
        if len(selected) < len(expected) and (state[0], state[2]) == expected[len(selected)]:
            # The accepted route observes the panel before opening inventory,
            # inside inventory, and finally with the real crank held.
            if route == 'crank-repair' and len(selected) == 3 and state[3] != 20:
                continue
            if route == 'betty-key' and len(selected) == 4 and state[3] != 19:
                continue
            if route == 'venus-column' and len(selected) == 3 and state[3] != 19:
                continue
            if len(selected) in held_steps and state[3] != held_steps[len(selected)]:
                continue
            selected.append(observation)
    if len(selected) != len(expected):
        raise ValueError('missing ordered route observations')
    if route in ('jupiter-column', 'moon-key', 'moon-column'):
        # Earlier inventory shots can share scene/view/held cells. Check the
        # final two observations, rather than treating those as checkpoints.
        if any((state[0], state[2]) != expected[-1] for state, _, _ in observations[-2:]):
            raise ValueError('missing final safe route observations')
        selected[-2:] = observations[-2:]
    if route == 'jane-jigsaw':
        _, scope, flags = selected[0]
        if not {1424, 1980} <= scope:
            raise ValueError('RC_FLAGS did not observe every required event')
        if flags.get(1424, 0) != 1 or flags.get(1980, 0) != 0:
            raise ValueError('puzzle did not start before the loan win')
    if route == 'telescope-use':
        state, scope, flags = selected[2]
        if 1906 not in scope or 1309 not in selected[3][1]:
            raise ValueError('RC_FLAGS did not observe every required event')
        if flags.get(1906, 0) != 0:
            raise ValueError('telescope was already complete before lens use')
        if state[3] != 12:
            raise ValueError('lens is not held before installation')
        if selected[3][2].get(1309, 0) != 1:
            raise ValueError('lens installation flag is not 1 in the filtered view')
    if route == 'seedlings':
        if any(state[1] != state[0] for state, _, _ in selected):
            raise ValueError('seedlings route art does not match the observed scene')
        if 2002 not in selected[0][1]:
            raise ValueError('RC_FLAGS did not observe every required event')
        if selected[0][2].get(2002, 0) != 0:
            raise ValueError('seedlings puzzle was already complete before packing')
        if selected[1][2].get(2002, 0) != 1:
            raise ValueError('seedlings win was not observed before the checkpoint')
        if selected[-1][0][3] != -1:
            raise ValueError('seedlings checkpoint is not safe with an item held')
    if route == 'crank-repair':
        if any(state[0] != state[1] for state, _, _ in selected):
            raise ValueError('crank route art scene does not match the requested scene')
        for index in (0, 1, 2, 3, 4):
            _, scope, flags = selected[index]
            if not (positive | negative) <= scope:
                raise ValueError('RC_FLAGS did not observe every required event')
            if flags.get(1906, 0) != 1 or flags.get(2002, 0) != 1:
                raise ValueError('telescope or seedlings prerequisite flag is not 1')
            if flags.get(1963, 0) != 0 or flags.get(1782, 0) != 0:
                raise ValueError('crank route began after keypad or card progression')
            if index <= 1 and flags.get(1541, 0) != 0:
                raise ValueError('crank reward was already present before claim')
            if index >= 2 and flags.get(1541, 0) != 1:
                raise ValueError('crank reward flag is not 1 after claim')
            if flags.get(1160, 0) != (1 if index == 4 else 0):
                raise ValueError('crank repair flag does not match pre/post-repair observations')
        if selected[4][0][3] != -1 or selected[5][0][3] != -1 or selected[6][0][3] != -1:
            raise ValueError('crank route did not return to a safe state with no held item')
    if route in ('betty-key', 'venus-column', 'jupiter-column', 'moon-key', 'moon-column'):
        if any(state[0] != state[1] for state, _, _ in selected):
            raise ValueError('key route art scene does not match the requested scene')
        if any(state[3] != -1 for state, _, _ in selected[-2:]):
            raise ValueError('key route did not return to a safe state with no held item')
    if route == 'betty-key':
        for index, (_, scope, flags) in enumerate(selected):
            if not positive <= scope:
                raise ValueError('RC_FLAGS did not observe every required event')
            if any(flags.get(f, 0) != 1 for f in positive - {1963}):
                raise ValueError('Betty prerequisite flag is not 1')
            if flags.get(1963, 0) != (0 if index < 3 else 1):
                raise ValueError('Betty prize flag does not match pre/post-win observations')
    if route in ('venus-column', 'jupiter-column', 'moon-column'):
        transition, after_use, name = {
            'venus-column': ({1892, 2000, 2015}, 4, 'Venus'),
            'jupiter-column': ({1436, 1981}, 5, 'Jupiter'),
            'moon-column': ({1597, 1994}, 5, 'Moon'),
        }[route]
        for index, (_, scope, flags) in enumerate(selected):
            if not (positive | negative) <= scope:
                raise ValueError('RC_FLAGS did not observe every required event')
            if any(flags.get(f, 0) != 1 for f in positive - transition):
                raise ValueError(name + ' earned-key prerequisite flag is not 1')
            if any(flags.get(f, 0) != (0 if index < after_use else 1) for f in transition):
                raise ValueError(name + ' flags do not match pre/post-key-use observations')
            if any(flags.get(f, 0) != 0 for f in negative):
                raise ValueError('unexpected column or armor progression flag')
        if selected[after_use][0][3] != -1:
            raise ValueError(name + ' use did not consume the held key')
    if route == 'moon-key':
        first_one = {1259: 3, 2077: 8, 1996: 9, 2019: 11, 2092: 11}
        for index, (_, scope, flags) in enumerate(selected):
            if not (positive | negative) <= scope:
                raise ValueError('RC_FLAGS did not observe every required event')
            if any(flags.get(f, 0) != 1 for f in positive - first_one.keys()):
                raise ValueError('Moon earned-key prerequisite flag is not 1')
            if any(flags.get(f, 0) != (1 if index >= phase else 0)
                   for f, phase in first_one.items()):
                raise ValueError('Moon flags do not match pre/post-lens-and-zodiac observations')
            if any(flags.get(f, 0) != 0 for f in negative):
                raise ValueError('unexpected column or armor progression flag')
        if selected[8][0][3] != -1:
            raise ValueError('Moon lens installation did not consume the held lens')
        if selected[14][0][3] != -1:
            raise ValueError('Moon key was not put away before return')
    for _, scope, flags in selected[-2:]:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required event')
        if any(flags.get(f, 0) != 1 for f in positive):
            raise ValueError('required prerequisite flag is not 1')
        if any(flags.get(f, 0) != 0 for f in negative):
            raise ValueError('unexpected route progression flag')
    # The existing harness prints Windows paths without JSON escaping. Inspect
    # only the stop field; do not treat that whole diagnostic line as valid JSON.
    results = [line[7:] for line in log.splitlines() if line.startswith('RESULT ')]
    if len(results) != 1 or not re.match(r'\{\s*"stopped"\s*:\s*"stop requested(?: |")', results[0]):
        raise ValueError('game did not reach a clean requested stop')
    if not re.search(r'FILE open .*\\' + re.escape(save.name) + r'\s+\[virtual \d+ ms\]', log):
        raise ValueError('this run did not open the requested checkpoint save')
    if not save.is_file() or save.stat().st_size != 170770:
        raise ValueError('checkpoint save is missing or has an unexpected length')
    return {'route': route, 'scene': expected[-1][0], 'view': expected[-1][1],
            'flags_one': sorted(positive), 'flags_zero': sorted(negative),
            'save': save.name, 'telescope_complete': route in ('telescope-use', 'seedlings', 'crank-repair', 'betty-key', 'venus-column', 'jupiter-column', 'moon-key', 'moon-column')}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('run_log', type=Path)
    parser.add_argument('save_file', type=Path)
    parser.add_argument('--route', choices=('telescope-prep', 'jane-jigsaw', 'telescope-use', 'seedlings', 'crank-repair', 'betty-key', 'venus-column', 'jupiter-column', 'moon-key', 'moon-column'),
                        default='telescope-prep')
    args = parser.parse_args()
    try:
        print(json.dumps(verify(args.run_log.read_text(), args.save_file,
                                args.route), sort_keys=True))
    except (ValueError, OSError) as error:
        raise SystemExit('route verification failed: ' + str(error))
