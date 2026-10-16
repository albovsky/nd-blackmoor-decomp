# FUN_004fbd98
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fbd98
# extent:       0x004fbd98-0x004fc05d (709 code bytes)
# span:         0x004fbd98-0x004fc05d (code 709, tables 0, padding 0)
# sha256:       a86c965d39d040a251a5183de7646ae2c737a19e60c64150a47722305896b0ab
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fbd98
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 6 more
# fields:       [eax + n] field_138, field_13c; [ecx + n] field_130, field_138; [edx + n] field_132, field_134, field_13c, field_16a
# callees:      calls FUN_004fc62d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 161 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)

.org 0x004fbd98 - 0x401000
.globl FUN_004fbd98
FUN_004fbd98:
    # block 0x004fbd98: entry, 61 instruction(s), ends with je to 0x004fbec7 (forward)
    push ebp                                     # 004fbd98
    {load} mov ebp, esp                          # 004fbd99
    sub esp, 0x48                                # 004fbd9b
    mov dword ptr [ebp - local_8], ecx           # 004fbd9e
    mov ax, word ptr [0x5b451f]                  # 004fbda1
    mov word ptr [ebp - local_4], ax             # 004fbda7
    mov ecx, dword ptr [ebp - local_4]           # 004fbdab
    and ecx, 0xffff                              # 004fbdae
    imul ecx, ecx, 0x5bb                         # 004fbdb4
    mov edx, dword ptr [ebp - local_8]           # 004fbdba
    mov eax, dword ptr [0x5b4525]                # 004fbdbd
    mov dword ptr [edx + ecx + field_134], eax   # 004fbdc2
    movsx ecx, word ptr [0x5b4529]               # 004fbdc9
    mov dword ptr [ebp - local_c], ecx           # 004fbdd0
    fild dword ptr [ebp - local_c]               # 004fbdd3
    fstp dword ptr [ebp - local_10]              # 004fbdd6
    fld dword ptr [ebp - local_10]               # 004fbdd9
    fdiv dword ptr [0x52cbec]                    # 004fbddc
    mov edx, dword ptr [ebp - local_4]           # 004fbde2
    and edx, 0xffff                              # 004fbde5
    imul edx, edx, 0x5bb                         # 004fbdeb
    mov eax, dword ptr [ebp - local_8]           # 004fbdf1
    fstp dword ptr [eax + edx + field_138]       # 004fbdf4
    movsx ecx, word ptr [0x5b452b]               # 004fbdfb
    mov dword ptr [ebp - local_14], ecx          # 004fbe02
    fild dword ptr [ebp - local_14]              # 004fbe05
    fstp dword ptr [ebp - local_18]              # 004fbe08
    fld dword ptr [ebp - local_18]               # 004fbe0b
    fdiv dword ptr [0x52cbec]                    # 004fbe0e
    mov edx, dword ptr [ebp - local_4]           # 004fbe14
    and edx, 0xffff                              # 004fbe17
    imul edx, edx, 0x5bb                         # 004fbe1d
    mov eax, dword ptr [ebp - local_8]           # 004fbe23
    fstp dword ptr [eax + edx + field_13c]       # 004fbe26
    mov ecx, dword ptr [ebp - local_4]           # 004fbe2d
    and ecx, 0xffff                              # 004fbe30
    imul ecx, ecx, 0x5bb                         # 004fbe36
    mov edx, dword ptr [ebp - local_8]           # 004fbe3c
    mov word ptr [edx + ecx + field_132], 0x0    # 004fbe3f
    mov eax, dword ptr [ebp - local_4]           # 004fbe49
    and eax, 0xffff                              # 004fbe4c
    imul eax, eax, 0x5bb                         # 004fbe51
    mov ecx, dword ptr [ebp - local_8]           # 004fbe57
    mov word ptr [ecx + eax + field_130], 0x1    # 004fbe5a
    movsx edx, word ptr [0x5b4523]               # 004fbe64
    {load} xor eax, eax                          # 004fbe6b
    cmp edx, 0x2                                 # 004fbe6d
    sete al                                      # 004fbe70
    mov ecx, dword ptr [ebp - local_4]           # 004fbe73
    and ecx, 0xffff                              # 004fbe76
    imul ecx, ecx, 0x5bb                         # 004fbe7c
    mov edx, dword ptr [ebp - local_8]           # 004fbe82
    mov dword ptr [edx + ecx + field_16a], eax   # 004fbe85
    mov eax, dword ptr [ebp - local_4]           # 004fbe8c
    and eax, 0xffff                              # 004fbe8f
    imul eax, eax, 0x5bb                         # 004fbe94
    fld dword ptr [eax + 0x5c3b9f]               # 004fbe9a
    fcomp qword ptr [0x52c598]                   # 004fbea0
    fnstsw ax                                    # 004fbea6
    test ah, 0x1                                 # 004fbea8
    je.d8 L_004fbec7                             # 004fbeab
    # block 0x004fbead: entered by fall-through of je at 0x004fbeab, 6 instruction(s), ends with forward jump to 0x004fbed5
    mov ecx, dword ptr [ebp - local_4]           # 004fbead
    and ecx, 0xffff                              # 004fbeb0
    imul ecx, ecx, 0x5bb                         # 004fbeb6
    fld dword ptr [ecx + 0x5c3b9f]               # 004fbebc
    fstp qword ptr [ebp - local_20]              # 004fbec2
    jmp.d8 L_004fbed5                            # 004fbec5
