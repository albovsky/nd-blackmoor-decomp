# FUN_004aec35
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004aec35
# extent:       0x004aec35-0x004aef4a (789 code bytes)
# span:         0x004aec35-0x004aef4a (code 789, tables 0, padding 0)
# sha256:       a400026355ceec51979f60bb6ee780481b568ec2fc994214d4910bb649c3e778
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004aec35
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       28 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 16 more
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_24, field_27; [ecx + n] field_4, field_8, field_c, field_26, field_e6d, field_e71; [edx + n] field_4, field_8, field_c, field_20, field_6e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 263 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_6e, 0x6e  # offset +0x6e
.equ field_e6d, 0xe6d  # offset +0xe6d
.equ field_e71, 0xe71  # offset +0xe71

# --- external targets -----------------------------------------------

.org 0x004aec35 - 0x401000
.globl FUN_004aec35
FUN_004aec35:
    # block 0x004aec35: entry, 48 instruction(s), ends with jge to 0x004aed19 (forward)
    push ebp                                     # 004aec35
    {load} mov ebp, esp                          # 004aec36
    sub esp, 0x70                                # 004aec38
    mov dword ptr [ebp - local_70], ecx          # 004aec3b
    mov eax, dword ptr [ebp - local_70]          # 004aec3e
    movsx ecx, word ptr [eax + field_24]         # 004aec41
    imul ecx, ecx, 0xc7                          # 004aec45
    mov edx, dword ptr [ebp - local_70]          # 004aec4b
    lea eax, [edx + ecx + field_6e]              # 004aec4e
    mov dword ptr [ebp - local_68], eax          # 004aec52
    mov ecx, dword ptr [ebp - local_68]          # 004aec55
    {load} xor edx, edx                          # 004aec58
    mov dl, byte ptr [ecx + field_26]            # 004aec5a
    imul edx, edx, 0x28                          # 004aec5d
    mov eax, dword ptr [ebp - local_68]          # 004aec60
    lea ecx, [eax + edx + field_27]              # 004aec63
    mov dword ptr [ebp - local_4c], ecx          # 004aec67
    mov edx, dword ptr [ebp - local_68]          # 004aec6a
    add edx, 0x2                                 # 004aec6d
    mov dword ptr [ebp - local_48], edx          # 004aec70
    mov eax, dword ptr [ebp - local_4c]          # 004aec73
    mov ecx, dword ptr [eax + field_1c]          # 004aec76
    mov dword ptr [ebp - local_14], ecx          # 004aec79
    mov edx, dword ptr [ebp - local_4c]          # 004aec7c
    mov ax, word ptr [edx + field_20]            # 004aec7f
    mov word ptr [ebp - local_10], ax            # 004aec83
    mov ecx, dword ptr [ebp - local_70]          # 004aec87
    mov edx, dword ptr [ecx + field_e6d]         # 004aec8a
    mov dword ptr [ebp - local_54], edx          # 004aec90
    mov eax, dword ptr [ebp - local_70]          # 004aec93
    add eax, 0xe79                               # 004aec96
    mov dword ptr [ebp - local_18], eax          # 004aec9b
    mov ecx, dword ptr [ebp - local_70]          # 004aec9e
    mov dx, word ptr [ecx + field_e71]           # 004aeca1
    mov word ptr [ebp - local_8], dx             # 004aeca8
    mov eax, dword ptr [ebp + arg_8]             # 004aecac
    mov dword ptr [eax], 0x1                     # 004aecaf
    mov dword ptr [ebp - local_40], 0x0          # 004aecb5
    or ecx, -0x1                                 # 004aecbc
    mov dword ptr [ebp - local_2c], ecx          # 004aecbf
    mov dword ptr [ebp - local_28], ecx          # 004aecc2
    mov dword ptr [ebp - local_24], ecx          # 004aecc5
    mov dword ptr [ebp - local_20], ecx          # 004aecc8
    mov edx, dword ptr [ebp - local_48]          # 004aeccb
    mov eax, dword ptr [ebp - local_18]          # 004aecce
    mov ecx, dword ptr [edx]                     # 004aecd1
    cmp ecx, dword ptr [eax]                     # 004aecd3
    jge.d8 L_004aed19                            # 004aecd5
    # block 0x004aecd7: entered by fall-through of jge at 0x004aecd5, 5 instruction(s), ends with jl to 0x004aed10 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004aecd7
    mov eax, dword ptr [ebp - local_18]          # 004aecda
    mov ecx, dword ptr [edx + field_8]           # 004aecdd
    cmp ecx, dword ptr [eax]                     # 004aece0
    jl.d8 L_004aed10                             # 004aece2
    # block 0x004aece4: entered by fall-through of jl at 0x004aece2, 8 instruction(s), ends with jle to 0x004aed05 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004aece4
    mov eax, dword ptr [edx]                     # 004aece7
    mov dword ptr [ebp - local_2c], eax          # 004aece9
    mov ecx, dword ptr [ebp - local_48]          # 004aecec
    mov edx, dword ptr [ebp - local_18]          # 004aecef
    mov eax, dword ptr [ecx + field_8]           # 004aecf2
    cmp eax, dword ptr [edx + field_8]           # 004aecf5
    jle.d8 L_004aed05                            # 004aecf8
    # block 0x004aecfa: entered by fall-through of jle at 0x004aecf8, 4 instruction(s), ends with forward jump to 0x004aed0e
    mov ecx, dword ptr [ebp - local_18]          # 004aecfa
    mov edx, dword ptr [ecx + field_8]           # 004aecfd
    mov dword ptr [ebp - local_24], edx          # 004aed00
    jmp.d8 L_004aed0e                            # 004aed03
