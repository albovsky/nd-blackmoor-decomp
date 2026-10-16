# FUN_004d7ea4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d7ea4
# extent:       0x004d7ea4-0x004d812e (650 code bytes)
# span:         0x004d7ea4-0x004d812e (code 650, tables 0, padding 0)
# sha256:       deab16c4c48f628b11a18883897ce5f7dc9acc45c6ede07f288109ce45377628
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d7ea4
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       19 ebp-relative slot(s): local_4, local_8, local_c, local_d, local_e, local_14, local_18, local_1c, local_20, local_21, local_22, local_28 and 7 more
# fields:       [eax + n] field_98ac; [ecx + n] field_1, field_98ac; [edx + n] field_1, field_98ac
# callees:      calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, FUN_0050cf61, FUN_0050cee4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 205 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_d, 0xd  # offset -0xd
.equ local_e, 0xe  # offset -0xe
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_21, 0x21  # offset -0x21
.equ local_22, 0x22  # offset -0x22
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_35, 0x35  # offset -0x35
.equ local_36, 0x36  # offset -0x36
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ field_98ac, 0x98ac  # offset +0x98ac

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)

.org 0x004d7ea4 - 0x401000
.globl FUN_004d7ea4
FUN_004d7ea4:
    # block 0x004d7ea4: entry, 18 instruction(s), ends with jne to 0x004d7f09 (forward)
    push ebp                                     # 004d7ea4
    {load} mov ebp, esp                          # 004d7ea5
    sub esp, 0x40                                # 004d7ea7
    push esi                                     # 004d7eaa
    push edi                                     # 004d7eab
    mov dword ptr [ebp - local_4], ecx           # 004d7eac
    mov ecx, 0xa6c4                              # 004d7eaf
    {load} xor eax, eax                          # 004d7eb4
    mov edi, dword ptr [ebp - local_4]           # 004d7eb6
    add edi, 0x98b0                              # 004d7eb9
    rep stosd dword ptr es:[edi], eax            # 004d7ebf
    stosw word ptr es:[edi], ax                  # 004d7ec1
    mov edi, 0x55a820                            # 004d7ec3
    mov esi, dword ptr [ebp + arg_8]             # 004d7ec8
    mov ecx, 0xe                                 # 004d7ecb
    {load} xor eax, eax                          # 004d7ed0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004d7ed2
    jne.d8 L_004d7f09                            # 004d7ed4
    # block 0x004d7ed6: entered by fall-through of jne at 0x004d7ed4, 19 instruction(s), ends with forward jump to 0x004d7f34
    mov ecx, dword ptr [ebp - local_4]           # 004d7ed6
    add ecx, 0x29b                               # 004d7ed9
    {load} mov edi, ecx                          # 004d7edf
    mov edx, dword ptr [ebp - local_4]           # 004d7ee1
    add edx, 0x333c2                             # 004d7ee4
    or ecx, -0x1                                 # 004d7eea
    {load} xor eax, eax                          # 004d7eed
    repne scasb al, byte ptr es:[edi]            # 004d7eef
    not ecx                                      # 004d7ef1
    {load} sub edi, ecx                          # 004d7ef3
    {load} mov esi, edi                          # 004d7ef5
    {load} mov eax, ecx                          # 004d7ef7
    {load} mov edi, edx                          # 004d7ef9
    shr ecx, 0x2                                 # 004d7efb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7efe
    {load} mov ecx, eax                          # 004d7f00
    and ecx, 0x3                                 # 004d7f02
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d7f05
    jmp.d8 L_004d7f34                            # 004d7f07
L_004d7f09:
    # block 0x004d7f09: entered by jne at 0x004d7ed4, 17 instruction(s), falls into the block at 0x004d7f34
    mov edi, dword ptr [ebp + arg_8]             # 004d7f09
    mov ecx, dword ptr [ebp - local_4]           # 004d7f0c
    add ecx, 0x333c2                             # 004d7f0f
    {load} mov edx, ecx                          # 004d7f15
    or ecx, -0x1                                 # 004d7f17
    {load} xor eax, eax                          # 004d7f1a
    repne scasb al, byte ptr es:[edi]            # 004d7f1c
    not ecx                                      # 004d7f1e
    {load} sub edi, ecx                          # 004d7f20
    {load} mov esi, edi                          # 004d7f22
    {load} mov eax, ecx                          # 004d7f24
    {load} mov edi, edx                          # 004d7f26
    shr ecx, 0x2                                 # 004d7f28
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d7f2b
    {load} mov ecx, eax                          # 004d7f2d
    and ecx, 0x3                                 # 004d7f2f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d7f32
