# FUN_004f79ce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f79ce
# extent:       0x004f79ce-0x004f7c36 (616 code bytes)
# span:         0x004f79ce-0x004f7c36 (code 616, tables 0, padding 0)
# sha256:       914f02db683401643fde801e75ac119e853edb53010ab646dc4301cd8afe205f
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f79ce
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30
# fields:       [eax + n] field_134, field_138, field_14e, field_162, field_172, field_3c2, field_3ce; [ecx + n] field_134, field_138, field_146, field_152, field_287; [edx + n] field_134, field_138, field_14a, field_14e, field_152, field_16e
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004fca60, FUN_004f61e7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 154 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ field_134, 0x134  # offset +0x134
.equ field_138, 0x138  # offset +0x138
.equ field_146, 0x146  # offset +0x146
.equ field_14a, 0x14a  # offset +0x14a
.equ field_14e, 0x14e  # offset +0x14e
.equ field_152, 0x152  # offset +0x152
.equ field_162, 0x162  # offset +0x162
.equ field_16e, 0x16e  # offset +0x16e
.equ field_172, 0x172  # offset +0x172
.equ field_287, 0x287  # offset +0x287
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f61e7, .text + (0x004f61e7 - 0x401000)
.set FUN_004fca60, .text + (0x004fca60 - 0x401000)

.org 0x004f79ce - 0x401000
.globl FUN_004f79ce
FUN_004f79ce:
    # block 0x004f79ce: entry, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004f79ff
    push ebp                                     # 004f79ce
    {load} mov ebp, esp                          # 004f79cf
    sub esp, 0x30                                # 004f79d1
    mov dword ptr [ebp - local_10], ecx          # 004f79d4
    call dword ptr [0x52a23c]                    # 004f79d7
    mov dword ptr [ebp - local_8], eax           # 004f79dd
    mov eax, dword ptr [ebp - local_10]          # 004f79e0
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f79e3
    mov dword ptr [ebp - local_4], 0x0           # 004f79ed
    jmp.d8 L_004f79ff                            # 004f79f4
L_004f79f6:
    # block 0x004f79f6: entered by jmp at 0x004f7a5c; jmp at 0x004f7c2d, 3 instruction(s), falls into the block at 0x004f79ff
    mov ecx, dword ptr [ebp - local_4]           # 004f79f6
    add ecx, 0x1                                 # 004f79f9
    mov dword ptr [ebp - local_4], ecx           # 004f79fc
L_004f79ff:
    # block 0x004f79ff: entered by jmp at 0x004f79f4, 2 instruction(s), ends with jge to 0x004f7c32 (forward)
    cmp dword ptr [ebp - local_4], 0x20          # 004f79ff
    jge.d32 L_004f7c32                           # 004f7a03
    # block 0x004f7a09: entered by fall-through of jge at 0x004f7a03, 9 instruction(s), ends with je to 0x004f7a5c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f7a09
    imul edx, edx, 0x5bb                         # 004f7a0c
    mov eax, dword ptr [ebp - local_10]          # 004f7a12
    mov ecx, dword ptr [eax + field_3ce]         # 004f7a15
    {load} add ecx, edx                          # 004f7a1b
    mov dword ptr [ebp - local_c], ecx           # 004f7a1d
    mov edx, dword ptr [ebp - local_c]           # 004f7a20
    cmp dword ptr [edx + field_152], 0x0         # 004f7a23
    je.d8 L_004f7a5c                             # 004f7a2a
    # block 0x004f7a2c: entered by fall-through of je at 0x004f7a2a, 3 instruction(s), ends with je to 0x004f7a5c (forward)
    mov eax, dword ptr [ebp - local_c]           # 004f7a2c
    cmp dword ptr [eax + field_162], 0x0         # 004f7a2f
    je.d8 L_004f7a5c                             # 004f7a36
    # block 0x004f7a38: entered by fall-through of je at 0x004f7a36, 3 instruction(s), ends with jne to 0x004f7a5c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f7a38
    cmp dword ptr [ecx + field_287], 0x0         # 004f7a3b
    jne.d8 L_004f7a5c                            # 004f7a42
    # block 0x004f7a44: entered by fall-through of jne at 0x004f7a42, 3 instruction(s), ends with jne to 0x004f7a5c (forward)
    mov edx, dword ptr [ebp - local_c]           # 004f7a44
    cmp dword ptr [edx + field_16e], 0x0         # 004f7a47
    jne.d8 L_004f7a5c                            # 004f7a4e
    # block 0x004f7a50: entered by fall-through of jne at 0x004f7a4e, 3 instruction(s), ends with je to 0x004f7a5e (forward)
    mov eax, dword ptr [ebp - local_c]           # 004f7a50
    cmp dword ptr [eax + field_172], 0x0         # 004f7a53
    je.d8 L_004f7a5e                             # 004f7a5a