L_004aed05:
    # block 0x004aed05: entered by jle at 0x004aecf8, 3 instruction(s), falls into the block at 0x004aed0e
    mov eax, dword ptr [ebp - local_48]          # 004aed05
    mov ecx, dword ptr [eax + field_8]           # 004aed08
    mov dword ptr [ebp - local_24], ecx          # 004aed0b
L_004aed0e:
    # block 0x004aed0e: entered by jmp at 0x004aed03, 1 instruction(s), ends with forward jump to 0x004aed17
    jmp.d8 L_004aed17                            # 004aed0e
L_004aed10:
    # block 0x004aed10: entered by jl at 0x004aece2, 2 instruction(s), ends with forward jump to 0x004aef44
    {load} xor eax, eax                          # 004aed10
    jmp.d32 L_004aef44                           # 004aed12
L_004aed17:
    # block 0x004aed17: entered by jmp at 0x004aed0e, 1 instruction(s), ends with forward jump to 0x004aed59
    jmp.d8 L_004aed59                            # 004aed17
L_004aed19:
    # block 0x004aed19: entered by jge at 0x004aecd5, 5 instruction(s), ends with jg to 0x004aed52 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004aed19
    mov eax, dword ptr [ebp - local_18]          # 004aed1c
    mov ecx, dword ptr [edx]                     # 004aed1f
    cmp ecx, dword ptr [eax + field_8]           # 004aed21
    jg.d8 L_004aed52                             # 004aed24
    # block 0x004aed26: entered by fall-through of jg at 0x004aed24, 8 instruction(s), ends with jg to 0x004aed47 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004aed26
    mov eax, dword ptr [edx]                     # 004aed29
    mov dword ptr [ebp - local_2c], eax          # 004aed2b
    mov ecx, dword ptr [ebp - local_48]          # 004aed2e
    mov edx, dword ptr [ebp - local_18]          # 004aed31
    mov eax, dword ptr [ecx + field_8]           # 004aed34
    cmp eax, dword ptr [edx + field_8]           # 004aed37
    jg.d8 L_004aed47                             # 004aed3a
    # block 0x004aed3c: entered by fall-through of jg at 0x004aed3a, 4 instruction(s), ends with forward jump to 0x004aed50
    mov ecx, dword ptr [ebp - local_48]          # 004aed3c
    mov edx, dword ptr [ecx + field_8]           # 004aed3f
    mov dword ptr [ebp - local_24], edx          # 004aed42
    jmp.d8 L_004aed50                            # 004aed45
L_004aed47:
    # block 0x004aed47: entered by jg at 0x004aed3a, 3 instruction(s), falls into the block at 0x004aed50
    mov eax, dword ptr [ebp - local_18]          # 004aed47
    mov ecx, dword ptr [eax + field_8]           # 004aed4a
    mov dword ptr [ebp - local_24], ecx          # 004aed4d
