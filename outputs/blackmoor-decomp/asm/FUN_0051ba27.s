# FUN_0051ba27
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ba27
# extent:       0x0051ba27-0x0051bed5 (1198 code bytes)
# span:         0x0051ba27-0x0051bf99 (code 1198, tables 196, padding 0)
# sha256:       6b6aa32ccee4f061988a506322406bf29093afe693cfb394c30296ce8b1f61fe
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ba27
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_10, field_20, field_28, field_78; [ebp + n] field_8, field_c, field_10, field_14, field_minus_4, field_minus_c, field_minus_10, field_minus_14, field_minus_20, field_minus_24, field_minus_28, field_minus_44 and 1 more; [ebx + n] field_4, field_8, field_14; [ecx + n] field_8, field_10; [edi + n] field_1c, field_34; [edx + n] field_7c; [esi + n] field_4, field_8
# callees:      calls FUN_0050f978, FUN_0051abe4, FUN_0051a94c, FUN_0051a9ad, FUN_00525ffa, FUN_0052606a, FUN_0051b9a3, KERNEL32.dll!GetVersion, FUN_00520ace, FUN_00520a2c, FUN_0051a7c3, FUN_0051ac0b, FUN_0051a57e, FUN_0051b257, FUN_00520b14, FUN_0051fa37; plus 15 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 422 instruction(s), 26 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_20, 0x20  # offset -0x20
.equ field_minus_24, 0x24  # offset -0x24
.equ field_minus_28, 0x28  # offset -0x28
.equ field_minus_44, 0x44  # offset -0x44
.equ field_minus_60, 0x60  # offset -0x60
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_28, 0x28  # offset +0x28
.equ field_34, 0x34  # offset +0x34
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a57e, .text + (0x0051a57e - 0x401000)
.set FUN_0051a7c3, .text + (0x0051a7c3 - 0x401000)
.set FUN_0051a94c, .text + (0x0051a94c - 0x401000)
.set FUN_0051a9ad, .text + (0x0051a9ad - 0x401000)
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)
.set FUN_0051b9a3, .text + (0x0051b9a3 - 0x401000)
.set FUN_0051fa37, .text + (0x0051fa37 - 0x401000)
.set FUN_00520a2c, .text + (0x00520a2c - 0x401000)
.set FUN_00520ace, .text + (0x00520ace - 0x401000)
.set FUN_00520b14, .text + (0x00520b14 - 0x401000)
.set FUN_00525ffa, .text + (0x00525ffa - 0x401000)
.set FUN_0052606a, .text + (0x0052606a - 0x401000)

.org 0x0051ba27 - 0x401000
.globl FUN_0051ba27
FUN_0051ba27:
    # block 0x0051ba27: entry, 11 instruction(s), calls FUN_0050f978, ends with jne to 0x0051ba60 (forward)
    mov eax, 0x528bb8                            # 0051ba27
    call FUN_0050f978                            # 0051ba2c
    sub esp, 0x54                                # 0051ba31
    and dword ptr [ebp - field_minus_10], 0x0    # 0051ba34
    push ebx                                     # 0051ba38
    mov ebx, dword ptr [ebp + field_8]           # 0051ba39
    push esi                                     # 0051ba3c
    push edi                                     # 0051ba3d
    cmp ebx, 0x111                               # 0051ba3e
    {load} mov edi, ecx                          # 0051ba44
    jne.d8 L_0051ba60                            # 0051ba46
    # block 0x0051ba48: entered by fall-through of jne at 0x0051ba46, 6 instruction(s), calls indirect dword ptr [eax + 0x78], ends with je to 0x0051bbb0 (forward)
    push dword ptr [ebp + field_10]              # 0051ba48
    mov eax, dword ptr [edi]                     # 0051ba4b
    push dword ptr [ebp + field_c]               # 0051ba4d
    call dword ptr [eax + field_78]              # 0051ba50
    test eax, eax                                # 0051ba53
    je.d32 L_0051bbb0                            # 0051ba55
    # block 0x0051ba5b: entered by fall-through of je at 0x0051ba55, 1 instruction(s), ends with forward jump to 0x0051be7d
    jmp.d32 L_0051be7d                           # 0051ba5b
L_0051ba60:
    # block 0x0051ba60: entered by jne at 0x0051ba46, 2 instruction(s), ends with jne to 0x0051ba8d (forward)
    cmp ebx, 0x4e                                # 0051ba60
    jne.d8 L_0051ba8d                            # 0051ba63
    # block 0x0051ba65: entered by fall-through of jne at 0x0051ba63, 3 instruction(s), ends with je to 0x0051bbb0 (forward)
    mov eax, dword ptr [ebp + field_10]          # 0051ba65
    cmp dword ptr [eax], 0x0                     # 0051ba68
    je.d32 L_0051bbb0                            # 0051ba6b
    # block 0x0051ba71: entered by fall-through of je at 0x0051ba6b, 7 instruction(s), calls indirect dword ptr [edx + 0x7c], falls into the block at 0x0051ba80
    mov edx, dword ptr [edi]                     # 0051ba71
    lea ecx, [ebp - field_minus_10]              # 0051ba73
    push ecx                                     # 0051ba76
    push eax                                     # 0051ba77
    push dword ptr [ebp + field_c]               # 0051ba78
    {load} mov ecx, edi                          # 0051ba7b
    call dword ptr [edx + field_7c]              # 0051ba7d
L_0051ba80:
    # block 0x0051ba80: entered by jmp at 0x0051bea1, 2 instruction(s), ends with jne to 0x0051bec1 (forward)
    test eax, eax                                # 0051ba80
    jne.d32 L_0051bec1                           # 0051ba82
    # block 0x0051ba88: entered by fall-through of jne at 0x0051ba82, 1 instruction(s), ends with forward jump to 0x0051bbb0
    jmp.d32 L_0051bbb0                           # 0051ba88