L_004fbec7:
    # block 0x004fbec7: entered by je at 0x004fbeab, 2 instruction(s), falls into the block at 0x004fbed5
    mov dword ptr [ebp - local_20], 0x0          # 004fbec7
    mov dword ptr [ebp - local_1c], 0x3ff00000   # 004fbece
L_004fbed5:
    # block 0x004fbed5: entered by jmp at 0x004fbec5, 16 instruction(s), ends with jne to 0x004fbf33 (forward)
    fld qword ptr [ebp - local_20]               # 004fbed5
    fstp dword ptr [ebp - local_24]              # 004fbed8
    fld dword ptr [ebp - local_24]               # 004fbedb
    mov edx, dword ptr [ebp - local_4]           # 004fbede
    and edx, 0xffff                              # 004fbee1
    imul edx, edx, 0x5bb                         # 004fbee7
    mov eax, dword ptr [ebp - local_8]           # 004fbeed
    fstp dword ptr [eax + edx + field_138]       # 004fbef0
    mov ecx, dword ptr [ebp - local_4]           # 004fbef7
    and ecx, 0xffff                              # 004fbefa
    imul ecx, ecx, 0x5bb                         # 004fbf00
    fld dword ptr [ecx + 0x5c3b9f]               # 004fbf06
    fcomp qword ptr [0x52c7b0]                   # 004fbf0c
    fnstsw ax                                    # 004fbf12
    test ah, 0x41                                # 004fbf14
    jne.d8 L_004fbf33                            # 004fbf17
    # block 0x004fbf19: entered by fall-through of jne at 0x004fbf17, 6 instruction(s), ends with forward jump to 0x004fbf41
    mov edx, dword ptr [ebp - local_4]           # 004fbf19
    and edx, 0xffff                              # 004fbf1c
    imul edx, edx, 0x5bb                         # 004fbf22
    fld dword ptr [edx + 0x5c3b9f]               # 004fbf28
    fstp qword ptr [ebp - local_2c]              # 004fbf2e
    jmp.d8 L_004fbf41                            # 004fbf31
L_004fbf33:
    # block 0x004fbf33: entered by jne at 0x004fbf17, 2 instruction(s), falls into the block at 0x004fbf41
    mov dword ptr [ebp - local_2c], 0x0          # 004fbf33
    mov dword ptr [ebp - local_28], 0x0          # 004fbf3a
L_004fbf41:
    # block 0x004fbf41: entered by jmp at 0x004fbf31, 16 instruction(s), ends with je to 0x004fbf9d (forward)
    fld qword ptr [ebp - local_2c]               # 004fbf41
    fstp dword ptr [ebp - local_30]              # 004fbf44
    fld dword ptr [ebp - local_30]               # 004fbf47
    mov eax, dword ptr [ebp - local_4]           # 004fbf4a
    and eax, 0xffff                              # 004fbf4d
    imul eax, eax, 0x5bb                         # 004fbf52
    mov ecx, dword ptr [ebp - local_8]           # 004fbf58
    fstp dword ptr [ecx + eax + field_138]       # 004fbf5b
    mov edx, dword ptr [ebp - local_4]           # 004fbf62
    and edx, 0xffff                              # 004fbf65
    imul edx, edx, 0x5bb                         # 004fbf6b
    fld dword ptr [edx + 0x5c3ba3]               # 004fbf71
    fcomp qword ptr [0x52c598]                   # 004fbf77
    fnstsw ax                                    # 004fbf7d
    test ah, 0x1                                 # 004fbf7f
    je.d8 L_004fbf9d                             # 004fbf82
    # block 0x004fbf84: entered by fall-through of je at 0x004fbf82, 6 instruction(s), ends with forward jump to 0x004fbfab
    mov eax, dword ptr [ebp - local_4]           # 004fbf84
    and eax, 0xffff                              # 004fbf87
    imul eax, eax, 0x5bb                         # 004fbf8c
    fld dword ptr [eax + 0x5c3ba3]               # 004fbf92
    fstp qword ptr [ebp - local_38]              # 004fbf98
    jmp.d8 L_004fbfab                            # 004fbf9b