L_004aed50:
    # block 0x004aed50: entered by jmp at 0x004aed45, 1 instruction(s), ends with forward jump to 0x004aed59
    jmp.d8 L_004aed59                            # 004aed50
L_004aed52:
    # block 0x004aed52: entered by jg at 0x004aed24, 2 instruction(s), ends with forward jump to 0x004aef44
    {load} xor eax, eax                          # 004aed52
    jmp.d32 L_004aef44                           # 004aed54
L_004aed59:
    # block 0x004aed59: entered by jmp at 0x004aed17; jmp at 0x004aed50, 5 instruction(s), ends with jge to 0x004aedab (forward)
    mov edx, dword ptr [ebp - local_48]          # 004aed59
    mov eax, dword ptr [ebp - local_18]          # 004aed5c
    mov ecx, dword ptr [edx + field_4]           # 004aed5f
    cmp ecx, dword ptr [eax + field_4]           # 004aed62
    jge.d8 L_004aedab                            # 004aed65
    # block 0x004aed67: entered by fall-through of jge at 0x004aed65, 5 instruction(s), ends with jl to 0x004aeda2 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004aed67
    mov eax, dword ptr [ebp - local_18]          # 004aed6a
    mov ecx, dword ptr [edx + field_c]           # 004aed6d
    cmp ecx, dword ptr [eax + field_4]           # 004aed70
    jl.d8 L_004aeda2                             # 004aed73
    # block 0x004aed75: entered by fall-through of jl at 0x004aed73, 8 instruction(s), ends with jle to 0x004aed97 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004aed75
    mov eax, dword ptr [edx + field_4]           # 004aed78
    mov dword ptr [ebp - local_28], eax          # 004aed7b
    mov ecx, dword ptr [ebp - local_48]          # 004aed7e
    mov edx, dword ptr [ebp - local_18]          # 004aed81
    mov eax, dword ptr [ecx + field_c]           # 004aed84
    cmp eax, dword ptr [edx + field_c]           # 004aed87
    jle.d8 L_004aed97                            # 004aed8a
    # block 0x004aed8c: entered by fall-through of jle at 0x004aed8a, 4 instruction(s), ends with forward jump to 0x004aeda0
    mov ecx, dword ptr [ebp - local_18]          # 004aed8c
    mov edx, dword ptr [ecx + field_c]           # 004aed8f
    mov dword ptr [ebp - local_20], edx          # 004aed92
    jmp.d8 L_004aeda0                            # 004aed95
L_004aed97:
    # block 0x004aed97: entered by jle at 0x004aed8a, 3 instruction(s), falls into the block at 0x004aeda0
    mov eax, dword ptr [ebp - local_48]          # 004aed97
    mov ecx, dword ptr [eax + field_c]           # 004aed9a
    mov dword ptr [ebp - local_20], ecx          # 004aed9d
L_004aeda0:
    # block 0x004aeda0: entered by jmp at 0x004aed95, 1 instruction(s), ends with forward jump to 0x004aeda9
    jmp.d8 L_004aeda9                            # 004aeda0
L_004aeda2:
    # block 0x004aeda2: entered by jl at 0x004aed73, 2 instruction(s), ends with forward jump to 0x004aef44
    {load} xor eax, eax                          # 004aeda2
    jmp.d32 L_004aef44                           # 004aeda4
L_004aeda9:
    # block 0x004aeda9: entered by jmp at 0x004aeda0, 1 instruction(s), ends with forward jump to 0x004aeded
    jmp.d8 L_004aeded                            # 004aeda9
