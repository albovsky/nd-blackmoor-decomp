# FUN_004dd471
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dd471
# extent:       0x004dd471-0x004dd8f7 (1158 code bytes)
# span:         0x004dd471-0x004dd8f7 (code 1158, tables 0, padding 0)
# sha256:       28e84435c56c4a3aa913e6379ce1930d49ffb6eb316bfab86b305d83d1456f8e
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dd471
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_8, local_c
# fields:       [eax + n] field_4, field_e1, field_32f, field_minus_1; [ecx + n] field_4, field_f1, field_minus_1; [edx + n] field_dd, field_f3
# callees:      calls FUN_0044a2b7, FUN_00425fc0, FUN_004dad60, FUN_0043da93, FUN_004c2790, FUN_004dae88, FUN_004daeb5, FUN_0043dbd5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 237 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_dd, 0xdd  # offset +0xdd
.equ field_e1, 0xe1  # offset +0xe1
.equ field_f1, 0xf1  # offset +0xf1
.equ field_f3, 0xf3  # offset +0xf3
.equ field_32f, 0x32f  # offset +0x32f

# --- external targets -----------------------------------------------
.set FUN_00425fc0, .text + (0x00425fc0 - 0x401000)
.set FUN_0043da93, .text + (0x0043da93 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)

.org 0x004dd471 - 0x401000
.globl FUN_004dd471
FUN_004dd471:
    # block 0x004dd471: entry, 9 instruction(s), ends with je to 0x004dd494 (forward)
    push ebp                                     # 004dd471
    {load} mov ebp, esp                          # 004dd472
    sub esp, 0xc                                 # 004dd474
    push esi                                     # 004dd477
    push edi                                     # 004dd478
    mov dword ptr [ebp - local_c], ecx           # 004dd479
    movsx eax, word ptr [0x63a4cd]               # 004dd47c
    test eax, eax                                # 004dd483
    je.d8 L_004dd494                             # 004dd485
    # block 0x004dd487: entered by fall-through of je at 0x004dd485, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dd494
    push 0x55b6c4                                # 004dd487
    call FUN_0044a2b7                            # 004dd48c
    add esp, 0x4                                 # 004dd491
L_004dd494:
    # block 0x004dd494: entered by je at 0x004dd485, 4 instruction(s), ends with je to 0x004dd4ac (forward)
    {load} xor ecx, ecx                          # 004dd494
    mov cl, byte ptr [0x58320d]                  # 004dd496
    test ecx, ecx                                # 004dd49c
    je.d8 L_004dd4ac                             # 004dd49e
    # block 0x004dd4a0: entered by fall-through of je at 0x004dd49e, 2 instruction(s), calls FUN_00425fc0, falls into the block at 0x004dd4ac
    mov byte ptr [0x58320d], 0x0                 # 004dd4a0
    call FUN_00425fc0                            # 004dd4a7
L_004dd4ac:
    # block 0x004dd4ac: entered by je at 0x004dd49e, 21 instruction(s), calls FUN_004dad60, FUN_0043da93, ends with jne to 0x004dd55e (forward)
    mov ecx, 0x5830a6                            # 004dd4ac
    call FUN_004dad60                            # 004dd4b1
    mov edx, dword ptr [ebp - local_c]           # 004dd4b6
    mov dword ptr [edx + field_dd], 0x0          # 004dd4b9
    mov eax, dword ptr [ebp - local_c]           # 004dd4c3
    mov dword ptr [eax + field_e1], 0x0          # 004dd4c6
    mov ecx, dword ptr [ebp - local_c]           # 004dd4d0
    mov word ptr [ecx + field_f1], 0xffff        # 004dd4d3
    mov edx, dword ptr [ebp - local_c]           # 004dd4dc
    mov word ptr [edx + field_f3], 0xffff        # 004dd4df
    mov eax, dword ptr [ebp - local_c]           # 004dd4e8
    mov dword ptr [eax + field_32f], 0x0         # 004dd4eb
    call FUN_0043da93                            # 004dd4f5
    mov dword ptr [0x5d2a2b], 0x0                # 004dd4fa
    mov dword ptr [0x5d2a75], 0x0                # 004dd504
    mov dword ptr [0x5d2abf], 0x0                # 004dd50e
    mov dword ptr [0x5d2b09], 0x0                # 004dd518
    mov dword ptr [0x5d2b53], 0x0                # 004dd522
    mov dword ptr [0x5d2b9d], 0x0                # 004dd52c
    cmp dword ptr [0x5d0383], 0x0                # 004dd536
    jne.d8 L_004dd55e                            # 004dd53d
    # block 0x004dd53f: entered by fall-through of jne at 0x004dd53d, 8 instruction(s), calls FUN_004c2790, falls into the block at 0x004dd55e
    push 0x55b6e0                                # 004dd53f
    push 0x6                                     # 004dd544
    mov ecx, dword ptr [ebp + arg_8]             # 004dd546
    push ecx                                     # 004dd549
    push 0x55b6fc                                # 004dd54a
    mov ecx, 0x5cf659                            # 004dd54f
    call FUN_004c2790                            # 004dd554
    mov dword ptr [0x5d0383], eax                # 004dd559
