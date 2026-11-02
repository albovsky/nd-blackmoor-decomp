"""Captured-pixel Memory bookkeeping; no guest deck, RNG, timer or save access.

No image/template/asset bytes ship. Exact face equality is a capture heuristic
requiring actual runtime calibration; ambiguous/missed captures are refused.
The original game alone decides matches, attempts, completion and rewards.
"""
import hashlib
from collections import defaultdict
from bul_live import crop, require

RAW_LEFT = (13, 114, 214, 315, 415, 516)
RAW_TOP = (11, 101, 191, 281)
POINT_X = (58, 159, 259, 360, 460, 561)
POINT_Y = (51, 141, 231, 321)
INSET = 8
WIDTH, HEIGHT = 73, 63
MIN_CHANGED_PIXELS = 32


def point(index):
    require(type(index) is int and 0 <= index < 24, 'invalid card index')
    return POINT_X[index % 6], POINT_Y[index // 6]


def face(data, index):
    point(index)
    require(len(data) == 640 * 480 * 3, 'incomplete framebuffer')
    # Rendering adds10,10; these are crop coordinates, not click coordinates.
    return crop(data, RAW_LEFT[index % 6] + 10 + INSET,
                RAW_TOP[index // 6] + 10 + INSET, WIDTH, HEIGHT)


def changed(a, b):
    require(len(a) == len(b), 'crop length differs')
    return sum(a[i:i+3] != b[i:i+3] for i in range(0, len(a), 3))


class FaceMemory:
    def __init__(self, initial):
        self.backs = [face(initial, i) for i in range(24)]
        self.labels = {}
        self.matched = set()
        self.attempts = 0

    def reveal(self, data, index):
        pixels = face(data, index)
        require(changed(pixels, self.backs[index]) >= MIN_CHANGED_PIXELS,
                'card is hidden or capture did not expose enough stable pixels')
        label = hashlib.sha256(pixels).hexdigest()
        require(index not in self.labels or self.labels[index] == label,
                'same exposed card changed identity; capture ambiguous')
        require(sum(v == label for k,v in self.labels.items() if k != index) < 2,
                'more than two cards have an identical face; refuse ambiguous classification')
        self.labels[index] = label
        return label

    def pair(self, first, second, data):
        require(first != second and first not in self.matched and second not in self.matched,
                'same/already matched card cannot form a new attempt')
        a = self.reveal(data, first)
        b = self.reveal(data, second)
        self.attempts += 1
        require(self.attempts <= 24, 'bounded capture strategy exhausted')
        same = a == b
        if same:
            self.matched.update((first, second))
        return same

    def settled(self, data, first, second, same):
        if same:
            require(self.reveal(data, first) == self.reveal(data, second),
                    'predicted match did not remain visibly face-up')
        else:
            require(face(data, first) == self.backs[first] and face(data, second) == self.backs[second],
                    'mismatch did not visibly return to its captured backs')

    def recalled_pairs(self):
        require(len(self.labels) == 24, 'not every card was observed')
        groups = defaultdict(list)
        for index, label in self.labels.items():
            groups[label].append(index)
        require(len(groups) == 12 and all(len(v) == 2 for v in groups.values()),
                'captured identities are not12 unambiguous pairs')
        return [tuple(sorted(v)) for v in groups.values() if not set(v) <= self.matched]


def flip_payload(index):
    x, y = point(index)
    # Release at181ms, park at201ms, captures at251/451ms: second face is retained
    # before the original600ms mismatch deadline. No clock changes or pauses.
    return f'1:move:{x},{y};101:click:{x},{y},80;201:move:635,385;251:shot:0,0;451:shot:0,0'


def settle_payload():
    # Strictly beyond600ms, with normal guest scheduling continuing.
    return '1:move:635,385;1001:shot:0,0'
