# FUN_00454847
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454847
# extent:       0x00454847-0x00454c63 (1052 code bytes)
# span:         0x00454847-0x00454c70 (code 1052, tables 0, padding 13)
# sha256:       eb0fef5a0e0c2b8c157544ad17f1fa58c110b86485b0fea6ed3efa492f4d1e6d
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00454847
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_minus_1
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 257 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x00454847 - 0x401000
.globl FUN_00454847
FUN_00454847:
    # block 0x00454847: entry, 5 instruction(s), ends with jne to 0x0045485b (forward)
    push ebp                                     # 00454847
    {load} mov ebp, esp                          # 00454848
    sub esp, 0x28                                # 0045484a
    cmp dword ptr [0x61d887], 0x0                # 0045484d
    jne.d8 L_0045485b                            # 00454854
    # block 0x00454856: entered by fall-through of jne at 0x00454854, 1 instruction(s), ends with forward jump to 0x00454c5f
    jmp.d32 L_00454c5f                           # 00454856
L_0045485b:
    # block 0x0045485b: entered by jne at 0x00454854, 2 instruction(s), ends with je to 0x004548ad (forward)
    cmp dword ptr [0x61d937], 0x0                # 0045485b
    je.d8 L_004548ad                             # 00454862
    # block 0x00454864: entered by fall-through of je at 0x00454862, 13 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00454c5f
    push 0x549e60                                # 00454864
    push 0x61d8af                                # 00454869
    push 0x61d8bf                                # 0045486e
    mov eax, dword ptr [0x5cf665]                # 00454873
    push eax                                     # 00454878
    mov ecx, dword ptr [0x5d15e3]                # 00454879
    push ecx                                     # 0045487f
    mov ecx, 0x5cf659                            # 00454880
    call FUN_004c5377                            # 00454885
    mov dword ptr [0x61d937], 0x0                # 0045488a
    mov dword ptr [0x61d933], 0x0                # 00454894
    mov dword ptr [0x61d9d3], 0x0                # 0045489e
    jmp.d32 L_00454c5f                           # 004548a8
L_004548ad:
    # block 0x004548ad: entered by je at 0x00454862, 2 instruction(s), ends with je to 0x00454921 (forward)
    cmp dword ptr [0x61d933], 0x0                # 004548ad
    je.d8 L_00454921                             # 004548b4
    # block 0x004548b6: entered by fall-through of je at 0x004548b4, 23 instruction(s), calls FUN_004c5377, falls into the block at 0x00454921
    mov edx, dword ptr [0x61d94b]                # 004548b6
    sub edx, dword ptr [0x61dbbf]                # 004548bc
    mov dword ptr [ebp - local_10], edx          # 004548c2
    mov eax, dword ptr [0x61d953]                # 004548c5
    sub eax, dword ptr [0x61dbbf]                # 004548ca
    mov dword ptr [ebp - local_8], eax           # 004548d0
    mov ecx, dword ptr [0x61d94f]                # 004548d3
    sub ecx, dword ptr [0x61dbc3]                # 004548d9
    mov dword ptr [ebp - local_c], ecx           # 004548df
    mov edx, dword ptr [0x61d957]                # 004548e2
    sub edx, dword ptr [0x61dbc3]                # 004548e8
    mov dword ptr [ebp - local_4], edx           # 004548ee
    push 0x549e88                                # 004548f1
    push 0x61d94b                                # 004548f6
    lea eax, [ebp - local_10]                    # 004548fb
    push eax                                     # 004548fe
    mov ecx, dword ptr [0x5cf665]                # 004548ff
    push ecx                                     # 00454905
    mov edx, dword ptr [0x5d15e3]                # 00454906
    push edx                                     # 0045490c
    mov ecx, 0x5cf659                            # 0045490d
    call FUN_004c5377                            # 00454912
    mov dword ptr [0x61d933], 0x0                # 00454917