L_004fbf9d:
    # block 0x004fbf9d: entered by je at 0x004fbf82, 2 instruction(s), falls into the block at 0x004fbfab
    mov dword ptr [ebp - local_38], 0x0          # 004fbf9d
    mov dword ptr [ebp - local_34], 0x3ff00000   # 004fbfa4
L_004fbfab:
    # block 0x004fbfab: entered by jmp at 0x004fbf9b, 16 instruction(s), ends with jne to 0x004fc008 (forward)
    fld qword ptr [ebp - local_38]               # 004fbfab
    fstp dword ptr [ebp - local_3c]              # 004fbfae
    fld dword ptr [ebp - local_3c]               # 004fbfb1
    mov ecx, dword ptr [ebp - local_4]           # 004fbfb4
    and ecx, 0xffff                              # 004fbfb7
    imul ecx, ecx, 0x5bb                         # 004fbfbd
    mov edx, dword ptr [ebp - local_8]           # 004fbfc3
    fstp dword ptr [edx + ecx + field_13c]       # 004fbfc6
    mov eax, dword ptr [ebp - local_4]           # 004fbfcd
    and eax, 0xffff                              # 004fbfd0
    imul eax, eax, 0x5bb                         # 004fbfd5
    fld dword ptr [eax + 0x5c3ba3]               # 004fbfdb
    fcomp qword ptr [0x52c7b0]                   # 004fbfe1
    fnstsw ax                                    # 004fbfe7
    test ah, 0x41                                # 004fbfe9
    jne.d8 L_004fc008                            # 004fbfec
    # block 0x004fbfee: entered by fall-through of jne at 0x004fbfec, 6 instruction(s), ends with forward jump to 0x004fc016
    mov ecx, dword ptr [ebp - local_4]           # 004fbfee
    and ecx, 0xffff                              # 004fbff1
    imul ecx, ecx, 0x5bb                         # 004fbff7
    fld dword ptr [ecx + 0x5c3ba3]               # 004fbffd
    fstp qword ptr [ebp - local_44]              # 004fc003
    jmp.d8 L_004fc016                            # 004fc006
L_004fc008:
    # block 0x004fc008: entered by jne at 0x004fbfec, 2 instruction(s), falls into the block at 0x004fc016
    mov dword ptr [ebp - local_44], 0x0          # 004fc008
    mov dword ptr [ebp - local_40], 0x0          # 004fc00f
L_004fc016:
    # block 0x004fc016: entered by jmp at 0x004fc006, 20 instruction(s), calls FUN_004fc62d, ends with ret
    fld qword ptr [ebp - local_44]               # 004fc016
    fstp dword ptr [ebp - local_48]              # 004fc019
    fld dword ptr [ebp - local_48]               # 004fc01c
    mov edx, dword ptr [ebp - local_4]           # 004fc01f
    and edx, 0xffff                              # 004fc022
    imul edx, edx, 0x5bb                         # 004fc028
    mov eax, dword ptr [ebp - local_8]           # 004fc02e
    fstp dword ptr [eax + edx + field_13c]       # 004fc031
    push 0x0                                     # 004fc038
    push 0x5b452d                                # 004fc03a
    movsx ecx, word ptr [0x5b4521]               # 004fc03f
    push ecx                                     # 004fc046
    push 0x5b44fe                                # 004fc047
    mov dx, word ptr [ebp - local_4]             # 004fc04c
    push edx                                     # 004fc050
    mov ecx, dword ptr [ebp - local_8]           # 004fc051
    call FUN_004fc62d                            # 004fc054
    {load} mov esp, ebp                          # 004fc059
    pop ebp                                      # 004fc05b
    ret                                          # 004fc05c