L_004d7f34:
    # block 0x004d7f34: entered by jmp at 0x004d7f07, 29 instruction(s), calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004d7fad (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d7f34
    add ecx, 0x2af                               # 004d7f37
    push ecx                                     # 004d7f3d
    push 0x55a830                                # 004d7f3e
    mov edx, dword ptr [ebp - local_4]           # 004d7f43
    add edx, 0x333e3                             # 004d7f46
    push edx                                     # 004d7f4c
    call FUN_0050ca3e                            # 004d7f4d
    add esp, 0xc                                 # 004d7f52
    mov eax, dword ptr [ebp - local_4]           # 004d7f55
    add eax, 0x333e3                             # 004d7f58
    push eax                                     # 004d7f5d
    mov ecx, dword ptr [ebp - local_4]           # 004d7f5e
    add ecx, 0x333c2                             # 004d7f61
    push ecx                                     # 004d7f67
    push 0x63a3c9                                # 004d7f68
    push 0x63a9ac                                # 004d7f6d
    push 0x63888b                                # 004d7f72
    call FUN_0050cd72                            # 004d7f77
    add esp, 0x14                                # 004d7f7c
    push 0x55a834                                # 004d7f7f
    push 0x63888b                                # 004d7f84
    call FUN_0050d0a9                            # 004d7f89
    add esp, 0x8                                 # 004d7f8e
    mov edx, dword ptr [ebp - local_4]           # 004d7f91
    mov dword ptr [edx + field_98ac], eax        # 004d7f94
    mov eax, dword ptr [ebp - local_4]           # 004d7f9a
    cmp dword ptr [eax + field_98ac], 0x0        # 004d7f9d
    jne.d8 L_004d7fad                            # 004d7fa4
    # block 0x004d7fa6: entered by fall-through of jne at 0x004d7fa4, 2 instruction(s), ends with forward jump to 0x004d8126
    {load} xor eax, eax                          # 004d7fa6
    jmp.d32 L_004d8126                           # 004d7fa8
L_004d7fad:
    # block 0x004d7fad: entered by jne at 0x004d7fa4, 12 instruction(s), calls FUN_0050cf61, ends with je to 0x004d7fdb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d7fad
    mov edx, dword ptr [ecx + field_98ac]        # 004d7fb0
    push edx                                     # 004d7fb6
    push 0x1                                     # 004d7fb7
    push 0x29b12                                 # 004d7fb9
    mov eax, dword ptr [ebp - local_4]           # 004d7fbe
    add eax, 0x98b0                              # 004d7fc1
    push eax                                     # 004d7fc6
    call FUN_0050cf61                            # 004d7fc7
    add esp, 0x10                                # 004d7fcc
    cmp eax, 0x1                                 # 004d7fcf
    je.d8 L_004d7fdb                             # 004d7fd2
    # block 0x004d7fd4: entered by fall-through of je at 0x004d7fd2, 2 instruction(s), ends with forward jump to 0x004d8126
    {load} xor eax, eax                          # 004d7fd4
    jmp.d32 L_004d8126                           # 004d7fd6
L_004d7fdb:
    # block 0x004d7fdb: entered by je at 0x004d7fd2, 4 instruction(s), falls into the block at 0x004d7fee
    mov dword ptr [ebp - local_8], 0x5b0113      # 004d7fdb
    mov ecx, dword ptr [ebp - local_4]           # 004d7fe2
    add ecx, 0x98b0                              # 004d7fe5
    mov dword ptr [ebp - local_c], ecx           # 004d7feb
L_004d7fee:
    # block 0x004d7fee: entered by jne at 0x004d8020, 6 instruction(s), ends with jne to 0x004d802b (forward)
    mov edx, dword ptr [ebp - local_c]           # 004d7fee
    mov al, byte ptr [edx]                       # 004d7ff1
    mov byte ptr [ebp - local_d], al             # 004d7ff3
    mov ecx, dword ptr [ebp - local_8]           # 004d7ff6
    cmp al, byte ptr [ecx]                       # 004d7ff9
    jne.d8 L_004d802b                            # 004d7ffb
    # block 0x004d7ffd: entered by fall-through of jne at 0x004d7ffb, 2 instruction(s), ends with je to 0x004d8022 (forward)
    cmp byte ptr [ebp - local_d], 0x0            # 004d7ffd
    je.d8 L_004d8022                             # 004d8001
    # block 0x004d8003: entered by fall-through of je at 0x004d8001, 6 instruction(s), ends with jne to 0x004d802b (forward)
    mov edx, dword ptr [ebp - local_c]           # 004d8003
    mov al, byte ptr [edx + field_1]             # 004d8006
    mov byte ptr [ebp - local_e], al             # 004d8009
    mov ecx, dword ptr [ebp - local_8]           # 004d800c
    cmp al, byte ptr [ecx + field_1]             # 004d800f
    jne.d8 L_004d802b                            # 004d8012
    # block 0x004d8014: entered by fall-through of jne at 0x004d8012, 4 instruction(s), ends with jne to 0x004d7fee (backward)
    add dword ptr [ebp - local_c], 0x2           # 004d8014
    add dword ptr [ebp - local_8], 0x2           # 004d8018
    cmp byte ptr [ebp - local_e], 0x0            # 004d801c
    jne.d8 L_004d7fee                            # 004d8020