L_004dd55e:
    # block 0x004dd55e: entered by jne at 0x004dd53d, 2 instruction(s), ends with jne to 0x004dd587 (forward)
    cmp dword ptr [0x5d0377], 0x0                # 004dd55e
    jne.d8 L_004dd587                            # 004dd565
    # block 0x004dd567: entered by fall-through of jne at 0x004dd565, 7 instruction(s), calls FUN_004c2790, falls into the block at 0x004dd587
    push 0x55b704                                # 004dd567
    push 0x6                                     # 004dd56c
    push 0x5b06aa                                # 004dd56e
    push 0x55b718                                # 004dd573
    mov ecx, 0x5cf659                            # 004dd578
    call FUN_004c2790                            # 004dd57d
    mov dword ptr [0x5d0377], eax                # 004dd582
L_004dd587:
    # block 0x004dd587: entered by jne at 0x004dd565, 181 instruction(s), calls FUN_004dae88, FUN_004daeb5, FUN_0043dbd5, ends with ret 0x4
    mov dword ptr [0x5b44f0], 0x4                # 004dd587
    mov dword ptr [0x5b44f4], 0x1                # 004dd591
    push 0x0                                     # 004dd59b
    push 0x0                                     # 004dd59d
    mov ecx, 0x5830a6                            # 004dd59f
    call FUN_004dae88                            # 004dd5a4
    lea edx, [ebp - local_8]                     # 004dd5a9
    push edx                                     # 004dd5ac
    mov ecx, 0x5830a6                            # 004dd5ad
    call FUN_004daeb5                            # 004dd5b2
    mov ecx, dword ptr [eax]                     # 004dd5b7
    mov edx, dword ptr [eax + field_4]           # 004dd5b9
    mov dword ptr [0x5830e2], ecx                # 004dd5bc
    mov dword ptr [0x5830e6], edx                # 004dd5c2
    mov eax, dword ptr [0x5830e2]                # 004dd5c8
    mov dword ptr [0x5830ea], eax                # 004dd5cd
    mov ecx, dword ptr [0x5830e6]                # 004dd5d2
    mov dword ptr [0x5830ee], ecx                # 004dd5d8
    mov edx, dword ptr [0x5830e6]                # 004dd5de
    mov dword ptr [0x583106], edx                # 004dd5e4
    mov eax, dword ptr [0x583106]                # 004dd5ea
    mov dword ptr [0x5830f6], eax                # 004dd5ef
    mov ecx, dword ptr [0x5b44f4]                # 004dd5f4
    shl ecx, 0x2                                 # 004dd5fa
    mov edx, dword ptr [0x5b44f0]                # 004dd5fd
    movsx eax, word ptr [ecx + 8*edx + 0x5b3792] # 004dd603
    mov ecx, dword ptr [0x5830e6]                # 004dd60b
    lea edx, [ecx + eax - field_minus_1]         # 004dd611
    mov dword ptr [0x58310e], edx                # 004dd615
    mov eax, dword ptr [0x58310e]                # 004dd61b
    mov dword ptr [0x5830fe], eax                # 004dd620
    mov ecx, dword ptr [0x5830e2]                # 004dd625
    mov dword ptr [0x583102], ecx                # 004dd62b
    mov edx, dword ptr [0x583102]                # 004dd631
    mov dword ptr [0x5830f2], edx                # 004dd637
    mov eax, dword ptr [0x5b44f4]                # 004dd63d
    shl eax, 0x2                                 # 004dd642
    mov ecx, dword ptr [0x5b44f0]                # 004dd645
    movsx edx, word ptr [eax + 8*ecx + 0x5b3790] # 004dd64b
    mov eax, dword ptr [0x5830e2]                # 004dd653
    lea ecx, [eax + edx - field_minus_1]         # 004dd658
    mov dword ptr [0x58310a], ecx                # 004dd65c
    mov edx, dword ptr [0x58310a]                # 004dd662
    mov dword ptr [0x5830fa], edx                # 004dd668
    mov dword ptr [0x5d2d45], 0x1                # 004dd66e
    mov dword ptr [0x5d2d49], 0x4de0cf           # 004dd678
    mov eax, dword ptr [0x5d0383]                # 004dd682
    mov dword ptr [0x5d2d4d], eax                # 004dd687
    mov dword ptr [0x5d2d51], 0x0                # 004dd68c
    mov dword ptr [0x5d2d55], 0x0                # 004dd696
    mov dword ptr [0x5d2d59], 0x1                # 004dd6a0
    mov dword ptr [0x5d2d5d], 0x1                # 004dd6aa
    mov word ptr [0x5d2d61], 0x0                 # 004dd6b4
    mov edi, 0x55b720                            # 004dd6bd
    mov edx, 0x5d2d67                            # 004dd6c2
    or ecx, -0x1                                 # 004dd6c7
    {load} xor eax, eax                          # 004dd6ca
    repne scasb al, byte ptr es:[edi]            # 004dd6cc
    not ecx                                      # 004dd6ce
    {load} sub edi, ecx                          # 004dd6d0
    {load} mov esi, edi                          # 004dd6d2
    {load} mov eax, ecx                          # 004dd6d4
    {load} mov edi, edx                          # 004dd6d6
    shr ecx, 0x2                                 # 004dd6d8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004dd6db
    {load} mov ecx, eax                          # 004dd6dd
    and ecx, 0x3                                 # 004dd6df
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004dd6e2
    mov dword ptr [0x5d2d8f], 0x14               # 004dd6e4
    mov dword ptr [0x5d2d93], 0x0                # 004dd6ee
    mov ecx, dword ptr [0x5d0377]                # 004dd6f8
    mov dword ptr [0x5d2d97], ecx                # 004dd6fe
    mov edx, dword ptr [0x5b44f0]                # 004dd704
    shl edx, 0x5                                 # 004dd70a
    mov eax, dword ptr [0x5b44f4]                # 004dd70d
    shl eax, 0x4                                 # 004dd712
    lea ecx, [edx + eax + 0x5b160c]              # 004dd715
    mov dword ptr [0x5d2d9b], ecx                # 004dd71c
    mov dword ptr [0x5d2d9f], 0x583102           # 004dd722
    mov dword ptr [0x5d2da3], 0x1                # 004dd72c
    mov dword ptr [0x5d2da7], 0x1                # 004dd736
    mov word ptr [0x5d2dab], 0x2                 # 004dd740
    mov edi, 0x55b734                            # 004dd749
    mov edx, 0x5d2db1                            # 004dd74e
    or ecx, -0x1                                 # 004dd753
    {load} xor eax, eax                          # 004dd756
    repne scasb al, byte ptr es:[edi]            # 004dd758
    not ecx                                      # 004dd75a
    {load} sub edi, ecx                          # 004dd75c
    {load} mov esi, edi                          # 004dd75e
    {load} mov eax, ecx                          # 004dd760
    {load} mov edi, edx                          # 004dd762
    shr ecx, 0x2                                 # 004dd764
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004dd767
    {load} mov ecx, eax                          # 004dd769
    and ecx, 0x3                                 # 004dd76b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004dd76e
    mov dword ptr [0x5d2dd9], 0x2                # 004dd770
    mov dword ptr [0x5d2ddd], 0x0                # 004dd77a
    mov ecx, dword ptr [0x5d0383]                # 004dd784
    mov dword ptr [0x5d2de1], ecx                # 004dd78a
    mov dword ptr [0x5d2de5], 0x5830f2           # 004dd790
    mov dword ptr [0x5d2de9], 0x5830f2           # 004dd79a
    mov dword ptr [0x5d2ded], 0x0                # 004dd7a4
    mov dword ptr [0x5d2df1], 0x1                # 004dd7ae
    mov word ptr [0x5d2df5], 0x1                 # 004dd7b8
    mov edi, 0x55b74c                            # 004dd7c1
    mov edx, 0x5d2dfb                            # 004dd7c6
    or ecx, -0x1                                 # 004dd7cb
    {load} xor eax, eax                          # 004dd7ce
    repne scasb al, byte ptr es:[edi]            # 004dd7d0
    not ecx                                      # 004dd7d2
    {load} sub edi, ecx                          # 004dd7d4
    {load} mov esi, edi                          # 004dd7d6
    {load} mov eax, ecx                          # 004dd7d8
    {load} mov edi, edx                          # 004dd7da
    shr ecx, 0x2                                 # 004dd7dc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004dd7df
    {load} mov ecx, eax                          # 004dd7e1
    and ecx, 0x3                                 # 004dd7e3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004dd7e6
    mov dword ptr [0x5d2e23], 0x8                # 004dd7e8
    mov dword ptr [0x5d2e27], 0x0                # 004dd7f2
    mov ecx, dword ptr [0x5d0383]                # 004dd7fc
    mov dword ptr [0x5d2e2b], ecx                # 004dd802
    mov edx, dword ptr [ebp - local_c]           # 004dd808
    add edx, 0xf5                                # 004dd80b
    mov dword ptr [0x5d2e2f], edx                # 004dd811
    mov eax, dword ptr [ebp - local_c]           # 004dd817
    add eax, 0x105                               # 004dd81a
    mov dword ptr [0x5d2e33], eax                # 004dd81f
    mov dword ptr [0x5d2e37], 0x0                # 004dd824
    mov dword ptr [0x5d2e3b], 0x1                # 004dd82e
    mov word ptr [0x5d2e3f], 0x1                 # 004dd838
    mov edi, 0x55b764                            # 004dd841
    mov edx, 0x5d2e45                            # 004dd846
    or ecx, -0x1                                 # 004dd84b
    {load} xor eax, eax                          # 004dd84e
    repne scasb al, byte ptr es:[edi]            # 004dd850
    not ecx                                      # 004dd852
    {load} sub edi, ecx                          # 004dd854
    {load} mov esi, edi                          # 004dd856
    {load} mov eax, ecx                          # 004dd858
    {load} mov edi, edx                          # 004dd85a
    shr ecx, 0x2                                 # 004dd85c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004dd85f
    {load} mov ecx, eax                          # 004dd861
    and ecx, 0x3                                 # 004dd863
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004dd866
    mov dword ptr [0x5d2e6d], 0x4                # 004dd868
    mov dword ptr [0x5d2e71], 0x4de009           # 004dd872
    mov ecx, dword ptr [0x5d0383]                # 004dd87c
    mov dword ptr [0x5d2e75], ecx                # 004dd882
    mov dword ptr [0x5d2e79], 0x0                # 004dd888
    mov dword ptr [0x5d2e7d], 0x0                # 004dd892
    mov dword ptr [0x5d2e81], 0x0                # 004dd89c
    mov dword ptr [0x5d2e85], 0x1                # 004dd8a6
    mov word ptr [0x5d2e89], 0x0                 # 004dd8b0
    mov edi, 0x55b77c                            # 004dd8b9
    mov edx, 0x5d2e8f                            # 004dd8be
    or ecx, -0x1                                 # 004dd8c3
    {load} xor eax, eax                          # 004dd8c6
    repne scasb al, byte ptr es:[edi]            # 004dd8c8
    not ecx                                      # 004dd8ca
    {load} sub edi, ecx                          # 004dd8cc
    {load} mov esi, edi                          # 004dd8ce
    {load} mov eax, ecx                          # 004dd8d0
    {load} mov edi, edx                          # 004dd8d2
    shr ecx, 0x2                                 # 004dd8d4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004dd8d7
    {load} mov ecx, eax                          # 004dd8d9
    and ecx, 0x3                                 # 004dd8db
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004dd8de
    call FUN_0043dbd5                            # 004dd8e0
    mov ecx, dword ptr [ebp - local_c]           # 004dd8e5
    mov dword ptr [ecx + field_4], 0x1           # 004dd8e8
    pop edi                                      # 004dd8ef
    pop esi                                      # 004dd8f0
    {load} mov esp, ebp                          # 004dd8f1
    pop ebp                                      # 004dd8f3
    ret 0x4                                      # 004dd8f4

