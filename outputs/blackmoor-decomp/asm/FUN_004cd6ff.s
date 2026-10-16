# FUN_004cd6ff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cd6ff
# extent:       0x004cd6ff-0x004cdfd3 (2260 code bytes)
# span:         0x004cd6ff-0x004cdfd3 (code 2260, tables 0, padding 0)
# sha256:       bdca476b91db9275c96c89775550a1cfaea685fec114b5a215e1f82cab7e0eb5
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cd6ff
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_23, field_25, field_31, field_1de, field_216, field_21a, field_222, field_226, field_22e, field_23e, field_246, field_24a and 2 more; [ebx + n] field_246; [ecx + n] field_23, field_25, field_29, field_17a, field_192, field_1de, field_212, field_222, field_226, field_22a, field_22e, field_236 and 6 more; [edi + n] field_25; [edx + n] field_21, field_23, field_25, field_17a, field_1de, field_202, field_222, field_226, field_22e, field_236, field_23e, field_246 and 3 more; [esi + n] field_29, field_226
# callees:      calls FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_004ccef1, FUN_004ccfbd, FUN_004d36ed, FUN_00516530, FUN_004cf0a9, FUN_004cf026, FUN_004cdfd3, FUN_004ce602, FUN_004ce8ea, FUN_004cf0ce, FUN_0050cd50, KERNEL32.dll!GetTickCount and 1 more
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:avf_player_restart (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 530 instruction(s), 34 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_31, 0x31  # offset +0x31
.equ field_17a, 0x17a  # offset +0x17a
.equ field_192, 0x192  # offset +0x192
.equ field_1de, 0x1de  # offset +0x1de
.equ field_202, 0x202  # offset +0x202
.equ field_212, 0x212  # offset +0x212
.equ field_216, 0x216  # offset +0x216
.equ field_21a, 0x21a  # offset +0x21a
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_22a, 0x22a  # offset +0x22a
.equ field_22e, 0x22e  # offset +0x22e
.equ field_236, 0x236  # offset +0x236
.equ field_23e, 0x23e  # offset +0x23e
.equ field_246, 0x246  # offset +0x246
.equ field_24a, 0x24a  # offset +0x24a
.equ field_24e, 0x24e  # offset +0x24e
.equ field_252, 0x252  # offset +0x252
.equ field_256, 0x256  # offset +0x256
.equ field_25a, 0x25a  # offset +0x25a

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004ccef1, .text + (0x004ccef1 - 0x401000)
.set FUN_004ccfbd, .text + (0x004ccfbd - 0x401000)
.set FUN_004cdfd3, .text + (0x004cdfd3 - 0x401000)
.set FUN_004ce602, .text + (0x004ce602 - 0x401000)
.set FUN_004ce8ea, .text + (0x004ce8ea - 0x401000)
.set FUN_004ceb3b, .text + (0x004ceb3b - 0x401000)
.set FUN_004cf026, .text + (0x004cf026 - 0x401000)
.set FUN_004cf0a9, .text + (0x004cf0a9 - 0x401000)
.set FUN_004cf0ce, .text + (0x004cf0ce - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_00516530, .text + (0x00516530 - 0x401000)

.org 0x004cd6ff - 0x401000
.globl FUN_004cd6ff
FUN_004cd6ff:
    # block 0x004cd6ff: entry, 23 instruction(s), ends with je to 0x004cd76d (forward)
    push ebp                                     # 004cd6ff
    {load} mov ebp, esp                          # 004cd700
    sub esp, 0x14                                # 004cd702
    push ebx                                     # 004cd705
    push esi                                     # 004cd706
    push edi                                     # 004cd707
    mov dword ptr [ebp - local_4], ecx           # 004cd708
    movsx eax, word ptr [ebp + arg_8]            # 004cd70b
    mov ecx, dword ptr [ebp - local_4]           # 004cd70f
    mov dword ptr [ecx + field_23e], eax         # 004cd712
    mov edx, dword ptr [ebp - local_4]           # 004cd718
    mov eax, dword ptr [edx + field_23e]         # 004cd71b
    imul eax, eax, 0x8d                          # 004cd721
    mov ecx, dword ptr [ebp - local_4]           # 004cd727
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004cd72a
    mov dword ptr [ecx + field_222], edx         # 004cd730
    mov eax, dword ptr [ebp - local_4]           # 004cd736
    mov ecx, dword ptr [eax + field_23e]         # 004cd739
    imul ecx, ecx, 0x8d                          # 004cd73f
    mov edx, dword ptr [ecx + 0x5bb632]          # 004cd745
    mov dword ptr [ebp - local_8], edx           # 004cd74b
    cmp dword ptr [ebp - local_8], 0x0           # 004cd74e
    je.d8 L_004cd76d                             # 004cd752
    # block 0x004cd754: entered by fall-through of je at 0x004cd752, 2 instruction(s), ends with je to 0x004cdb26 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004cd754
    je.d32 L_004cdb26                            # 004cd758
    # block 0x004cd75e: entered by fall-through of je at 0x004cd758, 2 instruction(s), ends with je to 0x004cdfb7 (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004cd75e
    je.d32 L_004cdfb7                            # 004cd762
    # block 0x004cd768: entered by fall-through of je at 0x004cd762, 1 instruction(s), ends with forward jump to 0x004cdfca
    jmp.d32 L_004cdfca                           # 004cd768
L_004cd76d:
    # block 0x004cd76d: entered by je at 0x004cd752, 3 instruction(s), ends with je to 0x004cd7e1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cd76d
    cmp dword ptr [eax + field_216], 0x0         # 004cd770
    je.d8 L_004cd7e1                             # 004cd777
    # block 0x004cd779: entered by fall-through of je at 0x004cd777, 18 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004cd7d2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cd779
    mov edx, dword ptr [ecx + field_23e]         # 004cd77c
    imul edx, edx, 0x8d                          # 004cd782
    add edx, 0x5bb5b3                            # 004cd788
    push edx                                     # 004cd78e
    mov eax, dword ptr [ebp - local_4]           # 004cd78f
    mov ecx, dword ptr [eax + field_23e]         # 004cd792
    push ecx                                     # 004cd798
    push 0x559314                                # 004cd799
    push 0x63888b                                # 004cd79e
    call FUN_0050ca3e                            # 004cd7a3
    add esp, 0x10                                # 004cd7a8
    push 0x63888b                                # 004cd7ab
    mov ecx, 0x583979                            # 004cd7b0
    call FUN_004264e8                            # 004cd7b5
    movsx edx, word ptr [0x63a4cd]               # 004cd7ba
    test edx, edx                                # 004cd7c1
    je.d8 L_004cd7d2                             # 004cd7c3
    # block 0x004cd7c5: entered by fall-through of je at 0x004cd7c3, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cd7d2
    push 0x63888b                                # 004cd7c5
    call FUN_0044a2b7                            # 004cd7ca
    add esp, 0x4                                 # 004cd7cf
L_004cd7d2:
    # block 0x004cd7d2: entered by je at 0x004cd7c3, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cdfca
    mov ecx, 0x5cf659                            # 004cd7d2
    call FUN_004c97b4                            # 004cd7d7
    jmp.d32 L_004cdfca                           # 004cd7dc
L_004cd7e1:
    # block 0x004cd7e1: entered by je at 0x004cd777, 18 instruction(s), calls FUN_004ccef1, FUN_004ccfbd, FUN_004d36ed, ends with jne to 0x004cd852 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cd7e1
    call FUN_004ccef1                            # 004cd7e4
    mov ecx, dword ptr [ebp - local_4]           # 004cd7e9
    call FUN_004ccfbd                            # 004cd7ec
    mov eax, dword ptr [ebp - local_4]           # 004cd7f1
    mov dword ptr [eax + field_216], 0x1         # 004cd7f4
    mov ecx, dword ptr [ebp - local_4]           # 004cd7fe
    mov word ptr [ecx + field_192], 0x0          # 004cd801
    mov dword ptr [0x5bb1ca], 0x1                # 004cd80a
    call FUN_004d36ed                            # 004cd814
    mov edx, dword ptr [ebp - local_4]           # 004cd819
    mov eax, dword ptr [0x5839a9]                # 004cd81c
    mov dword ptr [edx + field_202], eax         # 004cd821
    mov ecx, dword ptr [ebp - local_4]           # 004cd827
    mov edx, dword ptr [ecx + field_222]         # 004cd82a
    movsx eax, word ptr [edx + field_21]         # 004cd830
    cmp eax, 0x1                                 # 004cd834
    jne.d8 L_004cd852                            # 004cd837
    # block 0x004cd839: entered by fall-through of jne at 0x004cd837, 4 instruction(s), ends with forward jump to 0x004cd887
    mov dword ptr [0x5839a9], 0x0                # 004cd839
    mov ecx, dword ptr [ebp - local_4]           # 004cd843
    mov dword ptr [ecx + field_17a], 0x1         # 004cd846
    jmp.d8 L_004cd887                            # 004cd850
L_004cd852:
    # block 0x004cd852: entered by jne at 0x004cd837, 6 instruction(s), falls into the block at 0x004cd887
    mov dword ptr [0x5839a9], 0x1                # 004cd852
    mov edx, dword ptr [ebp - local_4]           # 004cd85c
    mov dword ptr [edx + field_17a], 0x0         # 004cd85f
    mov dword ptr [0x5d16cd], 0x0                # 004cd869
    mov dword ptr [0x5d1683], 0x0                # 004cd873
    mov dword ptr [0x5d1639], 0x0                # 004cd87d
L_004cd887:
    # block 0x004cd887: entered by jmp at 0x004cd850, 12 instruction(s), calls FUN_00516530, ends with jne to 0x004cd969 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cd887
    mov dword ptr [eax + field_246], 0xffffffff  # 004cd88a
    mov ecx, dword ptr [ebp - local_4]           # 004cd894
    mov dword ptr [ecx + field_25a], 0x0         # 004cd897
    push 0x55939c                                # 004cd8a1
    mov edx, dword ptr [ebp - local_4]           # 004cd8a6
    mov eax, dword ptr [edx + field_222]         # 004cd8a9
    push eax                                     # 004cd8af
    call FUN_00516530                            # 004cd8b0
    add esp, 0x8                                 # 004cd8b5
    test eax, eax                                # 004cd8b8
    jne.d32 L_004cd969                           # 004cd8ba
    # block 0x004cd8c0: entered by fall-through of jne at 0x004cd8ba, 5 instruction(s), ends with jg to 0x004cd927 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cd8c0
    mov edx, dword ptr [ecx + field_222]         # 004cd8c3
    movsx eax, word ptr [edx + field_23]         # 004cd8c9
    test eax, eax                                # 004cd8cd
    jg.d8 L_004cd927                             # 004cd8cf
    # block 0x004cd8d1: entered by fall-through of jg at 0x004cd8cf, 14 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004cd918 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cd8d1
    mov edx, dword ptr [ecx + field_222]         # 004cd8d4
    movsx eax, word ptr [edx + field_23]         # 004cd8da
    push eax                                     # 004cd8de
    push 0x5593a8                                # 004cd8df
    push 0x63888b                                # 004cd8e4
    call FUN_0050ca3e                            # 004cd8e9
    add esp, 0xc                                 # 004cd8ee
    push 0x63888b                                # 004cd8f1
    mov ecx, 0x583979                            # 004cd8f6
    call FUN_004264e8                            # 004cd8fb
    movsx ecx, word ptr [0x63a4cd]               # 004cd900
    test ecx, ecx                                # 004cd907
    je.d8 L_004cd918                             # 004cd909
    # block 0x004cd90b: entered by fall-through of je at 0x004cd909, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cd918
    push 0x63888b                                # 004cd90b
    call FUN_0044a2b7                            # 004cd910
    add esp, 0x4                                 # 004cd915
L_004cd918:
    # block 0x004cd918: entered by je at 0x004cd909, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cdfca
    mov ecx, 0x5cf659                            # 004cd918
    call FUN_004c97b4                            # 004cd91d
    jmp.d32 L_004cdfca                           # 004cd922
L_004cd927:
    # block 0x004cd927: entered by jg at 0x004cd8cf, 5 instruction(s), ends with jne to 0x004cd948 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cd927
    mov eax, dword ptr [edx + field_222]         # 004cd92a
    movsx ecx, word ptr [eax + field_23]         # 004cd930
    cmp ecx, 0x1                                 # 004cd934
    jne.d8 L_004cd948                            # 004cd937
    # block 0x004cd939: entered by fall-through of jne at 0x004cd937, 3 instruction(s), ends with forward jump to 0x004cd967
    mov edx, dword ptr [ebp - local_4]           # 004cd939
    mov dword ptr [edx + field_246], 0x0         # 004cd93c
    jmp.d8 L_004cd967                            # 004cd946
L_004cd948:
    # block 0x004cd948: entered by jne at 0x004cd937, 8 instruction(s), calls FUN_004cf0a9, falls into the block at 0x004cd967
    mov eax, dword ptr [ebp - local_4]           # 004cd948
    mov ecx, dword ptr [eax + field_222]         # 004cd94b
    movsx edx, word ptr [ecx + field_23]         # 004cd951
    push edx                                     # 004cd955
    mov ecx, dword ptr [ebp - local_4]           # 004cd956
    call FUN_004cf0a9                            # 004cd959
    mov ecx, dword ptr [ebp - local_4]           # 004cd95e
    mov dword ptr [ecx + field_246], eax         # 004cd961
L_004cd967:
    # block 0x004cd967: entered by jmp at 0x004cd946, 1 instruction(s), ends with forward jump to 0x004cd9e2
    jmp.d8 L_004cd9e2                            # 004cd967
L_004cd969:
    # block 0x004cd969: entered by jne at 0x004cd8ba, 10 instruction(s), calls FUN_004cf026, ends with jne to 0x004cd9e2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cd969
    mov eax, dword ptr [edx + field_222]         # 004cd96c
    push eax                                     # 004cd972
    mov ecx, dword ptr [ebp - local_4]           # 004cd973
    call FUN_004cf026                            # 004cd976
    mov ecx, dword ptr [ebp - local_4]           # 004cd97b
    mov dword ptr [ecx + field_246], eax         # 004cd97e
    mov edx, dword ptr [ebp - local_4]           # 004cd984
    cmp dword ptr [edx + field_246], -0x1        # 004cd987
    jne.d8 L_004cd9e2                            # 004cd98e
    # block 0x004cd990: entered by fall-through of jne at 0x004cd98e, 13 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004cd9d3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cd990
    mov ecx, dword ptr [eax + field_222]         # 004cd993
    push ecx                                     # 004cd999
    push 0x559400                                # 004cd99a
    push 0x63888b                                # 004cd99f
    call FUN_0050ca3e                            # 004cd9a4
    add esp, 0xc                                 # 004cd9a9
    push 0x63888b                                # 004cd9ac
    mov ecx, 0x583979                            # 004cd9b1
    call FUN_004264e8                            # 004cd9b6
    movsx edx, word ptr [0x63a4cd]               # 004cd9bb
    test edx, edx                                # 004cd9c2
    je.d8 L_004cd9d3                             # 004cd9c4
    # block 0x004cd9c6: entered by fall-through of je at 0x004cd9c4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cd9d3
    push 0x63888b                                # 004cd9c6
    call FUN_0044a2b7                            # 004cd9cb
    add esp, 0x4                                 # 004cd9d0
L_004cd9d3:
    # block 0x004cd9d3: entered by je at 0x004cd9c4, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cdfca
    mov ecx, 0x5cf659                            # 004cd9d3
    call FUN_004c97b4                            # 004cd9d8
    jmp.d32 L_004cdfca                           # 004cd9dd
L_004cd9e2:
    # block 0x004cd9e2: entered by jmp at 0x004cd967; jne at 0x004cd98e, 7 instruction(s), calls FUN_004cdfd3, ends with jne to 0x004cda62 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cd9e2
    mov ecx, dword ptr [eax + field_246]         # 004cd9e5
    push ecx                                     # 004cd9eb
    mov ecx, dword ptr [ebp - local_4]           # 004cd9ec
    call FUN_004cdfd3                            # 004cd9ef
    test eax, eax                                # 004cd9f4
    jne.d8 L_004cda62                            # 004cd9f6
    # block 0x004cd9f8: entered by fall-through of jne at 0x004cd9f6, 20 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004cda53 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cd9f8
    mov eax, dword ptr [edx + field_246]         # 004cd9fb
    push eax                                     # 004cda01
    mov ecx, dword ptr [ebp - local_4]           # 004cda02
    mov edx, dword ptr [ecx + field_246]         # 004cda05
    imul edx, edx, 0x35                          # 004cda0b
    mov eax, dword ptr [ebp - local_4]           # 004cda0e
    mov ecx, dword ptr [eax + field_226]         # 004cda11
    {load} add ecx, edx                          # 004cda17
    push ecx                                     # 004cda19
    push 0x55946c                                # 004cda1a
    push 0x63888b                                # 004cda1f
    call FUN_0050ca3e                            # 004cda24
    add esp, 0x10                                # 004cda29
    push 0x63888b                                # 004cda2c
    mov ecx, 0x583979                            # 004cda31
    call FUN_004264e8                            # 004cda36
    movsx edx, word ptr [0x63a4cd]               # 004cda3b
    test edx, edx                                # 004cda42
    je.d8 L_004cda53                             # 004cda44
    # block 0x004cda46: entered by fall-through of je at 0x004cda44, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cda53
    push 0x63888b                                # 004cda46
    call FUN_0044a2b7                            # 004cda4b
    add esp, 0x4                                 # 004cda50
L_004cda53:
    # block 0x004cda53: entered by je at 0x004cda44, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cdfca
    mov ecx, 0x5cf659                            # 004cda53
    call FUN_004c97b4                            # 004cda58
    jmp.d32 L_004cdfca                           # 004cda5d
L_004cda62:
    # block 0x004cda62: entered by jne at 0x004cd9f6, 3 instruction(s), ends with je to 0x004cdaae (forward)
    movsx eax, word ptr [0x63a4cd]               # 004cda62
    test eax, eax                                # 004cda69
    je.d8 L_004cdaae                             # 004cda6b
    # block 0x004cda6d: entered by fall-through of je at 0x004cda6b, 17 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004cdaae
    mov ecx, dword ptr [ebp - local_4]           # 004cda6d
    mov edx, dword ptr [ecx + field_246]         # 004cda70
    push edx                                     # 004cda76
    mov eax, dword ptr [ebp - local_4]           # 004cda77
    mov ecx, dword ptr [eax + field_246]         # 004cda7a
    imul ecx, ecx, 0x35                          # 004cda80
    mov edx, dword ptr [ebp - local_4]           # 004cda83
    mov eax, dword ptr [edx + field_226]         # 004cda86
    {load} add eax, ecx                          # 004cda8c
    push eax                                     # 004cda8e
    push 0x5594c4                                # 004cda8f
    push 0x63888b                                # 004cda94
    call FUN_0050ca3e                            # 004cda99
    add esp, 0x10                                # 004cda9e
    push 0x63888b                                # 004cdaa1
    call FUN_0044a2b7                            # 004cdaa6
    add esp, 0x4                                 # 004cdaab
L_004cdaae:
    # block 0x004cdaae: entered by je at 0x004cda6b, 12 instruction(s), ends with je to 0x004cdafb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cdaae
    mov edx, dword ptr [ecx + field_23e]         # 004cdab1
    imul edx, edx, 0x8d                          # 004cdab7
    mov dword ptr [edx + 0x5bb626], 0x0          # 004cdabd
    mov eax, dword ptr [ebp - local_4]           # 004cdac7
    mov dword ptr [eax + field_24a], 0xffffffff  # 004cdaca
    mov ecx, dword ptr [ebp - local_4]           # 004cdad4
    mov edx, dword ptr [ecx + field_212]         # 004cdad7
    mov dword ptr [0x5d1a39], edx                # 004cdadd
    movsx eax, word ptr [0x63a4cd]               # 004cdae3
    test eax, eax                                # 004cdaea
    je.d8 L_004cdafb                             # 004cdaec
    # block 0x004cdaee: entered by fall-through of je at 0x004cdaec, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cdafb
    push 0x55950c                                # 004cdaee
    call FUN_0044a2b7                            # 004cdaf3
    add esp, 0x4                                 # 004cdaf8
L_004cdafb:
    # block 0x004cdafb: entered by je at 0x004cdaec, 7 instruction(s), ends with forward jump to 0x004cdfca
    mov ecx, dword ptr [ebp - local_4]           # 004cdafb
    mov dword ptr [ecx + field_1de], 0x0         # 004cdafe
    mov edx, dword ptr [ebp - local_4]           # 004cdb08
    mov eax, dword ptr [edx + field_23e]         # 004cdb0b
    imul eax, eax, 0x8d                          # 004cdb11
    mov dword ptr [eax + 0x5bb632], 0x1          # 004cdb17
    jmp.d32 L_004cdfca                           # 004cdb21
L_004cdb26:
    # block 0x004cdb26: entered by je at 0x004cd758, 5 instruction(s), ends with je to 0x004cdb60 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cdb26
    mov edx, dword ptr [ecx + field_222]         # 004cdb29
    movsx eax, word ptr [edx + field_21]         # 004cdb2f
    cmp eax, 0x1                                 # 004cdb33
    je.d8 L_004cdb60                             # 004cdb36
    # block 0x004cdb38: entered by fall-through of je at 0x004cdb36, 4 instruction(s), falls into the block at 0x004cdb60
    mov dword ptr [0x5839a9], 0x1                # 004cdb38
    mov dword ptr [0x5d1639], 0x0                # 004cdb42
    mov dword ptr [0x5d16cd], 0x0                # 004cdb4c
    mov dword ptr [0x5d1683], 0x0                # 004cdb56
L_004cdb60:
    # block 0x004cdb60: entered by je at 0x004cdb36, 8 instruction(s), ends with forward jump to 0x004cdba8
    mov dword ptr [0x5d1a45], 0x0                # 004cdb60
    mov ecx, dword ptr [ebp - local_4]           # 004cdb6a
    mov dword ptr [ecx + field_236], 0x0         # 004cdb6d
    mov edx, dword ptr [ebp - local_4]           # 004cdb77
    mov dword ptr [edx + field_24a], 0xffffffff  # 004cdb7a
    mov eax, dword ptr [ebp - local_4]           # 004cdb84
    mov dword ptr [eax + field_22e], 0x0         # 004cdb87
    jmp.d8 L_004cdba8                            # 004cdb91
L_004cdb93:
    # block 0x004cdb93: entered by jmp at 0x004cdc0f, 5 instruction(s), falls into the block at 0x004cdba8
    mov ecx, dword ptr [ebp - local_4]           # 004cdb93
    mov edx, dword ptr [ecx + field_22e]         # 004cdb96
    add edx, 0x1                                 # 004cdb9c
    mov eax, dword ptr [ebp - local_4]           # 004cdb9f
    mov dword ptr [eax + field_22e], edx         # 004cdba2
L_004cdba8:
    # block 0x004cdba8: entered by jmp at 0x004cdb91, 6 instruction(s), ends with jge to 0x004cdc11 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cdba8
    mov edx, dword ptr [ecx + field_222]         # 004cdbab
    movsx eax, word ptr [edx + field_25]         # 004cdbb1
    mov ecx, dword ptr [ebp - local_4]           # 004cdbb5
    cmp dword ptr [ecx + field_22e], eax         # 004cdbb8
    jge.d8 L_004cdc11                            # 004cdbbe
    # block 0x004cdbc0: entered by fall-through of jge at 0x004cdbbe, 9 instruction(s), ends with jne to 0x004cdc0f (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cdbc0
    mov eax, dword ptr [edx + field_22e]         # 004cdbc3
    imul eax, eax, 0x22                          # 004cdbc9
    mov ecx, dword ptr [ebp - local_4]           # 004cdbcc
    mov edx, dword ptr [ecx + field_22a]         # 004cdbcf
    movsx eax, word ptr [edx + eax]              # 004cdbd5
    movsx ecx, word ptr [0x5bb50b]               # 004cdbd9
    {load} cmp eax, ecx                          # 004cdbe0
    jne.d8 L_004cdc0f                            # 004cdbe2
    # block 0x004cdbe4: entered by fall-through of jne at 0x004cdbe2, 8 instruction(s), ends with forward jump to 0x004cdc11
    mov edx, dword ptr [ebp - local_4]           # 004cdbe4
    mov dword ptr [edx + field_236], 0x1         # 004cdbe7
    mov dword ptr [0x5d1a45], 0x1                # 004cdbf1
    mov eax, dword ptr [ebp - local_4]           # 004cdbfb
    mov ecx, dword ptr [ebp - local_4]           # 004cdbfe
    mov edx, dword ptr [ecx + field_22e]         # 004cdc01
    mov dword ptr [eax + field_24a], edx         # 004cdc07
    jmp.d8 L_004cdc11                            # 004cdc0d
L_004cdc0f:
    # block 0x004cdc0f: entered by jne at 0x004cdbe2, 1 instruction(s), ends with backward jump to 0x004cdb93
    jmp.d8 L_004cdb93                            # 004cdc0f
L_004cdc11:
    # block 0x004cdc11: entered by jge at 0x004cdbbe; jmp at 0x004cdc0d, 5 instruction(s), ends with je to 0x004cdc38 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cdc11
    mov ecx, dword ptr [eax + field_1de]         # 004cdc14
    mov dword ptr [ebp - local_c], ecx           # 004cdc1a
    cmp dword ptr [ebp - local_c], 0x0           # 004cdc1d
    je.d8 L_004cdc38                             # 004cdc21
    # block 0x004cdc23: entered by fall-through of je at 0x004cdc21, 2 instruction(s), ends with je to 0x004cdf63 (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 004cdc23
    je.d32 L_004cdf63                            # 004cdc27
    # block 0x004cdc2d: entered by fall-through of je at 0x004cdc27, 2 instruction(s), ends with je to 0x004cdc6d (forward)
    cmp dword ptr [ebp - local_c], 0x3           # 004cdc2d
    je.d8 L_004cdc6d                             # 004cdc31
    # block 0x004cdc33: entered by fall-through of je at 0x004cdc31, 1 instruction(s), ends with forward jump to 0x004cdfb5
    jmp.d32 L_004cdfb5                           # 004cdc33
L_004cdc38:
    # block 0x004cdc38: entered by je at 0x004cdc21, 3 instruction(s), ends with je to 0x004cdc68 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cdc38
    cmp dword ptr [edx + field_236], 0x0         # 004cdc3b
    je.d8 L_004cdc68                             # 004cdc42
    # block 0x004cdc44: entered by fall-through of je at 0x004cdc42, 5 instruction(s), ends with je to 0x004cdc60 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cdc44
    mov ecx, dword ptr [eax + field_21a]         # 004cdc47
    mov dword ptr [ebp - local_10], ecx          # 004cdc4d
    cmp dword ptr [ebp - local_10], 0x1          # 004cdc50
    je.d8 L_004cdc60                             # 004cdc54
    # block 0x004cdc56: entered by fall-through of je at 0x004cdc54, 3 instruction(s), calls FUN_004ce602, ends with forward jump to 0x004cdc68
    mov ecx, dword ptr [ebp - local_4]           # 004cdc56
    call FUN_004ce602                            # 004cdc59
    jmp.d8 L_004cdc68                            # 004cdc5e
L_004cdc60:
    # block 0x004cdc60: entered by je at 0x004cdc54, 2 instruction(s), calls FUN_004ce8ea, falls into the block at 0x004cdc68
    mov ecx, dword ptr [ebp - local_4]           # 004cdc60
    call FUN_004ce8ea                            # 004cdc63
L_004cdc68:
    # block 0x004cdc68: entered by je at 0x004cdc42; jmp at 0x004cdc5e, 1 instruction(s), ends with forward jump to 0x004cdfb5
    jmp.d32 L_004cdfb5                           # 004cdc68
L_004cdc6d:
    # block 0x004cdc6d: entered by je at 0x004cdc31, 12 instruction(s), calls FUN_004ccef1, FUN_004cf0ce, ends with jne to 0x004cddd3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cdc6d
    call FUN_004ccef1                            # 004cdc70
    mov edx, dword ptr [ebp - local_4]           # 004cdc75
    mov eax, dword ptr [edx + field_246]         # 004cdc78
    push eax                                     # 004cdc7e
    mov ecx, dword ptr [ebp - local_4]           # 004cdc7f
    call FUN_004cf0ce                            # 004cdc82
    mov ecx, dword ptr [ebp - local_4]           # 004cdc87
    mov dword ptr [ecx + field_256], eax         # 004cdc8a
    mov edx, dword ptr [ebp - local_4]           # 004cdc90
    cmp dword ptr [edx + field_256], -0x1        # 004cdc93
    jne.d32 L_004cddd3                           # 004cdc9a
    # block 0x004cdca0: entered by fall-through of jne at 0x004cdc9a, 13 instruction(s), ends with jl to 0x004cdcf8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cdca0
    mov ecx, dword ptr [eax + field_246]         # 004cdca3
    imul ecx, ecx, 0x35                          # 004cdca9
    mov edx, dword ptr [ebp - local_4]           # 004cdcac
    mov eax, dword ptr [edx + field_226]         # 004cdcaf
    mov edx, dword ptr [ebp - local_4]           # 004cdcb5
    mov edx, dword ptr [edx + field_246]         # 004cdcb8
    imul edx, edx, 0x35                          # 004cdcbe
    mov esi, dword ptr [ebp - local_4]           # 004cdcc1
    mov esi, dword ptr [esi + field_226]         # 004cdcc4
    mov eax, dword ptr [eax + ecx + field_25]    # 004cdcca
    cmp eax, dword ptr [esi + edx + field_29]    # 004cdcce
    jl.d8 L_004cdcf8                             # 004cdcd2
    # block 0x004cdcd4: entered by fall-through of jl at 0x004cdcd2, 9 instruction(s), ends with forward jump to 0x004cdd5e
    mov ecx, dword ptr [ebp - local_4]           # 004cdcd4
    mov edx, dword ptr [ecx + field_246]         # 004cdcd7
    imul edx, edx, 0x35                          # 004cdcdd
    mov eax, dword ptr [ebp - local_4]           # 004cdce0
    mov ecx, dword ptr [eax + field_226]         # 004cdce3
    mov eax, dword ptr [ebp - local_4]           # 004cdce9
    mov ecx, dword ptr [ecx + edx + field_25]    # 004cdcec
    mov dword ptr [eax + field_252], ecx         # 004cdcf0
    jmp.d8 L_004cdd5e                            # 004cdcf6
L_004cdcf8:
    # block 0x004cdcf8: entered by jl at 0x004cdcd2, 27 instruction(s), calls FUN_0050cd50, falls into the block at 0x004cdd5e
    mov edx, dword ptr [ebp - local_4]           # 004cdcf8
    mov esi, dword ptr [edx + field_246]         # 004cdcfb
    imul esi, esi, 0x35                          # 004cdd01
    mov eax, dword ptr [ebp - local_4]           # 004cdd04
    mov edi, dword ptr [eax + field_226]         # 004cdd07
    call FUN_0050cd50                            # 004cdd0d
    mov ecx, dword ptr [ebp - local_4]           # 004cdd12
    mov edx, dword ptr [ecx + field_246]         # 004cdd15
    imul edx, edx, 0x35                          # 004cdd1b
    mov ecx, dword ptr [ebp - local_4]           # 004cdd1e
    mov ecx, dword ptr [ecx + field_226]         # 004cdd21
    mov ebx, dword ptr [ebp - local_4]           # 004cdd27
    mov ebx, dword ptr [ebx + field_246]         # 004cdd2a
    imul ebx, ebx, 0x35                          # 004cdd30
    mov dword ptr [ebp - local_14], eax          # 004cdd33
    mov eax, dword ptr [ebp - local_4]           # 004cdd36
    mov eax, dword ptr [eax + field_226]         # 004cdd39
    mov ecx, dword ptr [ecx + edx + field_29]    # 004cdd3f
    sub ecx, dword ptr [eax + ebx + field_25]    # 004cdd43
    mov edx, dword ptr [ebp - local_14]          # 004cdd47
    {load} mov eax, edx                          # 004cdd4a
    cdq                                          # 004cdd4c
    idiv ecx                                     # 004cdd4d
    mov eax, dword ptr [edi + esi + field_25]    # 004cdd4f
    {load} add eax, edx                          # 004cdd53
    mov ecx, dword ptr [ebp - local_4]           # 004cdd55
    mov dword ptr [ecx + field_252], eax         # 004cdd58
L_004cdd5e:
    # block 0x004cdd5e: entered by jmp at 0x004cdcf6, 12 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004cddce (forward)
    call dword ptr [0x52a23c]                    # 004cdd5e
    mov edx, dword ptr [ebp - local_4]           # 004cdd64
    add eax, dword ptr [edx + field_252]         # 004cdd67
    mov ecx, dword ptr [ebp - local_4]           # 004cdd6d
    mov dword ptr [ecx + field_24e], eax         # 004cdd70
    mov edx, dword ptr [ebp - local_4]           # 004cdd76
    mov dword ptr [edx + field_1de], 0x1         # 004cdd79
    mov eax, dword ptr [ebp - local_4]           # 004cdd83
    mov dword ptr [eax + field_25a], 0x1         # 004cdd86
    movsx ecx, word ptr [0x63a4cd]               # 004cdd90
    test ecx, ecx                                # 004cdd97
    je.d8 L_004cddce                             # 004cdd99
    # block 0x004cdd9b: entered by fall-through of je at 0x004cdd99, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004cddce
    mov edx, dword ptr [ebp - local_4]           # 004cdd9b
    mov eax, dword ptr [edx + field_252]         # 004cdd9e
    push eax                                     # 004cdda4
    mov ecx, dword ptr [ebp - local_4]           # 004cdda5
    mov edx, dword ptr [ecx + field_246]         # 004cdda8
    push edx                                     # 004cddae
    push 0x559564                                # 004cddaf
    push 0x63888b                                # 004cddb4
    call FUN_0050ca3e                            # 004cddb9
    add esp, 0x10                                # 004cddbe
    push 0x63888b                                # 004cddc1
    call FUN_0044a2b7                            # 004cddc6
    add esp, 0x4                                 # 004cddcb
L_004cddce:
    # block 0x004cddce: entered by je at 0x004cdd99, 1 instruction(s), ends with forward jump to 0x004cdf61
    jmp.d32 L_004cdf61                           # 004cddce
L_004cddd3:
    # block 0x004cddd3: entered by jne at 0x004cdc9a, 18 instruction(s), calls FUN_004cf026, ends with jne to 0x004cde88 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cddd3
    mov ecx, dword ptr [eax + field_246]         # 004cddd6
    imul ecx, ecx, 0x35                          # 004cdddc
    mov edx, dword ptr [ebp - local_4]           # 004cdddf
    mov eax, dword ptr [edx + field_226]         # 004cdde2
    mov edx, dword ptr [ebp - local_4]           # 004cdde8
    mov edx, dword ptr [edx + field_256]         # 004cddeb
    imul edx, edx, 0x23                          # 004cddf1
    mov eax, dword ptr [eax + ecx + field_31]    # 004cddf4
    {load} add eax, edx                          # 004cddf8
    push eax                                     # 004cddfa
    mov ecx, dword ptr [ebp - local_4]           # 004cddfb
    call FUN_004cf026                            # 004cddfe
    mov ecx, dword ptr [ebp - local_4]           # 004cde03
    mov dword ptr [ecx + field_246], eax         # 004cde06
    mov edx, dword ptr [ebp - local_4]           # 004cde0c
    cmp dword ptr [edx + field_246], -0x1        # 004cde0f
    jne.d8 L_004cde88                            # 004cde16
    # block 0x004cde18: entered by fall-through of jne at 0x004cde16, 21 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004cde79 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cde18
    mov ecx, dword ptr [eax + field_246]         # 004cde1b
    imul ecx, ecx, 0x35                          # 004cde21
    mov edx, dword ptr [ebp - local_4]           # 004cde24
    mov eax, dword ptr [edx + field_226]         # 004cde27
    mov edx, dword ptr [ebp - local_4]           # 004cde2d
    mov edx, dword ptr [edx + field_256]         # 004cde30
    imul edx, edx, 0x23                          # 004cde36
    mov eax, dword ptr [eax + ecx + field_31]    # 004cde39
    {load} add eax, edx                          # 004cde3d
    push eax                                     # 004cde3f
    push 0x559604                                # 004cde40
    push 0x63888b                                # 004cde45
    call FUN_0050ca3e                            # 004cde4a
    add esp, 0xc                                 # 004cde4f
    push 0x63888b                                # 004cde52
    mov ecx, 0x583979                            # 004cde57
    call FUN_004264e8                            # 004cde5c
    movsx ecx, word ptr [0x63a4cd]               # 004cde61
    test ecx, ecx                                # 004cde68
    je.d8 L_004cde79                             # 004cde6a
    # block 0x004cde6c: entered by fall-through of je at 0x004cde6a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cde79
    push 0x63888b                                # 004cde6c
    call FUN_0044a2b7                            # 004cde71
    add esp, 0x4                                 # 004cde76
L_004cde79:
    # block 0x004cde79: entered by je at 0x004cde6a, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cdfca
    mov ecx, 0x5cf659                            # 004cde79
    call FUN_004c97b4                            # 004cde7e
    jmp.d32 L_004cdfca                           # 004cde83
L_004cde88:
    # block 0x004cde88: entered by jne at 0x004cde16, 7 instruction(s), calls FUN_004cdfd3, ends with jne to 0x004cdf08 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cde88
    mov eax, dword ptr [edx + field_246]         # 004cde8b
    push eax                                     # 004cde91
    mov ecx, dword ptr [ebp - local_4]           # 004cde92
    call FUN_004cdfd3                            # 004cde95
    test eax, eax                                # 004cde9a
    jne.d8 L_004cdf08                            # 004cde9c
    # block 0x004cde9e: entered by fall-through of jne at 0x004cde9c, 20 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004cdef9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cde9e
    mov edx, dword ptr [ecx + field_246]         # 004cdea1
    push edx                                     # 004cdea7
    mov eax, dword ptr [ebp - local_4]           # 004cdea8
    mov ecx, dword ptr [eax + field_246]         # 004cdeab
    imul ecx, ecx, 0x35                          # 004cdeb1
    mov edx, dword ptr [ebp - local_4]           # 004cdeb4
    mov eax, dword ptr [edx + field_226]         # 004cdeb7
    {load} add eax, ecx                          # 004cdebd
    push eax                                     # 004cdebf
    push 0x559668                                # 004cdec0
    push 0x63888b                                # 004cdec5
    call FUN_0050ca3e                            # 004cdeca
    add esp, 0x10                                # 004cdecf
    push 0x63888b                                # 004cded2
    mov ecx, 0x583979                            # 004cded7
    call FUN_004264e8                            # 004cdedc
    movsx ecx, word ptr [0x63a4cd]               # 004cdee1
    test ecx, ecx                                # 004cdee8
    je.d8 L_004cdef9                             # 004cdeea
    # block 0x004cdeec: entered by fall-through of je at 0x004cdeea, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cdef9
    push 0x63888b                                # 004cdeec
    call FUN_0044a2b7                            # 004cdef1
    add esp, 0x4                                 # 004cdef6
L_004cdef9:
    # block 0x004cdef9: entered by je at 0x004cdeea, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004cdfca
    mov ecx, 0x5cf659                            # 004cdef9
    call FUN_004c97b4                            # 004cdefe
    jmp.d32 L_004cdfca                           # 004cdf03
L_004cdf08:
    # block 0x004cdf08: entered by jne at 0x004cde9c, 5 instruction(s), ends with je to 0x004cdf61 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cdf08
    mov dword ptr [edx + field_1de], 0x0         # 004cdf0b
    movsx eax, word ptr [0x63a4cd]               # 004cdf15
    test eax, eax                                # 004cdf1c
    je.d8 L_004cdf61                             # 004cdf1e
    # block 0x004cdf20: entered by fall-through of je at 0x004cdf1e, 17 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004cdf61
    mov ecx, dword ptr [ebp - local_4]           # 004cdf20
    mov edx, dword ptr [ecx + field_246]         # 004cdf23
    imul edx, edx, 0x35                          # 004cdf29
    mov eax, dword ptr [ebp - local_4]           # 004cdf2c
    mov ecx, dword ptr [eax + field_226]         # 004cdf2f
    {load} add ecx, edx                          # 004cdf35
    push ecx                                     # 004cdf37
    mov edx, dword ptr [ebp - local_4]           # 004cdf38
    mov eax, dword ptr [edx + field_246]         # 004cdf3b
    push eax                                     # 004cdf41
    push 0x5596c0                                # 004cdf42
    push 0x63888b                                # 004cdf47
    call FUN_0050ca3e                            # 004cdf4c
    add esp, 0x10                                # 004cdf51
    push 0x63888b                                # 004cdf54
    call FUN_0044a2b7                            # 004cdf59
    add esp, 0x4                                 # 004cdf5e
L_004cdf61:
    # block 0x004cdf61: entered by jmp at 0x004cddce; je at 0x004cdf1e, 1 instruction(s), ends with forward jump to 0x004cdfb5
    jmp.d8 L_004cdfb5                            # 004cdf61
L_004cdf63:
    # block 0x004cdf63: entered by je at 0x004cdc27, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004cdfb5 (forward)
    call dword ptr [0x52a23c]                    # 004cdf63
    mov ecx, dword ptr [ebp - local_4]           # 004cdf69
    cmp eax, dword ptr [ecx + field_24e]         # 004cdf6c
    jb.d8 L_004cdfb5                             # 004cdf72
    # block 0x004cdf74: entered by fall-through of jb at 0x004cdf72, 5 instruction(s), ends with je to 0x004cdfb5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cdf74
    mov dword ptr [edx + field_1de], 0x3         # 004cdf77
    movsx eax, word ptr [0x63a4cd]               # 004cdf81
    test eax, eax                                # 004cdf88
    je.d8 L_004cdfb5                             # 004cdf8a
    # block 0x004cdf8c: entered by fall-through of je at 0x004cdf8a, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004cdfb5
    mov ecx, dword ptr [ebp - local_4]           # 004cdf8c
    mov edx, dword ptr [ecx + field_246]         # 004cdf8f
    push edx                                     # 004cdf95
    push 0x559770                                # 004cdf96
    push 0x63888b                                # 004cdf9b
    call FUN_0050ca3e                            # 004cdfa0
    add esp, 0xc                                 # 004cdfa5
    push 0x63888b                                # 004cdfa8
    call FUN_0044a2b7                            # 004cdfad
    add esp, 0x4                                 # 004cdfb2
L_004cdfb5:
    # block 0x004cdfb5: entered by jmp at 0x004cdc33; jmp at 0x004cdc68; jmp at 0x004cdf61; jb at 0x004cdf72; more, 1 instruction(s), ends with forward jump to 0x004cdfca
    jmp.d8 L_004cdfca                            # 004cdfb5
L_004cdfb7:
    # block 0x004cdfb7: entered by je at 0x004cd762, 5 instruction(s), calls FUN_004ceb3b, falls into the block at 0x004cdfca
    mov eax, dword ptr [ebp - local_4]           # 004cdfb7
    mov cx, word ptr [eax + field_23e]           # 004cdfba
    push ecx                                     # 004cdfc1
    mov ecx, dword ptr [ebp - local_4]           # 004cdfc2
    call FUN_004ceb3b                            # 004cdfc5
L_004cdfca:
    # block 0x004cdfca: entered by jmp at 0x004cd768; jmp at 0x004cd7dc; jmp at 0x004cd922; jmp at 0x004cd9dd; more, 6 instruction(s), ends with ret 0x4
    pop edi                                      # 004cdfca
    pop esi                                      # 004cdfcb
    pop ebx                                      # 004cdfcc
    {load} mov esp, ebp                          # 004cdfcd
    pop ebp                                      # 004cdfcf
    ret 0x4                                      # 004cdfd0

