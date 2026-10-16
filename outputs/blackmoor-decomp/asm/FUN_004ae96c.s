# FUN_004ae96c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ae96c
# extent:       0x004ae96c-0x004aec35 (713 code bytes)
# span:         0x004ae96c-0x004aec35 (code 713, tables 0, padding 0)
# sha256:       806fff4c80861190daa9843e230b6d559a3d305f3d7f74aa9c77698a6eb6b7ae
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ae96c
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       27 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 15 more
# fields:       [eax + n] field_4, field_8, field_c, field_26, field_e6d, field_e71; [ecx + n] field_4, field_8, field_c, field_20, field_6e; [edx + n] field_4, field_8, field_c, field_1c, field_27
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 242 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_6e, 0x6e  # offset +0x6e
.equ field_e6d, 0xe6d  # offset +0xe6d
.equ field_e71, 0xe71  # offset +0xe71

# --- external targets -----------------------------------------------

.org 0x004ae96c - 0x401000
.globl FUN_004ae96c
FUN_004ae96c:
    # block 0x004ae96c: entry, 44 instruction(s), ends with jge to 0x004aea3b (forward)
    push ebp                                     # 004ae96c
    {load} mov ebp, esp                          # 004ae96d
    sub esp, 0x6c                                # 004ae96f
    mov dword ptr [ebp - local_6c], ecx          # 004ae972
    mov eax, dword ptr [ebp + arg_8]             # 004ae975
    imul eax, eax, 0xc7                          # 004ae978
    mov ecx, dword ptr [ebp - local_6c]          # 004ae97e
    lea edx, [ecx + eax + field_6e]              # 004ae981
    mov dword ptr [ebp - local_64], edx          # 004ae985
    mov eax, dword ptr [ebp - local_64]          # 004ae988
    {load} xor ecx, ecx                          # 004ae98b
    mov cl, byte ptr [eax + field_26]            # 004ae98d
    imul ecx, ecx, 0x28                          # 004ae990
    mov edx, dword ptr [ebp - local_64]          # 004ae993
    lea eax, [edx + ecx + field_27]              # 004ae996
    mov dword ptr [ebp - local_48], eax          # 004ae99a
    mov ecx, dword ptr [ebp - local_64]          # 004ae99d
    add ecx, 0x2                                 # 004ae9a0
    mov dword ptr [ebp - local_44], ecx          # 004ae9a3
    mov edx, dword ptr [ebp - local_48]          # 004ae9a6
    mov eax, dword ptr [edx + field_1c]          # 004ae9a9
    mov dword ptr [ebp - local_14], eax          # 004ae9ac
    mov ecx, dword ptr [ebp - local_48]          # 004ae9af
    mov dx, word ptr [ecx + field_20]            # 004ae9b2
    mov word ptr [ebp - local_10], dx            # 004ae9b6
    mov eax, dword ptr [ebp - local_6c]          # 004ae9ba
    mov ecx, dword ptr [eax + field_e6d]         # 004ae9bd
    mov dword ptr [ebp - local_50], ecx          # 004ae9c3
    mov edx, dword ptr [ebp - local_6c]          # 004ae9c6
    add edx, 0xe79                               # 004ae9c9
    mov dword ptr [ebp - local_18], edx          # 004ae9cf
    mov eax, dword ptr [ebp - local_6c]          # 004ae9d2
    mov cx, word ptr [eax + field_e71]           # 004ae9d5
    mov word ptr [ebp - local_8], cx             # 004ae9dc
    or edx, -0x1                                 # 004ae9e0
    mov dword ptr [ebp - local_2c], edx          # 004ae9e3
    mov dword ptr [ebp - local_28], edx          # 004ae9e6
    mov dword ptr [ebp - local_24], edx          # 004ae9e9
    mov dword ptr [ebp - local_20], edx          # 004ae9ec
    mov eax, dword ptr [ebp - local_44]          # 004ae9ef
    mov ecx, dword ptr [ebp - local_18]          # 004ae9f2
    mov edx, dword ptr [eax]                     # 004ae9f5
    cmp edx, dword ptr [ecx]                     # 004ae9f7
    jge.d8 L_004aea3b                            # 004ae9f9
    # block 0x004ae9fb: entered by fall-through of jge at 0x004ae9f9, 5 instruction(s), ends with jl to 0x004aea34 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004ae9fb
    mov ecx, dword ptr [ebp - local_18]          # 004ae9fe
    mov edx, dword ptr [eax + field_8]           # 004aea01
    cmp edx, dword ptr [ecx]                     # 004aea04
    jl.d8 L_004aea34                             # 004aea06
    # block 0x004aea08: entered by fall-through of jl at 0x004aea06, 8 instruction(s), ends with jle to 0x004aea29 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004aea08
    mov ecx, dword ptr [eax]                     # 004aea0b
    mov dword ptr [ebp - local_2c], ecx          # 004aea0d
    mov edx, dword ptr [ebp - local_44]          # 004aea10
    mov eax, dword ptr [ebp - local_18]          # 004aea13
    mov ecx, dword ptr [edx + field_8]           # 004aea16
    cmp ecx, dword ptr [eax + field_8]           # 004aea19
    jle.d8 L_004aea29                            # 004aea1c
    # block 0x004aea1e: entered by fall-through of jle at 0x004aea1c, 4 instruction(s), ends with forward jump to 0x004aea32
    mov edx, dword ptr [ebp - local_18]          # 004aea1e
    mov eax, dword ptr [edx + field_8]           # 004aea21
    mov dword ptr [ebp - local_24], eax          # 004aea24
    jmp.d8 L_004aea32                            # 004aea27
