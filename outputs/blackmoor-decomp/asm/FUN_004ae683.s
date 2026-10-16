# FUN_004ae683
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ae683
# extent:       0x004ae683-0x004ae96c (745 code bytes)
# span:         0x004ae683-0x004ae96c (code 745, tables 0, padding 0)
# sha256:       4a13514f958a8edfc3e5b7018418de0327a722aaf00e2be7ca8bd9688d3d4109
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ae683
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       28 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 16 more
# fields:       [eax + n] field_4, field_8, field_c, field_26, field_e6d, field_e71; [ecx + n] field_4, field_8, field_c, field_20, field_6e; [edx + n] field_4, field_8, field_c, field_1c, field_27
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 250 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_6e, 0x6e  # offset +0x6e
.equ field_e6d, 0xe6d  # offset +0xe6d
.equ field_e71, 0xe71  # offset +0xe71

# --- external targets -----------------------------------------------

.org 0x004ae683 - 0x401000
.globl FUN_004ae683
FUN_004ae683:
    # block 0x004ae683: entry, 44 instruction(s), ends with jge to 0x004ae752 (forward)
    push ebp                                     # 004ae683
    {load} mov ebp, esp                          # 004ae684
    sub esp, 0x70                                # 004ae686
    mov dword ptr [ebp - local_70], ecx          # 004ae689
    mov eax, dword ptr [ebp + arg_8]             # 004ae68c
    imul eax, eax, 0xc7                          # 004ae68f
    mov ecx, dword ptr [ebp - local_70]          # 004ae695
    lea edx, [ecx + eax + field_6e]              # 004ae698
    mov dword ptr [ebp - local_68], edx          # 004ae69c
    mov eax, dword ptr [ebp - local_68]          # 004ae69f
    {load} xor ecx, ecx                          # 004ae6a2
    mov cl, byte ptr [eax + field_26]            # 004ae6a4
    imul ecx, ecx, 0x28                          # 004ae6a7
    mov edx, dword ptr [ebp - local_68]          # 004ae6aa
    lea eax, [edx + ecx + field_27]              # 004ae6ad
    mov dword ptr [ebp - local_4c], eax          # 004ae6b1
    mov ecx, dword ptr [ebp - local_68]          # 004ae6b4
    add ecx, 0x2                                 # 004ae6b7
    mov dword ptr [ebp - local_48], ecx          # 004ae6ba
    mov edx, dword ptr [ebp - local_4c]          # 004ae6bd
    mov eax, dword ptr [edx + field_1c]          # 004ae6c0
    mov dword ptr [ebp - local_14], eax          # 004ae6c3
    mov ecx, dword ptr [ebp - local_4c]          # 004ae6c6
    mov dx, word ptr [ecx + field_20]            # 004ae6c9
    mov word ptr [ebp - local_10], dx            # 004ae6cd
    mov eax, dword ptr [ebp - local_70]          # 004ae6d1
    mov ecx, dword ptr [eax + field_e6d]         # 004ae6d4
    mov dword ptr [ebp - local_54], ecx          # 004ae6da
    mov edx, dword ptr [ebp - local_70]          # 004ae6dd
    add edx, 0xe79                               # 004ae6e0
    mov dword ptr [ebp - local_18], edx          # 004ae6e6
    mov eax, dword ptr [ebp - local_70]          # 004ae6e9
    mov cx, word ptr [eax + field_e71]           # 004ae6ec
    mov word ptr [ebp - local_8], cx             # 004ae6f3
    or edx, -0x1                                 # 004ae6f7
    mov dword ptr [ebp - local_2c], edx          # 004ae6fa
    mov dword ptr [ebp - local_28], edx          # 004ae6fd
    mov dword ptr [ebp - local_24], edx          # 004ae700
    mov dword ptr [ebp - local_20], edx          # 004ae703
    mov eax, dword ptr [ebp - local_48]          # 004ae706
    mov ecx, dword ptr [ebp - local_18]          # 004ae709
    mov edx, dword ptr [eax]                     # 004ae70c
    cmp edx, dword ptr [ecx]                     # 004ae70e
    jge.d8 L_004ae752                            # 004ae710
    # block 0x004ae712: entered by fall-through of jge at 0x004ae710, 5 instruction(s), ends with jl to 0x004ae74b (forward)
    mov eax, dword ptr [ebp - local_48]          # 004ae712
    mov ecx, dword ptr [ebp - local_18]          # 004ae715
    mov edx, dword ptr [eax + field_8]           # 004ae718
    cmp edx, dword ptr [ecx]                     # 004ae71b
    jl.d8 L_004ae74b                             # 004ae71d
    # block 0x004ae71f: entered by fall-through of jl at 0x004ae71d, 8 instruction(s), ends with jle to 0x004ae740 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004ae71f
    mov ecx, dword ptr [eax]                     # 004ae722
    mov dword ptr [ebp - local_2c], ecx          # 004ae724
    mov edx, dword ptr [ebp - local_48]          # 004ae727
    mov eax, dword ptr [ebp - local_18]          # 004ae72a
    mov ecx, dword ptr [edx + field_8]           # 004ae72d
    cmp ecx, dword ptr [eax + field_8]           # 004ae730
    jle.d8 L_004ae740                            # 004ae733
    # block 0x004ae735: entered by fall-through of jle at 0x004ae733, 4 instruction(s), ends with forward jump to 0x004ae749
    mov edx, dword ptr [ebp - local_18]          # 004ae735
    mov eax, dword ptr [edx + field_8]           # 004ae738
    mov dword ptr [ebp - local_24], eax          # 004ae73b
    jmp.d8 L_004ae749                            # 004ae73e
