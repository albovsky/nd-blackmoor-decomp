# FUN_00414692
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414692
# extent:       0x00414692-0x00414947 (693 code bytes)
# span:         0x00414692-0x00414947 (code 693, tables 0, padding 0)
# sha256:       a14081d6c878930bce560a0ee3bc9e67b11c07f016e3d583ca133dde909f8966
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00414692
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_2, field_1c, field_20; [ecx + n] field_2, field_1c, field_1e, field_20; [edx + n] field_1c, field_1e, field_24
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 224 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00414692 - 0x401000
.globl FUN_00414692
FUN_00414692:
    # block 0x00414692: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004146f6 (forward)
    push ebp                                     # 00414692
    {load} mov ebp, esp                          # 00414693
    sub esp, 0x10                                # 00414695
    push esi                                     # 00414698
    push edi                                     # 00414699
    mov dword ptr [ebp - local_10], ecx          # 0041469a
    push 0x22                                    # 0041469d
    call FUN_0051dc43                            # 0041469f
    add esp, 0x4                                 # 004146a4
    mov dword ptr [ebp - local_4], eax           # 004146a7
    mov eax, dword ptr [ebp + arg_8]             # 004146aa
    mov ecx, dword ptr [ebp - local_4]           # 004146ad
    mov dword ptr [eax], ecx                     # 004146b0
    cmp dword ptr [ebp - local_4], 0x0           # 004146b2
    jne.d8 L_004146f6                            # 004146b6
    # block 0x004146b8: entered by fall-through of jne at 0x004146b6, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004146f6
    movsx edx, word ptr [0x5c39e3]               # 004146b8
    push edx                                     # 004146bf
    mov eax, dword ptr [0x5bb57b]                # 004146c0
    push eax                                     # 004146c5
    push 0x5417a4                                # 004146c6
    push 0x63888b                                # 004146cb
    call FUN_0050ca3e                            # 004146d0
    add esp, 0x10                                # 004146d5
    push 0x63888b                                # 004146d8
    push 0x5417d0                                # 004146dd
    mov ecx, 0x583979                            # 004146e2
    call FUN_0042639d                            # 004146e7
    mov ecx, 0x5cf659                            # 004146ec
    call FUN_004c97b4                            # 004146f1
L_004146f6:
    # block 0x004146f6: entered by jne at 0x004146b6, 34 instruction(s), calls FUN_0051dc43, ends with jne to 0x00414795 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004146f6
    mov edx, dword ptr [ebp + arg_8]             # 004146f9
    mov eax, dword ptr [edx]                     # 004146fc
    mov dword ptr [ecx + field_1c], eax          # 004146fe
    mov ecx, dword ptr [ebp + arg_c]             # 00414701
    mov edx, dword ptr [ecx]                     # 00414704
    mov eax, dword ptr [ebp - local_10]          # 00414706
    mov ecx, dword ptr [eax + field_1c]          # 00414709
    mov dx, word ptr [edx]                       # 0041470c
    mov word ptr [ecx], dx                       # 0041470f
    mov eax, dword ptr [ebp + arg_c]             # 00414712
    mov ecx, dword ptr [eax]                     # 00414715
    add ecx, 0x2                                 # 00414717
    mov edx, dword ptr [ebp + arg_c]             # 0041471a
    mov dword ptr [edx], ecx                     # 0041471d
    mov eax, dword ptr [ebp + arg_10]            # 0041471f
    mov ecx, dword ptr [eax]                     # 00414722
    add ecx, 0x2                                 # 00414724
    mov edx, dword ptr [ebp + arg_10]            # 00414727
    mov dword ptr [edx], ecx                     # 0041472a
    mov eax, dword ptr [ebp - local_10]          # 0041472c
    mov ecx, dword ptr [eax + field_1c]          # 0041472f
    movsx edx, word ptr [ecx]                    # 00414732
    imul edx, edx, 0x16                          # 00414735
    push edx                                     # 00414738
    call FUN_0051dc43                            # 00414739
    add esp, 0x4                                 # 0041473e
    mov dword ptr [ebp - local_8], eax           # 00414741
    mov eax, dword ptr [ebp - local_10]          # 00414744
    mov ecx, dword ptr [eax + field_1c]          # 00414747
    mov edx, dword ptr [ebp - local_8]           # 0041474a
    mov dword ptr [ecx + field_2], edx           # 0041474d
    cmp dword ptr [ebp - local_8], 0x0           # 00414750
    jne.d8 L_00414795                            # 00414754
    # block 0x00414756: entered by fall-through of jne at 0x00414754, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00414795
    movsx eax, word ptr [0x5c39e3]               # 00414756
    push eax                                     # 0041475d
    mov ecx, dword ptr [0x5bb57b]                # 0041475e
    push ecx                                     # 00414764
    push 0x5417ec                                # 00414765
    push 0x63888b                                # 0041476a
    call FUN_0050ca3e                            # 0041476f
    add esp, 0x10                                # 00414774
    push 0x63888b                                # 00414777
    push 0x541818                                # 0041477c
    mov ecx, 0x583979                            # 00414781
    call FUN_0042639d                            # 00414786
    mov ecx, 0x5cf659                            # 0041478b
    call FUN_004c97b4                            # 00414790
