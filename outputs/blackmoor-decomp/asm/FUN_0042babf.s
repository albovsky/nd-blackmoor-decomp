# FUN_0042babf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042babf
# extent:       0x0042babf-0x0042c221 (1890 code bytes)
# span:         0x0042babf-0x0042c221 (code 1890, tables 0, padding 0)
# sha256:       4b99c5c9d0234cf1c397c6b537acc7248f730cc0c54105598086e0f3ec95c11b
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042babf
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       23 ebp-relative slot(s): local_104, local_108, local_10c, local_110, local_114, local_118, local_11c, local_120, local_124, local_128, local_12c, local_130 and 11 more
# fields:       [eax + n] field_2f, field_56; [ecx + n] field_21, field_23, field_25, field_29, field_31, field_33, field_35, field_37, field_39, field_3d, field_41, field_45 and 4 more; [edx + n] field_2d, field_4c, field_4e, field_5a
# callees:      calls FUN_004fc62d, FUN_004faf98, FUN_0052139c, FUN_004c97b4, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 358 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_104, 0x104  # offset -0x104
.equ local_108, 0x108  # offset -0x108
.equ local_10c, 0x10c  # offset -0x10c
.equ local_110, 0x110  # offset -0x110
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ local_12c, 0x12c  # offset -0x12c
.equ local_130, 0x130  # offset -0x130
.equ local_134, 0x134  # offset -0x134
.equ local_138, 0x138  # offset -0x138
.equ local_13c, 0x13c  # offset -0x13c
.equ local_140, 0x140  # offset -0x140
.equ local_144, 0x144  # offset -0x144
.equ local_148, 0x148  # offset -0x148
.equ local_14c, 0x14c  # offset -0x14c
.equ local_150, 0x150  # offset -0x150
.equ local_154, 0x154  # offset -0x154
.equ local_158, 0x158  # offset -0x158
.equ local_15c, 0x15c  # offset -0x15c
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_37, 0x37  # offset +0x37
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45
.equ field_47, 0x47  # offset +0x47
.equ field_48, 0x48  # offset +0x48
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4c, 0x4c  # offset +0x4c
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_5a, 0x5a  # offset +0x5a

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004faf98, .text + (0x004faf98 - 0x401000)
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0042babf - 0x401000
.globl FUN_0042babf
FUN_0042babf:
    # block 0x0042babf: entry, 9 instruction(s), ends with je to 0x0042bb02 (forward)
    push ebp                                     # 0042babf
    {load} mov ebp, esp                          # 0042bac0
    sub esp, 0x15c                               # 0042bac2
    movsx eax, word ptr [ebp + arg_8]            # 0042bac8
    imul eax, eax, 0x8d                          # 0042bacc
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042bad2
    mov dword ptr [ebp - local_110], ecx         # 0042bad8
    cmp dword ptr [ebp - local_110], 0x0         # 0042bade
    je.d8 L_0042bb02                             # 0042bae5
    # block 0x0042bae7: entered by fall-through of je at 0x0042bae5, 2 instruction(s), ends with je to 0x0042bb20 (forward)
    cmp dword ptr [ebp - local_110], 0x1         # 0042bae7
    je.d8 L_0042bb20                             # 0042baee
    # block 0x0042baf0: entered by fall-through of je at 0x0042baee, 2 instruction(s), ends with je to 0x0042bc82 (forward)
    cmp dword ptr [ebp - local_110], 0x2         # 0042baf0
    je.d32 L_0042bc82                            # 0042baf7
    # block 0x0042bafd: entered by fall-through of je at 0x0042baf7, 1 instruction(s), ends with forward jump to 0x0042c21d
    jmp.d32 L_0042c21d                           # 0042bafd
L_0042bb02:
    # block 0x0042bb02: entered by je at 0x0042bae5, 4 instruction(s), falls into the block at 0x0042bb20
    mov dword ptr [0x5bb1ca], 0x1                # 0042bb02
    movsx edx, word ptr [ebp + arg_8]            # 0042bb0c
    imul edx, edx, 0x8d                          # 0042bb10
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042bb16
L_0042bb20:
    # block 0x0042bb20: entered by je at 0x0042baee, 5 instruction(s), ends with forward jump to 0x0042bb51
    movsx eax, word ptr [ebp + arg_8]            # 0042bb20
    imul eax, eax, 0x8d                          # 0042bb24
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042bb2a
    mov word ptr [ebp - local_10c], 0x0          # 0042bb34
    jmp.d8 L_0042bb51                            # 0042bb3d
