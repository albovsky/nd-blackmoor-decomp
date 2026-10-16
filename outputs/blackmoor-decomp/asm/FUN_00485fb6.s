# FUN_00485fb6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00485fb6
# extent:       0x00485fb6-0x0048633c (902 code bytes)
# span:         0x00485fb6-0x0048633c (code 902, tables 0, padding 0)
# sha256:       f94e4166037ec6fa5531a630ce23fba29000e2c9db565fcfd68b51b4476a9648
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00485fb6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_d8, local_dc, local_e0
# fields:       [eax + n] field_26, field_a9a, field_aec, field_bc1; [ecx + n] field_b4f, field_bac, field_bc1, field_bc9; [edi + n] field_minus_1; [edx + n] field_aec, field_b4f, field_bac
# callees:      calls FUN_0050cd50, FUN_004fb77a, FUN_004fb2e3, FUN_00423259, FUN_00448d11, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 242 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_d8, 0xd8  # offset -0xd8
.equ local_dc, 0xdc  # offset -0xdc
.equ local_e0, 0xe0  # offset -0xe0
.equ field_26, 0x26  # offset +0x26
.equ field_a9a, 0xa9a  # offset +0xa9a
.equ field_aec, 0xaec  # offset +0xaec
.equ field_b4f, 0xb4f  # offset +0xb4f
.equ field_bac, 0xbac  # offset +0xbac
.equ field_bc1, 0xbc1  # offset +0xbc1
.equ field_bc9, 0xbc9  # offset +0xbc9

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x00485fb6 - 0x401000
.globl FUN_00485fb6
FUN_00485fb6:
    # block 0x00485fb6: entry, 19 instruction(s), ends with jne to 0x00486015 (forward)
    push ebp                                     # 00485fb6
    {load} mov ebp, esp                          # 00485fb7
    sub esp, 0xe0                                # 00485fb9
    push esi                                     # 00485fbf
    push edi                                     # 00485fc0
    mov dword ptr [ebp - local_e0], ecx          # 00485fc1
    mov dword ptr [ebp - local_c], 0x0           # 00485fc7
    mov eax, dword ptr [ebp - local_e0]          # 00485fce
    movsx ecx, word ptr [eax + field_26]         # 00485fd4
    imul ecx, ecx, 0x8d                          # 00485fd8
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00485fde
    mov dword ptr [ebp - local_8], edx           # 00485fe4
    mov edi, 0x54db84                            # 00485fe7
    mov esi, dword ptr [ebp - local_8]           # 00485fec
    add esi, 0xa79                               # 00485fef
    mov ecx, 0x9                                 # 00485ff5
    {load} xor eax, eax                          # 00485ffa
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00485ffc
    jne.d8 L_00486015                            # 00485ffe
    # block 0x00486000: entered by fall-through of jne at 0x00485ffe, 3 instruction(s), ends with forward jump to 0x00486336
    mov ecx, dword ptr [ebp - local_e0]          # 00486000
    mov dword ptr [ecx + field_bac], 0x0         # 00486006
    jmp.d32 L_00486336                           # 00486010
L_00486015:
    # block 0x00486015: entered by jne at 0x00485ffe, 15 instruction(s), calls FUN_0050cd50, ends with jle to 0x00486154 (forward)
    mov esi, dword ptr [ebp - local_8]           # 00486015
    add esi, 0xa79                               # 00486018
    mov edi, dword ptr [ebp - local_e0]          # 0048601e
    add edi, 0xb21                               # 00486024
    mov ecx, 0xc                                 # 0048602a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048602f
    movsb byte ptr es:[edi], byte ptr [esi]      # 00486031
    call FUN_0050cd50                            # 00486032
    cdq                                          # 00486037
    mov ecx, 0x3                                 # 00486038
    idiv ecx                                     # 0048603d
    mov word ptr [ebp - local_dc], dx            # 0048603f
    movsx edx, word ptr [ebp - local_dc]         # 00486046
    test edx, edx                                # 0048604d
    jle.d32 L_00486154                           # 0048604f
    # block 0x00486055: entered by fall-through of jle at 0x0048604f, 1 instruction(s), falls into the block at 0x0048605c
    mov dword ptr [ebp - local_4], 0x0           # 00486055