L_004ae740:
    # block 0x004ae740: entered by jle at 0x004ae733, 3 instruction(s), falls into the block at 0x004ae749
    mov ecx, dword ptr [ebp - local_48]          # 004ae740
    mov edx, dword ptr [ecx + field_8]           # 004ae743
    mov dword ptr [ebp - local_24], edx          # 004ae746
L_004ae749:
    # block 0x004ae749: entered by jmp at 0x004ae73e, 1 instruction(s), ends with forward jump to 0x004ae750
    jmp.d8 L_004ae750                            # 004ae749
L_004ae74b:
    # block 0x004ae74b: entered by jl at 0x004ae71d, 1 instruction(s), ends with forward jump to 0x004ae966
    jmp.d32 L_004ae966                           # 004ae74b
L_004ae750:
    # block 0x004ae750: entered by jmp at 0x004ae749, 1 instruction(s), ends with forward jump to 0x004ae790
    jmp.d8 L_004ae790                            # 004ae750
L_004ae752:
    # block 0x004ae752: entered by jge at 0x004ae710, 5 instruction(s), ends with jg to 0x004ae78b (forward)
    mov eax, dword ptr [ebp - local_48]          # 004ae752
    mov ecx, dword ptr [ebp - local_18]          # 004ae755
    mov edx, dword ptr [eax]                     # 004ae758
    cmp edx, dword ptr [ecx + field_8]           # 004ae75a
    jg.d8 L_004ae78b                             # 004ae75d
    # block 0x004ae75f: entered by fall-through of jg at 0x004ae75d, 8 instruction(s), ends with jg to 0x004ae780 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004ae75f
    mov ecx, dword ptr [eax]                     # 004ae762
    mov dword ptr [ebp - local_2c], ecx          # 004ae764
    mov edx, dword ptr [ebp - local_48]          # 004ae767
    mov eax, dword ptr [ebp - local_18]          # 004ae76a
    mov ecx, dword ptr [edx + field_8]           # 004ae76d
    cmp ecx, dword ptr [eax + field_8]           # 004ae770
    jg.d8 L_004ae780                             # 004ae773
    # block 0x004ae775: entered by fall-through of jg at 0x004ae773, 4 instruction(s), ends with forward jump to 0x004ae789
    mov edx, dword ptr [ebp - local_48]          # 004ae775
    mov eax, dword ptr [edx + field_8]           # 004ae778
    mov dword ptr [ebp - local_24], eax          # 004ae77b
    jmp.d8 L_004ae789                            # 004ae77e