L_004f7a5c:
    # block 0x004f7a5c: entered by je at 0x004f7a2a; je at 0x004f7a36; jne at 0x004f7a42; jne at 0x004f7a4e; more, 1 instruction(s), ends with backward jump to 0x004f79f6
    jmp.d8 L_004f79f6                            # 004f7a5c
L_004f7a5e:
    # block 0x004f7a5e: entered by je at 0x004f7a5a, 3 instruction(s), ends with je to 0x004f7c2d (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f7a5e
    cmp dword ptr [ecx + field_152], 0x0         # 004f7a61
    je.d32 L_004f7c2d                            # 004f7a68
    # block 0x004f7a6e: entered by fall-through of je at 0x004f7a68, 4 instruction(s), ends with jbe to 0x004f7c2d (forward)
    mov edx, dword ptr [ebp - local_c]           # 004f7a6e
    mov eax, dword ptr [ebp - local_8]           # 004f7a71
    cmp eax, dword ptr [edx + field_14e]         # 004f7a74
    jbe.d32 L_004f7c2d                           # 004f7a7a
    # block 0x004f7a80: entered by fall-through of jbe at 0x004f7a7a, 18 instruction(s), ends with jne to 0x004f7ada (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f7a80
    mov edx, dword ptr [ebp - local_c]           # 004f7a83
    fld dword ptr [ecx + field_134]              # 004f7a86
    fsub dword ptr [edx + field_14a]             # 004f7a8c
    mov eax, dword ptr [ebp - local_c]           # 004f7a92
    fstp dword ptr [eax + field_134]             # 004f7a95
    mov ecx, dword ptr [ebp - local_c]           # 004f7a9b
    mov edx, dword ptr [ebp - local_c]           # 004f7a9e
    fld dword ptr [ecx + field_138]              # 004f7aa1
    fsub dword ptr [edx + field_14a]             # 004f7aa7
    mov eax, dword ptr [ebp - local_c]           # 004f7aad
    fstp dword ptr [eax + field_138]             # 004f7ab0
    mov ecx, dword ptr [ebp - local_c]           # 004f7ab6
    fld dword ptr [ecx + field_134]              # 004f7ab9
    fcomp qword ptr [0x52c7b0]                   # 004f7abf
    fnstsw ax                                    # 004f7ac5
    test ah, 0x41                                # 004f7ac7
    jne.d8 L_004f7ada                            # 004f7aca
    # block 0x004f7acc: entered by fall-through of jne at 0x004f7aca, 4 instruction(s), ends with forward jump to 0x004f7ae8
    mov edx, dword ptr [ebp - local_c]           # 004f7acc
    fld dword ptr [edx + field_134]              # 004f7acf
    fstp qword ptr [ebp - local_18]              # 004f7ad5
    jmp.d8 L_004f7ae8                            # 004f7ad8
L_004f7ada:
    # block 0x004f7ada: entered by jne at 0x004f7aca, 2 instruction(s), falls into the block at 0x004f7ae8
    mov dword ptr [ebp - local_18], 0x0          # 004f7ada
    mov dword ptr [ebp - local_14], 0x0          # 004f7ae1
