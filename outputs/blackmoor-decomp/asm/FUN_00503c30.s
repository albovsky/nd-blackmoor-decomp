# FUN_00503c30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00503c30
# extent:       0x00503c30-0x00503dd7 (423 code bytes)
# span:         0x00503c30-0x00503de0 (code 423, tables 0, padding 9)
# sha256:       4b43f1d824122d065ff95de9aac8e678d31b51e53111e2e4313b345e38730058
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00503c30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_minus_4; [edx + n] field_4; [esp + n] stk_8, stk_10, stk_14, stk_18, stk_1c, stk_20, stk_28, stk_2c, stk_30
# callees:      calls FUN_00504410, FUN_00503de0, FUN_00503fa0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 159 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_00503de0, .text + (0x00503de0 - 0x401000)
.set FUN_00503fa0, .text + (0x00503fa0 - 0x401000)
.set FUN_00504410, .text + (0x00504410 - 0x401000)

.org 0x00503c30 - 0x401000
.globl FUN_00503c30
FUN_00503c30:
    # block 0x00503c30: entry, 10 instruction(s), ends with jle to 0x00503dd1 (forward)
    sub esp, 0xc                                 # 00503c30
    mov edx, dword ptr [esp + stk_20]            # 00503c33
    mov ecx, dword ptr [esp + stk_10]            # 00503c37
    push ebp                                     # 00503c3b
    push edi                                     # 00503c3c
    mov eax, dword ptr [edx + field_4]           # 00503c3d
    mov dword ptr [esp + stk_28], 0x1            # 00503c40
    test eax, eax                                # 00503c48
    mov dword ptr [esp + stk_8], ecx             # 00503c4a
    jle.d32 L_00503dd1                           # 00503c4e
    # block 0x00503c54: entered by fall-through of jle at 0x00503c4e, 8 instruction(s), falls into the block at 0x00503c6e
    mov ebp, dword ptr [esp + stk_20]            # 00503c54
    mov edi, dword ptr [esp + stk_1c]            # 00503c58
    lea edx, [edx + 4*eax + field_4]             # 00503c5c
    push ebx                                     # 00503c60
    mov ebx, dword ptr [esp + stk_28]            # 00503c61
    push esi                                     # 00503c65
    mov dword ptr [esp + stk_14], edx            # 00503c66
    mov dword ptr [esp + stk_18], eax            # 00503c6a
L_00503c6e:
    # block 0x00503c6e: entered by jne at 0x00503dab, 28 instruction(s), ends with je to 0x00503d60 (forward)
    mov eax, dword ptr [esp + stk_14]            # 00503c6e
    mov edx, dword ptr [eax]                     # 00503c72
    {load} mov eax, ecx                          # 00503c74
    mov dword ptr [esp + stk_2c], edx            # 00503c76
    cdq                                          # 00503c7a
    idiv dword ptr [esp + stk_2c]                # 00503c7b
    {load} mov esi, eax                          # 00503c7f
    mov eax, dword ptr [esp + stk_20]            # 00503c81
    cdq                                          # 00503c85
    idiv ecx                                     # 00503c86
    mov edx, dword ptr [esp + stk_10]            # 00503c88
    {load} mov ecx, eax                          # 00503c8c
    imul ecx, esi                                # 00503c8e
    mov dword ptr [esp + stk_2c], ecx            # 00503c91
    mov ecx, dword ptr [esp + stk_14]            # 00503c95
    mov ecx, dword ptr [ecx]                     # 00503c99
    dec ecx                                      # 00503c9b
    imul ecx, eax                                # 00503c9c
    {load} sub edx, ecx                          # 00503c9f
    mov ecx, dword ptr [esp + stk_30]            # 00503ca1
    mov dword ptr [esp + stk_10], edx            # 00503ca5
    mov edx, 0x1                                 # 00503ca9
    {load} sub edx, ecx                          # 00503cae
    mov dword ptr [esp + stk_30], edx            # 00503cb0
    mov edx, dword ptr [esp + stk_14]            # 00503cb4
    mov ecx, dword ptr [edx]                     # 00503cb8
    cmp ecx, 0x4                                 # 00503cba
    je.d32 L_00503d60                            # 00503cbd
    # block 0x00503cc3: entered by fall-through of je at 0x00503cbd, 2 instruction(s), ends with je to 0x00503d33 (forward)
    cmp ecx, 0x2                                 # 00503cc3
    je.d8 L_00503d33                             # 00503cc6
    # block 0x00503cc8: entered by fall-through of je at 0x00503cc6, 2 instruction(s), ends with jne to 0x00503cdd (forward)
    cmp eax, 0x1                                 # 00503cc8
    jne.d8 L_00503cdd                            # 00503ccb
    # block 0x00503ccd: entered by fall-through of jne at 0x00503ccb, 5 instruction(s), falls into the block at 0x00503cdd
    mov edx, dword ptr [esp + stk_30]            # 00503ccd
    {load} mov ecx, eax                          # 00503cd1
    {load} sub ecx, edx                          # 00503cd3
    mov edx, dword ptr [esp + stk_14]            # 00503cd5
    mov dword ptr [esp + stk_30], ecx            # 00503cd9
