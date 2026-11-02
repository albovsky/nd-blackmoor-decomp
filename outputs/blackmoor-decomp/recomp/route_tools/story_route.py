#!/usr/bin/env python3
"""The story routes of ROUTES.md as INPUT strings for rc_headless.

  python3 story_route.py LEG [--save NAME]      LEG is one of: stairs, lock, slider, moon, telescope-prep, linda, jane-intro, jane-jigsaw, telescope-use, seedlings, crank-repair, slider-verify
  python3 story_route.py slider-verify          replays the recorded 105 slider moves on the puzzle rules and prints whether they solve it

Each leg starts from a save made in the game's own Load & Save screen and (with --save NAME) ends by saving the next one, so the legs chain:

  m0 (bedroom, right after the suitcase; see ROUTES.md)  --stairs-->  m1 (S3397, the stair lock open, key 17 taken)
  m1  --lock-->   m4 (S3447, behind the S3448 lock: key, order, delivery, butter, grease, unlock)
  m4  --slider--> m5 (S3303, the slider puzzle solved and the item taken)
  m5  --moon-->   m6 (S2076, the moon box open, the telescope lens)
  m6  --telescope-prep--> m7 (lens collected, star chart read, bedroom view 2)
  m7  --linda--> m8 (Linda introduction complete, S4408)
  m8  --jane-intro--> S1206 (optional Memory branch, no save tail)
  m8  --jane-jigsaw--> m9 (Junior jigsaw won, telescope loan earned, S3510 view 4)
  m9  --telescope-use--> m10 (delivery, Petrov call, filtered telescope, bedroom view 19)
  m10 --seedlings--> m11 (S2347, seedlings packed; crank not yet collected)
  m11 --crank-repair--> m12 (Drake's crank reward, Betty repaired, keypad visited, safe S2701)

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

    def turns(self, direction, count):
        """One panorama frame per short edge hover, with AutoMove enabled.

        A normal click's one-second pre-hover pans several frames. Moving back
        inside after 100 ms keeps each turn below the game's 400 ms repeat.
        """
        x = {'left': 10, 'right': 620}[direction]
        for _ in range(count):
            self.o.append('%s+%d:move:%d,200' % (self.a, self.t, x))
            self.o.append('%s+%d:move:320,60' % (self.a, self.t + 100))
            self.t += 2500
        return self


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


def leg_telescope_prep(save=None):
    """m6 -> m7: collect the lens, inspect the empty tripod and read the chart.

    This does not install the telescope: Jane must lend it first (1980),
    followed by delivery flags 2037/2036. Telescope completion is flag 1906.
    """
    r = R().at('S2076.CIF', 8000)
    r.clicks('310,352 326,177 310,352 310,352 310,352', 8000)
    # The moon-box return enters bedroom frame 8. Eight single right turns
    # reach frame 0; the tripod's return explicitly selects frame 19.
    r.turns('right', 8).clicks('shot 528,272 shot 310,352 48,157', 8000)
    r.clicks('303,182 337,164 559,188 559,188 559,188 shot', 8000)
    # The last chart page pops straight to S2015, then back to bedroom frame 2.
    r.clicks('310,352 310,352 shot', 8000)
    out = [r.text()]
    if save:
        out.append(menu_to_save_screen(r.a, r.t + 5000))
        out.append(save_tail(r.a, r.t + 18000, save))
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


def leg_linda(save=None):
    """m7 bedroom view2 -> Linda's introduction, flag1570, S4408 / m8."""
    r = R().at('S2010.CIF', 8000).turns('left', 6)
    r.clicks('64,171 317,167 277,175 317,162 336,162 317,162 473,161 128,162', 6000)
    r.gap(10000).clicks('292,189 292,162', 8000)
    r2 = R().at('S4405.CIF', 8000).clicks('72,165 316,180 391,170 276,166', 8000)
    r3 = R().at('S1137.CIF', 50000).clicks('150,433,300', 6000)
    r4 = R().at('S1136.CIF', 40000).clicks('150,433,300', 6000)
    out = [r.text(), r2.text(), r3.text(), r4.text(), 'S1107.CIF+50000:shot:0,0']
    if save:
        out.append(menu_to_save_screen('S1107.CIF', 60000))
        out.append(save_tail('S1107.CIF', 75000, save))
    return ';'.join(out)


