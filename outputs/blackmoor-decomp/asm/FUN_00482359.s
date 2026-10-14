# FUN_00482359
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00482359
# extent:       0x00482359-0x00482595 (572 code bytes)
# span:         0x00482359-0x00482595 (code 572, tables 0, padding 0)
# sha256:       286336193b807c5d9ec13efb771848e456ca7cc54e5429dd0759305536c8e4f7
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# name:         PointerHitTest::hit_test_action_rects
# arguments:    thiscall, stdcall-style stack cleanup: ecx=this; [ebp+8] = x (signed 16-bit read, movsx of the low word of the dword slot); [ebp+0xc] = y (signed 16-bit read); callee pops both with ret 0x8; returns eax = 1 when a rectangle was hit (cursor globals set), else eax = 0
# locals:       [ebp-local_this] = this (spilled from ecx); [ebp-local_payload] = dword read from the action-slot table: *(0x005bb5e5 + (signed word this+0x1e) * 0x8d), i.e. the payload pointer of the action slot this object refers to; [ebp-local_rect_index] = signed 16-bit loop counter (only the low word is stored and read)
# fields:       this+0x1e word: action slot index (stride 0x8d, table base 0x5bb5e5 = slot+2 payload pointer); this+0xa8 byte: gate, the routine returns 0 when it is zero; this+0x91 byte and this+0x92 word: both zero together suppress a hit on rectangle pay_sel_c; this+0xad word: written with the hit rectangle index on a rectangle hit. Payload fields (via the slot payload pointer): +0xfc word rectangle count; rectangle array at +0x23e (left), +0x242 (top), +0x246 (right), +0x24a (bottom) as signed dwords with stride 0x10; +0x39e, +0x3a0, +0x3a2 words rectangle indices; +0x86c/+0x870/+0x874/+0x878 dwords (left/top/right/bottom of one extra rectangle); +0x87c word. Globals written: 0x005b44f0 (cursor type: 0x16 or 9), 0x005b44f4 (cursor variant: 1), 0x005d162d (copy of the dword at 0x005d0377), 0x005d1631 (address 0x005b160c + type*0x20 + variant*0x10: 0x5b18dc for type 0x16, 0x5b173c for type 9), 0x005d1639 (1), 0x005c39e5 (0x27b5 for a list rectangle hit, 0x27b6 for the extra rectangle). Globals read: 0x005b44f0, 0x005b44f4 (re-read right after being stored), 0x005d0377. Table base 0x005bb5e5 is read only.
# callees:      none
# track-n:      host-adapter: none
# unverified:   Class and method name are my labels; the bytes only show a thiscall method that takes a point and tests it against rectangles read from a slot payload. Its single caller in the indexed code is the pointer hit-test chain in FUN_004f0059 (from its unverified pseudocode; the call site was not re-read in the bytes), which passes the words at its this+0x5e (x) and this+0x5a (y); argument order x then y therefore rests on that pseudocode plus the comparison targets (the first argument is compared with the +0x23e/+0x246 pair, the second with +0x242/+0x24a), and on s0-action-runtime-trace.md for the x/y slots of the other hit tests. The rectangle edge order (left, top, right, bottom at +0x23e, +0x242, +0x246, +0x24a) is inferred from which argument each pair is compared with, not from field names. Meaning of this+0x91, this+0x92, this+0xa8 and of the payload words +0x39e, +0x3a0, +0x3a2, +0x87c is not established; only the comparisons they take part in are. Globals named by caption_lifecycle.h (cursor type 0x5b44f0, variant 0x5b44f4, surface 0x5d162d, default surface 0x5d0377, source index 0x5d1631, layer enabled 0x5d1639, 0x5c39e5 = slider_cursor_scene) are Track N labels; this routine only stores the values listed. The values 0x27b5 and 0x27b6 written to 0x5c39e5 are literals whose meaning to the readers of 0x5c39e5 is not established here. Behaviour when the rectangle count is negative or the slot index is out of range is not guarded in the original (the table read has no bound check); the native port must reject it explicitly.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_payload, 0x4  # [ebp - 0x4]: payload pointer of the action slot (*(0x5bb5e5 + slot*0x8d))
.equ local_rect_index, 0x8  # [ebp - 0x8]: signed 16-bit rectangle loop counter (word)
.equ local_this, 0xc  # [ebp - 0xc]: this, spilled from ecx
.equ arg_x, 0x8  # [ebp + 0x8]: x coordinate (low word, signed)
.equ arg_y, 0xc  # [ebp + 0xc]: y coordinate (low word, signed)

