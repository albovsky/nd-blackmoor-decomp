# FUN_004be1dd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be1dd
# extent:       0x004be1dd-0x004be2c6 (233 code bytes)
# span:         0x004be1dd-0x004be2c6 (code 233, tables 0, padding 0)
# sha256:       f5f9882550cde146a3a920a19af3e48d854c11bf6e55820615e5a5cc7ebffe23
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4be1dd_lifted
# naming:       native port src/original_methods_fl41.c:m4be1dd_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 8 seeds; oracle: 69/69 instructions, 18/18 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4c, field_14c, field_150; [ecx + n] field_4c, field_50, field_14c, field_150; [edx + n] field_4c, field_150
# callees:      calls FUN_004be2c6
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4be1dd_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_14c, 0x14c  # offset +0x14c
.equ field_150, 0x150  # offset +0x150

# --- external targets -----------------------------------------------
.set FUN_004be2c6, .text + (0x004be2c6 - 0x401000)

.org 0x004be1dd - 0x401000
.globl FUN_004be1dd
FUN_004be1dd:
    # block 0x004be1dd: entry, 7 instruction(s), ends with jne to 0x004be1f4 (forward)
    push ebp                                     # 004be1dd
    {load} mov ebp, esp                          # 004be1de
    sub esp, 0x10                                # 004be1e0
    mov dword ptr [ebp - local_10], ecx          # 004be1e3
    mov eax, dword ptr [ebp - local_10]          # 004be1e6
    cmp dword ptr [eax + field_4c], 0x0          # 004be1e9
    jne.d8 L_004be1f4                            # 004be1ed
    # block 0x004be1ef: entered by fall-through of jne at 0x004be1ed, 1 instruction(s), ends with forward jump to 0x004be2c0
    jmp.d32 L_004be2c0                           # 004be1ef
L_004be1f4:
    # block 0x004be1f4: entered by jne at 0x004be1ed, 2 instruction(s), ends with jne to 0x004be1ff (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004be1f4
    jne.d8 L_004be1ff                            # 004be1f8
    # block 0x004be1fa: entered by fall-through of jne at 0x004be1f8, 1 instruction(s), ends with forward jump to 0x004be2c0
    jmp.d32 L_004be2c0                           # 004be1fa
L_004be1ff:
    # block 0x004be1ff: entered by jne at 0x004be1f8, 10 instruction(s), ends with jne to 0x004be24c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004be1ff
    mov edx, dword ptr [ecx + field_150]         # 004be202
    mov dword ptr [ebp - local_c], edx           # 004be208
    mov eax, dword ptr [ebp + arg_8]             # 004be20b
    mov ecx, dword ptr [eax + field_14c]         # 004be20e
    mov dword ptr [ebp - local_8], ecx           # 004be214
    mov edx, dword ptr [ebp - local_10]          # 004be217
    mov eax, dword ptr [ebp + arg_8]             # 004be21a
    cmp eax, dword ptr [edx + field_4c]          # 004be21d
    jne.d8 L_004be24c                            # 004be220
    # block 0x004be222: entered by fall-through of jne at 0x004be220, 2 instruction(s), ends with je to 0x004be240 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004be222
    je.d8 L_004be240                             # 004be226
    # block 0x004be228: entered by fall-through of je at 0x004be226, 6 instruction(s), ends with forward jump to 0x004be24a
    mov ecx, dword ptr [ebp - local_10]          # 004be228
    mov edx, dword ptr [ebp - local_c]           # 004be22b
    mov dword ptr [ecx + field_4c], edx          # 004be22e
    mov eax, dword ptr [ebp - local_c]           # 004be231
    mov dword ptr [eax + field_14c], 0x0         # 004be234
    jmp.d8 L_004be24a                            # 004be23e
L_004be240:
    # block 0x004be240: entered by je at 0x004be226, 2 instruction(s), falls into the block at 0x004be24a
    mov ecx, dword ptr [ebp - local_10]          # 004be240
    mov dword ptr [ecx + field_4c], 0x0          # 004be243
