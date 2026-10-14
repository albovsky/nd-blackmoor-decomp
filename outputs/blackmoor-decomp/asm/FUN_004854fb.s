# FUN_004854fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004854fb
# extent:       0x004854fb-0x0048569e (419 code bytes)
# span:         0x004854fb-0x0048569e (code 419, tables 0, padding 0)
# sha256:       81850f86de93ecda5129d44a2ff1c9323cf536507db7631f5a8a5554c3c699e1
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# name:         SceneUI::select_cursor_for_event
# arguments:    thiscall: ecx=this (spilled to [ebp-8]), [ebp+8]=event id (only the low 16 bits are used, sign-extended with movsx, compared with 0x2778, 0x277c, 0x2779), callee pops 4 (ret 4), no return value (eax is not set), every other id takes the default path
# locals:       [ebp-8]=saved this (from ecx), [ebp-4]=scene record pointer = dword at 0x5bb5e5 + int16(this+0x26)*0x8d, loaded before the event id is looked at (only the 0x2779 and default paths dereference it)
# fields:       this+0x26: int16 scene index selecting a 0x8d-byte entry of the table at 0x5bb5e5, scene record+0xda7: int16 cursor type (default path), scene record+0xda9: int16 cursor type (event 0x2779), globals 0x005b44f0 (dword, cursor type index), 0x005b44f4 (dword, cursor variant), 0x005d0377 (dword, read), 0x005d162d (dword, written with a copy of 0x5d0377), 0x005d1631 (dword, written with 0x5b160c + type*0x20 + variant*0x10), 0x005d1639 (dword, written 1), 0x005c39e5 (dword, written with the sign-extended event id), the last four globals sit at odd (unaligned) addresses
# callees:      none
# track-n:      host-adapter: none
# unverified:   The roles of the globals are the labels in src/caption_lifecycle.h (cursor type, cursor variant, cursor surface, cursor layer enable), they are not proven by these bytes, and the same header's reading of 0x5d1631 as a dword index and of 0x5c39e5 as a slider scene does not match the byte address and the event id stored here. The table at 0x5bb5e5 (stride 0x8d, first dword read as a record pointer) and the fields at record+0xda7 and +0xda9 are described only by this function's own accesses, what the record is and what those two int16 values mean are not established, the class of this and the method name are my labels. The default path (any id other than 0x2778, 0x277c, 0x2779) is verified in the control flow, which ids reach it in the game is not: the Ghidra pseudocode of 0x484f42 calls it with 0x2777, 0x2778, 0x2779, 0x277a, 0x277b and 0x277c, not re-verified in disassembly. No bound check exists on this+0x26 or on the type read from the record before it scales an index into the descriptor table at 0x5b160c, and a null record pointer would fault on the 0x2779 and default paths.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_scene_record, 0x4  # [ebp - 0x4]: scene record pointer, dword at 0x5bb5e5 + scene index*0x8d
.equ local_saved_this, 0x8  # [ebp - 0x8]: this, spilled from ecx
.equ arg_event_id, 0x8  # [ebp + 0x8]: event id, only the low word is read (movsx word)

.equ this_scene_index, 0x26  # this+0x26: int16 scene index, multiplied by 0x8d to index the table at 0x5bb5e5

.equ record_cursor_type_default, 0xda7  # scene record+0xda7: int16 cursor type used on the default path
.equ record_cursor_type_2779, 0xda9  # scene record+0xda9: int16 cursor type used for event 0x2779

# --- external targets -----------------------------------------------

.org 0x004854fb - 0x401000
.globl FUN_004854fb
FUN_004854fb:
    # block 0x004854fb: entry: build the frame, spill this, load the scene record pointer from the table at 0x5bb5e5 indexed by int16(this+0x26)*0x8d, compare the event id with 0x2778 and jump to L_check_277c when different
    push ebp                                     # 004854fb
    {load} mov ebp, esp                          # 004854fc
    sub esp, 0x8                                 # 004854fe
    mov dword ptr [ebp - local_saved_this], ecx           # 00485501
    mov eax, dword ptr [ebp - local_saved_this]           # 00485504
    movsx ecx, word ptr [eax + this_scene_index]         # 00485507
    imul ecx, ecx, 0x8d                          # 0048550b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00485511
    mov dword ptr [ebp - local_scene_record], edx           # 00485517
    movsx eax, word ptr [ebp + arg_event_id]            # 0048551a
    cmp eax, 0x2778                              # 0048551e
    jne.d8 L_check_277c                            # 00485523
    # block 0x00485525: event 0x2778: [0x5b44f0]=0x14 (cursor type), [0x5b44f4]=0 (variant 0, unlike the other paths), then the common stores (surface copy, descriptor pointer, enable flag, event id), then jump to L_epilogue
    mov dword ptr [0x5b44f0], 0x14               # 00485525
    mov dword ptr [0x5b44f4], 0x0                # 0048552f
    mov ecx, dword ptr [0x5d0377]                # 00485539
    mov dword ptr [0x5d162d], ecx                # 0048553f
    mov edx, dword ptr [0x5b44f0]                # 00485545
    shl edx, 0x5                                 # 0048554b
    mov eax, dword ptr [0x5b44f4]                # 0048554e
    shl eax, 0x4                                 # 00485553
    lea ecx, [edx + eax + 0x5b160c]              # 00485556
    mov dword ptr [0x5d1631], ecx                # 0048555d
    mov dword ptr [0x5d1639], 0x1                # 00485563
    movsx edx, word ptr [ebp + arg_event_id]            # 0048556d
    mov dword ptr [0x5c39e5], edx                # 00485571
    jmp.d32 L_epilogue                           # 00485577
