# FUN_00430ca0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00430ca0
# extent:       0x00430ca0-0x004313d3 (1843 code bytes)
# span:         0x00430ca0-0x004313e3 (code 1843, tables 16, padding 0)
# sha256:       5a20bc21b8307f063465a52cb4f283e63660ada249039f64eb010b3675868213
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00430ca0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_21, field_2a2, field_2a4, field_2a6, field_2a8, field_2aa, field_2ae, field_2b2, field_2b6; [ecx + n] field_265, field_2b8, field_2ba, field_2de; [edx + n] field_265, field_2bb, field_2de, field_2ee, field_2f0, field_2f2, field_2f4, field_2f6, field_2fa, field_2fe, field_302, field_304 and 1 more
# callees:      calls FUN_004e8d96, FUN_0050cd50, FUN_004c2dfb, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 373 instruction(s), 21 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_265, 0x265  # offset +0x265
.equ field_2a2, 0x2a2  # offset +0x2a2
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_2a6, 0x2a6  # offset +0x2a6
.equ field_2a8, 0x2a8  # offset +0x2a8
.equ field_2aa, 0x2aa  # offset +0x2aa
.equ field_2ae, 0x2ae  # offset +0x2ae
.equ field_2b2, 0x2b2  # offset +0x2b2
.equ field_2b6, 0x2b6  # offset +0x2b6
.equ field_2b8, 0x2b8  # offset +0x2b8
.equ field_2ba, 0x2ba  # offset +0x2ba
.equ field_2bb, 0x2bb  # offset +0x2bb
.equ field_2de, 0x2de  # offset +0x2de
.equ field_2ee, 0x2ee  # offset +0x2ee
.equ field_2f0, 0x2f0  # offset +0x2f0
.equ field_2f2, 0x2f2  # offset +0x2f2
.equ field_2f4, 0x2f4  # offset +0x2f4
.equ field_2f6, 0x2f6  # offset +0x2f6
.equ field_2fa, 0x2fa  # offset +0x2fa
.equ field_2fe, 0x2fe  # offset +0x2fe
.equ field_302, 0x302  # offset +0x302
.equ field_304, 0x304  # offset +0x304
.equ field_306, 0x306  # offset +0x306

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x00430ca0 - 0x401000
.globl FUN_00430ca0
FUN_00430ca0:
    # block 0x00430ca0: entry, 12 instruction(s), ends with je to 0x00430cdb (forward)
    push ebp                                     # 00430ca0
    {load} mov ebp, esp                          # 00430ca1
    sub esp, 0x14                                # 00430ca3
    push ebx                                     # 00430ca6
    push esi                                     # 00430ca7
    push edi                                     # 00430ca8
    movsx eax, word ptr [ebp + arg_8]            # 00430ca9
    imul eax, eax, 0x8d                          # 00430cad
    mov ecx, dword ptr [eax + 0x5bb632]          # 00430cb3
    mov dword ptr [ebp - local_10], ecx          # 00430cb9
    cmp dword ptr [ebp - local_10], 0x0          # 00430cbc
    je.d8 L_00430cdb                             # 00430cc0
    # block 0x00430cc2: entered by fall-through of je at 0x00430cc0, 2 instruction(s), ends with je to 0x00430e66 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 00430cc2
    je.d32 L_00430e66                            # 00430cc6
    # block 0x00430ccc: entered by fall-through of je at 0x00430cc6, 2 instruction(s), ends with je to 0x0043109c (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 00430ccc
    je.d32 L_0043109c                            # 00430cd0
    # block 0x00430cd6: entered by fall-through of je at 0x00430cd0, 1 instruction(s), ends with forward jump to 0x004313cc
    jmp.d32 L_004313cc                           # 00430cd6