L_0042bb3f:
    # block 0x0042bb3f: entered by jmp at 0x0042bc78, 3 instruction(s), falls into the block at 0x0042bb51
    mov cx, word ptr [ebp - local_10c]           # 0042bb3f
    add cx, 0x1                                  # 0042bb46
    mov word ptr [ebp - local_10c], cx           # 0042bb4a
L_0042bb51:
    # block 0x0042bb51: entered by jmp at 0x0042bb3d, 7 instruction(s), ends with jge to 0x0042bc7d (forward)
    movsx edx, word ptr [ebp - local_10c]        # 0042bb51
    movsx eax, word ptr [ebp + arg_8]            # 0042bb58
    imul eax, eax, 0x8d                          # 0042bb5c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042bb62
    movsx eax, word ptr [ecx + field_4a]         # 0042bb68
    {load} cmp edx, eax                          # 0042bb6c
    jge.d32 L_0042bc7d                           # 0042bb6e
    # block 0x0042bb74: entered by fall-through of jge at 0x0042bb6e, 9 instruction(s), ends with jne to 0x0042bc78 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0042bb74
    imul ecx, ecx, 0x8d                          # 0042bb78
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042bb7e
    movsx eax, word ptr [ebp - local_10c]        # 0042bb84
    imul eax, eax, 0x12                          # 0042bb8b
    movsx ecx, word ptr [edx + eax + field_4c]   # 0042bb8e
    movsx edx, word ptr [0x5bb50b]               # 0042bb93
    {load} cmp ecx, edx                          # 0042bb9a
    jne.d32 L_0042bc78                           # 0042bb9c
    # block 0x0042bba2: entered by fall-through of jne at 0x0042bb9c, 40 instruction(s), ends with forward jump to 0x0042bc7d
    movsx eax, word ptr [ebp + arg_8]            # 0042bba2
    imul eax, eax, 0x8d                          # 0042bba6
    mov dword ptr [eax + 0x5bb626], 0x1          # 0042bbac
    movsx ecx, word ptr [ebp + arg_8]            # 0042bbb6
    imul ecx, ecx, 0x8d                          # 0042bbba
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042bbc0
    movsx eax, word ptr [ebp - local_10c]        # 0042bbc6
    imul eax, eax, 0x12                          # 0042bbcd
    movsx ecx, word ptr [ebp + arg_8]            # 0042bbd0
    imul ecx, ecx, 0x8d                          # 0042bbd4
    mov dx, word ptr [edx + eax + field_4e]      # 0042bbda
    mov word ptr [ecx + 0x5bb62a], dx            # 0042bbdf
    movsx eax, word ptr [ebp + arg_8]            # 0042bbe6
    imul eax, eax, 0x8d                          # 0042bbea
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042bbf0
    movsx edx, word ptr [ebp - local_10c]        # 0042bbf6
    imul edx, edx, 0x12                          # 0042bbfd
    movsx eax, word ptr [ebp + arg_8]            # 0042bc00
    imul eax, eax, 0x8d                          # 0042bc04
    mov cx, word ptr [ecx + edx + field_52]      # 0042bc0a
    mov word ptr [eax + 0x5bb62c], cx            # 0042bc0f
    movsx edx, word ptr [ebp + arg_8]            # 0042bc16
    imul edx, edx, 0x8d                          # 0042bc1a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042bc20
    movsx ecx, word ptr [ebp - local_10c]        # 0042bc26
    imul ecx, ecx, 0x12                          # 0042bc2d
    movsx edx, word ptr [ebp + arg_8]            # 0042bc30
    imul edx, edx, 0x8d                          # 0042bc34
    mov ax, word ptr [eax + ecx + field_56]      # 0042bc3a
    mov word ptr [edx + 0x5bb62e], ax            # 0042bc3f
    movsx ecx, word ptr [ebp + arg_8]            # 0042bc46
    imul ecx, ecx, 0x8d                          # 0042bc4a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042bc50
    movsx eax, word ptr [ebp - local_10c]        # 0042bc56
    imul eax, eax, 0x12                          # 0042bc5d
    movsx ecx, word ptr [ebp + arg_8]            # 0042bc60
    imul ecx, ecx, 0x8d                          # 0042bc64
    mov dx, word ptr [edx + eax + field_5a]      # 0042bc6a
    mov word ptr [ecx + 0x5bb630], dx            # 0042bc6f
    jmp.d8 L_0042bc7d                            # 0042bc76
