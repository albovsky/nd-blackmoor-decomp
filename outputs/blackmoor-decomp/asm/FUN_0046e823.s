# FUN_0046e823
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e823
# extent:       0x0046e823-0x0046e9c0 (413 code bytes)
# span:         0x0046e823-0x0046e9c0 (code 413, tables 0, padding 0)
# sha256:       93b86c54181647e395c1d6d30f56a126e73687b32688aea30f2fcd8e86d19a88
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046e823
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_91, field_f8f; [edx + n] field_91
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 122 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_91, 0x91  # offset +0x91
.equ field_f8f, 0xf8f  # offset +0xf8f

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0046e823 - 0x401000
.globl FUN_0046e823
FUN_0046e823:
    # block 0x0046e823: entry, 16 instruction(s), calls FUN_0051dc43, ends with jne to 0x0046e891 (forward)
    push ebp                                     # 0046e823
    {load} mov ebp, esp                          # 0046e824
    sub esp, 0x18                                # 0046e826
    push esi                                     # 0046e829
    push edi                                     # 0046e82a
    mov dword ptr [ebp - local_18], ecx          # 0046e82b
    mov dword ptr [ebp - local_c], 0x0           # 0046e82e
    push 0xf91                                   # 0046e835
    call FUN_0051dc43                            # 0046e83a
    add esp, 0x4                                 # 0046e83f
    mov dword ptr [ebp - local_10], eax          # 0046e842
    mov eax, dword ptr [ebp + arg_8]             # 0046e845
    mov ecx, dword ptr [ebp - local_10]          # 0046e848
    mov dword ptr [eax], ecx                     # 0046e84b
    cmp dword ptr [ebp - local_10], 0x0          # 0046e84d
    jne.d8 L_0046e891                            # 0046e851
    # block 0x0046e853: entered by fall-through of jne at 0x0046e851, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0046e891
    movsx edx, word ptr [0x5c39e3]               # 0046e853
    push edx                                     # 0046e85a
    mov eax, dword ptr [0x5bb57b]                # 0046e85b
    push eax                                     # 0046e860
    push 0x54c074                                # 0046e861
    push 0x63888b                                # 0046e866
    call FUN_0050ca3e                            # 0046e86b
    add esp, 0x10                                # 0046e870
    push 0x63888b                                # 0046e873
    push 0x54c0a0                                # 0046e878
    mov ecx, 0x583979                            # 0046e87d
    call FUN_0042639d                            # 0046e882
    mov ecx, 0x5cf659                            # 0046e887
    call FUN_004c97b4                            # 0046e88c
L_0046e891:
    # block 0x0046e891: entered by jne at 0x0046e851, 26 instruction(s), ends with jle to 0x0046e93f (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0046e891
    mov esi, dword ptr [ecx]                     # 0046e894
    mov edx, dword ptr [ebp + arg_8]             # 0046e896
    mov edi, dword ptr [edx]                     # 0046e899
    mov ecx, 0x3e4                               # 0046e89b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046e8a0
    movsb byte ptr es:[edi], byte ptr [esi]      # 0046e8a2
    mov eax, dword ptr [ebp + arg_8]             # 0046e8a3
    mov ecx, dword ptr [eax]                     # 0046e8a6
    mov dword ptr [ebp - local_4], ecx           # 0046e8a8
    mov edx, dword ptr [ebp + arg_10]            # 0046e8ab
    mov eax, dword ptr [edx]                     # 0046e8ae
    add eax, 0xf91                               # 0046e8b0
    mov ecx, dword ptr [ebp + arg_10]            # 0046e8b5
    mov dword ptr [ecx], eax                     # 0046e8b8
    mov edx, dword ptr [ebp + arg_c]             # 0046e8ba
    mov eax, dword ptr [edx]                     # 0046e8bd
    add eax, 0xf91                               # 0046e8bf
    mov ecx, dword ptr [ebp + arg_c]             # 0046e8c4
    mov dword ptr [ecx], eax                     # 0046e8c7
    mov edx, dword ptr [ebp + arg_8]             # 0046e8c9
    mov eax, dword ptr [edx]                     # 0046e8cc
    movsx ecx, word ptr [eax + field_f8f]        # 0046e8ce
    mov dword ptr [ebp - local_c], ecx           # 0046e8d5
    cmp dword ptr [ebp - local_c], 0x0           # 0046e8d8
    jle.d8 L_0046e93f                            # 0046e8dc
    # block 0x0046e8de: entered by fall-through of jle at 0x0046e8dc, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x0046e93f (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046e8de
    imul edx, edx, 0xa8                          # 0046e8e1
    push edx                                     # 0046e8e7
    call FUN_0051dc43                            # 0046e8e8
    add esp, 0x4                                 # 0046e8ed
    mov dword ptr [ebp - local_14], eax          # 0046e8f0
    mov eax, dword ptr [ebp - local_18]          # 0046e8f3
    mov ecx, dword ptr [ebp - local_14]          # 0046e8f6
    mov dword ptr [eax + field_91], ecx          # 0046e8f9
    cmp dword ptr [ebp - local_14], 0x0          # 0046e8ff
    jne.d8 L_0046e93f                            # 0046e903
    # block 0x0046e905: entered by fall-through of jne at 0x0046e903, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0046e93f
    mov edx, dword ptr [ebp - local_c]           # 0046e905
    push edx                                     # 0046e908
    mov eax, dword ptr [0x5bb57b]                # 0046e909
    push eax                                     # 0046e90e
    push 0x54c0bc                                # 0046e90f
    push 0x63888b                                # 0046e914
    call FUN_0050ca3e                            # 0046e919
    add esp, 0x10                                # 0046e91e
    push 0x63888b                                # 0046e921
    push 0x54c0f4                                # 0046e926
    mov ecx, 0x583979                            # 0046e92b
    call FUN_0042639d                            # 0046e930
    mov ecx, 0x5cf659                            # 0046e935
    call FUN_004c97b4                            # 0046e93a