L_00430cdb:
    # block 0x00430cdb: entered by je at 0x00430cc0, 10 instruction(s), calls FUN_004e8d96, ends with forward jump to 0x00430d23
    mov byte ptr [0x5b51ab], 0x1                 # 00430cdb
    mov byte ptr [0x5b51b9], 0x0                 # 00430ce2
    mov dword ptr [0x5bb1ca], 0x1                # 00430ce9
    mov dx, word ptr [ebp + arg_8]               # 00430cf3
    mov word ptr [0x5b51ac], dx                  # 00430cf7
    mov byte ptr [0x5b51b0], 0x0                 # 00430cfe
    mov ecx, 0x571442                            # 00430d05
    call FUN_004e8d96                            # 00430d0a
    mov word ptr [ebp - local_8], 0x0            # 00430d0f
    jmp.d8 L_00430d23                            # 00430d15
L_00430d17:
    # block 0x00430d17: entered by jmp at 0x00430da6, 3 instruction(s), falls into the block at 0x00430d23
    mov ax, word ptr [ebp - local_8]             # 00430d17
    .insn 0x66, 0x05, 0x0001{:u16}               # 00430d1b
    mov word ptr [ebp - local_8], ax             # 00430d1f
L_00430d23:
    # block 0x00430d23: entered by jmp at 0x00430d15, 7 instruction(s), ends with jge to 0x00430dab (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00430d23
    movsx edx, word ptr [ebp + arg_8]            # 00430d27
    imul edx, edx, 0x8d                          # 00430d2b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00430d31
    movsx edx, word ptr [eax + field_21]         # 00430d37
    {load} cmp ecx, edx                          # 00430d3b
    jge.d8 L_00430dab                            # 00430d3d
    # block 0x00430d3f: entered by fall-through of jge at 0x00430d3d, 5 instruction(s), calls FUN_0050cd50, falls into the block at 0x00430d50
    call FUN_0050cd50                            # 00430d3f
    cdq                                          # 00430d44
    mov ecx, 0xa                                 # 00430d45
    idiv ecx                                     # 00430d4a
    mov word ptr [ebp - local_4], dx             # 00430d4c
L_00430d50:
    # block 0x00430d50: entered by jmp at 0x00430d86, 9 instruction(s), ends with jne to 0x00430d88 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00430d50
    movsx eax, word ptr [ebp + arg_8]            # 00430d54
    imul eax, eax, 0x8d                          # 00430d58
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430d5e
    movsx eax, word ptr [ebp - local_8]          # 00430d64
    {load} xor ebx, ebx                          # 00430d68
    mov bl, byte ptr [ecx + eax + field_265]     # 00430d6a
    {load} cmp edx, ebx                          # 00430d71
    jne.d8 L_00430d88                            # 00430d73
    # block 0x00430d75: entered by fall-through of jne at 0x00430d73, 6 instruction(s), calls FUN_0050cd50, ends with backward jump to 0x00430d50
    call FUN_0050cd50                            # 00430d75
    cdq                                          # 00430d7a
    mov ecx, 0xa                                 # 00430d7b
    idiv ecx                                     # 00430d80
    mov word ptr [ebp - local_4], dx             # 00430d82
    jmp.d8 L_00430d50                            # 00430d86
L_00430d88:
    # block 0x00430d88: entered by jne at 0x00430d73, 6 instruction(s), ends with backward jump to 0x00430d17
    movsx edx, word ptr [ebp - local_4]          # 00430d88
    movsx eax, word ptr [ebp - local_8]          # 00430d8c
    mov dword ptr [4*eax + 0x5b516b], edx        # 00430d90
    movsx ecx, word ptr [ebp - local_8]          # 00430d97
    mov dword ptr [4*ecx + 0x5b518b], 0x0        # 00430d9b
    jmp.d32 L_00430d17                           # 00430da6
