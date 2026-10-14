# FUN_00470ffe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470ffe
# extent:       0x00470ffe-0x004712b0 (690 code bytes)
# span:         0x00470ffe-0x004712b0 (code 690, tables 0, padding 0)
# sha256:       1a99ab253749788c02e0224f889d8dfcdf2d74f3b92e0989721b5121733255f9
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# name:         HotspotPanel::hit_test_pointer
# arguments:    thiscall: ecx=this (spilled to local_this; the one caller, 0x004f0e6d, passes the constant 0x0062387c); [ebp+8]=arg_ptr_x int16 (read with movsx, caller pushes the word at pointer+0x5e), [ebp+0xc]=arg_ptr_y int16 (caller pushes the word at pointer+0x5a); callee pops 8 (ret 8); returns eax=1 on a hit (event request globals written) or eax=0 on a miss (this+0xd2a set to 0xffff)
# locals:       frame 0xc bytes: local_payload [ebp-4] = dword loaded from [0x5bb5e5 + int16(this+0xd28) * 0x8d] (the payload pointer of action slot this+0x1e, slot base 0x5bb5e3 + slot*0x8d + 2, layout per action type; region is a label); local_slot [ebp-8] = int16 loop index over the this+0x65c rectangle array (16-bit increment, signed compare against int16 [payload+0x21]); local_this [ebp-0xc] = this spilled from ecx
# fields:       this+0xd28: int16 action slot index (table at 0x5bb5e5: the payload pointer at slot+2, stride 0x8d); this+0xd3e: byte, zero means no hit is possible (zero-extended, tested for zero); this+0xd3b: byte, non-zero suppresses the slot rectangles and the extra rectangle; this+0xd2a: int16, written with the hit slot, 0x28 for the extra rectangle, or 0xffff on a miss; this+0x65c+16*slot: four dwords x_min,y_min,x_max,y_max (+0x65c,+0x660,+0x664,+0x668 compared as signed 32-bit); payload+0xfc,+0x100,+0x104,+0x108: dwords x_min,y_min,x_max,y_max of the whole-region rectangle; payload+0x21: int16 slot count; payload+0x24: byte flag enabling the extra rectangle; payload+0x35,+0x39,+0x3d,+0x41: dwords x_min,y_min,x_max,y_max of the extra rectangle (unaligned dword reads); globals: 0x005b44f0 (dword, set to 9 or 0x16), 0x005b44f4 (dword, set to 1), 0x005d0377 (dword read), 0x005d162d (dword, written with the value of 0x5d0377), 0x005d1631 (dword pointer, written 0x5b160c + 32*[0x5b44f0] + 16*[0x5b44f4], i.e. 0x5b173c or 0x5b18dc), 0x005d1639 (dword, set to 1), 0x005c39e5 (dword; s0-action-runtime-trace.md: pending event/hotspot index; Track N caption_lifecycle.h: slider_cursor_scene; here it receives 0x27ad or 0x27a6, role not established), table base 0x005bb5e5 (stride 0x8d)
# callees:      none
# track-n:      host-adapter: none
# unverified:   No Track N source covers this routine. The x/y labelling of the two arguments comes from the caller bytes (0x4f0e5b..0x4f0e67 push the word at pointer+0x5a first, then the word at pointer+0x5e) and from outputs/blackmoor-decomp/s0-action-runtime-trace.md, which calls +0x5e the pointer X and +0x5a the pointer Y; the compare order here (arg_ptr_y against the +0x100/+0x108 dwords, arg_ptr_x against +0xfc/+0x104) matches that, but what the object at 0x62387c is, what the payload pointer at [0x5bb5e5 + index*0x8d] points to (layout per action type), and what the 16-byte rectangles at this+0x65c are for are not established by the bytes: HotspotPanel, the rectangle and field names are my labels. Every rectangle test is inclusive on both ends and uses signed compares (jl/jg after movsx). Meaning of the event codes 0x27ad and 0x27a6 is not established. 0x5d162d, 0x5d1631 and 0x5d1639 are fields +8, +0xc and +0x14 of entry 2 of the render layer table 0x5d1591 (stride 0x4a, 0x5d1591 + 2*0x4a = 0x5d1625), per tests/caption_lifecycle_original_oracle.py:56-57 (the same reading as in FUN_004462d3); 0x5b44f0 and 0x5b44f4 are Track N's cursor_type and cursor_variant labels (src/caption_lifecycle.h, not proven); 0x5c39e5 matches the pending-event index of the input path described in s0-action-runtime-trace.md but that link was not traced here. The sequence that rebuilds 0x5d1631 re-reads 0x5b44f0 and 0x5b44f4 right after storing them; the constants 0x5b173c and 0x5b18dc are derived by me from that arithmetic, not read. Unsafe original behaviour: no bounds check on the action slot index (int16 times 0x8d), on the slot count against the capacity of the rectangle array at this+0x65c, or on the payload pointer being non-null; a native port must reject out-of-range index, count and null pointer explicitly. The whole-region rectangle is tested before this+0xd3b is read, so this+0xd3b only suppresses the slot and extra-rectangle hits. This+0xd2a is not written on the whole-region hit path.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_payload, 0x4  # [ebp - 0x4]: payload pointer of action slot this+0x1e (a region, label), loaded from [0x5bb5e5 + this_slot_index*0x8d]
.equ local_slot, 0x8  # [ebp - 0x8]: int16 slot loop index (increment done as a 16-bit add)
.equ local_this, 0xc  # [ebp - 0xc]: this, spilled from ecx
.equ arg_ptr_x, 0x8  # [ebp + 0x8]: int16 pointer X (caller pushes word at pointer+0x5e)
.equ arg_ptr_y, 0xc  # [ebp + 0xc]: int16 pointer Y (caller pushes word at pointer+0x5a)
.equ rec_slot_count, 0x21  # payload+0x21: int16 number of slot rectangles to test
.equ rec_extra_enabled, 0x24  # payload+0x24: byte, non-zero enables the extra rectangle
.equ rec_extra_x_min, 0x35  # payload+0x35: dword x_min of the extra rectangle (unaligned)
.equ rec_extra_y_min, 0x39  # payload+0x39: dword y_min of the extra rectangle (unaligned)
.equ rec_extra_x_max, 0x3d  # payload+0x3d: dword x_max of the extra rectangle (unaligned)
.equ rec_extra_y_max, 0x41  # payload+0x41: dword y_max of the extra rectangle (unaligned)
.equ rec_x_min, 0xfc  # payload+0xfc: dword x_min of the whole-region rectangle
.equ rec_y_min, 0x100  # payload+0x100: dword y_min of the whole-region rectangle
.equ rec_x_max, 0x104  # payload+0x104: dword x_max of the whole-region rectangle
.equ rec_y_max, 0x108  # payload+0x108: dword y_max of the whole-region rectangle
.equ this_slot_x_min, 0x65c  # this+0x65c (+16*slot): dword x_min of slot rectangle
.equ this_slot_y_min, 0x660  # this+0x660 (+16*slot): dword y_min of slot rectangle
.equ this_slot_x_max, 0x664  # this+0x664 (+16*slot): dword x_max of slot rectangle
.equ this_slot_y_max, 0x668  # this+0x668 (+16*slot): dword y_max of slot rectangle
.equ this_slot_index, 0xd28  # this+0xd28: int16 action slot index into the payload pointer table at 0x5bb5e5 (stride 0x8d)
.equ this_hit_slot, 0xd2a  # this+0xd2a: int16 hit slot, 0x28 for the extra rectangle, 0xffff for no hit
.equ this_suppress_flag, 0xd3b  # this+0xd3b: byte, non-zero suppresses slot and extra-rectangle hits
.equ this_active_flag, 0xd3e  # this+0xd3e: byte, zero means no hit possible