L_004d8022:
    # block 0x004d8022: entered by je at 0x004d8001; fall-through of jne at 0x004d8020, 2 instruction(s), ends with forward jump to 0x004d8033
    mov dword ptr [ebp - local_14], 0x0          # 004d8022
    jmp.d8 L_004d8033                            # 004d8029
L_004d802b:
    # block 0x004d802b: entered by jne at 0x004d7ffb; jne at 0x004d8012, 3 instruction(s), falls into the block at 0x004d8033
    {load} sbb edx, edx                          # 004d802b
    sbb edx, -0x1                                # 004d802d
    mov dword ptr [ebp - local_14], edx          # 004d8030
L_004d8033:
    # block 0x004d8033: entered by jmp at 0x004d8029, 4 instruction(s), ends with jne to 0x004d810b (forward)
    mov eax, dword ptr [ebp - local_14]          # 004d8033
    mov dword ptr [ebp - local_18], eax          # 004d8036
    cmp dword ptr [ebp - local_18], 0x0          # 004d8039
    jne.d32 L_004d810b                           # 004d803d
    # block 0x004d8043: entered by fall-through of jne at 0x004d803d, 4 instruction(s), falls into the block at 0x004d8056
    mov dword ptr [ebp - local_1c], 0x5b0131     # 004d8043
    mov ecx, dword ptr [ebp - local_4]           # 004d804a
    add ecx, 0x98ce                              # 004d804d
    mov dword ptr [ebp - local_20], ecx          # 004d8053
L_004d8056:
    # block 0x004d8056: entered by jne at 0x004d8088, 6 instruction(s), ends with jne to 0x004d8093 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004d8056
    mov al, byte ptr [edx]                       # 004d8059
    mov byte ptr [ebp - local_21], al            # 004d805b
    mov ecx, dword ptr [ebp - local_1c]          # 004d805e
    cmp al, byte ptr [ecx]                       # 004d8061
    jne.d8 L_004d8093                            # 004d8063
    # block 0x004d8065: entered by fall-through of jne at 0x004d8063, 2 instruction(s), ends with je to 0x004d808a (forward)
    cmp byte ptr [ebp - local_21], 0x0           # 004d8065
    je.d8 L_004d808a                             # 004d8069
    # block 0x004d806b: entered by fall-through of je at 0x004d8069, 6 instruction(s), ends with jne to 0x004d8093 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004d806b
    mov al, byte ptr [edx + field_1]             # 004d806e
    mov byte ptr [ebp - local_22], al            # 004d8071
    mov ecx, dword ptr [ebp - local_1c]          # 004d8074
    cmp al, byte ptr [ecx + field_1]             # 004d8077
    jne.d8 L_004d8093                            # 004d807a
    # block 0x004d807c: entered by fall-through of jne at 0x004d807a, 4 instruction(s), ends with jne to 0x004d8056 (backward)
    add dword ptr [ebp - local_20], 0x2          # 004d807c
    add dword ptr [ebp - local_1c], 0x2          # 004d8080
    cmp byte ptr [ebp - local_22], 0x0           # 004d8084
    jne.d8 L_004d8056                            # 004d8088
L_004d808a:
    # block 0x004d808a: entered by je at 0x004d8069; fall-through of jne at 0x004d8088, 2 instruction(s), ends with forward jump to 0x004d809b
    mov dword ptr [ebp - local_28], 0x0          # 004d808a
    jmp.d8 L_004d809b                            # 004d8091
L_004d8093:
    # block 0x004d8093: entered by jne at 0x004d8063; jne at 0x004d807a, 3 instruction(s), falls into the block at 0x004d809b
    {load} sbb edx, edx                          # 004d8093
    sbb edx, -0x1                                # 004d8095
    mov dword ptr [ebp - local_28], edx          # 004d8098
