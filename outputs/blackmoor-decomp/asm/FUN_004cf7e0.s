# FUN_004cf7e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf7e0
# extent:       0x004cf7e0-0x004cf9f4 (532 code bytes)
# span:         0x004cf7e0-0x004cf9f4 (code 532, tables 0, padding 0)
# sha256:       305a8904764eeb29bf509d489c30d29a6a4658a1e2bfc5261fb0e8c97593a052
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cf7e0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_58, local_5c, local_60, local_64
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_004c5377, FUN_004c5d4b, FUN_0052139c, FUN_004c97b4, FUN_004c4c2b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 154 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004c4c2b, .text + (0x004c4c2b - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004cf7e0 - 0x401000
.globl FUN_004cf7e0
FUN_004cf7e0:
    # block 0x004cf7e0: entry, 11 instruction(s), ends with forward jump to 0x004cf808
    push ebp                                     # 004cf7e0
    {load} mov ebp, esp                          # 004cf7e1
    sub esp, 0x64                                # 004cf7e3
    push edi                                     # 004cf7e6
    mov ecx, 0x16                                # 004cf7e7
    {load} xor eax, eax                          # 004cf7ec
    lea edi, [ebp - local_58]                    # 004cf7ee
    rep stosd dword ptr es:[edi], eax            # 004cf7f1
    movsx eax, word ptr [0x5bb1c4]               # 004cf7f3
    mov dword ptr [ebp - local_5c], eax          # 004cf7fa
    jmp.d8 L_004cf808                            # 004cf7fd
L_004cf7ff:
    # block 0x004cf7ff: entered by jmp at 0x004cf9e0, 3 instruction(s), falls into the block at 0x004cf808
    mov ecx, dword ptr [ebp - local_5c]          # 004cf7ff
    add ecx, 0x1                                 # 004cf802
    mov dword ptr [ebp - local_5c], ecx          # 004cf805
L_004cf808:
    # block 0x004cf808: entered by jmp at 0x004cf7fd, 2 instruction(s), ends with jge to 0x004cf9e5 (forward)
    cmp dword ptr [ebp - local_5c], 0x15         # 004cf808
    jge.d32 L_004cf9e5                           # 004cf80c
    # block 0x004cf812: entered by fall-through of jge at 0x004cf80c, 2 instruction(s), ends with forward jump to 0x004cf824
    mov dword ptr [ebp - local_60], 0x0          # 004cf812
    jmp.d8 L_004cf824                            # 004cf819
L_004cf81b:
    # block 0x004cf81b: entered by jmp at 0x004cf88f; jmp at 0x004cf9db, 3 instruction(s), falls into the block at 0x004cf824
    mov edx, dword ptr [ebp - local_60]          # 004cf81b
    add edx, 0x1                                 # 004cf81e
    mov dword ptr [ebp - local_60], edx          # 004cf821
L_004cf824:
    # block 0x004cf824: entered by jmp at 0x004cf819, 5 instruction(s), ends with je to 0x004cf9e0 (forward)
    mov eax, dword ptr [ebp - local_60]          # 004cf824
    mov ecx, dword ptr [ebp + arg_8]             # 004cf827
    movsx edx, word ptr [ecx + 2*eax]            # 004cf82a
    cmp edx, -0x1                                # 004cf82e
    je.d32 L_004cf9e0                            # 004cf831
    # block 0x004cf837: entered by fall-through of je at 0x004cf831, 7 instruction(s), ends with jne to 0x004cf88f (forward)
    mov eax, dword ptr [ebp - local_60]          # 004cf837
    mov ecx, dword ptr [ebp + arg_8]             # 004cf83a
    movsx edx, word ptr [ecx + 2*eax]            # 004cf83d
    {load} xor eax, eax                          # 004cf841
    mov al, byte ptr [ebp + edx - local_58]      # 004cf843
    test eax, eax                                # 004cf847
    jne.d8 L_004cf88f                            # 004cf849
    # block 0x004cf84b: entered by fall-through of jne at 0x004cf849, 6 instruction(s), ends with je to 0x004cf88f (forward)
    mov ecx, dword ptr [ebp - local_60]          # 004cf84b
    mov edx, dword ptr [ebp + arg_8]             # 004cf84e
    movsx eax, word ptr [edx + 2*ecx]            # 004cf851
    imul eax, eax, 0x4a                          # 004cf855
    cmp dword ptr [eax + 0x5d15a5], 0x0          # 004cf858
    je.d8 L_004cf88f                             # 004cf85f
    # block 0x004cf861: entered by fall-through of je at 0x004cf85f, 6 instruction(s), ends with je to 0x004cf88f (forward)
    mov ecx, dword ptr [ebp - local_60]          # 004cf861
    mov edx, dword ptr [ebp + arg_8]             # 004cf864
    movsx eax, word ptr [edx + 2*ecx]            # 004cf867
    imul eax, eax, 0x4a                          # 004cf86b
    cmp dword ptr [eax + 0x5d15a9], 0x0          # 004cf86e
    je.d8 L_004cf88f                             # 004cf875
    # block 0x004cf877: entered by fall-through of je at 0x004cf875, 7 instruction(s), ends with je to 0x004cf891 (forward)
    mov ecx, dword ptr [ebp - local_60]          # 004cf877
    mov edx, dword ptr [ebp + arg_8]             # 004cf87a
    movsx eax, word ptr [edx + 2*ecx]            # 004cf87d
    imul eax, eax, 0x4a                          # 004cf881
    mov ecx, dword ptr [eax + 0x5d1591]          # 004cf884
    cmp ecx, dword ptr [ebp - local_5c]          # 004cf88a
    je.d8 L_004cf891                             # 004cf88d
L_004cf88f:
    # block 0x004cf88f: entered by jne at 0x004cf849; je at 0x004cf85f; je at 0x004cf875; fall-through of je at 0x004cf88d, 1 instruction(s), ends with backward jump to 0x004cf81b
    jmp.d8 L_004cf81b                            # 004cf88f
L_004cf891:
    # block 0x004cf891: entered by je at 0x004cf88d, 6 instruction(s), ends with je to 0x004cf8c6 (forward)
    mov edx, dword ptr [ebp - local_60]          # 004cf891
    mov eax, dword ptr [ebp + arg_8]             # 004cf894
    movsx ecx, word ptr [eax + 2*edx]            # 004cf897
    imul ecx, ecx, 0x4a                          # 004cf89b
    cmp dword ptr [ecx + 0x5d1595], 0x0          # 004cf89e
    je.d8 L_004cf8c6                             # 004cf8a5
    # block 0x004cf8a7: entered by fall-through of je at 0x004cf8a5, 9 instruction(s), calls indirect dword ptr [edx + 0x5d1595], ends with forward jump to 0x004cf9cc
    mov edx, dword ptr [ebp - local_60]          # 004cf8a7
    push edx                                     # 004cf8aa
    mov eax, dword ptr [ebp - local_60]          # 004cf8ab
    mov ecx, dword ptr [ebp + arg_8]             # 004cf8ae
    movsx edx, word ptr [ecx + 2*eax]            # 004cf8b1
    imul edx, edx, 0x4a                          # 004cf8b5
    call dword ptr [edx + 0x5d1595]              # 004cf8b8
    add esp, 0x4                                 # 004cf8be
    jmp.d32 L_004cf9cc                           # 004cf8c1
L_004cf8c6:
    # block 0x004cf8c6: entered by je at 0x004cf8a5, 17 instruction(s), calls FUN_0050ca3e, ends with je to 0x004cf90d (forward)
    mov eax, dword ptr [ebp - local_60]          # 004cf8c6
    mov ecx, dword ptr [ebp + arg_8]             # 004cf8c9
    movsx edx, word ptr [ecx + 2*eax]            # 004cf8cc
    push edx                                     # 004cf8d0
    push 0x559dd0                                # 004cf8d1
    push 0x63888b                                # 004cf8d6
    call FUN_0050ca3e                            # 004cf8db
    add esp, 0xc                                 # 004cf8e0
    mov eax, dword ptr [ebp - local_60]          # 004cf8e3
    mov ecx, dword ptr [ebp + arg_8]             # 004cf8e6
    movsx edx, word ptr [ecx + 2*eax]            # 004cf8e9
    imul edx, edx, 0x4a                          # 004cf8ed
    {load} xor eax, eax                          # 004cf8f0
    mov ax, word ptr [edx + 0x5d15ad]            # 004cf8f2
    mov dword ptr [ebp - local_64], eax          # 004cf8f9
    cmp dword ptr [ebp - local_64], 0x1          # 004cf8fc
    je.d8 L_004cf90d                             # 004cf900
    # block 0x004cf902: entered by fall-through of je at 0x004cf900, 2 instruction(s), ends with je to 0x004cf960 (forward)
    cmp dword ptr [ebp - local_64], 0x2          # 004cf902
    je.d8 L_004cf960                             # 004cf906
    # block 0x004cf908: entered by fall-through of je at 0x004cf906, 1 instruction(s), ends with forward jump to 0x004cf9b4
    jmp.d32 L_004cf9b4                           # 004cf908
L_004cf90d:
    # block 0x004cf90d: entered by je at 0x004cf900, 24 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004cf9cc
    push 0x63888b                                # 004cf90d
    mov ecx, dword ptr [ebp - local_60]          # 004cf912
    mov edx, dword ptr [ebp + arg_8]             # 004cf915
    movsx eax, word ptr [edx + 2*ecx]            # 004cf918
    imul eax, eax, 0x4a                          # 004cf91c
    mov ecx, dword ptr [eax + 0x5d15a1]          # 004cf91f
    push ecx                                     # 004cf925
    mov edx, dword ptr [ebp - local_60]          # 004cf926
    mov eax, dword ptr [ebp + arg_8]             # 004cf929
    movsx ecx, word ptr [eax + 2*edx]            # 004cf92c
    imul ecx, ecx, 0x4a                          # 004cf930
    mov edx, dword ptr [ecx + 0x5d159d]          # 004cf933
    push edx                                     # 004cf939
    mov eax, dword ptr [0x5cf665]                # 004cf93a
    push eax                                     # 004cf93f
    mov ecx, dword ptr [ebp - local_60]          # 004cf940
    mov edx, dword ptr [ebp + arg_8]             # 004cf943
    movsx eax, word ptr [edx + 2*ecx]            # 004cf946
    imul eax, eax, 0x4a                          # 004cf94a
    mov ecx, dword ptr [eax + 0x5d1599]          # 004cf94d
    push ecx                                     # 004cf953
    mov ecx, 0x5cf659                            # 004cf954
    call FUN_004c5377                            # 004cf959
    jmp.d8 L_004cf9cc                            # 004cf95e
L_004cf960:
    # block 0x004cf960: entered by je at 0x004cf906, 24 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004cf9cc
    push 0x63888b                                # 004cf960
    mov edx, dword ptr [ebp - local_60]          # 004cf965
    mov eax, dword ptr [ebp + arg_8]             # 004cf968
    movsx ecx, word ptr [eax + 2*edx]            # 004cf96b
    imul ecx, ecx, 0x4a                          # 004cf96f
    mov edx, dword ptr [ecx + 0x5d15a1]          # 004cf972
    push edx                                     # 004cf978
    mov eax, dword ptr [ebp - local_60]          # 004cf979
    mov ecx, dword ptr [ebp + arg_8]             # 004cf97c
    movsx edx, word ptr [ecx + 2*eax]            # 004cf97f
    imul edx, edx, 0x4a                          # 004cf983
    mov eax, dword ptr [edx + 0x5d159d]          # 004cf986
    push eax                                     # 004cf98c
    mov ecx, dword ptr [0x5cf665]                # 004cf98d
    push ecx                                     # 004cf993
    mov edx, dword ptr [ebp - local_60]          # 004cf994
    mov eax, dword ptr [ebp + arg_8]             # 004cf997
    movsx ecx, word ptr [eax + 2*edx]            # 004cf99a
    imul ecx, ecx, 0x4a                          # 004cf99e
    mov edx, dword ptr [ecx + 0x5d1599]          # 004cf9a1
    push edx                                     # 004cf9a7
    mov ecx, 0x5cf659                            # 004cf9a8
    call FUN_004c5d4b                            # 004cf9ad
    jmp.d8 L_004cf9cc                            # 004cf9b2
L_004cf9b4:
    # block 0x004cf9b4: entered by jmp at 0x004cf908, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004cf9cc
    push 0x0                                     # 004cf9b4
    push 0x0                                     # 004cf9b6
    push 0x559df0                                # 004cf9b8
    call FUN_0052139c                            # 004cf9bd
    mov ecx, 0x5cf659                            # 004cf9c2
    call FUN_004c97b4                            # 004cf9c7
L_004cf9cc:
    # block 0x004cf9cc: entered by jmp at 0x004cf8c1; jmp at 0x004cf95e; jmp at 0x004cf9b2, 5 instruction(s), ends with backward jump to 0x004cf81b
    mov eax, dword ptr [ebp - local_60]          # 004cf9cc
    mov ecx, dword ptr [ebp + arg_8]             # 004cf9cf
    movsx edx, word ptr [ecx + 2*eax]            # 004cf9d2
    mov byte ptr [ebp + edx - local_58], 0x1     # 004cf9d6
    jmp.d32 L_004cf81b                           # 004cf9db
L_004cf9e0:
    # block 0x004cf9e0: entered by je at 0x004cf831, 1 instruction(s), ends with backward jump to 0x004cf7ff
    jmp.d32 L_004cf7ff                           # 004cf9e0
L_004cf9e5:
    # block 0x004cf9e5: entered by jge at 0x004cf80c, 6 instruction(s), calls FUN_004c4c2b, ends with ret
    mov ecx, 0x5cf659                            # 004cf9e5
    call FUN_004c4c2b                            # 004cf9ea
    pop edi                                      # 004cf9ef
    {load} mov esp, ebp                          # 004cf9f0
    pop ebp                                      # 004cf9f2
    ret                                          # 004cf9f3