L_004aedab:
    # block 0x004aedab: entered by jge at 0x004aed65, 5 instruction(s), ends with jg to 0x004aede6 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004aedab
    mov eax, dword ptr [ebp - local_18]          # 004aedae
    mov ecx, dword ptr [edx + field_4]           # 004aedb1
    cmp ecx, dword ptr [eax + field_c]           # 004aedb4
    jg.d8 L_004aede6                             # 004aedb7
    # block 0x004aedb9: entered by fall-through of jg at 0x004aedb7, 8 instruction(s), ends with jg to 0x004aeddb (forward)
    mov edx, dword ptr [ebp - local_48]          # 004aedb9
    mov eax, dword ptr [edx + field_4]           # 004aedbc
    mov dword ptr [ebp - local_28], eax          # 004aedbf
    mov ecx, dword ptr [ebp - local_48]          # 004aedc2
    mov edx, dword ptr [ebp - local_18]          # 004aedc5
    mov eax, dword ptr [ecx + field_c]           # 004aedc8
    cmp eax, dword ptr [edx + field_c]           # 004aedcb
    jg.d8 L_004aeddb                             # 004aedce
    # block 0x004aedd0: entered by fall-through of jg at 0x004aedce, 4 instruction(s), ends with forward jump to 0x004aede4
    mov ecx, dword ptr [ebp - local_48]          # 004aedd0
    mov edx, dword ptr [ecx + field_c]           # 004aedd3
    mov dword ptr [ebp - local_20], edx          # 004aedd6
    jmp.d8 L_004aede4                            # 004aedd9
L_004aeddb:
    # block 0x004aeddb: entered by jg at 0x004aedce, 3 instruction(s), falls into the block at 0x004aede4
    mov eax, dword ptr [ebp - local_18]          # 004aeddb
    mov ecx, dword ptr [eax + field_c]           # 004aedde
    mov dword ptr [ebp - local_20], ecx          # 004aede1
L_004aede4:
    # block 0x004aede4: entered by jmp at 0x004aedd9, 1 instruction(s), ends with forward jump to 0x004aeded
    jmp.d8 L_004aeded                            # 004aede4
L_004aede6:
    # block 0x004aede6: entered by jg at 0x004aedb7, 2 instruction(s), ends with forward jump to 0x004aef44
    {load} xor eax, eax                          # 004aede6
    jmp.d32 L_004aef44                           # 004aede8
L_004aeded:
    # block 0x004aeded: entered by jmp at 0x004aeda9; jmp at 0x004aede4, 2 instruction(s), ends with je to 0x004aee05 (forward)
    cmp dword ptr [ebp - local_28], -0x1         # 004aeded
    je.d8 L_004aee05                             # 004aedf1
    # block 0x004aedf3: entered by fall-through of je at 0x004aedf1, 2 instruction(s), ends with je to 0x004aee05 (forward)
    cmp dword ptr [ebp - local_20], -0x1         # 004aedf3
    je.d8 L_004aee05                             # 004aedf7
    # block 0x004aedf9: entered by fall-through of je at 0x004aedf7, 2 instruction(s), ends with je to 0x004aee05 (forward)
    cmp dword ptr [ebp - local_2c], -0x1         # 004aedf9
    je.d8 L_004aee05                             # 004aedfd
    # block 0x004aedff: entered by fall-through of je at 0x004aedfd, 2 instruction(s), ends with jne to 0x004aee0c (forward)
    cmp dword ptr [ebp - local_24], -0x1         # 004aedff
    jne.d8 L_004aee0c                            # 004aee03
L_004aee05:
    # block 0x004aee05: entered by je at 0x004aedf1; je at 0x004aedf7; je at 0x004aedfd; fall-through of jne at 0x004aee03, 2 instruction(s), ends with forward jump to 0x004aef44
    {load} xor eax, eax                          # 004aee05
    jmp.d32 L_004aef44                           # 004aee07
