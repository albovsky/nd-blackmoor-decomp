#!/usr/bin/env python3
"""Check an observed headless story leg, not merely its process exit.

python3 check_route.py RUN_LOG SAVE_FILE [--route telescope-prep|jane-jigsaw|telescope-use|seedlings|crank-repair|betty-key|venus-column|jupiter-column|moon-key|moon-column|nigel-computer|night-wait|goggles|ghost-hunt|afternoon-door|linda-passage|bul-key|slide-ball|saturn-column|dragon-passage|glyph-request|glyph-win|lit-word-clue|loulou-barber|loulou-morning|drake-magic|loulou-answer|light-depletion|paid-light-request|repeat-glyph-win|word-lock|right-fire-panel|ethel-interrogation|linda-curse|gargoyle-inspect|corbin-portrait|typing-crest]
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


def glyph_win_configuration(glyph_scene=3588):
    if glyph_scene not in (3588, 3589):
        raise ValueError('unsupported original glyph scene')
    _, pending, unmet = dragon_light_configuration('glyph-request')
    expected = [(3510, 4), (glyph_scene, 0), (1294, 0), (1945, 0),
                (3510, 4), (3510, 4), (3510, 4)]
    return expected, (pending - {1418}) | {2001, 1357}, (unmet - {2001, 1357}) | {1418}


def verify_glyph_win_observations(log, observations, selected, clocks, positive, negative, glyph_scene=3588):
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
    for alternatives in ((glyph_scene,), (1299,), (1294, 1295), (1945,), (3510,)):
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


WORD_LOCK_ROUTES = ('light-depletion', 'paid-light-request', 'repeat-glyph-win', 'word-lock')
WORD_LOCK_STAGES = {1984: 7, 1967: 8, 1966: 9, 1977: 10, 2018: 11, 1979: 11}
WORD_LOCK_SCENES = {
    'light-depletion': (2910, 3175, 3180, 3181, 2942, 3058, 2903, 3326, 3334, 3335),
    'paid-light-request': (3345, 3346, 3500, 3505, 3510, 1200, 1282, 1281, 3585, 3513, 3522, 3510),
    'repeat-glyph-win': (3588, 1299, 1295, 1949, 3510),
    'word-lock': (2910, 2942, 4375, 4389, 4376, 4377, 4378, 4379, 4380, 4387),
}


def word_lock_configuration(route):
    _, earned, zero = word_prerequisite_configuration('loulou-answer')
    retained, zero = earned - {2041}, zero - {1418, 2042}
    if route == 'light-depletion':
        states = [(3335, 0), (3332, 0), (3342, 0), (3343, 0), (2910, 0), (3175, 0),
                  (2912, 0), (2933, 0), (2933, 0), (2942, 0), (3058, 0), (3326, 0),
                  (3335, 0), (3335, 0)]
        return states, retained | {1809}, zero | {1418, 2041, 2042}
    if route == 'paid-light-request':
        states = [(3335, 0), (3335, 0), (3335, 0), (3345, 0), (3346, 0), (3505, 0),
                  (3510, 4), (1200, 0), (3585, 0), (3513, 0), (3510, 4), (3510, 4)]
        return states, retained | {1809, 1418}, zero | {2041, 2042}
    if route == 'repeat-glyph-win':
        states = [(3510, 4), (3588, 0), (1295, 0), (1949, 0), (3510, 4), (3510, 4), (3510, 4)]
        return states, retained, zero | {1809, 1418, 2041, 2042}
    if route == 'word-lock':
        states = [(3510, 4), (3332, 0), (3342, 0), (3343, 0), (2910, 0), (2942, 0),
                  (4376, 0), (4377, 0), (4378, 0), (4379, 0), (4380, 0), (4387, 0), (4387, 0)]
        return states, retained | {2041} | WORD_LOCK_STAGES.keys(), (zero - WORD_LOCK_STAGES.keys()) | {1809, 1418, 2042, 1972}
    raise ValueError('unknown replacement-light/word-lock route')


def verify_word_lock_observations(route, log, observations, selected, clocks, positive, negative):
    up = {'light-depletion': {1809: 5}, 'paid-light-request': {1418: 8},
          'repeat-glyph-win': {}, 'word-lock': {2041: 4, **WORD_LOCK_STAGES}}[route]
    down = {'light-depletion': {2041: 6}, 'paid-light-request': {},
            'repeat-glyph-win': {1418: 3, 1809: 3}, 'word-lock': {}}[route]
    changing = up.keys() | down.keys() | ({2042} if route == 'light-depletion' else set())
    previous = {**{f: 0 for f in up}, **{f: 1 for f in down}}
    expired = False
    transient_previous = 0
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required replacement-light/word-lock event')
        if any(flags.get(f, 0) != 1 for f in positive - changing):
            raise ValueError('replacement-light/word-lock retained prerequisite differs')
        if any(flags.get(f, 0) != 0 for f in negative - changing):
            raise ValueError('unexpected replacement-light/word-lock later, failure or timer event')
        for f in previous:
            value = flags.get(f, 0)
            backwards = value < previous[f] if f in up else value > previous[f]
            if value not in (0, 1) or backwards:
                raise ValueError('replacement-light/word-lock phase is not binary/monotone')
            previous[f] = value
        if route == 'light-depletion':
            value = flags.get(2042, 0)
            if transient_previous == 1 and value == 0:
                expired = True
            if value not in (0, 1) or (expired and value) or (value and (flags.get(2041, 0) or not flags.get(1809, 0))):
                raise ValueError('original light timer did not follow its authored depletion phases')
            transient_previous = value
        if route == 'word-lock':
            stages = [flags.get(f, 0) for f in (1984, 1967, 1966, 1977, 2018, 1979)]
            if any(a < b for a, b in zip(stages, stages[1:])):
                raise ValueError('later word-lock stage preceded an earlier original win')
        allowed = (-1, 5) if route == 'paid-light-request' else (-1, 4)
        if state[3] not in allowed:
            raise ValueError('replacement-light/word-lock unexpected held item')
        if state[3] == 5 and (state[:3] != (3335, 3335, 0) or flags.get(1418, 0)):
            raise ValueError('used5 was not observed before the paid request')
        if state[3] == 4:
            valid = ((flags.get(2041, 0) or flags.get(2042, 0)) if route == 'light-depletion' else
                     (state[:3] == (3510, 3510, 4) and not flags.get(1418, 0) and not flags.get(1809, 0)) if route == 'repeat-glyph-win' else
                     (flags.get(2041, 0) and not 4376 <= state[0] <= 4389))
            if not valid:
                raise ValueError('real light4 does not match the original route phase')
    held = {'light-depletion': {4: 4, 5: 4, 6: 4, 7: 4}, 'paid-light-request': {1: 5},
            'repeat-glyph-win': {4: 4}, 'word-lock': {4: 4, 5: 4}}[route]
    for i, (state, _, flags) in enumerate(selected):
        if state[1] != state[0] or state[3] != held.get(i, -1):
            raise ValueError('replacement-light/word-lock art, actual item or final safe frame differs')
        if any(flags.get(f, 0) != int(i >= phase) for f, phase in up.items()) or any(
                flags.get(f, 0) != int(i < phase) for f, phase in down.items()):
            raise ValueError('replacement-light/word-lock source and original progression phases differ')
        if route == 'light-depletion' and flags.get(2042, 0) != int(6 <= i < 8):
            raise ValueError('original light timer start/expiry was not observed')
    verify_clock_diagnostics(clocks)
    source = clocks[0][1]
    source_hour = {'light-depletion': 8, 'paid-light-request': 9, 'repeat-glyph-win': 14, 'word-lock': 14}[route]
    if source['day'] != 3 or source['hour'] != source_hour:
        raise ValueError('replacement-light/word-lock observed source clock gate differs')
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    cursor = 0
    for scene in WORD_LOCK_SCENES[route]:
        while cursor < len(opened) and opened[cursor] != scene:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered replacement-light/word-lock authored scene opens')
        cursor += 1
    return clocks[-1][1]


CREST_PREREQUISITE_ROUTES = ('right-fire-panel', 'ethel-interrogation', 'linda-curse', 'gargoyle-inspect')
RIGHT_FIRE_BITS = {1150, 1154, 1156, 1157, 1158}
# Original builder0x4455b8 chooses rand()%3; all three resources return4408.
LINDA_CURSE_BYE_SCENES = (1190, 1191, 1192)
CREST_SCENES = {
    'right-fire-panel': (4366, 2942, 3053, 2943, 2944, 2945, 3060, 3199, 3140, 3141, 3143, 3155, 3126, 3158),
    'ethel-interrogation': (3199, 3060, 2903, 3326, 3364, 1404, 1425, 1405, 1426, 1406, 1427, 1407, 1490, 1491, 3428),
    'linda-curse': (3350, 3351, 4400, 4405, 4410, 1100, 1128, 1129, 1130, 1131, 1132, 1146, 1133,
                    LINDA_CURSE_BYE_SCENES, 4408),
    'gargoyle-inspect': (4412, 4410, 4406, 4407, 3312, 3323, 3324, 3366, 3410),
}


def crest_prerequisite_configuration(route):
    _, retained, zero = word_lock_configuration('word-lock')
    retained, zero = retained - {2154}, zero - {2154}
    partial = RIGHT_FIRE_BITS | {1808, 2060}
    remaining = set(range(1148, 1160)) - RIGHT_FIRE_BITS
    unmet = {1492, 1783, 1786, 1974, 2059}
    if route == 'right-fire-panel':
        states = [(4387, 0), (2942, 0), (2943, 0), (2944, 0), (2945, 0),
                  (3060, 0), (3199, 0)] + [(3141, 0)] * 5
        return states, retained | partial, zero | remaining | unmet | {2154}
    retained |= partial
    zero |= remaining
    if route == 'ethel-interrogation':
        states = [(3141, 0), (3060, 0), (3326, 0), (1405, 0), (1406, 0), (1407, 0), (3428, 0), (3428, 0)]
        return states, retained | {2154}, zero | unmet
    if route == 'linda-curse':
        states = [(3428, 0), (3318, 0), (3350, 0), (3351, 0), (4410, 3), (4412, 0),
                  (4408, 0), (1146, 0), (1133, 0), (4408, 0), (4408, 0)]
        return states, retained | {1492}, zero | (unmet - {1492}) | {2154}
    if route == 'gargoyle-inspect':
        states = [(4408, 0), (4412, 0), (4410, 2), (4406, 0), (4407, 0), (3312, 0), (3323, 0),
                  (3324, 0), (3366, 0), (3366, 0), (3410, 0), (3410, 0), (3410, 0)]
        return states, retained | {1492, 1786, 1783}, zero | {1974, 2059, 2014, 2154}
    raise ValueError('unknown crest-prerequisite route')


def verify_crest_prerequisite_observations(route, log, observations, selected, clocks, positive, negative):
    up = {'right-fire-panel': {1808: 7, 2060: 8, 1154: 8, 1150: 9, 1157: 9, 1156: 10, 1158: 10},
          'ethel-interrogation': {2154: 4}, 'linda-curse': {1492: 7},
          'gargoyle-inspect': {1786: 8, 1783: 10}}[route]
    down = {2154: 1} if route == 'linda-curse' else {}
    transient = {1155, 1159} if route == 'right-fire-panel' else set()
    changing = up.keys() | down.keys() | transient
    previous = {**{f: 0 for f in up}, **{f: 1 for f in down}}
    transient_previous = {f: 0 for f in transient}
    cleared = set()
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required crest-prerequisite event')
        if any(flags.get(f, 0) != 1 for f in positive - changing):
            raise ValueError('crest-prerequisite retained event differs')
        if any(flags.get(f, 0) != 0 for f in negative - changing):
            raise ValueError('unexpected crest-prerequisite next gate, failure or timer event')
        for f in previous:
            value = flags.get(f, 0)
            backwards = value < previous[f] if f in up else value > previous[f]
            if value not in (0, 1) or backwards:
                raise ValueError('crest-prerequisite phase is not binary/monotone')
            previous[f] = value
        for f in transient:
            value = flags.get(f, 0)
            if transient_previous[f] == 1 and value == 0:
                cleared.add(f)
            if value not in (0, 1) or (f in cleared and value):
                raise ValueError('right-fire initialized bits did not follow the original partial changes')
            transient_previous[f] = value
        if state[3] not in (-1, 4) or (route in ('linda-curse', 'gargoyle-inspect') and state[3] != -1):
            raise ValueError('crest-prerequisite unexpected held item')
        if route == 'ethel-interrogation' and flags.get(2154, 0) == 1 and state[3] != -1:
            raise ValueError('Ethel conversation did not put the original held light away')
    for i, (state, _, flags) in enumerate(selected):
        art = 4408 if route == 'linda-curse' and state[0] in (1128, 1129, 1130, 1131, 1132, 1146, 1133) else state[0]
        held = 4 if ((route == 'right-fire-panel' and i > 0) or
                     (route == 'ethel-interrogation' and i < 3)) else -1
        if state[1] != art or state[3] != held:
            raise ValueError('crest-prerequisite art, actual item or final safe frame differs')
        if any(flags.get(f, 0) != int(i >= phase) for f, phase in up.items()) or any(
                flags.get(f, 0) != int(i < phase) for f, phase in down.items()):
            raise ValueError('crest-prerequisite source and authored progression phases differ')
        if route == 'right-fire-panel' and (flags.get(1155, 0), flags.get(1159, 0)) != (int(i == 7), int(7 <= i < 9)):
            raise ValueError('right-fire initializer/partial panel bit observations differ')
    verify_clock_diagnostics(clocks)
    source = clocks[0][1]
    # Source-only pins for this current chain; no whole-dialogue/day window.
    hour = {'right-fire-panel': 15, 'ethel-interrogation': 15, 'linda-curse': 15, 'gargoyle-inspect': 15}[route]
    if source['day'] != 3 or source['hour'] != hour:
        raise ValueError('crest-prerequisite observed source clock gate differs')
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    cursor = 0
    for stage in CREST_SCENES[route]:
        alternatives = stage if isinstance(stage, tuple) else (stage,)
        while cursor < len(opened) and opened[cursor] not in alternatives:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered crest-prerequisite authored scene opens')
        cursor += 1
    return clocks[-1][1]


TYPING_CREST_ROUTES = ('corbin-portrait', 'typing-crest')


def typing_crest_configuration(route):
    _, prior, zero = crest_prerequisite_configuration('gargoyle-inspect')
    zero = zero | {1687, 2088}
    if route == 'corbin-portrait':
        states = [(3410, 0), (3311, 0), (3312, 0), (3313, 0), (2610, 0), (2611, 0), (2612, 0),
                  (2605, 5), (2615, 0), (2617, 0), (2618, 0), (4101, 0), (4112, 0),
                  (4108, 0), (4109, 0), (4110, 0), (2619, 0), (2616, 0), (2605, 12),
                  (2627, 0), (2629, 0), (2741, 0), (2741, 0)]
        return states, prior | {1863}, zero
    if route == 'typing-crest':
        states = [(2741, 0), (2629, 0), (2605, 4), (4112, 0), (1300, 0), (1340, 0),
                  (1343, 0), (4138, 0), (4120, 0), (4114, 0), (4115, 0), (4116, 0),
                  (4114, 0), (6200, 0), (4114, 0), (4114, 0)]
        return states, prior | {1863, 2088, 2014}, (zero - {2088, 2014}) | {1672}
    raise ValueError('unknown portrait/typing-crest route')


def verify_typing_crest_observations(route, log, observations, selected, clocks, positive, negative):
    up = {1863: 20} if route == 'corbin-portrait' else {2088: 5, 2014: 6}
    down = {1672: 7} if route == 'typing-crest' else {}
    changing = up.keys() | down.keys()
    previous = {**{f: 0 for f in up}, **{f: 1 for f in down}}
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required portrait/typing event')
        if any(flags.get(f, 0) != 1 for f in positive - changing):
            raise ValueError('portrait/typing retained prerequisite differs')
        if any(flags.get(f, 0) != 0 for f in negative - changing):
            raise ValueError('unexpected portrait/typing failure, repeat or next gate event')
        if state[1] != state[0] or state[3] != -1:
            raise ValueError('portrait/typing art or held item differs; crest2 is examined, not held')
        for f in previous:
            value = flags.get(f, 0)
            backwards = value < previous[f] if f in up else value > previous[f]
            if value not in (0, 1) or backwards:
                raise ValueError('portrait/typing phase is not binary/monotone')
            previous[f] = value
    for i, (_, _, flags) in enumerate(selected):
        if any(flags.get(f, 0) != int(i >= phase) for f, phase in up.items()) or any(
                flags.get(f, 0) != int(i < phase) for f, phase in down.items()):
            raise ValueError('portrait/typing source and original progression phases differ')
    source = clocks[0][1]
    if source['day'] != 3 or source['hour'] != 16:
        raise ValueError('portrait/typing observed source clock gate differs')
    if route == 'corbin-portrait':
        verify_clock_diagnostics(clocks)
    else:
        # S4138 raw64 mode1 is an original same-day03:15 clock assignment.
        # Permit exactly that observed post-win boundary; all other segments
        # retain normal complete/valid/monotone diagnostics.
        previous_clock = None
        reset_seen = False
        win_seen = False
        for (state, _, flags), item in zip(observations, clocks):
            verify_clock_diagnostics([item])
            clock = item[1]
            current = (clock['day']-1)*1440 + clock['total_minutes']
            if previous_clock is not None and current < previous_clock[0]:
                allowed = (not reset_seen and win_seen and state[:3] == (4138, 4138, 0)
                           and flags.get(2014) == 1 and flags.get(1672, 0) == 0
                           and clock['day'] == previous_clock[1] and (clock['hour'], clock['minute']) == (3, 15))
                if not allowed:
                    raise ValueError('clock moved backwards outside the original4138 post-win reset')
                reset_seen = True
            win_seen |= flags.get(2014, 0) == 1
            previous_clock = (current, clock['day'])
        if not reset_seen:
            raise ValueError('original4138 post-win03:15 reset was not observed')
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    required = ((3410, 4112, 4108, 4109, 4110, 2619, 2616, 2605, 2627, 2629, 2741) if route == 'corbin-portrait' else
                (1300, 1340, 1343, 4134, 4135, 4136, 4137, 4138, 4120, 4114, 4115, 4116, 4114, 6200))
    cursor = 0
    for scene in required:
        while cursor < len(opened) and opened[cursor] != scene:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered portrait/typing win or actual crest examination opens')
        cursor += 1
    return clocks[-1][1]


OIL_RUNE_ROUTES = ('oil-gargoyle', 'rune-passage')
OIL_RUNE_SCENES = {
    'oil-gargoyle': (4106, 4398, 1900, 1902, 1903, 1904, 2619, 3366,
                     3401, 3402, 3403, 3404, 3405, 3367, 3406, 3415, 3416),
    'rune-passage': (3499, 2900, 2965, 2966, 2967, 2968, 3175, 3176, 2968,
                     3063, 3171, 3063, 3170, 3194, 3195, 3050),
}


def oil_rune_configuration(route):
    _, prior, zero = typing_crest_configuration('typing-crest')
    # 2062 already belongs to the actual m47 source; oil does not newly earn it.
    prior |= {2062}
    if route == 'oil-gargoyle':
        states = [(4114, 0), (4112, 0), (4108, 0), (4109, 0), (4106, 0), (1900, 0),
                  (2619, 0), (2616, 0), (2605, 19), (2606, 0), (2607, 0), (2608, 0),
                  (2609, 0), (3321, 0), (3322, 0), (3323, 0), (3324, 0), (3366, 0),
                  (3401, 0), (3402, 0), (3403, 0), (3404, 0), (3405, 0), (3367, 0),
                  (3416, 0), (3416, 0), (3416, 0)]
        return states, prior | {1944, 1974, 1877}, (zero - {1974}) | {1864, 2003, 2081}
    if route == 'rune-passage':
        states = [(3416, 0), (3171, 0)] + [(3170, 0)] * 6 + [(3195, 0), (3050, 0), (3050, 0)]
        return states, (prior - {2041}) | {1944, 1974, 1877, 1864, 2003, 2081, 2042, 1809}, (zero - {1974, 2042, 1809}) | {2041}
    raise ValueError('unknown oil/rune route')


def verify_oil_rune_observations(route, log, observations, selected, clocks, positive, negative):
    # Original3175 a1 sound row4 (1357=1) writes1809=1 at0x432e35;
    # required3175->3176 opens precede its first held-light3171 observation.
    up = ({1944: 6, 1974: 24, 1877: 24} if route == 'oil-gargoyle' else
          {1809: 1, 1864: 1, 2042: 1, 2081: 2, 2003: 8})
    down = {2041: 1} if route == 'rune-passage' else {}
    changing = up.keys() | down.keys()
    previous = {**{f: 0 for f in up}, **{f: 1 for f in down}}
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required oil/rune event')
        if any(flags.get(f, 0) != 1 for f in positive - changing):
            raise ValueError('oil/rune retained prerequisite differs')
        if any(flags.get(f, 0) != 0 for f in negative - changing):
            raise ValueError('unexpected oil/rune unmet gate, failure or repeat event')
        if state[1] != state[0] or state[3] not in ((-1,) if route == 'oil-gargoyle' else (-1, 4)):
            raise ValueError('oil/rune art or actual item differs; crest2 is not held2')
        for f in previous:
            value = flags.get(f, 0)
            backwards = value < previous[f] if f in up else value > previous[f]
            if value not in (0, 1) or backwards:
                raise ValueError('oil/rune phase is not binary/monotone')
            previous[f] = value
    for i, (state, _, flags) in enumerate(selected):
        held = 4 if route == 'rune-passage' and i > 0 else -1
        if state[3] != held:
            raise ValueError('oil/rune actual held light or final safe state differs')
        if any(flags.get(f, 0) != int(i >= phase) for f, phase in up.items()) or any(
                flags.get(f, 0) != int(i < phase) for f, phase in down.items()):
            raise ValueError('oil/rune source and authored progression phases differ')
    # No fixed hour/day is required here. The original post-typing reset has
    # already happened; only complete, valid, monotone clock diagnostics apply.
    verify_clock_diagnostics(clocks)
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    cursor = 0
    for scene in OIL_RUNE_SCENES[route]:
        while cursor < len(opened) and opened[cursor] != scene:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered oil/rune authored scene opens')
        cursor += 1
    return clocks[-1][1]


RUNE_LIGHT_ROUTES = ('rune-light-wait', 'rune-light-replacement')
RUNE_LIGHT_SCENES = {
    'rune-light-wait': (3021, 3022, 3023, 3024, 3025, 3067, 3048, 2901, 3311,
                        3312, 3313, 3314, 3315, 3316, 3317, 3334, 3335, 6200, 3335),
    'rune-light-replacement': (3318, 3319, 3320, 3321, 3322, 3323, 3324, 3305,
                               3345, 3346, 3500, 3505, 3510, 1200, 1282, 1281, 3585,
                               3588, 1299, 1295, 1949, 3510),
}


def rune_light_configuration(route):
    _, prior, zero = oil_rune_configuration('rune-passage')
    # Original3345 afternoon door requires known1570 and2158 clear.
    prior |= {1570}
    zero |= {2158}
    if route == 'rune-light-wait':
        states = [(3050, 0), (3021, 0), (3022, 0), (3023, 0), (3024, 0), (3025, 0),
                  (3067, 0), (3048, 0), (3311, 0), (3312, 0), (3313, 0), (3314, 0),
                  (3315, 0), (3316, 0), (3317, 0), (3334, 0)] + [(3335, 0)] * 6
        return states, prior - {2042, 1514}, zero | {2042, 1514}
    if route == 'rune-light-replacement':
        states = [(3335, 0), (3318, 0), (3319, 0), (3320, 0), (3321, 0), (3322, 0),
                  (3323, 0), (3324, 0), (3305, 0), (3345, 0), (3346, 0), (3505, 0),
                  (3510, 4), (1200, 0), (1200, 0), (1200, 0), (3585, 0),
                  (3588, 0), (1295, 0), (1949, 0), (3510, 4), (3510, 4), (3510, 4)]
        return states, prior - {1809, 2042, 1514}, zero | {1809, 2042, 1514}
    raise ValueError('unknown rune-light route')


def verify_rune_light_observations(route, log, observations, selected, clocks, positive, negative):
    # Original3312 row7 clears1514 on this night traversal, before the wait;
    # its daytime row8 cannot restore it while the player remains at3335.
    down = {2042: 8, 1514: 9} if route == 'rune-light-wait' else {1809: 19}
    changing = down.keys() | ({1418} if route == 'rune-light-replacement' else set())
    previous = {f: 1 for f in down}
    pending_seen = pending_closed = False
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required rune-light event')
        if any(flags.get(f, 0) != 1 for f in positive - changing):
            raise ValueError('rune-light retained prerequisite differs')
        if any(flags.get(f, 0) != 0 for f in negative - changing):
            raise ValueError('unexpected rune-light future, failure or timer event')
        if state[1] != state[0] or state[3] not in (-1, 4, 5):
            raise ValueError('rune-light art or real item differs')
        for f in previous:
            value = flags.get(f, 0)
            if value not in (0, 1) or value > previous[f]:
                raise ValueError('rune-light original clear phase is not binary/monotone')
            previous[f] = value
        if route == 'rune-light-replacement':
            value = flags.get(1418, 0)
            if value not in (0, 1) or (pending_closed and value):
                raise ValueError('rune-light request/pickup pending cycle differs')
            if pending_seen and not value:
                pending_closed = True
            pending_seen |= value == 1
    for i, (state, _, flags) in enumerate(selected):
        held = (4 if i < 8 else 5 if i >= 18 else -1) if route == 'rune-light-wait' else (5 if i < 13 else 4 if i == 20 else -1)
        if state[3] != held:
            raise ValueError('rune-light used5, actual fresh4 or final safe frame differs')
        if any(flags.get(f, 0) != int(i < phase) for f, phase in down.items()):
            raise ValueError('rune-light source and authored clear phases differ')
        if route == 'rune-light-replacement' and flags.get(1418, 0) != int(16 <= i < 19):
            raise ValueError('rune-light actual paid request then reward was not observed')
    verify_clock_diagnostics(clocks)
    gated = clocks[-2:] if route == 'rune-light-wait' else [clocks[0], clocks[observations.index(selected[9])]]
    if any(clock['day'] != 3 or not 14 <= clock['hour'] < 21 for _, clock in gated):
        raise ValueError('rune-light original afternoon door window differs')
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    cursor = 0
    for scene in RUNE_LIGHT_SCENES[route]:
        while cursor < len(opened) and opened[cursor] != scene:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered rune-light authored opens or fresh1299 win')
        cursor += 1
    return clocks[-1][1]


FIRE_ALCHEMY_ROUTES = ('fire-phosphorus', 'moving-room-entry', 'alchemy-snake-clue',
                       'nigel-library', 'nigel-snake', 'alchemy-return')
NIGEL_BYE_SCENES = (1390, 1391, 1392, 1393)
ROOM_ORIENTATION_FLAGS = (1510, 1511, 1512, 1513)
FIRE_ALCHEMY_SCENES = {
    'fire-phosphorus': (3506, 3507, 3303, 3304, 3366, 3415, 3416, 3499, 2900, 2965, 2969, 3050, 3198,
                        3111, 3112, 3116, 3124, 3128, 2963, 3036, 3061, 3095, 3096, 3037),
    'moving-room-entry': (3037, 3056, 4300, 4302, 4303, 4301, 4304, 4305, 3046),
    'alchemy-snake-clue': (3190, 3046),
    'nigel-library': (3047, 3055, 4300, 4302, 4303, 4301, 4304, 4305, 3038, 2901,
                       3311, 3312, 2605, 4100, 4101, 4112),
    'nigel-snake': (1300, 1371, NIGEL_BYE_SCENES, 4112),
    'alchemy-return': (4399, 2619, 3366, 3415, 3416, 3499, 2900, 2969, 3050, 2963,
                       3036, 3037, 4300, 4302, 4303, 4301, 4304, 4305, 3046),
}


def fire_alchemy_configuration(route):
    _, prior, zero = rune_light_configuration('rune-light-replacement')
    # Actual source1510/1932/1935 are retained conditions, not new rewards.
    prior |= {1510, 1932, 1935}
    zero |= {1511, 1512, 1513, 1694, 1747, 1748, 1749, 1750, 1989, 2073, 2053, 2132}
    zero |= set(range(2136, 2146))
    # Fire/moving/clue never instantiate a1514 writer;3312 is reached later
    # on the library walk. Its daytime action restores1514 with Nigel presence.
    fire = set(range(1148, 1160)) | {1804, 1875, 1972, 2059}
    if route == 'fire-phosphorus':
        states = [(3510, 4), (3401, 0), (3402, 0), (3403, 0), (3404, 0), (3405, 0),
                  (3367, 0), (3416, 0), (3198, 0)] + [(3111, 0)] * 4 + [(2963, 0),
                  (3096, 0), (3096, 0), (3037, 0), (3037, 0)]
        return states, prior | fire, zero - fire
    prior |= fire
    zero -= fire
    if route == 'moving-room-entry':
        states = [(3037, 0), (3056, 0), (4300, 0), (4302, 0), (4302, 0), (4303, 0),
                  (4302, 0), (4303, 0), (4302, 0), (3046, 0), (3046, 0)]
        return states, (prior - {1510}) | {1512, 1989, 2073}, (zero - {1512, 1989, 2073}) | {1510}
    prior = (prior - {1510}) | {1512, 1989, 2073}
    zero = (zero - {1512, 1989, 2073}) | {1510}
    if route == 'alchemy-snake-clue':
        return [(3046, 0), (3190, 0), (3046, 0), (3046, 0)], prior | {1922}, zero - {1922}
    prior |= {1922}
    zero -= {1922}
    # Source-backed Nigel presence/list conditions, scoped when that NPC is relevant.
    zero |= {1670, 1673, 1674, 1675, 1680, 1684, 1705}
    if route == 'nigel-library':
        states = [(3046, 0), (4302, 0), (4302, 0), (3038, 0), (4112, 0), (4112, 0)]
        return states, (prior - {1512}) | {1510, 1514, 1672}, (zero - {1510, 1514, 1672}) | {1512}
    prior = (prior - {1512}) | {1510, 1514, 1672}
    zero = (zero - {1510, 1514, 1672}) | {1512}
    # These predicates fix the exercised Nigel response order without adding
    # unrelated fields whose branches are already excluded by retained flags.
    prior |= {1563, 1679}
    zero |= {1683, 1698, 1704, 1874, 1901}
    if route == 'nigel-snake':
        return [(4112, 0), (1300, 0), (1371, 0), (1371, 0), (4112, 0), (4112, 0)], prior | {1694}, zero - {1694}
    if route == 'alchemy-return':
        states = [(4112, 0), (3401, 0), (3402, 0), (3403, 0), (3404, 0), (3405, 0),
                  (3367, 0), (3416, 0), (3056, 0), (4300, 0), (4302, 0), (4302, 0),
                  (4303, 0), (4302, 0), (4303, 0), (4302, 0), (3046, 0), (3046, 0)]
        return states, (prior - {1510}) | {1512, 1694}, (zero - {1512, 1694}) | {1510}
    raise ValueError('unknown fire/alchemy-entry route')


def verify_fire_alchemy_observations(route, log, observations, selected, clocks, positive, negative):
    up = {'fire-phosphorus': {1148: 10, 1155: 10, 2059: 10, 1149: 11, 1153: 11,
                              1151: 12, 1152: 13, 1159: 13, 1972: 13, 1804: 14, 1875: 14},
          'moving-room-entry': {2073: 6, 1989: 9}, 'alchemy-snake-clue': {1922: 1},
          'nigel-library': {1514: 4, 1672: 4}, 'nigel-snake': {1694: 2}, 'alchemy-return': {}}[route]
    room_pulse = {'moving-room-entry': (2, 9), 'nigel-library': (1, 3),
                  'alchemy-return': (9, 16)}.get(route)
    changing = up.keys() | set(ROOM_ORIENTATION_FLAGS) | ({2041} if route == 'fire-phosphorus' else set())
    if room_pulse:
        changing |= {2137}
    orientations = {'fire-phosphorus': [0] * 18, 'moving-room-entry': [0] * 6 + [1, 1, 2, 2, 2],
                    'alchemy-snake-clue': [2] * 4, 'nigel-library': [2, 3, 0, 0, 0, 0],
                    'nigel-snake': [0] * 6, 'alchemy-return': [0] * 13 + [1, 1, 2, 2, 2]}[route]
    allowed_order = list(dict.fromkeys(orientations))
    orientation_phase = 0
    previous = {f: 0 for f in up}
    light_seen = light_closed = False
    room_seen = room_closed = False
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required fire/alchemy event')
        if any(flags.get(f, 0) != 1 for f in positive - changing):
            raise ValueError('fire/alchemy retained prerequisite differs')
        if any(flags.get(f, 0) != 0 for f in negative - changing):
            raise ValueError('unexpected fire/alchemy future, failure, timer or room event')
        for f in previous:
            value = flags.get(f, 0)
            if value not in (0, 1) or value < previous[f]:
                raise ValueError('fire/alchemy original progression is not binary/monotone')
            previous[f] = value
        room = [flags.get(f, 0) for f in ROOM_ORIENTATION_FLAGS]
        if any(v not in (0, 1) for v in room) or sum(room) != 1:
            raise ValueError('original first-room orientation is not one-hot')
        orientation = room.index(1)
        if orientation != allowed_order[orientation_phase]:
            orientation_phase += 1
            if orientation_phase == len(allowed_order) or orientation != allowed_order[orientation_phase]:
                raise ValueError('first-room orientation skipped or reversed an original turn')
        if route == 'fire-phosphorus':
            value = flags.get(2041, 0)
            if value not in (0, 1) or (light_closed and value):
                raise ValueError('fire route light activation/reset cycle differs')
            if light_seen and not value:
                light_closed = True
            light_seen |= value == 1
        if room_pulse:
            # Original raw6B sets2137 at4300/4301 and clears it at3038/3046.
            value = flags.get(2137, 0)
            if value not in (0, 1) or value != int(4300 <= state[0] <= 4305) or (room_closed and value):
                raise ValueError('original2137 moving-room entry/exit pulse differs')
            if room_seen and not value:
                room_closed = True
            room_seen |= value == 1
        allowed_held = ((-1, 4, 13) if route == 'fire-phosphorus' else
                        (13, -1) if route in ('nigel-snake', 'alchemy-return') else (13,))
        if state[1] != state[0] or state[3] not in allowed_held:
            raise ValueError('fire/alchemy art or real held item differs')
    for i, (state, _, flags) in enumerate(selected):
        held = ((4 if 8 <= i <= 14 else 13 if i >= 16 else -1) if route == 'fire-phosphorus' else
                (13 if i == 0 else -1) if route == 'nigel-snake' else
                (-1 if i < 8 else 13) if route == 'alchemy-return' else 13)
        if state[3] != held or flags.get(ROOM_ORIENTATION_FLAGS[orientations[i]], 0) != 1:
            raise ValueError('fire/alchemy actual13 or ordered room phase differs')
        if any(flags.get(f, 0) != int(i >= phase) for f, phase in up.items()):
            raise ValueError('fire/alchemy source and authored progression phases differ')
        if room_pulse and flags.get(2137, 0) != int(room_pulse[0] <= i < room_pulse[1]):
            raise ValueError('original2137 selected entry/exit phases differ')
        if route == 'fire-phosphorus' and flags.get(2041, 0) != int(8 <= i < 14):
            raise ValueError('fire route did not retain then reset actual light4')
    verify_clock_diagnostics(clocks)
    if route in ('nigel-library', 'nigel-snake'):
        relevant = selected[-2:] if route == 'nigel-library' else selected[:1]
        if any(not 480 <= clocks[observations.index(o)][1]['total_minutes'] <= 1260 for o in relevant):
            raise ValueError('original Nigel08:00..21:00 presence window differs')
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    cursor = 0
    for stage in FIRE_ALCHEMY_SCENES[route]:
        alternatives = stage if isinstance(stage, tuple) else (stage,)
        while cursor < len(opened) and opened[cursor] not in alternatives:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered fire/alchemy authored scene opens')
        cursor += 1
    return clocks[-1][1]


ALCHEMY_WIN_ROUTES = ('alchemy-win',)


def alchemy_win_configuration():
    _, prior, zero = fire_alchemy_configuration('alchemy-return')
    # This chapter ends at the first safe room beyond the alchemy door.
    # Aeolus, well, forge and final lab rewards remain unearned.
    zero |= {1959, 1973, 2004, 2017, 2052}
    return ([(3046, 0)] * 2 + [(3196, 0)] * 5 + [(3054, 0)] * 2,
            prior | {1960, 2053}, zero - {1960, 2053})


def verify_alchemy_win_observations(log, observations, selected, clocks, positive, negative):
    changing = {1960, 2053, 2132}
    previous = {1960: 0, 2053: 0}
    for state, scope, flags in observations:
        if not (positive | negative) <= scope:
            raise ValueError('RC_FLAGS did not observe every required alchemy event')
        if any(flags.get(f, 0) != 1 for f in positive - changing):
            raise ValueError('alchemy retained prerequisite differs')
        if any(flags.get(f, 0) != 0 for f in negative - changing):
            raise ValueError('unexpected alchemy future, failure or room event')
        for f in previous:
            value = flags.get(f, 0)
            if value not in (0, 1) or value < previous[f]:
                raise ValueError('alchemy original progression is not binary/monotone')
            previous[f] = value
        # 2053 is also set on exit/explosion, so it cannot establish a win.
        # 3193 sets2132;3054 clears it before the final safe observations.
        pulse = flags.get(2132, 0)
        if (pulse not in (0, 1) or
                (flags.get(1960, 0) == 1 and flags.get(2053, 0) != 1) or
                (pulse and flags.get(1960, 0) != 1)):
            raise ValueError('alchemy original win/door pulse differs')
        if state[1] != state[0] or state[3] != 13:
            raise ValueError('alchemy art or real held13 differs')
    for i, (_, _, flags) in enumerate(selected):
        if any(flags.get(f, 0) != int(i >= 7) for f in (1960, 2053)) or flags.get(2132, 0) != 0:
            raise ValueError('alchemy source, five-round and new-win phases differ')
    verify_clock_diagnostics(clocks)
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    if set(opened) & {3049, 3191, 3192, 6301}:
        raise ValueError('alchemy took original exit or explosion branch')
    cursor = 0
    for scene in (3190, 3196, 3193, 3054):
        while cursor < len(opened) and opened[cursor] != scene:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered alchemy authored scene opens')
        cursor += 1
    return clocks[-1][1]


LAB_MOULD_ROUTES = ('lab-entry', 'mould-shape')
MOULD_BAR_ORDER = (2147, 2148, 2149, 2151, 2162, 2164, 2165, 2167, 2170, 2172, 2173,
                   2176, 2178, 2179, 2181, 2182, 2183, 2185, 2186, 2187, 2189, 2190, 2191, 2163)
MOULD_BAR_FLAGS = set(range(2147, 2152)) | set(range(2162, 2193))
LAB_LOCAL_FLAGS = {1000, 1001, 1005}


def lab_mould_configuration(route):
    # A focused logged scope fits the existing1024-byte FLAGS buffer. Root's
    # outer save audit separately retains all185 inherited alchemy predicates.
    prior = set(range(1148, 1160)) | {1512, 1514, 1694, 1804, 1875, 1922, 1960,
                1972, 1989, 2003, 2014, 2018, 2053, 2059, 2156, 2159}
    zero = {1098, 1099, 1100, 1101, 1510, 1511, 1513, 1561, 1862, 1889, 1926,
            1942, 1959, 1961, 1965, 1973, 1999, 2004, 2017, 2052, 2067, 2070, 2132}
    zero |= set(range(2136, 2146))
    progress = {1876, 1888, 2234}
    if route == 'lab-entry':
        return [(3054, 0)] + [(3804, 0)] * 3, prior, zero | progress | MOULD_BAR_FLAGS
    if route == 'mould-shape':
        return ([(s, 0) for s in (3804, 3805, 3808, 3803)] + [(3801, 0)] * 27 + [(3803, 0)] * 2,
                prior | progress | set(MOULD_BAR_ORDER), zero | (MOULD_BAR_FLAGS - set(MOULD_BAR_ORDER)))
    raise ValueError('unknown lab/mould route')


def verify_lab_mould_observations(route, log, observations, selected, clocks, positive, negative):
    phases = ({1876: 2, 1888: 4, 2234: 6} |
              {flag: 6+i for i, flag in enumerate(MOULD_BAR_ORDER)}) if route == 'mould-shape' else {}
    previous = {flag: 0 for flag in phases}
    for state, scope, flags in observations:
        if not (positive | negative | LAB_LOCAL_FLAGS) <= scope:
            raise ValueError('RC_FLAGS did not observe every required lab/mould event')
        if any(flags.get(f, 0) != 1 for f in positive - phases.keys()):
            raise ValueError('lab/mould retained prerequisite differs')
        if any(flags.get(f, 0) != 0 for f in negative):
            raise ValueError('unexpected lab/mould bar, future or failure event')
        if any(flags.get(f, 0) not in (0, 1) for f in LAB_LOCAL_FLAGS):
            raise ValueError('lab/mould local input flag is not binary')
        for f in previous:
            value = flags.get(f, 0)
            if value not in (0, 1) or value < previous[f]:
                raise ValueError('lab/mould original progression is not binary/monotone')
            previous[f] = value
        if state[1] != state[0] or state[3] != 13:
            raise ValueError('lab/mould art or real held13 differs')
    for i, (_, _, flags) in enumerate(selected):
        if any(flags.get(f, 0) != int(i >= phase) for f, phase in phases.items()):
            raise ValueError('lab/mould empty-source, feedback or ordered bar phases differ')
    verify_clock_diagnostics(clocks)
    opened = [int(m[1]) for m in re.finditer(r'FILE open .*\\S(\d+)\.CIF\s+\[virtual \d+ ms\]', log)]
    required = (2908, 3800, 3804) if route == 'lab-entry' else (3805, 3808, 3803, 3801, 3803)
    cursor = 0
    for scene in required:
        while cursor < len(opened) and opened[cursor] != scene:
            cursor += 1
        if cursor == len(opened):
            raise ValueError('missing ordered lab/mould authored scene opens')
        cursor += 1
    return clocks[-1][1]


def verify(log, save, route='telescope-prep', *, glyph_scene=3588):
    if glyph_scene not in (3588, 3589) or (glyph_scene != 3588 and route != 'glyph-win'):
        raise ValueError('explicit glyph scene is valid only for glyph-win')
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
        expected, positive, negative = glyph_win_configuration(glyph_scene)
    elif route in WORD_PREREQUISITE_ROUTES:
        expected, positive, negative = word_prerequisite_configuration(route)
    elif route in WORD_LOCK_ROUTES:
        expected, positive, negative = word_lock_configuration(route)
    elif route in CREST_PREREQUISITE_ROUTES:
        expected, positive, negative = crest_prerequisite_configuration(route)
    elif route in TYPING_CREST_ROUTES:
        expected, positive, negative = typing_crest_configuration(route)
    elif route in OIL_RUNE_ROUTES:
        expected, positive, negative = oil_rune_configuration(route)
    elif route in RUNE_LIGHT_ROUTES:
        expected, positive, negative = rune_light_configuration(route)
    elif route in FIRE_ALCHEMY_ROUTES:
        expected, positive, negative = fire_alchemy_configuration(route)
    elif route in ALCHEMY_WIN_ROUTES:
        expected, positive, negative = alchemy_win_configuration()
    elif route in LAB_MOULD_ROUTES:
        expected, positive, negative = lab_mould_configuration(route)
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
    if route in WORD_LOCK_ROUTES:
        held_steps = {'light-depletion': {4: 4, 5: 4, 6: 4, 7: 4, 8: -1},
                      'paid-light-request': {1: 5, 2: -1}, 'repeat-glyph-win': {4: 4},
                      'word-lock': {4: 4, 5: 4}}[route]
    if route in CREST_PREREQUISITE_ROUTES:
        held_steps = {'right-fire-panel': {i: 4 for i in range(1, 12)},
                      'ethel-interrogation': {0: 4, 1: 4, 2: 4}}.get(route, {})
    if route == 'rune-light-replacement':
        held_steps = {20: 4}
    selected = []
    for observation in observations:
        state, scope, flags = observation
        pair = (state[0], state[2])
        if route == 'glyph-win' and len(selected) == 2 and pair == (1295, 0):
            pair = (1294, 0)
        if route == 'linda-curse' and len(selected) == 7 and state[0] in (1128, 1129, 1130, 1131, 1132, 1146, 1133) and state[2] == 0:
            pair = (1146, 0)
        if route == 'typing-crest' and len(selected) == 6 and pair == (1340, 0) and flags.get(2014, 0) == 1:
            pair = (1343, 0)
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
    if route in ('jupiter-column', 'moon-key', 'moon-column') + GHOST_ROUTES + PASSAGE_ROUTES + POST_KEY_ROUTES + DRAGON_LIGHT_ROUTES + GLYPH_WIN_ROUTES + WORD_PREREQUISITE_ROUTES + WORD_LOCK_ROUTES + CREST_PREREQUISITE_ROUTES + TYPING_CREST_ROUTES + OIL_RUNE_ROUTES + RUNE_LIGHT_ROUTES + FIRE_ALCHEMY_ROUTES + ALCHEMY_WIN_ROUTES + LAB_MOULD_ROUTES:
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
        clock_diagnostics = verify_glyph_win_observations(log, observations, selected, clocks, positive, negative, glyph_scene)
    if route in WORD_PREREQUISITE_ROUTES:
        clock_diagnostics = verify_word_prerequisite_observations(route, log, observations, selected, clocks, positive, negative)
    if route in WORD_LOCK_ROUTES:
        clock_diagnostics = verify_word_lock_observations(route, log, observations, selected, clocks, positive, negative)
    if route in CREST_PREREQUISITE_ROUTES:
        clock_diagnostics = verify_crest_prerequisite_observations(route, log, observations, selected, clocks, positive, negative)
    if route in TYPING_CREST_ROUTES:
        clock_diagnostics = verify_typing_crest_observations(route, log, observations, selected, clocks, positive, negative)
    if route in OIL_RUNE_ROUTES:
        clock_diagnostics = verify_oil_rune_observations(route, log, observations, selected, clocks, positive, negative)
    if route in RUNE_LIGHT_ROUTES:
        clock_diagnostics = verify_rune_light_observations(route, log, observations, selected, clocks, positive, negative)
    if route in FIRE_ALCHEMY_ROUTES:
        clock_diagnostics = verify_fire_alchemy_observations(route, log, observations, selected, clocks, positive, negative)
    if route in ALCHEMY_WIN_ROUTES:
        clock_diagnostics = verify_alchemy_win_observations(log, observations, selected, clocks, positive, negative)
    if route in LAB_MOULD_ROUTES:
        clock_diagnostics = verify_lab_mould_observations(route, log, observations, selected, clocks, positive, negative)
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
            'save': save.name, 'telescope_complete': route in ('telescope-use', 'seedlings', 'crank-repair', 'betty-key', 'venus-column', 'jupiter-column', 'moon-key', 'moon-column') + GHOST_ROUTES + PASSAGE_ROUTES + POST_KEY_ROUTES + DRAGON_LIGHT_ROUTES + GLYPH_WIN_ROUTES + WORD_PREREQUISITE_ROUTES + WORD_LOCK_ROUTES + CREST_PREREQUISITE_ROUTES + TYPING_CREST_ROUTES + OIL_RUNE_ROUTES + RUNE_LIGHT_ROUTES + FIRE_ALCHEMY_ROUTES + ALCHEMY_WIN_ROUTES + LAB_MOULD_ROUTES}
    if route in WORD_PREREQUISITE_ROUTES + WORD_LOCK_ROUTES:
        result['word_lock_won'] = route == 'word-lock'
    if route in TYPING_CREST_ROUTES:
        result['typing_won'] = route == 'typing-crest'
    if route in OIL_RUNE_ROUTES:
        result['rune_won'] = route == 'rune-passage'
    if route in RUNE_LIGHT_ROUTES:
        result['fresh_light_earned'] = route == 'rune-light-replacement'
    if route in FIRE_ALCHEMY_ROUTES:
        result['alchemy_knowledge_ready'] = route == 'alchemy-return'
        result['alchemy_won'] = False
    if route in ALCHEMY_WIN_ROUTES:
        result['alchemy_knowledge_ready'] = True
        result['alchemy_won'] = True
    if route in LAB_MOULD_ROUTES:
        result['alchemy_knowledge_ready'] = True
        result['alchemy_won'] = True
        result['mould_prepared'] = route == 'mould-shape'
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
    parser.add_argument('--route', choices=('telescope-prep', 'jane-jigsaw', 'telescope-use', 'seedlings', 'crank-repair', 'betty-key', 'venus-column', 'jupiter-column', 'moon-key', 'moon-column') + GHOST_ROUTES + PASSAGE_ROUTES + POST_KEY_ROUTES + DRAGON_LIGHT_ROUTES + GLYPH_WIN_ROUTES + WORD_PREREQUISITE_ROUTES + WORD_LOCK_ROUTES + CREST_PREREQUISITE_ROUTES + TYPING_CREST_ROUTES + OIL_RUNE_ROUTES + RUNE_LIGHT_ROUTES + FIRE_ALCHEMY_ROUTES + ALCHEMY_WIN_ROUTES + LAB_MOULD_ROUTES,
                        default='telescope-prep')
    parser.add_argument('--glyph-scene', type=int, choices=(3588, 3589), default=3588,
                        help='explicit original board scene for glyph-win only')
    args = parser.parse_args()
    try:
        print(json.dumps(verify(args.run_log.read_text(), args.save_file,
                                args.route, glyph_scene=args.glyph_scene), sort_keys=True))
    except (ValueError, OSError) as error:
        raise SystemExit('route verification failed: ' + str(error))
