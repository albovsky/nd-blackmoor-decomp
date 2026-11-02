#!/usr/bin/env python3
"""Check an observed headless story leg, not merely its process exit.

python3 check_route.py RUN_LOG SAVE_FILE [--route telescope-prep|jane-jigsaw|telescope-use|seedlings|crank-repair|betty-key|venus-column|jupiter-column|moon-key|moon-column|nigel-computer|night-wait|goggles|ghost-hunt|afternoon-door|linda-passage|bul-key|slide-ball|saturn-column|dragon-passage|glyph-request|glyph-win|lit-word-clue|loulou-barber|loulou-morning|drake-magic|loulou-answer]
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


def flag_scope(text, include_clock=False):
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
    return flags if include_clock else flags - CLOCK_OVERLAP_DIAGNOSTICS


# Recorded authored capture order: closeup before/after, then its original flag.
GHOST_HUNT_STAGES = ((2354, 2351, 1174), (2325, 2325, 1173),
                     (2694, 2694, 1172), (2693, 2693, 1171),
                     (3432, 3432, 1163), (3433, 3433, 1164),
                     (3431, 3431, 1162), (2691, 2691, 1169),
                     (3434, 3434, 1165), (3435, 3435, 1166),
                     (3436, 3436, 1167), (3437, 3437, 1168), (2692, 2692, 1170))
GHOST_ROUTES = ('nigel-computer', 'night-wait', 'goggles', 'ghost-hunt')
NIGHT_ROUTES = ('night-wait', 'goggles', 'ghost-hunt')
COLUMN_PREREQUISITES = {1160, 1259, 1436, 1541, 1597, 1782, 1892, 1906, 1963, 1980,
                        1981, 1993, 1994, 1996, 2000, 2002, 2015, 2019, 2036, 2037, 2077, 2092}
NIGEL_FLAGS = {1573, 1677, 1682, 1692, 1701, 1823, 1985, 2069}
HUNT_FLAGS = set(range(1162, 1175))


def ghost_configuration(route):
    positive = COLUMN_PREREQUISITES | NIGEL_FLAGS
    negative = HUNT_FLAGS | {1192, 1788, 1893, 1947, 1958, 1961, 1999, 2039, 2040, 2063, 2070}
    if route == 'nigel-computer':
        expected = [(2626, 0), (2605, 15), (2605, 6), (4101, 0), (4112, 0),
                    (1300, 0), (1304, 0), (1305, 0), (1306, 0), (1319, 0),
                    (1307, 0), (1311, 0), (4112, 0), (4160, 0), (4165, 0),
                    (4160, 0), (4111, 0), (4111, 0)]
    elif route == 'night-wait':
        expected = [(4111, 0), (4111, 0)]
    elif route == 'goggles':
        expected = [(4111, 0), (4105, 10), (2605, 19), (3308, 0), (3471, 0),
                    (3473, 0), (3369, 0), (3368, 0), (3473, 0), (2605, 5),
                    (4111, 0), (4111, 0), (4111, 0), (4111, 0)]
        positive |= {1788, 1893}
        negative -= {1788, 1893}
    else:
        expected = [(4111, 0), (4165, 0), (4111, 0)]
        expected += [(scene, 0) for before, after, _ in GHOST_HUNT_STAGES
                     for scene in (before, after)]
        expected += [(4111, 0), (4178, 0), (4160, 0), (4111, 0), (4111, 0)]
        positive |= HUNT_FLAGS | {1788, 1893, 1947, 1958, 2063}
        negative = {1192, 1961, 1999, 2039, 2040, 2070}
    return expected, positive, negative


def verify_ghost_observations(route, observations, selected, clocks, positive, negative):
    first_one = {
        'nigel-computer': {1573: 6, 1701: 8, 1677: 9, 1682: 11,
                           1692: 13, 2069: 13, 1823: 14, 1985: 14},
        'night-wait': {}, 'goggles': {1893: 4, 1788: 6},
        'ghost-hunt': {2063: 2, 1958: 28, 1947: 30,
                       **{flag: 4 + 2 * i for i, (_, _, flag) in enumerate(GHOST_HUNT_STAGES)}},
    }[route]
    permanent_zero = negative - ({1192, 2039} if route == 'ghost-hunt' else set())
    retained = positive - first_one.keys()
    # A failure outside the selected snapshots must not be hidden.
    for _, scope, flags in observations:
        if not (permanent_zero | retained) <= scope:
            raise ValueError('RC_FLAGS did not observe every required event')
        if any(flags.get(f, 0) != 0 for f in permanent_zero):
            raise ValueError('unexpected hunt failure, timer or story progression flag')
        if any(flags.get(f, 0) != 1 for f in retained):
            raise ValueError('ghost-route retained prerequisite flag is not 1')
    for index, (state, scope, flags) in enumerate(selected):
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required event')
        if any(flags.get(f, 0) != (1 if index >= phase else 0)
               for f, phase in first_one.items()):
            raise ValueError('ghost-route flags do not match pre/post-original-progression observations')
        if route == 'ghost-hunt' and any(flags.get(f, 0) != (1 if 2 <= index < 30 else 0)
                                          for f in (1192, 2039)):
            raise ValueError('hunt timer did not follow original start/reward-clear observations')
        if state[3] != (21 if route == 'goggles' and index == 11 else -1):
            raise ValueError('ghost route has an unexpected held-item state')
    if route not in NIGHT_ROUTES:
        return None
    verify_clock_diagnostics(clocks)
    for _, clock in clocks:
        if route != 'night-wait' and not (clock['day'] == 2 and clock['hour'] < 4):
            raise ValueError('original night gate was not observed')
    if route == 'night-wait' and clocks[0][1]['day'] != 1:
        raise ValueError('night wait did not start before the observed day transition')
    if any(clock['day'] != 2 or clock['hour'] >= 4 for _, clock in clocks[-2:]):
        raise ValueError('final original night gate was not observed')
    return clocks[-1][1]


PASSAGE_ROUTES = ('afternoon-door', 'linda-passage', 'bul-key')
GHOST_REWARD_PREREQUISITES = COLUMN_PREREQUISITES | NIGEL_FLAGS | HUNT_FLAGS | {1788, 1893, 1947, 1958, 2063}
LINDA_CAPTION_SCENES = {1114, 1139, 1120, 1142, 1124, 1127}


def verify_clock_diagnostics(clocks):
    previous = -1
    for scope, clock in clocks:
        if scope != CLOCK_OVERLAP_DIAGNOSTICS:
            raise ValueError('clock diagnostics 338-341 were not fully observed')
        day, hour, minute = clock['day'], clock['hour'], clock['minute']
        if day < 1 or not 0 <= hour < 24 or not 0 <= minute < 60 or clock['total_minutes'] != hour * 60 + minute:
            raise ValueError('invalid recorded clock diagnostics')
        current = (day - 1) * 1440 + clock['total_minutes']
        if current < previous:
            raise ValueError('recorded original clock moved backwards')
        previous = current


def passage_configuration(route):
    positive = GHOST_REWARD_PREREQUISITES | {2058}
    negative = {1192, 1404, 1405, 1435, 1494, 1496, 1498, 1961, 1969, 1971,
                1999, 2039, 2040, 2070, 2156}
    if route == 'afternoon-door':
        expected = [(4111, 0), (2605, 19), (3329, 0), (3360, 0),
                    (3360, 0), (3360, 0), (3360, 0)]
    elif route == 'linda-passage':
        expected = [(3360, 0), (4408, 0), (1114, 0), (4408, 0),
                    (4410, 2), (4410, 10), (2605, 5), (4408, 0),
                    (1139, 0), (1120, 0), (1142, 0), (1124, 0),
                    (1127, 0), (4408, 0), (4408, 0)]
        positive |= {1494, 1496, 1498, 2156}
        negative -= {1494, 1496, 1498, 2156}
    elif route == 'bul-key':
        expected = [(4408, 0), (4410, 2), (4410, 10), (3510, 0),
                    (3510, 4), (1200, 0), (1252, 0), (1261, 0),
                    (1258, 0), (1259, 0), (1264, 0), (1218, 0),
                    (3510, 4), (3510, 4), (3510, 4), (3510, 4)]
        positive |= {1494, 1496, 1498, 2156, 1404, 1405, 1435}
        negative -= {1494, 1496, 1498, 2156, 1404, 1405, 1435}
    else:
        raise ValueError('unknown passage route')
    return expected, positive, negative


def verify_passage_observations(route, log, observations, selected, clocks, positive, negative):
    first_one = {'afternoon-door': {2058: 4},
                 'linda-passage': {1496: 2, 2156: 6, 1494: 8, 1498: 12},
                 'bul-key': {1404: 6, 1435: 7, 1405: 9}}[route]
    retained = positive - first_one.keys()
    permanent_zero = negative - ({1969} if route == 'bul-key' else set())
    for _, scope, flags in observations:
        if not (retained | permanent_zero) <= scope:
            raise ValueError('RC_FLAGS did not observe every required event')
        if any(flags.get(f, 0) != 1 for f in retained):
            raise ValueError('passage-route retained prerequisite flag is not 1')
        if any(flags.get(f, 0) != 0 for f in permanent_zero):
            raise ValueError('unexpected passage, key, failure or timer progression flag')
    for index, (state, scope, flags) in enumerate(selected):
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required event')
        art = 4408 if route == 'linda-passage' and state[0] in LINDA_CAPTION_SCENES else state[0]
        if state[1] != art:
            raise ValueError('passage route art scene does not match the observed frame')
        if any(flags.get(f, 0) != (1 if index >= phase else 0)
               for f, phase in first_one.items()):
            raise ValueError('passage-route flags do not match pre/post-original-progression observations')
        held = 7 if route == 'bul-key' and index == 13 else -1
        if state[3] != held:
            raise ValueError('passage route did not return to a safe state with the expected held item')
        if route == 'bul-key':
            # 1969 can already be cleared by 1258's secondary effects. The
            # authored scene chain and durable 1405 prove the win, not a
            # requirement to retain this transient flag after the reward.
            win = flags.get(1969, 0)
            if win not in (0, 1) or (index != 8 and win != 0):
                raise ValueError('transient Bul win flag was not clear before/after the win')
    verify_clock_diagnostics(clocks)
    if any(clock['day'] != 2 for _, clock in clocks):
        raise ValueError('original afternoon day was not observed')
    if route == 'afternoon-door':
        if clocks[0][1]['hour'] >= 4:
            raise ValueError('afternoon wait did not start in the observed night window')
    elif any(not 14 <= clock['hour'] <= 20 for _, clock in clocks):
        raise ValueError('original afternoon gate was not observed')
    if any(not 14 <= clock['hour'] <= 20 for _, clock in clocks[-2:]):
        raise ValueError('final original afternoon gate was not observed')
    if route == 'bul-key':
        opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
        cursor = 0
        for scene in (3610, 3635, 1258, 1259, 1264, 1218):
            while cursor < len(opened) and opened[cursor] != scene:
                cursor += 1
            if cursor == len(opened):
                raise ValueError('missing ordered authored Bul win/reward scene opens')
            cursor += 1
    return clocks[-1][1]


POST_KEY_ROUTES = ('slide-ball', 'saturn-column')
POST_KEY_SCENES = {
    'slide-ball': (1420, 1400, 1401, 3310, 3360, 3361, 3330, 3344, 3425, 3420, 2676, 3215),
    'saturn-column': (3420, 3421, 3426, 2677, 2620, 2685, 2620),
}


def post_key_configuration(route):
    _, retained, _ = passage_configuration('bul-key')
    zero = {1961, 1969, 1999, 2070, 1192, 2039, 2040}
    slide = {1562, 1971, 1575, 1844, 2050}
    if route == 'slide-ball':
        expected = [(3510, 4), (1400, 0), (1401, 0), (3310, 0),
                    (3360, 0), (3361, 0), (3330, 0), (3344, 0),
                    (3425, 0), (2676, 0), (3215, 0), (3215, 0),
                    (3215, 0), (3215, 0), (3215, 0)]
        return expected, retained | slide, zero | {1970, 1820, 2005}
    if route == 'saturn-column':
        expected = [(3215, 0), (3420, 0), (3421, 0), (2677, 0),
                    (2677, 0), (2620, 0), (2685, 0), (2620, 0), (2620, 0)]
        return expected, retained | slide | {1970, 1820, 2005}, zero
    raise ValueError('unknown post-key route')


def verify_post_key_observations(route, log, observations, selected, clocks, positive, negative):
    first_one = {'slide-ball': {1562: 1, 1971: 5, 1575: 9, 1844: 9, 2050: 11},
                 'saturn-column': {1970: 3, 1820: 6, 2005: 6}}[route]
    retained = positive - first_one.keys()
    previous = {f: 0 for f in first_one}
    # Check every recorded observation, including extra nonselected frames.
    for _, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required post-key event')
        if any(flags.get(f, 0) != 1 for f in retained):
            raise ValueError('post-key retained prerequisite flag is not 1')
        if any(flags.get(f, 0) != 0 for f in negative):
            raise ValueError('unexpected post-key unmet, failure or timer flag')
        for f in first_one:
            value = flags.get(f, 0)
            if value not in (0, 1) or value < previous[f]:
                raise ValueError('post-key phase flag is not binary/monotone')
            previous[f] = value
    held_steps = {'slide-ball': {4: 7, 12: 3}, 'saturn-column': {4: 16, 5: 16}}[route]
    for index, (state, _, flags) in enumerate(selected):
        if state[1] != state[0]:
            raise ValueError('post-key art scene differs from requested frame')
        if state[3] != held_steps.get(index, -1):
            raise ValueError('post-key expected held item or final safe state differs')
        if any(flags.get(f, 0) != (1 if index >= phase else 0)
               for f, phase in first_one.items()):
            raise ValueError('post-key flags do not match pre/post-original-progression observations')
    verify_clock_diagnostics(clocks)
    if any(clock['day'] != 2 or not 14 <= clock['hour'] <= 20 for _, clock in clocks):
        raise ValueError('post-key original afternoon gate was not observed')
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    cursor = 0
    for scene in POST_KEY_SCENES[route]:
        while cursor < len(opened) and opened[cursor] != scene:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered post-key authored scene opens')
        cursor += 1
    # 1005 was zero in the observed hit. It is not a positive prerequisite;
    # 2050 remains pickup history after the original ball-consumption path.
    return clocks[-1][1]


DRAGON_LIGHT_ROUTES = ('dragon-passage', 'glyph-request')
DRAGON_LIGHT_SCENES = {
    'dragon-passage': (3332, 3338, 3339, 3342, 3343, 3417, 3418, 2903, 3326),
    'glyph-request': (1216, 1217, 1280, 1281, 3585, 3513, 3562, 3513, 3522, 3510),
}


def dragon_light_configuration(route):
    _, retained, zero = post_key_configuration('saturn-column')
    zero = zero | {2001, 1357, 1804}
    passage = {1997, 2078, 1925, 1865}
    request = {1349, 1418, 1791, 1408, 1361, 1388}
    if route == 'dragon-passage':
        expected = [(2620, 0), (3332, 0), (3332, 0), (3342, 0),
                    (3343, 0), (3417, 0), (3418, 0), (3326, 0), (3326, 0)]
        return expected, retained | passage, zero | request
    if route == 'glyph-request':
        expected = [(3326, 0), (3510, 0), (3510, 4), (1217, 0),
                    (3585, 0), (3562, 0), (3513, 0), (3510, 4), (3510, 4)]
        return expected, retained | passage | request, zero
    raise ValueError('unknown dragon/light route')


def verify_dragon_light_observations(route, log, observations, selected, clocks, positive, negative):
    first_one = {'dragon-passage': {2078: 2, 1997: 3, 1925: 4, 1865: 4},
                 'glyph-request': {1791: 3, 1349: 4, 1418: 4, 1408: 4, 1361: 5, 1388: 5}}[route]
    retained = positive - first_one.keys()
    previous = {f: 0 for f in first_one}
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required dragon/light event')
        if any(flags.get(f, 0) != 1 for f in retained):
            raise ValueError('dragon/light retained prerequisite flag is not 1')
        if any(flags.get(f, 0) != 0 for f in negative):
            raise ValueError('unexpected dragon/light unmet, win, reward, failure or timer flag')
        if state[3] != -1:
            raise ValueError('dragon/light route unexpectedly holds an item')
        for f in first_one:
            value = flags.get(f, 0)
            if value not in (0, 1) or value < previous[f]:
                raise ValueError('dragon/light phase flag is not binary/monotone')
            previous[f] = value
    for index, (state, _, flags) in enumerate(selected):
        if state[1] != state[0]:
            raise ValueError('dragon/light art scene differs from requested frame')
        if any(flags.get(f, 0) != (1 if index >= phase else 0)
               for f, phase in first_one.items()):
            raise ValueError('dragon/light flags do not match pre/post-original-progression observations')
    verify_clock_diagnostics(clocks)
    low, high = (14, 20) if route == 'dragon-passage' else (16, 19)
    if any(clock['day'] != 2 or not low <= clock['hour'] <= high for _, clock in clocks):
        raise ValueError('dragon/light observed clock gate was not retained')
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    cursor = 0
    for scene in DRAGON_LIGHT_SCENES[route]:
        while cursor < len(opened) and opened[cursor] != scene:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered dragon/light authored scene opens')
        cursor += 1
    return clocks[-1][1]


GLYPH_WIN_ROUTES = ('glyph-win',)


def glyph_win_configuration():
    _, pending, unmet = dragon_light_configuration('glyph-request')
    expected = [(3510, 4), (3588, 0), (1294, 0), (1945, 0),
                (3510, 4), (3510, 4), (3510, 4)]
    return expected, (pending - {1418}) | {2001, 1357}, (unmet - {2001, 1357}) | {1418}


def verify_glyph_win_observations(log, observations, selected, clocks, positive, negative):
    retained, unmet = positive - {2001, 1357}, negative - {1418}
    previous = {1418: 1, 2001: 0, 1357: 0}
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required glyph-win event')
        if any(flags.get(f, 0) != 1 for f in retained):
            raise ValueError('glyph-win retained prerequisite flag is not 1')
        if any(flags.get(f, 0) != 0 for f in unmet):
            raise ValueError('unexpected glyph-win later, failure or timer flag')
        for f in previous:
            value = flags.get(f, 0)
            backwards = value > previous[f] if f == 1418 else value < previous[f]
            if value not in (0, 1) or backwards:
                raise ValueError('glyph-win phase flag is not binary/monotone')
            previous[f] = value
        if flags.get(1357, 0) > flags.get(2001, 0):
            raise ValueError('glyph reward preceded the actual win')
        if state[3] not in (-1, 4) or (state[3] == 4 and
                (state[:3] != (3510, 3510, 4) or flags.get(1357, 0) != 1 or flags.get(1418, 0) != 0)):
            raise ValueError('glyph-win unexpectedly holds an item')
    for index, (state, _, flags) in enumerate(selected):
        if state[1] != state[0]:
            raise ValueError('glyph-win art scene differs from requested frame')
        if state[3] != (4 if index == 4 else -1):
            raise ValueError('glyph-win real4 or final safe state differs')
        phase = (1 if index < 3 else 0, 1 if index >= 2 else 0, 1 if index >= 3 else 0)
        if tuple(flags.get(f, 0) for f in (1418, 2001, 1357)) != phase:
            raise ValueError('glyph-win flags do not match source/win/pickup phases')
    verify_clock_diagnostics(clocks)
    source_clock = clocks[0][1]
    if source_clock['day'] != 2 or not 16 <= source_clock['hour'] <= 19:
        raise ValueError('glyph-win observed source clock gate differs')
    # Live solving can legitimately advance past the static request's gate.
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    cursor = 0
    for alternatives in ((3588,), (1299,), (1294, 1295), (1945,), (3510,)):
        while cursor < len(opened) and opened[cursor] not in alternatives:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered glyph-win authored scene opens')
        cursor += 1
    return clocks[-1][1]


WORD_PREREQUISITE_ROUTES = ('lit-word-clue', 'loulou-barber', 'loulou-morning',
                            'drake-magic', 'loulou-answer')
WORD_PREREQUISITE_SCENES = {
    'lit-word-clue': (3332, 3338, 3339, 3342, 3343, 3498, 2902, 2910, 2942, 2964, 4375, 4389),
    'loulou-barber': (3058, 2903, 3326, 3334, 3335, 3440, 1502, 1503, 1506, 1552, 3335),
    'loulou-morning': (3335,),
    'drake-magic': (2332, 1000, 1067, 1068, 1071, 1092, 2332),
    'loulou-answer': (3334, 3335, 3336, 1500, 1556, 1557, 1558, 3335),
}
WORD_PREREQUISITE_PHASES = {
    'lit-word-clue': {2041: 4, 2232: 6, 1818: 7, 1836: 7},
    'loulou-barber': {1569: 4, 1467: 7},
    'loulou-morning': {},
    'drake-magic': {1525: 5, 1526: 6},
    'loulou-answer': {1465: 4, 1476: 4, 1774: 4},
}


def word_prerequisite_configuration(route):
    _, retained, zero = glyph_win_configuration()
    if route in ('drake-magic', 'loulou-answer'):
        retained = retained | {1514}
    zero = zero | {1465, 1467, 1476, 1525, 1526, 1569, 1774, 1818, 1836,
                   1922, 1960, 1966, 1967, 1977, 1979, 1984, 2018, 2041, 2042, 2154, 2232}
    states = {
        'lit-word-clue': [(3510, 4), (3332, 0), (3342, 0), (3343, 0), (2910, 0),
                          (2942, 0), (2942, 0), (4389, 0), (4389, 0)],
        'loulou-barber': [(4389, 0), (3058, 0), (3326, 0), (3334, 0), (1502, 0),
                         (1503, 0), (1506, 0), (1552, 0), (3335, 0), (3335, 0)],
        'loulou-morning': [(3335, 0), (3335, 0), (3335, 0)],
        'drake-magic': [(3335, 0), (2300, 3), (2300, 19), (2332, 0), (1000, 0),
                        (1067, 0), (1071, 0), (2332, 0), (2332, 0)],
        'loulou-answer': [(2332, 0), (3334, 0), (3336, 0), (1500, 0), (1558, 0),
                          (3335, 0), (3335, 0)],
    }
    for leg in WORD_PREREQUISITE_ROUTES:
        earned = set(WORD_PREREQUISITE_PHASES[leg])
        retained |= earned
        zero -= earned
        if leg == route:
            return states[route], retained, zero
    raise ValueError('unknown word-prerequisite route')


def verify_word_prerequisite_observations(route, log, observations, selected, clocks, positive, negative):
    first_one = WORD_PREREQUISITE_PHASES[route]
    retained = positive - first_one.keys()
    previous = {f: 0 for f in first_one}
    # Reject a bad extra snapshot too; selected phases cannot hide it.
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required word-prerequisite event')
        if any(flags.get(f, 0) != 1 for f in retained):
            raise ValueError('word-prerequisite retained event is not 1')
        if any(flags.get(f, 0) != 0 for f in negative):
            raise ValueError('unexpected word-lock, dialogue, failure or timer progression')
        for f in first_one:
            value = flags.get(f, 0)
            if value not in (0, 1) or value < previous[f]:
                raise ValueError('word-prerequisite phase event is not binary/monotone')
            previous[f] = value
        held = 4 if ((route == 'lit-word-clue' and flags.get(2041, 0)) or
                     (route == 'loulou-barber' and not flags.get(1569, 0))) else -1
        if state[3] != held:
            raise ValueError('word-prerequisite authored light or safe held-item state differs')
    for index, (state, _, flags) in enumerate(selected):
        art = 3440 if route == 'loulou-barber' and state[0] in (1502, 1503, 1506, 1552) else state[0]
        if route == 'loulou-answer' and state[0] in (1500, 1558):
            art = 3336
        if state[1] != art:
            raise ValueError('word-prerequisite art differs from the observed dialogue frame')
        if any(flags.get(f, 0) != (1 if index >= phase else 0)
               for f, phase in first_one.items()):
            raise ValueError('word-prerequisite events differ from original pre/post phases')
    verify_clock_diagnostics(clocks)
    # These are source gates for the final public chain, not universal NPC
    # schedules or a whole-leg time window. Long waits may cross midnight.
    source = clocks[0][1]
    source_day, source_hour = {'lit-word-clue': (2, 16), 'loulou-barber': (2, 17),
                               'loulou-morning': (2, 17), 'drake-magic': (3, 8),
                               'loulou-answer': (3, 8)}[route]
    if (source['day'], source['hour']) != (source_day, source_hour):
        raise ValueError('word-prerequisite observed source clock gate differs')
    if route == 'loulou-morning' and any(clock['day'] != 3 or clock['hour'] != 8
                                        for _, clock in clocks[-2:]):
        raise ValueError('original morning arrival was not observed')
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    cursor = 0
    for scene in WORD_PREREQUISITE_SCENES[route]:
        while cursor < len(opened) and opened[cursor] != scene:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered word-prerequisite authored scene opens')
        cursor += 1
    return clocks[-1][1]


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
    elif route in GHOST_ROUTES:
        expected, positive, negative = ghost_configuration(route)
    elif route in PASSAGE_ROUTES:
        expected, positive, negative = passage_configuration(route)
    elif route in POST_KEY_ROUTES:
        expected, positive, negative = post_key_configuration(route)
    elif route in DRAGON_LIGHT_ROUTES:
        expected, positive, negative = dragon_light_configuration(route)
    elif route == 'glyph-win':
        expected, positive, negative = glyph_win_configuration()
    elif route in WORD_PREREQUISITE_ROUTES:
        expected, positive, negative = word_prerequisite_configuration(route)
    else:
        raise ValueError('unknown story route')
    observations = []
    clocks = []
    state = None
    scope = set()
    raw_scope = set()
    for line in log.splitlines():
        match = re.fullmatch(r'\s*STATE requested_scene=(\d+) art_scene=(\d+) view=(-?\d+) held_item=(-?\d+)', line)
        if match:
            state = tuple(map(int, match.groups()))
            scope = set()
            raw_scope = set()
        elif line.startswith('  RC_FLAGS '):
            raw_scope = flag_scope(line.removeprefix('  RC_FLAGS '), include_clock=True)
            scope = raw_scope - CLOCK_OVERLAP_DIAGNOSTICS
        elif line.startswith('  FLAGS') and state is not None:
            raw = {int(k): int(v) for k, v in re.findall(r'(\d+)=(\d+)', line)}
            values = {k: v for k, v in raw.items() if k not in CLOCK_OVERLAP_DIAGNOSTICS}
            observations.append((state, scope.copy(), values))
            clock = {'total_minutes': (raw.get(338, 0) >> 16) | ((raw.get(339, 0) & 65535) << 16),
                     'hour': raw.get(340, 0) & 65535, 'minute': raw.get(339, 0) >> 16,
                     'day': raw.get(340, 0) >> 16}
            clocks.append((raw_scope & CLOCK_OVERLAP_DIAGNOSTICS, clock))
    # Include the pre-click frame for the tripod, or the actual puzzle, win
    # conversation and normal room return for Jane's loan.
    held_steps = {'jupiter-column': {4: 6}, 'moon-key': {7: 12, 13: 11},
                  'moon-column': {4: 11}, 'goggles': {11: 21}, 'bul-key': {13: 7},
                  'slide-ball': {4: 7, 12: 3}, 'saturn-column': {4: 16, 5: 16}, 'glyph-win': {4: 4}}.get(route, {})
    selected = []
    for observation in observations:
        state, scope, flags = observation
        pair = (state[0], state[2])
        if route == 'glyph-win' and len(selected) == 2 and pair == (1295, 0):
            pair = (1294, 0)
        if len(selected) < len(expected) and pair == expected[len(selected)]:
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
            if route == 'dragon-passage' and len(selected) == 2 and flags.get(2078, 0) != 1:
                # The first lever observation can repeat3332 before2078 rises.
                continue
            if route == 'lit-word-clue' and len(selected) == 6 and flags.get(2232, 0) != 1:
                # The clue is inspected once before the lit reinspection.
                continue
            selected.append(observation)
    if len(selected) != len(expected):
        raise ValueError('missing ordered route observations')
    if route in ('jupiter-column', 'moon-key', 'moon-column') + GHOST_ROUTES + PASSAGE_ROUTES + POST_KEY_ROUTES + DRAGON_LIGHT_ROUTES + GLYPH_WIN_ROUTES + WORD_PREREQUISITE_ROUTES:
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
    if route in ('betty-key', 'venus-column', 'jupiter-column', 'moon-key', 'moon-column') + GHOST_ROUTES:
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
    clock_diagnostics = None
    if route in GHOST_ROUTES:
        clock_diagnostics = verify_ghost_observations(route, observations, selected, clocks, positive, negative)
    if route in PASSAGE_ROUTES:
        clock_diagnostics = verify_passage_observations(route, log, observations, selected, clocks, positive, negative)
    if route in POST_KEY_ROUTES:
        clock_diagnostics = verify_post_key_observations(route, log, observations, selected, clocks, positive, negative)
    if route in DRAGON_LIGHT_ROUTES:
        clock_diagnostics = verify_dragon_light_observations(route, log, observations, selected, clocks, positive, negative)
    if route == 'glyph-win':
        clock_diagnostics = verify_glyph_win_observations(log, observations, selected, clocks, positive, negative)
    if route in WORD_PREREQUISITE_ROUTES:
        clock_diagnostics = verify_word_prerequisite_observations(route, log, observations, selected, clocks, positive, negative)
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
    result = {'route': route, 'scene': expected[-1][0], 'view': expected[-1][1],
            'flags_one': sorted(positive), 'flags_zero': sorted(negative),
            'save': save.name, 'telescope_complete': route in ('telescope-use', 'seedlings', 'crank-repair', 'betty-key', 'venus-column', 'jupiter-column', 'moon-key', 'moon-column') + GHOST_ROUTES + PASSAGE_ROUTES + POST_KEY_ROUTES + DRAGON_LIGHT_ROUTES + GLYPH_WIN_ROUTES + WORD_PREREQUISITE_ROUTES}
    if route in WORD_PREREQUISITE_ROUTES:
        result['word_lock_won'] = False
    if route == 'glyph-request':
        result['glyph_pending'] = True
    if route == 'glyph-win':
        result['glyph_win'] = True
        result['light_reward_earned'] = True
    if clock_diagnostics is not None:
        result['clock_diagnostics'] = clock_diagnostics
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('run_log', type=Path)
    parser.add_argument('save_file', type=Path)
    parser.add_argument('--route', choices=('telescope-prep', 'jane-jigsaw', 'telescope-use', 'seedlings', 'crank-repair', 'betty-key', 'venus-column', 'jupiter-column', 'moon-key', 'moon-column') + GHOST_ROUTES + PASSAGE_ROUTES + POST_KEY_ROUTES + DRAGON_LIGHT_ROUTES + GLYPH_WIN_ROUTES + WORD_PREREQUISITE_ROUTES,
                        default='telescope-prep')
    args = parser.parse_args()
    try:
        print(json.dumps(verify(args.run_log.read_text(), args.save_file,
                                args.route), sort_keys=True))
    except (ValueError, OSError) as error:
        raise SystemExit('route verification failed: ' + str(error))