L_004be24a:
    # block 0x004be24a: entered by jmp at 0x004be23e, 1 instruction(s), ends with forward jump to 0x004be285
    jmp.d8 L_004be285                            # 004be24a
L_004be24c:
    # block 0x004be24c: entered by jne at 0x004be220, 2 instruction(s), ends with je to 0x004be272 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004be24c
    je.d8 L_004be272                             # 004be250
    # block 0x004be252: entered by fall-through of je at 0x004be250, 2 instruction(s), ends with je to 0x004be272 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004be252
    je.d8 L_004be272                             # 004be256
    # block 0x004be258: entered by fall-through of je at 0x004be256, 7 instruction(s), ends with forward jump to 0x004be285
    mov edx, dword ptr [ebp - local_8]           # 004be258
    mov eax, dword ptr [ebp - local_c]           # 004be25b
    mov dword ptr [edx + field_150], eax         # 004be25e
    mov ecx, dword ptr [ebp - local_c]           # 004be264
    mov edx, dword ptr [ebp - local_8]           # 004be267
    mov dword ptr [ecx + field_14c], edx         # 004be26a
    jmp.d8 L_004be285                            # 004be270
L_004be272:
    # block 0x004be272: entered by je at 0x004be250; je at 0x004be256, 2 instruction(s), ends with je to 0x004be285 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004be272
    je.d8 L_004be285                             # 004be276
    # block 0x004be278: entered by fall-through of je at 0x004be276, 2 instruction(s), falls into the block at 0x004be285
    mov eax, dword ptr [ebp - local_8]           # 004be278
    mov dword ptr [eax + field_150], 0x0         # 004be27b
L_004be285:
    # block 0x004be285: entered by jmp at 0x004be24a; jmp at 0x004be270; je at 0x004be276, 3 instruction(s), ends with je to 0x004be2b4 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004be285
    cmp dword ptr [ecx + field_4c], 0x0          # 004be288
    je.d8 L_004be2b4                             # 004be28c
    # block 0x004be28e: entered by fall-through of je at 0x004be28c, 3 instruction(s), falls into the block at 0x004be297
    mov edx, dword ptr [ebp - local_10]          # 004be28e
    mov eax, dword ptr [edx + field_4c]          # 004be291
    mov dword ptr [ebp - local_4], eax           # 004be294
L_004be297:
    # block 0x004be297: entered by jmp at 0x004be2b2, 2 instruction(s), ends with je to 0x004be2b4 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004be297
    je.d8 L_004be2b4                             # 004be29b
    # block 0x004be29d: entered by fall-through of je at 0x004be29b, 7 instruction(s), ends with backward jump to 0x004be297
    mov ecx, dword ptr [ebp - local_10]          # 004be29d
    mov edx, dword ptr [ebp - local_4]           # 004be2a0
    mov dword ptr [ecx + field_50], edx          # 004be2a3
    mov eax, dword ptr [ebp - local_4]           # 004be2a6
    mov ecx, dword ptr [eax + field_150]         # 004be2a9
    mov dword ptr [ebp - local_4], ecx           # 004be2af
    jmp.d8 L_004be297                            # 004be2b2
L_004be2b4:
    # block 0x004be2b4: entered by je at 0x004be28c; je at 0x004be29b, 4 instruction(s), calls FUN_004be2c6, falls into the block at 0x004be2c0
    mov edx, dword ptr [ebp + arg_8]             # 004be2b4
    push edx                                     # 004be2b7
    mov ecx, dword ptr [ebp - local_10]          # 004be2b8
    call FUN_004be2c6                            # 004be2bb
L_004be2c0:
    # block 0x004be2c0: entered by jmp at 0x004be1ef; jmp at 0x004be1fa, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004be2c0
    pop ebp                                      # 004be2c2
    ret 0x4                                      # 004be2c3

