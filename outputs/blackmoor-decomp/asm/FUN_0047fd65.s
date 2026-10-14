# FUN_0047fd65
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047fd65
# extent:       0x0047fd65-0x0047ff0e (425 code bytes)
# span:         0x0047fd65-0x0047ff0e (code 425, tables 0, padding 0)
# sha256:       05a9653ac9793f62cc284140f22b9621eb2f64dafb70aacc30e54371a2085bb3
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# name:         MultibuildPuzzle::set_cursor_for_hover_kind
# arguments:    thiscall: ecx=this, one stack argument [esp+4] = cursor kind (int16 read with movsx, values 0x278d to 0x2791 appear at the callers), callee pops it (ret 4), no return value (eax is scratch). Call sites found by scanning the original: 0x0047f751, 0x0047f933, 0x0047f958, 0x0047f9ab, 0x0047f9fb (all inside FUN_0047f421, with ecx = its saved this), pushing 0x2791, 0x278e, 0x278d, 0x278f and 0x2790 respectively
# locals:       8 bytes reserved: [ebp-4] = pointer to the active action slot payload record, [ebp-8] = this (spilled from ecx)
# fields:       this+0x1e: int16 action slot index (read, used unchecked), this+0x13df: dword flag (read, zero or non-zero), slot table 0x005bb5e5 + slot*0x8d: dword payload pointer (read), payload+0x8c2, +0x8c4, +0x8c6: int16 cursor row numbers (read), globals 0x005b44f0 (dword cursor row, written), 0x005b44f4 (dword cursor column, written 0 or 1), 0x005d0377 (dword read, copied), 0x005d162d (dword written with that copy), 0x005d1631 (dword written with 0x005b160c + (row << 5) + (column << 4)), 0x005d1639 (dword written 1), 0x005c39e5 (dword written with the sign-extended kind)
# callees:      none
# track-n:      host-adapter: none
# unverified:   Class name is only my label from the nearest strings (Mouselight puzzle view window and Multibuild Puzzle Piece texts at 0x47e0ad and 0x47e736 sit in the same address band) and the caller FUN_0047f421 reading the same this+0x1e and this+0x13df fields per its pseudocode, no RTTI or vtable was checked. Track N names for the globals exist in src/caption_lifecycle.h (cursor_type 0x5b44f0, cursor_variant 0x5b44f4, cursor_surface 0x5d162d, default_cursor_surface 0x5d0377, cursor_layer_enabled 0x5d1639, 0x5c39e5 labelled slider_cursor_scene) but that file does not contain this function and I do not know that the labels fit this use, so the comments call them cursor row, column, kind and so on. What the kinds mean in the game is not established. The five pushed constants at the call sites 0x47f749 (0x2791), 0x47f92b (0x278e), 0x47f950 (0x278d), 0x47f9a3 (0x278f) and 0x47f9f3 (0x2790) were read from the bytes, but the conditions guarding them come only from the Ghidra pseudocode of FUN_0047f421 (a hint): 0x2791 after setting this+0x13df, 0x278e when this+0x1441 is non-zero, 0x278d when this+0x1417 is non-zero, 0x278f or 0x2790 when the pointer lies inside rectangles held in the payload record, the layout of the payload record (words at +0x8c2, +0x8c4, +0x8c6) is not decoded here. The routine reads the slot payload pointer unconditionally at entry, before the kind is examined, using this+0x1e as an unchecked slot index. 0x278e does not use the payload at all. For kinds other than 0x278e, 0x278f and 0x2790 the row is 0x16 when this+0x13df is zero and the kind is not 0x278d, otherwise the payload word +0x8c2. The final cursor-table pointer is a full 32-bit address into the table at 0x5b160c (row stride 32, column stride 16), not an index.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_payload_ptr, 0x4  # [ebp - 0x4]: pointer to the action slot payload record (slot table 0x5bb5e5 entry for this+0x1e)
.equ local_this, 0x8  # [ebp - 0x8]: this, spilled from ecx
.equ arg_cursor_kind, 0x8  # [ebp + 0x8]: int16 cursor kind (0x278d to 0x2791)
.equ this_slot_index, 0x1e  # this+0x1e: int16 action slot index (0x8d-byte slots at 0x5bb5e3)
.equ payload_row_general, 0x8c2  # payload record +0x8c2: int16 cursor row for the general case
.equ payload_row_278f, 0x8c4  # payload record +0x8c4: int16 cursor row used for kind 0x278f
.equ payload_row_2790, 0x8c6  # payload record +0x8c6: int16 cursor row used for kind 0x2790
.equ this_flag_13df, 0x13df  # this+0x13df: dword flag, zero selects the fixed row 0x16 unless the kind is 0x278d

