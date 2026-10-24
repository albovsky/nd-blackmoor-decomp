# FUN_004a140b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a140b
# extent:       0x004a140b-0x004a14c6 (187 code bytes)
# span:         0x004a140b-0x004a14c6 (code 187, tables 0, padding 0)
# sha256:       0ba41b8085f195a786116bfc1e50e68004a63e50dd76808bcf279824cf48c15f
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a140b_lifted
# naming:       native port src/original_methods_fl41.c:m4a140b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 8 seeds; oracle: 51/51 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_dec, field_df0, field_df4; [ecx + n] field_4, field_df0; [edx + n] field_dec, field_df0
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4a140b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 51 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_dec, 0xdec  # offset +0xdec
.equ field_df0, 0xdf0  # offset +0xdf0
.equ field_df4, 0xdf4  # offset +0xdf4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004a140b - 0x401000
.globl FUN_004a140b
FUN_004a140b:
    # block 0x004a140b: entry, 10 instruction(s), ends with jl to 0x004a1475 (forward)
    push ebp                                     # 004a140b
    {load} mov ebp, esp                          # 004a140c
    push ecx                                     # 004a140e
    mov dword ptr [ebp - local_4], ecx           # 004a140f
    mov eax, dword ptr [ebp - local_4]           # 004a1412
    mov ecx, dword ptr [eax + field_df4]         # 004a1415
    sub ecx, 0x1                                 # 004a141b
    mov edx, dword ptr [ebp - local_4]           # 004a141e
    cmp dword ptr [edx + field_df0], ecx         # 004a1421
    jl.d8 L_004a1475                             # 004a1427
    # block 0x004a1429: entered by fall-through of jl at 0x004a1427, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x004a146b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a1429
    mov ecx, dword ptr [eax + field_df0]         # 004a142c
    push ecx                                     # 004a1432
    push 0x550278                                # 004a1433
    push 0x63888b                                # 004a1438
    call FUN_0050ca3e                            # 004a143d
    add esp, 0xc                                 # 004a1442
    push 0x0                                     # 004a1445
    push 0x0                                     # 004a1447
    push 0x63888b                                # 004a1449
    call FUN_0052139c                            # 004a144e
    movsx edx, word ptr [0x63a4cd]               # 004a1453
    test edx, edx                                # 004a145a
    je.d8 L_004a146b                             # 004a145c
    # block 0x004a145e: entered by fall-through of je at 0x004a145c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004a146b
    push 0x63888b                                # 004a145e
    call FUN_0044a2b7                            # 004a1463
    add esp, 0x4                                 # 004a1468
L_004a146b:
    # block 0x004a146b: entered by je at 0x004a145c, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x004a1475
    mov ecx, 0x5cf659                            # 004a146b
    call FUN_004c97b4                            # 004a1470
L_004a1475:
    # block 0x004a1475: entered by jl at 0x004a1427, 22 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004a1475
    mov ecx, dword ptr [eax + field_df0]         # 004a1478
    add ecx, 0x1                                 # 004a147e
    mov edx, dword ptr [ebp - local_4]           # 004a1481
    mov dword ptr [edx + field_df0], ecx         # 004a1484
    mov eax, dword ptr [ebp - local_4]           # 004a148a
    mov ecx, dword ptr [eax + field_df0]         # 004a148d
    mov edx, dword ptr [ebp - local_4]           # 004a1493
    mov eax, dword ptr [edx + field_dec]         # 004a1496
    mov edx, dword ptr [ebp + arg_8]             # 004a149c
    mov eax, dword ptr [eax + 8*ecx]             # 004a149f
    mov dword ptr [edx], eax                     # 004a14a2
    mov ecx, dword ptr [ebp - local_4]           # 004a14a4
    mov edx, dword ptr [ecx + field_df0]         # 004a14a7
    mov eax, dword ptr [ebp - local_4]           # 004a14ad
    mov ecx, dword ptr [eax + field_dec]         # 004a14b0
    mov eax, dword ptr [ebp + arg_8]             # 004a14b6
    mov ecx, dword ptr [ecx + 8*edx + field_4]   # 004a14b9
    mov dword ptr [eax + field_4], ecx           # 004a14bd
    {load} mov esp, ebp                          # 004a14c0
    pop ebp                                      # 004a14c2
    ret 0x4                                      # 004a14c3