def walk_to_jane():
    """m8/S4408 -> Jane's first greeting, using the verified hall views."""
    r = R().at('S4408.CIF', 8000).clicks('310,354 310,354', 8000).turns('left', 8)
    r.clicks('290,195 312,163 415,163 325,161 325,161 219,163 481,219 308,193 292,162 306,173', 8000)
    return r.text()


def leg_jane_intro(save=None):
    """m8 -> Jane's first conversation and S1206 Memory; no puzzle solve yet."""
    if save:
        raise ValueError('jane-intro ends inside Memory; save after completing the puzzle')
    r2 = R().at('S1200.CIF', 50000).clicks('150,446,300', 6000)
    return ';'.join([walk_to_jane(), r2.text(), 'S1206.CIF+8000:shot:0,0'])


def leg_jane_jigsaw(save=None):
    """Junior m8 -> Jane's authored story replies, timed jigsaw win, room/m9.

    Memory remains a separate optional branch. These picks apply to the first
    S3575 layout, with the normal 10,10 viewport and unrotated Junior pieces.
    """
    out = [walk_to_jane()]
    for scene, y in ((1200, 466), (1222, 446), (1225, 446), (1228, 433)):
        out.append(R().at('S%d.CIF' % scene, 40000).clicks('150,%d,100' % y, 6000).text())
    out += ['S1289.CIF+40000:shot:0,0',
            R().at('S1289.CIF', 42000).clicks('312,233,100', 6000).text(),
            'S1289.CIF+60000:shot:0,0',
            R().at('S1289.CIF', 62000).clicks('150,452,100', 6000).text(),
            'S1273.CIF+30000:shot:0,0',
            R().at('S1273.CIF', 32000).clicks('322,154,100', 6000).text(),
            'S3575.CIF+1500:shot:0,0']
    # Pick ties favor the lowest remaining layer-0 index. Successful snaps
    # remove each piece from the unplaced candidates. Drops include the
    # viewport translation and the genuine cursor rectangle's centre offset.
    picks_drops = [
        ((404, 73), (170, 53)), ((308, 64), (246, 55)),
        ((224, 113), (321, 52)), ((260, 128), (396, 55)),
        ((353, 99), (460, 50)), ((179, 94), (464, 103)),
        ((351, 235), (393, 103)), ((373, 164), (320, 104)),
        ((357, 175), (247, 104)), ((262, 194), (166, 105)),
        ((318, 61), (171, 163)), ((304, 147), (244, 161)),
        ((217, 228), (320, 161)), ((191, 128), (392, 159)),
        ((526, 157), (459, 158)), ((339, 135), (462, 207)),
        ((289, 210), (396, 214)), ((269, 103), (317, 211)),
        ((237, 190), (243, 217)), ((238, 105), (165, 211)),
    ]
    puzzle = R().at('S3575.CIF', 8000)
    for pick, drop in picks_drops:
        for x, y in (pick, drop):
            puzzle.clicks('%d,%d,100' % (x, y), 2500)
    out += [puzzle.text(), 'S3575.CIF+118000:shot:0,0',
            'S1234.CIF+40000:shot:0,0']
    # The post-win Bye is below the text viewport. Drag the original UICO
    # thumb gradually while held, then release before choosing the last reply.
    out.append(R().at('S1234.CIF', 42000).clicks('22,405,6000', 6000).text())
    out += ['S1234.CIF+%d:move:22,%d' % (43300 + i * 300, y)
            for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 456))]
    out += ['S1234.CIF+51000:shot:0,0',
            R().at('S1234.CIF', 53000).clicks('150,430,100', 6000).text(),
            'S1234.CIF+70000:shot:0,0']
    if save:
        out += [menu_to_save_screen('S1234.CIF', 80000),
                save_tail('S1234.CIF', 95000, save)]
    return ';'.join(out)


