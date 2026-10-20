# FUN_00423142
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423142
# extent:       0x00423142-0x00423259 (279 code bytes)
# span:         0x00423142-0x00423259 (code 279, tables 0, padding 0)
# sha256:       6910fd42954f15d645d47b5092f2f8856dca626982d0c7e053a167083309f578
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m423142_insert
# naming:       native port src/original_methods_fl28a.c:m423142_insert (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m423142_insert: the oracle runs every instruction of 0x423142..0x423259 and both jump directions, comparing ordered host calls and memory. See tasks/fl28a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00423368, FUN_0051dc43, FUN_00423000
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28a.c:m423142_insert (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 101 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00423000, .text + (0x00423000 - 0x401000)
.set FUN_00423368, .text + (0x00423368 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00423142 - 0x401000
.globl FUN_00423142
FUN_00423142:
    # block 0x00423142: entry, 20 instruction(s), calls FUN_00423368, falls into the block at 0x0042317d
    push ebp                                     # 00423142
    {load} mov ebp, esp                          # 00423143
    push -0x1                                    # 00423145
    push 0x5273db                                # 00423147
    mov eax, dword ptr fs:[0x0]                  # 0042314c
    push eax                                     # 00423152
    mov dword ptr fs:[0x0], esp                  # 00423153
    sub esp, 0x1c                                # 0042315a
    push esi                                     # 0042315d
    push edi                                     # 0042315e
    mov dword ptr [ebp - local_24], ecx          # 0042315f
    mov eax, dword ptr [ebp + arg_8]             # 00423162
    push eax                                     # 00423165
    mov ecx, dword ptr [ebp - local_24]          # 00423166
    call FUN_00423368                            # 00423169
    mov dword ptr [ebp - local_14], eax          # 0042316e
    mov ecx, dword ptr [ebp - local_14]          # 00423171
    mov edx, dword ptr [ebp - local_24]          # 00423174
    lea eax, [edx + 4*ecx]                       # 00423177
    mov dword ptr [ebp - local_10], eax          # 0042317a
L_0042317d:
    # block 0x0042317d: entered by jmp at 0x00423190, 3 instruction(s), ends with je to 0x00423192 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0042317d
    cmp dword ptr [ecx], 0x0                     # 00423180
    je.d8 L_00423192                             # 00423183
    # block 0x00423185: entered by fall-through of je at 0x00423183, 5 instruction(s), ends with backward jump to 0x0042317d
    mov edx, dword ptr [ebp - local_10]          # 00423185
    mov eax, dword ptr [edx]                     # 00423188
    add eax, 0x25                                # 0042318a
    mov dword ptr [ebp - local_10], eax          # 0042318d
    jmp.d8 L_0042317d                            # 00423190
L_00423192:
    # block 0x00423192: entered by je at 0x00423183, 7 instruction(s), calls FUN_0051dc43, ends with je to 0x004231b9 (forward)
    push 0x29                                    # 00423192
    call FUN_0051dc43                            # 00423194
    add esp, 0x4                                 # 00423199
    mov dword ptr [ebp - local_1c], eax          # 0042319c
    mov dword ptr [ebp - local_4], 0x0           # 0042319f
    cmp dword ptr [ebp - local_1c], 0x0          # 004231a6
    je.d8 L_004231b9                             # 004231aa
    # block 0x004231ac: entered by fall-through of je at 0x004231aa, 4 instruction(s), calls FUN_00423000, ends with forward jump to 0x004231c0
    mov ecx, dword ptr [ebp - local_1c]          # 004231ac
    call FUN_00423000                            # 004231af
    mov dword ptr [ebp - local_28], eax          # 004231b4
    jmp.d8 L_004231c0                            # 004231b7
L_004231b9:
    # block 0x004231b9: entered by je at 0x004231aa, 1 instruction(s), falls into the block at 0x004231c0
    mov dword ptr [ebp - local_28], 0x0          # 004231b9
L_004231c0:
    # block 0x004231c0: entered by jmp at 0x004231b7, 61 instruction(s), calls FUN_0051dc43, ends with ret 0x8
    mov ecx, dword ptr [ebp - local_28]          # 004231c0
    mov dword ptr [ebp - local_18], ecx          # 004231c3
    mov dword ptr [ebp - local_4], 0xffffffff    # 004231c6
    mov edx, dword ptr [ebp - local_10]          # 004231cd
    mov eax, dword ptr [ebp - local_18]          # 004231d0
    mov dword ptr [edx], eax                     # 004231d3
    mov edi, dword ptr [ebp + arg_c]             # 004231d5
    or ecx, -0x1                                 # 004231d8
    {load} xor eax, eax                          # 004231db
    repne scasb al, byte ptr es:[edi]            # 004231dd
    not ecx                                      # 004231df
    inc ecx                                      # 004231e1
    push ecx                                     # 004231e2
    call FUN_0051dc43                            # 004231e3
    add esp, 0x4                                 # 004231e8
    mov dword ptr [ebp - local_20], eax          # 004231eb
    mov ecx, dword ptr [ebp - local_10]          # 004231ee
    mov edx, dword ptr [ecx]                     # 004231f1
    mov eax, dword ptr [ebp - local_20]          # 004231f3
    mov dword ptr [edx], eax                     # 004231f6
    mov edi, dword ptr [ebp + arg_8]             # 004231f8
    mov ecx, dword ptr [ebp - local_10]          # 004231fb
    mov edx, dword ptr [ecx]                     # 004231fe
    add edx, 0x4                                 # 00423200
    or ecx, -0x1                                 # 00423203
    {load} xor eax, eax                          # 00423206
    repne scasb al, byte ptr es:[edi]            # 00423208
    not ecx                                      # 0042320a
    {load} sub edi, ecx                          # 0042320c
    {load} mov esi, edi                          # 0042320e
    {load} mov eax, ecx                          # 00423210
    {load} mov edi, edx                          # 00423212
    shr ecx, 0x2                                 # 00423214
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00423217
    {load} mov ecx, eax                          # 00423219
    and ecx, 0x3                                 # 0042321b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0042321e
    mov edi, dword ptr [ebp + arg_c]             # 00423220
    mov ecx, dword ptr [ebp - local_10]          # 00423223
    mov edx, dword ptr [ecx]                     # 00423226
    mov edx, dword ptr [edx]                     # 00423228
    or ecx, -0x1                                 # 0042322a
    {load} xor eax, eax                          # 0042322d
    repne scasb al, byte ptr es:[edi]            # 0042322f
    not ecx                                      # 00423231
    {load} sub edi, ecx                          # 00423233
    {load} mov esi, edi                          # 00423235
    {load} mov eax, ecx                          # 00423237
    {load} mov edi, edx                          # 00423239
    shr ecx, 0x2                                 # 0042323b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0042323e
    {load} mov ecx, eax                          # 00423240
    and ecx, 0x3                                 # 00423242
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00423245
    mov ecx, dword ptr [ebp - local_c]           # 00423247
    mov dword ptr fs:[0x0], ecx                  # 0042324a
    pop edi                                      # 00423251
    pop esi                                      # 00423252
    {load} mov esp, ebp                          # 00423253
    pop ebp                                      # 00423255
    ret 0x8                                      # 00423256