L_00454921:
    # block 0x00454921: entered by je at 0x004548b4, 2 instruction(s), ends with je to 0x00454993 (forward)
    cmp dword ptr [0x61d9d3], 0x0                # 00454921
    je.d8 L_00454993                             # 00454928
    # block 0x0045492a: entered by fall-through of je at 0x00454928, 23 instruction(s), calls FUN_004c5377, falls into the block at 0x00454993
    mov eax, dword ptr [0x61d9c3]                # 0045492a
    sub eax, dword ptr [0x61dbbf]                # 0045492f
    mov dword ptr [ebp - local_10], eax          # 00454935
    mov ecx, dword ptr [0x61d9cb]                # 00454938
    sub ecx, dword ptr [0x61dbbf]                # 0045493e
    mov dword ptr [ebp - local_8], ecx           # 00454944
    mov edx, dword ptr [0x61d9c7]                # 00454947
    sub edx, dword ptr [0x61dbc3]                # 0045494d
    mov dword ptr [ebp - local_c], edx           # 00454953
    mov eax, dword ptr [0x61d9cf]                # 00454956
    sub eax, dword ptr [0x61dbc3]                # 0045495b
    mov dword ptr [ebp - local_4], eax           # 00454961
    push 0x549eb8                                # 00454964
    push 0x61d9c3                                # 00454969
    lea ecx, [ebp - local_10]                    # 0045496e
    push ecx                                     # 00454971
    mov edx, dword ptr [0x5cf665]                # 00454972
    push edx                                     # 00454978
    mov eax, dword ptr [0x5d15e3]                # 00454979
    push eax                                     # 0045497e
    mov ecx, 0x5cf659                            # 0045497f
    call FUN_004c5377                            # 00454984
    mov dword ptr [0x61d9d3], 0x0                # 00454989
L_00454993:
    # block 0x00454993: entered by je at 0x00454928, 22 instruction(s), calls FUN_004c5377, ends with jne to 0x00454a2e (forward)
    push 0x549ee4                                # 00454993
    push 0x61db8f                                # 00454998
    push 0x61db7f                                # 0045499d
    mov ecx, dword ptr [0x5cf665]                # 004549a2
    push ecx                                     # 004549a8
    mov edx, dword ptr [0x61db17]                # 004549a9
    push edx                                     # 004549af
    mov ecx, 0x5cf659                            # 004549b0
    call FUN_004c5377                            # 004549b5
    push 0x549efc                                # 004549ba
    push 0x61d93b                                # 004549bf
    push 0x61d89f                                # 004549c4
    mov eax, dword ptr [0x5cf665]                # 004549c9
    push eax                                     # 004549ce
    movsx ecx, word ptr [0x61d877]               # 004549cf
    imul ecx, ecx, 0x4a                          # 004549d6
    mov edx, dword ptr [ecx + 0x5d1599]          # 004549d9
    push edx                                     # 004549df
    mov ecx, 0x5cf659                            # 004549e0
    call FUN_004c5377                            # 004549e5
    cmp dword ptr [0x61d897], 0x0                # 004549ea
    jne.d8 L_00454a2e                            # 004549f1
    # block 0x004549f3: entered by fall-through of jne at 0x004549f1, 2 instruction(s), ends with jne to 0x00454a2e (forward)
    cmp dword ptr [0x61d89b], 0x0                # 004549f3
    jne.d8 L_00454a2e                            # 004549fa
    # block 0x004549fc: entered by fall-through of jne at 0x004549fa, 12 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00454a70
    push 0x549f14                                # 004549fc
    push 0x61d98b                                # 00454a01
    push 0x61d97b                                # 00454a06
    mov eax, dword ptr [0x5cf665]                # 00454a0b
    push eax                                     # 00454a10
    movsx ecx, word ptr [0x61d877]               # 00454a11
    imul ecx, ecx, 0x4a                          # 00454a18
    mov edx, dword ptr [ecx + 0x5d1599]          # 00454a1b
    push edx                                     # 00454a21
    mov ecx, 0x5cf659                            # 00454a22
    call FUN_004c5d4b                            # 00454a27
    jmp.d8 L_00454a70                            # 00454a2c
L_00454a2e:
    # block 0x00454a2e: entered by jne at 0x004549f1; jne at 0x004549fa, 2 instruction(s), ends with je to 0x00454a70 (forward)
    cmp dword ptr [0x61d897], 0x0                # 00454a2e
    je.d8 L_00454a70                             # 00454a35
    # block 0x00454a37: entered by fall-through of je at 0x00454a35, 2 instruction(s), ends with jne to 0x00454a70 (forward)
    cmp dword ptr [0x61d89b], 0x0                # 00454a37
    jne.d8 L_00454a70                            # 00454a3e
    # block 0x00454a40: entered by fall-through of jne at 0x00454a3e, 11 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00454a70
    push 0x549f28                                # 00454a40
    push 0x61d9ab                                # 00454a45
    push 0x61d99b                                # 00454a4a
    mov eax, dword ptr [0x5cf665]                # 00454a4f
    push eax                                     # 00454a54
    movsx ecx, word ptr [0x61d877]               # 00454a55
    imul ecx, ecx, 0x4a                          # 00454a5c
    mov edx, dword ptr [ecx + 0x5d1599]          # 00454a5f
    push edx                                     # 00454a65
    mov ecx, 0x5cf659                            # 00454a66
    call FUN_004c5d4b                            # 00454a6b
