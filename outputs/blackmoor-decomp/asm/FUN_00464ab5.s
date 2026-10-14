# FUN_00464ab5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00464ab5
# extent:       0x00464ab5-0x00464c59 (420 code bytes)
# span:         0x00464ab5-0x00464c59 (code 420, tables 0, padding 0)
# sha256:       2b207500a44da63cbf294b4e9585d1c75c23cea530fbfa6638e3c3e933c5fc45
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# name:         HotspotUI::select_cursor_for_event
# arguments:    thiscall: ecx=this (spilled to [ebp-4]), [ebp+8]=event id (only the low 16 bits are used, sign-extended with movsx, compared with 0x27c9, 0x27ca, 0x27cb, 0x27cc, 0x27cd), [ebp+0xc]=second argument (only its low 16 bits are used, and only on the 0x27c9 and 0x27cd path), callee pops 8 (ret 8), no return value (eax is not set), nothing at all is written for any other event id
# locals:       [ebp-4]=saved this (written from ecx, read back only on the 0x27c9/0x27cd path)
# fields:       this+0x38: int16, receives the low word of the second argument (0x27c9 and 0x27cd only), globals 0x005b44f0 (dword, cursor type index), 0x005b44f4 (dword, cursor variant), 0x005d0377 (dword, read), 0x005d162d (dword, written with a copy of 0x5d0377), 0x005d1631 (dword, written with 0x5b160c + type*0x20 + variant*0x10), 0x005d1639 (dword, written 1), 0x005c39e5 (dword, written with the sign-extended event id), the last five globals (0x5d0377, 0x5d162d, 0x5d1631, 0x5d1639, 0x5c39e5) sit at odd (unaligned) addresses
# callees:      none
# track-n:      host-adapter: none
# unverified:   The roles of the globals (cursor type, cursor variant, cursor surface, cursor source pointer, cursor layer enable) are the labels written in src/caption_lifecycle.h (cursor_type 0x5b44f0, cursor_variant 0x5b44f4, cursor_surface 0x5d162d, default_cursor_surface 0x5d0377, cursor_layer_enabled 0x5d1639), they are not proven by these bytes. That header calls 0x5d1631 a source index counted in dwords from 0x5b160c, while these bytes store the byte address 0x5b160c + type*0x20 + variant*0x10 itself, and it labels 0x5c39e5 slider_cursor_scene while s0-action-runtime-trace.md calls it the hotspot index, here it simply receives the event id 0x27c9..0x27cd, so its meaning is not established. The class that owns this method, the meaning of this+0x38 and of the event ids, and the contents of the descriptor table at 0x5b160c (not read) are not established, the method name is only my label. The callers (the Ghidra pseudocode of 0x464792 calls it with ids 0x27c9..0x27cd and a slot index as second argument) were not re-verified in disassembly. No bound check exists on the type value used to index the descriptor table because the type is always one of four constants here.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_saved_this, 0x4  # [ebp - 0x4]: this, spilled from ecx, read back only on the 0x27c9/0x27cd path
.equ arg_event_id, 0x8  # [ebp + 0x8]: event id, only the low word is read (movsx word)
.equ arg_slot_word, 0xc  # [ebp + 0xc]: second argument, only the low word is read (mov cx, word)

.equ this_slot_word, 0x38  # this+0x38: int16, receives the low word of arg_slot_word on the 0x27c9/0x27cd path

# --- external targets -----------------------------------------------

.org 0x00464ab5 - 0x401000
.globl FUN_00464ab5
FUN_00464ab5:
    # block 0x00464ab5: entry: build the frame, spill this, sign-extend the low word of arg_event_id and compare it with 0x27cc, if different jump to L_check_27c9
    push ebp                                     # 00464ab5
    {load} mov ebp, esp                          # 00464ab6
    push ecx                                     # 00464ab8
    mov dword ptr [ebp - local_saved_this], ecx           # 00464ab9
    movsx eax, word ptr [ebp + arg_event_id]            # 00464abc
    cmp eax, 0x27cc                              # 00464ac0
    jne.d8 L_check_27c9                            # 00464ac5
    # block 0x00464ac7: event 0x27cc: [0x5b44f0]=0x16 (cursor type), [0x5b44f4]=1, then the common stores (surface copy, descriptor pointer, enable flag, event id), then jump to L_epilogue
    mov dword ptr [0x5b44f0], 0x16               # 00464ac7
    mov dword ptr [0x5b44f4], 0x1                # 00464ad1
    mov ecx, dword ptr [0x5d0377]                # 00464adb
    mov dword ptr [0x5d162d], ecx                # 00464ae1
    mov edx, dword ptr [0x5b44f0]                # 00464ae7
    shl edx, 0x5                                 # 00464aed
    mov eax, dword ptr [0x5b44f4]                # 00464af0
    shl eax, 0x4                                 # 00464af5
    lea ecx, [edx + eax + 0x5b160c]              # 00464af8
    mov dword ptr [0x5d1631], ecx                # 00464aff
    mov dword ptr [0x5d1639], 0x1                # 00464b05
    movsx edx, word ptr [ebp + arg_event_id]            # 00464b0f
    mov dword ptr [0x5c39e5], edx                # 00464b13
    jmp.d32 L_epilogue                           # 00464b19