L_0048605c:
    # block 0x0048605c: entered by jmp at 0x0048614f, 2 instruction(s), ends with jne to 0x00486154 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0048605c
    jne.d32 L_00486154                           # 00486060
    # block 0x00486066: entered by fall-through of jne at 0x00486060, 3 instruction(s), ends with jle to 0x00486154 (forward)
    movsx eax, word ptr [ebp - local_dc]         # 00486066
    test eax, eax                                # 0048606d
    jle.d32 L_00486154                           # 0048606f
    # block 0x00486075: entered by fall-through of jle at 0x0048606f, 3 instruction(s), ends with jne to 0x004860d8 (forward)
    movsx ecx, word ptr [ebp - local_dc]         # 00486075
    cmp ecx, 0x1                                 # 0048607c
    jne.d8 L_004860d8                            # 0048607f
    # block 0x00486081: entered by fall-through of jne at 0x0048607f, 7 instruction(s), ends with je to 0x004860d8 (forward)
    mov edi, 0x54db90                            # 00486081
    mov esi, dword ptr [ebp - local_8]           # 00486086
    add esi, 0xaaa                               # 00486089
    mov ecx, 0x9                                 # 0048608f
    {load} xor edx, edx                          # 00486094
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00486096
    je.d8 L_004860d8                             # 00486098
    # block 0x0048609a: entered by fall-through of je at 0x00486098, 21 instruction(s), ends with forward jump to 0x0048614f
    mov eax, dword ptr [ebp - local_8]           # 0048609a
    add eax, 0xaaa                               # 0048609d
    {load} mov edi, eax                          # 004860a2
    mov ecx, dword ptr [ebp - local_e0]          # 004860a4
    add ecx, 0xb21                               # 004860aa
    {load} mov edx, ecx                          # 004860b0
    or ecx, -0x1                                 # 004860b2
    {load} xor eax, eax                          # 004860b5
    repne scasb al, byte ptr es:[edi]            # 004860b7
    not ecx                                      # 004860b9
    {load} sub edi, ecx                          # 004860bb
    {load} mov esi, edi                          # 004860bd
    {load} mov eax, ecx                          # 004860bf
    {load} mov edi, edx                          # 004860c1
    shr ecx, 0x2                                 # 004860c3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004860c6
    {load} mov ecx, eax                          # 004860c8
    and ecx, 0x3                                 # 004860ca
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004860cd
    mov dword ptr [ebp - local_4], 0x1           # 004860cf
    jmp.d8 L_0048614f                            # 004860d6
L_004860d8:
    # block 0x004860d8: entered by jne at 0x0048607f; je at 0x00486098, 3 instruction(s), ends with jne to 0x0048613b (forward)
    movsx ecx, word ptr [ebp - local_dc]         # 004860d8
    cmp ecx, 0x2                                 # 004860df
    jne.d8 L_0048613b                            # 004860e2
    # block 0x004860e4: entered by fall-through of jne at 0x004860e2, 7 instruction(s), ends with je to 0x0048613b (forward)
    mov edi, 0x54db9c                            # 004860e4
    mov esi, dword ptr [ebp - local_8]           # 004860e9
    add esi, 0xacb                               # 004860ec
    mov ecx, 0x9                                 # 004860f2
    {load} xor edx, edx                          # 004860f7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004860f9
    je.d8 L_0048613b                             # 004860fb
    # block 0x004860fd: entered by fall-through of je at 0x004860fb, 21 instruction(s), ends with forward jump to 0x0048614f
    mov eax, dword ptr [ebp - local_8]           # 004860fd
    add eax, 0xacb                               # 00486100
    {load} mov edi, eax                          # 00486105
    mov ecx, dword ptr [ebp - local_e0]          # 00486107
    add ecx, 0xb21                               # 0048610d
    {load} mov edx, ecx                          # 00486113
    or ecx, -0x1                                 # 00486115
    {load} xor eax, eax                          # 00486118
    repne scasb al, byte ptr es:[edi]            # 0048611a
    not ecx                                      # 0048611c
    {load} sub edi, ecx                          # 0048611e
    {load} mov esi, edi                          # 00486120
    {load} mov eax, ecx                          # 00486122
    {load} mov edi, edx                          # 00486124
    shr ecx, 0x2                                 # 00486126
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00486129
    {load} mov ecx, eax                          # 0048612b
    and ecx, 0x3                                 # 0048612d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00486130
    mov dword ptr [ebp - local_4], 0x1           # 00486132
    jmp.d8 L_0048614f                            # 00486139
L_0048613b:
    # block 0x0048613b: entered by jne at 0x004860e2; je at 0x004860fb, 5 instruction(s), calls FUN_0050cd50, falls into the block at 0x0048614f
    call FUN_0050cd50                            # 0048613b
    cdq                                          # 00486140
    mov ecx, 0x3                                 # 00486141
    idiv ecx                                     # 00486146
    mov word ptr [ebp - local_dc], dx            # 00486148
