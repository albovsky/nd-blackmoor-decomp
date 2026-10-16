# FUN_00422a0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00422a0a
# extent:       0x00422a0a-0x00422e3a (1072 code bytes)
# span:         0x00422a0a-0x00422e4a (code 1072, tables 16, padding 0)
# sha256:       55a946d3d5d46d7c6b95716f51888b3eb92663d424f6f5b63243b1a9c7550bd6
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00422a0a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       21 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 9 more
# fields:       [eax + n] field_4, field_6, field_8, field_c, field_2f, field_49, field_4d, field_51, field_b2, field_b6, field_ba; [ecx + n] field_4, field_8, field_c, field_1f, field_2f, field_45, field_49, field_4d; [edx + n] field_4, field_8, field_c, field_1e, field_1f, field_2f, field_45, field_51, field_fa, field_fe, field_102, field_106
# callees:      calls FUN_004c5377, FUN_004c609b, FUN_004c5770
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:blit_add (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 303 instruction(s), 12 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_54, 0x54  # offset -0x54
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1f, 0x1f  # offset +0x1f
.equ field_2f, 0x2f  # offset +0x2f
.equ field_45, 0x45  # offset +0x45
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51
.equ field_b2, 0xb2  # offset +0xb2
.equ field_b6, 0xb6  # offset +0xb6
.equ field_ba, 0xba  # offset +0xba
.equ field_fa, 0xfa  # offset +0xfa
.equ field_fe, 0xfe  # offset +0xfe
.equ field_102, 0x102  # offset +0x102
.equ field_106, 0x106  # offset +0x106

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5770, .text + (0x004c5770 - 0x401000)
.set FUN_004c609b, .text + (0x004c609b - 0x401000)

.org 0x00422a0a - 0x401000
.globl FUN_00422a0a
FUN_00422a0a:
    # block 0x00422a0a: entry, 11 instruction(s), ends with je to 0x00422a42 (forward)
    push ebp                                     # 00422a0a
    {load} mov ebp, esp                          # 00422a0b
    sub esp, 0x54                                # 00422a0d
    movsx eax, word ptr [0x617e78]               # 00422a10
    imul eax, eax, 0x16                          # 00422a17
    add eax, 0x617804                            # 00422a1a
    mov dword ptr [ebp - local_24], eax          # 00422a1f
    mov cl, byte ptr [0x617f42]                  # 00422a22
    mov byte ptr [ebp - local_48], cl            # 00422a28
    cmp byte ptr [ebp - local_48], 0x39          # 00422a2b
    je.d8 L_00422a42                             # 00422a2f
    # block 0x00422a31: entered by fall-through of je at 0x00422a2f, 2 instruction(s), ends with je to 0x00422a42 (forward)
    cmp byte ptr [ebp - local_48], 0x3b          # 00422a31
    je.d8 L_00422a42                             # 00422a35
    # block 0x00422a37: entered by fall-through of je at 0x00422a35, 2 instruction(s), ends with je to 0x00422a42 (forward)
    cmp byte ptr [ebp - local_48], 0x3e          # 00422a37
    je.d8 L_00422a42                             # 00422a3b
    # block 0x00422a3d: entered by fall-through of je at 0x00422a3b, 1 instruction(s), ends with forward jump to 0x00422e2c
    jmp.d32 L_00422e2c                           # 00422a3d
L_00422a42:
    # block 0x00422a42: entered by je at 0x00422a2f; je at 0x00422a35; je at 0x00422a3b, 2 instruction(s), ends with forward jump to 0x00422a56
    mov word ptr [ebp - local_4], 0x0            # 00422a42
    jmp.d8 L_00422a56                            # 00422a48
L_00422a4a:
    # block 0x00422a4a: entered by jmp at 0x00422e27, 3 instruction(s), falls into the block at 0x00422a56
    mov dx, word ptr [ebp - local_4]             # 00422a4a
    add dx, 0x1                                  # 00422a4e
    mov word ptr [ebp - local_4], dx             # 00422a52
L_00422a56:
    # block 0x00422a56: entered by jmp at 0x00422a48, 4 instruction(s), ends with jge to 0x00422e2c (forward)
    movsx eax, word ptr [ebp - local_4]          # 00422a56
    movsx ecx, word ptr [0x618783]               # 00422a5a
    {load} cmp eax, ecx                          # 00422a61
    jge.d32 L_00422e2c                           # 00422a63
    # block 0x00422a69: entered by fall-through of jge at 0x00422a63, 2 instruction(s), ends with forward jump to 0x00422a7d
    mov word ptr [ebp - local_8], 0x0            # 00422a69
    jmp.d8 L_00422a7d                            # 00422a6f
L_00422a71:
    # block 0x00422a71: entered by jmp at 0x00422e22, 3 instruction(s), falls into the block at 0x00422a7d
    mov dx, word ptr [ebp - local_8]             # 00422a71
    add dx, 0x1                                  # 00422a75
    mov word ptr [ebp - local_8], dx             # 00422a79
L_00422a7d:
    # block 0x00422a7d: entered by jmp at 0x00422a6f, 4 instruction(s), ends with jge to 0x00422e27 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00422a7d
    movsx ecx, word ptr [0x618783]               # 00422a81
    {load} cmp eax, ecx                          # 00422a88
    jge.d32 L_00422e27                           # 00422a8a
    # block 0x00422a90: entered by fall-through of jge at 0x00422a8a, 7 instruction(s), ends with jne to 0x00422e22 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00422a90
    mov eax, dword ptr [0x618795]                # 00422a94
    {load} xor ecx, ecx                          # 00422a99
    mov cl, byte ptr [eax + edx + field_b2]      # 00422a9b
    movsx edx, word ptr [ebp - local_4]          # 00422aa2
    {load} cmp ecx, edx                          # 00422aa6
    jne.d32 L_00422e22                           # 00422aa8
    # block 0x00422aae: entered by fall-through of jne at 0x00422aa8, 15 instruction(s), ends with ja to 0x00422e20 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00422aae
    movsx ecx, word ptr [2*eax + 0x61879d]       # 00422ab2
    imul ecx, ecx, 0x84d                         # 00422aba
    add ecx, 0x5d34d1                            # 00422ac0
    mov dword ptr [ebp - local_20], ecx          # 00422ac6
    movsx edx, word ptr [ebp - local_8]          # 00422ac9
    mov eax, dword ptr [ebp - local_24]          # 00422acd
    mov ecx, dword ptr [eax + 4*edx + field_6]   # 00422ad0
    mov dword ptr [ebp - local_c], ecx           # 00422ad4
    mov edx, dword ptr [ebp - local_20]          # 00422ad7
    {load} xor eax, eax                          # 00422ada
    mov al, byte ptr [edx + field_1e]            # 00422adc
    mov dword ptr [ebp - local_4c], eax          # 00422adf
    cmp dword ptr [ebp - local_4c], 0x3          # 00422ae2
    ja.d32 L_00422e20                            # 00422ae6
    # block 0x00422aec: entered by fall-through of ja at 0x00422ae6, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x422e3a]
    mov ecx, dword ptr [ebp - local_4c]          # 00422aec
    jmp dword ptr [4*ecx + SWTAB_00422e3a_VA]    # 00422aef
L_00422af6:
    # block 0x00422af6: entered by switch case, 6 instruction(s), ends with jne to 0x00422bdc (forward)
    movsx edx, word ptr [ebp - local_8]          # 00422af6
    mov eax, dword ptr [0x618795]                # 00422afa
    {load} xor ecx, ecx                          # 00422aff
    mov cl, byte ptr [eax + edx + field_b6]      # 00422b01
    cmp ecx, 0x2                                 # 00422b08
    jne.d32 L_00422bdc                           # 00422b0b
    # block 0x00422b11: entered by fall-through of jne at 0x00422b0b, 49 instruction(s), ends with forward jump to 0x00422c52
    movsx edx, word ptr [ebp - local_8]          # 00422b11
    shl edx, 0x4                                 # 00422b15
    mov eax, dword ptr [0x618795]                # 00422b18
    lea ecx, [eax + edx + field_ba]              # 00422b1d
    mov edx, dword ptr [ecx]                     # 00422b24
    mov dword ptr [ebp - local_1c], edx          # 00422b26
    mov eax, dword ptr [ecx + field_4]           # 00422b29
    mov dword ptr [ebp - local_18], eax          # 00422b2c
    mov edx, dword ptr [ecx + field_8]           # 00422b2f
    mov dword ptr [ebp - local_14], edx          # 00422b32
    mov eax, dword ptr [ecx + field_c]           # 00422b35
    mov dword ptr [ebp - local_10], eax          # 00422b38
    movsx ecx, word ptr [ebp - local_8]          # 00422b3b
    shl ecx, 0x4                                 # 00422b3f
    mov edx, dword ptr [0x618795]                # 00422b42
    mov eax, dword ptr [edx + ecx + field_fe]    # 00422b48
    add eax, dword ptr [0x58318a]                # 00422b4f
    mov dword ptr [ebp - local_40], eax          # 00422b55
    movsx ecx, word ptr [ebp - local_8]          # 00422b58
    shl ecx, 0x4                                 # 00422b5c
    mov edx, dword ptr [0x618795]                # 00422b5f
    mov eax, dword ptr [edx + ecx + field_106]   # 00422b65
    add eax, dword ptr [0x58318a]                # 00422b6c
    mov dword ptr [ebp - local_38], eax          # 00422b72
    movsx ecx, word ptr [ebp - local_8]          # 00422b75
    shl ecx, 0x4                                 # 00422b79
    mov edx, dword ptr [0x618795]                # 00422b7c
    mov eax, dword ptr [edx + ecx + field_fa]    # 00422b82
    add eax, dword ptr [0x583186]                # 00422b89
    mov dword ptr [ebp - local_44], eax          # 00422b8f
    movsx ecx, word ptr [ebp - local_8]          # 00422b92
    shl ecx, 0x4                                 # 00422b96
    mov edx, dword ptr [0x618795]                # 00422b99
    mov eax, dword ptr [edx + ecx + field_102]   # 00422b9f
    add eax, dword ptr [0x583186]                # 00422ba6
    mov dword ptr [ebp - local_3c], eax          # 00422bac
    movsx ecx, word ptr [ebp - local_8]          # 00422baf
    shl ecx, 0x4                                 # 00422bb3
    mov edx, dword ptr [0x618795]                # 00422bb6
    lea eax, [edx + ecx + field_fa]              # 00422bbc
    mov ecx, dword ptr [eax]                     # 00422bc3
    mov dword ptr [ebp - local_34], ecx          # 00422bc5
    mov edx, dword ptr [eax + field_4]           # 00422bc8
    mov dword ptr [ebp - local_30], edx          # 00422bcb
    mov ecx, dword ptr [eax + field_8]           # 00422bce
    mov dword ptr [ebp - local_2c], ecx          # 00422bd1
    mov edx, dword ptr [eax + field_c]           # 00422bd4
    mov dword ptr [ebp - local_28], edx          # 00422bd7
    jmp.d8 L_00422c52                            # 00422bda
L_00422bdc:
    # block 0x00422bdc: entered by jne at 0x00422b0b, 36 instruction(s), falls into the block at 0x00422c52
    mov eax, dword ptr [ebp - local_c]           # 00422bdc
    add eax, 0x35                                # 00422bdf
    mov ecx, dword ptr [eax]                     # 00422be2
    mov dword ptr [ebp - local_1c], ecx          # 00422be4
    mov edx, dword ptr [eax + field_4]           # 00422be7
    mov dword ptr [ebp - local_18], edx          # 00422bea
    mov ecx, dword ptr [eax + field_8]           # 00422bed
    mov dword ptr [ebp - local_14], ecx          # 00422bf0
    mov edx, dword ptr [eax + field_c]           # 00422bf3
    mov dword ptr [ebp - local_10], edx          # 00422bf6
    mov eax, dword ptr [ebp - local_c]           # 00422bf9
    mov ecx, dword ptr [eax + field_49]          # 00422bfc
    add ecx, dword ptr [0x58318a]                # 00422bff
    mov dword ptr [ebp - local_40], ecx          # 00422c05
    mov edx, dword ptr [ebp - local_c]           # 00422c08
    mov eax, dword ptr [edx + field_51]          # 00422c0b
    add eax, dword ptr [0x58318a]                # 00422c0e
    mov dword ptr [ebp - local_38], eax          # 00422c14
    mov ecx, dword ptr [ebp - local_c]           # 00422c17
    mov edx, dword ptr [ecx + field_45]          # 00422c1a
    add edx, dword ptr [0x583186]                # 00422c1d
    mov dword ptr [ebp - local_44], edx          # 00422c23
    mov eax, dword ptr [ebp - local_c]           # 00422c26
    mov ecx, dword ptr [eax + field_4d]          # 00422c29
    add ecx, dword ptr [0x583186]                # 00422c2c
    mov dword ptr [ebp - local_3c], ecx          # 00422c32
    mov edx, dword ptr [ebp - local_c]           # 00422c35
    add edx, 0x45                                # 00422c38
    mov eax, dword ptr [edx]                     # 00422c3b
    mov dword ptr [ebp - local_34], eax          # 00422c3d
    mov ecx, dword ptr [edx + field_4]           # 00422c40
    mov dword ptr [ebp - local_30], ecx          # 00422c43
    mov eax, dword ptr [edx + field_8]           # 00422c46
    mov dword ptr [ebp - local_2c], eax          # 00422c49
    mov ecx, dword ptr [edx + field_c]           # 00422c4c
    mov dword ptr [ebp - local_28], ecx          # 00422c4f
L_00422c52:
    # block 0x00422c52: entered by jmp at 0x00422bda, 5 instruction(s), ends with je to 0x00422c69 (forward)
    mov edx, dword ptr [ebp - local_20]          # 00422c52
    mov al, byte ptr [edx + field_1f]            # 00422c55
    mov byte ptr [ebp - local_50], al            # 00422c58
    cmp byte ptr [ebp - local_50], 0x1           # 00422c5b
    je.d8 L_00422c69                             # 00422c5f
    # block 0x00422c61: entered by fall-through of je at 0x00422c5f, 2 instruction(s), ends with je to 0x00422cba (forward)
    cmp byte ptr [ebp - local_50], 0x2           # 00422c61
    je.d8 L_00422cba                             # 00422c65
    # block 0x00422c67: entered by fall-through of je at 0x00422c65, 1 instruction(s), ends with forward jump to 0x00422ce6
    jmp.d8 L_00422ce6                            # 00422c67
L_00422c69:
    # block 0x00422c69: entered by je at 0x00422c5f, 27 instruction(s), calls FUN_004c5377, FUN_004c609b, ends with forward jump to 0x00422ce6
    push 0x544330                                # 00422c69
    lea ecx, [ebp - local_44]                    # 00422c6e
    push ecx                                     # 00422c71
    lea edx, [ebp - local_34]                    # 00422c72
    push edx                                     # 00422c75
    mov eax, dword ptr [0x5cf665]                # 00422c76
    push eax                                     # 00422c7b
    mov ecx, dword ptr [0x5d15e3]                # 00422c7c
    push ecx                                     # 00422c82
    mov ecx, 0x5cf659                            # 00422c83
    call FUN_004c5377                            # 00422c88
    push 0x54434c                                # 00422c8d
    mov edx, dword ptr [ebp - local_c]           # 00422c92
    movsx eax, word ptr [edx + field_2f]         # 00422c95
    push eax                                     # 00422c99
    lea ecx, [ebp - local_44]                    # 00422c9a
    push ecx                                     # 00422c9d
    lea edx, [ebp - local_1c]                    # 00422c9e
    push edx                                     # 00422ca1
    mov eax, dword ptr [0x5cf665]                # 00422ca2
    push eax                                     # 00422ca7
    mov ecx, dword ptr [ebp - local_c]           # 00422ca8
    mov edx, dword ptr [ecx]                     # 00422cab
    push edx                                     # 00422cad
    mov ecx, 0x5cf659                            # 00422cae
    call FUN_004c609b                            # 00422cb3
    jmp.d8 L_00422ce6                            # 00422cb8
L_00422cba:
    # block 0x00422cba: entered by je at 0x00422c65, 15 instruction(s), calls FUN_004c5770, falls into the block at 0x00422ce6
    push 0x544368                                # 00422cba
    mov eax, dword ptr [ebp - local_c]           # 00422cbf
    movsx ecx, word ptr [eax + field_2f]         # 00422cc2
    push ecx                                     # 00422cc6
    lea edx, [ebp - local_44]                    # 00422cc7
    push edx                                     # 00422cca
    lea eax, [ebp - local_1c]                    # 00422ccb
    push eax                                     # 00422cce
    mov ecx, dword ptr [0x5cf665]                # 00422ccf
    push ecx                                     # 00422cd5
    mov edx, dword ptr [ebp - local_c]           # 00422cd6
    mov eax, dword ptr [edx]                     # 00422cd9
    push eax                                     # 00422cdb
    mov ecx, 0x5cf659                            # 00422cdc
    call FUN_004c5770                            # 00422ce1
L_00422ce6:
    # block 0x00422ce6: entered by jmp at 0x00422c67; jmp at 0x00422cb8, 1 instruction(s), ends with forward jump to 0x00422e20
    jmp.d32 L_00422e20                           # 00422ce6
L_00422ceb:
    # block 0x00422ceb: entered by switch case, 36 instruction(s), calls FUN_004c5377, ends with je to 0x00422d75 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00422ceb
    mov edx, dword ptr [ecx + field_49]          # 00422cee
    add edx, dword ptr [0x58318a]                # 00422cf1
    mov dword ptr [ebp - local_40], edx          # 00422cf7
    mov eax, dword ptr [ebp - local_c]           # 00422cfa
    mov ecx, dword ptr [eax + field_51]          # 00422cfd
    add ecx, dword ptr [0x58318a]                # 00422d00
    mov dword ptr [ebp - local_38], ecx          # 00422d06
    mov edx, dword ptr [ebp - local_c]           # 00422d09
    mov eax, dword ptr [edx + field_45]          # 00422d0c
    add eax, dword ptr [0x583186]                # 00422d0f
    mov dword ptr [ebp - local_44], eax          # 00422d15
    mov ecx, dword ptr [ebp - local_c]           # 00422d18
    mov edx, dword ptr [ecx + field_4d]          # 00422d1b
    add edx, dword ptr [0x583186]                # 00422d1e
    mov dword ptr [ebp - local_3c], edx          # 00422d24
    push 0x544388                                # 00422d27
    movsx eax, word ptr [ebp - local_8]          # 00422d2c
    shl eax, 0x4                                 # 00422d30
    add eax, 0x617f02                            # 00422d33
    push eax                                     # 00422d38
    movsx ecx, word ptr [ebp - local_8]          # 00422d39
    shl ecx, 0x4                                 # 00422d3d
    add ecx, 0x617ec2                            # 00422d40
    push ecx                                     # 00422d46
    mov edx, dword ptr [0x5cf665]                # 00422d47
    push edx                                     # 00422d4d
    mov eax, dword ptr [0x5d15e3]                # 00422d4e
    push eax                                     # 00422d53
    mov ecx, 0x5cf659                            # 00422d54
    call FUN_004c5377                            # 00422d59
    mov ecx, dword ptr [ebp - local_20]          # 00422d5e
    mov dl, byte ptr [ecx + field_1f]            # 00422d61
    mov byte ptr [ebp - local_54], dl            # 00422d64
    cmp byte ptr [ebp - local_54], 0x1           # 00422d67
    je.d8 L_00422d75                             # 00422d6b
    # block 0x00422d6d: entered by fall-through of je at 0x00422d6b, 2 instruction(s), ends with je to 0x00422da6 (forward)
    cmp byte ptr [ebp - local_54], 0x2           # 00422d6d
    je.d8 L_00422da6                             # 00422d71
    # block 0x00422d73: entered by fall-through of je at 0x00422d71, 1 instruction(s), ends with forward jump to 0x00422dd5
    jmp.d8 L_00422dd5                            # 00422d73
L_00422d75:
    # block 0x00422d75: entered by je at 0x00422d6b, 17 instruction(s), calls FUN_004c609b, ends with forward jump to 0x00422dd5
    push 0x5443a4                                # 00422d75
    mov eax, dword ptr [ebp - local_c]           # 00422d7a
    movsx ecx, word ptr [eax + field_2f]         # 00422d7d
    push ecx                                     # 00422d81
    lea edx, [ebp - local_44]                    # 00422d82
    push edx                                     # 00422d85
    mov eax, dword ptr [ebp - local_c]           # 00422d86
    add eax, 0x35                                # 00422d89
    push eax                                     # 00422d8c
    mov ecx, dword ptr [0x5cf665]                # 00422d8d
    push ecx                                     # 00422d93
    mov edx, dword ptr [ebp - local_c]           # 00422d94
    mov eax, dword ptr [edx]                     # 00422d97
    push eax                                     # 00422d99
    mov ecx, 0x5cf659                            # 00422d9a
    call FUN_004c609b                            # 00422d9f
    jmp.d8 L_00422dd5                            # 00422da4
L_00422da6:
    # block 0x00422da6: entered by je at 0x00422d71, 16 instruction(s), calls FUN_004c5770, falls into the block at 0x00422dd5
    push 0x5443c0                                # 00422da6
    mov ecx, dword ptr [ebp - local_c]           # 00422dab
    movsx edx, word ptr [ecx + field_2f]         # 00422dae
    push edx                                     # 00422db2
    lea eax, [ebp - local_44]                    # 00422db3
    push eax                                     # 00422db6
    mov ecx, dword ptr [ebp - local_c]           # 00422db7
    add ecx, 0x35                                # 00422dba
    push ecx                                     # 00422dbd
    mov edx, dword ptr [0x5cf665]                # 00422dbe
    push edx                                     # 00422dc4
    mov eax, dword ptr [ebp - local_c]           # 00422dc5
    mov ecx, dword ptr [eax]                     # 00422dc8
    push ecx                                     # 00422dca
    mov ecx, 0x5cf659                            # 00422dcb
    call FUN_004c5770                            # 00422dd0
L_00422dd5:
    # block 0x00422dd5: entered by jmp at 0x00422d73; jmp at 0x00422da4, 24 instruction(s), falls into the block at 0x00422e20
    mov edx, dword ptr [ebp - local_c]           # 00422dd5
    add edx, 0x45                                # 00422dd8
    movsx eax, word ptr [ebp - local_8]          # 00422ddb
    shl eax, 0x4                                 # 00422ddf
    add eax, 0x617ec2                            # 00422de2
    mov ecx, dword ptr [edx]                     # 00422de7
    mov dword ptr [eax], ecx                     # 00422de9
    mov ecx, dword ptr [edx + field_4]           # 00422deb
    mov dword ptr [eax + field_4], ecx           # 00422dee
    mov ecx, dword ptr [edx + field_8]           # 00422df1
    mov dword ptr [eax + field_8], ecx           # 00422df4
    mov edx, dword ptr [edx + field_c]           # 00422df7
    mov dword ptr [eax + field_c], edx           # 00422dfa
    movsx eax, word ptr [ebp - local_8]          # 00422dfd
    shl eax, 0x4                                 # 00422e01
    add eax, 0x617f02                            # 00422e04
    mov ecx, dword ptr [ebp - local_44]          # 00422e09
    mov dword ptr [eax], ecx                     # 00422e0c
    mov edx, dword ptr [ebp - local_40]          # 00422e0e
    mov dword ptr [eax + field_4], edx           # 00422e11
    mov ecx, dword ptr [ebp - local_3c]          # 00422e14
    mov dword ptr [eax + field_8], ecx           # 00422e17
    mov edx, dword ptr [ebp - local_38]          # 00422e1a
    mov dword ptr [eax + field_c], edx           # 00422e1d
L_00422e20:
    # block 0x00422e20: entered by ja at 0x00422ae6; jmp at 0x00422ce6, 1 instruction(s), ends with forward jump to 0x00422e27
    jmp.d8 L_00422e27                            # 00422e20
L_00422e22:
    # block 0x00422e22: entered by jne at 0x00422aa8, 1 instruction(s), ends with backward jump to 0x00422a71
    jmp.d32 L_00422a71                           # 00422e22
L_00422e27:
    # block 0x00422e27: entered by jge at 0x00422a8a; jmp at 0x00422e20, 1 instruction(s), ends with backward jump to 0x00422a4a
    jmp.d32 L_00422a4a                           # 00422e27
L_00422e2c:
    # block 0x00422e2c: entered by jmp at 0x00422a3d; jge at 0x00422a63, 4 instruction(s), ends with ret
    mov dword ptr [0x5d191d], 0x0                # 00422e2c
    {load} mov esp, ebp                          # 00422e36
    pop ebp                                      # 00422e38
    ret                                          # 00422e39

# --- data items (not part of the function) -------------------------
.org 0x00422e3a - 0x401000
SWTAB_00422e3a:  # 4 case address(es)
    .long L_00422af6 - .text + 0x401000
    .long L_00422af6 - .text + 0x401000
    .long L_00422ceb - .text + 0x401000
    .long L_00422af6 - .text + 0x401000
.set SWTAB_00422e3a_VA, SWTAB_00422e3a - .text + 0x401000