L_00454a70:
    # block 0x00454a70: entered by jmp at 0x00454a2c; je at 0x00454a35; jne at 0x00454a3e, 2 instruction(s), ends with je to 0x00454b15 (forward)
    cmp dword ptr [0x61d893], 0x0                # 00454a70
    je.d32 L_00454b15                            # 00454a77
    # block 0x00454a7d: entered by fall-through of je at 0x00454a77, 42 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00454b15
    mov eax, dword ptr [0x61d8f7]                # 00454a7d
    sub eax, dword ptr [0x61d8ef]                # 00454a82
    add eax, 0x1                                 # 00454a88
    mov dword ptr [ebp - local_18], eax          # 00454a8b
    mov ecx, dword ptr [0x61d8fb]                # 00454a8e
    sub ecx, dword ptr [0x61d8f3]                # 00454a94
    add ecx, 0x1                                 # 00454a9a
    mov dword ptr [ebp - local_14], ecx          # 00454a9d
    mov eax, dword ptr [0x61dbcf]                # 00454aa0
    sub eax, dword ptr [ebp - local_18]          # 00454aa5
    cdq                                          # 00454aa8
    {load} sub eax, edx                          # 00454aa9
    sar eax                                      # 00454aab
    add eax, dword ptr [0x61dbbf]                # 00454aad
    mov dword ptr [ebp - local_28], eax          # 00454ab3
    mov eax, dword ptr [0x61dbd3]                # 00454ab6
    sub eax, dword ptr [ebp - local_14]          # 00454abb
    cdq                                          # 00454abe
    {load} sub eax, edx                          # 00454abf
    sar eax                                      # 00454ac1
    add eax, dword ptr [0x61dbc3]                # 00454ac3
    mov dword ptr [ebp - local_24], eax          # 00454ac9
    mov edx, dword ptr [ebp - local_18]          # 00454acc
    mov eax, dword ptr [ebp - local_28]          # 00454acf
    lea ecx, [eax + edx - field_minus_1]         # 00454ad2
    mov dword ptr [ebp - local_20], ecx          # 00454ad6
    mov edx, dword ptr [ebp - local_14]          # 00454ad9
    mov eax, dword ptr [ebp - local_24]          # 00454adc
    lea ecx, [eax + edx - field_minus_1]         # 00454adf
    mov dword ptr [ebp - local_1c], ecx          # 00454ae3
    push 0x549f44                                # 00454ae6
    lea edx, [ebp - local_28]                    # 00454aeb
    push edx                                     # 00454aee
    push 0x61d8ef                                # 00454aef
    mov eax, dword ptr [0x5cf665]                # 00454af4
    push eax                                     # 00454af9
    movsx ecx, word ptr [0x61d877]               # 00454afa
    imul ecx, ecx, 0x4a                          # 00454b01
    mov edx, dword ptr [ecx + 0x5d1599]          # 00454b04
    push edx                                     # 00454b0a
    mov ecx, 0x5cf659                            # 00454b0b
    call FUN_004c5d4b                            # 00454b10
L_00454b15:
    # block 0x00454b15: entered by je at 0x00454a77, 2 instruction(s), ends with je to 0x00454bba (forward)
    cmp dword ptr [0x61d88f], 0x0                # 00454b15
    je.d32 L_00454bba                            # 00454b1c
    # block 0x00454b22: entered by fall-through of je at 0x00454b1c, 42 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00454bba
    mov eax, dword ptr [0x61d8d7]                # 00454b22
    sub eax, dword ptr [0x61d8cf]                # 00454b27
    add eax, 0x1                                 # 00454b2d
    mov dword ptr [ebp - local_18], eax          # 00454b30
    mov ecx, dword ptr [0x61d8db]                # 00454b33
    sub ecx, dword ptr [0x61d8d3]                # 00454b39
    add ecx, 0x1                                 # 00454b3f
    mov dword ptr [ebp - local_14], ecx          # 00454b42
    mov eax, dword ptr [0x61dbcf]                # 00454b45
    sub eax, dword ptr [ebp - local_18]          # 00454b4a
    cdq                                          # 00454b4d
    {load} sub eax, edx                          # 00454b4e
    sar eax                                      # 00454b50
    add eax, dword ptr [0x61dbbf]                # 00454b52
    mov dword ptr [ebp - local_28], eax          # 00454b58
    mov eax, dword ptr [0x61dbd3]                # 00454b5b
    sub eax, dword ptr [ebp - local_14]          # 00454b60
    cdq                                          # 00454b63
    {load} sub eax, edx                          # 00454b64
    sar eax                                      # 00454b66
    add eax, dword ptr [0x61dbc3]                # 00454b68
    mov dword ptr [ebp - local_24], eax          # 00454b6e
    mov edx, dword ptr [ebp - local_18]          # 00454b71
    mov eax, dword ptr [ebp - local_28]          # 00454b74
    lea ecx, [eax + edx - field_minus_1]         # 00454b77
    mov dword ptr [ebp - local_20], ecx          # 00454b7b
    mov edx, dword ptr [ebp - local_14]          # 00454b7e
    mov eax, dword ptr [ebp - local_24]          # 00454b81
    lea ecx, [eax + edx - field_minus_1]         # 00454b84
    mov dword ptr [ebp - local_1c], ecx          # 00454b88
    push 0x549f64                                # 00454b8b
    lea edx, [ebp - local_28]                    # 00454b90
    push edx                                     # 00454b93
    push 0x61d8cf                                # 00454b94
    mov eax, dword ptr [0x5cf665]                # 00454b99
    push eax                                     # 00454b9e
    movsx ecx, word ptr [0x61d877]               # 00454b9f
    imul ecx, ecx, 0x4a                          # 00454ba6
    mov edx, dword ptr [ecx + 0x5d1599]          # 00454ba9
    push edx                                     # 00454baf
    mov ecx, 0x5cf659                            # 00454bb0
    call FUN_004c5d4b                            # 00454bb5
