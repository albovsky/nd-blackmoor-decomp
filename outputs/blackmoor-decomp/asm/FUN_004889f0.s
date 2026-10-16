# FUN_004889f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004889f0
# extent:       0x004889f0-0x00488ca8 (696 code bytes)
# span:         0x004889f0-0x00488cc0 (code 696, tables 16, padding 8)
# sha256:       1eb9b50fff8433bf284c6b433a84503b7d86ba9c393b7077b48a80a464a239c2
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004889f0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_25, field_325; [ecx + n] field_125, field_449, field_47b, field_47f, field_483, field_487; [edx + n] field_21, field_225, field_325, field_329, field_32d, field_331, field_44b
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 176 instruction(s), 5 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_125, 0x125  # offset +0x125
.equ field_225, 0x225  # offset +0x225
.equ field_325, 0x325  # offset +0x325
.equ field_329, 0x329  # offset +0x329
.equ field_32d, 0x32d  # offset +0x32d
.equ field_331, 0x331  # offset +0x331
.equ field_449, 0x449  # offset +0x449
.equ field_44b, 0x44b  # offset +0x44b
.equ field_47b, 0x47b  # offset +0x47b
.equ field_47f, 0x47f  # offset +0x47f
.equ field_483, 0x483  # offset +0x483
.equ field_487, 0x487  # offset +0x487

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004889f0 - 0x401000
.globl FUN_004889f0
FUN_004889f0:
    # block 0x004889f0: entry, 11 instruction(s), ends with je to 0x00488ca4 (forward)
    push ebp                                     # 004889f0
    {load} mov ebp, esp                          # 004889f1
    sub esp, 0x1c                                # 004889f3
    movsx eax, word ptr [0x61d7f6]               # 004889f6
    imul eax, eax, 0x8d                          # 004889fd
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00488a03
    mov dword ptr [ebp - local_4], ecx           # 00488a09
    {load} xor edx, edx                          # 00488a0c
    mov dl, byte ptr [0x61d7fc]                  # 00488a0e
    test edx, edx                                # 00488a14
    je.d32 L_00488ca4                            # 00488a16
    # block 0x00488a1c: entered by fall-through of je at 0x00488a16, 2 instruction(s), ends with forward jump to 0x00488a30
    mov word ptr [ebp - local_8], 0x0            # 00488a1c
    jmp.d8 L_00488a30                            # 00488a22
L_00488a24:
    # block 0x00488a24: entered by jmp at 0x00488bbb, 3 instruction(s), falls into the block at 0x00488a30
    mov ax, word ptr [ebp - local_8]             # 00488a24
    .insn 0x66, 0x05, 0x0001{:u16}               # 00488a28
    mov word ptr [ebp - local_8], ax             # 00488a2c
L_00488a30:
    # block 0x00488a30: entered by jmp at 0x00488a22, 5 instruction(s), ends with jge to 0x00488bc0 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00488a30
    mov edx, dword ptr [ebp - local_4]           # 00488a34
    movsx eax, word ptr [edx + field_21]         # 00488a37
    {load} cmp ecx, eax                          # 00488a3b
    jge.d32 L_00488bc0                           # 00488a3d
    # block 0x00488a43: entered by fall-through of jge at 0x00488a3d, 29 instruction(s), ends with ja to 0x00488bbb (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00488a43
    shl ecx, 0x4                                 # 00488a47
    mov edx, dword ptr [ebp - local_4]           # 00488a4a
    mov eax, dword ptr [edx + ecx + field_329]   # 00488a4d
    add eax, dword ptr [0x58318a]                # 00488a54
    mov dword ptr [ebp - local_14], eax          # 00488a5a
    movsx ecx, word ptr [ebp - local_8]          # 00488a5d
    shl ecx, 0x4                                 # 00488a61
    mov edx, dword ptr [ebp - local_4]           # 00488a64
    mov eax, dword ptr [edx + ecx + field_331]   # 00488a67
    add eax, dword ptr [0x58318a]                # 00488a6e
    mov dword ptr [ebp - local_c], eax           # 00488a74
    movsx ecx, word ptr [ebp - local_8]          # 00488a77
    shl ecx, 0x4                                 # 00488a7b
    mov edx, dword ptr [ebp - local_4]           # 00488a7e
    mov eax, dword ptr [edx + ecx + field_325]   # 00488a81
    add eax, dword ptr [0x583186]                # 00488a88
    mov dword ptr [ebp - local_18], eax          # 00488a8e
    movsx ecx, word ptr [ebp - local_8]          # 00488a91
    shl ecx, 0x4                                 # 00488a95
    mov edx, dword ptr [ebp - local_4]           # 00488a98
    mov eax, dword ptr [edx + ecx + field_32d]   # 00488a9b
    add eax, dword ptr [0x583186]                # 00488aa2
    mov dword ptr [ebp - local_10], eax          # 00488aa8
    movsx ecx, word ptr [ebp - local_8]          # 00488aab
    mov edx, dword ptr [4*ecx + 0x61d7fd]        # 00488aaf
    mov dword ptr [ebp - local_1c], edx          # 00488ab6
    cmp dword ptr [ebp - local_1c], 0x3          # 00488ab9
    ja.d32 L_00488bbb                            # 00488abd
    # block 0x00488ac3: entered by fall-through of ja at 0x00488abd, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x488ca8]
    mov eax, dword ptr [ebp - local_1c]          # 00488ac3
    jmp dword ptr [4*eax + SWTAB_00488ca8_VA]    # 00488ac6