L_0051ba8d:
    # block 0x0051ba8d: entered by jne at 0x0051ba63, 3 instruction(s), ends with jne to 0x0051baa5 (forward)
    mov esi, dword ptr [ebp + field_10]          # 0051ba8d
    cmp ebx, 0x6                                 # 0051ba90
    jne.d8 L_0051baa5                            # 0051ba93
    # block 0x0051ba95: entered by fall-through of jne at 0x0051ba93, 6 instruction(s), calls FUN_0051abe4, FUN_0051a94c, falls into the block at 0x0051baa5
    push esi                                     # 0051ba95
    call FUN_0051abe4                            # 0051ba96
    push eax                                     # 0051ba9b
    push dword ptr [ebp + field_c]               # 0051ba9c
    push edi                                     # 0051ba9f
    call FUN_0051a94c                            # 0051baa0
L_0051baa5:
    # block 0x0051baa5: entered by jne at 0x0051ba93, 2 instruction(s), ends with jne to 0x0051bac2 (forward)
    cmp ebx, 0x20                                # 0051baa5
    jne.d8 L_0051bac2                            # 0051baa8
    # block 0x0051baaa: entered by fall-through of jne at 0x0051baa8, 9 instruction(s), calls FUN_0051a9ad, ends with jne to 0x0051be7d (forward)
    {load} mov eax, esi                          # 0051baaa
    shr eax, 0x10                                # 0051baac
    push eax                                     # 0051baaf
    movsx eax, si                                # 0051bab0
    push eax                                     # 0051bab3
    push edi                                     # 0051bab4
    call FUN_0051a9ad                            # 0051bab5
    test eax, eax                                # 0051baba
    jne.d32 L_0051be7d                           # 0051babc
L_0051bac2:
    # block 0x0051bac2: entered by jne at 0x0051baa8; fall-through of jne at 0x0051babc, 18 instruction(s), calls indirect dword ptr [eax + 0x28], FUN_00525ffa, ends with jne to 0x0051bb28 (forward)
    mov eax, dword ptr [edi]                     # 0051bac2
    {load} mov ecx, edi                          # 0051bac4
    call dword ptr [eax + field_28]              # 0051bac6
    mov ecx, dword ptr [ebp + field_8]           # 0051bac9
    mov dword ptr [ebp - field_minus_14], eax    # 0051bacc
    {load} mov ebx, eax                          # 0051bacf
    mov eax, 0x1ff                               # 0051bad1
    {load} and ebx, eax                          # 0051bad6
    {load} and ecx, eax                          # 0051bad8
    push 0x7                                     # 0051bada
    {load} xor ebx, ecx                          # 0051badc
    call FUN_00525ffa                            # 0051bade
    mov ecx, dword ptr [ebp + field_8]           # 0051bae3
    lea eax, [ebx + 2*ebx]                       # 0051bae6
    cmp ecx, dword ptr [4*eax + 0x63aa30]        # 0051bae9
    lea ebx, [4*eax + 0x63aa30]                  # 0051baf0
    mov eax, dword ptr [ebp - field_minus_14]    # 0051baf7
    jne.d8 L_0051bb28                            # 0051bafa
    # block 0x0051bafc: entered by fall-through of jne at 0x0051bafa, 2 instruction(s), ends with jne to 0x0051bb28 (forward)
    cmp eax, dword ptr [ebx + field_8]           # 0051bafc
    jne.d8 L_0051bb28                            # 0051baff
    # block 0x0051bb01: entered by fall-through of jne at 0x0051baff, 6 instruction(s), calls FUN_0052606a, ends with je to 0x0051bbb0 (forward)
    mov ebx, dword ptr [ebx + field_4]           # 0051bb01
    push 0x7                                     # 0051bb04
    mov dword ptr [ebp + field_10], ebx          # 0051bb06
    call FUN_0052606a                            # 0051bb09
    test ebx, ebx                                # 0051bb0e
    je.d32 L_0051bbb0                            # 0051bb10
    # block 0x0051bb16: entered by fall-through of je at 0x0051bb10, 2 instruction(s), ends with jb to 0x0051bbd0 (forward)
    cmp dword ptr [ebp + field_8], 0xc000        # 0051bb16
    jb.d32 L_0051bbd0                            # 0051bb1d
    # block 0x0051bb23: entered by fall-through of jb at 0x0051bb1d, 1 instruction(s), ends with forward jump to 0x0051beb3
    jmp.d32 L_0051beb3                           # 0051bb23
L_0051bb28:
    # block 0x0051bb28: entered by jne at 0x0051bafa; jne at 0x0051baff, 4 instruction(s), ends with je to 0x0051bba5 (forward)
    test eax, eax                                # 0051bb28
    mov dword ptr [ebx], ecx                     # 0051bb2a
    mov dword ptr [ebx + field_8], eax           # 0051bb2c
    je.d8 L_0051bba5                             # 0051bb2f
    # block 0x0051bb31: entered by fall-through of je at 0x0051bb2f, 1 instruction(s), ends with forward jump to 0x0051bb39
    jmp.d8 L_0051bb39                            # 0051bb31
L_0051bb33:
    # block 0x0051bb33: entered by jne at 0x0051bba3, 2 instruction(s), falls into the block at 0x0051bb39
    mov eax, dword ptr [ebp - field_minus_14]    # 0051bb33
    mov ecx, dword ptr [ebp + field_8]           # 0051bb36
