# FUN_00426c51
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426c51
# extent:       0x00426c51-0x00426cf4 (163 code bytes)
# span:         0x00426c51-0x00426cf4 (code 163, tables 0, padding 0)
# sha256:       4fa461a761a0b4d79be5428fa9326ff5576dabe64a0547011aedc1c4bc941f90
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m426c51_lifted
# naming:       native port src/original_methods_fl40.c:m426c51_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 4 seeds; oracle 45/45 instructions, 6/6 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_ca145; [ecx + n] field_34888; [edx + n] field_ca145
# callees:      calls FUN_00437614, FUN_0044a2b7, FUN_0043f0fb, FUN_0050ca3e, FUN_0050cee4, FUN_00524f85
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426c51_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_34888, 0x34888  # offset +0x34888
.equ field_ca145, 0xca145  # offset +0xca145

# --- external targets -----------------------------------------------
.set FUN_00437614, .text + (0x00437614 - 0x401000)
.set FUN_0043f0fb, .text + (0x0043f0fb - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_00524f85, .text + (0x00524f85 - 0x401000)

.org 0x00426c51 - 0x401000
.globl FUN_00426c51
FUN_00426c51:
    # block 0x00426c51: entry, 9 instruction(s), calls FUN_00437614, ends with je to 0x00426c78 (forward)
    push ebp                                     # 00426c51
    {load} mov ebp, esp                          # 00426c52
    push ecx                                     # 00426c54
    mov dword ptr [ebp - local_4], ecx           # 00426c55
    call FUN_00437614                            # 00426c58
    mov eax, dword ptr [ebp - local_4]           # 00426c5d
    movsx ecx, word ptr [eax + field_ca145]      # 00426c60
    test ecx, ecx                                # 00426c67
    je.d8 L_00426c78                             # 00426c69
    # block 0x00426c6b: entered by fall-through of je at 0x00426c69, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00426c78
    push 0x5454f0                                # 00426c6b
    call FUN_0044a2b7                            # 00426c70
    add esp, 0x4                                 # 00426c75
L_00426c78:
    # block 0x00426c78: entered by je at 0x00426c69, 7 instruction(s), calls FUN_0043f0fb, ends with je to 0x00426cbb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00426c78
    add ecx, 0x62ba5                             # 00426c7b
    call FUN_0043f0fb                            # 00426c81
    mov edx, dword ptr [ebp - local_4]           # 00426c86
    movsx eax, word ptr [edx + field_ca145]      # 00426c89
    test eax, eax                                # 00426c90
    je.d8 L_00426cbb                             # 00426c92
    # block 0x00426c94: entered by fall-through of je at 0x00426c92, 9 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00426cbb
    movsx ecx, word ptr [0x5d04df]               # 00426c94
    push ecx                                     # 00426c9b
    push 0x545504                                # 00426c9c
    push 0x63888b                                # 00426ca1
    call FUN_0050ca3e                            # 00426ca6
    add esp, 0xc                                 # 00426cab
    push 0x63888b                                # 00426cae
    call FUN_0044a2b7                            # 00426cb3
    add esp, 0x4                                 # 00426cb8
L_00426cbb:
    # block 0x00426cbb: entered by je at 0x00426c92, 4 instruction(s), ends with je to 0x00426ce8 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00426cbb
    movsx eax, word ptr [edx + field_ca145]      # 00426cbe
    test eax, eax                                # 00426cc5
    je.d8 L_00426ce8                             # 00426cc7
    # block 0x00426cc9: entered by fall-through of je at 0x00426cc7, 8 instruction(s), calls FUN_0044a2b7, FUN_0050cee4, falls into the block at 0x00426ce8
    push 0x545528                                # 00426cc9
    call FUN_0044a2b7                            # 00426cce
    add esp, 0x4                                 # 00426cd3
    mov ecx, dword ptr [ebp - local_4]           # 00426cd6
    mov edx, dword ptr [ecx + field_34888]       # 00426cd9
    push edx                                     # 00426cdf
    call FUN_0050cee4                            # 00426ce0
    add esp, 0x4                                 # 00426ce5
L_00426ce8:
    # block 0x00426ce8: entered by je at 0x00426cc7, 5 instruction(s), calls FUN_00524f85, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00426ce8
    call FUN_00524f85                            # 00426ceb
    {load} mov esp, ebp                          # 00426cf0
    pop ebp                                      # 00426cf2
    ret                                          # 00426cf3

