# FUN_0050cf90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cf90
# extent:       0x0050cf90-0x0050d078 (232 code bytes)
# span:         0x0050cf90-0x0050d078 (code 232, tables 0, padding 0)
# sha256:       277541f56cd9b7a04d41bee44243ca62c5d6c474e7aeed4ac0d5e2d703938812
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cf90
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       [esi + n] field_4, field_c, field_10, field_18
# callees:      calls FUN_0050fa90, FUN_00512437, FUN_0051235b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 92 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051235b, .text + (0x0051235b - 0x401000)
.set FUN_00512437, .text + (0x00512437 - 0x401000)

.org 0x0050cf90 - 0x401000
.globl FUN_0050cf90
FUN_0050cf90:
    # block 0x0050cf90: entry, 14 instruction(s), ends with jne to 0x0050cfb4 (forward)
    push ebp                                     # 0050cf90
    {load} mov ebp, esp                          # 0050cf91
    push ecx                                     # 0050cf93
    push ebx                                     # 0050cf94
    push esi                                     # 0050cf95
    push edi                                     # 0050cf96
    mov edi, dword ptr [ebp + arg_c]             # 0050cf97
    imul edi, dword ptr [ebp + arg_10]           # 0050cf9a
    mov ebx, dword ptr [ebp + arg_8]             # 0050cf9e
    {load} mov ecx, edi                          # 0050cfa1
    test edi, edi                                # 0050cfa3
    mov dword ptr [ebp - local_4], edi           # 0050cfa5
    mov dword ptr [ebp + arg_8], ecx             # 0050cfa8
    jne.d8 L_0050cfb4                            # 0050cfab
    # block 0x0050cfad: entered by fall-through of jne at 0x0050cfab, 2 instruction(s), ends with forward jump to 0x0050d05d
    {load} xor eax, eax                          # 0050cfad
    jmp.d32 L_0050d05d                           # 0050cfaf
L_0050cfb4:
    # block 0x0050cfb4: entered by jne at 0x0050cfab, 3 instruction(s), ends with je to 0x0050cfc7 (forward)
    mov esi, dword ptr [ebp + arg_14]            # 0050cfb4
    test word ptr [esi + field_c], 0x10c         # 0050cfb7
    je.d8 L_0050cfc7                             # 0050cfbd
    # block 0x0050cfbf: entered by fall-through of je at 0x0050cfbd, 3 instruction(s), ends with forward jump to 0x0050cfd3
    mov eax, dword ptr [esi + field_18]          # 0050cfbf
    mov dword ptr [ebp + arg_14], eax            # 0050cfc2
    jmp.d8 L_0050cfd3                            # 0050cfc5
L_0050cfc7:
    # block 0x0050cfc7: entered by je at 0x0050cfbd, 2 instruction(s), ends with forward jump to 0x0050cfd3
    mov dword ptr [ebp + arg_14], 0x1000         # 0050cfc7
    jmp.d8 L_0050cfd3                            # 0050cfce
L_0050cfd0:
    # block 0x0050cfd0: entered by jne at 0x0050d054, 1 instruction(s), falls into the block at 0x0050cfd3
    mov ecx, dword ptr [ebp + arg_8]             # 0050cfd0
L_0050cfd3:
    # block 0x0050cfd3: entered by jmp at 0x0050cfc5; jmp at 0x0050cfce, 2 instruction(s), ends with je to 0x0050d005 (forward)
    test word ptr [esi + field_c], 0x10c         # 0050cfd3
    je.d8 L_0050d005                             # 0050cfd9
    # block 0x0050cfdb: entered by fall-through of je at 0x0050cfd9, 3 instruction(s), ends with je to 0x0050d005 (forward)
    mov eax, dword ptr [esi + field_4]           # 0050cfdb
    test eax, eax                                # 0050cfde
    je.d8 L_0050d005                             # 0050cfe0
    # block 0x0050cfe2: entered by fall-through of je at 0x0050cfe0, 3 instruction(s), ends with jb to 0x0050cfea (forward)
    {load} cmp ecx, eax                          # 0050cfe2
    {load} mov edi, ecx                          # 0050cfe4
    jb.d8 L_0050cfea                             # 0050cfe6
    # block 0x0050cfe8: entered by fall-through of jb at 0x0050cfe6, 1 instruction(s), falls into the block at 0x0050cfea
    {load} mov edi, eax                          # 0050cfe8
L_0050cfea:
    # block 0x0050cfea: entered by jb at 0x0050cfe6, 11 instruction(s), calls FUN_0050fa90, ends with forward jump to 0x0050d050
    push edi                                     # 0050cfea
    push dword ptr [esi]                         # 0050cfeb
    push ebx                                     # 0050cfed
    call FUN_0050fa90                            # 0050cfee
    sub dword ptr [ebp + arg_8], edi             # 0050cff3
    sub dword ptr [esi + field_4], edi           # 0050cff6
    add dword ptr [esi], edi                     # 0050cff9
    add esp, 0xc                                 # 0050cffb
    {load} add ebx, edi                          # 0050cffe
    mov edi, dword ptr [ebp - local_4]           # 0050d000
    jmp.d8 L_0050d050                            # 0050d003
