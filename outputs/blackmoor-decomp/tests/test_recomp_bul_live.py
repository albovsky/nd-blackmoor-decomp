"""Finite synthetic pixels/protocol checks. No game, assets or native process."""
import importlib.util
from pathlib import Path
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1] / 'recomp/route_tools'
sys.path.insert(0, str(TOOLS))
import bul_live as bul
sys.path.pop(0)


def frame(player=1, computer=12, enabled=False):
    data = bytearray([32]) * (640 * 480 * 3)
    def fill(left, top, width, height, color):
        for y in range(top, top + height):
            data[(y * 640 + left) * 3:(y * 640 + left + width) * 3] = bytes(color) * width
    fill(63 + (player - 1) * 43, 163, 41, 83, (20, 40, 220))
    fill(63 + (computer - 1) * 43, 163, 41, 83, (220, 40, 20))
    if enabled:
        fill(282, 136, 74, 24, (200, 200, 200))
    return data


class BulPixelsTests(unittest.TestCase):
    def test_actual_visible_gap_and_button_select_only_legal_roll_pass(self):
        reader = bul.BoardPixels(frame())
        for player, computer, enabled, expected in ((1, 12, False, 'roll'),
                (2, 5, True, 'roll'), (2, 6, True, 'pass'),
                (6, 3, True, 'roll'), (2, 6, False, 'roll')):
            with self.subTest(player=player, computer=computer, enabled=enabled):
                board = reader.read(frame(player, computer, enabled))
                self.assertEqual((board['player'], board['computer']), (player, computer))
                self.assertEqual(bul.action(board), expected)
        self.assertEqual([i for i in range(1, 12) if bul.action({'gap': i, 'pass_enabled': True}) == 'roll'],
                         [1, 2, 3, 9, 10])

    def test_ambiguous_marker_and_transitional_button_refuse_a_move(self):
        reader = bul.BoardPixels(frame())
        duplicate = frame()
        for y in range(163, 246):
            duplicate[(y * 640 + 106) * 3:(y * 640 + 147) * 3] = bytes((20, 40, 220)) * 41
        with self.assertRaises(bul.CapturePending):
            reader.read(duplicate)
        transitional = frame()
        for y in range(136, 160):
            transitional[(y * 640 + 282) * 3:(y * 640 + 356) * 3] = bytes((33, 33, 33)) * 74
        with self.assertRaises(bul.CapturePending):
            reader.read(transitional)
        with self.assertRaisesRegex(ValueError, 'distinct'):
            bul.BoardPixels(bytes(640 * 480 * 3))

    def test_native_single_line_header_preserves_raster_boundary(self):
        with tempfile.TemporaryDirectory() as folder:
            image = Path(folder) / 'native-format.ppm'
            pixels = bytes((10, 32, 255)) + frame()[3:]
            image.write_bytes(b'P6 640 480 255\n' + pixels)
            self.assertEqual(bul.ppm(image), pixels)

    def test_closed_ppm_geometry_and_length_boundaries(self):
        with tempfile.TemporaryDirectory() as folder:
            image = Path(folder) / 'synthetic.ppm'
            for header in (b'P6 640 480 255\n', b'P6\n640 480\n255\n'):
                raw = header + frame()
                image.write_bytes(raw)
                self.assertEqual(bul.ppm(image), frame())
                for invalid in (raw[:-1], raw + b'\0',
                                raw.replace(b'640 480', b'480 640', 1),
                                raw.replace(b'255', b'254', 1),
                                raw.replace(b'P6', b'P3', 1)):
                    image.write_bytes(invalid)
                    with self.assertRaisesRegex(ValueError, 'closed 640x480'):
                        bul.ppm(image)


class BulProtocolTests(unittest.TestCase):
    def test_batch_text_prevents_request_injection_and_bounds_size(self):
        self.assertEqual(bul.batch_line(1, '1:move:320,60;5000:shot:0,0'),
                         '1 1:move:320,60;5000:shot:0,0\n')
        for request_id, payload in ((0, 'finish'), (192, 'finish'),
                (1, ''), (1, '1:shot:0,0\n2 finish'), (1, 'x' * 65537), (1, ';'.join(['x'] * 513))):
            with self.subTest(request=request_id, length=len(payload)):
                with self.assertRaises(ValueError):
                    bul.batch_line(request_id, payload)

    def test_ack_must_match_own_batch_and_cumulative_step_shot_counts(self):
        line = '  CONTROL ACK id=3 steps=4/4 shots=1 clock_ms=100 total_steps=14 total_shots=5'
        self.assertEqual(bul.ack(line, 3, 4, [10, 4])[5:], [14, 5])
        for bad in (line.replace('id=3', 'id=2'), line.replace('4/4', '3/4'),
                    line.replace('total_steps=14', 'total_steps=13'), line + ' trailing'):
            with self.assertRaises(ValueError):
                bul.ack(bad, 3, 4, [10, 4])

    def test_finish_requires_complete_empty_pending_protocol(self):
        line = ('  CONTROL SUMMARY complete=1 finish_id=4 acked=3 requests=4 '
                'steps=14/14 shots=5 bytes=100 pending=0 clock_ms=100 failed=0 reason=')
        self.assertEqual(bul.completed(line, 4, [14, 5]), line.strip())
        for bad in (line.replace('pending=0', 'pending=1'), line.replace('failed=0', 'failed=1'),
                    line.replace('complete=1', 'complete=0'), line.replace('14/14', '13/14'), line + '\n' + line):
            with self.assertRaises(ValueError):
                bul.completed(bad, 4, [14, 5])


if __name__ == '__main__':
    unittest.main()