L_00430dab:
    # block 0x00430dab: entered by jge at 0x00430d3d, 25 instruction(s), calls FUN_004c2dfb, FUN_004c2790, ends with je to 0x00430e43 (forward)
    push 0x5d03d3                                # 00430dab
    mov ecx, 0x5cf659                            # 00430db0
    call FUN_004c2dfb                            # 00430db5
    push 0x545c50                                # 00430dba
    push 0x6                                     # 00430dbf
    movsx edx, word ptr [ebp + arg_8]            # 00430dc1
    imul edx, edx, 0x8d                          # 00430dc5
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00430dcb
    push eax                                     # 00430dd1
    push 0x545c70                                # 00430dd2
    mov ecx, 0x5cf659                            # 00430dd7
    call FUN_004c2790                            # 00430ddc
    mov dword ptr [0x5d03d3], eax                # 00430de1
    mov ecx, dword ptr [0x5d03d3]                # 00430de6
    mov dword ptr [0x5d1acd], ecx                # 00430dec
    mov dword ptr [0x5d1ad9], 0x1                # 00430df2
    mov edi, 0x545c78                            # 00430dfc
    movsx edx, word ptr [ebp + arg_8]            # 00430e01
    imul edx, edx, 0x8d                          # 00430e05
    mov esi, dword ptr [edx + 0x5bb5e5]          # 00430e0b
    add esi, 0x271                               # 00430e11
    mov ecx, 0x9                                 # 00430e17
    {load} xor eax, eax                          # 00430e1c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00430e1e
    je.d8 L_00430e43                             # 00430e20
    # block 0x00430e22: entered by fall-through of je at 0x00430e20, 7 instruction(s), calls FUN_004fb77a, falls into the block at 0x00430e43
    movsx ecx, word ptr [ebp + arg_8]            # 00430e22
    imul ecx, ecx, 0x8d                          # 00430e26
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430e2c
    add edx, 0x271                               # 00430e32
    push edx                                     # 00430e38
    mov ecx, 0x5c3a67                            # 00430e39
    call FUN_004fb77a                            # 00430e3e
L_00430e43:
    # block 0x00430e43: entered by je at 0x00430e20, 5 instruction(s), ends with forward jump to 0x004313cc
    mov dword ptr [0x5b51b5], 0x0                # 00430e43
    movsx eax, word ptr [ebp + arg_8]            # 00430e4d
    imul eax, eax, 0x8d                          # 00430e51
    mov dword ptr [eax + 0x5bb632], 0x1          # 00430e57
    jmp.d32 L_004313cc                           # 00430e61
L_00430e66:
    # block 0x00430e66: entered by je at 0x00430cc6, 4 instruction(s), ends with ja to 0x00431097 (forward)
    mov ecx, dword ptr [0x5b51b5]                # 00430e66
    mov dword ptr [ebp - local_14], ecx          # 00430e6c
    cmp dword ptr [ebp - local_14], 0x3          # 00430e6f
    ja.d32 L_00431097                            # 00430e73
    # block 0x00430e79: entered by fall-through of ja at 0x00430e73, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4313d3]
    mov edx, dword ptr [ebp - local_14]          # 00430e79
    jmp dword ptr [4*edx + SWTAB_004313d3_VA]    # 00430e7c
L_00430e83:
    # block 0x00430e83: entered by switch case, 3 instruction(s), ends with forward jump to 0x00430e9e
    mov byte ptr [0x5b51b9], 0x1                 # 00430e83
    mov word ptr [ebp - local_8], 0x0            # 00430e8a
    jmp.d8 L_00430e9e                            # 00430e90
L_00430e92:
    # block 0x00430e92: entered by jmp at 0x00430eed, 3 instruction(s), falls into the block at 0x00430e9e
    mov ax, word ptr [ebp - local_8]             # 00430e92
    .insn 0x66, 0x05, 0x0001{:u16}               # 00430e96
    mov word ptr [ebp - local_8], ax             # 00430e9a