L_00454bba:
    # block 0x00454bba: entered by je at 0x00454b1c, 2 instruction(s), ends with je to 0x00454c5f (forward)
    cmp dword ptr [0x61d88b], 0x0                # 00454bba
    je.d32 L_00454c5f                            # 00454bc1
    # block 0x00454bc7: entered by fall-through of je at 0x00454bc1, 42 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00454c5f
    mov eax, dword ptr [0x61d8e7]                # 00454bc7
    sub eax, dword ptr [0x61d8df]                # 00454bcc
    add eax, 0x1                                 # 00454bd2
    mov dword ptr [ebp - local_18], eax          # 00454bd5
    mov ecx, dword ptr [0x61d8eb]                # 00454bd8
    sub ecx, dword ptr [0x61d8e3]                # 00454bde
    add ecx, 0x1                                 # 00454be4
    mov dword ptr [ebp - local_14], ecx          # 00454be7
    mov eax, dword ptr [0x61dbcf]                # 00454bea
    sub eax, dword ptr [ebp - local_18]          # 00454bef
    cdq                                          # 00454bf2
    {load} sub eax, edx                          # 00454bf3
    sar eax                                      # 00454bf5
    add eax, dword ptr [0x61dbbf]                # 00454bf7
    mov dword ptr [ebp - local_28], eax          # 00454bfd
    mov eax, dword ptr [0x61dbd3]                # 00454c00
    sub eax, dword ptr [ebp - local_14]          # 00454c05
    cdq                                          # 00454c08
    {load} sub eax, edx                          # 00454c09
    sar eax                                      # 00454c0b
    add eax, dword ptr [0x61dbc3]                # 00454c0d
    mov dword ptr [ebp - local_24], eax          # 00454c13
    mov edx, dword ptr [ebp - local_18]          # 00454c16
    mov eax, dword ptr [ebp - local_28]          # 00454c19
    lea ecx, [eax + edx - field_minus_1]         # 00454c1c
    mov dword ptr [ebp - local_20], ecx          # 00454c20
    mov edx, dword ptr [ebp - local_14]          # 00454c23
    mov eax, dword ptr [ebp - local_24]          # 00454c26
    lea ecx, [eax + edx - field_minus_1]         # 00454c29
    mov dword ptr [ebp - local_1c], ecx          # 00454c2d
    push 0x549f8c                                # 00454c30
    lea edx, [ebp - local_28]                    # 00454c35
    push edx                                     # 00454c38
    push 0x61d8df                                # 00454c39
    mov eax, dword ptr [0x5cf665]                # 00454c3e
    push eax                                     # 00454c43
    movsx ecx, word ptr [0x61d877]               # 00454c44
    imul ecx, ecx, 0x4a                          # 00454c4b
    mov edx, dword ptr [ecx + 0x5d1599]          # 00454c4e
    push edx                                     # 00454c54
    mov ecx, 0x5cf659                            # 00454c55
    call FUN_004c5d4b                            # 00454c5a
L_00454c5f:
    # block 0x00454c5f: entered by jmp at 0x00454856; jmp at 0x004548a8; je at 0x00454bc1, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00454c5f
    pop ebp                                      # 00454c61
    ret                                          # 00454c62

# --- data items (not part of the function) -------------------------
.org 0x00454c63 - 0x401000
PAD_00454c63:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