# --- fields of this (ecx) ----------------------------------------------
.equ obj_slot_index, 0x1e  # this+0x1e: signed word, index into the 0x8d-stride action slot table
.equ obj_flag_91, 0x91  # this+0x91: byte, zero test only (use not established)
.equ obj_word_92, 0x92  # this+0x92: signed word, zero test only (use not established)
.equ obj_gate_a8, 0xa8  # this+0xa8: byte, routine returns 0 when it is zero
.equ obj_hit_index_ad, 0xad  # this+0xad: word, receives the hit rectangle index

# --- fields of the slot payload (local_payload) --------------------------
.equ pay_rect_count, 0xfc  # payload+0xfc: signed word, number of rectangles in the array
.equ pay_rect_left, 0x23e  # payload+0x23e+i*0x10: dword, x lower bound (compared with arg_x, inclusive)
.equ pay_rect_top, 0x242  # payload+0x242+i*0x10: dword, y lower bound (compared with arg_y, inclusive)
.equ pay_rect_right, 0x246  # payload+0x246+i*0x10: dword, x upper bound (inclusive)
.equ pay_rect_bottom, 0x24a  # payload+0x24a+i*0x10: dword, y upper bound (inclusive)
.equ pay_sel_a, 0x39e  # payload+0x39e: signed word, rectangle index compared with the loop index
.equ pay_sel_b, 0x3a0  # payload+0x3a0: signed word, rectangle index compared with the loop index
.equ pay_sel_c, 0x3a2  # payload+0x3a2: signed word, rectangle index compared with the loop index
.equ pay_extra_left, 0x86c  # payload+0x86c: dword, extra rectangle x lower bound
.equ pay_extra_top, 0x870  # payload+0x870: dword, extra rectangle y lower bound
.equ pay_extra_right, 0x874  # payload+0x874: dword, extra rectangle x upper bound
.equ pay_extra_bottom, 0x878  # payload+0x878: dword, extra rectangle y upper bound
.equ pay_mode_87c, 0x87c  # payload+0x87c: signed word, compared with 1

# --- external targets -----------------------------------------------

.org 0x00482359 - 0x401000
.globl FUN_00482359
FUN_00482359:
    # block 0x00482359: entry: spill this, load the slot payload pointer from 0x5bb5e5 + (signed word this+0x1e)*0x8d into local_payload, test this+0xa8 byte; if it is zero jump to return_zero (je)
    push ebp                                     # 00482359
    {load} mov ebp, esp                          # 0048235a
    sub esp, 0xc                                 # 0048235c
    mov dword ptr [ebp - local_this], ecx           # 0048235f
    mov eax, dword ptr [ebp - local_this]           # 00482362
    movsx ecx, word ptr [eax + obj_slot_index]         # 00482365
    imul ecx, ecx, 0x8d                          # 00482369
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048236f
    mov dword ptr [ebp - local_payload], edx           # 00482375
    mov eax, dword ptr [ebp - local_this]           # 00482378
    {load} xor ecx, ecx                          # 0048237b
    mov cl, byte ptr [eax + obj_gate_a8]            # 0048237d
    test ecx, ecx                                # 00482383
    je.d32 return_zero                            # 00482385
    # block 0x0048238b: gate set: rectangle index = 0, jump to loop_test
    mov word ptr [ebp - local_rect_index], 0x0            # 0048238b
    jmp.d8 loop_test                            # 00482391
loop_next_index:
    # block 0x00482393: loop increment: rectangle index = (word) index + 1
    mov dx, word ptr [ebp - local_rect_index]             # 00482393
    add dx, 0x1                                  # 00482397
    mov word ptr [ebp - local_rect_index], dx             # 0048239b