L_0051bb39:
    # block 0x0051bb39: entered by jmp at 0x0051bb31, 3 instruction(s), ends with jae to 0x0051bb58 (forward)
    mov edx, 0xc000                              # 0051bb39
    {load} cmp ecx, edx                          # 0051bb3e
    jae.d8 L_0051bb58                            # 0051bb40
    # block 0x0051bb42: entered by fall-through of jae at 0x0051bb40, 8 instruction(s), calls FUN_0051b9a3, ends with jne to 0x0051bbc3 (forward)
    push 0x0                                     # 0051bb42
    push 0x0                                     # 0051bb44
    push ecx                                     # 0051bb46
    push dword ptr [eax + field_4]               # 0051bb47
    call FUN_0051b9a3                            # 0051bb4a
    test eax, eax                                # 0051bb4f
    mov dword ptr [ebp + field_10], eax          # 0051bb51
    jne.d8 L_0051bbc3                            # 0051bb54
    # block 0x0051bb56: entered by fall-through of jne at 0x0051bb54, 1 instruction(s), ends with forward jump to 0x0051bb99
    jmp.d8 L_0051bb99                            # 0051bb56
L_0051bb58:
    # block 0x0051bb58: entered by jae at 0x0051bb40, 9 instruction(s), calls FUN_0051b9a3, ends with je to 0x0051bb99 (forward)
    mov eax, dword ptr [eax + field_4]           # 0051bb58
    push 0x0                                     # 0051bb5b
    push 0x0                                     # 0051bb5d
    push edx                                     # 0051bb5f
    push eax                                     # 0051bb60
    call FUN_0051b9a3                            # 0051bb61
    test eax, eax                                # 0051bb66
    mov dword ptr [ebp + field_10], eax          # 0051bb68
    je.d8 L_0051bb99                             # 0051bb6b
    # block 0x0051bb6d: entered by fall-through of je at 0x0051bb6b, 1 instruction(s), ends with forward jump to 0x0051bb72
    jmp.d8 L_0051bb72                            # 0051bb6d
L_0051bb6f:
    # block 0x0051bb6f: entered by jne at 0x0051bb97, 1 instruction(s), falls into the block at 0x0051bb72
    mov eax, dword ptr [ebp + field_10]          # 0051bb6f
L_0051bb72:
    # block 0x0051bb72: entered by jmp at 0x0051bb6d, 4 instruction(s), ends with je to 0x0051bea6 (forward)
    mov ecx, dword ptr [eax + field_10]          # 0051bb72
    mov edx, dword ptr [ebp + field_8]           # 0051bb75
    cmp dword ptr [ecx], edx                     # 0051bb78
    je.d32 L_0051bea6                            # 0051bb7a
    # block 0x0051bb80: entered by fall-through of je at 0x0051bb7a, 9 instruction(s), calls FUN_0051b9a3, ends with jne to 0x0051bb6f (backward)
    push 0x0                                     # 0051bb80
    push 0x0                                     # 0051bb82
    add eax, 0x18                                # 0051bb84
    push 0xc000                                  # 0051bb87
    push eax                                     # 0051bb8c
    call FUN_0051b9a3                            # 0051bb8d
    test eax, eax                                # 0051bb92
    mov dword ptr [ebp + field_10], eax          # 0051bb94
    jne.d8 L_0051bb6f                            # 0051bb97
L_0051bb99:
    # block 0x0051bb99: entered by jmp at 0x0051bb56; je at 0x0051bb6b; fall-through of jne at 0x0051bb97, 5 instruction(s), ends with jne to 0x0051bb33 (backward)
    mov eax, dword ptr [ebp - field_minus_14]    # 0051bb99
    mov eax, dword ptr [eax]                     # 0051bb9c
    test eax, eax                                # 0051bb9e
    mov dword ptr [ebp - field_minus_14], eax    # 0051bba0
    jne.d8 L_0051bb33                            # 0051bba3
L_0051bba5:
    # block 0x0051bba5: entered by je at 0x0051bb2f; fall-through of jne at 0x0051bba3, 3 instruction(s), calls FUN_0052606a, falls into the block at 0x0051bbb0
    and dword ptr [ebx + field_4], 0x0           # 0051bba5
    push 0x7                                     # 0051bba9
    call FUN_0052606a                            # 0051bbab
L_0051bbb0:
    # block 0x0051bbb0: entered by je at 0x0051ba55; je at 0x0051ba6b; jmp at 0x0051ba88; je at 0x0051bb10, 1 instruction(s), falls into the block at 0x0051bbb2
    {load} xor eax, eax                          # 0051bbb0
L_0051bbb2:
    # block 0x0051bbb2: entered by jmp at 0x0051bed0, 7 instruction(s), ends with ret 0x10
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051bbb2
    pop edi                                      # 0051bbb5
    pop esi                                      # 0051bbb6
    pop ebx                                      # 0051bbb7
    mov dword ptr fs:[0x0], ecx                  # 0051bbb8
    leave                                        # 0051bbbf
    ret 0x10                                     # 0051bbc0
L_0051bbc3:
    # block 0x0051bbc3: entered by jne at 0x0051bb54, 4 instruction(s), calls FUN_0052606a, falls into the block at 0x0051bbd0
    push 0x7                                     # 0051bbc3
    mov dword ptr [ebx + field_4], eax           # 0051bbc5
    call FUN_0052606a                            # 0051bbc8
    mov ebx, dword ptr [ebp + field_10]          # 0051bbcd
L_0051bbd0:
    # block 0x0051bbd0: entered by jb at 0x0051bb1d, 5 instruction(s), ends with jne to 0x0051bbf1 (forward)
    mov ecx, dword ptr [ebp + field_10]          # 0051bbd0
    mov ebx, dword ptr [ebx + field_14]          # 0051bbd3
    cmp dword ptr [ecx + field_8], 0x1a          # 0051bbd6
    mov eax, dword ptr [ecx + field_10]          # 0051bbda
    jne.d8 L_0051bbf1                            # 0051bbdd
    # block 0x0051bbdf: entered by fall-through of jne at 0x0051bbdd, 6 instruction(s), calls KERNEL32.dll!GetVersion, falls into the block at 0x0051bbf1
    call dword ptr [0x52a224]                    # 0051bbdf
    mov ecx, dword ptr [ebp + field_10]          # 0051bbe5
    cmp al, 0x4                                  # 0051bbe8
    {load} sbb eax, eax                          # 0051bbea
    and al, -0x10                                # 0051bbec
    add eax, 0x2f                                # 0051bbee