L_004aee0c:
    # block 0x004aee0c: entered by jne at 0x004aee03, 37 instruction(s), ends with forward jump to 0x004aee88
    mov edx, dword ptr [ebp - local_48]          # 004aee0c
    mov eax, dword ptr [ebp - local_2c]          # 004aee0f
    sub eax, dword ptr [edx]                     # 004aee12
    mov dword ptr [ebp - local_5c], eax          # 004aee14
    mov ecx, dword ptr [ebp - local_48]          # 004aee17
    mov edx, dword ptr [ebp - local_24]          # 004aee1a
    sub edx, dword ptr [ecx]                     # 004aee1d
    mov dword ptr [ebp - local_3c], edx          # 004aee1f
    mov eax, dword ptr [ebp - local_48]          # 004aee22
    mov ecx, dword ptr [ebp - local_28]          # 004aee25
    sub ecx, dword ptr [eax + field_4]           # 004aee28
    mov dword ptr [ebp - local_60], ecx          # 004aee2b
    mov edx, dword ptr [ebp - local_48]          # 004aee2e
    mov eax, dword ptr [ebp - local_20]          # 004aee31
    sub eax, dword ptr [edx + field_4]           # 004aee34
    mov dword ptr [ebp - local_c], eax           # 004aee37
    mov ecx, dword ptr [ebp - local_18]          # 004aee3a
    mov edx, dword ptr [ebp - local_2c]          # 004aee3d
    sub edx, dword ptr [ecx]                     # 004aee40
    mov dword ptr [ebp - local_6c], edx          # 004aee42
    mov eax, dword ptr [ebp - local_18]          # 004aee45
    mov ecx, dword ptr [ebp - local_24]          # 004aee48
    sub ecx, dword ptr [eax]                     # 004aee4b
    mov dword ptr [ebp - local_50], ecx          # 004aee4d
    mov edx, dword ptr [ebp - local_18]          # 004aee50
    mov eax, dword ptr [ebp - local_28]          # 004aee53
    sub eax, dword ptr [edx + field_4]           # 004aee56
    mov dword ptr [ebp - local_64], eax          # 004aee59
    mov ecx, dword ptr [ebp - local_18]          # 004aee5c
    mov edx, dword ptr [ebp - local_20]          # 004aee5f
    sub edx, dword ptr [ecx + field_4]           # 004aee62
    mov dword ptr [ebp - local_58], edx          # 004aee65
    mov eax, dword ptr [ebp - local_60]          # 004aee68
    mov dword ptr [ebp - local_38], eax          # 004aee6b
    mov ecx, dword ptr [ebp - local_64]          # 004aee6e
    mov dword ptr [ebp - local_30], ecx          # 004aee71
    jmp.d8 L_004aee88                            # 004aee74
L_004aee76:
    # block 0x004aee76: entered by jmp at 0x004aef30, 6 instruction(s), falls into the block at 0x004aee88
    mov edx, dword ptr [ebp - local_38]          # 004aee76
    add edx, 0x1                                 # 004aee79
    mov dword ptr [ebp - local_38], edx          # 004aee7c
    mov eax, dword ptr [ebp - local_30]          # 004aee7f
    add eax, 0x1                                 # 004aee82
    mov dword ptr [ebp - local_30], eax          # 004aee85
L_004aee88:
    # block 0x004aee88: entered by jmp at 0x004aee74, 3 instruction(s), ends with jg to 0x004aef35 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004aee88
    cmp ecx, dword ptr [ebp - local_c]           # 004aee8b
    jg.d32 L_004aef35                            # 004aee8e
    # block 0x004aee94: entered by fall-through of jg at 0x004aee8e, 5 instruction(s), ends with forward jump to 0x004aeeb4
    mov edx, dword ptr [ebp - local_5c]          # 004aee94
    mov dword ptr [ebp - local_34], edx          # 004aee97
    mov eax, dword ptr [ebp - local_6c]          # 004aee9a
    mov dword ptr [ebp - local_1c], eax          # 004aee9d
    jmp.d8 L_004aeeb4                            # 004aeea0
L_004aeea2:
    # block 0x004aeea2: entered by jmp at 0x004aef2b, 6 instruction(s), falls into the block at 0x004aeeb4
    mov ecx, dword ptr [ebp - local_34]          # 004aeea2
    add ecx, 0x1                                 # 004aeea5
    mov dword ptr [ebp - local_34], ecx          # 004aeea8
    mov edx, dword ptr [ebp - local_1c]          # 004aeeab
    add edx, 0x1                                 # 004aeeae
    mov dword ptr [ebp - local_1c], edx          # 004aeeb1