L_00430e9e:
    # block 0x00430e9e: entered by jmp at 0x00430e90, 7 instruction(s), ends with jge to 0x00430eef (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00430e9e
    movsx edx, word ptr [ebp + arg_8]            # 00430ea2
    imul edx, edx, 0x8d                          # 00430ea6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00430eac
    movsx edx, word ptr [eax + field_21]         # 00430eb2
    {load} cmp ecx, edx                          # 00430eb6
    jge.d8 L_00430eef                            # 00430eb8
    # block 0x00430eba: entered by fall-through of jge at 0x00430eb8, 9 instruction(s), ends with je to 0x00430eed (forward)
    movsx eax, word ptr [ebp - local_8]          # 00430eba
    movsx ecx, word ptr [ebp + arg_8]            # 00430ebe
    imul ecx, ecx, 0x8d                          # 00430ec2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430ec8
    movsx ecx, word ptr [ebp - local_8]          # 00430ece
    {load} xor ebx, ebx                          # 00430ed2
    mov bl, byte ptr [edx + ecx + field_265]     # 00430ed4
    cmp dword ptr [4*eax + 0x5b516b], ebx        # 00430edb
    je.d8 L_00430eed                             # 00430ee2
    # block 0x00430ee4: entered by fall-through of je at 0x00430ee2, 2 instruction(s), ends with forward jump to 0x00430eef
    mov byte ptr [0x5b51b9], 0x0                 # 00430ee4
    jmp.d8 L_00430eef                            # 00430eeb
L_00430eed:
    # block 0x00430eed: entered by je at 0x00430ee2, 1 instruction(s), ends with backward jump to 0x00430e92
    jmp.d8 L_00430e92                            # 00430eed
L_00430eef:
    # block 0x00430eef: entered by jge at 0x00430eb8; jmp at 0x00430eeb, 4 instruction(s), ends with je to 0x00430f0a (forward)
    {load} xor edx, edx                          # 00430eef
    mov dl, byte ptr [0x5b51b9]                  # 00430ef1
    test edx, edx                                # 00430ef7
    je.d8 L_00430f0a                             # 00430ef9
    # block 0x00430efb: entered by fall-through of je at 0x00430ef9, 2 instruction(s), ends with forward jump to 0x00431097
    mov dword ptr [0x5b51b5], 0x1                # 00430efb
    jmp.d32 L_00431097                           # 00430f05
L_00430f0a:
    # block 0x00430f0a: entered by je at 0x00430ef9, 1 instruction(s), ends with forward jump to 0x00431097
    jmp.d32 L_00431097                           # 00430f0a
L_00430f0f:
    # block 0x00430f0f: entered by switch case, 6 instruction(s), ends with je to 0x00430f61 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00430f0f
    imul eax, eax, 0x8d                          # 00430f13
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430f19
    movsx edx, word ptr [ecx + field_2b8]        # 00430f1f
    cmp edx, -0x1                                # 00430f26
    je.d8 L_00430f61                             # 00430f29
    # block 0x00430f2b: entered by fall-through of je at 0x00430f29, 10 instruction(s), falls into the block at 0x00430f61
    movsx eax, word ptr [ebp + arg_8]            # 00430f2b
    imul eax, eax, 0x8d                          # 00430f2f
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430f35
    {load} xor edx, edx                          # 00430f3b
    mov dl, byte ptr [ecx + field_2ba]           # 00430f3d
    movsx eax, word ptr [ebp + arg_8]            # 00430f43
    imul eax, eax, 0x8d                          # 00430f47
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430f4d
    movsx eax, word ptr [ecx + field_2b8]        # 00430f53
    mov dword ptr [4*eax + 0x585801], edx        # 00430f5a