L_0051bbf1:
    # block 0x0051bbf1: entered by jne at 0x0051bbdd, 3 instruction(s), ends with ja to 0x0051bec1 (forward)
    dec eax                                      # 0051bbf1
    cmp eax, 0x30                                # 0051bbf2
    ja.d32 L_0051bec1                            # 0051bbf5
    # block 0x0051bbfb: entered by fall-through of ja at 0x0051bbf5, 1 instruction(s), ends with indirect jump dword ptr [4*eax + 0x51bed5]
    jmp dword ptr [4*eax + SWTAB_0051bed5_VA]    # 0051bbfb
L_0051bc02:
    # block 0x0051bc02: entered by switch case, 4 instruction(s), calls FUN_00520ace, ends with forward jump to 0x0051bd0b
    push dword ptr [ebp + field_c]               # 0051bc02
    call FUN_00520ace                            # 0051bc05
    push eax                                     # 0051bc0a
    jmp.d32 L_0051bd0b                           # 0051bc0b
L_0051bc10:
    # block 0x0051bc10: entered by switch case, 2 instruction(s), ends with forward jump to 0x0051bd0b
    push dword ptr [ebp + field_c]               # 0051bc10
    jmp.d32 L_0051bd0b                           # 0051bc13
L_0051bc18:
    # block 0x0051bc18: entered by switch case, 8 instruction(s), calls FUN_0051abe4, ends with forward jump to 0x0051bd26
    {load} mov eax, esi                          # 0051bc18
    shr eax, 0x10                                # 0051bc1a
    push eax                                     # 0051bc1d
    movsx eax, si                                # 0051bc1e
    push eax                                     # 0051bc21
    push dword ptr [ebp + field_c]               # 0051bc22
    call FUN_0051abe4                            # 0051bc25
    jmp.d32 L_0051bd26                           # 0051bc2a
L_0051bc2f:
    # block 0x0051bc2f: entered by switch case, 4 instruction(s), calls FUN_0051abe4, ends with forward jump to 0x0051be40
    push esi                                     # 0051bc2f
    push dword ptr [ebp + field_c]               # 0051bc30
    call FUN_0051abe4                            # 0051bc33
    jmp.d32 L_0051be40                           # 0051bc38
L_0051bc3d:
    # block 0x0051bc3d: entered by switch case, 15 instruction(s), calls FUN_00520a2c, FUN_0051a7c3, FUN_0051ac0b, ends with jne to 0x0051bc89 (forward)
    lea ecx, [ebp - field_minus_24]              # 0051bc3d
    call FUN_00520a2c                            # 0051bc40
    mov eax, dword ptr [esi + field_4]           # 0051bc45
    and dword ptr [ebp - field_minus_4], 0x0     # 0051bc48
    lea ecx, [ebp - field_minus_60]              # 0051bc4c
    mov dword ptr [ebp - field_minus_20], eax    # 0051bc4f
    call FUN_0051a7c3                            # 0051bc52
    mov eax, dword ptr [esi]                     # 0051bc57
    mov esi, dword ptr [esi + field_8]           # 0051bc59
    push eax                                     # 0051bc5c
    mov byte ptr [ebp - field_minus_4], 0x1      # 0051bc5d
    mov dword ptr [ebp - field_minus_44], eax    # 0051bc61
    call FUN_0051ac0b                            # 0051bc64
    test eax, eax                                # 0051bc69
    jne.d8 L_0051bc89                            # 0051bc6b
    # block 0x0051bc6d: entered by fall-through of jne at 0x0051bc6b, 3 instruction(s), ends with je to 0x0051bc86 (forward)
    mov eax, dword ptr [edi + field_34]          # 0051bc6d
    test eax, eax                                # 0051bc70
    je.d8 L_0051bc86                             # 0051bc72
    # block 0x0051bc74: entered by fall-through of je at 0x0051bc72, 5 instruction(s), calls FUN_0051a57e, ends with je to 0x0051bc86 (forward)
    push dword ptr [ebp - field_minus_44]        # 0051bc74
    lea ecx, [eax + field_20]                    # 0051bc77
    call FUN_0051a57e                            # 0051bc7a
    test eax, eax                                # 0051bc7f
    je.d8 L_0051bc86                             # 0051bc81
    # block 0x0051bc83: entered by fall-through of je at 0x0051bc81, 1 instruction(s), falls into the block at 0x0051bc86
    mov dword ptr [ebp - field_minus_28], eax    # 0051bc83
L_0051bc86:
    # block 0x0051bc86: entered by je at 0x0051bc72; je at 0x0051bc81, 1 instruction(s), falls into the block at 0x0051bc89
    lea eax, [ebp - field_minus_60]              # 0051bc86
L_0051bc89:
    # block 0x0051bc89: entered by jne at 0x0051bc6b, 15 instruction(s), calls indirect ebx, FUN_0051b257, ends with forward jump to 0x0051bce1
    push esi                                     # 0051bc89
    push eax                                     # 0051bc8a
    lea eax, [ebp - field_minus_24]              # 0051bc8b
    {load} mov ecx, edi                          # 0051bc8e
    push eax                                     # 0051bc90
    call ebx                                     # 0051bc91
    and dword ptr [ebp - field_minus_20], 0x0    # 0051bc93
    and dword ptr [ebp - field_minus_44], 0x0    # 0051bc97
    and byte ptr [ebp - field_minus_4], 0x0      # 0051bc9b
    lea ecx, [ebp - field_minus_60]              # 0051bc9f
    mov dword ptr [ebp - field_minus_10], eax    # 0051bca2
    call FUN_0051b257                            # 0051bca5
    or dword ptr [ebp - field_minus_4], -0x1     # 0051bcaa
    lea ecx, [ebp - field_minus_24]              # 0051bcae
    jmp.d8 L_0051bce1                            # 0051bcb1