L_004ae780:
    # block 0x004ae780: entered by jg at 0x004ae773, 3 instruction(s), falls into the block at 0x004ae789
    mov ecx, dword ptr [ebp - local_18]          # 004ae780
    mov edx, dword ptr [ecx + field_8]           # 004ae783
    mov dword ptr [ebp - local_24], edx          # 004ae786
L_004ae789:
    # block 0x004ae789: entered by jmp at 0x004ae77e, 1 instruction(s), ends with forward jump to 0x004ae790
    jmp.d8 L_004ae790                            # 004ae789
L_004ae78b:
    # block 0x004ae78b: entered by jg at 0x004ae75d, 1 instruction(s), ends with forward jump to 0x004ae966
    jmp.d32 L_004ae966                           # 004ae78b
L_004ae790:
    # block 0x004ae790: entered by jmp at 0x004ae750; jmp at 0x004ae789, 5 instruction(s), ends with jge to 0x004ae7e0 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004ae790
    mov ecx, dword ptr [ebp - local_18]          # 004ae793
    mov edx, dword ptr [eax + field_4]           # 004ae796
    cmp edx, dword ptr [ecx + field_4]           # 004ae799
    jge.d8 L_004ae7e0                            # 004ae79c
    # block 0x004ae79e: entered by fall-through of jge at 0x004ae79c, 5 instruction(s), ends with jl to 0x004ae7d9 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004ae79e
    mov ecx, dword ptr [ebp - local_18]          # 004ae7a1
    mov edx, dword ptr [eax + field_c]           # 004ae7a4
    cmp edx, dword ptr [ecx + field_4]           # 004ae7a7
    jl.d8 L_004ae7d9                             # 004ae7aa
    # block 0x004ae7ac: entered by fall-through of jl at 0x004ae7aa, 8 instruction(s), ends with jle to 0x004ae7ce (forward)
    mov eax, dword ptr [ebp - local_18]          # 004ae7ac
    mov ecx, dword ptr [eax + field_4]           # 004ae7af
    mov dword ptr [ebp - local_28], ecx          # 004ae7b2
    mov edx, dword ptr [ebp - local_48]          # 004ae7b5
    mov eax, dword ptr [ebp - local_18]          # 004ae7b8
    mov ecx, dword ptr [edx + field_c]           # 004ae7bb
    cmp ecx, dword ptr [eax + field_c]           # 004ae7be
    jle.d8 L_004ae7ce                            # 004ae7c1
    # block 0x004ae7c3: entered by fall-through of jle at 0x004ae7c1, 4 instruction(s), ends with forward jump to 0x004ae7d7
    mov edx, dword ptr [ebp - local_18]          # 004ae7c3
    mov eax, dword ptr [edx + field_c]           # 004ae7c6
    mov dword ptr [ebp - local_20], eax          # 004ae7c9
    jmp.d8 L_004ae7d7                            # 004ae7cc
L_004ae7ce:
    # block 0x004ae7ce: entered by jle at 0x004ae7c1, 3 instruction(s), falls into the block at 0x004ae7d7
    mov ecx, dword ptr [ebp - local_48]          # 004ae7ce
    mov edx, dword ptr [ecx + field_c]           # 004ae7d1
    mov dword ptr [ebp - local_20], edx          # 004ae7d4
L_004ae7d7:
    # block 0x004ae7d7: entered by jmp at 0x004ae7cc, 1 instruction(s), ends with forward jump to 0x004ae7de
    jmp.d8 L_004ae7de                            # 004ae7d7
L_004ae7d9:
    # block 0x004ae7d9: entered by jl at 0x004ae7aa, 1 instruction(s), ends with forward jump to 0x004ae966
    jmp.d32 L_004ae966                           # 004ae7d9
L_004ae7de:
    # block 0x004ae7de: entered by jmp at 0x004ae7d7, 1 instruction(s), ends with forward jump to 0x004ae820
    jmp.d8 L_004ae820                            # 004ae7de
