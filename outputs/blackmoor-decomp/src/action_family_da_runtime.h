#ifndef BLACKMOOR_ACTION_FAMILY_DA_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_DA_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xda, the Bul puzzle (RT-59; loaded as "AT_BUL_PUZZLE", surface "Bul Puzzle Surface", z entry label
 * "BUL PUZZLE OVERLAYS" (the original strings contain spaces), scene S1261): a two-sided piece game. The player and the computer each own a barrack and a jail of
 * pieces; a marker per side ("current player piece", "current computer piece") moves along numbered positions; the player (or
 * the computer) presses a roll button, a random draw of "moves" is made and the marker walks that many positions, one per
 * tick; when both markers meet, the side that moved sends the other piece to jail and scores; the first side with the winning
 * number of pieces ends the game (win or lose scene change). Every step is followed by a spoken caption (sound plus caption
 * text). Nothing here claims original source structure.
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly (the Ghidra pseudocode was used only for
 * navigation). The object ("CBulPuzzle") is one static 0x1b9-byte singleton at 0x624734 (ECX of every method; allocated by
 * 0x45b300, constructor 0x45b37a -> reset 0x45b3ea). Row bookkeeping: body pointer [0x5bb5e5 + row * 0x8d], row phase dword
 * [0x5bb632 + row * 0x8d].
 *   0x45b4ae  loader (arm 0x41061d): copies 2,958 bytes into a fresh row allocation (src/action_family_da.[ch]).
 *   0x45c18f  handler (dispatcher arm 0x42a424 after gate 0x423f57(deps, 0), `ret 4`, row word): a switch on the row phase.
 *             Phase 0 init, phase 1 the inner state machine on obj+0x24 (jump table 0x45d286, states 0..0xb, state 5 is a
 *             no-op), phase 2 finish.
 *   0x45b5bb  pointer receiver (`ret 8`, first word x, second word y; the cascade 0x4f0059 calls it at 0x4f0c63) with the
 *             candidate/cursor writer 0x45b7a8 (`ret 8`).
 *   0x45b872  click on an accepted release (chain 0x43b2a0, call at 0x43b2f5), acts on the retained candidate [0x5c39e5].
 *   0x45b477  slot invalidate (0x43d9ba), 0x45b42e cleanup (0x438bfd, 0x43ded9 and the end of phase 2) + reset 0x45b3ea.
 *   0x45d2c6  render callback of the generic z entry (type 10), with 0x45b568 (rectangle + view origin, `ret 8`).
 *   0x45ba0b  per-game reset of the working rectangles, positions and counters (from the body).
 *   0x45bbd8  random pick of four rectangles (`_rand`), returns the number of "moves".
 *   0x45bcc1  one step check (both markers on the same position): caption, state 6, score.
 *   0x45bda7  win / lose check.  0x45be3f  "is this a real sound name".  0x45be7f  caption + sound picker.
 *
 * Typed body (2,958 bytes; words signed, a rectangle is four dwords left, top, right, bottom; offsets from the body start):
 *   +0x000 NUL-terminated name of the puzzle surface image (CIFTREE, 6, "Bul Puzzle Surface"), 0x21 bytes
 *   +0x021 word M positions on the track      +0x023 word N pieces per side (the winning score)
 *   +0x025 ... (unused by this class)         +0x027 byte "two players" (0: the computer plays side 2)
 *   +0x028 byte "smart computer" (decides to pass from the distance)
 *   +0x029 word start position of the player marker, +0x02b of the computer marker (1..M)
 *   +0x02d 4 rectangles, +0x06d 4 rectangles: screen rectangles of the two sets of "roll" overlays (drawn from the object's
 *          working rectangles +0x36 / +0x76, which 0x45ba0b and 0x45bbd8 fill)
 *   +0x0ad M position rectangles (marker positions; 15 slots reach +0x19d)
 *   +0x19d player barrack rects (6), +0x1fd player jail rects (6), +0x25d computer barrack rects (6), +0x2bd computer jail
 *          rects (6) (each 6 x 16 bytes; N <= 6)
 *   +0x31d rectangle of button 0 (roll), +0x32d button 1 (pass), +0x33d button 2 (reset); +0x34d player light, +0x35d computer
 *          light
 *   +0x36d 4 x 0x20 bytes: for k = 0..3 two source rectangles (+0x20 * k, +0x10 + 0x20 * k) of the roll overlay
 *   +0x3ed / +0x3fd the marker images (current player / computer piece); +0x40d / +0x41d the marker images after a step
 *   +0x42d barrack piece (player), +0x43d barrack piece (computer), +0x44d jail piece (computer), +0x45d jail piece (player)
 *   +0x46d 3 rectangles of the pressed-button images, +0x49d player light on, +0x4ad computer light on, +0x4bd pass button
 *          disabled
 *   +0x4cd sound record (step sound: name 0x21 bytes, word channel at +0x21 = +0x4ee, 0x31 bytes per record)
 *   +0x4fe / +0x52f / +0x560 sound records of buttons 0 / 1 / 2 (channel words +0x51f / +0x550 / +0x581)
 *   +0x591 + 0x2dc * e (e = 0 player side, 1 computer side) caption entry: word channel (+0x00), words +0x02 and +0x04, then 22
 *          names of 0x21 bytes at +0x06: name 0 (+0x06, phase-0 greeting for e = 1), name 1 (+0x27, pass), 4 names +0x48
 *          (before the roll), 4 names +0xcc (when the moves end), 4 names +0x150 (a step scores), 4 names +0x1d4 (win / lose), 4 names
 *          +0x258 (click on the finish rectangle); e = 1 starts at +0x86d
 *   +0xb49 finish block of a game that ended (finish kind != 0), +0xb65 block of a game that was left (finish kind 0),
 *   +0xb7e finish rectangle (pointer candidate 0x27bb)
 * A finish block (0x1c bytes): scene word (9999 none), words +2 +4 +6, dwords +8 +0xc +0x10, start-flag word +0x14 (== 1 stores
 * 0, else 1), then +0x16 event flag word (-1 none) and +0x18 byte value; the block at +0xb49 has a second flag word +0x19 / byte
 * +0x1b: +0x16 is stored when the player won, +0x19 when not.
 *
 * Object (offsets in the object; every field a mirror of the original width):
 *   +0x1c word z slot (-1 none)     +0x1e word row (-1 none)      +0x20 dword puzzle surface (0 none)
 *   +0x24 dword state (0 idle, 1 caption pick, 2 pick of moves, 3 moving, 4 wait, 6 score step, 7 / 8 win / lose caption,
 *         9 reset wait for a sound, 10 caption wait, 0xb exit delay)
 *   +0x28 dword button animation active    +0x2c word button kind     +0x2e dword button deadline   +0x32 dword button down
 *   +0x36 / +0x76 working rectangle sets (4 x 16)   +0xb6 / +0xb8 words player / computer score   +0xba word mode (0..3)
 *   +0xbc / +0xcc current player / computer marker rectangles   +0xdc moving piece rectangle (valid when +0xe4 != 0)
 *   +0xec / +0xfc marker images   +0x10c erase rectangle (valid when +0x114 != 0)   +0x11c +0x12c +0x13c +0x14c "clearing out"
 *   +0x15c word side   +0x15e dword player light visible   +0x162 dword finish kind   +0x166 dword active   +0x16a dword won
 *   +0x16e +0x17c +0x180 dword deadlines   +0x172 word pending button   +0x174 word moves   +0x176 word step
 *   +0x178 / +0x17a words player / computer position   +0x184 33-byte sound name buffer
 *   +0x1a5 word caption channel, +0x1a7 = 2, +0x1a9 = 1, +0x1ab = 1 (words), +0x1ad dword 1, +0x1b1 / +0x1b3 words from the
 *   caption entry, +0x1b5 dword next state after the caption.
 * Process cells the class reads or writes: 0x5bb1ca start flag (BulWorld), the seven scene-change cells 0x5bb57b 0x5bb599
 * 0x5bb595 0x5c39ff 0x5bb59b 0x5bb59f 0x5bb5a3 and the engine mode 0x583999 (BulHost.transition / engine_mode), the event
 * flags [0x585801 + 4 * i], the view origin [0x583186] / [0x58318a] (BulHost.view_origin), the cursor cells of the pointer
 * (BulPointerResult), the retained candidate 0x5c39e5 (the caller keeps it), the caption destination [0x5d03b3] and the
 * backdrop surface [0x5d15e3] (the host).
 *
 * Host contract: every engine call whose body lies outside this slice is a callback of BulHost, issued in the original order;
 * the optional `observe` receives each call and each global store in that order (BulEffect). Host callbacks that can fail
 * return nonzero; the kernel then returns BUL_ERR_HOST (the original has no recovery, the session must stop). The kernel keeps
 * no globals: all state is in BulObject / BulWorld.
 *
 * Quirks of the original that are preserved (the kernel mirrors them, they are not fixed):
 *  - 0x45be7f copies the chosen name with strlen + 1 bytes into obj+0x184 (33 bytes); its random pick draws `_rand % count`
 *    until it finds a real name ("is real" = not "NO SOUND\0" in the first 9 bytes and not empty), or until every index was
 *    seen as a non-real name (then it reports 0 and does nothing but fill the caption descriptor +0x1a5..+0x1b3, which it
 *    always writes first). With count <= 1 the single name is tested directly and no `_rand` is drawn. On success it calls
 *    0x4fb77a(name), 0x4fb2e3(channel), 0x423259(name) (the caption text), shows the text plus a 4-byte suffix dword
 *    (the constant dword "<e>" at 0x54ab74) through 0x448d11 unless the text is longer than 0x9c40 bytes, and sets obj+0x24 = 10.
 *    The channel is passed as a 16-bit value (0x4fb2e3 masks with 0xffff); 0x4f6334 gets the sign-extended word.
 *  - 0x45bbd8 draws two `_rand` per rectangle (an "odd" bit and a row of 4) and returns the number of odd draws, or 5 when no
 *    draw was odd (so there are always 1..4 or 5 moves).
 *  - Phase 0 stores to +0x124 / +0x128 and +0x134 / +0x138 overwrite the right / bottom of the rectangles just copied to
 *    +0x11c and +0x12c (they become bounding boxes with the right / bottom of the last jail slot, body +0x255 / +0x259 and
 *    +0x315 / +0x319); the order is replicated.
 *  - 0x45ba0b zeroes +0x28..+0x35 with dword stores at +0x28, +0x2c, +0x30 and a word store at +0x34; the button kind (word
 *    +0x2c), the deadline (dword +0x2e) and the down flag (dword +0x32) are separate fields here and all three become 0, which
 *    is the same result as the overlapping stores of the original.
 *  - 0x45bcc1 compares the two position words +0x178 and +0x17a regardless of the side it is called with; its third
 *    argument to 0x45be7f carries the upper half of an unrelated register (only the low word is used).
 *  - State 6 reads the jail / barrack rectangle at index (N - score - 1), which is -1 when the score reached N (the last
 *    rectangle of the previous array, still inside the body).
 *  - Phase 2 stops the sound records +0x4fe / +0x52f / +0x560 but not +0x4cd (phase 0 prepared all four). It does not check
 *    the row against obj+0x1e. 0x45b42e releases the surface (0x4c2dfb zeroes the handle) and the slot, and 0x45b3ea resets only
 *    row, slot, active, won and finish kind; every other field survives into the next game until phase 0 rewrites it.
 *  - The pointer receiver ignores input while the button animation runs, and for the computer's turns (two-players byte +0x27
 *    zero and mode >= 2). The rectangle tests are signed 32-bit compares of the sign-extended 16-bit pointer words; the pass
 *    button (kind 1) only answers in modes 1 and 3 and with the rectangle narrowed by 10 horizontally, moved by +5
 *    vertically; button 0 extends 5 up and down.
 *  - The render callback does not test `active`; it reads the object through globals and erases from the backdrop surface
 *    [0x5d15e3] (the entry of z slot 1). The kernel returns the blits the host must perform (kind, source, rectangles) and
 *    does the object stores of the original (it zeroes the erase rectangles after erasing them and clears the button
 *    animation after the button was restored).
 *  - Uninitialised locals: none are read by the kernel; the original leaves the loop flag of 0x45be7f undefined when count <= 1
 *    (not read there) and 0x45c18f state 0 initialises its decision local. The stack garbage in the upper half of arguments
 *    pushed with 16-bit moves is never used by the callees (checked for 0x4fb2e3, 0x45be7f, 0x45bcc1).
 *
 * Native-only refusals (the original has none of these guards; none of them can fire on a body that passes
 * bul_validate_body and an object the kernel built itself):
 *  - bul_validate_body: length other than 2958, a surface / sound / caption name without NUL inside its 0x21 bytes (the
 *    original copies strlen + 1 bytes into 33-byte or 36-byte buffers), M outside 1..15 (position rectangles), N outside 1..6
 *    (barrack / jail rectangles), a start position outside 1..M. Reported as BUL_ERR_BODY before the first effect.
 *  - Phase 1 / 2 on an object that phase 0 did not initialise for `row` (BUL_ERR_UNSUPPORTED, before any effect); phase 1 /
 *    click / render on an object whose mode is outside 0..3, scores outside 0..N, positions outside 1..M, side outside 0..1,
 *    button kind outside 0..2 (BUL_ERR_UNSUPPORTED before any effect, from hand-made objects only).
 *  - Event flag indexes of the finish block that the host calls invalid (host query, before any effect, BUL_ERR_BOUNDS).
 *  - A rectangle index outside its array during the visit (BUL_ERR_BOUNDS); a random draw outside 0..32767 (BUL_ERR_HOST); a
 *    z slot below 0 (BUL_ERR_HOST).
 *  - Loops that never end: the 0x45be7f name pick stops with BUL_ERR_STUCK after BUL_PICK_LIMIT draws.
 *  - A caption text longer than BUL_CAPTION_MAX (200) that is not longer than 0x9c40: the original copies it into a 204-byte
 *    stack buffer (a stack overflow); the kernel returns BUL_ERR_BOUNDS after 0x423259 was called.
 *  - More blits than BUL_MAX_BLITS in one render (BUL_ERR_BOUNDS).
 * An error returned after an effect leaves the object in the partial state the original would have; the session must stop. */