L_0051bcb3:
    # block 0x0051bcb3: entered by switch case, 14 instruction(s), calls FUN_00520a2c, indirect ebx, falls into the block at 0x0051bce1
    lea ecx, [ebp - field_minus_24]              # 0051bcb3
    call FUN_00520a2c                            # 0051bcb6
    mov eax, dword ptr [esi + field_4]           # 0051bcbb
    push dword ptr [esi + field_8]               # 0051bcbe
    mov dword ptr [ebp - field_minus_20], eax    # 0051bcc1
    lea eax, [ebp - field_minus_24]              # 0051bcc4
    push eax                                     # 0051bcc7
    {load} mov ecx, edi                          # 0051bcc8
    mov dword ptr [ebp - field_minus_4], 0x2     # 0051bcca
    call ebx                                     # 0051bcd1
    and dword ptr [ebp - field_minus_20], 0x0    # 0051bcd3
    or dword ptr [ebp - field_minus_4], -0x1     # 0051bcd7
    mov dword ptr [ebp - field_minus_10], eax    # 0051bcdb
    lea ecx, [ebp - field_minus_24]              # 0051bcde
L_0051bce1:
    # block 0x0051bce1: entered by jmp at 0x0051bcb1, 2 instruction(s), calls FUN_00520b14, ends with forward jump to 0x0051bec1
    call FUN_00520b14                            # 0051bce1
    jmp.d32 L_0051bec1                           # 0051bce6
L_0051bceb:
    # block 0x0051bceb: entered by switch case, 6 instruction(s), calls FUN_0051abe4, ends with forward jump to 0x0051bd21
    mov eax, dword ptr [ebp + field_c]           # 0051bceb
    shr eax, 0x10                                # 0051bcee
    push eax                                     # 0051bcf1
    push esi                                     # 0051bcf2
    call FUN_0051abe4                            # 0051bcf3
    jmp.d8 L_0051bd21                            # 0051bcf8
L_0051bcfa:
    # block 0x0051bcfa: entered by switch case, 5 instruction(s), ends with forward jump to 0x0051be40
    mov eax, dword ptr [ebp + field_c]           # 0051bcfa
    shr eax, 0x10                                # 0051bcfd
    push eax                                     # 0051bd00
    movzx eax, word ptr [ebp + field_c]          # 0051bd01
    jmp.d32 L_0051be40                           # 0051bd05
L_0051bd0a:
    # block 0x0051bd0a: entered by switch case, 1 instruction(s), falls into the block at 0x0051bd0b
    push esi                                     # 0051bd0a
L_0051bd0b:
    # block 0x0051bd0b: entered by jmp at 0x0051bc0b; jmp at 0x0051bc13, 3 instruction(s), calls indirect ebx, ends with forward jump to 0x0051bebe
    {load} mov ecx, edi                          # 0051bd0b
    call ebx                                     # 0051bd0d
    jmp.d32 L_0051bebe                           # 0051bd0f
L_0051bd14:
    # block 0x0051bd14: entered by switch case, 5 instruction(s), calls FUN_0051fa37, falls into the block at 0x0051bd21
    push esi                                     # 0051bd14
    call FUN_0051fa37                            # 0051bd15
    push eax                                     # 0051bd1a
    mov eax, dword ptr [ebp + field_c]           # 0051bd1b
    shr eax, 0x10                                # 0051bd1e
L_0051bd21:
    # block 0x0051bd21: entered by jmp at 0x0051bcf8, 2 instruction(s), falls into the block at 0x0051bd26
    push eax                                     # 0051bd21
    movzx eax, word ptr [ebp + field_c]          # 0051bd22
L_0051bd26:
    # block 0x0051bd26: entered by jmp at 0x0051bc2a, 4 instruction(s), calls indirect ebx, ends with forward jump to 0x0051bebe
    push eax                                     # 0051bd26
    {load} mov ecx, edi                          # 0051bd27
    call ebx                                     # 0051bd29
    jmp.d32 L_0051bebe                           # 0051bd2b
L_0051bd30:
    # block 0x0051bd30: entered by switch case, 3 instruction(s), calls indirect ebx, ends with forward jump to 0x0051bec1
    {load} mov ecx, edi                          # 0051bd30
    call ebx                                     # 0051bd32
    jmp.d32 L_0051bec1                           # 0051bd34
L_0051bd39:
    # block 0x0051bd39: entered by switch case, 2 instruction(s), ends with forward jump to 0x0051be4a
    push dword ptr [ebp + field_c]               # 0051bd39
    jmp.d32 L_0051be4a                           # 0051bd3c
L_0051bd41:
    # block 0x0051bd41: entered by switch case, 5 instruction(s), falls into the block at 0x0051bd4d
    {load} mov eax, esi                          # 0051bd41
    shr eax, 0x10                                # 0051bd43
    movsx eax, ax                                # 0051bd46
    push eax                                     # 0051bd49
    movsx eax, si                                # 0051bd4a
L_0051bd4d:
    # block 0x0051bd4d: entered by jmp at 0x0051bde1, 2 instruction(s), ends with forward jump to 0x0051be2d
    push eax                                     # 0051bd4d
    jmp.d32 L_0051be2d                           # 0051bd4e
L_0051bd53:
    # block 0x0051bd53: entered by switch case, 5 instruction(s), ends with forward jump to 0x0051be6b
    {load} mov eax, esi                          # 0051bd53
    shr eax, 0x10                                # 0051bd55
    push eax                                     # 0051bd58
    movzx eax, si                                # 0051bd59
    jmp.d32 L_0051be6b                           # 0051bd5c