L_00430f61:
    # block 0x00430f61: entered by je at 0x00430f29, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x00431097
    call dword ptr [0x52a23c]                    # 00430f61
    movsx ecx, word ptr [ebp + arg_8]            # 00430f67
    imul ecx, ecx, 0x8d                          # 00430f6b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430f71
    movsx ecx, word ptr [edx + field_2bb]        # 00430f77
    imul ecx, ecx, 0x3e8                         # 00430f7e
    {load} add eax, ecx                          # 00430f84
    mov dword ptr [0x5b51b1], eax                # 00430f86
    mov dword ptr [0x5b51b5], 0x2                # 00430f8b
    jmp.d32 L_00431097                           # 00430f95
L_00430f9a:
    # block 0x00430f9a: entered by switch case, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00431035 (forward)
    call dword ptr [0x52a23c]                    # 00430f9a
    cmp eax, dword ptr [0x5b51b1]                # 00430fa0
    jb.d32 L_00431035                            # 00430fa6
    # block 0x00430fac: entered by fall-through of jb at 0x00430fa6, 9 instruction(s), ends with je to 0x00431021 (forward)
    mov edi, 0x545c84                            # 00430fac
    movsx edx, word ptr [ebp + arg_8]            # 00430fb1
    imul edx, edx, 0x8d                          # 00430fb5
    mov esi, dword ptr [edx + 0x5bb5e5]          # 00430fbb
    add esi, 0x2bd                               # 00430fc1
    mov ecx, 0x9                                 # 00430fc7
    {load} xor eax, eax                          # 00430fcc
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00430fce
    je.d8 L_00431021                             # 00430fd0
    # block 0x00430fd2: entered by fall-through of je at 0x00430fd0, 16 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00431035
    movsx ecx, word ptr [ebp + arg_8]            # 00430fd2
    imul ecx, ecx, 0x8d                          # 00430fd6
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00430fdc
    add edx, 0x2bd                               # 00430fe2
    push edx                                     # 00430fe8
    mov ecx, 0x5c3a67                            # 00430fe9
    call FUN_004fb77a                            # 00430fee
    movsx eax, word ptr [ebp + arg_8]            # 00430ff3
    imul eax, eax, 0x8d                          # 00430ff7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00430ffd
    mov dx, word ptr [ecx + field_2de]           # 00431003
    push edx                                     # 0043100a
    mov ecx, 0x5c3a67                            # 0043100b
    call FUN_004fb2e3                            # 00431010
    mov dword ptr [0x5b51b5], 0x3                # 00431015
    jmp.d8 L_00431035                            # 0043101f
L_00431021:
    # block 0x00431021: entered by je at 0x00430fd0, 3 instruction(s), falls into the block at 0x00431035
    movsx eax, word ptr [ebp + arg_8]            # 00431021
    imul eax, eax, 0x8d                          # 00431025
    mov dword ptr [eax + 0x5bb632], 0x2          # 0043102b
L_00431035:
    # block 0x00431035: entered by jb at 0x00430fa6; jmp at 0x0043101f, 1 instruction(s), ends with forward jump to 0x00431097
    jmp.d8 L_00431097                            # 00431035
L_00431037:
    # block 0x00431037: entered by switch case, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x00431097 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00431037
    imul ecx, ecx, 0x8d                          # 0043103b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431041
    movsx eax, word ptr [edx + field_2de]        # 00431047
    mov dword ptr [ebp - local_c], eax           # 0043104e
    mov ecx, dword ptr [ebp - local_c]           # 00431051
    push ecx                                     # 00431054
    mov ecx, 0x5cf1eb                            # 00431055
    call FUN_004f6334                            # 0043105a
    test eax, eax                                # 0043105f
    jne.d8 L_00431097                            # 00431061
    # block 0x00431063: entered by fall-through of jne at 0x00431061, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x00431097
    movsx edx, word ptr [ebp + arg_8]            # 00431063
    imul edx, edx, 0x8d                          # 00431067
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043106d
    add eax, 0x2bd                               # 00431073
    push eax                                     # 00431078
    mov ecx, 0x5c3a67                            # 00431079
    call FUN_004fba69                            # 0043107e
    movsx ecx, word ptr [ebp + arg_8]            # 00431083
    imul ecx, ecx, 0x8d                          # 00431087
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0043108d
L_00431097:
    # block 0x00431097: entered by ja at 0x00430e73; jmp at 0x00430f05; jmp at 0x00430f0a; jmp at 0x00430f95; more, 1 instruction(s), ends with forward jump to 0x004313cc
    jmp.d32 L_004313cc                           # 00431097
