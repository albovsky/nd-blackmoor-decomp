# FUN_0047d02d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d02d
# extent:       0x0047d02d-0x0047d1c3 (406 code bytes)
# span:         0x0047d02d-0x0047d1c3 (code 406, tables 0, padding 0)
# sha256:       168eb928e1f7250de7c75a86b3bea83032a4ce87b8a510c562c54e70f4c82d4e
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sound_record_caption_player
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_ee_runtime.c:292 says "0x47d02d: play the sound record at body offset `id` and show its caption."
# name-note:    Plays the sound record at a body offset and shows its caption.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_6c, local_70
# fields:       [edi + n] field_4, field_6; [edx + n] field_21
# callees:      calls FUN_00516530, FUN_004fb77a, FUN_004fb2e3, FUN_00423259, FUN_00448d11
# track-n:      outputs/blackmoor-decomp/src/action_family_ee_runtime.c:play_record (function ledger class candidate_port; also show_caption; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 136 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_00516530, .text + (0x00516530 - 0x401000)

.org 0x0047d02d - 0x401000
.globl FUN_0047d02d
FUN_0047d02d:
    # block 0x0047d02d: entry, 13 instruction(s), calls FUN_00516530, ends with je to 0x0047d06d (forward)
    push ebp                                     # 0047d02d
    {load} mov ebp, esp                          # 0047d02e
    sub esp, 0x70                                # 0047d030
    push esi                                     # 0047d033
    push edi                                     # 0047d034
    mov dword ptr [ebp - local_70], ecx          # 0047d035
    push 0x54d14c                                # 0047d038
    mov eax, dword ptr [ebp + arg_8]             # 0047d03d
    push eax                                     # 0047d040
    call FUN_00516530                            # 0047d041
    add esp, 0x8                                 # 0047d046
    test eax, eax                                # 0047d049
    je.d8 L_0047d06d                             # 0047d04b
    # block 0x0047d04d: entered by fall-through of je at 0x0047d04b, 9 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x0047d06d
    mov ecx, dword ptr [ebp + arg_8]             # 0047d04d
    push ecx                                     # 0047d050
    mov ecx, 0x5c3a67                            # 0047d051
    call FUN_004fb77a                            # 0047d056
    mov edx, dword ptr [ebp + arg_8]             # 0047d05b
    mov ax, word ptr [edx + field_21]            # 0047d05e
    push eax                                     # 0047d062
    mov ecx, 0x5c3a67                            # 0047d063
    call FUN_004fb2e3                            # 0047d068
L_0047d06d:
    # block 0x0047d06d: entered by je at 0x0047d04b, 3 instruction(s), ends with je to 0x0047d1bb (forward)
    mov dword ptr [ebp - local_4], 0x0           # 0047d06d
    cmp dword ptr [0x5bb202], 0x0                # 0047d074
    je.d32 L_0047d1bb                            # 0047d07b
    # block 0x0047d081: entered by fall-through of je at 0x0047d07b, 9 instruction(s), ends with jbe to 0x0047d136 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0047d081
    add edi, 0x31                                # 0047d084
    or ecx, -0x1                                 # 0047d087
    {load} xor eax, eax                          # 0047d08a
    repne scasb al, byte ptr es:[edi]            # 0047d08c
    not ecx                                      # 0047d08e
    add ecx, -0x1                                # 0047d090
    test ecx, ecx                                # 0047d093
    jbe.d32 L_0047d136                           # 0047d095
    # block 0x0047d09b: entered by fall-through of jbe at 0x0047d095, 8 instruction(s), calls FUN_00423259, ends with je to 0x0047d12f (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0047d09b
    add ecx, 0x31                                # 0047d09e
    push ecx                                     # 0047d0a1
    mov ecx, 0x619a6b                            # 0047d0a2
    call FUN_00423259                            # 0047d0a7
    mov dword ptr [ebp - local_4], eax           # 0047d0ac
    cmp dword ptr [ebp - local_4], 0x0           # 0047d0af
    je.d8 L_0047d12f                             # 0047d0b3
    # block 0x0047d0b5: entered by fall-through of je at 0x0047d0b3, 8 instruction(s), ends with ja to 0x0047d12f (forward)
    mov edi, dword ptr [ebp - local_4]           # 0047d0b5
    or ecx, -0x1                                 # 0047d0b8
    {load} xor eax, eax                          # 0047d0bb
    repne scasb al, byte ptr es:[edi]            # 0047d0bd
    not ecx                                      # 0047d0bf
    add ecx, -0x1                                # 0047d0c1
    cmp ecx, 0x9c40                              # 0047d0c4
    ja.d8 L_0047d12f                             # 0047d0ca
    # block 0x0047d0cc: entered by fall-through of ja at 0x0047d0ca, 33 instruction(s), calls FUN_00448d11, ends with forward jump to 0x0047d136
    mov edi, dword ptr [ebp - local_4]           # 0047d0cc
    or ecx, -0x1                                 # 0047d0cf
    {load} xor eax, eax                          # 0047d0d2
    repne scasb al, byte ptr es:[edi]            # 0047d0d4
    not ecx                                      # 0047d0d6
    mov esi, dword ptr [ebp - local_4]           # 0047d0d8
    lea edi, [ebp - local_6c]                    # 0047d0db
    {load} mov edx, ecx                          # 0047d0de
    shr ecx, 0x2                                 # 0047d0e0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047d0e3
    {load} mov ecx, edx                          # 0047d0e5
    and ecx, 0x3                                 # 0047d0e7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0047d0ea
    lea edi, [ebp - local_6c]                    # 0047d0ec
    or ecx, -0x1                                 # 0047d0ef
    {load} xor eax, eax                          # 0047d0f2
    repne scasb al, byte ptr es:[edi]            # 0047d0f4
    add edi, -0x1                                # 0047d0f6
    mov eax, dword ptr [0x54d158]                # 0047d0f9
    mov dword ptr [edi], eax                     # 0047d0fe
    mov cx, word ptr [0x54d15c]                  # 0047d100
    mov word ptr [edi + field_4], cx             # 0047d107
    mov dl, byte ptr [0x54d15e]                  # 0047d10b
    mov byte ptr [edi + field_6], dl             # 0047d111
    push 0x0                                     # 0047d114
    push -0x1                                    # 0047d116
    lea eax, [ebp - local_6c]                    # 0047d118
    push eax                                     # 0047d11b
    mov ecx, dword ptr [0x5d03b3]                # 0047d11c
    push ecx                                     # 0047d122
    mov ecx, 0x619a05                            # 0047d123
    call FUN_00448d11                            # 0047d128
    jmp.d8 L_0047d136                            # 0047d12d