L_0051bd61:
    # block 0x0051bd61: entered by switch case, 9 instruction(s), calls FUN_0051abe4, falls into the block at 0x0051bd79
    push dword ptr [ebp + field_c]               # 0051bd61
    call FUN_0051abe4                            # 0051bd64
    push eax                                     # 0051bd69
    push esi                                     # 0051bd6a
    call FUN_0051abe4                            # 0051bd6b
    push eax                                     # 0051bd70
    {load} xor eax, eax                          # 0051bd71
    cmp dword ptr [edi + field_1c], esi          # 0051bd73
    sete al                                      # 0051bd76
L_0051bd79:
    # block 0x0051bd79: entered by jmp at 0x0051bda9; jmp at 0x0051bdd6; jmp at 0x0051be5c, 2 instruction(s), ends with forward jump to 0x0051be6f
    push eax                                     # 0051bd79
    jmp.d32 L_0051be6f                           # 0051bd7a
L_0051bd7f:
    # block 0x0051bd7f: entered by switch case, 2 instruction(s), calls FUN_00520ace, falls into the block at 0x0051bd87
    push dword ptr [ebp + field_c]               # 0051bd7f
    call FUN_00520ace                            # 0051bd82
L_0051bd87:
    # block 0x0051bd87: entered by jmp at 0x0051bd95; jmp at 0x0051bdb6, 2 instruction(s), ends with forward jump to 0x0051be4a
    push eax                                     # 0051bd87
    jmp.d32 L_0051be4a                           # 0051bd88
L_0051bd8d:
    # block 0x0051bd8d: entered by switch case, 3 instruction(s), calls FUN_0051fa37, ends with backward jump to 0x0051bd87
    push dword ptr [ebp + field_c]               # 0051bd8d
    call FUN_0051fa37                            # 0051bd90
    jmp.d8 L_0051bd87                            # 0051bd95
L_0051bd97:
    # block 0x0051bd97: entered by switch case, 8 instruction(s), calls FUN_0051fa37, ends with backward jump to 0x0051bd79
    {load} mov eax, esi                          # 0051bd97
    shr eax, 0x10                                # 0051bd99
    push eax                                     # 0051bd9c
    movzx eax, si                                # 0051bd9d
    push eax                                     # 0051bda0
    push dword ptr [ebp + field_c]               # 0051bda1
    call FUN_0051fa37                            # 0051bda4
    jmp.d8 L_0051bd79                            # 0051bda9
L_0051bdab:
    # block 0x0051bdab: entered by switch case, 2 instruction(s), ends with forward jump to 0x0051bdb1
    push dword ptr [ebp + field_c]               # 0051bdab
    jmp.d8 L_0051bdb1                            # 0051bdae
L_0051bdb0:
    # block 0x0051bdb0: entered by switch case, 1 instruction(s), falls into the block at 0x0051bdb1
    push esi                                     # 0051bdb0
L_0051bdb1:
    # block 0x0051bdb1: entered by jmp at 0x0051bdae, 2 instruction(s), calls FUN_0051abe4, ends with backward jump to 0x0051bd87
    call FUN_0051abe4                            # 0051bdb1
    jmp.d8 L_0051bd87                            # 0051bdb6
L_0051bdb8:
    # block 0x0051bdb8: entered by switch case, 5 instruction(s), ends with forward jump to 0x0051bdcd
    {load} mov eax, esi                          # 0051bdb8
    shr eax, 0x10                                # 0051bdba
    push eax                                     # 0051bdbd
    movzx eax, si                                # 0051bdbe
    jmp.d8 L_0051bdcd                            # 0051bdc1
L_0051bdc3:
    # block 0x0051bdc3: entered by switch case, 4 instruction(s), falls into the block at 0x0051bdcd
    movsx eax, si                                # 0051bdc3
    shr esi, 0x10                                # 0051bdc6
    movsx ecx, si                                # 0051bdc9
    push ecx                                     # 0051bdcc
L_0051bdcd:
    # block 0x0051bdcd: entered by jmp at 0x0051bdc1, 4 instruction(s), calls FUN_0051abe4, ends with backward jump to 0x0051bd79
    push eax                                     # 0051bdcd
    push dword ptr [ebp + field_c]               # 0051bdce
    call FUN_0051abe4                            # 0051bdd1
    jmp.d8 L_0051bd79                            # 0051bdd6
L_0051bdd8:
    # block 0x0051bdd8: entered by switch case, 4 instruction(s), calls FUN_0051abe4, ends with backward jump to 0x0051bd4d
    push esi                                     # 0051bdd8
    push dword ptr [ebp + field_c]               # 0051bdd9
    call FUN_0051abe4                            # 0051bddc
    jmp.d32 L_0051bd4d                           # 0051bde1
L_0051bde6:
    # block 0x0051bde6: entered by switch case, 4 instruction(s), calls FUN_0051abe4, ends with forward jump to 0x0051be2a
    push esi                                     # 0051bde6
    call FUN_0051abe4                            # 0051bde7
    push eax                                     # 0051bdec
    jmp.d8 L_0051be2a                            # 0051bded
L_0051bdef:
    # block 0x0051bdef: entered by switch case, 6 instruction(s), calls FUN_0051abe4, ends with forward jump to 0x0051be57
    mov eax, dword ptr [ebp + field_c]           # 0051bdef
    shr eax, 0x10                                # 0051bdf2
    push eax                                     # 0051bdf5
    push esi                                     # 0051bdf6
    call FUN_0051abe4                            # 0051bdf7
    jmp.d8 L_0051be57                            # 0051bdfc