# --- external targets -----------------------------------------------

.org 0x0047fd65 - 0x401000
.globl FUN_0047fd65
FUN_0047fd65:
    # block 0x0047fd65: entry: spill this, load the slot payload pointer from 0x5bb5e5 + (int16 this+0x1e)*0x8d into local_payload_ptr, compare the kind with 0x278e, not equal goes to L_not_kind_278e (jne)
    push ebp                                     # 0047fd65
    {load} mov ebp, esp                          # 0047fd66
    sub esp, 0x8                                 # 0047fd68
    mov dword ptr [ebp - local_this], ecx           # 0047fd6b
    mov eax, dword ptr [ebp - local_this]           # 0047fd6e
    movsx ecx, word ptr [eax + this_slot_index]         # 0047fd71
    imul ecx, ecx, 0x8d                          # 0047fd75
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047fd7b
    mov dword ptr [ebp - local_payload_ptr], edx           # 0047fd81
    movsx eax, word ptr [ebp + arg_cursor_kind]            # 0047fd84
    cmp eax, 0x278e                              # 0047fd88
    jne.d8 L_not_kind_278e                            # 0047fd8d
    # block 0x0047fd8f: kind 0x278e: cursor row 0x5b44f0 = 0x14, column 0x5b44f4 = 0, 0x5d162d = 0x5d0377, 0x5d1631 = 0x5b160c + (row << 5) + (column << 4), 0x5d1639 = 1, 0x5c39e5 = kind, then jump to L_epilogue
    mov dword ptr [0x5b44f0], 0x14               # 0047fd8f
    mov dword ptr [0x5b44f4], 0x0                # 0047fd99
    mov ecx, dword ptr [0x5d0377]                # 0047fda3
    mov dword ptr [0x5d162d], ecx                # 0047fda9
    mov edx, dword ptr [0x5b44f0]                # 0047fdaf
    shl edx, 0x5                                 # 0047fdb5
    mov eax, dword ptr [0x5b44f4]                # 0047fdb8
    shl eax, 0x4                                 # 0047fdbd
    lea ecx, [edx + eax + 0x5b160c]              # 0047fdc0
    mov dword ptr [0x5d1631], ecx                # 0047fdc7
    mov dword ptr [0x5d1639], 0x1                # 0047fdcd
    movsx edx, word ptr [ebp + arg_cursor_kind]            # 0047fdd7
    mov dword ptr [0x5c39e5], edx                # 0047fddb
    jmp.d32 L_epilogue                           # 0047fde1
L_not_kind_278e:
    # block 0x0047fde6: kind is not 0x278e: compare with 0x278f, equal goes to L_kind_278f_or_2790 (je)
    movsx eax, word ptr [ebp + arg_cursor_kind]            # 0047fde6
    cmp eax, 0x278f                              # 0047fdea
    je.d32 L_kind_278f_or_2790                            # 0047fdef
    # block 0x0047fdf5: compare with 0x2790, equal goes to L_kind_278f_or_2790 (je)
    movsx ecx, word ptr [ebp + arg_cursor_kind]            # 0047fdf5
    cmp ecx, 0x2790                              # 0047fdf9
    je.d32 L_kind_278f_or_2790                            # 0047fdff
    # block 0x0047fe05: any other kind: if the dword this+0x13df is non-zero take the payload row path (jne to L_row_from_payload)
    mov edx, dword ptr [ebp - local_this]           # 0047fe05
    cmp dword ptr [edx + this_flag_13df], 0x0        # 0047fe08
    jne.d8 L_row_from_payload                            # 0047fe0f
    # block 0x0047fe11: this+0x13df is zero: kind != 0x278d goes to L_row_fixed_16 (jne), kind == 0x278d falls into the payload row path
    movsx eax, word ptr [ebp + arg_cursor_kind]            # 0047fe11
    cmp eax, 0x278d                              # 0047fe15
    jne.d8 L_row_fixed_16                            # 0047fe1a
