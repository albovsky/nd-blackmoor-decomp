# FUN_004d1898
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d1898
# extent:       0x004d1898-0x004d214b (2227 code bytes)
# span:         0x004d1898-0x004d214b (code 2227, tables 0, padding 0)
# sha256:       40507896051bee0f7caf857cc81c628c7b644197b23bf2bf9cb9094a4392e0a6
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d1898
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       27 ebp-relative slot(s): local_10, local_20, local_24, local_28, local_2c, local_30, local_34, local_38, local_3c, local_40, local_44, local_48 and 15 more
# fields:       [eax + n] field_4, field_8, field_c
# callees:      calls FUN_004c5377, FUN_00493a47, FUN_0050ca3e, FUN_004d2c20, FUN_004939e6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 578 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
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
.equ local_58, 0x58  # offset -0x58
.equ local_bc, 0xbc  # offset -0xbc
.equ local_c0, 0xc0  # offset -0xc0
.equ local_c4, 0xc4  # offset -0xc4
.equ local_c8, 0xc8  # offset -0xc8
.equ local_d8, 0xd8  # offset -0xd8
.equ local_dc, 0xdc  # offset -0xdc
.equ local_e0, 0xe0  # offset -0xe0
.equ local_e4, 0xe4  # offset -0xe4
.equ local_e8, 0xe8  # offset -0xe8
.equ local_ec, 0xec  # offset -0xec
.equ local_f0, 0xf0  # offset -0xf0
.equ local_f4, 0xf4  # offset -0xf4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004939e6, .text + (0x004939e6 - 0x401000)
.set FUN_00493a47, .text + (0x00493a47 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004d1898 - 0x401000
.globl FUN_004d1898
FUN_004d1898:
    # block 0x004d1898: entry, 27 instruction(s), ends with jne to 0x004d18fe (forward)
    push ebp                                     # 004d1898
    {load} mov ebp, esp                          # 004d1899
    sub esp, 0xf4                                # 004d189b
    push esi                                     # 004d18a1
    push edi                                     # 004d18a2
    {load} xor eax, eax                          # 004d18a3
    mov dword ptr [ebp - local_30], eax          # 004d18a5
    mov dword ptr [ebp - local_2c], eax          # 004d18a8
    mov dword ptr [ebp - local_28], eax          # 004d18ab
    mov dword ptr [ebp - local_24], eax          # 004d18ae
    {load} xor ecx, ecx                          # 004d18b1
    mov dword ptr [ebp - local_40], ecx          # 004d18b3
    mov dword ptr [ebp - local_3c], ecx          # 004d18b6
    mov dword ptr [ebp - local_38], ecx          # 004d18b9
    mov dword ptr [ebp - local_34], ecx          # 004d18bc
    {load} xor edx, edx                          # 004d18bf
    mov dword ptr [ebp - local_50], edx          # 004d18c1
    mov dword ptr [ebp - local_4c], edx          # 004d18c4
    mov dword ptr [ebp - local_48], edx          # 004d18c7
    mov dword ptr [ebp - local_44], edx          # 004d18ca
    mov ax, word ptr [0x5b026e]                  # 004d18cd
    mov word ptr [ebp - local_c4], ax            # 004d18d3
    mov cx, word ptr [0x5b0270]                  # 004d18da
    mov word ptr [ebp - local_c0], cx            # 004d18e1
    movsx edx, word ptr [0x5b0266]               # 004d18e8
    cmp dword ptr [4*edx + 0x5d032f], 0x0        # 004d18ef
    jne.d8 L_004d18fe                            # 004d18f7
    # block 0x004d18f9: entered by fall-through of jne at 0x004d18f7, 1 instruction(s), ends with forward jump to 0x004d2145
    jmp.d32 L_004d2145                           # 004d18f9
L_004d18fe:
    # block 0x004d18fe: entered by jne at 0x004d18f7, 2 instruction(s), ends with je to 0x004d193f (forward)
    cmp dword ptr [0x5bb1f2], 0x0                # 004d18fe
    je.d8 L_004d193f                             # 004d1905
    # block 0x004d1907: entered by fall-through of je at 0x004d1905, 2 instruction(s), ends with jne to 0x004d193f (forward)
    cmp dword ptr [0x583981], 0xe                # 004d1907
    jne.d8 L_004d193f                            # 004d190e
    # block 0x004d1910: entered by fall-through of jne at 0x004d190e, 2 instruction(s), ends with jne to 0x004d193f (forward)
    cmp dword ptr [0x583999], 0x3                # 004d1910
    jne.d8 L_004d193f                            # 004d1917
    # block 0x004d1919: entered by fall-through of jne at 0x004d1917, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004d193f
    push 0x55a184                                # 004d1919
    push 0x5bb1ea                                # 004d191e
    push 0x5bb1ea                                # 004d1923
    mov eax, dword ptr [0x5cf665]                # 004d1928
    push eax                                     # 004d192d
    mov ecx, dword ptr [0x570c57]                # 004d192e
    push ecx                                     # 004d1934
    mov ecx, 0x5cf659                            # 004d1935
    call FUN_004c5377                            # 004d193a
L_004d193f:
    # block 0x004d193f: entered by je at 0x004d1905; jne at 0x004d190e; jne at 0x004d1917, 12 instruction(s), calls FUN_00493a47, ends with je to 0x004d1bf1 (forward)
    movsx edx, word ptr [ebp - local_c4]         # 004d193f
    mov dword ptr [0x5bb1ea], edx                # 004d1946
    movsx eax, word ptr [ebp - local_c0]         # 004d194c
    movsx ecx, word ptr [0x5b0266]               # 004d1953
    imul ecx, ecx, 0x1d0                         # 004d195a
    movsx edx, word ptr [ecx + 0x5adb3c]         # 004d1960
    {load} sub eax, edx                          # 004d1967
    mov dword ptr [0x5bb1ee], eax                # 004d1969
    mov ecx, 0x630a9a                            # 004d196e
    call FUN_00493a47                            # 004d1973
    test eax, eax                                # 004d1978
    je.d32 L_004d1bf1                            # 004d197a
    # block 0x004d1980: entered by fall-through of je at 0x004d197a, 58 instruction(s), calls FUN_0050ca3e, FUN_004d2c20, ends with je to 0x004d1a96 (forward)
    mov eax, dword ptr [0x6329a5]                # 004d1980
    push eax                                     # 004d1985
    mov ecx, dword ptr [0x6329a1]                # 004d1986
    push ecx                                     # 004d198c
    mov edx, dword ptr [0x63299d]                # 004d198d
    push edx                                     # 004d1993
    mov eax, dword ptr [0x632999]                # 004d1994
    push eax                                     # 004d1999
    mov ecx, dword ptr [0x632995]                # 004d199a
    push ecx                                     # 004d19a0
    mov edx, dword ptr [0x632991]                # 004d19a1
    push edx                                     # 004d19a7
    push 0x55a190                                # 004d19a8
    lea eax, [ebp - local_bc]                    # 004d19ad
    push eax                                     # 004d19b3
    call FUN_0050ca3e                            # 004d19b4
    add esp, 0x20                                # 004d19b9
    push 0x0                                     # 004d19bc
    mov ecx, dword ptr [0x5cf665]                # 004d19be
    push ecx                                     # 004d19c4
    movsx edx, word ptr [0x5b0266]               # 004d19c5
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004d19cc
    push eax                                     # 004d19d3
    mov cx, word ptr [ebp - local_c0]            # 004d19d4
    push ecx                                     # 004d19db
    mov dx, word ptr [ebp - local_c4]            # 004d19dc
    push edx                                     # 004d19e3
    movsx eax, word ptr [0x5b0266]               # 004d19e4
    imul eax, eax, 0x1d0                         # 004d19eb
    add eax, 0x5adb3a                            # 004d19f1
    push eax                                     # 004d19f6
    movsx ecx, word ptr [0x5b0266]               # 004d19f7
    imul ecx, ecx, 0x7f3                         # 004d19fe
    add ecx, 0x5a4c24                            # 004d1a04
    push ecx                                     # 004d1a0a
    lea edx, [ebp - local_bc]                    # 004d1a0b
    push edx                                     # 004d1a11
    call FUN_004d2c20                            # 004d1a12
    add esp, 0x20                                # 004d1a17
    mov ecx, dword ptr [eax]                     # 004d1a1a
    mov dword ptr [ebp - local_30], ecx          # 004d1a1c
    mov edx, dword ptr [eax + field_4]           # 004d1a1f
    mov dword ptr [ebp - local_2c], edx          # 004d1a22
    mov ecx, dword ptr [eax + field_8]           # 004d1a25
    mov dword ptr [ebp - local_28], ecx          # 004d1a28
    mov edx, dword ptr [eax + field_c]           # 004d1a2b
    mov dword ptr [ebp - local_24], edx          # 004d1a2e
    mov ax, word ptr [0x5b026e]                  # 004d1a31
    mov word ptr [ebp - local_c4], ax            # 004d1a37
    movsx ecx, word ptr [0x5b0266]               # 004d1a3e
    imul ecx, ecx, 0x1d0                         # 004d1a45
    movsx edx, word ptr [ecx + 0x5adb3c]         # 004d1a4b
    add edx, 0x3                                 # 004d1a52
    mov ax, word ptr [ebp - local_c0]            # 004d1a55
    {load} add ax, dx                            # 004d1a5c
    mov word ptr [ebp - local_c0], ax            # 004d1a5f
    cmp dword ptr [0x6329dd], 0x0                # 004d1a66
    je.d8 L_004d1a96                             # 004d1a6d
    # block 0x004d1a6f: entered by fall-through of je at 0x004d1a6d, 16 instruction(s), ends with forward jump to 0x004d1a9a
    mov edi, 0x55a1c8                            # 004d1a6f
    lea edx, [ebp - local_58]                    # 004d1a74
    or ecx, -0x1                                 # 004d1a77
    {load} xor eax, eax                          # 004d1a7a
    repne scasb al, byte ptr es:[edi]            # 004d1a7c
    not ecx                                      # 004d1a7e
    {load} sub edi, ecx                          # 004d1a80
    {load} mov esi, edi                          # 004d1a82
    {load} mov eax, ecx                          # 004d1a84
    {load} mov edi, edx                          # 004d1a86
    shr ecx, 0x2                                 # 004d1a88
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d1a8b
    {load} mov ecx, eax                          # 004d1a8d
    and ecx, 0x3                                 # 004d1a8f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d1a92
    jmp.d8 L_004d1a9a                            # 004d1a94
L_004d1a96:
    # block 0x004d1a96: entered by je at 0x004d1a6d, 1 instruction(s), falls into the block at 0x004d1a9a
    mov byte ptr [ebp - local_58], 0x0           # 004d1a96
L_004d1a9a:
    # block 0x004d1a9a: entered by jmp at 0x004d1a94, 62 instruction(s), calls FUN_004939e6, FUN_0050ca3e, FUN_004d2c20, ends with jle to 0x004d1ba6 (forward)
    lea ecx, [ebp - local_58]                    # 004d1a9a
    push ecx                                     # 004d1a9d
    fld dword ptr [0x6329c5]                     # 004d1a9e
    sub esp, 0x8                                 # 004d1aa4
    fstp qword ptr [esp]                         # 004d1aa7
    fld dword ptr [0x5c3a4b]                     # 004d1aaa
    sub esp, 0x8                                 # 004d1ab0
    fstp qword ptr [esp]                         # 004d1ab3
    mov ecx, 0x630a9a                            # 004d1ab6
    call FUN_004939e6                            # 004d1abb
    push eax                                     # 004d1ac0
    mov edx, dword ptr [0x63298d]                # 004d1ac1
    push edx                                     # 004d1ac7
    push 0x55a1d0                                # 004d1ac8
    lea eax, [ebp - local_bc]                    # 004d1acd
    push eax                                     # 004d1ad3
    call FUN_0050ca3e                            # 004d1ad4
    add esp, 0x24                                # 004d1ad9
    push 0x0                                     # 004d1adc
    mov ecx, dword ptr [0x5cf665]                # 004d1ade
    push ecx                                     # 004d1ae4
    movsx edx, word ptr [0x5b0266]               # 004d1ae5
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004d1aec
    push eax                                     # 004d1af3
    mov cx, word ptr [ebp - local_c0]            # 004d1af4
    push ecx                                     # 004d1afb
    mov dx, word ptr [ebp - local_c4]            # 004d1afc
    push edx                                     # 004d1b03
    movsx eax, word ptr [0x5b0266]               # 004d1b04
    imul eax, eax, 0x1d0                         # 004d1b0b
    add eax, 0x5adb3a                            # 004d1b11
    push eax                                     # 004d1b16
    movsx ecx, word ptr [0x5b0266]               # 004d1b17
    imul ecx, ecx, 0x7f3                         # 004d1b1e
    add ecx, 0x5a4c24                            # 004d1b24
    push ecx                                     # 004d1b2a
    lea edx, [ebp - local_bc]                    # 004d1b2b
    push edx                                     # 004d1b31
    call FUN_004d2c20                            # 004d1b32
    add esp, 0x20                                # 004d1b37
    mov ecx, dword ptr [eax]                     # 004d1b3a
    mov dword ptr [ebp - local_40], ecx          # 004d1b3c
    mov edx, dword ptr [eax + field_4]           # 004d1b3f
    mov dword ptr [ebp - local_3c], edx          # 004d1b42
    mov ecx, dword ptr [eax + field_8]           # 004d1b45
    mov dword ptr [ebp - local_38], ecx          # 004d1b48
    mov edx, dword ptr [eax + field_c]           # 004d1b4b
    mov dword ptr [ebp - local_34], edx          # 004d1b4e
    mov ax, word ptr [0x5b026e]                  # 004d1b51
    mov word ptr [ebp - local_c4], ax            # 004d1b57
    movsx ecx, word ptr [0x5b0266]               # 004d1b5e
    imul ecx, ecx, 0x1d0                         # 004d1b65
    movsx edx, word ptr [ecx + 0x5adb3c]         # 004d1b6b
    add edx, 0x3                                 # 004d1b72
    mov ax, word ptr [ebp - local_c0]            # 004d1b75
    {load} add ax, dx                            # 004d1b7c
    mov word ptr [ebp - local_c0], ax            # 004d1b7f
    movsx ecx, word ptr [ebp - local_c0]         # 004d1b86
    mov dword ptr [0x5bb1f6], ecx                # 004d1b8d
    mov edx, dword ptr [ebp - local_28]          # 004d1b93
    cmp edx, dword ptr [ebp - local_38]          # 004d1b96
    jle.d8 L_004d1ba6                            # 004d1b99
    # block 0x004d1b9b: entered by fall-through of jle at 0x004d1b99, 3 instruction(s), ends with forward jump to 0x004d1baf
    mov eax, dword ptr [ebp - local_28]          # 004d1b9b
    mov dword ptr [ebp - local_dc], eax          # 004d1b9e
    jmp.d8 L_004d1baf                            # 004d1ba4
L_004d1ba6:
    # block 0x004d1ba6: entered by jle at 0x004d1b99, 2 instruction(s), falls into the block at 0x004d1baf
    mov ecx, dword ptr [ebp - local_38]          # 004d1ba6
    mov dword ptr [ebp - local_dc], ecx          # 004d1ba9
L_004d1baf:
    # block 0x004d1baf: entered by jmp at 0x004d1ba4, 5 instruction(s), ends with jle to 0x004d1bd8 (forward)
    mov dx, word ptr [ebp - local_dc]            # 004d1baf
    mov word ptr [ebp - local_c8], dx            # 004d1bb6
    movsx eax, word ptr [ebp - local_c8]         # 004d1bbd
    cmp eax, dword ptr [ebp - local_48]          # 004d1bc4
    jle.d8 L_004d1bd8                            # 004d1bc7
    # block 0x004d1bc9: entered by fall-through of jle at 0x004d1bc7, 3 instruction(s), ends with forward jump to 0x004d1be1
    movsx ecx, word ptr [ebp - local_c8]         # 004d1bc9
    mov dword ptr [ebp - local_e0], ecx          # 004d1bd0
    jmp.d8 L_004d1be1                            # 004d1bd6
L_004d1bd8:
    # block 0x004d1bd8: entered by jle at 0x004d1bc7, 2 instruction(s), falls into the block at 0x004d1be1
    mov edx, dword ptr [ebp - local_48]          # 004d1bd8
    mov dword ptr [ebp - local_e0], edx          # 004d1bdb
L_004d1be1:
    # block 0x004d1be1: entered by jmp at 0x004d1bd6, 3 instruction(s), ends with forward jump to 0x004d2145
    mov eax, dword ptr [ebp - local_e0]          # 004d1be1
    mov dword ptr [0x5bb1f2], eax                # 004d1be7
    jmp.d32 L_004d2145                           # 004d1bec
L_004d1bf1:
    # block 0x004d1bf1: entered by je at 0x004d197a, 73 instruction(s), calls FUN_0050ca3e, FUN_004d2c20, ends with je to 0x004d1dec (forward)
    mov ecx, dword ptr [0x5c3a63]                # 004d1bf1
    imul ecx, ecx, 0x106                         # 004d1bf7
    movsx edx, word ptr [ecx + 0x585d6d]         # 004d1bfd
    push edx                                     # 004d1c04
    mov eax, dword ptr [0x5c3a63]                # 004d1c05
    imul eax, eax, 0x106                         # 004d1c0a
    movsx ecx, word ptr [eax + 0x585d71]         # 004d1c10
    push ecx                                     # 004d1c17
    mov edx, dword ptr [0x5c3a63]                # 004d1c18
    imul edx, edx, 0x106                         # 004d1c1e
    movsx eax, word ptr [edx + 0x585d75]         # 004d1c24
    push eax                                     # 004d1c2b
    mov ecx, dword ptr [0x5c3a63]                # 004d1c2c
    push ecx                                     # 004d1c32
    fld dword ptr [0x5c3a4b]                     # 004d1c33
    sub esp, 0x8                                 # 004d1c39
    fstp qword ptr [esp]                         # 004d1c3c
    movsx edx, word ptr [0x5c3a51]               # 004d1c3f
    push edx                                     # 004d1c46
    movsx eax, word ptr [0x5c3a4f]               # 004d1c47
    push eax                                     # 004d1c4e
    movsx ecx, word ptr [0x585d3b]               # 004d1c4f
    push ecx                                     # 004d1c56
    movsx edx, word ptr [0x585d3d]               # 004d1c57
    push edx                                     # 004d1c5e
    movsx eax, word ptr [0x585d3f]               # 004d1c5f
    push eax                                     # 004d1c66
    push 0x55a1fc                                # 004d1c67
    lea ecx, [ebp - local_bc]                    # 004d1c6c
    push ecx                                     # 004d1c72
    call FUN_0050ca3e                            # 004d1c73
    add esp, 0x34                                # 004d1c78
    push 0x0                                     # 004d1c7b
    mov edx, dword ptr [0x5cf665]                # 004d1c7d
    push edx                                     # 004d1c83
    movsx eax, word ptr [0x5b0266]               # 004d1c84
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 004d1c8b
    push ecx                                     # 004d1c92
    mov dx, word ptr [ebp - local_c0]            # 004d1c93
    push edx                                     # 004d1c9a
    mov ax, word ptr [ebp - local_c4]            # 004d1c9b
    push eax                                     # 004d1ca2
    movsx ecx, word ptr [0x5b0266]               # 004d1ca3
    imul ecx, ecx, 0x1d0                         # 004d1caa
    add ecx, 0x5adb3a                            # 004d1cb0
    push ecx                                     # 004d1cb6
    movsx edx, word ptr [0x5b0266]               # 004d1cb7
    imul edx, edx, 0x7f3                         # 004d1cbe
    add edx, 0x5a4c24                            # 004d1cc4
    push edx                                     # 004d1cca
    lea eax, [ebp - local_bc]                    # 004d1ccb
    push eax                                     # 004d1cd1
    call FUN_004d2c20                            # 004d1cd2
    add esp, 0x20                                # 004d1cd7
    mov ecx, dword ptr [eax]                     # 004d1cda
    mov dword ptr [ebp - local_30], ecx          # 004d1cdc
    mov edx, dword ptr [eax + field_4]           # 004d1cdf
    mov dword ptr [ebp - local_2c], edx          # 004d1ce2
    mov ecx, dword ptr [eax + field_8]           # 004d1ce5
    mov dword ptr [ebp - local_28], ecx          # 004d1ce8
    mov edx, dword ptr [eax + field_c]           # 004d1ceb
    mov dword ptr [ebp - local_24], edx          # 004d1cee
    mov ax, word ptr [0x5b026e]                  # 004d1cf1
    mov word ptr [ebp - local_c4], ax            # 004d1cf7
    movsx ecx, word ptr [0x5b0266]               # 004d1cfe
    imul ecx, ecx, 0x1d0                         # 004d1d05
    movsx edx, word ptr [ecx + 0x5adb3c]         # 004d1d0b
    add edx, 0x3                                 # 004d1d12
    mov ax, word ptr [ebp - local_c0]            # 004d1d15
    {load} add ax, dx                            # 004d1d1c
    mov word ptr [ebp - local_c0], ax            # 004d1d1f
    cmp dword ptr [0x5c39e9], 0x0                # 004d1d26
    je.d32 L_004d1dec                            # 004d1d2d
    # block 0x004d1d33: entered by fall-through of je at 0x004d1d2d, 47 instruction(s), calls FUN_0050ca3e, FUN_004d2c20, ends with forward jump to 0x004d1e99
    push 0x617f45                                # 004d1d33
    mov ecx, dword ptr [0x5c3a57]                # 004d1d38
    push ecx                                     # 004d1d3e
    mov edx, dword ptr [0x5c3a53]                # 004d1d3f
    push edx                                     # 004d1d45
    movsx eax, word ptr [0x585d45]               # 004d1d46
    push eax                                     # 004d1d4d
    movsx ecx, word ptr [0x585d47]               # 004d1d4e
    push ecx                                     # 004d1d55
    movsx edx, word ptr [0x585d49]               # 004d1d56
    push edx                                     # 004d1d5d
    push 0x55a23c                                # 004d1d5e
    lea eax, [ebp - local_bc]                    # 004d1d63
    push eax                                     # 004d1d69
    call FUN_0050ca3e                            # 004d1d6a
    add esp, 0x20                                # 004d1d6f
    push 0x0                                     # 004d1d72
    mov ecx, dword ptr [0x5cf665]                # 004d1d74
    push ecx                                     # 004d1d7a
    movsx edx, word ptr [0x5b0266]               # 004d1d7b
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004d1d82
    push eax                                     # 004d1d89
    mov cx, word ptr [ebp - local_c0]            # 004d1d8a
    push ecx                                     # 004d1d91
    mov dx, word ptr [ebp - local_c4]            # 004d1d92
    push edx                                     # 004d1d99
    movsx eax, word ptr [0x5b0266]               # 004d1d9a
    imul eax, eax, 0x1d0                         # 004d1da1
    add eax, 0x5adb3a                            # 004d1da7
    push eax                                     # 004d1dac
    movsx ecx, word ptr [0x5b0266]               # 004d1dad
    imul ecx, ecx, 0x7f3                         # 004d1db4
    add ecx, 0x5a4c24                            # 004d1dba
    push ecx                                     # 004d1dc0
    lea edx, [ebp - local_bc]                    # 004d1dc1
    push edx                                     # 004d1dc7
    call FUN_004d2c20                            # 004d1dc8
    add esp, 0x20                                # 004d1dcd
    mov ecx, dword ptr [eax]                     # 004d1dd0
    mov dword ptr [ebp - local_40], ecx          # 004d1dd2
    mov edx, dword ptr [eax + field_4]           # 004d1dd5
    mov dword ptr [ebp - local_3c], edx          # 004d1dd8
    mov ecx, dword ptr [eax + field_8]           # 004d1ddb
    mov dword ptr [ebp - local_38], ecx          # 004d1dde
    mov edx, dword ptr [eax + field_c]           # 004d1de1
    mov dword ptr [ebp - local_34], edx          # 004d1de4
    jmp.d32 L_004d1e99                           # 004d1de7
L_004d1dec:
    # block 0x004d1dec: entered by je at 0x004d1d2d, 45 instruction(s), calls FUN_0050ca3e, FUN_004d2c20, falls into the block at 0x004d1e99
    mov eax, dword ptr [0x5c3a57]                # 004d1dec
    push eax                                     # 004d1df1
    mov ecx, dword ptr [0x5c3a53]                # 004d1df2
    push ecx                                     # 004d1df8
    movsx edx, word ptr [0x585d45]               # 004d1df9
    push edx                                     # 004d1e00
    movsx eax, word ptr [0x585d47]               # 004d1e01
    push eax                                     # 004d1e08
    movsx ecx, word ptr [0x585d49]               # 004d1e09
    push ecx                                     # 004d1e10
    push 0x55a26c                                # 004d1e11
    lea edx, [ebp - local_bc]                    # 004d1e16
    push edx                                     # 004d1e1c
    call FUN_0050ca3e                            # 004d1e1d
    add esp, 0x1c                                # 004d1e22
    push 0x0                                     # 004d1e25
    mov eax, dword ptr [0x5cf665]                # 004d1e27
    push eax                                     # 004d1e2c
    movsx ecx, word ptr [0x5b0266]               # 004d1e2d
    mov edx, dword ptr [4*ecx + 0x5d032f]        # 004d1e34
    push edx                                     # 004d1e3b
    mov ax, word ptr [ebp - local_c0]            # 004d1e3c
    push eax                                     # 004d1e43
    mov cx, word ptr [ebp - local_c4]            # 004d1e44
    push ecx                                     # 004d1e4b
    movsx edx, word ptr [0x5b0266]               # 004d1e4c
    imul edx, edx, 0x1d0                         # 004d1e53
    add edx, 0x5adb3a                            # 004d1e59
    push edx                                     # 004d1e5f
    movsx eax, word ptr [0x5b0266]               # 004d1e60
    imul eax, eax, 0x7f3                         # 004d1e67
    add eax, 0x5a4c24                            # 004d1e6d
    push eax                                     # 004d1e72
    lea ecx, [ebp - local_bc]                    # 004d1e73
    push ecx                                     # 004d1e79
    call FUN_004d2c20                            # 004d1e7a
    add esp, 0x20                                # 004d1e7f
    mov edx, dword ptr [eax]                     # 004d1e82
    mov dword ptr [ebp - local_40], edx          # 004d1e84
    mov ecx, dword ptr [eax + field_4]           # 004d1e87
    mov dword ptr [ebp - local_3c], ecx          # 004d1e8a
    mov edx, dword ptr [eax + field_8]           # 004d1e8d
    mov dword ptr [ebp - local_38], edx          # 004d1e90
    mov eax, dword ptr [eax + field_c]           # 004d1e93
    mov dword ptr [ebp - local_34], eax          # 004d1e96
L_004d1e99:
    # block 0x004d1e99: entered by jmp at 0x004d1de7, 13 instruction(s), ends with je to 0x004d1ef0 (forward)
    mov cx, word ptr [0x5b026e]                  # 004d1e99
    mov word ptr [ebp - local_c4], cx            # 004d1ea0
    movsx edx, word ptr [0x5b0266]               # 004d1ea7
    imul edx, edx, 0x1d0                         # 004d1eae
    movsx eax, word ptr [edx + 0x5adb3c]         # 004d1eb4
    add eax, 0x3                                 # 004d1ebb
    mov cx, word ptr [ebp - local_c0]            # 004d1ebe
    {load} add cx, ax                            # 004d1ec5
    mov word ptr [ebp - local_c0], cx            # 004d1ec8
    movsx edx, word ptr [0x5bb20a]               # 004d1ecf
    mov dword ptr [ebp - local_e4], edx          # 004d1ed6
    cmp dword ptr [ebp - local_e4], 0x0          # 004d1edc
    je.d8 L_004d1ef0                             # 004d1ee3
    # block 0x004d1ee5: entered by fall-through of je at 0x004d1ee3, 2 instruction(s), ends with je to 0x004d1f17 (forward)
    cmp dword ptr [ebp - local_e4], 0x1          # 004d1ee5
    je.d8 L_004d1f17                             # 004d1eec
    # block 0x004d1eee: entered by fall-through of je at 0x004d1eec, 1 instruction(s), ends with forward jump to 0x004d1f3c
    jmp.d8 L_004d1f3c                            # 004d1eee
L_004d1ef0:
    # block 0x004d1ef0: entered by je at 0x004d1ee3, 16 instruction(s), ends with forward jump to 0x004d1f3c
    mov edi, 0x55a2a4                            # 004d1ef0
    lea edx, [ebp - local_20]                    # 004d1ef5
    or ecx, -0x1                                 # 004d1ef8
    {load} xor eax, eax                          # 004d1efb
    repne scasb al, byte ptr es:[edi]            # 004d1efd
    not ecx                                      # 004d1eff
    {load} sub edi, ecx                          # 004d1f01
    {load} mov esi, edi                          # 004d1f03
    {load} mov eax, ecx                          # 004d1f05
    {load} mov edi, edx                          # 004d1f07
    shr ecx, 0x2                                 # 004d1f09
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d1f0c
    {load} mov ecx, eax                          # 004d1f0e
    and ecx, 0x3                                 # 004d1f10
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d1f13
    jmp.d8 L_004d1f3c                            # 004d1f15
L_004d1f17:
    # block 0x004d1f17: entered by je at 0x004d1eec, 15 instruction(s), falls into the block at 0x004d1f3c
    mov edi, 0x55a2a8                            # 004d1f17
    lea edx, [ebp - local_20]                    # 004d1f1c
    or ecx, -0x1                                 # 004d1f1f
    {load} xor eax, eax                          # 004d1f22
    repne scasb al, byte ptr es:[edi]            # 004d1f24
    not ecx                                      # 004d1f26
    {load} sub edi, ecx                          # 004d1f28
    {load} mov esi, edi                          # 004d1f2a
    {load} mov eax, ecx                          # 004d1f2c
    {load} mov edi, edx                          # 004d1f2e
    shr ecx, 0x2                                 # 004d1f30
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d1f33
    {load} mov ecx, eax                          # 004d1f35
    and ecx, 0x3                                 # 004d1f37
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d1f3a
L_004d1f3c:
    # block 0x004d1f3c: entered by jmp at 0x004d1eee; jmp at 0x004d1f15, 4 instruction(s), ends with je to 0x004d1f86 (forward)
    mov cl, byte ptr [0x58322a]                  # 004d1f3c
    mov byte ptr [ebp - local_e8], cl            # 004d1f42
    cmp byte ptr [ebp - local_e8], 0x0           # 004d1f48
    je.d8 L_004d1f86                             # 004d1f4f
    # block 0x004d1f51: entered by fall-through of je at 0x004d1f4f, 2 instruction(s), ends with je to 0x004d1f5c (forward)
    cmp byte ptr [ebp - local_e8], 0x1           # 004d1f51
    je.d8 L_004d1f5c                             # 004d1f58
    # block 0x004d1f5a: entered by fall-through of je at 0x004d1f58, 1 instruction(s), ends with forward jump to 0x004d1fae
    jmp.d8 L_004d1fae                            # 004d1f5a
L_004d1f5c:
    # block 0x004d1f5c: entered by je at 0x004d1f58, 16 instruction(s), ends with forward jump to 0x004d1fae
    mov edi, 0x55a2b0                            # 004d1f5c
    lea edx, [ebp - local_d8]                    # 004d1f61
    or ecx, -0x1                                 # 004d1f67
    {load} xor eax, eax                          # 004d1f6a
    repne scasb al, byte ptr es:[edi]            # 004d1f6c
    not ecx                                      # 004d1f6e
    {load} sub edi, ecx                          # 004d1f70
    {load} mov esi, edi                          # 004d1f72
    {load} mov eax, ecx                          # 004d1f74
    {load} mov edi, edx                          # 004d1f76
    shr ecx, 0x2                                 # 004d1f78
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d1f7b
    {load} mov ecx, eax                          # 004d1f7d
    and ecx, 0x3                                 # 004d1f7f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d1f82
    jmp.d8 L_004d1fae                            # 004d1f84
L_004d1f86:
    # block 0x004d1f86: entered by je at 0x004d1f4f, 15 instruction(s), falls into the block at 0x004d1fae
    mov edi, 0x63a98c                            # 004d1f86
    lea edx, [ebp - local_d8]                    # 004d1f8b
    or ecx, -0x1                                 # 004d1f91
    {load} xor eax, eax                          # 004d1f94
    repne scasb al, byte ptr es:[edi]            # 004d1f96
    not ecx                                      # 004d1f98
    {load} sub edi, ecx                          # 004d1f9a
    {load} mov esi, edi                          # 004d1f9c
    {load} mov eax, ecx                          # 004d1f9e
    {load} mov edi, edx                          # 004d1fa0
    shr ecx, 0x2                                 # 004d1fa2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d1fa5
    {load} mov ecx, eax                          # 004d1fa7
    and ecx, 0x3                                 # 004d1fa9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d1fac
L_004d1fae:
    # block 0x004d1fae: entered by jmp at 0x004d1f5a; jmp at 0x004d1f84, 4 instruction(s), ends with je to 0x004d1ff5 (forward)
    mov cl, byte ptr [0x58322b]                  # 004d1fae
    mov byte ptr [ebp - local_ec], cl            # 004d1fb4
    cmp byte ptr [ebp - local_ec], 0x0           # 004d1fba
    je.d8 L_004d1ff5                             # 004d1fc1
    # block 0x004d1fc3: entered by fall-through of je at 0x004d1fc1, 2 instruction(s), ends with je to 0x004d1fce (forward)
    cmp byte ptr [ebp - local_ec], 0x1           # 004d1fc3
    je.d8 L_004d1fce                             # 004d1fca
    # block 0x004d1fcc: entered by fall-through of je at 0x004d1fca, 1 instruction(s), ends with forward jump to 0x004d201a
    jmp.d8 L_004d201a                            # 004d1fcc
L_004d1fce:
    # block 0x004d1fce: entered by je at 0x004d1fca, 16 instruction(s), ends with forward jump to 0x004d201a
    mov edi, 0x55a2bc                            # 004d1fce
    lea edx, [ebp - local_10]                    # 004d1fd3
    or ecx, -0x1                                 # 004d1fd6
    {load} xor eax, eax                          # 004d1fd9
    repne scasb al, byte ptr es:[edi]            # 004d1fdb
    not ecx                                      # 004d1fdd
    {load} sub edi, ecx                          # 004d1fdf
    {load} mov esi, edi                          # 004d1fe1
    {load} mov eax, ecx                          # 004d1fe3
    {load} mov edi, edx                          # 004d1fe5
    shr ecx, 0x2                                 # 004d1fe7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d1fea
    {load} mov ecx, eax                          # 004d1fec
    and ecx, 0x3                                 # 004d1fee
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d1ff1
    jmp.d8 L_004d201a                            # 004d1ff3
L_004d1ff5:
    # block 0x004d1ff5: entered by je at 0x004d1fc1, 15 instruction(s), falls into the block at 0x004d201a
    mov edi, 0x63a990                            # 004d1ff5
    lea edx, [ebp - local_10]                    # 004d1ffa
    or ecx, -0x1                                 # 004d1ffd
    {load} xor eax, eax                          # 004d2000
    repne scasb al, byte ptr es:[edi]            # 004d2002
    not ecx                                      # 004d2004
    {load} sub edi, ecx                          # 004d2006
    {load} mov esi, edi                          # 004d2008
    {load} mov eax, ecx                          # 004d200a
    {load} mov edi, edx                          # 004d200c
    shr ecx, 0x2                                 # 004d200e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d2011
    {load} mov ecx, eax                          # 004d2013
    and ecx, 0x3                                 # 004d2015
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d2018
L_004d201a:
    # block 0x004d201a: entered by jmp at 0x004d1fcc; jmp at 0x004d1ff3, 58 instruction(s), calls FUN_0050ca3e, FUN_004d2c20, ends with jle to 0x004d20fe (forward)
    lea ecx, [ebp - local_10]                    # 004d201a
    push ecx                                     # 004d201d
    lea edx, [ebp - local_d8]                    # 004d201e
    push edx                                     # 004d2024
    lea eax, [ebp - local_20]                    # 004d2025
    push eax                                     # 004d2028
    mov ecx, dword ptr [0x5c3a5f]                # 004d2029
    push ecx                                     # 004d202f
    mov edx, dword ptr [0x5c3a5b]                # 004d2030
    push edx                                     # 004d2036
    mov eax, dword ptr [0x585d4b]                # 004d2037
    push eax                                     # 004d203c
    movsx ecx, word ptr [0x585d4f]               # 004d203d
    push ecx                                     # 004d2044
    movsx edx, word ptr [0x585d51]               # 004d2045
    push edx                                     # 004d204c
    movsx eax, word ptr [0x585d53]               # 004d204d
    push eax                                     # 004d2054
    push 0x55a2c8                                # 004d2055
    lea ecx, [ebp - local_bc]                    # 004d205a
    push ecx                                     # 004d2060
    call FUN_0050ca3e                            # 004d2061
    add esp, 0x2c                                # 004d2066
    push 0x0                                     # 004d2069
    mov edx, dword ptr [0x5cf665]                # 004d206b
    push edx                                     # 004d2071
    movsx eax, word ptr [0x5b0266]               # 004d2072
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 004d2079
    push ecx                                     # 004d2080
    mov dx, word ptr [ebp - local_c0]            # 004d2081
    push edx                                     # 004d2088
    mov ax, word ptr [ebp - local_c4]            # 004d2089
    push eax                                     # 004d2090
    movsx ecx, word ptr [0x5b0266]               # 004d2091
    imul ecx, ecx, 0x1d0                         # 004d2098
    add ecx, 0x5adb3a                            # 004d209e
    push ecx                                     # 004d20a4
    movsx edx, word ptr [0x5b0266]               # 004d20a5
    imul edx, edx, 0x7f3                         # 004d20ac
    add edx, 0x5a4c24                            # 004d20b2
    push edx                                     # 004d20b8
    lea eax, [ebp - local_bc]                    # 004d20b9
    push eax                                     # 004d20bf
    call FUN_004d2c20                            # 004d20c0
    add esp, 0x20                                # 004d20c5
    mov ecx, dword ptr [eax]                     # 004d20c8
    mov dword ptr [ebp - local_50], ecx          # 004d20ca
    mov edx, dword ptr [eax + field_4]           # 004d20cd
    mov dword ptr [ebp - local_4c], edx          # 004d20d0
    mov ecx, dword ptr [eax + field_8]           # 004d20d3
    mov dword ptr [ebp - local_48], ecx          # 004d20d6
    mov edx, dword ptr [eax + field_c]           # 004d20d9
    mov dword ptr [ebp - local_44], edx          # 004d20dc
    movsx eax, word ptr [ebp - local_c0]         # 004d20df
    mov dword ptr [0x5bb1f6], eax                # 004d20e6
    mov ecx, dword ptr [ebp - local_28]          # 004d20eb
    cmp ecx, dword ptr [ebp - local_38]          # 004d20ee
    jle.d8 L_004d20fe                            # 004d20f1
    # block 0x004d20f3: entered by fall-through of jle at 0x004d20f1, 3 instruction(s), ends with forward jump to 0x004d2107
    mov edx, dword ptr [ebp - local_28]          # 004d20f3
    mov dword ptr [ebp - local_f0], edx          # 004d20f6
    jmp.d8 L_004d2107                            # 004d20fc
L_004d20fe:
    # block 0x004d20fe: entered by jle at 0x004d20f1, 2 instruction(s), falls into the block at 0x004d2107
    mov eax, dword ptr [ebp - local_38]          # 004d20fe
    mov dword ptr [ebp - local_f0], eax          # 004d2101
L_004d2107:
    # block 0x004d2107: entered by jmp at 0x004d20fc, 5 instruction(s), ends with jle to 0x004d2130 (forward)
    mov cx, word ptr [ebp - local_f0]            # 004d2107
    mov word ptr [ebp - local_c8], cx            # 004d210e
    movsx edx, word ptr [ebp - local_c8]         # 004d2115
    cmp edx, dword ptr [ebp - local_48]          # 004d211c
    jle.d8 L_004d2130                            # 004d211f
    # block 0x004d2121: entered by fall-through of jle at 0x004d211f, 3 instruction(s), ends with forward jump to 0x004d2139
    movsx eax, word ptr [ebp - local_c8]         # 004d2121
    mov dword ptr [ebp - local_f4], eax          # 004d2128
    jmp.d8 L_004d2139                            # 004d212e
L_004d2130:
    # block 0x004d2130: entered by jle at 0x004d211f, 2 instruction(s), falls into the block at 0x004d2139
    mov ecx, dword ptr [ebp - local_48]          # 004d2130
    mov dword ptr [ebp - local_f4], ecx          # 004d2133
L_004d2139:
    # block 0x004d2139: entered by jmp at 0x004d212e, 2 instruction(s), falls into the block at 0x004d2145
    mov edx, dword ptr [ebp - local_f4]          # 004d2139
    mov dword ptr [0x5bb1f2], edx                # 004d213f
L_004d2145:
    # block 0x004d2145: entered by jmp at 0x004d18f9; jmp at 0x004d1bec, 5 instruction(s), ends with ret
    pop edi                                      # 004d2145
    pop esi                                      # 004d2146
    {load} mov esp, ebp                          # 004d2147
    pop ebp                                      # 004d2149
    ret                                          # 004d214a

