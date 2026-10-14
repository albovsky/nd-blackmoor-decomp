# FUN_004e22fd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e22fd
# extent:       0x004e22fd-0x004e2522 (549 code bytes)
# span:         0x004e22fd-0x004e2522 (code 549, tables 0, padding 0)
# sha256:       a255537effcab825f59fc19465913931e457058483472244a196a3abc53c8494
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# name:         CUIButton::HitTestAndUpdateState
# arguments:    thiscall: ecx=this (the button sub-object), two stack arguments popped by the callee (ret 8): [ebp+8] = x coordinate and [ebp+0xc] = y coordinate, both read as sign-extended 16-bit words (movsx word ptr). Returns eax=1 when the point is inside the rectangle and the state machine accepted it (kind 0 in state 0/1/3 or kind 1 in state 0/1/2), else eax=0
# locals:       [ebp-local_this] = this, spilled from ecx. [ebp-local_kind] = copy of this+0x18 (the kind selector, tested against 0 and 1). The frame reserves 8 bytes via sub esp, 8
# fields:       this+0x04: dword, x minimum (inclusive). this+0x08: dword, y minimum (inclusive). this+0x0c: dword, x maximum (inclusive). this+0x10: dword, y maximum (inclusive). this+0x18: dword kind selector (0 or 1 handled, other values return 0). this+0x1c: dword flag read on a miss in kind 1. this+0x30: dword state (4 returns 0 at once, 0, 1 and 3 pass the kind 0 gate, 0, 1 and 2 pass the kind 1 gate, every other value returns 0), written 0, 1 or 2. this+0xe2: dword flag, non-zero makes a hit set state 1. this+0xe6: dword flag, non-zero makes a hit publish the cursor selection. this+0x183: dword hit result, cleared on entry and set to 1 on a hit. Globals written on a hit when this+0xe6 is non-zero: 0x005c39e5 = 0x27d8, 0x005b44f4 = 1, 0x005d1631 = 0x5b160c + (dword [0x005b44f0] << 5) + (1 << 4) as computed from the two globals, 0x005d1639 = 1. Global read: 0x005b44f0
# callees:      none
# track-n:      host-adapter: none
# unverified:   Class and role names are my labels. The class label comes from one of seven direct callers (in 0x473206, 0x4deed7, 0x4e075a, 0x4e412d, 0x4e89eb, 0x4ebd85 and 0x4ee2a9; the 0x4ee2a9 call at 0x4ee4cc passes ecx = obj+0x31c and tests obj+0x15f first, then pushes obj+4 and obj+8 words), none of which was otherwise traced, and src/caption_lifecycle.c, which cites 0x4e22fd only as the unsupported has-button return and has no counterpart for this routine, so there is no Track N source. The meaning of kind 0 versus kind 1, of states 0 to 4, of this+0x1c, this+0xe2 and this+0xe6, and of the scene value 0x27d8 are not established from these bytes: the field and label names (btn_hover_flag, btn_cursor_flag, btn_miss_flag, btn_hit_result, kind0 and kind1 and so on) are role labels inferred from how each field is tested and written, not from original symbols. Whether this+0x04/+0x08/+0x0c/+0x10 are screen or object-relative coordinates is not verified. Rectangle edge order (x range at +4/+0xc, y range at +8/+0x10) follows the compare operands in the bytes. The globals written on a hit: 0x005c39e5 (dword; s0-action-runtime-trace.md: pending event/hotspot index; Track N caption_lifecycle.h: slider_cursor_scene; here it receives 0x27d8, role not established), 0x5b44f4 and 0x5b44f0 are Track N's cursor_variant and cursor_type labels (not proven). 0x5d1631 and 0x5d1639 are fields +0xc and +0x14 of entry 2 of the render layer table 0x5d1591 (stride 0x4a, 0x5d1591 + 2*0x4a = 0x5d1625), per tests/caption_lifecycle_original_oracle.py:56-57. Track N's cursor_src_index label counts dwords (src/caption_lifecycle.h:164: (address-0x5b160c)/4); the bytes store the byte address 0x5b160c + (type<<5) + (variant<<4). The reader side of the cursor selection (what reads 0x5d1631 and 0x5d1639 beyond the render layer table) is not traced here. States other than 0, 1 and 3 (kind 0) or 0, 1 and 2 (kind 1) all return 0, including 5 and above and negative values.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # this pointer spilled from ecx
.equ local_kind, 0x8  # copy of this+0x18, the kind selector
.equ btn_left, 0x4  # this+0x04: x minimum, inclusive
.equ btn_top, 0x8  # this+0x08: y minimum, inclusive
.equ arg_x, 0x8  # first stack argument: x coordinate, 16-bit word read with sign extension
.equ arg_y, 0xc  # second stack argument: y coordinate, 16-bit word read with sign extension
.equ btn_right, 0xc  # this+0x0c: x maximum, inclusive
.equ btn_bottom, 0x10  # this+0x10: y maximum, inclusive
.equ btn_kind, 0x18  # this+0x18: kind selector (0 or 1 handled)
.equ btn_miss_flag, 0x1c  # this+0x1c: flag read on a kind 1 miss, non-zero gives state 0, zero gives state 2
.equ btn_state, 0x30  # this+0x30: state, 0 to 3 handled, 4 returns 0 immediately
.equ btn_hover_flag, 0xe2  # this+0xe2: flag, non-zero makes a hit set state 1
.equ btn_cursor_flag, 0xe6  # this+0xe6: flag, non-zero makes a hit publish the cursor selection globals
.equ btn_hit_result, 0x183  # this+0x183: hit result dword, cleared on entry, set to 1 on a hit