L_004d809b:
    # block 0x004d809b: entered by jmp at 0x004d8091, 4 instruction(s), ends with jne to 0x004d810b (forward)
    mov eax, dword ptr [ebp - local_28]          # 004d809b
    mov dword ptr [ebp - local_2c], eax          # 004d809e
    cmp dword ptr [ebp - local_2c], 0x0          # 004d80a1
    jne.d8 L_004d810b                            # 004d80a5
    # block 0x004d80a7: entered by fall-through of jne at 0x004d80a5, 4 instruction(s), falls into the block at 0x004d80ba
    mov dword ptr [ebp - local_30], 0x5b014f     # 004d80a7
    mov ecx, dword ptr [ebp - local_4]           # 004d80ae
    add ecx, 0x98ec                              # 004d80b1
    mov dword ptr [ebp - local_34], ecx          # 004d80b7
L_004d80ba:
    # block 0x004d80ba: entered by jne at 0x004d80ec, 6 instruction(s), ends with jne to 0x004d80f7 (forward)
    mov edx, dword ptr [ebp - local_34]          # 004d80ba
    mov al, byte ptr [edx]                       # 004d80bd
    mov byte ptr [ebp - local_35], al            # 004d80bf
    mov ecx, dword ptr [ebp - local_30]          # 004d80c2
    cmp al, byte ptr [ecx]                       # 004d80c5
    jne.d8 L_004d80f7                            # 004d80c7
    # block 0x004d80c9: entered by fall-through of jne at 0x004d80c7, 2 instruction(s), ends with je to 0x004d80ee (forward)
    cmp byte ptr [ebp - local_35], 0x0           # 004d80c9
    je.d8 L_004d80ee                             # 004d80cd
    # block 0x004d80cf: entered by fall-through of je at 0x004d80cd, 6 instruction(s), ends with jne to 0x004d80f7 (forward)
    mov edx, dword ptr [ebp - local_34]          # 004d80cf
    mov al, byte ptr [edx + field_1]             # 004d80d2
    mov byte ptr [ebp - local_36], al            # 004d80d5
    mov ecx, dword ptr [ebp - local_30]          # 004d80d8
    cmp al, byte ptr [ecx + field_1]             # 004d80db
    jne.d8 L_004d80f7                            # 004d80de
    # block 0x004d80e0: entered by fall-through of jne at 0x004d80de, 4 instruction(s), ends with jne to 0x004d80ba (backward)
    add dword ptr [ebp - local_34], 0x2          # 004d80e0
    add dword ptr [ebp - local_30], 0x2          # 004d80e4
    cmp byte ptr [ebp - local_36], 0x0           # 004d80e8
    jne.d8 L_004d80ba                            # 004d80ec
L_004d80ee:
    # block 0x004d80ee: entered by je at 0x004d80cd; fall-through of jne at 0x004d80ec, 2 instruction(s), ends with forward jump to 0x004d80ff
    mov dword ptr [ebp - local_3c], 0x0          # 004d80ee
    jmp.d8 L_004d80ff                            # 004d80f5
L_004d80f7:
    # block 0x004d80f7: entered by jne at 0x004d80c7; jne at 0x004d80de, 3 instruction(s), falls into the block at 0x004d80ff
    {load} sbb edx, edx                          # 004d80f7
    sbb edx, -0x1                                # 004d80f9
    mov dword ptr [ebp - local_3c], edx          # 004d80fc
L_004d80ff:
    # block 0x004d80ff: entered by jmp at 0x004d80f5, 4 instruction(s), ends with je to 0x004d810f (forward)
    mov eax, dword ptr [ebp - local_3c]          # 004d80ff
    mov dword ptr [ebp - local_40], eax          # 004d8102
    cmp dword ptr [ebp - local_40], 0x0          # 004d8105
    je.d8 L_004d810f                             # 004d8109
L_004d810b:
    # block 0x004d810b: entered by jne at 0x004d803d; jne at 0x004d80a5; fall-through of je at 0x004d8109, 2 instruction(s), ends with forward jump to 0x004d8126
    {load} xor eax, eax                          # 004d810b
    jmp.d8 L_004d8126                            # 004d810d
L_004d810f:
    # block 0x004d810f: entered by je at 0x004d8109, 6 instruction(s), calls FUN_0050cee4, falls into the block at 0x004d8126
    mov ecx, dword ptr [ebp - local_4]           # 004d810f
    mov edx, dword ptr [ecx + field_98ac]        # 004d8112
    push edx                                     # 004d8118
    call FUN_0050cee4                            # 004d8119
    add esp, 0x4                                 # 004d811e
    mov eax, 0x1                                 # 004d8121
L_004d8126:
    # block 0x004d8126: entered by jmp at 0x004d7fa8; jmp at 0x004d7fd6; jmp at 0x004d810d, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004d8126
    pop esi                                      # 004d8127
    {load} mov esp, ebp                          # 004d8128
    pop ebp                                      # 004d812a
    ret 0x4                                      # 004d812b