L_00488acd:
    # block 0x00488acd: entered by switch case, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00488bbb
    push 0x54deb8                                # 00488acd
    lea ecx, [ebp - local_18]                    # 00488ad2
    push ecx                                     # 00488ad5
    movsx edx, word ptr [ebp - local_8]          # 00488ad6
    shl edx, 0x4                                 # 00488ada
    mov eax, dword ptr [ebp - local_4]           # 00488add
    lea ecx, [eax + edx + field_325]             # 00488ae0
    push ecx                                     # 00488ae7
    mov edx, dword ptr [0x5cf665]                # 00488ae8
    push edx                                     # 00488aee
    mov eax, dword ptr [0x5d15e3]                # 00488aef
    push eax                                     # 00488af4
    mov ecx, 0x5cf659                            # 00488af5
    call FUN_004c5377                            # 00488afa
    jmp.d32 L_00488bbb                           # 00488aff
L_00488b04:
    # block 0x00488b04: entered by switch case, 17 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00488bbb
    push 0x54ded4                                # 00488b04
    lea ecx, [ebp - local_18]                    # 00488b09
    push ecx                                     # 00488b0c
    movsx edx, word ptr [ebp - local_8]          # 00488b0d
    shl edx, 0x4                                 # 00488b11
    mov eax, dword ptr [ebp - local_4]           # 00488b14
    lea ecx, [eax + edx + field_25]              # 00488b17
    push ecx                                     # 00488b1b
    mov edx, dword ptr [0x5cf665]                # 00488b1c
    push edx                                     # 00488b22
    movsx eax, word ptr [0x61d7f4]               # 00488b23
    imul eax, eax, 0x4a                          # 00488b2a
    mov ecx, dword ptr [eax + 0x5d1599]          # 00488b2d
    push ecx                                     # 00488b33
    mov ecx, 0x5cf659                            # 00488b34
    call FUN_004c5377                            # 00488b39
    jmp.d8 L_00488bbb                            # 00488b3e
L_00488b40:
    # block 0x00488b40: entered by switch case, 17 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00488bbb
    push 0x54def0                                # 00488b40
    lea edx, [ebp - local_18]                    # 00488b45
    push edx                                     # 00488b48
    movsx eax, word ptr [ebp - local_8]          # 00488b49
    shl eax, 0x4                                 # 00488b4d
    mov ecx, dword ptr [ebp - local_4]           # 00488b50
    lea edx, [ecx + eax + field_125]             # 00488b53
    push edx                                     # 00488b5a
    mov eax, dword ptr [0x5cf665]                # 00488b5b
    push eax                                     # 00488b60
    movsx ecx, word ptr [0x61d7f4]               # 00488b61
    imul ecx, ecx, 0x4a                          # 00488b68
    mov edx, dword ptr [ecx + 0x5d1599]          # 00488b6b
    push edx                                     # 00488b71
    mov ecx, 0x5cf659                            # 00488b72
    call FUN_004c5377                            # 00488b77
    jmp.d8 L_00488bbb                            # 00488b7c
L_00488b7e:
    # block 0x00488b7e: entered by switch case, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x00488bbb
    push 0x54df0c                                # 00488b7e
    lea eax, [ebp - local_18]                    # 00488b83
    push eax                                     # 00488b86
    movsx ecx, word ptr [ebp - local_8]          # 00488b87
    shl ecx, 0x4                                 # 00488b8b
    mov edx, dword ptr [ebp - local_4]           # 00488b8e
    lea eax, [edx + ecx + field_225]             # 00488b91
    push eax                                     # 00488b98
    mov ecx, dword ptr [0x5cf665]                # 00488b99
    push ecx                                     # 00488b9f
    movsx edx, word ptr [0x61d7f4]               # 00488ba0
    imul edx, edx, 0x4a                          # 00488ba7
    mov eax, dword ptr [edx + 0x5d1599]          # 00488baa
    push eax                                     # 00488bb0
    mov ecx, 0x5cf659                            # 00488bb1
    call FUN_004c5377                            # 00488bb6
L_00488bbb:
    # block 0x00488bbb: entered by ja at 0x00488abd; jmp at 0x00488aff; jmp at 0x00488b3e; jmp at 0x00488b7c, 1 instruction(s), ends with backward jump to 0x00488a24
    jmp.d32 L_00488a24                           # 00488bbb