L_0050d005:
    # block 0x0050d005: entered by je at 0x0050cfd9; je at 0x0050cfe0, 2 instruction(s), ends with jb to 0x0050d038 (forward)
    cmp ecx, dword ptr [ebp + arg_14]            # 0050d005
    jb.d8 L_0050d038                             # 0050d008
    # block 0x0050d00a: entered by fall-through of jb at 0x0050d008, 3 instruction(s), ends with je to 0x0050d01b (forward)
    cmp dword ptr [ebp + arg_14], 0x0            # 0050d00a
    {load} mov eax, ecx                          # 0050d00e
    je.d8 L_0050d01b                             # 0050d010
    # block 0x0050d012: entered by fall-through of je at 0x0050d010, 4 instruction(s), falls into the block at 0x0050d01b
    {load} xor edx, edx                          # 0050d012
    div dword ptr [ebp + arg_14]                 # 0050d014
    {load} mov eax, ecx                          # 0050d017
    {load} sub eax, edx                          # 0050d019
L_0050d01b:
    # block 0x0050d01b: entered by je at 0x0050d010, 7 instruction(s), calls FUN_00512437, ends with je to 0x0050d062 (forward)
    push eax                                     # 0050d01b
    push ebx                                     # 0050d01c
    push dword ptr [esi + field_10]              # 0050d01d
    call FUN_00512437                            # 0050d020
    add esp, 0xc                                 # 0050d025
    test eax, eax                                # 0050d028
    je.d8 L_0050d062                             # 0050d02a
    # block 0x0050d02c: entered by fall-through of je at 0x0050d02a, 2 instruction(s), ends with je to 0x0050d068 (forward)
    cmp eax, -0x1                                # 0050d02c
    je.d8 L_0050d068                             # 0050d02f
    # block 0x0050d031: entered by fall-through of je at 0x0050d02f, 3 instruction(s), ends with forward jump to 0x0050d050
    sub dword ptr [ebp + arg_8], eax             # 0050d031
    {load} add ebx, eax                          # 0050d034
    jmp.d8 L_0050d050                            # 0050d036
L_0050d038:
    # block 0x0050d038: entered by jb at 0x0050d008, 5 instruction(s), calls FUN_0051235b, ends with je to 0x0050d06c (forward)
    push esi                                     # 0050d038
    call FUN_0051235b                            # 0050d039
    cmp eax, -0x1                                # 0050d03e
    pop ecx                                      # 0050d041
    je.d8 L_0050d06c                             # 0050d042
    # block 0x0050d044: entered by fall-through of je at 0x0050d042, 5 instruction(s), falls into the block at 0x0050d050
    mov byte ptr [ebx], al                       # 0050d044
    mov eax, dword ptr [esi + field_18]          # 0050d046
    inc ebx                                      # 0050d049
    dec dword ptr [ebp + arg_8]                  # 0050d04a
    mov dword ptr [ebp + arg_14], eax            # 0050d04d
L_0050d050:
    # block 0x0050d050: entered by jmp at 0x0050d003; jmp at 0x0050d036, 2 instruction(s), ends with jne to 0x0050cfd0 (backward)
    cmp dword ptr [ebp + arg_8], 0x0             # 0050d050
    jne.d32 L_0050cfd0                           # 0050d054
    # block 0x0050d05a: entered by fall-through of jne at 0x0050d054, 1 instruction(s), falls into the block at 0x0050d05d
    mov eax, dword ptr [ebp + arg_10]            # 0050d05a
L_0050d05d:
    # block 0x0050d05d: entered by jmp at 0x0050cfaf; jmp at 0x0050d076, 5 instruction(s), ends with ret
    pop edi                                      # 0050d05d
    pop esi                                      # 0050d05e
    pop ebx                                      # 0050d05f
    leave                                        # 0050d060
    ret                                          # 0050d061
L_0050d062:
    # block 0x0050d062: entered by je at 0x0050d02a, 2 instruction(s), ends with forward jump to 0x0050d06c
    or dword ptr [esi + field_c], 0x10           # 0050d062
    jmp.d8 L_0050d06c                            # 0050d066
L_0050d068:
    # block 0x0050d068: entered by je at 0x0050d02f, 1 instruction(s), falls into the block at 0x0050d06c
    or dword ptr [esi + field_c], 0x20           # 0050d068
L_0050d06c:
    # block 0x0050d06c: entered by je at 0x0050d042; jmp at 0x0050d066, 5 instruction(s), ends with backward jump to 0x0050d05d
    {load} mov eax, edi                          # 0050d06c
    {load} xor edx, edx                          # 0050d06e
    sub eax, dword ptr [ebp + arg_8]             # 0050d070
    div dword ptr [ebp + arg_c]                  # 0050d073
    jmp.d8 L_0050d05d                            # 0050d076

