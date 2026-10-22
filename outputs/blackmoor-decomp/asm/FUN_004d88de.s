# FUN_004d88de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d88de
# extent:       0x004d88de-0x004d8dca (1260 code bytes)
# span:         0x004d88de-0x004d8dca (code 1260, tables 0, padding 0)
# sha256:       f297e1fb2ce5f9b1b37939f464d619c2e665205fbd025bc1287f0505915c5d7d
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d88de
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_100, field_9556, field_980c, field_9810, field_989c, field_98a0, field_98a8, field_337ef, field_33907; [ecx + n] field_108, field_9556, field_980c, field_9810, field_989c, field_98a0, field_98a8, field_337fb, field_33907; [edi + n] field_minus_1; [edx + n] field_100, field_9556, field_9804, field_980c, field_989c, field_98a0, field_98a8, field_337ef, field_337fb, field_33907; [esi + n] field_9810
# callees:      calls FUN_004d8f0a, FUN_0050ca3e, FUN_0050cd72, FUN_0050e5cc, FUN_004d8fb6, FUN_0050e699, FUN_0050e761, FUN_004d9910, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_004d8dca, FUN_00427a40
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 327 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_100, 0x100  # offset +0x100
.equ field_108, 0x108  # offset +0x108
.equ field_9556, 0x9556  # offset +0x9556
.equ field_9804, 0x9804  # offset +0x9804
.equ field_980c, 0x980c  # offset +0x980c
.equ field_9810, 0x9810  # offset +0x9810
.equ field_989c, 0x989c  # offset +0x989c
.equ field_98a0, 0x98a0  # offset +0x98a0
.equ field_98a8, 0x98a8  # offset +0x98a8
.equ field_337ef, 0x337ef  # offset +0x337ef
.equ field_337fb, 0x337fb  # offset +0x337fb
.equ field_33907, 0x33907  # offset +0x33907

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d8dca, .text + (0x004d8dca - 0x401000)
.set FUN_004d8f0a, .text + (0x004d8f0a - 0x401000)
.set FUN_004d8fb6, .text + (0x004d8fb6 - 0x401000)
.set FUN_004d9910, .text + (0x004d9910 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050e5cc, .text + (0x0050e5cc - 0x401000)
.set FUN_0050e699, .text + (0x0050e699 - 0x401000)
.set FUN_0050e761, .text + (0x0050e761 - 0x401000)

.org 0x004d88de - 0x401000
.globl FUN_004d88de
FUN_004d88de:
    # block 0x004d88de: entry, 46 instruction(s), calls FUN_004d8f0a, FUN_0050ca3e, FUN_0050cd72, FUN_0050e5cc, ends with jne to 0x004d8983 (forward)
    push ebp                                     # 004d88de
    {load} mov ebp, esp                          # 004d88df
    sub esp, 0x18                                # 004d88e1
    push esi                                     # 004d88e4
    push edi                                     # 004d88e5
    mov dword ptr [ebp - local_c], ecx           # 004d88e6
    mov ecx, dword ptr [ebp - local_c]           # 004d88e9
    call FUN_004d8f0a                            # 004d88ec
    mov eax, dword ptr [ebp - local_c]           # 004d88f1
    add eax, 0x2af                               # 004d88f4
    push eax                                     # 004d88f9
    push 0x55a894                                # 004d88fa
    mov ecx, dword ptr [ebp - local_c]           # 004d88ff
    add ecx, 0x333e3                             # 004d8902
    push ecx                                     # 004d8908
    call FUN_0050ca3e                            # 004d8909
    add esp, 0xc                                 # 004d890e
    mov edx, dword ptr [ebp - local_c]           # 004d8911
    add edx, 0x333e3                             # 004d8914
    push edx                                     # 004d891a
    push 0x55a898                                # 004d891b
    push 0x63a3c9                                # 004d8920
    push 0x63a9b4                                # 004d8925
    mov eax, dword ptr [ebp - local_c]           # 004d892a
    add eax, 0x333e8                             # 004d892d
    push eax                                     # 004d8932
    call FUN_0050cd72                            # 004d8933
    add esp, 0x14                                # 004d8938
    mov ecx, 0x46                                # 004d893b
    {load} xor eax, eax                          # 004d8940
    mov edi, dword ptr [ebp - local_c]           # 004d8942
    add edi, 0x337ef                             # 004d8945
    rep stosd dword ptr es:[edi], eax            # 004d894b
    mov ecx, dword ptr [ebp - local_c]           # 004d894d
    add ecx, 0x337ef                             # 004d8950
    push ecx                                     # 004d8956
    mov edx, dword ptr [ebp - local_c]           # 004d8957
    add edx, 0x333e8                             # 004d895a
    push edx                                     # 004d8960
    call FUN_0050e5cc                            # 004d8961
    add esp, 0x8                                 # 004d8966
    mov ecx, dword ptr [ebp - local_c]           # 004d8969
    mov dword ptr [ecx + field_33907], eax       # 004d896c
    mov edx, dword ptr [ebp - local_c]           # 004d8972
    cmp dword ptr [edx + field_33907], -0x1      # 004d8975
    jne.d8 L_004d8983                            # 004d897c
    # block 0x004d897e: entered by fall-through of jne at 0x004d897c, 1 instruction(s), ends with forward jump to 0x004d8dc4
    jmp.d32 L_004d8dc4                           # 004d897e
L_004d8983:
    # block 0x004d8983: entered by jne at 0x004d897c, 5 instruction(s), ends with jne to 0x004d89af (forward)
    mov eax, dword ptr [ebp - local_c]           # 004d8983
    mov ecx, dword ptr [eax + field_337ef]       # 004d8986
    and ecx, 0x15                                # 004d898c
    test ecx, ecx                                # 004d898f
    jne.d8 L_004d89af                            # 004d8991
    # block 0x004d8993: entered by fall-through of jne at 0x004d8991, 8 instruction(s), calls FUN_004d8fb6, falls into the block at 0x004d89af
    mov edx, dword ptr [ebp - local_c]           # 004d8993
    mov eax, dword ptr [edx + field_337fb]       # 004d8996
    push eax                                     # 004d899c
    mov ecx, dword ptr [ebp - local_c]           # 004d899d
    add ecx, 0x33803                             # 004d89a0
    push ecx                                     # 004d89a6
    mov ecx, dword ptr [ebp - local_c]           # 004d89a7
    call FUN_004d8fb6                            # 004d89aa
L_004d89af:
    # block 0x004d89af: entered by jne at 0x004d8991; jmp at 0x004d89fa, 10 instruction(s), calls FUN_0050e699, ends with jne to 0x004d89fc (forward)
    mov edx, dword ptr [ebp - local_c]           # 004d89af
    add edx, 0x337ef                             # 004d89b2
    push edx                                     # 004d89b8
    mov eax, dword ptr [ebp - local_c]           # 004d89b9
    mov ecx, dword ptr [eax + field_33907]       # 004d89bc
    push ecx                                     # 004d89c2
    call FUN_0050e699                            # 004d89c3
    add esp, 0x8                                 # 004d89c8
    test eax, eax                                # 004d89cb
    jne.d8 L_004d89fc                            # 004d89cd
    # block 0x004d89cf: entered by fall-through of jne at 0x004d89cd, 5 instruction(s), ends with jne to 0x004d89fa (forward)
    mov edx, dword ptr [ebp - local_c]           # 004d89cf
    mov eax, dword ptr [edx + field_337ef]       # 004d89d2
    and eax, 0x15                                # 004d89d8
    test eax, eax                                # 004d89db
    jne.d8 L_004d89fa                            # 004d89dd
    # block 0x004d89df: entered by fall-through of jne at 0x004d89dd, 8 instruction(s), calls FUN_004d8fb6, falls into the block at 0x004d89fa
    mov ecx, dword ptr [ebp - local_c]           # 004d89df
    mov edx, dword ptr [ecx + field_337fb]       # 004d89e2
    push edx                                     # 004d89e8
    mov eax, dword ptr [ebp - local_c]           # 004d89e9
    add eax, 0x33803                             # 004d89ec
    push eax                                     # 004d89f1
    mov ecx, dword ptr [ebp - local_c]           # 004d89f2
    call FUN_004d8fb6                            # 004d89f5
L_004d89fa:
    # block 0x004d89fa: entered by jne at 0x004d89dd, 1 instruction(s), ends with backward jump to 0x004d89af
    jmp.d8 L_004d89af                            # 004d89fa
L_004d89fc:
    # block 0x004d89fc: entered by jne at 0x004d89cd, 8 instruction(s), calls FUN_0050e761, ends with jne to 0x004d8a1f (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004d89fc
    mov edx, dword ptr [ecx + field_33907]       # 004d89ff
    push edx                                     # 004d8a05
    call FUN_0050e761                            # 004d8a06
    add esp, 0x4                                 # 004d8a0b
    mov eax, dword ptr [ebp - local_c]           # 004d8a0e
    cmp dword ptr [eax + field_98a0], 0x0        # 004d8a11
    jne.d8 L_004d8a1f                            # 004d8a18
    # block 0x004d8a1a: entered by fall-through of jne at 0x004d8a18, 1 instruction(s), ends with forward jump to 0x004d8dc4
    jmp.d32 L_004d8dc4                           # 004d8a1a
L_004d8a1f:
    # block 0x004d8a1f: entered by jne at 0x004d8a18, 14 instruction(s), calls FUN_004d9910, falls into the block at 0x004d8a56
    mov ecx, dword ptr [ebp - local_c]           # 004d8a1f
    mov edx, dword ptr [ecx + field_98a0]        # 004d8a22
    shl edx, 0x2                                 # 004d8a28
    push edx                                     # 004d8a2b
    mov eax, dword ptr [ebp - local_c]           # 004d8a2c
    add eax, 0x980c                              # 004d8a2f
    push eax                                     # 004d8a34
    mov ecx, dword ptr [ebp - local_c]           # 004d8a35
    call FUN_004d9910                            # 004d8a38
    mov ecx, dword ptr [ebp - local_c]           # 004d8a3d
    mov dword ptr [ecx + field_98a8], 0x0        # 004d8a40
    mov edx, dword ptr [ebp - local_c]           # 004d8a4a
    mov eax, dword ptr [edx + field_9804]        # 004d8a4d
    mov dword ptr [ebp - local_4], eax           # 004d8a53
L_004d8a56:
    # block 0x004d8a56: entered by jmp at 0x004d8a95, 2 instruction(s), ends with je to 0x004d8a97 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004d8a56
    je.d8 L_004d8a97                             # 004d8a5a
    # block 0x004d8a5c: entered by fall-through of je at 0x004d8a5a, 15 instruction(s), ends with backward jump to 0x004d8a56
    mov ecx, dword ptr [ebp - local_c]           # 004d8a5c
    mov edx, dword ptr [ecx + field_98a8]        # 004d8a5f
    mov eax, dword ptr [ebp - local_c]           # 004d8a65
    mov ecx, dword ptr [eax + field_980c]        # 004d8a68
    mov eax, dword ptr [ebp - local_4]           # 004d8a6e
    mov dword ptr [ecx + 4*edx], eax             # 004d8a71
    mov ecx, dword ptr [ebp - local_c]           # 004d8a74
    mov edx, dword ptr [ecx + field_98a8]        # 004d8a77
    add edx, 0x1                                 # 004d8a7d
    mov eax, dword ptr [ebp - local_c]           # 004d8a80
    mov dword ptr [eax + field_98a8], edx        # 004d8a83
    mov ecx, dword ptr [ebp - local_4]           # 004d8a89
    mov edx, dword ptr [ecx + field_108]         # 004d8a8c
    mov dword ptr [ebp - local_4], edx           # 004d8a92
    jmp.d8 L_004d8a56                            # 004d8a95
L_004d8a97:
    # block 0x004d8a97: entered by je at 0x004d8a5a, 5 instruction(s), ends with je to 0x004d8b07 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004d8a97
    mov ecx, dword ptr [ebp - local_c]           # 004d8a9a
    mov edx, dword ptr [eax + field_98a8]        # 004d8a9d
    cmp edx, dword ptr [ecx + field_98a0]        # 004d8aa3
    je.d8 L_004d8b07                             # 004d8aa9
    # block 0x004d8aab: entered by fall-through of je at 0x004d8aa9, 16 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004d8af8 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004d8aab
    mov ecx, dword ptr [eax + field_98a0]        # 004d8aae
    push ecx                                     # 004d8ab4
    mov edx, dword ptr [ebp - local_c]           # 004d8ab5
    mov eax, dword ptr [edx + field_98a8]        # 004d8ab8
    push eax                                     # 004d8abe
    push 0x55a89c                                # 004d8abf
    push 0x63888b                                # 004d8ac4
    call FUN_0050ca3e                            # 004d8ac9
    add esp, 0x10                                # 004d8ace
    push 0x63888b                                # 004d8ad1
    mov ecx, 0x583979                            # 004d8ad6
    call FUN_004264e8                            # 004d8adb
    movsx ecx, word ptr [0x63a4cd]               # 004d8ae0
    test ecx, ecx                                # 004d8ae7
    je.d8 L_004d8af8                             # 004d8ae9
    # block 0x004d8aeb: entered by fall-through of je at 0x004d8ae9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004d8af8
    push 0x63888b                                # 004d8aeb
    call FUN_0044a2b7                            # 004d8af0
    add esp, 0x4                                 # 004d8af5
L_004d8af8:
    # block 0x004d8af8: entered by je at 0x004d8ae9, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004d8dc4
    mov ecx, 0x5cf659                            # 004d8af8
    call FUN_004c97b4                            # 004d8afd
    jmp.d32 L_004d8dc4                           # 004d8b02
L_004d8b07:
    # block 0x004d8b07: entered by je at 0x004d8aa9, 10 instruction(s), calls FUN_004d8dca, ends with je to 0x004d8c02 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004d8b07
    mov eax, dword ptr [edx + field_98a0]        # 004d8b0a
    sub eax, 0x1                                 # 004d8b10
    push eax                                     # 004d8b13
    push 0x0                                     # 004d8b14
    mov ecx, dword ptr [ebp - local_c]           # 004d8b16
    call FUN_004d8dca                            # 004d8b19
    movsx ecx, word ptr [0x63a4cd]               # 004d8b1e
    test ecx, ecx                                # 004d8b25
    je.d32 L_004d8c02                            # 004d8b27
    # block 0x004d8b2d: entered by fall-through of je at 0x004d8b27, 3 instruction(s), ends with forward jump to 0x004d8b51
    mov edx, dword ptr [ebp - local_c]           # 004d8b2d
    mov dword ptr [edx + field_98a8], 0x0        # 004d8b30
    jmp.d8 L_004d8b51                            # 004d8b3a
L_004d8b3c:
    # block 0x004d8b3c: entered by jmp at 0x004d8bfd, 5 instruction(s), falls into the block at 0x004d8b51
    mov eax, dword ptr [ebp - local_c]           # 004d8b3c
    mov ecx, dword ptr [eax + field_98a8]        # 004d8b3f
    add ecx, 0x1                                 # 004d8b45
    mov edx, dword ptr [ebp - local_c]           # 004d8b48
    mov dword ptr [edx + field_98a8], ecx        # 004d8b4b
L_004d8b51:
    # block 0x004d8b51: entered by jmp at 0x004d8b3a, 5 instruction(s), ends with jge to 0x004d8c02 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004d8b51
    mov ecx, dword ptr [ebp - local_c]           # 004d8b54
    mov edx, dword ptr [eax + field_98a8]        # 004d8b57
    cmp edx, dword ptr [ecx + field_98a0]        # 004d8b5d
    jge.d32 L_004d8c02                           # 004d8b63
    # block 0x004d8b69: entered by fall-through of jge at 0x004d8b63, 32 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004d8bed (forward)
    mov eax, dword ptr [ebp - local_c]           # 004d8b69
    mov ecx, dword ptr [eax + field_98a8]        # 004d8b6c
    mov edx, dword ptr [ebp - local_c]           # 004d8b72
    mov eax, dword ptr [edx + field_980c]        # 004d8b75
    mov ecx, dword ptr [eax + 4*ecx]             # 004d8b7b
    push ecx                                     # 004d8b7e
    mov edx, dword ptr [ebp - local_c]           # 004d8b7f
    mov eax, dword ptr [edx + field_98a8]        # 004d8b82
    mov ecx, dword ptr [ebp - local_c]           # 004d8b88
    mov edx, dword ptr [ecx + field_980c]        # 004d8b8b
    mov eax, dword ptr [edx + 4*eax]             # 004d8b91
    mov ecx, dword ptr [eax + field_100]         # 004d8b94
    push ecx                                     # 004d8b9a
    mov edx, dword ptr [ebp - local_c]           # 004d8b9b
    mov eax, dword ptr [edx + field_98a8]        # 004d8b9e
    push eax                                     # 004d8ba4
    push 0x55a91c                                # 004d8ba5
    push 0x63888b                                # 004d8baa
    call FUN_0050ca3e                            # 004d8baf
    add esp, 0x14                                # 004d8bb4
    push 0x63888b                                # 004d8bb7
    call FUN_0044a2b7                            # 004d8bbc
    add esp, 0x4                                 # 004d8bc1
    mov edi, 0x63888b                            # 004d8bc4
    or ecx, -0x1                                 # 004d8bc9
    {load} xor eax, eax                          # 004d8bcc
    repne scasb al, byte ptr es:[edi]            # 004d8bce
    mov cx, word ptr [0x55a95c]                  # 004d8bd0
    mov word ptr [edi - field_minus_1], cx       # 004d8bd7
    mov edx, 0x1                                 # 004d8bdb
    test edx, edx                                # 004d8be0
    je.d8 L_004d8bed                             # 004d8be2
    # block 0x004d8be4: entered by fall-through of je at 0x004d8be2, 2 instruction(s), ends with forward jump to 0x004d8bfd
    mov dword ptr [ebp - local_10], 0x0          # 004d8be4
    jmp.d8 L_004d8bfd                            # 004d8beb
L_004d8bed:
    # block 0x004d8bed: entered by je at 0x004d8be2, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x004d8bfd
    push 0x63888b                                # 004d8bed
    call FUN_00427a40                            # 004d8bf2
    add esp, 0x4                                 # 004d8bf7
    mov dword ptr [ebp - local_10], eax          # 004d8bfa
L_004d8bfd:
    # block 0x004d8bfd: entered by jmp at 0x004d8beb, 1 instruction(s), ends with backward jump to 0x004d8b3c
    jmp.d32 L_004d8b3c                           # 004d8bfd
L_004d8c02:
    # block 0x004d8c02: entered by je at 0x004d8b27; jge at 0x004d8b63, 3 instruction(s), ends with jle to 0x004d8c17 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004d8c02
    cmp dword ptr [eax + field_98a0], 0x23       # 004d8c05
    jle.d8 L_004d8c17                            # 004d8c0c
    # block 0x004d8c0e: entered by fall-through of jle at 0x004d8c0c, 2 instruction(s), ends with forward jump to 0x004d8c23
    mov dword ptr [ebp - local_14], 0x23         # 004d8c0e
    jmp.d8 L_004d8c23                            # 004d8c15
L_004d8c17:
    # block 0x004d8c17: entered by jle at 0x004d8c0c, 3 instruction(s), falls into the block at 0x004d8c23
    mov ecx, dword ptr [ebp - local_c]           # 004d8c17
    mov edx, dword ptr [ecx + field_98a0]        # 004d8c1a
    mov dword ptr [ebp - local_14], edx          # 004d8c20
L_004d8c23:
    # block 0x004d8c23: entered by jmp at 0x004d8c15, 6 instruction(s), ends with forward jump to 0x004d8c53
    mov eax, dword ptr [ebp - local_c]           # 004d8c23
    mov ecx, dword ptr [ebp - local_14]          # 004d8c26
    mov dword ptr [eax + field_989c], ecx        # 004d8c29
    mov edx, dword ptr [ebp - local_c]           # 004d8c2f
    mov dword ptr [edx + field_98a8], 0x0        # 004d8c32
    jmp.d8 L_004d8c53                            # 004d8c3c
L_004d8c3e:
    # block 0x004d8c3e: entered by jmp at 0x004d8c9b, 5 instruction(s), falls into the block at 0x004d8c53
    mov eax, dword ptr [ebp - local_c]           # 004d8c3e
    mov ecx, dword ptr [eax + field_98a8]        # 004d8c41
    add ecx, 0x1                                 # 004d8c47
    mov edx, dword ptr [ebp - local_c]           # 004d8c4a
    mov dword ptr [edx + field_98a8], ecx        # 004d8c4d
L_004d8c53:
    # block 0x004d8c53: entered by jmp at 0x004d8c3c, 5 instruction(s), ends with jge to 0x004d8c9d (forward)
    mov eax, dword ptr [ebp - local_c]           # 004d8c53
    mov ecx, dword ptr [ebp - local_c]           # 004d8c56
    mov edx, dword ptr [eax + field_98a8]        # 004d8c59
    cmp edx, dword ptr [ecx + field_989c]        # 004d8c5f
    jge.d8 L_004d8c9d                            # 004d8c65
    # block 0x004d8c67: entered by fall-through of jge at 0x004d8c65, 13 instruction(s), ends with backward jump to 0x004d8c3e
    mov eax, dword ptr [ebp - local_c]           # 004d8c67
    mov ecx, dword ptr [eax + field_98a0]        # 004d8c6a
    sub ecx, 0x1                                 # 004d8c70
    mov edx, dword ptr [ebp - local_c]           # 004d8c73
    sub ecx, dword ptr [edx + field_98a8]        # 004d8c76
    mov eax, dword ptr [ebp - local_c]           # 004d8c7c
    mov edx, dword ptr [eax + field_980c]        # 004d8c7f
    mov eax, dword ptr [ebp - local_c]           # 004d8c85
    mov eax, dword ptr [eax + field_98a8]        # 004d8c88
    mov esi, dword ptr [ebp - local_c]           # 004d8c8e
    mov ecx, dword ptr [edx + 4*ecx]             # 004d8c91
    mov dword ptr [esi + 4*eax + field_9810], ecx # 004d8c94
    jmp.d8 L_004d8c3e                            # 004d8c9b
L_004d8c9d:
    # block 0x004d8c9d: entered by jge at 0x004d8c65, 3 instruction(s), ends with je to 0x004d8d7c (forward)
    movsx edx, word ptr [0x63a4cd]               # 004d8c9d
    test edx, edx                                # 004d8ca4
    je.d32 L_004d8d7c                            # 004d8ca6
    # block 0x004d8cac: entered by fall-through of je at 0x004d8ca6, 3 instruction(s), ends with forward jump to 0x004d8cd0
    mov eax, dword ptr [ebp - local_c]           # 004d8cac
    mov dword ptr [eax + field_98a8], 0x0        # 004d8caf
    jmp.d8 L_004d8cd0                            # 004d8cb9
L_004d8cbb:
    # block 0x004d8cbb: entered by jmp at 0x004d8d77, 5 instruction(s), falls into the block at 0x004d8cd0
    mov ecx, dword ptr [ebp - local_c]           # 004d8cbb
    mov edx, dword ptr [ecx + field_98a8]        # 004d8cbe
    add edx, 0x1                                 # 004d8cc4
    mov eax, dword ptr [ebp - local_c]           # 004d8cc7
    mov dword ptr [eax + field_98a8], edx        # 004d8cca
L_004d8cd0:
    # block 0x004d8cd0: entered by jmp at 0x004d8cb9, 5 instruction(s), ends with jge to 0x004d8d7c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004d8cd0
    mov edx, dword ptr [ebp - local_c]           # 004d8cd3
    mov eax, dword ptr [ecx + field_98a8]        # 004d8cd6
    cmp eax, dword ptr [edx + field_989c]        # 004d8cdc
    jge.d32 L_004d8d7c                           # 004d8ce2
    # block 0x004d8ce8: entered by fall-through of jge at 0x004d8ce2, 30 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004d8d67 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004d8ce8
    mov edx, dword ptr [ecx + field_98a8]        # 004d8ceb
    mov eax, dword ptr [ebp - local_c]           # 004d8cf1
    mov ecx, dword ptr [eax + 4*edx + field_9810] # 004d8cf4
    push ecx                                     # 004d8cfb
    mov edx, dword ptr [ebp - local_c]           # 004d8cfc
    mov eax, dword ptr [edx + field_98a8]        # 004d8cff
    mov ecx, dword ptr [ebp - local_c]           # 004d8d05
    mov edx, dword ptr [ecx + 4*eax + field_9810] # 004d8d08
    mov eax, dword ptr [edx + field_100]         # 004d8d0f
    push eax                                     # 004d8d15
    mov ecx, dword ptr [ebp - local_c]           # 004d8d16
    mov edx, dword ptr [ecx + field_98a8]        # 004d8d19
    push edx                                     # 004d8d1f
    push 0x55a960                                # 004d8d20
    push 0x63888b                                # 004d8d25
    call FUN_0050ca3e                            # 004d8d2a
    add esp, 0x14                                # 004d8d2f
    push 0x63888b                                # 004d8d32
    call FUN_0044a2b7                            # 004d8d37
    add esp, 0x4                                 # 004d8d3c
    mov edi, 0x63888b                            # 004d8d3f
    or ecx, -0x1                                 # 004d8d44
    {load} xor eax, eax                          # 004d8d47
    repne scasb al, byte ptr es:[edi]            # 004d8d49
    mov ax, word ptr [0x55a9a4]                  # 004d8d4b
    mov word ptr [edi - field_minus_1], ax       # 004d8d51
    mov ecx, 0x1                                 # 004d8d55
    test ecx, ecx                                # 004d8d5a
    je.d8 L_004d8d67                             # 004d8d5c
    # block 0x004d8d5e: entered by fall-through of je at 0x004d8d5c, 2 instruction(s), ends with forward jump to 0x004d8d77
    mov dword ptr [ebp - local_18], 0x0          # 004d8d5e
    jmp.d8 L_004d8d77                            # 004d8d65
L_004d8d67:
    # block 0x004d8d67: entered by je at 0x004d8d5c, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x004d8d77
    push 0x63888b                                # 004d8d67
    call FUN_00427a40                            # 004d8d6c
    add esp, 0x4                                 # 004d8d71
    mov dword ptr [ebp - local_18], eax          # 004d8d74
L_004d8d77:
    # block 0x004d8d77: entered by jmp at 0x004d8d65, 1 instruction(s), ends with backward jump to 0x004d8cbb
    jmp.d32 L_004d8cbb                           # 004d8d77
L_004d8d7c:
    # block 0x004d8d7c: entered by je at 0x004d8ca6; jge at 0x004d8ce2, 8 instruction(s), falls into the block at 0x004d8d9e
    mov edx, dword ptr [ebp - local_c]           # 004d8d7c
    mov dword ptr [edx + field_9556], 0x0        # 004d8d7f
    mov eax, dword ptr [ebp - local_c]           # 004d8d89
    mov ecx, dword ptr [eax + field_989c]        # 004d8d8c
    mov dword ptr [ebp - local_8], ecx           # 004d8d92
    mov edx, dword ptr [ebp - local_8]           # 004d8d95
    sub edx, 0x8                                 # 004d8d98
    mov dword ptr [ebp - local_8], edx           # 004d8d9b
L_004d8d9e:
    # block 0x004d8d9e: entered by jmp at 0x004d8dc2, 2 instruction(s), ends with jle to 0x004d8dc4 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004d8d9e
    jle.d8 L_004d8dc4                            # 004d8da2
    # block 0x004d8da4: entered by fall-through of jle at 0x004d8da2, 9 instruction(s), ends with backward jump to 0x004d8d9e
    mov eax, dword ptr [ebp - local_8]           # 004d8da4
    sub eax, 0x9                                 # 004d8da7
    mov dword ptr [ebp - local_8], eax           # 004d8daa
    mov ecx, dword ptr [ebp - local_c]           # 004d8dad
    mov edx, dword ptr [ecx + field_9556]        # 004d8db0
    add edx, 0x1                                 # 004d8db6
    mov eax, dword ptr [ebp - local_c]           # 004d8db9
    mov dword ptr [eax + field_9556], edx        # 004d8dbc
    jmp.d8 L_004d8d9e                            # 004d8dc2
L_004d8dc4:
    # block 0x004d8dc4: entered by jmp at 0x004d897e; jmp at 0x004d8a1a; jmp at 0x004d8b02; jle at 0x004d8da2, 5 instruction(s), ends with ret
    pop edi                                      # 004d8dc4
    pop esi                                      # 004d8dc5
    {load} mov esp, ebp                          # 004d8dc6
    pop ebp                                      # 004d8dc8
    ret                                          # 004d8dc9

