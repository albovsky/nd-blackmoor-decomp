# FUN_004ffa30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ffa30
# extent:       0x004ffa30-0x004ffb86 (342 code bytes)
# span:         0x004ffa30-0x004ffb90 (code 342, tables 0, padding 10)
# sha256:       1317884c310467d15b09058dbc2b53634acbd221ede18d42bcc0677954654b17
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ffa30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_c, field_64; [ebp + n] field_4, field_1c; [ecx + n] field_20, field_120, field_220; [edi + n] field_4, field_c, field_10, field_14, field_18, field_1c; [edx + n] field_10, field_2c; [esi + n] field_4, field_18, field_1c, field_20, field_24, field_28, field_2c, field_30, field_34, field_38, field_3c, field_40; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20
# callees:      calls FUN_004feea0, FUN_0050bc50, FUN_0050be60, FUN_004fee30; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 135 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_64, 0x64  # offset +0x64
.equ field_120, 0x120  # offset +0x120
.equ field_220, 0x220  # offset +0x220

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_004feea0, .text + (0x004feea0 - 0x401000)
.set FUN_0050bc50, .text + (0x0050bc50 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)

.org 0x004ffa30 - 0x401000
.globl FUN_004ffa30
FUN_004ffa30:
    # block 0x004ffa30: entry, 28 instruction(s), calls FUN_004feea0, FUN_0050bc50, FUN_0050be60, ends with je to 0x004ffa81 (forward)
    push ecx                                     # 004ffa30
    push ebx                                     # 004ffa31
    push ebp                                     # 004ffa32
    push esi                                     # 004ffa33
    mov esi, dword ptr [esp + stk_14]            # 004ffa34
    push edi                                     # 004ffa38
    push esi                                     # 004ffa39
    mov eax, dword ptr [esi + field_40]          # 004ffa3a
    lea ebx, [esi + field_4]                     # 004ffa3d
    mov ebp, dword ptr [eax + field_4]           # 004ffa40
    mov ecx, dword ptr [eax + field_64]          # 004ffa43
    mov dword ptr [esp + stk_14], ecx            # 004ffa46
    mov edx, dword ptr [ebp + field_1c]          # 004ffa4a
    mov dword ptr [esp + stk_1c], edx            # 004ffa4d
    call FUN_004feea0                            # 004ffa51
    mov edi, dword ptr [esp + stk_20]            # 004ffa56
    mov eax, dword ptr [edi + field_4]           # 004ffa5a
    mov ecx, dword ptr [edi]                     # 004ffa5d
    push eax                                     # 004ffa5f
    push ecx                                     # 004ffa60
    push ebx                                     # 004ffa61
    call FUN_0050bc50                            # 004ffa62
    push 0x1                                     # 004ffa67
    push ebx                                     # 004ffa69
    call FUN_0050be60                            # 004ffa6a
    add esp, 0x18                                # 004ffa6f
    test eax, eax                                # 004ffa72
    je.d8 L_004ffa81                             # 004ffa74
    # block 0x004ffa76: entered by fall-through of je at 0x004ffa74, 7 instruction(s), ends with ret
    pop edi                                      # 004ffa76
    pop esi                                      # 004ffa77
    pop ebp                                      # 004ffa78
    mov eax, 0xffffff79                          # 004ffa79
    pop ebx                                      # 004ffa7e
    pop ecx                                      # 004ffa7f
    ret                                          # 004ffa80
L_004ffa81:
    # block 0x004ffa81: entered by je at 0x004ffa74, 9 instruction(s), calls FUN_0050be60, ends with jne to 0x004ffaa6 (forward)
    mov edx, dword ptr [esp + stk_10]            # 004ffa81
    mov eax, dword ptr [edx + field_2c]          # 004ffa85
    push eax                                     # 004ffa88
    push ebx                                     # 004ffa89
    call FUN_0050be60                            # 004ffa8a
    add esp, 0x8                                 # 004ffa8f
    cmp eax, -0x1                                # 004ffa92
    mov dword ptr [esp + stk_1c], eax            # 004ffa95
    jne.d8 L_004ffaa6                            # 004ffa99
    # block 0x004ffa9b: entered by fall-through of jne at 0x004ffa99, 7 instruction(s), ends with ret
    pop edi                                      # 004ffa9b
    pop esi                                      # 004ffa9c
    pop ebp                                      # 004ffa9d
    mov eax, 0xffffff78                          # 004ffa9e
    pop ebx                                      # 004ffaa3
    pop ecx                                      # 004ffaa4
    ret                                          # 004ffaa5