# --- external targets -----------------------------------------------

.org 0x00470ffe - 0x401000
.globl FUN_00470ffe
FUN_00470ffe:
    # block 0x00470ffe: entry: spill this, local_payload = dword [0x5bb5e5 + int16 this_slot_index * 0x8d]; zero-extend byte this_active_flag; if it is zero jump to L_miss
    push ebp                                     # 00470ffe
    {load} mov ebp, esp                          # 00470fff
    sub esp, 0xc                                 # 00471001
    mov dword ptr [ebp - local_this], ecx           # 00471004
    mov eax, dword ptr [ebp - local_this]           # 00471007
    movsx ecx, word ptr [eax + this_slot_index]        # 0047100a
    imul ecx, ecx, 0x8d                          # 00471011
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00471017
    mov dword ptr [ebp - local_payload], edx           # 0047101d
    mov eax, dword ptr [ebp - local_this]           # 00471020
    {load} xor ecx, ecx                          # 00471023
    mov cl, byte ptr [eax + this_active_flag]           # 00471025
    test ecx, ecx                                # 0047102b
    je.d32 L_miss                            # 0047102d
    # block 0x00471033: whole-region test 1: if signed arg_ptr_y < dword rec_y_min jump to L_slot_loop_init (jl)
    movsx edx, word ptr [ebp + arg_ptr_y]            # 00471033
    mov eax, dword ptr [ebp - local_payload]           # 00471037
    cmp edx, dword ptr [eax + rec_y_min]         # 0047103a
    jl.d32 L_slot_loop_init                            # 00471040
    # block 0x00471046: whole-region test 2: if signed arg_ptr_y > dword rec_y_max jump to L_slot_loop_init (jg)
    movsx ecx, word ptr [ebp + arg_ptr_y]            # 00471046
    mov edx, dword ptr [ebp - local_payload]           # 0047104a
    cmp ecx, dword ptr [edx + rec_y_max]         # 0047104d
    jg.d8 L_slot_loop_init                             # 00471053
    # block 0x00471055: whole-region test 3: if signed arg_ptr_x < dword rec_x_min jump to L_slot_loop_init (jl)
    movsx eax, word ptr [ebp + arg_ptr_x]            # 00471055
    mov ecx, dword ptr [ebp - local_payload]           # 00471059
    cmp eax, dword ptr [ecx + rec_x_min]          # 0047105c
    jl.d8 L_slot_loop_init                             # 00471062
    # block 0x00471064: whole-region test 4: if signed arg_ptr_x > dword rec_x_max jump to L_slot_loop_init (jg)
    movsx edx, word ptr [ebp + arg_ptr_x]            # 00471064
    mov eax, dword ptr [ebp - local_payload]           # 00471068
    cmp edx, dword ptr [eax + rec_x_max]         # 0047106b
    jg.d8 L_slot_loop_init                             # 00471071
    # block 0x00471073: whole-region hit: sets globals [0x5b44f0]=9, [0x5b44f4]=1, [0x5d162d]=[0x5d0377], [0x5d1631]=0x5b160c+32*[0x5b44f0]+16*[0x5b44f4] (re-read from the globals just stored), [0x5d1639]=1, [0x5c39e5]=0x27ad; return eax=1 (this_hit_slot untouched)
    mov dword ptr [0x5b44f0], 0x9                # 00471073
    mov dword ptr [0x5b44f4], 0x1                # 0047107d
    mov ecx, dword ptr [0x5d0377]                # 00471087
    mov dword ptr [0x5d162d], ecx                # 0047108d
    mov edx, dword ptr [0x5b44f0]                # 00471093
    shl edx, 0x5                                 # 00471099
    mov eax, dword ptr [0x5b44f4]                # 0047109c
    shl eax, 0x4                                 # 004710a1
    lea ecx, [edx + eax + 0x5b160c]              # 004710a4
    mov dword ptr [0x5d1631], ecx                # 004710ab
    mov dword ptr [0x5d1639], 0x1                # 004710b1
    mov dword ptr [0x5c39e5], 0x27ad             # 004710bb
    mov eax, 0x1                                 # 004710c5
    jmp.d32 L_return                           # 004710ca