L_004aea29:
    # block 0x004aea29: entered by jle at 0x004aea1c, 3 instruction(s), falls into the block at 0x004aea32
    mov ecx, dword ptr [ebp - local_44]          # 004aea29
    mov edx, dword ptr [ecx + field_8]           # 004aea2c
    mov dword ptr [ebp - local_24], edx          # 004aea2f
L_004aea32:
    # block 0x004aea32: entered by jmp at 0x004aea27, 1 instruction(s), ends with forward jump to 0x004aea39
    jmp.d8 L_004aea39                            # 004aea32
L_004aea34:
    # block 0x004aea34: entered by jl at 0x004aea06, 1 instruction(s), ends with forward jump to 0x004aec2f
    jmp.d32 L_004aec2f                           # 004aea34
L_004aea39:
    # block 0x004aea39: entered by jmp at 0x004aea32, 1 instruction(s), ends with forward jump to 0x004aea79
    jmp.d8 L_004aea79                            # 004aea39
L_004aea3b:
    # block 0x004aea3b: entered by jge at 0x004ae9f9, 5 instruction(s), ends with jg to 0x004aea74 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004aea3b
    mov ecx, dword ptr [ebp - local_18]          # 004aea3e
    mov edx, dword ptr [eax]                     # 004aea41
    cmp edx, dword ptr [ecx + field_8]           # 004aea43
    jg.d8 L_004aea74                             # 004aea46
    # block 0x004aea48: entered by fall-through of jg at 0x004aea46, 8 instruction(s), ends with jg to 0x004aea69 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004aea48
    mov ecx, dword ptr [eax]                     # 004aea4b
    mov dword ptr [ebp - local_2c], ecx          # 004aea4d
    mov edx, dword ptr [ebp - local_44]          # 004aea50
    mov eax, dword ptr [ebp - local_18]          # 004aea53
    mov ecx, dword ptr [edx + field_8]           # 004aea56
    cmp ecx, dword ptr [eax + field_8]           # 004aea59
    jg.d8 L_004aea69                             # 004aea5c
    # block 0x004aea5e: entered by fall-through of jg at 0x004aea5c, 4 instruction(s), ends with forward jump to 0x004aea72
    mov edx, dword ptr [ebp - local_44]          # 004aea5e
    mov eax, dword ptr [edx + field_8]           # 004aea61
    mov dword ptr [ebp - local_24], eax          # 004aea64
    jmp.d8 L_004aea72                            # 004aea67
