#!/usr/bin/env python3
"""The story routes of ROUTES.md as INPUT strings for rc_headless.

  python3 story_route.py LEG [--save NAME]      LEG is one of: stairs, lock, slider, moon, telescope-prep, linda, jane-intro, jane-jigsaw, telescope-use, seedlings, crank-repair, betty-key, venus-column, jupiter-column, moon-key, moon-column, nigel-computer, night-wait, goggles, ghost-hunt, afternoon-door, linda-passage, bul-start, slide-ball, saturn-column, dragon-passage, glyph-request, lit-word-clue, loulou-barber, loulou-morning, drake-magic, loulou-answer, light-depletion, paid-light-request, word-lock, right-fire-panel, ethel-start, linda-curse, gargoyle-inspect, corbin-portrait, typing-start, oil-gargoyle, rune-passage, rune-light-wait, rune-light-start, fire-phosphorus, moving-room-entry, alchemy-snake-clue, nigel-library, nigel-snake, alchemy-return, alchemy-win, lab-entry, mould-shape, slider-verify
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
  m12 --betty-key--> m13 (observed prize-game win, Venus key earned, safe S2700)
  m13 --venus-column--> m14 (key purpose found, safe S2633; other columns remain)
  m14 --jupiter-column--> m15 (real Jupiter key used and returned, safe S2631)
  m15 --moon-key--> m16 (authored hallway interruption, zodiac win, Moon key and lens retained, safe S2010 view 3)
  m16 --moon-column--> m17 (real Moon key used and returned, safe S2626; columns and armor remain incomplete)
  m17 --nigel-computer--> m18 (Nigel, computer permission and hunt instructions; safe S4111, hunt not started)
  m18 --night-wait--> m19 (ordinary original-clock wait into the night window; safe S4111)
  m19 --goggles--> m20 (authored night interruption and real goggles 21; safe S4111)
  m20 --ghost-hunt--> m21 (all thirteen original ghosts, win and reward; safe S4111)
  m21 --afternoon-door--> m22 (real locked-door attempt and original afternoon wait, safe S3360)
  m22 --linda-passage--> m23 (Linda passage conversation, safe S4408)
  m23 --bul-start--> S1261 (wagered Bul; live play required, no save tail)
  bul_live.py may earn and verify m24 through ordinary play; loss/incomplete runs are refused.
  m24 --slide-ball--> m25 (first Ethel greeting, real7 door, first slide and actual ball3, safe S3215)
  m25 --saturn-column--> m26 (movie-timed bullseye, real16 and Saturn use, safe S2620)
  m26 --dragon-passage--> m27 (dragon levers, dark passage entry and retreat, safe S3326)
  m27 --glyph-request--> m28 (request a light, read glyph rules and exit unsolved, safe S3510 view 4)
   glyph_live.py may earn and verify m29 through first-time Junior play.
   m29 --lit-word-clue--> m30 (earned light4 and original lit word clue, safe S4389 with authored held4)
   m30 --loulou-barber--> m31 (daytime introduction and Barber clue, safe S3335)
   m31 --loulou-morning--> m32 (source-specific ordinary morning wait, safe S3335)
   m32 --drake-magic--> m34 (Drake magic-word knowledge, safe S2332; Barber already earned)
   m34 --loulou-answer--> m35 (original LEECH clue, safe S3335; word lock remains unsolved)
   m57 --alchemy-win--> m58 (five original alchemy rounds, new1960, safe S3054; lab puzzles remain)
   m58 --lab-entry--> m59 (original laboratory entry, safe S3804/held13)
   m59 --mould-shape--> m60 (24-bar mould, original item10 grant, safe S3803/held13; forge remains)

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


def load_save_prefix(slot_y=105):
    """The same seven ordinary main-menu load steps used by route_load.sh."""
    if type(slot_y) is not int or not 0 <= slot_y < 480:
        raise ValueError('invalid load row')
    r = R().at('MAIN.CIF', 1400).clicks('mv:275,95', 0)
    r.o.append('MAIN.CIF+2400:click:275,95,800')
    r.at('MAIN.CIF', 9000).clicks('mv:300,%d' % slot_y, 0)
    r.o.append('MAIN.CIF+10000:click:300,%d,800' % slot_y)
    r.at('MAIN.CIF', 14000).clicks('mv:553,248', 0)
    r.o += ['MAIN.CIF+15000:click:553,248,800', 'MAIN.CIF+20000:shot:0,0']
    return r.text()


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


def leg_betty_key(save=None):
    """m12 -> original Betty prize win, real Venus key 19 and safe S2700/m13.

    This bounded 160-request policy won the observed public-chain deal. Other
    deals or difficulties can fail; the checker must observe the real prize.
    """
    out = [R().at('S2701.CIF', 8000).clicks('312,270', 8000).text(),
           'S2702.CIF+13000:shot:0,0']
    panel = R().at('S2702.CIF', 20000)
    panel.clicks('279,321 155,321 465,321 217,321 527,321', 8000)
    panel.clicks('310,354,300', 8000)
    out += [panel.text(), 'S2702.CIF+120000:shot:0,0']
    # Keep the first keypad anchor while original scripts enter the prize game.
    # Only normal name requests are queued; no hand/deck/RNG data is consulted.
    requests = R().at('S2702.CIF', 130000)
    columns = (4, 7, 8, 3, 2, 5, 0, 6, 1, 9)
    for request in range(160):
        t = requests.t
        x = 31 + 62 * columns[request % len(columns)]
        requests.clicks('%d,321,300' % x, 20000)
        if request % 5 == 4:
            requests.o.append('S2702.CIF+%d:shot:0,0' % (t + 18000))
    prize = R().at('S2702.CIF', 3350000)
    prize.clicks('308,298 304,185 shot 212,448 shot 62,100 shot '
                 '212,448 62,100 shot 360,20 shot 310,354 shot', 8000)
    out += [requests.text(), prize.text()]
    if save:
        out += [menu_to_save_screen('S2702.CIF', 3470000),
                save_tail('S2702.CIF', 3488000, save)]
    return ';'.join(out)


def leg_venus_column(save=None):
    """m13 -> use the actual key 19 in Venus, task2000, safe S2633/m14.

    This completes the key-purpose task, not all columns or armor orientation.
    Uses the accepted m13 inventory layout and ordinary pointer clicks.
    """
    r = R().at('S2700.CIF', 12000).clicks('shot', 0)
    r.at('S2700.CIF', 20000).clicks(
        '576,161 584,161 298,160 570,161 310,160 315,145 shot '
        '66,160 516,160 310,221 shot 212,448 shot 62,170 shot 278,187 shot', 8000)
    r.at('S2700.CIF', 167000).clicks('shot', 0)
    r.at('S2700.CIF', 176000).clicks('310,354', 8000)
    r.at('S2700.CIF', 195000).clicks('shot', 0)
    out = [r.text()]
    if save:
        # The original save auto-closes; an extra close click is unexercised.
        out += [menu_to_save_screen('S2700.CIF', 210000),
                save_tail('S2700.CIF', 228000, save)]
    return ';'.join(out)


def leg_jupiter_column(save=None):
    """m14 -> use the earned Jupiter key 6 and return safely to S2631/m15.

    Keep the accepted inventory slot and both interior observations. This does
    not turn the armor or complete the remaining columns.
    """
    r = R().at('S2633.CIF', 12000).clicks('shot', 0)
    r.at('S2633.CIF', 20000).clicks('310,354 310,354 298,162 shot', 8000)
    r.turns('right', 3).clicks('shot 310,161 shot 212,448 shot 274,100 shot 273,111 shot', 8000)
    r.at('S2633.CIF', 143500).clicks('shot 310,354 shot', 8000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen('S2633.CIF', 175000),
                save_tail('S2633.CIF', 193000, save)]
    return ';'.join(out)


def leg_moon_key(save=None):
    """m15 -> authored lens/zodiac gate, real Moon key 11 and safe m16.

    The accepted route waits through the hallway interruption, installs the
    actual lens, solves the visible ordering puzzle, takes the key and returns
    the lens through the normal exit. The Moon column is a separate leg.
    """
    r = R().at('S2631.CIF', 12000).clicks('shot', 0)
    r.at('S2631.CIF', 20000).clicks('310,354 shot', 8000)
    r.turns('right', 5).clicks('shot', 8000)
    r.clicks('310,160 328,162 328,162 328,162 494,162 '
             '310,354 325,161 325,161 325,161 219,163', 8000)
    # Keep the exercised wait and the normal S3345 left exit. Earlier clicks
    # after this authored interruption ran before its caption/voice finished.
    r.at('S2631.CIF', 189500).clicks('shot', 7000)
    r.clicks('45,188 294,162 304,162 532,161 292,189 292,162 353,173 shot', 8000)
    r.turns('left', 2).clicks('shot', 8000)
    r.clicks('254,189 505,204 304,291 shot 212,448 274,100 shot '
             '169,262 shot 169,262 shot 366,170 shot', 8000)
    # Ordinary Aries-through-Pisces clicks on the original zodiac panel.
    r.at('S2631.CIF', 400000).clicks(
        '255,106 367,322 140,215 367,106 255,215 482,322 '
        '367,215 255,322 140,322 482,106 140,106 482,215', 8000)
    r.at('S2631.CIF', 520000).clicks(
        'shot 358,204 shot 343,196 shot 212,448 shot 62,100 shot '
        '212,448 62,100 360,20 shot '
        '310,354 shot 310,354 shot 310,354 310,354 shot', 8000)
    r.at('S2631.CIF', 685000).clicks('212,448 shot 360,20 shot', 8000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen('S2631.CIF', 725000),
                save_tail('S2631.CIF', 743000, save)]
    return ';'.join(out)


def leg_moon_column(save=None):
    """m16 -> use the actual Moon key 11, then return to safe S2626/m17.

    Uses the accepted six-item inventory layout. Other column keys and armor
    progression remain unmet; no orientation hotspot is clicked.
    """
    r = R().at('S2010.CIF', 12000).clicks('shot', 0)
    r.at('S2010.CIF', 20000).turns('left', 5)
    r.clicks('64,171 317,167 277,175 317,162 336,162 317,162 473,161 '
             '327,162 317,162 532,161 328,162 328,162 562,161 shot', 8000)
    r.turns('left', 10).clicks('shot 310,161 shot 212,448 shot 134,170 shot 311,171 shot', 8000)
    r.at('S2010.CIF', 253500).clicks('shot 310,354 shot', 8000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen('S2010.CIF', 289500),
                save_tail('S2010.CIF', 307500, save)]
    return ';'.join(out)


def leg_nigel_computer(save=None):
    """m17 -> Nigel, computer permission and PURGAMENTUM instructions/m18.

    Preserve the observed conversation choices and waits, then decline the hunt
    and cancel normally. The timed game starts in a later night leg.
    """
    a = 'S2626.CIF'
    r = R().at(a, 12000).clicks('shot', 0)
    r.at(a, 20000).clicks('310,354 shot', 8000)
    r.turns('right', 9).clicks('shot 268,160 385,162 307,160 307,160 shot 60,160 shot 463,232', 8000)
    r.at(a, 190500).clicks('shot', 0)
    for t, y, shot_at in ((200000, 440, 270000), (280000, 440, 350000),
                           (360000, 434, 430000), (440000, 454, 510000),
                           (520000, 434, 600000), (610000, 430, 730000),
                           (740000, 452, 810000)):
        r.at(a, t).clicks('150,%d,300' % y, 0)
        r.at(a, shot_at - 1000).clicks('shot', 0)
    r.at(a, 820000).clicks('570,160 310,174 310,174 310,189 229,220 shot', 8000)
    r.at(a, 928000).clicks('shot', 0)
    for i, ch in enumerate('PURGAMENTUM'):
        r.at(a, 970000 + 500 * i).clicks('key:%d' % ord(ch), 0)
    r.at(a, 975000).clicks('shot', 0)
    r.at(a, 978000).clicks('key:13', 0)
    r.at(a, 1069000).clicks('shot', 0)
    r.at(a, 1080000).clicks('445,98 shot 310,354 shot', 8000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 1124000), save_tail(a, 1142000, save)]
    return ';'.join(out)


def leg_night_wait(save=None):
    """m18 -> m19 through ordinary original-clock waiting beside the computer.

    Only idle time, moves and observations advance the original clock. The
    checker must observe the actual day-two midnight-to-4AM window.
    """
    a = 'S4111.CIF'
    r = R().at(a, 12000).clicks('shot', 0)
    for slot in range(1, 15):
        r.at(a, slot * 1000000).clicks('mv:320,60', 0)
        if slot % 3 == 0:
            r.at(a, slot * 1000000).clicks('shot', 0)
    r.at(a, 14499000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 14520000), save_tail(a, 14538000, save)]
    return ';'.join(out)


def leg_goggles(save=None):
    """m19 -> authored night interruption, real goggles 21 and safe m20.

    Keep every exercised navigation observation. Selecting an item closes the
    bag; reopen it before PUT, then explicitly close inventory before saving.
    """
    a = 'S4111.CIF'
    r = R()
    def observed_walk(start, points):
        for i, point in enumerate(points.split()):
            t = start + 5000 * i
            r.at(a, t).clicks(point, 0)
            r.o.append('%s+%d:shot:0,0' % (a, t + 3500))
    observed_walk(12000, '310,353 274,188 307,175 307,175 319,171 319,171')
    observed_walk(43000, '310,161 68,161 161,161 311,164 329,163 329,163 '
                  '126,163 326,162 326,162 326,162 220,164 299,163 '
                  '295,163 305,163 310,353')
    r.at(a, 133000).clicks('shot', 0)
    r.at(a, 139000).clicks('500,280', 0)
    r.at(a, 145000).clicks('shot', 0)
    r.at(a, 161000).clicks('shot', 0)
    r.at(a, 167000).clicks('432,112', 0)
    r.at(a, 173000).clicks('shot', 0)
    r.at(a, 185000).clicks('310,354', 0)
    r.at(a, 190000).clicks('shot', 0)
    r.at(a, 195000).clicks('310,354', 0)
    r.at(a, 200000).clicks('shot', 0)
    observed_walk(205000, '318,163 533,162 329,163 329,163 563,162 '
                  '124,161 386,163 308,161 308,161')
    observed_walk(251000, '307,175 307,175 307,175 303,190')
    r.at(a, 271000).clicks('212,448 60,100', 5000).clicks('shot', 0)
    r.at(a, 286000).clicks('212,448 62,100 360,20 shot', 5000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 306000), save_tail(a, 324000, save)]
    return ';'.join(out)


def leg_ghost_hunt(save=None):
    """m20 -> all thirteen original ghost captures and the earned m21 reward.

    This is the accepted night route, with its short ordinary-input cadence.
    No partial eleven-ghost probe or alternate hunt path is included.
    """
    entry = R().at('S4111.CIF', 12000).clicks('shot', 0)
    entry.at('S4111.CIF', 20000).clicks('229,220', 0)
    for i, ch in enumerate('PURGAMENTUM'):
        entry.at('S4111.CIF', 35000 + 500 * i).clicks('key:%d' % ord(ch), 0)
    entry.at('S4111.CIF', 42000).clicks('key:13', 0)
    entry.at('S4111.CIF', 64000).clicks('shot', 0)
    entry.at('S4111.CIF', 75000).clicks('173,96,300', 0)
    a = 'S4172.CIF'
    r = R().at(a, 1500)
    def walk(points, gap=1200):
        for point in points.split():
            r.o += ['%s+%d:move:%s' % (a, r.t, point),
                    '%s+%d:click:%s,300' % (a, r.t + 200, point)]
            r.t += gap
    def turn(direction, count):
        x = 10 if direction == 'left' else 620
        for _ in range(count):
            r.o += ['%s+%d:move:%d,200' % (a, r.t, x),
                    '%s+%d:move:320,60' % (a, r.t + 100)]
            r.t += 1200
    def observe():
        r.o.append('%s+%d:shot:0,0' % (a, r.t - 50))
    walk('310,354 310,354', gap=2000)
    observe()
    walk('310,353 274,188 307,175 307,175')
    walk('319,171 319,171', gap=1700)
    walk('310,161 316,146 270,162 381,164 310,193')
    walk('313,169', gap=1700)
    walk('308,161', gap=2200)
    turn('right', 4)
    walk('484,220 211,185 235,184 218,205 316,192 316,192 316,192 316,192 316,192 316,192 316,192 311,183 311,183 361,265 310,206')
    observe()
    walk('298,189', gap=1600)
    observe()
    walk('398,353')
    turn('left', 2)
    walk('102,196 92,348')
    turn('left', 1)
    walk('82,180 310,353 572,158 382,200 427,189 319,159 319,159 319,159 319,159 319,159 319,159 319,159 319,159 404,198 420,192 292,185 419,297')
    observe()
    walk('327,208', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('106,161')
    walk('311,165 296,157 25,335', gap=1700)
    observe()
    walk('362,188', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('579,163 306,164')
    walk('113,275', gap=1700)
    observe()
    walk('339,223', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('307,163 307,163', gap=1700)
    walk('543,188 318,165 318,165 310,353 593,336')
    observe()
    walk('393,183', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('318,165 318,165 318,165 583,253')
    observe()
    walk('317,183', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('318,165 318,165 318,165 310,353 37,261')
    observe()
    walk('318,167', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('318,165 563,165')
    walk('314,174', gap=1700)
    walk('314,164', gap=2200)
    walk('52,161 194,161 310,353')
    walk('564,127', gap=1700)
    observe()
    walk('306,163', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('543,81 311,164 329,163 329,163 495,163 318,163 318,163 318,163 469,164 531,266')
    observe()
    walk('317,183', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('310,353 153,162 326,162 94,199')
    observe()
    walk('317,183', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('326,162 326,162 326,162 326,162 326,162')
    walk('220,164', gap=1700)
    walk('299,163 295,163 535,162 308,162 407,161 394,162 394,162 394,162 394,162 394,162 394,162 394,162 394,162 436,49')
    observe()
    walk('317,183', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('310,353 323,173 323,173 323,173 323,173 323,173 323,173 323,173 323,173 268,164 362,163 473,162 305,163 310,353 82,255')
    observe()
    walk('317,183', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('318,163 337,163 318,163')
    walk('474,162', gap=1700)
    walk('328,163 318,163 533,162 329,163 329,163 563,162 124,161')
    walk('258,233', gap=1700)
    observe()
    walk('300,233', gap=1600)
    observe()
    walk('310,354')
    observe()
    walk('386,163')
    walk('308,161', gap=1700)
    walk('308,161', gap=2200)
    walk('307,175 307,175 307,175 303,190')
    observe()
    walk('229,220', gap=3000)
    for i, ch in enumerate('PURGAMENTUM'):
        r.at(a, 239000 + 500 * i).clicks('key:%d' % ord(ch), 0)
    r.at(a, 245500).clicks('key:13', 0)
    r.at(a, 269450).clicks('shot', 0)
    r.at(a, 275000).clicks('445,96', 0)
    r.at(a, 280000).clicks('shot', 0)
    r.at(a, 305000).clicks('shot', 0)
    r.at(a, 310000).clicks('310,354', 0)
    r.at(a, 315000).clicks('shot', 0)
    out = [entry.text(), r.text()]
    if save:
        out += [menu_to_save_screen(a, 320000), save_tail(a, 338000, save)]
    return ';'.join(out)


def _observed_walk(r, start, points, gap=5000, shot_after=3500):
    """Keep each exercised move/click and its separate observation slot."""
    anchor = r.a
    for i, point in enumerate(points.split()):
        t = start + gap * i
        r.at(anchor, t).clicks(point, 0)
        r.o.append('%s+%d:shot:0,0' % (anchor, t + shot_after))
    return r


def leg_afternoon_door(save=None):
    """m21 -> original locked-door attempt and afternoon wait, safe m22.

    Ordinary idle time advances the original clock. Preserve the exercised
    center click after waiting, followed by the original UI save.
    """
    a = 'S4111.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '310,353 274,188 307,175 307,175 319,171 319,171')
    _observed_walk(r, 43000, '310,161 68,161 161,161 311,164 329,163 329,163 '
                   '495,163 318,163 318,163 318,163 469,164 316,166')
    r.at(a, 103000).clicks('316,168', 0)
    r.at(a, 109000).clicks('shot', 0)
    r.at(a, 127000).clicks('shot', 0)
    r.at(a, 15730000).clicks('320,60', 0)
    r.at(a, 15733000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 15736000), save_tail(a, 15754000, save)]
    return ';'.join(out)


def leg_linda_passage(save=None):
    """m22 -> Linda, Great Hall return and passage conversation, safe m23.

    Retain the actual conversation waits and caption choices. These dialogue
    scenes keep the room artwork while the original requested scene changes.
    """
    a = 'S3360.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '310,353 310,353 153,162 326,162 326,162 326,162 326,162 563,161')
    _observed_walk(r, 52000, '292,189 292,162 72,165 316,180 391,170', 14000, 8000)
    r.at(a, 122000).clicks('276,166', 0)
    r.at(a, 159000).clicks('shot', 0)
    r.at(a, 175000).clicks('150,440', 0)
    r.at(a, 205000).clicks('shot', 0)
    r.at(a, 215000).clicks('310,354 shot 310,354 shot', 5000)
    r.at(a, 235000).turns('left', 8).clicks('shot', 0)
    _observed_walk(r, 260000, '290,195 312,163 415,163', 10000, 6000)
    _observed_walk(r, 290000, '310,353 533,162 329,163 329,163 563,162')
    r.at(a, 315000).turns('right', 1)
    _observed_walk(r, 317500, '563,164 543,81 311,164 329,163 329,163 126,163 326,162 563,161')
    _observed_walk(r, 357500, '292,189 292,162 72,165 316,180 391,170', 14000, 8000)
    r.at(a, 427500).clicks('276,166', 0)
    r.at(a, 464500).clicks('shot', 0)
    for t, y, shot in ((480000, 440, 516000), (535000, 440, 631000),
                       (640000, 440, 666000), (680000, 440, 716000),
                       (725000, 453, 751000)):
        r.at(a, t).clicks('150,%d' % y, 0)
        r.at(a, shot - 1000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 755000), save_tail(a, 773000, save)]
    return ';'.join(out)


def leg_bul_start(save=None):
    """m23 -> original passage wager and Bul board; no win or save claim.

    The historical fixed100-roll policy lost on the root chain. Adaptive
    ordinary roll/pass input is required after this start, in either mode.
    """
    if save is not None:
        raise ValueError('bul-start ends inside Bul; use bul_live.py for an observed win/save')
    a = 'S4408.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '310,354 310,354', 10000, 6000)
    r.at(a, 32000).turns('left', 8).clicks('shot', 0)
    _observed_walk(r, 57000, '290,195 312,163 415,163', 10000, 6000)
    _observed_walk(r, 87000, '326,162 326,162 220,164 482,220')
    _observed_walk(r, 107000, '308,193 292,162 306,173', 14000, 8000)
    r.at(a, 149000).turns('left', 4).clicks('shot', 0)
    for t, point, shot in ((165000, '312,233', 190000),
                           (205000, '150,440', 246000),
                           (255000, '150,440', 326000)):
        r.at(a, t).clicks(point, 0)
        r.at(a, shot - 1000).clicks('shot', 0)
    return r.text()


def bul_win_tail(save):
    """Original pickup/bag/save UI, for a caller that has observed S1259 +1405.

    This helper never establishes a win. The live player checks the real
    authored win before sending it, then checks actual7 and the resulting save.
    """
    r = R()
    won = 'S1259.CIF'
    r.at(won, 10000).clicks('150,453', 0)
    r.at(won, 33000).clicks('shot', 0)
    r.at(won, 38000).clicks('312,178', 0)
    r.at(won, 58000).clicks('shot', 0)
    r.at(won, 63000).clicks('22,405,6000', 0)
    r.o += ['%s+%d:move:22,%d' % (won, 64500 + 400 * i, y)
            for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 456))]
    r.at(won, 71500).clicks('shot', 0)
    r.at(won, 82000).clicks('150,438', 0)
    r.at(won, 102000).clicks('shot', 0)
    r.at(won, 107000).clicks('212,448 60,100', 5000).clicks('shot', 0)
    r.at(won, 122000).clicks('212,448 62,100 360,20 shot', 5000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(won, 142000), save_tail(won, 160000, save)]
    return ';'.join(out)


def leg_slide_ball(save=None):
    """Observed Junior m24 -> Ethel, real7 door, first slide and ball3.

    Source Ethel/door/slide/ball flags are still zero. Keep the authored first
    greeting, every exercised wait and the real inventory selections.
    """
    a = 'S3510.CIF'
    r = R().at(a, 12000).turns('left', 6)
    r.at(a, 27000).clicks('shot', 0)
    _observed_walk(r, 33000, '310,195 312,163 234,171', 12000, 7000)
    r.at(a, 80000).clicks('150,440', 0)
    r.at(a, 125000).clicks('shot', 0)
    r.at(a, 140000).clicks('150,421', 0)
    r.at(a, 205000).clicks('shot', 0)
    _observed_walk(r, 220000, '141,190 318,163 474,162 328,163 318,163 303,163 '
                   '318,163 318,163 318,163 469,164 316,166')
    r.at(a, 275000).clicks('212,448 280,174 shot 316,168 shot 316,168 shot '
                            '65,162 shot 322,202 shot', 7000)
    r.gap(12000).clicks('shot 274,178 shot', 7000)
    r.gap(12000).clicks('shot', 5000)
    _observed_walk(r, 402000, '55,162 280,163 304,163 306,164 307,163 307,163 '
                   '543,188 310,353 318,165 318,165 318,165 318,165')
    r.at(a, 462000).clicks('306,222 shot', 7000).gap(8000)
    r.clicks('310,164 shot 212,448 60,100 shot 212,448 62,100 360,20 shot', 5000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 529000), save_tail(a, 547000, save)]
    return ';'.join(out)


def leg_saturn_column(save=None):
    """Observed Junior m25 -> original bullseye16 reward and Saturn use.

    Movie timing is the exercised native timing, not a real-time FPS model.
    The 15ms pre-hover/40ms click and corrected inventory slots are deliberate.
    """
    a = 'S3215.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '310,353 318,165 563,165 314,174 314,164')
    _observed_walk(r, 38000, '52,161 194,161 49,162 88,161 311,164 329,163 '
                   '329,163 495,163 318,163 318,163 318,163 469,164 316,166 '
                   '315,168 315,168 65,162')
    r.at(a, 118000).clicks('322,202 shot', 7000)
    r.at(a, 142000).clicks('shot', 0)
    r.at(a, 149000).clicks('274,178', 0)
    movie = 'HAL_SLIDE_ANIM.BIK'
    r.o += [movie + '+800:shot:0,0', movie + '+835:move:380,140',
            movie + '+850:click:380,140,40', movie + '+930:shot:0,0',
            movie + '+6000:shot:0,0']
    r.at(movie, 18000).clicks('310,217 shot 212,448 60,100 shot '
                               '212,448 62,100 360,20 shot 310,100', 5000)
    r.gap(6000).clicks('shot', 3000)
    _observed_walk(r, 77000, '55,162 545,254 311,353 310,353 50,162 231,149')
    r.at(movie, 107000).clicks('212,448 60,243 shot 310,226 shot', 5000)
    r.gap(12000).clicks('310,354 shot', 7000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(movie, 158000), save_tail(movie, 176000, save)]
    return ';'.join(out)


def leg_dragon_passage(save=None):
    """Observed Junior m26 -> original dragon win, darkness and safe retreat.

    Eleven ordinary lever clicks leave states3,0,2,1,2,3 through the game's
    rules. This earns passage entry, not a light, word or armor completion.
    """
    a = 'S2620.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '525,163 310,353 68,161 161,161 311,164 329,163 '
                   '329,163 495,163 318,163 318,163 318,163 469,164 316,166 '
                   '315,168 315,168 321,162 214,163')
    r.at(a, 97000).clicks('shot', 0)
    _observed_walk(r, 102000, '289,99 289,99 289,99 211,149 211,149 431,193 '
                   '216,246 216,246 406,306 406,306 406,306')
    r.at(a, 172000).clicks('shot', 0)
    r.at(a, 185000).clicks('334,198', 0)
    r.at(a, 190000).clicks('shot', 0)
    r.at(a, 195000).clicks('282,166', 0)
    r.at(a, 222000).clicks('shot', 0)
    r.at(a, 228000).clicks('310,354', 0)
    r.at(a, 234000).clicks('shot', 0)
    r.at(a, 240000).clicks('359,163', 0)
    r.at(a, 246000).clicks('shot', 0)
    r.at(a, 257000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 262000), save_tail(a, 280000, save)]
    return ';'.join(out)


def leg_glyph_request(save=None):
    """Observed Junior m27 -> light request and glyph rules, saved unsolved.

    The scrolled reply asks for a light. No glyph moves, win or item4 reward
    are claimed: the original rules screen is exited normally before saving.
    """
    a = 'S3326.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '315,162 326,162 315,168 315,168 153,162 326,162 '
                   '326,162 326,162 326,162 326,162 326,162 220,164 482,220')
    _observed_walk(r, 77000, '308,193 292,162 306,173', 14000, 8000)
    r.at(a, 119000).turns('left', 4).clicks('shot', 0)
    r.at(a, 135000).clicks('312,233', 0)
    r.at(a, 171000).clicks('shot', 0)
    r.at(a, 185000).clicks('22,405,6000', 0)
    r.o += ['%s+%d:move:22,%d' % (a, 186500 + 400 * i, y)
            for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 456))]
    r.at(a, 193500).clicks('shot', 0)
    r.at(a, 205000).clicks('150,418', 0)
    r.at(a, 245000).clicks('shot', 0)
    rules = 'S3585.CIF'
    r.at(rules, 25000).clicks('310,355,300', 0)
    r.at(rules, 33000).clicks('shot', 0)
    r.at(rules, 44000).clicks('shot', 0)
    r.at(rules, 48000).clicks('310,355', 0)
    r.at(rules, 55000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(rules, 62000), save_tail(rules, 80000, save)]
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


def leg_lit_word_clue(save=None):
    """m29 -> use earned light4, inspect the lit clue; word lock stays unsolved."""
    a = 'S3510.CIF'
    r = R().at(a, 12000).turns('left', 6).clicks('shot', 0)
    _observed_walk(r, 32000, '310,195 312,163 234,171', 10000, 6000)
    _observed_walk(r, 62000, '318,163 474,162 328,163 318,163 303,163 '
                   '318,163 318,163 318,163 469,164 316,166 315,168 '
                   '315,168 321,162 214,163', 7000, 4500)
    r.at(a, 168000).clicks('shot', 0)
    r.at(a, 176000).clicks('289,99 289,99 289,99 211,149 211,149 431,193 '
                             '216,246 216,246 406,306 406,306 406,306', 3500)
    r.at(a, 222500).clicks('shot', 0)
    r.at(a, 227500).clicks('334,198', 0)
    r.at(a, 232500).clicks('shot', 0)
    r.at(a, 237500).clicks('282,166', 0)
    r.at(a, 249500).clicks('mv:310,180 shot', 0)
    _observed_walk(r, 255500, '271,165 240,164 235,164 295,169 298,167 309,168 '
                   '291,167 332,164 302,169 311,168 213,166 207,167 228,165 '
                   '306,168 308,166 329,165 306,164 339,167 306,165 310,164 341,166 310,166')
    for t, shot in ((365500, 383500), (387500, 405500)):
        r.at(a, t).clicks('347,107', 0)
        r.at(a, shot - 1000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 410500), save_tail(a, 428500, save)]
    return ';'.join(out)


def leg_loulou_barber(save=None):
    """m30 -> original daytime introduction and Barber clue, safe m31.

    The night-list attempt had no save. Preserve the successful four replies;
    this already earns Barber, so a separate magic-word request is unnecessary.
    """
    a = 'S4389.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '311,358 201,355 228,165 237,166 314,165 305,165 '
                   '377,165 316,164 302,167 320,164 315,164 399,164 401,165 '
                   '345,166 345,166 310,164 377,165 358,166 304,167 309,166 '
                   '307,164 322,167 315,169 391,167 359,163 359,163')
    _observed_walk(r, 145000, '315,162 326,162 315,168 315,168 439,162')
    r.at(a, 170000).clicks('324,196', 0)
    r.at(a, 195000).clicks('shot', 0)
    for t, shot in ((202000, 240000), (247000, 286000),
                    (292000, 330000), (337000, 375000)):
        r.at(a, t).clicks('150,421', 0)
        r.at(a, shot - 1000).clicks('shot', 0)
    r.at(a, 394000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 400000), save_tail(a, 418000, save)]
    return ';'.join(out)


def leg_loulou_morning(save=None):
    """m31 -> ordinary morning wait, safe m32; no clock/state writes.

    This exact 18-million-ms wait from the day-two 17:23 source is specific. The checker requires the
    actual morning arrival; a different source time may need another route.
    """
    a = 'S3335.CIF'
    r = R().at(a, 12000).clicks('mv:320,60 shot', 0)
    r.at(a, 18000000).clicks('mv:320,60 shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 18008000), save_tail(a, 18026000, save)]
    return ';'.join(out)


def leg_drake_magic(save=None):
    """m32 -> Drake's actual Loulou and magic-word replies, safe m34."""
    a = 'S3335.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '58,189 326,162 326,162 86,161 329,163 329,163 '
                   '58,161 116,161 381,164 310,193 313,169 308,161')
    r.at(a, 75000).clicks('shot', 0)
    for t in (77000, 81000, 85000, 89000):
        r.at(a, t).turns('right', 1)
        r.at(a, t + 2500).clicks('shot', 0)
    _observed_walk(r, 93000, '484,220 211,185 235,184 218,205 316,192 316,192 '
                   '316,192 316,192 316,192 316,192 316,192 48,158 82,180 353,184 490,170')
    r.at(a, 168000).clicks('327,234', 0)
    r.at(a, 208000).clicks('shot', 0)
    # Keep the exercised six-second thumb drags and actual scrolled replies.
    for t, reply_y, shot in ((216000, 399, 266000), (270000, 399, 320000),
                             (324000, 438, 364000)):
        r.at(a, t).clicks('22,405,6000', 0)
        r.o += ['%s+%d:move:22,%d' % (a, t + 1500 + 400 * i, y)
                for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 456))]
        r.at(a, t + 8000).clicks('shot', 0)
        r.at(a, t + 14000).clicks('150,%d' % reply_y, 0)
        r.at(a, shot - 1000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 368000), save_tail(a, 386000, save)]
    return ';'.join(out)


