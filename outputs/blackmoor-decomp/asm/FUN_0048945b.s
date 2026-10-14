# FUN_0048945b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048945b
# extent:       0x0048945b-0x004895cc (369 code bytes)
# span:         0x0048945b-0x004895cc (code 369, tables 0, padding 0)
# sha256:       799385eaa2201dd5e8137d0e30f1e96fe0d6a0cbaf4390fe3966bf987464f79a
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# name:         ActionFamily37::init_object_defaults
# arguments:    thiscall: ecx=this (owner object, saved at [ebp-8]); [ebp+8]=obj, the freshly zeroed 0xABA-byte action object; [ebp+0xc]=rect, pointer to four int32 words (left, top, right, bottom order as Track N reads them from body+0x25); callee pops 8 (ret 8); esi and edi are saved and restored; no return value
# locals:       frame 8 bytes: [ebp-4]=int16 loop counter i (word, signed compare against 10); [ebp-8]=saved ecx (this)
# fields:       this+0x20 (written with obj); obj+0x21 (word=2); obj+0x25 (word=2); obj+0x29 (word=1); obj+0x2b (word=1); obj+0x39 (word=0xffff); obj+0x3d (word=0x270f); obj+0x43 (word=1); obj+0x4d (dword=1); obj+0x51+4*i for i=0..9 (word=0xffff); obj+0x79 (copy of the C string "NO SOUND" at 0x0054e058 including its NUL); obj+0xaa (word=1); obj+0x6ec (word=0); obj+0x6ee (word=0); obj+0x6f0 (word=2); obj+0x6f2 (dword=0); obj+0x6f6 (dword=0); obj+0x6fa (dword = rect[2]-rect[0]); obj+0x6fe (dword = rect[3]-rect[1]); obj+0x702..0x711 (copy of the four rect dwords); reads rect[0..3]
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/action_family_37.c:initialize_original_defaults
# unverified:   meaning of the written fields (0x21/0x25/0x29 etc.) is unknown and kept neutral; rect is called fixed_rect by Track N and is read here only as four dword words; the unsigned versus signed meaning of rect values is not established (the subtractions are plain 32-bit wrap); the string at 0x54e058 was confirmed as "NO SOUND" from the owned GAME.EXE bytes; Track N initialize_original_defaults reproduces exactly these stores; the name copy and the +0x23/+0x27 option words are written in action_family_37_construct and correspond to FUN_004895cc; the null obj/rect pointer cases are not guarded in the original (callers pass valid pointers); the obj_word_* and obj_dword_* names only record offset, width and default value written, meanings are unidentified; the owner this+0x20 object named this_object_ptr holds the action object; rect_* and objrect_* name rect elements by the left, top, right, bottom order Track N assumes
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_i, 0x4  # [ebp - 0x4]
.equ local_saved_this, 0x8  # [ebp - 0x8]
.equ arg_obj, 0x8  # [ebp + 0x8]
.equ arg_rect, 0xc  # [ebp + 0xc]

.equ rect_top, 0x4  # rect (4 int32: left, top, right, bottom)+0x4: top
.equ rect_right, 0x8  # rect+0x8: right
.equ rect_bottom, 0xc  # rect+0xc: bottom
.equ objrect_top, 0x4  # action object rect copy at obj+0x702, +0x4: top (destination)
.equ objrect_right, 0x8  # action object rect copy at obj+0x702, +0x8: right (destination)
.equ objrect_bottom, 0xc  # action object rect copy at obj+0x702, +0xc: bottom (destination)
.equ this_object_ptr, 0x20  # owner object this+0x20: pointer to the action object (written with obj)
.equ obj_word_21, 0x21  # action object+0x21: word, default 2 (meaning unidentified)
.equ obj_word_25, 0x25  # action object+0x25: word, default 2 (meaning unidentified)
.equ obj_word_29, 0x29  # action object+0x29: word, default 1 (meaning unidentified)
.equ obj_word_2b, 0x2b  # action object+0x2b: word, default 1 (meaning unidentified)
.equ obj_word_39_unset, 0x39  # action object+0x39: word, default 0xffff (meaning unidentified)
.equ obj_word_3d_9999, 0x3d  # action object+0x3d: word, default 0x270f = 9999 (meaning unidentified)
.equ obj_word_43, 0x43  # action object+0x43: word, default 1 (meaning unidentified)
.equ obj_dword_4d, 0x4d  # action object+0x4d: dword, default 1 (meaning unidentified)
.equ obj_slot_array_51, 0x51  # action object+0x51: array of ten words at stride 4, default 0xffff each
.equ obj_word_aa, 0xaa  # action object+0xaa: word, default 1 (meaning unidentified)
.equ obj_word_6ec, 0x6ec  # action object+0x6ec: word, default 0 (meaning unidentified)
.equ obj_word_6ee, 0x6ee  # action object+0x6ee: word, default 0 (meaning unidentified)
.equ obj_word_6f0, 0x6f0  # action object+0x6f0: word, default 2 (meaning unidentified)
.equ obj_dword_6f2, 0x6f2  # action object+0x6f2: dword, default 0 (meaning unidentified)
.equ obj_dword_6f6, 0x6f6  # action object+0x6f6: dword, default 0 (meaning unidentified)
.equ obj_rect_width_6fa, 0x6fa  # action object+0x6fa: dword = rect right - rect left
.equ obj_rect_height_6fe, 0x6fe  # action object+0x6fe: dword = rect bottom - rect top