L_004ae7e0:
    # block 0x004ae7e0: entered by jge at 0x004ae79c, 5 instruction(s), ends with jg to 0x004ae81b (forward)
    mov eax, dword ptr [ebp - local_48]          # 004ae7e0
    mov ecx, dword ptr [ebp - local_18]          # 004ae7e3
    mov edx, dword ptr [eax + field_4]           # 004ae7e6
    cmp edx, dword ptr [ecx + field_c]           # 004ae7e9
    jg.d8 L_004ae81b                             # 004ae7ec
    # block 0x004ae7ee: entered by fall-through of jg at 0x004ae7ec, 8 instruction(s), ends with jg to 0x004ae810 (forward)
    mov eax, dword ptr [ebp - local_48]          # 004ae7ee
    mov ecx, dword ptr [eax + field_4]           # 004ae7f1
    mov dword ptr [ebp - local_28], ecx          # 004ae7f4
    mov edx, dword ptr [ebp - local_48]          # 004ae7f7
    mov eax, dword ptr [ebp - local_18]          # 004ae7fa
    mov ecx, dword ptr [edx + field_c]           # 004ae7fd
    cmp ecx, dword ptr [eax + field_c]           # 004ae800
    jg.d8 L_004ae810                             # 004ae803
    # block 0x004ae805: entered by fall-through of jg at 0x004ae803, 4 instruction(s), ends with forward jump to 0x004ae819
    mov edx, dword ptr [ebp - local_48]          # 004ae805
    mov eax, dword ptr [edx + field_c]           # 004ae808
    mov dword ptr [ebp - local_20], eax          # 004ae80b
    jmp.d8 L_004ae819                            # 004ae80e
L_004ae810:
    # block 0x004ae810: entered by jg at 0x004ae803, 3 instruction(s), falls into the block at 0x004ae819
    mov ecx, dword ptr [ebp - local_18]          # 004ae810
    mov edx, dword ptr [ecx + field_c]           # 004ae813
    mov dword ptr [ebp - local_20], edx          # 004ae816
L_004ae819:
    # block 0x004ae819: entered by jmp at 0x004ae80e, 1 instruction(s), ends with forward jump to 0x004ae820
    jmp.d8 L_004ae820                            # 004ae819
L_004ae81b:
    # block 0x004ae81b: entered by jg at 0x004ae7ec, 1 instruction(s), ends with forward jump to 0x004ae966
    jmp.d32 L_004ae966                           # 004ae81b
L_004ae820:
    # block 0x004ae820: entered by jmp at 0x004ae7de; jmp at 0x004ae819, 2 instruction(s), ends with je to 0x004ae838 (forward)
    cmp dword ptr [ebp - local_28], -0x1         # 004ae820
    je.d8 L_004ae838                             # 004ae824
    # block 0x004ae826: entered by fall-through of je at 0x004ae824, 2 instruction(s), ends with je to 0x004ae838 (forward)
    cmp dword ptr [ebp - local_20], -0x1         # 004ae826
    je.d8 L_004ae838                             # 004ae82a
    # block 0x004ae82c: entered by fall-through of je at 0x004ae82a, 2 instruction(s), ends with je to 0x004ae838 (forward)
    cmp dword ptr [ebp - local_2c], -0x1         # 004ae82c
    je.d8 L_004ae838                             # 004ae830
    # block 0x004ae832: entered by fall-through of je at 0x004ae830, 2 instruction(s), ends with jne to 0x004ae83d (forward)
    cmp dword ptr [ebp - local_24], -0x1         # 004ae832
    jne.d8 L_004ae83d                            # 004ae836
L_004ae838:
    # block 0x004ae838: entered by je at 0x004ae824; je at 0x004ae82a; je at 0x004ae830; fall-through of jne at 0x004ae836, 1 instruction(s), ends with forward jump to 0x004ae966
    jmp.d32 L_004ae966                           # 004ae838