loop_test:
    # block 0x0048239f: loop test: sign-extend the index and the word payload+0xfc (rect count); if index >= count (jge) leave the loop for after_loop_extra_rect
    movsx eax, word ptr [ebp - local_rect_index]          # 0048239f
    mov ecx, dword ptr [ebp - local_payload]           # 004823a3
    movsx edx, word ptr [ecx + pay_rect_count]         # 004823a6
    {load} cmp eax, edx                          # 004823ad
    jge.d32 after_loop_extra_rect                           # 004823af
    # block 0x004823b5: y lower bound: if arg_y < dword rect[i].top (payload+0x242+i*0x10) skip to loop_continue (jl, signed)
    movsx eax, word ptr [ebp + arg_y]            # 004823b5
    movsx ecx, word ptr [ebp - local_rect_index]          # 004823b9
    shl ecx, 0x4                                 # 004823bd
    mov edx, dword ptr [ebp - local_payload]           # 004823c0
    cmp eax, dword ptr [edx + ecx + pay_rect_top]   # 004823c3
    jl.d32 loop_continue                            # 004823ca
    # block 0x004823d0: y upper bound: if arg_y > dword rect[i].bottom (payload+0x24a+i*0x10) skip to loop_continue (jg, signed)
    movsx eax, word ptr [ebp + arg_y]            # 004823d0
    movsx ecx, word ptr [ebp - local_rect_index]          # 004823d4
    shl ecx, 0x4                                 # 004823d8
    mov edx, dword ptr [ebp - local_payload]           # 004823db
    cmp eax, dword ptr [edx + ecx + pay_rect_bottom]   # 004823de
    jg.d32 loop_continue                            # 004823e5
    # block 0x004823eb: x lower bound: if arg_x < dword rect[i].left (payload+0x23e+i*0x10) skip to loop_continue (jl, signed)
    movsx eax, word ptr [ebp + arg_x]            # 004823eb
    movsx ecx, word ptr [ebp - local_rect_index]          # 004823ef
    shl ecx, 0x4                                 # 004823f3
    mov edx, dword ptr [ebp - local_payload]           # 004823f6
    cmp eax, dword ptr [edx + ecx + pay_rect_left]   # 004823f9
    jl.d32 loop_continue                            # 00482400
    # block 0x00482406: x upper bound: if arg_x > dword rect[i].right (payload+0x246+i*0x10) skip to loop_continue (jg, signed)
    movsx eax, word ptr [ebp + arg_x]            # 00482406
    movsx ecx, word ptr [ebp - local_rect_index]          # 0048240a
    shl ecx, 0x4                                 # 0048240e
    mov edx, dword ptr [ebp - local_payload]           # 00482411
    cmp eax, dword ptr [edx + ecx + pay_rect_right]   # 00482414
    jg.d32 loop_continue                            # 0048241b
    # block 0x00482421: point is inside rect i: if i != word payload+0x3a2 go to check_sel_ab (jne)
    movsx eax, word ptr [ebp - local_rect_index]          # 00482421
    mov ecx, dword ptr [ebp - local_payload]           # 00482425
    movsx edx, word ptr [ecx + pay_sel_c]        # 00482428
    {load} cmp eax, edx                          # 0048242f
    jne.d8 check_sel_ab                            # 00482431
    # block 0x00482433: i == payload+0x3a2: if the signed word this+0x92 is non-zero go to check_sel_ab (jne)
    mov eax, dword ptr [ebp - local_this]           # 00482433
    movsx ecx, word ptr [eax + obj_word_92]         # 00482436
    test ecx, ecx                                # 0048243d
    jne.d8 check_sel_ab                            # 0048243f
    # block 0x00482441: i == payload+0x3a2 and this+0x92 == 0: if the byte this+0x91 is zero skip this rectangle (je to loop_continue); otherwise fall into check_sel_ab
    mov edx, dword ptr [ebp - local_this]           # 00482441
    {load} xor eax, eax                          # 00482444
    mov al, byte ptr [edx + obj_flag_91]            # 00482446
    test eax, eax                                # 0048244c
    je.d32 loop_continue                            # 0048244e
check_sel_ab:
    # block 0x00482454: if i == word payload+0x39e jump to check_mode_87c (je)
    movsx ecx, word ptr [ebp - local_rect_index]          # 00482454
    mov edx, dword ptr [ebp - local_payload]           # 00482458
    movsx eax, word ptr [edx + pay_sel_a]        # 0048245b
    {load} cmp ecx, eax                          # 00482462
    je.d8 check_mode_87c                             # 00482464
    # block 0x00482466: i != payload+0x39e: if i != word payload+0x3a0 go to rect_hit (jne); otherwise fall into check_mode_87c
    movsx ecx, word ptr [ebp - local_rect_index]          # 00482466
    mov edx, dword ptr [ebp - local_payload]           # 0048246a
    movsx eax, word ptr [edx + pay_sel_b]        # 0048246d
    {load} cmp ecx, eax                          # 00482474
    jne.d8 rect_hit                            # 00482476
check_mode_87c:
    # block 0x00482478: i is payload+0x39e or payload+0x3a0: if the signed word payload+0x87c equals 1 skip this rectangle (je to loop_continue); otherwise fall into rect_hit
    mov ecx, dword ptr [ebp - local_payload]           # 00482478
    movsx edx, word ptr [ecx + pay_mode_87c]        # 0048247b
    cmp edx, 0x1                                 # 00482482
    je.d8 loop_continue                             # 00482485