L_check_27c9:
    # block 0x00464b1e: event is not 0x27cc: compare it with 0x27c9 and jump to L_set_type_12 when equal
    movsx eax, word ptr [ebp + arg_event_id]            # 00464b1e
    cmp eax, 0x27c9                              # 00464b22
    je.d8 L_set_type_12                             # 00464b27
    # block 0x00464b29: event is not 0x27c9: compare it with 0x27cd and jump to L_check_27ca when it differs
    movsx ecx, word ptr [ebp + arg_event_id]            # 00464b29
    cmp ecx, 0x27cd                              # 00464b2d
    jne.d8 L_check_27ca                            # 00464b33
L_set_type_12:
    # block 0x00464b35: events 0x27c9 and 0x27cd: [0x5b44f0]=0x12, [0x5b44f4]=1, surface copy, this+0x38 = low word of arg_slot_word, descriptor pointer, enable flag, event id, then jump to L_epilogue
    mov dword ptr [0x5b44f0], 0x12               # 00464b35
    mov dword ptr [0x5b44f4], 0x1                # 00464b3f
    mov edx, dword ptr [0x5d0377]                # 00464b49
    mov dword ptr [0x5d162d], edx                # 00464b4f
    mov eax, dword ptr [ebp - local_saved_this]           # 00464b55
    mov cx, word ptr [ebp + arg_slot_word]               # 00464b58
    mov word ptr [eax + this_slot_word], cx            # 00464b5c
    mov edx, dword ptr [0x5b44f0]                # 00464b60
    shl edx, 0x5                                 # 00464b66
    mov eax, dword ptr [0x5b44f4]                # 00464b69
    shl eax, 0x4                                 # 00464b6e
    lea ecx, [edx + eax + 0x5b160c]              # 00464b71
    mov dword ptr [0x5d1631], ecx                # 00464b78
    mov dword ptr [0x5d1639], 0x1                # 00464b7e
    movsx edx, word ptr [ebp + arg_event_id]            # 00464b88
    mov dword ptr [0x5c39e5], edx                # 00464b8c
    jmp.d32 L_epilogue                           # 00464b92
L_check_27ca:
    # block 0x00464b97: event is neither 0x27cc, 0x27c9 nor 0x27cd: compare it with 0x27ca and jump to L_check_27cb when it differs
    movsx eax, word ptr [ebp + arg_event_id]            # 00464b97
    cmp eax, 0x27ca                              # 00464b9b
    jne.d8 L_check_27cb                            # 00464ba0
    # block 0x00464ba2: event 0x27ca: [0x5b44f0]=0x14, [0x5b44f4]=1, then the common stores, then jump to L_epilogue
    mov dword ptr [0x5b44f0], 0x14               # 00464ba2
    mov dword ptr [0x5b44f4], 0x1                # 00464bac
    mov ecx, dword ptr [0x5d0377]                # 00464bb6
    mov dword ptr [0x5d162d], ecx                # 00464bbc
    mov edx, dword ptr [0x5b44f0]                # 00464bc2
    shl edx, 0x5                                 # 00464bc8
    mov eax, dword ptr [0x5b44f4]                # 00464bcb
    shl eax, 0x4                                 # 00464bd0
    lea ecx, [edx + eax + 0x5b160c]              # 00464bd3
    mov dword ptr [0x5d1631], ecx                # 00464bda
    mov dword ptr [0x5d1639], 0x1                # 00464be0
    movsx edx, word ptr [ebp + arg_event_id]            # 00464bea
    mov dword ptr [0x5c39e5], edx                # 00464bee
    jmp.d8 L_epilogue                            # 00464bf4
L_check_27cb:
    # block 0x00464bf6: event is not 0x27ca: compare it with 0x27cb and jump to L_epilogue when it differs (no global is written for any other id)
    movsx eax, word ptr [ebp + arg_event_id]            # 00464bf6
    cmp eax, 0x27cb                              # 00464bfa
    jne.d8 L_epilogue                            # 00464bff
    # block 0x00464c01: event 0x27cb: [0x5b44f0]=0x15, [0x5b44f4]=1, then the common stores, then fall into L_epilogue
    mov dword ptr [0x5b44f0], 0x15               # 00464c01
    mov dword ptr [0x5b44f4], 0x1                # 00464c0b
    mov ecx, dword ptr [0x5d0377]                # 00464c15
    mov dword ptr [0x5d162d], ecx                # 00464c1b
    mov edx, dword ptr [0x5b44f0]                # 00464c21
    shl edx, 0x5                                 # 00464c27
    mov eax, dword ptr [0x5b44f4]                # 00464c2a
    shl eax, 0x4                                 # 00464c2f
    lea ecx, [edx + eax + 0x5b160c]              # 00464c32
    mov dword ptr [0x5d1631], ecx                # 00464c39
    mov dword ptr [0x5d1639], 0x1                # 00464c3f
    movsx edx, word ptr [ebp + arg_event_id]            # 00464c49
    mov dword ptr [0x5c39e5], edx                # 00464c4d
L_epilogue:
    # block 0x00464c53: shared epilogue: restore the frame and return, popping the two stack arguments (ret 8)
    {load} mov esp, ebp                          # 00464c53
    pop ebp                                      # 00464c55
    ret 0x8                                      # 00464c56
