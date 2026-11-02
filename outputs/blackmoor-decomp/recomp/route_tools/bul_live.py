#!/usr/bin/env python3
"""One bounded Bul wager attempt through reviewed headless ordinary input.

Requires an uncompleted m23-equivalent save at S4408. A loss or incomplete
run is refused. Pixel heuristics choose UI clicks; the original game owns
all puzzle rules, AI, randomness, story transitions and save serialization.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import stat
import struct
import subprocess
import tempfile
import time

import check_route
import story_route

ORIGINAL_SHA256 = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
# The observed Senior-derived UI heuristic, also exercised in one Junior win.
# Optional second roll only for these visible gaps; never a victory guarantee.
OPTIONAL_ROLL_GAPS = {1, 2, 3, 9, 10}
MAX_BATCHES = 192
SAVE_DIR = Path('Documents5') / 'The Curse of Blackmoor Manor'


def require(ok, message):
    if not ok:
        raise ValueError(message)


def digest(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2) + '\n')


def save_state(path, progression_flags=(1404, 1435, 1405)):
    """Read-only fields of the original save layout; never serialize a save."""
    data = path.read_bytes()
    require(len(data) == 170770, 'unexpected save length')
    result = {name: struct.unpack_from('<h', data, offset)[0] for name, offset in (
        ('difficulty', 0x9034), ('held', 0x10e), ('scene', 0x21642),
        ('art', 0x21646), ('view', 0x215d2))}
    result['progression'] = {flag: struct.unpack_from('<I', data, 0x1ee6 + 4 * flag)[0]
                             for flag in progression_flags}
    return result


def ppm(path):
    raw = path.read_bytes()
    headers = (b'P6 640 480 255\n', b'P6\n640 480\n255\n')
    header = next((value for value in headers if raw.startswith(value)), None)
    require(header is not None and len(raw) == len(header) + 640 * 480 * 3,
            'expected a closed 640x480 P6 capture')
    return raw[len(header):]


def crop(data, left, top, width, height):
    return b''.join(data[((top + y) * 640 + left) * 3:
                        ((top + y) * 640 + left + width) * 3] for y in range(height))


class CapturePending(ValueError):
    """Visible markers/button are ambiguous during an animation."""


class BoardPixels:
    """Calibrate from the actual initial board: player1, computer12, PASS off.

    Geometry/color thresholds are capture tooling, not a puzzle implementation.
    No image template or resource bytes are distributed with this tool.
    """
    def __init__(self, initial):
        require(len(initial) == 640 * 480 * 3, 'incomplete initial capture')
        self.player = crop(initial, 63, 163, 41, 83)
        self.computer = crop(initial, 536, 163, 41, 83)
        self.mask = [i for i in range(0, len(self.player), 3)
                     if max(abs(self.player[i+k] - self.computer[i+k]) for k in range(3)) > 50
                     and max(self.player[i:i+3]) - min(self.player[i:i+3]) > 40]
        require(len(self.mask) >= 20, 'initial marker colors are not distinct')
        self.disabled = crop(initial, 282, 136, 74, 24)
        first = self.read(initial)
        require((first['player'], first['computer'], first['pass_enabled']) == (1, 12, False),
                'capture is not the initial Bul board')

    def read(self, data):
        require(len(data) == 640 * 480 * 3, 'incomplete board capture')
        cells = [crop(data, 63 + 43 * i, 163, 41, 83) for i in range(12)]
        def marker(template):
            ranked = sorted((sum(abs(cell[i+k] - template[i+k]) for i in self.mask
                                 for k in range(3)) / (len(self.mask) * 3), n + 1)
                            for n, cell in enumerate(cells))
            if ranked[0][0] > 8 or ranked[1][0] - ranked[0][0] < 10:
                raise CapturePending('marker pixels are not unambiguous')
            return ranked[0][1]
        player, computer = marker(self.player), marker(self.computer)
        button = crop(data, 282, 136, 74, 24)
        error = sum(abs(a-b) for a, b in zip(button, self.disabled)) / len(button)
        if .2 < error < 3 or player == computer:
            raise CapturePending('board/button animation is not settled')
        gap = (computer - player) % 12
        return {'player': player, 'computer': computer, 'gap': gap,
                'pass_enabled': error >= 3, 'pass_pixel_error': round(error, 4)}


def action(board):
    require(1 <= board['gap'] <= 11, 'invalid visible gap')
    return 'roll' if not board['pass_enabled'] or board['gap'] in OPTIONAL_ROLL_GAPS else 'pass'


def batch_line(request_id, payload):
    require(type(request_id) is int and 1 <= request_id < MAX_BATCHES, 'batch id out of bounds')
    require(payload and payload.isascii() and '\n' not in payload and '\r' not in payload
            and len(payload.encode()) <= 65536 and len(payload.split(';')) <= 512,
            'invalid bounded batch text')
    return f'{request_id} {payload}\n'


def ack(line, request_id, count, previous):
    match = re.fullmatch(r'  CONTROL ACK id=(\d+) steps=(\d+)/(\d+) shots=(\d+) '
                         r'clock_ms=(\d+) total_steps=(\d+) total_shots=(\d+)', line)
    require(match is not None, 'malformed ACK')
    values = list(map(int, match.groups()))
    require(values[0] == request_id and values[1] == values[2] == count
            and values[5] == previous[0] + count and values[6] == previous[1] + values[3],
            'ACK id/count totals differ from the submitted batch')
    return values


def completed(log, finish_id, previous):
    lines = [line for line in log.splitlines() if line.startswith('  CONTROL SUMMARY ')]
    require(len(lines) == 1, 'missing/duplicate control summary')
    match = re.fullmatch(r'  CONTROL SUMMARY complete=1 finish_id=(\d+) acked=(\d+) '
                         r'requests=(\d+) steps=(\d+)/(\d+) shots=(\d+) bytes=(\d+) '
                         r'pending=0 clock_ms=(\d+) failed=0 reason=', lines[0])
    require(match is not None, 'control stream did not finish cleanly')
    values = list(map(int, match.groups()))
    require(values[:3] == [finish_id, finish_id - 1, finish_id]
            and values[3:6] == [previous[0], previous[0], previous[1]], 'finish totals differ')
    return lines[0].strip()


def flag_scope(rc_flags=None):
    if rc_flags is not None:
        require(isinstance(rc_flags, str) and bool(rc_flags), 'invalid explicit RC_FLAGS')
        return rc_flags
    _, one, zero = check_route.passage_configuration('bul-key')
    return ','.join(map(str, sorted(one | zero | set(range(338, 342)))))


class Session:
    """One fresh clone, one native child, sequential ordinary FIFO batches."""
    def __init__(self, args, out, source, *, rc_flags=None):
        self.out, self.source, self.args = out, source, args
        selected_flags = flag_scope(rc_flags)
        out.mkdir(exist_ok=False)
        self.source_hash = digest(source)
        self.game = out / 'game'
        subprocess.run(['cp', '-cR', str(args.game_data), str(self.game)], check=True)
        self.saves = self.game / SAVE_DIR
        self.saves.mkdir(parents=True, exist_ok=False)
        self.copy = self.saves / source.name
        shutil.copy2(source, self.copy)
        require(digest(self.copy) == self.source_hash, 'source copy hash mismatch')
        self.fifo = out / 'ordinary-input.fifo'
        os.mkfifo(self.fifo, 0o600)
        require(stat.S_IMODE(self.fifo.stat().st_mode) == 0o600, 'FIFO mode differs')
        self.fd = os.open(self.fifo, os.O_RDWR | os.O_NONBLOCK)
        self.stream = (out / 'requests.txt').open('w')
        self.started, self.request_id, self.total = time.monotonic(), 0, [0, 0]
        self.position, self.fragment, self.pending = 0, '', False
        self.observations, self.state, self.scope = [], None, ''
        self.receipt = {'accepted': False, 'acceptance_owner': 'combined outer receipt after verified save-only reload',
                        'source_sha256': self.source_hash,
                        'copied_source_sha256': digest(self.copy), 'native_sha256': args.native_sha256,
                        'game_dir': str(self.game), 'source_save': str(source), 'RC_FLAGS': selected_flags,
                        'source_state': save_state(source), 'fifo_mode': '0o600',
                        'max_imports': 90000000, 'max_idle_polls': 1800000,
                        'timeout_seconds': args.timeout, 'max_batches': MAX_BATCHES}
        write_json(out / 'receipt.json', self.receipt)
        env = dict(os.environ)
        for key in ('INPUT', 'RC_REAL', 'RC_TRACE_MS', 'RC_CONTROL_FIFO'):
            env.pop(key, None)
        env.update(GAME_EXE=str(args.game_exe), RC_GAMEDIR=str(self.game), RC_OUT=str(out),
                   RC_CONTROL_FIFO=str(self.fifo), RC_FLAGS=self.receipt['RC_FLAGS'],
                   MAX_IMPORTS='90000000', MAX_IDLE_POLLS='1800000')
        self.stdout = (out / 'stdout.txt').open('w')
        self.proc = subprocess.Popen([str(args.native)], cwd=self.game, env=env,
                                     stdout=self.stdout, stderr=subprocess.STDOUT)

    def lines(self):
        path = self.out / 'run.log'
        if not path.exists():
            return []
        with path.open() as stream:
            stream.seek(self.position)
            data = stream.read()
            self.position = stream.tell()
        lines = (self.fragment + data).split('\n')
        self.fragment = lines.pop()
        for line in lines:
            if line.startswith('  CONTROL ERROR'):
                raise ValueError(line)
            match = re.fullmatch(r'  STATE requested_scene=(\d+) art_scene=(\d+) view=(-?\d+) held_item=(-?\d+)', line)
            if match:
                self.state = list(map(int, match.groups()))
                self.scope = ''
            elif line.startswith('  RC_FLAGS '):
                self.scope = line[11:]
            elif line.startswith('  FLAGS') and self.state is not None:
                require(len(line.encode()) < 1023, 'FLAGS record may be truncated')
                self.observations.append({'state': self.state, 'scope': self.scope,
                    'flags': {int(k): int(v) for k, v in re.findall(r'(\d+)=(\d+)', line)}})
        return lines

    def send(self, payload):
        self.request_id += 1
        line = batch_line(self.request_id, payload)
        self.stream.write(line)
        self.stream.flush()
        data, self.pending = line.encode(), True
        while data:
            try:
                data = data[os.write(self.fd, data):]
            except BlockingIOError:
                require(time.monotonic() - self.started < self.args.timeout, 'FIFO write deadline')
                time.sleep(.001)
        while True:
            for response in self.lines():
                if response.startswith('  CONTROL ACK '):
                    values = ack(response, self.request_id, len(payload.split(';')), self.total)
                    self.total = values[5:7]
                    self.pending = False
                    image = self.out / 'frames' / f'shot{values[6]:03d}.ppm'
                    require(image.is_file() and self.observations, 'closed capture/observation missing')
                    return self.observations[-1], image
            require(self.proc.poll() is None, 'native exited before ACK')
            require(time.monotonic() - self.started < self.args.timeout, 'native/controller deadline')
            time.sleep(.001)

    def shot(self, delay=5000):
        # Center parking avoids the old helper's post-save panorama edge turn.
        return self.send(f'1:move:320,60;{delay}:shot:0,0')

    def click(self, y):
        return self.send(f'1:move:319,{y};201:click:319,{y},300;701:move:320,60;10000:shot:0,0')

    def close(self, error=None):
        try:
            if self.proc.poll() is None and not self.pending:
                self.request_id += 1
                line = f'{self.request_id} finish\n'
                self.stream.write(line)
                self.stream.flush()
                os.write(self.fd, line.encode())
                self.proc.wait(timeout=20)
            require(self.proc.poll() == 0, 'native did not exit normally after finish')
            self.lines()
            self.receipt['control_summary'] = completed((self.out / 'run.log').read_text(), self.request_id, self.total)
        except (OSError, ValueError, subprocess.TimeoutExpired) as failure:
            error = error or str(failure)
            if self.proc.poll() is None:
                self.proc.terminate()
                self.proc.wait(timeout=10)
        finally:
            self.stream.close()
            self.stdout.close()
            os.close(self.fd)
            self.receipt.update(error=error, returncode=self.proc.returncode,
                observations=self.observations, requests_sha256=digest(self.out / 'requests.txt'),
                source_unchanged=digest(self.source) == self.source_hash,
                copy_unchanged=digest(self.copy) == self.source_hash,
                wall_seconds=round(time.monotonic() - self.started, 3),
                captures={f.name: digest(f) for f in sorted((self.out / 'frames').glob('*.ppm'))})
            if (self.out / 'run.log').exists():
                self.receipt['log_sha256'] = digest(self.out / 'run.log')
            write_json(self.out / 'receipt.json', self.receipt)
        require(error is None and self.receipt['source_unchanged'] and self.receipt['copy_unchanged'],
                error or 'supplied/copied source changed')


def relative_win_tail(name):
    return ';'.join(f'{int(step.split("+", 1)[1].split(":", 1)[0])-9000}:{step.split(":", 1)[1]}'
                    for step in story_route.bul_win_tail(name).split(';'))


def play(session, name):
    observation, image = session.send(story_route.load_save_prefix() + ';' + story_route.leg_bul_start())
    require(observation['state'] == [1261, 1261, 0, -1] and observation['flags'].get(1435) == 1,
            'ordinary prefix did not reach the wagered board')
    pixels = BoardPixels(ppm(image))
    for turn in range(160):
        scene = observation['state'][0]
        require(scene not in (1255, 1256, 3634), 'natural Bul loss; no retry or accepted save')
        if scene == 1259 and observation['flags'].get(1405) == 1:
            session.send(relative_win_tail(name))
            session.shot()
            return
        if scene != 1261:
            observation, image = session.shot(6000)
            continue
        try:
            board = pixels.read(ppm(image))
        except CapturePending:
            observation, image = session.shot()
            continue
        move = action(board)
        write_json(session.out / f'plan-{turn:03d}.json', dict(board, action=move,
                   capture=image.name, capture_sha256=digest(image)))
        observation, image = session.click(153 if move == 'pass' else 123)
    raise ValueError('bounded Bul observations exhausted; no accepted save')


def verify_reload(session):
    _, one, zero = check_route.passage_configuration('bul-key')
    observations = session.observations
    require(len(observations) >= 4, 'reload observations incomplete')
    for observation in observations:
        require(observation['state'][:3] == [3510, 3510, 4], 'reload safe scene/view differs')
        values = observation['flags']
        require((one | zero) <= check_route.flag_scope(observation['scope'])
                and all(values.get(f, 0) == 1 for f in one)
                and all(values.get(f, 0) == 0 for f in zero), 'reload durable/zero flag proof differs')
    require([o['state'][3] for o in observations if o['state'][3] != -1] == [7], 'reload did not select actual7')
    require(all(o['state'] == [3510, 3510, 4, -1] for o in observations[-2:]), 'reload final safe pair missing')


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('native', 'game-exe', 'game-data', 'source-save'):
        parser.add_argument('--' + name, type=Path, required=True)
    parser.add_argument('--native-sha256', required=True, help='reviewed headless binary pin')
    parser.add_argument('--save-sha256', required=True, help='supplied uncompleted m23-equivalent pin')
    parser.add_argument('--save-name', default='m24', help='new original-UI name, 1-10 lowercase letters/digits')
    parser.add_argument('--output', type=Path, help='new evidence directory; default: retained temporary directory')
    parser.add_argument('--timeout', type=int, default=300, help='per-session wall deadline, 1-300 seconds')
    args = parser.parse_args(argv)
    out, active, receipt = None, None, {'accepted': False}
    try:
        for name in ('native', 'game_exe', 'game_data', 'source_save'):
            setattr(args, name, getattr(args, name).resolve(strict=True))
        require(1 <= args.timeout <= 300, 'timeout must be 1-300 seconds')
        require(args.native_sha256 != ORIGINAL_SHA256, 'native must be a reviewed host, not the original data image')
        require(re.fullmatch('[a-z0-9]{1,10}', args.save_name) is not None, 'invalid new save name')
        require(args.source_save.name.lower() != args.save_name + '.sav', 'new save name must differ from source')
        require(digest(args.native) == args.native_sha256 and digest(args.source_save) == args.save_sha256,
                'reviewed native/source pins differ')
        require(digest(args.game_exe) == ORIGINAL_SHA256 and digest(args.game_data / 'GAME.EXE') == ORIGINAL_SHA256,
                'original data image pin differs')
        require(not (args.game_data / 'Documents5').exists(), 'game-data seed must contain no Documents5 saves')
        require(not any(p.is_symlink() for p in args.game_data.rglob('*')), 'game-data seed contains symlinks')
        state = save_state(args.source_save)
        require(state['difficulty'] in (0, 2) and [state[k] for k in ('scene', 'art', 'view', 'held')] == [4408, 4408, 0, -1]
                and all(v == 0 for v in state['progression'].values()), 'source is not an uncompleted Junior/Senior m23-equivalent')
        target = args.output.resolve() if args.output else Path(tempfile.mkdtemp(prefix='blackmoor-bul-'))
        require(not (target == args.game_data or args.game_data in target.parents or target == args.source_save.parent
                     or args.source_save.parent in target.parents), 'output must be outside supplied data/save directories')
        if args.output:
            target.mkdir(parents=True, exist_ok=False)
        out = target
        protected = {str(p): digest(p) for p in (args.native, args.game_exe, args.source_save,
                     args.game_data / 'GAME.EXE', args.game_data / 'Game.ini', args.game_data / 'Ciftree' / 'CIFTREE.DAT',
                     Path(__file__), Path(story_route.__file__), Path(check_route.__file__))}
        receipt.update(native_sha256=args.native_sha256, source_sha256=args.save_sha256, difficulty=state['difficulty'],
                       protected_inputs=protected, original_sha256=ORIGINAL_SHA256, scope='one observed ordinary-input attempt; no all-deal guarantee')
        write_json(out / 'receipt.json', receipt)
        producer = active = Session(args, out / 'producer', args.source_save)
        error = None
        try:
            play(producer, args.save_name)
        except (OSError, ValueError, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        producer.close(error)
        saved = producer.saves / (args.save_name + '.SAV')
        checked = check_route.verify((producer.out / 'run.log').read_text(), saved, 'bul-key')
        saved_state = save_state(saved)
        require(saved_state == dict(difficulty=state['difficulty'], held=-1, scene=3510, art=3510, view=4,
                                   progression={1404: 1, 1435: 1, 1405: 1}), 'original UI saved state differs')
        reload = active = Session(args, out / 'reload', saved)
        error = None
        try:
            r = story_route.R().at('S3510.CIF', 12000).clicks('shot', 0)
            r.at('S3510.CIF', 17000).clicks('212,448 280,174 shot', 5000)
            r.at('S3510.CIF', 32000).clicks('212,448 62,100 360,20 shot', 5000)
            r.at('S3510.CIF', 52000).clicks('mv:320,60', 0).gap(3000).clicks('shot', 0)
            reload.send(story_route.load_save_prefix() + ';' + r.text())
        except (OSError, ValueError, KeyboardInterrupt) as failure:
            error = str(failure) or type(failure).__name__
        reload.close(error)
        verify_reload(reload)
        require(sorted(f.name for f in reload.saves.glob('*.SAV')) == [saved.name], 'reload has additional saves')
        require(all(digest(Path(p)) == pin for p, pin in protected.items()), 'protected native/source/tool input changed')
        accepted = out / (args.save_name + '.SAV')
        require(not accepted.exists(), 'refuse accepted checkpoint overwrite')
        shutil.copy2(saved, accepted)
        receipt.update(accepted=True, result=checked, output_save_sha256=digest(accepted), output_save=str(accepted),
                       producer_receipt_sha256=digest(producer.out / 'receipt.json'), reload_receipt_sha256=digest(reload.out / 'receipt.json'))
        write_json(out / 'receipt.json', receipt)
        print(json.dumps({'accepted': True, 'receipt': str(out / 'receipt.json'), 'save_sha256': receipt['output_save_sha256']}))
        return 0
    except (OSError, ValueError, subprocess.SubprocessError, KeyboardInterrupt) as error:
        receipt.update(error=str(error) or type(error).__name__)
        if out is not None:
            write_json(out / 'receipt.json', receipt)
        print(json.dumps({'accepted': False, 'error': str(error), 'evidence': str(out) if out else None}))
        return 1
    finally:
        if active is not None and active.proc.poll() is None:
            active.proc.terminate()
            try:
                active.proc.wait(timeout=10)
            except subprocess.TimeoutExpired:
                active.proc.kill()
                active.proc.wait(timeout=10)


if __name__ == '__main__':
    raise SystemExit(main())