L_0043109c:
    # block 0x0043109c: entered by je at 0x00430cd0, 15 instruction(s), calls FUN_004c2dfb, ends with je to 0x0043110d (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0043109c
    mov byte ptr [0x5b51ab], 0x0                 # 004310a6
    push 0x5d03d3                                # 004310ad
    mov ecx, 0x5cf659                            # 004310b2
    call FUN_004c2dfb                            # 004310b7
    mov dword ptr [0x5d1ad9], 0x0                # 004310bc
    mov edi, 0x545c90                            # 004310c6
    movsx edx, word ptr [ebp + arg_8]            # 004310cb
    imul edx, edx, 0x8d                          # 004310cf
    mov esi, dword ptr [edx + 0x5bb5e5]          # 004310d5
    add esi, 0x271                               # 004310db
    mov ecx, 0x9                                 # 004310e1
    {load} xor eax, eax                          # 004310e6
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004310e8
    je.d8 L_0043110d                             # 004310ea
    # block 0x004310ec: entered by fall-through of je at 0x004310ea, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x0043110d
    movsx ecx, word ptr [ebp + arg_8]            # 004310ec
    imul ecx, ecx, 0x8d                          # 004310f0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004310f6
    add edx, 0x271                               # 004310fc
    push edx                                     # 00431102
    mov ecx, 0x5c3a67                            # 00431103
    call FUN_004fba69                            # 00431108
L_0043110d:
    # block 0x0043110d: entered by je at 0x004310ea, 4 instruction(s), ends with je to 0x00431295 (forward)
    {load} xor eax, eax                          # 0043110d
    mov al, byte ptr [0x5b51b0]                  # 0043110f
    test eax, eax                                # 00431114
    je.d32 L_00431295                            # 00431116
    # block 0x0043111c: entered by fall-through of je at 0x00431116, 6 instruction(s), ends with je to 0x0043123e (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0043111c
    imul ecx, ecx, 0x8d                          # 00431120
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431126
    movsx eax, word ptr [edx + field_2ee]        # 0043112c
    cmp eax, 0x270f                              # 00431133
    je.d32 L_0043123e                            # 00431138
    # block 0x0043113e: entered by fall-through of je at 0x00431138, 41 instruction(s), ends with jne to 0x0043122a (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0043113e
    imul ecx, ecx, 0x8d                          # 00431142
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431148
    movsx eax, word ptr [edx + field_2ee]        # 0043114e
    mov dword ptr [0x5bb57b], eax                # 00431155
    movsx ecx, word ptr [ebp + arg_8]            # 0043115a
    imul ecx, ecx, 0x8d                          # 0043115e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431164
    mov ax, word ptr [edx + field_2f0]           # 0043116a
    mov word ptr [0x5bb599], ax                  # 00431171
    movsx ecx, word ptr [ebp + arg_8]            # 00431177
    imul ecx, ecx, 0x8d                          # 0043117b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431181
    mov ax, word ptr [edx + field_2f2]           # 00431187
    mov word ptr [0x5bb595], ax                  # 0043118e
    movsx ecx, word ptr [ebp + arg_8]            # 00431194
    imul ecx, ecx, 0x8d                          # 00431198
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043119e
    mov ax, word ptr [edx + field_2f4]           # 004311a4
    mov word ptr [0x5c39ff], ax                  # 004311ab
    movsx ecx, word ptr [ebp + arg_8]            # 004311b1
    imul ecx, ecx, 0x8d                          # 004311b5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004311bb
    mov eax, dword ptr [edx + field_2f6]         # 004311c1
    mov dword ptr [0x5bb59b], eax                # 004311c7
    movsx ecx, word ptr [ebp + arg_8]            # 004311cc
    imul ecx, ecx, 0x8d                          # 004311d0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004311d6
    mov eax, dword ptr [edx + field_2fa]         # 004311dc
    mov dword ptr [0x5bb59f], eax                # 004311e2
    movsx ecx, word ptr [ebp + arg_8]            # 004311e7
    imul ecx, ecx, 0x8d                          # 004311eb
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004311f1
    mov eax, dword ptr [edx + field_2fe]         # 004311f7
    mov dword ptr [0x5bb5a3], eax                # 004311fd
    movsx ecx, word ptr [ebp + arg_8]            # 00431202
    imul ecx, ecx, 0x8d                          # 00431206
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043120c
    movsx eax, word ptr [edx + field_302]        # 00431212
    cmp eax, 0x1                                 # 00431219
    jne.d8 L_0043122a                            # 0043121c
    # block 0x0043121e: entered by fall-through of jne at 0x0043121c, 2 instruction(s), ends with forward jump to 0x00431234
    mov dword ptr [0x5bb1ca], 0x0                # 0043121e
    jmp.d8 L_00431234                            # 00431228
