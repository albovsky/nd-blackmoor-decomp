#!/usr/bin/env python3
"""FL-46: resumable batch driver for long mutation runs (the container is reset when a session idles, which kills a background job; this skips every row already in the log).

  fl46_driver.py --log LOG [--rescue REQUESTS.json --base N --seeds N] [--rows a,b,c | --rows-file F] [--batch 4] [--corpus FILE]      (run from outputs/blackmoor-decomp)

The environment passes through (FL46_STRICT_HANG=1, FL46_ALARM=0.5). With --rescue, only the rows of the requests file (or of --rows) are run, in batches, each batch against its own slice of the requests.
"""
import argparse
import concurrent.futures
import threading
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile

PROJECT = Path(__file__).resolve().parents[1]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--log', required=True)
    ap.add_argument('--rescue')
    ap.add_argument('--base', default='40000')
    ap.add_argument('--seeds', default='1500')
    ap.add_argument('--rows')
    ap.add_argument('--rows-file')
    ap.add_argument('--batch', type=int, default=4)
    ap.add_argument('--corpus')
    ap.add_argument('--jobs', default='4')
    a = ap.parse_args()
    request = json.loads(Path(a.rescue).read_text()) if a.rescue else None
    rows = a.rows.split(',') if a.rows else Path(a.rows_file).read_text().strip().split(',') if a.rows_file else list(request['rows_with_survivors'])
    log = Path(a.log)
    done = {l.split()[0] for l in log.read_text().splitlines() if re.match(r'0x[0-9a-f]+ ', l)} if log.is_file() else set()
    todo = [r for r in rows if r not in done]
    lock = threading.Lock()

    def one(row):
        cmd = [sys.executable, 'tests/fl40_mutation_check.py', '--per-row', '100000', '--jobs', '1']
        if a.corpus:
            cmd += ['--corpus', a.corpus]
        tmp = None
        if request:
            if row not in request['rows_with_survivors']:
                return
            tmp = tempfile.NamedTemporaryFile('w', suffix='.json', delete=False)
            json.dump({'rows_with_survivors': {row: request['rows_with_survivors'][row]}}, tmp)
            tmp.close()
            cmd += ['--rescue', tmp.name, '--base', a.base, '--seeds', a.seeds]
        else:
            cmd += ['--rows', row]
        out = subprocess.run(cmd, capture_output=True, text=True, cwd=PROJECT).stdout
        with lock, log.open('a') as f:
            for line in out.splitlines():
                if re.match(r'0x[0-9a-f]+ ', line):
                    f.write(line + '\n')

    with concurrent.futures.ThreadPoolExecutor(int(a.jobs)) as pool:
        list(pool.map(one, todo))


if __name__ == '__main__':
    main()
