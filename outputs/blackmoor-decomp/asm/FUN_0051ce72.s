# FUN_0051ce72
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ce72
# extent:       0x0051ce72-0x0051cfd1 (351 code bytes)
# span:         0x0051ce72-0x0051cfd1 (code 351, tables 0, padding 0)
# sha256:       c46895b65483f0bf6256d96e732ffe9722d309aef4680e90844f1340c823c202
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ce72
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_70; [ebp + n] field_4; [edx + n] field_5c, field_64; [esi + n] field_1c, field_24, field_2c; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_24, stk_28
# callees:      calls FUN_0051d526, USER32.dll!GetParent, FUN_0051ec6f, USER32.dll!PeekMessageA, FUN_0051d630, USER32.dll!SendMessageA, FUN_00526978; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 122 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_5c, 0x5c  # offset +0x5c
.equ field_64, 0x64  # offset +0x64
.equ field_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051d630, .text + (0x0051d630 - 0x401000)
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_00526978, .text + (0x00526978 - 0x401000)

.org 0x0051ce72 - 0x401000
.globl FUN_0051ce72
FUN_0051ce72:
    # block 0x0051ce72: entry, 13 instruction(s), ends with je to 0x0051ce9f (forward)
    sub esp, 0x10                                # 0051ce72
    push ebx                                     # 0051ce75
    push ebp                                     # 0051ce76
    push esi                                     # 0051ce77
    push edi                                     # 0051ce78
    push 0x1                                     # 0051ce79
    {load} xor edi, edi                          # 0051ce7b
    test byte ptr [esp + stk_28], 0x4            # 0051ce7d
    pop ebx                                      # 0051ce82
    {load} mov esi, ecx                          # 0051ce83
    mov dword ptr [esp + stk_18], ebx            # 0051ce85
    mov dword ptr [esp + stk_14], edi            # 0051ce89
    je.d8 L_0051ce9f                             # 0051ce8d
    # block 0x0051ce8f: entered by fall-through of je at 0x0051ce8d, 4 instruction(s), calls FUN_0051d526, ends with je to 0x0051cea3 (forward)
    call FUN_0051d526                            # 0051ce8f
    test eax, 0x10000000                         # 0051ce94
    mov dword ptr [esp + stk_10], ebx            # 0051ce99
    je.d8 L_0051cea3                             # 0051ce9d
L_0051ce9f:
    # block 0x0051ce9f: entered by je at 0x0051ce8d; fall-through of je at 0x0051ce9d, 1 instruction(s), falls into the block at 0x0051cea3
    mov dword ptr [esp + stk_10], edi            # 0051ce9f
L_0051cea3:
    # block 0x0051cea3: entered by je at 0x0051ce9d, 8 instruction(s), calls USER32.dll!GetParent, FUN_0051ec6f, falls into the block at 0x0051cec4
    push dword ptr [esi + field_1c]              # 0051cea3
    call dword ptr [0x52a3dc]                    # 0051cea6
    or dword ptr [esi + field_24], 0x18          # 0051ceac
    mov dword ptr [esp + stk_1c], eax            # 0051ceb0
    call FUN_0051ec6f                            # 0051ceb4
    mov ebx, dword ptr [0x52a49c]                # 0051ceb9
    {load} mov ebp, eax                          # 0051cebf
    add ebp, 0x30                                # 0051cec1
L_0051cec4:
    # block 0x0051cec4: entered by jne at 0x0051cf38; jmp at 0x0051cf3e; jmp at 0x0051cfb0, 2 instruction(s), ends with je to 0x0051cf40 (forward)
    cmp dword ptr [esp + stk_18], edi            # 0051cec4
    je.d8 L_0051cf40                             # 0051cec8
    # block 0x0051ceca: entered by fall-through of je at 0x0051cec8, 8 instruction(s), calls USER32.dll!PeekMessageA, ends with jne to 0x0051cf40 (forward)
    push edi                                     # 0051ceca
    push edi                                     # 0051cecb
    push edi                                     # 0051cecc
    push edi                                     # 0051cecd
    push ebp                                     # 0051cece
    call dword ptr [0x52a4c0]                    # 0051cecf
    test eax, eax                                # 0051ced5
    jne.d8 L_0051cf40                            # 0051ced7
    # block 0x0051ced9: entered by fall-through of jne at 0x0051ced7, 2 instruction(s), ends with je to 0x0051cef1 (forward)
    cmp dword ptr [esp + stk_10], edi            # 0051ced9
    je.d8 L_0051cef1                             # 0051cedd
    # block 0x0051cedf: entered by fall-through of je at 0x0051cedd, 6 instruction(s), calls FUN_0051d630, indirect ebx, falls into the block at 0x0051cef1
    push 0x1                                     # 0051cedf
    {load} mov ecx, esi                          # 0051cee1
    call FUN_0051d630                            # 0051cee3
    push dword ptr [esi + field_1c]              # 0051cee8
    call ebx                                     # 0051ceeb
    mov dword ptr [esp + stk_10], edi            # 0051ceed
