# FUN_004bf10f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf10f
# extent:       0x004bf10f-0x004bf19a (139 code bytes)
# span:         0x004bf10f-0x004bf19a (code 139, tables 0, padding 0)
# sha256:       8ff4f95ff0aa5b703b2f812bf1ed8bed592c7ff1d2b1b452ef73e2d8440182e5
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf10f_bink_next
# naming:       native port src/original_methods_fl27a.c:m4bf10f_bink_next (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4bf10f_bink_next: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_c, field_2c0; [ecx + n] field_8, field_c, field_2c4; [edx + n] field_c
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkNextFrame@4, binkw32.dll!_BinkGoto@12
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27a.c:m4bf10f_bink_next (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 46 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_2c0, 0x2c0  # offset +0x2c0
.equ field_2c4, 0x2c4  # offset +0x2c4

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004bf10f - 0x401000
.globl FUN_004bf10f
FUN_004bf10f:
    # block 0x004bf10f: entry, 8 instruction(s), calls FUN_004bf38c, ends with jne to 0x004bf137 (forward)
    push ebp                                     # 004bf10f
    {load} mov ebp, esp                          # 004bf110
    sub esp, 0x8                                 # 004bf112
    mov dword ptr [ebp - local_4], ecx           # 004bf115
    mov ecx, dword ptr [ebp - local_4]           # 004bf118
    call FUN_004bf38c                            # 004bf11b
    cmp dword ptr [ebp + arg_8], 0x0             # 004bf120
    jne.d8 L_004bf137                            # 004bf124
    # block 0x004bf126: entered by fall-through of jne at 0x004bf124, 4 instruction(s), ends with forward jump to 0x004bf194
    mov eax, dword ptr [ebp - local_4]           # 004bf126
    mov dword ptr [eax + field_2c0], 0xfffffffd  # 004bf129
    {load} xor eax, eax                          # 004bf133
    jmp.d8 L_004bf194                            # 004bf135
L_004bf137:
    # block 0x004bf137: entered by jne at 0x004bf124, 5 instruction(s), ends with je to 0x004bf16c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bf137
    mov edx, dword ptr [ecx + field_2c4]         # 004bf13a
    mov dword ptr [ebp - local_8], edx           # 004bf140
    cmp dword ptr [ebp - local_8], 0x1           # 004bf143
    je.d8 L_004bf16c                             # 004bf147
    # block 0x004bf149: entered by fall-through of je at 0x004bf147, 5 instruction(s), ends with jne to 0x004bf15b (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004bf149
    mov ecx, dword ptr [ebp + arg_8]             # 004bf14c
    mov edx, dword ptr [eax + field_c]           # 004bf14f
    cmp edx, dword ptr [ecx + field_8]           # 004bf152
    jne.d8 L_004bf15b                            # 004bf155
    # block 0x004bf157: entered by fall-through of jne at 0x004bf155, 2 instruction(s), ends with forward jump to 0x004bf194
    {load} xor eax, eax                          # 004bf157
    jmp.d8 L_004bf194                            # 004bf159
L_004bf15b:
    # block 0x004bf15b: entered by jne at 0x004bf155, 5 instruction(s), calls binkw32.dll!_BinkNextFrame@4, ends with forward jump to 0x004bf194
    mov eax, dword ptr [ebp + arg_8]             # 004bf15b
    push eax                                     # 004bf15e
    call dword ptr [0x52a520]                    # 004bf15f
    mov eax, 0x1                                 # 004bf165
    jmp.d8 L_004bf194                            # 004bf16a
L_004bf16c:
    # block 0x004bf16c: entered by je at 0x004bf147, 3 instruction(s), ends with jne to 0x004bf179 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004bf16c
    cmp dword ptr [ecx + field_c], 0x1           # 004bf16f
    jne.d8 L_004bf179                            # 004bf173
    # block 0x004bf175: entered by fall-through of jne at 0x004bf173, 2 instruction(s), ends with forward jump to 0x004bf194
    {load} xor eax, eax                          # 004bf175
    jmp.d8 L_004bf194                            # 004bf177
L_004bf179:
    # block 0x004bf179: entered by jne at 0x004bf173, 9 instruction(s), calls binkw32.dll!_BinkGoto@12, falls into the block at 0x004bf194
    push 0x0                                     # 004bf179
    mov edx, dword ptr [ebp + arg_8]             # 004bf17b
    mov eax, dword ptr [edx + field_c]           # 004bf17e
    sub eax, 0x1                                 # 004bf181
    push eax                                     # 004bf184
    mov ecx, dword ptr [ebp + arg_8]             # 004bf185
    push ecx                                     # 004bf188
    call dword ptr [0x52a530]                    # 004bf189
    mov eax, 0x1                                 # 004bf18f
L_004bf194:
    # block 0x004bf194: entered by jmp at 0x004bf135; jmp at 0x004bf159; jmp at 0x004bf16a; jmp at 0x004bf177, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004bf194
    pop ebp                                      # 004bf196
    ret 0x4                                      # 004bf197