# --- external targets -----------------------------------------------

.org 0x0048945b - 0x401000
.globl FUN_0048945b
FUN_0048945b:
    # block 0x0048945b: prologue; save esi, edi, this; this+0x20 = obj; obj+0x25=2, +0x3d=0x270f, +0x39=0xffff, +0x21=2, +0x29=1 (words); i = 0, go to the loop test
    push ebp                                     # 0048945b
    {load} mov ebp, esp                          # 0048945c
    sub esp, 0x8                                 # 0048945e
    push esi                                     # 00489461
    push edi                                     # 00489462
    mov dword ptr [ebp - local_saved_this], ecx           # 00489463
    mov eax, dword ptr [ebp - local_saved_this]           # 00489466
    mov ecx, dword ptr [ebp + arg_obj]             # 00489469
    mov dword ptr [eax + this_object_ptr], ecx              # 0048946c
    mov edx, dword ptr [ebp - local_saved_this]           # 0048946f
    mov eax, dword ptr [edx + this_object_ptr]              # 00489472
    mov word ptr [eax + obj_word_25], 0x2               # 00489475
    mov ecx, dword ptr [ebp - local_saved_this]           # 0048947b
    mov edx, dword ptr [ecx + this_object_ptr]              # 0048947e
    mov word ptr [edx + obj_word_3d_9999], 0x270f            # 00489481
    mov eax, dword ptr [ebp - local_saved_this]           # 00489487
    mov ecx, dword ptr [eax + this_object_ptr]              # 0048948a
    mov word ptr [ecx + obj_word_39_unset], 0xffff            # 0048948d
    mov edx, dword ptr [ebp - local_saved_this]           # 00489493
    mov eax, dword ptr [edx + this_object_ptr]              # 00489496
    mov word ptr [eax + obj_word_21], 0x2               # 00489499
    mov ecx, dword ptr [ebp - local_saved_this]           # 0048949f
    mov edx, dword ptr [ecx + this_object_ptr]              # 004894a2
    mov word ptr [edx + obj_word_29], 0x1               # 004894a5
    mov word ptr [ebp - local_i], 0x0            # 004894ab
    jmp.d8 L_loop_test                            # 004894b1
L_loop_increment:
    # block 0x004894b3: i = i + 1 (16-bit add of 1)
    mov ax, word ptr [ebp - local_i]             # 004894b3
    .insn 0x66, 0x05, 0x0001{:u16}               # 004894b7
    mov word ptr [ebp - local_i], ax             # 004894bb
L_loop_test:
    # block 0x004894bf: loop test: if (int16)i >= 10 leave the loop
    movsx ecx, word ptr [ebp - local_i]          # 004894bf
    cmp ecx, 0xa                                 # 004894c3
    jge.d8 L_after_loop                            # 004894c6
    # block 0x004894c8: obj[0x51 + 4*i] (word) = 0xffff, then next iteration
    mov edx, dword ptr [ebp - local_saved_this]           # 004894c8
    mov eax, dword ptr [edx + this_object_ptr]              # 004894cb
    movsx ecx, word ptr [ebp - local_i]          # 004894ce
    mov word ptr [eax + 4*ecx + obj_slot_array_51], 0xffff    # 004894d2
    jmp.d8 L_loop_increment                            # 004894d9
