# FUN_004eaf2a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eaf2a
# extent:       0x004eaf2a-0x004eb0f7 (461 code bytes)
# span:         0x004eaf2a-0x004eb107 (code 461, tables 16, padding 0)
# sha256:       f7a2fcad72d1f0b0722d1b2093426c2361af98dcd54c44b9780307d511b24622
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4eaf2a_lifted
# naming:       native port src/original_methods_fl41.c:m4eaf2a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 13 seeds; oracle: 141/141 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1; [ecx + n] field_1; [edx + n] field_1
# callees:      calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4eaf2a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 141 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004eaf2a - 0x401000
.globl FUN_004eaf2a
FUN_004eaf2a:
    # block 0x004eaf2a: entry, 16 instruction(s), ends with ja to 0x004eb09c (forward)
    push ebp                                     # 004eaf2a
    {load} mov ebp, esp                          # 004eaf2b
    sub esp, 0xc                                 # 004eaf2d
    push esi                                     # 004eaf30
    push edi                                     # 004eaf31
    mov dword ptr [ebp - local_8], ecx           # 004eaf32
    movsx eax, word ptr [ebp + arg_8]            # 004eaf35
    imul eax, eax, 0x8d                          # 004eaf39
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eaf3f
    mov dword ptr [ebp - local_4], ecx           # 004eaf45
    mov edx, dword ptr [ebp - local_4]           # 004eaf48
    {load} xor eax, eax                          # 004eaf4b
    mov al, byte ptr [edx]                       # 004eaf4d
    mov dword ptr [ebp - local_c], eax           # 004eaf4f
    cmp dword ptr [ebp - local_c], 0x3           # 004eaf52
    ja.d32 L_004eb09c                            # 004eaf56
    # block 0x004eaf5c: entered by fall-through of ja at 0x004eaf56, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4eb0f7]
    mov ecx, dword ptr [ebp - local_c]           # 004eaf5c
    jmp dword ptr [4*ecx + SWTAB_004eb0f7_VA]    # 004eaf5f
L_004eaf66:
    # block 0x004eaf66: entered by switch case, 23 instruction(s), ends with forward jump to 0x004eb0de
    mov edx, dword ptr [ebp - local_4]           # 004eaf66
    movsx eax, word ptr [edx + field_1]          # 004eaf69
    imul eax, eax, 0x6e                          # 004eaf6d
    mov byte ptr [eax + 0x583f1f], 0x1           # 004eaf70
    mov edi, 0x55cb4c                            # 004eaf77
    mov ecx, dword ptr [ebp - local_4]           # 004eaf7c
    movsx edx, word ptr [ecx + field_1]          # 004eaf7f
    imul edx, edx, 0x6e                          # 004eaf83
    add edx, 0x583f5c                            # 004eaf86
    or ecx, -0x1                                 # 004eaf8c
    {load} xor eax, eax                          # 004eaf8f
    repne scasb al, byte ptr es:[edi]            # 004eaf91
    not ecx                                      # 004eaf93
    {load} sub edi, ecx                          # 004eaf95
    {load} mov esi, edi                          # 004eaf97
    {load} mov eax, ecx                          # 004eaf99
    {load} mov edi, edx                          # 004eaf9b
    shr ecx, 0x2                                 # 004eaf9d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eafa0
    {load} mov ecx, eax                          # 004eafa2
    and ecx, 0x3                                 # 004eafa4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eafa7
    jmp.d32 L_004eb0de                           # 004eafa9
L_004eafae:
    # block 0x004eafae: entered by switch case, 5 instruction(s), ends with forward jump to 0x004eb0de
    mov ecx, dword ptr [ebp - local_4]           # 004eafae
    movsx edx, word ptr [ecx + field_1]          # 004eafb1
    imul edx, edx, 0x6e                          # 004eafb5
    mov byte ptr [edx + 0x583f1f], 0x0           # 004eafb8
    jmp.d32 L_004eb0de                           # 004eafbf
L_004eafc4:
    # block 0x004eafc4: entered by switch case, 35 instruction(s), ends with forward jump to 0x004eb0de
    mov eax, dword ptr [ebp - local_4]           # 004eafc4
    movsx ecx, word ptr [eax + field_1]          # 004eafc7
    imul ecx, ecx, 0x6e                          # 004eafcb
    mov byte ptr [ecx + 0x583f1f], 0x1           # 004eafce
    mov edx, dword ptr [ebp - local_4]           # 004eafd5
    add edx, 0x5                                 # 004eafd8
    {load} mov edi, edx                          # 004eafdb
    mov eax, dword ptr [ebp - local_4]           # 004eafdd
    movsx ecx, word ptr [eax + field_1]          # 004eafe0
    imul ecx, ecx, 0x6e                          # 004eafe4
    add ecx, 0x583f20                            # 004eafe7
    {load} mov edx, ecx                          # 004eafed
    or ecx, -0x1                                 # 004eafef
    {load} xor eax, eax                          # 004eaff2
    repne scasb al, byte ptr es:[edi]            # 004eaff4
    not ecx                                      # 004eaff6
    {load} sub edi, ecx                          # 004eaff8
    {load} mov esi, edi                          # 004eaffa
    {load} mov eax, ecx                          # 004eaffc
    {load} mov edi, edx                          # 004eaffe
    shr ecx, 0x2                                 # 004eb000
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb003
    {load} mov ecx, eax                          # 004eb005
    and ecx, 0x3                                 # 004eb007
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb00a
    mov esi, dword ptr [ebp - local_4]           # 004eb00c
    add esi, 0x41                                # 004eb00f
    mov ecx, dword ptr [ebp - local_4]           # 004eb012
    movsx edi, word ptr [ecx + field_1]          # 004eb015
    imul edi, edi, 0x6e                          # 004eb019
    add edi, 0x583f5c                            # 004eb01c
    mov ecx, 0xc                                 # 004eb022
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb027
    movsb byte ptr es:[edi], byte ptr [esi]      # 004eb029
    jmp.d32 L_004eb0de                           # 004eb02a
