#!/usr/bin/env python3
"""The story routes of ROUTES.md as INPUT strings for rc_headless.

  python3 story_route.py LEG [--save NAME]      LEG is one of: stairs, lock, slider, moon, slider-verify
  python3 story_route.py slider-verify          replays the recorded 105 slider moves on the puzzle rules and prints whether they solve it

Each leg starts from a save made in the game's own Load & Save screen and (with --save NAME) ends by saving the next one, so the legs chain:

  m0 (bedroom, right after the suitcase; see ROUTES.md)  --stairs-->  m1 (S3397, the stair lock open, key 17 taken)
  m1  --lock-->   m4 (S3447, behind the S3448 lock: key, order, delivery, butter, grease, unlock)
  m4  --slider--> m5 (S3303, the slider puzzle solved and the item taken)
  m5  --moon-->   m6 (S2076, the moon box open, the telescope lens)

Steps are `anchor+ms:kind:args` (rc_headless.c). `click x,y,hold` is a move 1 s before the click; `mv:x,y` a bare move; `key:VK` a key press.
A bare click on a hotspot needs a move onto it first or the game ignores it (the cursor must have been seen there), so every click has its move.
All coordinates are positions on the 640x480 screen as the game receives them. Nothing here contains game data."""
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


class R:
    """Builds a list of steps; `at` sets the anchor file and the offset of the next slot, `clicks` lays tokens out `spacing` ms apart."""

    def __init__(self):
        self.o = []
        self.a = None
        self.t = 0

    def at(self, anchor, t):
        self.a, self.t = anchor, t
        return self

    def gap(self, ms):
        self.t += ms
        return self

    def clicks(self, toks, spacing):
        for tok in toks.split():
            if tok == 'shot':
                self.o.append('%s+%d:shot:0,0' % (self.a, self.t + 1000))
            elif tok == 'wait':
                pass
            elif tok.startswith('mv:'):
                self.o.append('%s+%d:move:%s' % (self.a, self.t, tok[3:]))
            elif tok.startswith('key:'):
                self.o.append('%s+%d:key:%s' % (self.a, self.t, tok[4:]))
            else:
                p = tok.split(',')
                hold = p[2] if len(p) > 2 else '600'
                self.o.append('%s+%d:move:%s,%s' % (self.a, self.t, p[0], p[1]))
                self.o.append('%s+%d:click:%s,%s,%s' % (self.a, self.t + 1000, p[0], p[1], hold))
            self.t += spacing
        return self

    def text(self):
        return ';'.join(self.o)


def save_tail(anchor, t, name):
    """From an open Load & Save screen: click the name box, clear it, type NAME (lower case letters and digits), click SAVE."""
    o = ['%s+%d:move:280,41' % (anchor, t), '%s+%d:click:280,41,300' % (anchor, t + 1000)]
    t += 2000
    for _ in range(10):
        o.append('%s+%d:key:8' % (anchor, t))
        t += 300
    for ch in name:
        o.append('%s+%d:key:%d' % (anchor, t, ord(ch.upper())))
        t += 400
    o += ['%s+%d:move:550,40' % (anchor, t + 500), '%s+%d:click:550,40,800' % (anchor, t + 1500), '%s+%d:shot:0,0' % (anchor, t + 5500)]
    return ';'.join(o)


def menu_to_save_screen(anchor, t):
    """Taskbar MENU, then Load & Save; the screen is up 6 s after the second click."""
    return ';'.join(['%s+%d:move:75,448' % (anchor, t), '%s+%d:click:75,448,1000' % (anchor, t + 1000),
                     '%s+%d:move:275,95' % (anchor, t + 5000), '%s+%d:click:275,95,1000' % (anchor, t + 6000)])