# --- external targets -----------------------------------------------

.org 0x004e22fd - 0x401000
.globl FUN_004e22fd
FUN_004e22fd:
    # block 0x004e22fd: entry: spill this, clear this+0x183 (hit result), if state (this+0x30) != 4 go to kind_dispatch (jne)
    push ebp                                     # 004e22fd
    {load} mov ebp, esp                          # 004e22fe
    sub esp, 0x8                                 # 004e2300
    mov dword ptr [ebp - local_this], ecx           # 004e2303
    mov eax, dword ptr [ebp - local_this]           # 004e2306
    mov dword ptr [eax + btn_hit_result], 0x0         # 004e2309
    mov ecx, dword ptr [ebp - local_this]           # 004e2313
    cmp dword ptr [ecx + btn_state], 0x4          # 004e2316
    jne.d8 kind_dispatch                            # 004e231a
    # block 0x004e231c: state == 4: return 0 (xor eax, eax) through the epilogue, no further work
    {load} xor eax, eax                          # 004e231c
    jmp.d32 epilogue                           # 004e231e
kind_dispatch:
    # block 0x004e2323: kind_dispatch: local_kind = this+0x18, if kind == 0 go to kind0_state_gate (je)
    mov edx, dword ptr [ebp - local_this]           # 004e2323
    mov eax, dword ptr [edx + btn_kind]          # 004e2326
    mov dword ptr [ebp - local_kind], eax           # 004e2329
    cmp dword ptr [ebp - local_kind], 0x0           # 004e232c
    je.d8 kind0_state_gate                             # 004e2330
    # block 0x004e2332: kind != 0: if kind == 1 go to kind1_state_gate (je)
    cmp dword ptr [ebp - local_kind], 0x1           # 004e2332
    je.d32 kind1_state_gate                            # 004e2336
    # block 0x004e233c: kind is neither 0 nor 1: return 0
    jmp.d32 return_0                           # 004e233c