L_0043122a:
    # block 0x0043122a: entered by jne at 0x0043121c, 1 instruction(s), falls into the block at 0x00431234
    mov dword ptr [0x5bb1ca], 0x1                # 0043122a
L_00431234:
    # block 0x00431234: entered by jmp at 0x00431228, 1 instruction(s), falls into the block at 0x0043123e
    mov dword ptr [0x583999], 0x4                # 00431234
L_0043123e:
    # block 0x0043123e: entered by je at 0x00431138, 6 instruction(s), ends with je to 0x00431290 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0043123e
    imul ecx, ecx, 0x8d                          # 00431242
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431248
    movsx eax, word ptr [edx + field_304]        # 0043124e
    cmp eax, -0x1                                # 00431255
    je.d8 L_00431290                             # 00431258
    # block 0x0043125a: entered by fall-through of je at 0x00431258, 10 instruction(s), falls into the block at 0x00431290
    movsx ecx, word ptr [ebp + arg_8]            # 0043125a
    imul ecx, ecx, 0x8d                          # 0043125e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00431264
    {load} xor eax, eax                          # 0043126a
    mov al, byte ptr [edx + field_306]           # 0043126c
    movsx ecx, word ptr [ebp + arg_8]            # 00431272
    imul ecx, ecx, 0x8d                          # 00431276
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0043127c
    movsx ecx, word ptr [edx + field_304]        # 00431282
    mov dword ptr [4*ecx + 0x585801], eax        # 00431289
L_00431290:
    # block 0x00431290: entered by je at 0x00431258, 1 instruction(s), ends with forward jump to 0x004313bf
    jmp.d32 L_004313bf                           # 00431290