L_004aea69:
    # block 0x004aea69: entered by jg at 0x004aea5c, 3 instruction(s), falls into the block at 0x004aea72
    mov ecx, dword ptr [ebp - local_18]          # 004aea69
    mov edx, dword ptr [ecx + field_8]           # 004aea6c
    mov dword ptr [ebp - local_24], edx          # 004aea6f
L_004aea72:
    # block 0x004aea72: entered by jmp at 0x004aea67, 1 instruction(s), ends with forward jump to 0x004aea79
    jmp.d8 L_004aea79                            # 004aea72
L_004aea74:
    # block 0x004aea74: entered by jg at 0x004aea46, 1 instruction(s), ends with forward jump to 0x004aec2f
    jmp.d32 L_004aec2f                           # 004aea74
L_004aea79:
    # block 0x004aea79: entered by jmp at 0x004aea39; jmp at 0x004aea72, 5 instruction(s), ends with jge to 0x004aeac9 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004aea79
    mov ecx, dword ptr [ebp - local_18]          # 004aea7c
    mov edx, dword ptr [eax + field_4]           # 004aea7f
    cmp edx, dword ptr [ecx + field_4]           # 004aea82
    jge.d8 L_004aeac9                            # 004aea85
    # block 0x004aea87: entered by fall-through of jge at 0x004aea85, 5 instruction(s), ends with jl to 0x004aeac2 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004aea87
    mov ecx, dword ptr [ebp - local_18]          # 004aea8a
    mov edx, dword ptr [eax + field_c]           # 004aea8d
    cmp edx, dword ptr [ecx + field_4]           # 004aea90
    jl.d8 L_004aeac2                             # 004aea93
    # block 0x004aea95: entered by fall-through of jl at 0x004aea93, 8 instruction(s), ends with jle to 0x004aeab7 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004aea95
    mov ecx, dword ptr [eax + field_4]           # 004aea98
    mov dword ptr [ebp - local_28], ecx          # 004aea9b
    mov edx, dword ptr [ebp - local_44]          # 004aea9e
    mov eax, dword ptr [ebp - local_18]          # 004aeaa1
    mov ecx, dword ptr [edx + field_c]           # 004aeaa4
    cmp ecx, dword ptr [eax + field_c]           # 004aeaa7
    jle.d8 L_004aeab7                            # 004aeaaa
    # block 0x004aeaac: entered by fall-through of jle at 0x004aeaaa, 4 instruction(s), ends with forward jump to 0x004aeac0
    mov edx, dword ptr [ebp - local_18]          # 004aeaac
    mov eax, dword ptr [edx + field_c]           # 004aeaaf
    mov dword ptr [ebp - local_20], eax          # 004aeab2
    jmp.d8 L_004aeac0                            # 004aeab5
L_004aeab7:
    # block 0x004aeab7: entered by jle at 0x004aeaaa, 3 instruction(s), falls into the block at 0x004aeac0
    mov ecx, dword ptr [ebp - local_44]          # 004aeab7
    mov edx, dword ptr [ecx + field_c]           # 004aeaba
    mov dword ptr [ebp - local_20], edx          # 004aeabd
L_004aeac0:
    # block 0x004aeac0: entered by jmp at 0x004aeab5, 1 instruction(s), ends with forward jump to 0x004aeac7
    jmp.d8 L_004aeac7                            # 004aeac0
L_004aeac2:
    # block 0x004aeac2: entered by jl at 0x004aea93, 1 instruction(s), ends with forward jump to 0x004aec2f
    jmp.d32 L_004aec2f                           # 004aeac2
L_004aeac7:
    # block 0x004aeac7: entered by jmp at 0x004aeac0, 1 instruction(s), ends with forward jump to 0x004aeb09
    jmp.d8 L_004aeb09                            # 004aeac7
