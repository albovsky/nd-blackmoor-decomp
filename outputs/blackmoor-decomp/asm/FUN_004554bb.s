# FUN_004554bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004554bb
# extent:       0x004554bb-0x0045565f (420 code bytes)
# span:         0x004554bb-0x0045565f (code 420, tables 0, padding 0)
# sha256:       ec0637aa72db5f532174fb1aab8e236ebe9e2f5ba961593d425f3905c93c832e
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# name:         AssemblyPuzzle::set_cursor_for_hover_kind
# arguments:    thiscall: ecx=this, two stack arguments, [esp+4] = cursor kind (int16 read with movsx: 0x27c4, 0x27c5, 0x27c6, 0x27c7 or 0x27c8) and [esp+8] = int16 piece index (read as a word, stored only for kinds 0x27c4 and 0x27c8), callee pops both (ret 8), no return value (eax is scratch). The six call sites 0x004552ac, 0x004552fa, 0x00455343, 0x00455398, 0x00455433 and 0x004554a2 all lie inside FUN_00455180 and push the second argument first
# locals:       [ebp-4] = this, spilled from ecx (push ecx reserves the slot)
# fields:       this+0x38: int16, written with the second argument for kinds 0x27c4 and 0x27c8 only, globals 0x005b44f0 (dword cursor row, written), 0x005b44f4 (dword cursor column, written 1), 0x005d0377 (dword read, copied), 0x005d162d (dword written with that copy), 0x005d1631 (dword written with 0x005b160c + (row << 5) + (column << 4)), 0x005d1639 (dword written 1), 0x005c39e5 (dword written with the sign-extended kind)
# callees:      none
# track-n:      host-adapter: none
# unverified:   Class name is only my label from the nearest strings (ASSEMBLY PUZZLE OVERLAYS at 0x455f3a and the Arcade puzzle texts just before it) and the caller FUN_00455180 being a hit test over a record table, not from RTTI or a vtable. The call-site constants and the pushed second arguments were read from the bytes (this+0x36 word for 0x27c8 and one 0x27c4 site, a loop index local for the other 0x27c4 site, zero for 0x27c5 to 0x27c7), but what this+0x38 and this+0x36 mean is not established, nor what the five kinds mean in the game. Rows chosen: 0x27c7 row 9, 0x27c4 and 0x27c8 row 0x12, 0x27c5 row 0x14, 0x27c6 row 0x15, always column 1, the table at 0x5b160c is a cursor table only by the structure of the writes (row stride 32, column stride 16), its contents were not read. For any other kind value the routine changes nothing and returns (no write to any global, this+0x38 untouched). Track N names for the globals exist in src/caption_lifecycle.h (cursor_type 0x5b44f0, cursor_variant 0x5b44f4, cursor_surface 0x5d162d, default_cursor_surface 0x5d0377, cursor_layer_enabled 0x5d1639) but that file does not contain this function and I do not claim the labels fit this use. The pointer written to 0x5d1631 is a full 32-bit address into the table, not an index.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]: this, spilled from ecx
.equ arg_cursor_kind, 0x8  # [ebp + 0x8]: int16 cursor kind
.equ arg_piece_index, 0xc  # [ebp + 0xc]: int16 second argument (an index or zero at the call sites), stored into this+0x38 for kinds 0x27c4 and 0x27c8
.equ this_piece_index, 0x38  # this+0x38: int16 written with arg_piece_index

# --- external targets -----------------------------------------------

.org 0x004554bb - 0x401000
.globl FUN_004554bb
FUN_004554bb:
    # block 0x004554bb: entry: spill this, compare the kind with 0x27c7, not equal goes to L_not_kind_27c7 (jne)
    push ebp                                     # 004554bb
    {load} mov ebp, esp                          # 004554bc
    push ecx                                     # 004554be
    mov dword ptr [ebp - local_this], ecx           # 004554bf
    movsx eax, word ptr [ebp + arg_cursor_kind]            # 004554c2
    cmp eax, 0x27c7                              # 004554c6
    jne.d8 L_not_kind_27c7                            # 004554cb
    # block 0x004554cd: kind 0x27c7: row 0x5b44f0 = 9, column 0x5b44f4 = 1, 0x5d162d = 0x5d0377, 0x5d1631 = 0x5b160c + (row << 5) + (column << 4), 0x5d1639 = 1, 0x5c39e5 = kind, jump to L_epilogue
    mov dword ptr [0x5b44f0], 0x9                # 004554cd
    mov dword ptr [0x5b44f4], 0x1                # 004554d7
    mov ecx, dword ptr [0x5d0377]                # 004554e1
    mov dword ptr [0x5d162d], ecx                # 004554e7
    mov edx, dword ptr [0x5b44f0]                # 004554ed
    shl edx, 0x5                                 # 004554f3
    mov eax, dword ptr [0x5b44f4]                # 004554f6
    shl eax, 0x4                                 # 004554fb
    lea ecx, [edx + eax + 0x5b160c]              # 004554fe
    mov dword ptr [0x5d1631], ecx                # 00455505
    mov dword ptr [0x5d1639], 0x1                # 0045550b
    movsx edx, word ptr [ebp + arg_cursor_kind]            # 00455515
    mov dword ptr [0x5c39e5], edx                # 00455519
    jmp.d32 L_epilogue                           # 0045551f
