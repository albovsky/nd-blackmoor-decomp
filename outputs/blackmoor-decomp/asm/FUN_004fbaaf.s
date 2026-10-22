# FUN_004fbaaf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fbaaf
# extent:       0x004fbaaf-0x004fbd7e (719 code bytes)
# span:         0x004fbaaf-0x004fbd7e (code 719, tables 0, padding 0)
# sha256:       99ae120824ccd396ec8afdb1804fc8a60fae3a075190bc729cf8c7bfaadc5eb7
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fbaaf
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 6 more
# fields:       [eax + n] field_138, field_13c; [ecx + n] field_130, field_138; [edx + n] field_132, field_134, field_13c, field_16a
# callees:      calls FUN_004fc62d, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 165 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ field_130, 0x130  # offset +0x130
.equ field_132, 0x132  # offset +0x132
.equ field_134, 0x134  # offset +0x134
.equ field_138, 0x138  # offset +0x138
.equ field_13c, 0x13c  # offset +0x13c
.equ field_16a, 0x16a  # offset +0x16a

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)

.org 0x004fbaaf - 0x401000
.globl FUN_004fbaaf
FUN_004fbaaf:
    # block 0x004fbaaf: entry, 61 instruction(s), ends with je to 0x004fbbde (forward)
    push ebp                                     # 004fbaaf
    {load} mov ebp, esp                          # 004fbab0
    sub esp, 0x48                                # 004fbab2
    mov dword ptr [ebp - local_8], ecx           # 004fbab5
    mov ax, word ptr [0x5b00d9]                  # 004fbab8
    mov word ptr [ebp - local_4], ax             # 004fbabe
    mov ecx, dword ptr [ebp - local_4]           # 004fbac2
    and ecx, 0xffff                              # 004fbac5
    imul ecx, ecx, 0x5bb                         # 004fbacb
    mov edx, dword ptr [ebp - local_8]           # 004fbad1
    mov eax, dword ptr [0x5b00df]                # 004fbad4
    mov dword ptr [edx + ecx + field_134], eax   # 004fbad9
    movsx ecx, word ptr [0x5b00e3]               # 004fbae0
    mov dword ptr [ebp - local_c], ecx           # 004fbae7
    fild dword ptr [ebp - local_c]               # 004fbaea
    fstp dword ptr [ebp - local_10]              # 004fbaed
    fld dword ptr [ebp - local_10]               # 004fbaf0
    fdiv dword ptr [0x52cbec]                    # 004fbaf3
    mov edx, dword ptr [ebp - local_4]           # 004fbaf9
    and edx, 0xffff                              # 004fbafc
    imul edx, edx, 0x5bb                         # 004fbb02
    mov eax, dword ptr [ebp - local_8]           # 004fbb08
    fstp dword ptr [eax + edx + field_138]       # 004fbb0b
    movsx ecx, word ptr [0x5b00e5]               # 004fbb12
    mov dword ptr [ebp - local_14], ecx          # 004fbb19
    fild dword ptr [ebp - local_14]              # 004fbb1c
    fstp dword ptr [ebp - local_18]              # 004fbb1f
    fld dword ptr [ebp - local_18]               # 004fbb22
    fdiv dword ptr [0x52cbec]                    # 004fbb25
    mov edx, dword ptr [ebp - local_4]           # 004fbb2b
    and edx, 0xffff                              # 004fbb2e
    imul edx, edx, 0x5bb                         # 004fbb34
    mov eax, dword ptr [ebp - local_8]           # 004fbb3a
    fstp dword ptr [eax + edx + field_13c]       # 004fbb3d
    mov ecx, dword ptr [ebp - local_4]           # 004fbb44
    and ecx, 0xffff                              # 004fbb47
    imul ecx, ecx, 0x5bb                         # 004fbb4d
    mov edx, dword ptr [ebp - local_8]           # 004fbb53
    mov word ptr [edx + ecx + field_132], 0x0    # 004fbb56
    mov eax, dword ptr [ebp - local_4]           # 004fbb60
    and eax, 0xffff                              # 004fbb63
    imul eax, eax, 0x5bb                         # 004fbb68
    mov ecx, dword ptr [ebp - local_8]           # 004fbb6e
    mov word ptr [ecx + eax + field_130], 0x1    # 004fbb71
    movsx edx, word ptr [0x5b00dd]               # 004fbb7b
    {load} xor eax, eax                          # 004fbb82
    cmp edx, 0x2                                 # 004fbb84
    sete al                                      # 004fbb87
    mov ecx, dword ptr [ebp - local_4]           # 004fbb8a
    and ecx, 0xffff                              # 004fbb8d
    imul ecx, ecx, 0x5bb                         # 004fbb93
    mov edx, dword ptr [ebp - local_8]           # 004fbb99
    mov dword ptr [edx + ecx + field_16a], eax   # 004fbb9c
    mov eax, dword ptr [ebp - local_4]           # 004fbba3
    and eax, 0xffff                              # 004fbba6
    imul eax, eax, 0x5bb                         # 004fbbab
    fld dword ptr [eax + 0x5c3b9f]               # 004fbbb1
    fcomp qword ptr [0x52c598]                   # 004fbbb7
    fnstsw ax                                    # 004fbbbd
    test ah, 0x1                                 # 004fbbbf
    je.d8 L_004fbbde                             # 004fbbc2
    # block 0x004fbbc4: entered by fall-through of je at 0x004fbbc2, 6 instruction(s), ends with forward jump to 0x004fbbec
    mov ecx, dword ptr [ebp - local_4]           # 004fbbc4
    and ecx, 0xffff                              # 004fbbc7
    imul ecx, ecx, 0x5bb                         # 004fbbcd
    fld dword ptr [ecx + 0x5c3b9f]               # 004fbbd3
    fstp qword ptr [ebp - local_20]              # 004fbbd9
    jmp.d8 L_004fbbec                            # 004fbbdc