def leg_loulou_answer(save=None):
    """m34 -> actual LEECH answer and word clue, safe m35; no word-lock win."""
    a = 'S2332.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '310,353')
    # Entering S2333 can start MDM06 (5.138s). Its left exit requires
    # channel12 to finish; retain the ordinary route after a ten-second wait.
    _observed_walk(r, 27000, '92,181 313,183 572,158 382,200 427,189 '
                   '319,159 319,159 319,159 319,159 319,159 319,159 319,159 319,159 '
                   '404,198 420,192 292,185 106,161 311,165 296,157')
    r.at(a, 125000).clicks('shot', 0)
    _observed_walk(r, 127000, '313,164 581,164 534,163 311,164 329,163 329,163 '
                   '495,163 318,163 318,163 318,163 163,162 324,196')
    r.at(a, 187000).clicks('317,197', 0)
    r.at(a, 192000).clicks('shot', 0)
    for t, point, shot in ((197000, '310,176', 233000),
                            (238000, '150,421', 274000), (279000, '150,421', 305000)):
        r.at(a, t).clicks(point, 0)
        r.at(a, shot - 1000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 309000), save_tail(a, 327000, save)]
    return ';'.join(out)


def leg_light_depletion(save=None):
    """m35 -> authored first-light depletion and ordinary retreat, safe m36."""
    a = 'S3335.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '212,448 360,20 560,188 316,166 315,168 315,168 321,162 214,163')
    r.at(a, 52000).clicks('289,99 289,99 289,99 211,149 211,149 431,193 '
                            '216,246 216,246 406,306 406,306 406,306', 3500)
    r.at(a, 98500).clicks('shot', 0)
    r.at(a, 103500).clicks('334,198', 0)
    r.at(a, 108500).clicks('shot', 0)
    r.at(a, 113500).clicks('282,166', 0)
    r.at(a, 125500).clicks('mv:310,180 shot', 0)
    _observed_walk(r, 130500, '271,165 240,164 235,164 295,169 298,167 309,168 '
                   '291,167 332,164 302,169 311,168 213,166 207,167 228,165 '
                   '306,168 308,166 329,165 306,164 339,167 306,165 310,164 341,166 310,166')
    r.at(a, 240500).clicks('347,107', 0)
    r.at(a, 260500).clicks('shot', 0)
    _observed_walk(r, 275000, '201,355 228,165 237,166 314,165 305,165 377,165 '
                   '316,164 302,167 320,164 315,164 399,164 401,165 345,166 '
                   '345,166 310,164 377,165 358,166 304,167 309,166 307,164 '
                   '322,167 315,169 391,167 359,163 359,163 315,162 326,162 '
                   '315,168 315,168 439,162 324,196', 8000, 5000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 523000), save_tail(a, 541000, save)]
    return ';'.join(out)