L_004f7ae8:
    # block 0x004f7ae8: entered by jmp at 0x004f7ad8, 9 instruction(s), ends with je to 0x004f7b18 (forward)
    fld qword ptr [ebp - local_18]               # 004f7ae8
    mov eax, dword ptr [ebp - local_c]           # 004f7aeb
    fstp dword ptr [eax + field_134]             # 004f7aee
    mov ecx, dword ptr [ebp - local_c]           # 004f7af4
    fld dword ptr [ecx + field_134]              # 004f7af7
    fcomp qword ptr [0x52c598]                   # 004f7afd
    fnstsw ax                                    # 004f7b03
    test ah, 0x1                                 # 004f7b05
    je.d8 L_004f7b18                             # 004f7b08
    # block 0x004f7b0a: entered by fall-through of je at 0x004f7b08, 4 instruction(s), ends with forward jump to 0x004f7b26
    mov edx, dword ptr [ebp - local_c]           # 004f7b0a
    fld dword ptr [edx + field_134]              # 004f7b0d
    fstp qword ptr [ebp - local_20]              # 004f7b13
    jmp.d8 L_004f7b26                            # 004f7b16
L_004f7b18:
    # block 0x004f7b18: entered by je at 0x004f7b08, 2 instruction(s), falls into the block at 0x004f7b26
    mov dword ptr [ebp - local_20], 0x0          # 004f7b18
    mov dword ptr [ebp - local_1c], 0x3ff00000   # 004f7b1f
L_004f7b26:
    # block 0x004f7b26: entered by jmp at 0x004f7b16, 9 instruction(s), ends with jne to 0x004f7b56 (forward)
    fld qword ptr [ebp - local_20]               # 004f7b26
    mov eax, dword ptr [ebp - local_c]           # 004f7b29
    fstp dword ptr [eax + field_134]             # 004f7b2c
    mov ecx, dword ptr [ebp - local_c]           # 004f7b32
    fld dword ptr [ecx + field_138]              # 004f7b35
    fcomp qword ptr [0x52c7b0]                   # 004f7b3b
    fnstsw ax                                    # 004f7b41
    test ah, 0x41                                # 004f7b43
    jne.d8 L_004f7b56                            # 004f7b46
    # block 0x004f7b48: entered by fall-through of jne at 0x004f7b46, 4 instruction(s), ends with forward jump to 0x004f7b64
    mov edx, dword ptr [ebp - local_c]           # 004f7b48
    fld dword ptr [edx + field_138]              # 004f7b4b
    fstp qword ptr [ebp - local_28]              # 004f7b51
    jmp.d8 L_004f7b64                            # 004f7b54
L_004f7b56:
    # block 0x004f7b56: entered by jne at 0x004f7b46, 2 instruction(s), falls into the block at 0x004f7b64
    mov dword ptr [ebp - local_28], 0x0          # 004f7b56
    mov dword ptr [ebp - local_24], 0x0          # 004f7b5d
L_004f7b64:
    # block 0x004f7b64: entered by jmp at 0x004f7b54, 9 instruction(s), ends with je to 0x004f7b94 (forward)
    fld qword ptr [ebp - local_28]               # 004f7b64
    mov eax, dword ptr [ebp - local_c]           # 004f7b67
    fstp dword ptr [eax + field_138]             # 004f7b6a
    mov ecx, dword ptr [ebp - local_c]           # 004f7b70
    fld dword ptr [ecx + field_138]              # 004f7b73
    fcomp qword ptr [0x52c598]                   # 004f7b79
    fnstsw ax                                    # 004f7b7f
    test ah, 0x1                                 # 004f7b81
    je.d8 L_004f7b94                             # 004f7b84
    # block 0x004f7b86: entered by fall-through of je at 0x004f7b84, 4 instruction(s), ends with forward jump to 0x004f7ba2
    mov edx, dword ptr [ebp - local_c]           # 004f7b86
    fld dword ptr [edx + field_138]              # 004f7b89
    fstp qword ptr [ebp - local_30]              # 004f7b8f
    jmp.d8 L_004f7ba2                            # 004f7b92