L_00414795:
    # block 0x00414795: entered by jne at 0x00414754, 85 instruction(s), calls FUN_0051dc43, ends with jne to 0x004148c0 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00414795
    mov eax, dword ptr [edx + field_1c]          # 00414798
    mov ecx, dword ptr [ebp - local_10]          # 0041479b
    mov edx, dword ptr [eax + field_2]           # 0041479e
    mov dword ptr [ecx + field_20], edx          # 004147a1
    mov eax, dword ptr [ebp - local_10]          # 004147a4
    mov ecx, dword ptr [eax + field_1c]          # 004147a7
    movsx ecx, word ptr [ecx]                    # 004147aa
    imul ecx, ecx, 0x16                          # 004147ad
    mov edx, dword ptr [ebp + arg_c]             # 004147b0
    mov esi, dword ptr [edx]                     # 004147b3
    mov eax, dword ptr [ebp - local_10]          # 004147b5
    mov edi, dword ptr [eax + field_20]          # 004147b8
    {load} mov edx, ecx                          # 004147bb
    shr ecx, 0x2                                 # 004147bd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004147c0
    {load} mov ecx, edx                          # 004147c2
    and ecx, 0x3                                 # 004147c4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004147c7
    mov eax, dword ptr [ebp - local_10]          # 004147c9
    mov ecx, dword ptr [eax + field_1c]          # 004147cc
    movsx edx, word ptr [ecx]                    # 004147cf
    imul edx, edx, 0x16                          # 004147d2
    mov eax, dword ptr [ebp + arg_c]             # 004147d5
    mov ecx, dword ptr [eax]                     # 004147d8
    {load} add ecx, edx                          # 004147da
    mov edx, dword ptr [ebp + arg_c]             # 004147dc
    mov dword ptr [edx], ecx                     # 004147df
    mov eax, dword ptr [ebp - local_10]          # 004147e1
    mov ecx, dword ptr [eax + field_1c]          # 004147e4
    movsx edx, word ptr [ecx]                    # 004147e7
    imul edx, edx, 0x16                          # 004147ea
    mov eax, dword ptr [ebp + arg_10]            # 004147ed
    mov ecx, dword ptr [eax]                     # 004147f0
    {load} add ecx, edx                          # 004147f2
    mov edx, dword ptr [ebp + arg_10]            # 004147f4
    mov dword ptr [edx], ecx                     # 004147f7
    mov eax, dword ptr [ebp + arg_c]             # 004147f9
    mov esi, dword ptr [eax]                     # 004147fc
    mov ecx, dword ptr [ebp - local_10]          # 004147fe
    mov edi, dword ptr [ecx + field_1c]          # 00414801
    add edi, 0x6                                 # 00414804
    mov ecx, 0x5                                 # 00414807
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041480c
    movsw word ptr es:[edi], word ptr [esi]      # 0041480e
    mov edx, dword ptr [ebp + arg_c]             # 00414810
    mov eax, dword ptr [edx]                     # 00414813
    add eax, 0x16                                # 00414815
    mov ecx, dword ptr [ebp + arg_c]             # 00414818
    mov dword ptr [ecx], eax                     # 0041481b
    mov edx, dword ptr [ebp + arg_10]            # 0041481d
    mov eax, dword ptr [edx]                     # 00414820
    add eax, 0x16                                # 00414822
    mov ecx, dword ptr [ebp + arg_10]            # 00414825
    mov dword ptr [ecx], eax                     # 00414828
    mov edx, dword ptr [ebp + arg_c]             # 0041482a
    mov eax, dword ptr [edx]                     # 0041482d
    mov ecx, dword ptr [ebp - local_10]          # 0041482f
    mov edx, dword ptr [ecx + field_1c]          # 00414832
    mov ax, word ptr [eax]                       # 00414835
    mov word ptr [edx + field_1c], ax            # 00414838
    mov ecx, dword ptr [ebp + arg_c]             # 0041483c
    mov edx, dword ptr [ecx]                     # 0041483f
    add edx, 0x2                                 # 00414841
    mov eax, dword ptr [ebp + arg_c]             # 00414844
    mov dword ptr [eax], edx                     # 00414847
    mov ecx, dword ptr [ebp + arg_10]            # 00414849
    mov edx, dword ptr [ecx]                     # 0041484c
    add edx, 0x2                                 # 0041484e
    mov eax, dword ptr [ebp + arg_10]            # 00414851
    mov dword ptr [eax], edx                     # 00414854
    mov ecx, dword ptr [ebp - local_10]          # 00414856
    mov edx, dword ptr [ecx + field_1c]          # 00414859
    movsx eax, word ptr [edx + field_1c]         # 0041485c
    imul eax, eax, 0x12                          # 00414860
    push eax                                     # 00414863
    call FUN_0051dc43                            # 00414864
    add esp, 0x4                                 # 00414869
    mov dword ptr [ebp - local_c], eax           # 0041486c
    mov ecx, dword ptr [ebp - local_10]          # 0041486f
    mov edx, dword ptr [ecx + field_1c]          # 00414872
    mov eax, dword ptr [ebp - local_c]           # 00414875
    mov dword ptr [edx + field_1e], eax          # 00414878
    cmp dword ptr [ebp - local_c], 0x0           # 0041487b
    jne.d8 L_004148c0                            # 0041487f
    # block 0x00414881: entered by fall-through of jne at 0x0041487f, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004148c0
    movsx ecx, word ptr [0x5c39e3]               # 00414881
    push ecx                                     # 00414888
    mov edx, dword ptr [0x5bb57b]                # 00414889
    push edx                                     # 0041488f
    push 0x541834                                # 00414890
    push 0x63888b                                # 00414895
    call FUN_0050ca3e                            # 0041489a
    add esp, 0x10                                # 0041489f
    push 0x63888b                                # 004148a2
    push 0x541860                                # 004148a7
    mov ecx, 0x583979                            # 004148ac
    call FUN_0042639d                            # 004148b1
    mov ecx, 0x5cf659                            # 004148b6
    call FUN_004c97b4                            # 004148bb