def leg_telescope_use(save=None):
    """m9 -> telescope delivery, Petrov's call, filtered view and room/m10.

    Uses the observed no-Ethel branch and first incoming Petrov call. Stops at
    unopened anchors if those story conditions differ; it does not force them.
    """
    r = R().at('S3510.CIF', 8000).turns('left', 6)
    r.clicks('290,195 312,182', 8000)
    out = [r.text(), 'S3507.CIF+8000:shot:0,0',
           R().at('S3507.CIF', 12000).clicks('234,171', 8000).text(),
           R().at('S3303.CIF', 8000).clicks('317,162 309,352 298,162 294,162 304,162', 8000).text(),
           R().at('S1601.CIF', 50000).clicks('150,414,300', 6000).text(),
           R().at('S1602.CIF', 50000).clicks('150,440,300', 6000).text(),
           'S1605.CIF+50000:shot:0,0',
           R().at('S1605.CIF', 52000).clicks('22,405,6000', 6000).text()]
    out += ['S1605.CIF+%d:move:22,%d' % (53300 + i * 300, y)
            for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 456))]
    out += ['S1605.CIF+61000:shot:0,0',
            R().at('S1605.CIF', 63000).clicks('150,430,100', 6000).text()]
    # 6310 already closes the phone and restores 3308. An extra click on its
    # former X would hit the hallway exit, putting the remaining route ahead.
    room = R().at('S6310.CIF', 23000).clicks('532,161 292,189 292,162 353,173', 8000)
    room.turns('right', 1).clicks('528,272 302,161 212,448 62,100', 8000)
    out += [room.text(), 'S6310.CIF+87000:shot:0,0']
    view = R().at('S6310.CIF', 89500).clicks('365,223 305,130', 8000)
    view.clicks('shot 310,354 310,354 310,354 shot', 8000)
    out.append(view.text())
    if save:
        out += [menu_to_save_screen('S6310.CIF', 150500),
                save_tail('S6310.CIF', 163500, save)]
    return ';'.join(out)


def leg_seedlings(save=None):
    """m10 -> Betty, Drake's seedling errand, zero-rotation packing and m11.

    Uses the exercised first dialogue choices and ordinary pointer placements.
    Crank collection/installation follows later; this stops safely in S2347.
    """
    walk = R().at('S2010.CIF', 8000).turns('left', 9)
    walk.clicks('64,171 317,167 277,175 317,162 336,162 317,162 473,161 '
                '327,162 317,162 532,161 328,162 328,162 562,161', 8000)
    walk.at('S2605.CIF', 8000).turns('left', 2)
    walk.clicks('230,148 66,166 313,133 312,270', 8000)
    out = [walk.text(), 'S2708.CIF+20000:shot:0,0']
    out.append(R().at('S2708.CIF', 25000).clicks('310,354', 9000).clicks(
        '576,161 584,161 298,160 570,161 310,160 '
        '315,145 269,161 380,163 310,192 312,168 307,160', 8000).text())
    drake = R().at('S2300.CIF', 8000).turns('right', 5)
    drake.clicks('334,222 210,184 234,183 217,204 '
                 + '315,191 ' * 7
                 + '47,157 81,179 352,183 489,169 327,234', 8000)
    out += [drake.text(), 'S1000.CIF+50000:shot:0,0',
            R().at('S1008.CIF', 50000).clicks('150,448,300', 6000).text()]
    for scene, y in ((1010, 433), (1002, 448), (1007, 460), (1055, 448)):
        anchor = 'S%d.CIF' % scene
        out += [anchor + '+50000:shot:0,0',
                R().at(anchor, 60000).clicks('150,%d,300' % y, 6000).text()]
    out.append('S2347.CIF+30000:shot:0,0')
    # 1085 opens 2347, which automatically opens 2348. This now-empty-area
    # click did not enter the puzzle; retain its exercised timing unchanged.
    out.append(R().at('S2347.CIF', 40000).clicks('306,194,300', 6000).text())
    picks_drops = [
        ((540, 61), (84, 83)), ((536, 151), (174, 63)),
        ((427, 42), (244, 63)), ((427, 121), (184, 133)),
        ((331, 286), (254, 143)), ((510, 229), (54, 173)),
        ((333, 151), (104, 153)), ((330, 205), (94, 193)),
        ((565, 209), (134, 193)), ((415, 295), (194, 213)),
        ((496, 306), (254, 223)), ((337, 66), (64, 263)),
        ((568, 287), (124, 263)), ((419, 213), (214, 283)),
    ]
    puzzle = R().at('S2348.CIF', 8000)
    for pick, drop in picks_drops:
        t = puzzle.t
        puzzle.clicks('%d,%d,300' % pick, 16000)
        # Preserve both exercised drop hovers and the 2 s gap before click.
        puzzle.o += ['S2348.CIF+%d:move:%d,%d' % (t + offset, *drop)
                     for offset in (5000, 6000)]
        puzzle.o.append('S2348.CIF+%d:click:%d,%d,300' % (t + 8000, *drop))
    out += [puzzle.text(), 'S2348.CIF+228000:shot:0,0']
    if save:
        # Anchor to puzzle entry, since 2347 was also seen before the win.
        out += [menu_to_save_screen('S2348.CIF', 250000),
                save_tail('S2348.CIF', 268000, save)]
    return ';'.join(out)


