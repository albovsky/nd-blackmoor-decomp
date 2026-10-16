# FUN_0051c04f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c04f
# extent:       0x0051c04f-0x0051c0c9 (122 code bytes)
# span:         0x0051c04f-0x0051c0c9 (code 122, tables 0, padding 0)
# sha256:       c6538a1a9788b0be4710780772290304c05da7d3a3ea7b58ad538128994e1ada
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c04f
# arguments:    2 ebp-relative stack slot(s) referenced: arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c, field_b8; [edi + n] field_1c; [esi + n] field_8
# callees:      calls USER32.dll!GetDlgCtrlID, FUN_00525b0f, FUN_0051c519; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------
.set FUN_0051c519, .text + (0x0051c519 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051c04f - 0x401000
.globl FUN_0051c04f
FUN_0051c04f:
    # block 0x0051c04f: entry, 21 instruction(s), calls USER32.dll!GetDlgCtrlID, FUN_00525b0f, ends with je to 0x0051c099 (forward)
    push ebp                                     # 0051c04f
    {load} mov ebp, esp                          # 0051c050
    sub esp, 0xc                                 # 0051c052
    push ebx                                     # 0051c055
    push esi                                     # 0051c056
    mov esi, dword ptr [ebp + arg_c]             # 0051c057
    push edi                                     # 0051c05a
    {load} mov edi, ecx                          # 0051c05b
    mov ebx, dword ptr [esi]                     # 0051c05d
    push ebx                                     # 0051c05f
    call dword ptr [0x52a40c]                    # 0051c060
    movzx eax, ax                                # 0051c066
    mov dword ptr [ebp - local_4], eax           # 0051c069
    mov eax, dword ptr [esi + field_8]           # 0051c06c
    push 0x52496c                                # 0051c06f
    mov ecx, 0x63c444                            # 0051c074
    mov dword ptr [ebp + arg_c], eax             # 0051c079
    call FUN_00525b0f                            # 0051c07c
    mov eax, dword ptr [eax + field_b8]          # 0051c081
    cmp eax, dword ptr [edi + field_1c]          # 0051c087
    je.d8 L_0051c099                             # 0051c08a
    # block 0x0051c08c: entered by fall-through of je at 0x0051c08a, 5 instruction(s), calls FUN_0051c519, ends with je to 0x0051c09e (forward)
    push dword ptr [ebp + arg_10]                # 0051c08c
    push ebx                                     # 0051c08f
    call FUN_0051c519                            # 0051c090
    test eax, eax                                # 0051c095
    je.d8 L_0051c09e                             # 0051c097
L_0051c099:
    # block 0x0051c099: entered by je at 0x0051c08a; fall-through of je at 0x0051c097, 3 instruction(s), ends with forward jump to 0x0051c0c2
    push 0x1                                     # 0051c099
    pop eax                                      # 0051c09b
    jmp.d8 L_0051c0c2                            # 0051c09c
L_0051c09e:
    # block 0x0051c09e: entered by je at 0x0051c097, 13 instruction(s), calls indirect dword ptr [eax + 0xc], falls into the block at 0x0051c0c2
    mov eax, dword ptr [ebp + arg_10]            # 0051c09e
    lea ecx, [ebp - local_c]                     # 0051c0a1
    push 0x0                                     # 0051c0a4
    push ecx                                     # 0051c0a6
    movzx ecx, word ptr [ebp + arg_c]            # 0051c0a7
    or ecx, 0x4e0000                             # 0051c0ab
    mov dword ptr [ebp - local_c], eax           # 0051c0b1
    mov eax, dword ptr [edi]                     # 0051c0b4
    push ecx                                     # 0051c0b6
    push dword ptr [ebp - local_4]               # 0051c0b7
    {load} mov ecx, edi                          # 0051c0ba
    mov dword ptr [ebp - local_8], esi           # 0051c0bc
    call dword ptr [eax + field_c]               # 0051c0bf
L_0051c0c2:
    # block 0x0051c0c2: entered by jmp at 0x0051c09c, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0051c0c2
    pop esi                                      # 0051c0c3
    pop ebx                                      # 0051c0c4
    leave                                        # 0051c0c5
    ret 0xc                                      # 0051c0c6