L_0051bdfe:
    # block 0x0051bdfe: entered by switch case, 8 instruction(s), ends with jne to 0x0051be25 (forward)
    mov eax, dword ptr [ebp + field_c]           # 0051bdfe
    movsx edx, ax                                # 0051be01
    shr eax, 0x10                                # 0051be04
    cmp dword ptr [ecx + field_10], 0x1d         # 0051be07
    mov dword ptr [ebp + field_8], edx           # 0051be0b
    movsx eax, ax                                # 0051be0e
    mov dword ptr [ebp + field_c], eax           # 0051be11
    jne.d8 L_0051be25                            # 0051be14
    # block 0x0051be16: entered by fall-through of jne at 0x0051be14, 6 instruction(s), calls FUN_0051abe4, ends with forward jump to 0x0051be6f
    push esi                                     # 0051be16
    call FUN_0051abe4                            # 0051be17
    push eax                                     # 0051be1c
    push dword ptr [ebp + field_c]               # 0051be1d
    push dword ptr [ebp + field_8]               # 0051be20
    jmp.d8 L_0051be6f                            # 0051be23
L_0051be25:
    # block 0x0051be25: entered by jne at 0x0051be14, 3 instruction(s), ends with forward jump to 0x0051be2d
    push eax                                     # 0051be25
    push edx                                     # 0051be26
    jmp.d8 L_0051be2d                            # 0051be27
L_0051be29:
    # block 0x0051be29: entered by switch case, 1 instruction(s), falls into the block at 0x0051be2a
    push esi                                     # 0051be29
L_0051be2a:
    # block 0x0051be2a: entered by jmp at 0x0051bded, 1 instruction(s), falls into the block at 0x0051be2d
    push dword ptr [ebp + field_c]               # 0051be2a
L_0051be2d:
    # block 0x0051be2d: entered by jmp at 0x0051bd4e; jmp at 0x0051be27, 3 instruction(s), calls indirect ebx, ends with forward jump to 0x0051bec1
    {load} mov ecx, edi                          # 0051be2d
    call ebx                                     # 0051be2f
    jmp.d32 L_0051bec1                           # 0051be31
L_0051be36:
    # block 0x0051be36: entered by switch case, 4 instruction(s), falls into the block at 0x0051be40
    movsx eax, si                                # 0051be36
    shr esi, 0x10                                # 0051be39
    movsx ecx, si                                # 0051be3c
    push ecx                                     # 0051be3f
L_0051be40:
    # block 0x0051be40: entered by jmp at 0x0051bc38; jmp at 0x0051bd05, 2 instruction(s), ends with forward jump to 0x0051beba
    push eax                                     # 0051be40
    jmp.d8 L_0051beba                            # 0051be41
L_0051be43:
    # block 0x0051be43: entered by switch case, 3 instruction(s), calls indirect ebx, ends with forward jump to 0x0051bebe
    {load} mov ecx, edi                          # 0051be43
    call ebx                                     # 0051be45
    jmp.d8 L_0051bebe                            # 0051be47
L_0051be49:
    # block 0x0051be49: entered by switch case, 1 instruction(s), falls into the block at 0x0051be4a
    push esi                                     # 0051be49
L_0051be4a:
    # block 0x0051be4a: entered by jmp at 0x0051bd3c; jmp at 0x0051bd88, 3 instruction(s), calls indirect ebx, ends with forward jump to 0x0051bec1
    {load} mov ecx, edi                          # 0051be4a
    call ebx                                     # 0051be4c
    jmp.d8 L_0051bec1                            # 0051be4e
L_0051be50:
    # block 0x0051be50: entered by switch case, 3 instruction(s), falls into the block at 0x0051be57
    mov eax, dword ptr [ebp + field_c]           # 0051be50
    push esi                                     # 0051be53
    shr eax, 0x10                                # 0051be54
L_0051be57:
    # block 0x0051be57: entered by jmp at 0x0051bdfc, 3 instruction(s), ends with backward jump to 0x0051bd79
    push eax                                     # 0051be57
    movzx eax, word ptr [ebp + field_c]          # 0051be58
    jmp.d32 L_0051bd79                           # 0051be5c
L_0051be61:
    # block 0x0051be61: entered by switch case, 4 instruction(s), falls into the block at 0x0051be6b
    movsx eax, si                                # 0051be61
    shr esi, 0x10                                # 0051be64
    movsx ecx, si                                # 0051be67
    push ecx                                     # 0051be6a
L_0051be6b:
    # block 0x0051be6b: entered by jmp at 0x0051bd5c, 2 instruction(s), falls into the block at 0x0051be6f
    push eax                                     # 0051be6b
    push dword ptr [ebp + field_c]               # 0051be6c
L_0051be6f:
    # block 0x0051be6f: entered by jmp at 0x0051bd7a; jmp at 0x0051be23, 3 instruction(s), calls indirect ebx, ends with forward jump to 0x0051bec1
    {load} mov ecx, edi                          # 0051be6f
    call ebx                                     # 0051be71
    jmp.d8 L_0051bec1                            # 0051be73
L_0051be75:
    # block 0x0051be75: entered by switch case, 4 instruction(s), calls indirect ebx, falls into the block at 0x0051be7d
    push esi                                     # 0051be75
    {load} mov ecx, edi                          # 0051be76
    push dword ptr [ebp + field_c]               # 0051be78
    call ebx                                     # 0051be7b
L_0051be7d:
    # block 0x0051be7d: entered by jmp at 0x0051ba5b; jne at 0x0051babc, 2 instruction(s), ends with forward jump to 0x0051bec1
    mov dword ptr [ebp - field_minus_10], 0x1    # 0051be7d
    jmp.d8 L_0051bec1                            # 0051be84