L_004ae83d:
    # block 0x004ae83d: entered by jne at 0x004ae836, 37 instruction(s), ends with forward jump to 0x004ae8b9
    mov eax, dword ptr [ebp - local_48]          # 004ae83d
    mov ecx, dword ptr [ebp - local_2c]          # 004ae840
    sub ecx, dword ptr [eax]                     # 004ae843
    mov dword ptr [ebp - local_5c], ecx          # 004ae845
    mov edx, dword ptr [ebp - local_48]          # 004ae848
    mov eax, dword ptr [ebp - local_24]          # 004ae84b
    sub eax, dword ptr [edx]                     # 004ae84e
    mov dword ptr [ebp - local_3c], eax          # 004ae850
    mov ecx, dword ptr [ebp - local_48]          # 004ae853
    mov edx, dword ptr [ebp - local_28]          # 004ae856
    sub edx, dword ptr [ecx + field_4]           # 004ae859
    mov dword ptr [ebp - local_60], edx          # 004ae85c
    mov eax, dword ptr [ebp - local_48]          # 004ae85f
    mov ecx, dword ptr [ebp - local_20]          # 004ae862
    sub ecx, dword ptr [eax + field_4]           # 004ae865
    mov dword ptr [ebp - local_c], ecx           # 004ae868
    mov edx, dword ptr [ebp - local_18]          # 004ae86b
    mov eax, dword ptr [ebp - local_2c]          # 004ae86e
    sub eax, dword ptr [edx]                     # 004ae871
    mov dword ptr [ebp - local_6c], eax          # 004ae873
    mov ecx, dword ptr [ebp - local_18]          # 004ae876
    mov edx, dword ptr [ebp - local_24]          # 004ae879
    sub edx, dword ptr [ecx]                     # 004ae87c
    mov dword ptr [ebp - local_50], edx          # 004ae87e
    mov eax, dword ptr [ebp - local_18]          # 004ae881
    mov ecx, dword ptr [ebp - local_28]          # 004ae884
    sub ecx, dword ptr [eax + field_4]           # 004ae887
    mov dword ptr [ebp - local_64], ecx          # 004ae88a
    mov edx, dword ptr [ebp - local_18]          # 004ae88d
    mov eax, dword ptr [ebp - local_20]          # 004ae890
    sub eax, dword ptr [edx + field_4]           # 004ae893
    mov dword ptr [ebp - local_58], eax          # 004ae896
    mov ecx, dword ptr [ebp - local_60]          # 004ae899
    mov dword ptr [ebp - local_38], ecx          # 004ae89c
    mov edx, dword ptr [ebp - local_64]          # 004ae89f
    mov dword ptr [ebp - local_30], edx          # 004ae8a2
    jmp.d8 L_004ae8b9                            # 004ae8a5
L_004ae8a7:
    # block 0x004ae8a7: entered by jmp at 0x004ae961, 6 instruction(s), falls into the block at 0x004ae8b9
    mov eax, dword ptr [ebp - local_38]          # 004ae8a7
    add eax, 0x1                                 # 004ae8aa
    mov dword ptr [ebp - local_38], eax          # 004ae8ad
    mov ecx, dword ptr [ebp - local_30]          # 004ae8b0
    add ecx, 0x1                                 # 004ae8b3
    mov dword ptr [ebp - local_30], ecx          # 004ae8b6
L_004ae8b9:
    # block 0x004ae8b9: entered by jmp at 0x004ae8a5, 3 instruction(s), ends with jg to 0x004ae966 (forward)
    mov edx, dword ptr [ebp - local_38]          # 004ae8b9
    cmp edx, dword ptr [ebp - local_c]           # 004ae8bc
    jg.d32 L_004ae966                            # 004ae8bf
    # block 0x004ae8c5: entered by fall-through of jg at 0x004ae8bf, 5 instruction(s), ends with forward jump to 0x004ae8e5
    mov eax, dword ptr [ebp - local_5c]          # 004ae8c5
    mov dword ptr [ebp - local_34], eax          # 004ae8c8
    mov ecx, dword ptr [ebp - local_6c]          # 004ae8cb
    mov dword ptr [ebp - local_1c], ecx          # 004ae8ce
    jmp.d8 L_004ae8e5                            # 004ae8d1
L_004ae8d3:
    # block 0x004ae8d3: entered by jmp at 0x004ae95c, 6 instruction(s), falls into the block at 0x004ae8e5
    mov edx, dword ptr [ebp - local_34]          # 004ae8d3
    add edx, 0x1                                 # 004ae8d6
    mov dword ptr [ebp - local_34], edx          # 004ae8d9
    mov eax, dword ptr [ebp - local_1c]          # 004ae8dc
    add eax, 0x1                                 # 004ae8df
    mov dword ptr [ebp - local_1c], eax          # 004ae8e2