L_0042bc78:
    # block 0x0042bc78: entered by jne at 0x0042bb9c, 1 instruction(s), ends with backward jump to 0x0042bb3f
    jmp.d32 L_0042bb3f                           # 0042bc78
L_0042bc7d:
    # block 0x0042bc7d: entered by jge at 0x0042bb6e; jmp at 0x0042bc76, 1 instruction(s), ends with forward jump to 0x0042c21d
    jmp.d32 L_0042c21d                           # 0042bc7d
L_0042bc82:
    # block 0x0042bc82: entered by je at 0x0042baf7, 59 instruction(s), ends with je to 0x0042bded (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042bc82
    imul eax, eax, 0x8d                          # 0042bc86
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042bc8c
    mov dx, word ptr [ecx + field_21]            # 0042bc92
    mov word ptr [ebp - local_108], dx           # 0042bc96
    movsx eax, word ptr [ebp + arg_8]            # 0042bc9d
    imul eax, eax, 0x8d                          # 0042bca1
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042bca7
    mov edx, dword ptr [ebp - local_108]         # 0042bcad
    and edx, 0xffff                              # 0042bcb3
    imul edx, edx, 0x5bb                         # 0042bcb9
    mov eax, dword ptr [ecx + field_29]          # 0042bcbf
    mov dword ptr [edx + 0x5c3b9b], eax          # 0042bcc2
    movsx ecx, word ptr [ebp + arg_8]            # 0042bcc8
    imul ecx, ecx, 0x8d                          # 0042bccc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042bcd2
    movsx eax, word ptr [edx + field_2d]         # 0042bcd8
    mov dword ptr [ebp - local_114], eax         # 0042bcdc
    fild dword ptr [ebp - local_114]             # 0042bce2
    fstp dword ptr [ebp - local_118]             # 0042bce8
    fld dword ptr [ebp - local_118]              # 0042bcee
    fdiv qword ptr [0x52c680]                    # 0042bcf4
    fstp dword ptr [ebp - local_11c]             # 0042bcfa
    fld dword ptr [ebp - local_11c]              # 0042bd00
    mov ecx, dword ptr [ebp - local_108]         # 0042bd06
    and ecx, 0xffff                              # 0042bd0c
    imul ecx, ecx, 0x5bb                         # 0042bd12
    fstp dword ptr [ecx + 0x5c3b9f]              # 0042bd18
    movsx edx, word ptr [ebp + arg_8]            # 0042bd1e
    imul edx, edx, 0x8d                          # 0042bd22
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042bd28
    movsx ecx, word ptr [eax + field_2f]         # 0042bd2e
    mov dword ptr [ebp - local_120], ecx         # 0042bd32
    fild dword ptr [ebp - local_120]             # 0042bd38
    fstp dword ptr [ebp - local_124]             # 0042bd3e
    fld dword ptr [ebp - local_124]              # 0042bd44
    fdiv qword ptr [0x52c680]                    # 0042bd4a
    fstp dword ptr [ebp - local_128]             # 0042bd50
    fld dword ptr [ebp - local_128]              # 0042bd56
    mov edx, dword ptr [ebp - local_108]         # 0042bd5c
    and edx, 0xffff                              # 0042bd62
    imul edx, edx, 0x5bb                         # 0042bd68
    fstp dword ptr [edx + 0x5c3ba3]              # 0042bd6e
    mov eax, dword ptr [ebp - local_108]         # 0042bd74
    and eax, 0xffff                              # 0042bd7a
    imul eax, eax, 0x5bb                         # 0042bd7f
    mov word ptr [eax + 0x5c3b97], 0x1           # 0042bd85
    mov ecx, dword ptr [ebp - local_108]         # 0042bd8e
    and ecx, 0xffff                              # 0042bd94
    imul ecx, ecx, 0x5bb                         # 0042bd9a
    mov word ptr [ecx + 0x5c3b99], 0x0           # 0042bda0
    mov edx, dword ptr [ebp - local_108]         # 0042bda9
    and edx, 0xffff                              # 0042bdaf
    imul edx, edx, 0x5bb                         # 0042bdb5
    fld dword ptr [edx + 0x5c3b9f]               # 0042bdbb
    fcomp qword ptr [0x52c598]                   # 0042bdc1
    fnstsw ax                                    # 0042bdc7
    test ah, 0x1                                 # 0042bdc9
    je.d8 L_0042bded                             # 0042bdcc
    # block 0x0042bdce: entered by fall-through of je at 0x0042bdcc, 6 instruction(s), ends with forward jump to 0x0042be01
    mov eax, dword ptr [ebp - local_108]         # 0042bdce
    and eax, 0xffff                              # 0042bdd4
    imul eax, eax, 0x5bb                         # 0042bdd9
    fld dword ptr [eax + 0x5c3b9f]               # 0042bddf
    fstp qword ptr [ebp - local_130]             # 0042bde5
    jmp.d8 L_0042be01                            # 0042bdeb