L_0047d12f:
    # block 0x0047d12f: entered by je at 0x0047d0b3; ja at 0x0047d0ca, 1 instruction(s), falls into the block at 0x0047d136
    mov dword ptr [ebp - local_4], 0x0           # 0047d12f
L_0047d136:
    # block 0x0047d136: entered by jbe at 0x0047d095; jmp at 0x0047d12d, 2 instruction(s), ends with jne to 0x0047d1bb (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0047d136
    jne.d8 L_0047d1bb                            # 0047d13a
    # block 0x0047d13c: entered by fall-through of jne at 0x0047d13a, 9 instruction(s), ends with jbe to 0x0047d1bb (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0047d13c
    add edi, 0x52                                # 0047d13f
    or ecx, -0x1                                 # 0047d142
    {load} xor eax, eax                          # 0047d145
    repne scasb al, byte ptr es:[edi]            # 0047d147
    not ecx                                      # 0047d149
    add ecx, -0x1                                # 0047d14b
    test ecx, ecx                                # 0047d14e
    jbe.d8 L_0047d1bb                            # 0047d150
    # block 0x0047d152: entered by fall-through of jbe at 0x0047d150, 36 instruction(s), calls FUN_00448d11, falls into the block at 0x0047d1bb
    mov edx, dword ptr [ebp + arg_8]             # 0047d152
    add edx, 0x52                                # 0047d155
    {load} mov edi, edx                          # 0047d158
    lea edx, [ebp - local_6c]                    # 0047d15a
    or ecx, -0x1                                 # 0047d15d
    {load} xor eax, eax                          # 0047d160
    repne scasb al, byte ptr es:[edi]            # 0047d162
    not ecx                                      # 0047d164
    {load} sub edi, ecx                          # 0047d166
    {load} mov esi, edi                          # 0047d168
    {load} mov eax, ecx                          # 0047d16a
    {load} mov edi, edx                          # 0047d16c
    shr ecx, 0x2                                 # 0047d16e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047d171
    {load} mov ecx, eax                          # 0047d173
    and ecx, 0x3                                 # 0047d175
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0047d178
    lea edi, [ebp - local_6c]                    # 0047d17a
    or ecx, -0x1                                 # 0047d17d
    {load} xor eax, eax                          # 0047d180
    repne scasb al, byte ptr es:[edi]            # 0047d182
    add edi, -0x1                                # 0047d184
    mov ecx, dword ptr [0x54d160]                # 0047d187
    mov dword ptr [edi], ecx                     # 0047d18d
    mov dx, word ptr [0x54d164]                  # 0047d18f
    mov word ptr [edi + field_4], dx             # 0047d196
    mov al, byte ptr [0x54d166]                  # 0047d19a
    mov byte ptr [edi + field_6], al             # 0047d19f
    push 0x0                                     # 0047d1a2
    push -0x1                                    # 0047d1a4
    lea ecx, [ebp - local_6c]                    # 0047d1a6
    push ecx                                     # 0047d1a9
    mov edx, dword ptr [0x5d03b3]                # 0047d1aa
    push edx                                     # 0047d1b0
    mov ecx, 0x619a05                            # 0047d1b1
    call FUN_00448d11                            # 0047d1b6
L_0047d1bb:
    # block 0x0047d1bb: entered by je at 0x0047d07b; jne at 0x0047d13a; jbe at 0x0047d150, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0047d1bb
    pop esi                                      # 0047d1bc
    {load} mov esp, ebp                          # 0047d1bd
    pop ebp                                      # 0047d1bf
    ret 0x4                                      # 0047d1c0