L_after_loop:
    # block 0x004894db: copy "NO SOUND" (0x54e058) with NUL to obj+0x79; set obj+0x43=1, +0x4d=1, +0x2b=1, +0xaa=1; obj+0x6ec=0, +0x6ee=0, +0x6f0=2; copy rect[0..3] to obj+0x702; obj+0x6f6=0, +0x6f2=0; obj+0x6fe = rect[3]-rect[1]; obj+0x6fa = rect[2]-rect[0]; restore esi/edi and return popping 8
    mov edi, 0x54e058                            # 004894db
    mov edx, dword ptr [ebp - local_saved_this]           # 004894e0
    mov eax, dword ptr [edx + this_object_ptr]              # 004894e3
    add eax, 0x79                                # 004894e6
    {load} mov edx, eax                          # 004894e9
    or ecx, -0x1                                 # 004894eb
    {load} xor eax, eax                          # 004894ee
    repne scasb al, byte ptr es:[edi]            # 004894f0
    not ecx                                      # 004894f2
    {load} sub edi, ecx                          # 004894f4
    {load} mov esi, edi                          # 004894f6
    {load} mov eax, ecx                          # 004894f8
    {load} mov edi, edx                          # 004894fa
    shr ecx, 0x2                                 # 004894fc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004894ff
    {load} mov ecx, eax                          # 00489501
    and ecx, 0x3                                 # 00489503
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00489506
    mov ecx, dword ptr [ebp - local_saved_this]           # 00489508
    mov edx, dword ptr [ecx + this_object_ptr]              # 0048950b
    mov word ptr [edx + obj_word_43], 0x1               # 0048950e
    mov eax, dword ptr [ebp - local_saved_this]           # 00489514
    mov ecx, dword ptr [eax + this_object_ptr]              # 00489517
    mov dword ptr [ecx + obj_dword_4d], 0x1              # 0048951a
    mov edx, dword ptr [ebp - local_saved_this]           # 00489521
    mov eax, dword ptr [edx + this_object_ptr]              # 00489524
    mov word ptr [eax + obj_word_2b], 0x1               # 00489527
    mov ecx, dword ptr [ebp - local_saved_this]           # 0048952d
    mov edx, dword ptr [ecx + this_object_ptr]              # 00489530
    mov word ptr [edx + obj_word_aa], 0x1               # 00489533
    mov eax, dword ptr [ebp + arg_obj]             # 0048953c
    mov word ptr [eax + obj_word_6ec], 0x0              # 0048953f
    mov ecx, dword ptr [ebp + arg_obj]             # 00489548
    mov word ptr [ecx + obj_word_6ee], 0x0              # 0048954b
    mov edx, dword ptr [ebp + arg_obj]             # 00489554
    mov word ptr [edx + obj_word_6f0], 0x2              # 00489557
    mov eax, dword ptr [ebp + arg_obj]             # 00489560
    add eax, 0x702                               # 00489563
    mov ecx, dword ptr [ebp + arg_rect]             # 00489568
    mov edx, dword ptr [ecx]                     # 0048956b
    mov dword ptr [eax], edx                     # 0048956d
    mov edx, dword ptr [ecx + rect_top]               # 0048956f
    mov dword ptr [eax + objrect_top], edx               # 00489572
    mov edx, dword ptr [ecx + rect_right]               # 00489575
    mov dword ptr [eax + objrect_right], edx               # 00489578
    mov ecx, dword ptr [ecx + rect_bottom]               # 0048957b
    mov dword ptr [eax + objrect_bottom], ecx               # 0048957e
    mov edx, dword ptr [ebp + arg_obj]             # 00489581
    mov dword ptr [edx + obj_dword_6f6], 0x0             # 00489584
    mov eax, dword ptr [ebp + arg_obj]             # 0048958e
    mov dword ptr [eax + obj_dword_6f2], 0x0             # 00489591
    mov ecx, dword ptr [ebp + arg_rect]             # 0048959b
    mov edx, dword ptr [ebp + arg_rect]             # 0048959e
    mov eax, dword ptr [ecx + rect_bottom]               # 004895a1
    sub eax, dword ptr [edx + rect_top]               # 004895a4
    mov ecx, dword ptr [ebp + arg_obj]             # 004895a7
    mov dword ptr [ecx + obj_rect_height_6fe], eax             # 004895aa
    mov edx, dword ptr [ebp + arg_rect]             # 004895b0
    mov eax, dword ptr [ebp + arg_rect]             # 004895b3
    mov ecx, dword ptr [edx + rect_right]               # 004895b6
    sub ecx, dword ptr [eax]                     # 004895b9
    mov edx, dword ptr [ebp + arg_obj]             # 004895bb
    mov dword ptr [edx + obj_rect_width_6fa], ecx             # 004895be
    pop edi                                      # 004895c4
    pop esi                                      # 004895c5
    {load} mov esp, ebp                          # 004895c6
    pop ebp                                      # 004895c8
    ret 0x8                                      # 004895c9