rect_hit:
    # block 0x00482487: rect hit: store cursor type 0x16 to 0x5b44f0 and variant 1 to 0x5b44f4; 0x5d162d = dword at 0x5d0377; 0x5d1631 = 0x5b160c + (type<<5) + (variant<<4) (re-reading both globals, 0x5b18dc); 0x5d1639 = 1; 0x5c39e5 = 0x27b5; this+0xad = rectangle index; eax = 1; jump to epilogue
    mov dword ptr [0x5b44f0], 0x16               # 00482487
    mov dword ptr [0x5b44f4], 0x1                # 00482491
    mov eax, dword ptr [0x5d0377]                # 0048249b
    mov dword ptr [0x5d162d], eax                # 004824a0
    mov ecx, dword ptr [0x5b44f0]                # 004824a5
    shl ecx, 0x5                                 # 004824ab
    mov edx, dword ptr [0x5b44f4]                # 004824ae
    shl edx, 0x4                                 # 004824b4
    lea eax, [ecx + edx + 0x5b160c]              # 004824b7
    mov dword ptr [0x5d1631], eax                # 004824be
    mov dword ptr [0x5d1639], 0x1                # 004824c3
    mov dword ptr [0x5c39e5], 0x27b5             # 004824cd
    mov ecx, dword ptr [ebp - local_this]           # 004824d7
    mov dx, word ptr [ebp - local_rect_index]             # 004824da
    mov word ptr [ecx + obj_hit_index_ad], dx            # 004824de
    mov eax, 0x1                                 # 004824e5
    jmp.d32 epilogue                           # 004824ea
loop_continue:
    # block 0x004824ef: skipped rectangle: jump back to loop_next_index
    jmp.d32 loop_next_index                           # 004824ef
after_loop_extra_rect:
    # block 0x004824f4: after the rectangle loop: if arg_y < dword payload+0x870 return 0 (jl to return_zero, signed)
    movsx eax, word ptr [ebp + arg_y]            # 004824f4
    mov ecx, dword ptr [ebp - local_payload]           # 004824f8
    cmp eax, dword ptr [ecx + pay_extra_top]         # 004824fb
    jl.d32 return_zero                            # 00482501
    # block 0x00482507: if arg_y > dword payload+0x878 return 0 (jg to return_zero)
    movsx edx, word ptr [ebp + arg_y]            # 00482507
    mov eax, dword ptr [ebp - local_payload]           # 0048250b
    cmp edx, dword ptr [eax + pay_extra_bottom]         # 0048250e
    jg.d8 return_zero                             # 00482514
    # block 0x00482516: if arg_x < dword payload+0x86c return 0 (jl to return_zero)
    movsx ecx, word ptr [ebp + arg_x]            # 00482516
    mov edx, dword ptr [ebp - local_payload]           # 0048251a
    cmp ecx, dword ptr [edx + pay_extra_left]         # 0048251d
    jl.d8 return_zero                             # 00482523
    # block 0x00482525: if arg_x > dword payload+0x874 return 0 (jg to return_zero)
    movsx eax, word ptr [ebp + arg_x]            # 00482525
    mov ecx, dword ptr [ebp - local_payload]           # 00482529
    cmp eax, dword ptr [ecx + pay_extra_right]         # 0048252c
    jg.d8 return_zero                             # 00482532
    # block 0x00482534: extra rectangle hit: cursor type 9 to 0x5b44f0, variant 1 to 0x5b44f4; 0x5d162d = dword at 0x5d0377; 0x5d1631 = 0x5b160c + (type<<5) + (variant<<4) (0x5b173c); 0x5d1639 = 1; 0x5c39e5 = 0x27b6; eax = 1; jump to epilogue (this+0xad is not written on this path)
    mov dword ptr [0x5b44f0], 0x9                # 00482534
    mov dword ptr [0x5b44f4], 0x1                # 0048253e
    mov edx, dword ptr [0x5d0377]                # 00482548
    mov dword ptr [0x5d162d], edx                # 0048254e
    mov eax, dword ptr [0x5b44f0]                # 00482554
    shl eax, 0x5                                 # 00482559
    mov ecx, dword ptr [0x5b44f4]                # 0048255c
    shl ecx, 0x4                                 # 00482562
    lea edx, [eax + ecx + 0x5b160c]              # 00482565
    mov dword ptr [0x5d1631], edx                # 0048256c
    mov dword ptr [0x5d1639], 0x1                # 00482572
    mov dword ptr [0x5c39e5], 0x27b6             # 0048257c
    mov eax, 0x1                                 # 00482586
    jmp.d8 epilogue                            # 0048258b
return_zero:
    # block 0x0048258d: no hit: eax = 0
    {load} xor eax, eax                          # 0048258d
epilogue:
    # block 0x0048258f: epilogue: restore the frame and return, popping the two stack arguments (ret 8)
    {load} mov esp, ebp                          # 0048258f
    pop ebp                                      # 00482591
    ret 0x8                                      # 00482592