L_004ae8e5:
    # block 0x004ae8e5: entered by jmp at 0x004ae8d1, 3 instruction(s), ends with jg to 0x004ae961 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004ae8e5
    cmp ecx, dword ptr [ebp - local_3c]          # 004ae8e8
    jg.d8 L_004ae961                             # 004ae8eb
    # block 0x004ae8ed: entered by fall-through of jg at 0x004ae8eb, 12 instruction(s), ends with je to 0x004ae95c (forward)
    movsx edx, word ptr [ebp - local_10]         # 004ae8ed
    mov eax, dword ptr [ebp - local_38]          # 004ae8f1
    imul eax, edx                                # 004ae8f4
    mov ecx, dword ptr [ebp - local_14]          # 004ae8f7
    {load} add ecx, eax                          # 004ae8fa
    mov edx, dword ptr [ebp - local_34]          # 004ae8fc
    mov al, byte ptr [ecx + edx]                 # 004ae8ff
    mov byte ptr [ebp - local_4], al             # 004ae902
    mov ecx, dword ptr [ebp - local_4]           # 004ae905
    and ecx, 0xff                                # 004ae908
    test ecx, ecx                                # 004ae90e
    je.d8 L_004ae95c                             # 004ae910
    # block 0x004ae912: entered by fall-through of je at 0x004ae910, 14 instruction(s), ends with je to 0x004ae95c (forward)
    movsx edx, word ptr [ebp - local_8]          # 004ae912
    mov eax, dword ptr [ebp - local_30]          # 004ae916
    imul eax, edx                                # 004ae919
    mov ecx, dword ptr [ebp - local_54]          # 004ae91c
    {load} add ecx, eax                          # 004ae91f
    add ecx, dword ptr [ebp - local_1c]          # 004ae921
    mov dword ptr [ebp - local_40], ecx          # 004ae924
    mov edx, dword ptr [ebp - local_40]          # 004ae927
    mov al, byte ptr [edx]                       # 004ae92a
    mov byte ptr [ebp - local_44], al            # 004ae92c
    mov ecx, dword ptr [ebp - local_44]          # 004ae92f
    and ecx, 0xff                                # 004ae932
    test ecx, ecx                                # 004ae938
    je.d8 L_004ae95c                             # 004ae93a
    # block 0x004ae93c: entered by fall-through of je at 0x004ae93a, 5 instruction(s), ends with jle to 0x004ae95c (forward)
    mov edx, dword ptr [ebp - local_44]          # 004ae93c
    and edx, 0xff                                # 004ae93f
    and edx, 0x7f                                # 004ae945
    test edx, edx                                # 004ae948
    jle.d8 L_004ae95c                            # 004ae94a
    # block 0x004ae94c: entered by fall-through of jle at 0x004ae94a, 6 instruction(s), falls into the block at 0x004ae95c
    mov al, byte ptr [ebp - local_44]            # 004ae94c
    sub al, 0x1                                  # 004ae94f
    mov byte ptr [ebp - local_44], al            # 004ae951
    mov ecx, dword ptr [ebp - local_40]          # 004ae954
    mov dl, byte ptr [ebp - local_44]            # 004ae957
    mov byte ptr [ecx], dl                       # 004ae95a
L_004ae95c:
    # block 0x004ae95c: entered by je at 0x004ae910; je at 0x004ae93a; jle at 0x004ae94a, 1 instruction(s), ends with backward jump to 0x004ae8d3
    jmp.d32 L_004ae8d3                           # 004ae95c
L_004ae961:
    # block 0x004ae961: entered by jg at 0x004ae8eb, 1 instruction(s), ends with backward jump to 0x004ae8a7
    jmp.d32 L_004ae8a7                           # 004ae961
L_004ae966:
    # block 0x004ae966: entered by jmp at 0x004ae74b; jmp at 0x004ae78b; jmp at 0x004ae7d9; jmp at 0x004ae81b; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004ae966
    pop ebp                                      # 004ae968
    ret 0x4                                      # 004ae969

