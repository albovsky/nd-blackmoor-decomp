# FUN_004e204a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e204a
# extent:       0x004e204a-0x004e22fd (691 code bytes)
# span:         0x004e204a-0x004e22fd (code 691, tables 0, padding 0)
# sha256:       194e6aa771b336f416c25c27f95b11a4f8d4c3156e63082ae4e5503837ba606e
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e204a
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_ce, field_d2, field_d6, field_da, field_17f, field_187; [ecx + n] field_4, field_8, field_c, field_30, field_34, field_17f, field_187, field_18b; [edx + n] field_4, field_8, field_c, field_10, field_24, field_de, field_ea, field_ee, field_187
# callees:      calls FUN_004e1c9f, FUN_004e29ec
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 189 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_24, 0x24  # offset +0x24
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
.equ field_18b, 0x18b  # offset +0x18b

# --- external targets -----------------------------------------------
.set FUN_004e1c9f, .text + (0x004e1c9f - 0x401000)
.set FUN_004e29ec, .text + (0x004e29ec - 0x401000)

.org 0x004e204a - 0x401000
.globl FUN_004e204a
FUN_004e204a:
    # block 0x004e204a: entry, 22 instruction(s), calls FUN_004e1c9f, ends with jne to 0x004e2093 (forward)
    push ebp                                     # 004e204a
    {load} mov ebp, esp                          # 004e204b
    push ecx                                     # 004e204d
    push esi                                     # 004e204e
    push edi                                     # 004e204f
    mov dword ptr [ebp - local_4], ecx           # 004e2050
    mov ecx, dword ptr [ebp - local_4]           # 004e2053
    call FUN_004e1c9f                            # 004e2056
    mov edi, dword ptr [ebp - local_4]           # 004e205b
    add edi, 0x38                                # 004e205e
    mov ecx, 0x3b                                # 004e2061
    mov esi, dword ptr [ebp + arg_8]             # 004e2066
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e2069
    movsw word ptr es:[edi], word ptr [esi]      # 004e206b
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e206d
    mov edi, 0x55bf04                            # 004e206e
    mov esi, dword ptr [ebp - local_4]           # 004e2073
    add esi, 0x38                                # 004e2076
    mov ecx, 0xf                                 # 004e2079
    {load} xor eax, eax                          # 004e207e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e2080
    jne.d8 L_004e2093                            # 004e2082
    # block 0x004e2084: entered by fall-through of jne at 0x004e2082, 3 instruction(s), ends with forward jump to 0x004e20a0
    mov ecx, dword ptr [ebp - local_4]           # 004e2084
    mov dword ptr [ecx + field_187], 0x1         # 004e2087
    jmp.d8 L_004e20a0                            # 004e2091
L_004e2093:
    # block 0x004e2093: entered by jne at 0x004e2082, 2 instruction(s), falls into the block at 0x004e20a0
    mov edx, dword ptr [ebp - local_4]           # 004e2093
    mov dword ptr [edx + field_187], 0x0         # 004e2096
L_004e20a0:
    # block 0x004e20a0: entered by jmp at 0x004e2091, 3 instruction(s), ends with je to 0x004e215d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e20a0
    cmp dword ptr [eax + field_187], 0x0         # 004e20a3
    je.d32 L_004e215d                            # 004e20aa
    # block 0x004e20b0: entered by fall-through of je at 0x004e20aa, 41 instruction(s), ends with forward jump to 0x004e21f8
    mov ecx, dword ptr [ebp - local_4]           # 004e20b0
    add ecx, 0x127                               # 004e20b3
    mov edx, dword ptr [0x5afbfe]                # 004e20b9
    mov dword ptr [ecx], edx                     # 004e20bf
    mov eax, dword ptr [0x5afc02]                # 004e20c1
    mov dword ptr [ecx + field_4], eax           # 004e20c6
    mov edx, dword ptr [0x5afc06]                # 004e20c9
    mov dword ptr [ecx + field_8], edx           # 004e20cf
    mov eax, dword ptr [0x5afc0a]                # 004e20d2
    mov dword ptr [ecx + field_c], eax           # 004e20d7
    mov ecx, dword ptr [ebp - local_4]           # 004e20da
    add ecx, 0x137                               # 004e20dd
    mov edx, dword ptr [0x5afc0e]                # 004e20e3
    mov dword ptr [ecx], edx                     # 004e20e9
    mov eax, dword ptr [0x5afc12]                # 004e20eb
    mov dword ptr [ecx + field_4], eax           # 004e20f0
    mov edx, dword ptr [0x5afc16]                # 004e20f3
    mov dword ptr [ecx + field_8], edx           # 004e20f9
    mov eax, dword ptr [0x5afc1a]                # 004e20fc
    mov dword ptr [ecx + field_c], eax           # 004e2101
    mov ecx, dword ptr [ebp - local_4]           # 004e2104
    add ecx, 0x147                               # 004e2107
    mov edx, dword ptr [0x5afc1e]                # 004e210d
    mov dword ptr [ecx], edx                     # 004e2113
    mov eax, dword ptr [0x5afc22]                # 004e2115
    mov dword ptr [ecx + field_4], eax           # 004e211a
    mov edx, dword ptr [0x5afc26]                # 004e211d
    mov dword ptr [ecx + field_8], edx           # 004e2123
    mov eax, dword ptr [0x5afc2a]                # 004e2126
    mov dword ptr [ecx + field_c], eax           # 004e212b
    mov ecx, dword ptr [ebp - local_4]           # 004e212e
    add ecx, 0x157                               # 004e2131
    mov edx, dword ptr [0x5afc2e]                # 004e2137
    mov dword ptr [ecx], edx                     # 004e213d
    mov eax, dword ptr [0x5afc32]                # 004e213f
    mov dword ptr [ecx + field_4], eax           # 004e2144
    mov edx, dword ptr [0x5afc36]                # 004e2147
    mov dword ptr [ecx + field_8], edx           # 004e214d
    mov eax, dword ptr [0x5afc3a]                # 004e2150
    mov dword ptr [ecx + field_c], eax           # 004e2155
    jmp.d32 L_004e21f8                           # 004e2158
