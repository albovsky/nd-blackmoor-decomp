# FUN_0041f5b1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041f5b1
# extent:       0x0041f5b1-0x0041f986 (981 code bytes)
# span:         0x0041f5b1-0x0041f986 (code 981, tables 0, padding 0)
# sha256:       843f2d1c2e96c298f048749fd2396ca24580c90837bb9f9d02c4437bd99c1aae
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041f5b1
# arguments:    9 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28; ret 0x24 (callee pops 36 bytes); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_8, local_1390, local_1394, local_1398
# fields:       [eax + n] field_20dd; [ecx + n] field_20e1, field_20e7; [edx + n] field_20e3
# callees:      calls FUN_0050c920, FUN_0052139c, FUN_004c97b4, FUN_004d3836, FUN_004d270b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 249 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_1390, 0x1390  # offset -0x1390
.equ local_1394, 0x1394  # offset -0x1394
.equ local_1398, 0x1398  # offset -0x1398
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28
.equ field_20dd, 0x20dd  # offset +0x20dd
.equ field_20e1, 0x20e1  # offset +0x20e1
.equ field_20e3, 0x20e3  # offset +0x20e3
.equ field_20e7, 0x20e7  # offset +0x20e7

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d270b, .text + (0x004d270b - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0041f5b1 - 0x401000
.globl FUN_0041f5b1
FUN_0041f5b1:
    # block 0x0041f5b1: entry, 14 instruction(s), calls FUN_0050c920, falls into the block at 0x0041f5eb
    push ebp                                     # 0041f5b1
    {load} mov ebp, esp                          # 0041f5b2
    mov eax, 0x1398                              # 0041f5b4
    call FUN_0050c920                            # 0041f5b9
    push esi                                     # 0041f5be
    push edi                                     # 0041f5bf
    mov dword ptr [ebp - local_1398], ecx        # 0041f5c0
    mov dword ptr [ebp - local_4], 0x0           # 0041f5c6
    mov ecx, 0x4e2                               # 0041f5cd
    {load} xor eax, eax                          # 0041f5d2
    lea edi, [ebp - local_1390]                  # 0041f5d4
    rep stosd dword ptr es:[edi], eax            # 0041f5da
    mov word ptr [ebp - local_8], 0x0            # 0041f5dc
    mov word ptr [ebp - local_1394], 0x0         # 0041f5e2
L_0041f5eb:
    # block 0x0041f5eb: entered by jmp at 0x0041f96d, 3 instruction(s), ends with je to 0x0041f972 (forward)
    mov eax, 0x1                                 # 0041f5eb
    test eax, eax                                # 0041f5f0
    je.d32 L_0041f972                            # 0041f5f2
    # block 0x0041f5f8: entered by fall-through of je at 0x0041f5f2, 3 instruction(s), ends with je to 0x0041f700 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 0041f5f8
    cmp dword ptr [ecx], 0x0                     # 0041f5fb
    je.d32 L_0041f700                            # 0041f5fe
    # block 0x0041f604: entered by fall-through of je at 0x0041f5fe, 3 instruction(s), ends with je to 0x0041f635 (forward)
    mov edx, dword ptr [ebp - local_1398]        # 0041f604
    cmp dword ptr [edx + field_20e3], 0x0        # 0041f60a
    je.d8 L_0041f635                             # 0041f611
    # block 0x0041f613: entered by fall-through of je at 0x0041f611, 8 instruction(s), ends with forward jump to 0x0041f6d1
    movsx eax, word ptr [ebp + arg_c]            # 0041f613
    imul eax, eax, 0x1d0                         # 0041f617
    mov ecx, dword ptr [ebp + arg_14]            # 0041f61d
    mov dx, word ptr [ecx]                       # 0041f620
    add dx, word ptr [eax + 0x5adb3c]            # 0041f623
    mov eax, dword ptr [ebp + arg_14]            # 0041f62a
    mov word ptr [eax], dx                       # 0041f62d
    jmp.d32 L_0041f6d1                           # 0041f630
L_0041f635:
    # block 0x0041f635: entered by je at 0x0041f611, 3 instruction(s), ends with je to 0x0041f696 (forward)
    mov ecx, dword ptr [ebp - local_1398]        # 0041f635
    cmp dword ptr [ecx + field_20e7], 0x0        # 0041f63b
    je.d8 L_0041f696                             # 0041f642
    # block 0x0041f644: entered by fall-through of je at 0x0041f642, 21 instruction(s), ends with forward jump to 0x0041f6d1
    movsx edx, word ptr [ebp + arg_c]            # 0041f644
    imul edx, edx, 0x1d0                         # 0041f648
    movsx ecx, word ptr [edx + 0x5adb3c]         # 0041f64e
    movsx edx, word ptr [ebp + arg_c]            # 0041f655
    imul edx, edx, 0x1d0                         # 0041f659
    movsx eax, word ptr [edx + 0x5adb3c]         # 0041f65f
    cdq                                          # 0041f666
    mov esi, 0x9                                 # 0041f667
    idiv esi                                     # 0041f66c
    {load} add eax, ecx                          # 0041f66e
    cdq                                          # 0041f670
    {load} sub eax, edx                          # 0041f671
    sar eax                                      # 0041f673
    mov ecx, dword ptr [ebp + arg_14]            # 0041f675
    mov dx, word ptr [ecx]                       # 0041f678
    {load} add dx, ax                            # 0041f67b
    mov eax, dword ptr [ebp + arg_14]            # 0041f67e
    mov word ptr [eax], dx                       # 0041f681
    mov ecx, dword ptr [ebp - local_1398]        # 0041f684
    mov dword ptr [ecx + field_20e7], 0x0        # 0041f68a
    jmp.d8 L_0041f6d1                            # 0041f694
L_0041f696:
    # block 0x0041f696: entered by je at 0x0041f642, 15 instruction(s), falls into the block at 0x0041f6d1
    movsx edx, word ptr [ebp + arg_c]            # 0041f696
    imul edx, edx, 0x1d0                         # 0041f69a
    movsx ecx, word ptr [edx + 0x5adb3c]         # 0041f6a0
    movsx edx, word ptr [ebp + arg_c]            # 0041f6a7
    imul edx, edx, 0x1d0                         # 0041f6ab
    movsx eax, word ptr [edx + 0x5adb3c]         # 0041f6b1
    cdq                                          # 0041f6b8
    mov esi, 0x9                                 # 0041f6b9
    idiv esi                                     # 0041f6be
    {load} add ecx, eax                          # 0041f6c0
    mov eax, dword ptr [ebp + arg_14]            # 0041f6c2
    mov dx, word ptr [eax]                       # 0041f6c5
    {load} add dx, cx                            # 0041f6c8
    mov eax, dword ptr [ebp + arg_14]            # 0041f6cb
    mov word ptr [eax], dx                       # 0041f6ce
L_0041f6d1:
    # block 0x0041f6d1: entered by jmp at 0x0041f630; jmp at 0x0041f694, 5 instruction(s), ends with jl to 0x0041f6f7 (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 0041f6d1
    movsx edx, word ptr [ecx]                    # 0041f6d4
    movsx eax, word ptr [ebp + arg_18]           # 0041f6d7
    {load} cmp edx, eax                          # 0041f6db
    jl.d8 L_0041f6f7                             # 0041f6dd
    # block 0x0041f6df: entered by fall-through of jl at 0x0041f6dd, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0041f6f7
    push 0x0                                     # 0041f6df
    push 0x0                                     # 0041f6e1
    push 0x543a08                                # 0041f6e3
    call FUN_0052139c                            # 0041f6e8
    mov ecx, 0x5cf659                            # 0041f6ed
    call FUN_004c97b4                            # 0041f6f2
L_0041f6f7:
    # block 0x0041f6f7: entered by jl at 0x0041f6dd, 2 instruction(s), falls into the block at 0x0041f700
    mov ecx, dword ptr [ebp + arg_10]            # 0041f6f7
    mov dword ptr [ecx], 0x0                     # 0041f6fa
L_0041f700:
    # block 0x0041f700: entered by je at 0x0041f5fe, 8 instruction(s), ends with jne to 0x0041f718 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0041f700
    or ecx, -0x1                                 # 0041f703
    {load} xor eax, eax                          # 0041f706
    repne scasb al, byte ptr es:[edi]            # 0041f708
    not ecx                                      # 0041f70a
    add ecx, -0x1                                # 0041f70c
    test ecx, ecx                                # 0041f70f
    jne.d8 L_0041f718                            # 0041f711
    # block 0x0041f713: entered by fall-through of jne at 0x0041f711, 1 instruction(s), ends with forward jump to 0x0041f972
    jmp.d32 L_0041f972                           # 0041f713
L_0041f718:
    # block 0x0041f718: entered by jne at 0x0041f711; jmp at 0x0041f7a0, 19 instruction(s), calls FUN_004d3836, ends with jge to 0x0041f7a5 (forward)
    mov edx, dword ptr [ebp + arg_20]            # 0041f718
    movsx esi, word ptr [edx]                    # 0041f71b
    movsx eax, word ptr [ebp + arg_c]            # 0041f71e
    imul eax, eax, 0x1d0                         # 0041f722
    add eax, 0x5adb3a                            # 0041f728
    push eax                                     # 0041f72d
    movsx ecx, word ptr [ebp + arg_c]            # 0041f72e
    imul ecx, ecx, 0x7f3                         # 0041f732
    add ecx, 0x5a4c24                            # 0041f738
    push ecx                                     # 0041f73e
    lea edx, [ebp - local_1390]                  # 0041f73f
    push edx                                     # 0041f745
    call FUN_004d3836                            # 0041f746
    add esp, 0xc                                 # 0041f74b
    movsx eax, ax                                # 0041f74e
    {load} add esi, eax                          # 0041f751
    movsx ecx, word ptr [ebp + arg_1c]           # 0041f753
    {load} cmp esi, ecx                          # 0041f757
    jge.d8 L_0041f7a5                            # 0041f759
    # block 0x0041f75b: entered by fall-through of jge at 0x0041f759, 5 instruction(s), ends with je to 0x0041f7a5 (forward)
    movsx edx, word ptr [ebp - local_8]          # 0041f75b
    mov eax, dword ptr [ebp + arg_8]             # 0041f75f
    movsx ecx, byte ptr [eax + edx]              # 0041f762
    test ecx, ecx                                # 0041f766
    je.d8 L_0041f7a5                             # 0041f768
    # block 0x0041f76a: entered by fall-through of je at 0x0041f768, 12 instruction(s), ends with backward jump to 0x0041f718
    movsx edx, word ptr [ebp - local_8]          # 0041f76a
    movsx eax, word ptr [ebp - local_1394]       # 0041f76e
    mov ecx, dword ptr [ebp + arg_8]             # 0041f775
    mov dl, byte ptr [ecx + edx]                 # 0041f778
    mov byte ptr [ebp + eax - local_1390], dl    # 0041f77b
    mov ax, word ptr [ebp - local_1394]          # 0041f782
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041f789
    mov word ptr [ebp - local_1394], ax          # 0041f78d
    mov cx, word ptr [ebp - local_8]             # 0041f794
    add cx, 0x1                                  # 0041f798
    mov word ptr [ebp - local_8], cx             # 0041f79c
    jmp.d32 L_0041f718                           # 0041f7a0
L_0041f7a5:
    # block 0x0041f7a5: entered by jge at 0x0041f759; je at 0x0041f768, 5 instruction(s), ends with je to 0x0041f858 (forward)
    movsx edx, word ptr [ebp - local_8]          # 0041f7a5
    mov eax, dword ptr [ebp + arg_8]             # 0041f7a9
    movsx ecx, byte ptr [eax + edx]              # 0041f7ac
    test ecx, ecx                                # 0041f7b0
    je.d32 L_0041f858                            # 0041f7b2
    # block 0x0041f7b8: entered by fall-through of je at 0x0041f7b2, 8 instruction(s), falls into the block at 0x0041f7e5
    mov dx, word ptr [ebp - local_1394]          # 0041f7b8
    sub dx, 0x1                                  # 0041f7bf
    mov word ptr [ebp - local_1394], dx          # 0041f7c3
    mov ax, word ptr [ebp - local_8]             # 0041f7ca
    .insn 0x66, 0x2d, 0x0001{:u16}               # 0041f7ce
    mov word ptr [ebp - local_8], ax             # 0041f7d2
    movsx ecx, word ptr [ebp - local_1394]       # 0041f7d6
    mov byte ptr [ebp + ecx - local_1390], 0x0   # 0041f7dd
L_0041f7e5:
    # block 0x0041f7e5: entered by jmp at 0x0041f822, 4 instruction(s), ends with je to 0x0041f824 (forward)
    movsx edx, word ptr [ebp - local_1394]       # 0041f7e5
    movsx eax, byte ptr [ebp + edx - local_1390] # 0041f7ec
    cmp eax, 0x20                                # 0041f7f4
    je.d8 L_0041f824                             # 0041f7f7
    # block 0x0041f7f9: entered by fall-through of je at 0x0041f7f7, 3 instruction(s), ends with jl to 0x0041f824 (forward)
    movsx ecx, word ptr [ebp - local_1394]       # 0041f7f9
    test ecx, ecx                                # 0041f800
    jl.d8 L_0041f824                             # 0041f802
    # block 0x0041f804: entered by fall-through of jl at 0x0041f802, 7 instruction(s), ends with backward jump to 0x0041f7e5
    mov dx, word ptr [ebp - local_1394]          # 0041f804
    sub dx, 0x1                                  # 0041f80b
    mov word ptr [ebp - local_1394], dx          # 0041f80f
    mov ax, word ptr [ebp - local_8]             # 0041f816
    .insn 0x66, 0x2d, 0x0001{:u16}               # 0041f81a
    mov word ptr [ebp - local_8], ax             # 0041f81e
    jmp.d8 L_0041f7e5                            # 0041f822
L_0041f824:
    # block 0x0041f824: entered by je at 0x0041f7f7; jl at 0x0041f802, 9 instruction(s), falls into the block at 0x0041f858
    mov cx, word ptr [ebp - local_1394]          # 0041f824
    add cx, 0x1                                  # 0041f82b
    mov word ptr [ebp - local_1394], cx          # 0041f82f
    mov dx, word ptr [ebp - local_8]             # 0041f836
    add dx, 0x1                                  # 0041f83a
    mov word ptr [ebp - local_8], dx             # 0041f83e
    movsx eax, word ptr [ebp - local_1394]       # 0041f842
    mov byte ptr [ebp + eax - local_1390], 0x0   # 0041f849
    mov dword ptr [ebp - local_4], 0x1           # 0041f851
L_0041f858:
    # block 0x0041f858: entered by je at 0x0041f7b2, 8 instruction(s), ends with jbe to 0x0041f921 (forward)
    lea edi, [ebp - local_1390]                  # 0041f858
    or ecx, -0x1                                 # 0041f85e
    {load} xor eax, eax                          # 0041f861
    repne scasb al, byte ptr es:[edi]            # 0041f863
    not ecx                                      # 0041f865
    add ecx, -0x1                                # 0041f867
    test ecx, ecx                                # 0041f86a
    jbe.d32 L_0041f921                           # 0041f86c
    # block 0x0041f872: entered by fall-through of jbe at 0x0041f86c, 48 instruction(s), calls FUN_004d270b, FUN_004d3836, falls into the block at 0x0041f921
    mov ecx, dword ptr [ebp - local_1398]        # 0041f872
    mov dx, word ptr [ecx + field_20e1]          # 0041f878
    push edx                                     # 0041f87f
    mov eax, dword ptr [ebp - local_1398]        # 0041f880
    mov ecx, dword ptr [eax + field_20dd]        # 0041f886
    push ecx                                     # 0041f88c
    mov dx, word ptr [ebp + arg_24]              # 0041f88d
    push edx                                     # 0041f891
    mov eax, dword ptr [ebp + arg_28]            # 0041f892
    push eax                                     # 0041f895
    movsx ecx, word ptr [ebp + arg_c]            # 0041f896
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 0041f89a
    push edx                                     # 0041f8a1
    mov eax, dword ptr [ebp + arg_14]            # 0041f8a2
    mov cx, word ptr [eax]                       # 0041f8a5
    push ecx                                     # 0041f8a8
    mov edx, dword ptr [ebp + arg_20]            # 0041f8a9
    mov ax, word ptr [edx]                       # 0041f8ac
    push eax                                     # 0041f8af
    movsx ecx, word ptr [ebp + arg_c]            # 0041f8b0
    imul ecx, ecx, 0x1d0                         # 0041f8b4
    add ecx, 0x5adb3a                            # 0041f8ba
    push ecx                                     # 0041f8c0
    movsx edx, word ptr [ebp + arg_c]            # 0041f8c1
    imul edx, edx, 0x7f3                         # 0041f8c5
    add edx, 0x5a4c24                            # 0041f8cb
    push edx                                     # 0041f8d1
    lea eax, [ebp - local_1390]                  # 0041f8d2
    push eax                                     # 0041f8d8
    call FUN_004d270b                            # 0041f8d9
    add esp, 0x28                                # 0041f8de
    movsx ecx, word ptr [ebp + arg_c]            # 0041f8e1
    imul ecx, ecx, 0x1d0                         # 0041f8e5
    add ecx, 0x5adb3a                            # 0041f8eb
    push ecx                                     # 0041f8f1
    movsx edx, word ptr [ebp + arg_c]            # 0041f8f2
    imul edx, edx, 0x7f3                         # 0041f8f6
    add edx, 0x5a4c24                            # 0041f8fc
    push edx                                     # 0041f902
    lea eax, [ebp - local_1390]                  # 0041f903
    push eax                                     # 0041f909
    call FUN_004d3836                            # 0041f90a
    add esp, 0xc                                 # 0041f90f
    mov ecx, dword ptr [ebp + arg_20]            # 0041f912
    mov dx, word ptr [ecx]                       # 0041f915
    {load} add dx, ax                            # 0041f918
    mov eax, dword ptr [ebp + arg_20]            # 0041f91b
    mov word ptr [eax], dx                       # 0041f91e
L_0041f921:
    # block 0x0041f921: entered by jbe at 0x0041f86c, 2 instruction(s), ends with je to 0x0041f944 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0041f921
    je.d8 L_0041f944                             # 0041f925
    # block 0x0041f927: entered by fall-through of je at 0x0041f925, 6 instruction(s), falls into the block at 0x0041f944
    mov dword ptr [ebp - local_4], 0x0           # 0041f927
    mov ecx, dword ptr [ebp + arg_20]            # 0041f92e
    mov dx, word ptr [0x5b0a36]                  # 0041f931
    mov word ptr [ecx], dx                       # 0041f938
    mov eax, dword ptr [ebp + arg_10]            # 0041f93b
    mov dword ptr [eax], 0x1                     # 0041f93e
L_0041f944:
    # block 0x0041f944: entered by je at 0x0041f925, 10 instruction(s), ends with jne to 0x0041f96d (forward)
    mov ecx, 0x4e2                               # 0041f944
    {load} xor eax, eax                          # 0041f949
    lea edi, [ebp - local_1390]                  # 0041f94b
    rep stosd dword ptr es:[edi], eax            # 0041f951
    mov word ptr [ebp - local_1394], 0x0         # 0041f953
    movsx ecx, word ptr [ebp - local_8]          # 0041f95c
    mov edx, dword ptr [ebp + arg_8]             # 0041f960
    movsx eax, byte ptr [edx + ecx]              # 0041f963
    test eax, eax                                # 0041f967
    jne.d8 L_0041f96d                            # 0041f969
    # block 0x0041f96b: entered by fall-through of jne at 0x0041f969, 1 instruction(s), ends with forward jump to 0x0041f972
    jmp.d8 L_0041f972                            # 0041f96b
L_0041f96d:
    # block 0x0041f96d: entered by jne at 0x0041f969, 1 instruction(s), ends with backward jump to 0x0041f5eb
    jmp.d32 L_0041f5eb                           # 0041f96d
L_0041f972:
    # block 0x0041f972: entered by je at 0x0041f5f2; jmp at 0x0041f713; jmp at 0x0041f96b, 9 instruction(s), ends with ret 0x24
    mov ecx, 0x4e2                               # 0041f972
    {load} xor eax, eax                          # 0041f977
    mov edi, dword ptr [ebp + arg_8]             # 0041f979
    rep stosd dword ptr es:[edi], eax            # 0041f97c
    pop edi                                      # 0041f97e
    pop esi                                      # 0041f97f
    {load} mov esp, ebp                          # 0041f980
    pop ebp                                      # 0041f982
    ret 0x24                                     # 0041f983