L_00488bc0:
    # block 0x00488bc0: entered by jge at 0x00488a3d, 4 instruction(s), ends with je to 0x00488ca4 (forward)
    {load} xor ecx, ecx                          # 00488bc0
    mov cl, byte ptr [0x61d848]                  # 00488bc2
    test ecx, ecx                                # 00488bc8
    je.d32 L_00488ca4                            # 00488bca
    # block 0x00488bd0: entered by fall-through of je at 0x00488bca, 2 instruction(s), ends with forward jump to 0x00488be4
    mov word ptr [ebp - local_8], 0x0            # 00488bd0
    jmp.d8 L_00488be4                            # 00488bd6
L_00488bd8:
    # block 0x00488bd8: entered by jmp at 0x00488c9f, 3 instruction(s), falls into the block at 0x00488be4
    mov dx, word ptr [ebp - local_8]             # 00488bd8
    add dx, 0x1                                  # 00488bdc
    mov word ptr [ebp - local_8], dx             # 00488be0
L_00488be4:
    # block 0x00488be4: entered by jmp at 0x00488bd6, 5 instruction(s), ends with jge to 0x00488ca4 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00488be4
    mov ecx, dword ptr [ebp - local_4]           # 00488be8
    movsx edx, word ptr [ecx + field_449]        # 00488beb
    {load} cmp eax, edx                          # 00488bf2
    jge.d32 L_00488ca4                           # 00488bf4
    # block 0x00488bfa: entered by fall-through of jge at 0x00488bf4, 41 instruction(s), calls FUN_004c5377, ends with backward jump to 0x00488bd8
    movsx eax, word ptr [ebp - local_8]          # 00488bfa
    shl eax, 0x4                                 # 00488bfe
    mov ecx, dword ptr [ebp - local_4]           # 00488c01
    mov edx, dword ptr [ecx + eax + field_47f]   # 00488c04
    add edx, dword ptr [0x58318a]                # 00488c0b
    mov dword ptr [ebp - local_14], edx          # 00488c11
    movsx eax, word ptr [ebp - local_8]          # 00488c14
    shl eax, 0x4                                 # 00488c18
    mov ecx, dword ptr [ebp - local_4]           # 00488c1b
    mov edx, dword ptr [ecx + eax + field_487]   # 00488c1e
    add edx, dword ptr [0x58318a]                # 00488c25
    mov dword ptr [ebp - local_c], edx           # 00488c2b
    movsx eax, word ptr [ebp - local_8]          # 00488c2e
    shl eax, 0x4                                 # 00488c32
    mov ecx, dword ptr [ebp - local_4]           # 00488c35
    mov edx, dword ptr [ecx + eax + field_47b]   # 00488c38
    add edx, dword ptr [0x583186]                # 00488c3f
    mov dword ptr [ebp - local_18], edx          # 00488c45
    movsx eax, word ptr [ebp - local_8]          # 00488c48
    shl eax, 0x4                                 # 00488c4c
    mov ecx, dword ptr [ebp - local_4]           # 00488c4f
    mov edx, dword ptr [ecx + eax + field_483]   # 00488c52
    add edx, dword ptr [0x583186]                # 00488c59
    mov dword ptr [ebp - local_10], edx          # 00488c5f
    push 0x54df28                                # 00488c62
    lea eax, [ebp - local_18]                    # 00488c67
    push eax                                     # 00488c6a
    movsx ecx, word ptr [ebp - local_8]          # 00488c6b
    shl ecx, 0x4                                 # 00488c6f
    mov edx, dword ptr [ebp - local_4]           # 00488c72
    lea eax, [edx + ecx + field_44b]             # 00488c75
    push eax                                     # 00488c7c
    mov ecx, dword ptr [0x5cf665]                # 00488c7d
    push ecx                                     # 00488c83
    movsx edx, word ptr [0x61d7f4]               # 00488c84
    imul edx, edx, 0x4a                          # 00488c8b
    mov eax, dword ptr [edx + 0x5d1599]          # 00488c8e
    push eax                                     # 00488c94
    mov ecx, 0x5cf659                            # 00488c95
    call FUN_004c5377                            # 00488c9a
    jmp.d32 L_00488bd8                           # 00488c9f
L_00488ca4:
    # block 0x00488ca4: entered by je at 0x00488a16; je at 0x00488bca; jge at 0x00488bf4, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00488ca4
    pop ebp                                      # 00488ca6
    ret                                          # 00488ca7

# --- data items (not part of the function) -------------------------
.org 0x00488ca8 - 0x401000
SWTAB_00488ca8:  # 4 case address(es)
    .long L_00488acd - .text + 0x401000
    .long L_00488b04 - .text + 0x401000
    .long L_00488b40 - .text + 0x401000
    .long L_00488b7e - .text + 0x401000
.org 0x00488cb8 - 0x401000
PAD_00488cb8:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc
.set SWTAB_00488ca8_VA, SWTAB_00488ca8 - .text + 0x401000