L_0042bded:
    # block 0x0042bded: entered by je at 0x0042bdcc, 2 instruction(s), falls into the block at 0x0042be01
    mov dword ptr [ebp - local_130], 0x0         # 0042bded
    mov dword ptr [ebp - local_12c], 0x3ff00000  # 0042bdf7
L_0042be01:
    # block 0x0042be01: entered by jmp at 0x0042bdeb, 15 instruction(s), ends with jne to 0x0042be6f (forward)
    fld qword ptr [ebp - local_130]              # 0042be01
    fstp dword ptr [ebp - local_134]             # 0042be07
    fld dword ptr [ebp - local_134]              # 0042be0d
    mov ecx, dword ptr [ebp - local_108]         # 0042be13
    and ecx, 0xffff                              # 0042be19
    imul ecx, ecx, 0x5bb                         # 0042be1f
    fstp dword ptr [ecx + 0x5c3b9f]              # 0042be25
    mov edx, dword ptr [ebp - local_108]         # 0042be2b
    and edx, 0xffff                              # 0042be31
    imul edx, edx, 0x5bb                         # 0042be37
    fld dword ptr [edx + 0x5c3b9f]               # 0042be3d
    fcomp qword ptr [0x52c7b0]                   # 0042be43
    fnstsw ax                                    # 0042be49
    test ah, 0x41                                # 0042be4b
    jne.d8 L_0042be6f                            # 0042be4e
    # block 0x0042be50: entered by fall-through of jne at 0x0042be4e, 6 instruction(s), ends with forward jump to 0x0042be83
    mov eax, dword ptr [ebp - local_108]         # 0042be50
    and eax, 0xffff                              # 0042be56
    imul eax, eax, 0x5bb                         # 0042be5b
    fld dword ptr [eax + 0x5c3b9f]               # 0042be61
    fstp qword ptr [ebp - local_13c]             # 0042be67
    jmp.d8 L_0042be83                            # 0042be6d
L_0042be6f:
    # block 0x0042be6f: entered by jne at 0x0042be4e, 2 instruction(s), falls into the block at 0x0042be83
    mov dword ptr [ebp - local_13c], 0x0         # 0042be6f
    mov dword ptr [ebp - local_138], 0x0         # 0042be79
L_0042be83:
    # block 0x0042be83: entered by jmp at 0x0042be6d, 15 instruction(s), ends with je to 0x0042bef1 (forward)
    fld qword ptr [ebp - local_13c]              # 0042be83
    fstp dword ptr [ebp - local_140]             # 0042be89
    fld dword ptr [ebp - local_140]              # 0042be8f
    mov ecx, dword ptr [ebp - local_108]         # 0042be95
    and ecx, 0xffff                              # 0042be9b
    imul ecx, ecx, 0x5bb                         # 0042bea1
    fstp dword ptr [ecx + 0x5c3b9f]              # 0042bea7
    mov edx, dword ptr [ebp - local_108]         # 0042bead
    and edx, 0xffff                              # 0042beb3
    imul edx, edx, 0x5bb                         # 0042beb9
    fld dword ptr [edx + 0x5c3ba3]               # 0042bebf
    fcomp qword ptr [0x52c598]                   # 0042bec5
    fnstsw ax                                    # 0042becb
    test ah, 0x1                                 # 0042becd
    je.d8 L_0042bef1                             # 0042bed0
    # block 0x0042bed2: entered by fall-through of je at 0x0042bed0, 6 instruction(s), ends with forward jump to 0x0042bf05
    mov eax, dword ptr [ebp - local_108]         # 0042bed2
    and eax, 0xffff                              # 0042bed8
    imul eax, eax, 0x5bb                         # 0042bedd
    fld dword ptr [eax + 0x5c3ba3]               # 0042bee3
    fstp qword ptr [ebp - local_148]             # 0042bee9
    jmp.d8 L_0042bf05                            # 0042beef