def leg_stairs(save=None):
    """m0 -> m1. Turn to the carved door, library nook, door, upstairs hall, stairs, then the S3395 piano (keys 1,0,3,2,0,3,4,4 of seven at y 250), S3397, S3398 key 17."""
    r = R().at('S2010.CIF', 8000).clicks('10,200,150 10,200,150 10,200,150 303,170 20,170 317,167 277,175 317,162 67,161 307,161 406,160'
                                         ' 393,161 393,161 393,161 393,161 393,161 393,161 393,161 393,161 393,161 357,188', 6000)
    xs = [47, 131, 222, 319, 414, 509, 592]
    r.at('S2010.CIF', 144000).clicks(' '.join('%d,250,300' % xs[k] for k in (1, 0, 3, 2, 0, 3, 4, 4)), 5000)
    r.at('S2010.CIF', 204000).clicks('314,108 284,204', 6000)
    out = [r.text()]
    if save:
        out.append(menu_to_save_screen('S2010.CIF', 222000))
        out.append(save_tail('S2010.CIF', 262000, save))
    return ';'.join(out)


def leg_lock(save=None):
    """m1 -> m4. From S3397 down the hall to the S3448 lock (key 17 shows the lock is stuck), back to the bedroom, the intercom order (bread and butter),
    out through S3350/S4400 (the delivery flag), the tray (S2107, S2113 butter 25), back to the lock: grease it, turn the key, S3449, S3447."""
    pre = R().at('S3397.CIF', 8000).clicks('309,352 309,352' + ' 322,172' * 8 + ' 267,163 361,162 138,160 166,209 583,221', 6000)
    lock = R().at('S3448.CIF', 6000).clicks('328,214 212,448 67,113 328,214 wait 212,448 67,113 365,25 309,352 45,188 294,162 304,162 532,161 292,189 292,162 353,173', 6000)
    turn = '10,200,150 mv:320,60 ' * 4
    r = R().at('S2010.CIF', 8000).clicks(turn, 3500)
    r.clicks('405,262 405,199 201,208 307,100', 6000)       # the phone in view 17, S2013, S2020, S2098 -> S1800
    conv = ('S1807.CIF+10000:move:150,433;S1807.CIF+11000:click:150,433,300;S1820.CIF+10000:move:100,421;S1820.CIF+11000:click:100,421,300')
    r2 = R().at('S1821.CIF', 14000).clicks('320,352 320,352 320,352', 6000)
    r2.clicks('10,200,150 mv:320,60 ' * 6, 3500)
    r2.clicks('303,170 317,167 277,175 317,162 336,162 317,162 473,161 128,162', 6000)
    r2.gap(10000).clicks('292,189 292,162', 8000)
    r3 = R().at('S4405.CIF', 8000).clicks('310,354 312,163 415,163 325,161 325,161 219,163 298,162 294,162 304,162 532,161 292,189 292,162 wait', 6000)
    r3.gap(6000).clicks('310,239', 8000)
    r3.clicks('461,215', 12000).clicks('461,215', 12000).clicks('309,310', 14000).clicks('316,209 310,347 310,354 310,354', 8000)
    r3.clicks('10,200,150 mv:320,60 ' * 6, 3500)
    r3.clicks('303,170 317,167 277,175 317,162 176,219 593,231', 6000)
    # butter on the lock (hover first, then click), put it away, take the key, turn it
    r3.gap(4000).clicks('212,448', 6000).clicks('62,100', 6000).clicks('mv:300,190 mv:320,205 320,205,300 wait', 3000).gap(8000).clicks('318,204 wait', 8000)
    r3.gap(12000).clicks('wait 212,448 62,100 62,100', 4000).gap(8000).clicks('mv:300,190 mv:320,205 320,205,300 wait', 3000).gap(8000).clicks('318,204 wait', 8000).gap(14000).clicks('wait', 6000)
    out = [pre.text(), lock.text(), r.text(), conv, r2.text(), r3.text()]
    if save:
        out.append(menu_to_save_screen('S3447.CIF', 8000))
        out.append(save_tail('S3447.CIF', 20000, save))
    return ';'.join(out)