def leg_paid_light_request(save=None):
    """m36 -> actual used5, first paid replacement topic and pending m37.

    The six-million-ms ordinary wait belongs to this source, not all clocks.
    Preserve the exercised caption thumb drag and first-paid150,418 reply.
    """
    a = 'S3335.CIF'
    r = R().at(a, 6012000).clicks('212,448', 0)
    r.at(a, 6015500).clicks('shot', 0)
    r.at(a, 6019000).clicks('60,100', 0)
    r.at(a, 6022500).clicks('shot', 0)
    r.at(a, 6026000).clicks('212,448 62,100 360,20', 3500)
    r.at(a, 6036500).clicks('shot', 0)
    _observed_walk(r, 6040000, '58,189 326,162 326,162 326,162 326,162 326,162 '
                   '326,162 220,164 482,220', 8000, 5000)
    _observed_walk(r, 6112000, '310,194 310,194 63,172', 16000, 9000)
    r.at(a, 6170000).clicks('310,190', 0)
    r.at(a, 6178000).clicks('shot', 0)
    r.at(a, 6194000).clicks('shot', 0)
    r.at(a, 6230000).clicks('22,405,6000', 0)
    r.o += ['%s+%d:move:22,%d' % (a, 6231400 + 400*i, y)
            for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455))]
    r.at(a, 6235500).clicks('mv:22,456', 0)
    r.at(a, 6238000).clicks('shot', 0)
    r.at(a, 6270000).clicks('150,418', 0)
    r.at(a, 6292000).clicks('shot', 0)
    _observed_walk(r, 6294000, '310,355 310,355', 20000, 11000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 6334000), save_tail(a, 6352000, save)]
    return ';'.join(out)


