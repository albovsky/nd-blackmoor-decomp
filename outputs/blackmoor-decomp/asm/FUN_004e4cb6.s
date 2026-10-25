# FUN_004e4cb6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e4cb6
# extent:       0x004e4cb6-0x004e5f43 (4749 code bytes)
# span:         0x004e4cb6-0x004e5fdb (code 4749, tables 152, padding 0)
# sha256:       16d10c94f77c53e7438ab7f257aa802966883a93c344523235d76fa8fcd8f547
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e4cb6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_4, field_8, field_a, field_c, field_691, field_699, field_6a1, field_6a5, field_6b2, field_10d1, field_10f1, field_1473 and 15 more; [ecx + n] field_4, field_8, field_a, field_c, field_691, field_6a5, field_6b2, field_eac, field_10cd, field_10d9, field_10f5, field_10f9 and 19 more; [edx + n] field_4, field_8, field_a, field_c, field_691, field_699, field_6a1, field_6a5, field_6a7, field_6b2, field_ea8, field_10d5 and 20 more
# callees:      calls FUN_004c2dfb, FUN_004e49e2, FUN_004e35e8, FUN_004ee5cd, FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_0043dbd5, FUN_004d36ed, FUN_004ee6c7, FUN_004e303b, FUN_004e4bc4, FUN_004e29ec, FUN_004e2913 and 21 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1135 instruction(s), 72 conditional branch(es) and 3 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_691, 0x691  # offset +0x691
.equ field_699, 0x699  # offset +0x699
.equ field_6a1, 0x6a1  # offset +0x6a1
.equ field_6a5, 0x6a5  # offset +0x6a5
.equ field_6a7, 0x6a7  # offset +0x6a7
.equ field_6b2, 0x6b2  # offset +0x6b2
.equ field_ea8, 0xea8  # offset +0xea8
.equ field_eac, 0xeac  # offset +0xeac
.equ field_10cd, 0x10cd  # offset +0x10cd
.equ field_10d1, 0x10d1  # offset +0x10d1
.equ field_10d5, 0x10d5  # offset +0x10d5
.equ field_10d9, 0x10d9  # offset +0x10d9
.equ field_10f1, 0x10f1  # offset +0x10f1
.equ field_10f5, 0x10f5  # offset +0x10f5
.equ field_10f9, 0x10f9  # offset +0x10f9
.equ field_1119, 0x1119  # offset +0x1119
.equ field_1321, 0x1321  # offset +0x1321
.equ field_1329, 0x1329  # offset +0x1329
.equ field_1473, 0x1473  # offset +0x1473
.equ field_1475, 0x1475  # offset +0x1475
.equ field_1477, 0x1477  # offset +0x1477
.equ field_1c77, 0x1c77  # offset +0x1c77
.equ field_1c9a, 0x1c9a  # offset +0x1c9a
.equ field_1c9c, 0x1c9c  # offset +0x1c9c
.equ field_1c9e, 0x1c9e  # offset +0x1c9e
.equ field_1ca0, 0x1ca0  # offset +0x1ca0
.equ field_1ca2, 0x1ca2  # offset +0x1ca2
.equ field_4528, 0x4528  # offset +0x4528
.equ field_452c, 0x452c  # offset +0x452c
.equ field_4530, 0x4530  # offset +0x4530
.equ field_4534, 0x4534  # offset +0x4534
.equ field_4538, 0x4538  # offset +0x4538
.equ field_455d, 0x455d  # offset +0x455d
.equ field_456d, 0x456d  # offset +0x456d
.equ field_4577, 0x4577  # offset +0x4577
.equ field_4579, 0x4579  # offset +0x4579
.equ field_53bd, 0x53bd  # offset +0x53bd
.equ field_53bf, 0x53bf  # offset +0x53bf
.equ field_53c1, 0x53c1  # offset +0x53c1
.equ field_53db, 0x53db  # offset +0x53db
.equ field_65cc, 0x65cc  # offset +0x65cc
.equ field_65d2, 0x65d2  # offset +0x65d2

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004e0559, .text + (0x004e0559 - 0x401000)
.set FUN_004e2913, .text + (0x004e2913 - 0x401000)
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)
.set FUN_004e29ec, .text + (0x004e29ec - 0x401000)
.set FUN_004e303b, .text + (0x004e303b - 0x401000)
.set FUN_004e35e8, .text + (0x004e35e8 - 0x401000)
.set FUN_004e364a, .text + (0x004e364a - 0x401000)
.set FUN_004e3691, .text + (0x004e3691 - 0x401000)
.set FUN_004e36fc, .text + (0x004e36fc - 0x401000)
.set FUN_004e3772, .text + (0x004e3772 - 0x401000)
.set FUN_004e37bd, .text + (0x004e37bd - 0x401000)
.set FUN_004e3833, .text + (0x004e3833 - 0x401000)
.set FUN_004e3a64, .text + (0x004e3a64 - 0x401000)
.set FUN_004e3cd7, .text + (0x004e3cd7 - 0x401000)
.set FUN_004e3ede, .text + (0x004e3ede - 0x401000)
.set FUN_004e40a6, .text + (0x004e40a6 - 0x401000)
.set FUN_004e45be, .text + (0x004e45be - 0x401000)
.set FUN_004e498d, .text + (0x004e498d - 0x401000)
.set FUN_004e49e2, .text + (0x004e49e2 - 0x401000)
.set FUN_004e4a3a, .text + (0x004e4a3a - 0x401000)
.set FUN_004e4bc4, .text + (0x004e4bc4 - 0x401000)
.set FUN_004e7512, .text + (0x004e7512 - 0x401000)
.set FUN_004ee5cd, .text + (0x004ee5cd - 0x401000)
.set FUN_004ee5f2, .text + (0x004ee5f2 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e4cb6 - 0x401000
.globl FUN_004e4cb6
FUN_004e4cb6:
    # block 0x004e4cb6: entry, 12 instruction(s), ends with ja to 0x004e5f3c (forward)
    push ebp                                     # 004e4cb6
    {load} mov ebp, esp                          # 004e4cb7
    sub esp, 0x28                                # 004e4cb9
    push ebx                                     # 004e4cbc
    push esi                                     # 004e4cbd
    push edi                                     # 004e4cbe
    mov dword ptr [ebp - local_18], ecx          # 004e4cbf
    mov eax, dword ptr [ebp - local_18]          # 004e4cc2
    mov ecx, dword ptr [eax + field_4528]        # 004e4cc5
    mov dword ptr [ebp - local_1c], ecx          # 004e4ccb
    cmp dword ptr [ebp - local_1c], 0x5          # 004e4cce
    ja.d32 L_004e5f3c                            # 004e4cd2
    # block 0x004e4cd8: entered by fall-through of ja at 0x004e4cd2, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4e5f43]
    mov edx, dword ptr [ebp - local_1c]          # 004e4cd8
    jmp dword ptr [4*edx + SWTAB_004e5f43_VA]    # 004e4cdb
L_004e4ce2:
    # block 0x004e4ce2: entered by switch case, 2 instruction(s), ends with je to 0x004e4cfa (forward)
    cmp dword ptr [0x5d039f], 0x0                # 004e4ce2
    je.d8 L_004e4cfa                             # 004e4ce9
    # block 0x004e4ceb: entered by fall-through of je at 0x004e4ce9, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e4cfa
    push 0x5d039f                                # 004e4ceb
    mov ecx, 0x5cf659                            # 004e4cf0
    call FUN_004c2dfb                            # 004e4cf5
L_004e4cfa:
    # block 0x004e4cfa: entered by je at 0x004e4ce9, 17 instruction(s), calls FUN_004e49e2, FUN_004e35e8, FUN_004ee5cd, ends with jne to 0x004e4d62 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e4cfa
    mov dword ptr [eax + field_4538], 0x0        # 004e4cfd
    mov ecx, dword ptr [ebp - local_18]          # 004e4d07
    mov word ptr [ecx + field_456d], 0xffff      # 004e4d0a
    mov dword ptr [0x5bb22a], 0x0                # 004e4d13
    mov edx, dword ptr [ebp - local_18]          # 004e4d1d
    mov dword ptr [edx + field_4530], 0x0        # 004e4d20
    mov eax, dword ptr [ebp - local_18]          # 004e4d2a
    mov dword ptr [eax + field_65d2], 0x0        # 004e4d2d
    mov ecx, dword ptr [ebp - local_18]          # 004e4d37
    call FUN_004e49e2                            # 004e4d3a
    mov ecx, dword ptr [ebp - local_18]          # 004e4d3f
    call FUN_004e35e8                            # 004e4d42
    mov ecx, dword ptr [ebp - local_18]          # 004e4d47
    call FUN_004ee5cd                            # 004e4d4a
    test eax, eax                                # 004e4d4f
    jne.d8 L_004e4d62                            # 004e4d51
    # block 0x004e4d53: entered by fall-through of jne at 0x004e4d51, 3 instruction(s), ends with forward jump to 0x004e4d6f
    mov ecx, dword ptr [ebp - local_18]          # 004e4d53
    mov dword ptr [ecx + field_4528], 0x4        # 004e4d56
    jmp.d8 L_004e4d6f                            # 004e4d60
L_004e4d62:
    # block 0x004e4d62: entered by jne at 0x004e4d51, 2 instruction(s), falls into the block at 0x004e4d6f
    mov edx, dword ptr [ebp - local_18]          # 004e4d62
    mov dword ptr [edx + field_4528], 0x5        # 004e4d65
L_004e4d6f:
    # block 0x004e4d6f: entered by jmp at 0x004e4d60, 1 instruction(s), ends with forward jump to 0x004e5f3c
    jmp.d32 L_004e5f3c                           # 004e4d6f
L_004e4d74:
    # block 0x004e4d74: entered by switch case, 4 instruction(s), calls FUN_004ee5cd, ends with je to 0x004e4deb (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e4d74
    call FUN_004ee5cd                            # 004e4d77
    test eax, eax                                # 004e4d7c
    je.d8 L_004e4deb                             # 004e4d7e
    # block 0x004e4d80: entered by fall-through of je at 0x004e4d7e, 4 instruction(s), calls FUN_004ee5f2, ends with je to 0x004e4dde (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e4d80
    call FUN_004ee5f2                            # 004e4d83
    cmp eax, 0x4                                 # 004e4d88
    je.d8 L_004e4dde                             # 004e4d8b
    # block 0x004e4d8d: entered by fall-through of je at 0x004e4d8b, 13 instruction(s), calls FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, ends with je to 0x004e4dcf (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e4d8d
    call FUN_004ee5f2                            # 004e4d90
    push eax                                     # 004e4d95
    push 0x55c110                                # 004e4d96
    push 0x63888b                                # 004e4d9b
    call FUN_0050ca3e                            # 004e4da0
    add esp, 0xc                                 # 004e4da5
    push 0x63888b                                # 004e4da8
    mov ecx, 0x583979                            # 004e4dad
    call FUN_004264e8                            # 004e4db2
    movsx eax, word ptr [0x63a4cd]               # 004e4db7
    test eax, eax                                # 004e4dbe
    je.d8 L_004e4dcf                             # 004e4dc0
    # block 0x004e4dc2: entered by fall-through of je at 0x004e4dc0, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e4dcf
    push 0x63888b                                # 004e4dc2
    call FUN_0044a2b7                            # 004e4dc7
    add esp, 0x4                                 # 004e4dcc
L_004e4dcf:
    # block 0x004e4dcf: entered by je at 0x004e4dc0, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004e5f3c
    mov ecx, 0x5cf659                            # 004e4dcf
    call FUN_004c97b4                            # 004e4dd4
    jmp.d32 L_004e5f3c                           # 004e4dd9
L_004e4dde:
    # block 0x004e4dde: entered by je at 0x004e4d8b, 2 instruction(s), falls into the block at 0x004e4deb
    mov ecx, dword ptr [ebp - local_18]          # 004e4dde
    mov dword ptr [ecx + field_4528], 0x5        # 004e4de1
L_004e4deb:
    # block 0x004e4deb: entered by je at 0x004e4d7e, 1 instruction(s), ends with forward jump to 0x004e5f3c
    jmp.d32 L_004e5f3c                           # 004e4deb
L_004e4df0:
    # block 0x004e4df0: entered by switch case, 9 instruction(s), calls FUN_0043dbd5, FUN_004d36ed, falls into the block at 0x004e4e18
    mov edx, dword ptr [ebp - local_18]          # 004e4df0
    mov eax, dword ptr [ebp - local_18]          # 004e4df3
    mov ecx, dword ptr [eax + field_452c]        # 004e4df6
    mov dword ptr [edx + field_4528], ecx        # 004e4dfc
    call FUN_0043dbd5                            # 004e4e02
    call FUN_004d36ed                            # 004e4e07
    mov edx, dword ptr [ebp - local_18]          # 004e4e0c
    mov eax, dword ptr [edx + field_4528]        # 004e4e0f
    mov dword ptr [ebp - local_20], eax          # 004e4e15
L_004e4e18:
    # block 0x004e4e18: entered by switch case, 5 instruction(s), calls FUN_004ee6c7, ends with jne to 0x004e4e33 (forward)
    push 0x1                                     # 004e4e18
    mov ecx, dword ptr [ebp - local_18]          # 004e4e1a
    call FUN_004ee6c7                            # 004e4e1d
    test eax, eax                                # 004e4e22
    jne.d8 L_004e4e33                            # 004e4e24
    # block 0x004e4e26: entered by fall-through of jne at 0x004e4e24, 3 instruction(s), calls FUN_004e303b, ends with forward jump to 0x004e5f3c
    mov ecx, dword ptr [ebp - local_18]          # 004e4e26
    call FUN_004e303b                            # 004e4e29
    jmp.d32 L_004e5f3c                           # 004e4e2e
L_004e4e33:
    # block 0x004e4e33: entered by jne at 0x004e4e24, 6 instruction(s), calls FUN_004e4bc4, ends with jne to 0x004e572a (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e4e33
    call FUN_004e4bc4                            # 004e4e36
    mov ecx, dword ptr [ebp - local_18]          # 004e4e3b
    movsx edx, word ptr [ecx + field_6b2]        # 004e4e3e
    cmp edx, 0x270f                              # 004e4e45
    jne.d32 L_004e572a                           # 004e4e4b
    # block 0x004e4e51: entered by fall-through of jne at 0x004e4e4b, 3 instruction(s), ends with jne to 0x004e572a (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e4e51
    cmp dword ptr [eax + field_65d2], 0x0        # 004e4e54
    jne.d32 L_004e572a                           # 004e4e5b
    # block 0x004e4e61: entered by fall-through of jne at 0x004e4e5b, 2 instruction(s), ends with forward jump to 0x004e4e75
    mov word ptr [ebp - local_8], 0x0            # 004e4e61
    jmp.d8 L_004e4e75                            # 004e4e67
L_004e4e69:
    # block 0x004e4e69: entered by jmp at 0x004e4e97, 3 instruction(s), falls into the block at 0x004e4e75
    mov cx, word ptr [ebp - local_8]             # 004e4e69
    add cx, 0x1                                  # 004e4e6d
    mov word ptr [ebp - local_8], cx             # 004e4e71
L_004e4e75:
    # block 0x004e4e75: entered by jmp at 0x004e4e67, 3 instruction(s), ends with jge to 0x004e4e99 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004e4e75
    cmp edx, 0x1a                                # 004e4e79
    jge.d8 L_004e4e99                            # 004e4e7c
    # block 0x004e4e7e: entered by fall-through of jge at 0x004e4e7c, 6 instruction(s), calls FUN_004e29ec, ends with backward jump to 0x004e4e69
    movsx eax, word ptr [ebp - local_8]          # 004e4e7e
    imul eax, eax, 0x18f                         # 004e4e82
    mov ecx, dword ptr [ebp - local_18]          # 004e4e88
    lea ecx, [ecx + eax + field_1ca2]            # 004e4e8b
    call FUN_004e29ec                            # 004e4e92
    jmp.d8 L_004e4e69                            # 004e4e97
L_004e4e99:
    # block 0x004e4e99: entered by jge at 0x004e4e7c, 2 instruction(s), ends with forward jump to 0x004e4ead
    mov word ptr [ebp - local_8], 0x0            # 004e4e99
    jmp.d8 L_004e4ead                            # 004e4e9f
L_004e4ea1:
    # block 0x004e4ea1: entered by jmp at 0x004e5725, 3 instruction(s), falls into the block at 0x004e4ead
    mov dx, word ptr [ebp - local_8]             # 004e4ea1
    add dx, 0x1                                  # 004e4ea5
    mov word ptr [ebp - local_8], dx             # 004e4ea9
L_004e4ead:
    # block 0x004e4ead: entered by jmp at 0x004e4e9f, 3 instruction(s), ends with jge to 0x004e572a (forward)
    movsx eax, word ptr [ebp - local_8]          # 004e4ead
    cmp eax, 0x1a                                # 004e4eb1
    jge.d32 L_004e572a                           # 004e4eb4
    # block 0x004e4eba: entered by fall-through of jge at 0x004e4eb4, 7 instruction(s), calls FUN_004e2913, ends with je to 0x004e5725 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e4eba
    imul ecx, ecx, 0x18f                         # 004e4ebe
    mov edx, dword ptr [ebp - local_18]          # 004e4ec4
    lea ecx, [edx + ecx + field_1ca2]            # 004e4ec7
    call FUN_004e2913                            # 004e4ece
    test eax, eax                                # 004e4ed3
    je.d32 L_004e5725                            # 004e4ed5
    # block 0x004e4edb: entered by fall-through of je at 0x004e4ed5, 7 instruction(s), ends with ja to 0x004e55fa (forward)
    movsx eax, word ptr [ebp - local_8]          # 004e4edb
    mov dword ptr [ebp - local_24], eax          # 004e4edf
    mov ecx, dword ptr [ebp - local_24]          # 004e4ee2
    sub ecx, 0xa                                 # 004e4ee5
    mov dword ptr [ebp - local_24], ecx          # 004e4ee8
    cmp dword ptr [ebp - local_24], 0xf          # 004e4eeb
    ja.d32 L_004e55fa                            # 004e4eef
    # block 0x004e4ef5: entered by fall-through of ja at 0x004e4eef, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4e5f5b]
    mov edx, dword ptr [ebp - local_24]          # 004e4ef5
    jmp dword ptr [4*edx + SWTAB_004e5f5b_VA]    # 004e4ef8
L_004e4eff:
    # block 0x004e4eff: entered by switch case, 3 instruction(s), ends with jne to 0x004e4f37 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e4eff
    cmp dword ptr [eax + field_4530], 0xb        # 004e4f02
    jne.d8 L_004e4f37                            # 004e4f09
    # block 0x004e4f0b: entered by fall-through of jne at 0x004e4f09, 9 instruction(s), calls FUN_004e49e2, FUN_004e35e8, ends with forward jump to 0x004e4f44
    mov ecx, dword ptr [ebp - local_18]          # 004e4f0b
    call FUN_004e49e2                            # 004e4f0e
    mov ecx, dword ptr [ebp - local_18]          # 004e4f13
    call FUN_004e35e8                            # 004e4f16
    mov ecx, dword ptr [ebp - local_18]          # 004e4f1b
    mov dword ptr [ecx + field_691], 0x1         # 004e4f1e
    mov edx, dword ptr [ebp - local_18]          # 004e4f28
    mov dword ptr [edx + field_4530], 0x0        # 004e4f2b
    jmp.d8 L_004e4f44                            # 004e4f35
L_004e4f37:
    # block 0x004e4f37: entered by jne at 0x004e4f09, 2 instruction(s), falls into the block at 0x004e4f44
    mov eax, dword ptr [ebp - local_18]          # 004e4f37
    mov dword ptr [eax + field_4530], 0x2        # 004e4f3a
L_004e4f44:
    # block 0x004e4f44: entered by jmp at 0x004e4f35, 1 instruction(s), ends with forward jump to 0x004e5725
    jmp.d32 L_004e5725                           # 004e4f44
L_004e4f49:
    # block 0x004e4f49: entered by switch case, 32 instruction(s), calls FUN_004e49e2, FUN_004e3691, FUN_004e3cd7, ends with forward jump to 0x004e5725
    mov ecx, dword ptr [ebp - local_18]          # 004e4f49
    call FUN_004e49e2                            # 004e4f4c
    mov ecx, dword ptr [ebp - local_18]          # 004e4f51
    call FUN_004e3691                            # 004e4f54
    mov ecx, dword ptr [ebp - local_18]          # 004e4f59
    add ecx, 0xea0                               # 004e4f5c
    mov edx, dword ptr [ebp - local_18]          # 004e4f62
    add edx, 0x53d7                              # 004e4f65
    mov eax, dword ptr [ecx]                     # 004e4f6b
    mov dword ptr [edx], eax                     # 004e4f6d
    mov eax, dword ptr [ecx + field_4]           # 004e4f6f
    mov dword ptr [edx + field_4], eax           # 004e4f72
    mov eax, dword ptr [ecx + field_8]           # 004e4f75
    mov dword ptr [edx + field_8], eax           # 004e4f78
    mov ecx, dword ptr [ecx + field_c]           # 004e4f7b
    mov dword ptr [edx + field_c], ecx           # 004e4f7e
    mov edx, dword ptr [ebp - local_18]          # 004e4f81
    mov eax, dword ptr [edx + field_1119]        # 004e4f84
    add eax, 0x2                                 # 004e4f8a
    mov ecx, dword ptr [ebp - local_18]          # 004e4f8d
    mov dword ptr [ecx + field_53db], eax        # 004e4f90
    mov edx, dword ptr [ebp - local_18]          # 004e4f96
    mov dword ptr [edx + field_4530], 0xa        # 004e4f99
    mov eax, dword ptr [ebp - local_18]          # 004e4fa3
    add eax, 0xfa4                               # 004e4fa6
    push eax                                     # 004e4fab
    mov ecx, dword ptr [ebp - local_18]          # 004e4fac
    add ecx, 0x53d7                              # 004e4faf
    push ecx                                     # 004e4fb5
    mov ecx, dword ptr [ebp - local_18]          # 004e4fb6
    call FUN_004e3cd7                            # 004e4fb9
    jmp.d32 L_004e5725                           # 004e4fbe
L_004e4fc3:
    # block 0x004e4fc3: entered by switch case, 7 instruction(s), calls FUN_004e49e2, FUN_004e36fc, ends with forward jump to 0x004e5725
    mov ecx, dword ptr [ebp - local_18]          # 004e4fc3
    call FUN_004e49e2                            # 004e4fc6
    mov ecx, dword ptr [ebp - local_18]          # 004e4fcb
    call FUN_004e36fc                            # 004e4fce
    mov edx, dword ptr [ebp - local_18]          # 004e4fd3
    mov dword ptr [edx + field_4530], 0xb        # 004e4fd6
    jmp.d32 L_004e5725                           # 004e4fe0
L_004e4fe5:
    # block 0x004e4fe5: entered by switch case, 77 instruction(s), calls FUN_004e49e2, FUN_004e3691, FUN_004e0559, FUN_004e4a3a, ends with forward jump to 0x004e5725
    mov ecx, dword ptr [ebp - local_18]          # 004e4fe5
    call FUN_004e49e2                            # 004e4fe8
    mov ecx, dword ptr [ebp - local_18]          # 004e4fed
    call FUN_004e3691                            # 004e4ff0
    mov eax, dword ptr [ebp - local_18]          # 004e4ff5
    mov word ptr [eax + field_456d], 0x0         # 004e4ff8
    mov ecx, dword ptr [ebp - local_18]          # 004e5001
    add ecx, 0x1477                              # 004e5004
    mov edx, dword ptr [ebp - local_18]          # 004e500a
    add edx, 0x6a7                               # 004e500d
    mov eax, dword ptr [ecx]                     # 004e5013
    mov dword ptr [edx], eax                     # 004e5015
    mov eax, dword ptr [ecx + field_4]           # 004e5017
    mov dword ptr [edx + field_4], eax           # 004e501a
    mov ax, word ptr [ecx + field_8]             # 004e501d
    mov word ptr [edx + field_8], ax             # 004e5021
    mov cl, byte ptr [ecx + field_a]             # 004e5025
    mov byte ptr [edx + field_a], cl             # 004e5028
    mov edx, dword ptr [ebp - local_18]          # 004e502b
    mov dword ptr [edx + field_53c1], 0x1        # 004e502e
    mov eax, dword ptr [ebp - local_18]          # 004e5038
    mov word ptr [eax + field_4577], 0x0         # 004e503b
    mov ecx, dword ptr [ebp - local_18]          # 004e5044
    mov word ptr [ecx + field_4579], 0x0         # 004e5047
    mov edx, dword ptr [ebp - local_18]          # 004e5050
    add edx, 0x10ed                              # 004e5053
    mov eax, dword ptr [ebp - local_18]          # 004e5059
    add eax, 0x695                               # 004e505c
    mov ecx, dword ptr [edx]                     # 004e5061
    mov dword ptr [eax], ecx                     # 004e5063
    mov ecx, dword ptr [edx + field_4]           # 004e5065
    mov dword ptr [eax + field_4], ecx           # 004e5068
    mov ecx, dword ptr [edx + field_8]           # 004e506b
    mov dword ptr [eax + field_8], ecx           # 004e506e
    mov edx, dword ptr [edx + field_c]           # 004e5071
    mov dword ptr [eax + field_c], edx           # 004e5074
    mov eax, dword ptr [ebp - local_18]          # 004e5077
    mov ecx, dword ptr [eax + field_699]         # 004e507a
    add ecx, 0x1                                 # 004e5080
    mov edx, dword ptr [ebp - local_18]          # 004e5083
    mov dword ptr [edx + field_699], ecx         # 004e5086
    mov eax, dword ptr [ebp - local_18]          # 004e508c
    mov ecx, dword ptr [eax + field_6a1]         # 004e508f
    add ecx, 0x1                                 # 004e5095
    mov edx, dword ptr [ebp - local_18]          # 004e5098
    mov dword ptr [edx + field_6a1], ecx         # 004e509b
    mov eax, dword ptr [ebp - local_18]          # 004e50a1
    mov dword ptr [eax + field_4530], 0x9        # 004e50a4
    push 0x0                                     # 004e50ae
    push 0x0                                     # 004e50b0
    push 0x3                                     # 004e50b2
    mov ecx, 0x570508                            # 004e50b4
    call FUN_004e0559                            # 004e50b9
    mov ecx, dword ptr [ebp - local_18]          # 004e50be
    mov edx, dword ptr [ebp - local_18]          # 004e50c1
    mov eax, dword ptr [ecx + field_10f9]        # 004e50c4
    sub eax, dword ptr [edx + field_10f1]        # 004e50ca
    add eax, 0x8                                 # 004e50d0
    push eax                                     # 004e50d3
    mov ecx, dword ptr [ebp - local_18]          # 004e50d4
    mov dx, word ptr [ecx + field_eac]           # 004e50d7
    push edx                                     # 004e50de
    mov eax, dword ptr [ebp - local_18]          # 004e50df
    mov ecx, dword ptr [eax + field_10f1]        # 004e50e2
    sub ecx, 0x5                                 # 004e50e8
    push ecx                                     # 004e50eb
    mov edx, dword ptr [ebp - local_18]          # 004e50ec
    mov eax, dword ptr [edx + field_ea8]         # 004e50ef
    sub eax, 0x1e                                # 004e50f5
    push eax                                     # 004e50f8
    mov ecx, dword ptr [ebp - local_18]          # 004e50f9
    mov edx, dword ptr [ecx + field_10f5]        # 004e50fc
    add edx, 0x5                                 # 004e5102
    push edx                                     # 004e5105
    mov ecx, dword ptr [ebp - local_18]          # 004e5106
    call FUN_004e4a3a                            # 004e5109
    jmp.d32 L_004e5725                           # 004e510e
L_004e5113:
    # block 0x004e5113: entered by switch case, 3 instruction(s), ends with je to 0x004e513e (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5113
    cmp dword ptr [eax + field_4530], 0x10       # 004e5116
    je.d8 L_004e513e                             # 004e511d
    # block 0x004e511f: entered by fall-through of je at 0x004e511d, 7 instruction(s), calls FUN_004e49e2, FUN_004e35e8, ends with forward jump to 0x004e514b
    mov ecx, dword ptr [ebp - local_18]          # 004e511f
    call FUN_004e49e2                            # 004e5122
    mov ecx, dword ptr [ebp - local_18]          # 004e5127
    call FUN_004e35e8                            # 004e512a
    mov ecx, dword ptr [ebp - local_18]          # 004e512f
    mov dword ptr [ecx + field_4530], 0x0        # 004e5132
    jmp.d8 L_004e514b                            # 004e513c
L_004e513e:
    # block 0x004e513e: entered by je at 0x004e511d, 2 instruction(s), falls into the block at 0x004e514b
    mov edx, dword ptr [ebp - local_18]          # 004e513e
    mov dword ptr [edx + field_4530], 0xe        # 004e5141
L_004e514b:
    # block 0x004e514b: entered by jmp at 0x004e513c, 1 instruction(s), ends with forward jump to 0x004e5725
    jmp.d32 L_004e5725                           # 004e514b
L_004e5150:
    # block 0x004e5150: entered by switch case, 3 instruction(s), ends with jne to 0x004e5253 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5150
    cmp dword ptr [eax + field_4530], 0x9        # 004e5153
    jne.d32 L_004e5253                           # 004e515a
    # block 0x004e5160: entered by fall-through of jne at 0x004e515a, 4 instruction(s), ends with jle to 0x004e5251 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e5160
    movsx edx, word ptr [ecx + field_4577]       # 004e5163
    test edx, edx                                # 004e516a
    jle.d32 L_004e5251                           # 004e516c
    # block 0x004e5172: entered by fall-through of jle at 0x004e516c, 12 instruction(s), ends with jge to 0x004e5202 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5172
    mov cx, word ptr [eax + field_4577]          # 004e5175
    sub cx, 0x1                                  # 004e517c
    mov edx, dword ptr [ebp - local_18]          # 004e5180
    mov word ptr [edx + field_4577], cx          # 004e5183
    mov eax, dword ptr [ebp - local_18]          # 004e518a
    movsx ecx, word ptr [eax + field_4579]       # 004e518d
    mov edx, dword ptr [ebp - local_18]          # 004e5194
    movsx eax, word ptr [edx + field_53bd]       # 004e5197
    sub eax, 0x1                                 # 004e519e
    {load} cmp ecx, eax                          # 004e51a1
    jge.d8 L_004e5202                            # 004e51a3
    # block 0x004e51a5: entered by fall-through of jge at 0x004e51a3, 27 instruction(s), calls FUN_004e40a6, ends with forward jump to 0x004e5251
    mov ecx, dword ptr [ebp - local_18]          # 004e51a5
    mov dx, word ptr [ecx + field_4579]          # 004e51a8
    add dx, 0x1                                  # 004e51af
    mov eax, dword ptr [ebp - local_18]          # 004e51b3
    mov word ptr [eax + field_4579], dx          # 004e51b6
    push 0x8                                     # 004e51bd
    mov ecx, dword ptr [ebp - local_18]          # 004e51bf
    add ecx, 0x695                               # 004e51c2
    push ecx                                     # 004e51c8
    mov edx, dword ptr [ebp - local_18]          # 004e51c9
    add edx, 0x10ed                              # 004e51cc
    sub esp, 0x10                                # 004e51d2
    {load} mov eax, esp                          # 004e51d5
    mov ecx, dword ptr [edx]                     # 004e51d7
    mov dword ptr [eax], ecx                     # 004e51d9
    mov ecx, dword ptr [edx + field_4]           # 004e51db
    mov dword ptr [eax + field_4], ecx           # 004e51de
    mov ecx, dword ptr [edx + field_8]           # 004e51e1
    mov dword ptr [eax + field_8], ecx           # 004e51e4
    mov edx, dword ptr [edx + field_c]           # 004e51e7
    mov dword ptr [eax + field_c], edx           # 004e51ea
    mov eax, dword ptr [ebp - local_18]          # 004e51ed
    mov cx, word ptr [eax + field_4579]          # 004e51f0
    push ecx                                     # 004e51f7
    mov ecx, dword ptr [ebp - local_18]          # 004e51f8
    call FUN_004e40a6                            # 004e51fb
    jmp.d8 L_004e5251                            # 004e5200
L_004e5202:
    # block 0x004e5202: entered by jge at 0x004e51a3, 20 instruction(s), falls into the block at 0x004e5251
    mov edx, dword ptr [ebp - local_18]          # 004e5202
    mov ax, word ptr [edx + field_456d]          # 004e5205
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004e520c
    mov ecx, dword ptr [ebp - local_18]          # 004e5210
    mov word ptr [ecx + field_456d], ax          # 004e5213
    mov edx, dword ptr [ebp - local_18]          # 004e521a
    movsx eax, word ptr [edx + field_456d]       # 004e521d
    imul eax, eax, 0x29                          # 004e5224
    mov ecx, dword ptr [ebp - local_18]          # 004e5227
    lea edx, [ecx + eax + field_1477]            # 004e522a
    mov eax, dword ptr [ebp - local_18]          # 004e5231
    add eax, 0x6a7                               # 004e5234
    mov ecx, dword ptr [edx]                     # 004e5239
    mov dword ptr [eax], ecx                     # 004e523b
    mov ecx, dword ptr [edx + field_4]           # 004e523d
    mov dword ptr [eax + field_4], ecx           # 004e5240
    mov cx, word ptr [edx + field_8]             # 004e5243
    mov word ptr [eax + field_8], cx             # 004e5247
    mov dl, byte ptr [edx + field_a]             # 004e524b
    mov byte ptr [eax + field_a], dl             # 004e524e
L_004e5251:
    # block 0x004e5251: entered by jle at 0x004e516c; jmp at 0x004e5200, 1 instruction(s), ends with forward jump to 0x004e525d
    jmp.d8 L_004e525d                            # 004e5251
L_004e5253:
    # block 0x004e5253: entered by jne at 0x004e515a, 3 instruction(s), calls FUN_004e3ede, falls into the block at 0x004e525d
    push 0x1                                     # 004e5253
    mov ecx, dword ptr [ebp - local_18]          # 004e5255
    call FUN_004e3ede                            # 004e5258
L_004e525d:
    # block 0x004e525d: entered by jmp at 0x004e5251, 3 instruction(s), ends with forward jump to 0x004e5725
    mov eax, dword ptr [ebp - local_18]          # 004e525d
    mov dword ptr [eax + field_691], 0x1         # 004e5260
    jmp.d32 L_004e5725                           # 004e526a
L_004e526f:
    # block 0x004e526f: entered by switch case, 3 instruction(s), ends with jne to 0x004e537b (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e526f
    cmp dword ptr [ecx + field_4530], 0x9        # 004e5272
    jne.d32 L_004e537b                           # 004e5279
    # block 0x004e527f: entered by fall-through of jne at 0x004e5279, 9 instruction(s), ends with jge to 0x004e5379 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e527f
    movsx eax, word ptr [edx + field_4577]       # 004e5282
    mov ecx, dword ptr [ebp - local_18]          # 004e5289
    movsx edx, word ptr [ecx + field_53bd]       # 004e528c
    {load} add eax, edx                          # 004e5293
    mov ecx, dword ptr [ebp - local_18]          # 004e5295
    movsx edx, word ptr [ecx + field_1473]       # 004e5298
    {load} cmp eax, edx                          # 004e529f
    jge.d32 L_004e5379                           # 004e52a1
    # block 0x004e52a7: entered by fall-through of jge at 0x004e52a1, 9 instruction(s), ends with jle to 0x004e5329 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e52a7
    mov cx, word ptr [eax + field_4577]          # 004e52aa
    add cx, 0x1                                  # 004e52b1
    mov edx, dword ptr [ebp - local_18]          # 004e52b5
    mov word ptr [edx + field_4577], cx          # 004e52b8
    mov eax, dword ptr [ebp - local_18]          # 004e52bf
    movsx ecx, word ptr [eax + field_4579]       # 004e52c2
    test ecx, ecx                                # 004e52c9
    jle.d8 L_004e5329                            # 004e52cb
    # block 0x004e52cd: entered by fall-through of jle at 0x004e52cb, 27 instruction(s), calls FUN_004e40a6, ends with forward jump to 0x004e5379
    mov edx, dword ptr [ebp - local_18]          # 004e52cd
    mov ax, word ptr [edx + field_4579]          # 004e52d0
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004e52d7
    mov ecx, dword ptr [ebp - local_18]          # 004e52db
    mov word ptr [ecx + field_4579], ax          # 004e52de
    push 0x8                                     # 004e52e5
    mov edx, dword ptr [ebp - local_18]          # 004e52e7
    add edx, 0x695                               # 004e52ea
    push edx                                     # 004e52f0
    mov eax, dword ptr [ebp - local_18]          # 004e52f1
    add eax, 0x10ed                              # 004e52f4
    sub esp, 0x10                                # 004e52f9
    {load} mov ecx, esp                          # 004e52fc
    mov edx, dword ptr [eax]                     # 004e52fe
    mov dword ptr [ecx], edx                     # 004e5300
    mov edx, dword ptr [eax + field_4]           # 004e5302
    mov dword ptr [ecx + field_4], edx           # 004e5305
    mov edx, dword ptr [eax + field_8]           # 004e5308
    mov dword ptr [ecx + field_8], edx           # 004e530b
    mov eax, dword ptr [eax + field_c]           # 004e530e
    mov dword ptr [ecx + field_c], eax           # 004e5311
    mov ecx, dword ptr [ebp - local_18]          # 004e5314
    mov dx, word ptr [ecx + field_4579]          # 004e5317
    push edx                                     # 004e531e
    mov ecx, dword ptr [ebp - local_18]          # 004e531f
    call FUN_004e40a6                            # 004e5322
    jmp.d8 L_004e5379                            # 004e5327
L_004e5329:
    # block 0x004e5329: entered by jle at 0x004e52cb, 20 instruction(s), falls into the block at 0x004e5379
    mov eax, dword ptr [ebp - local_18]          # 004e5329
    mov cx, word ptr [eax + field_456d]          # 004e532c
    add cx, 0x1                                  # 004e5333
    mov edx, dword ptr [ebp - local_18]          # 004e5337
    mov word ptr [edx + field_456d], cx          # 004e533a
    mov eax, dword ptr [ebp - local_18]          # 004e5341
    movsx ecx, word ptr [eax + field_456d]       # 004e5344
    imul ecx, ecx, 0x29                          # 004e534b
    mov edx, dword ptr [ebp - local_18]          # 004e534e
    lea eax, [edx + ecx + field_1477]            # 004e5351
    mov ecx, dword ptr [ebp - local_18]          # 004e5358
    add ecx, 0x6a7                               # 004e535b
    mov edx, dword ptr [eax]                     # 004e5361
    mov dword ptr [ecx], edx                     # 004e5363
    mov edx, dword ptr [eax + field_4]           # 004e5365
    mov dword ptr [ecx + field_4], edx           # 004e5368
    mov dx, word ptr [eax + field_8]             # 004e536b
    mov word ptr [ecx + field_8], dx             # 004e536f
    mov al, byte ptr [eax + field_a]             # 004e5373
    mov byte ptr [ecx + field_a], al             # 004e5376
L_004e5379:
    # block 0x004e5379: entered by jge at 0x004e52a1; jmp at 0x004e5327, 1 instruction(s), ends with forward jump to 0x004e5385
    jmp.d8 L_004e5385                            # 004e5379
L_004e537b:
    # block 0x004e537b: entered by jne at 0x004e5279, 3 instruction(s), calls FUN_004e3ede, falls into the block at 0x004e5385
    push 0x2                                     # 004e537b
    mov ecx, dword ptr [ebp - local_18]          # 004e537d
    call FUN_004e3ede                            # 004e5380
L_004e5385:
    # block 0x004e5385: entered by jmp at 0x004e5379, 3 instruction(s), ends with forward jump to 0x004e5725
    mov ecx, dword ptr [ebp - local_18]          # 004e5385
    mov dword ptr [ecx + field_691], 0x1         # 004e5388
    jmp.d32 L_004e5725                           # 004e5392
L_004e5397:
    # block 0x004e5397: entered by switch case, 35 instruction(s), calls FUN_004e49e2, FUN_004e3833, FUN_004e0559, FUN_004e4a3a, ends with forward jump to 0x004e5725
    mov edx, dword ptr [ebp - local_18]          # 004e5397
    mov dword ptr [edx + field_4530], 0xe        # 004e539a
    mov ecx, dword ptr [ebp - local_18]          # 004e53a4
    call FUN_004e49e2                            # 004e53a7
    mov ecx, dword ptr [ebp - local_18]          # 004e53ac
    call FUN_004e3833                            # 004e53af
    mov eax, dword ptr [ebp - local_18]          # 004e53b4
    mov word ptr [eax + field_4577], 0x0         # 004e53b7
    push 0x1                                     # 004e53c0
    push 0x0                                     # 004e53c2
    push 0x3                                     # 004e53c4
    mov ecx, 0x570508                            # 004e53c6
    call FUN_004e0559                            # 004e53cb
    mov ecx, dword ptr [ebp - local_18]          # 004e53d0
    mov edx, dword ptr [ebp - local_18]          # 004e53d3
    mov eax, dword ptr [ecx + field_1329]        # 004e53d6
    sub eax, dword ptr [edx + field_1321]        # 004e53dc
    add eax, 0x1                                 # 004e53e2
    push eax                                     # 004e53e5
    mov ecx, dword ptr [ebp - local_18]          # 004e53e6
    mov dx, word ptr [ecx + field_10d9]          # 004e53e9
    push edx                                     # 004e53f0
    mov eax, dword ptr [ebp - local_18]          # 004e53f1
    mov cx, word ptr [eax + field_10d1]          # 004e53f4
    push ecx                                     # 004e53fb
    mov edx, dword ptr [ebp - local_18]          # 004e53fc
    mov ax, word ptr [edx + field_10d5]          # 004e53ff
    push eax                                     # 004e5406
    mov ecx, dword ptr [ebp - local_18]          # 004e5407
    mov edx, dword ptr [ecx + field_10cd]        # 004e540a
    add edx, 0x5                                 # 004e5410
    push edx                                     # 004e5413
    mov ecx, dword ptr [ebp - local_18]          # 004e5414
    call FUN_004e4a3a                            # 004e5417
    jmp.d32 L_004e5725                           # 004e541c
L_004e5421:
    # block 0x004e5421: entered by switch case, 10 instruction(s), calls FUN_004e49e2, FUN_004e3772, FUN_004e7512, ends with forward jump to 0x004e5725
    mov eax, dword ptr [ebp - local_18]          # 004e5421
    mov dword ptr [eax + field_4530], 0xc        # 004e5424
    mov ecx, dword ptr [ebp - local_18]          # 004e542e
    call FUN_004e49e2                            # 004e5431
    mov ecx, dword ptr [ebp - local_18]          # 004e5436
    call FUN_004e3772                            # 004e5439
    push 0x0                                     # 004e543e
    mov ecx, dword ptr [ebp - local_18]          # 004e5440
    call FUN_004e7512                            # 004e5443
    jmp.d32 L_004e5725                           # 004e5448
L_004e544d:
    # block 0x004e544d: entered by switch case, 3 instruction(s), ends with je to 0x004e5465 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e544d
    cmp dword ptr [ecx + field_4530], 0xc        # 004e5450
    je.d8 L_004e5465                             # 004e5457
    # block 0x004e5459: entered by fall-through of je at 0x004e5457, 3 instruction(s), ends with jne to 0x004e5471 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e5459
    cmp dword ptr [edx + field_4530], 0x10       # 004e545c
    jne.d8 L_004e5471                            # 004e5463
L_004e5465:
    # block 0x004e5465: entered by je at 0x004e5457; fall-through of jne at 0x004e5463, 4 instruction(s), calls FUN_004e3ede, ends with forward jump to 0x004e5497
    push 0x1                                     # 004e5465
    mov ecx, dword ptr [ebp - local_18]          # 004e5467
    call FUN_004e3ede                            # 004e546a
    jmp.d8 L_004e5497                            # 004e546f
L_004e5471:
    # block 0x004e5471: entered by jne at 0x004e5463, 4 instruction(s), ends with jle to 0x004e5497 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5471
    movsx ecx, word ptr [eax + field_4577]       # 004e5474
    test ecx, ecx                                # 004e547b
    jle.d8 L_004e5497                            # 004e547d
    # block 0x004e547f: entered by fall-through of jle at 0x004e547d, 5 instruction(s), falls into the block at 0x004e5497
    mov edx, dword ptr [ebp - local_18]          # 004e547f
    mov ax, word ptr [edx + field_4577]          # 004e5482
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004e5489
    mov ecx, dword ptr [ebp - local_18]          # 004e548d
    mov word ptr [ecx + field_4577], ax          # 004e5490
L_004e5497:
    # block 0x004e5497: entered by jmp at 0x004e546f; jle at 0x004e547d, 3 instruction(s), ends with forward jump to 0x004e5725
    mov edx, dword ptr [ebp - local_18]          # 004e5497
    mov dword ptr [edx + field_691], 0x1         # 004e549a
    jmp.d32 L_004e5725                           # 004e54a4
L_004e54a9:
    # block 0x004e54a9: entered by switch case, 3 instruction(s), ends with jne to 0x004e54f0 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e54a9
    cmp dword ptr [eax + field_4530], 0xe        # 004e54ac
    jne.d8 L_004e54f0                            # 004e54b3
    # block 0x004e54b5: entered by fall-through of jne at 0x004e54b3, 8 instruction(s), ends with jge to 0x004e54ee (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e54b5
    movsx edx, word ptr [ecx + field_4577]       # 004e54b8
    mov eax, dword ptr [ebp - local_18]          # 004e54bf
    movsx ecx, word ptr [eax + field_53bd]       # 004e54c2
    {load} add edx, ecx                          # 004e54c9
    movsx eax, word ptr [0x5a1e5e]               # 004e54cb
    {load} cmp edx, eax                          # 004e54d2
    jge.d8 L_004e54ee                            # 004e54d4
    # block 0x004e54d6: entered by fall-through of jge at 0x004e54d4, 5 instruction(s), falls into the block at 0x004e54ee
    mov ecx, dword ptr [ebp - local_18]          # 004e54d6
    mov dx, word ptr [ecx + field_4577]          # 004e54d9
    add dx, 0x1                                  # 004e54e0
    mov eax, dword ptr [ebp - local_18]          # 004e54e4
    mov word ptr [eax + field_4577], dx          # 004e54e7
L_004e54ee:
    # block 0x004e54ee: entered by jge at 0x004e54d4, 1 instruction(s), ends with forward jump to 0x004e5559
    jmp.d8 L_004e5559                            # 004e54ee
L_004e54f0:
    # block 0x004e54f0: entered by jne at 0x004e54b3, 3 instruction(s), ends with jne to 0x004e5537 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e54f0
    cmp dword ptr [ecx + field_4530], 0xd        # 004e54f3
    jne.d8 L_004e5537                            # 004e54fa
    # block 0x004e54fc: entered by fall-through of jne at 0x004e54fa, 8 instruction(s), ends with jge to 0x004e5535 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e54fc
    movsx eax, word ptr [edx + field_4577]       # 004e54ff
    mov ecx, dword ptr [ebp - local_18]          # 004e5506
    movsx edx, word ptr [ecx + field_53bd]       # 004e5509
    {load} add eax, edx                          # 004e5510
    movsx ecx, word ptr [0x5a1e60]               # 004e5512
    {load} cmp eax, ecx                          # 004e5519
    jge.d8 L_004e5535                            # 004e551b
    # block 0x004e551d: entered by fall-through of jge at 0x004e551b, 5 instruction(s), falls into the block at 0x004e5535
    mov edx, dword ptr [ebp - local_18]          # 004e551d
    mov ax, word ptr [edx + field_4577]          # 004e5520
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e5527
    mov ecx, dword ptr [ebp - local_18]          # 004e552b
    mov word ptr [ecx + field_4577], ax          # 004e552e
L_004e5535:
    # block 0x004e5535: entered by jge at 0x004e551b, 1 instruction(s), ends with forward jump to 0x004e5559
    jmp.d8 L_004e5559                            # 004e5535
L_004e5537:
    # block 0x004e5537: entered by jne at 0x004e54fa, 3 instruction(s), ends with je to 0x004e554f (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e5537
    cmp dword ptr [edx + field_4530], 0xc        # 004e553a
    je.d8 L_004e554f                             # 004e5541
    # block 0x004e5543: entered by fall-through of je at 0x004e5541, 3 instruction(s), ends with jne to 0x004e5559 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5543
    cmp dword ptr [eax + field_4530], 0x10       # 004e5546
    jne.d8 L_004e5559                            # 004e554d
L_004e554f:
    # block 0x004e554f: entered by je at 0x004e5541; fall-through of jne at 0x004e554d, 3 instruction(s), calls FUN_004e3ede, falls into the block at 0x004e5559
    push 0x2                                     # 004e554f
    mov ecx, dword ptr [ebp - local_18]          # 004e5551
    call FUN_004e3ede                            # 004e5554
L_004e5559:
    # block 0x004e5559: entered by jmp at 0x004e54ee; jmp at 0x004e5535; jne at 0x004e554d, 3 instruction(s), ends with forward jump to 0x004e5725
    mov ecx, dword ptr [ebp - local_18]          # 004e5559
    mov dword ptr [ecx + field_691], 0x1         # 004e555c
    jmp.d32 L_004e5725                           # 004e5566
L_004e556b:
    # block 0x004e556b: entered by switch case, 35 instruction(s), calls FUN_004e49e2, FUN_004e37bd, FUN_004e0559, FUN_004e4a3a, ends with forward jump to 0x004e5725
    mov edx, dword ptr [ebp - local_18]          # 004e556b
    mov dword ptr [edx + field_4530], 0xd        # 004e556e
    mov ecx, dword ptr [ebp - local_18]          # 004e5578
    call FUN_004e49e2                            # 004e557b
    mov ecx, dword ptr [ebp - local_18]          # 004e5580
    call FUN_004e37bd                            # 004e5583
    mov eax, dword ptr [ebp - local_18]          # 004e5588
    mov word ptr [eax + field_4577], 0x0         # 004e558b
    push 0x2                                     # 004e5594
    push 0x0                                     # 004e5596
    push 0x3                                     # 004e5598
    mov ecx, 0x570508                            # 004e559a
    call FUN_004e0559                            # 004e559f
    mov ecx, dword ptr [ebp - local_18]          # 004e55a4
    mov edx, dword ptr [ebp - local_18]          # 004e55a7
    mov eax, dword ptr [ecx + field_1329]        # 004e55aa
    sub eax, dword ptr [edx + field_1321]        # 004e55b0
    add eax, 0x1                                 # 004e55b6
    push eax                                     # 004e55b9
    mov ecx, dword ptr [ebp - local_18]          # 004e55ba
    mov dx, word ptr [ecx + field_10d9]          # 004e55bd
    push edx                                     # 004e55c4
    mov eax, dword ptr [ebp - local_18]          # 004e55c5
    mov cx, word ptr [eax + field_10d1]          # 004e55c8
    push ecx                                     # 004e55cf
    mov edx, dword ptr [ebp - local_18]          # 004e55d0
    mov ax, word ptr [edx + field_10d5]          # 004e55d3
    push eax                                     # 004e55da
    mov ecx, dword ptr [ebp - local_18]          # 004e55db
    mov edx, dword ptr [ecx + field_10cd]        # 004e55de
    add edx, 0x5                                 # 004e55e4
    push edx                                     # 004e55e7
    mov ecx, dword ptr [ebp - local_18]          # 004e55e8
    call FUN_004e4a3a                            # 004e55eb
    jmp.d32 L_004e5725                           # 004e55f0
L_004e55f5:
    # block 0x004e55f5: entered by switch case, 1 instruction(s), ends with forward jump to 0x004e5725
    jmp.d32 L_004e5725                           # 004e55f5
L_004e55fa:
    # block 0x004e55fa: entered by ja at 0x004e4eef, 3 instruction(s), ends with je to 0x004e5626 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e55fa
    cmp dword ptr [eax + field_4530], 0x0        # 004e55fd
    je.d8 L_004e5626                             # 004e5604
    # block 0x004e5606: entered by fall-through of je at 0x004e5604, 3 instruction(s), ends with je to 0x004e5626 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e5606
    cmp dword ptr [ecx + field_4530], 0x1        # 004e5609
    je.d8 L_004e5626                             # 004e5610
    # block 0x004e5612: entered by fall-through of je at 0x004e5610, 4 instruction(s), calls FUN_004e364a, falls into the block at 0x004e5626
    mov edx, dword ptr [ebp - local_18]          # 004e5612
    mov word ptr [edx + field_6a5], 0x0          # 004e5615
    mov ecx, dword ptr [ebp - local_18]          # 004e561e
    call FUN_004e364a                            # 004e5621
L_004e5626:
    # block 0x004e5626: entered by je at 0x004e5604; je at 0x004e5610, 4 instruction(s), ends with jne to 0x004e5675 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5626
    movsx ecx, word ptr [eax + field_6a5]        # 004e5629
    test ecx, ecx                                # 004e5630
    jne.d8 L_004e5675                            # 004e5632
    # block 0x004e5634: entered by fall-through of jne at 0x004e5632, 15 instruction(s), calls FUN_004e2940, falls into the block at 0x004e5675
    push 0x0                                     # 004e5634
    mov ecx, dword ptr [ebp - local_18]          # 004e5636
    add ecx, 0x3403                              # 004e5639
    call FUN_004e2940                            # 004e563f
    mov edx, dword ptr [ebp - local_18]          # 004e5644
    mov dword ptr [edx + field_691], 0x1         # 004e5647
    {load} xor eax, eax                          # 004e5651
    mov ecx, dword ptr [ebp - local_18]          # 004e5653
    add ecx, 0x6a7                               # 004e5656
    mov dword ptr [ecx], eax                     # 004e565c
    mov dword ptr [ecx + field_4], eax           # 004e565e
    mov word ptr [ecx + field_8], ax             # 004e5661
    mov byte ptr [ecx + field_a], al             # 004e5665
    mov edx, dword ptr [ebp - local_18]          # 004e5668
    mov dword ptr [edx + field_53c1], 0x0        # 004e566b
L_004e5675:
    # block 0x004e5675: entered by jne at 0x004e5632, 9 instruction(s), ends with jne to 0x004e56e3 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5675
    movsx ecx, word ptr [eax + field_6a5]        # 004e5678
    mov edx, dword ptr [ebp - local_18]          # 004e567f
    mov al, byte ptr [ebp - local_8]             # 004e5682
    mov byte ptr [edx + ecx + field_6a7], al     # 004e5685
    mov ecx, dword ptr [ebp - local_18]          # 004e568c
    movsx edx, word ptr [ecx + field_6a5]        # 004e568f
    test edx, edx                                # 004e5696
    jne.d8 L_004e56e3                            # 004e5698
    # block 0x004e569a: entered by fall-through of jne at 0x004e5698, 3 instruction(s), ends with je to 0x004e56af (forward)
    movsx eax, word ptr [ebp - local_8]          # 004e569a
    cmp eax, 0x1                                 # 004e569e
    je.d8 L_004e56af                             # 004e56a1
    # block 0x004e56a3: entered by fall-through of je at 0x004e56a1, 3 instruction(s), ends with jne to 0x004e56ca (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e56a3
    cmp dword ptr [ecx + field_4534], 0x0        # 004e56a6
    jne.d8 L_004e56ca                            # 004e56ad
L_004e56af:
    # block 0x004e56af: entered by je at 0x004e56a1; fall-through of jne at 0x004e56ad, 5 instruction(s), ends with forward jump to 0x004e56e3
    mov edx, dword ptr [ebp - local_18]          # 004e56af
    mov dword ptr [edx + field_4538], 0x1        # 004e56b2
    mov eax, dword ptr [ebp - local_18]          # 004e56bc
    mov word ptr [eax + field_1c77], 0xb         # 004e56bf
    jmp.d8 L_004e56e3                            # 004e56c8
L_004e56ca:
    # block 0x004e56ca: entered by jne at 0x004e56ad, 4 instruction(s), falls into the block at 0x004e56e3
    mov ecx, dword ptr [ebp - local_18]          # 004e56ca
    mov dword ptr [ecx + field_4538], 0x0        # 004e56cd
    mov edx, dword ptr [ebp - local_18]          # 004e56d7
    mov word ptr [edx + field_1c77], 0x7         # 004e56da
L_004e56e3:
    # block 0x004e56e3: entered by jne at 0x004e5698; jmp at 0x004e56c8, 13 instruction(s), calls FUN_004e2940, falls into the block at 0x004e5725
    mov eax, dword ptr [ebp - local_18]          # 004e56e3
    mov cx, word ptr [eax + field_6a5]           # 004e56e6
    add cx, 0x1                                  # 004e56ed
    mov edx, dword ptr [ebp - local_18]          # 004e56f1
    mov word ptr [edx + field_6a5], cx           # 004e56f4
    mov eax, dword ptr [ebp - local_18]          # 004e56fb
    mov dword ptr [eax + field_4530], 0x1        # 004e56fe
    push 0x4                                     # 004e5708
    mov ecx, dword ptr [ebp - local_18]          # 004e570a
    add ecx, 0x3403                              # 004e570d
    call FUN_004e2940                            # 004e5713
    mov ecx, dword ptr [ebp - local_18]          # 004e5718
    mov dword ptr [ecx + field_691], 0x1         # 004e571b
L_004e5725:
    # block 0x004e5725: entered by je at 0x004e4ed5; jmp at 0x004e4f44; jmp at 0x004e4fbe; jmp at 0x004e4fe0; more, 1 instruction(s), ends with backward jump to 0x004e4ea1
    jmp.d32 L_004e4ea1                           # 004e5725
L_004e572a:
    # block 0x004e572a: entered by jne at 0x004e4e4b; jne at 0x004e4e5b; jge at 0x004e4eb4, 5 instruction(s), ends with ja to 0x004e5f3c (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e572a
    mov eax, dword ptr [edx + field_4530]        # 004e572d
    mov dword ptr [ebp - local_28], eax          # 004e5733
    cmp dword ptr [ebp - local_28], 0xf          # 004e5736
    ja.d32 L_004e5f3c                            # 004e573a
    # block 0x004e5740: entered by fall-through of ja at 0x004e573a, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4e5f9b]
    mov ecx, dword ptr [ebp - local_28]          # 004e5740
    jmp dword ptr [4*ecx + SWTAB_004e5f9b_VA]    # 004e5743
L_004e574a:
    # block 0x004e574a: entered by switch case, 3 instruction(s), ends with je to 0x004e5763 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e574a
    cmp dword ptr [edx + field_65d2], 0x0        # 004e574d
    je.d8 L_004e5763                             # 004e5754
    # block 0x004e5756: entered by fall-through of je at 0x004e5754, 3 instruction(s), calls FUN_004e303b, ends with forward jump to 0x004e581c
    mov ecx, dword ptr [ebp - local_18]          # 004e5756
    call FUN_004e303b                            # 004e5759
    jmp.d32 L_004e581c                           # 004e575e
L_004e5763:
    # block 0x004e5763: entered by je at 0x004e5754, 4 instruction(s), ends with je to 0x004e581c (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5763
    movsx ecx, word ptr [eax + field_6b2]        # 004e5766
    cmp ecx, 0x270f                              # 004e576d
    je.d32 L_004e581c                            # 004e5773
    # block 0x004e5779: entered by fall-through of je at 0x004e5773, 2 instruction(s), ends with jne to 0x004e581c (forward)
    cmp dword ptr [0x5a1e58], 0x0                # 004e5779
    jne.d32 L_004e581c                           # 004e5780
    # block 0x004e5786: entered by fall-through of jne at 0x004e5780, 9 instruction(s), ends with je to 0x004e580f (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e5786
    mov dword ptr [edx + field_4530], 0x2        # 004e5789
    mov edi, 0x55c17c                            # 004e5793
    mov esi, dword ptr [ebp - local_18]          # 004e5798
    add esi, 0x142f                              # 004e579b
    mov ecx, 0x9                                 # 004e57a1
    {load} xor eax, eax                          # 004e57a6
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e57a8
    je.d8 L_004e580f                             # 004e57aa
    # block 0x004e57ac: entered by fall-through of je at 0x004e57aa, 9 instruction(s), ends with je to 0x004e580f (forward)
    mov edi, dword ptr [ebp - local_18]          # 004e57ac
    add edi, 0x142f                              # 004e57af
    or ecx, -0x1                                 # 004e57b5
    {load} xor eax, eax                          # 004e57b8
    repne scasb al, byte ptr es:[edi]            # 004e57ba
    not ecx                                      # 004e57bc
    add ecx, -0x1                                # 004e57be
    test ecx, ecx                                # 004e57c1
    je.d8 L_004e580f                             # 004e57c3
    # block 0x004e57c5: entered by fall-through of je at 0x004e57c3, 18 instruction(s), calls FUN_004e498d, FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004e581c
    mov ecx, dword ptr [ebp - local_18]          # 004e57c5
    add ecx, 0x142f                              # 004e57c8
    push ecx                                     # 004e57ce
    mov ecx, dword ptr [ebp - local_18]          # 004e57cf
    call FUN_004e498d                            # 004e57d2
    mov edx, dword ptr [ebp - local_18]          # 004e57d7
    add edx, 0x453c                              # 004e57da
    push edx                                     # 004e57e0
    mov ecx, 0x5c3a67                            # 004e57e1
    call FUN_004fb77a                            # 004e57e6
    mov eax, dword ptr [ebp - local_18]          # 004e57eb
    mov cx, word ptr [eax + field_455d]          # 004e57ee
    push ecx                                     # 004e57f5
    mov ecx, 0x5c3a67                            # 004e57f6
    call FUN_004fb2e3                            # 004e57fb
    mov edx, dword ptr [ebp - local_18]          # 004e5800
    mov dword ptr [edx + field_4530], 0x5        # 004e5803
    jmp.d8 L_004e581c                            # 004e580d
L_004e580f:
    # block 0x004e580f: entered by je at 0x004e57aa; je at 0x004e57c3, 2 instruction(s), falls into the block at 0x004e581c
    mov eax, dword ptr [ebp - local_18]          # 004e580f
    mov dword ptr [eax + field_4530], 0x6        # 004e5812
L_004e581c:
    # block 0x004e581c: entered by jmp at 0x004e575e; je at 0x004e5773; jne at 0x004e5780; jmp at 0x004e580d, 1 instruction(s), ends with forward jump to 0x004e5f3c
    jmp.d32 L_004e5f3c                           # 004e581c
L_004e5821:
    # block 0x004e5821: entered by switch case, 4 instruction(s), ends with jle to 0x004e590e (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e5821
    movsx edx, word ptr [ecx + field_6a5]        # 004e5824
    test edx, edx                                # 004e582b
    jle.d32 L_004e590e                           # 004e582d
    # block 0x004e5833: entered by fall-through of jle at 0x004e582d, 3 instruction(s), ends with jne to 0x004e590e (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5833
    cmp dword ptr [eax + field_4538], 0x0        # 004e5836
    jne.d32 L_004e590e                           # 004e583d
    # block 0x004e5843: entered by fall-through of jne at 0x004e583d, 2 instruction(s), ends with forward jump to 0x004e5857
    mov word ptr [ebp - local_8], 0x0            # 004e5843
    jmp.d8 L_004e5857                            # 004e5849
L_004e584b:
    # block 0x004e584b: entered by jmp at 0x004e5909, 3 instruction(s), falls into the block at 0x004e5857
    mov cx, word ptr [ebp - local_8]             # 004e584b
    add cx, 0x1                                  # 004e584f
    mov word ptr [ebp - local_8], cx             # 004e5853
L_004e5857:
    # block 0x004e5857: entered by jmp at 0x004e5849, 5 instruction(s), ends with jge to 0x004e590e (forward)
    movsx edx, word ptr [ebp - local_8]          # 004e5857
    mov eax, dword ptr [ebp - local_18]          # 004e585b
    movsx ecx, word ptr [eax + field_1473]       # 004e585e
    {load} cmp edx, ecx                          # 004e5865
    jge.d32 L_004e590e                           # 004e5867
    # block 0x004e586d: entered by fall-through of jge at 0x004e5867, 2 instruction(s), ends with forward jump to 0x004e5881
    mov word ptr [ebp - local_4], 0x0            # 004e586d
    jmp.d8 L_004e5881                            # 004e5873
L_004e5875:
    # block 0x004e5875: entered by jmp at 0x004e5904, 3 instruction(s), falls into the block at 0x004e5881
    mov dx, word ptr [ebp - local_4]             # 004e5875
    add dx, 0x1                                  # 004e5879
    mov word ptr [ebp - local_4], dx             # 004e587d
L_004e5881:
    # block 0x004e5881: entered by jmp at 0x004e5873, 3 instruction(s), ends with jge to 0x004e5909 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e5881
    cmp eax, 0x7                                 # 004e5885
    jge.d8 L_004e5909                            # 004e5888
    # block 0x004e588a: entered by fall-through of jge at 0x004e5888, 11 instruction(s), ends with je to 0x004e58c6 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e588a
    imul ecx, ecx, 0x29                          # 004e588e
    movsx edx, word ptr [ebp - local_4]          # 004e5891
    {load} xor eax, eax                          # 004e5895
    mov al, byte ptr [ecx + edx + 0x5a1e64]      # 004e5897
    movsx ecx, word ptr [ebp - local_4]          # 004e589e
    mov edx, dword ptr [ebp - local_18]          # 004e58a2
    {load} xor ebx, ebx                          # 004e58a5
    mov bl, byte ptr [edx + ecx + field_6a7]     # 004e58a7
    {load} cmp eax, ebx                          # 004e58ae
    je.d8 L_004e58c6                             # 004e58b0
    # block 0x004e58b2: entered by fall-through of je at 0x004e58b0, 4 instruction(s), ends with forward jump to 0x004e5904
    mov eax, dword ptr [ebp - local_18]          # 004e58b2
    mov word ptr [eax + field_1c77], 0x7         # 004e58b5
    mov word ptr [ebp - local_4], 0x7            # 004e58be
    jmp.d8 L_004e5904                            # 004e58c4
L_004e58c6:
    # block 0x004e58c6: entered by je at 0x004e58b0, 7 instruction(s), ends with jne to 0x004e5904 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e58c6
    imul ecx, ecx, 0x29                          # 004e58ca
    movsx edx, word ptr [ebp - local_4]          # 004e58cd
    {load} xor eax, eax                          # 004e58d1
    mov al, byte ptr [ecx + edx + 0x5a1e65]      # 004e58d3
    cmp eax, 0xa                                 # 004e58da
    jne.d8 L_004e5904                            # 004e58dd
    # block 0x004e58df: entered by fall-through of jne at 0x004e58dd, 8 instruction(s), falls into the block at 0x004e5904
    movsx ecx, word ptr [ebp - local_4]          # 004e58df
    add ecx, 0x1                                 # 004e58e3
    mov edx, dword ptr [ebp - local_18]          # 004e58e6
    mov word ptr [edx + field_1c77], cx          # 004e58e9
    mov word ptr [ebp - local_4], 0x7            # 004e58f0
    mov eax, dword ptr [ebp - local_18]          # 004e58f6
    mov cx, word ptr [eax + field_1473]          # 004e58f9
    mov word ptr [ebp - local_8], cx             # 004e5900
L_004e5904:
    # block 0x004e5904: entered by jmp at 0x004e58c4; jne at 0x004e58dd, 1 instruction(s), ends with backward jump to 0x004e5875
    jmp.d32 L_004e5875                           # 004e5904
L_004e5909:
    # block 0x004e5909: entered by jge at 0x004e5888, 1 instruction(s), ends with backward jump to 0x004e584b
    jmp.d32 L_004e584b                           # 004e5909
L_004e590e:
    # block 0x004e590e: entered by jle at 0x004e582d; jne at 0x004e583d; jge at 0x004e5867, 3 instruction(s), ends with jne to 0x004e5932 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e590e
    cmp dword ptr [edx + field_4538], 0x0        # 004e5911
    jne.d8 L_004e5932                            # 004e5918
    # block 0x004e591a: entered by fall-through of jne at 0x004e5918, 6 instruction(s), ends with jge to 0x004e594d (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e591a
    movsx ecx, word ptr [eax + field_6a5]        # 004e591d
    mov edx, dword ptr [ebp - local_18]          # 004e5924
    movsx eax, word ptr [edx + field_1c77]       # 004e5927
    {load} cmp ecx, eax                          # 004e592e
    jge.d8 L_004e594d                            # 004e5930
L_004e5932:
    # block 0x004e5932: entered by jne at 0x004e5918; fall-through of jge at 0x004e5930, 3 instruction(s), ends with jne to 0x004e595c (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e5932
    cmp dword ptr [ecx + field_4538], 0x1        # 004e5935
    jne.d8 L_004e595c                            # 004e593c
    # block 0x004e593e: entered by fall-through of jne at 0x004e593c, 4 instruction(s), ends with jl to 0x004e595c (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e593e
    movsx eax, word ptr [edx + field_6a5]        # 004e5941
    cmp eax, 0xb                                 # 004e5948
    jl.d8 L_004e595c                             # 004e594b
L_004e594d:
    # block 0x004e594d: entered by jge at 0x004e5930; fall-through of jl at 0x004e594b, 3 instruction(s), ends with forward jump to 0x004e59bc
    mov ecx, dword ptr [ebp - local_18]          # 004e594d
    mov dword ptr [ecx + field_4530], 0x2        # 004e5950
    jmp.d8 L_004e59bc                            # 004e595a
L_004e595c:
    # block 0x004e595c: entered by jne at 0x004e593c; jl at 0x004e594b, 4 instruction(s), ends with jle to 0x004e59b7 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e595c
    movsx eax, word ptr [edx + field_6a5]        # 004e595f
    cmp eax, 0xb                                 # 004e5966
    jle.d8 L_004e59b7                            # 004e5969
    # block 0x004e596b: entered by fall-through of jle at 0x004e5969, 16 instruction(s), ends with forward jump to 0x004e59bc
    mov ecx, dword ptr [ebp - local_18]          # 004e596b
    mov word ptr [ecx + field_6a5], 0x0          # 004e596e
    mov edx, dword ptr [ebp - local_18]          # 004e5977
    mov dword ptr [edx + field_691], 0x1         # 004e597a
    {load} xor eax, eax                          # 004e5984
    mov ecx, dword ptr [ebp - local_18]          # 004e5986
    add ecx, 0x6a7                               # 004e5989
    mov dword ptr [ecx], eax                     # 004e598f
    mov dword ptr [ecx + field_4], eax           # 004e5991
    mov word ptr [ecx + field_8], ax             # 004e5994
    mov byte ptr [ecx + field_a], al             # 004e5998
    mov edx, dword ptr [ebp - local_18]          # 004e599b
    mov dword ptr [edx + field_53c1], 0x0        # 004e599e
    mov eax, dword ptr [ebp - local_18]          # 004e59a8
    mov dword ptr [eax + field_4530], 0x0        # 004e59ab
    jmp.d8 L_004e59bc                            # 004e59b5
L_004e59b7:
    # block 0x004e59b7: entered by jle at 0x004e5969, 1 instruction(s), ends with forward jump to 0x004e5f3c
    jmp.d32 L_004e5f3c                           # 004e59b7
L_004e59bc:
    # block 0x004e59bc: entered by jmp at 0x004e595a; jmp at 0x004e59b5; switch case, 19 instruction(s), calls FUN_004e2940, ends with je to 0x004e5a67 (forward)
    push 0x4                                     # 004e59bc
    mov ecx, dword ptr [ebp - local_18]          # 004e59be
    add ecx, 0x3403                              # 004e59c1
    call FUN_004e2940                            # 004e59c7
    push 0x4                                     # 004e59cc
    mov ecx, dword ptr [ebp - local_18]          # 004e59ce
    add ecx, 0x3721                              # 004e59d1
    call FUN_004e2940                            # 004e59d7
    push 0x4                                     # 004e59dc
    mov ecx, dword ptr [ebp - local_18]          # 004e59de
    add ecx, 0x38b0                              # 004e59e1
    call FUN_004e2940                            # 004e59e7
    mov edi, 0x55c188                            # 004e59ec
    mov esi, dword ptr [ebp - local_18]          # 004e59f1
    add esi, 0x140e                              # 004e59f4
    mov ecx, 0x9                                 # 004e59fa
    {load} xor edx, edx                          # 004e59ff
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e5a01
    je.d8 L_004e5a67                             # 004e5a03
    # block 0x004e5a05: entered by fall-through of je at 0x004e5a03, 9 instruction(s), ends with je to 0x004e5a67 (forward)
    mov edi, dword ptr [ebp - local_18]          # 004e5a05
    add edi, 0x140e                              # 004e5a08
    or ecx, -0x1                                 # 004e5a0e
    {load} xor eax, eax                          # 004e5a11
    repne scasb al, byte ptr es:[edi]            # 004e5a13
    not ecx                                      # 004e5a15
    add ecx, -0x1                                # 004e5a17
    test ecx, ecx                                # 004e5a1a
    je.d8 L_004e5a67                             # 004e5a1c
    # block 0x004e5a1e: entered by fall-through of je at 0x004e5a1c, 18 instruction(s), calls FUN_004e498d, FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004e5a74
    mov eax, dword ptr [ebp - local_18]          # 004e5a1e
    add eax, 0x140e                              # 004e5a21
    push eax                                     # 004e5a26
    mov ecx, dword ptr [ebp - local_18]          # 004e5a27
    call FUN_004e498d                            # 004e5a2a
    mov ecx, dword ptr [ebp - local_18]          # 004e5a2f
    add ecx, 0x453c                              # 004e5a32
    push ecx                                     # 004e5a38
    mov ecx, 0x5c3a67                            # 004e5a39
    call FUN_004fb77a                            # 004e5a3e
    mov edx, dword ptr [ebp - local_18]          # 004e5a43
    mov ax, word ptr [edx + field_455d]          # 004e5a46
    push eax                                     # 004e5a4d
    mov ecx, 0x5c3a67                            # 004e5a4e
    call FUN_004fb2e3                            # 004e5a53
    mov ecx, dword ptr [ebp - local_18]          # 004e5a58
    mov dword ptr [ecx + field_4530], 0x3        # 004e5a5b
    jmp.d8 L_004e5a74                            # 004e5a65
L_004e5a67:
    # block 0x004e5a67: entered by je at 0x004e5a03; je at 0x004e5a1c, 2 instruction(s), falls into the block at 0x004e5a74
    mov edx, dword ptr [ebp - local_18]          # 004e5a67
    mov dword ptr [edx + field_4530], 0x4        # 004e5a6a
L_004e5a74:
    # block 0x004e5a74: entered by jmp at 0x004e5a65, 1 instruction(s), ends with forward jump to 0x004e5f3c
    jmp.d32 L_004e5f3c                           # 004e5a74
L_004e5a79:
    # block 0x004e5a79: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004e5ab8 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5a79
    movsx ecx, word ptr [eax + field_455d]       # 004e5a7c
    mov dword ptr [ebp - local_c], ecx           # 004e5a83
    mov edx, dword ptr [ebp - local_c]           # 004e5a86
    push edx                                     # 004e5a89
    mov ecx, 0x5cf1eb                            # 004e5a8a
    call FUN_004f6334                            # 004e5a8f
    test eax, eax                                # 004e5a94
    jne.d8 L_004e5ab8                            # 004e5a96
    # block 0x004e5a98: entered by fall-through of jne at 0x004e5a96, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x004e5ab8
    mov eax, dword ptr [ebp - local_18]          # 004e5a98
    add eax, 0x453c                              # 004e5a9b
    push eax                                     # 004e5aa0
    mov ecx, 0x5c3a67                            # 004e5aa1
    call FUN_004fba69                            # 004e5aa6
    mov ecx, dword ptr [ebp - local_18]          # 004e5aab
    mov dword ptr [ecx + field_4530], 0x4        # 004e5aae
L_004e5ab8:
    # block 0x004e5ab8: entered by jne at 0x004e5a96, 1 instruction(s), ends with forward jump to 0x004e5f3c
    jmp.d32 L_004e5f3c                           # 004e5ab8
L_004e5abd:
    # block 0x004e5abd: entered by switch case, 3 instruction(s), ends with jne to 0x004e5b14 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e5abd
    cmp dword ptr [edx + field_53c1], 0x0        # 004e5ac0
    jne.d8 L_004e5b14                            # 004e5ac7
    # block 0x004e5ac9: entered by fall-through of jne at 0x004e5ac7, 15 instruction(s), calls FUN_004e45be, ends with je to 0x004e5b08 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5ac9
    mov cx, word ptr [eax + field_1c77]          # 004e5acc
    push ecx                                     # 004e5ad3
    mov edx, dword ptr [ebp - local_18]          # 004e5ad4
    mov eax, dword ptr [edx + field_4538]        # 004e5ad7
    push eax                                     # 004e5add
    mov ecx, dword ptr [ebp - local_18]          # 004e5ade
    add ecx, 0x6a7                               # 004e5ae1
    push ecx                                     # 004e5ae7
    lea edx, [ebp - local_8]                     # 004e5ae8
    push edx                                     # 004e5aeb
    mov ecx, dword ptr [ebp - local_18]          # 004e5aec
    call FUN_004e45be                            # 004e5aef
    test eax, eax                                # 004e5af4
    je.d8 L_004e5b08                             # 004e5af6
    # block 0x004e5af8: entered by fall-through of je at 0x004e5af6, 4 instruction(s), ends with forward jump to 0x004e5b14
    mov eax, dword ptr [ebp - local_18]          # 004e5af8
    mov cx, word ptr [ebp - local_8]             # 004e5afb
    mov word ptr [eax + field_456d], cx          # 004e5aff
    jmp.d8 L_004e5b14                            # 004e5b06
L_004e5b08:
    # block 0x004e5b08: entered by je at 0x004e5af6, 2 instruction(s), falls into the block at 0x004e5b14
    mov edx, dword ptr [ebp - local_18]          # 004e5b08
    mov word ptr [edx + field_456d], 0xffff      # 004e5b0b
L_004e5b14:
    # block 0x004e5b14: entered by jne at 0x004e5ac7; jmp at 0x004e5b06, 4 instruction(s), ends with je to 0x004e5bb1 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5b14
    movsx ecx, word ptr [eax + field_456d]       # 004e5b17
    cmp ecx, -0x1                                # 004e5b1e
    je.d32 L_004e5bb1                            # 004e5b21
    # block 0x004e5b27: entered by fall-through of je at 0x004e5b21, 7 instruction(s), ends with je to 0x004e5ba2 (forward)
    mov edi, 0x55c194                            # 004e5b27
    mov esi, dword ptr [ebp - local_18]          # 004e5b2c
    add esi, 0x142f                              # 004e5b2f
    mov ecx, 0x9                                 # 004e5b35
    {load} xor edx, edx                          # 004e5b3a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e5b3c
    je.d8 L_004e5ba2                             # 004e5b3e
    # block 0x004e5b40: entered by fall-through of je at 0x004e5b3e, 9 instruction(s), ends with je to 0x004e5ba2 (forward)
    mov edi, dword ptr [ebp - local_18]          # 004e5b40
    add edi, 0x142f                              # 004e5b43
    or ecx, -0x1                                 # 004e5b49
    {load} xor eax, eax                          # 004e5b4c
    repne scasb al, byte ptr es:[edi]            # 004e5b4e
    not ecx                                      # 004e5b50
    add ecx, -0x1                                # 004e5b52
    test ecx, ecx                                # 004e5b55
    je.d8 L_004e5ba2                             # 004e5b57
    # block 0x004e5b59: entered by fall-through of je at 0x004e5b57, 18 instruction(s), calls FUN_004e498d, FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004e5baf
    mov eax, dword ptr [ebp - local_18]          # 004e5b59
    add eax, 0x142f                              # 004e5b5c
    push eax                                     # 004e5b61
    mov ecx, dword ptr [ebp - local_18]          # 004e5b62
    call FUN_004e498d                            # 004e5b65
    mov ecx, dword ptr [ebp - local_18]          # 004e5b6a
    add ecx, 0x453c                              # 004e5b6d
    push ecx                                     # 004e5b73
    mov ecx, 0x5c3a67                            # 004e5b74
    call FUN_004fb77a                            # 004e5b79
    mov edx, dword ptr [ebp - local_18]          # 004e5b7e
    mov ax, word ptr [edx + field_455d]          # 004e5b81
    push eax                                     # 004e5b88
    mov ecx, 0x5c3a67                            # 004e5b89
    call FUN_004fb2e3                            # 004e5b8e
    mov ecx, dword ptr [ebp - local_18]          # 004e5b93
    mov dword ptr [ecx + field_4530], 0x5        # 004e5b96
    jmp.d8 L_004e5baf                            # 004e5ba0
L_004e5ba2:
    # block 0x004e5ba2: entered by je at 0x004e5b3e; je at 0x004e5b57, 2 instruction(s), falls into the block at 0x004e5baf
    mov edx, dword ptr [ebp - local_18]          # 004e5ba2
    mov dword ptr [edx + field_4530], 0x6        # 004e5ba5
L_004e5baf:
    # block 0x004e5baf: entered by jmp at 0x004e5ba0, 1 instruction(s), ends with forward jump to 0x004e5bbe
    jmp.d8 L_004e5bbe                            # 004e5baf
L_004e5bb1:
    # block 0x004e5bb1: entered by je at 0x004e5b21, 2 instruction(s), falls into the block at 0x004e5bbe
    mov eax, dword ptr [ebp - local_18]          # 004e5bb1
    mov dword ptr [eax + field_4530], 0x7        # 004e5bb4
L_004e5bbe:
    # block 0x004e5bbe: entered by jmp at 0x004e5baf, 10 instruction(s), ends with forward jump to 0x004e5f3c
    mov ecx, dword ptr [ebp - local_18]          # 004e5bbe
    mov word ptr [ecx + field_6a5], 0x0          # 004e5bc1
    {load} xor edx, edx                          # 004e5bca
    mov eax, dword ptr [ebp - local_18]          # 004e5bcc
    add eax, 0x6a7                               # 004e5bcf
    mov dword ptr [eax], edx                     # 004e5bd4
    mov dword ptr [eax + field_4], edx           # 004e5bd6
    mov word ptr [eax + field_8], dx             # 004e5bd9
    mov byte ptr [eax + field_a], dl             # 004e5bdd
    jmp.d32 L_004e5f3c                           # 004e5be0
L_004e5be5:
    # block 0x004e5be5: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004e5c25 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e5be5
    movsx edx, word ptr [ecx + field_455d]       # 004e5be8
    mov dword ptr [ebp - local_10], edx          # 004e5bef
    mov eax, dword ptr [ebp - local_10]          # 004e5bf2
    push eax                                     # 004e5bf5
    mov ecx, 0x5cf1eb                            # 004e5bf6
    call FUN_004f6334                            # 004e5bfb
    test eax, eax                                # 004e5c00
    jne.d8 L_004e5c25                            # 004e5c02
    # block 0x004e5c04: entered by fall-through of jne at 0x004e5c02, 7 instruction(s), calls FUN_004fba69, falls into the block at 0x004e5c25
    mov ecx, dword ptr [ebp - local_18]          # 004e5c04
    add ecx, 0x453c                              # 004e5c07
    push ecx                                     # 004e5c0d
    mov ecx, 0x5c3a67                            # 004e5c0e
    call FUN_004fba69                            # 004e5c13
    mov edx, dword ptr [ebp - local_18]          # 004e5c18
    mov dword ptr [edx + field_4530], 0x6        # 004e5c1b
L_004e5c25:
    # block 0x004e5c25: entered by jne at 0x004e5c02, 1 instruction(s), ends with forward jump to 0x004e5f3c
    jmp.d32 L_004e5f3c                           # 004e5c25
L_004e5c2a:
    # block 0x004e5c2a: entered by switch case, 9 instruction(s), ends with je to 0x004e5cb2 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5c2a
    mov dword ptr [eax + field_53c1], 0x0        # 004e5c2d
    mov edi, 0x55c1a0                            # 004e5c37
    mov esi, dword ptr [ebp - local_18]          # 004e5c3c
    add esi, 0x1450                              # 004e5c3f
    mov ecx, 0x9                                 # 004e5c45
    {load} xor edx, edx                          # 004e5c4a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e5c4c
    je.d8 L_004e5cb2                             # 004e5c4e
    # block 0x004e5c50: entered by fall-through of je at 0x004e5c4e, 9 instruction(s), ends with je to 0x004e5cb2 (forward)
    mov edi, dword ptr [ebp - local_18]          # 004e5c50
    add edi, 0x1450                              # 004e5c53
    or ecx, -0x1                                 # 004e5c59
    {load} xor eax, eax                          # 004e5c5c
    repne scasb al, byte ptr es:[edi]            # 004e5c5e
    not ecx                                      # 004e5c60
    add ecx, -0x1                                # 004e5c62
    test ecx, ecx                                # 004e5c65
    je.d8 L_004e5cb2                             # 004e5c67
    # block 0x004e5c69: entered by fall-through of je at 0x004e5c67, 18 instruction(s), calls FUN_004e498d, FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x004e5ccf
    mov eax, dword ptr [ebp - local_18]          # 004e5c69
    add eax, 0x1450                              # 004e5c6c
    push eax                                     # 004e5c71
    mov ecx, dword ptr [ebp - local_18]          # 004e5c72
    call FUN_004e498d                            # 004e5c75
    mov ecx, dword ptr [ebp - local_18]          # 004e5c7a
    add ecx, 0x453c                              # 004e5c7d
    push ecx                                     # 004e5c83
    mov ecx, 0x5c3a67                            # 004e5c84
    call FUN_004fb77a                            # 004e5c89
    mov edx, dword ptr [ebp - local_18]          # 004e5c8e
    mov ax, word ptr [edx + field_455d]          # 004e5c91
    push eax                                     # 004e5c98
    mov ecx, 0x5c3a67                            # 004e5c99
    call FUN_004fb2e3                            # 004e5c9e
    mov ecx, dword ptr [ebp - local_18]          # 004e5ca3
    mov dword ptr [ecx + field_4530], 0x8        # 004e5ca6
    jmp.d8 L_004e5ccf                            # 004e5cb0
L_004e5cb2:
    # block 0x004e5cb2: entered by je at 0x004e5c4e; je at 0x004e5c67, 6 instruction(s), calls FUN_004e49e2, FUN_004e35e8, falls into the block at 0x004e5ccf
    mov ecx, dword ptr [ebp - local_18]          # 004e5cb2
    call FUN_004e49e2                            # 004e5cb5
    mov ecx, dword ptr [ebp - local_18]          # 004e5cba
    call FUN_004e35e8                            # 004e5cbd
    mov edx, dword ptr [ebp - local_18]          # 004e5cc2
    mov dword ptr [edx + field_4530], 0x0        # 004e5cc5
L_004e5ccf:
    # block 0x004e5ccf: entered by jmp at 0x004e5cb0, 1 instruction(s), ends with forward jump to 0x004e5f3c
    jmp.d32 L_004e5f3c                           # 004e5ccf
L_004e5cd4:
    # block 0x004e5cd4: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004e5d23 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5cd4
    movsx ecx, word ptr [eax + field_455d]       # 004e5cd7
    mov dword ptr [ebp - local_14], ecx          # 004e5cde
    mov edx, dword ptr [ebp - local_14]          # 004e5ce1
    push edx                                     # 004e5ce4
    mov ecx, 0x5cf1eb                            # 004e5ce5
    call FUN_004f6334                            # 004e5cea
    test eax, eax                                # 004e5cef
    jne.d8 L_004e5d23                            # 004e5cf1
    # block 0x004e5cf3: entered by fall-through of jne at 0x004e5cf1, 11 instruction(s), calls FUN_004fba69, FUN_004e49e2, FUN_004e35e8, falls into the block at 0x004e5d23
    mov eax, dword ptr [ebp - local_18]          # 004e5cf3
    add eax, 0x453c                              # 004e5cf6
    push eax                                     # 004e5cfb
    mov ecx, 0x5c3a67                            # 004e5cfc
    call FUN_004fba69                            # 004e5d01
    mov ecx, dword ptr [ebp - local_18]          # 004e5d06
    call FUN_004e49e2                            # 004e5d09
    mov ecx, dword ptr [ebp - local_18]          # 004e5d0e
    call FUN_004e35e8                            # 004e5d11
    mov ecx, dword ptr [ebp - local_18]          # 004e5d16
    mov dword ptr [ecx + field_4530], 0x0        # 004e5d19
L_004e5d23:
    # block 0x004e5d23: entered by jne at 0x004e5cf1, 1 instruction(s), ends with forward jump to 0x004e5f3c
    jmp.d32 L_004e5f3c                           # 004e5d23
L_004e5d28:
    # block 0x004e5d28: entered by switch case, 4 instruction(s), ends with je to 0x004e5d67 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e5d28
    movsx eax, word ptr [edx + field_6b2]        # 004e5d2b
    cmp eax, 0x270f                              # 004e5d32
    je.d8 L_004e5d67                             # 004e5d37
    # block 0x004e5d39: entered by fall-through of je at 0x004e5d37, 9 instruction(s), ends with forward jump to 0x004e5dc1
    mov ecx, dword ptr [ebp - local_18]          # 004e5d39
    mov edx, dword ptr [ebp - local_18]          # 004e5d3c
    mov ax, word ptr [edx + field_6b2]           # 004e5d3f
    mov word ptr [ecx + field_1c9a], ax          # 004e5d46
    mov ecx, dword ptr [ebp - local_18]          # 004e5d4d
    mov word ptr [ecx + field_1c9e], 0xffff      # 004e5d50
    mov edx, dword ptr [ebp - local_18]          # 004e5d59
    mov word ptr [edx + field_1c9c], 0x1         # 004e5d5c
    jmp.d8 L_004e5dc1                            # 004e5d65
L_004e5d67:
    # block 0x004e5d67: entered by je at 0x004e5d37, 3 instruction(s), ends with je to 0x004e5d9d (forward)
    mov eax, dword ptr [ebp - local_18]          # 004e5d67
    cmp dword ptr [eax + field_53c1], 0x0        # 004e5d6a
    je.d8 L_004e5d9d                             # 004e5d71
    # block 0x004e5d73: entered by fall-through of je at 0x004e5d71, 11 instruction(s), ends with forward jump to 0x004e5dc1
    mov ecx, dword ptr [ebp - local_18]          # 004e5d73
    movsx edx, word ptr [ecx + field_456d]       # 004e5d76
    imul edx, edx, 0x29                          # 004e5d7d
    mov eax, dword ptr [ebp - local_18]          # 004e5d80
    lea esi, [eax + edx + field_1475]            # 004e5d83
    mov edi, dword ptr [ebp - local_18]          # 004e5d8a
    add edi, 0x1c79                              # 004e5d8d
    mov ecx, 0xa                                 # 004e5d93
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e5d98
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e5d9a
    jmp.d8 L_004e5dc1                            # 004e5d9b
L_004e5d9d:
    # block 0x004e5d9d: entered by je at 0x004e5d71, 9 instruction(s), falls into the block at 0x004e5dc1
    mov ecx, dword ptr [ebp - local_18]          # 004e5d9d
    movsx esi, word ptr [ecx + field_456d]       # 004e5da0
    imul esi, esi, 0x29                          # 004e5da7
    add esi, 0x5a1e62                            # 004e5daa
    mov edi, dword ptr [ebp - local_18]          # 004e5db0
    add edi, 0x1c79                              # 004e5db3
    mov ecx, 0xa                                 # 004e5db9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e5dbe
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e5dc0
L_004e5dc1:
    # block 0x004e5dc1: entered by jmp at 0x004e5d65; jmp at 0x004e5d9b, 4 instruction(s), ends with je to 0x004e5e77 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e5dc1
    movsx eax, word ptr [edx + field_1c9a]       # 004e5dc4
    cmp eax, 0x270f                              # 004e5dcb
    je.d32 L_004e5e77                            # 004e5dd0
    # block 0x004e5dd6: entered by fall-through of je at 0x004e5dd0, 17 instruction(s), calls FUN_004e3a64, ends with je to 0x004e5e59 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e5dd6
    call FUN_004e3a64                            # 004e5dd9
    mov ecx, dword ptr [ebp - local_18]          # 004e5dde
    movsx edx, word ptr [ecx + field_1c9a]       # 004e5de1
    mov dword ptr [0x5bb57b], edx                # 004e5de8
    mov word ptr [0x5bb599], 0x0                 # 004e5dee
    mov word ptr [0x5bb595], 0x0                 # 004e5df7
    mov eax, dword ptr [ebp - local_18]          # 004e5e00
    mov cx, word ptr [eax + field_1c9c]          # 004e5e03
    mov word ptr [0x5c39ff], cx                  # 004e5e0a
    mov dword ptr [0x5bb59b], 0x0                # 004e5e11
    mov dword ptr [0x5bb59f], 0x0                # 004e5e1b
    mov dword ptr [0x5bb5a3], 0x1                # 004e5e25
    mov edx, dword ptr [ebp - local_18]          # 004e5e2f
    movsx eax, word ptr [edx + field_1c9e]       # 004e5e32
    cmp eax, -0x1                                # 004e5e39
    je.d8 L_004e5e59                             # 004e5e3c
    # block 0x004e5e3e: entered by fall-through of je at 0x004e5e3c, 5 instruction(s), falls into the block at 0x004e5e59
    mov ecx, dword ptr [ebp - local_18]          # 004e5e3e
    movsx edx, word ptr [ecx + field_1ca0]       # 004e5e41
    mov eax, dword ptr [ebp - local_18]          # 004e5e48
    movsx ecx, word ptr [eax + field_1c9e]       # 004e5e4b
    mov dword ptr [4*ecx + 0x585801], edx        # 004e5e52
L_004e5e59:
    # block 0x004e5e59: entered by je at 0x004e5e3c, 3 instruction(s), falls into the block at 0x004e5e77
    mov dword ptr [0x583999], 0x4                # 004e5e59
    mov dword ptr [0x583204], 0x0                # 004e5e63
    mov dword ptr [0x5bb22a], 0x1                # 004e5e6d
L_004e5e77:
    # block 0x004e5e77: entered by je at 0x004e5dd0, 18 instruction(s), calls FUN_004e49e2, FUN_004e35e8, ends with forward jump to 0x004e5f3c
    mov edx, dword ptr [ebp - local_18]          # 004e5e77
    mov word ptr [edx + field_6a5], 0x0          # 004e5e7a
    {load} xor eax, eax                          # 004e5e83
    mov ecx, dword ptr [ebp - local_18]          # 004e5e85
    add ecx, 0x6a7                               # 004e5e88
    mov dword ptr [ecx], eax                     # 004e5e8e
    mov dword ptr [ecx + field_4], eax           # 004e5e90
    mov word ptr [ecx + field_8], ax             # 004e5e93
    mov byte ptr [ecx + field_a], al             # 004e5e97
    mov edx, dword ptr [ebp - local_18]          # 004e5e9a
    mov dword ptr [edx + field_53c1], 0x0        # 004e5e9d
    mov ecx, dword ptr [ebp - local_18]          # 004e5ea7
    call FUN_004e49e2                            # 004e5eaa
    mov ecx, dword ptr [ebp - local_18]          # 004e5eaf
    call FUN_004e35e8                            # 004e5eb2
    mov eax, dword ptr [ebp - local_18]          # 004e5eb7
    mov dword ptr [eax + field_4530], 0x0        # 004e5eba
    jmp.d8 L_004e5f3c                            # 004e5ec4
L_004e5ec6:
    # block 0x004e5ec6: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004e5f3c (forward)
    call dword ptr [0x52a23c]                    # 004e5ec6
    mov ecx, dword ptr [ebp - local_18]          # 004e5ecc
    cmp eax, dword ptr [ecx + field_65cc]        # 004e5ecf
    jbe.d8 L_004e5f3c                            # 004e5ed5
    # block 0x004e5ed7: entered by fall-through of jbe at 0x004e5ed5, 2 instruction(s), ends with jne to 0x004e5f2f (forward)
    cmp dword ptr [0x5a1e58], 0x0                # 004e5ed7
    jne.d8 L_004e5f2f                            # 004e5ede
    # block 0x004e5ee0: entered by fall-through of jne at 0x004e5ede, 10 instruction(s), ends with je to 0x004e5f2f (forward)
    mov edx, dword ptr [ebp - local_18]          # 004e5ee0
    movsx eax, word ptr [edx + field_53bf]       # 004e5ee3
    imul eax, eax, 0x4a                          # 004e5eea
    mov dword ptr [eax + 0x5a26aa], 0x1          # 004e5eed
    mov ecx, dword ptr [ebp - local_18]          # 004e5ef7
    movsx edx, word ptr [ecx + field_53bf]       # 004e5efa
    imul edx, edx, 0x4a                          # 004e5f01
    movsx eax, word ptr [edx + 0x5a26a8]         # 004e5f04
    cmp eax, -0x1                                # 004e5f0b
    je.d8 L_004e5f2f                             # 004e5f0e
    # block 0x004e5f10: entered by fall-through of je at 0x004e5f0e, 5 instruction(s), falls into the block at 0x004e5f2f
    mov ecx, dword ptr [ebp - local_18]          # 004e5f10
    movsx edx, word ptr [ecx + field_53bf]       # 004e5f13
    imul edx, edx, 0x4a                          # 004e5f1a
    movsx eax, word ptr [edx + 0x5a26a8]         # 004e5f1d
    mov dword ptr [4*eax + 0x585801], 0x1        # 004e5f24
L_004e5f2f:
    # block 0x004e5f2f: entered by jne at 0x004e5ede; je at 0x004e5f0e, 2 instruction(s), falls into the block at 0x004e5f3c
    mov ecx, dword ptr [ebp - local_18]          # 004e5f2f
    mov dword ptr [ecx + field_4530], 0x10       # 004e5f32
L_004e5f3c:
    # block 0x004e5f3c: entered by ja at 0x004e4cd2; jmp at 0x004e4d6f; jmp at 0x004e4dd9; jmp at 0x004e4deb; more, 6 instruction(s), ends with ret
    pop edi                                      # 004e5f3c
    pop esi                                      # 004e5f3d
    pop ebx                                      # 004e5f3e
    {load} mov esp, ebp                          # 004e5f3f
    pop ebp                                      # 004e5f41
    ret                                          # 004e5f42

# --- data items (not part of the function) -------------------------
.org 0x004e5f43 - 0x401000
SWTAB_004e5f43:  # 6 case address(es)
    .long L_004e4ce2 - .text + 0x401000
    .long L_004e5f3c - .text + 0x401000
    .long L_004e4e18 - .text + 0x401000
    .long L_004e5f3c - .text + 0x401000
    .long L_004e4d74 - .text + 0x401000
    .long L_004e4df0 - .text + 0x401000
.org 0x004e5f5b - 0x401000
SWTAB_004e5f5b:  # 16 case address(es)
    .long L_004e55f5 - .text + 0x401000
    .long L_004e55f5 - .text + 0x401000
    .long L_004e4eff - .text + 0x401000
    .long L_004e4fc3 - .text + 0x401000
    .long L_004e4fe5 - .text + 0x401000
    .long L_004e4f49 - .text + 0x401000
    .long L_004e5113 - .text + 0x401000
    .long L_004e5150 - .text + 0x401000
    .long L_004e526f - .text + 0x401000
    .long L_004e5397 - .text + 0x401000
    .long L_004e5421 - .text + 0x401000
    .long L_004e544d - .text + 0x401000
    .long L_004e54a9 - .text + 0x401000
    .long L_004e5113 - .text + 0x401000
    .long L_004e556b - .text + 0x401000
    .long L_004e5421 - .text + 0x401000
.org 0x004e5f9b - 0x401000
SWTAB_004e5f9b:  # 16 case address(es)
    .long L_004e574a - .text + 0x401000
    .long L_004e5821 - .text + 0x401000
    .long L_004e59bc - .text + 0x401000
    .long L_004e5a79 - .text + 0x401000
    .long L_004e5abd - .text + 0x401000
    .long L_004e5be5 - .text + 0x401000
    .long L_004e5d28 - .text + 0x401000
    .long L_004e5c2a - .text + 0x401000
    .long L_004e5cd4 - .text + 0x401000
    .long L_004e5f3c - .text + 0x401000
    .long L_004e5f3c - .text + 0x401000
    .long L_004e5f3c - .text + 0x401000
    .long L_004e5f3c - .text + 0x401000
    .long L_004e5f3c - .text + 0x401000
    .long L_004e5f3c - .text + 0x401000
    .long L_004e5ec6 - .text + 0x401000
.set SWTAB_004e5f43_VA, SWTAB_004e5f43 - .text + 0x401000
.set SWTAB_004e5f5b_VA, SWTAB_004e5f5b - .text + 0x401000
.set SWTAB_004e5f9b_VA, SWTAB_004e5f9b - .text + 0x401000