L_slot_loop_init:
    # block 0x004710cf: slot loop start (L_slot_loop_init): local_slot (int16) = 0, jump to the loop test
    mov word ptr [ebp - local_slot], 0x0            # 004710cf
    jmp.d8 L_slot_loop_test                            # 004710d5
L_slot_next:
    # block 0x004710d7: slot loop step: local_slot = local_slot + 1 as a 16-bit add
    mov dx, word ptr [ebp - local_slot]             # 004710d7
    add dx, 0x1                                  # 004710db
    mov word ptr [ebp - local_slot], dx             # 004710df
L_slot_loop_test:
    # block 0x004710e3: slot loop test: if signed local_slot >= signed int16 rec_slot_count leave the loop to L_after_slots (jge)
    movsx eax, word ptr [ebp - local_slot]          # 004710e3
    mov ecx, dword ptr [ebp - local_payload]           # 004710e7
    movsx edx, word ptr [ecx + rec_slot_count]         # 004710ea
    {load} cmp eax, edx                          # 004710ee
    jge.d32 L_after_slots                           # 004710f0
    # block 0x004710f6: slot gate: zero-extend byte this_suppress_flag; if non-zero skip this slot (jne to L_slot_continue)
    mov eax, dword ptr [ebp - local_this]           # 004710f6
    {load} xor ecx, ecx                          # 004710f9
    mov cl, byte ptr [eax + this_suppress_flag]           # 004710fb
    test ecx, ecx                                # 00471101
    jne.d32 L_slot_continue                           # 00471103
    # block 0x00471109: slot test 1: if signed arg_ptr_y < dword this_slot_y_min of rect[local_slot] (this + local_slot*16) skip slot (jl)
    movsx edx, word ptr [ebp + arg_ptr_y]            # 00471109
    movsx eax, word ptr [ebp - local_slot]          # 0047110d
    shl eax, 0x4                                 # 00471111
    mov ecx, dword ptr [ebp - local_this]           # 00471114
    cmp edx, dword ptr [ecx + eax + this_slot_y_min]   # 00471117
    jl.d32 L_slot_continue                            # 0047111e
    # block 0x00471124: slot test 2: if signed arg_ptr_y > dword this_slot_y_max of rect[local_slot] skip slot (jg)
    movsx edx, word ptr [ebp + arg_ptr_y]            # 00471124
    movsx eax, word ptr [ebp - local_slot]          # 00471128
    shl eax, 0x4                                 # 0047112c
    mov ecx, dword ptr [ebp - local_this]           # 0047112f
    cmp edx, dword ptr [ecx + eax + this_slot_y_max]   # 00471132
    jg.d32 L_slot_continue                            # 00471139
    # block 0x0047113f: slot test 3: if signed arg_ptr_x < dword this_slot_x_min of rect[local_slot] skip slot (jl)
    movsx edx, word ptr [ebp + arg_ptr_x]            # 0047113f
    movsx eax, word ptr [ebp - local_slot]          # 00471143
    shl eax, 0x4                                 # 00471147
    mov ecx, dword ptr [ebp - local_this]           # 0047114a
    cmp edx, dword ptr [ecx + eax + this_slot_x_min]   # 0047114d
    jl.d32 L_slot_continue                            # 00471154
    # block 0x0047115a: slot test 4: if signed arg_ptr_x > dword this_slot_x_max of rect[local_slot] skip slot (jg)
    movsx edx, word ptr [ebp + arg_ptr_x]            # 0047115a
    movsx eax, word ptr [ebp - local_slot]          # 0047115e
    shl eax, 0x4                                 # 00471162
    mov ecx, dword ptr [ebp - local_this]           # 00471165
    cmp edx, dword ptr [ecx + eax + this_slot_x_max]   # 00471168
    jg.d8 L_slot_continue                             # 0047116f
    # block 0x00471171: slot hit: sets globals [0x5b44f0]=0x16, [0x5b44f4]=1, [0x5d162d]=[0x5d0377], [0x5d1631]=0x5b160c+32*[0x5b44f0]+16*[0x5b44f4] (re-read from the globals just stored), [0x5d1639]=1, [0x5c39e5]=0x27a6; this_hit_slot = local_slot (16-bit store); return eax=1
    mov dword ptr [0x5b44f0], 0x16               # 00471171
    mov dword ptr [0x5b44f4], 0x1                # 0047117b
    mov edx, dword ptr [0x5d0377]                # 00471185
    mov dword ptr [0x5d162d], edx                # 0047118b
    mov eax, dword ptr [0x5b44f0]                # 00471191
    shl eax, 0x5                                 # 00471196
    mov ecx, dword ptr [0x5b44f4]                # 00471199
    shl ecx, 0x4                                 # 0047119f
    lea edx, [eax + ecx + 0x5b160c]              # 004711a2
    mov dword ptr [0x5d1631], edx                # 004711a9
    mov dword ptr [0x5d1639], 0x1                # 004711af
    mov dword ptr [0x5c39e5], 0x27a6             # 004711b9
    mov eax, dword ptr [ebp - local_this]           # 004711c3
    mov cx, word ptr [ebp - local_slot]             # 004711c6
    mov word ptr [eax + this_hit_slot], cx           # 004711ca
    mov eax, 0x1                                 # 004711d1
    jmp.d32 L_return                           # 004711d6
