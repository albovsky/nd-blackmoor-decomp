# FUN_0051aa23
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051aa23
# extent:       0x0051aa23-0x0051aacd (170 code bytes)
# span:         0x0051aa23-0x0051aacd (code 170, tables 0, padding 0)
# sha256:       44f764b57a1cdcc1ae6a425cc266968995084b62e2722fb09e78986659fe6f2a
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051aa23
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_5c, field_98; [ebp + n] field_8, field_c, field_10, field_14, field_18, field_minus_4, field_minus_10, field_minus_14, field_minus_24, field_minus_40; [ebx + n] field_34, field_38, field_3c, field_40; [edi + n] field_34
# callees:      calls FUN_0050f978, FUN_00525b0f, FUN_0051a8b0, FUN_0051a8d3, tail jump FUN_0051aaf7; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_24, 0x24  # offset -0x24
.equ field_minus_40, 0x40  # offset -0x40
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_5c, 0x5c  # offset +0x5c
.equ field_98, 0x98  # offset +0x98

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a8b0, .text + (0x0051a8b0 - 0x401000)
.set FUN_0051a8d3, .text + (0x0051a8d3 - 0x401000)
.set FUN_0051aaf7, .text + (0x0051aaf7 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051aa23 - 0x401000
.globl FUN_0051aa23
FUN_0051aa23:
    # block 0x0051aa23: entry, 30 instruction(s), calls FUN_0050f978, FUN_00525b0f, ends with jne to 0x0051aa88 (forward)
    mov eax, 0x528b40                            # 0051aa23
    call FUN_0050f978                            # 0051aa28
    sub esp, 0x34                                # 0051aa2d
    push ebx                                     # 0051aa30
    push esi                                     # 0051aa31
    push edi                                     # 0051aa32
    mov ecx, 0x63c444                            # 0051aa33
    mov dword ptr [ebp - field_minus_10], esp    # 0051aa38
    push 0x52496c                                # 0051aa3b
    call FUN_00525b0f                            # 0051aa40
    {load} mov ebx, eax                          # 0051aa45
    push 0x7                                     # 0051aa47
    pop ecx                                      # 0051aa49
    lea edi, [ebp - field_minus_40]              # 0051aa4a
    lea eax, [ebx + field_34]                    # 0051aa4d
    and dword ptr [ebp - field_minus_4], 0x0     # 0051aa50
    {load} mov esi, eax                          # 0051aa54
    mov dword ptr [ebp - field_minus_14], ebx    # 0051aa56
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0051aa59
    mov ecx, dword ptr [ebp + field_c]           # 0051aa5b
    mov esi, dword ptr [ebp + field_10]          # 0051aa5e
    mov edi, dword ptr [ebp + field_8]           # 0051aa61
    mov dword ptr [eax], ecx                     # 0051aa64
    mov eax, dword ptr [ebp + field_14]          # 0051aa66
    cmp esi, 0x2                                 # 0051aa69
    mov dword ptr [ebx + field_3c], eax          # 0051aa6c
    mov eax, dword ptr [ebp + field_18]          # 0051aa6f
    mov dword ptr [ebx + field_38], esi          # 0051aa72
    mov dword ptr [ebx + field_40], eax          # 0051aa75
    jne.d8 L_0051aa88                            # 0051aa78
    # block 0x0051aa7a: entered by fall-through of jne at 0x0051aa78, 3 instruction(s), ends with je to 0x0051aa88 (forward)
    mov ecx, dword ptr [edi + field_34]          # 0051aa7a
    test ecx, ecx                                # 0051aa7d
    je.d8 L_0051aa88                             # 0051aa7f
    # block 0x0051aa81: entered by fall-through of je at 0x0051aa7f, 3 instruction(s), calls indirect dword ptr [eax + 0x5c], falls into the block at 0x0051aa88
    mov eax, dword ptr [ecx]                     # 0051aa81
    push 0x0                                     # 0051aa83
    call dword ptr [eax + field_5c]              # 0051aa85
L_0051aa88:
    # block 0x0051aa88: entered by jne at 0x0051aa78; je at 0x0051aa7f, 3 instruction(s), ends with jne to 0x0051aaa2 (forward)
    and dword ptr [ebp + field_8], 0x0           # 0051aa88
    cmp esi, 0x110                               # 0051aa8c
    jne.d8 L_0051aaa2                            # 0051aa92
    # block 0x0051aa94: entered by fall-through of jne at 0x0051aa92, 6 instruction(s), calls FUN_0051a8b0, falls into the block at 0x0051aaa2
    lea eax, [ebp + field_8]                     # 0051aa94
    push eax                                     # 0051aa97
    lea eax, [ebp - field_minus_24]              # 0051aa98
    push eax                                     # 0051aa9b
    push edi                                     # 0051aa9c
    call FUN_0051a8b0                            # 0051aa9d
L_0051aaa2:
    # block 0x0051aaa2: entered by jne at 0x0051aa92, 9 instruction(s), calls indirect dword ptr [eax + 0x98], ends with jne to 0x0051aaf7 (forward)
    push dword ptr [ebp + field_18]              # 0051aaa2
    mov eax, dword ptr [edi]                     # 0051aaa5
    {load} mov ecx, edi                          # 0051aaa7
    push dword ptr [ebp + field_14]              # 0051aaa9
    push esi                                     # 0051aaac
    call dword ptr [eax + field_98]              # 0051aaad
    cmp esi, 0x110                               # 0051aab3
    mov dword ptr [ebp + field_18], eax          # 0051aab9
    jne.d8 . + (59)  # -> FUN_0051aaf7           # 0051aabc
    # block 0x0051aabe: entered by fall-through of jne at 0x0051aabc, 6 instruction(s), calls FUN_0051a8d3, ends with forward jump to 0x0051aaf7
    push dword ptr [ebp + field_8]               # 0051aabe
    lea eax, [ebp - field_minus_24]              # 0051aac1
    push eax                                     # 0051aac4
    push edi                                     # 0051aac5
    call FUN_0051a8d3                            # 0051aac6
    jmp.d8 . + (44)  # -> FUN_0051aaf7           # 0051aacb