L_004e215d:
    # block 0x004e215d: entered by je at 0x004e20aa, 48 instruction(s), falls into the block at 0x004e21f8
    mov ecx, dword ptr [ebp - local_4]           # 004e215d
    add ecx, 0x7e                                # 004e2160
    mov edx, dword ptr [ebp - local_4]           # 004e2163
    add edx, 0x127                               # 004e2166
    mov eax, dword ptr [ecx]                     # 004e216c
    mov dword ptr [edx], eax                     # 004e216e
    mov eax, dword ptr [ecx + field_4]           # 004e2170
    mov dword ptr [edx + field_4], eax           # 004e2173
    mov eax, dword ptr [ecx + field_8]           # 004e2176
    mov dword ptr [edx + field_8], eax           # 004e2179
    mov ecx, dword ptr [ecx + field_c]           # 004e217c
    mov dword ptr [edx + field_c], ecx           # 004e217f
    mov edx, dword ptr [ebp - local_4]           # 004e2182
    add edx, 0x8e                                # 004e2185
    mov eax, dword ptr [ebp - local_4]           # 004e218b
    add eax, 0x137                               # 004e218e
    mov ecx, dword ptr [edx]                     # 004e2193
    mov dword ptr [eax], ecx                     # 004e2195
    mov ecx, dword ptr [edx + field_4]           # 004e2197
    mov dword ptr [eax + field_4], ecx           # 004e219a
    mov ecx, dword ptr [edx + field_8]           # 004e219d
    mov dword ptr [eax + field_8], ecx           # 004e21a0
    mov edx, dword ptr [edx + field_c]           # 004e21a3
    mov dword ptr [eax + field_c], edx           # 004e21a6
    mov eax, dword ptr [ebp - local_4]           # 004e21a9
    add eax, 0x9e                                # 004e21ac
    mov ecx, dword ptr [ebp - local_4]           # 004e21b1
    add ecx, 0x147                               # 004e21b4
    mov edx, dword ptr [eax]                     # 004e21ba
    mov dword ptr [ecx], edx                     # 004e21bc
    mov edx, dword ptr [eax + field_4]           # 004e21be
    mov dword ptr [ecx + field_4], edx           # 004e21c1
    mov edx, dword ptr [eax + field_8]           # 004e21c4
    mov dword ptr [ecx + field_8], edx           # 004e21c7
    mov eax, dword ptr [eax + field_c]           # 004e21ca
    mov dword ptr [ecx + field_c], eax           # 004e21cd
    mov ecx, dword ptr [ebp - local_4]           # 004e21d0
    add ecx, 0xae                                # 004e21d3
    mov edx, dword ptr [ebp - local_4]           # 004e21d9
    add edx, 0x157                               # 004e21dc
    mov eax, dword ptr [ecx]                     # 004e21e2
    mov dword ptr [edx], eax                     # 004e21e4
    mov eax, dword ptr [ecx + field_4]           # 004e21e6
    mov dword ptr [edx + field_4], eax           # 004e21e9
    mov eax, dword ptr [ecx + field_8]           # 004e21ec
    mov dword ptr [edx + field_8], eax           # 004e21ef
    mov ecx, dword ptr [ecx + field_c]           # 004e21f2
    mov dword ptr [edx + field_c], ecx           # 004e21f5