#define BUL_RUNTIME_TYPE UINT8_C(0xda)
#define BUL_BODY_BYTES 2958u
#define BUL_NAME_BYTES 0x21u
#define BUL_NO_SLOT (-1)
#define BUL_NO_SCENE 9999
#define BUL_NO_FLAG (-1)
#define BUL_NO_OFFSET (-1)
#define BUL_CANDIDATE_BUTTON 0x27ba /* 0x45b7a8 (button 0..2) */
#define BUL_CANDIDATE_FINISH 0x27bb /* 0x45b7a8 (finish rectangle) */
#define BUL_MAX_POSITIONS 15
#define BUL_MAX_PIECES 6
#define BUL_CAPTION_MAX 200u
#define BUL_CAPTION_LIMIT 0x9c40u
#define BUL_PICK_LIMIT 100000u /* draws of the name pick before BUL_ERR_STUCK */
#define BUL_MAX_BLITS 64
#define BUL_CALLBACK_PUZZLE 1  /* the render callback 0x45d2c6 handed to register_slot */

/* Body offsets. */
enum {
    BUL_B_POSITIONS = 0x21,
    BUL_B_PIECES = 0x23,
    BUL_B_TWO_PLAYERS = 0x27,
    BUL_B_SMART = 0x28,
    BUL_B_START_PLAYER = 0x29,
    BUL_B_START_COMPUTER = 0x2b,
    BUL_B_ROLL_A_DST = 0x2d,
    BUL_B_ROLL_B_DST = 0x6d,
    BUL_B_POSITION_RECT = 0xad,
    BUL_B_PLAYER_BARRACK = 0x19d,
    BUL_B_PLAYER_JAIL = 0x1fd,
    BUL_B_COMPUTER_BARRACK = 0x25d,
    BUL_B_COMPUTER_JAIL = 0x2bd,
    BUL_B_BUTTON_RECT = 0x31d,
    BUL_B_PLAYER_LIGHT = 0x34d,
    BUL_B_COMPUTER_LIGHT = 0x35d,
    BUL_B_WORK_SRC = 0x36d,
    BUL_B_MARKER_IMAGE = 0x3ed,
    BUL_B_MARKER_AFTER = 0x40d,
    BUL_B_PIECE_PLAYER_BARRACK = 0x42d,
    BUL_B_PIECE_COMPUTER_BARRACK = 0x43d,
    BUL_B_PIECE_COMPUTER_JAIL = 0x44d,
    BUL_B_PIECE_PLAYER_JAIL = 0x45d,
    BUL_B_BUTTON_DOWN_IMAGE = 0x46d,
    BUL_B_PLAYER_LIGHT_ON = 0x49d,
    BUL_B_COMPUTER_LIGHT_ON = 0x4ad,
    BUL_B_PASS_DISABLED = 0x4bd,
    BUL_B_SOUND_STEP = 0x4cd,
    BUL_B_SOUND_BUTTON = 0x4fe, /* + 0x31 * kind */
    BUL_B_SOUND_RECORD_BYTES = 0x31,
    BUL_B_CAPTION = 0x591,      /* + 0x2dc * entry */
    BUL_B_CAPTION_STRIDE = 0x2dc,
    BUL_B_BLOCK_ENDED = 0xb49,
    BUL_B_BLOCK_LEFT = 0xb65,
    BUL_B_FINISH_RECT = 0xb7e
};