L_004aeac9:
    # block 0x004aeac9: entered by jge at 0x004aea85, 5 instruction(s), ends with jg to 0x004aeb04 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004aeac9
    mov ecx, dword ptr [ebp - local_18]          # 004aeacc
    mov edx, dword ptr [eax + field_4]           # 004aeacf
    cmp edx, dword ptr [ecx + field_c]           # 004aead2
    jg.d8 L_004aeb04                             # 004aead5
    # block 0x004aead7: entered by fall-through of jg at 0x004aead5, 8 instruction(s), ends with jg to 0x004aeaf9 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004aead7
    mov ecx, dword ptr [eax + field_4]           # 004aeada
    mov dword ptr [ebp - local_28], ecx          # 004aeadd
    mov edx, dword ptr [ebp - local_44]          # 004aeae0
    mov eax, dword ptr [ebp - local_18]          # 004aeae3
    mov ecx, dword ptr [edx + field_c]           # 004aeae6
    cmp ecx, dword ptr [eax + field_c]           # 004aeae9
    jg.d8 L_004aeaf9                             # 004aeaec
    # block 0x004aeaee: entered by fall-through of jg at 0x004aeaec, 4 instruction(s), ends with forward jump to 0x004aeb02
    mov edx, dword ptr [ebp - local_44]          # 004aeaee
    mov eax, dword ptr [edx + field_c]           # 004aeaf1
    mov dword ptr [ebp - local_20], eax          # 004aeaf4
    jmp.d8 L_004aeb02                            # 004aeaf7
L_004aeaf9:
    # block 0x004aeaf9: entered by jg at 0x004aeaec, 3 instruction(s), falls into the block at 0x004aeb02
    mov ecx, dword ptr [ebp - local_18]          # 004aeaf9
    mov edx, dword ptr [ecx + field_c]           # 004aeafc
    mov dword ptr [ebp - local_20], edx          # 004aeaff
L_004aeb02:
    # block 0x004aeb02: entered by jmp at 0x004aeaf7, 1 instruction(s), ends with forward jump to 0x004aeb09
    jmp.d8 L_004aeb09                            # 004aeb02
L_004aeb04:
    # block 0x004aeb04: entered by jg at 0x004aead5, 1 instruction(s), ends with forward jump to 0x004aec2f
    jmp.d32 L_004aec2f                           # 004aeb04
L_004aeb09:
    # block 0x004aeb09: entered by jmp at 0x004aeac7; jmp at 0x004aeb02, 2 instruction(s), ends with je to 0x004aeb21 (forward)
    cmp dword ptr [ebp - local_28], -0x1         # 004aeb09
    je.d8 L_004aeb21                             # 004aeb0d
    # block 0x004aeb0f: entered by fall-through of je at 0x004aeb0d, 2 instruction(s), ends with je to 0x004aeb21 (forward)
    cmp dword ptr [ebp - local_20], -0x1         # 004aeb0f
    je.d8 L_004aeb21                             # 004aeb13
    # block 0x004aeb15: entered by fall-through of je at 0x004aeb13, 2 instruction(s), ends with je to 0x004aeb21 (forward)
    cmp dword ptr [ebp - local_2c], -0x1         # 004aeb15
    je.d8 L_004aeb21                             # 004aeb19
    # block 0x004aeb1b: entered by fall-through of je at 0x004aeb19, 2 instruction(s), ends with jne to 0x004aeb26 (forward)
    cmp dword ptr [ebp - local_24], -0x1         # 004aeb1b
    jne.d8 L_004aeb26                            # 004aeb1f
L_004aeb21:
    # block 0x004aeb21: entered by je at 0x004aeb0d; je at 0x004aeb13; je at 0x004aeb19; fall-through of jne at 0x004aeb1f, 1 instruction(s), ends with forward jump to 0x004aec2f
    jmp.d32 L_004aec2f                           # 004aeb21
