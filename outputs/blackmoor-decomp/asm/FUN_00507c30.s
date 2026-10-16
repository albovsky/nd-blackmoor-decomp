# FUN_00507c30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507c30
# extent:       0x00507c30-0x00507e46 (534 code bytes)
# span:         0x00507c30-0x00507e50 (code 534, tables 0, padding 10)
# sha256:       60a183725e7324789c488f721b625dcd5b790e77ab7b00de425643b344243623
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507c30
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_10, field_minus_1; [ebx + n] field_14; [ecx + n] field_4, field_8, field_1c; [edx + n] field_8, field_10, field_14
# callees:      calls FUN_0050c920, FUN_004fee30, FUN_005030a0; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 194 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00507e50
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
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_40, 0x40  # offset -0x40
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_005030a0, .text + (0x005030a0 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x00507c30 - 0x401000
.globl FUN_00507c30
FUN_00507c30:
    # block 0x00507c30: entry, 33 instruction(s), calls FUN_0050c920, ends with jle to 0x00507ca6 (forward)
    push ebp                                     # 00507c30
    {load} mov ebp, esp                          # 00507c31
    sub esp, 0x34                                # 00507c33
    mov eax, dword ptr [ebp + arg_c]             # 00507c36
    push ebx                                     # 00507c39
    push esi                                     # 00507c3a
    push edi                                     # 00507c3b
    mov ecx, dword ptr [eax]                     # 00507c3c
    mov eax, dword ptr [eax + field_10]          # 00507c3e
    mov ebx, dword ptr [ebp + arg_14]            # 00507c41
    mov dword ptr [ebp - local_24], ecx          # 00507c44
    mov esi, dword ptr [eax]                     # 00507c47
    mov eax, dword ptr [ecx + field_4]           # 00507c49
    mov edx, dword ptr [ecx]                     # 00507c4c
    mov edi, dword ptr [ecx + field_8]           # 00507c4e
    {load} sub eax, edx                          # 00507c51
    mov dword ptr [ebp - local_30], esi          # 00507c53
    cdq                                          # 00507c56
    idiv edi                                     # 00507c57
    mov dword ptr [ebp - local_c], edi           # 00507c59
    mov dword ptr [ebp - local_1c], eax          # 00507c5c
    lea eax, [eax + esi - field_minus_1]         # 00507c5f
    cdq                                          # 00507c63
    idiv esi                                     # 00507c64
    {load} mov esi, eax                          # 00507c66
    lea eax, [4*ebx]                             # 00507c68
    add eax, 0x3                                 # 00507c6f
    and al, -0x4                                 # 00507c72
    call FUN_0050c920                            # 00507c74
    {load} mov eax, esp                          # 00507c79
    test ebx, ebx                                # 00507c7b
    mov dword ptr [ebp - local_20], eax          # 00507c7d
    jle.d8 L_00507ca6                            # 00507c80
    # block 0x00507c82: entered by fall-through of jle at 0x00507c80, 3 instruction(s), falls into the block at 0x00507c8e
    lea ecx, [4*esi]                             # 00507c82
    {load} mov esi, eax                          # 00507c89
    mov dword ptr [ebp - local_2c], ecx          # 00507c8b
L_00507c8e:
    # block 0x00507c8e: entered by jne at 0x00507ca4, 10 instruction(s), calls FUN_004fee30, ends with jne to 0x00507c8e (backward)
    mov edx, dword ptr [ebp - local_2c]          # 00507c8e
    mov eax, dword ptr [ebp + arg_8]             # 00507c91
    push edx                                     # 00507c94
    push eax                                     # 00507c95
    call FUN_004fee30                            # 00507c96
    mov dword ptr [esi], eax                     # 00507c9b
    add esp, 0x8                                 # 00507c9d
    add esi, 0x4                                 # 00507ca0
    dec ebx                                      # 00507ca3
    jne.d8 L_00507c8e                            # 00507ca4
L_00507ca6:
    # block 0x00507ca6: entered by jle at 0x00507c80; fall-through of jne at 0x00507ca4, 6 instruction(s), ends with jle to 0x00507e3a (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00507ca6
    {load} xor ecx, ecx                          # 00507ca9
    mov dword ptr [ebp - local_8], ecx           # 00507cab
    mov eax, dword ptr [edx + field_8]           # 00507cae
    test eax, eax                                # 00507cb1
    jle.d32 L_00507e3a                           # 00507cb3
L_00507cb9:
    # block 0x00507cb9: entered by jl at 0x00507e34; fall-through of jle at 0x00507cb3, 5 instruction(s), ends with jle to 0x00507e2a (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00507cb9
    {load} xor eax, eax                          # 00507cbc
    test edx, edx                                # 00507cbe
    mov dword ptr [ebp - local_10], eax          # 00507cc0
    jle.d32 L_00507e2a                           # 00507cc3
    # block 0x00507cc9: entered by fall-through of jle at 0x00507cc3, 2 instruction(s), falls into the block at 0x00507cce
    {load} xor ebx, ebx                          # 00507cc9
    mov dword ptr [ebp - local_18], ebx          # 00507ccb
L_00507cce:
    # block 0x00507cce: entered by jl at 0x00507e24, 2 instruction(s), ends with jne to 0x00507d31 (forward)
    test ecx, ecx                                # 00507cce
    jne.d8 L_00507d31                            # 00507cd0
    # block 0x00507cd2: entered by fall-through of jne at 0x00507cd0, 4 instruction(s), ends with jle to 0x00507d31 (forward)
    mov edx, dword ptr [ebp + arg_14]            # 00507cd2
    {load} xor esi, esi                          # 00507cd5
    test edx, edx                                # 00507cd7
    jle.d8 L_00507d31                            # 00507cd9
    # block 0x00507cdb: entered by fall-through of jle at 0x00507cd9, 4 instruction(s), falls into the block at 0x00507ce7
    mov eax, dword ptr [ebp + arg_8]             # 00507cdb
    mov edi, dword ptr [ebp - local_20]          # 00507cde
    add eax, 0x4                                 # 00507ce1
    mov dword ptr [ebp - local_2c], eax          # 00507ce4
L_00507ce7:
    # block 0x00507ce7: entered by jl at 0x00507d26, 9 instruction(s), calls FUN_005030a0, ends with je to 0x00507e3a (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00507ce7
    mov ecx, dword ptr [ebp - local_2c]          # 00507cea
    push ecx                                     # 00507ced
    mov eax, dword ptr [edx + field_10]          # 00507cee
    push eax                                     # 00507cf1
    call FUN_005030a0                            # 00507cf2
    add esp, 0x8                                 # 00507cf7
    cmp eax, -0x1                                # 00507cfa
    je.d32 L_00507e3a                            # 00507cfd
    # block 0x00507d03: entered by fall-through of je at 0x00507cfd, 8 instruction(s), ends with je to 0x00507e3a (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00507d03
    mov edx, dword ptr [ecx + field_1c]          # 00507d06
    mov ecx, dword ptr [edi]                     # 00507d09
    mov edx, dword ptr [edx + 4*eax]             # 00507d0b
    mov dword ptr [ebx + ecx], edx               # 00507d0e
    mov eax, dword ptr [edi]                     # 00507d11
    cmp dword ptr [ebx + eax], 0x0               # 00507d13
    je.d32 L_00507e3a                            # 00507d17
    # block 0x00507d1d: entered by fall-through of je at 0x00507d17, 5 instruction(s), ends with jl to 0x00507ce7 (backward)
    mov eax, dword ptr [ebp + arg_14]            # 00507d1d
    inc esi                                      # 00507d20
    add edi, 0x4                                 # 00507d21
    {load} cmp esi, eax                          # 00507d24
    jl.d8 L_00507ce7                             # 00507d26
    # block 0x00507d28: entered by fall-through of jl at 0x00507d26, 3 instruction(s), falls into the block at 0x00507d31
    mov eax, dword ptr [ebp - local_10]          # 00507d28
    mov edi, dword ptr [ebp - local_c]           # 00507d2b
    mov ecx, dword ptr [ebp - local_8]           # 00507d2e
L_00507d31:
    # block 0x00507d31: entered by jne at 0x00507cd0; jle at 0x00507cd9, 5 instruction(s), ends with jle to 0x00507e19 (forward)
    mov esi, dword ptr [ebp - local_30]          # 00507d31
    {load} xor edx, edx                          # 00507d34
    {load} cmp esi, edx                          # 00507d36
    mov dword ptr [ebp - local_2c], edx          # 00507d38
    jle.d32 L_00507e19                           # 00507d3b
    # block 0x00507d41: entered by fall-through of jle at 0x00507d3b, 4 instruction(s), falls into the block at 0x00507d4c
    mov dword ptr [ebp - local_4], edx           # 00507d41
    {load} mov edx, eax                          # 00507d44
    imul edx, edi                                # 00507d46
    mov dword ptr [ebp - local_14], edx          # 00507d49
L_00507d4c:
    # block 0x00507d4c: entered by jl at 0x00507e13, 2 instruction(s), ends with jge to 0x00507e19 (forward)
    cmp eax, dword ptr [ebp - local_1c]          # 00507d4c
    jge.d32 L_00507e19                           # 00507d4f
    # block 0x00507d55: entered by fall-through of jge at 0x00507d4f, 4 instruction(s), ends with jle to 0x00507df2 (forward)
    mov edx, dword ptr [ebp + arg_14]            # 00507d55
    mov dword ptr [ebp - local_28], 0x0          # 00507d58
    test edx, edx                                # 00507d5f
    jle.d32 L_00507df2                           # 00507d61
    # block 0x00507d67: entered by fall-through of jle at 0x00507d61, 6 instruction(s), falls into the block at 0x00507d79
    mov esi, dword ptr [ebp - local_20]          # 00507d67
    mov eax, dword ptr [ebp + arg_10]            # 00507d6a
    mov edi, 0x1                                 # 00507d6d
    shl edi, cl                                  # 00507d72
    {load} sub eax, esi                          # 00507d74
    mov dword ptr [ebp - local_34], eax          # 00507d76
L_00507d79:
    # block 0x00507d79: entered by jl at 0x00507de7, 12 instruction(s), ends with je to 0x00507dd5 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 00507d79
    mov edx, dword ptr [esi]                     # 00507d7c
    mov eax, dword ptr [ecx]                     # 00507d7e
    mov ecx, dword ptr [ebp - local_14]          # 00507d80
    {load} add eax, ecx                          # 00507d83
    lea ecx, [ebx + edx]                         # 00507d85
    mov ebx, dword ptr [ebp - local_4]           # 00507d88
    mov edx, dword ptr [ecx]                     # 00507d8b
    mov edx, dword ptr [ebx + edx]               # 00507d8d
    mov ebx, dword ptr [ebp - local_24]          # 00507d90
    test dword ptr [ebx + 4*edx + field_14], edi # 00507d93
    je.d8 L_00507dd5                             # 00507d97
    # block 0x00507d99: entered by fall-through of je at 0x00507d97, 10 instruction(s), ends with je to 0x00507dd5 (forward)
    mov ecx, dword ptr [ecx]                     # 00507d99
    mov edx, dword ptr [ebp - local_4]           # 00507d9b
    mov ecx, dword ptr [edx + ecx]               # 00507d9e
    mov edx, dword ptr [ebp + arg_c]             # 00507da1
    mov edx, dword ptr [edx + field_14]          # 00507da4
    mov ecx, dword ptr [edx + 4*ecx]             # 00507da7
    mov edx, dword ptr [ebp - local_8]           # 00507daa
    mov ecx, dword ptr [ecx + 4*edx]             # 00507dad
    test ecx, ecx                                # 00507db0
    je.d8 L_00507dd5                             # 00507db2
    # block 0x00507db4: entered by fall-through of je at 0x00507db2, 14 instruction(s), calls indirect dword ptr [ebp + 0x18], ends with je to 0x00507e3a (forward)
    mov edx, dword ptr [ebp - local_c]           # 00507db4
    push edx                                     # 00507db7
    mov edx, dword ptr [ebp + arg_8]             # 00507db8
    add edx, 0x4                                 # 00507dbb
    push edx                                     # 00507dbe
    mov edx, dword ptr [ebp - local_34]          # 00507dbf
    mov edx, dword ptr [edx + esi]               # 00507dc2
    lea eax, [edx + 4*eax]                       # 00507dc5
    push eax                                     # 00507dc8
    push ecx                                     # 00507dc9
    call dword ptr [ebp + arg_18]                # 00507dca
    add esp, 0x10                                # 00507dcd
    cmp eax, -0x1                                # 00507dd0
    je.d8 L_00507e3a                             # 00507dd3
L_00507dd5:
    # block 0x00507dd5: entered by je at 0x00507d97; je at 0x00507db2; fall-through of je at 0x00507dd3, 8 instruction(s), ends with jl to 0x00507d79 (backward)
    mov eax, dword ptr [ebp - local_28]          # 00507dd5
    mov ecx, dword ptr [ebp + arg_14]            # 00507dd8
    mov ebx, dword ptr [ebp - local_18]          # 00507ddb
    inc eax                                      # 00507dde
    add esi, 0x4                                 # 00507ddf
    {load} cmp eax, ecx                          # 00507de2
    mov dword ptr [ebp - local_28], eax          # 00507de4
    jl.d8 L_00507d79                             # 00507de7
    # block 0x00507de9: entered by fall-through of jl at 0x00507de7, 3 instruction(s), falls into the block at 0x00507df2
    mov eax, dword ptr [ebp - local_10]          # 00507de9
    mov edi, dword ptr [ebp - local_c]           # 00507dec
    mov ecx, dword ptr [ebp - local_8]           # 00507def
L_00507df2:
    # block 0x00507df2: entered by jle at 0x00507d61, 14 instruction(s), ends with jl to 0x00507d4c (backward)
    mov esi, dword ptr [ebp - local_4]           # 00507df2
    mov edx, dword ptr [ebp - local_2c]          # 00507df5
    add esi, 0x4                                 # 00507df8
    inc edx                                      # 00507dfb
    mov dword ptr [ebp - local_4], esi           # 00507dfc
    mov esi, dword ptr [ebp - local_14]          # 00507dff
    {load} add esi, edi                          # 00507e02
    inc eax                                      # 00507e04
    mov dword ptr [ebp - local_14], esi          # 00507e05
    mov esi, dword ptr [ebp - local_30]          # 00507e08
    {load} cmp edx, esi                          # 00507e0b
    mov dword ptr [ebp - local_2c], edx          # 00507e0d
    mov dword ptr [ebp - local_10], eax          # 00507e10
    jl.d32 L_00507d4c                            # 00507e13
L_00507e19:
    # block 0x00507e19: entered by jle at 0x00507d3b; jge at 0x00507d4f; fall-through of jl at 0x00507e13, 5 instruction(s), ends with jl to 0x00507cce (backward)
    mov edx, dword ptr [ebp - local_1c]          # 00507e19
    add ebx, 0x4                                 # 00507e1c
    {load} cmp eax, edx                          # 00507e1f
    mov dword ptr [ebp - local_18], ebx          # 00507e21
    jl.d32 L_00507cce                            # 00507e24
L_00507e2a:
    # block 0x00507e2a: entered by jle at 0x00507cc3; fall-through of jl at 0x00507e24, 5 instruction(s), ends with jl to 0x00507cb9 (backward)
    mov edx, dword ptr [ebp + arg_c]             # 00507e2a
    inc ecx                                      # 00507e2d
    mov dword ptr [ebp - local_8], ecx           # 00507e2e
    cmp ecx, dword ptr [edx + field_8]           # 00507e31
    jl.d32 L_00507cb9                            # 00507e34
L_00507e3a:
    # block 0x00507e3a: entered by jle at 0x00507cb3; je at 0x00507cfd; je at 0x00507d17; je at 0x00507dd3; more, 8 instruction(s), ends with ret
    lea esp, [ebp - local_40]                    # 00507e3a
    {load} xor eax, eax                          # 00507e3d
    pop edi                                      # 00507e3f
    pop esi                                      # 00507e40
    pop ebx                                      # 00507e41
    {load} mov esp, ebp                          # 00507e42
    pop ebp                                      # 00507e44
    ret                                          # 00507e45

# --- data items (not part of the function) -------------------------
.org 0x00507e46 - 0x401000
PAD_00507e46:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