L_004fbbde:
    # block 0x004fbbde: entered by je at 0x004fbbc2, 2 instruction(s), falls into the block at 0x004fbbec
    mov dword ptr [ebp - local_20], 0x0          # 004fbbde
    mov dword ptr [ebp - local_1c], 0x3ff00000   # 004fbbe5
L_004fbbec:
    # block 0x004fbbec: entered by jmp at 0x004fbbdc, 16 instruction(s), ends with jne to 0x004fbc4a (forward)
    fld qword ptr [ebp - local_20]               # 004fbbec
    fstp dword ptr [ebp - local_24]              # 004fbbef
    fld dword ptr [ebp - local_24]               # 004fbbf2
    mov edx, dword ptr [ebp - local_4]           # 004fbbf5
    and edx, 0xffff                              # 004fbbf8
    imul edx, edx, 0x5bb                         # 004fbbfe
    mov eax, dword ptr [ebp - local_8]           # 004fbc04
    fstp dword ptr [eax + edx + field_138]       # 004fbc07
    mov ecx, dword ptr [ebp - local_4]           # 004fbc0e
    and ecx, 0xffff                              # 004fbc11
    imul ecx, ecx, 0x5bb                         # 004fbc17
    fld dword ptr [ecx + 0x5c3b9f]               # 004fbc1d
    fcomp qword ptr [0x52c7b0]                   # 004fbc23
    fnstsw ax                                    # 004fbc29
    test ah, 0x41                                # 004fbc2b
    jne.d8 L_004fbc4a                            # 004fbc2e
    # block 0x004fbc30: entered by fall-through of jne at 0x004fbc2e, 6 instruction(s), ends with forward jump to 0x004fbc58
    mov edx, dword ptr [ebp - local_4]           # 004fbc30
    and edx, 0xffff                              # 004fbc33
    imul edx, edx, 0x5bb                         # 004fbc39
    fld dword ptr [edx + 0x5c3b9f]               # 004fbc3f
    fstp qword ptr [ebp - local_2c]              # 004fbc45
    jmp.d8 L_004fbc58                            # 004fbc48
L_004fbc4a:
    # block 0x004fbc4a: entered by jne at 0x004fbc2e, 2 instruction(s), falls into the block at 0x004fbc58
    mov dword ptr [ebp - local_2c], 0x0          # 004fbc4a
    mov dword ptr [ebp - local_28], 0x0          # 004fbc51
L_004fbc58:
    # block 0x004fbc58: entered by jmp at 0x004fbc48, 16 instruction(s), ends with je to 0x004fbcb4 (forward)
    fld qword ptr [ebp - local_2c]               # 004fbc58
    fstp dword ptr [ebp - local_30]              # 004fbc5b
    fld dword ptr [ebp - local_30]               # 004fbc5e
    mov eax, dword ptr [ebp - local_4]           # 004fbc61
    and eax, 0xffff                              # 004fbc64
    imul eax, eax, 0x5bb                         # 004fbc69
    mov ecx, dword ptr [ebp - local_8]           # 004fbc6f
    fstp dword ptr [ecx + eax + field_138]       # 004fbc72
    mov edx, dword ptr [ebp - local_4]           # 004fbc79
    and edx, 0xffff                              # 004fbc7c
    imul edx, edx, 0x5bb                         # 004fbc82
    fld dword ptr [edx + 0x5c3ba3]               # 004fbc88
    fcomp qword ptr [0x52c598]                   # 004fbc8e
    fnstsw ax                                    # 004fbc94
    test ah, 0x1                                 # 004fbc96
    je.d8 L_004fbcb4                             # 004fbc99
    # block 0x004fbc9b: entered by fall-through of je at 0x004fbc99, 6 instruction(s), ends with forward jump to 0x004fbcc2
    mov eax, dword ptr [ebp - local_4]           # 004fbc9b
    and eax, 0xffff                              # 004fbc9e
    imul eax, eax, 0x5bb                         # 004fbca3
    fld dword ptr [eax + 0x5c3ba3]               # 004fbca9
    fstp qword ptr [ebp - local_38]              # 004fbcaf
    jmp.d8 L_004fbcc2                            # 004fbcb2