L_004aeb26:
    # block 0x004aeb26: entered by jne at 0x004aeb1f, 37 instruction(s), ends with forward jump to 0x004aeba2
    mov eax, dword ptr [ebp - local_44]          # 004aeb26
    mov ecx, dword ptr [ebp - local_2c]          # 004aeb29
    sub ecx, dword ptr [eax]                     # 004aeb2c
    mov dword ptr [ebp - local_58], ecx          # 004aeb2e
    mov edx, dword ptr [ebp - local_44]          # 004aeb31
    mov eax, dword ptr [ebp - local_24]          # 004aeb34
    sub eax, dword ptr [edx]                     # 004aeb37
    mov dword ptr [ebp - local_3c], eax          # 004aeb39
    mov ecx, dword ptr [ebp - local_44]          # 004aeb3c
    mov edx, dword ptr [ebp - local_28]          # 004aeb3f
    sub edx, dword ptr [ecx + field_4]           # 004aeb42
    mov dword ptr [ebp - local_5c], edx          # 004aeb45
    mov eax, dword ptr [ebp - local_44]          # 004aeb48
    mov ecx, dword ptr [ebp - local_20]          # 004aeb4b
    sub ecx, dword ptr [eax + field_4]           # 004aeb4e
    mov dword ptr [ebp - local_c], ecx           # 004aeb51
    mov edx, dword ptr [ebp - local_18]          # 004aeb54
    mov eax, dword ptr [ebp - local_2c]          # 004aeb57
    sub eax, dword ptr [edx]                     # 004aeb5a
    mov dword ptr [ebp - local_68], eax          # 004aeb5c
    mov ecx, dword ptr [ebp - local_18]          # 004aeb5f
    mov edx, dword ptr [ebp - local_24]          # 004aeb62
    sub edx, dword ptr [ecx]                     # 004aeb65
    mov dword ptr [ebp - local_4c], edx          # 004aeb67
    mov eax, dword ptr [ebp - local_18]          # 004aeb6a
    mov ecx, dword ptr [ebp - local_28]          # 004aeb6d
    sub ecx, dword ptr [eax + field_4]           # 004aeb70
    mov dword ptr [ebp - local_60], ecx          # 004aeb73
    mov edx, dword ptr [ebp - local_18]          # 004aeb76
    mov eax, dword ptr [ebp - local_20]          # 004aeb79
    sub eax, dword ptr [edx + field_4]           # 004aeb7c
    mov dword ptr [ebp - local_54], eax          # 004aeb7f
    mov ecx, dword ptr [ebp - local_5c]          # 004aeb82
    mov dword ptr [ebp - local_38], ecx          # 004aeb85
    mov edx, dword ptr [ebp - local_60]          # 004aeb88
    mov dword ptr [ebp - local_30], edx          # 004aeb8b
    jmp.d8 L_004aeba2                            # 004aeb8e
L_004aeb90:
    # block 0x004aeb90: entered by jmp at 0x004aec2a, 6 instruction(s), falls into the block at 0x004aeba2
    mov eax, dword ptr [ebp - local_38]          # 004aeb90
    add eax, 0x1                                 # 004aeb93
    mov dword ptr [ebp - local_38], eax          # 004aeb96
    mov ecx, dword ptr [ebp - local_30]          # 004aeb99
    add ecx, 0x1                                 # 004aeb9c
    mov dword ptr [ebp - local_30], ecx          # 004aeb9f
L_004aeba2:
    # block 0x004aeba2: entered by jmp at 0x004aeb8e, 3 instruction(s), ends with jg to 0x004aec2f (forward)
    mov edx, dword ptr [ebp - local_38]          # 004aeba2
    cmp edx, dword ptr [ebp - local_c]           # 004aeba5
    jg.d32 L_004aec2f                            # 004aeba8
    # block 0x004aebae: entered by fall-through of jg at 0x004aeba8, 5 instruction(s), ends with forward jump to 0x004aebce
    mov eax, dword ptr [ebp - local_58]          # 004aebae
    mov dword ptr [ebp - local_34], eax          # 004aebb1
    mov ecx, dword ptr [ebp - local_68]          # 004aebb4
    mov dword ptr [ebp - local_1c], ecx          # 004aebb7
    jmp.d8 L_004aebce                            # 004aebba