L_slot_continue:
    # block 0x004711db: slot skipped or missed: jump back to the loop step
    jmp.d32 L_slot_next                           # 004711db
L_after_slots:
    # block 0x004711e0: after the slot loop: if byte this_suppress_flag is non-zero go to L_miss (jne)
    mov edx, dword ptr [ebp - local_this]           # 004711e0
    {load} xor eax, eax                          # 004711e3
    mov al, byte ptr [edx + this_suppress_flag]           # 004711e5
    test eax, eax                                # 004711eb
    jne.d32 L_miss                           # 004711ed
    # block 0x004711f3: extra rectangle gate: if byte rec_extra_enabled is zero go to L_miss (je)
    mov ecx, dword ptr [ebp - local_payload]           # 004711f3
    {load} xor edx, edx                          # 004711f6
    mov dl, byte ptr [ecx + rec_extra_enabled]            # 004711f8
    test edx, edx                                # 004711fb
    je.d32 L_miss                            # 004711fd
    # block 0x00471203: extra test 1: if signed arg_ptr_y < dword rec_extra_y_min go to L_miss (jl)
    movsx eax, word ptr [ebp + arg_ptr_y]            # 00471203
    mov ecx, dword ptr [ebp - local_payload]           # 00471207
    cmp eax, dword ptr [ecx + rec_extra_y_min]          # 0047120a
    jl.d32 L_miss                            # 0047120d
    # block 0x00471213: extra test 2: if signed arg_ptr_y > dword rec_extra_y_max go to L_miss (jg)
    movsx edx, word ptr [ebp + arg_ptr_y]            # 00471213
    mov eax, dword ptr [ebp - local_payload]           # 00471217
    cmp edx, dword ptr [eax + rec_extra_y_max]          # 0047121a
    jg.d8 L_miss                             # 0047121d
    # block 0x0047121f: extra test 3: if signed arg_ptr_x < dword rec_extra_x_min go to L_miss (jl)
    movsx ecx, word ptr [ebp + arg_ptr_x]            # 0047121f
    mov edx, dword ptr [ebp - local_payload]           # 00471223
    cmp ecx, dword ptr [edx + rec_extra_x_min]          # 00471226
    jl.d8 L_miss                             # 00471229
    # block 0x0047122b: extra test 4: if signed arg_ptr_x > dword rec_extra_x_max go to L_miss (jg)
    movsx eax, word ptr [ebp + arg_ptr_x]            # 0047122b
    mov ecx, dword ptr [ebp - local_payload]           # 0047122f
    cmp eax, dword ptr [ecx + rec_extra_x_max]          # 00471232
    jg.d8 L_miss                             # 00471235
    # block 0x00471237: extra rectangle hit: sets globals [0x5b44f0]=0x16, [0x5b44f4]=1, [0x5d162d]=[0x5d0377], [0x5d1631]=0x5b160c+32*[0x5b44f0]+16*[0x5b44f4] (re-read from the globals just stored), [0x5d1639]=1, [0x5c39e5]=0x27a6; this_hit_slot = 0x28; return eax=1
    mov dword ptr [0x5b44f0], 0x16               # 00471237
    mov dword ptr [0x5b44f4], 0x1                # 00471241
    mov edx, dword ptr [0x5d0377]                # 0047124b
    mov dword ptr [0x5d162d], edx                # 00471251
    mov eax, dword ptr [0x5b44f0]                # 00471257
    shl eax, 0x5                                 # 0047125c
    mov ecx, dword ptr [0x5b44f4]                # 0047125f
    shl ecx, 0x4                                 # 00471265
    lea edx, [eax + ecx + 0x5b160c]              # 00471268
    mov dword ptr [0x5d1631], edx                # 0047126f
    mov dword ptr [0x5d1639], 0x1                # 00471275
    mov dword ptr [0x5c39e5], 0x27a6             # 0047127f
    mov eax, dword ptr [ebp - local_this]           # 00471289
    mov word ptr [eax + this_hit_slot], 0x28         # 0047128c
    mov eax, 0x1                                 # 00471295
    jmp.d8 L_return                            # 0047129a
L_miss:
    # block 0x0047129c: miss (L_miss): this_hit_slot = 0xffff (16-bit store), eax = 0
    mov ecx, dword ptr [ebp - local_this]           # 0047129c
    mov word ptr [ecx + this_hit_slot], 0xffff       # 0047129f
    {load} xor eax, eax                          # 004712a8
L_return:
    # block 0x004712aa: shared epilogue: restore the frame and return, callee pops the two arguments (ret 8)
    {load} mov esp, ebp                          # 004712aa
    pop ebp                                      # 004712ac
    ret 0x8                                      # 004712ad
