# FUN_004bca71
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bca71
# extent:       0x004bca71-0x004be16f (5886 code bytes)
# span:         0x004bca71-0x004be18b (code 5886, tables 28, padding 0)
# sha256:       d833855a9d7dbcfc119600c7bf2b4f3a4e8836768dddc848a550d695fc583cb6
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bca71
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4, field_6, field_c, field_14, field_18, field_1c, field_24, field_2c, field_3c, field_40, field_44, field_68 and 59 more; [ecx + n] field_4, field_6, field_8, field_c, field_14, field_18, field_1c, field_20, field_24, field_2c, field_34, field_38 and 50 more; [edx + n] field_4, field_6, field_8, field_c, field_10, field_18, field_1c, field_24, field_2c, field_34, field_38, field_3c and 60 more
# callees:      calls FUN_004e8d96, FUN_004db870, FUN_004d39f9, FUN_004c2790, FUN_004ba13d, FUN_004bc2aa, FUN_004fb77a, FUN_004460d6, FUN_0044655e, FUN_00446532, KERNEL32.dll!GetTickCount, FUN_004bb336, FUN_004fb2e3, FUN_004ba56a, FUN_004bbe46, FUN_004bbb3e and 7 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1428 instruction(s), 50 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_2c, 0x2c  # offset +0x2c
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_c0, 0xc0  # offset +0xc0
.equ field_c4, 0xc4  # offset +0xc4
.equ field_d8, 0xd8  # offset +0xd8
.equ field_dc, 0xdc  # offset +0xdc
.equ field_e0, 0xe0  # offset +0xe0
.equ field_e4, 0xe4  # offset +0xe4
.equ field_e8, 0xe8  # offset +0xe8
.equ field_ec, 0xec  # offset +0xec
.equ field_f0, 0xf0  # offset +0xf0
.equ field_f4, 0xf4  # offset +0xf4
.equ field_f8, 0xf8  # offset +0xf8
.equ field_fc, 0xfc  # offset +0xfc
.equ field_100, 0x100  # offset +0x100
.equ field_104, 0x104  # offset +0x104
.equ field_168, 0x168  # offset +0x168
.equ field_16c, 0x16c  # offset +0x16c
.equ field_170, 0x170  # offset +0x170
.equ field_174, 0x174  # offset +0x174
.equ field_178, 0x178  # offset +0x178
.equ field_17c, 0x17c  # offset +0x17c
.equ field_180, 0x180  # offset +0x180
.equ field_184, 0x184  # offset +0x184
.equ field_188, 0x188  # offset +0x188
.equ field_18c, 0x18c  # offset +0x18c
.equ field_190, 0x190  # offset +0x190
.equ field_194, 0x194  # offset +0x194
.equ field_198, 0x198  # offset +0x198
.equ field_19c, 0x19c  # offset +0x19c
.equ field_1a4, 0x1a4  # offset +0x1a4
.equ field_1a8, 0x1a8  # offset +0x1a8
.equ field_1b4, 0x1b4  # offset +0x1b4
.equ field_1dc, 0x1dc  # offset +0x1dc
.equ field_1e0, 0x1e0  # offset +0x1e0
.equ field_1e4, 0x1e4  # offset +0x1e4
.equ field_1e8, 0x1e8  # offset +0x1e8
.equ field_1ec, 0x1ec  # offset +0x1ec
.equ field_1f0, 0x1f0  # offset +0x1f0
.equ field_1f4, 0x1f4  # offset +0x1f4
.equ field_1f8, 0x1f8  # offset +0x1f8
.equ field_1fc, 0x1fc  # offset +0x1fc
.equ field_200, 0x200  # offset +0x200
.equ field_208, 0x208  # offset +0x208
.equ field_2ac, 0x2ac  # offset +0x2ac
.equ field_2b0, 0x2b0  # offset +0x2b0
.equ field_2b4, 0x2b4  # offset +0x2b4
.equ field_2b8, 0x2b8  # offset +0x2b8
.equ field_2bc, 0x2bc  # offset +0x2bc
.equ field_2c0, 0x2c0  # offset +0x2c0
.equ field_2dc, 0x2dc  # offset +0x2dc
.equ field_2e0, 0x2e0  # offset +0x2e0
.equ field_2e4, 0x2e4  # offset +0x2e4
.equ field_2f4, 0x2f4  # offset +0x2f4
.equ field_2f8, 0x2f8  # offset +0x2f8
.equ field_2fc, 0x2fc  # offset +0x2fc
.equ field_300, 0x300  # offset +0x300
.equ field_30c, 0x30c  # offset +0x30c
.equ field_310, 0x310  # offset +0x310
.equ field_318, 0x318  # offset +0x318
.equ field_401, 0x401  # offset +0x401
.equ field_704, 0x704  # offset +0x704
.equ field_708, 0x708  # offset +0x708
.equ field_70c, 0x70c  # offset +0x70c
.equ field_710, 0x710  # offset +0x710
.equ field_784, 0x784  # offset +0x784
.equ field_788, 0x788  # offset +0x788
.equ field_78c, 0x78c  # offset +0x78c
.equ field_790, 0x790  # offset +0x790
.equ field_798, 0x798  # offset +0x798
.equ field_79c, 0x79c  # offset +0x79c
.equ field_7a0, 0x7a0  # offset +0x7a0
.equ field_7a4, 0x7a4  # offset +0x7a4
.equ field_7a8, 0x7a8  # offset +0x7a8
.equ field_7ac, 0x7ac  # offset +0x7ac
.equ field_7b0, 0x7b0  # offset +0x7b0
.equ field_7b4, 0x7b4  # offset +0x7b4
.equ field_7b8, 0x7b8  # offset +0x7b8
.equ field_7bc, 0x7bc  # offset +0x7bc
.equ field_7c0, 0x7c0  # offset +0x7c0
.equ field_7c4, 0x7c4  # offset +0x7c4
.equ field_7c8, 0x7c8  # offset +0x7c8
.equ field_7ec, 0x7ec  # offset +0x7ec
.equ field_7f0, 0x7f0  # offset +0x7f0
.equ field_7f4, 0x7f4  # offset +0x7f4
.equ field_7f8, 0x7f8  # offset +0x7f8
.equ field_80c, 0x80c  # offset +0x80c
.equ field_810, 0x810  # offset +0x810
.equ field_814, 0x814  # offset +0x814
.equ field_818, 0x818  # offset +0x818
.equ field_81c, 0x81c  # offset +0x81c
.equ field_820, 0x820  # offset +0x820
.equ field_824, 0x824  # offset +0x824
.equ field_828, 0x828  # offset +0x828
.equ field_82c, 0x82c  # offset +0x82c
.equ field_830, 0x830  # offset +0x830
.equ field_834, 0x834  # offset +0x834
.equ field_838, 0x838  # offset +0x838
.equ field_8b0, 0x8b0  # offset +0x8b0
.equ field_8b4, 0x8b4  # offset +0x8b4
.equ field_8b8, 0x8b8  # offset +0x8b8
.equ field_8bc, 0x8bc  # offset +0x8bc
.equ field_8c0, 0x8c0  # offset +0x8c0
.equ field_8c4, 0x8c4  # offset +0x8c4
.equ field_8c8, 0x8c8  # offset +0x8c8
.equ field_8e8, 0x8e8  # offset +0x8e8
.equ field_8f0, 0x8f0  # offset +0x8f0
.equ field_8f4, 0x8f4  # offset +0x8f4
.equ field_8f8, 0x8f8  # offset +0x8f8
.equ field_8fd, 0x8fd  # offset +0x8fd
.equ field_8fe, 0x8fe  # offset +0x8fe
.equ field_91a, 0x91a  # offset +0x91a
.equ field_922, 0x922  # offset +0x922
.equ field_a1b, 0xa1b  # offset +0xa1b
.equ field_a1d, 0xa1d  # offset +0xa1d
.equ field_a1f, 0xa1f  # offset +0xa1f
.equ field_a21, 0xa21  # offset +0xa21
.equ field_a23, 0xa23  # offset +0xa23
.equ field_a27, 0xa27  # offset +0xa27
.equ field_a2b, 0xa2b  # offset +0xa2b
.equ field_a2f, 0xa2f  # offset +0xa2f
.equ field_a31, 0xa31  # offset +0xa31
.equ field_a33, 0xa33  # offset +0xa33
.equ field_a66, 0xa66  # offset +0xa66
.equ field_a68, 0xa68  # offset +0xa68
.equ field_a6a, 0xa6a  # offset +0xa6a
.equ field_a6c, 0xa6c  # offset +0xa6c
.equ field_a6e, 0xa6e  # offset +0xa6e
.equ field_a72, 0xa72  # offset +0xa72
.equ field_a76, 0xa76  # offset +0xa76
.equ field_a7a, 0xa7a  # offset +0xa7a
.equ field_a7c, 0xa7c  # offset +0xa7c
.equ field_a7e, 0xa7e  # offset +0xa7e

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00445f53, .text + (0x00445f53 - 0x401000)
.set FUN_004460d6, .text + (0x004460d6 - 0x401000)
.set FUN_00446532, .text + (0x00446532 - 0x401000)
.set FUN_0044655e, .text + (0x0044655e - 0x401000)
.set FUN_004ba07f, .text + (0x004ba07f - 0x401000)
.set FUN_004ba13d, .text + (0x004ba13d - 0x401000)
.set FUN_004ba56a, .text + (0x004ba56a - 0x401000)
.set FUN_004bb219, .text + (0x004bb219 - 0x401000)
.set FUN_004bb336, .text + (0x004bb336 - 0x401000)
.set FUN_004bb775, .text + (0x004bb775 - 0x401000)
.set FUN_004bbb3e, .text + (0x004bbb3e - 0x401000)
.set FUN_004bbe46, .text + (0x004bbe46 - 0x401000)
.set FUN_004bc2aa, .text + (0x004bc2aa - 0x401000)
.set FUN_004be504, .text + (0x004be504 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004bca71 - 0x401000
.globl FUN_004bca71
FUN_004bca71:
    # block 0x004bca71: entry, 17 instruction(s), ends with je to 0x004bcac4 (forward)
    push ebp                                     # 004bca71
    {load} mov ebp, esp                          # 004bca72
    sub esp, 0x1c                                # 004bca74
    push esi                                     # 004bca77
    push edi                                     # 004bca78
    mov dword ptr [ebp - local_4], ecx           # 004bca79
    movsx eax, word ptr [ebp + arg_8]            # 004bca7c
    imul eax, eax, 0x8d                          # 004bca80
    mov ecx, dword ptr [ebp - local_4]           # 004bca86
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004bca89
    mov dword ptr [ecx + field_18], edx          # 004bca8f
    movsx eax, word ptr [ebp + arg_8]            # 004bca92
    imul eax, eax, 0x8d                          # 004bca96
    mov ecx, dword ptr [eax + 0x5bb632]          # 004bca9c
    mov dword ptr [ebp - local_8], ecx           # 004bcaa2
    cmp dword ptr [ebp - local_8], 0x0           # 004bcaa5
    je.d8 L_004bcac4                             # 004bcaa9
    # block 0x004bcaab: entered by fall-through of je at 0x004bcaa9, 2 instruction(s), ends with je to 0x004bd89d (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004bcaab
    je.d32 L_004bd89d                            # 004bcaaf
    # block 0x004bcab5: entered by fall-through of je at 0x004bcaaf, 2 instruction(s), ends with je to 0x004bde1f (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004bcab5
    je.d32 L_004bde1f                            # 004bcab9
    # block 0x004bcabf: entered by fall-through of je at 0x004bcab9, 1 instruction(s), ends with forward jump to 0x004be167
    jmp.d32 L_004be167                           # 004bcabf
L_004bcac4:
    # block 0x004bcac4: entered by je at 0x004bcaa9, 13 instruction(s), calls FUN_004e8d96, ends with je to 0x004bcb08 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bcac4
    mov ax, word ptr [ebp + arg_8]               # 004bcac7
    mov word ptr [edx + field_6], ax             # 004bcacb
    mov ecx, dword ptr [ebp - local_4]           # 004bcacf
    mov dword ptr [ecx + field_34], 0x1          # 004bcad2
    mov dword ptr [0x5bb1ca], 0x1                # 004bcad9
    mov ecx, 0x571442                            # 004bcae3
    call FUN_004e8d96                            # 004bcae8
    mov edx, dword ptr [ebp - local_4]           # 004bcaed
    mov eax, dword ptr [edx + field_18]          # 004bcaf0
    movsx ecx, byte ptr [eax + field_8fd]        # 004bcaf3
    test ecx, ecx                                # 004bcafa
    je.d8 L_004bcb08                             # 004bcafc
    # block 0x004bcafe: entered by fall-through of je at 0x004bcafc, 2 instruction(s), calls FUN_004db870, falls into the block at 0x004bcb08
    mov ecx, 0x5830ce                            # 004bcafe
    call FUN_004db870                            # 004bcb03
L_004bcb08:
    # block 0x004bcb08: entered by je at 0x004bcafc, 165 instruction(s), ends with forward jump to 0x004bcda8
    mov edx, dword ptr [ebp - local_4]           # 004bcb08
    add edx, 0x1dc                               # 004bcb0b
    mov eax, dword ptr [0x583186]                # 004bcb11
    mov dword ptr [edx], eax                     # 004bcb16
    mov ecx, dword ptr [0x58318a]                # 004bcb18
    mov dword ptr [edx + field_4], ecx           # 004bcb1e
    mov eax, dword ptr [0x58318e]                # 004bcb21
    mov dword ptr [edx + field_8], eax           # 004bcb26
    mov ecx, dword ptr [0x583192]                # 004bcb29
    mov dword ptr [edx + field_c], ecx           # 004bcb2f
    mov edx, dword ptr [ebp - local_4]           # 004bcb32
    mov eax, dword ptr [ebp - local_4]           # 004bcb35
    mov ecx, dword ptr [edx + field_1e4]         # 004bcb38
    sub ecx, dword ptr [eax + field_1dc]         # 004bcb3e
    add ecx, 0x1                                 # 004bcb44
    mov edx, dword ptr [ebp - local_4]           # 004bcb47
    mov dword ptr [edx + field_1ec], ecx         # 004bcb4a
    mov eax, dword ptr [ebp - local_4]           # 004bcb50
    mov ecx, dword ptr [ebp - local_4]           # 004bcb53
    mov edx, dword ptr [eax + field_1e8]         # 004bcb56
    sub edx, dword ptr [ecx + field_1e0]         # 004bcb5c
    add edx, 0x1                                 # 004bcb62
    mov eax, dword ptr [ebp - local_4]           # 004bcb65
    mov dword ptr [eax + field_1f0], edx         # 004bcb68
    mov ecx, dword ptr [ebp - local_4]           # 004bcb6e
    add ecx, 0x1dc                               # 004bcb71
    mov edx, dword ptr [ebp - local_4]           # 004bcb77
    add edx, 0x58                                # 004bcb7a
    mov eax, dword ptr [ecx]                     # 004bcb7d
    mov dword ptr [edx], eax                     # 004bcb7f
    mov eax, dword ptr [ecx + field_4]           # 004bcb81
    mov dword ptr [edx + field_4], eax           # 004bcb84
    mov eax, dword ptr [ecx + field_8]           # 004bcb87
    mov dword ptr [edx + field_8], eax           # 004bcb8a
    mov ecx, dword ptr [ecx + field_c]           # 004bcb8d
    mov dword ptr [edx + field_c], ecx           # 004bcb90
    mov edx, dword ptr [ebp - local_4]           # 004bcb93
    mov eax, dword ptr [edx + field_18]          # 004bcb96
    mov ecx, dword ptr [ebp - local_4]           # 004bcb99
    mov edx, dword ptr [ecx + field_18]          # 004bcb9c
    mov eax, dword ptr [eax + field_814]         # 004bcb9f
    sub eax, dword ptr [edx + field_80c]         # 004bcba5
    add eax, 0x1                                 # 004bcbab
    mov ecx, dword ptr [ebp - local_4]           # 004bcbae
    mov dword ptr [ecx + field_184], eax         # 004bcbb1
    mov edx, dword ptr [ebp - local_4]           # 004bcbb7
    mov eax, dword ptr [edx + field_18]          # 004bcbba
    mov ecx, dword ptr [ebp - local_4]           # 004bcbbd
    mov edx, dword ptr [ecx + field_18]          # 004bcbc0
    mov eax, dword ptr [eax + field_818]         # 004bcbc3
    sub eax, dword ptr [edx + field_810]         # 004bcbc9
    add eax, 0x1                                 # 004bcbcf
    mov ecx, dword ptr [ebp - local_4]           # 004bcbd2
    mov dword ptr [ecx + field_188], eax         # 004bcbd5
    mov edx, dword ptr [ebp - local_4]           # 004bcbdb
    mov eax, dword ptr [edx + field_18]          # 004bcbde
    mov ecx, dword ptr [ebp - local_4]           # 004bcbe1
    mov edx, dword ptr [ecx + field_18]          # 004bcbe4
    mov eax, dword ptr [eax + field_8c]          # 004bcbe7
    sub eax, dword ptr [edx + field_84]          # 004bcbed
    add eax, 0x1                                 # 004bcbf3
    mov ecx, dword ptr [ebp - local_4]           # 004bcbf6
    mov dword ptr [ecx + field_18c], eax         # 004bcbf9
    mov edx, dword ptr [ebp - local_4]           # 004bcbff
    mov eax, dword ptr [edx + field_18]          # 004bcc02
    mov ecx, dword ptr [ebp - local_4]           # 004bcc05
    mov edx, dword ptr [ecx + field_18]          # 004bcc08
    mov eax, dword ptr [eax + field_90]          # 004bcc0b
    sub eax, dword ptr [edx + field_88]          # 004bcc11
    add eax, 0x1                                 # 004bcc17
    mov ecx, dword ptr [ebp - local_4]           # 004bcc1a
    mov dword ptr [ecx + field_190], eax         # 004bcc1d
    mov edx, dword ptr [ebp - local_4]           # 004bcc23
    mov eax, dword ptr [edx + field_18c]         # 004bcc26
    cdq                                          # 004bcc2c
    {load} sub eax, edx                          # 004bcc2d
    sar eax                                      # 004bcc2f
    mov ecx, dword ptr [ebp - local_4]           # 004bcc31
    mov dword ptr [ecx + field_194], eax         # 004bcc34
    mov edx, dword ptr [ebp - local_4]           # 004bcc3a
    mov eax, dword ptr [edx + field_18]          # 004bcc3d
    mov ecx, dword ptr [ebp - local_4]           # 004bcc40
    mov edx, dword ptr [ecx + field_18]          # 004bcc43
    mov eax, dword ptr [eax + field_70c]         # 004bcc46
    sub eax, dword ptr [edx + field_704]         # 004bcc4c
    add eax, 0x1                                 # 004bcc52
    mov ecx, dword ptr [ebp - local_4]           # 004bcc55
    mov dword ptr [ecx + field_198], eax         # 004bcc58
    mov edx, dword ptr [ebp - local_4]           # 004bcc5e
    mov eax, dword ptr [edx + field_18]          # 004bcc61
    mov ecx, dword ptr [ebp - local_4]           # 004bcc64
    mov edx, dword ptr [ecx + field_18]          # 004bcc67
    mov eax, dword ptr [eax + field_710]         # 004bcc6a
    sub eax, dword ptr [edx + field_708]         # 004bcc70
    add eax, 0x1                                 # 004bcc76
    mov ecx, dword ptr [ebp - local_4]           # 004bcc79
    mov dword ptr [ecx + field_19c], eax         # 004bcc7c
    mov edx, dword ptr [ebp - local_4]           # 004bcc82
    mov eax, dword ptr [edx + field_18]          # 004bcc85
    mov ecx, dword ptr [ebp - local_4]           # 004bcc88
    mov edx, dword ptr [ecx + field_18]          # 004bcc8b
    mov eax, dword ptr [eax + field_790]         # 004bcc8e
    sub eax, dword ptr [edx + field_78c]         # 004bcc94
    add eax, 0x1                                 # 004bcc9a
    mov ecx, dword ptr [ebp - local_4]           # 004bcc9d
    mov dword ptr [ecx + field_318], eax         # 004bcca0
    mov edx, dword ptr [ebp - local_4]           # 004bcca6
    mov eax, dword ptr [edx + field_18]          # 004bcca9
    mov ecx, dword ptr [eax + field_79c]         # 004bccac
    mov edx, dword ptr [ebp - local_4]           # 004bccb2
    add ecx, dword ptr [edx + field_1dc]         # 004bccb5
    mov eax, dword ptr [ebp - local_4]           # 004bccbb
    mov dword ptr [eax + field_68], ecx          # 004bccbe
    mov ecx, dword ptr [ebp - local_4]           # 004bccc1
    mov edx, dword ptr [ecx + field_18]          # 004bccc4
    mov eax, dword ptr [edx + field_7a4]         # 004bccc7
    mov ecx, dword ptr [ebp - local_4]           # 004bcccd
    add eax, dword ptr [ecx + field_1dc]         # 004bccd0
    mov edx, dword ptr [ebp - local_4]           # 004bccd6
    mov dword ptr [edx + field_70], eax          # 004bccd9
    mov eax, dword ptr [ebp - local_4]           # 004bccdc
    mov ecx, dword ptr [eax + field_18]          # 004bccdf
    mov edx, dword ptr [ecx + field_7a0]         # 004bcce2
    mov eax, dword ptr [ebp - local_4]           # 004bcce8
    add edx, dword ptr [eax + field_1e0]         # 004bcceb
    mov ecx, dword ptr [ebp - local_4]           # 004bccf1
    mov dword ptr [ecx + field_6c], edx          # 004bccf4
    mov edx, dword ptr [ebp - local_4]           # 004bccf7
    mov eax, dword ptr [edx + field_18]          # 004bccfa
    mov ecx, dword ptr [eax + field_7a8]         # 004bccfd
    mov edx, dword ptr [ebp - local_4]           # 004bcd03
    add ecx, dword ptr [edx + field_1e0]         # 004bcd06
    mov eax, dword ptr [ebp - local_4]           # 004bcd0c
    mov dword ptr [eax + field_74], ecx          # 004bcd0f
    mov ecx, dword ptr [ebp - local_4]           # 004bcd12
    mov edx, dword ptr [ecx + field_18]          # 004bcd15
    mov eax, dword ptr [edx + field_7ac]         # 004bcd18
    mov ecx, dword ptr [ebp - local_4]           # 004bcd1e
    add eax, dword ptr [ecx + field_1dc]         # 004bcd21
    mov edx, dword ptr [ebp - local_4]           # 004bcd27
    mov dword ptr [edx + field_78], eax          # 004bcd2a
    mov eax, dword ptr [ebp - local_4]           # 004bcd2d
    mov ecx, dword ptr [eax + field_18]          # 004bcd30
    mov edx, dword ptr [ecx + field_7b4]         # 004bcd33
    mov eax, dword ptr [ebp - local_4]           # 004bcd39
    add edx, dword ptr [eax + field_1dc]         # 004bcd3c
    mov ecx, dword ptr [ebp - local_4]           # 004bcd42
    mov dword ptr [ecx + field_80], edx          # 004bcd45
    mov edx, dword ptr [ebp - local_4]           # 004bcd4b
    mov eax, dword ptr [edx + field_18]          # 004bcd4e
    mov ecx, dword ptr [eax + field_7b0]         # 004bcd51
    mov edx, dword ptr [ebp - local_4]           # 004bcd57
    add ecx, dword ptr [edx + field_1e0]         # 004bcd5a
    mov eax, dword ptr [ebp - local_4]           # 004bcd60
    mov dword ptr [eax + field_7c], ecx          # 004bcd63
    mov ecx, dword ptr [ebp - local_4]           # 004bcd66
    mov edx, dword ptr [ecx + field_18]          # 004bcd69
    mov eax, dword ptr [edx + field_7b8]         # 004bcd6c
    mov ecx, dword ptr [ebp - local_4]           # 004bcd72
    add eax, dword ptr [ecx + field_1e0]         # 004bcd75
    mov edx, dword ptr [ebp - local_4]           # 004bcd7b
    mov dword ptr [edx + field_84], eax          # 004bcd7e
    mov eax, dword ptr [ebp - local_4]           # 004bcd84
    mov dword ptr [eax + field_310], 0x0         # 004bcd87
    jmp.d8 L_004bcda8                            # 004bcd91
L_004bcd93:
    # block 0x004bcd93: entered by jmp at 0x004bce98, 5 instruction(s), falls into the block at 0x004bcda8
    mov ecx, dword ptr [ebp - local_4]           # 004bcd93
    mov edx, dword ptr [ecx + field_310]         # 004bcd96
    add edx, 0x1                                 # 004bcd9c
    mov eax, dword ptr [ebp - local_4]           # 004bcd9f
    mov dword ptr [eax + field_310], edx         # 004bcda2
L_004bcda8:
    # block 0x004bcda8: entered by jmp at 0x004bcd91, 3 instruction(s), ends with jge to 0x004bce9d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bcda8
    cmp dword ptr [ecx + field_310], 0x3         # 004bcdab
    jge.d32 L_004bce9d                           # 004bcdb2
    # block 0x004bcdb8: entered by fall-through of jge at 0x004bcdb2, 53 instruction(s), ends with backward jump to 0x004bcd93
    mov edx, dword ptr [ebp - local_4]           # 004bcdb8
    mov eax, dword ptr [edx + field_18]          # 004bcdbb
    mov ecx, dword ptr [ebp - local_4]           # 004bcdbe
    mov edx, dword ptr [ecx + field_310]         # 004bcdc1
    shl edx, 0x4                                 # 004bcdc7
    mov eax, dword ptr [eax + edx + field_7bc]   # 004bcdca
    mov ecx, dword ptr [ebp - local_4]           # 004bcdd1
    add eax, dword ptr [ecx + field_1dc]         # 004bcdd4
    mov edx, dword ptr [ebp - local_4]           # 004bcdda
    mov ecx, dword ptr [edx + field_310]         # 004bcddd
    shl ecx, 0x4                                 # 004bcde3
    mov edx, dword ptr [ebp - local_4]           # 004bcde6
    mov dword ptr [edx + ecx + field_88], eax    # 004bcde9
    mov eax, dword ptr [ebp - local_4]           # 004bcdf0
    mov ecx, dword ptr [eax + field_18]          # 004bcdf3
    mov edx, dword ptr [ebp - local_4]           # 004bcdf6
    mov eax, dword ptr [edx + field_310]         # 004bcdf9
    shl eax, 0x4                                 # 004bcdff
    mov ecx, dword ptr [ecx + eax + field_7c4]   # 004bce02
    mov edx, dword ptr [ebp - local_4]           # 004bce09
    add ecx, dword ptr [edx + field_1dc]         # 004bce0c
    mov eax, dword ptr [ebp - local_4]           # 004bce12
    mov edx, dword ptr [eax + field_310]         # 004bce15
    shl edx, 0x4                                 # 004bce1b
    mov eax, dword ptr [ebp - local_4]           # 004bce1e
    mov dword ptr [eax + edx + field_90], ecx    # 004bce21
    mov ecx, dword ptr [ebp - local_4]           # 004bce28
    mov edx, dword ptr [ecx + field_18]          # 004bce2b
    mov eax, dword ptr [ebp - local_4]           # 004bce2e
    mov ecx, dword ptr [eax + field_310]         # 004bce31
    shl ecx, 0x4                                 # 004bce37
    mov edx, dword ptr [edx + ecx + field_7c0]   # 004bce3a
    mov eax, dword ptr [ebp - local_4]           # 004bce41
    add edx, dword ptr [eax + field_1e0]         # 004bce44
    mov ecx, dword ptr [ebp - local_4]           # 004bce4a
    mov eax, dword ptr [ecx + field_310]         # 004bce4d
    shl eax, 0x4                                 # 004bce53
    mov ecx, dword ptr [ebp - local_4]           # 004bce56
    mov dword ptr [ecx + eax + field_8c], edx    # 004bce59
    mov edx, dword ptr [ebp - local_4]           # 004bce60
    mov eax, dword ptr [edx + field_18]          # 004bce63
    mov ecx, dword ptr [ebp - local_4]           # 004bce66
    mov edx, dword ptr [ecx + field_310]         # 004bce69
    shl edx, 0x4                                 # 004bce6f
    mov eax, dword ptr [eax + edx + field_7c8]   # 004bce72
    mov ecx, dword ptr [ebp - local_4]           # 004bce79
    add eax, dword ptr [ecx + field_1e0]         # 004bce7c
    mov edx, dword ptr [ebp - local_4]           # 004bce82
    mov ecx, dword ptr [edx + field_310]         # 004bce85
    shl ecx, 0x4                                 # 004bce8b
    mov edx, dword ptr [ebp - local_4]           # 004bce8e
    mov dword ptr [edx + ecx + field_94], eax    # 004bce91
    jmp.d32 L_004bcd93                           # 004bce98
L_004bce9d:
    # block 0x004bce9d: entered by jge at 0x004bcdb2, 3 instruction(s), ends with forward jump to 0x004bcec1
    mov eax, dword ptr [ebp - local_4]           # 004bce9d
    mov dword ptr [eax + field_310], 0x0         # 004bcea0
    jmp.d8 L_004bcec1                            # 004bceaa
L_004bceac:
    # block 0x004bceac: entered by jmp at 0x004bcfb1, 5 instruction(s), falls into the block at 0x004bcec1
    mov ecx, dword ptr [ebp - local_4]           # 004bceac
    mov edx, dword ptr [ecx + field_310]         # 004bceaf
    add edx, 0x1                                 # 004bceb5
    mov eax, dword ptr [ebp - local_4]           # 004bceb8
    mov dword ptr [eax + field_310], edx         # 004bcebb
L_004bcec1:
    # block 0x004bcec1: entered by jmp at 0x004bceaa, 3 instruction(s), ends with jge to 0x004bcfb6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bcec1
    cmp dword ptr [ecx + field_310], 0x2         # 004bcec4
    jge.d32 L_004bcfb6                           # 004bcecb
    # block 0x004bced1: entered by fall-through of jge at 0x004bcecb, 53 instruction(s), ends with backward jump to 0x004bceac
    mov edx, dword ptr [ebp - local_4]           # 004bced1
    mov eax, dword ptr [edx + field_18]          # 004bced4
    mov ecx, dword ptr [ebp - local_4]           # 004bced7
    mov edx, dword ptr [ecx + field_310]         # 004bceda
    shl edx, 0x4                                 # 004bcee0
    mov eax, dword ptr [eax + edx + field_7ec]   # 004bcee3
    mov ecx, dword ptr [ebp - local_4]           # 004bceea
    add eax, dword ptr [ecx + field_1dc]         # 004bceed
    mov edx, dword ptr [ebp - local_4]           # 004bcef3
    mov ecx, dword ptr [edx + field_310]         # 004bcef6
    shl ecx, 0x4                                 # 004bcefc
    mov edx, dword ptr [ebp - local_4]           # 004bceff
    mov dword ptr [edx + ecx + field_b8], eax    # 004bcf02
    mov eax, dword ptr [ebp - local_4]           # 004bcf09
    mov ecx, dword ptr [eax + field_18]          # 004bcf0c
    mov edx, dword ptr [ebp - local_4]           # 004bcf0f
    mov eax, dword ptr [edx + field_310]         # 004bcf12
    shl eax, 0x4                                 # 004bcf18
    mov ecx, dword ptr [ecx + eax + field_7f4]   # 004bcf1b
    mov edx, dword ptr [ebp - local_4]           # 004bcf22
    add ecx, dword ptr [edx + field_1dc]         # 004bcf25
    mov eax, dword ptr [ebp - local_4]           # 004bcf2b
    mov edx, dword ptr [eax + field_310]         # 004bcf2e
    shl edx, 0x4                                 # 004bcf34
    mov eax, dword ptr [ebp - local_4]           # 004bcf37
    mov dword ptr [eax + edx + field_c0], ecx    # 004bcf3a
    mov ecx, dword ptr [ebp - local_4]           # 004bcf41
    mov edx, dword ptr [ecx + field_18]          # 004bcf44
    mov eax, dword ptr [ebp - local_4]           # 004bcf47
    mov ecx, dword ptr [eax + field_310]         # 004bcf4a
    shl ecx, 0x4                                 # 004bcf50
    mov edx, dword ptr [edx + ecx + field_7f0]   # 004bcf53
    mov eax, dword ptr [ebp - local_4]           # 004bcf5a
    add edx, dword ptr [eax + field_1e0]         # 004bcf5d
    mov ecx, dword ptr [ebp - local_4]           # 004bcf63
    mov eax, dword ptr [ecx + field_310]         # 004bcf66
    shl eax, 0x4                                 # 004bcf6c
    mov ecx, dword ptr [ebp - local_4]           # 004bcf6f
    mov dword ptr [ecx + eax + field_bc], edx    # 004bcf72
    mov edx, dword ptr [ebp - local_4]           # 004bcf79
    mov eax, dword ptr [edx + field_18]          # 004bcf7c
    mov ecx, dword ptr [ebp - local_4]           # 004bcf7f
    mov edx, dword ptr [ecx + field_310]         # 004bcf82
    shl edx, 0x4                                 # 004bcf88
    mov eax, dword ptr [eax + edx + field_7f8]   # 004bcf8b
    mov ecx, dword ptr [ebp - local_4]           # 004bcf92
    add eax, dword ptr [ecx + field_1e0]         # 004bcf95
    mov edx, dword ptr [ebp - local_4]           # 004bcf9b
    mov ecx, dword ptr [edx + field_310]         # 004bcf9e
    shl ecx, 0x4                                 # 004bcfa4
    mov edx, dword ptr [ebp - local_4]           # 004bcfa7
    mov dword ptr [edx + ecx + field_c4], eax    # 004bcfaa
    jmp.d32 L_004bceac                           # 004bcfb1
L_004bcfb6:
    # block 0x004bcfb6: entered by jge at 0x004bcecb, 77 instruction(s), ends with forward jump to 0x004bd112
    mov eax, dword ptr [ebp - local_4]           # 004bcfb6
    mov ecx, dword ptr [eax + field_18]          # 004bcfb9
    mov edx, dword ptr [ecx + field_80c]         # 004bcfbc
    mov eax, dword ptr [ebp - local_4]           # 004bcfc2
    add edx, dword ptr [eax + field_1dc]         # 004bcfc5
    mov ecx, dword ptr [ebp - local_4]           # 004bcfcb
    mov dword ptr [ecx + field_d8], edx          # 004bcfce
    mov edx, dword ptr [ebp - local_4]           # 004bcfd4
    mov eax, dword ptr [edx + field_18]          # 004bcfd7
    mov ecx, dword ptr [eax + field_814]         # 004bcfda
    mov edx, dword ptr [ebp - local_4]           # 004bcfe0
    add ecx, dword ptr [edx + field_1dc]         # 004bcfe3
    mov eax, dword ptr [ebp - local_4]           # 004bcfe9
    mov dword ptr [eax + field_e0], ecx          # 004bcfec
    mov ecx, dword ptr [ebp - local_4]           # 004bcff2
    mov edx, dword ptr [ecx + field_18]          # 004bcff5
    mov eax, dword ptr [edx + field_810]         # 004bcff8
    mov ecx, dword ptr [ebp - local_4]           # 004bcffe
    add eax, dword ptr [ecx + field_1e0]         # 004bd001
    mov edx, dword ptr [ebp - local_4]           # 004bd007
    mov dword ptr [edx + field_dc], eax          # 004bd00a
    mov eax, dword ptr [ebp - local_4]           # 004bd010
    mov ecx, dword ptr [eax + field_18]          # 004bd013
    mov edx, dword ptr [ecx + field_818]         # 004bd016
    mov eax, dword ptr [ebp - local_4]           # 004bd01c
    add edx, dword ptr [eax + field_1e0]         # 004bd01f
    mov ecx, dword ptr [ebp - local_4]           # 004bd025
    mov dword ptr [ecx + field_e4], edx          # 004bd028
    mov edx, dword ptr [ebp - local_4]           # 004bd02e
    mov eax, dword ptr [edx + field_18]          # 004bd031
    mov ecx, dword ptr [ebp - local_4]           # 004bd034
    mov edx, dword ptr [ecx + field_18]          # 004bd037
    mov eax, dword ptr [eax + field_814]         # 004bd03a
    sub eax, dword ptr [edx + field_80c]         # 004bd040
    add eax, 0x1                                 # 004bd046
    mov ecx, dword ptr [ebp - local_4]           # 004bd049
    mov dword ptr [ecx + field_168], eax         # 004bd04c
    mov edx, dword ptr [ebp - local_4]           # 004bd052
    mov eax, dword ptr [edx + field_18]          # 004bd055
    mov ecx, dword ptr [ebp - local_4]           # 004bd058
    mov edx, dword ptr [ecx + field_18]          # 004bd05b
    mov eax, dword ptr [eax + field_818]         # 004bd05e
    sub eax, dword ptr [edx + field_810]         # 004bd064
    add eax, 0x1                                 # 004bd06a
    mov ecx, dword ptr [ebp - local_4]           # 004bd06d
    mov dword ptr [ecx + field_16c], eax         # 004bd070
    mov edx, dword ptr [ebp - local_4]           # 004bd076
    mov eax, dword ptr [edx + field_18]          # 004bd079
    mov ecx, dword ptr [eax + field_81c]         # 004bd07c
    mov edx, dword ptr [ebp - local_4]           # 004bd082
    add ecx, dword ptr [edx + field_1dc]         # 004bd085
    mov eax, dword ptr [ebp - local_4]           # 004bd08b
    mov dword ptr [eax + field_e8], ecx          # 004bd08e
    mov ecx, dword ptr [ebp - local_4]           # 004bd094
    mov edx, dword ptr [ecx + field_18]          # 004bd097
    mov eax, dword ptr [edx + field_824]         # 004bd09a
    mov ecx, dword ptr [ebp - local_4]           # 004bd0a0
    add eax, dword ptr [ecx + field_1dc]         # 004bd0a3
    mov edx, dword ptr [ebp - local_4]           # 004bd0a9
    mov dword ptr [edx + field_f0], eax          # 004bd0ac
    mov eax, dword ptr [ebp - local_4]           # 004bd0b2
    mov ecx, dword ptr [eax + field_18]          # 004bd0b5
    mov edx, dword ptr [ecx + field_820]         # 004bd0b8
    mov eax, dword ptr [ebp - local_4]           # 004bd0be
    add edx, dword ptr [eax + field_1e0]         # 004bd0c1
    mov ecx, dword ptr [ebp - local_4]           # 004bd0c7
    mov dword ptr [ecx + field_ec], edx          # 004bd0ca
    mov edx, dword ptr [ebp - local_4]           # 004bd0d0
    mov eax, dword ptr [edx + field_18]          # 004bd0d3
    mov ecx, dword ptr [eax + field_828]         # 004bd0d6
    mov edx, dword ptr [ebp - local_4]           # 004bd0dc
    add ecx, dword ptr [edx + field_1e0]         # 004bd0df
    mov eax, dword ptr [ebp - local_4]           # 004bd0e5
    mov dword ptr [eax + field_f4], ecx          # 004bd0e8
    mov ecx, dword ptr [ebp - local_4]           # 004bd0ee
    mov dword ptr [ecx + field_310], 0x0         # 004bd0f1
    jmp.d8 L_004bd112                            # 004bd0fb
L_004bd0fd:
    # block 0x004bd0fd: entered by jmp at 0x004bd202, 5 instruction(s), falls into the block at 0x004bd112
    mov edx, dword ptr [ebp - local_4]           # 004bd0fd
    mov eax, dword ptr [edx + field_310]         # 004bd100
    add eax, 0x1                                 # 004bd106
    mov ecx, dword ptr [ebp - local_4]           # 004bd109
    mov dword ptr [ecx + field_310], eax         # 004bd10c
L_004bd112:
    # block 0x004bd112: entered by jmp at 0x004bd0fb, 3 instruction(s), ends with jge to 0x004bd207 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bd112
    cmp dword ptr [edx + field_310], 0x7         # 004bd115
    jge.d32 L_004bd207                           # 004bd11c
    # block 0x004bd122: entered by fall-through of jge at 0x004bd11c, 53 instruction(s), ends with backward jump to 0x004bd0fd
    mov eax, dword ptr [ebp - local_4]           # 004bd122
    mov ecx, dword ptr [eax + field_18]          # 004bd125
    mov edx, dword ptr [ebp - local_4]           # 004bd128
    mov eax, dword ptr [edx + field_310]         # 004bd12b
    shl eax, 0x4                                 # 004bd131
    mov ecx, dword ptr [ecx + eax + field_82c]   # 004bd134
    mov edx, dword ptr [ebp - local_4]           # 004bd13b
    add ecx, dword ptr [edx + field_1dc]         # 004bd13e
    mov eax, dword ptr [ebp - local_4]           # 004bd144
    mov edx, dword ptr [eax + field_310]         # 004bd147
    shl edx, 0x4                                 # 004bd14d
    mov eax, dword ptr [ebp - local_4]           # 004bd150
    mov dword ptr [eax + edx + field_f8], ecx    # 004bd153
    mov ecx, dword ptr [ebp - local_4]           # 004bd15a
    mov edx, dword ptr [ecx + field_18]          # 004bd15d
    mov eax, dword ptr [ebp - local_4]           # 004bd160
    mov ecx, dword ptr [eax + field_310]         # 004bd163
    shl ecx, 0x4                                 # 004bd169
    mov edx, dword ptr [edx + ecx + field_834]   # 004bd16c
    mov eax, dword ptr [ebp - local_4]           # 004bd173
    add edx, dword ptr [eax + field_1dc]         # 004bd176
    mov ecx, dword ptr [ebp - local_4]           # 004bd17c
    mov eax, dword ptr [ecx + field_310]         # 004bd17f
    shl eax, 0x4                                 # 004bd185
    mov ecx, dword ptr [ebp - local_4]           # 004bd188
    mov dword ptr [ecx + eax + field_100], edx   # 004bd18b
    mov edx, dword ptr [ebp - local_4]           # 004bd192
    mov eax, dword ptr [edx + field_18]          # 004bd195
    mov ecx, dword ptr [ebp - local_4]           # 004bd198
    mov edx, dword ptr [ecx + field_310]         # 004bd19b
    shl edx, 0x4                                 # 004bd1a1
    mov eax, dword ptr [eax + edx + field_830]   # 004bd1a4
    mov ecx, dword ptr [ebp - local_4]           # 004bd1ab
    add eax, dword ptr [ecx + field_1e0]         # 004bd1ae
    mov edx, dword ptr [ebp - local_4]           # 004bd1b4
    mov ecx, dword ptr [edx + field_310]         # 004bd1b7
    shl ecx, 0x4                                 # 004bd1bd
    mov edx, dword ptr [ebp - local_4]           # 004bd1c0
    mov dword ptr [edx + ecx + field_fc], eax    # 004bd1c3
    mov eax, dword ptr [ebp - local_4]           # 004bd1ca
    mov ecx, dword ptr [eax + field_18]          # 004bd1cd
    mov edx, dword ptr [ebp - local_4]           # 004bd1d0
    mov eax, dword ptr [edx + field_310]         # 004bd1d3
    shl eax, 0x4                                 # 004bd1d9
    mov ecx, dword ptr [ecx + eax + field_838]   # 004bd1dc
    mov edx, dword ptr [ebp - local_4]           # 004bd1e3
    add ecx, dword ptr [edx + field_1e0]         # 004bd1e6
    mov eax, dword ptr [ebp - local_4]           # 004bd1ec
    mov edx, dword ptr [eax + field_310]         # 004bd1ef
    shl edx, 0x4                                 # 004bd1f5
    mov eax, dword ptr [ebp - local_4]           # 004bd1f8
    mov dword ptr [eax + edx + field_104], ecx   # 004bd1fb
    jmp.d32 L_004bd0fd                           # 004bd202
L_004bd207:
    # block 0x004bd207: entered by jge at 0x004bd11c, 91 instruction(s), calls FUN_004d39f9, ends with jne to 0x004bd3a6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bd207
    mov edx, dword ptr [ecx + field_18]          # 004bd20a
    mov eax, dword ptr [edx + field_784]         # 004bd20d
    mov ecx, dword ptr [ebp - local_4]           # 004bd213
    add eax, dword ptr [ecx + field_1e0]         # 004bd216
    mov edx, dword ptr [ebp - local_4]           # 004bd21c
    mov dword ptr [edx + field_174], eax         # 004bd21f
    mov eax, dword ptr [ebp - local_4]           # 004bd225
    mov ecx, dword ptr [eax + field_18]          # 004bd228
    mov edx, dword ptr [ecx + field_788]         # 004bd22b
    mov eax, dword ptr [ebp - local_4]           # 004bd231
    add edx, dword ptr [eax + field_1e0]         # 004bd234
    mov ecx, dword ptr [ebp - local_4]           # 004bd23a
    mov dword ptr [ecx + field_178], edx         # 004bd23d
    mov edx, dword ptr [ebp - local_4]           # 004bd243
    mov eax, dword ptr [edx + field_18]          # 004bd246
    mov ecx, dword ptr [eax + field_78c]         # 004bd249
    mov edx, dword ptr [ebp - local_4]           # 004bd24f
    add ecx, dword ptr [edx + field_1e0]         # 004bd252
    mov eax, dword ptr [ebp - local_4]           # 004bd258
    mov dword ptr [eax + field_17c], ecx         # 004bd25b
    mov ecx, dword ptr [ebp - local_4]           # 004bd261
    mov edx, dword ptr [ecx + field_18]          # 004bd264
    mov eax, dword ptr [edx + field_790]         # 004bd267
    mov ecx, dword ptr [ebp - local_4]           # 004bd26d
    add eax, dword ptr [ecx + field_1e0]         # 004bd270
    mov edx, dword ptr [ebp - local_4]           # 004bd276
    mov dword ptr [edx + field_180], eax         # 004bd279
    mov eax, dword ptr [ebp - local_4]           # 004bd27f
    mov ecx, dword ptr [eax + field_18]          # 004bd282
    mov edx, dword ptr [ecx + field_798]         # 004bd285
    mov eax, dword ptr [ebp - local_4]           # 004bd28b
    add edx, dword ptr [eax + field_1e0]         # 004bd28e
    mov ecx, dword ptr [ebp - local_4]           # 004bd294
    mov dword ptr [ecx + field_170], edx         # 004bd297
    call FUN_004d39f9                            # 004bd29d
    mov edx, dword ptr [ebp - local_4]           # 004bd2a2
    mov word ptr [edx + field_4], ax             # 004bd2a5
    mov eax, dword ptr [ebp - local_4]           # 004bd2a9
    movsx ecx, word ptr [eax + field_4]          # 004bd2ac
    imul ecx, ecx, 0x4a                          # 004bd2b0
    mov dword ptr [ecx + 0x5d1591], 0xb          # 004bd2b3
    mov edx, dword ptr [ebp - local_4]           # 004bd2bd
    movsx eax, word ptr [edx + field_4]          # 004bd2c0
    imul eax, eax, 0x4a                          # 004bd2c4
    mov dword ptr [eax + 0x5d1595], 0x4be6a4     # 004bd2c7
    mov ecx, dword ptr [ebp - local_4]           # 004bd2d1
    movsx edx, word ptr [ecx + field_4]          # 004bd2d4
    imul edx, edx, 0x4a                          # 004bd2d8
    mov dword ptr [edx + 0x5d1599], 0x0          # 004bd2db
    mov eax, dword ptr [ebp - local_4]           # 004bd2e5
    movsx ecx, word ptr [eax + field_4]          # 004bd2e8
    imul ecx, ecx, 0x4a                          # 004bd2ec
    mov dword ptr [ecx + 0x5d159d], 0x0          # 004bd2ef
    mov edx, dword ptr [ebp - local_4]           # 004bd2f9
    movsx eax, word ptr [edx + field_4]          # 004bd2fc
    imul eax, eax, 0x4a                          # 004bd300
    mov dword ptr [eax + 0x5d15a1], 0x0          # 004bd303
    mov ecx, dword ptr [ebp - local_4]           # 004bd30d
    movsx edx, word ptr [ecx + field_4]          # 004bd310
    imul edx, edx, 0x4a                          # 004bd314
    mov dword ptr [edx + 0x5d15a5], 0x1          # 004bd317
    mov eax, dword ptr [ebp - local_4]           # 004bd321
    movsx ecx, word ptr [eax + field_4]          # 004bd324
    imul ecx, ecx, 0x4a                          # 004bd328
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 004bd32b
    mov edx, dword ptr [ebp - local_4]           # 004bd335
    movsx eax, word ptr [edx + field_4]          # 004bd338
    imul eax, eax, 0x4a                          # 004bd33c
    mov word ptr [eax + 0x5d15ad], 0x0           # 004bd33f
    mov edi, 0x551fa0                            # 004bd348
    mov ecx, dword ptr [ebp - local_4]           # 004bd34d
    movsx edx, word ptr [ecx + field_4]          # 004bd350
    imul edx, edx, 0x4a                          # 004bd354
    add edx, 0x5d15b3                            # 004bd357
    or ecx, -0x1                                 # 004bd35d
    {load} xor eax, eax                          # 004bd360
    repne scasb al, byte ptr es:[edi]            # 004bd362
    not ecx                                      # 004bd364
    {load} sub edi, ecx                          # 004bd366
    {load} mov esi, edi                          # 004bd368
    {load} mov eax, ecx                          # 004bd36a
    {load} mov edi, edx                          # 004bd36c
    shr ecx, 0x2                                 # 004bd36e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bd371
    {load} mov ecx, eax                          # 004bd373
    and ecx, 0x3                                 # 004bd375
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bd378
    mov ecx, dword ptr [ebp - local_4]           # 004bd37a
    cmp dword ptr [ecx + field_8], 0x0           # 004bd37d
    jne.d8 L_004bd3a6                            # 004bd381
    # block 0x004bd383: entered by fall-through of jne at 0x004bd381, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004bd3a6
    push 0x551fc4                                # 004bd383
    push 0x6                                     # 004bd388
    mov edx, dword ptr [ebp - local_4]           # 004bd38a
    mov eax, dword ptr [edx + field_18]          # 004bd38d
    push eax                                     # 004bd390
    push 0x551fec                                # 004bd391
    mov ecx, 0x5cf659                            # 004bd396
    call FUN_004c2790                            # 004bd39b
    mov ecx, dword ptr [ebp - local_4]           # 004bd3a0
    mov dword ptr [ecx + field_8], eax           # 004bd3a3
L_004bd3a6:
    # block 0x004bd3a6: entered by jne at 0x004bd381, 9 instruction(s), ends with jne to 0x004bd3eb (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bd3a6
    movsx eax, word ptr [edx + field_4]          # 004bd3a9
    imul eax, eax, 0x4a                          # 004bd3ad
    mov ecx, dword ptr [ebp - local_4]           # 004bd3b0
    mov edx, dword ptr [ecx + field_8]           # 004bd3b3
    mov dword ptr [eax + 0x5d1599], edx          # 004bd3b6
    mov eax, dword ptr [ebp - local_4]           # 004bd3bc
    cmp dword ptr [eax + field_c], 0x0           # 004bd3bf
    jne.d8 L_004bd3eb                            # 004bd3c3
    # block 0x004bd3c5: entered by fall-through of jne at 0x004bd3c3, 11 instruction(s), calls FUN_004c2790, falls into the block at 0x004bd3eb
    push 0x551ff4                                # 004bd3c5
    push 0x6                                     # 004bd3ca
    mov ecx, dword ptr [ebp - local_4]           # 004bd3cc
    mov edx, dword ptr [ecx + field_18]          # 004bd3cf
    add edx, 0x21                                # 004bd3d2
    push edx                                     # 004bd3d5
    push 0x552018                                # 004bd3d6
    mov ecx, 0x5cf659                            # 004bd3db
    call FUN_004c2790                            # 004bd3e0
    mov ecx, dword ptr [ebp - local_4]           # 004bd3e5
    mov dword ptr [ecx + field_c], eax           # 004bd3e8
L_004bd3eb:
    # block 0x004bd3eb: entered by jne at 0x004bd3c3, 3 instruction(s), ends with jne to 0x004bd41a (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bd3eb
    cmp dword ptr [edx + field_10], 0x0          # 004bd3ee
    jne.d8 L_004bd41a                            # 004bd3f2
    # block 0x004bd3f4: entered by fall-through of jne at 0x004bd3f2, 11 instruction(s), calls FUN_004c2790, falls into the block at 0x004bd41a
    push 0x552020                                # 004bd3f4
    push 0x6                                     # 004bd3f9
    mov eax, dword ptr [ebp - local_4]           # 004bd3fb
    mov ecx, dword ptr [eax + field_18]          # 004bd3fe
    add ecx, 0x42                                # 004bd401
    push ecx                                     # 004bd404
    push 0x552048                                # 004bd405
    mov ecx, 0x5cf659                            # 004bd40a
    call FUN_004c2790                            # 004bd40f
    mov edx, dword ptr [ebp - local_4]           # 004bd414
    mov dword ptr [edx + field_10], eax          # 004bd417
L_004bd41a:
    # block 0x004bd41a: entered by jne at 0x004bd3f2, 3 instruction(s), ends with jne to 0x004bd449 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bd41a
    cmp dword ptr [eax + field_14], 0x0          # 004bd41d
    jne.d8 L_004bd449                            # 004bd421
    # block 0x004bd423: entered by fall-through of jne at 0x004bd421, 11 instruction(s), calls FUN_004c2790, falls into the block at 0x004bd449
    push 0x552050                                # 004bd423
    push 0x6                                     # 004bd428
    mov ecx, dword ptr [ebp - local_4]           # 004bd42a
    mov edx, dword ptr [ecx + field_18]          # 004bd42d
    add edx, 0x63                                # 004bd430
    push edx                                     # 004bd433
    push 0x552074                                # 004bd434
    mov ecx, 0x5cf659                            # 004bd439
    call FUN_004c2790                            # 004bd43e
    mov ecx, dword ptr [ebp - local_4]           # 004bd443
    mov dword ptr [ecx + field_14], eax          # 004bd446
L_004bd449:
    # block 0x004bd449: entered by jne at 0x004bd421, 51 instruction(s), calls FUN_004ba13d, FUN_004bc2aa, ends with je to 0x004bd516 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bd449
    call FUN_004ba13d                            # 004bd44c
    mov ecx, dword ptr [ebp - local_4]           # 004bd451
    call FUN_004bc2aa                            # 004bd454
    mov edx, dword ptr [ebp - local_4]           # 004bd459
    mov esi, dword ptr [edx + field_18]          # 004bd45c
    add esi, 0x926                               # 004bd45f
    mov edi, dword ptr [ebp - local_4]           # 004bd465
    add edi, 0x31c                               # 004bd468
    mov ecx, 0xc                                 # 004bd46e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bd473
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bd475
    mov eax, dword ptr [ebp - local_4]           # 004bd476
    mov esi, dword ptr [eax + field_18]          # 004bd479
    add esi, 0x957                               # 004bd47c
    mov edi, dword ptr [ebp - local_4]           # 004bd482
    add edi, 0x34d                               # 004bd485
    mov ecx, 0xc                                 # 004bd48b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bd490
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bd492
    mov ecx, dword ptr [ebp - local_4]           # 004bd493
    mov esi, dword ptr [ecx + field_18]          # 004bd496
    add esi, 0x988                               # 004bd499
    mov edi, dword ptr [ebp - local_4]           # 004bd49f
    add edi, 0x37e                               # 004bd4a2
    mov ecx, 0xc                                 # 004bd4a8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bd4ad
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bd4af
    mov edx, dword ptr [ebp - local_4]           # 004bd4b0
    mov esi, dword ptr [edx + field_18]          # 004bd4b3
    add esi, 0x9b9                               # 004bd4b6
    mov edi, dword ptr [ebp - local_4]           # 004bd4bc
    add edi, 0x3af                               # 004bd4bf
    mov ecx, 0xc                                 # 004bd4c5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bd4ca
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bd4cc
    mov eax, dword ptr [ebp - local_4]           # 004bd4cd
    mov esi, dword ptr [eax + field_18]          # 004bd4d0
    add esi, 0x9ea                               # 004bd4d3
    mov edi, dword ptr [ebp - local_4]           # 004bd4d9
    add edi, 0x411                               # 004bd4dc
    mov ecx, 0xc                                 # 004bd4e2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bd4e7
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bd4e9
    mov edi, 0x55207c                            # 004bd4ea
    mov esi, dword ptr [ebp - local_4]           # 004bd4ef
    add esi, 0x31c                               # 004bd4f2
    mov ecx, 0x9                                 # 004bd4f8
    {load} xor edx, edx                          # 004bd4fd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bd4ff
    je.d8 L_004bd516                             # 004bd501
    # block 0x004bd503: entered by fall-through of je at 0x004bd501, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004bd516
    mov eax, dword ptr [ebp - local_4]           # 004bd503
    add eax, 0x31c                               # 004bd506
    push eax                                     # 004bd50b
    mov ecx, 0x5c3a67                            # 004bd50c
    call FUN_004fb77a                            # 004bd511
L_004bd516:
    # block 0x004bd516: entered by je at 0x004bd501, 7 instruction(s), ends with je to 0x004bd542 (forward)
    mov edi, 0x552088                            # 004bd516
    mov esi, dword ptr [ebp - local_4]           # 004bd51b
    add esi, 0x34d                               # 004bd51e
    mov ecx, 0x9                                 # 004bd524
    {load} xor edx, edx                          # 004bd529
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bd52b
    je.d8 L_004bd542                             # 004bd52d
    # block 0x004bd52f: entered by fall-through of je at 0x004bd52d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004bd542
    mov eax, dword ptr [ebp - local_4]           # 004bd52f
    add eax, 0x34d                               # 004bd532
    push eax                                     # 004bd537
    mov ecx, 0x5c3a67                            # 004bd538
    call FUN_004fb77a                            # 004bd53d
L_004bd542:
    # block 0x004bd542: entered by je at 0x004bd52d, 7 instruction(s), ends with je to 0x004bd56e (forward)
    mov edi, 0x552094                            # 004bd542
    mov esi, dword ptr [ebp - local_4]           # 004bd547
    add esi, 0x37e                               # 004bd54a
    mov ecx, 0x9                                 # 004bd550
    {load} xor edx, edx                          # 004bd555
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bd557
    je.d8 L_004bd56e                             # 004bd559
    # block 0x004bd55b: entered by fall-through of je at 0x004bd559, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004bd56e
    mov eax, dword ptr [ebp - local_4]           # 004bd55b
    add eax, 0x37e                               # 004bd55e
    push eax                                     # 004bd563
    mov ecx, 0x5c3a67                            # 004bd564
    call FUN_004fb77a                            # 004bd569
L_004bd56e:
    # block 0x004bd56e: entered by je at 0x004bd559, 7 instruction(s), ends with je to 0x004bd59a (forward)
    mov edi, 0x5520a0                            # 004bd56e
    mov esi, dword ptr [ebp - local_4]           # 004bd573
    add esi, 0x3af                               # 004bd576
    mov ecx, 0x9                                 # 004bd57c
    {load} xor edx, edx                          # 004bd581
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bd583
    je.d8 L_004bd59a                             # 004bd585
    # block 0x004bd587: entered by fall-through of je at 0x004bd585, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004bd59a
    mov eax, dword ptr [ebp - local_4]           # 004bd587
    add eax, 0x3af                               # 004bd58a
    push eax                                     # 004bd58f
    mov ecx, 0x5c3a67                            # 004bd590
    call FUN_004fb77a                            # 004bd595
L_004bd59a:
    # block 0x004bd59a: entered by je at 0x004bd585, 7 instruction(s), ends with je to 0x004bd5c6 (forward)
    mov edi, 0x5520ac                            # 004bd59a
    mov esi, dword ptr [ebp - local_4]           # 004bd59f
    add esi, 0x411                               # 004bd5a2
    mov ecx, 0x9                                 # 004bd5a8
    {load} xor edx, edx                          # 004bd5ad
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bd5af
    je.d8 L_004bd5c6                             # 004bd5b1
    # block 0x004bd5b3: entered by fall-through of je at 0x004bd5b1, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004bd5c6
    mov eax, dword ptr [ebp - local_4]           # 004bd5b3
    add eax, 0x411                               # 004bd5b6
    push eax                                     # 004bd5bb
    mov ecx, 0x5c3a67                            # 004bd5bc
    call FUN_004fb77a                            # 004bd5c1
L_004bd5c6:
    # block 0x004bd5c6: entered by je at 0x004bd5b1, 67 instruction(s), calls FUN_004d39f9, FUN_004460d6, FUN_0044655e, ends with jne to 0x004bd718 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bd5c6
    mov dword ptr [ecx + field_1f4], 0x0         # 004bd5c9
    mov edx, dword ptr [ebp - local_4]           # 004bd5d3
    mov dword ptr [edx + field_1fc], 0x0         # 004bd5d6
    mov eax, dword ptr [ebp - local_4]           # 004bd5e0
    mov dword ptr [eax + field_200], 0x3f800000  # 004bd5e3
    mov ecx, dword ptr [ebp - local_4]           # 004bd5ed
    mov edx, dword ptr [ecx + field_18]          # 004bd5f0
    mov eax, dword ptr [ebp - local_4]           # 004bd5f3
    mov ecx, dword ptr [edx + field_8fe]         # 004bd5f6
    mov dword ptr [eax + field_1f8], ecx         # 004bd5fc
    mov edx, dword ptr [ebp - local_4]           # 004bd602
    mov eax, dword ptr [edx + field_18]          # 004bd605
    mov ecx, dword ptr [ebp - local_4]           # 004bd608
    mov edx, dword ptr [eax + field_8f8]         # 004bd60b
    mov dword ptr [ecx + field_2b4], edx         # 004bd611
    mov eax, dword ptr [ebp - local_4]           # 004bd617
    mov ecx, dword ptr [ebp - local_4]           # 004bd61a
    mov edx, dword ptr [ecx + field_8]           # 004bd61d
    mov dword ptr [eax + field_2b8], edx         # 004bd620
    call FUN_004d39f9                            # 004bd626
    movsx eax, ax                                # 004bd62b
    mov ecx, dword ptr [ebp - local_4]           # 004bd62e
    mov dword ptr [ecx + field_2bc], eax         # 004bd631
    mov edx, dword ptr [ebp - local_4]           # 004bd637
    mov dword ptr [edx + field_2c0], 0xa         # 004bd63a
    mov eax, dword ptr [ebp - local_4]           # 004bd644
    mov esi, dword ptr [eax + field_18]          # 004bd647
    add esi, 0x574                               # 004bd64a
    mov edi, dword ptr [ebp - local_4]           # 004bd650
    add edi, 0x20c                               # 004bd653
    mov ecx, 0x28                                # 004bd659
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bd65e
    mov ecx, dword ptr [ebp - local_4]           # 004bd660
    mov edx, dword ptr [ecx + field_18]          # 004bd663
    mov eax, dword ptr [ebp - local_4]           # 004bd666
    mov ecx, dword ptr [edx + field_79c]         # 004bd669
    mov dword ptr [eax + field_2ac], ecx         # 004bd66f
    mov edx, dword ptr [ebp - local_4]           # 004bd675
    mov eax, dword ptr [edx + field_18]          # 004bd678
    mov ecx, dword ptr [ebp - local_4]           # 004bd67b
    mov edx, dword ptr [eax + field_7a0]         # 004bd67e
    mov dword ptr [ecx + field_2b0], edx         # 004bd684
    mov eax, dword ptr [ebp - local_4]           # 004bd68a
    mov ecx, dword ptr [eax + field_2ac]         # 004bd68d
    mov edx, dword ptr [ebp - local_4]           # 004bd693
    add ecx, dword ptr [edx + field_1dc]         # 004bd696
    mov eax, dword ptr [ebp - local_4]           # 004bd69c
    mov dword ptr [eax + field_2ac], ecx         # 004bd69f
    mov ecx, dword ptr [ebp - local_4]           # 004bd6a5
    mov edx, dword ptr [ecx + field_2b0]         # 004bd6a8
    mov eax, dword ptr [ebp - local_4]           # 004bd6ae
    add edx, dword ptr [eax + field_1e0]         # 004bd6b1
    mov ecx, dword ptr [ebp - local_4]           # 004bd6b7
    mov dword ptr [ecx + field_2b0], edx         # 004bd6ba
    mov edx, dword ptr [ebp - local_4]           # 004bd6c0
    add edx, 0x20c                               # 004bd6c3
    push edx                                     # 004bd6c9
    mov ecx, 0x638603                            # 004bd6ca
    call FUN_004460d6                            # 004bd6cf
    mov eax, dword ptr [ebp - local_4]           # 004bd6d4
    mov ecx, dword ptr [eax + field_1f4]         # 004bd6d7
    push ecx                                     # 004bd6dd
    mov ecx, 0x638603                            # 004bd6de
    call FUN_0044655e                            # 004bd6e3
    cmp dword ptr [0x63883f], 0x0                # 004bd6e8
    jne.d8 L_004bd718                            # 004bd6ef
    # block 0x004bd6f1: entered by fall-through of jne at 0x004bd6ef, 15 instruction(s), falls into the block at 0x004bd718
    mov edi, 0x5520b8                            # 004bd6f1
    mov edx, 0x63885f                            # 004bd6f6
    or ecx, -0x1                                 # 004bd6fb
    {load} xor eax, eax                          # 004bd6fe
    repne scasb al, byte ptr es:[edi]            # 004bd700
    not ecx                                      # 004bd702
    {load} sub edi, ecx                          # 004bd704
    {load} mov esi, edi                          # 004bd706
    {load} mov eax, ecx                          # 004bd708
    {load} mov edi, edx                          # 004bd70a
    shr ecx, 0x2                                 # 004bd70c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bd70f
    {load} mov ecx, eax                          # 004bd711
    and ecx, 0x3                                 # 004bd713
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bd716
L_004bd718:
    # block 0x004bd718: entered by jne at 0x004bd6ef, 69 instruction(s), calls FUN_00446532, KERNEL32.dll!GetTickCount, ends with jge to 0x004bd84c (forward)
    push 0x1                                     # 004bd718
    mov ecx, 0x638603                            # 004bd71a
    call FUN_00446532                            # 004bd71f
    mov ecx, dword ptr [ebp - local_4]           # 004bd724
    mov edx, dword ptr [ecx + field_18]          # 004bd727
    fild dword ptr [edx + field_8e8]             # 004bd72a
    fstp dword ptr [ebp - local_c]               # 004bd730
    fld dword ptr [ebp - local_c]                # 004bd733
    fmul dword ptr [0x52db58]                    # 004bd736
    mov eax, dword ptr [ebp - local_4]           # 004bd73c
    fstp dword ptr [eax + field_30c]             # 004bd73f
    mov ecx, dword ptr [ebp - local_4]           # 004bd745
    mov edx, dword ptr [ecx + field_18]          # 004bd748
    mov eax, dword ptr [ebp - local_4]           # 004bd74b
    fld dword ptr [edx + field_91a]              # 004bd74e
    fdiv dword ptr [eax + field_30c]             # 004bd754
    mov ecx, dword ptr [ebp - local_4]           # 004bd75a
    fstp dword ptr [ecx + field_208]             # 004bd75d
    mov edx, dword ptr [ebp - local_4]           # 004bd763
    mov dword ptr [edx + field_38], 0x0          # 004bd766
    mov eax, dword ptr [ebp - local_4]           # 004bd76d
    mov dword ptr [eax + field_3c], 0x0          # 004bd770
    mov ecx, dword ptr [ebp - local_4]           # 004bd777
    mov dword ptr [ecx + field_40], 0x0          # 004bd77a
    mov edx, dword ptr [ebp - local_4]           # 004bd781
    mov dword ptr [edx + field_44], 0x0          # 004bd784
    mov eax, dword ptr [ebp - local_4]           # 004bd78b
    mov ecx, dword ptr [eax + field_18]          # 004bd78e
    mov edx, dword ptr [ebp - local_4]           # 004bd791
    mov eax, dword ptr [edx + field_18]          # 004bd794
    fild dword ptr [eax + field_8b4]             # 004bd797
    fstp dword ptr [ebp - local_10]              # 004bd79d
    fld dword ptr [ecx + field_8c0]              # 004bd7a0
    fdiv dword ptr [ebp - local_10]              # 004bd7a6
    mov ecx, dword ptr [ebp - local_4]           # 004bd7a9
    fstp dword ptr [ecx + field_2f8]             # 004bd7ac
    mov edx, dword ptr [ebp - local_4]           # 004bd7b2
    mov eax, dword ptr [edx + field_18]          # 004bd7b5
    mov ecx, dword ptr [ebp - local_4]           # 004bd7b8
    mov edx, dword ptr [ecx + field_18]          # 004bd7bb
    fild dword ptr [edx + field_8b8]             # 004bd7be
    fstp dword ptr [ebp - local_14]              # 004bd7c4
    fld dword ptr [eax + field_8c4]              # 004bd7c7
    fdiv dword ptr [ebp - local_14]              # 004bd7cd
    mov eax, dword ptr [ebp - local_4]           # 004bd7d0
    fstp dword ptr [eax + field_2fc]             # 004bd7d3
    mov ecx, dword ptr [ebp - local_4]           # 004bd7d9
    mov edx, dword ptr [ecx + field_18]          # 004bd7dc
    mov eax, dword ptr [ebp - local_4]           # 004bd7df
    mov ecx, dword ptr [eax + field_18]          # 004bd7e2
    fild dword ptr [ecx + field_8bc]             # 004bd7e5
    fstp dword ptr [ebp - local_18]              # 004bd7eb
    fld dword ptr [edx + field_8c8]              # 004bd7ee
    fdiv dword ptr [ebp - local_18]              # 004bd7f4
    mov edx, dword ptr [ebp - local_4]           # 004bd7f7
    fstp dword ptr [edx + field_300]             # 004bd7fa
    call dword ptr [0x52a23c]                    # 004bd800
    mov ecx, dword ptr [ebp - local_4]           # 004bd806
    mov dword ptr [ecx + field_2dc], eax         # 004bd809
    call dword ptr [0x52a23c]                    # 004bd80f
    mov edx, dword ptr [ebp - local_4]           # 004bd815
    mov dword ptr [edx + field_2e0], eax         # 004bd818
    call dword ptr [0x52a23c]                    # 004bd81e
    mov ecx, dword ptr [ebp - local_4]           # 004bd824
    mov dword ptr [ecx + field_2e4], eax         # 004bd827
    mov edx, dword ptr [ebp - local_4]           # 004bd82d
    mov eax, dword ptr [edx + field_18]          # 004bd830
    cmp dword ptr [eax + field_922], 0x1         # 004bd833
    jge.d8 L_004bd84c                            # 004bd83a
    # block 0x004bd83c: entered by fall-through of jge at 0x004bd83a, 3 instruction(s), falls into the block at 0x004bd84c
    mov ecx, dword ptr [ebp - local_4]           # 004bd83c
    mov edx, dword ptr [ecx + field_18]          # 004bd83f
    mov dword ptr [edx + field_922], 0x1         # 004bd842
L_004bd84c:
    # block 0x004bd84c: entered by jge at 0x004bd83a, 15 instruction(s), ends with forward jump to 0x004be167
    mov eax, dword ptr [ebp - local_4]           # 004bd84c
    mov dword ptr [eax + field_24], 0x0          # 004bd84f
    mov ecx, dword ptr [ebp - local_4]           # 004bd856
    mov dword ptr [ecx + field_2c], 0x0          # 004bd859
    mov edx, dword ptr [ebp - local_4]           # 004bd860
    mov dword ptr [edx + field_1b4], 0x0         # 004bd863
    mov eax, dword ptr [ebp - local_4]           # 004bd86d
    mov dword ptr [eax + field_1c], 0x0          # 004bd870
    mov ecx, dword ptr [ebp - local_4]           # 004bd877
    mov dword ptr [ecx + field_20], 0x0          # 004bd87a
    mov edx, dword ptr [ebp - local_4]           # 004bd881
    movsx eax, word ptr [edx + field_6]          # 004bd884
    imul eax, eax, 0x8d                          # 004bd888
    mov dword ptr [eax + 0x5bb632], 0x1          # 004bd88e
    jmp.d32 L_004be167                           # 004bd898
L_004bd89d:
    # block 0x004bd89d: entered by je at 0x004bcaaf, 5 instruction(s), ends with ja to 0x004bde1a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bd89d
    mov edx, dword ptr [ecx + field_1c]          # 004bd8a0
    mov dword ptr [ebp - local_1c], edx          # 004bd8a3
    cmp dword ptr [ebp - local_1c], 0x6          # 004bd8a6
    ja.d32 L_004bde1a                            # 004bd8aa
    # block 0x004bd8b0: entered by fall-through of ja at 0x004bd8aa, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4be16f]
    mov eax, dword ptr [ebp - local_1c]          # 004bd8b0
    jmp dword ptr [4*eax + SWTAB_004be16f_VA]    # 004bd8b3
L_004bd8ba:
    # block 0x004bd8ba: entered by switch case, 5 instruction(s), calls FUN_004bb336, ends with je to 0x004bd900 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bd8ba
    call FUN_004bb336                            # 004bd8bd
    mov ecx, dword ptr [ebp - local_4]           # 004bd8c2
    cmp dword ptr [ecx + field_44], 0x0          # 004bd8c5
    je.d8 L_004bd900                             # 004bd8c9
    # block 0x004bd8cb: entered by fall-through of je at 0x004bd8c9, 10 instruction(s), falls into the block at 0x004bd900
    mov edx, dword ptr [ebp - local_4]           # 004bd8cb
    mov dword ptr [edx + field_44], 0x0          # 004bd8ce
    mov eax, dword ptr [ebp - local_4]           # 004bd8d5
    mov dword ptr [eax + field_1c], 0x1          # 004bd8d8
    mov ecx, dword ptr [ebp - local_4]           # 004bd8df
    mov dword ptr [ecx + field_1b4], 0x1         # 004bd8e2
    mov edx, dword ptr [ebp - local_4]           # 004bd8ec
    mov dword ptr [edx + field_24], 0x2          # 004bd8ef
    mov eax, dword ptr [ebp - local_4]           # 004bd8f6
    mov dword ptr [eax + field_2c], 0x0          # 004bd8f9
L_004bd900:
    # block 0x004bd900: entered by je at 0x004bd8c9, 3 instruction(s), ends with je to 0x004bd98d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bd900
    cmp dword ptr [ecx + field_40], 0x0          # 004bd903
    je.d32 L_004bd98d                            # 004bd907
    # block 0x004bd90d: entered by fall-through of je at 0x004bd907, 12 instruction(s), ends with je to 0x004bd983 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bd90d
    mov dword ptr [edx + field_24], 0x2          # 004bd910
    mov eax, dword ptr [ebp - local_4]           # 004bd917
    mov dword ptr [eax + field_2c], 0x2          # 004bd91a
    mov edi, 0x5520c0                            # 004bd921
    mov ecx, dword ptr [ebp - local_4]           # 004bd926
    mov esi, dword ptr [ecx + field_18]          # 004bd929
    add esi, 0xa80                               # 004bd92c
    mov ecx, 0x9                                 # 004bd932
    {load} xor edx, edx                          # 004bd937
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bd939
    je.d8 L_004bd983                             # 004bd93b
    # block 0x004bd93d: entered by fall-through of je at 0x004bd93b, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004bd983
    mov eax, dword ptr [ebp - local_4]           # 004bd93d
    mov esi, dword ptr [eax + field_18]          # 004bd940
    add esi, 0xa80                               # 004bd943
    mov edi, dword ptr [ebp - local_4]           # 004bd949
    add edi, 0x3e0                               # 004bd94c
    mov ecx, 0xc                                 # 004bd952
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bd957
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bd959
    mov ecx, dword ptr [ebp - local_4]           # 004bd95a
    add ecx, 0x3e0                               # 004bd95d
    push ecx                                     # 004bd963
    mov ecx, 0x5c3a67                            # 004bd964
    call FUN_004fb77a                            # 004bd969
    mov edx, dword ptr [ebp - local_4]           # 004bd96e
    mov ax, word ptr [edx + field_401]           # 004bd971
    push eax                                     # 004bd978
    mov ecx, 0x5c3a67                            # 004bd979
    call FUN_004fb2e3                            # 004bd97e
L_004bd983:
    # block 0x004bd983: entered by je at 0x004bd93b, 2 instruction(s), falls into the block at 0x004bd98d
    mov ecx, dword ptr [ebp - local_4]           # 004bd983
    mov dword ptr [ecx + field_1c], 0x4          # 004bd986
L_004bd98d:
    # block 0x004bd98d: entered by je at 0x004bd907, 1 instruction(s), ends with forward jump to 0x004bde1a
    jmp.d32 L_004bde1a                           # 004bd98d
L_004bd992:
    # block 0x004bd992: entered by switch case, 2 instruction(s), calls FUN_004ba56a, falls into the block at 0x004bd99a
    mov ecx, dword ptr [ebp - local_4]           # 004bd992
    call FUN_004ba56a                            # 004bd995
L_004bd99a:
    # block 0x004bd99a: entered by jmp at 0x004bd9d3, 7 instruction(s), ends with jg to 0x004bd9d5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bd99a
    mov eax, dword ptr [edx + field_1a4]         # 004bd99d
    add eax, 0x1                                 # 004bd9a3
    mov ecx, dword ptr [ebp - local_4]           # 004bd9a6
    mov edx, dword ptr [ecx + field_18]          # 004bd9a9
    cmp eax, dword ptr [edx + field_8f0]         # 004bd9ac
    jg.d8 L_004bd9d5                             # 004bd9b2
    # block 0x004bd9b4: entered by fall-through of jg at 0x004bd9b2, 9 instruction(s), calls FUN_004bbe46, ends with backward jump to 0x004bd99a
    mov eax, dword ptr [ebp - local_4]           # 004bd9b4
    mov ecx, dword ptr [eax + field_1a4]         # 004bd9b7
    add ecx, 0x1                                 # 004bd9bd
    mov edx, dword ptr [ebp - local_4]           # 004bd9c0
    mov dword ptr [edx + field_1a4], ecx         # 004bd9c3
    push 0x0                                     # 004bd9c9
    mov ecx, dword ptr [ebp - local_4]           # 004bd9cb
    call FUN_004bbe46                            # 004bd9ce
    jmp.d8 L_004bd99a                            # 004bd9d3
L_004bd9d5:
    # block 0x004bd9d5: entered by jg at 0x004bd9b2; jmp at 0x004bda0e, 7 instruction(s), ends with jg to 0x004bda10 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bd9d5
    mov ecx, dword ptr [eax + field_1a8]         # 004bd9d8
    add ecx, 0x1                                 # 004bd9de
    mov edx, dword ptr [ebp - local_4]           # 004bd9e1
    mov eax, dword ptr [edx + field_18]          # 004bd9e4
    cmp ecx, dword ptr [eax + field_8f4]         # 004bd9e7
    jg.d8 L_004bda10                             # 004bd9ed
    # block 0x004bd9ef: entered by fall-through of jg at 0x004bd9ed, 9 instruction(s), calls FUN_004bbe46, ends with backward jump to 0x004bd9d5
    mov ecx, dword ptr [ebp - local_4]           # 004bd9ef
    mov edx, dword ptr [ecx + field_1a8]         # 004bd9f2
    add edx, 0x1                                 # 004bd9f8
    mov eax, dword ptr [ebp - local_4]           # 004bd9fb
    mov dword ptr [eax + field_1a8], edx         # 004bd9fe
    push 0x1                                     # 004bda04
    mov ecx, dword ptr [ebp - local_4]           # 004bda06
    call FUN_004bbe46                            # 004bda09
    jmp.d8 L_004bd9d5                            # 004bda0e
L_004bda10:
    # block 0x004bda10: entered by jg at 0x004bd9ed, 13 instruction(s), calls FUN_004bbb3e, FUN_004bb775, FUN_004bb219, FUN_004be504, FUN_004bb336, ends with je to 0x004bdae1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bda10
    call FUN_004bbb3e                            # 004bda13
    mov ecx, dword ptr [ebp - local_4]           # 004bda18
    call FUN_004bb775                            # 004bda1b
    mov ecx, dword ptr [ebp - local_4]           # 004bda20
    call FUN_004bb219                            # 004bda23
    mov ecx, dword ptr [ebp - local_4]           # 004bda28
    call FUN_004be504                            # 004bda2b
    mov ecx, dword ptr [ebp - local_4]           # 004bda30
    call FUN_004bb336                            # 004bda33
    mov ecx, dword ptr [ebp - local_4]           # 004bda38
    cmp dword ptr [ecx + field_3c], 0x0          # 004bda3b
    je.d32 L_004bdae1                            # 004bda3f
    # block 0x004bda45: entered by fall-through of je at 0x004bda3f, 18 instruction(s), ends with je to 0x004bdadc (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bda45
    mov dword ptr [edx + field_3c], 0x0          # 004bda48
    mov eax, dword ptr [ebp - local_4]           # 004bda4f
    mov dword ptr [eax + field_1c], 0x3          # 004bda52
    mov ecx, dword ptr [ebp - local_4]           # 004bda59
    mov dword ptr [ecx + field_1b4], 0x1         # 004bda5c
    mov edx, dword ptr [ebp - local_4]           # 004bda66
    mov dword ptr [edx + field_24], 0x0          # 004bda69
    mov eax, dword ptr [ebp - local_4]           # 004bda70
    mov dword ptr [eax + field_2c], 0x0          # 004bda73
    mov edi, 0x5520cc                            # 004bda7a
    mov ecx, dword ptr [ebp - local_4]           # 004bda7f
    mov esi, dword ptr [ecx + field_18]          # 004bda82
    add esi, 0xab1                               # 004bda85
    mov ecx, 0x9                                 # 004bda8b
    {load} xor edx, edx                          # 004bda90
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bda92
    je.d8 L_004bdadc                             # 004bda94
    # block 0x004bda96: entered by fall-through of je at 0x004bda94, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004bdadc
    mov eax, dword ptr [ebp - local_4]           # 004bda96
    mov esi, dword ptr [eax + field_18]          # 004bda99
    add esi, 0xab1                               # 004bda9c
    mov edi, dword ptr [ebp - local_4]           # 004bdaa2
    add edi, 0x3e0                               # 004bdaa5
    mov ecx, 0xc                                 # 004bdaab
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bdab0
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bdab2
    mov ecx, dword ptr [ebp - local_4]           # 004bdab3
    add ecx, 0x3e0                               # 004bdab6
    push ecx                                     # 004bdabc
    mov ecx, 0x5c3a67                            # 004bdabd
    call FUN_004fb77a                            # 004bdac2
    mov edx, dword ptr [ebp - local_4]           # 004bdac7
    mov ax, word ptr [edx + field_401]           # 004bdaca
    push eax                                     # 004bdad1
    mov ecx, 0x5c3a67                            # 004bdad2
    call FUN_004fb2e3                            # 004bdad7
L_004bdadc:
    # block 0x004bdadc: entered by je at 0x004bda94, 1 instruction(s), ends with forward jump to 0x004bdbc8
    jmp.d32 L_004bdbc8                           # 004bdadc
L_004bdae1:
    # block 0x004bdae1: entered by je at 0x004bda3f, 3 instruction(s), ends with je to 0x004bdb1a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bdae1
    cmp dword ptr [ecx + field_38], 0x0          # 004bdae4
    je.d8 L_004bdb1a                             # 004bdae8
    # block 0x004bdaea: entered by fall-through of je at 0x004bdae8, 9 instruction(s), ends with forward jump to 0x004bdbc8
    mov edx, dword ptr [ebp - local_4]           # 004bdaea
    mov dword ptr [edx + field_1c], 0x2          # 004bdaed
    mov eax, dword ptr [ebp - local_4]           # 004bdaf4
    mov dword ptr [eax + field_1b4], 0x1         # 004bdaf7
    mov ecx, dword ptr [ebp - local_4]           # 004bdb01
    mov dword ptr [ecx + field_24], 0x2          # 004bdb04
    mov edx, dword ptr [ebp - local_4]           # 004bdb0b
    mov dword ptr [edx + field_2c], 0x2          # 004bdb0e
    jmp.d32 L_004bdbc8                           # 004bdb15
L_004bdb1a:
    # block 0x004bdb1a: entered by je at 0x004bdae8, 3 instruction(s), ends with je to 0x004bdbc8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bdb1a
    cmp dword ptr [eax + field_40], 0x0          # 004bdb1d
    je.d32 L_004bdbc8                            # 004bdb21
    # block 0x004bdb27: entered by fall-through of je at 0x004bdb21, 14 instruction(s), ends with je to 0x004bdba7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bdb27
    mov dword ptr [ecx + field_1c], 0x4          # 004bdb2a
    mov edx, dword ptr [ebp - local_4]           # 004bdb31
    mov dword ptr [edx + field_24], 0x2          # 004bdb34
    mov eax, dword ptr [ebp - local_4]           # 004bdb3b
    mov dword ptr [eax + field_2c], 0x2          # 004bdb3e
    mov edi, 0x5520d8                            # 004bdb45
    mov ecx, dword ptr [ebp - local_4]           # 004bdb4a
    mov esi, dword ptr [ecx + field_18]          # 004bdb4d
    add esi, 0xa80                               # 004bdb50
    mov ecx, 0x9                                 # 004bdb56
    {load} xor edx, edx                          # 004bdb5b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bdb5d
    je.d8 L_004bdba7                             # 004bdb5f
    # block 0x004bdb61: entered by fall-through of je at 0x004bdb5f, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004bdba7
    mov eax, dword ptr [ebp - local_4]           # 004bdb61
    mov esi, dword ptr [eax + field_18]          # 004bdb64
    add esi, 0xa80                               # 004bdb67
    mov edi, dword ptr [ebp - local_4]           # 004bdb6d
    add edi, 0x3e0                               # 004bdb70
    mov ecx, 0xc                                 # 004bdb76
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bdb7b
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bdb7d
    mov ecx, dword ptr [ebp - local_4]           # 004bdb7e
    add ecx, 0x3e0                               # 004bdb81
    push ecx                                     # 004bdb87
    mov ecx, 0x5c3a67                            # 004bdb88
    call FUN_004fb77a                            # 004bdb8d
    mov edx, dword ptr [ebp - local_4]           # 004bdb92
    mov ax, word ptr [edx + field_401]           # 004bdb95
    push eax                                     # 004bdb9c
    mov ecx, 0x5c3a67                            # 004bdb9d
    call FUN_004fb2e3                            # 004bdba2
L_004bdba7:
    # block 0x004bdba7: entered by je at 0x004bdb5f, 6 instruction(s), calls FUN_00445f53, falls into the block at 0x004bdbc8
    mov ecx, dword ptr [ebp - local_4]           # 004bdba7
    movsx edx, word ptr [ecx + field_6]          # 004bdbaa
    imul edx, edx, 0x8d                          # 004bdbae
    mov dword ptr [edx + 0x5bb632], 0x2          # 004bdbb4
    mov ecx, 0x638603                            # 004bdbbe
    call FUN_00445f53                            # 004bdbc3
L_004bdbc8:
    # block 0x004bdbc8: entered by jmp at 0x004bdadc; jmp at 0x004bdb15; je at 0x004bdb21, 1 instruction(s), ends with forward jump to 0x004bde1a
    jmp.d32 L_004bde1a                           # 004bdbc8
L_004bdbcd:
    # block 0x004bdbcd: entered by switch case, 11 instruction(s), calls FUN_004ba13d, FUN_004bc2aa, FUN_0044655e, ends with jne to 0x004bdc21 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bdbcd
    call FUN_004ba13d                            # 004bdbd0
    mov ecx, dword ptr [ebp - local_4]           # 004bdbd5
    call FUN_004bc2aa                            # 004bdbd8
    mov eax, dword ptr [ebp - local_4]           # 004bdbdd
    mov ecx, dword ptr [eax + field_1f4]         # 004bdbe0
    push ecx                                     # 004bdbe6
    mov ecx, 0x638603                            # 004bdbe7
    call FUN_0044655e                            # 004bdbec
    cmp dword ptr [0x63883f], 0x0                # 004bdbf1
    jne.d8 L_004bdc21                            # 004bdbf8
    # block 0x004bdbfa: entered by fall-through of jne at 0x004bdbf8, 15 instruction(s), falls into the block at 0x004bdc21
    mov edi, 0x5520e4                            # 004bdbfa
    mov edx, 0x63885f                            # 004bdbff
    or ecx, -0x1                                 # 004bdc04
    {load} xor eax, eax                          # 004bdc07
    repne scasb al, byte ptr es:[edi]            # 004bdc09
    not ecx                                      # 004bdc0b
    {load} sub edi, ecx                          # 004bdc0d
    {load} mov esi, edi                          # 004bdc0f
    {load} mov eax, ecx                          # 004bdc11
    {load} mov edi, edx                          # 004bdc13
    shr ecx, 0x2                                 # 004bdc15
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bdc18
    {load} mov ecx, eax                          # 004bdc1a
    and ecx, 0x3                                 # 004bdc1c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bdc1f
L_004bdc21:
    # block 0x004bdc21: entered by jne at 0x004bdbf8, 3 instruction(s), ends with forward jump to 0x004bde1a
    mov ecx, dword ptr [ebp - local_4]           # 004bdc21
    mov dword ptr [ecx + field_1c], 0x1          # 004bdc24
    jmp.d32 L_004bde1a                           # 004bdc2b
L_004bdc30:
    # block 0x004bdc30: entered by switch case, 5 instruction(s), calls FUN_004bb336, ends with je to 0x004bdc76 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bdc30
    call FUN_004bb336                            # 004bdc33
    mov edx, dword ptr [ebp - local_4]           # 004bdc38
    cmp dword ptr [edx + field_44], 0x0          # 004bdc3b
    je.d8 L_004bdc76                             # 004bdc3f
    # block 0x004bdc41: entered by fall-through of je at 0x004bdc3f, 10 instruction(s), falls into the block at 0x004bdc76
    mov eax, dword ptr [ebp - local_4]           # 004bdc41
    mov dword ptr [eax + field_44], 0x0          # 004bdc44
    mov ecx, dword ptr [ebp - local_4]           # 004bdc4b
    mov dword ptr [ecx + field_1c], 0x5          # 004bdc4e
    mov edx, dword ptr [ebp - local_4]           # 004bdc55
    mov dword ptr [edx + field_1b4], 0x1         # 004bdc58
    mov eax, dword ptr [ebp - local_4]           # 004bdc62
    mov dword ptr [eax + field_24], 0x2          # 004bdc65
    mov ecx, dword ptr [ebp - local_4]           # 004bdc6c
    mov dword ptr [ecx + field_2c], 0x0          # 004bdc6f
L_004bdc76:
    # block 0x004bdc76: entered by je at 0x004bdc3f, 3 instruction(s), ends with je to 0x004bdd24 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bdc76
    cmp dword ptr [edx + field_40], 0x0          # 004bdc79
    je.d32 L_004bdd24                            # 004bdc7d
    # block 0x004bdc83: entered by fall-through of je at 0x004bdc7d, 14 instruction(s), ends with je to 0x004bdd03 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bdc83
    mov dword ptr [eax + field_1c], 0x4          # 004bdc86
    mov ecx, dword ptr [ebp - local_4]           # 004bdc8d
    mov dword ptr [ecx + field_24], 0x2          # 004bdc90
    mov edx, dword ptr [ebp - local_4]           # 004bdc97
    mov dword ptr [edx + field_2c], 0x2          # 004bdc9a
    mov edi, 0x5520ec                            # 004bdca1
    mov eax, dword ptr [ebp - local_4]           # 004bdca6
    mov esi, dword ptr [eax + field_18]          # 004bdca9
    add esi, 0xa80                               # 004bdcac
    mov ecx, 0x9                                 # 004bdcb2
    {load} xor edx, edx                          # 004bdcb7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bdcb9
    je.d8 L_004bdd03                             # 004bdcbb
    # block 0x004bdcbd: entered by fall-through of je at 0x004bdcbb, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004bdd03
    mov eax, dword ptr [ebp - local_4]           # 004bdcbd
    mov esi, dword ptr [eax + field_18]          # 004bdcc0
    add esi, 0xa80                               # 004bdcc3
    mov edi, dword ptr [ebp - local_4]           # 004bdcc9
    add edi, 0x3e0                               # 004bdccc
    mov ecx, 0xc                                 # 004bdcd2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bdcd7
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bdcd9
    mov ecx, dword ptr [ebp - local_4]           # 004bdcda
    add ecx, 0x3e0                               # 004bdcdd
    push ecx                                     # 004bdce3
    mov ecx, 0x5c3a67                            # 004bdce4
    call FUN_004fb77a                            # 004bdce9
    mov edx, dword ptr [ebp - local_4]           # 004bdcee
    mov ax, word ptr [edx + field_401]           # 004bdcf1
    push eax                                     # 004bdcf8
    mov ecx, 0x5c3a67                            # 004bdcf9
    call FUN_004fb2e3                            # 004bdcfe
L_004bdd03:
    # block 0x004bdd03: entered by je at 0x004bdcbb, 6 instruction(s), calls FUN_00445f53, falls into the block at 0x004bdd24
    mov ecx, dword ptr [ebp - local_4]           # 004bdd03
    movsx edx, word ptr [ecx + field_6]          # 004bdd06
    imul edx, edx, 0x8d                          # 004bdd0a
    mov dword ptr [edx + 0x5bb632], 0x2          # 004bdd10
    mov ecx, 0x638603                            # 004bdd1a
    call FUN_00445f53                            # 004bdd1f
L_004bdd24:
    # block 0x004bdd24: entered by je at 0x004bdc7d, 1 instruction(s), ends with forward jump to 0x004bde1a
    jmp.d32 L_004bde1a                           # 004bdd24
L_004bdd29:
    # block 0x004bdd29: entered by switch case, 8 instruction(s), ends with je to 0x004bdd8b (forward)
    mov edi, 0x5520f8                            # 004bdd29
    mov eax, dword ptr [ebp - local_4]           # 004bdd2e
    mov esi, dword ptr [eax + field_18]          # 004bdd31
    add esi, 0xa35                               # 004bdd34
    mov ecx, 0x9                                 # 004bdd3a
    {load} xor edx, edx                          # 004bdd3f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bdd41
    je.d8 L_004bdd8b                             # 004bdd43
    # block 0x004bdd45: entered by fall-through of je at 0x004bdd43, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004bdd8b
    mov eax, dword ptr [ebp - local_4]           # 004bdd45
    mov esi, dword ptr [eax + field_18]          # 004bdd48
    add esi, 0xa35                               # 004bdd4b
    mov edi, dword ptr [ebp - local_4]           # 004bdd51
    add edi, 0x3e0                               # 004bdd54
    mov ecx, 0xc                                 # 004bdd5a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bdd5f
    movsb byte ptr es:[edi], byte ptr [esi]      # 004bdd61
    mov ecx, dword ptr [ebp - local_4]           # 004bdd62
    add ecx, 0x3e0                               # 004bdd65
    push ecx                                     # 004bdd6b
    mov ecx, 0x5c3a67                            # 004bdd6c
    call FUN_004fb77a                            # 004bdd71
    mov edx, dword ptr [ebp - local_4]           # 004bdd76
    mov ax, word ptr [edx + field_401]           # 004bdd79
    push eax                                     # 004bdd80
    mov ecx, 0x5c3a67                            # 004bdd81
    call FUN_004fb2e3                            # 004bdd86
L_004bdd8b:
    # block 0x004bdd8b: entered by je at 0x004bdd43, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004bde1a
    call dword ptr [0x52a23c]                    # 004bdd8b
    mov ecx, dword ptr [ebp - local_4]           # 004bdd91
    mov edx, dword ptr [ecx + field_18]          # 004bdd94
    add eax, dword ptr [edx + field_8b0]         # 004bdd97
    mov ecx, dword ptr [ebp - local_4]           # 004bdd9d
    mov dword ptr [ecx + field_2f4], eax         # 004bdda0
    mov edx, dword ptr [ebp - local_4]           # 004bdda6
    mov dword ptr [edx + field_1c], 0x6          # 004bdda9
    jmp.d8 L_004bde1a                            # 004bddb0
L_004bddb2:
    # block 0x004bddb2: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004bddf7 (forward)
    call dword ptr [0x52a23c]                    # 004bddb2
    mov ecx, dword ptr [ebp - local_4]           # 004bddb8
    cmp eax, dword ptr [ecx + field_2f4]         # 004bddbb
    jbe.d8 L_004bddf7                            # 004bddc1
    # block 0x004bddc3: entered by fall-through of jbe at 0x004bddc1, 7 instruction(s), ends with je to 0x004bdded (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bddc3
    movsx eax, word ptr [edx + field_6]          # 004bddc6
    imul eax, eax, 0x8d                          # 004bddca
    mov dword ptr [eax + 0x5bb632], 0x2          # 004bddd0
    mov ecx, dword ptr [ebp - local_4]           # 004bddda
    cmp dword ptr [ecx + field_40], 0x0          # 004bdddd
    je.d8 L_004bdded                             # 004bdde1
    # block 0x004bdde3: entered by fall-through of je at 0x004bdde1, 2 instruction(s), falls into the block at 0x004bdded
    mov edx, dword ptr [ebp - local_4]           # 004bdde3
    mov dword ptr [edx + field_2c], 0x0          # 004bdde6
L_004bdded:
    # block 0x004bdded: entered by je at 0x004bdde1, 2 instruction(s), calls FUN_00445f53, falls into the block at 0x004bddf7
    mov ecx, 0x638603                            # 004bdded
    call FUN_00445f53                            # 004bddf2
L_004bddf7:
    # block 0x004bddf7: entered by jbe at 0x004bddc1, 1 instruction(s), ends with forward jump to 0x004bde1a
    jmp.d8 L_004bde1a                            # 004bddf7
L_004bddf9:
    # block 0x004bddf9: entered by switch case, 6 instruction(s), calls FUN_00445f53, falls into the block at 0x004bde1a
    mov eax, dword ptr [ebp - local_4]           # 004bddf9
    movsx ecx, word ptr [eax + field_6]          # 004bddfc
    imul ecx, ecx, 0x8d                          # 004bde00
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004bde06
    mov ecx, 0x638603                            # 004bde10
    call FUN_00445f53                            # 004bde15
L_004bde1a:
    # block 0x004bde1a: entered by ja at 0x004bd8aa; jmp at 0x004bd98d; jmp at 0x004bdbc8; jmp at 0x004bdc2b; more, 1 instruction(s), ends with forward jump to 0x004be167
    jmp.d32 L_004be167                           # 004bde1a
L_004bde1f:
    # block 0x004bde1f: entered by je at 0x004bcab9, 9 instruction(s), ends with je to 0x004bde56 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bde1f
    mov dword ptr [edx + field_34], 0x0          # 004bde22
    mov edi, 0x552104                            # 004bde29
    mov esi, dword ptr [ebp - local_4]           # 004bde2e
    add esi, 0x31c                               # 004bde31
    mov ecx, 0x9                                 # 004bde37
    {load} xor eax, eax                          # 004bde3c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bde3e
    je.d8 L_004bde56                             # 004bde40
    # block 0x004bde42: entered by fall-through of je at 0x004bde40, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004bde56
    mov ecx, dword ptr [ebp - local_4]           # 004bde42
    add ecx, 0x31c                               # 004bde45
    push ecx                                     # 004bde4b
    mov ecx, 0x5c3a67                            # 004bde4c
    call FUN_004fba69                            # 004bde51
L_004bde56:
    # block 0x004bde56: entered by je at 0x004bde40, 7 instruction(s), ends with je to 0x004bde82 (forward)
    mov edi, 0x552110                            # 004bde56
    mov esi, dword ptr [ebp - local_4]           # 004bde5b
    add esi, 0x34d                               # 004bde5e
    mov ecx, 0x9                                 # 004bde64
    {load} xor edx, edx                          # 004bde69
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bde6b
    je.d8 L_004bde82                             # 004bde6d
    # block 0x004bde6f: entered by fall-through of je at 0x004bde6d, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004bde82
    mov eax, dword ptr [ebp - local_4]           # 004bde6f
    add eax, 0x34d                               # 004bde72
    push eax                                     # 004bde77
    mov ecx, 0x5c3a67                            # 004bde78
    call FUN_004fba69                            # 004bde7d
L_004bde82:
    # block 0x004bde82: entered by je at 0x004bde6d, 7 instruction(s), ends with je to 0x004bdeae (forward)
    mov edi, 0x55211c                            # 004bde82
    mov esi, dword ptr [ebp - local_4]           # 004bde87
    add esi, 0x37e                               # 004bde8a
    mov ecx, 0x9                                 # 004bde90
    {load} xor edx, edx                          # 004bde95
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bde97
    je.d8 L_004bdeae                             # 004bde99
    # block 0x004bde9b: entered by fall-through of je at 0x004bde99, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004bdeae
    mov eax, dword ptr [ebp - local_4]           # 004bde9b
    add eax, 0x37e                               # 004bde9e
    push eax                                     # 004bdea3
    mov ecx, 0x5c3a67                            # 004bdea4
    call FUN_004fba69                            # 004bdea9
L_004bdeae:
    # block 0x004bdeae: entered by je at 0x004bde99, 7 instruction(s), ends with je to 0x004bdeda (forward)
    mov edi, 0x552128                            # 004bdeae
    mov esi, dword ptr [ebp - local_4]           # 004bdeb3
    add esi, 0x3af                               # 004bdeb6
    mov ecx, 0x9                                 # 004bdebc
    {load} xor edx, edx                          # 004bdec1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bdec3
    je.d8 L_004bdeda                             # 004bdec5
    # block 0x004bdec7: entered by fall-through of je at 0x004bdec5, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004bdeda
    mov eax, dword ptr [ebp - local_4]           # 004bdec7
    add eax, 0x3af                               # 004bdeca
    push eax                                     # 004bdecf
    mov ecx, 0x5c3a67                            # 004bded0
    call FUN_004fba69                            # 004bded5
L_004bdeda:
    # block 0x004bdeda: entered by je at 0x004bdec5, 7 instruction(s), ends with je to 0x004bdf06 (forward)
    mov edi, 0x552134                            # 004bdeda
    mov esi, dword ptr [ebp - local_4]           # 004bdedf
    add esi, 0x411                               # 004bdee2
    mov ecx, 0x9                                 # 004bdee8
    {load} xor edx, edx                          # 004bdeed
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bdeef
    je.d8 L_004bdf06                             # 004bdef1
    # block 0x004bdef3: entered by fall-through of je at 0x004bdef1, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004bdf06
    mov eax, dword ptr [ebp - local_4]           # 004bdef3
    add eax, 0x411                               # 004bdef6
    push eax                                     # 004bdefb
    mov ecx, 0x5c3a67                            # 004bdefc
    call FUN_004fba69                            # 004bdf01
L_004bdf06:
    # block 0x004bdf06: entered by je at 0x004bdef1, 7 instruction(s), ends with je to 0x004bdf32 (forward)
    mov edi, 0x552140                            # 004bdf06
    mov esi, dword ptr [ebp - local_4]           # 004bdf0b
    add esi, 0x3e0                               # 004bdf0e
    mov ecx, 0x9                                 # 004bdf14
    {load} xor edx, edx                          # 004bdf19
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004bdf1b
    je.d8 L_004bdf32                             # 004bdf1d
    # block 0x004bdf1f: entered by fall-through of je at 0x004bdf1d, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004bdf32
    mov eax, dword ptr [ebp - local_4]           # 004bdf1f
    add eax, 0x3e0                               # 004bdf22
    push eax                                     # 004bdf27
    mov ecx, 0x5c3a67                            # 004bdf28
    call FUN_004fba69                            # 004bdf2d
L_004bdf32:
    # block 0x004bdf32: entered by je at 0x004bdf1d, 3 instruction(s), ends with je to 0x004be047 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bdf32
    cmp dword ptr [ecx + field_38], 0x0          # 004bdf35
    je.d32 L_004be047                            # 004bdf39
    # block 0x004bdf3f: entered by fall-through of je at 0x004bdf39, 5 instruction(s), ends with je to 0x004be00f (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bdf3f
    mov eax, dword ptr [edx + field_18]          # 004bdf42
    movsx ecx, word ptr [eax + field_a1b]        # 004bdf45
    cmp ecx, 0x270f                              # 004bdf4c
    je.d32 L_004be00f                            # 004bdf52
    # block 0x004bdf58: entered by fall-through of je at 0x004bdf52, 33 instruction(s), ends with jne to 0x004bdffb (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bdf58
    mov eax, dword ptr [edx + field_18]          # 004bdf5b
    movsx ecx, word ptr [eax + field_a1b]        # 004bdf5e
    mov dword ptr [0x5bb57b], ecx                # 004bdf65
    mov edx, dword ptr [ebp - local_4]           # 004bdf6b
    mov eax, dword ptr [edx + field_18]          # 004bdf6e
    mov cx, word ptr [eax + field_a1d]           # 004bdf71
    mov word ptr [0x5bb599], cx                  # 004bdf78
    mov edx, dword ptr [ebp - local_4]           # 004bdf7f
    mov eax, dword ptr [edx + field_18]          # 004bdf82
    mov cx, word ptr [eax + field_a1f]           # 004bdf85
    mov word ptr [0x5bb595], cx                  # 004bdf8c
    mov edx, dword ptr [ebp - local_4]           # 004bdf93
    mov eax, dword ptr [edx + field_18]          # 004bdf96
    mov cx, word ptr [eax + field_a21]           # 004bdf99
    mov word ptr [0x5c39ff], cx                  # 004bdfa0
    mov edx, dword ptr [ebp - local_4]           # 004bdfa7
    mov eax, dword ptr [edx + field_18]          # 004bdfaa
    mov ecx, dword ptr [eax + field_a23]         # 004bdfad
    mov dword ptr [0x5bb59b], ecx                # 004bdfb3
    mov edx, dword ptr [ebp - local_4]           # 004bdfb9
    mov eax, dword ptr [edx + field_18]          # 004bdfbc
    mov ecx, dword ptr [eax + field_a27]         # 004bdfbf
    mov dword ptr [0x5bb59f], ecx                # 004bdfc5
    mov edx, dword ptr [ebp - local_4]           # 004bdfcb
    mov eax, dword ptr [edx + field_18]          # 004bdfce
    mov ecx, dword ptr [eax + field_a2b]         # 004bdfd1
    mov dword ptr [0x5bb5a3], ecx                # 004bdfd7
    mov edx, dword ptr [ebp - local_4]           # 004bdfdd
    mov eax, dword ptr [edx + field_18]          # 004bdfe0
    movsx ecx, word ptr [eax + field_a2f]        # 004bdfe3
    cmp ecx, 0x1                                 # 004bdfea
    jne.d8 L_004bdffb                            # 004bdfed
    # block 0x004bdfef: entered by fall-through of jne at 0x004bdfed, 2 instruction(s), ends with forward jump to 0x004be005
    mov dword ptr [0x5bb1ca], 0x0                # 004bdfef
    jmp.d8 L_004be005                            # 004bdff9
L_004bdffb:
    # block 0x004bdffb: entered by jne at 0x004bdfed, 1 instruction(s), falls into the block at 0x004be005
    mov dword ptr [0x5bb1ca], 0x1                # 004bdffb
L_004be005:
    # block 0x004be005: entered by jmp at 0x004bdff9, 1 instruction(s), falls into the block at 0x004be00f
    mov dword ptr [0x583999], 0x4                # 004be005
L_004be00f:
    # block 0x004be00f: entered by je at 0x004bdf52, 5 instruction(s), ends with je to 0x004be042 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004be00f
    mov eax, dword ptr [edx + field_18]          # 004be012
    movsx ecx, word ptr [eax + field_a31]        # 004be015
    cmp ecx, -0x1                                # 004be01c
    je.d8 L_004be042                             # 004be01f
    # block 0x004be021: entered by fall-through of je at 0x004be01f, 7 instruction(s), falls into the block at 0x004be042
    mov edx, dword ptr [ebp - local_4]           # 004be021
    mov eax, dword ptr [edx + field_18]          # 004be024
    movsx ecx, word ptr [eax + field_a33]        # 004be027
    mov edx, dword ptr [ebp - local_4]           # 004be02e
    mov eax, dword ptr [edx + field_18]          # 004be031
    movsx edx, word ptr [eax + field_a31]        # 004be034
    mov dword ptr [4*edx + 0x585801], ecx        # 004be03b
L_004be042:
    # block 0x004be042: entered by je at 0x004be01f, 1 instruction(s), ends with forward jump to 0x004be14f
    jmp.d32 L_004be14f                           # 004be042
L_004be047:
    # block 0x004be047: entered by je at 0x004bdf39, 3 instruction(s), ends with je to 0x004be14f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004be047
    cmp dword ptr [eax + field_40], 0x0          # 004be04a
    je.d32 L_004be14f                            # 004be04e
    # block 0x004be054: entered by fall-through of je at 0x004be04e, 5 instruction(s), ends with je to 0x004be11c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004be054
    mov edx, dword ptr [ecx + field_18]          # 004be057
    movsx eax, word ptr [edx + field_a66]        # 004be05a
    cmp eax, 0x270f                              # 004be061
    je.d32 L_004be11c                            # 004be066
    # block 0x004be06c: entered by fall-through of je at 0x004be066, 33 instruction(s), ends with jne to 0x004be108 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004be06c
    mov edx, dword ptr [ecx + field_18]          # 004be06f
    movsx eax, word ptr [edx + field_a66]        # 004be072
    mov dword ptr [0x5bb57b], eax                # 004be079
    mov ecx, dword ptr [ebp - local_4]           # 004be07e
    mov edx, dword ptr [ecx + field_18]          # 004be081
    mov ax, word ptr [edx + field_a68]           # 004be084
    mov word ptr [0x5bb599], ax                  # 004be08b
    mov ecx, dword ptr [ebp - local_4]           # 004be091
    mov edx, dword ptr [ecx + field_18]          # 004be094
    mov ax, word ptr [edx + field_a6a]           # 004be097
    mov word ptr [0x5bb595], ax                  # 004be09e
    mov ecx, dword ptr [ebp - local_4]           # 004be0a4
    mov edx, dword ptr [ecx + field_18]          # 004be0a7
    mov ax, word ptr [edx + field_a6c]           # 004be0aa
    mov word ptr [0x5c39ff], ax                  # 004be0b1
    mov ecx, dword ptr [ebp - local_4]           # 004be0b7
    mov edx, dword ptr [ecx + field_18]          # 004be0ba
    mov eax, dword ptr [edx + field_a6e]         # 004be0bd
    mov dword ptr [0x5bb59b], eax                # 004be0c3
    mov ecx, dword ptr [ebp - local_4]           # 004be0c8
    mov edx, dword ptr [ecx + field_18]          # 004be0cb
    mov eax, dword ptr [edx + field_a72]         # 004be0ce
    mov dword ptr [0x5bb59f], eax                # 004be0d4
    mov ecx, dword ptr [ebp - local_4]           # 004be0d9
    mov edx, dword ptr [ecx + field_18]          # 004be0dc
    mov eax, dword ptr [edx + field_a76]         # 004be0df
    mov dword ptr [0x5bb5a3], eax                # 004be0e5
    mov ecx, dword ptr [ebp - local_4]           # 004be0ea
    mov edx, dword ptr [ecx + field_18]          # 004be0ed
    movsx eax, word ptr [edx + field_a7a]        # 004be0f0
    cmp eax, 0x1                                 # 004be0f7
    jne.d8 L_004be108                            # 004be0fa
    # block 0x004be0fc: entered by fall-through of jne at 0x004be0fa, 2 instruction(s), ends with forward jump to 0x004be112
    mov dword ptr [0x5bb1ca], 0x0                # 004be0fc
    jmp.d8 L_004be112                            # 004be106
L_004be108:
    # block 0x004be108: entered by jne at 0x004be0fa, 1 instruction(s), falls into the block at 0x004be112
    mov dword ptr [0x5bb1ca], 0x1                # 004be108
L_004be112:
    # block 0x004be112: entered by jmp at 0x004be106, 1 instruction(s), falls into the block at 0x004be11c
    mov dword ptr [0x583999], 0x4                # 004be112
L_004be11c:
    # block 0x004be11c: entered by je at 0x004be066, 5 instruction(s), ends with je to 0x004be14f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004be11c
    mov edx, dword ptr [ecx + field_18]          # 004be11f
    movsx eax, word ptr [edx + field_a7c]        # 004be122
    cmp eax, -0x1                                # 004be129
    je.d8 L_004be14f                             # 004be12c
    # block 0x004be12e: entered by fall-through of je at 0x004be12c, 7 instruction(s), falls into the block at 0x004be14f
    mov ecx, dword ptr [ebp - local_4]           # 004be12e
    mov edx, dword ptr [ecx + field_18]          # 004be131
    movsx eax, word ptr [edx + field_a7e]        # 004be134
    mov ecx, dword ptr [ebp - local_4]           # 004be13b
    mov edx, dword ptr [ecx + field_18]          # 004be13e
    movsx ecx, word ptr [edx + field_a7c]        # 004be141
    mov dword ptr [4*ecx + 0x585801], eax        # 004be148
L_004be14f:
    # block 0x004be14f: entered by jmp at 0x004be042; je at 0x004be04e; je at 0x004be12c, 7 instruction(s), calls FUN_0042ba3a, FUN_004ba07f, falls into the block at 0x004be167
    mov edx, dword ptr [ebp - local_4]           # 004be14f
    mov ax, word ptr [edx + field_6]             # 004be152
    push eax                                     # 004be156
    call FUN_0042ba3a                            # 004be157
    add esp, 0x4                                 # 004be15c
    mov ecx, dword ptr [ebp - local_4]           # 004be15f
    call FUN_004ba07f                            # 004be162
L_004be167:
    # block 0x004be167: entered by jmp at 0x004bcabf; jmp at 0x004bd898; jmp at 0x004bde1a, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004be167
    pop esi                                      # 004be168
    {load} mov esp, ebp                          # 004be169
    pop ebp                                      # 004be16b
    ret 0x4                                      # 004be16c

# --- data items (not part of the function) -------------------------
.org 0x004be16f - 0x401000
SWTAB_004be16f:  # 7 case address(es)
    .long L_004bd8ba - .text + 0x401000
    .long L_004bd992 - .text + 0x401000
    .long L_004bdd29 - .text + 0x401000
    .long L_004bdc30 - .text + 0x401000
    .long L_004bddf9 - .text + 0x401000
    .long L_004bdbcd - .text + 0x401000
    .long L_004bddb2 - .text + 0x401000
.set SWTAB_004be16f_VA, SWTAB_004be16f - .text + 0x401000

