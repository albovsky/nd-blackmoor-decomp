# FUN_0041e647
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041e647
# extent:       0x0041e647-0x0041f56c (3877 code bytes)
# span:         0x0041e647-0x0041f5b1 (code 3877, tables 69, padding 0)
# sha256:       92850e8da321903030ba1b73262d2b566e58497ba812d51f9edb678c347d253c
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041e647
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       50 ebp-relative slot(s): local_4, local_8, local_c, local_e, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c and 38 more
# fields:       [eax + n] field_1, field_20dd, field_20e3, field_20e7; [ecx + n] field_2, field_20e1, field_20e3; [edx + n] field_20dd, field_20e3
# callees:      calls FUN_0050c920, FUN_004c46d1, FUN_004c924d, FUN_0051ea75, FUN_0052139c, FUN_004c97b4, FUN_0041f5b1, FUN_004c9340, FUN_0050cb1b, FUN_004c92c5, FUN_0050ce04, FUN_004d3836, FUN_004ee673, FUN_0051eac4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl56_unverified.c:m41e647_lifted (function ledger class candidate_port; also m420c17_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 971 instruction(s), 42 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_e, 0xe  # offset -0xe
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_46, 0x46  # offset -0x46
.equ local_47, 0x47  # offset -0x47
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_13e8, 0x13e8  # offset -0x13e8
.equ local_13ec, 0x13ec  # offset -0x13ec
.equ local_13f0, 0x13f0  # offset -0x13f0
.equ local_13f4, 0x13f4  # offset -0x13f4
.equ local_13f8, 0x13f8  # offset -0x13f8
.equ local_13fc, 0x13fc  # offset -0x13fc
.equ local_1400, 0x1400  # offset -0x1400
.equ local_1404, 0x1404  # offset -0x1404
.equ local_1408, 0x1408  # offset -0x1408
.equ local_140c, 0x140c  # offset -0x140c
.equ local_1410, 0x1410  # offset -0x1410
.equ local_1416, 0x1416  # offset -0x1416
.equ local_1417, 0x1417  # offset -0x1417
.equ local_1418, 0x1418  # offset -0x1418
.equ local_141c, 0x141c  # offset -0x141c
.equ local_1420, 0x1420  # offset -0x1420
.equ local_1424, 0x1424  # offset -0x1424
.equ local_1428, 0x1428  # offset -0x1428
.equ local_142c, 0x142c  # offset -0x142c
.equ local_1432, 0x1432  # offset -0x1432
.equ local_1433, 0x1433  # offset -0x1433
.equ local_1434, 0x1434  # offset -0x1434
.equ local_1438, 0x1438  # offset -0x1438
.equ local_143c, 0x143c  # offset -0x143c
.equ local_1440, 0x1440  # offset -0x1440
.equ local_1444, 0x1444  # offset -0x1444
.equ local_1448, 0x1448  # offset -0x1448
.equ local_144c, 0x144c  # offset -0x144c
.equ local_1450, 0x1450  # offset -0x1450
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_20dd, 0x20dd  # offset +0x20dd
.equ field_20e1, 0x20e1  # offset +0x20e1
.equ field_20e3, 0x20e3  # offset +0x20e3
.equ field_20e7, 0x20e7  # offset +0x20e7