L_0042bef1:
    # block 0x0042bef1: entered by je at 0x0042bed0, 2 instruction(s), falls into the block at 0x0042bf05
    mov dword ptr [ebp - local_148], 0x0         # 0042bef1
    mov dword ptr [ebp - local_144], 0x3ff00000  # 0042befb
L_0042bf05:
    # block 0x0042bf05: entered by jmp at 0x0042beef, 15 instruction(s), ends with jne to 0x0042bf73 (forward)
    fld qword ptr [ebp - local_148]              # 0042bf05
    fstp dword ptr [ebp - local_14c]             # 0042bf0b
    fld dword ptr [ebp - local_14c]              # 0042bf11
    mov ecx, dword ptr [ebp - local_108]         # 0042bf17
    and ecx, 0xffff                              # 0042bf1d
    imul ecx, ecx, 0x5bb                         # 0042bf23
    fstp dword ptr [ecx + 0x5c3ba3]              # 0042bf29
    mov edx, dword ptr [ebp - local_108]         # 0042bf2f
    and edx, 0xffff                              # 0042bf35
    imul edx, edx, 0x5bb                         # 0042bf3b
    fld dword ptr [edx + 0x5c3ba3]               # 0042bf41
    fcomp qword ptr [0x52c7b0]                   # 0042bf47
    fnstsw ax                                    # 0042bf4d
    test ah, 0x41                                # 0042bf4f
    jne.d8 L_0042bf73                            # 0042bf52
    # block 0x0042bf54: entered by fall-through of jne at 0x0042bf52, 6 instruction(s), ends with forward jump to 0x0042bf87
    mov eax, dword ptr [ebp - local_108]         # 0042bf54
    and eax, 0xffff                              # 0042bf5a
    imul eax, eax, 0x5bb                         # 0042bf5f
    fld dword ptr [eax + 0x5c3ba3]               # 0042bf65
    fstp qword ptr [ebp - local_154]             # 0042bf6b
    jmp.d8 L_0042bf87                            # 0042bf71
L_0042bf73:
    # block 0x0042bf73: entered by jne at 0x0042bf52, 2 instruction(s), falls into the block at 0x0042bf87
    mov dword ptr [ebp - local_154], 0x0         # 0042bf73
    mov dword ptr [ebp - local_150], 0x0         # 0042bf7d
L_0042bf87:
    # block 0x0042bf87: entered by jmp at 0x0042bf71, 30 instruction(s), calls FUN_004fc62d, ends with je to 0x0042c020 (forward)
    fld qword ptr [ebp - local_154]              # 0042bf87
    fstp dword ptr [ebp - local_158]             # 0042bf8d
    fld dword ptr [ebp - local_158]              # 0042bf93
    mov ecx, dword ptr [ebp - local_108]         # 0042bf99
    and ecx, 0xffff                              # 0042bf9f
    imul ecx, ecx, 0x5bb                         # 0042bfa5
    fstp dword ptr [ecx + 0x5c3ba3]              # 0042bfab
    push 0x0                                     # 0042bfb1
    lea edx, [ebp - local_104]                   # 0042bfb3
    push edx                                     # 0042bfb9
    movsx eax, word ptr [ebp + arg_8]            # 0042bfba
    imul eax, eax, 0x8d                          # 0042bfbe
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042bfc4
    movsx edx, word ptr [ecx + field_23]         # 0042bfca
    push edx                                     # 0042bfce
    movsx eax, word ptr [ebp + arg_8]            # 0042bfcf
    imul eax, eax, 0x8d                          # 0042bfd3
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042bfd9
    push ecx                                     # 0042bfdf
    mov dx, word ptr [ebp - local_108]           # 0042bfe0
    push edx                                     # 0042bfe7
    mov ecx, 0x5c3a67                            # 0042bfe8
    call FUN_004fc62d                            # 0042bfed
    movsx eax, word ptr [ebp + arg_8]            # 0042bff2
    imul eax, eax, 0x8d                          # 0042bff6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042bffc
    movsx edx, word ptr [ecx + field_25]         # 0042c002
    mov dword ptr [ebp - local_15c], edx         # 0042c006
    cmp dword ptr [ebp - local_15c], 0x1         # 0042c00c
    je.d8 L_0042c020                             # 0042c013
    # block 0x0042c015: entered by fall-through of je at 0x0042c013, 2 instruction(s), ends with je to 0x0042c056 (forward)
    cmp dword ptr [ebp - local_15c], 0x2         # 0042c015
    je.d8 L_0042c056                             # 0042c01c
    # block 0x0042c01e: entered by fall-through of je at 0x0042c01c, 1 instruction(s), ends with forward jump to 0x0042c08c
    jmp.d8 L_0042c08c                            # 0042c01e
