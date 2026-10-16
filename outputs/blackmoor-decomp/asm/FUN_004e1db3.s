# FUN_004e1db3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1db3
# extent:       0x004e1db3-0x004e204a (663 code bytes)
# span:         0x004e1db3-0x004e204a (code 663, tables 0, padding 0)
# sha256:       75576e41cf1200fbf5e75c6bab77167727d177b37eb44afd2d1abbcd1ec976f2
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e1db3
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_ce, field_d2, field_d6, field_da, field_17f, field_187; [ecx + n] field_4, field_8, field_c, field_30, field_34, field_17f, field_187; [edx + n] field_4, field_8, field_c, field_10, field_de, field_ea, field_ee, field_187
# callees:      calls FUN_004e1c9f, FUN_004e29ec
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 182 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_ce, 0xce  # offset +0xce
.equ field_d2, 0xd2  # offset +0xd2
.equ field_d6, 0xd6  # offset +0xd6
.equ field_da, 0xda  # offset +0xda
.equ field_de, 0xde  # offset +0xde
.equ field_ea, 0xea  # offset +0xea
.equ field_ee, 0xee  # offset +0xee
.equ field_17f, 0x17f  # offset +0x17f
.equ field_187, 0x187  # offset +0x187

# --- external targets -----------------------------------------------
.set FUN_004e1c9f, .text + (0x004e1c9f - 0x401000)
.set FUN_004e29ec, .text + (0x004e29ec - 0x401000)

.org 0x004e1db3 - 0x401000
.globl FUN_004e1db3
FUN_004e1db3:
    # block 0x004e1db3: entry, 22 instruction(s), calls FUN_004e1c9f, ends with jne to 0x004e1dfc (forward)
    push ebp                                     # 004e1db3
    {load} mov ebp, esp                          # 004e1db4
    push ecx                                     # 004e1db6
    push esi                                     # 004e1db7
    push edi                                     # 004e1db8
    mov dword ptr [ebp - local_4], ecx           # 004e1db9
    mov ecx, dword ptr [ebp - local_4]           # 004e1dbc
    call FUN_004e1c9f                            # 004e1dbf
    mov edi, dword ptr [ebp - local_4]           # 004e1dc4
    add edi, 0x38                                # 004e1dc7
    mov ecx, 0x3b                                # 004e1dca
    mov esi, dword ptr [ebp + arg_8]             # 004e1dcf
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e1dd2
    movsw word ptr es:[edi], word ptr [esi]      # 004e1dd4
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e1dd6
    mov edi, 0x55bee8                            # 004e1dd7
    mov esi, dword ptr [ebp - local_4]           # 004e1ddc
    add esi, 0x38                                # 004e1ddf
    mov ecx, 0xf                                 # 004e1de2
    {load} xor eax, eax                          # 004e1de7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e1de9
    jne.d8 L_004e1dfc                            # 004e1deb
    # block 0x004e1ded: entered by fall-through of jne at 0x004e1deb, 3 instruction(s), ends with forward jump to 0x004e1e09
    mov ecx, dword ptr [ebp - local_4]           # 004e1ded
    mov dword ptr [ecx + field_187], 0x1         # 004e1df0
    jmp.d8 L_004e1e09                            # 004e1dfa
L_004e1dfc:
    # block 0x004e1dfc: entered by jne at 0x004e1deb, 2 instruction(s), falls into the block at 0x004e1e09
    mov edx, dword ptr [ebp - local_4]           # 004e1dfc
    mov dword ptr [edx + field_187], 0x0         # 004e1dff