L_0051cef1:
    # block 0x0051cef1: entered by je at 0x0051cedd, 2 instruction(s), ends with jne to 0x0051cf17 (forward)
    test byte ptr [esp + stk_24], 0x1            # 0051cef1
    jne.d8 L_0051cf17                            # 0051cef6
    # block 0x0051cef8: entered by fall-through of jne at 0x0051cef6, 2 instruction(s), ends with je to 0x0051cf17 (forward)
    cmp dword ptr [esp + stk_1c], edi            # 0051cef8
    je.d8 L_0051cf17                             # 0051cefc
    # block 0x0051cefe: entered by fall-through of je at 0x0051cefc, 2 instruction(s), ends with jne to 0x0051cf17 (forward)
    cmp dword ptr [esp + stk_14], edi            # 0051cefe
    jne.d8 L_0051cf17                            # 0051cf02
    # block 0x0051cf04: entered by fall-through of jne at 0x0051cf02, 5 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x0051cf17
    push dword ptr [esi + field_1c]              # 0051cf04
    push edi                                     # 0051cf07
    push 0x121                                   # 0051cf08
    push dword ptr [esp + stk_28]                # 0051cf0d
    call dword ptr [0x52a4c8]                    # 0051cf11
L_0051cf17:
    # block 0x0051cf17: entered by jne at 0x0051cef6; je at 0x0051cefc; jne at 0x0051cf02, 2 instruction(s), ends with jne to 0x0051cf3a (forward)
    test byte ptr [esp + stk_24], 0x2            # 0051cf17
    jne.d8 L_0051cf3a                            # 0051cf1c
    # block 0x0051cf1e: entered by fall-through of jne at 0x0051cf1c, 9 instruction(s), calls USER32.dll!SendMessageA, ends with jne to 0x0051cec4 (backward)
    mov eax, dword ptr [esp + stk_14]            # 0051cf1e
    inc dword ptr [esp + stk_14]                 # 0051cf22
    push eax                                     # 0051cf26
    push edi                                     # 0051cf27
    push 0x36a                                   # 0051cf28
    push dword ptr [esi + field_1c]              # 0051cf2d
    call dword ptr [0x52a4c8]                    # 0051cf30
    test eax, eax                                # 0051cf36
    jne.d8 L_0051cec4                            # 0051cf38
L_0051cf3a:
    # block 0x0051cf3a: entered by jne at 0x0051cf1c; fall-through of jne at 0x0051cf38, 2 instruction(s), ends with backward jump to 0x0051cec4
    mov dword ptr [esp + stk_18], edi            # 0051cf3a
    jmp.d8 L_0051cec4                            # 0051cf3e
L_0051cf40:
    # block 0x0051cf40: entered by je at 0x0051cec8; jne at 0x0051ced7; jne at 0x0051cfae, 6 instruction(s), calls FUN_0051ec6f, indirect dword ptr [edx + 0x5c], ends with je to 0x0051cfb5 (forward)
    call FUN_0051ec6f                            # 0051cf40
    mov edx, dword ptr [eax]                     # 0051cf45
    {load} mov ecx, eax                          # 0051cf47
    call dword ptr [edx + field_5c]              # 0051cf49
    test eax, eax                                # 0051cf4c
    je.d8 L_0051cfb5                             # 0051cf4e
    # block 0x0051cf50: entered by fall-through of je at 0x0051cf4e, 2 instruction(s), ends with je to 0x0051cf79 (forward)
    cmp dword ptr [esp + stk_10], edi            # 0051cf50
    je.d8 L_0051cf79                             # 0051cf54
    # block 0x0051cf56: entered by fall-through of je at 0x0051cf54, 3 instruction(s), ends with je to 0x0051cf67 (forward)
    mov eax, dword ptr [ebp + field_4]           # 0051cf56
    cmp eax, 0x118                               # 0051cf59
    je.d8 L_0051cf67                             # 0051cf5e
    # block 0x0051cf60: entered by fall-through of je at 0x0051cf5e, 2 instruction(s), ends with jne to 0x0051cf79 (forward)
    cmp eax, 0x104                               # 0051cf60
    jne.d8 L_0051cf79                            # 0051cf65