L_00503cdd:
    # block 0x00503cdd: entered by jne at 0x00503ccb, 6 instruction(s), ends with je to 0x00503d12 (forward)
    mov ecx, dword ptr [esp + stk_30]            # 00503cdd
    test ecx, ecx                                # 00503ce1
    mov ecx, dword ptr [esp + stk_10]            # 00503ce3
    lea ecx, [ebx + 4*ecx - field_minus_4]       # 00503ce7
    push ecx                                     # 00503ceb
    je.d8 L_00503d12                             # 00503cec
    # block 0x00503cee: entered by fall-through of je at 0x00503cec, 15 instruction(s), calls FUN_00504410, ends with forward jump to 0x00503d95
    mov ecx, dword ptr [esp + stk_30]            # 00503cee
    mov edx, dword ptr [edx]                     # 00503cf2
    push edi                                     # 00503cf4
    push edi                                     # 00503cf5
    push ebp                                     # 00503cf6
    push ebp                                     # 00503cf7
    push ebp                                     # 00503cf8
    push ecx                                     # 00503cf9
    push esi                                     # 00503cfa
    push edx                                     # 00503cfb
    push eax                                     # 00503cfc
    call FUN_00504410                            # 00503cfd
    add esp, 0x28                                # 00503d02
    mov dword ptr [esp + stk_30], 0x0            # 00503d05
    jmp.d32 L_00503d95                           # 00503d0d
L_00503d12:
    # block 0x00503d12: entered by je at 0x00503cec, 15 instruction(s), calls FUN_00504410, ends with forward jump to 0x00503d95
    mov ecx, dword ptr [esp + stk_30]            # 00503d12
    mov edx, dword ptr [edx]                     # 00503d16
    push ebp                                     # 00503d18
    push ebp                                     # 00503d19
    push edi                                     # 00503d1a
    push edi                                     # 00503d1b
    push edi                                     # 00503d1c
    push ecx                                     # 00503d1d
    push esi                                     # 00503d1e
    push edx                                     # 00503d1f
    push eax                                     # 00503d20
    call FUN_00504410                            # 00503d21
    add esp, 0x28                                # 00503d26
    mov dword ptr [esp + stk_30], 0x1            # 00503d29
    jmp.d8 L_00503d95                            # 00503d31
L_00503d33:
    # block 0x00503d33: entered by je at 0x00503cc6, 6 instruction(s), ends with je to 0x00503d52 (forward)
    mov ecx, dword ptr [esp + stk_30]            # 00503d33
    mov edx, dword ptr [esp + stk_10]            # 00503d37
    test ecx, ecx                                # 00503d3b
    lea ecx, [ebx + 4*edx - field_minus_4]       # 00503d3d
    push ecx                                     # 00503d41
    je.d8 L_00503d52                             # 00503d42
    # block 0x00503d44: entered by fall-through of je at 0x00503d42, 7 instruction(s), calls FUN_00503de0, ends with forward jump to 0x00503d95
    push edi                                     # 00503d44
    push ebp                                     # 00503d45
    push esi                                     # 00503d46
    push eax                                     # 00503d47
    call FUN_00503de0                            # 00503d48
    add esp, 0x14                                # 00503d4d
    jmp.d8 L_00503d95                            # 00503d50
L_00503d52:
    # block 0x00503d52: entered by je at 0x00503d42, 7 instruction(s), calls FUN_00503de0, ends with forward jump to 0x00503d95
    push ebp                                     # 00503d52
    push edi                                     # 00503d53
    push esi                                     # 00503d54
    push eax                                     # 00503d55
    call FUN_00503de0                            # 00503d56
    add esp, 0x14                                # 00503d5b
    jmp.d8 L_00503d95                            # 00503d5e