def leg_word_lock(save=None):
    """m38 -> five original word-lock stages and safe4387/m39.

    These are the observed left-wheel clicks for LEECH*, BOOK**, BONNET,
    GLASS* and HILL**. The original game owns every wheel and win condition.
    """
    a = 'S3510.CIF'
    r = R().at(a, 12000).turns('left', 6).clicks('shot', 0)
    _observed_walk(r, 32000, '310,195 312,163 234,171', 10000, 6000)
    _observed_walk(r, 62000, '318,163 474,162 328,163 318,163 303,163 '
                   '318,163 318,163 318,163 469,164 316,166 315,168 '
                   '315,168 321,162 214,163', 7000, 4500)
    r.at(a, 168000).clicks('shot', 0)
    r.at(a, 176000).clicks('289,99 289,99 289,99 211,149 211,149 431,193 '
                             '216,246 216,246 406,306 406,306 406,306', 3500)
    r.at(a, 222500).clicks('shot', 0)
    r.at(a, 227500).clicks('334,198', 0)
    r.at(a, 232500).clicks('shot', 0)
    r.at(a, 237500).clicks('282,166', 0)
    r.at(a, 249500).clicks('mv:310,180 shot', 0)
    _observed_walk(r, 255000, '271,165 240,164 235,164 295,169 298,167 309,168 '
                   '291,167 332,164 302,169 311,168 213,166 207,167 228,165 '
                   '306,168 308,166 329,165 306,164 339,167 306,165 310,164 341,166 310,166', 4000, 3000)
    r.at(a, 343000).clicks('347,107', 0)
    r.at(a, 355000).clicks('shot', 0)
    for start, counts, shot in ((358000, (2, 3, 1, 6, 6, 0), 403000),
                                (404000, (1, 6, 1, 2, 1, 0), 435000),
                                (436000, (0, 0, 1, 1, 5, 3), 465000),
                                (466000, (5, 6, 4, 3, 3, 4), 525000),
                                (526000, (4, 4, 4, 5, 6, 0), 581000)):
        r.at(a, start)
        for x, count in zip((225, 281, 337, 393, 449, 505), counts):
            r.clicks(' '.join('%d,271' % x for _ in range(count)), 2000)
        r.at(a, shot - 1000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 582000), save_tail(a, 600000, save)]
    return ';'.join(out)