typedef enum BulStatus {
    BUL_OK = 0,
    BUL_ERR_ARGUMENT = 1,
    BUL_ERR_BODY = 2,
    BUL_ERR_UNSUPPORTED = 3,
    BUL_ERR_HOST = 4,
    BUL_ERR_BOUNDS = 5,
    BUL_ERR_STUCK = 6
} BulStatus;

/* States (obj+0x24). */
enum {
    BUL_STATE_IDLE = 0,
    BUL_STATE_CAPTION_PICK = 1,
    BUL_STATE_PICK_MOVES = 2,
    BUL_STATE_MOVING = 3,
    BUL_STATE_WAIT = 4,
    BUL_STATE_SCORE = 6,
    BUL_STATE_WIN = 7,
    BUL_STATE_LOSE = 8,
    BUL_STATE_RESET_WAIT = 9,
    BUL_STATE_CAPTION_WAIT = 10,
    BUL_STATE_EXIT_DELAY = 11
};

typedef struct BulRect {
    int32_t left, top, right, bottom;
} BulRect;

/* The singleton at 0x624734. Offsets are object offsets. Storage starts zeroed (a static object); bul_object_reset applies the
 * constructor's reset 0x45b3ea. */
typedef struct BulObject {
    int16_t slot;            /* +0x1c generic z entry, -1 none */
    int16_t row;             /* +0x1e */
    uint32_t surface;        /* +0x20 puzzle image handle, 0 none */
    int32_t state;           /* +0x24 */
    int32_t anim_active;     /* +0x28 button animation active */
    int16_t button_kind;     /* +0x2c */
    uint32_t anim_deadline;  /* +0x2e */
    int32_t button_down;     /* +0x32 */
    BulRect roll_a[4];       /* +0x36 working rectangles, first set */
    BulRect roll_b[4];       /* +0x76 working rectangles, second set */
    int16_t score_player;    /* +0xb6 */
    int16_t score_computer;  /* +0xb8 */
    int16_t mode;            /* +0xba 0..3 */
    BulRect cur_player;      /* +0xbc current player marker */
    BulRect cur_computer;    /* +0xcc current computer marker */
    BulRect moving;          /* +0xdc moving piece (right dword +0xe4 nonzero = valid) */
    BulRect image_player;    /* +0xec marker image, player */
    BulRect image_computer;  /* +0xfc marker image, computer */
    BulRect erase;           /* +0x10c erase rectangle (right dword +0x114 nonzero = valid) */
    BulRect clear[4];        /* +0x11c +0x12c +0x13c +0x14c */
    int16_t side;            /* +0x15c */
    int32_t light;           /* +0x15e */
    int32_t finish_kind;     /* +0x162 */
    int32_t active;          /* +0x166 */
    int32_t won;             /* +0x16a */
    uint32_t deadline_16e;   /* +0x16e */
    int16_t pending_button;  /* +0x172 */
    int16_t moves;           /* +0x174 */
    int16_t step;            /* +0x176 */
    int16_t pos_player;      /* +0x178 */
    int16_t pos_computer;    /* +0x17a */
    uint32_t deadline_17c;   /* +0x17c */
    uint32_t deadline_180;   /* +0x180 */
    uint8_t sound_name[33];  /* +0x184 */
    int16_t cap_channel;     /* +0x1a5 */
    int16_t cap_1a7;         /* +0x1a7 = 2 */
    int16_t cap_1a9;         /* +0x1a9 = 1 */
    int16_t cap_1ab;         /* +0x1ab = 1 */
    int32_t cap_1ad;         /* +0x1ad = 1 */
    int16_t cap_1b1;         /* +0x1b1 */
    int16_t cap_1b3;         /* +0x1b3 */
    int32_t next_state;      /* +0x1b5 state after the caption */
} BulObject;