L_004e1e09:
    # block 0x004e1e09: entered by jmp at 0x004e1dfa, 3 instruction(s), ends with je to 0x004e1ec6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e1e09
    cmp dword ptr [eax + field_187], 0x0         # 004e1e0c
    je.d32 L_004e1ec6                            # 004e1e13
    # block 0x004e1e19: entered by fall-through of je at 0x004e1e13, 41 instruction(s), ends with forward jump to 0x004e1f61
    mov ecx, dword ptr [ebp - local_4]           # 004e1e19
    add ecx, 0x127                               # 004e1e1c
    mov edx, dword ptr [0x5afbfe]                # 004e1e22
    mov dword ptr [ecx], edx                     # 004e1e28
    mov eax, dword ptr [0x5afc02]                # 004e1e2a
    mov dword ptr [ecx + field_4], eax           # 004e1e2f
    mov edx, dword ptr [0x5afc06]                # 004e1e32
    mov dword ptr [ecx + field_8], edx           # 004e1e38
    mov eax, dword ptr [0x5afc0a]                # 004e1e3b
    mov dword ptr [ecx + field_c], eax           # 004e1e40
    mov ecx, dword ptr [ebp - local_4]           # 004e1e43
    add ecx, 0x137                               # 004e1e46
    mov edx, dword ptr [0x5afc0e]                # 004e1e4c
    mov dword ptr [ecx], edx                     # 004e1e52
    mov eax, dword ptr [0x5afc12]                # 004e1e54
    mov dword ptr [ecx + field_4], eax           # 004e1e59
    mov edx, dword ptr [0x5afc16]                # 004e1e5c
    mov dword ptr [ecx + field_8], edx           # 004e1e62
    mov eax, dword ptr [0x5afc1a]                # 004e1e65
    mov dword ptr [ecx + field_c], eax           # 004e1e6a
    mov ecx, dword ptr [ebp - local_4]           # 004e1e6d
    add ecx, 0x147                               # 004e1e70
    mov edx, dword ptr [0x5afc1e]                # 004e1e76
    mov dword ptr [ecx], edx                     # 004e1e7c
    mov eax, dword ptr [0x5afc22]                # 004e1e7e
    mov dword ptr [ecx + field_4], eax           # 004e1e83
    mov edx, dword ptr [0x5afc26]                # 004e1e86
    mov dword ptr [ecx + field_8], edx           # 004e1e8c
    mov eax, dword ptr [0x5afc2a]                # 004e1e8f
    mov dword ptr [ecx + field_c], eax           # 004e1e94
    mov ecx, dword ptr [ebp - local_4]           # 004e1e97
    add ecx, 0x157                               # 004e1e9a
    mov edx, dword ptr [0x5afc2e]                # 004e1ea0
    mov dword ptr [ecx], edx                     # 004e1ea6
    mov eax, dword ptr [0x5afc32]                # 004e1ea8
    mov dword ptr [ecx + field_4], eax           # 004e1ead
    mov edx, dword ptr [0x5afc36]                # 004e1eb0
    mov dword ptr [ecx + field_8], edx           # 004e1eb6
    mov eax, dword ptr [0x5afc3a]                # 004e1eb9
    mov dword ptr [ecx + field_c], eax           # 004e1ebe
    jmp.d32 L_004e1f61                           # 004e1ec1
L_004e1ec6:
    # block 0x004e1ec6: entered by je at 0x004e1e13, 48 instruction(s), falls into the block at 0x004e1f61
    mov ecx, dword ptr [ebp - local_4]           # 004e1ec6
    add ecx, 0x7e                                # 004e1ec9
    mov edx, dword ptr [ebp - local_4]           # 004e1ecc
    add edx, 0x127                               # 004e1ecf
    mov eax, dword ptr [ecx]                     # 004e1ed5
    mov dword ptr [edx], eax                     # 004e1ed7
    mov eax, dword ptr [ecx + field_4]           # 004e1ed9
    mov dword ptr [edx + field_4], eax           # 004e1edc
    mov eax, dword ptr [ecx + field_8]           # 004e1edf
    mov dword ptr [edx + field_8], eax           # 004e1ee2
    mov ecx, dword ptr [ecx + field_c]           # 004e1ee5
    mov dword ptr [edx + field_c], ecx           # 004e1ee8
    mov edx, dword ptr [ebp - local_4]           # 004e1eeb
    add edx, 0x8e                                # 004e1eee
    mov eax, dword ptr [ebp - local_4]           # 004e1ef4
    add eax, 0x137                               # 004e1ef7
    mov ecx, dword ptr [edx]                     # 004e1efc
    mov dword ptr [eax], ecx                     # 004e1efe
    mov ecx, dword ptr [edx + field_4]           # 004e1f00
    mov dword ptr [eax + field_4], ecx           # 004e1f03
    mov ecx, dword ptr [edx + field_8]           # 004e1f06
    mov dword ptr [eax + field_8], ecx           # 004e1f09
    mov edx, dword ptr [edx + field_c]           # 004e1f0c
    mov dword ptr [eax + field_c], edx           # 004e1f0f
    mov eax, dword ptr [ebp - local_4]           # 004e1f12
    add eax, 0x9e                                # 004e1f15
    mov ecx, dword ptr [ebp - local_4]           # 004e1f1a
    add ecx, 0x147                               # 004e1f1d
    mov edx, dword ptr [eax]                     # 004e1f23
    mov dword ptr [ecx], edx                     # 004e1f25
    mov edx, dword ptr [eax + field_4]           # 004e1f27
    mov dword ptr [ecx + field_4], edx           # 004e1f2a
    mov edx, dword ptr [eax + field_8]           # 004e1f2d
    mov dword ptr [ecx + field_8], edx           # 004e1f30
    mov eax, dword ptr [eax + field_c]           # 004e1f33
    mov dword ptr [ecx + field_c], eax           # 004e1f36
    mov ecx, dword ptr [ebp - local_4]           # 004e1f39
    add ecx, 0xae                                # 004e1f3c
    mov edx, dword ptr [ebp - local_4]           # 004e1f42
    add edx, 0x157                               # 004e1f45
    mov eax, dword ptr [ecx]                     # 004e1f4b
    mov dword ptr [edx], eax                     # 004e1f4d
    mov eax, dword ptr [ecx + field_4]           # 004e1f4f
    mov dword ptr [edx + field_4], eax           # 004e1f52
    mov eax, dword ptr [ecx + field_8]           # 004e1f55
    mov dword ptr [edx + field_8], eax           # 004e1f58
    mov ecx, dword ptr [ecx + field_c]           # 004e1f5b
    mov dword ptr [edx + field_c], ecx           # 004e1f5e