L_004f7b94:
    # block 0x004f7b94: entered by je at 0x004f7b84, 2 instruction(s), falls into the block at 0x004f7ba2
    mov dword ptr [ebp - local_30], 0x0          # 004f7b94
    mov dword ptr [ebp - local_2c], 0x3ff00000   # 004f7b9b
L_004f7ba2:
    # block 0x004f7ba2: entered by jmp at 0x004f7b92, 19 instruction(s), calls FUN_004fca60, ends with jne to 0x004f7bfd (forward)
    fld qword ptr [ebp - local_30]               # 004f7ba2
    mov eax, dword ptr [ebp - local_c]           # 004f7ba5
    fstp dword ptr [eax + field_138]             # 004f7ba8
    mov ecx, dword ptr [ebp - local_c]           # 004f7bae
    mov edx, dword ptr [ecx + field_138]         # 004f7bb1
    push edx                                     # 004f7bb7
    mov eax, dword ptr [ebp - local_c]           # 004f7bb8
    mov ecx, dword ptr [eax + field_134]         # 004f7bbb
    push ecx                                     # 004f7bc1
    mov dx, word ptr [ebp - local_4]             # 004f7bc2
    push edx                                     # 004f7bc6
    mov ecx, 0x5c3a67                            # 004f7bc7
    call FUN_004fca60                            # 004f7bcc
    mov eax, dword ptr [ebp - local_c]           # 004f7bd1
    fld dword ptr [eax + field_134]              # 004f7bd4
    fcomp qword ptr [0x52c7b0]                   # 004f7bda
    fnstsw ax                                    # 004f7be0
    test ah, 0x41                                # 004f7be2
    jne.d8 L_004f7bfd                            # 004f7be5
    # block 0x004f7be7: entered by fall-through of jne at 0x004f7be5, 6 instruction(s), ends with je to 0x004f7c18 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f7be7
    fld dword ptr [ecx + field_138]              # 004f7bea
    fcomp qword ptr [0x52c7b0]                   # 004f7bf0
    fnstsw ax                                    # 004f7bf6
    test ah, 0x41                                # 004f7bf8
    je.d8 L_004f7c18                             # 004f7bfb
L_004f7bfd:
    # block 0x004f7bfd: entered by jne at 0x004f7be5; fall-through of je at 0x004f7bfb, 7 instruction(s), calls FUN_004f61e7, ends with forward jump to 0x004f7c2d
    mov edx, dword ptr [ebp - local_c]           # 004f7bfd
    mov dword ptr [edx + field_152], 0x0         # 004f7c00
    mov eax, dword ptr [ebp - local_4]           # 004f7c0a
    push eax                                     # 004f7c0d
    mov ecx, dword ptr [ebp - local_10]          # 004f7c0e
    call FUN_004f61e7                            # 004f7c11
    jmp.d8 L_004f7c2d                            # 004f7c16
L_004f7c18:
    # block 0x004f7c18: entered by je at 0x004f7bfb, 5 instruction(s), falls into the block at 0x004f7c2d
    mov ecx, dword ptr [ebp - local_c]           # 004f7c18
    mov edx, dword ptr [ebp - local_8]           # 004f7c1b
    add edx, dword ptr [ecx + field_146]         # 004f7c1e
    mov eax, dword ptr [ebp - local_c]           # 004f7c24
    mov dword ptr [eax + field_14e], edx         # 004f7c27
L_004f7c2d:
    # block 0x004f7c2d: entered by je at 0x004f7a68; jbe at 0x004f7a7a; jmp at 0x004f7c16, 1 instruction(s), ends with backward jump to 0x004f79f6
    jmp.d32 L_004f79f6                           # 004f7c2d
L_004f7c32:
    # block 0x004f7c32: entered by jge at 0x004f7a03, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004f7c32
    pop ebp                                      # 004f7c34
    ret                                          # 004f7c35