L_004aeeb4:
    # block 0x004aeeb4: entered by jmp at 0x004aeea0, 3 instruction(s), ends with jg to 0x004aef30 (forward)
    mov eax, dword ptr [ebp - local_34]          # 004aeeb4
    cmp eax, dword ptr [ebp - local_3c]          # 004aeeb7
    jg.d8 L_004aef30                             # 004aeeba
    # block 0x004aeebc: entered by fall-through of jg at 0x004aeeba, 12 instruction(s), ends with je to 0x004aef2b (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004aeebc
    mov edx, dword ptr [ebp - local_38]          # 004aeec0
    imul edx, ecx                                # 004aeec3
    mov eax, dword ptr [ebp - local_14]          # 004aeec6
    {load} add eax, edx                          # 004aeec9
    mov ecx, dword ptr [ebp - local_34]          # 004aeecb
    mov dl, byte ptr [eax + ecx]                 # 004aeece
    mov byte ptr [ebp - local_4], dl             # 004aeed1
    mov eax, dword ptr [ebp - local_4]           # 004aeed4
    and eax, 0xff                                # 004aeed7
    test eax, eax                                # 004aeedc
    je.d8 L_004aef2b                             # 004aeede
    # block 0x004aeee0: entered by fall-through of je at 0x004aeede, 15 instruction(s), ends with jne to 0x004aef12 (forward)
    mov ecx, dword ptr [ebp - local_40]          # 004aeee0
    add ecx, 0x1                                 # 004aeee3
    mov dword ptr [ebp - local_40], ecx          # 004aeee6
    movsx edx, word ptr [ebp - local_8]          # 004aeee9
    mov eax, dword ptr [ebp - local_30]          # 004aeeed
    imul eax, edx                                # 004aeef0
    mov ecx, dword ptr [ebp - local_54]          # 004aeef3
    {load} add ecx, eax                          # 004aeef6
    mov edx, dword ptr [ebp - local_1c]          # 004aeef8
    mov al, byte ptr [ecx + edx]                 # 004aeefb
    mov byte ptr [ebp - local_44], al            # 004aeefe
    mov ecx, dword ptr [ebp - local_44]          # 004aef01
    and ecx, 0xff                                # 004aef04
    test ecx, ecx                                # 004aef0a
    jne.d8 L_004aef12                            # 004aef0c
    # block 0x004aef0e: entered by fall-through of jne at 0x004aef0c, 2 instruction(s), ends with forward jump to 0x004aef44
    {load} xor eax, eax                          # 004aef0e
    jmp.d8 L_004aef44                            # 004aef10
L_004aef12:
    # block 0x004aef12: entered by jne at 0x004aef0c, 5 instruction(s), ends with je to 0x004aef2b (forward)
    mov edx, dword ptr [ebp - local_44]          # 004aef12
    and edx, 0xff                                # 004aef15
    and edx, 0x7f                                # 004aef1b
    test edx, edx                                # 004aef1e
    je.d8 L_004aef2b                             # 004aef20
    # block 0x004aef22: entered by fall-through of je at 0x004aef20, 2 instruction(s), falls into the block at 0x004aef2b
    mov eax, dword ptr [ebp + arg_8]             # 004aef22
    mov dword ptr [eax], 0x0                     # 004aef25
L_004aef2b:
    # block 0x004aef2b: entered by je at 0x004aeede; je at 0x004aef20, 1 instruction(s), ends with backward jump to 0x004aeea2
    jmp.d32 L_004aeea2                           # 004aef2b
L_004aef30:
    # block 0x004aef30: entered by jg at 0x004aeeba, 1 instruction(s), ends with backward jump to 0x004aee76
    jmp.d32 L_004aee76                           # 004aef30
L_004aef35:
    # block 0x004aef35: entered by jg at 0x004aee8e, 2 instruction(s), ends with jne to 0x004aef3f (forward)
    cmp dword ptr [ebp - local_40], 0x0          # 004aef35
    jne.d8 L_004aef3f                            # 004aef39
    # block 0x004aef3b: entered by fall-through of jne at 0x004aef39, 2 instruction(s), ends with forward jump to 0x004aef44
    {load} xor eax, eax                          # 004aef3b
    jmp.d8 L_004aef44                            # 004aef3d
L_004aef3f:
    # block 0x004aef3f: entered by jne at 0x004aef39, 1 instruction(s), falls into the block at 0x004aef44
    mov eax, 0x1                                 # 004aef3f
L_004aef44:
    # block 0x004aef44: entered by jmp at 0x004aed12; jmp at 0x004aed54; jmp at 0x004aeda4; jmp at 0x004aede8; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004aef44
    pop ebp                                      # 004aef46
    ret 0x4                                      # 004aef47