L_0051be86:
    # block 0x0051be86: entered by switch case, 13 instruction(s), calls indirect ebx, ends with backward jump to 0x0051ba80
    movzx eax, si                                # 0051be86
    shr esi, 0x10                                # 0051be89
    push esi                                     # 0051be8c
    push eax                                     # 0051be8d
    mov eax, dword ptr [ebp + field_c]           # 0051be8e
    {load} mov ecx, edi                          # 0051be91
    shr eax, 0x10                                # 0051be93
    push eax                                     # 0051be96
    movzx eax, word ptr [ebp + field_c]          # 0051be97
    push eax                                     # 0051be9b
    call ebx                                     # 0051be9c
    mov dword ptr [ebp - field_minus_10], eax    # 0051be9e
    jmp.d32 L_0051ba80                           # 0051bea1
L_0051bea6:
    # block 0x0051bea6: entered by je at 0x0051bb7a, 4 instruction(s), calls FUN_0052606a, falls into the block at 0x0051beb3
    push 0x7                                     # 0051bea6
    mov dword ptr [ebx + field_4], eax           # 0051bea8
    call FUN_0052606a                            # 0051beab
    mov ebx, dword ptr [ebp + field_10]          # 0051beb0
L_0051beb3:
    # block 0x0051beb3: entered by jmp at 0x0051bb23, 1 instruction(s), falls into the block at 0x0051beb6
    mov ebx, dword ptr [ebx + field_14]          # 0051beb3
L_0051beb6:
    # block 0x0051beb6: entered by switch case, 2 instruction(s), falls into the block at 0x0051beba
    push esi                                     # 0051beb6
    push dword ptr [ebp + field_c]               # 0051beb7
L_0051beba:
    # block 0x0051beba: entered by jmp at 0x0051be41, 2 instruction(s), calls indirect ebx, falls into the block at 0x0051bebe
    {load} mov ecx, edi                          # 0051beba
    call ebx                                     # 0051bebc
L_0051bebe:
    # block 0x0051bebe: entered by jmp at 0x0051bd0f; jmp at 0x0051bd2b; jmp at 0x0051be47, 1 instruction(s), falls into the block at 0x0051bec1
    mov dword ptr [ebp - field_minus_10], eax    # 0051bebe
L_0051bec1:
    # block 0x0051bec1: entered by jne at 0x0051ba82; ja at 0x0051bbf5; jmp at 0x0051bce6; jmp at 0x0051bd34; more, 3 instruction(s), ends with je to 0x0051becd (forward)
    mov eax, dword ptr [ebp + field_14]          # 0051bec1
    test eax, eax                                # 0051bec4
    je.d8 L_0051becd                             # 0051bec6
    # block 0x0051bec8: entered by fall-through of je at 0x0051bec6, 2 instruction(s), falls into the block at 0x0051becd
    mov ecx, dword ptr [ebp - field_minus_10]    # 0051bec8
    mov dword ptr [eax], ecx                     # 0051becb
L_0051becd:
    # block 0x0051becd: entered by je at 0x0051bec6, 3 instruction(s), ends with backward jump to 0x0051bbb2
    push 0x1                                     # 0051becd
    pop eax                                      # 0051becf
    jmp.d32 L_0051bbb2                           # 0051bed0

# --- data items (not part of the function) -------------------------
.org 0x0051bed5 - 0x401000
SWTAB_0051bed5:  # 49 case address(es)
    .long L_0051bc02 - .text + 0x401000
    .long L_0051bc10 - .text + 0x401000
    .long L_0051bc18 - .text + 0x401000
    .long L_0051bc3d - .text + 0x401000
    .long L_0051bcb3 - .text + 0x401000
    .long L_0051bceb - .text + 0x401000
    .long L_0051bcfa - .text + 0x401000
    .long L_0051bc18 - .text + 0x401000
    .long L_0051bd0a - .text + 0x401000
    .long L_0051beb6 - .text + 0x401000
    .long L_0051bd14 - .text + 0x401000
    .long L_0051bd30 - .text + 0x401000
    .long L_0051bd39 - .text + 0x401000
    .long L_0051be29 - .text + 0x401000
    .long L_0051bd41 - .text + 0x401000
    .long L_0051bd53 - .text + 0x401000
    .long L_0051bd53 - .text + 0x401000
    .long L_0051be29 - .text + 0x401000
    .long L_0051bd61 - .text + 0x401000
    .long L_0051bd7f - .text + 0x401000
    .long L_0051bd8d - .text + 0x401000
    .long L_0051bd97 - .text + 0x401000
    .long L_0051bdab - .text + 0x401000
    .long L_0051bdb8 - .text + 0x401000
    .long L_0051bdc3 - .text + 0x401000
    .long L_0051bdd8 - .text + 0x401000
    .long L_0051bde6 - .text + 0x401000
    .long L_0051bdef - .text + 0x401000
    .long L_0051bdfe - .text + 0x401000
    .long L_0051bdfe - .text + 0x401000
    .long L_0051be49 - .text + 0x401000
    .long L_0051be75 - .text + 0x401000
    .long L_0051beb6 - .text + 0x401000
    .long L_0051be36 - .text + 0x401000
    .long L_0051be43 - .text + 0x401000
    .long L_0051be49 - .text + 0x401000
    .long L_0051be29 - .text + 0x401000
    .long L_0051bec1 - .text + 0x401000
    .long L_0051bec1 - .text + 0x401000
    .long L_0051bec1 - .text + 0x401000
    .long L_0051bec1 - .text + 0x401000
    .long L_0051bd0a - .text + 0x401000
    .long L_0051be75 - .text + 0x401000
    .long L_0051bdb0 - .text + 0x401000
    .long L_0051bc2f - .text + 0x401000
    .long L_0051be86 - .text + 0x401000
    .long L_0051be29 - .text + 0x401000
    .long L_0051be50 - .text + 0x401000
    .long L_0051be61 - .text + 0x401000
.set SWTAB_0051bed5_VA, SWTAB_0051bed5 - .text + 0x401000