L_0048614f:
    # block 0x0048614f: entered by jmp at 0x004860d6; jmp at 0x00486139, 1 instruction(s), ends with backward jump to 0x0048605c
    jmp.d32 L_0048605c                           # 0048614f
L_00486154:
    # block 0x00486154: entered by jle at 0x0048604f; jne at 0x00486060; jle at 0x0048606f, 12 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with je to 0x0048630f (forward)
    mov edx, dword ptr [ebp - local_e0]          # 00486154
    add edx, 0xb21                               # 0048615a
    push edx                                     # 00486160
    mov ecx, 0x5c3a67                            # 00486161
    call FUN_004fb77a                            # 00486166
    mov eax, dword ptr [ebp - local_8]           # 0048616b
    mov cx, word ptr [eax + field_a9a]           # 0048616e
    push ecx                                     # 00486175
    mov ecx, 0x5c3a67                            # 00486176
    call FUN_004fb2e3                            # 0048617b
    cmp dword ptr [0x5bb202], 0x0                # 00486180
    je.d32 L_0048630f                            # 00486187
    # block 0x0048618d: entered by fall-through of je at 0x00486187, 11 instruction(s), ends with jbe to 0x00486261 (forward)
    movsx edx, word ptr [ebp - local_dc]         # 0048618d
    imul edx, edx, 0x21                          # 00486194
    mov eax, dword ptr [ebp - local_8]           # 00486197
    lea edi, [eax + edx + field_aec]             # 0048619a
    or ecx, -0x1                                 # 004861a1
    {load} xor eax, eax                          # 004861a4
    repne scasb al, byte ptr es:[edi]            # 004861a6
    not ecx                                      # 004861a8
    add ecx, -0x1                                # 004861aa
    test ecx, ecx                                # 004861ad
    jbe.d32 L_00486261                           # 004861af
    # block 0x004861b5: entered by fall-through of jbe at 0x004861af, 10 instruction(s), calls FUN_00423259, ends with je to 0x0048625a (forward)
    movsx ecx, word ptr [ebp - local_dc]         # 004861b5
    imul ecx, ecx, 0x21                          # 004861bc
    mov edx, dword ptr [ebp - local_8]           # 004861bf
    lea eax, [edx + ecx + field_aec]             # 004861c2
    push eax                                     # 004861c9
    mov ecx, 0x619a6b                            # 004861ca
    call FUN_00423259                            # 004861cf
    mov dword ptr [ebp - local_c], eax           # 004861d4
    cmp dword ptr [ebp - local_c], 0x0           # 004861d7
    je.d8 L_0048625a                             # 004861db
    # block 0x004861dd: entered by fall-through of je at 0x004861db, 8 instruction(s), ends with ja to 0x0048625a (forward)
    mov edi, dword ptr [ebp - local_c]           # 004861dd
    or ecx, -0x1                                 # 004861e0
    {load} xor eax, eax                          # 004861e3
    repne scasb al, byte ptr es:[edi]            # 004861e5
    not ecx                                      # 004861e7
    add ecx, -0x1                                # 004861e9
    cmp ecx, 0x9c40                              # 004861ec
    ja.d8 L_0048625a                             # 004861f2
    # block 0x004861f4: entered by fall-through of ja at 0x004861f2, 30 instruction(s), calls FUN_00448d11, ends with forward jump to 0x00486261
    mov edi, dword ptr [ebp - local_c]           # 004861f4
    or ecx, -0x1                                 # 004861f7
    {load} xor eax, eax                          # 004861fa
    repne scasb al, byte ptr es:[edi]            # 004861fc
    not ecx                                      # 004861fe
    mov esi, dword ptr [ebp - local_c]           # 00486200
    lea edi, [ebp - local_d8]                    # 00486203
    {load} mov edx, ecx                          # 00486209
    shr ecx, 0x2                                 # 0048620b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048620e
    {load} mov ecx, edx                          # 00486210
    and ecx, 0x3                                 # 00486212
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00486215
    lea edi, [ebp - local_d8]                    # 00486217
    or ecx, -0x1                                 # 0048621d
    {load} xor eax, eax                          # 00486220
    repne scasb al, byte ptr es:[edi]            # 00486222
    mov eax, dword ptr [0x54dba8]                # 00486224
    mov dword ptr [edi - field_minus_1], eax     # 00486229
    push 0x0                                     # 0048622c
    push -0x1                                    # 0048622e
    lea ecx, [ebp - local_d8]                    # 00486230
    push ecx                                     # 00486236
    mov edx, dword ptr [0x5d03b3]                # 00486237
    push edx                                     # 0048623d
    mov ecx, 0x619a05                            # 0048623e
    call FUN_00448d11                            # 00486243
    mov eax, dword ptr [ebp - local_e0]          # 00486248
    mov dword ptr [eax + field_bc1], 0x1         # 0048624e
    jmp.d8 L_00486261                            # 00486258