L_00503d60:
    # block 0x00503d60: entered by je at 0x00503cbd, 13 instruction(s), ends with je to 0x00503d89 (forward)
    mov edx, dword ptr [esp + stk_10]            # 00503d60
    lea ecx, [eax + edx]                         # 00503d64
    mov edx, dword ptr [esp + stk_30]            # 00503d67
    test edx, edx                                # 00503d6b
    lea edx, [ecx + eax]                         # 00503d6d
    lea ecx, [ebx + 4*ecx - field_minus_4]       # 00503d70
    lea edx, [ebx + 4*edx - field_minus_4]       # 00503d74
    push edx                                     # 00503d78
    mov edx, dword ptr [esp + stk_14]            # 00503d79
    push ecx                                     # 00503d7d
    lea ecx, [ebx + 4*edx - field_minus_4]       # 00503d7e
    push ecx                                     # 00503d82
    je.d8 L_00503d89                             # 00503d83
    # block 0x00503d85: entered by fall-through of je at 0x00503d83, 3 instruction(s), ends with forward jump to 0x00503d8b
    push edi                                     # 00503d85
    push ebp                                     # 00503d86
    jmp.d8 L_00503d8b                            # 00503d87
L_00503d89:
    # block 0x00503d89: entered by je at 0x00503d83, 2 instruction(s), falls into the block at 0x00503d8b
    push ebp                                     # 00503d89
    push edi                                     # 00503d8a
L_00503d8b:
    # block 0x00503d8b: entered by jmp at 0x00503d87, 4 instruction(s), calls FUN_00503fa0, falls into the block at 0x00503d95
    push esi                                     # 00503d8b
    push eax                                     # 00503d8c
    call FUN_00503fa0                            # 00503d8d
    add esp, 0x1c                                # 00503d92
L_00503d95:
    # block 0x00503d95: entered by jmp at 0x00503d0d; jmp at 0x00503d31; jmp at 0x00503d50; jmp at 0x00503d5e, 8 instruction(s), ends with jne to 0x00503c6e (backward)
    mov edx, dword ptr [esp + stk_14]            # 00503d95
    mov eax, dword ptr [esp + stk_18]            # 00503d99
    sub edx, 0x4                                 # 00503d9d
    dec eax                                      # 00503da0
    {load} mov ecx, esi                          # 00503da1
    mov dword ptr [esp + stk_14], edx            # 00503da3
    mov dword ptr [esp + stk_18], eax            # 00503da7
    jne.d32 L_00503c6e                           # 00503dab
    # block 0x00503db1: entered by fall-through of jne at 0x00503dab, 5 instruction(s), ends with je to 0x00503dd1 (forward)
    mov eax, dword ptr [esp + stk_30]            # 00503db1
    pop esi                                      # 00503db5
    cmp eax, 0x1                                 # 00503db6
    pop ebx                                      # 00503db9
    je.d8 L_00503dd1                             # 00503dba
    # block 0x00503dbc: entered by fall-through of je at 0x00503dba, 3 instruction(s), ends with jle to 0x00503dd1 (forward)
    mov eax, dword ptr [esp + stk_18]            # 00503dbc
    test eax, eax                                # 00503dc0
    jle.d8 L_00503dd1                            # 00503dc2
    # block 0x00503dc4: entered by fall-through of jle at 0x00503dc2, 1 instruction(s), falls into the block at 0x00503dc6
    {load} sub ebp, edi                          # 00503dc4
L_00503dc6:
    # block 0x00503dc6: entered by jne at 0x00503dcf, 5 instruction(s), ends with jne to 0x00503dc6 (backward)
    mov edx, dword ptr [edi + ebp]               # 00503dc6
    mov dword ptr [edi], edx                     # 00503dc9
    add edi, 0x4                                 # 00503dcb
    dec eax                                      # 00503dce
    jne.d8 L_00503dc6                            # 00503dcf
L_00503dd1:
    # block 0x00503dd1: entered by jle at 0x00503c4e; je at 0x00503dba; jle at 0x00503dc2; fall-through of jne at 0x00503dcf, 4 instruction(s), ends with ret
    pop edi                                      # 00503dd1
    pop ebp                                      # 00503dd2
    add esp, 0xc                                 # 00503dd3
    ret                                          # 00503dd6

# --- data items (not part of the function) -------------------------
.org 0x00503dd7 - 0x401000
PAD_00503dd7:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