L_004ffaa6:
    # block 0x004ffaa6: entered by jne at 0x004ffa99, 8 instruction(s), ends with je to 0x004ffae5 (forward)
    mov ecx, dword ptr [esp + stk_18]            # 004ffaa6
    mov dword ptr [esi + field_28], eax          # 004ffaaa
    mov edx, dword ptr [ecx + 4*eax + field_20]  # 004ffaad
    {load} xor ecx, ecx                          # 004ffab1
    mov eax, dword ptr [edx]                     # 004ffab3
    {load} cmp eax, ecx                          # 004ffab5
    mov dword ptr [esi + field_1c], eax          # 004ffab7
    je.d8 L_004ffae5                             # 004ffaba
    # block 0x004ffabc: entered by fall-through of je at 0x004ffaba, 11 instruction(s), calls FUN_0050be60, ends with jne to 0x004ffaeb (forward)
    push 0x1                                     # 004ffabc
    push ebx                                     # 004ffabe
    call FUN_0050be60                            # 004ffabf
    push 0x1                                     # 004ffac4
    push ebx                                     # 004ffac6
    mov dword ptr [esi + field_18], eax          # 004ffac7
    call FUN_0050be60                            # 004ffaca
    add esp, 0x10                                # 004ffacf
    cmp eax, -0x1                                # 004ffad2
    mov dword ptr [esi + field_20], eax          # 004ffad5
    jne.d8 L_004ffaeb                            # 004ffad8
    # block 0x004ffada: entered by fall-through of jne at 0x004ffad8, 7 instruction(s), ends with ret
    pop edi                                      # 004ffada
    pop esi                                      # 004ffadb
    pop ebp                                      # 004ffadc
    mov eax, 0xffffff78                          # 004ffadd
    pop ebx                                      # 004ffae2
    pop ecx                                      # 004ffae3
    ret                                          # 004ffae4
L_004ffae5:
    # block 0x004ffae5: entered by je at 0x004ffaba, 2 instruction(s), falls into the block at 0x004ffaeb
    mov dword ptr [esi + field_18], ecx          # 004ffae5
    mov dword ptr [esi + field_20], ecx          # 004ffae8
L_004ffaeb:
    # block 0x004ffaeb: entered by jne at 0x004ffad8, 27 instruction(s), calls FUN_004fee30, ends with jle to 0x004ffb54 (forward)
    mov eax, dword ptr [edi + field_10]          # 004ffaeb
    mov dword ptr [esi + field_30], eax          # 004ffaee
    mov ecx, dword ptr [edi + field_14]          # 004ffaf1
    mov dword ptr [esi + field_34], ecx          # 004ffaf4
    mov edx, dword ptr [edi + field_18]          # 004ffaf7
    mov eax, dword ptr [edi + field_1c]          # 004ffafa
    sub edx, 0x3                                 # 004ffafd
    sbb eax, 0x0                                 # 004ffb00
    mov dword ptr [esi + field_38], edx          # 004ffb03
    mov edx, dword ptr [esi + field_1c]          # 004ffb06
    mov dword ptr [esi + field_3c], eax          # 004ffb09
    mov ecx, dword ptr [edi + field_c]           # 004ffb0c
    mov eax, dword ptr [esp + stk_18]            # 004ffb0f
    mov dword ptr [esi + field_2c], ecx          # 004ffb13
    mov ecx, dword ptr [eax + 4*edx]             # 004ffb16
    mov dword ptr [esi + field_24], ecx          # 004ffb19
    mov edx, dword ptr [ebp + field_4]           # 004ffb1c
    shl edx, 0x2                                 # 004ffb1f
    push edx                                     # 004ffb22
    push esi                                     # 004ffb23
    call FUN_004fee30                            # 004ffb24
    mov dword ptr [esi], eax                     # 004ffb29
    mov eax, dword ptr [ebp + field_4]           # 004ffb2b
    add esp, 0x8                                 # 004ffb2e
    {load} xor edi, edi                          # 004ffb31
    test eax, eax                                # 004ffb33
    jle.d8 L_004ffb54                            # 004ffb35
L_004ffb37:
    # block 0x004ffb37: entered by jl at 0x004ffb52; fall-through of jle at 0x004ffb35, 12 instruction(s), calls FUN_004fee30, ends with jl to 0x004ffb37 (backward)
    mov eax, dword ptr [esi + field_24]          # 004ffb37
    shl eax, 0x2                                 # 004ffb3a
    push eax                                     # 004ffb3d
    push esi                                     # 004ffb3e
    call FUN_004fee30                            # 004ffb3f
    mov ecx, dword ptr [esi]                     # 004ffb44
    add esp, 0x8                                 # 004ffb46
    mov dword ptr [ecx + 4*edi], eax             # 004ffb49
    mov eax, dword ptr [ebp + field_4]           # 004ffb4c
    inc edi                                      # 004ffb4f
    {load} cmp edi, eax                          # 004ffb50
    jl.d8 L_004ffb37                             # 004ffb52
L_004ffb54:
    # block 0x004ffb54: entered by jle at 0x004ffb35; fall-through of jl at 0x004ffb52, 17 instruction(s), calls indirect dword ptr [edx + 0x10], ends with ret
    mov ecx, dword ptr [esp + stk_18]            # 004ffb54
    mov edx, dword ptr [esp + stk_1c]            # 004ffb58
    mov eax, dword ptr [ecx + 4*edx + field_20]  # 004ffb5c
    mov eax, dword ptr [eax + field_c]           # 004ffb60
    mov edx, dword ptr [ecx + 4*eax + field_120] # 004ffb63
    mov eax, dword ptr [ecx + 4*eax + field_220] # 004ffb6a
    push eax                                     # 004ffb71
    push esi                                     # 004ffb72
    mov edx, dword ptr [4*edx + 0x5669f4]        # 004ffb73
    call dword ptr [edx + field_10]              # 004ffb7a
    add esp, 0x8                                 # 004ffb7d
    pop edi                                      # 004ffb80
    pop esi                                      # 004ffb81
    pop ebp                                      # 004ffb82
    pop ebx                                      # 004ffb83
    pop ecx                                      # 004ffb84
    ret                                          # 004ffb85

# --- data items (not part of the function) -------------------------
.org 0x004ffb86 - 0x401000
PAD_004ffb86:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

