"""Captured Junior typing pixels to ordinary-key proposals; no game state/rules.

Geometry and OCR data are explicit caller-pinned local inputs. No template,
resource or training payload is distributed here.
"""
import json
import math
from pathlib import Path
import re
import subprocess
import time

import bul_live as io

SLOT_COUNT = 20
WIDTH, ROW_HEIGHT = 180, 160
TSV_HEADER = 'level page_num block_num par_num line_num word_num left top width height conf text'.split()


def load_geometry(path, expected_sha256):
    io.require(io.digest(path) == expected_sha256, 'geometry SHA-256 differs')
    value = json.loads(path.read_text())
    rects = value.get('position_rects') if isinstance(value, dict) else None
    io.require(isinstance(rects, list) and len(rects) == SLOT_COUNT, 'expected20 captured-position rectangles')
    for rect in rects:
        io.require(isinstance(rect, list) and len(rect) == 4 and all(type(v) is int for v in rect), 'invalid position rectangle')
        left, top, right, bottom = rect
        cx, cy = (left + right)//2 + 10, (top + bottom)//2 + 10
        io.require(0 <= left < right <= 640 and 0 <= top < bottom <= 480
                   and 12 <= cx <= 628 and 12 <= cy <= 468, 'position crop outside capture')
    return rects


def mosaic(rgb, rects):
    io.require(len(rgb) == 640*480*3 and len(rects) == SLOT_COUNT, 'incomplete captured pixels/positions')
    height = len(rects)*ROW_HEIGHT
    pixels = bytearray([255]) * (WIDTH*height)
    # Preserve the proven24px/threshold30/5x glyph mosaic geometry exactly.
    for index, (left, top, right, bottom) in enumerate(rects):
        cx, cy = (left + right)//2 + 10, (top + bottom)//2 + 10
        for yy in range(24):
            for xx in range(24):
                x, y = cx - 12 + xx, cy - 12 + yy
                value = 0 if max(rgb[3*(y*640+x):3*(y*640+x)+3]) < 30 else 255
                for dy in range(5):
                    offset = (index*ROW_HEIGHT + 20 + 5*yy + dy)*WIDTH + 30 + 5*xx
                    pixels[offset:offset+5] = bytes([value])*5
    return f'P5\n{WIDTH} {height}\n255\n'.encode() + pixels


def parse_tsv(text):
    lines = text.splitlines()
    io.require(lines and lines[0].split('\t') == TSV_HEADER, 'unexpected OCR TSV header')
    letters = []
    for line in lines[1:]:
        fields = line.split('\t')
        if len(fields) < 12 or not fields[11].strip():
            continue
        observed = fields[11].strip()
        confidence = float(fields[10])
        fold = observed.upper()
        if (not math.isfinite(confidence) or not 45 <= confidence <= 100 or not observed.isascii()
                or not fold.isalpha() or not all('A' <= c <= 'Z' for c in fold) or len(set(fold)) != 1):
            continue
        slot = int((int(fields[7]) + int(fields[9])/2)//ROW_HEIGHT)
        if not 0 <= slot < SLOT_COUNT:
            continue
        letters.append({'slot': slot, 'observed_text': observed, 'confidence': confidence, 'vk': ord(fold[0])})
    io.require(len(letters) <= 64, 'OCR proposal count outside bounded batch')
    return letters


def key_payload(letters):
    io.require(len(letters) <= 64 and all(type(letter.get('vk')) is int and 65 <= letter['vk'] <= 90 for letter in letters),
               'only bounded ordinary Junior letter VKs are supported')
    items = ['1:move:635,385']
    t = 100
    for letter in letters:
        items.append(f"{t}:key:{letter['vk']}")
        t += 120
    items.append(f'{max(1500, t+600)}:shot:0,0')
    return ';'.join(items)


def analyse(image, out, iteration, rects, ocr_tool, ocr_data):
    started = time.perf_counter()
    pgm = Path(out) / f'ocr-{iteration:03d}.pgm'
    pgm.write_bytes(mosaic(io.ppm(image), rects))
    result = subprocess.run([str(ocr_tool), str(pgm), 'stdout', '--psm', '6',
                             '--tessdata-dir', str(ocr_data.parent), '-l', 'eng', '-c',
                             'tessedit_char_whitelist=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 'tsv'],
                            capture_output=True, text=True, timeout=5)
    io.require(result.returncode == 0, 'local pixel OCR failed: ' + result.stderr[:200])
    tsv = Path(out) / f'ocr-{iteration:03d}.tsv'
    tsv.write_text(result.stdout)
    letters = parse_tsv(result.stdout)
    record = {'capture': image.name, 'capture_sha256': io.digest(image), 'mosaic_sha256': io.digest(pgm),
              'tsv_sha256': io.digest(tsv), 'letters': letters, 'elapsed_ms': round((time.perf_counter()-started)*1000, 3),
              'limits': 'Only ordinary VK proposals from actual captured pixels; original2014/1343 proves the game passed'}
    io.write_json(Path(out) / f'plan-{iteration:03d}.json', record)
    return record