kind0_state_gate:
    # block 0x004e2341: kind 0: if state (this+0x30) == 0 go to kind0_rect_test (je)
    mov ecx, dword ptr [ebp - local_this]           # 004e2341
    cmp dword ptr [ecx + btn_state], 0x0          # 004e2344
    je.d8 kind0_rect_test                             # 004e2348
    # block 0x004e234a: kind 0: if state == 1 go to kind0_rect_test (je)
    mov edx, dword ptr [ebp - local_this]           # 004e234a
    cmp dword ptr [edx + btn_state], 0x1          # 004e234d
    je.d8 kind0_rect_test                             # 004e2351
    # block 0x004e2353: kind 0: state not in {0,1,3} (the compare here is only against 3, after the 0 and 1 tests): if state != 3 go to kind0_miss_done and return 0 (jne), state 3 falls into the rectangle test
    mov eax, dword ptr [ebp - local_this]           # 004e2353
    cmp dword ptr [eax + btn_state], 0x3          # 004e2356
    jne.d32 kind0_miss_done                           # 004e235a
kind0_rect_test:
    # block 0x004e2360: kind0_rect_test: y = sign-extended arg_y, if y < this+0x08 (top) it is a miss (jl signed)
    movsx ecx, word ptr [ebp + arg_y]            # 004e2360
    mov edx, dword ptr [ebp - local_this]           # 004e2364
    cmp ecx, dword ptr [edx + btn_top]           # 004e2367
    jl.d32 kind0_miss                            # 004e236a
    # block 0x004e2370: y > this+0x10 (bottom) is a miss (jg signed)
    movsx eax, word ptr [ebp + arg_y]            # 004e2370
    mov ecx, dword ptr [ebp - local_this]           # 004e2374
    cmp eax, dword ptr [ecx + btn_bottom]          # 004e2377
    jg.d32 kind0_miss                            # 004e237a
    # block 0x004e2380: x = sign-extended arg_x, if x < this+0x04 (left) it is a miss (jl signed)
    movsx edx, word ptr [ebp + arg_x]            # 004e2380
    mov eax, dword ptr [ebp - local_this]           # 004e2384
    cmp edx, dword ptr [eax + btn_left]           # 004e2387
    jl.d32 kind0_miss                            # 004e238a
    # block 0x004e2390: x > this+0x0c (right) is a miss (jg signed), otherwise the point is inside the inclusive rectangle
    movsx ecx, word ptr [ebp + arg_x]            # 004e2390
    mov edx, dword ptr [ebp - local_this]           # 004e2394
    cmp ecx, dword ptr [edx + btn_right]           # 004e2397
    jg.d8 kind0_miss                             # 004e239a
    # block 0x004e239c: kind 0 hit: this+0x183 = 1, then if this+0xe2 == 0 skip to kind0_after_state (je)
    mov eax, dword ptr [ebp - local_this]           # 004e239c
    mov dword ptr [eax + btn_hit_result], 0x1         # 004e239f
    mov ecx, dword ptr [ebp - local_this]           # 004e23a9
    cmp dword ptr [ecx + btn_hover_flag], 0x0          # 004e23ac
    je.d8 kind0_after_state                             # 004e23b3
    # block 0x004e23b5: this+0xe2 != 0: if state == 3 skip to kind0_after_state (je)
    mov edx, dword ptr [ebp - local_this]           # 004e23b5
    cmp dword ptr [edx + btn_state], 0x3          # 004e23b8
    je.d8 kind0_after_state                             # 004e23bc
    # block 0x004e23be: this+0xe2 != 0 and state != 3: state (this+0x30) = 1
    mov eax, dword ptr [ebp - local_this]           # 004e23be
    mov dword ptr [eax + btn_state], 0x1          # 004e23c1