/* The process cell the handler writes: the start flag 0x5bb1ca. */
typedef struct BulWorld {
    int32_t start_flag_5bb1ca;
} BulWorld;

/* The seven scene-change cells of a finish block. */
typedef struct BulTransition {
    int16_t scene;     /* 0x5bb57b (dword, sign-extended) */
    int16_t word[3];   /* 0x5bb599, 0x5bb595, 0x5c39ff */
    int32_t dword[3];  /* 0x5bb59b, 0x5bb59f, 0x5bb5a3 */
} BulTransition;

typedef enum BulEffect {
    BUL_FX_START_FLAG = 1,       /* 0x5bb1ca := a */
    BUL_FX_CLEAR_ITEM = 2,       /* 0x4e8d96 */
    BUL_FX_ROW_PHASE = 3,        /* row phase dword := a */
    BUL_FX_SLOT = 4,             /* 0x4d39f9 returned a */
    BUL_FX_SLOT_REGISTER = 5,    /* entry stores of slot a: type 10, callback 0x45d2c6, surface 0, flags 0/0/1/1, label */
    BUL_FX_SURFACE_LOAD = 6,     /* 0x4c2790 returned a */
    BUL_FX_SLOT_SURFACE = 7,     /* slot a surface := b */
    BUL_FX_SOUND_PREPARE = 8,    /* 0x4fb77a(record at body offset a; BUL_NO_OFFSET = the buffer obj+0x184) */
    BUL_FX_SOUND_STOP = 9,       /* 0x4fba69(record at body offset a) */
    BUL_FX_SOUND_BUSY = 10,      /* 0x4f6334(channel a) returned b */
    BUL_FX_SOUND_PLAY = 11,      /* 0x4fb2e3(channel a) */
    BUL_FX_TICK = 12,            /* GetTickCount returned a */
    BUL_FX_RANDOM = 13,          /* _rand returned a */
    BUL_FX_CAPTION_TEXT = 14,    /* 0x423259 returned a text (a = 1) or NULL (a = 0) */
    BUL_FX_CAPTION_SHOW = 15,    /* 0x448d11 with a string of length a (text + suffix) */
    BUL_FX_XFER_5BB57B = 16,     /* dword := sign-extended scene word a */
    BUL_FX_XFER_5BB599 = 17,     /* word */
    BUL_FX_XFER_5BB595 = 18,     /* word */
    BUL_FX_XFER_5C39FF = 19,     /* word */
    BUL_FX_XFER_5BB59B = 20,     /* dword */
    BUL_FX_XFER_5BB59F = 21,     /* dword */
    BUL_FX_XFER_5BB5A3 = 22,     /* dword */
    BUL_FX_ENGINE_MODE = 23,     /* 0x583999 := a */
    BUL_FX_EVENT_FLAG = 24,      /* dword [0x585801 + 4 * a] := b */
    BUL_FX_COMPLETE = 25,        /* 0x42ba3a(row a) */
    BUL_FX_RELEASE_SURFACE = 26, /* 0x4c2dfb(&surface), the handle held was a */
    BUL_FX_RELEASE_SLOT = 27,    /* 0x4d3992(a) */
    BUL_FX_MARK_DIRTY = 28,      /* 0x45b477: entry a flag +0x14 := 1 */
    BUL_FX_BLIT = 29             /* render: blit kind a, index b */
} BulEffect;

