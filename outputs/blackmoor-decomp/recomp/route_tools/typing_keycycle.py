"""Pinned ordinary Senior key input and read-only source-clock profile guards."""
import json
from pathlib import Path
import re

import bul_live as io

CYCLE_PATH = Path(__file__).with_name('typing-senior-keycycle.txt')
CYCLE_SHA256 = '1487a40ffe72c92188d11559f90d322678a8d2e1e7bc53e946bcda69acb75179'
MAX_CYCLES = 24


def payload():
    io.require(io.digest(CYCLE_PATH) == CYCLE_SHA256, 'Senior key-cycle input hash differs')
    return CYCLE_PATH.read_text().strip()


def check_clock(clock):
    io.require(isinstance(clock, dict) and set(clock) == {'day', 'hour', 'minute', 'total_minutes'}
               and all(type(v) is int for v in clock.values()) and clock['day'] >= 0
               and 0 <= clock['hour'] < 24 and 0 <= clock['minute'] < 60
               and clock['total_minutes'] == clock['hour'] * 60 + clock['minute'],
               'invalid bound Senior source clock')


def load_profile(path, expected_sha256, source_sha256):
    io.require(path.stat().st_size <= 65536 and io.digest(path) == expected_sha256,
               'Senior source-profile hash or size differs')
    profile = json.loads(path.read_text())
    io.require(isinstance(profile, dict) and set(profile) == {'name', 'difficulty', 'source_sha256', 'clock'}
               and profile['name'] == 'senior' and type(profile['difficulty']) is int
               and profile['difficulty'] == 2 and isinstance(profile['source_sha256'], str)
               and re.fullmatch('[0-9a-f]{64}', profile['source_sha256']) is not None
               and profile['source_sha256'] == source_sha256, 'Senior source-profile identity differs')
    check_clock(profile['clock'])
    return profile


def check_full_quiz(log):
    opened = [(int(scene), int(t)) for scene, t in re.findall(
        r'FILE open .*?\\S(1340|1343)\.CIF\s+\[virtual (\d+) ms\]', log)]
    entered = [t for scene, t in opened if scene == 1340]
    passed = [t for scene, t in opened if scene == 1343]
    io.require(entered and passed and min(passed) - min(entered) >= 60000,
               'Senior win needs the full original60-second quiz and new1343')