L_004eb02f:
    # block 0x004eb02f: entered by switch case, 35 instruction(s), ends with forward jump to 0x004eb0de
    mov edx, dword ptr [ebp - local_4]           # 004eb02f
    movsx eax, word ptr [edx + field_1]          # 004eb032
    imul eax, eax, 0x6e                          # 004eb036
    mov byte ptr [eax + 0x583f1f], 0x1           # 004eb039
    mov ecx, dword ptr [ebp - local_8]           # 004eb040
    add ecx, 0x712                               # 004eb043
    {load} mov edi, ecx                          # 004eb049
    mov edx, dword ptr [ebp - local_4]           # 004eb04b
    movsx eax, word ptr [edx + field_1]          # 004eb04e
    imul eax, eax, 0x6e                          # 004eb052
    add eax, 0x583f20                            # 004eb055
    {load} mov edx, eax                          # 004eb05a
    or ecx, -0x1                                 # 004eb05c
    {load} xor eax, eax                          # 004eb05f
    repne scasb al, byte ptr es:[edi]            # 004eb061
    not ecx                                      # 004eb063
    {load} sub edi, ecx                          # 004eb065
    {load} mov esi, edi                          # 004eb067
    {load} mov eax, ecx                          # 004eb069
    {load} mov edi, edx                          # 004eb06b
    shr ecx, 0x2                                 # 004eb06d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb070
    {load} mov ecx, eax                          # 004eb072
    and ecx, 0x3                                 # 004eb074
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004eb077
    mov esi, dword ptr [ebp - local_8]           # 004eb079
    add esi, 0x6e1                               # 004eb07c
    mov ecx, dword ptr [ebp - local_4]           # 004eb082
    movsx edi, word ptr [ecx + field_1]          # 004eb085
    imul edi, edi, 0x6e                          # 004eb089
    add edi, 0x583f5c                            # 004eb08c
    mov ecx, 0xc                                 # 004eb092
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004eb097
    movsb byte ptr es:[edi], byte ptr [esi]      # 004eb099
    jmp.d8 L_004eb0de                            # 004eb09a
L_004eb09c:
    # block 0x004eb09c: entered by ja at 0x004eaf56, 17 instruction(s), calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4, falls into the block at 0x004eb0de
    mov edx, dword ptr [0x5bb57b]                # 004eb09c
    push edx                                     # 004eb0a2
    movsx eax, word ptr [0x5c39e3]               # 004eb0a3
    push eax                                     # 004eb0aa
    mov ecx, dword ptr [ebp - local_4]           # 004eb0ab
    {load} xor edx, edx                          # 004eb0ae
    mov dl, byte ptr [ecx]                       # 004eb0b0
    push edx                                     # 004eb0b2
    push 0x55cb58                                # 004eb0b3
    push 0x63888b                                # 004eb0b8
    call FUN_0050ca3e                            # 004eb0bd
    add esp, 0x14                                # 004eb0c2
    push 0x63888b                                # 004eb0c5
    mov ecx, 0x583979                            # 004eb0ca
    call FUN_004264e8                            # 004eb0cf
    mov ecx, 0x5cf659                            # 004eb0d4
    call FUN_004c97b4                            # 004eb0d9
L_004eb0de:
    # block 0x004eb0de: entered by jmp at 0x004eafa9; jmp at 0x004eafbf; jmp at 0x004eb02a; jmp at 0x004eb09a, 8 instruction(s), ends with ret 0x4
    movsx eax, word ptr [ebp + arg_8]            # 004eb0de
    imul eax, eax, 0x8d                          # 004eb0e2
    mov byte ptr [eax + 0x5bb625], 0x1           # 004eb0e8
    pop edi                                      # 004eb0ef
    pop esi                                      # 004eb0f0
    {load} mov esp, ebp                          # 004eb0f1
    pop ebp                                      # 004eb0f3
    ret 0x4                                      # 004eb0f4

# --- data items (not part of the function) -------------------------
.org 0x004eb0f7 - 0x401000
SWTAB_004eb0f7:  # 4 case address(es)
    .long L_004eaf66 - .text + 0x401000
    .long L_004eafae - .text + 0x401000
    .long L_004eafc4 - .text + 0x401000
    .long L_004eb02f - .text + 0x401000
.set SWTAB_004eb0f7_VA, SWTAB_004eb0f7 - .text + 0x401000