L_0042c020:
    # block 0x0042c020: entered by je at 0x0042c013, 11 instruction(s), calls FUN_004faf98, ends with forward jump to 0x0042c0a4
    mov eax, dword ptr [ebp - local_108]         # 0042c020
    and eax, 0xffff                              # 0042c026
    imul eax, eax, 0x5bb                         # 0042c02b
    mov dword ptr [eax + 0x5c3bd1], 0x0          # 0042c031
    mov cx, word ptr [ebp - local_108]           # 0042c03b
    push ecx                                     # 0042c042
    lea edx, [ebp - local_104]                   # 0042c043
    push edx                                     # 0042c049
    mov ecx, 0x5c3a67                            # 0042c04a
    call FUN_004faf98                            # 0042c04f
    jmp.d8 L_0042c0a4                            # 0042c054
L_0042c056:
    # block 0x0042c056: entered by je at 0x0042c01c, 11 instruction(s), calls FUN_004faf98, ends with forward jump to 0x0042c0a4
    mov eax, dword ptr [ebp - local_108]         # 0042c056
    and eax, 0xffff                              # 0042c05c
    imul eax, eax, 0x5bb                         # 0042c061
    mov dword ptr [eax + 0x5c3bd1], 0x1          # 0042c067
    mov cx, word ptr [ebp - local_108]           # 0042c071
    push ecx                                     # 0042c078
    lea edx, [ebp - local_104]                   # 0042c079
    push edx                                     # 0042c07f
    mov ecx, 0x5c3a67                            # 0042c080
    call FUN_004faf98                            # 0042c085
    jmp.d8 L_0042c0a4                            # 0042c08a
L_0042c08c:
    # block 0x0042c08c: entered by jmp at 0x0042c01e, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0042c0a4
    push 0x0                                     # 0042c08c
    push 0x0                                     # 0042c08e
    push 0x545764                                # 0042c090
    call FUN_0052139c                            # 0042c095
    mov ecx, 0x5cf659                            # 0042c09a
    call FUN_004c97b4                            # 0042c09f
