# FUN_004c3c5d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c3c5d
# extent:       0x004c3c5d-0x004c3efb (670 code bytes)
# span:         0x004c3c5d-0x004c3efb (code 670, tables 0, padding 0)
# sha256:       f409c9d7ed9c4b97e53dc41469de4426cd7e73ac6d1393d2cc48a4bbf8eb39cb
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c3c5d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       21 ebp-relative slot(s): local_58, local_6c, local_7c, local_a0, local_a3, local_a4, local_a6, local_a8, local_aa, local_ac, local_ad, local_af and 9 more
# fields:       [ecx + n] field_8; [edx + n] field_8
# callees:      calls FUN_0051dc43, FUN_004264e8, FUN_004c97b4, FUN_004c4067, FUN_0043f04b, FUN_004c4202, FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, FUN_0042639d, FUN_0050e493, FUN_004c7481, FUN_0050cee4, FUN_0051dc6c, USER32.dll!MessageBeep
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 149 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_58, 0x58  # offset -0x58
.equ local_6c, 0x6c  # offset -0x6c
.equ local_7c, 0x7c  # offset -0x7c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a3, 0xa3  # offset -0xa3
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a6, 0xa6  # offset -0xa6
.equ local_a8, 0xa8  # offset -0xa8
.equ local_aa, 0xaa  # offset -0xaa
.equ local_ac, 0xac  # offset -0xac
.equ local_ad, 0xad  # offset -0xad
.equ local_af, 0xaf  # offset -0xaf
.equ local_b1, 0xb1  # offset -0xb1
.equ local_b2, 0xb2  # offset -0xb2
.equ local_b3, 0xb3  # offset -0xb3
.equ local_b4, 0xb4  # offset -0xb4
.equ local_b8, 0xb8  # offset -0xb8
.equ local_bc, 0xbc  # offset -0xbc
.equ local_c0, 0xc0  # offset -0xc0
.equ local_c4, 0xc4  # offset -0xc4
.equ local_c8, 0xc8  # offset -0xc8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0043f04b, .text + (0x0043f04b - 0x401000)
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c7481, .text + (0x004c7481 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050e493, .text + (0x0050e493 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c3c5d - 0x401000
.globl FUN_004c3c5d
FUN_004c3c5d:
    # block 0x004c3c5d: entry, 18 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c3cd4 (forward)
    push ebp                                     # 004c3c5d
    {load} mov ebp, esp                          # 004c3c5e
    sub esp, 0xc8                                # 004c3c60
    mov dword ptr [ebp - local_c8], ecx          # 004c3c66
    mov dword ptr [ebp - local_bc], 0x0          # 004c3c6c
    movsx eax, word ptr [0x63988b]               # 004c3c76
    movsx ecx, word ptr [0x63988d]               # 004c3c7d
    imul eax, ecx                                # 004c3c84
    movsx edx, word ptr [0x639895]               # 004c3c87
    imul eax, edx                                # 004c3c8e
    push eax                                     # 004c3c91
    call FUN_0051dc43                            # 004c3c92
    add esp, 0x4                                 # 004c3c97
    mov dword ptr [ebp - local_c0], eax          # 004c3c9a
    mov eax, dword ptr [ebp - local_c0]          # 004c3ca0
    mov dword ptr [ebp - local_bc], eax          # 004c3ca6
    cmp dword ptr [ebp - local_bc], 0x0          # 004c3cac
    jne.d8 L_004c3cd4                            # 004c3cb3
    # block 0x004c3cb5: entered by fall-through of jne at 0x004c3cb3, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c3ef7
    push 0x554274                                # 004c3cb5
    mov ecx, 0x583979                            # 004c3cba
    call FUN_004264e8                            # 004c3cbf
    mov ecx, dword ptr [ebp - local_c8]          # 004c3cc4
    call FUN_004c97b4                            # 004c3cca
    jmp.d32 L_004c3ef7                           # 004c3ccf
L_004c3cd4:
    # block 0x004c3cd4: entered by jne at 0x004c3cb3, 68 instruction(s), calls FUN_004c4067, FUN_0043f04b, FUN_004c4202, FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004c3e35 (forward)
    push 0x10                                    # 004c3cd4
    push 0x5542b8                                # 004c3cd6
    lea ecx, [ebp - local_7c]                    # 004c3cdb
    push ecx                                     # 004c3cde
    push 0x0                                     # 004c3cdf
    mov edx, dword ptr [ebp - local_c8]          # 004c3ce1
    mov eax, dword ptr [edx + field_8]           # 004c3ce7
    push eax                                     # 004c3cea
    mov ecx, dword ptr [ebp - local_c8]          # 004c3ceb
    call FUN_004c4067                            # 004c3cf1
    mov ecx, dword ptr [ebp - local_6c]          # 004c3cf6
    push ecx                                     # 004c3cf9
    movsx edx, word ptr [0x63988b]               # 004c3cfa
    movsx eax, word ptr [0x639895]               # 004c3d01
    imul edx, eax                                # 004c3d08
    push edx                                     # 004c3d0b
    movsx ecx, word ptr [0x63988d]               # 004c3d0c
    push ecx                                     # 004c3d13
    mov edx, dword ptr [ebp - local_58]          # 004c3d14
    push edx                                     # 004c3d17
    mov eax, dword ptr [ebp - local_bc]          # 004c3d18
    push eax                                     # 004c3d1e
    mov ecx, 0x5d2f2d                            # 004c3d1f
    call FUN_0043f04b                            # 004c3d24
    push 0x5542ec                                # 004c3d29
    push 0x0                                     # 004c3d2e
    mov ecx, dword ptr [ebp - local_c8]          # 004c3d30
    mov edx, dword ptr [ecx + field_8]           # 004c3d36
    push edx                                     # 004c3d39
    mov ecx, dword ptr [ebp - local_c8]          # 004c3d3a
    call FUN_004c4202                            # 004c3d40
    mov byte ptr [ebp - local_b4], 0x0           # 004c3d45
    mov byte ptr [ebp - local_b3], 0x0           # 004c3d4c
    mov byte ptr [ebp - local_b2], 0x2           # 004c3d53
    mov word ptr [ebp - local_b1], 0x0           # 004c3d5a
    mov word ptr [ebp - local_af], 0x0           # 004c3d63
    mov byte ptr [ebp - local_ad], 0x0           # 004c3d6c
    mov word ptr [ebp - local_ac], 0x0           # 004c3d73
    mov word ptr [ebp - local_aa], 0x0           # 004c3d7c
    mov ax, word ptr [0x63988b]                  # 004c3d85
    mov word ptr [ebp - local_a8], ax            # 004c3d8b
    mov cx, word ptr [0x63988d]                  # 004c3d92
    mov word ptr [ebp - local_a6], cx            # 004c3d99
    mov dl, byte ptr [0x639893]                  # 004c3da0
    mov byte ptr [ebp - local_a4], dl            # 004c3da6
    mov byte ptr [ebp - local_a3], 0x20          # 004c3dac
    mov eax, dword ptr [0x5a4c14]                # 004c3db3
    push eax                                     # 004c3db8
    push 0x554320                                # 004c3db9
    lea ecx, [ebp - local_a0]                    # 004c3dbe
    push ecx                                     # 004c3dc4
    call FUN_0050ca3e                            # 004c3dc5
    add esp, 0xc                                 # 004c3dca
    push 0x554328                                # 004c3dcd
    lea edx, [ebp - local_a0]                    # 004c3dd2
    push edx                                     # 004c3dd8
    push 0x639aa2                                # 004c3dd9
    push 0x639a9f                                # 004c3dde
    push 0x63888b                                # 004c3de3
    call FUN_0050cd72                            # 004c3de8
    add esp, 0x14                                # 004c3ded
    push 0x554330                                # 004c3df0
    push 0x63888b                                # 004c3df5
    call FUN_0050d0a9                            # 004c3dfa
    add esp, 0x8                                 # 004c3dff
    mov dword ptr [ebp - local_b8], eax          # 004c3e02
    cmp dword ptr [ebp - local_b8], 0x0          # 004c3e08
    jne.d8 L_004c3e35                            # 004c3e0f
    # block 0x004c3e11: entered by fall-through of jne at 0x004c3e0f, 7 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c3ef7
    push 0x63888b                                # 004c3e11
    push 0x554334                                # 004c3e16
    mov ecx, 0x583979                            # 004c3e1b
    call FUN_0042639d                            # 004c3e20
    mov ecx, dword ptr [ebp - local_c8]          # 004c3e25
    call FUN_004c97b4                            # 004c3e2b
    jmp.d32 L_004c3ef7                           # 004c3e30
L_004c3e35:
    # block 0x004c3e35: entered by jne at 0x004c3e0f, 47 instruction(s), calls FUN_0050e493, FUN_004c7481, FUN_0050cee4, FUN_0051dc6c, USER32.dll!MessageBeep, falls into the block at 0x004c3ef7
    mov eax, dword ptr [ebp - local_b8]          # 004c3e35
    push eax                                     # 004c3e3b
    push 0x1                                     # 004c3e3c
    push 0x12                                    # 004c3e3e
    lea ecx, [ebp - local_b4]                    # 004c3e40
    push ecx                                     # 004c3e46
    call FUN_0050e493                            # 004c3e47
    add esp, 0x10                                # 004c3e4c
    movsx edx, word ptr [0x63988b]               # 004c3e4f
    movsx eax, word ptr [0x63988d]               # 004c3e56
    imul edx, eax                                # 004c3e5d
    movsx ecx, word ptr [0x639895]               # 004c3e60
    imul edx, ecx                                # 004c3e67
    push edx                                     # 004c3e6a
    mov edx, dword ptr [ebp - local_bc]          # 004c3e6b
    push edx                                     # 004c3e71
    mov ecx, dword ptr [ebp - local_c8]          # 004c3e72
    call FUN_004c7481                            # 004c3e78
    mov eax, dword ptr [ebp - local_b8]          # 004c3e7d
    push eax                                     # 004c3e83
    push 0x1                                     # 004c3e84
    movsx ecx, word ptr [0x63988b]               # 004c3e86
    movsx edx, word ptr [0x63988d]               # 004c3e8d
    imul ecx, edx                                # 004c3e94
    movsx eax, word ptr [0x639895]               # 004c3e97
    imul ecx, eax                                # 004c3e9e
    push ecx                                     # 004c3ea1
    mov ecx, dword ptr [ebp - local_bc]          # 004c3ea2
    push ecx                                     # 004c3ea8
    call FUN_0050e493                            # 004c3ea9
    add esp, 0x10                                # 004c3eae
    mov edx, dword ptr [ebp - local_b8]          # 004c3eb1
    push edx                                     # 004c3eb7
    call FUN_0050cee4                            # 004c3eb8
    add esp, 0x4                                 # 004c3ebd
    mov byte ptr [0x583224], 0x0                 # 004c3ec0
    mov eax, dword ptr [0x5a4c14]                # 004c3ec7
    add eax, 0x1                                 # 004c3ecc
    mov dword ptr [0x5a4c14], eax                # 004c3ecf
    mov ecx, dword ptr [ebp - local_bc]          # 004c3ed4
    mov dword ptr [ebp - local_c4], ecx          # 004c3eda
    mov edx, dword ptr [ebp - local_c4]          # 004c3ee0
    push edx                                     # 004c3ee6
    call FUN_0051dc6c                            # 004c3ee7
    add esp, 0x4                                 # 004c3eec
    push -0x1                                    # 004c3eef
    call dword ptr [0x52a490]                    # 004c3ef1
L_004c3ef7:
    # block 0x004c3ef7: entered by jmp at 0x004c3ccf; jmp at 0x004c3e30, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c3ef7
    pop ebp                                      # 004c3ef9
    ret                                          # 004c3efa