kind0_after_state:
    # block 0x004e23c8: kind0_after_state: if this+0xe6 == 0 skip the cursor publication to kind0_return_1 (je)
    mov ecx, dword ptr [ebp - local_this]           # 004e23c8
    cmp dword ptr [ecx + btn_cursor_flag], 0x0          # 004e23cb
    je.d8 kind0_return_1                             # 004e23d2
    # block 0x004e23d4: kind 0 hit with this+0xe6 != 0: sets the cursor selection globals: 0x5c39e5 = 0x27d8, 0x5b44f4 = 1, 0x5d1631 = 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4), 0x5d1639 = 1
    mov dword ptr [0x5c39e5], 0x27d8             # 004e23d4
    mov dword ptr [0x5b44f4], 0x1                # 004e23de
    mov edx, dword ptr [0x5b44f0]                # 004e23e8
    shl edx, 0x5                                 # 004e23ee
    mov eax, dword ptr [0x5b44f4]                # 004e23f1
    shl eax, 0x4                                 # 004e23f6
    lea ecx, [edx + eax + 0x5b160c]              # 004e23f9
    mov dword ptr [0x5d1631], ecx                # 004e2400
    mov dword ptr [0x5d1639], 0x1                # 004e2406
kind0_return_1:
    # block 0x004e2410: kind0_return_1: eax = 1 and jump to the epilogue
    mov eax, 0x1                                 # 004e2410
    jmp.d32 epilogue                           # 004e2415
kind0_miss:
    # block 0x004e241a: kind0_miss: if state != 1 go to kind0_miss_done (jne)
    mov edx, dword ptr [ebp - local_this]           # 004e241a
    cmp dword ptr [edx + btn_state], 0x1          # 004e241d
    jne.d8 kind0_miss_done                            # 004e2421
    # block 0x004e2423: kind 0 miss in state 1: state (this+0x30) = 0
    mov eax, dword ptr [ebp - local_this]           # 004e2423
    mov dword ptr [eax + btn_state], 0x0          # 004e2426
kind0_miss_done:
    # block 0x004e242d: kind0_miss_done: jump to return_0
    jmp.d32 return_0                           # 004e242d
kind1_state_gate:
    # block 0x004e2432: kind1_state_gate: if state (this+0x30) == 0 go to kind1_rect_test (je)
    mov ecx, dword ptr [ebp - local_this]           # 004e2432
    cmp dword ptr [ecx + btn_state], 0x0          # 004e2435
    je.d8 kind1_rect_test                             # 004e2439
    # block 0x004e243b: kind 1: if state == 1 go to kind1_rect_test (je)
    mov edx, dword ptr [ebp - local_this]           # 004e243b
    cmp dword ptr [edx + btn_state], 0x1          # 004e243e
    je.d8 kind1_rect_test                             # 004e2442
    # block 0x004e2444: kind 1: state not in {0,1,2}: if state != 2 return 0 (jne to return_0), state 2 falls into the rectangle test
    mov eax, dword ptr [ebp - local_this]           # 004e2444
    cmp dword ptr [eax + btn_state], 0x2          # 004e2447
    jne.d32 return_0                           # 004e244b
kind1_rect_test:
    # block 0x004e2451: kind1_rect_test: y = sign-extended arg_y, if y < this+0x08 (top) it is a miss (jl signed)
    movsx ecx, word ptr [ebp + arg_y]            # 004e2451
    mov edx, dword ptr [ebp - local_this]           # 004e2455
    cmp ecx, dword ptr [edx + btn_top]           # 004e2458
    jl.d32 kind1_miss                            # 004e245b
    # block 0x004e2461: y > this+0x10 (bottom) is a miss (jg signed)
    movsx eax, word ptr [ebp + arg_y]            # 004e2461
    mov ecx, dword ptr [ebp - local_this]           # 004e2465
    cmp eax, dword ptr [ecx + btn_bottom]          # 004e2468
    jg.d32 kind1_miss                            # 004e246b
    # block 0x004e2471: x = sign-extended arg_x, if x < this+0x04 (left) it is a miss (jl signed)
    movsx edx, word ptr [ebp + arg_x]            # 004e2471
    mov eax, dword ptr [ebp - local_this]           # 004e2475
    cmp edx, dword ptr [eax + btn_left]           # 004e2478
    jl.d8 kind1_miss                             # 004e247b
    # block 0x004e247d: x > this+0x0c (right) is a miss (jg signed), otherwise the point is inside the inclusive rectangle
    movsx ecx, word ptr [ebp + arg_x]            # 004e247d
    mov edx, dword ptr [ebp - local_this]           # 004e2481
    cmp ecx, dword ptr [edx + btn_right]           # 004e2484
    jg.d8 kind1_miss                             # 004e2487
    # block 0x004e2489: kind 1 hit: this+0x183 = 1, then if this+0xe2 == 0 skip to kind1_after_state (je)
    mov eax, dword ptr [ebp - local_this]           # 004e2489
    mov dword ptr [eax + btn_hit_result], 0x1         # 004e248c
    mov ecx, dword ptr [ebp - local_this]           # 004e2496
    cmp dword ptr [ecx + btn_hover_flag], 0x0          # 004e2499
    je.d8 kind1_after_state                             # 004e24a0
    # block 0x004e24a2: this+0xe2 != 0: state (this+0x30) = 1 (no state 3 exemption in kind 1)
    mov edx, dword ptr [ebp - local_this]           # 004e24a2
    mov dword ptr [edx + btn_state], 0x1          # 004e24a5