L_0046e93f:
    # block 0x0046e93f: entered by jle at 0x0046e8dc; jne at 0x0046e903, 2 instruction(s), ends with forward jump to 0x0046e951
    mov dword ptr [ebp - local_8], 0x0           # 0046e93f
    jmp.d8 L_0046e951                            # 0046e946
L_0046e948:
    # block 0x0046e948: entered by jmp at 0x0046e989, 3 instruction(s), falls into the block at 0x0046e951
    mov ecx, dword ptr [ebp - local_8]           # 0046e948
    add ecx, 0x1                                 # 0046e94b
    mov dword ptr [ebp - local_8], ecx           # 0046e94e
L_0046e951:
    # block 0x0046e951: entered by jmp at 0x0046e946, 3 instruction(s), ends with jge to 0x0046e98b (forward)
    mov edx, dword ptr [ebp - local_8]           # 0046e951
    cmp edx, dword ptr [ebp - local_c]           # 0046e954
    jge.d8 L_0046e98b                            # 0046e957
    # block 0x0046e959: entered by fall-through of jge at 0x0046e957, 15 instruction(s), ends with backward jump to 0x0046e948
    mov eax, dword ptr [ebp + arg_c]             # 0046e959
    mov esi, dword ptr [eax]                     # 0046e95c
    mov ecx, dword ptr [ebp - local_8]           # 0046e95e
    imul ecx, ecx, 0xa8                          # 0046e961
    mov edx, dword ptr [ebp - local_18]          # 0046e967
    mov edi, dword ptr [edx + field_91]          # 0046e96a
    {load} add edi, ecx                          # 0046e970
    mov ecx, 0x2a                                # 0046e972
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046e977
    mov eax, dword ptr [ebp + arg_c]             # 0046e979
    mov ecx, dword ptr [eax]                     # 0046e97c
    add ecx, 0xa8                                # 0046e97e
    mov edx, dword ptr [ebp + arg_c]             # 0046e984
    mov dword ptr [edx], ecx                     # 0046e987
    jmp.d8 L_0046e948                            # 0046e989
L_0046e98b:
    # block 0x0046e98b: entered by jge at 0x0046e957, 10 instruction(s), ends with je to 0x0046e9b8 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046e98b
    imul eax, eax, 0xa8                          # 0046e98e
    mov ecx, dword ptr [ebp + arg_10]            # 0046e994
    mov edx, dword ptr [ecx]                     # 0046e997
    {load} add edx, eax                          # 0046e999
    mov eax, dword ptr [ebp + arg_10]            # 0046e99b
    mov dword ptr [eax], edx                     # 0046e99e
    movsx ecx, word ptr [0x63a4cd]               # 0046e9a0
    test ecx, ecx                                # 0046e9a7
    je.d8 L_0046e9b8                             # 0046e9a9
    # block 0x0046e9ab: entered by fall-through of je at 0x0046e9a9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0046e9b8
    push 0x54c110                                # 0046e9ab
    call FUN_0044a2b7                            # 0046e9b0
    add esp, 0x4                                 # 0046e9b5
L_0046e9b8:
    # block 0x0046e9b8: entered by je at 0x0046e9a9, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0046e9b8
    pop esi                                      # 0046e9b9
    {load} mov esp, ebp                          # 0046e9ba
    pop ebp                                      # 0046e9bc
    ret 0xc                                      # 0046e9bd