L_0051cf67:
    # block 0x0051cf67: entered by je at 0x0051cf5e; fall-through of jne at 0x0051cf65, 6 instruction(s), calls FUN_0051d630, indirect ebx, falls into the block at 0x0051cf79
    push 0x1                                     # 0051cf67
    {load} mov ecx, esi                          # 0051cf69
    call FUN_0051d630                            # 0051cf6b
    push dword ptr [esi + field_1c]              # 0051cf70
    call ebx                                     # 0051cf73
    mov dword ptr [esp + stk_10], edi            # 0051cf75
L_0051cf79:
    # block 0x0051cf79: entered by je at 0x0051cf54; jne at 0x0051cf65, 5 instruction(s), calls indirect dword ptr [eax + 0x70], ends with je to 0x0051cfc0 (forward)
    mov eax, dword ptr [esi]                     # 0051cf79
    {load} mov ecx, esi                          # 0051cf7b
    call dword ptr [eax + field_70]              # 0051cf7d
    test eax, eax                                # 0051cf80
    je.d8 L_0051cfc0                             # 0051cf82
    # block 0x0051cf84: entered by fall-through of je at 0x0051cf82, 7 instruction(s), calls FUN_0051ec6f, indirect dword ptr [edx + 0x64], ends with je to 0x0051cfa1 (forward)
    call FUN_0051ec6f                            # 0051cf84
    mov edx, dword ptr [eax]                     # 0051cf89
    push ebp                                     # 0051cf8b
    {load} mov ecx, eax                          # 0051cf8c
    call dword ptr [edx + field_64]              # 0051cf8e
    test eax, eax                                # 0051cf91
    je.d8 L_0051cfa1                             # 0051cf93
    # block 0x0051cf95: entered by fall-through of je at 0x0051cf93, 2 instruction(s), falls into the block at 0x0051cfa1
    mov dword ptr [esp + stk_18], 0x1            # 0051cf95
    mov dword ptr [esp + stk_14], edi            # 0051cf9d
L_0051cfa1:
    # block 0x0051cfa1: entered by je at 0x0051cf93, 8 instruction(s), calls USER32.dll!PeekMessageA, ends with jne to 0x0051cf40 (backward)
    push edi                                     # 0051cfa1
    push edi                                     # 0051cfa2
    push edi                                     # 0051cfa3
    push edi                                     # 0051cfa4
    push ebp                                     # 0051cfa5
    call dword ptr [0x52a4c0]                    # 0051cfa6
    test eax, eax                                # 0051cfac
    jne.d8 L_0051cf40                            # 0051cfae
    # block 0x0051cfb0: entered by fall-through of jne at 0x0051cfae, 1 instruction(s), ends with backward jump to 0x0051cec4
    jmp.d32 L_0051cec4                           # 0051cfb0
L_0051cfb5:
    # block 0x0051cfb5: entered by je at 0x0051cf4e, 4 instruction(s), calls FUN_00526978, ends with forward jump to 0x0051cfc7
    push edi                                     # 0051cfb5
    call FUN_00526978                            # 0051cfb6
    or eax, -0x1                                 # 0051cfbb
    jmp.d8 L_0051cfc7                            # 0051cfbe
L_0051cfc0:
    # block 0x0051cfc0: entered by je at 0x0051cf82, 2 instruction(s), falls into the block at 0x0051cfc7
    and dword ptr [esi + field_24], -0x19        # 0051cfc0
    mov eax, dword ptr [esi + field_2c]          # 0051cfc4
L_0051cfc7:
    # block 0x0051cfc7: entered by jmp at 0x0051cfbe, 6 instruction(s), ends with ret 0x4
    pop edi                                      # 0051cfc7
    pop esi                                      # 0051cfc8
    pop ebp                                      # 0051cfc9
    pop ebx                                      # 0051cfca
    add esp, 0x10                                # 0051cfcb
    ret 0x4                                      # 0051cfce