kind1_after_state:
    # block 0x004e24ac: kind1_after_state: if this+0xe6 == 0 skip the cursor publication to kind1_return_1 (je)
    mov eax, dword ptr [ebp - local_this]           # 004e24ac
    cmp dword ptr [eax + btn_cursor_flag], 0x0          # 004e24af
    je.d8 kind1_return_1                             # 004e24b6
    # block 0x004e24b8: kind 1 hit with this+0xe6 != 0: sets the cursor selection globals: 0x5c39e5 = 0x27d8, 0x5b44f4 = 1, 0x5d1631 = 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4), 0x5d1639 = 1
    mov dword ptr [0x5c39e5], 0x27d8             # 004e24b8
    mov dword ptr [0x5b44f4], 0x1                # 004e24c2
    mov ecx, dword ptr [0x5b44f0]                # 004e24cc
    shl ecx, 0x5                                 # 004e24d2
    mov edx, dword ptr [0x5b44f4]                # 004e24d5
    shl edx, 0x4                                 # 004e24db
    lea eax, [ecx + edx + 0x5b160c]              # 004e24de
    mov dword ptr [0x5d1631], eax                # 004e24e5
    mov dword ptr [0x5d1639], 0x1                # 004e24ea
kind1_return_1:
    # block 0x004e24f4: kind1_return_1: eax = 1 and jump to the epilogue
    mov eax, 0x1                                 # 004e24f4
    jmp.d8 epilogue                            # 004e24f9
kind1_miss:
    # block 0x004e24fb: kind1_miss: if this+0x1c == 0 go to kind1_miss_state_2 (je)
    mov ecx, dword ptr [ebp - local_this]           # 004e24fb
    cmp dword ptr [ecx + btn_miss_flag], 0x0          # 004e24fe
    je.d8 kind1_miss_state_2                             # 004e2502
    # block 0x004e2504: kind 1 miss with this+0x1c != 0: state (this+0x30) = 0 and go to return_0
    mov edx, dword ptr [ebp - local_this]           # 004e2504
    mov dword ptr [edx + btn_state], 0x0          # 004e2507
    jmp.d8 return_0                            # 004e250e
kind1_miss_state_2:
    # block 0x004e2510: kind1_miss_state_2: state (this+0x30) = 2
    mov eax, dword ptr [ebp - local_this]           # 004e2510
    mov dword ptr [eax + btn_state], 0x2          # 004e2513
return_0:
    # block 0x004e251a: return_0: eax = 0 (xor eax, eax)
    {load} xor eax, eax                          # 004e251a
epilogue:
    # block 0x004e251c: epilogue: restore frame and return, ret 8 pops the two stack arguments
    {load} mov esp, ebp                          # 004e251c
    pop ebp                                      # 004e251e
    ret 0x8                                      # 004e251f