L_004e21f8:
    # block 0x004e21f8: entered by jmp at 0x004e2158, 3 instruction(s), ends with je to 0x004e225a (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e21f8
    cmp dword ptr [edx + field_de], 0x0          # 004e21fb
    je.d8 L_004e225a                             # 004e2202
    # block 0x004e2204: entered by fall-through of je at 0x004e2202, 21 instruction(s), ends with forward jump to 0x004e227e
    mov eax, dword ptr [ebp - local_4]           # 004e2204
    mov ecx, dword ptr [eax + field_ce]          # 004e2207
    add ecx, dword ptr [0x583186]                # 004e220d
    mov edx, dword ptr [ebp - local_4]           # 004e2213
    mov dword ptr [edx + field_4], ecx           # 004e2216
    mov eax, dword ptr [ebp - local_4]           # 004e2219
    mov ecx, dword ptr [eax + field_d6]          # 004e221c
    add ecx, dword ptr [0x583186]                # 004e2222
    mov edx, dword ptr [ebp - local_4]           # 004e2228
    mov dword ptr [edx + field_c], ecx           # 004e222b
    mov eax, dword ptr [ebp - local_4]           # 004e222e
    mov ecx, dword ptr [eax + field_d2]          # 004e2231
    add ecx, dword ptr [0x58318a]                # 004e2237
    mov edx, dword ptr [ebp - local_4]           # 004e223d
    mov dword ptr [edx + field_8], ecx           # 004e2240
    mov eax, dword ptr [ebp - local_4]           # 004e2243
    mov ecx, dword ptr [eax + field_da]          # 004e2246
    add ecx, dword ptr [0x58318a]                # 004e224c
    mov edx, dword ptr [ebp - local_4]           # 004e2252
    mov dword ptr [edx + field_10], ecx          # 004e2255
    jmp.d8 L_004e227e                            # 004e2258
L_004e225a:
    # block 0x004e225a: entered by je at 0x004e2202, 12 instruction(s), falls into the block at 0x004e227e
    mov eax, dword ptr [ebp - local_4]           # 004e225a
    add eax, 0xce                                # 004e225d
    mov ecx, dword ptr [ebp - local_4]           # 004e2262
    add ecx, 0x4                                 # 004e2265
    mov edx, dword ptr [eax]                     # 004e2268
    mov dword ptr [ecx], edx                     # 004e226a
    mov edx, dword ptr [eax + field_4]           # 004e226c
    mov dword ptr [ecx + field_4], edx           # 004e226f
    mov edx, dword ptr [eax + field_8]           # 004e2272
    mov dword ptr [ecx + field_8], edx           # 004e2275
    mov eax, dword ptr [eax + field_c]           # 004e2278
    mov dword ptr [ecx + field_c], eax           # 004e227b
L_004e227e:
    # block 0x004e227e: entered by jmp at 0x004e2258, 15 instruction(s), ends with jne to 0x004e22c4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e227e
    mov edx, dword ptr [ebp - local_4]           # 004e2281
    mov eax, dword ptr [edx + field_ee]          # 004e2284
    mov dword ptr [ecx + field_30], eax          # 004e228a
    mov ecx, dword ptr [ebp - local_4]           # 004e228d
    mov edx, dword ptr [ebp - local_4]           # 004e2290
    mov eax, dword ptr [edx + field_ea]          # 004e2293
    mov dword ptr [ecx + field_34], eax          # 004e2299
    mov edi, 0x55bf14                            # 004e229c
    mov esi, dword ptr [ebp - local_4]           # 004e22a1
    add esi, 0xf6                                # 004e22a4
    mov ecx, 0x9                                 # 004e22aa
    {load} xor edx, edx                          # 004e22af
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e22b1
    jne.d8 L_004e22c4                            # 004e22b3
    # block 0x004e22b5: entered by fall-through of jne at 0x004e22b3, 3 instruction(s), ends with forward jump to 0x004e22d1
    mov eax, dword ptr [ebp - local_4]           # 004e22b5
    mov dword ptr [eax + field_17f], 0x0         # 004e22b8
    jmp.d8 L_004e22d1                            # 004e22c2
L_004e22c4:
    # block 0x004e22c4: entered by jne at 0x004e22b3, 2 instruction(s), falls into the block at 0x004e22d1
    mov ecx, dword ptr [ebp - local_4]           # 004e22c4
    mov dword ptr [ecx + field_17f], 0x1         # 004e22c7
L_004e22d1:
    # block 0x004e22d1: entered by jmp at 0x004e22c2, 2 instruction(s), ends with je to 0x004e22ed (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004e22d1
    je.d8 L_004e22ed                             # 004e22d5
    # block 0x004e22d7: entered by fall-through of je at 0x004e22d5, 5 instruction(s), falls into the block at 0x004e22ed
    mov edx, dword ptr [ebp - local_4]           # 004e22d7
    mov eax, dword ptr [ebp + arg_c]             # 004e22da
    mov dword ptr [edx + field_24], eax          # 004e22dd
    mov ecx, dword ptr [ebp - local_4]           # 004e22e0
    mov dword ptr [ecx + field_18b], 0x1         # 004e22e3
L_004e22ed:
    # block 0x004e22ed: entered by je at 0x004e22d5, 7 instruction(s), calls FUN_004e29ec, ends with ret 0x8
    mov ecx, dword ptr [ebp - local_4]           # 004e22ed
    call FUN_004e29ec                            # 004e22f0
    pop edi                                      # 004e22f5
    pop esi                                      # 004e22f6
    {load} mov esp, ebp                          # 004e22f7
    pop ebp                                      # 004e22f9
    ret 0x8                                      # 004e22fa

