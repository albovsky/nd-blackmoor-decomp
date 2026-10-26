# FUN_004e1305
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1305
# extent:       0x004e1305-0x004e13e4 (223 code bytes)
# span:         0x004e1305-0x004e13e4 (code 223, tables 0, padding 0)
# sha256:       bcae7f0205b7b6a960a1b2d5e84d24d5ddd2895ad1e48bdb567f3f37cf214151
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e1305_lifted
# naming:       native port src/original_methods_fl41.c:m4e1305_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 21 seeds; oracle: 59/59 instructions, 20/20 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004eb96e, FUN_004e303b, FUN_004e7d04
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4e1305_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 59 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_004e303b, .text + (0x004e303b - 0x401000)
.set FUN_004e7d04, .text + (0x004e7d04 - 0x401000)
.set FUN_004eb96e, .text + (0x004eb96e - 0x401000)

.org 0x004e1305 - 0x401000
.globl FUN_004e1305
FUN_004e1305:
    # block 0x004e1305: entry, 9 instruction(s), ends with je to 0x004e13de (forward)
    push ebp                                     # 004e1305
    {load} mov ebp, esp                          # 004e1306
    sub esp, 0x8                                 # 004e1308
    mov dword ptr [ebp - local_4], ecx           # 004e130b
    mov eax, dword ptr [ebp + arg_10]            # 004e130e
    mov dword ptr [eax], 0x1                     # 004e1311
    movsx ecx, word ptr [ebp + arg_8]            # 004e1317
    test ecx, ecx                                # 004e131b
    je.d32 L_004e13de                            # 004e131d
    # block 0x004e1323: entered by fall-through of je at 0x004e131d, 4 instruction(s), ends with je to 0x004e1341 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004e1323
    mov dword ptr [ebp - local_8], edx           # 004e1327
    cmp dword ptr [ebp - local_8], 0x1           # 004e132a
    je.d8 L_004e1341                             # 004e132e
    # block 0x004e1330: entered by fall-through of je at 0x004e132e, 2 instruction(s), ends with je to 0x004e1376 (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004e1330
    je.d8 L_004e1376                             # 004e1334
    # block 0x004e1336: entered by fall-through of je at 0x004e1334, 2 instruction(s), ends with je to 0x004e13ab (forward)
    cmp dword ptr [ebp - local_8], 0x3           # 004e1336
    je.d8 L_004e13ab                             # 004e133a
    # block 0x004e133c: entered by fall-through of je at 0x004e133a, 1 instruction(s), ends with forward jump to 0x004e13de
    jmp.d32 L_004e13de                           # 004e133c
L_004e1341:
    # block 0x004e1341: entered by je at 0x004e132e, 2 instruction(s), ends with jne to 0x004e1356 (forward)
    cmp dword ptr [0x583204], 0x4                # 004e1341
    jne.d8 L_004e1356                            # 004e1348
    # block 0x004e134a: entered by fall-through of jne at 0x004e1348, 3 instruction(s), calls FUN_004eb96e, ends with forward jump to 0x004e1374
    mov ecx, 0x57fd34                            # 004e134a
    call FUN_004eb96e                            # 004e134f
    jmp.d8 L_004e1374                            # 004e1354
L_004e1356:
    # block 0x004e1356: entered by jne at 0x004e1348, 2 instruction(s), ends with jne to 0x004e136b (forward)
    cmp dword ptr [0x583204], 0x5                # 004e1356
    jne.d8 L_004e136b                            # 004e135d
    # block 0x004e135f: entered by fall-through of jne at 0x004e135d, 3 instruction(s), calls FUN_004e303b, ends with forward jump to 0x004e1374
    mov ecx, 0x57975c                            # 004e135f
    call FUN_004e303b                            # 004e1364
    jmp.d8 L_004e1374                            # 004e1369
L_004e136b:
    # block 0x004e136b: entered by jne at 0x004e135d, 2 instruction(s), falls into the block at 0x004e1374
    mov eax, dword ptr [ebp + arg_10]            # 004e136b
    mov dword ptr [eax], 0x0                     # 004e136e