typedef struct BulHost {
    void *context;
    /* 0x4d39f9: first free generic z entry. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type, callback (BUL_CALLBACK_PUZZLE), surface, flags 0 / 0 / 1 / 1, word 0, label. */
    int (*register_slot)(void *, int16_t slot, int32_t type, int callback, uint32_t surface, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, "Bul Puzzle Surface"). */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x45b477: entry flag +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The view origin: left [0x583186] and top [0x58318a]. */
    int (*view_origin)(void *, int32_t *x, int32_t *y);
    /* 0x4e8d96: commits the pending inventory item (phase 0 only). */
    int (*clear_pending_item)(void *);
    /* 0x4fb77a / 0x4fba69 on a sound name (a record inside the body or the caption buffer obj+0x184). */
    int (*sound_prepare)(void *, const uint8_t *name);
    int (*sound_stop)(void *, const uint8_t *name);
    /* 0x4f6334(channel): nonzero while the channel plays. */
    int (*sound_busy)(void *, int16_t channel);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x423259(name): the caption text of a sound name, or NULL. The returned string must stay valid until the next call. */
    const char *(*caption_text)(void *, const char *name);
    /* 0x448d11(destination [0x5d03b3], text, -1, 0) with text = caption text + the 4-byte suffix. */
    int (*caption_show)(void *, const char *text);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* _rand (0x50cd50): 0..32767. */
    int32_t (*random)(void *);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the seven scene-change cells as one request (the start flag and the engine mode follow separately). */
    int (*transition)(void *, const BulTransition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    int (*engine_mode)(void *, int32_t mode);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} BulHost;

typedef struct BulResult {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} BulResult;

/* A power-on object: zeroed storage with the constructor's reset 0x45b3ea (slot -1, row -1). */
void bul_object_reset(BulObject *object);

/* Native safety check of a typed body (see the refusals above). `failure` is optional. */
int bul_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x45c18f. Validation precedes the first effect. A host failure after effects returns BUL_ERR_HOST. */
int bul_step(BulObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, BulWorld *world,
             const BulHost *host, BulResult *result, const char **failure);

typedef struct BulPointerResult {
    uint8_t hit;           /* 0x45b5bb return value (1 = the cascade stops here) */
    int32_t candidate;     /* 0x5c39e5 written (BUL_CANDIDATE_*), -1 when nothing was written */
    int32_t cursor_kind;   /* 0x5b44f0: 9 (finish rectangle) or 0x16 (buttons) */
    int32_t cursor_sub;    /* 0x5b44f4 (1) */
    uint32_t cursor_cell;  /* 0x5d1631: 0x5b160c + cursor_kind * 32 + cursor_sub * 16 */
    uint8_t cursor_link;   /* 0x5d162d := [0x5d0377] and 0x5d1639 := 1 were stored */
    int32_t button;        /* obj+0x172 written (0..2), -1 when not written */
} BulPointerResult;

/* 0x45b5bb at (x, y), both taken as signed 16-bit words, with the candidate writer 0x45b7a8 (which stores obj+0x172 for a
 * button hit). Nothing happens while the object is inactive or the button animation runs. */
int bul_pointer(BulObject *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y, BulPointerResult *out);

typedef struct BulClickResult {
    uint8_t handled;    /* the gate held and the candidate was one of the two */
    uint32_t new_phase; /* the row phase after the click (2 when the click ended the game) */
} BulClickResult;

/* 0x45b872, run on an accepted release with the retained candidate 0x5c39e5. `row_phase` is the dword at
 * 0x5bb632 + obj.row * 0x8d. */
int bul_click(BulObject *object, const uint8_t *body, size_t body_length, const BulWorld *world, const BulHost *host,
              uint32_t row_phase, int32_t candidate, BulClickResult *out);

/* 0x45b477. */
int bul_invalidate(const BulObject *object, const BulHost *host);

/* 0x45b42e: release the surface and the slot, then the 0x45b3ea reset. Callable on an idle object. */
int bul_cleanup(BulObject *object, const BulHost *host);

/* Render callback 0x45d2c6. */
typedef enum BulBlitKind {
    BUL_BLIT_ROLL_A = 1,             /* restore, puzzle surface: src obj.roll_a[index], dst shifted body +0x2d + 16 * index */
    BUL_BLIT_ROLL_B = 2,             /* src obj.roll_b[index], dst shifted body +0x6d + 16 * index */
    BUL_BLIT_PLAYER_BARRACK = 3,     /* src body +0x42d, dst shifted body +0x19d + 16 * index */
    BUL_BLIT_PLAYER_JAIL = 4,        /* src body +0x45d, dst shifted body +0x1fd + 16 * index */
    BUL_BLIT_COMPUTER_BARRACK = 5,   /* src body +0x43d, dst shifted body +0x25d + 16 * index */
    BUL_BLIT_COMPUTER_JAIL = 6,      /* src body +0x44d, dst shifted body +0x2bd + 16 * index */
    BUL_BLIT_PLAYER_JAIL_AGAIN = 7,  /* the second pass over the player jail (same rectangles as kind 4) */
    BUL_BLIT_ERASE_BARRACK = 8,      /* restore, backdrop: src obj.erase, dst shifted obj.erase (then obj.erase := 0) */
    BUL_BLIT_PLAYER_LIGHT = 9,       /* puzzle: src body +0x49d, dst shifted body +0x34d */
    BUL_BLIT_COMPUTER_LIGHT_OFF = 10, /* backdrop: src body +0x35d, dst shifted body +0x35d */
    BUL_BLIT_COMPUTER_LIGHT = 11,    /* puzzle: src body +0x4ad, dst shifted body +0x35d */
    BUL_BLIT_PLAYER_LIGHT_OFF = 12,  /* backdrop: src body +0x34d, dst shifted body +0x34d */
    BUL_BLIT_PASS_DISABLED = 13,     /* puzzle: src body +0x4bd, dst shifted body +0x32d */
    BUL_BLIT_PASS_ENABLED = 14,      /* backdrop: src body +0x32d, dst shifted body +0x32d */
    BUL_BLIT_BUTTON_DOWN = 15,       /* draw (0x4c5d4b), puzzle: src body +0x46d + 16 * kind, dst shifted body +0x31d + 16 * kind */
    BUL_BLIT_BUTTON_UP = 16,         /* restore, backdrop: src body +0x31d + 16 * kind, dst shifted (then obj.anim_active := 0) */
    BUL_BLIT_PLAYER_PIECE = 17,      /* puzzle: src obj.image_player, dst shifted obj.cur_player */
    BUL_BLIT_COMPUTER_PIECE = 18,    /* puzzle: src obj.image_computer, dst shifted obj.cur_computer */
    BUL_BLIT_ERASE_MOVING = 19,      /* backdrop: src obj.moving, dst shifted obj.moving (then obj.moving := 0) */
    BUL_BLIT_CLEAR_PLAYER = 20,      /* backdrop: obj.clear[0] (state 9 only) */
    BUL_BLIT_CLEAR_COMPUTER = 21,    /* backdrop: obj.clear[1] */
    BUL_BLIT_ERASE_PLAYER_PIECE = 22, /* backdrop: obj.clear[2] */
    BUL_BLIT_ERASE_COMPUTER_PIECE = 23 /* backdrop: obj.clear[3] */
} BulBlitKind;

typedef struct BulBlit {
    int32_t kind;      /* BulBlitKind */
    int32_t index;     /* loop index or button kind, else 0 */
    int32_t backdrop;  /* 1: the source surface is the backdrop [0x5d15e3]; 0: the puzzle surface of the object's z entry */
    BulRect src;       /* the first rectangle argument (unshifted) */
    BulRect dst;       /* the second rectangle argument (src of the screen: view origin added) */
} BulBlit;

typedef struct BulRenderResult {
    uint8_t valid;     /* 0 when the callback does nothing (inactive object or no z entry) */
    uint16_t count;
    BulBlit blit[BUL_MAX_BLITS];
} BulRenderResult;

int bul_render(BulObject *object, const uint8_t *body, size_t body_length, const BulHost *host, BulRenderResult *out);

#ifdef __cplusplus
}
#endif
#endif
