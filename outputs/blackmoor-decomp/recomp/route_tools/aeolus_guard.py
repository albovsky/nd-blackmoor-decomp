"""Read-only source/result guards; never reads live puzzle positions or scores."""
import re
import struct
import check_route


def require(value, message):
    if not value:
        raise ValueError(message)


def scope(profile):
    values = sorted(set(profile['logged_fixed_one']) | set(profile['logged_source_zero']) | set(range(338, 342)))
    runs = []
    for value in values:
        if runs and value == runs[-1][1]+1: runs[-1][1] = value
        else: runs.append([value, value])
    return ','.join(str(a) if a == b else f'{a}-{b}' for a, b in runs)


def read_profile(path, profile):
    data = path.read_bytes()
    require(len(data) == 170770, 'original UI save length differs')
    return {'state': [struct.unpack_from('<h', data, offset)[0] for offset in (0x21642, 0x21646, 0x215d2, 0x10e)],
            'difficulty': struct.unpack_from('<h', data, 0x9034)[0],
            'flags': {key: struct.unpack_from('<I', data, 0x1ee6+4*int(key))[0] for key in profile['flags']},
            'inventory40': list(struct.unpack_from('<40I', data, 0x2ba)),
            'clock': dict(zip(('minute', 'hour', 'day'), struct.unpack_from('<3H', data, 0x2434)))}


def check_profile(value, profile, *, won):
    require(value['difficulty'] == profile['difficulty'] == 0, 'not the genuine Junior profile')
    require(value['state'] == ([3813, 3813, 0, 13] if won else profile['state']), 'saved scene/art/view/held differs')
    require(value['inventory40'] == profile['inventory40'], 'saved inventory differs; real10/held13 must persist')
    expected = dict(profile['flags'])
    if won: expected.update({str(f): 1 for f in profile['win_flags']})
    require(value['flags'] == expected, 'saved progression/mould differs;2163 must stay1')
    clock = value['clock']
    require(clock['day'] >= 1 and 0 <= clock['hour'] < 24 and 0 <= clock['minute'] < 60, 'saved clock invalid')
    total = lambda c: (c['day']-1)*1440+c['hour']*60+c['minute']
    require(total(clock) >= total(profile['clock']), 'original clock moved backwards')


def check_observation(observation, profile):
    state, flags = observation['state'], observation['flags']
    observed = check_route.flag_scope(observation['scope'], include_clock=True)
    required = check_route.flag_scope(scope(profile), include_clock=True)
    require(required <= observed, 'observation scope incomplete')
    changing = set(profile['win_flags'])
    require(all(flags.get(f, 0) == 1 for f in set(profile['logged_fixed_one'])-changing), 'retained/mould prerequisite differs')
    require(all(flags.get(f, 0) == 0 for f in set(profile['logged_source_zero'])-changing), 'unexpected future reward/failure')
    require(all(flags.get(f, 0) in (0, 1) for f in changing), 'Aeolus proof flag is not binary')
    require(state[0] == state[1] and state[3] == 13, 'art/real held13 differs')
    if flags.get(1959, 0):
        require(all(flags.get(f, 0) == 1 for f in (1098, 1099, 1100, 1101)), '1959 without allfour original prizes')


def check_observations(observations, profile, *, final=False):
    require(bool(observations), 'missing original observations')
    clocks = []
    for ob in observations:
        check_observation(ob, profile)
        flags = ob['flags']
        clocks.append((check_route.flag_scope(ob['scope'], include_clock=True) & set(range(338, 342)),
                       {'total_minutes': (flags.get(338, 0)>>16) | ((flags.get(339, 0)&65535)<<16),
                        'hour': flags.get(340, 0)&65535, 'minute': flags.get(339, 0)>>16,
                        'day': flags.get(340, 0)>>16}))
    check_route.verify_clock_diagnostics(clocks)
    if final:
        require(len(observations) >= 2, 'final safe observations incomplete')
        for ob in observations[-2:]:
            require(ob['state'] == [3813, 3813, 0, 13] and all(ob['flags'].get(f, 0) == 1 for f in profile['win_flags']),
                    'missing safe original win/return observations')


def check_protocol_receipt(receipt):
    require(receipt.get('protocol_complete') is True and receipt.get('returncode') == 0
            and receipt.get('error') is None and receipt.get('source_unchanged') is True
            and receipt.get('copied_source_unchanged') is True, 'control stream incomplete/error or source changed')


def check_requested_stop(log):
    results = [line[7:] for line in log.splitlines() if line.startswith('RESULT ')]
    require(len(results) == 1 and re.match(r'\{\s*"stopped"\s*:\s*"stop requested(?: |")', results[0]),
            'native did not report its normal requested stop')