def leg_right_fire_panel(save=None):
    """m39 -> observed right fire subset only, safe3141/held4/m40."""
    a = 'S4387.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '311,355 338,169 306,165 302,166 309,167 311,168 198,144')
    r.at(a, 47000).clicks('330,178', 0)
    r.at(a, 65000).clicks('shot', 0)
    _observed_walk(r, 110000, '75,100 225,188 75,276', 16000, 9000)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 158000), save_tail(a, 176000, save)]
    return ';'.join(out)


def leg_ethel_start(save=None):
    """m40 -> original Ethel interruption and truthful first reply.

    The retained continuation was live. Use ethel_live.py for curiosity,
    actual Bye and a verified UI save; this prefix has no save guarantee.
    """
    if save is not None:
        raise ValueError('ethel-start is a live prefix; use ethel_live.py for the complete save/reload leg')
    a = 'S3141.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '311,355 311,355', 8000, 5000)
    _observed_walk(r, 28000, '311,355 311,355 316,163 319,166 246,165 246,165 '
                   '228,165 237,166 314,165 305,165 377,165 316,164 302,167 '
                   '320,164 315,164 399,164 401,165 345,166 345,166 310,164 '
                   '377,165 358,166 304,167 309,166 307,164 322,167 315,169 '
                   '391,167 359,163 359,163', 6000, 4000)
    _observed_walk(r, 211000, '315,162 326,162 315,168 315,168', 6000, 4000)
    r.at(a, 243000).clicks('150,421', 0)
    r.at(a, 271000).clicks('shot', 0)
    return r.text()