# --- external targets -----------------------------------------------
.set FUN_0041f5b1, .text + (0x0041f5b1 - 0x401000)
.set FUN_004c46d1, .text + (0x004c46d1 - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004c9340, .text + (0x004c9340 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_004ee673, .text + (0x004ee673 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0041e647 - 0x401000
.globl FUN_0041e647
FUN_0041e647:
    # block 0x0041e647: entry, 100 instruction(s), calls FUN_0050c920, ends with forward jump to 0x0041e811
    push ebp                                     # 0041e647
    {load} mov ebp, esp                          # 0041e648
    mov eax, 0x1450                              # 0041e64a
    call FUN_0050c920                            # 0041e64f
    push ebx                                     # 0041e654
    push esi                                     # 0041e655
    push edi                                     # 0041e656
    mov dword ptr [ebp - local_1440], ecx        # 0041e657
    mov word ptr [ebp - local_28], 0x0           # 0041e65d
    mov word ptr [ebp - local_13f4], 0x0         # 0041e663
    mov dword ptr [ebp - local_24], 0x0          # 0041e66c
    mov edi, 0x5438b4                            # 0041e673
    lea edx, [ebp - local_1434]                  # 0041e678
    or ecx, -0x1                                 # 0041e67e
    {load} xor eax, eax                          # 0041e681
    repne scasb al, byte ptr es:[edi]            # 0041e683
    not ecx                                      # 0041e685
    {load} sub edi, ecx                          # 0041e687
    {load} mov esi, edi                          # 0041e689
    {load} mov eax, ecx                          # 0041e68b
    {load} mov edi, edx                          # 0041e68d
    shr ecx, 0x2                                 # 0041e68f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041e692
    {load} mov ecx, eax                          # 0041e694
    and ecx, 0x3                                 # 0041e696
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041e699
    mov edi, 0x5438b8                            # 0041e69b
    lea edx, [ebp - local_1418]                  # 0041e6a0
    or ecx, -0x1                                 # 0041e6a6
    {load} xor eax, eax                          # 0041e6a9
    repne scasb al, byte ptr es:[edi]            # 0041e6ab
    not ecx                                      # 0041e6ad
    {load} sub edi, ecx                          # 0041e6af
    {load} mov esi, edi                          # 0041e6b1
    {load} mov eax, ecx                          # 0041e6b3
    {load} mov edi, edx                          # 0041e6b5
    shr ecx, 0x2                                 # 0041e6b7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041e6ba
    {load} mov ecx, eax                          # 0041e6bc
    and ecx, 0x3                                 # 0041e6be
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041e6c1
    mov dword ptr [ebp - local_13fc], 0x0        # 0041e6c3
    mov dword ptr [ebp - local_13ec], 0x0        # 0041e6cd
    mov dword ptr [ebp - local_58], 0x0          # 0041e6d7
    mov dword ptr [ebp - local_13f8], 0x0        # 0041e6de
    mov dword ptr [ebp - local_141c], 0x0        # 0041e6e8
    mov dword ptr [ebp - local_4c], 0x0          # 0041e6f2
    mov cx, word ptr [0x5b0a64]                  # 0041e6f9
    mov word ptr [ebp - local_13f0], cx          # 0041e700
    mov dx, word ptr [0x5b0a32]                  # 0041e707
    mov word ptr [ebp - local_20], dx            # 0041e70e
    mov ax, word ptr [0x5b0a36]                  # 0041e712
    mov word ptr [ebp - local_4], ax             # 0041e718
    movsx ecx, word ptr [0x5b0a34]               # 0041e71c
    mov edx, dword ptr [0x5b0a2e]                # 0041e723
    {load} sub edx, ecx                          # 0041e729
    mov word ptr [ebp - local_1424], dx          # 0041e72b
    movsx eax, word ptr [0x5b0a38]               # 0041e732
    mov ecx, dword ptr [0x5b0a2a]                # 0041e739
    {load} sub ecx, eax                          # 0041e73f
    mov word ptr [ebp - local_1400], cx          # 0041e741
    mov dx, word ptr [ebp - local_1400]          # 0041e748
    mov word ptr [ebp - local_1420], dx          # 0041e74f
    mov eax, dword ptr [ebp - local_1440]        # 0041e756
    mov dword ptr [eax + field_20dd], 0x0        # 0041e75c
    mov ecx, dword ptr [ebp - local_1440]        # 0041e766
    mov word ptr [ecx + field_20e1], 0x0         # 0041e76c
    mov edx, dword ptr [ebp - local_1440]        # 0041e775
    mov dword ptr [edx + field_20e3], 0x0        # 0041e77b
    mov eax, dword ptr [ebp - local_1440]        # 0041e785
    mov dword ptr [eax + field_20e7], 0x0        # 0041e78b
    mov dword ptr [0x5b15c8], 0x0                # 0041e795
    mov dword ptr [0x5b1606], 0x0                # 0041e79f
    mov ecx, 0x4e2                               # 0041e7a9
    {load} xor eax, eax                          # 0041e7ae
    lea edi, [ebp - local_13e8]                  # 0041e7b0
    rep stosd dword ptr es:[edi], eax            # 0041e7b6
    mov ecx, 0x6                                 # 0041e7b8
    {load} xor eax, eax                          # 0041e7bd
    lea edi, [ebp - local_48]                    # 0041e7bf
    rep stosd dword ptr es:[edi], eax            # 0041e7c2
    stosb byte ptr es:[edi], al                  # 0041e7c4
    {load} xor ecx, ecx                          # 0041e7c5
    mov dword ptr [ebp - local_1c], ecx          # 0041e7c7
    mov dword ptr [ebp - local_18], ecx          # 0041e7ca
    mov dword ptr [ebp - local_14], ecx          # 0041e7cd
    mov word ptr [ebp - local_10], cx            # 0041e7d0
    mov byte ptr [ebp - local_e], cl             # 0041e7d4
    movsx ecx, word ptr [0x5b0a6a]               # 0041e7d7
    mov eax, 0x20202020                          # 0041e7de
    lea edi, [ebp - local_1c]                    # 0041e7e3
    {load} mov edx, ecx                          # 0041e7e6
    shr ecx, 0x2                                 # 0041e7e8
    rep stosd dword ptr es:[edi], eax            # 0041e7eb
    {load} mov ecx, edx                          # 0041e7ed
    and ecx, 0x3                                 # 0041e7ef
    rep stosb byte ptr es:[edi], al              # 0041e7f2
    mov word ptr [0x5b0a8e], 0x0                 # 0041e7f4
    mov word ptr [ebp - local_50], 0x0           # 0041e7fd
    jmp.d8 L_0041e811                            # 0041e803
L_0041e805:
    # block 0x0041e805: entered by jmp at 0x0041e831, 3 instruction(s), falls into the block at 0x0041e811
    mov ax, word ptr [ebp - local_50]            # 0041e805
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041e809
    mov word ptr [ebp - local_50], ax            # 0041e80d
L_0041e811:
    # block 0x0041e811: entered by jmp at 0x0041e803, 3 instruction(s), ends with jge to 0x0041e833 (forward)
    movsx ecx, word ptr [ebp - local_50]         # 0041e811
    cmp ecx, 0x3c                                # 0041e815
    jge.d8 L_0041e833                            # 0041e818
    # block 0x0041e81a: entered by fall-through of jge at 0x0041e818, 8 instruction(s), ends with backward jump to 0x0041e805
    mov ecx, 0x8                                 # 0041e81a
    {load} xor eax, eax                          # 0041e81f
    movsx edi, word ptr [ebp - local_50]         # 0041e821
    imul edi, edi, 0x29                          # 0041e825
    add edi, 0x5b0a9a                            # 0041e828
    rep stosd dword ptr es:[edi], eax            # 0041e82e
    stosb byte ptr es:[edi], al                  # 0041e830
    jmp.d8 L_0041e805                            # 0041e831
L_0041e833:
    # block 0x0041e833: entered by jge at 0x0041e818, 3 instruction(s), ends with forward jump to 0x0041e850
    mov word ptr [0x5b0a90], 0x0                 # 0041e833
    mov word ptr [ebp - local_50], 0x0           # 0041e83c
    jmp.d8 L_0041e850                            # 0041e842
L_0041e844:
    # block 0x0041e844: entered by jmp at 0x0041e867, 3 instruction(s), falls into the block at 0x0041e850
    mov dx, word ptr [ebp - local_50]            # 0041e844
    add dx, 0x1                                  # 0041e848
    mov word ptr [ebp - local_50], dx            # 0041e84c
L_0041e850:
    # block 0x0041e850: entered by jmp at 0x0041e842, 3 instruction(s), ends with jge to 0x0041e869 (forward)
    movsx eax, word ptr [ebp - local_50]         # 0041e850
    cmp eax, 0xa                                 # 0041e854
    jge.d8 L_0041e869                            # 0041e857
    # block 0x0041e859: entered by fall-through of jge at 0x0041e857, 4 instruction(s), ends with backward jump to 0x0041e844
    movsx ecx, word ptr [ebp - local_50]         # 0041e859
    imul ecx, ecx, 0x29                          # 0041e85d
    mov byte ptr [ecx + 0x5b1436], 0x0           # 0041e860
    jmp.d8 L_0041e844                            # 0041e867
L_0041e869:
    # block 0x0041e869: entered by jge at 0x0041e857, 22 instruction(s), calls FUN_004c46d1, FUN_004c924d, FUN_0051ea75, ends with forward jump to 0x0041e8c9
    mov dl, byte ptr [ebp + arg_14]              # 0041e869
    push edx                                     # 0041e86c
    mov al, byte ptr [ebp + arg_10]              # 0041e86d
    push eax                                     # 0041e870
    mov cl, byte ptr [ebp + arg_c]               # 0041e871
    push ecx                                     # 0041e874
    mov edx, dword ptr [ebp + arg_8]             # 0041e875
    push edx                                     # 0041e878
    mov ecx, 0x5cf659                            # 0041e879
    call FUN_004c46d1                            # 0041e87e
    mov ax, word ptr [ebp + arg_18]              # 0041e883
    push eax                                     # 0041e887
    mov ecx, 0x5cf659                            # 0041e888
    call FUN_004c924d                            # 0041e88d
    push 0x3a98                                  # 0041e892
    mov ecx, dword ptr [ebp - local_1440]        # 0041e897
    add ecx, 0xf1d                               # 0041e89d
    call FUN_0051ea75                            # 0041e8a3
    mov dword ptr [ebp - local_54], eax          # 0041e8a8
    mov dword ptr [ebp - local_142c], 0x0        # 0041e8ab
    mov word ptr [ebp - local_5c], 0x0           # 0041e8b5
    jmp.d8 L_0041e8c9                            # 0041e8bb
L_0041e8bd:
    # block 0x0041e8bd: entered by jmp at 0x0041e93a, 3 instruction(s), falls into the block at 0x0041e8c9
    mov cx, word ptr [ebp - local_5c]            # 0041e8bd
    add cx, 0x1                                  # 0041e8c1
    mov word ptr [ebp - local_5c], cx            # 0041e8c5
L_0041e8c9:
    # block 0x0041e8c9: entered by jmp at 0x0041e8bb, 11 instruction(s), ends with jae to 0x0041e93c (forward)
    movsx edx, word ptr [ebp - local_5c]         # 0041e8c9
    lea edi, [ebp - local_1434]                  # 0041e8cd
    or ecx, -0x1                                 # 0041e8d3
    {load} xor eax, eax                          # 0041e8d6
    repne scasb al, byte ptr es:[edi]            # 0041e8d8
    not ecx                                      # 0041e8da
    add ecx, -0x1                                # 0041e8dc
    mov eax, 0x5dc                               # 0041e8df
    {load} sub eax, ecx                          # 0041e8e4
    {load} cmp edx, eax                          # 0041e8e6
    jae.d8 L_0041e93c                            # 0041e8e8
    # block 0x0041e8ea: entered by fall-through of jae at 0x0041e8e8, 6 instruction(s), ends with jne to 0x0041e93a (forward)
    movsx ecx, word ptr [ebp - local_5c]         # 0041e8ea
    mov edx, dword ptr [ebp - local_54]          # 0041e8ee
    movsx eax, byte ptr [edx + ecx]              # 0041e8f1
    movsx ecx, byte ptr [ebp - local_1434]       # 0041e8f5
    {load} cmp eax, ecx                          # 0041e8fc
    jne.d8 L_0041e93a                            # 0041e8fe
    # block 0x0041e900: entered by fall-through of jne at 0x0041e8fe, 6 instruction(s), ends with jne to 0x0041e93a (forward)
    movsx edx, word ptr [ebp - local_5c]         # 0041e900
    mov eax, dword ptr [ebp - local_54]          # 0041e904
    movsx ecx, byte ptr [eax + edx + field_1]    # 0041e907
    movsx edx, byte ptr [ebp - local_1433]       # 0041e90c
    {load} cmp ecx, edx                          # 0041e913
    jne.d8 L_0041e93a                            # 0041e915
    # block 0x0041e917: entered by fall-through of jne at 0x0041e915, 6 instruction(s), ends with jne to 0x0041e93a (forward)
    movsx eax, word ptr [ebp - local_5c]         # 0041e917
    mov ecx, dword ptr [ebp - local_54]          # 0041e91b
    movsx edx, byte ptr [ecx + eax + field_2]    # 0041e91e
    movsx eax, byte ptr [ebp - local_1432]       # 0041e923
    {load} cmp edx, eax                          # 0041e92a
    jne.d8 L_0041e93a                            # 0041e92c
    # block 0x0041e92e: entered by fall-through of jne at 0x0041e92c, 2 instruction(s), ends with forward jump to 0x0041e93c
    mov dword ptr [ebp - local_142c], 0x1        # 0041e92e
    jmp.d8 L_0041e93c                            # 0041e938
L_0041e93a:
    # block 0x0041e93a: entered by jne at 0x0041e8fe; jne at 0x0041e915; jne at 0x0041e92c, 1 instruction(s), ends with backward jump to 0x0041e8bd
    jmp.d8 L_0041e8bd                            # 0041e93a
L_0041e93c:
    # block 0x0041e93c: entered by jae at 0x0041e8e8; jmp at 0x0041e938, 2 instruction(s), ends with jne to 0x0041e962 (forward)
    cmp dword ptr [ebp - local_142c], 0x0        # 0041e93c
    jne.d8 L_0041e962                            # 0041e943
    # block 0x0041e945: entered by fall-through of jne at 0x0041e943, 7 instruction(s), calls FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x0041f563
    push 0x0                                     # 0041e945
    push 0x0                                     # 0041e947
    push 0x5438bc                                # 0041e949
    call FUN_0052139c                            # 0041e94e
    mov ecx, 0x5cf659                            # 0041e953
    call FUN_004c97b4                            # 0041e958
    jmp.d32 L_0041f563                           # 0041e95d
L_0041e962:
    # block 0x0041e962: entered by jne at 0x0041e943, 12 instruction(s), ends with forward jump to 0x0041e999
    movsx edx, word ptr [ebp - local_5c]         # 0041e962
    lea edi, [ebp - local_1434]                  # 0041e966
    or ecx, -0x1                                 # 0041e96c
    {load} xor eax, eax                          # 0041e96f
    repne scasb al, byte ptr es:[edi]            # 0041e971
    not ecx                                      # 0041e973
    add ecx, -0x1                                # 0041e975
    {load} add edx, ecx                          # 0041e978
    mov word ptr [ebp - local_28], dx            # 0041e97a
    mov dword ptr [ebp - local_8], 0x0           # 0041e97e
    mov word ptr [ebp - local_5c], 0x0           # 0041e985
    jmp.d8 L_0041e999                            # 0041e98b
L_0041e98d:
    # block 0x0041e98d: entered by jmp at 0x0041ea07, 3 instruction(s), falls into the block at 0x0041e999
    mov ax, word ptr [ebp - local_5c]            # 0041e98d
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041e991
    mov word ptr [ebp - local_5c], ax            # 0041e995
L_0041e999:
    # block 0x0041e999: entered by jmp at 0x0041e98b, 11 instruction(s), ends with jae to 0x0041ea09 (forward)
    movsx edx, word ptr [ebp - local_5c]         # 0041e999
    lea edi, [ebp - local_1418]                  # 0041e99d
    or ecx, -0x1                                 # 0041e9a3
    {load} xor eax, eax                          # 0041e9a6
    repne scasb al, byte ptr es:[edi]            # 0041e9a8
    not ecx                                      # 0041e9aa
    add ecx, -0x1                                # 0041e9ac
    mov eax, 0x5dc                               # 0041e9af
    {load} sub eax, ecx                          # 0041e9b4
    {load} cmp edx, eax                          # 0041e9b6
    jae.d8 L_0041ea09                            # 0041e9b8
    # block 0x0041e9ba: entered by fall-through of jae at 0x0041e9b8, 6 instruction(s), ends with jne to 0x0041ea07 (forward)
    movsx ecx, word ptr [ebp - local_5c]         # 0041e9ba
    mov edx, dword ptr [ebp - local_54]          # 0041e9be
    movsx eax, byte ptr [edx + ecx]              # 0041e9c1
    movsx ecx, byte ptr [ebp - local_1418]       # 0041e9c5
    {load} cmp eax, ecx                          # 0041e9cc
    jne.d8 L_0041ea07                            # 0041e9ce
    # block 0x0041e9d0: entered by fall-through of jne at 0x0041e9ce, 6 instruction(s), ends with jne to 0x0041ea07 (forward)
    movsx edx, word ptr [ebp - local_5c]         # 0041e9d0
    mov eax, dword ptr [ebp - local_54]          # 0041e9d4
    movsx ecx, byte ptr [eax + edx + field_1]    # 0041e9d7
    movsx edx, byte ptr [ebp - local_1417]       # 0041e9dc
    {load} cmp ecx, edx                          # 0041e9e3
    jne.d8 L_0041ea07                            # 0041e9e5
    # block 0x0041e9e7: entered by fall-through of jne at 0x0041e9e5, 6 instruction(s), ends with jne to 0x0041ea07 (forward)
    movsx eax, word ptr [ebp - local_5c]         # 0041e9e7
    mov ecx, dword ptr [ebp - local_54]          # 0041e9eb
    movsx edx, byte ptr [ecx + eax + field_2]    # 0041e9ee
    movsx eax, byte ptr [ebp - local_1416]       # 0041e9f3
    {load} cmp edx, eax                          # 0041e9fa
    jne.d8 L_0041ea07                            # 0041e9fc
    # block 0x0041e9fe: entered by fall-through of jne at 0x0041e9fc, 2 instruction(s), ends with forward jump to 0x0041ea09
    mov dword ptr [ebp - local_8], 0x1           # 0041e9fe
    jmp.d8 L_0041ea09                            # 0041ea05
L_0041ea07:
    # block 0x0041ea07: entered by jne at 0x0041e9ce; jne at 0x0041e9e5; jne at 0x0041e9fc, 1 instruction(s), ends with backward jump to 0x0041e98d
    jmp.d8 L_0041e98d                            # 0041ea07
L_0041ea09:
    # block 0x0041ea09: entered by jae at 0x0041e9b8; jmp at 0x0041ea05, 2 instruction(s), ends with jne to 0x0041ea2c (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0041ea09
    jne.d8 L_0041ea2c                            # 0041ea0d
    # block 0x0041ea0f: entered by fall-through of jne at 0x0041ea0d, 7 instruction(s), calls FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x0041f563
    push 0x0                                     # 0041ea0f
    push 0x0                                     # 0041ea11
    push 0x543934                                # 0041ea13
    call FUN_0052139c                            # 0041ea18
    mov ecx, 0x5cf659                            # 0041ea1d
    call FUN_004c97b4                            # 0041ea22
    jmp.d32 L_0041f563                           # 0041ea27
L_0041ea2c:
    # block 0x0041ea2c: entered by jne at 0x0041ea0d, 11 instruction(s), ends with jne to 0x0041ea63 (forward)
    movsx edx, word ptr [ebp - local_5c]         # 0041ea2c
    lea edi, [ebp - local_1418]                  # 0041ea30
    or ecx, -0x1                                 # 0041ea36
    {load} xor eax, eax                          # 0041ea39
    repne scasb al, byte ptr es:[edi]            # 0041ea3b
    not ecx                                      # 0041ea3d
    add ecx, -0x1                                # 0041ea3f
    {load} add edx, ecx                          # 0041ea42
    mov word ptr [ebp - local_13f4], dx          # 0041ea44
    cmp dword ptr [0x5bb202], 0x0                # 0041ea4b
    jne.d8 L_0041ea63                            # 0041ea52
    # block 0x0041ea54: entered by fall-through of jne at 0x0041ea52, 4 instruction(s), falls into the block at 0x0041ea63
    movsx eax, word ptr [ebp - local_13f4]       # 0041ea54
    mov ecx, dword ptr [ebp - local_54]          # 0041ea5b
    {load} add ecx, eax                          # 0041ea5e
    mov dword ptr [ebp - local_54], ecx          # 0041ea60
L_0041ea63:
    # block 0x0041ea63: entered by jne at 0x0041ea52, 2 instruction(s), ends with forward jump to 0x0041ea80
    mov word ptr [ebp - local_5c], 0x0           # 0041ea63
    jmp.d8 L_0041ea80                            # 0041ea69
L_0041ea6b:
    # block 0x0041ea6b: entered by jmp at 0x0041ea8b; jmp at 0x0041f493, 6 instruction(s), falls into the block at 0x0041ea80
    mov dx, word ptr [ebp - local_5c]            # 0041ea6b
    add dx, 0x1                                  # 0041ea6f
    mov word ptr [ebp - local_5c], dx            # 0041ea73
    mov eax, dword ptr [ebp - local_54]          # 0041ea77
    add eax, 0x1                                 # 0041ea7a
    mov dword ptr [ebp - local_54], eax          # 0041ea7d
L_0041ea80:
    # block 0x0041ea80: entered by jmp at 0x0041ea69, 4 instruction(s), ends with jne to 0x0041ea8d (forward)
    mov ecx, dword ptr [ebp - local_54]          # 0041ea80
    movsx edx, byte ptr [ecx]                    # 0041ea83
    cmp edx, 0x5c                                # 0041ea86
    jne.d8 L_0041ea8d                            # 0041ea89
    # block 0x0041ea8b: entered by fall-through of jne at 0x0041ea89, 1 instruction(s), ends with backward jump to 0x0041ea6b
    jmp.d8 L_0041ea6b                            # 0041ea8b
L_0041ea8d:
    # block 0x0041ea8d: entered by jne at 0x0041ea89, 5 instruction(s), ends with je to 0x0041eaaf (forward)
    mov eax, dword ptr [ebp - local_54]          # 0041ea8d
    mov cl, byte ptr [eax]                       # 0041ea90
    mov byte ptr [ebp - local_1444], cl          # 0041ea92
    cmp byte ptr [ebp - local_1444], 0x3c        # 0041ea98
    je.d8 L_0041eaaf                             # 0041ea9f
    # block 0x0041eaa1: entered by fall-through of je at 0x0041ea9f, 2 instruction(s), ends with je to 0x0041eac8 (forward)
    cmp byte ptr [ebp - local_1444], 0x3e        # 0041eaa1
    je.d8 L_0041eac8                             # 0041eaa8
    # block 0x0041eaaa: entered by fall-through of je at 0x0041eaa8, 1 instruction(s), ends with forward jump to 0x0041f41b
    jmp.d32 L_0041f41b                           # 0041eaaa
L_0041eaaf:
    # block 0x0041eaaf: entered by je at 0x0041ea9f, 3 instruction(s), ends with forward jump to 0x0041f48b
    mov dword ptr [ebp - local_13fc], 0x1        # 0041eaaf
    mov dword ptr [ebp - local_13ec], 0x0        # 0041eab9
    jmp.d32 L_0041f48b                           # 0041eac3
L_0041eac8:
    # block 0x0041eac8: entered by je at 0x0041eaa8, 8 instruction(s), ends with ja to 0x0041f40c (forward)
    mov dword ptr [ebp - local_13fc], 0x0        # 0041eac8
    movsx edx, byte ptr [ebp - local_60]         # 0041ead2
    mov dword ptr [ebp - local_1448], edx        # 0041ead6
    mov eax, dword ptr [ebp - local_1448]        # 0041eadc
    sub eax, 0x63                                # 0041eae2
    mov dword ptr [ebp - local_1448], eax        # 0041eae5
    cmp dword ptr [ebp - local_1448], 0x14       # 0041eaeb
    ja.d32 L_0041f40c                            # 0041eaf2
    # block 0x0041eaf8: entered by fall-through of ja at 0x0041eaf2, 4 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x41f56c]
    mov edx, dword ptr [ebp - local_1448]        # 0041eaf8
    {load} xor ecx, ecx                          # 0041eafe
    mov cl, byte ptr [edx + IDXTAB_0041f59c_VA]  # 0041eb00
    jmp dword ptr [4*ecx + SWTAB_0041f56c_VA]    # 0041eb06
L_0041eb0d:
    # block 0x0041eb0d: entered by switch case, 3 instruction(s), ends with jne to 0x0041eb6d (forward)
    mov eax, dword ptr [ebp - local_1440]        # 0041eb0d
    cmp dword ptr [eax + field_20e3], 0x0        # 0041eb13
    jne.d8 L_0041eb6d                            # 0041eb1a
    # block 0x0041eb1c: entered by fall-through of jne at 0x0041eb1a, 23 instruction(s), calls FUN_0041f5b1, ends with forward jump to 0x0041ebbc
    mov ecx, dword ptr [ebp + arg_8]             # 0041eb1c
    push ecx                                     # 0041eb1f
    mov dx, word ptr [ebp - local_13f0]          # 0041eb20
    push edx                                     # 0041eb27
    lea eax, [ebp - local_4]                     # 0041eb28
    push eax                                     # 0041eb2b
    mov cx, word ptr [ebp - local_1420]          # 0041eb2c
    push ecx                                     # 0041eb33
    mov dx, word ptr [ebp - local_1424]          # 0041eb34
    push edx                                     # 0041eb3b
    lea eax, [ebp - local_20]                    # 0041eb3c
    push eax                                     # 0041eb3f
    lea ecx, [ebp - local_58]                    # 0041eb40
    push ecx                                     # 0041eb43
    mov dx, word ptr [ebp + arg_18]              # 0041eb44
    push edx                                     # 0041eb48
    lea eax, [ebp - local_13e8]                  # 0041eb49
    push eax                                     # 0041eb4f
    mov ecx, dword ptr [ebp - local_1440]        # 0041eb50
    call FUN_0041f5b1                            # 0041eb56
    mov ecx, dword ptr [ebp - local_1440]        # 0041eb5b
    mov dword ptr [ecx + field_20e3], 0x1        # 0041eb61
    jmp.d8 L_0041ebbc                            # 0041eb6b
L_0041eb6d:
    # block 0x0041eb6d: entered by jne at 0x0041eb1a, 22 instruction(s), calls FUN_0041f5b1, falls into the block at 0x0041ebbc
    mov edx, dword ptr [ebp + arg_8]             # 0041eb6d
    push edx                                     # 0041eb70
    mov ax, word ptr [ebp - local_13f0]          # 0041eb71
    push eax                                     # 0041eb78
    lea ecx, [ebp - local_4]                     # 0041eb79
    push ecx                                     # 0041eb7c
    mov dx, word ptr [ebp - local_1420]          # 0041eb7d
    push edx                                     # 0041eb84
    mov ax, word ptr [ebp - local_1424]          # 0041eb85
    push eax                                     # 0041eb8c
    lea ecx, [ebp - local_20]                    # 0041eb8d
    push ecx                                     # 0041eb90
    lea edx, [ebp - local_58]                    # 0041eb91
    push edx                                     # 0041eb94
    mov ax, word ptr [ebp + arg_18]              # 0041eb95
    push eax                                     # 0041eb99
    lea ecx, [ebp - local_13e8]                  # 0041eb9a
    push ecx                                     # 0041eba0
    mov ecx, dword ptr [ebp - local_1440]        # 0041eba1
    call FUN_0041f5b1                            # 0041eba7
    mov edx, dword ptr [ebp - local_1440]        # 0041ebac
    mov dword ptr [edx + field_20e3], 0x0        # 0041ebb2
L_0041ebbc:
    # block 0x0041ebbc: entered by jmp at 0x0041eb6b, 1 instruction(s), ends with forward jump to 0x0041f40c
    jmp.d32 L_0041f40c                           # 0041ebbc
L_0041ebc1:
    # block 0x0041ebc1: entered by switch case, 3 instruction(s), ends with jne to 0x0041ed46 (forward)
    mov eax, dword ptr [ebp - local_1440]        # 0041ebc1
    cmp dword ptr [eax + field_20dd], 0x0        # 0041ebc7
    jne.d32 L_0041ed46                           # 0041ebce
    # block 0x0041ebd4: entered by fall-through of jne at 0x0041ebce, 76 instruction(s), calls FUN_004c9340, FUN_0041f5b1, ends with forward jump to 0x0041ed95
    movsx ecx, word ptr [ebp + arg_18]           # 0041ebd4
    imul ecx, ecx, 0x7f3                         # 0041ebd8
    movsx edx, word ptr [ecx + 0x5a4c77]         # 0041ebde
    mov dword ptr [ebp - local_1428], edx        # 0041ebe5
    movsx eax, word ptr [ebp + arg_18]           # 0041ebeb
    imul eax, eax, 0x7f3                         # 0041ebef
    mov ecx, dword ptr [ebp - local_1428]        # 0041ebf5
    shl ecx, 0x4                                 # 0041ebfb
    movsx edx, word ptr [ebp + arg_18]           # 0041ebfe
    imul edx, edx, 0x7f3                         # 0041ec02
    movsx esi, word ptr [ebp - local_13f0]       # 0041ec08
    mov eax, dword ptr [eax + ecx + 0x5a4ceb]    # 0041ec0f
    add eax, dword ptr [edx + 8*esi + 0x5a4c67]  # 0041ec16
    mov dword ptr [ebp - local_140c], eax        # 0041ec1d
    movsx ecx, word ptr [ebp + arg_18]           # 0041ec23
    imul ecx, ecx, 0x7f3                         # 0041ec27
    mov edx, dword ptr [ebp - local_1428]        # 0041ec2d
    shl edx, 0x4                                 # 0041ec33
    movsx eax, word ptr [ebp + arg_18]           # 0041ec36
    imul eax, eax, 0x7f3                         # 0041ec3a
    movsx esi, word ptr [ebp - local_13f0]       # 0041ec40
    mov ecx, dword ptr [ecx + edx + 0x5a4cf3]    # 0041ec47
    add ecx, dword ptr [eax + 8*esi + 0x5a4c67]  # 0041ec4e
    mov dword ptr [ebp - local_1404], ecx        # 0041ec55
    movsx edx, word ptr [ebp + arg_18]           # 0041ec5b
    imul edx, edx, 0x7f3                         # 0041ec5f
    mov eax, dword ptr [ebp - local_1428]        # 0041ec65
    shl eax, 0x4                                 # 0041ec6b
    movsx ecx, word ptr [ebp + arg_18]           # 0041ec6e
    imul ecx, ecx, 0x7f3                         # 0041ec72
    movsx esi, word ptr [ebp - local_13f0]       # 0041ec78
    mov edx, dword ptr [edx + eax + 0x5a4ce7]    # 0041ec7f
    add edx, dword ptr [ecx + 8*esi + 0x5a4c63]  # 0041ec86
    mov dword ptr [ebp - local_1410], edx        # 0041ec8d
    movsx eax, word ptr [ebp + arg_18]           # 0041ec93
    imul eax, eax, 0x7f3                         # 0041ec97
    mov ecx, dword ptr [ebp - local_1428]        # 0041ec9d
    shl ecx, 0x4                                 # 0041eca3
    movsx edx, word ptr [ebp + arg_18]           # 0041eca6
    imul edx, edx, 0x7f3                         # 0041ecaa
    movsx esi, word ptr [ebp - local_13f0]       # 0041ecb0
    mov eax, dword ptr [eax + ecx + 0x5a4cef]    # 0041ecb7
    add eax, dword ptr [edx + 8*esi + 0x5a4c63]  # 0041ecbe
    mov dword ptr [ebp - local_1408], eax        # 0041ecc5
    lea ecx, [ebp - local_1410]                  # 0041eccb
    push ecx                                     # 0041ecd1
    movsx edx, word ptr [ebp + arg_18]           # 0041ecd2
    mov eax, dword ptr [4*edx + 0x5d032f]        # 0041ecd6
    push eax                                     # 0041ecdd
    mov ecx, 0x5cf659                            # 0041ecde
    call FUN_004c9340                            # 0041ece3
    mov ecx, dword ptr [ebp - local_1440]        # 0041ece8
    mov word ptr [ecx + field_20e1], ax          # 0041ecee
    mov edx, dword ptr [ebp + arg_8]             # 0041ecf5
    push edx                                     # 0041ecf8
    mov ax, word ptr [ebp - local_13f0]          # 0041ecf9
    push eax                                     # 0041ed00
    lea ecx, [ebp - local_4]                     # 0041ed01
    push ecx                                     # 0041ed04
    mov dx, word ptr [ebp - local_1420]          # 0041ed05
    push edx                                     # 0041ed0c
    mov ax, word ptr [ebp - local_1424]          # 0041ed0d
    push eax                                     # 0041ed14
    lea ecx, [ebp - local_20]                    # 0041ed15
    push ecx                                     # 0041ed18
    lea edx, [ebp - local_58]                    # 0041ed19
    push edx                                     # 0041ed1c
    mov ax, word ptr [ebp + arg_18]              # 0041ed1d
    push eax                                     # 0041ed21
    lea ecx, [ebp - local_13e8]                  # 0041ed22
    push ecx                                     # 0041ed28
    mov ecx, dword ptr [ebp - local_1440]        # 0041ed29
    call FUN_0041f5b1                            # 0041ed2f
    mov edx, dword ptr [ebp - local_1440]        # 0041ed34
    mov dword ptr [edx + field_20dd], 0x1        # 0041ed3a
    jmp.d8 L_0041ed95                            # 0041ed44
L_0041ed46:
    # block 0x0041ed46: entered by jne at 0x0041ebce, 22 instruction(s), calls FUN_0041f5b1, falls into the block at 0x0041ed95
    mov eax, dword ptr [ebp + arg_8]             # 0041ed46
    push eax                                     # 0041ed49
    mov cx, word ptr [ebp - local_13f0]          # 0041ed4a
    push ecx                                     # 0041ed51
    lea edx, [ebp - local_4]                     # 0041ed52
    push edx                                     # 0041ed55
    mov ax, word ptr [ebp - local_1420]          # 0041ed56
    push eax                                     # 0041ed5d
    mov cx, word ptr [ebp - local_1424]          # 0041ed5e
    push ecx                                     # 0041ed65
    lea edx, [ebp - local_20]                    # 0041ed66
    push edx                                     # 0041ed69
    lea eax, [ebp - local_58]                    # 0041ed6a
    push eax                                     # 0041ed6d
    mov cx, word ptr [ebp + arg_18]              # 0041ed6e
    push ecx                                     # 0041ed72
    lea edx, [ebp - local_13e8]                  # 0041ed73
    push edx                                     # 0041ed79
    mov ecx, dword ptr [ebp - local_1440]        # 0041ed7a
    call FUN_0041f5b1                            # 0041ed80
    mov eax, dword ptr [ebp - local_1440]        # 0041ed85
    mov dword ptr [eax + field_20dd], 0x0        # 0041ed8b
L_0041ed95:
    # block 0x0041ed95: entered by jmp at 0x0041ed44, 1 instruction(s), ends with forward jump to 0x0041f40c
    jmp.d32 L_0041f40c                           # 0041ed95
L_0041ed9a:
    # block 0x0041ed9a: entered by switch case, 27 instruction(s), calls FUN_0041f5b1, FUN_0050cb1b, ends with je to 0x0041edfb (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0041ed9a
    push ecx                                     # 0041ed9d
    mov dx, word ptr [ebp - local_13f0]          # 0041ed9e
    push edx                                     # 0041eda5
    lea eax, [ebp - local_4]                     # 0041eda6
    push eax                                     # 0041eda9
    mov cx, word ptr [ebp - local_1420]          # 0041edaa
    push ecx                                     # 0041edb1
    mov dx, word ptr [ebp - local_1424]          # 0041edb2
    push edx                                     # 0041edb9
    lea eax, [ebp - local_20]                    # 0041edba
    push eax                                     # 0041edbd
    lea ecx, [ebp - local_58]                    # 0041edbe
    push ecx                                     # 0041edc1
    mov dx, word ptr [ebp + arg_18]              # 0041edc2
    push edx                                     # 0041edc6
    lea eax, [ebp - local_13e8]                  # 0041edc7
    push eax                                     # 0041edcd
    mov ecx, dword ptr [ebp - local_1440]        # 0041edce
    call FUN_0041f5b1                            # 0041edd4
    lea ecx, [ebp - local_48]                    # 0041edd9
    push ecx                                     # 0041eddc
    call FUN_0050cb1b                            # 0041eddd
    add esp, 0x4                                 # 0041ede2
    mov word ptr [ebp - local_13f0], ax          # 0041ede5
    cmp dword ptr [ebp - local_58], 0x0          # 0041edec
    je.d8 L_0041edfb                             # 0041edf0
    # block 0x0041edf2: entered by fall-through of je at 0x0041edf0, 2 instruction(s), ends with forward jump to 0x0041ee02
    mov dword ptr [ebp - local_4c], 0x1          # 0041edf2
    jmp.d8 L_0041ee02                            # 0041edf9
L_0041edfb:
    # block 0x0041edfb: entered by je at 0x0041edf0, 1 instruction(s), falls into the block at 0x0041ee02
    mov dword ptr [ebp - local_4c], 0x0          # 0041edfb
L_0041ee02:
    # block 0x0041ee02: entered by jmp at 0x0041edf9, 1 instruction(s), ends with forward jump to 0x0041f40c
    jmp.d32 L_0041f40c                           # 0041ee02
L_0041ee07:
    # block 0x0041ee07: entered by switch case, 2 instruction(s), ends with forward jump to 0x0041f40c
    mov dword ptr [ebp - local_24], 0x1          # 0041ee07
    jmp.d32 L_0041f40c                           # 0041ee0e
L_0041ee13:
    # block 0x0041ee13: entered by switch case, 34 instruction(s), calls FUN_0041f5b1, FUN_004c92c5, FUN_0050cb1b, FUN_004c924d, ends with forward jump to 0x0041f40c
    mov edx, dword ptr [ebp + arg_8]             # 0041ee13
    push edx                                     # 0041ee16
    mov ax, word ptr [ebp - local_13f0]          # 0041ee17
    push eax                                     # 0041ee1e
    lea ecx, [ebp - local_4]                     # 0041ee1f
    push ecx                                     # 0041ee22
    mov dx, word ptr [ebp - local_1420]          # 0041ee23
    push edx                                     # 0041ee2a
    mov ax, word ptr [ebp - local_1424]          # 0041ee2b
    push eax                                     # 0041ee32
    lea ecx, [ebp - local_20]                    # 0041ee33
    push ecx                                     # 0041ee36
    lea edx, [ebp - local_58]                    # 0041ee37
    push edx                                     # 0041ee3a
    mov ax, word ptr [ebp + arg_18]              # 0041ee3b
    push eax                                     # 0041ee3f
    lea ecx, [ebp - local_13e8]                  # 0041ee40
    push ecx                                     # 0041ee46
    mov ecx, dword ptr [ebp - local_1440]        # 0041ee47
    call FUN_0041f5b1                            # 0041ee4d
    mov dx, word ptr [ebp + arg_18]              # 0041ee52
    push edx                                     # 0041ee56
    mov ecx, 0x5cf659                            # 0041ee57
    call FUN_004c92c5                            # 0041ee5c
    lea eax, [ebp - local_48]                    # 0041ee61
    push eax                                     # 0041ee64
    call FUN_0050cb1b                            # 0041ee65
    add esp, 0x4                                 # 0041ee6a
    mov word ptr [ebp + arg_18], ax              # 0041ee6d
    mov cx, word ptr [ebp + arg_18]              # 0041ee71
    push ecx                                     # 0041ee75
    mov ecx, 0x5cf659                            # 0041ee76
    call FUN_004c924d                            # 0041ee7b
    jmp.d32 L_0041f40c                           # 0041ee80
L_0041ee85:
    # block 0x0041ee85: entered by switch case, 28 instruction(s), calls FUN_0041f5b1, ends with jbe to 0x0041ef7d (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0041ee85
    push edx                                     # 0041ee88
    mov ax, word ptr [ebp - local_13f0]          # 0041ee89
    push eax                                     # 0041ee90
    lea ecx, [ebp - local_4]                     # 0041ee91
    push ecx                                     # 0041ee94
    mov dx, word ptr [ebp - local_1420]          # 0041ee95
    push edx                                     # 0041ee9c
    mov ax, word ptr [ebp - local_1424]          # 0041ee9d
    push eax                                     # 0041eea4
    lea ecx, [ebp - local_20]                    # 0041eea5
    push ecx                                     # 0041eea8
    lea edx, [ebp - local_58]                    # 0041eea9
    push edx                                     # 0041eeac
    mov ax, word ptr [ebp + arg_18]              # 0041eead
    push eax                                     # 0041eeb1
    lea ecx, [ebp - local_13e8]                  # 0041eeb2
    push ecx                                     # 0041eeb8
    mov ecx, dword ptr [ebp - local_1440]        # 0041eeb9
    call FUN_0041f5b1                            # 0041eebf
    lea edi, [ebp - local_48]                    # 0041eec4
    or ecx, -0x1                                 # 0041eec7
    {load} xor eax, eax                          # 0041eeca
    repne scasb al, byte ptr es:[edi]            # 0041eecc
    not ecx                                      # 0041eece
    add ecx, -0x1                                # 0041eed0
    test ecx, ecx                                # 0041eed3
    jbe.d32 L_0041ef7d                           # 0041eed5
    # block 0x0041eedb: entered by fall-through of jbe at 0x0041eed5, 22 instruction(s), calls FUN_0050cb1b, ends with jne to 0x0041ef78 (forward)
    mov dx, word ptr [0x5b0a8e]                  # 0041eedb
    add dx, 0x1                                  # 0041eee2
    mov word ptr [0x5b0a8e], dx                  # 0041eee6
    lea eax, [ebp - local_48]                    # 0041eeed
    push eax                                     # 0041eef0
    call FUN_0050cb1b                            # 0041eef1
    add esp, 0x4                                 # 0041eef6
    mov word ptr [ebp - local_2c], ax            # 0041eef9
    movsx ecx, word ptr [ebp - local_2c]         # 0041eefd
    imul ecx, ecx, 0x29                          # 0041ef01
    mov dx, word ptr [0x5b0a36]                  # 0041ef04
    mov word ptr [ecx + 0x5b0a92], dx            # 0041ef0b
    movsx eax, word ptr [ebp - local_20]         # 0041ef12
    movsx ecx, word ptr [ebp + arg_18]           # 0041ef16
    imul ecx, ecx, 0x1d0                         # 0041ef1a
    movsx edx, word ptr [ecx + 0x5adb3c]         # 0041ef20
    {load} sub eax, edx                          # 0041ef27
    movsx ecx, word ptr [ebp - local_2c]         # 0041ef29
    imul ecx, ecx, 0x29                          # 0041ef2d
    mov word ptr [ecx + 0x5b0a94], ax            # 0041ef30
    cmp dword ptr [ebp - local_13f8], 0x0        # 0041ef37
    jne.d8 L_0041ef78                            # 0041ef3e
    # block 0x0041ef40: entered by fall-through of jne at 0x0041ef3e, 2 instruction(s), ends with forward jump to 0x0041ef54
    mov word ptr [ebp - local_50], 0x0           # 0041ef40
    jmp.d8 L_0041ef54                            # 0041ef46
L_0041ef48:
    # block 0x0041ef48: entered by jmp at 0x0041ef6c, 3 instruction(s), falls into the block at 0x0041ef54
    mov dx, word ptr [ebp - local_50]            # 0041ef48
    add dx, 0x1                                  # 0041ef4c
    mov word ptr [ebp - local_50], dx            # 0041ef50
L_0041ef54:
    # block 0x0041ef54: entered by jmp at 0x0041ef46, 3 instruction(s), ends with jge to 0x0041ef6e (forward)
    movsx eax, word ptr [ebp - local_50]         # 0041ef54
    cmp eax, 0x1e                                # 0041ef58
    jge.d8 L_0041ef6e                            # 0041ef5b
    # block 0x0041ef5d: entered by fall-through of jge at 0x0041ef5b, 3 instruction(s), ends with backward jump to 0x0041ef48
    movsx ecx, word ptr [ebp - local_50]         # 0041ef5d
    mov dword ptr [4*ecx + 0x5839b1], 0x0        # 0041ef61
    jmp.d8 L_0041ef48                            # 0041ef6c
L_0041ef6e:
    # block 0x0041ef6e: entered by jge at 0x0041ef5b, 1 instruction(s), falls into the block at 0x0041ef78
    mov dword ptr [ebp - local_13f8], 0x1        # 0041ef6e
L_0041ef78:
    # block 0x0041ef78: entered by jne at 0x0041ef3e, 1 instruction(s), ends with forward jump to 0x0041f0ca
    jmp.d32 L_0041f0ca                           # 0041ef78
L_0041ef7d:
    # block 0x0041ef7d: entered by jbe at 0x0041eed5, 28 instruction(s), calls FUN_0050ce04, ends with jge to 0x0041f0ca (forward)
    movsx edx, word ptr [ebp - local_2c]         # 0041ef7d
    imul edx, edx, 0x29                          # 0041ef81
    mov ax, word ptr [ebp - local_1400]          # 0041ef84
    mov word ptr [edx + 0x5b0a96], ax            # 0041ef8b
    movsx esi, word ptr [ebp - local_20]         # 0041ef92
    movsx ecx, word ptr [ebp + arg_18]           # 0041ef96
    imul ecx, ecx, 0x1d0                         # 0041ef9a
    movsx edx, word ptr [ecx + 0x5adb3c]         # 0041efa0
    mov dword ptr [ebp - local_144c], edx        # 0041efa7
    fild dword ptr [ebp - local_144c]            # 0041efad
    fstp dword ptr [ebp - local_1450]            # 0041efb3
    fld dword ptr [ebp - local_1450]             # 0041efb9
    fdiv qword ptr [0x52c678]                    # 0041efbf
    call FUN_0050ce04                            # 0041efc5
    movsx eax, ax                                # 0041efca
    {load} add esi, eax                          # 0041efcd
    movsx ecx, word ptr [ebp - local_2c]         # 0041efcf
    imul ecx, ecx, 0x29                          # 0041efd3
    mov word ptr [ecx + 0x5b0a98], si            # 0041efd6
    movsx edx, word ptr [ebp - local_2c]         # 0041efdd
    imul edx, edx, 0x29                          # 0041efe1
    movsx eax, word ptr [edx + 0x5b0a98]         # 0041efe4
    movsx ecx, word ptr [ebp - local_2c]         # 0041efeb
    imul ecx, ecx, 0x29                          # 0041efef
    movsx edx, word ptr [ecx + 0x5b0a94]         # 0041eff2
    {load} sub eax, edx                          # 0041eff9
    cmp eax, 0x6                                 # 0041effb
    jge.d32 L_0041f0ca                           # 0041effe
    # block 0x0041f004: entered by fall-through of jge at 0x0041effe, 32 instruction(s), ends with jge to 0x0041f09c (forward)
    movsx ecx, word ptr [ebp - local_2c]         # 0041f004
    imul ecx, ecx, 0x29                          # 0041f008
    movsx edx, word ptr [ebp + arg_18]           # 0041f00b
    imul edx, edx, 0x1d0                         # 0041f00f
    movsx eax, word ptr [edx + 0x5adb3c]         # 0041f015
    cdq                                          # 0041f01c
    {load} sub eax, edx                          # 0041f01d
    sar eax                                      # 0041f01f
    mov cx, word ptr [ecx + 0x5b0a94]            # 0041f021
    {load} sub cx, ax                            # 0041f028
    movsx edx, word ptr [ebp - local_2c]         # 0041f02b
    imul edx, edx, 0x29                          # 0041f02f
    mov word ptr [edx + 0x5b0a94], cx            # 0041f032
    movsx ecx, word ptr [ebp - local_2c]         # 0041f039
    imul ecx, ecx, 0x29                          # 0041f03d
    movsx edx, word ptr [ebp + arg_18]           # 0041f040
    imul edx, edx, 0x1d0                         # 0041f044
    movsx eax, word ptr [edx + 0x5adb3c]         # 0041f04a
    cdq                                          # 0041f051
    {load} sub eax, edx                          # 0041f052
    sar eax                                      # 0041f054
    mov cx, word ptr [ecx + 0x5b0a98]            # 0041f056
    {load} add cx, ax                            # 0041f05d
    movsx edx, word ptr [ebp - local_2c]         # 0041f060
    imul edx, edx, 0x29                          # 0041f064
    mov word ptr [edx + 0x5b0a98], cx            # 0041f067
    movsx eax, word ptr [ebp - local_2c]         # 0041f06e
    imul eax, eax, 0x29                          # 0041f072
    movsx ecx, word ptr [eax + 0x5b0a94]         # 0041f075
    movsx edx, word ptr [0x5b0a32]               # 0041f07c
    {load} cmp ecx, edx                          # 0041f083
    jge.d8 L_0041f09c                            # 0041f085
    # block 0x0041f087: entered by fall-through of jge at 0x0041f085, 4 instruction(s), falls into the block at 0x0041f09c
    movsx eax, word ptr [ebp - local_2c]         # 0041f087
    imul eax, eax, 0x29                          # 0041f08b
    mov cx, word ptr [0x5b0a32]                  # 0041f08e
    mov word ptr [eax + 0x5b0a94], cx            # 0041f095
L_0041f09c:
    # block 0x0041f09c: entered by jge at 0x0041f085, 6 instruction(s), ends with jle to 0x0041f0ca (forward)
    movsx edx, word ptr [ebp - local_2c]         # 0041f09c
    imul edx, edx, 0x29                          # 0041f0a0
    movsx eax, word ptr [edx + 0x5b0a98]         # 0041f0a3
    movsx ecx, word ptr [ebp - local_1424]       # 0041f0aa
    {load} cmp eax, ecx                          # 0041f0b1
    jle.d8 L_0041f0ca                            # 0041f0b3
    # block 0x0041f0b5: entered by fall-through of jle at 0x0041f0b3, 4 instruction(s), falls into the block at 0x0041f0ca
    movsx edx, word ptr [ebp - local_2c]         # 0041f0b5
    imul edx, edx, 0x29                          # 0041f0b9
    mov ax, word ptr [ebp - local_1424]          # 0041f0bc
    mov word ptr [edx + 0x5b0a98], ax            # 0041f0c3
L_0041f0ca:
    # block 0x0041f0ca: entered by jmp at 0x0041ef78; jge at 0x0041effe; jle at 0x0041f0b3, 1 instruction(s), ends with forward jump to 0x0041f40c
    jmp.d32 L_0041f40c                           # 0041f0ca
L_0041f0cf:
    # block 0x0041f0cf: entered by switch case, 2 instruction(s), ends with jne to 0x0041f141 (forward)
    cmp dword ptr [ebp - local_4c], 0x0          # 0041f0cf
    jne.d8 L_0041f141                            # 0041f0d3
    # block 0x0041f0d5: entered by fall-through of jne at 0x0041f0d3, 26 instruction(s), calls FUN_0041f5b1, ends with jne to 0x0041f13f (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0041f0d5
    push ecx                                     # 0041f0d8
    mov dx, word ptr [ebp - local_13f0]          # 0041f0d9
    push edx                                     # 0041f0e0
    lea eax, [ebp - local_4]                     # 0041f0e1
    push eax                                     # 0041f0e4
    mov cx, word ptr [ebp - local_1420]          # 0041f0e5
    push ecx                                     # 0041f0ec
    mov dx, word ptr [ebp - local_1424]          # 0041f0ed
    push edx                                     # 0041f0f4
    lea eax, [ebp - local_20]                    # 0041f0f5
    push eax                                     # 0041f0f8
    lea ecx, [ebp - local_58]                    # 0041f0f9
    push ecx                                     # 0041f0fc
    mov dx, word ptr [ebp + arg_18]              # 0041f0fd
    push edx                                     # 0041f101
    lea eax, [ebp - local_13e8]                  # 0041f102
    push eax                                     # 0041f108
    mov ecx, dword ptr [ebp - local_1440]        # 0041f109
    call FUN_0041f5b1                            # 0041f10f
    mov cx, word ptr [0x5b0a36]                  # 0041f114
    mov word ptr [ebp - local_4], cx             # 0041f11b
    mov dword ptr [ebp - local_58], 0x1          # 0041f11f
    movsx edx, byte ptr [ebp - local_60]         # 0041f126
    cmp edx, 0x77                                # 0041f12a
    jne.d8 L_0041f13f                            # 0041f12d
    # block 0x0041f12f: entered by fall-through of jne at 0x0041f12d, 2 instruction(s), falls into the block at 0x0041f13f
    mov eax, dword ptr [ebp - local_1440]        # 0041f12f
    mov dword ptr [eax + field_20e7], 0x1        # 0041f135
L_0041f13f:
    # block 0x0041f13f: entered by jne at 0x0041f12d, 1 instruction(s), ends with forward jump to 0x0041f148
    jmp.d8 L_0041f148                            # 0041f13f
L_0041f141:
    # block 0x0041f141: entered by jne at 0x0041f0d3, 1 instruction(s), falls into the block at 0x0041f148
    mov dword ptr [ebp - local_4c], 0x0          # 0041f141
L_0041f148:
    # block 0x0041f148: entered by jmp at 0x0041f13f, 1 instruction(s), ends with forward jump to 0x0041f40c
    jmp.d32 L_0041f40c                           # 0041f148
L_0041f14d:
    # block 0x0041f14d: entered by switch case, 2 instruction(s), ends with je to 0x0041f1ac (forward)
    cmp dword ptr [ebp - local_141c], 0x0        # 0041f14d
    je.d8 L_0041f1ac                             # 0041f154
    # block 0x0041f156: entered by fall-through of je at 0x0041f154, 20 instruction(s), calls FUN_004d3836, falls into the block at 0x0041f1ac
    movsx esi, word ptr [ebp - local_1420]       # 0041f156
    movsx ecx, word ptr [ebp + arg_18]           # 0041f15d
    imul ecx, ecx, 0x1d0                         # 0041f161
    add ecx, 0x5adb3a                            # 0041f167
    push ecx                                     # 0041f16d
    movsx edx, word ptr [ebp + arg_18]           # 0041f16e
    imul edx, edx, 0x7f3                         # 0041f172
    add edx, 0x5a4c24                            # 0041f178
    push edx                                     # 0041f17e
    lea eax, [ebp - local_13e8]                  # 0041f17f
    push eax                                     # 0041f185
    call FUN_004d3836                            # 0041f186
    add esp, 0xc                                 # 0041f18b
    movsx ecx, ax                                # 0041f18e
    {load} sub esi, ecx                          # 0041f191
    mov word ptr [ebp - local_4], si             # 0041f193
    movsx edx, word ptr [ebp - local_1438]       # 0041f197
    imul edx, edx, 0x29                          # 0041f19e
    mov ax, word ptr [ebp - local_4]             # 0041f1a1
    mov word ptr [edx + 0x5b142e], ax            # 0041f1a5
L_0041f1ac:
    # block 0x0041f1ac: entered by je at 0x0041f154, 22 instruction(s), calls FUN_0041f5b1, ends with je to 0x0041f209 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0041f1ac
    push ecx                                     # 0041f1af
    mov dx, word ptr [ebp - local_13f0]          # 0041f1b0
    push edx                                     # 0041f1b7
    lea eax, [ebp - local_4]                     # 0041f1b8
    push eax                                     # 0041f1bb
    mov cx, word ptr [ebp - local_1420]          # 0041f1bc
    push ecx                                     # 0041f1c3
    mov dx, word ptr [ebp - local_1424]          # 0041f1c4
    push edx                                     # 0041f1cb
    lea eax, [ebp - local_20]                    # 0041f1cc
    push eax                                     # 0041f1cf
    lea ecx, [ebp - local_58]                    # 0041f1d0
    push ecx                                     # 0041f1d3
    mov dx, word ptr [ebp + arg_18]              # 0041f1d4
    push edx                                     # 0041f1d8
    lea eax, [ebp - local_13e8]                  # 0041f1d9
    push eax                                     # 0041f1df
    mov ecx, dword ptr [ebp - local_1440]        # 0041f1e0
    call FUN_0041f5b1                            # 0041f1e6
    cmp dword ptr [ebp - local_141c], 0x0        # 0041f1eb
    je.d8 L_0041f209                             # 0041f1f2
    # block 0x0041f1f4: entered by fall-through of je at 0x0041f1f2, 4 instruction(s), falls into the block at 0x0041f209
    movsx ecx, word ptr [ebp - local_1438]       # 0041f1f4
    imul ecx, ecx, 0x29                          # 0041f1fb
    mov dx, word ptr [ebp - local_4]             # 0041f1fe
    mov word ptr [ecx + 0x5b1432], dx            # 0041f202
L_0041f209:
    # block 0x0041f209: entered by je at 0x0041f1f2, 8 instruction(s), ends with jbe to 0x0041f2aa (forward)
    lea edi, [ebp - local_48]                    # 0041f209
    or ecx, -0x1                                 # 0041f20c
    {load} xor eax, eax                          # 0041f20f
    repne scasb al, byte ptr es:[edi]            # 0041f211
    not ecx                                      # 0041f213
    add ecx, -0x1                                # 0041f215
    test ecx, ecx                                # 0041f218
    jbe.d32 L_0041f2aa                           # 0041f21a
    # block 0x0041f220: entered by fall-through of jbe at 0x0041f21a, 6 instruction(s), ends with jne to 0x0041f258 (forward)
    mov ax, word ptr [0x5b0a90]                  # 0041f220
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041f226
    mov word ptr [0x5b0a90], ax                  # 0041f22a
    movsx ecx, byte ptr [ebp - local_48]         # 0041f230
    cmp ecx, 0x72                                # 0041f234
    jne.d8 L_0041f258                            # 0041f237
    # block 0x0041f239: entered by fall-through of jne at 0x0041f237, 7 instruction(s), calls FUN_0050cb1b, ends with forward jump to 0x0041f275
    mov dword ptr [ebp - local_141c], 0x1        # 0041f239
    lea edx, [ebp - local_47]                    # 0041f243
    push edx                                     # 0041f246
    call FUN_0050cb1b                            # 0041f247
    add esp, 0x4                                 # 0041f24c
    mov word ptr [ebp - local_1438], ax          # 0041f24f
    jmp.d8 L_0041f275                            # 0041f256
L_0041f258:
    # block 0x0041f258: entered by jne at 0x0041f237, 6 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0041f275
    mov dword ptr [ebp - local_141c], 0x0        # 0041f258
    lea eax, [ebp - local_48]                    # 0041f262
    push eax                                     # 0041f265
    call FUN_0050cb1b                            # 0041f266
    add esp, 0x4                                 # 0041f26b
    mov word ptr [ebp - local_1438], ax          # 0041f26e
L_0041f275:
    # block 0x0041f275: entered by jmp at 0x0041f256, 2 instruction(s), ends with jne to 0x0041f293 (forward)
    cmp dword ptr [ebp - local_141c], 0x0        # 0041f275
    jne.d8 L_0041f293                            # 0041f27c
    # block 0x0041f27e: entered by fall-through of jne at 0x0041f27c, 4 instruction(s), falls into the block at 0x0041f293
    movsx ecx, word ptr [ebp - local_1438]       # 0041f27e
    imul ecx, ecx, 0x29                          # 0041f285
    mov dx, word ptr [ebp - local_4]             # 0041f288
    mov word ptr [ecx + 0x5b142e], dx            # 0041f28c
L_0041f293:
    # block 0x0041f293: entered by jne at 0x0041f27c, 5 instruction(s), ends with forward jump to 0x0041f2e7
    movsx eax, word ptr [ebp - local_1438]       # 0041f293
    imul eax, eax, 0x29                          # 0041f29a
    mov cx, word ptr [ebp - local_20]            # 0041f29d
    mov word ptr [eax + 0x5b1430], cx            # 0041f2a1
    jmp.d8 L_0041f2e7                            # 0041f2a8
L_0041f2aa:
    # block 0x0041f2aa: entered by jbe at 0x0041f21a, 2 instruction(s), ends with jne to 0x0041f2c8 (forward)
    cmp dword ptr [ebp - local_141c], 0x0        # 0041f2aa
    jne.d8 L_0041f2c8                            # 0041f2b1
    # block 0x0041f2b3: entered by fall-through of jne at 0x0041f2b1, 4 instruction(s), falls into the block at 0x0041f2c8
    movsx edx, word ptr [ebp - local_1438]       # 0041f2b3
    imul edx, edx, 0x29                          # 0041f2ba
    mov ax, word ptr [ebp - local_4]             # 0041f2bd
    mov word ptr [edx + 0x5b1432], ax            # 0041f2c1
L_0041f2c8:
    # block 0x0041f2c8: entered by jne at 0x0041f2b1, 5 instruction(s), falls into the block at 0x0041f2e7
    movsx ecx, word ptr [ebp - local_1438]       # 0041f2c8
    imul ecx, ecx, 0x29                          # 0041f2cf
    mov dx, word ptr [ebp - local_20]            # 0041f2d2
    mov word ptr [ecx + 0x5b1434], dx            # 0041f2d6
    mov dword ptr [ebp - local_141c], 0x0        # 0041f2dd
L_0041f2e7:
    # block 0x0041f2e7: entered by jmp at 0x0041f2a8, 1 instruction(s), ends with forward jump to 0x0041f40c
    jmp.d32 L_0041f40c                           # 0041f2e7
L_0041f2ec:
    # block 0x0041f2ec: entered by switch case, 40 instruction(s), calls FUN_004d3836, FUN_0041f5b1, ends with forward jump to 0x0041f40c
    movsx esi, word ptr [ebp - local_1420]       # 0041f2ec
    movsx eax, word ptr [ebp + arg_18]           # 0041f2f3
    imul eax, eax, 0x1d0                         # 0041f2f7
    add eax, 0x5adb3a                            # 0041f2fd
    push eax                                     # 0041f302
    movsx ecx, word ptr [ebp + arg_18]           # 0041f303
    imul ecx, ecx, 0x7f3                         # 0041f307
    add ecx, 0x5a4c24                            # 0041f30d
    push ecx                                     # 0041f313
    lea edx, [ebp - local_13e8]                  # 0041f314
    push edx                                     # 0041f31a
    call FUN_004d3836                            # 0041f31b
    add esp, 0xc                                 # 0041f320
    movsx eax, ax                                # 0041f323
    {load} sub esi, eax                          # 0041f326
    mov word ptr [ebp - local_4], si             # 0041f328
    mov ecx, dword ptr [ebp + arg_8]             # 0041f32c
    push ecx                                     # 0041f32f
    mov dx, word ptr [ebp - local_13f0]          # 0041f330
    push edx                                     # 0041f337
    lea eax, [ebp - local_4]                     # 0041f338
    push eax                                     # 0041f33b
    mov cx, word ptr [ebp - local_1420]          # 0041f33c
    push ecx                                     # 0041f343
    mov dx, word ptr [ebp - local_1424]          # 0041f344
    push edx                                     # 0041f34b
    lea eax, [ebp - local_20]                    # 0041f34c
    push eax                                     # 0041f34f
    lea ecx, [ebp - local_58]                    # 0041f350
    push ecx                                     # 0041f353
    mov dx, word ptr [ebp + arg_18]              # 0041f354
    push edx                                     # 0041f358
    lea eax, [ebp - local_13e8]                  # 0041f359
    push eax                                     # 0041f35f
    mov ecx, dword ptr [ebp - local_1440]        # 0041f360
    call FUN_0041f5b1                            # 0041f366
    mov cx, word ptr [0x5b0a36]                  # 0041f36b
    mov word ptr [ebp - local_4], cx             # 0041f372
    mov dword ptr [ebp - local_58], 0x1          # 0041f376
    jmp.d32 L_0041f40c                           # 0041f37d
L_0041f382:
    # block 0x0041f382: entered by switch case, 30 instruction(s), calls FUN_0050cb1b, ends with forward jump to 0x0041f40c
    mov dl, byte ptr [ebp - local_46]            # 0041f382
    mov byte ptr [ebp - local_c], dl             # 0041f385
    mov byte ptr [ebp - local_46], 0x0           # 0041f388
    lea eax, [ebp - local_48]                    # 0041f38c
    push eax                                     # 0041f38f
    call FUN_0050cb1b                            # 0041f390
    add esp, 0x4                                 # 0041f395
    mov word ptr [ebp - local_143c], ax          # 0041f398
    mov cl, byte ptr [ebp - local_c]             # 0041f39f
    mov byte ptr [ebp - local_46], cl            # 0041f3a2
    lea edx, [ebp - local_46]                    # 0041f3a5
    {load} mov edi, edx                          # 0041f3a8
    movsx eax, word ptr [ebp - local_143c]       # 0041f3aa
    imul eax, eax, 0x29                          # 0041f3b1
    add eax, 0x5b0a9a                            # 0041f3b4
    {load} mov edx, eax                          # 0041f3b9
    or ecx, -0x1                                 # 0041f3bb
    {load} xor eax, eax                          # 0041f3be
    repne scasb al, byte ptr es:[edi]            # 0041f3c0
    not ecx                                      # 0041f3c2
    {load} sub edi, ecx                          # 0041f3c4
    {load} mov esi, edi                          # 0041f3c6
    {load} mov eax, ecx                          # 0041f3c8
    {load} mov edi, edx                          # 0041f3ca
    shr ecx, 0x2                                 # 0041f3cc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041f3cf
    {load} mov ecx, eax                          # 0041f3d1
    and ecx, 0x3                                 # 0041f3d3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041f3d6
    jmp.d8 L_0041f40c                            # 0041f3d8
L_0041f3da:
    # block 0x0041f3da: entered by switch case, 20 instruction(s), falls into the block at 0x0041f40c
    lea edi, [ebp - local_1c]                    # 0041f3da
    lea edx, [ebp - local_13e8]                  # 0041f3dd
    or ecx, -0x1                                 # 0041f3e3
    {load} xor eax, eax                          # 0041f3e6
    repne scasb al, byte ptr es:[edi]            # 0041f3e8
    not ecx                                      # 0041f3ea
    {load} sub edi, ecx                          # 0041f3ec
    {load} mov esi, edi                          # 0041f3ee
    {load} mov ebx, ecx                          # 0041f3f0
    {load} mov edi, edx                          # 0041f3f2
    or ecx, -0x1                                 # 0041f3f4
    {load} xor eax, eax                          # 0041f3f7
    repne scasb al, byte ptr es:[edi]            # 0041f3f9
    add edi, -0x1                                # 0041f3fb
    {load} mov ecx, ebx                          # 0041f3fe
    shr ecx, 0x2                                 # 0041f400
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041f403
    {load} mov ecx, ebx                          # 0041f405
    and ecx, 0x3                                 # 0041f407
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041f40a
L_0041f40c:
    # block 0x0041f40c: entered by ja at 0x0041eaf2; jmp at 0x0041ebbc; jmp at 0x0041ed95; jmp at 0x0041ee02; more, 6 instruction(s), ends with forward jump to 0x0041f48b
    mov ecx, 0x6                                 # 0041f40c
    {load} xor eax, eax                          # 0041f411
    lea edi, [ebp - local_48]                    # 0041f413
    rep stosd dword ptr es:[edi], eax            # 0041f416
    stosb byte ptr es:[edi], al                  # 0041f418
    jmp.d8 L_0041f48b                            # 0041f419
L_0041f41b:
    # block 0x0041f41b: entered by jmp at 0x0041eaaa, 2 instruction(s), ends with je to 0x0041f441 (forward)
    cmp dword ptr [ebp - local_13fc], 0x0        # 0041f41b
    je.d8 L_0041f441                             # 0041f422
    # block 0x0041f424: entered by fall-through of je at 0x0041f422, 2 instruction(s), ends with jne to 0x0041f441 (forward)
    cmp dword ptr [ebp - local_13ec], 0x0        # 0041f424
    jne.d8 L_0041f441                            # 0041f42b
    # block 0x0041f42d: entered by fall-through of jne at 0x0041f42b, 5 instruction(s), ends with forward jump to 0x0041f48b
    mov eax, dword ptr [ebp - local_54]          # 0041f42d
    mov cl, byte ptr [eax]                       # 0041f430
    mov byte ptr [ebp - local_60], cl            # 0041f432
    mov dword ptr [ebp - local_13ec], 0x1        # 0041f435
    jmp.d8 L_0041f48b                            # 0041f43f
L_0041f441:
    # block 0x0041f441: entered by je at 0x0041f422; jne at 0x0041f42b, 2 instruction(s), ends with je to 0x0041f46d (forward)
    cmp dword ptr [ebp - local_13fc], 0x0        # 0041f441
    je.d8 L_0041f46d                             # 0041f448
    # block 0x0041f44a: entered by fall-through of je at 0x0041f448, 2 instruction(s), ends with je to 0x0041f46d (forward)
    cmp dword ptr [ebp - local_13ec], 0x0        # 0041f44a
    je.d8 L_0041f46d                             # 0041f451
    # block 0x0041f453: entered by fall-through of je at 0x0041f451, 10 instruction(s), ends with forward jump to 0x0041f48b
    lea edi, [ebp - local_48]                    # 0041f453
    or ecx, -0x1                                 # 0041f456
    {load} xor eax, eax                          # 0041f459
    repne scasb al, byte ptr es:[edi]            # 0041f45b
    not ecx                                      # 0041f45d
    add ecx, -0x1                                # 0041f45f
    mov edx, dword ptr [ebp - local_54]          # 0041f462
    mov al, byte ptr [edx]                       # 0041f465
    mov byte ptr [ebp + ecx - local_48], al      # 0041f467
    jmp.d8 L_0041f48b                            # 0041f46b
L_0041f46d:
    # block 0x0041f46d: entered by je at 0x0041f448; je at 0x0041f451, 9 instruction(s), falls into the block at 0x0041f48b
    lea edi, [ebp - local_13e8]                  # 0041f46d
    or ecx, -0x1                                 # 0041f473
    {load} xor eax, eax                          # 0041f476
    repne scasb al, byte ptr es:[edi]            # 0041f478
    not ecx                                      # 0041f47a
    add ecx, -0x1                                # 0041f47c
    mov edx, dword ptr [ebp - local_54]          # 0041f47f
    mov al, byte ptr [edx]                       # 0041f482
    mov byte ptr [ebp + ecx - local_13e8], al    # 0041f484
L_0041f48b:
    # block 0x0041f48b: entered by jmp at 0x0041eac3; jmp at 0x0041f419; jmp at 0x0041f43f; jmp at 0x0041f46b, 2 instruction(s), ends with je to 0x0041f493 (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 0041f48b
    je.d8 L_0041f493                             # 0041f48f
    # block 0x0041f491: entered by fall-through of je at 0x0041f48f, 1 instruction(s), ends with forward jump to 0x0041f498
    jmp.d8 L_0041f498                            # 0041f491
L_0041f493:
    # block 0x0041f493: entered by je at 0x0041f48f, 1 instruction(s), ends with backward jump to 0x0041ea6b
    jmp.d32 L_0041ea6b                           # 0041f493
L_0041f498:
    # block 0x0041f498: entered by jmp at 0x0041f491, 9 instruction(s), ends with jl to 0x0041f4d4 (forward)
    movsx ecx, word ptr [0x5b0a34]               # 0041f498
    imul ecx, ecx, 0x3                           # 0041f49f
    mov dx, word ptr [ebp - local_20]            # 0041f4a2
    {load} add dx, cx                            # 0041f4a6
    mov word ptr [ebp - local_20], dx            # 0041f4a9
    movsx eax, word ptr [ebp - local_20]         # 0041f4ad
    movsx ecx, word ptr [ebp - local_1424]       # 0041f4b1
    {load} cmp eax, ecx                          # 0041f4b8
    jl.d8 L_0041f4d4                             # 0041f4ba
    # block 0x0041f4bc: entered by fall-through of jl at 0x0041f4ba, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0041f4d4
    push 0x0                                     # 0041f4bc
    push 0x0                                     # 0041f4be
    push 0x5439ac                                # 0041f4c0
    call FUN_0052139c                            # 0041f4c5
    mov ecx, 0x5cf659                            # 0041f4ca
    call FUN_004c97b4                            # 0041f4cf
L_0041f4d4:
    # block 0x0041f4d4: entered by jl at 0x0041f4ba, 5 instruction(s), ends with jle to 0x0041f50e (forward)
    movsx edx, word ptr [ebp - local_20]         # 0041f4d4
    mov eax, dword ptr [0x5b0a26]                # 0041f4d8
    add eax, dword ptr [0x5b0a1e]                # 0041f4dd
    {load} cmp edx, eax                          # 0041f4e3
    jle.d8 L_0041f50e                            # 0041f4e5
    # block 0x0041f4e7: entered by fall-through of jle at 0x0041f4e5, 9 instruction(s), ends with forward jump to 0x0041f517
    movsx ecx, word ptr [ebp - local_20]         # 0041f4e7
    sub ecx, dword ptr [0x5b0a26]                # 0041f4eb
    add ecx, 0x1                                 # 0041f4f1
    mov edx, dword ptr [0x5b0a1e]                # 0041f4f4
    sub edx, dword ptr [0x5b0a16]                # 0041f4fa
    add edx, 0x1                                 # 0041f500
    {load} sub ecx, edx                          # 0041f503
    mov word ptr [0x5b0a7c], cx                  # 0041f505
    jmp.d8 L_0041f517                            # 0041f50c
L_0041f50e:
    # block 0x0041f50e: entered by jle at 0x0041f4e5, 1 instruction(s), falls into the block at 0x0041f517
    mov word ptr [0x5b0a7c], 0x1                 # 0041f50e
L_0041f517:
    # block 0x0041f517: entered by jmp at 0x0041f50c, 3 instruction(s), ends with jg to 0x0041f52b (forward)
    movsx eax, word ptr [0x5b0a7c]               # 0041f517
    test eax, eax                                # 0041f51e
    jg.d8 L_0041f52b                             # 0041f520
    # block 0x0041f522: entered by fall-through of jg at 0x0041f520, 1 instruction(s), falls into the block at 0x0041f52b
    mov word ptr [0x5b0a7c], 0x1                 # 0041f522
L_0041f52b:
    # block 0x0041f52b: entered by jg at 0x0041f520, 12 instruction(s), calls FUN_004ee673, FUN_004c92c5, FUN_0051eac4, falls into the block at 0x0041f563
    push 0x0                                     # 0041f52b
    mov ecx, 0x582711                            # 0041f52d
    call FUN_004ee673                            # 0041f532
    mov cx, word ptr [ebp + arg_18]              # 0041f537
    push ecx                                     # 0041f53b
    mov ecx, 0x5cf659                            # 0041f53c
    call FUN_004c92c5                            # 0041f541
    push -0x1                                    # 0041f546
    mov ecx, dword ptr [ebp - local_1440]        # 0041f548
    add ecx, 0xf1d                               # 0041f54e
    call FUN_0051eac4                            # 0041f554
    mov dword ptr [0x5b15d6], 0x1                # 0041f559
L_0041f563:
    # block 0x0041f563: entered by jmp at 0x0041e95d; jmp at 0x0041ea27, 6 instruction(s), ends with ret 0x14
    pop edi                                      # 0041f563
    pop esi                                      # 0041f564
    pop ebx                                      # 0041f565
    {load} mov esp, ebp                          # 0041f566
    pop ebp                                      # 0041f568
    ret 0x14                                     # 0041f569

# --- data items (not part of the function) -------------------------
.org 0x0041f56c - 0x401000
SWTAB_0041f56c:  # 12 case address(es)
    .long L_0041ed9a - .text + 0x401000
    .long L_0041ee07 - .text + 0x401000
    .long L_0041ee13 - .text + 0x401000
    .long L_0041ee85 - .text + 0x401000
    .long L_0041eb0d - .text + 0x401000
    .long L_0041f0cf - .text + 0x401000
    .long L_0041f14d - .text + 0x401000
    .long L_0041f2ec - .text + 0x401000
    .long L_0041f382 - .text + 0x401000
    .long L_0041f3da - .text + 0x401000
    .long L_0041ebc1 - .text + 0x401000
    .long L_0041f40c - .text + 0x401000
.org 0x0041f59c - 0x401000
IDXTAB_0041f59c:  # index table of FUN_0041e647 for the switch jump at 0x0041eb06 (21 byte(s))
    .byte 0, 11, 1, 2, 11, 3, 11, 11, 11, 4, 11, 5, 11, 6, 11, 7
    .byte 8, 9, 10, 11, 5
.set SWTAB_0041f56c_VA, SWTAB_0041f56c - .text + 0x401000
.set IDXTAB_0041f59c_VA, IDXTAB_0041f59c - .text + 0x401000