L_0048625a:
    # block 0x0048625a: entered by je at 0x004861db; ja at 0x004861f2, 1 instruction(s), falls into the block at 0x00486261
    mov dword ptr [ebp - local_c], 0x0           # 0048625a
L_00486261:
    # block 0x00486261: entered by jbe at 0x004861af; jmp at 0x00486258, 2 instruction(s), ends with jne to 0x0048630f (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 00486261
    jne.d32 L_0048630f                           # 00486265
    # block 0x0048626b: entered by fall-through of jne at 0x00486265, 11 instruction(s), ends with jbe to 0x0048630f (forward)
    movsx ecx, word ptr [ebp - local_dc]         # 0048626b
    imul ecx, ecx, 0xc8                          # 00486272
    mov edx, dword ptr [ebp - local_8]           # 00486278
    lea edi, [edx + ecx + field_b4f]             # 0048627b
    or ecx, -0x1                                 # 00486282
    {load} xor eax, eax                          # 00486285
    repne scasb al, byte ptr es:[edi]            # 00486287
    not ecx                                      # 00486289
    add ecx, -0x1                                # 0048628b
    test ecx, ecx                                # 0048628e
    jbe.d8 L_0048630f                            # 00486290
    # block 0x00486292: entered by fall-through of jbe at 0x00486290, 35 instruction(s), calls FUN_00448d11, falls into the block at 0x0048630f
    movsx eax, word ptr [ebp - local_dc]         # 00486292
    imul eax, eax, 0xc8                          # 00486299
    mov ecx, dword ptr [ebp - local_8]           # 0048629f
    lea edx, [ecx + eax + field_b4f]             # 004862a2
    {load} mov edi, edx                          # 004862a9
    lea edx, [ebp - local_d8]                    # 004862ab
    or ecx, -0x1                                 # 004862b1
    {load} xor eax, eax                          # 004862b4
    repne scasb al, byte ptr es:[edi]            # 004862b6
    not ecx                                      # 004862b8
    {load} sub edi, ecx                          # 004862ba
    {load} mov esi, edi                          # 004862bc
    {load} mov eax, ecx                          # 004862be
    {load} mov edi, edx                          # 004862c0
    shr ecx, 0x2                                 # 004862c2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004862c5
    {load} mov ecx, eax                          # 004862c7
    and ecx, 0x3                                 # 004862c9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004862cc
    lea edi, [ebp - local_d8]                    # 004862ce
    or ecx, -0x1                                 # 004862d4
    {load} xor eax, eax                          # 004862d7
    repne scasb al, byte ptr es:[edi]            # 004862d9
    mov ecx, dword ptr [0x54dbac]                # 004862db
    mov dword ptr [edi - field_minus_1], ecx     # 004862e1
    push 0x0                                     # 004862e4
    push -0x1                                    # 004862e6
    lea edx, [ebp - local_d8]                    # 004862e8
    push edx                                     # 004862ee
    mov eax, dword ptr [0x5d03b3]                # 004862ef
    push eax                                     # 004862f4
    mov ecx, 0x619a05                            # 004862f5
    call FUN_00448d11                            # 004862fa
    mov ecx, dword ptr [ebp - local_e0]          # 004862ff
    mov dword ptr [ecx + field_bc1], 0x1         # 00486305
L_0048630f:
    # block 0x0048630f: entered by je at 0x00486187; jne at 0x00486265; jbe at 0x00486290, 6 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x00486336
    mov edx, dword ptr [ebp - local_e0]          # 0048630f
    mov dword ptr [edx + field_bac], 0x2         # 00486315
    call dword ptr [0x52a23c]                    # 0048631f
    add eax, 0x7d0                               # 00486325
    mov ecx, dword ptr [ebp - local_e0]          # 0048632a
    mov dword ptr [ecx + field_bc9], eax         # 00486330
L_00486336:
    # block 0x00486336: entered by jmp at 0x00486010, 5 instruction(s), ends with ret
    pop edi                                      # 00486336
    pop esi                                      # 00486337
    {load} mov esp, ebp                          # 00486338
    pop ebp                                      # 0048633a
    ret                                          # 0048633b