L_not_kind_27c7:
    # block 0x00455524: kind is not 0x27c7: compare with 0x27c4, equal goes to L_kind_27c4_or_27c8 (je)
    movsx eax, word ptr [ebp + arg_cursor_kind]            # 00455524
    cmp eax, 0x27c4                              # 00455528
    je.d8 L_kind_27c4_or_27c8                             # 0045552d
    # block 0x0045552f: compare with 0x27c8, not equal goes to L_not_kind_27c4_27c8 (jne), equal falls into the shared block
    movsx ecx, word ptr [ebp + arg_cursor_kind]            # 0045552f
    cmp ecx, 0x27c8                              # 00455533
    jne.d8 L_not_kind_27c4_27c8                            # 00455539
L_kind_27c4_or_27c8:
    # block 0x0045553b: kind 0x27c4 or 0x27c8: row 0x5b44f0 = 0x12, column 0x5b44f4 = 1, 0x5d162d = 0x5d0377, this+0x38 = int16 second argument, 0x5d1631 = 0x5b160c + (row << 5) + (column << 4), 0x5d1639 = 1, 0x5c39e5 = kind, jump to L_epilogue
    mov dword ptr [0x5b44f0], 0x12               # 0045553b
    mov dword ptr [0x5b44f4], 0x1                # 00455545
    mov edx, dword ptr [0x5d0377]                # 0045554f
    mov dword ptr [0x5d162d], edx                # 00455555
    mov eax, dword ptr [ebp - local_this]           # 0045555b
    mov cx, word ptr [ebp + arg_piece_index]               # 0045555e
    mov word ptr [eax + this_piece_index], cx            # 00455562
    mov edx, dword ptr [0x5b44f0]                # 00455566
    shl edx, 0x5                                 # 0045556c
    mov eax, dword ptr [0x5b44f4]                # 0045556f
    shl eax, 0x4                                 # 00455574
    lea ecx, [edx + eax + 0x5b160c]              # 00455577
    mov dword ptr [0x5d1631], ecx                # 0045557e
    mov dword ptr [0x5d1639], 0x1                # 00455584
    movsx edx, word ptr [ebp + arg_cursor_kind]            # 0045558e
    mov dword ptr [0x5c39e5], edx                # 00455592
    jmp.d32 L_epilogue                           # 00455598
L_not_kind_27c4_27c8:
    # block 0x0045559d: compare the kind with 0x27c5, not equal goes to L_not_kind_27c5 (jne)
    movsx eax, word ptr [ebp + arg_cursor_kind]            # 0045559d
    cmp eax, 0x27c5                              # 004555a1
    jne.d8 L_not_kind_27c5                            # 004555a6
    # block 0x004555a8: kind 0x27c5: row 0x5b44f0 = 0x14, column 0x5b44f4 = 1, 0x5d162d = 0x5d0377, 0x5d1631 = 0x5b160c + (row << 5) + (column << 4), 0x5d1639 = 1, 0x5c39e5 = kind, jump to L_epilogue
    mov dword ptr [0x5b44f0], 0x14               # 004555a8
    mov dword ptr [0x5b44f4], 0x1                # 004555b2
    mov ecx, dword ptr [0x5d0377]                # 004555bc
    mov dword ptr [0x5d162d], ecx                # 004555c2
    mov edx, dword ptr [0x5b44f0]                # 004555c8
    shl edx, 0x5                                 # 004555ce
    mov eax, dword ptr [0x5b44f4]                # 004555d1
    shl eax, 0x4                                 # 004555d6
    lea ecx, [edx + eax + 0x5b160c]              # 004555d9
    mov dword ptr [0x5d1631], ecx                # 004555e0
    mov dword ptr [0x5d1639], 0x1                # 004555e6
    movsx edx, word ptr [ebp + arg_cursor_kind]            # 004555f0
    mov dword ptr [0x5c39e5], edx                # 004555f4
    jmp.d8 L_epilogue                            # 004555fa
L_not_kind_27c5:
    # block 0x004555fc: compare the kind with 0x27c6, not equal goes to L_epilogue and changes nothing (jne)
    movsx eax, word ptr [ebp + arg_cursor_kind]            # 004555fc
    cmp eax, 0x27c6                              # 00455600
    jne.d8 L_epilogue                            # 00455605
    # block 0x00455607: kind 0x27c6: row 0x5b44f0 = 0x15, column 0x5b44f4 = 1, 0x5d162d = 0x5d0377, 0x5d1631 = 0x5b160c + (row << 5) + (column << 4), 0x5d1639 = 1, 0x5c39e5 = kind, fall into L_epilogue
    mov dword ptr [0x5b44f0], 0x15               # 00455607
    mov dword ptr [0x5b44f4], 0x1                # 00455611
    mov ecx, dword ptr [0x5d0377]                # 0045561b
    mov dword ptr [0x5d162d], ecx                # 00455621
    mov edx, dword ptr [0x5b44f0]                # 00455627
    shl edx, 0x5                                 # 0045562d
    mov eax, dword ptr [0x5b44f4]                # 00455630
    shl eax, 0x4                                 # 00455635
    lea ecx, [edx + eax + 0x5b160c]              # 00455638
    mov dword ptr [0x5d1631], ecx                # 0045563f
    mov dword ptr [0x5d1639], 0x1                # 00455645
    movsx edx, word ptr [ebp + arg_cursor_kind]            # 0045564f
    mov dword ptr [0x5c39e5], edx                # 00455653
L_epilogue:
    # block 0x00455659: epilogue: restore the frame and return, popping the two stack arguments (ret 8)
    {load} mov esp, ebp                          # 00455659
    pop ebp                                      # 0045565b
    ret 0x8                                      # 0045565c