def leg_crank_repair(save=None):
    """m11 -> m12. Let the original clock reach morning, claim crank20,
    repair Betty with the held item, visit the keypad, and return to S2701.

    The accepted m11 starts at 22:22. Preserve the ordinary overnight wait;
    these mouse events never set the game's clock or story state. The card
    game and its Venus-key reward remain beyond this checkpoint.
    """
    r = R().at('S2347.CIF', 7000).clicks('shot', 0)
    for wait_slot in range(1, 10):
        x = 110 if wait_slot % 2 else 100
        r.at('S2347.CIF', wait_slot * 1000000).clicks('mv:%d,300' % x, 0)
    r.at('S2347.CIF', 9949000).clicks('shot', 0)
    r.at('S2347.CIF', 10008000).clicks('310,354 310,354 91,180 312,182 310,182', 8000)
    r.turns('right', 7).clicks('381,199 426,188' + ' 318,158' * 8 + ' 403,197 419,191 291,184', 8000)
    r.turns('left', 1).clicks('253,160 310,164 295,156 310,354 310,192 312,168 307,160', 8000)
    # Leave and reenter through the authored daytime housekeeping scene.
    conservatory = R().at('S2399.CIF', 8000).clicks('shot', 0)
    conservatory.at('S2399.CIF', 11000).turns('right', 5)
    conservatory.clicks('334,222 210,184 234,183 217,204' + ' 315,191' * 7 +
                       ' 47,157 81,179 352,183 489,169 327,234', 8000)
    out = [r.text(), conservatory.text()]
    # Claim the seedlings reward, then say goodbye, using the original caption
    # slider. Each click holds while the subsequent moves drag its thumb down.
    for anchor, reply_y in (('S1000.CIF', 418), ('S1089.CIF', 430)):
        out.append(R().at(anchor, 49000).clicks('shot', 0)
                   .at(anchor, 60000).clicks('22,405,6000', 0).text())
        out += ['%s+%d:move:22,%d' % (anchor, 61500 + i * 500, y)
                for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 456))]
        out.append(R().at(anchor, 71000).clicks('shot', 0)
                   .at(anchor, 80000).clicks('150,%d,300' % reply_y, 0).text())
    repair = R().at('S1089.CIF', 99000).clicks('shot', 0)
    repair.at('S1089.CIF', 120000).clicks('310,354 91,180 312,182 310,182', 8000)
    repair.turns('right', 7).clicks('381,199 426,188' + ' 318,158' * 8 + ' 403,197 419,191 291,184', 8000)
    repair.turns('left', 1).clicks('253,160 310,164 295,156 312,163 380,146', 8000)
    repair.turns('left', 1).clicks('230,148 66,166 308,302', 8000)
    repair.clicks('shot 212,448', 8000)
    repair.at('S1089.CIF', 358500).clicks('shot', 0)
    repair.at('S1089.CIF', 367500).clicks('62,100', 0)
    repair.at('S1089.CIF', 375500).clicks('shot', 0)
    repair.at('S1089.CIF', 383500).clicks('311,127', 0)
    out += [repair.text(),
            R().at('S2713.CIF', 7000).clicks('shot', 0)
            .at('S2713.CIF', 18000).clicks('310,40,300', 0).text(),
            R().at('S2701.CIF', 8000).clicks('312,270,300', 0).text(),
            R().at('S2702.CIF', 15000).clicks('shot', 0)
            .at('S2702.CIF', 24000).clicks('135,354,300', 0).text()]
    if save:
        out += [menu_to_save_screen('S2702.CIF', 32000),
                save_tail('S2702.CIF', 50000, save)]
    return ';'.join(out)


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
    legs = {'stairs': leg_stairs, 'lock': leg_lock, 'slider': leg_slider,
            'moon': leg_moon, 'telescope-prep': leg_telescope_prep,
            'linda': leg_linda, 'jane-intro': leg_jane_intro,
            'jane-jigsaw': leg_jane_jigsaw, 'telescope-use': leg_telescope_use,
            'seedlings': leg_seedlings, 'crank-repair': leg_crank_repair}
    if leg not in legs:
        sys.exit(__doc__)
    print(legs[leg](save))