L_004aebbc:
    # block 0x004aebbc: entered by jmp at 0x004aec28, 6 instruction(s), falls into the block at 0x004aebce
    mov edx, dword ptr [ebp - local_34]          # 004aebbc
    add edx, 0x1                                 # 004aebbf
    mov dword ptr [ebp - local_34], edx          # 004aebc2
    mov eax, dword ptr [ebp - local_1c]          # 004aebc5
    add eax, 0x1                                 # 004aebc8
    mov dword ptr [ebp - local_1c], eax          # 004aebcb
L_004aebce:
    # block 0x004aebce: entered by jmp at 0x004aebba, 3 instruction(s), ends with jg to 0x004aec2a (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004aebce
    cmp ecx, dword ptr [ebp - local_3c]          # 004aebd1
    jg.d8 L_004aec2a                             # 004aebd4
    # block 0x004aebd6: entered by fall-through of jg at 0x004aebd4, 12 instruction(s), ends with je to 0x004aec28 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004aebd6
    mov eax, dword ptr [ebp - local_38]          # 004aebda
    imul eax, edx                                # 004aebdd
    mov ecx, dword ptr [ebp - local_14]          # 004aebe0
    {load} add ecx, eax                          # 004aebe3
    mov edx, dword ptr [ebp - local_34]          # 004aebe5
    mov al, byte ptr [ecx + edx]                 # 004aebe8
    mov byte ptr [ebp - local_4], al             # 004aebeb
    mov ecx, dword ptr [ebp - local_4]           # 004aebee
    and ecx, 0xff                                # 004aebf1
    test ecx, ecx                                # 004aebf7
    je.d8 L_004aec28                             # 004aebf9
    # block 0x004aebfb: entered by fall-through of je at 0x004aebf9, 12 instruction(s), ends with je to 0x004aec28 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004aebfb
    mov eax, dword ptr [ebp - local_30]          # 004aebff
    imul eax, edx                                # 004aec02
    mov ecx, dword ptr [ebp - local_50]          # 004aec05
    {load} add ecx, eax                          # 004aec08
    add ecx, dword ptr [ebp - local_1c]          # 004aec0a
    mov dword ptr [ebp - local_40], ecx          # 004aec0d
    mov edx, dword ptr [ebp - local_40]          # 004aec10
    {load} xor eax, eax                          # 004aec13
    mov al, byte ptr [edx]                       # 004aec15
    test eax, eax                                # 004aec17
    je.d8 L_004aec28                             # 004aec19
    # block 0x004aec1b: entered by fall-through of je at 0x004aec19, 5 instruction(s), falls into the block at 0x004aec28
    mov ecx, dword ptr [ebp - local_40]          # 004aec1b
    mov dl, byte ptr [ecx]                       # 004aec1e
    add dl, 0x1                                  # 004aec20
    mov eax, dword ptr [ebp - local_40]          # 004aec23
    mov byte ptr [eax], dl                       # 004aec26
L_004aec28:
    # block 0x004aec28: entered by je at 0x004aebf9; je at 0x004aec19, 1 instruction(s), ends with backward jump to 0x004aebbc
    jmp.d8 L_004aebbc                            # 004aec28
L_004aec2a:
    # block 0x004aec2a: entered by jg at 0x004aebd4, 1 instruction(s), ends with backward jump to 0x004aeb90
    jmp.d32 L_004aeb90                           # 004aec2a
L_004aec2f:
    # block 0x004aec2f: entered by jmp at 0x004aea34; jmp at 0x004aea74; jmp at 0x004aeac2; jmp at 0x004aeb04; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004aec2f
    pop ebp                                      # 004aec31
    ret 0x4                                      # 004aec32