def leg_moon(save=None):
    """m5 -> m6. Back down the hall to the bedroom, the library nook S2011, the moon box S2038. Each of its five faces is a moon-phase dial: a click on the lever
    on the right steps the colour (blue, red, green), a click on the knob at the top left steps the phase (first quarter, waxing gibbous, full, waning gibbous,
    last quarter, waning crescent, new, waxing crescent). The box opens (S2075, the telescope lens) when the dials of its scene scripts read 12 (DRACO), 18 (LEPUS),
    13 (LEO), 3 (PISCES) and 0, 8 or 16 (LYNX), i.e. value = colour * 8 + phase (colours 0 blue, 1 red, 2 green; phases 0 new, 1 waxing crescent, 2 first
    quarter, 3 waxing gibbous, 4 full, 5 waning gibbous, 6 last quarter, 7 waning crescent): red full moon, green first quarter, red waning gibbous, blue
    waxing gibbous and a new moon. The faces start at blue first quarter (DRACO), blue waxing gibbous (LYNX), red full (LEO), red first quarter (LEPUS) and green
    waning gibbous (PISCES), so the clicks below are (lever, knob) per face. The cube turns with a click on its right edge: A (DRACO | LYNX), D (LYNX | LEPUS),
    C (LEPUS | PISCES), B (PISCES | DRACO); LEO is the top face in every view."""
    pre = R().at('S3303.CIF', 8000).clicks('309,352 294,162 304,162 532,161 292,189 292,162 353,173', 6000).gap(6000)
    r2 = R().at('S2010.CIF', 8000).clicks('10,200,150 mv:320,60', 3500).clicks('mv:500,170 mv:518,180 518,180', 5000)
    r2.clicks('mv:330,265 mv:338,272 338,272', 8000).clicks('wait', 6000).clicks('mv:250,215 mv:255,223 255,223', 8000).clicks('wait', 6000)
    r2.clicks('mv:300,160 mv:314,172 314,172', 8000).clicks('wait', 8000)
    r = R().at('S2047.CIF', 14000)

    def setface(lever, knob):
        toks = ''
        if lever:
            toks += 'mv:436,150 ' + ' '.join(['436,150,200'] * lever) + ' '
        if knob:
            toks += 'mv:182,70 ' + ' '.join(['182,70,200'] * knob) + ' '
        r.clicks(toks + 'wait wait', 3000)

    def leave():
        r.gap(3000).clicks('mv:300,352 310,352,300 mv:300,352 310,352,300', 7000)

    def enter(x, y):
        r.clicks('mv:%d,%d %d,%d,300' % (x - 8, y - 8, x, y), 9000)       # the face on the cube
        r.clicks('mv:300,160 314,172,300', 9000)                           # its plate

    setface(1, 2); leave()                       # DRACO: red full (12)
    enter(376, 221); setface(0, 5); leave()      # LYNX: a new moon
    enter(322, 65); setface(0, 1); leave()       # LEO: red waning gibbous (13)
    r.clicks('mv:520,160 529,165,300', 9000)     # D
    enter(376, 221); setface(1, 0); leave()      # LEPUS: green first quarter (18)
    r.clicks('mv:520,160 529,165,300', 9000)     # C
    enter(376, 221); setface(1, 6); leave()      # PISCES: blue waxing gibbous (3); the box opens
    r.gap(12000).clicks('wait', 6000)
    # S2075 ("Wonder what this is?"), S2076 (the lens and where it goes): a click each
    r3 = R().at('S2075.CIF', 8000).clicks('mv:300,190 320,200,300 wait', 8000).gap(8000).clicks('mv:300,190 320,200,300 wait', 8000)
    out = [pre.text(), r2.text(), r.text(), r3.text()]
    if save:
        out.append(menu_to_save_screen('S2075.CIF', 40000))
        out.append(save_tail('S2075.CIF', 54000, save))
    return ';'.join(out)


def slider_moves():
    """The recorded 105 moves: (piece, direction 16 left, 17 up, 18 down, 19 right, x, y). x, y are the zone centres of the native port's frame, whose
    view origin is (10, 10); the game itself takes (x - 10, y - 10)."""
    out = []
    for ln in (HERE / 'slider3450_moves.txt').read_text().splitlines():
        if ln.strip() and not ln.startswith('#'):
            k, piece, d, x, y = ln.split()
            out.append((int(piece), int(d), int(x), int(y)))
    return out