L_004e1374:
    # block 0x004e1374: entered by jmp at 0x004e1354; jmp at 0x004e1369, 1 instruction(s), ends with forward jump to 0x004e13de
    jmp.d8 L_004e13de                            # 004e1374
L_004e1376:
    # block 0x004e1376: entered by je at 0x004e1334, 2 instruction(s), ends with jne to 0x004e138b (forward)
    cmp dword ptr [0x583204], 0x3                # 004e1376
    jne.d8 L_004e138b                            # 004e137d
    # block 0x004e137f: entered by fall-through of jne at 0x004e137d, 3 instruction(s), calls FUN_004e7d04, ends with forward jump to 0x004e13a9
    mov ecx, 0x571442                            # 004e137f
    call FUN_004e7d04                            # 004e1384
    jmp.d8 L_004e13a9                            # 004e1389
L_004e138b:
    # block 0x004e138b: entered by jne at 0x004e137d, 2 instruction(s), ends with jne to 0x004e13a0 (forward)
    cmp dword ptr [0x583204], 0x5                # 004e138b
    jne.d8 L_004e13a0                            # 004e1392
    # block 0x004e1394: entered by fall-through of jne at 0x004e1392, 3 instruction(s), calls FUN_004e303b, ends with forward jump to 0x004e13a9
    mov ecx, 0x57975c                            # 004e1394
    call FUN_004e303b                            # 004e1399
    jmp.d8 L_004e13a9                            # 004e139e
L_004e13a0:
    # block 0x004e13a0: entered by jne at 0x004e1392, 2 instruction(s), falls into the block at 0x004e13a9
    mov ecx, dword ptr [ebp + arg_10]            # 004e13a0
    mov dword ptr [ecx], 0x0                     # 004e13a3
L_004e13a9:
    # block 0x004e13a9: entered by jmp at 0x004e1389; jmp at 0x004e139e, 1 instruction(s), ends with forward jump to 0x004e13de
    jmp.d8 L_004e13de                            # 004e13a9
L_004e13ab:
    # block 0x004e13ab: entered by je at 0x004e133a, 2 instruction(s), ends with jne to 0x004e13c0 (forward)
    cmp dword ptr [0x583204], 0x3                # 004e13ab
    jne.d8 L_004e13c0                            # 004e13b2
    # block 0x004e13b4: entered by fall-through of jne at 0x004e13b2, 3 instruction(s), calls FUN_004e7d04, ends with forward jump to 0x004e13de
    mov ecx, 0x571442                            # 004e13b4
    call FUN_004e7d04                            # 004e13b9
    jmp.d8 L_004e13de                            # 004e13be
L_004e13c0:
    # block 0x004e13c0: entered by jne at 0x004e13b2, 2 instruction(s), ends with jne to 0x004e13d5 (forward)
    cmp dword ptr [0x583204], 0x4                # 004e13c0
    jne.d8 L_004e13d5                            # 004e13c7
    # block 0x004e13c9: entered by fall-through of jne at 0x004e13c7, 3 instruction(s), calls FUN_004eb96e, ends with forward jump to 0x004e13de
    mov ecx, 0x57fd34                            # 004e13c9
    call FUN_004eb96e                            # 004e13ce
    jmp.d8 L_004e13de                            # 004e13d3
L_004e13d5:
    # block 0x004e13d5: entered by jne at 0x004e13c7, 2 instruction(s), falls into the block at 0x004e13de
    mov edx, dword ptr [ebp + arg_10]            # 004e13d5
    mov dword ptr [edx], 0x0                     # 004e13d8
L_004e13de:
    # block 0x004e13de: entered by je at 0x004e131d; jmp at 0x004e133c; jmp at 0x004e1374; jmp at 0x004e13a9; more, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004e13de
    pop ebp                                      # 004e13e0
    ret 0xc                                      # 004e13e1