def ethel_curiosity_payload():
    return '1:move:150,421;101:click:150,421,600;30001:shot:0,0'


def ethel_bye_payload():
    return '1:move:150,459;101:click:150,459,600;30001:shot:0,0'


def ethel_save_payload(name):
    """Keep the retained relative UI timing; parameterize only the save name."""
    import re
    if re.fullmatch('[a-z0-9]{1,10}', name) is None or name == 'continue':
        raise ValueError('invalid UI save name')
    payload = menu_to_save_screen('unused', 1000) + ';' + save_tail('unused', 19000, name)
    return re.sub(r'unused\+(\d+)', r'\1', payload)


def ethel_reload_payload():
    return 'S3428.CIF+12000:move:315,180;S3428.CIF+14000:shot:0,0'


def leg_linda_curse(save=None):
    """m41 -> original Linda curse/gargoyle clue, safe4408/m42."""
    a = 'S3428.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '163,162 326,162 326,162 326,162 326,162 563,161', 7000, 4500)
    _observed_walk(r, 54000, '292,189 292,162 72,165 316,180 391,170', 16000, 9000)
    r.at(a, 134000).clicks('276,166', 0)
    r.at(a, 174000).clicks('shot', 0)
    r.at(a, 279000).clicks('shot', 0)
    r.at(a, 310000).clicks('150,453', 0)
    r.at(a, 334000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 337000), save_tail(a, 355000, save)]
    return ';'.join(out)


def leg_gargoyle_inspect(save=None):
    """m42 -> inspect the actual gargoyle without a crest; safe3410/m43."""
    a = 'S4408.CIF'
    r = R().at(a, 12000).clicks('311,355', 0)
    r.at(a, 17000).clicks('shot', 0)
    r.at(a, 22000).clicks('311,355', 0)
    r.at(a, 25500).clicks('shot', 0)
    r.at(a, 29000).turns('left', 6)
    _observed_walk(r, 44000, '66,189 313,164 253,164 310,353 326,162 464,199', 7000, 4500)
    r.at(a, 106000).clicks('shot', 0)
    r.at(a, 109000).clicks('376,202', 0)
    r.at(a, 131000).clicks('shot', 0)
    r.at(a, 134000).clicks('376,202', 0)
    r.at(a, 142000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 150000), save_tail(a, 168000, save)]
    return ';'.join(out)


def leg_corbin_portrait(save=None):
    """m43 -> library walk and actual Corbin portrait1863, safe2741/m45.

    The family/paintings topics are already known. Preserve the exercised
    walk-only prefix and portrait body without an intermediate m44 save.
    """
    walk = R().at('S3410.CIF', 0)
    _observed_walk(walk, 12000, '566,188 328,163 318,163 533,162 329,163 329,163 '
                   '563,162 124,161 386,163 308,161 308,161', 7000, 4500)
    _observed_walk(walk, 92000, '61,161', 7000, 4500)
    a = 'S4112.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '40,162 307,175 319,171 319,171', 7000, 4500)
    _observed_walk(r, 43000, '310,161 554,162 81,162 233,163', 7000, 4500)
    r.at(a, 71000).clicks('480,111', 0)
    r.at(a, 93000).clicks('shot', 0)
    out = [walk.text(), r.text()]
    if save:
        out += [menu_to_save_screen(a, 96000), save_tail(a, 114000, save)]
    return ';'.join(out)


def leg_typing_start(save=None):
    """m45 -> original first-time Junior typing entry; no abandoned attempt.

    Preserve the exercised prefix through the first1340capture, omitting the
    old probe's later X. Use typing_live.py for actual play and verified save.
    """
    if save is not None:
        raise ValueError('typing-start is a live prefix; use typing_live.py for win/reward/save')
    a = 'S2741.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '310,353 310,357 311,162 297,153 41,163 386,163 308,161 308,161', 7000, 4500)
    _observed_walk(r, 71000, '61,161', 7000, 4500)
    r.at(a, 78000).clicks('463,232', 0)
    r.at(a, 118000).clicks('shot', 0)
    r.at(a, 121000).clicks('22,405,6000', 0)
    r.o += ['%s+%d:move:22,%d' % (a, 122500 + 400*i, y)
            for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 456))]
    r.at(a, 129000).clicks('shot', 0)
    r.at(a, 145000).clicks('150,399', 0)
    r.o += ['S1340.CIF+500:move:635,385', 'S1340.CIF+1000:shot:0,0']
    return r.text()


def typing_continue_payload():
    return '1:move:635,385;20000:shot:0,0'


def typing_pickup_payload():
    return ('1:move:605,32;101:click:605,32,300;5001:shot:0,0;'
            '6001:move:311,355;6101:click:311,355,600;10001:shot:0,0;'
            '11001:move:179,303;11101:click:179,303,600;16001:shot:0,0')


def typing_flip_bag_payload():
    return ('1:move:505,217;101:click:505,217,600;4001:shot:0,0;'
            '5001:move:310,180;5101:click:310,180,600;9001:shot:0,0;'
            '10001:move:311,355;10101:click:311,355,600;14001:shot:0,0;'
            '15001:move:212,448;15101:click:212,448,600;19001:shot:0,0')


def typing_examine_payload():
    return '1:move:60,100;101:click:60,100,600;3501:shot:0,0'


def typing_close_payload():
    return ('1:move:310,180;101:click:310,180,600;4001:shot:0,0;'
            '5001:move:360,20;5101:click:360,20,600;9001:shot:0,0')


def typing_reload_payload():
    r = R().at('S4114.CIF', 0)
    _observed_walk(r, 12000, '212,448 60,100 310,180', 6000, 4000)
    r.at('S4114.CIF', 30000).clicks('360,20', 0)
    r.at('S4114.CIF', 34000).clicks('shot', 0)
    return r.text()