L_row_from_payload:
    # block 0x0047fe1c: payload row path: 0x5b44f0 = sign-extended int16 payload+0x8c2, 0x5b44f4 = 1, 0x5d162d = 0x5d0377, jump to L_finish_general
    mov ecx, dword ptr [ebp - local_payload_ptr]           # 0047fe1c
    movsx edx, word ptr [ecx + payload_row_general]        # 0047fe1f
    mov dword ptr [0x5b44f0], edx                # 0047fe26
    mov dword ptr [0x5b44f4], 0x1                # 0047fe2c
    mov eax, dword ptr [0x5d0377]                # 0047fe36
    mov dword ptr [0x5d162d], eax                # 0047fe3b
    jmp.d8 L_finish_general                            # 0047fe40
L_row_fixed_16:
    # block 0x0047fe42: fixed row path: 0x5b44f0 = 0x16, 0x5b44f4 = 1, 0x5d162d = 0x5d0377
    mov dword ptr [0x5b44f0], 0x16               # 0047fe42
    mov dword ptr [0x5b44f4], 0x1                # 0047fe4c
    mov ecx, dword ptr [0x5d0377]                # 0047fe56
    mov dword ptr [0x5d162d], ecx                # 0047fe5c
L_finish_general:
    # block 0x0047fe62: general finish: 0x5d1631 = 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4), 0x5d1639 = 1, 0x5c39e5 = kind, jump to L_epilogue
    mov edx, dword ptr [0x5b44f0]                # 0047fe62
    shl edx, 0x5                                 # 0047fe68
    mov eax, dword ptr [0x5b44f4]                # 0047fe6b
    shl eax, 0x4                                 # 0047fe70
    lea ecx, [edx + eax + 0x5b160c]              # 0047fe73
    mov dword ptr [0x5d1631], ecx                # 0047fe7a
    mov dword ptr [0x5d1639], 0x1                # 0047fe80
    movsx edx, word ptr [ebp + arg_cursor_kind]            # 0047fe8a
    mov dword ptr [0x5c39e5], edx                # 0047fe8e
    jmp.d8 L_epilogue                            # 0047fe94
L_kind_278f_or_2790:
    # block 0x0047fe96: kind 0x278f or 0x2790: column 0x5b44f4 = 1, 0x5d162d = 0x5d0377, kind == 0x278f? not equal goes to L_row_278f_not_taken (jne)
    mov dword ptr [0x5b44f4], 0x1                # 0047fe96
    mov eax, dword ptr [0x5d0377]                # 0047fea0
    mov dword ptr [0x5d162d], eax                # 0047fea5
    movsx ecx, word ptr [ebp + arg_cursor_kind]            # 0047feaa
    cmp ecx, 0x278f                              # 0047feae
    jne.d8 L_row_278f_not_taken                            # 0047feb4
    # block 0x0047feb6: kind 0x278f: 0x5b44f0 = sign-extended int16 payload+0x8c4, jump to L_finish_278f_2790
    mov edx, dword ptr [ebp - local_payload_ptr]           # 0047feb6
    movsx eax, word ptr [edx + payload_row_278f]        # 0047feb9
    mov dword ptr [0x5b44f0], eax                # 0047fec0
    jmp.d8 L_finish_278f_2790                            # 0047fec5
L_row_278f_not_taken:
    # block 0x0047fec7: kind 0x2790: 0x5b44f0 = sign-extended int16 payload+0x8c6
    mov ecx, dword ptr [ebp - local_payload_ptr]           # 0047fec7
    movsx edx, word ptr [ecx + payload_row_2790]        # 0047feca
    mov dword ptr [0x5b44f0], edx                # 0047fed1
L_finish_278f_2790:
    # block 0x0047fed7: finish for 0x278f and 0x2790: 0x5d1631 = 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4), 0x5d1639 = 1, 0x5c39e5 = kind
    mov eax, dword ptr [0x5b44f0]                # 0047fed7
    shl eax, 0x5                                 # 0047fedc
    mov ecx, dword ptr [0x5b44f4]                # 0047fedf
    shl ecx, 0x4                                 # 0047fee5
    lea edx, [eax + ecx + 0x5b160c]              # 0047fee8
    mov dword ptr [0x5d1631], edx                # 0047feef
    mov dword ptr [0x5d1639], 0x1                # 0047fef5
    movsx eax, word ptr [ebp + arg_cursor_kind]            # 0047feff
    mov dword ptr [0x5c39e5], eax                # 0047ff03
L_epilogue:
    # block 0x0047ff08: epilogue: restore the frame and return, popping the one stack argument (ret 4)
    {load} mov esp, ebp                          # 0047ff08
    pop ebp                                      # 0047ff0a
    ret 0x4                                      # 0047ff0b