L_004148c0:
    # block 0x004148c0: entered by jne at 0x0041487f, 40 instruction(s), ends with je to 0x0041493f (forward)
    mov eax, dword ptr [ebp - local_10]          # 004148c0
    mov ecx, dword ptr [eax + field_1c]          # 004148c3
    mov edx, dword ptr [ebp - local_10]          # 004148c6
    mov eax, dword ptr [ecx + field_1e]          # 004148c9
    mov dword ptr [edx + field_24], eax          # 004148cc
    mov ecx, dword ptr [ebp - local_10]          # 004148cf
    mov edx, dword ptr [ecx + field_1c]          # 004148d2
    movsx ecx, word ptr [edx + field_1c]         # 004148d5
    imul ecx, ecx, 0x12                          # 004148d9
    mov eax, dword ptr [ebp + arg_c]             # 004148dc
    mov esi, dword ptr [eax]                     # 004148df
    mov edx, dword ptr [ebp - local_10]          # 004148e1
    mov edi, dword ptr [edx + field_24]          # 004148e4
    {load} mov eax, ecx                          # 004148e7
    shr ecx, 0x2                                 # 004148e9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004148ec
    {load} mov ecx, eax                          # 004148ee
    and ecx, 0x3                                 # 004148f0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004148f3
    mov ecx, dword ptr [ebp - local_10]          # 004148f5
    mov edx, dword ptr [ecx + field_1c]          # 004148f8
    movsx eax, word ptr [edx + field_1c]         # 004148fb
    imul eax, eax, 0x12                          # 004148ff
    mov ecx, dword ptr [ebp + arg_c]             # 00414902
    mov edx, dword ptr [ecx]                     # 00414905
    {load} add edx, eax                          # 00414907
    mov eax, dword ptr [ebp + arg_c]             # 00414909
    mov dword ptr [eax], edx                     # 0041490c
    mov ecx, dword ptr [ebp - local_10]          # 0041490e
    mov edx, dword ptr [ecx + field_1c]          # 00414911
    movsx eax, word ptr [edx + field_1c]         # 00414914
    imul eax, eax, 0x12                          # 00414918
    mov ecx, dword ptr [ebp + arg_10]            # 0041491b
    mov edx, dword ptr [ecx]                     # 0041491e
    {load} add edx, eax                          # 00414920
    mov eax, dword ptr [ebp + arg_10]            # 00414922
    mov dword ptr [eax], edx                     # 00414925
    movsx ecx, word ptr [0x63a4cd]               # 00414927
    test ecx, ecx                                # 0041492e
    je.d8 L_0041493f                             # 00414930
    # block 0x00414932: entered by fall-through of je at 0x00414930, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0041493f
    push 0x54187c                                # 00414932
    call FUN_0044a2b7                            # 00414937
    add esp, 0x4                                 # 0041493c
L_0041493f:
    # block 0x0041493f: entered by je at 0x00414930, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0041493f
    pop esi                                      # 00414940
    {load} mov esp, ebp                          # 00414941
    pop ebp                                      # 00414943
    ret 0xc                                      # 00414944