L_004e1f61:
    # block 0x004e1f61: entered by jmp at 0x004e1ec1, 3 instruction(s), ends with je to 0x004e1fc3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e1f61
    cmp dword ptr [edx + field_de], 0x0          # 004e1f64
    je.d8 L_004e1fc3                             # 004e1f6b
    # block 0x004e1f6d: entered by fall-through of je at 0x004e1f6b, 21 instruction(s), ends with forward jump to 0x004e1fe7
    mov eax, dword ptr [ebp - local_4]           # 004e1f6d
    mov ecx, dword ptr [eax + field_ce]          # 004e1f70
    add ecx, dword ptr [0x583186]                # 004e1f76
    mov edx, dword ptr [ebp - local_4]           # 004e1f7c
    mov dword ptr [edx + field_4], ecx           # 004e1f7f
    mov eax, dword ptr [ebp - local_4]           # 004e1f82
    mov ecx, dword ptr [eax + field_d6]          # 004e1f85
    add ecx, dword ptr [0x583186]                # 004e1f8b
    mov edx, dword ptr [ebp - local_4]           # 004e1f91
    mov dword ptr [edx + field_c], ecx           # 004e1f94
    mov eax, dword ptr [ebp - local_4]           # 004e1f97
    mov ecx, dword ptr [eax + field_d2]          # 004e1f9a
    add ecx, dword ptr [0x58318a]                # 004e1fa0
    mov edx, dword ptr [ebp - local_4]           # 004e1fa6
    mov dword ptr [edx + field_8], ecx           # 004e1fa9
    mov eax, dword ptr [ebp - local_4]           # 004e1fac
    mov ecx, dword ptr [eax + field_da]          # 004e1faf
    add ecx, dword ptr [0x58318a]                # 004e1fb5
    mov edx, dword ptr [ebp - local_4]           # 004e1fbb
    mov dword ptr [edx + field_10], ecx          # 004e1fbe
    jmp.d8 L_004e1fe7                            # 004e1fc1
L_004e1fc3:
    # block 0x004e1fc3: entered by je at 0x004e1f6b, 12 instruction(s), falls into the block at 0x004e1fe7
    mov eax, dword ptr [ebp - local_4]           # 004e1fc3
    add eax, 0xce                                # 004e1fc6
    mov ecx, dword ptr [ebp - local_4]           # 004e1fcb
    add ecx, 0x4                                 # 004e1fce
    mov edx, dword ptr [eax]                     # 004e1fd1
    mov dword ptr [ecx], edx                     # 004e1fd3
    mov edx, dword ptr [eax + field_4]           # 004e1fd5
    mov dword ptr [ecx + field_4], edx           # 004e1fd8
    mov edx, dword ptr [eax + field_8]           # 004e1fdb
    mov dword ptr [ecx + field_8], edx           # 004e1fde
    mov eax, dword ptr [eax + field_c]           # 004e1fe1
    mov dword ptr [ecx + field_c], eax           # 004e1fe4
L_004e1fe7:
    # block 0x004e1fe7: entered by jmp at 0x004e1fc1, 15 instruction(s), ends with jne to 0x004e202d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e1fe7
    mov edx, dword ptr [ebp - local_4]           # 004e1fea
    mov eax, dword ptr [edx + field_ee]          # 004e1fed
    mov dword ptr [ecx + field_30], eax          # 004e1ff3
    mov ecx, dword ptr [ebp - local_4]           # 004e1ff6
    mov edx, dword ptr [ebp - local_4]           # 004e1ff9
    mov eax, dword ptr [edx + field_ea]          # 004e1ffc
    mov dword ptr [ecx + field_34], eax          # 004e2002
    mov edi, 0x55bef8                            # 004e2005
    mov esi, dword ptr [ebp - local_4]           # 004e200a
    add esi, 0xf6                                # 004e200d
    mov ecx, 0x9                                 # 004e2013
    {load} xor edx, edx                          # 004e2018
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e201a
    jne.d8 L_004e202d                            # 004e201c
    # block 0x004e201e: entered by fall-through of jne at 0x004e201c, 3 instruction(s), ends with forward jump to 0x004e203a
    mov eax, dword ptr [ebp - local_4]           # 004e201e
    mov dword ptr [eax + field_17f], 0x0         # 004e2021
    jmp.d8 L_004e203a                            # 004e202b
L_004e202d:
    # block 0x004e202d: entered by jne at 0x004e201c, 2 instruction(s), falls into the block at 0x004e203a
    mov ecx, dword ptr [ebp - local_4]           # 004e202d
    mov dword ptr [ecx + field_17f], 0x1         # 004e2030
L_004e203a:
    # block 0x004e203a: entered by jmp at 0x004e202b, 7 instruction(s), calls FUN_004e29ec, ends with ret 0x4
    mov ecx, dword ptr [ebp - local_4]           # 004e203a
    call FUN_004e29ec                            # 004e203d
    pop edi                                      # 004e2042
    pop esi                                      # 004e2043
    {load} mov esp, ebp                          # 004e2044
    pop ebp                                      # 004e2046
    ret 0x4                                      # 004e2047