L_0042c0a4:
    # block 0x0042c0a4: entered by jmp at 0x0042c054; jmp at 0x0042c08a, 6 instruction(s), ends with je to 0x0042c1b3 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042c0a4
    imul eax, eax, 0x8d                          # 0042c0a8
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c0ae
    movsx edx, word ptr [ecx + field_31]         # 0042c0b4
    cmp edx, 0x270f                              # 0042c0b8
    je.d32 L_0042c1b3                            # 0042c0be
    # block 0x0042c0c4: entered by fall-through of je at 0x0042c0be, 41 instruction(s), ends with jne to 0x0042c19f (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042c0c4
    imul eax, eax, 0x8d                          # 0042c0c8
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c0ce
    movsx edx, word ptr [ecx + field_31]         # 0042c0d4
    mov dword ptr [0x5bb57b], edx                # 0042c0d8
    movsx eax, word ptr [ebp + arg_8]            # 0042c0de
    imul eax, eax, 0x8d                          # 0042c0e2
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c0e8
    mov dx, word ptr [ecx + field_33]            # 0042c0ee
    mov word ptr [0x5bb599], dx                  # 0042c0f2
    movsx eax, word ptr [ebp + arg_8]            # 0042c0f9
    imul eax, eax, 0x8d                          # 0042c0fd
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c103
    mov dx, word ptr [ecx + field_35]            # 0042c109
    mov word ptr [0x5bb595], dx                  # 0042c10d
    movsx eax, word ptr [ebp + arg_8]            # 0042c114
    imul eax, eax, 0x8d                          # 0042c118
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c11e
    mov dx, word ptr [ecx + field_37]            # 0042c124
    mov word ptr [0x5c39ff], dx                  # 0042c128
    movsx eax, word ptr [ebp + arg_8]            # 0042c12f
    imul eax, eax, 0x8d                          # 0042c133
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c139
    mov edx, dword ptr [ecx + field_39]          # 0042c13f
    mov dword ptr [0x5bb59b], edx                # 0042c142
    movsx eax, word ptr [ebp + arg_8]            # 0042c148
    imul eax, eax, 0x8d                          # 0042c14c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c152
    mov edx, dword ptr [ecx + field_3d]          # 0042c158
    mov dword ptr [0x5bb59f], edx                # 0042c15b
    movsx eax, word ptr [ebp + arg_8]            # 0042c161
    imul eax, eax, 0x8d                          # 0042c165
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c16b
    mov edx, dword ptr [ecx + field_41]          # 0042c171
    mov dword ptr [0x5bb5a3], edx                # 0042c174
    movsx eax, word ptr [ebp + arg_8]            # 0042c17a
    imul eax, eax, 0x8d                          # 0042c17e
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c184
    movsx edx, word ptr [ecx + field_48]         # 0042c18a
    cmp edx, 0x1                                 # 0042c18e
    jne.d8 L_0042c19f                            # 0042c191
    # block 0x0042c193: entered by fall-through of jne at 0x0042c191, 2 instruction(s), ends with forward jump to 0x0042c1a9
    mov dword ptr [0x5bb1ca], 0x0                # 0042c193
    jmp.d8 L_0042c1a9                            # 0042c19d
L_0042c19f:
    # block 0x0042c19f: entered by jne at 0x0042c191, 1 instruction(s), falls into the block at 0x0042c1a9
    mov dword ptr [0x5bb1ca], 0x1                # 0042c19f
L_0042c1a9:
    # block 0x0042c1a9: entered by jmp at 0x0042c19d, 1 instruction(s), falls into the block at 0x0042c1b3
    mov dword ptr [0x583999], 0x4                # 0042c1a9
L_0042c1b3:
    # block 0x0042c1b3: entered by je at 0x0042c0be, 6 instruction(s), ends with je to 0x0042c1fc (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042c1b3
    imul eax, eax, 0x8d                          # 0042c1b7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c1bd
    movsx edx, word ptr [ecx + field_45]         # 0042c1c3
    cmp edx, -0x1                                # 0042c1c7
    je.d8 L_0042c1fc                             # 0042c1ca
    # block 0x0042c1cc: entered by fall-through of je at 0x0042c1ca, 10 instruction(s), falls into the block at 0x0042c1fc
    movsx eax, word ptr [ebp + arg_8]            # 0042c1cc
    imul eax, eax, 0x8d                          # 0042c1d0
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c1d6
    {load} xor edx, edx                          # 0042c1dc
    mov dl, byte ptr [ecx + field_47]            # 0042c1de
    movsx eax, word ptr [ebp + arg_8]            # 0042c1e1
    imul eax, eax, 0x8d                          # 0042c1e5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042c1eb
    movsx eax, word ptr [ecx + field_45]         # 0042c1f1
    mov dword ptr [4*eax + 0x585801], edx        # 0042c1f5
L_0042c1fc:
    # block 0x0042c1fc: entered by je at 0x0042c1ca, 7 instruction(s), calls FUN_0042ba3a, falls into the block at 0x0042c21d
    movsx ecx, word ptr [ebp + arg_8]            # 0042c1fc
    imul ecx, ecx, 0x8d                          # 0042c200
    mov dword ptr [ecx + 0x5bb626], 0x0          # 0042c206
    mov dx, word ptr [ebp + arg_8]               # 0042c210
    push edx                                     # 0042c214
    call FUN_0042ba3a                            # 0042c215
    add esp, 0x4                                 # 0042c21a
L_0042c21d:
    # block 0x0042c21d: entered by jmp at 0x0042bafd; jmp at 0x0042bc7d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042c21d
    pop ebp                                      # 0042c21f
    ret                                          # 0042c220