L_00431295:
    # block 0x00431295: entered by je at 0x00431116, 6 instruction(s), ends with je to 0x004313bf (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00431295
    imul edx, edx, 0x8d                          # 00431299
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043129f
    movsx ecx, word ptr [eax + field_2a2]        # 004312a5
    cmp ecx, 0x270f                              # 004312ac
    je.d32 L_004313bf                            # 004312b2
    # block 0x004312b8: entered by fall-through of je at 0x004312b2, 41 instruction(s), ends with jne to 0x004313ab (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004312b8
    imul edx, edx, 0x8d                          # 004312bc
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004312c2
    movsx ecx, word ptr [eax + field_2a2]        # 004312c8
    mov dword ptr [0x5bb57b], ecx                # 004312cf
    movsx edx, word ptr [ebp + arg_8]            # 004312d5
    imul edx, edx, 0x8d                          # 004312d9
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004312df
    mov cx, word ptr [eax + field_2a4]           # 004312e5
    mov word ptr [0x5bb599], cx                  # 004312ec
    movsx edx, word ptr [ebp + arg_8]            # 004312f3
    imul edx, edx, 0x8d                          # 004312f7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004312fd
    mov cx, word ptr [eax + field_2a6]           # 00431303
    mov word ptr [0x5bb595], cx                  # 0043130a
    movsx edx, word ptr [ebp + arg_8]            # 00431311
    imul edx, edx, 0x8d                          # 00431315
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043131b
    mov cx, word ptr [eax + field_2a8]           # 00431321
    mov word ptr [0x5c39ff], cx                  # 00431328
    movsx edx, word ptr [ebp + arg_8]            # 0043132f
    imul edx, edx, 0x8d                          # 00431333
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431339
    mov ecx, dword ptr [eax + field_2aa]         # 0043133f
    mov dword ptr [0x5bb59b], ecx                # 00431345
    movsx edx, word ptr [ebp + arg_8]            # 0043134b
    imul edx, edx, 0x8d                          # 0043134f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431355
    mov ecx, dword ptr [eax + field_2ae]         # 0043135b
    mov dword ptr [0x5bb59f], ecx                # 00431361
    movsx edx, word ptr [ebp + arg_8]            # 00431367
    imul edx, edx, 0x8d                          # 0043136b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00431371
    mov ecx, dword ptr [eax + field_2b2]         # 00431377
    mov dword ptr [0x5bb5a3], ecx                # 0043137d
    movsx edx, word ptr [ebp + arg_8]            # 00431383
    imul edx, edx, 0x8d                          # 00431387
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043138d
    movsx ecx, word ptr [eax + field_2b6]        # 00431393
    cmp ecx, 0x1                                 # 0043139a
    jne.d8 L_004313ab                            # 0043139d
    # block 0x0043139f: entered by fall-through of jne at 0x0043139d, 2 instruction(s), ends with forward jump to 0x004313b5
    mov dword ptr [0x5bb1ca], 0x0                # 0043139f
    jmp.d8 L_004313b5                            # 004313a9
L_004313ab:
    # block 0x004313ab: entered by jne at 0x0043139d, 1 instruction(s), falls into the block at 0x004313b5
    mov dword ptr [0x5bb1ca], 0x1                # 004313ab
L_004313b5:
    # block 0x004313b5: entered by jmp at 0x004313a9, 1 instruction(s), falls into the block at 0x004313bf
    mov dword ptr [0x583999], 0x4                # 004313b5
L_004313bf:
    # block 0x004313bf: entered by jmp at 0x00431290; je at 0x004312b2, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x004313cc
    mov dx, word ptr [ebp + arg_8]               # 004313bf
    push edx                                     # 004313c3
    call FUN_0042ba3a                            # 004313c4
    add esp, 0x4                                 # 004313c9
L_004313cc:
    # block 0x004313cc: entered by jmp at 0x00430cd6; jmp at 0x00430e61; jmp at 0x00431097, 6 instruction(s), ends with ret
    pop edi                                      # 004313cc
    pop esi                                      # 004313cd
    pop ebx                                      # 004313ce
    {load} mov esp, ebp                          # 004313cf
    pop ebp                                      # 004313d1
    ret                                          # 004313d2

# --- data items (not part of the function) -------------------------
.org 0x004313d3 - 0x401000
SWTAB_004313d3:  # 4 case address(es)
    .long L_00430e83 - .text + 0x401000
    .long L_00430f0f - .text + 0x401000
    .long L_00430f9a - .text + 0x401000
    .long L_00431037 - .text + 0x401000
.set SWTAB_004313d3_VA, SWTAB_004313d3 - .text + 0x401000

