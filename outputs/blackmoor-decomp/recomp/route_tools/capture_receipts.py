"""Validate the Session's full PPM catalog and exact ordinary-shot accounting."""
from collections.abc import Mapping
import re
import bul_live as io


def verify_captures(out, catalog, expected_shots):
    io.require(isinstance(catalog, Mapping) and type(expected_shots) is int and expected_shots > 0,
               'capture receipt must be a name-to-sha256 mapping')
    io.require(all(isinstance(name, str) and re.fullmatch(r'(shot|frame)\d{3,}\.ppm', name)
                   and isinstance(sha, str) and re.fullmatch(r'[0-9a-f]{64}', sha)
                   for name, sha in catalog.items()), 'invalid closed capture catalog entry')
    ordinary = {name for name in catalog if name.startswith('shot')}
    io.require(ordinary == {f'shot{n:03d}.ppm' for n in range(1, expected_shots+1)},
               'closed ordinary-shot sequence differs')
    directory = out / 'frames'
    io.require(set(catalog) == {p.name for p in directory.glob('*.ppm')},
               'receipt/disk PPM catalog differs')
    for name, expected in catalog.items():
        path = directory / name
        io.require(path.is_file() and not path.is_symlink() and io.digest(path) == expected,
                   'closed capture hash changed: ' + name)
        io.ppm(path)
    return {'ordinary_shots': {n: catalog[n] for n in sorted(ordinary)},
            'automatic_frames': {n: catalog[n] for n in sorted(set(catalog)-ordinary)},
            'all_catalog_hashes_and_closed_P6_valid': True}