def leg_oil_gargoyle(save=None):
    """m47 -> authored oil1944 and actual crest2 gargoyle opening, safe3416.

    Preserve the recorded oil-story pause and R,R,L,R,L,L,R turns. Crest2
    remains an owned examination item; no inventory selection/PUT is added.
    """
    a = 'S4114.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '310,353 40,162 307,175 319,171 319,171', 10000, 6000)
    r.at(a, 62000).clicks('311,180', 0)
    r.at(a, 212000).clicks('shot', 0)
    _observed_walk(r, 225000, '310,161 68,161 161,161 311,164 329,163 329,163 '
                   '126,163 326,162 326,162 326,162 464,199', 7000, 4500)
    _observed_walk(r, 310000, '376,202 376,202 236,202 376,202 236,202 236,202 376,202', 7000, 4500)
    r.at(a, 375000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 378000), save_tail(a, 396000, save)]
    return ';'.join(out)


def leg_rune_passage(save=None):
    """m48 -> nearby curse and six original rune clicks, actual win and held4.

    Original passage entry changes2041/2042. Preserve every recorded click
    and observation; this route ends at3050 without replacement/alchemy.
    """
    a = 'S3416.CIF'
    r = R().at(a, 12000).clicks('302,190 284,165 293,176 315,164 312,178 311,70', 4000)
    r.at(a, 56000).clicks('shot', 0)
    r.at(a, 60000).clicks('311,355 311,193', 4000)
    r.at(a, 68000).clicks('shot', 0)
    _observed_walk(r, 72000, '274,318 183,158 456,78 274,238 456,158 456,318', 5000, 3500)
    r.at(a, 118000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 154000), save_tail(a, 172000, save)]
    return ';'.join(out)


def leg_rune_light_wait(save=None):
    """m49 -> original West exit/used5 and source-specific afternoon staging.

    Keep the accepted61-event exit/inventory prefix. The12.9M ordinary gap
    accounts for this source03:42,70minutes earlier than the old04:52 save.
    End at a genuine3335/held5 UI checkpoint, without starting/abandoning play.
    """
    a = 'S3050.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '311,355 310,166 320,168 310,166 310,166 308,166 307,164 126,165', 8000, 5000)
    _observed_walk(r, 80000, '328,163 318,163 303,163 318,163 318,163 318,163 163,162 324,196', 8000, 5000)
    r.at(a, 144000).clicks('212,448', 0)
    r.at(a, 149000).clicks('shot', 0)
    r.at(a, 156000).clicks('60,100', 0)
    r.at(a, 161000).clicks('shot', 0)
    r.at(a, 166000).clicks('212,448 62,100 360,20', 5000)
    r.at(a, 181000).clicks('shot', 0)
    r.at(a, 13081000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 13086000), save_tail(a, 13104000, save)]
    return ';'.join(out)


def leg_rune_light_start(save=None):
    """Afternoon3335/held5 -> actual later paid request3585; live-only prefix.

    Preserve the old successful request suffix, rebased to this real staging
    save.150,399 is this source's scrolled reply, not first-paid150,418.
    """
    if save is not None:
        raise ValueError('rune-light-start is a live prefix; use repeat_glyph_live.py --context rune-passage')
    a = 'S3335.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '58,189 326,162 326,162 326,162 326,162 326,162 326,162 220,164 482,220', 8000, 5000)
    _observed_walk(r, 84000, '310,194 310,194 63,172', 16000, 9000)
    r.at(a, 142000).clicks('310,190', 0)
    r.at(a, 150000).clicks('shot', 0)
    r.at(a, 166000).clicks('shot', 0)
    r.at(a, 202000).clicks('22,405,6000', 0)
    r.o += ['%s+%d:move:22,%d' % (a, 203400 + 400*i, y)
            for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455))]
    r.at(a, 207500).clicks('mv:22,456', 0)
    r.at(a, 210000).clicks('shot', 0)
    r.at(a, 227000).clicks('150,399', 0)
    r.at(a, 250000).clicks('shot', 0)
    return r.text()


def leg_fire_phosphorus(save=None):
    """m51 -> other fire panel/all12, original phosphorus and real held13."""
    a = 'S3510.CIF'
    r = R().at(a, 12000).turns('left', 6)
    r.at(a, 31000).clicks('310,195 312,163 234,171 318,163', 10000)
    r.at(a, 68000).clicks('213,190', 0)
    _observed_walk(r, 75000, '376,202 376,202 236,202 376,202 236,202 236,202 376,202', 7000, 4500)
    r.at(a, 130000).clicks('302,190', 0)
    r.at(a, 138000).clicks('284,165 293,176 315,164 109,168 298,165 299,164 '
                             '315,164 315,164 315,164 315,164 315,164 315,164 '
                             '138,167 238,167 310,165 310,165 310,165 310,165 '
                             '310,165 310,165 310,165 357,166 310,165 310,165 '
                             '345,166 310,165 137,167 310,165 310,165 310,165 '
                             '211,167 229,168 413,127', 3000)
    r.at(a, 241000).clicks('shot', 0)
    r.at(a, 245000).clicks('330,178', 0)
    r.at(a, 261000).clicks('shot', 0)
    _observed_walk(r, 268000, '395,100 545,100 545,188 395,276', 9000, 5500)
    r.at(a, 312000).clicks('361,185 291,168 341,172 311,187', 6000)
    r.at(a, 360000).clicks('shot', 0)
    r.at(a, 366000).clicks('315,276', 0)
    r.at(a, 372000).clicks('shot', 0)
    r.at(a, 378000).clicks('311,355', 0)
    r.at(a, 394000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 400000), save_tail(a, 418000, save)]
    return ';'.join(out)


def _moving_room_entry(save=None, menu_at=165000):
    a = 'S3037.CIF'
    r = R().at(a, 0)
    _observed_walk(r, 12000, '306,166 304,165 313,173', 12000, 7000)
    r.at(a, 68000).clicks('shot', 0)
    for t, point in ((75000, '320,173'), (87000, '66,174'), (111000, '320,173'), (123000, '66,174')):
        _observed_walk(r, t, point, 0, 7000)
    r.at(a, 135000).clicks('311,355 313,173 320,173 307,179', 6000)
    r.at(a, 159000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, menu_at), save_tail(a, menu_at + 18000, save)]
    return ';'.join(out)


def leg_moving_room_entry(save=None):
    """m52 -> two normal Mars rotations, Mercury exit and safe3046/held13."""
    return _moving_room_entry(save)


def leg_alchemy_snake_clue(save=None):
    """m53 -> actual closed panel/snake1922, back to3046; test still locked."""
    a = 'S3046.CIF'
    r = R().at(a, 12000).clicks('328,99', 0)
    r.at(a, 19000).clicks('340,97', 0)
    r.at(a, 46000).clicks('shot', 0)
    r.at(a, 53000).clicks('311,370', 0)
    r.at(a, 60000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 67000), save_tail(a, 85000, save)]
    return ';'.join(out)


def leg_nigel_library(save=None):
    """m54 -> daytime library via normal inverse rotations, safe4112/held13.

    Current afternoon source needs no historical11M night wait. Every other
    navigation token and its cadence is unchanged by that explicit delta.
    """
    a = 'S3046.CIF'
    r = R().at(a, 12000).clicks('311,355 307,167 307,167 313,173 320,173 66,174', 6500)
    r.at(a, 51000).clicks('shot', 0)
    r.at(a, 57500).clicks('320,173 66,174', 6500)
    r.at(a, 70500).clicks('shot', 0)
    r.at(a, 77000).clicks('311,355 313,173 320,173 307,179', 6500)
    r.at(a, 103000).clicks('shot', 0)
    r.at(a, 109500).clicks('311,175 438,178 304,165 304,165 304,165 377,165 '
                              '303,165 303,165 303,165 303,165 239,165 '
                              '312,166 312,166 312,166 312,166 312,166 312,166 312,166 '
                              '315,167 474,166 310,166 310,166 310,166 310,166 310,166 '
                              '310,166 320,165 320,165 310,166 320,168 310,166 310,166 '
                              '308,166 307,164 126,165', 5000)
    r.at(a, 289500).clicks('328,163 318,163 533,162 329,163 329,163 563,162 '
                              '124,161 386,163 308,161 308,161', 5000)
    r.at(a, 344500).clicks('61,161', 0)
    r.at(a, 359500).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 372500), save_tail(a, 390500, save)]
    return ';'.join(out)


