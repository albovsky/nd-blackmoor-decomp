# FUN_0051aea1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051aea1
# extent:       0x0051aea1-0x0051b097 (502 code bytes)
# span:         0x0051aea1-0x0051b097 (code 502, tables 0, padding 0)
# sha256:       743e01893de19e13bf6470d5e8e125b1cbcd142b9f4e9ef199d138871ca0d792
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051aea1
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_4, local_8, local_10
# fields:       [eax + n] field_14, field_28, field_2c, field_50, field_80; [edi + n] field_20, field_23, field_28; [esi + n] field_14, field_2c
# callees:      calls FUN_00525b0f, USER32.dll!CallNextHookEx, FUN_00525371, USER32.dll!GetClassLongA, KERNEL32.dll!GlobalGetAtomNameA, KERNEL32.dll!lstrcmpiA, FUN_0051ac29, FUN_0051aa23, FUN_0051acc0, USER32.dll!GetWindowLongA, USER32.dll!SetWindowLongA, USER32.dll!SetPropA, KERNEL32.dll!GlobalAddAtomA, USER32.dll!UnhookWindowsHookEx; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 170 instruction(s), 21 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_20, 0x20  # offset +0x20
.equ field_23, 0x23  # offset +0x23
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_50, 0x50  # offset +0x50
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------
.set FUN_0051aa23, .text + (0x0051aa23 - 0x401000)
.set FUN_0051ac29, .text + (0x0051ac29 - 0x401000)
.set FUN_0051acc0, .text + (0x0051acc0 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051aea1 - 0x401000
.globl FUN_0051aea1
FUN_0051aea1:
    # block 0x0051aea1: entry, 9 instruction(s), calls FUN_00525b0f, ends with je to 0x0051aed6 (forward)
    push ebp                                     # 0051aea1
    {load} mov ebp, esp                          # 0051aea2
    sub esp, 0x10                                # 0051aea4
    push 0x52496c                                # 0051aea7
    mov ecx, 0x63c444                            # 0051aeac
    call FUN_00525b0f                            # 0051aeb1
    cmp dword ptr [ebp + arg_8], 0x3             # 0051aeb6
    mov dword ptr [ebp - local_4], eax           # 0051aeba
    je.d8 L_0051aed6                             # 0051aebd
    # block 0x0051aebf: entered by fall-through of je at 0x0051aebd, 6 instruction(s), calls USER32.dll!CallNextHookEx, ends with forward jump to 0x0051b093
    push dword ptr [ebp + arg_10]                # 0051aebf
    push dword ptr [ebp + arg_c]                 # 0051aec2
    push dword ptr [ebp + arg_8]                 # 0051aec5
    push dword ptr [eax + field_2c]              # 0051aec8
    call dword ptr [0x52a420]                    # 0051aecb
    jmp.d32 L_0051b093                           # 0051aed1
L_0051aed6:
    # block 0x0051aed6: entered by je at 0x0051aebd, 12 instruction(s), calls FUN_00525371, ends with jne to 0x0051af06 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 0051aed6
    push ebx                                     # 0051aed9
    push esi                                     # 0051aeda
    mov esi, dword ptr [eax + field_14]          # 0051aedb
    push edi                                     # 0051aede
    mov edi, dword ptr [ecx]                     # 0051aedf
    call FUN_00525371                            # 0051aee1
    movzx eax, byte ptr [eax + field_14]         # 0051aee6
    mov ebx, dword ptr [ebp + arg_c]             # 0051aeea
    mov dword ptr [ebp - local_8], eax           # 0051aeed
    test esi, esi                                # 0051aef0
    jne.d8 L_0051af06                            # 0051aef2
    # block 0x0051aef4: entered by fall-through of jne at 0x0051aef2, 2 instruction(s), ends with jne to 0x0051b067 (forward)
    test byte ptr [edi + field_23], 0x40         # 0051aef4
    jne.d32 L_0051b067                           # 0051aef8
    # block 0x0051aefe: entered by fall-through of jne at 0x0051aef8, 2 instruction(s), ends with jne to 0x0051b067 (forward)
    test eax, eax                                # 0051aefe
    jne.d32 L_0051b067                           # 0051af00
L_0051af06:
    # block 0x0051af06: entered by jne at 0x0051aef2; fall-through of jne at 0x0051af00, 2 instruction(s), ends with je to 0x0051af5b (forward)
    cmp dword ptr [0x63c7b4], 0x0                # 0051af06
    je.d8 L_0051af5b                             # 0051af0d
    # block 0x0051af0f: entered by fall-through of je at 0x0051af0d, 5 instruction(s), calls USER32.dll!GetClassLongA, ends with jne to 0x0051b067 (forward)
    push -0x1a                                   # 0051af0f
    push ebx                                     # 0051af11
    call dword ptr [0x52a424]                    # 0051af12
    test eax, 0x10000                            # 0051af18
    jne.d32 L_0051b067                           # 0051af1d
    # block 0x0051af23: entered by fall-through of jne at 0x0051af1d, 5 instruction(s), ends with jne to 0x0051af47 (forward)
    mov eax, dword ptr [edi + field_28]          # 0051af23
    {load} mov ecx, eax                          # 0051af26
    shr ecx, 0x10                                # 0051af28
    test cx, cx                                  # 0051af2b
    jne.d8 L_0051af47                            # 0051af2e
    # block 0x0051af30: entered by fall-through of jne at 0x0051af2e, 8 instruction(s), calls KERNEL32.dll!GlobalGetAtomNameA, falls into the block at 0x0051af47
    and byte ptr [ebp - local_10], cl            # 0051af30
    lea eax, [ebp - local_10]                    # 0051af33
    push 0x5                                     # 0051af36
    push eax                                     # 0051af38
    mov ax, word ptr [edi + field_28]            # 0051af39
    push eax                                     # 0051af3d
    call dword ptr [0x52a22c]                    # 0051af3e
    lea eax, [ebp - local_10]                    # 0051af44
L_0051af47:
    # block 0x0051af47: entered by jne at 0x0051af2e, 5 instruction(s), calls KERNEL32.dll!lstrcmpiA, ends with je to 0x0051b067 (forward)
    push 0x52eb18                                # 0051af47
    push eax                                     # 0051af4c
    call dword ptr [0x52a230]                    # 0051af4d
    test eax, eax                                # 0051af53
    je.d32 L_0051b067                            # 0051af55
L_0051af5b:
    # block 0x0051af5b: entered by je at 0x0051af0d; fall-through of je at 0x0051af55, 2 instruction(s), ends with je to 0x0051b00c (forward)
    test esi, esi                                # 0051af5b
    je.d32 L_0051b00c                            # 0051af5d
    # block 0x0051af63: entered by fall-through of je at 0x0051af5d, 12 instruction(s), calls FUN_0051ac29, indirect dword ptr [eax + 0x50], indirect dword ptr [eax + 0x80], ends with jne to 0x0051afe9 (forward)
    push ebx                                     # 0051af63
    {load} mov ecx, esi                          # 0051af64
    call FUN_0051ac29                            # 0051af66
    mov eax, dword ptr [esi]                     # 0051af6b
    {load} mov ecx, esi                          # 0051af6d
    call dword ptr [eax + field_50]              # 0051af6f
    mov eax, dword ptr [esi]                     # 0051af72
    {load} mov ecx, esi                          # 0051af74
    call dword ptr [eax + field_80]              # 0051af76
    cmp dword ptr [0x63c7a4], 0x0                # 0051af7c
    mov dword ptr [ebp + arg_c], eax             # 0051af83
    jne.d8 L_0051afe9                            # 0051af86
    # block 0x0051af88: entered by fall-through of jne at 0x0051af86, 2 instruction(s), ends with jne to 0x0051afe9 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0051af88
    jne.d8 L_0051afe9                            # 0051af8c
    # block 0x0051af8e: entered by fall-through of jne at 0x0051af8c, 3 instruction(s), ends with je to 0x0051afe9 (forward)
    mov edi, dword ptr [0x63c740]                # 0051af8e
    test edi, edi                                # 0051af94
    je.d8 L_0051afe9                             # 0051af96
    # block 0x0051af98: entered by fall-through of je at 0x0051af96, 2 instruction(s), ends with je to 0x0051afe9 (forward)
    cmp dword ptr [edi + field_20], 0x0          # 0051af98
    je.d8 L_0051afe9                             # 0051af9c
    # block 0x0051af9e: entered by fall-through of je at 0x0051af9c, 9 instruction(s), calls FUN_0051aa23, ends with je to 0x0051afe9 (forward)
    push 0x0                                     # 0051af9e
    push 0x0                                     # 0051afa0
    push 0x36f                                   # 0051afa2
    push ebx                                     # 0051afa7
    push esi                                     # 0051afa8
    call FUN_0051aa23                            # 0051afa9
    test eax, eax                                # 0051afae
    mov dword ptr [ebp - local_10], eax          # 0051afb0
    je.d8 L_0051afe9                             # 0051afb3
    # block 0x0051afb5: entered by fall-through of je at 0x0051afb3, 15 instruction(s), calls FUN_0051acc0, USER32.dll!GetWindowLongA, indirect dword ptr [edi + 0x20], ends with jne to 0x0051b003 (forward)
    call FUN_0051acc0                            # 0051afb5
    push -0x4                                    # 0051afba
    push ebx                                     # 0051afbc
    mov dword ptr [ebp + arg_8], eax             # 0051afbd
    call dword ptr [0x52a454]                    # 0051afc0
    push dword ptr [ebp - local_10]              # 0051afc6
    {load} mov esi, eax                          # 0051afc9
    sub esi, dword ptr [ebp + arg_8]             # 0051afcb
    push ebx                                     # 0051afce
    neg esi                                      # 0051afcf
    {load} sbb esi, esi                          # 0051afd1
    inc esi                                      # 0051afd3
    call dword ptr [edi + field_20]              # 0051afd4
    test esi, esi                                # 0051afd7
    jne.d8 L_0051b003                            # 0051afd9
    # block 0x0051afdb: entered by fall-through of jne at 0x0051afd9, 5 instruction(s), calls USER32.dll!SetWindowLongA, ends with forward jump to 0x0051affe
    push dword ptr [ebp + arg_8]                 # 0051afdb
    push -0x4                                    # 0051afde
    push ebx                                     # 0051afe0
    call dword ptr [0x52a458]                    # 0051afe1
    jmp.d8 L_0051affe                            # 0051afe7
L_0051afe9:
    # block 0x0051afe9: entered by jne at 0x0051af86; jne at 0x0051af8c; je at 0x0051af96; je at 0x0051af9c; je at 0x0051afb3, 8 instruction(s), calls FUN_0051acc0, USER32.dll!SetWindowLongA, ends with je to 0x0051b003 (forward)
    call FUN_0051acc0                            # 0051afe9
    {load} mov esi, eax                          # 0051afee
    push esi                                     # 0051aff0
    push -0x4                                    # 0051aff1
    push ebx                                     # 0051aff3
    call dword ptr [0x52a458]                    # 0051aff4
    {load} cmp eax, esi                          # 0051affa
    je.d8 L_0051b003                             # 0051affc
L_0051affe:
    # block 0x0051affe: entered by jmp at 0x0051afe7; fall-through of je at 0x0051affc, 2 instruction(s), falls into the block at 0x0051b003
    mov ecx, dword ptr [ebp + arg_c]             # 0051affe
    mov dword ptr [ecx], eax                     # 0051b001
L_0051b003:
    # block 0x0051b003: entered by jne at 0x0051afd9; je at 0x0051affc, 3 instruction(s), ends with forward jump to 0x0051b06a
    mov esi, dword ptr [ebp - local_4]           # 0051b003
    and dword ptr [esi + field_14], 0x0          # 0051b006
    jmp.d8 L_0051b06a                            # 0051b00a
L_0051b00c:
    # block 0x0051b00c: entered by je at 0x0051af5d, 6 instruction(s), calls USER32.dll!GetWindowLongA, ends with je to 0x0051b067 (forward)
    push -0x4                                    # 0051b00c
    push ebx                                     # 0051b00e
    call dword ptr [0x52a454]                    # 0051b00f
    test eax, eax                                # 0051b015
    mov dword ptr [ebp + arg_8], eax             # 0051b017
    je.d8 L_0051b067                             # 0051b01a
    # block 0x0051b01c: entered by fall-through of je at 0x0051b01a, 7 instruction(s), calls indirect edi, ends with jne to 0x0051b067 (forward)
    mov edi, dword ptr [0x52a430]                # 0051b01c
    mov esi, 0x52e958                            # 0051b022
    push esi                                     # 0051b027
    push ebx                                     # 0051b028
    call edi                                     # 0051b029
    test eax, eax                                # 0051b02b
    jne.d8 L_0051b067                            # 0051b02d
    # block 0x0051b02f: entered by fall-through of jne at 0x0051b02d, 9 instruction(s), calls USER32.dll!SetPropA, indirect edi, ends with jne to 0x0051b067 (forward)
    push dword ptr [ebp + arg_8]                 # 0051b02f
    push esi                                     # 0051b032
    push ebx                                     # 0051b033
    call dword ptr [0x52a428]                    # 0051b034
    push esi                                     # 0051b03a
    push ebx                                     # 0051b03b
    call edi                                     # 0051b03c
    cmp eax, dword ptr [ebp + arg_8]             # 0051b03e
    jne.d8 L_0051b067                            # 0051b041
    # block 0x0051b043: entered by fall-through of jne at 0x0051b041, 6 instruction(s), calls KERNEL32.dll!GlobalAddAtomA, ends with jne to 0x0051b05d (forward)
    push esi                                     # 0051b043
    call dword ptr [0x52a234]                    # 0051b044
    mov eax, dword ptr [ebp - local_4]           # 0051b04a
    cmp dword ptr [eax + field_28], 0x0          # 0051b04d
    mov eax, 0x51ae25                            # 0051b051
    jne.d8 L_0051b05d                            # 0051b056
    # block 0x0051b058: entered by fall-through of jne at 0x0051b056, 1 instruction(s), falls into the block at 0x0051b05d
    mov eax, 0x51acc6                            # 0051b058
L_0051b05d:
    # block 0x0051b05d: entered by jne at 0x0051b056, 4 instruction(s), calls USER32.dll!SetWindowLongA, falls into the block at 0x0051b067
    push eax                                     # 0051b05d
    push -0x4                                    # 0051b05e
    push ebx                                     # 0051b060
    call dword ptr [0x52a458]                    # 0051b061
L_0051b067:
    # block 0x0051b067: entered by jne at 0x0051aef8; jne at 0x0051af00; jne at 0x0051af1d; je at 0x0051af55; more, 1 instruction(s), falls into the block at 0x0051b06a
    mov esi, dword ptr [ebp - local_4]           # 0051b067
L_0051b06a:
    # block 0x0051b06a: entered by jmp at 0x0051b00a, 8 instruction(s), calls USER32.dll!CallNextHookEx, ends with je to 0x0051b08e (forward)
    push dword ptr [ebp + arg_10]                # 0051b06a
    push ebx                                     # 0051b06d
    push 0x3                                     # 0051b06e
    push dword ptr [esi + field_2c]              # 0051b070
    call dword ptr [0x52a420]                    # 0051b073
    cmp dword ptr [ebp - local_8], 0x0           # 0051b079
    {load} mov edi, eax                          # 0051b07d
    je.d8 L_0051b08e                             # 0051b07f
    # block 0x0051b081: entered by fall-through of je at 0x0051b07f, 3 instruction(s), calls USER32.dll!UnhookWindowsHookEx, falls into the block at 0x0051b08e
    push dword ptr [esi + field_2c]              # 0051b081
    call dword ptr [0x52a42c]                    # 0051b084
    and dword ptr [esi + field_2c], 0x0          # 0051b08a
L_0051b08e:
    # block 0x0051b08e: entered by je at 0x0051b07f, 4 instruction(s), falls into the block at 0x0051b093
    {load} mov eax, edi                          # 0051b08e
    pop edi                                      # 0051b090
    pop esi                                      # 0051b091
    pop ebx                                      # 0051b092
L_0051b093:
    # block 0x0051b093: entered by jmp at 0x0051aed1, 2 instruction(s), ends with ret 0xc
    leave                                        # 0051b093
    ret 0xc                                      # 0051b094