L_004fbcb4:
    # block 0x004fbcb4: entered by je at 0x004fbc99, 2 instruction(s), falls into the block at 0x004fbcc2
    mov dword ptr [ebp - local_38], 0x0          # 004fbcb4
    mov dword ptr [ebp - local_34], 0x3ff00000   # 004fbcbb
L_004fbcc2:
    # block 0x004fbcc2: entered by jmp at 0x004fbcb2, 16 instruction(s), ends with jne to 0x004fbd1f (forward)
    fld qword ptr [ebp - local_38]               # 004fbcc2
    fstp dword ptr [ebp - local_3c]              # 004fbcc5
    fld dword ptr [ebp - local_3c]               # 004fbcc8
    mov ecx, dword ptr [ebp - local_4]           # 004fbccb
    and ecx, 0xffff                              # 004fbcce
    imul ecx, ecx, 0x5bb                         # 004fbcd4
    mov edx, dword ptr [ebp - local_8]           # 004fbcda
    fstp dword ptr [edx + ecx + field_13c]       # 004fbcdd
    mov eax, dword ptr [ebp - local_4]           # 004fbce4
    and eax, 0xffff                              # 004fbce7
    imul eax, eax, 0x5bb                         # 004fbcec
    fld dword ptr [eax + 0x5c3ba3]               # 004fbcf2
    fcomp qword ptr [0x52c7b0]                   # 004fbcf8
    fnstsw ax                                    # 004fbcfe
    test ah, 0x41                                # 004fbd00
    jne.d8 L_004fbd1f                            # 004fbd03
    # block 0x004fbd05: entered by fall-through of jne at 0x004fbd03, 6 instruction(s), ends with forward jump to 0x004fbd2d
    mov ecx, dword ptr [ebp - local_4]           # 004fbd05
    and ecx, 0xffff                              # 004fbd08
    imul ecx, ecx, 0x5bb                         # 004fbd0e
    fld dword ptr [ecx + 0x5c3ba3]               # 004fbd14
    fstp qword ptr [ebp - local_44]              # 004fbd1a
    jmp.d8 L_004fbd2d                            # 004fbd1d
L_004fbd1f:
    # block 0x004fbd1f: entered by jne at 0x004fbd03, 2 instruction(s), falls into the block at 0x004fbd2d
    mov dword ptr [ebp - local_44], 0x0          # 004fbd1f
    mov dword ptr [ebp - local_40], 0x0          # 004fbd26
L_004fbd2d:
    # block 0x004fbd2d: entered by jmp at 0x004fbd1d, 24 instruction(s), calls FUN_004fc62d, FUN_004fb2e3, ends with ret
    fld qword ptr [ebp - local_44]               # 004fbd2d
    fstp dword ptr [ebp - local_48]              # 004fbd30
    fld dword ptr [ebp - local_48]               # 004fbd33
    mov edx, dword ptr [ebp - local_4]           # 004fbd36
    and edx, 0xffff                              # 004fbd39
    imul edx, edx, 0x5bb                         # 004fbd3f
    mov eax, dword ptr [ebp - local_8]           # 004fbd45
    fstp dword ptr [eax + edx + field_13c]       # 004fbd48
    push 0x1                                     # 004fbd4f
    push 0x0                                     # 004fbd51
    movsx ecx, word ptr [0x5b00db]               # 004fbd53
    push ecx                                     # 004fbd5a
    push 0x5b00b8                                # 004fbd5b
    mov dx, word ptr [ebp - local_4]             # 004fbd60
    push edx                                     # 004fbd64
    mov ecx, dword ptr [ebp - local_8]           # 004fbd65
    call FUN_004fc62d                            # 004fbd68
    mov ax, word ptr [ebp - local_4]             # 004fbd6d
    push eax                                     # 004fbd71
    mov ecx, dword ptr [ebp - local_8]           # 004fbd72
    call FUN_004fb2e3                            # 004fbd75
    {load} mov esp, ebp                          # 004fbd7a
    pop ebp                                      # 004fbd7c
    ret                                          # 004fbd7d