def leg_nigel_snake(save=None):
    """m55 -> original1371/1694 using the source-matched visible question.

    Preserve the exercised response-list/scroll/Bye cadence. Source1704/1698
    are0, so the snake question is third; the original caption scroll exposes
    the work Bye. The checker requires that bounded source profile.
    """
    a = 'S4112.CIF'
    r = R().at(a, 24000).clicks('shot', 0)
    r.at(a, 30000).clicks('463,232', 0)
    r.at(a, 69000).clicks('shot', 0)
    r.at(a, 80000).clicks('150,459', 0)
    r.at(a, 164000).clicks('shot', 0)
    r.at(a, 180000).clicks('22,405,6000', 0)
    r.o += ['%s+%d:move:22,%d' % (a, 181500 + 400*i, y)
            for i, y in enumerate((410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 456))]
    r.at(a, 189000).clicks('shot', 0)
    r.at(a, 200000).clicks('150,438', 0)
    r.at(a, 221000).clicks('shot', 0)
    out = [r.text()]
    if save:
        out += [menu_to_save_screen(a, 245000), save_tail(a, 263000, save)]
    return ';'.join(out)


def leg_alchemy_return(save=None):
    """m56 -> earned passage/real13 and two original room turns, safe3046."""
    a = 'S4112.CIF'
    r = R().at(a, 12000).clicks('40,162 307,175 319,171 319,171', 5000)
    r.at(a, 37000).clicks('310,161 68,161 161,161 311,164 329,163 329,163 '
                             '126,163 326,162 326,162 326,162 464,199', 5000)
    _observed_walk(r, 92000, '376,202 376,202 236,202 376,202 236,202 236,202 376,202', 7000, 4500)
    r.at(a, 147000).clicks('302,190', 0)
    r.at(a, 155000).clicks('284,165 293,176 315,164 109,168 298,165 299,164 '
                             '315,164 315,164 315,164 315,164 315,164 315,164 '
                             '138,167 238,167 310,165 310,165 310,165 310,165 '
                             '310,165 310,165 310,165 357,166 310,165 310,165 '
                             '345,166 310,165 137,167 310,165 310,165 310,165 '
                             '211,167 229,168 361,185 291,168', 3500)
    return r.text() + ';' + _moving_room_entry(save, menu_at=166000)


def leg_alchemy_win(save=None):
    """m57: genuine1694/held13 -> five authored rounds -> safe3054/new1960.

    The continuous Senior s62->s63 INPUT is retained exactly, including all
    three key10 releases,600ms holds and the original scene-open anchors.
    D6 has one difficulty-independent recipe; public m57 has the same entry
    prerequisites. Only the optional UI save name is parameterized.
    """
    r = R().at('S3046.CIF', 24000).clicks('shot', 0)
    r.at('S3046.CIF', 30000).clicks('328,99', 0)
    r.at('S3046.CIF', 44000).clicks('shot', 0)
    for start, keys, capture in (
            (22000, '212,122 100,236 338,315', 39000),
            (42000, '212,122 100,236 156,236 156,236 156,236 338,315', 68000),
            (71000, '100,179 156,122 338,315', 88000),
            (91000, '100,65 100,122 338,315', 108000),
            (111000, '100,65 212,236 156,65 212,179 338,315', 134000)):
        r.at('S3196.CIF', start).clicks(keys, 3000)
        r.at('S3196.CIF', capture - 1000).clicks('shot', 0)
    if save:
        return ';'.join((r.text(), menu_to_save_screen('S3196.CIF', 153000),
                         save_tail('S3196.CIF', 171000, save)))
    return r.text()


def leg_lab_entry(save=None):
    """The exercised Senior s63->s64 entry, with only the UI save name changed."""
    r = R().at('S3054.CIF', 12000).clicks('311,164', 0)
    r.at('S3054.CIF', 44000).clicks('shot', 0)
    r.at('S3054.CIF', 59000).clicks('shot', 0)
    if save:
        return ';'.join((r.text(), menu_to_save_screen('S3054.CIF', 75000),
                         save_tail('S3054.CIF', 93000, save)))
    return r.text()


def leg_mould_shape(save=None):
    """Retain Senior s64->s65, adding the effective-resource2163 correction.

    The old23 strokes and every old offset remain. The same ordinary325,76
    control exists in3801 and3880; the actual loose3876 gate needs this24th
    bar. Taking the mould grants10, without lighting or pouring the forge.
    """
    r = R()
    for start, point, capture in ((12000, '325,165', 21000), (26000, '252,219', 43000),
                                  (48000, '306,190', 58000), (64000, '215,310', 86000)):
        r.at('S3804.CIF', start).clicks(point, 0)
        r.at('S3804.CIF', capture - 1000).clicks('shot', 0)
    r.at('S3804.CIF', 104000).clicks('shot', 0)
    r.at('S3801.CIF', 50000).clicks('37,76', 0)
    r.at('S3801.CIF', 52500).clicks('shot', 0)
    for i, point in enumerate(('68,76', '100,76', '214,76', '246,76', '356,76',
            '388,76', '503,76', '68,173', '183,173', '214,173', '356,173',
            '472,173', '503,173', '37,268', '68,270', '100,268', '214,270',
            '246,268', '325,268', '388,268', '472,268', '503,270')):
        start = 80000 + i * 5000
        r.at('S3801.CIF', start).clicks(point, 0)
        r.at('S3801.CIF', start + 2500).clicks('shot', 0)
    r.at('S3801.CIF', 192000).clicks('325,76', 0)
    r.at('S3801.CIF', 194500).clicks('shot', 0)
    r.at('S3801.CIF', 199000).clicks('shot', 0)
    r.at('S3801.CIF', 206000).clicks('311,355', 0)
    r.at('S3801.CIF', 221000).clicks('shot', 0)
    if save:
        return ';'.join((r.text(), menu_to_save_screen('S3801.CIF', 235000),
                         save_tail('S3801.CIF', 253000, save)))
    return r.text()


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
            'seedlings': leg_seedlings, 'crank-repair': leg_crank_repair,
            'betty-key': leg_betty_key, 'venus-column': leg_venus_column,
            'jupiter-column': leg_jupiter_column, 'moon-key': leg_moon_key,
            'moon-column': leg_moon_column, 'nigel-computer': leg_nigel_computer,
            'night-wait': leg_night_wait, 'goggles': leg_goggles,
            'ghost-hunt': leg_ghost_hunt, 'afternoon-door': leg_afternoon_door,
            'linda-passage': leg_linda_passage, 'bul-start': leg_bul_start,
            'slide-ball': leg_slide_ball, 'saturn-column': leg_saturn_column,
            'dragon-passage': leg_dragon_passage, 'glyph-request': leg_glyph_request,
            'lit-word-clue': leg_lit_word_clue, 'loulou-barber': leg_loulou_barber,
            'loulou-morning': leg_loulou_morning, 'drake-magic': leg_drake_magic,
            'loulou-answer': leg_loulou_answer, 'light-depletion': leg_light_depletion,
            'paid-light-request': leg_paid_light_request, 'word-lock': leg_word_lock,
            'right-fire-panel': leg_right_fire_panel, 'ethel-start': leg_ethel_start,
            'linda-curse': leg_linda_curse, 'gargoyle-inspect': leg_gargoyle_inspect,
            'corbin-portrait': leg_corbin_portrait, 'typing-start': leg_typing_start,
            'oil-gargoyle': leg_oil_gargoyle, 'rune-passage': leg_rune_passage,
            'rune-light-wait': leg_rune_light_wait, 'rune-light-start': leg_rune_light_start,
            'fire-phosphorus': leg_fire_phosphorus, 'moving-room-entry': leg_moving_room_entry,
            'alchemy-snake-clue': leg_alchemy_snake_clue, 'nigel-library': leg_nigel_library,
            'nigel-snake': leg_nigel_snake, 'alchemy-return': leg_alchemy_return,
            'alchemy-win': leg_alchemy_win, 'lab-entry': leg_lab_entry,
            'mould-shape': leg_mould_shape}
    if leg not in legs:
        sys.exit(__doc__)
    print(legs[leg](save))