def leg_slider(save=None, gap=5000):
    """m4 -> m5. S3447 stairs hotspot, the slider puzzle S3450 (105 moves), the compartment S3452/S3453 item, the cancel strip at S3455, S3457, S3303."""
    r = R().at('S3447.CIF', 8000).clicks('mv:230,150 mv:241,166 241,166,300', 3000)
    r2 = R().at('S3450.CIF', 8000).clicks('wait', 3000)
    for piece, d, x, y in slider_moves():
        x, y = x - 10, y - 10
        r2.clicks('mv:%d,%d mv:%d,%d' % (x - 3, y - 3, x, y), 400)
        r2.clicks('%d,%d,200' % (x, y), gap)
        r2.gap(1500)
    r3 = R().at('S3452.CIF', 8000).clicks('mv:300,210 mv:310,216 310,216,300', 3000)
    r4 = R().at('S3453.CIF', 8000).clicks('mv:310,180 mv:318,191 318,191,300 wait', 8000).gap(6000).clicks('mv:300,350 mv:310,352 310,352,300', 4000).gap(16000).clicks('wait', 10000).gap(20000).clicks('wait', 6000)
    r5 = R().at('S3455.CIF', 8000).clicks('mv:300,350 mv:310,352 310,352,300', 3000).gap(20000).clicks('wait', 10000).gap(20000).clicks('wait', 6000)
    out = [r.text(), r2.text(), r3.text(), r4.text(), r5.text()]
    if save:
        out.append(menu_to_save_screen('S3303.CIF', 8000))
        out.append(save_tail('S3303.CIF', 20000, save))
    return ';'.join(out)


def verify_slider():
    """The puzzle rules of the body of S3450 (action_family_d3_runtime.c): five rows by six columns; types 0x10..0x13 are one-way edge arrows, 0x14 walls,
    1..10 the cell a piece of that number must rest on. A piece slides until a barrier or another piece stops it."""
    L, U, D, Rg, W = 0x10, 0x11, 0x12, 0x13, 0x14
    t = [[0x10, 0x11, 0x11, 0x11, 0x11, 0x13], [0x10, 0x14, 0x14, 0x14, 0x14, 0x13], [6, 10, 1, 8, 9, 5], [4, 0x14, 0x14, 0x14, 0x14, 7], [3, 0x14, 0x14, 0x14, 0x14, 2]]
    pos = {1: (4, 0), 2: (3, 0), 3: (2, 0), 4: (2, 1), 5: (2, 2), 6: (2, 3), 7: (2, 4), 8: (2, 5), 9: (3, 5), 10: (4, 5)}
    occ = {p: k for k, p in pos.items()}

    def can(a, b, d):
        if d == L:
            return b > 0 and t[a][b] != L and t[a][b - 1] != Rg and (a, b - 1) not in occ and t[a][b - 1] != W
        if d == U:
            return a > 0 and t[a][b] != U and t[a - 1][b] != D and (a - 1, b) not in occ and t[a - 1][b] != W
        if d == D:
            return a < 4 and t[a][b] != D and t[a + 1][b] != U and (a + 1, b) not in occ and t[a + 1][b] != W
        return b < 5 and t[a][b] != Rg and t[a][b + 1] != L and (a, b + 1) not in occ and t[a][b + 1] != W

    for piece, d, x, y in slider_moves():
        a, b = pos[piece]
        if not can(a, b, d):
            return False
        while can(a, b, d):
            del occ[(a, b)]
            a, b = (a, b - 1) if d == L else (a, b + 1) if d == Rg else (a - 1, b) if d == U else (a + 1, b)
            occ[(a, b)] = piece
        pos[piece] = (a, b)
    return all(t[a][b] == p for p, (a, b) in pos.items())


if __name__ == '__main__':
    leg = sys.argv[1] if len(sys.argv) > 1 else ''
    save = sys.argv[sys.argv.index('--save') + 1] if '--save' in sys.argv else None
    if leg == 'slider-verify':
        ok = verify_slider()
        print('the recorded 105 slider moves %s the puzzle' % ('solve' if ok else 'do NOT solve'))
        sys.exit(0 if ok else 1)
    legs = {'stairs': leg_stairs, 'lock': leg_lock, 'slider': leg_slider, 'moon': leg_moon}
    if leg not in legs:
        sys.exit(__doc__)
    print(legs[leg](save))