L_check_277c:
    # block 0x0048557c: event is not 0x2778: compare it with 0x277c and jump to L_check_2779 when different
    movsx eax, word ptr [ebp + arg_event_id]            # 0048557c
    cmp eax, 0x277c                              # 00485580
    jne.d8 L_check_2779                            # 00485585
    # block 0x00485587: event 0x277c: [0x5b44f0]=0x16, [0x5b44f4]=1, then the common stores, then jump to L_epilogue
    mov dword ptr [0x5b44f0], 0x16               # 00485587
    mov dword ptr [0x5b44f4], 0x1                # 00485591
    mov ecx, dword ptr [0x5d0377]                # 0048559b
    mov dword ptr [0x5d162d], ecx                # 004855a1
    mov edx, dword ptr [0x5b44f0]                # 004855a7
    shl edx, 0x5                                 # 004855ad
    mov eax, dword ptr [0x5b44f4]                # 004855b0
    shl eax, 0x4                                 # 004855b5
    lea ecx, [edx + eax + 0x5b160c]              # 004855b8
    mov dword ptr [0x5d1631], ecx                # 004855bf
    mov dword ptr [0x5d1639], 0x1                # 004855c5
    movsx edx, word ptr [ebp + arg_event_id]            # 004855cf
    mov dword ptr [0x5c39e5], edx                # 004855d3
    jmp.d32 L_epilogue                           # 004855d9
L_check_2779:
    # block 0x004855de: event is not 0x277c: compare it with 0x2779 and jump to L_event_2779 when equal
    movsx eax, word ptr [ebp + arg_event_id]            # 004855de
    cmp eax, 0x2779                              # 004855e2
    je.d8 L_event_2779                             # 004855e7
    # block 0x004855e9: default path (any other event id): [0x5b44f0]=int16 at scene record+0xda7 (sign-extended), [0x5b44f4]=1, then the common stores, then jump to L_epilogue
    mov ecx, dword ptr [ebp - local_scene_record]           # 004855e9
    movsx edx, word ptr [ecx + record_cursor_type_default]        # 004855ec
    mov dword ptr [0x5b44f0], edx                # 004855f3
    mov dword ptr [0x5b44f4], 0x1                # 004855f9
    mov eax, dword ptr [0x5d0377]                # 00485603
    mov dword ptr [0x5d162d], eax                # 00485608
    mov ecx, dword ptr [0x5b44f0]                # 0048560d
    shl ecx, 0x5                                 # 00485613
    mov edx, dword ptr [0x5b44f4]                # 00485616
    shl edx, 0x4                                 # 0048561c
    lea eax, [ecx + edx + 0x5b160c]              # 0048561f
    mov dword ptr [0x5d1631], eax                # 00485626
    mov dword ptr [0x5d1639], 0x1                # 0048562b
    movsx ecx, word ptr [ebp + arg_event_id]            # 00485635
    mov dword ptr [0x5c39e5], ecx                # 00485639
    jmp.d8 L_epilogue                            # 0048563f
L_event_2779:
    # block 0x00485641: event 0x2779: [0x5b44f0]=int16 at scene record+0xda9 (sign-extended), [0x5b44f4]=1, then the common stores, then fall into L_epilogue
    mov edx, dword ptr [ebp - local_scene_record]           # 00485641
    movsx eax, word ptr [edx + record_cursor_type_2779]        # 00485644
    mov dword ptr [0x5b44f0], eax                # 0048564b
    mov dword ptr [0x5b44f4], 0x1                # 00485650
    mov ecx, dword ptr [0x5d0377]                # 0048565a
    mov dword ptr [0x5d162d], ecx                # 00485660
    mov edx, dword ptr [0x5b44f0]                # 00485666
    shl edx, 0x5                                 # 0048566c
    mov eax, dword ptr [0x5b44f4]                # 0048566f
    shl eax, 0x4                                 # 00485674
    lea ecx, [edx + eax + 0x5b160c]              # 00485677
    mov dword ptr [0x5d1631], ecx                # 0048567e
    mov dword ptr [0x5d1639], 0x1                # 00485684
    movsx edx, word ptr [ebp + arg_event_id]            # 0048568e
    mov dword ptr [0x5c39e5], edx                # 00485692
L_epilogue:
    # block 0x00485698: shared epilogue: restore the frame and return, popping the one stack argument (ret 4)
    {load} mov esp, ebp                          # 00485698
    pop ebp                                      # 0048569a
    ret 0x4                                      # 0048569b
