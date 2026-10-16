# FUN_004f95a4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f95a4
# extent:       0x004f95a4-0x004f9b50 (1452 code bytes)
# span:         0x004f95a4-0x004f9b50 (code 1452, tables 0, padding 0)
# sha256:       54bf920ee46659fa42b4dd906a983249355ffe3968509ae66862d5b43a8e14bd
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f95a4
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_2c, field_3c, field_40, field_48, field_54, field_58, field_60, field_64, field_68, field_6c, field_74, field_78 and 6 more; [ecx + n] field_34, field_38, field_3c, field_44, field_60, field_64, field_68, field_6c, field_74, field_80, field_84, field_12c and 5 more; [edx + n] field_30, field_3c, field_44, field_48, field_4c, field_50, field_5c, field_60, field_64, field_68, field_70, field_7c and 8 more
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004f8bdc, FUN_004f9234, FUN_004f93ec, FUN_0050ca3e, FUN_0044a2b7, FUN_004f9f92, FUN_004f8f94, FUN_004f9040, FUN_004f9b50, FUN_0050df94, FUN_004f9d18
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 419 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
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
.equ field_e1, 0xe1  # offset +0xe1
.equ field_e5, 0xe5  # offset +0xe5
.equ field_12c, 0x12c  # offset +0x12c
.equ field_28b, 0x28b  # offset +0x28b
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d6, 0x3d6  # offset +0x3d6

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f8bdc, .text + (0x004f8bdc - 0x401000)
.set FUN_004f8f94, .text + (0x004f8f94 - 0x401000)
.set FUN_004f9040, .text + (0x004f9040 - 0x401000)
.set FUN_004f9234, .text + (0x004f9234 - 0x401000)
.set FUN_004f93ec, .text + (0x004f93ec - 0x401000)
.set FUN_004f9b50, .text + (0x004f9b50 - 0x401000)
.set FUN_004f9d18, .text + (0x004f9d18 - 0x401000)
.set FUN_004f9f92, .text + (0x004f9f92 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050df94, .text + (0x0050df94 - 0x401000)

.org 0x004f95a4 - 0x401000
.globl FUN_004f95a4
FUN_004f95a4:
    # block 0x004f95a4: entry, 18 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004f9b48 (forward)
    push ebp                                     # 004f95a4
    {load} mov ebp, esp                          # 004f95a5
    sub esp, 0x38                                # 004f95a7
    mov dword ptr [ebp - local_10], ecx          # 004f95aa
    mov eax, dword ptr [ebp + arg_8]             # 004f95ad
    imul eax, eax, 0x5bb                         # 004f95b0
    mov ecx, dword ptr [ebp - local_10]          # 004f95b6
    mov edx, dword ptr [ecx + field_3ce]         # 004f95b9
    {load} add edx, eax                          # 004f95bf
    mov dword ptr [ebp - local_c], edx           # 004f95c1
    mov eax, dword ptr [ebp - local_c]           # 004f95c4
    add eax, 0x19e                               # 004f95c7
    mov dword ptr [ebp - local_4], eax           # 004f95cc
    call dword ptr [0x52a23c]                    # 004f95cf
    mov dword ptr [ebp - local_8], eax           # 004f95d5
    mov ecx, dword ptr [ebp - local_c]           # 004f95d8
    cmp dword ptr [ecx + field_29b], 0x0         # 004f95db
    je.d32 L_004f9b48                            # 004f95e2
    # block 0x004f95e8: entered by fall-through of je at 0x004f95e2, 6 instruction(s), ends with jne to 0x004f9636 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004f95e8
    {load} xor eax, eax                          # 004f95eb
    mov ax, word ptr [edx + field_12c]           # 004f95ed
    and eax, 0x20                                # 004f95f4
    test eax, eax                                # 004f95f7
    jne.d8 L_004f9636                            # 004f95f9
    # block 0x004f95fb: entered by fall-through of jne at 0x004f95f9, 5 instruction(s), ends with je to 0x004f9636 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f95fb
    {load} xor edx, edx                          # 004f95fe
    mov dx, word ptr [ecx + field_12c]           # 004f9600
    cmp edx, 0x3                                 # 004f9607
    je.d8 L_004f9636                             # 004f960a
    # block 0x004f960c: entered by fall-through of je at 0x004f960a, 5 instruction(s), ends with je to 0x004f9636 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004f960c
    {load} xor ecx, ecx                          # 004f960f
    mov cx, word ptr [eax + field_12c]           # 004f9611
    cmp ecx, 0x7                                 # 004f9618
    je.d8 L_004f9636                             # 004f961b
    # block 0x004f961d: entered by fall-through of je at 0x004f961b, 6 instruction(s), ends with je to 0x004f96fb (forward)
    mov edx, dword ptr [ebp - local_c]           # 004f961d
    {load} xor eax, eax                          # 004f9620
    mov ax, word ptr [edx + field_12c]           # 004f9622
    and eax, 0x100                               # 004f9629
    test eax, eax                                # 004f962e
    je.d32 L_004f96fb                            # 004f9630
L_004f9636:
    # block 0x004f9636: entered by jne at 0x004f95f9; je at 0x004f960a; je at 0x004f961b; fall-through of je at 0x004f9630, 33 instruction(s), calls FUN_004f8bdc, FUN_004f9234, FUN_004f93ec, ends with je to 0x004f96f9 (forward)
    push 0x0                                     # 004f9636
    mov ecx, dword ptr [ebp + arg_8]             # 004f9638
    push ecx                                     # 004f963b
    mov ecx, dword ptr [ebp - local_10]          # 004f963c
    call FUN_004f8bdc                            # 004f963f
    mov edx, dword ptr [ebp - local_4]           # 004f9644
    fild dword ptr [edx + field_e1]              # 004f9647
    fstp dword ptr [ebp - local_14]              # 004f964d
    mov eax, dword ptr [ebp - local_14]          # 004f9650
    push eax                                     # 004f9653
    mov ecx, dword ptr [ebp + arg_8]             # 004f9654
    push ecx                                     # 004f9657
    mov ecx, dword ptr [ebp - local_10]          # 004f9658
    call FUN_004f9234                            # 004f965b
    mov edx, dword ptr [ebp - local_4]           # 004f9660
    fild dword ptr [edx + field_e5]              # 004f9663
    fstp dword ptr [ebp - local_18]              # 004f9669
    mov eax, dword ptr [ebp - local_18]          # 004f966c
    push eax                                     # 004f966f
    mov ecx, dword ptr [ebp + arg_8]             # 004f9670
    push ecx                                     # 004f9673
    mov ecx, dword ptr [ebp - local_10]          # 004f9674
    call FUN_004f93ec                            # 004f9677
    mov edx, dword ptr [ebp - local_c]           # 004f967c
    mov dword ptr [edx + field_28b], 0x1         # 004f967f
    mov eax, dword ptr [ebp - local_10]          # 004f9689
    mov ecx, dword ptr [eax + field_3d6]         # 004f968c
    add ecx, 0x1                                 # 004f9692
    mov edx, dword ptr [ebp - local_10]          # 004f9695
    mov dword ptr [edx + field_3d6], ecx         # 004f9698
    movsx eax, word ptr [0x63a4cd]               # 004f969e
    test eax, eax                                # 004f96a5
    je.d8 L_004f96f9                             # 004f96a7
    # block 0x004f96a9: entered by fall-through of je at 0x004f96a7, 23 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f96f9
    mov ecx, dword ptr [ebp - local_10]          # 004f96a9
    mov edx, dword ptr [ecx + field_3d6]         # 004f96ac
    push edx                                     # 004f96b2
    mov eax, dword ptr [ebp - local_4]           # 004f96b3
    mov ecx, dword ptr [eax + field_e5]          # 004f96b6
    push ecx                                     # 004f96bc
    mov edx, dword ptr [ebp - local_4]           # 004f96bd
    mov eax, dword ptr [edx + field_e1]          # 004f96c0
    push eax                                     # 004f96c6
    push 0x0                                     # 004f96c7
    mov ecx, dword ptr [ebp - local_c]           # 004f96c9
    {load} xor edx, edx                          # 004f96cc
    mov dx, word ptr [ecx + field_12c]           # 004f96ce
    push edx                                     # 004f96d5
    mov eax, dword ptr [ebp + arg_8]             # 004f96d6
    push eax                                     # 004f96d9
    push 0x55f254                                # 004f96da
    push 0x63888b                                # 004f96df
    call FUN_0050ca3e                            # 004f96e4
    add esp, 0x20                                # 004f96e9
    push 0x63888b                                # 004f96ec
    call FUN_0044a2b7                            # 004f96f1
    add esp, 0x4                                 # 004f96f6
L_004f96f9:
    # block 0x004f96f9: entered by je at 0x004f96a7, 1 instruction(s), ends with forward jump to 0x004f975b
    jmp.d8 L_004f975b                            # 004f96f9
L_004f96fb:
    # block 0x004f96fb: entered by je at 0x004f9630, 10 instruction(s), calls FUN_004f8bdc, ends with je to 0x004f9751 (forward)
    push 0x2                                     # 004f96fb
    mov ecx, dword ptr [ebp + arg_8]             # 004f96fd
    push ecx                                     # 004f9700
    mov ecx, dword ptr [ebp - local_10]          # 004f9701
    call FUN_004f8bdc                            # 004f9704
    mov edx, dword ptr [ebp - local_c]           # 004f9709
    mov dword ptr [edx + field_28b], 0x0         # 004f970c
    movsx eax, word ptr [0x63a4cd]               # 004f9716
    test eax, eax                                # 004f971d
    je.d8 L_004f9751                             # 004f971f
    # block 0x004f9721: entered by fall-through of je at 0x004f971f, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f9751
    mov ecx, dword ptr [ebp - local_c]           # 004f9721
    {load} xor edx, edx                          # 004f9724
    mov dx, word ptr [ecx + field_12c]           # 004f9726
    push edx                                     # 004f972d
    mov eax, dword ptr [ebp + arg_8]             # 004f972e
    push eax                                     # 004f9731
    push 0x55f2d8                                # 004f9732
    push 0x63888b                                # 004f9737
    call FUN_0050ca3e                            # 004f973c
    add esp, 0x10                                # 004f9741
    push 0x63888b                                # 004f9744
    call FUN_0044a2b7                            # 004f9749
    add esp, 0x4                                 # 004f974e
L_004f9751:
    # block 0x004f9751: entered by je at 0x004f971f, 2 instruction(s), ends with forward jump to 0x004f9b4a
    mov eax, 0x1                                 # 004f9751
    jmp.d32 L_004f9b4a                           # 004f9756
L_004f975b:
    # block 0x004f975b: entered by jmp at 0x004f96f9, 6 instruction(s), ends with je to 0x004f979c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f975b
    {load} xor edx, edx                          # 004f975e
    mov dx, word ptr [ecx + field_12c]           # 004f9760
    and edx, 0x20                                # 004f9767
    test edx, edx                                # 004f976a
    je.d8 L_004f979c                             # 004f976c
    # block 0x004f976e: entered by fall-through of je at 0x004f976c, 15 instruction(s), calls FUN_004f9f92, FUN_004f8f94, FUN_004f9040, falls into the block at 0x004f979c
    mov eax, dword ptr [ebp + arg_8]             # 004f976e
    push eax                                     # 004f9771
    mov ecx, dword ptr [ebp - local_10]          # 004f9772
    call FUN_004f9f92                            # 004f9775
    mov ecx, dword ptr [ebp + arg_8]             # 004f977a
    push ecx                                     # 004f977d
    mov ecx, dword ptr [ebp - local_10]          # 004f977e
    call FUN_004f8f94                            # 004f9781
    mov edx, dword ptr [ebp - local_c]           # 004f9786
    add edx, 0x2a3                               # 004f9789
    push edx                                     # 004f978f
    mov eax, dword ptr [ebp + arg_8]             # 004f9790
    push eax                                     # 004f9793
    mov ecx, dword ptr [ebp - local_10]          # 004f9794
    call FUN_004f9040                            # 004f9797
L_004f979c:
    # block 0x004f979c: entered by je at 0x004f976c, 5 instruction(s), ends with jne to 0x004f9801 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004f979c
    {load} xor edx, edx                          # 004f979f
    mov dx, word ptr [ecx + field_12c]           # 004f97a1
    cmp edx, 0x3                                 # 004f97a8
    jne.d8 L_004f9801                            # 004f97ab
    # block 0x004f97ad: entered by fall-through of jne at 0x004f97ab, 24 instruction(s), calls FUN_004f8f94, FUN_004f9040, ends with forward jump to 0x004f9b41
    mov eax, dword ptr [ebp - local_4]           # 004f97ad
    fild dword ptr [eax + field_2c]              # 004f97b0
    mov ecx, dword ptr [ebp - local_c]           # 004f97b3
    fstp dword ptr [ecx + field_2a3]             # 004f97b6
    mov edx, dword ptr [ebp - local_4]           # 004f97bc
    fild dword ptr [edx + field_30]              # 004f97bf
    mov eax, dword ptr [ebp - local_c]           # 004f97c2
    fstp dword ptr [eax + field_2a7]             # 004f97c5
    mov ecx, dword ptr [ebp - local_4]           # 004f97cb
    fild dword ptr [ecx + field_34]              # 004f97ce
    mov edx, dword ptr [ebp - local_c]           # 004f97d1
    fstp dword ptr [edx + field_2ab]             # 004f97d4
    mov eax, dword ptr [ebp + arg_8]             # 004f97da
    push eax                                     # 004f97dd
    mov ecx, dword ptr [ebp - local_10]          # 004f97de
    call FUN_004f8f94                            # 004f97e1
    mov ecx, dword ptr [ebp - local_c]           # 004f97e6
    add ecx, 0x2a3                               # 004f97e9
    push ecx                                     # 004f97ef
    mov edx, dword ptr [ebp + arg_8]             # 004f97f0
    push edx                                     # 004f97f3
    mov ecx, dword ptr [ebp - local_10]          # 004f97f4
    call FUN_004f9040                            # 004f97f7
    jmp.d32 L_004f9b41                           # 004f97fc
L_004f9801:
    # block 0x004f9801: entered by jne at 0x004f97ab, 5 instruction(s), ends with jne to 0x004f9823 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004f9801
    {load} xor ecx, ecx                          # 004f9804
    mov cx, word ptr [eax + field_12c]           # 004f9806
    cmp ecx, 0x7                                 # 004f980d
    jne.d8 L_004f9823                            # 004f9810
    # block 0x004f9812: entered by fall-through of jne at 0x004f9810, 5 instruction(s), calls FUN_004f9b50, ends with forward jump to 0x004f9b41
    mov edx, dword ptr [ebp + arg_8]             # 004f9812
    push edx                                     # 004f9815
    mov ecx, dword ptr [ebp - local_10]          # 004f9816
    call FUN_004f9b50                            # 004f9819
    jmp.d32 L_004f9b41                           # 004f981e
L_004f9823:
    # block 0x004f9823: entered by jne at 0x004f9810, 5 instruction(s), ends with jne to 0x004f99ed (forward)
    mov eax, dword ptr [ebp - local_c]           # 004f9823
    {load} xor ecx, ecx                          # 004f9826
    mov cx, word ptr [eax + field_12c]           # 004f9828
    cmp ecx, 0x100                               # 004f982f
    jne.d32 L_004f99ed                           # 004f9835
    # block 0x004f983b: entered by fall-through of jne at 0x004f9835, 101 instruction(s), calls FUN_0050df94, FUN_004f8f94, FUN_004f9040, ends with je to 0x004f99e8 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f983b
    mov eax, dword ptr [ebp - local_4]           # 004f983e
    mov ecx, dword ptr [edx + field_70]          # 004f9841
    sub ecx, dword ptr [eax + field_6c]          # 004f9844
    mov dword ptr [ebp - local_1c], ecx          # 004f9847
    fild dword ptr [ebp - local_1c]              # 004f984a
    mov edx, dword ptr [ebp - local_4]           # 004f984d
    fstp dword ptr [edx + field_60]              # 004f9850
    mov eax, dword ptr [ebp - local_4]           # 004f9853
    mov ecx, dword ptr [ebp - local_4]           # 004f9856
    mov edx, dword ptr [eax + field_78]          # 004f9859
    sub edx, dword ptr [ecx + field_74]          # 004f985c
    mov dword ptr [ebp - local_20], edx          # 004f985f
    fild dword ptr [ebp - local_20]              # 004f9862
    mov eax, dword ptr [ebp - local_4]           # 004f9865
    fstp dword ptr [eax + field_64]              # 004f9868
    mov ecx, dword ptr [ebp - local_4]           # 004f986b
    mov edx, dword ptr [ebp - local_4]           # 004f986e
    mov eax, dword ptr [ecx + field_80]          # 004f9871
    sub eax, dword ptr [edx + field_7c]          # 004f9877
    mov dword ptr [ebp - local_24], eax          # 004f987a
    fild dword ptr [ebp - local_24]              # 004f987d
    mov ecx, dword ptr [ebp - local_4]           # 004f9880
    fstp dword ptr [ecx + field_68]              # 004f9883
    mov edx, dword ptr [ebp - local_4]           # 004f9886
    mov eax, dword ptr [ebp - local_4]           # 004f9889
    fld dword ptr [edx + field_60]               # 004f988c
    fmul dword ptr [eax + field_60]              # 004f988f
    mov ecx, dword ptr [ebp - local_4]           # 004f9892
    mov edx, dword ptr [ebp - local_4]           # 004f9895
    fld dword ptr [ecx + field_64]               # 004f9898
    fmul dword ptr [edx + field_64]              # 004f989b
    faddp st(1), st                              # 004f989e
    mov eax, dword ptr [ebp - local_4]           # 004f98a0
    mov ecx, dword ptr [ebp - local_4]           # 004f98a3
    fld dword ptr [eax + field_68]               # 004f98a6
    fmul dword ptr [ecx + field_68]              # 004f98a9
    faddp st(1), st                              # 004f98ac
    sub esp, 0x8                                 # 004f98ae
    fstp qword ptr [esp]                         # 004f98b1
    call FUN_0050df94                            # 004f98b4
    add esp, 0x8                                 # 004f98b9
    mov edx, dword ptr [ebp - local_4]           # 004f98bc
    fstp dword ptr [edx + field_5c]              # 004f98bf
    mov eax, dword ptr [ebp - local_4]           # 004f98c2
    fild dword ptr [eax + field_3c]              # 004f98c5
    fstp dword ptr [ebp - local_28]              # 004f98c8
    mov ecx, dword ptr [ebp - local_4]           # 004f98cb
    fld dword ptr [ecx + field_60]               # 004f98ce
    fdiv dword ptr [ebp - local_28]              # 004f98d1
    mov edx, dword ptr [ebp - local_4]           # 004f98d4
    fstp dword ptr [edx + field_44]              # 004f98d7
    mov eax, dword ptr [ebp - local_4]           # 004f98da
    fild dword ptr [eax + field_3c]              # 004f98dd
    fstp dword ptr [ebp - local_2c]              # 004f98e0
    mov ecx, dword ptr [ebp - local_4]           # 004f98e3
    fld dword ptr [ecx + field_64]               # 004f98e6
    fdiv dword ptr [ebp - local_2c]              # 004f98e9
    mov edx, dword ptr [ebp - local_4]           # 004f98ec
    fstp dword ptr [edx + field_48]              # 004f98ef
    mov eax, dword ptr [ebp - local_4]           # 004f98f2
    fild dword ptr [eax + field_3c]              # 004f98f5
    fstp dword ptr [ebp - local_30]              # 004f98f8
    mov ecx, dword ptr [ebp - local_4]           # 004f98fb
    fld dword ptr [ecx + field_68]               # 004f98fe
    fdiv dword ptr [ebp - local_30]              # 004f9901
    mov edx, dword ptr [ebp - local_4]           # 004f9904
    fstp dword ptr [edx + field_4c]              # 004f9907
    mov eax, dword ptr [ebp - local_4]           # 004f990a
    mov dword ptr [eax + field_54], 0x0          # 004f990d
    mov ecx, dword ptr [ebp - local_4]           # 004f9914
    mov edx, dword ptr [ebp - local_8]           # 004f9917
    add edx, dword ptr [ecx + field_38]          # 004f991a
    mov eax, dword ptr [ebp - local_4]           # 004f991d
    mov dword ptr [eax + field_40], edx          # 004f9920
    mov ecx, dword ptr [ebp - local_4]           # 004f9923
    fild dword ptr [ecx + field_6c]              # 004f9926
    mov edx, dword ptr [ebp - local_c]           # 004f9929
    fstp dword ptr [edx + field_2a3]             # 004f992c
    mov eax, dword ptr [ebp - local_4]           # 004f9932
    fild dword ptr [eax + field_74]              # 004f9935
    mov ecx, dword ptr [ebp - local_c]           # 004f9938
    fstp dword ptr [ecx + field_2a7]             # 004f993b
    mov edx, dword ptr [ebp - local_4]           # 004f9941
    fild dword ptr [edx + field_7c]              # 004f9944
    mov eax, dword ptr [ebp - local_c]           # 004f9947
    fstp dword ptr [eax + field_2ab]             # 004f994a
    mov ecx, dword ptr [ebp + arg_8]             # 004f9950
    push ecx                                     # 004f9953
    mov ecx, dword ptr [ebp - local_10]          # 004f9954
    call FUN_004f8f94                            # 004f9957
    mov edx, dword ptr [ebp - local_c]           # 004f995c
    add edx, 0x2a3                               # 004f995f
    push edx                                     # 004f9965
    mov eax, dword ptr [ebp + arg_8]             # 004f9966
    push eax                                     # 004f9969
    mov ecx, dword ptr [ebp - local_10]          # 004f996a
    call FUN_004f9040                            # 004f996d
    movsx ecx, word ptr [0x63a4cd]               # 004f9972
    test ecx, ecx                                # 004f9979
    je.d8 L_004f99e8                             # 004f997b
    # block 0x004f997d: entered by fall-through of je at 0x004f997b, 33 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f99e8
    mov edx, dword ptr [ebp - local_4]           # 004f997d
    fld dword ptr [edx + field_4c]               # 004f9980
    sub esp, 0x8                                 # 004f9983
    fstp qword ptr [esp]                         # 004f9986
    mov eax, dword ptr [ebp - local_4]           # 004f9989
    fld dword ptr [eax + field_48]               # 004f998c
    sub esp, 0x8                                 # 004f998f
    fstp qword ptr [esp]                         # 004f9992
    mov ecx, dword ptr [ebp - local_4]           # 004f9995
    fld dword ptr [ecx + field_44]               # 004f9998
    sub esp, 0x8                                 # 004f999b
    fstp qword ptr [esp]                         # 004f999e
    mov edx, dword ptr [ebp - local_4]           # 004f99a1
    fld dword ptr [edx + field_68]               # 004f99a4
    sub esp, 0x8                                 # 004f99a7
    fstp qword ptr [esp]                         # 004f99aa
    mov eax, dword ptr [ebp - local_4]           # 004f99ad
    fld dword ptr [eax + field_64]               # 004f99b0
    sub esp, 0x8                                 # 004f99b3
    fstp qword ptr [esp]                         # 004f99b6
    mov ecx, dword ptr [ebp - local_4]           # 004f99b9
    fld dword ptr [ecx + field_60]               # 004f99bc
    sub esp, 0x8                                 # 004f99bf
    fstp qword ptr [esp]                         # 004f99c2
    mov edx, dword ptr [ebp + arg_8]             # 004f99c5
    push edx                                     # 004f99c8
    push 0x55f328                                # 004f99c9
    push 0x63888b                                # 004f99ce
    call FUN_0050ca3e                            # 004f99d3
    add esp, 0x3c                                # 004f99d8
    push 0x63888b                                # 004f99db
    call FUN_0044a2b7                            # 004f99e0
    add esp, 0x4                                 # 004f99e5
L_004f99e8:
    # block 0x004f99e8: entered by je at 0x004f997b, 1 instruction(s), ends with forward jump to 0x004f9b41
    jmp.d32 L_004f9b41                           # 004f99e8
L_004f99ed:
    # block 0x004f99ed: entered by jne at 0x004f9835, 5 instruction(s), ends with jne to 0x004f9a12 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004f99ed
    {load} xor ecx, ecx                          # 004f99f0
    mov cx, word ptr [eax + field_12c]           # 004f99f2
    cmp ecx, 0x500                               # 004f99f9
    jne.d8 L_004f9a12                            # 004f99ff
    # block 0x004f9a01: entered by fall-through of jne at 0x004f99ff, 5 instruction(s), calls FUN_004f9d18, ends with forward jump to 0x004f9b41
    mov edx, dword ptr [ebp + arg_8]             # 004f9a01
    push edx                                     # 004f9a04
    mov ecx, dword ptr [ebp - local_10]          # 004f9a05
    call FUN_004f9d18                            # 004f9a08
    jmp.d32 L_004f9b41                           # 004f9a0d
L_004f9a12:
    # block 0x004f9a12: entered by jne at 0x004f99ff, 5 instruction(s), ends with jne to 0x004f9b41 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004f9a12
    {load} xor ecx, ecx                          # 004f9a15
    mov cx, word ptr [eax + field_12c]           # 004f9a17
    cmp ecx, 0x300                               # 004f9a1e
    jne.d32 L_004f9b41                           # 004f9a24
    # block 0x004f9a2a: entered by fall-through of jne at 0x004f9a24, 3 instruction(s), ends with jge to 0x004f9a41 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f9a2a
    cmp dword ptr [edx + field_3c], 0x168        # 004f9a2d
    jge.d8 L_004f9a41                            # 004f9a34
    # block 0x004f9a36: entered by fall-through of jge at 0x004f9a34, 4 instruction(s), ends with forward jump to 0x004f9a48
    mov eax, dword ptr [ebp - local_4]           # 004f9a36
    mov ecx, dword ptr [eax + field_3c]          # 004f9a39
    mov dword ptr [ebp - local_34], ecx          # 004f9a3c
    jmp.d8 L_004f9a48                            # 004f9a3f
L_004f9a41:
    # block 0x004f9a41: entered by jge at 0x004f9a34, 1 instruction(s), falls into the block at 0x004f9a48
    mov dword ptr [ebp - local_34], 0x168        # 004f9a41
L_004f9a48:
    # block 0x004f9a48: entered by jmp at 0x004f9a3f, 43 instruction(s), calls FUN_004f8f94, FUN_004f9040, ends with je to 0x004f9b41 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f9a48
    mov eax, dword ptr [ebp - local_34]          # 004f9a4b
    mov dword ptr [edx + field_3c], eax          # 004f9a4e
    mov ecx, dword ptr [ebp - local_4]           # 004f9a51
    fild dword ptr [ecx + field_3c]              # 004f9a54
    fstp dword ptr [ebp - local_38]              # 004f9a57
    fld dword ptr [ebp - local_38]               # 004f9a5a
    fdivr qword ptr [0x52e510]                   # 004f9a5d
    mov edx, dword ptr [ebp - local_4]           # 004f9a63
    fstp dword ptr [edx + field_50]              # 004f9a66
    mov eax, dword ptr [ebp - local_4]           # 004f9a69
    mov dword ptr [eax + field_58], 0x0          # 004f9a6c
    mov ecx, dword ptr [ebp - local_4]           # 004f9a73
    mov edx, dword ptr [ebp - local_8]           # 004f9a76
    add edx, dword ptr [ecx + field_38]          # 004f9a79
    mov eax, dword ptr [ebp - local_4]           # 004f9a7c
    mov dword ptr [eax + field_40], edx          # 004f9a7f
    mov ecx, dword ptr [ebp - local_4]           # 004f9a82
    fild dword ptr [ecx + field_84]              # 004f9a85
    mov edx, dword ptr [ebp - local_c]           # 004f9a8b
    fstp dword ptr [edx + field_2a3]             # 004f9a8e
    mov eax, dword ptr [ebp - local_4]           # 004f9a94
    fild dword ptr [eax + field_88]              # 004f9a97
    mov ecx, dword ptr [ebp - local_c]           # 004f9a9d
    fstp dword ptr [ecx + field_2a7]             # 004f9aa0
    mov edx, dword ptr [ebp - local_4]           # 004f9aa6
    fild dword ptr [edx + field_8c]              # 004f9aa9
    mov eax, dword ptr [ebp - local_c]           # 004f9aaf
    fstp dword ptr [eax + field_2ab]             # 004f9ab2
    mov ecx, dword ptr [ebp + arg_8]             # 004f9ab8
    push ecx                                     # 004f9abb
    mov ecx, dword ptr [ebp - local_10]          # 004f9abc
    call FUN_004f8f94                            # 004f9abf
    mov edx, dword ptr [ebp - local_c]           # 004f9ac4
    add edx, 0x2a3                               # 004f9ac7
    push edx                                     # 004f9acd
    mov eax, dword ptr [ebp + arg_8]             # 004f9ace
    push eax                                     # 004f9ad1
    mov ecx, dword ptr [ebp - local_10]          # 004f9ad2
    call FUN_004f9040                            # 004f9ad5
    movsx ecx, word ptr [0x63a4cd]               # 004f9ada
    test ecx, ecx                                # 004f9ae1
    je.d8 L_004f9b41                             # 004f9ae3
    # block 0x004f9ae5: entered by fall-through of je at 0x004f9ae3, 25 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f9b41
    mov edx, dword ptr [ebp - local_c]           # 004f9ae5
    fld dword ptr [edx + field_2ab]              # 004f9ae8
    sub esp, 0x8                                 # 004f9aee
    fstp qword ptr [esp]                         # 004f9af1
    mov eax, dword ptr [ebp - local_c]           # 004f9af4
    fld dword ptr [eax + field_2a7]              # 004f9af7
    sub esp, 0x8                                 # 004f9afd
    fstp qword ptr [esp]                         # 004f9b00
    mov ecx, dword ptr [ebp - local_c]           # 004f9b03
    fld dword ptr [ecx + field_2a3]              # 004f9b06
    sub esp, 0x8                                 # 004f9b0c
    fstp qword ptr [esp]                         # 004f9b0f
    mov edx, dword ptr [ebp - local_4]           # 004f9b12
    fld dword ptr [edx + field_50]               # 004f9b15
    sub esp, 0x8                                 # 004f9b18
    fstp qword ptr [esp]                         # 004f9b1b
    mov eax, dword ptr [ebp + arg_8]             # 004f9b1e
    push eax                                     # 004f9b21
    push 0x55f3a8                                # 004f9b22
    push 0x63888b                                # 004f9b27
    call FUN_0050ca3e                            # 004f9b2c
    add esp, 0x2c                                # 004f9b31
    push 0x63888b                                # 004f9b34
    call FUN_0044a2b7                            # 004f9b39
    add esp, 0x4                                 # 004f9b3e
L_004f9b41:
    # block 0x004f9b41: entered by jmp at 0x004f97fc; jmp at 0x004f981e; jmp at 0x004f99e8; jmp at 0x004f9a0d; more, 2 instruction(s), ends with forward jump to 0x004f9b4a
    mov eax, 0x1                                 # 004f9b41
    jmp.d8 L_004f9b4a                            # 004f9b46
L_004f9b48:
    # block 0x004f9b48: entered by je at 0x004f95e2, 1 instruction(s), falls into the block at 0x004f9b4a
    {load} xor eax, eax                          # 004f9b48
L_004f9b4a:
    # block 0x004f9b4a: entered by jmp at 0x004f9756; jmp at 0x004f9b46, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f9b4a
    pop ebp                                      # 004f9b4c
    ret 0x4                                      # 004f9b4d

