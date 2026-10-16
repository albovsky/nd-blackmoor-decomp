# FUN_004d4803
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d4803
# extent:       0x004d4803-0x004d4c24 (1057 code bytes)
# span:         0x004d4803-0x004d4c24 (code 1057, tables 0, padding 0)
# sha256:       3e44b4a613789c85c028f04904fb3bf5487d204a6d15c09f7c1dd6f240962352
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d4803
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_8
# fields:       [eax + n] field_4; [ecx + n] field_minus_1; [edx + n] field_minus_1
# callees:      calls FUN_00425fc0, FUN_004dad60, FUN_0043da93, FUN_004c2790, FUN_004dae88, FUN_004daeb5, FUN_0043dbd5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 214 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00425fc0, .text + (0x00425fc0 - 0x401000)
.set FUN_0043da93, .text + (0x0043da93 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)

.org 0x004d4803 - 0x401000
.globl FUN_004d4803
FUN_004d4803:
    # block 0x004d4803: entry, 9 instruction(s), ends with je to 0x004d4822 (forward)
    push ebp                                     # 004d4803
    {load} mov ebp, esp                          # 004d4804
    sub esp, 0x8                                 # 004d4806
    push esi                                     # 004d4809
    push edi                                     # 004d480a
    {load} xor eax, eax                          # 004d480b
    mov al, byte ptr [0x58320d]                  # 004d480d
    test eax, eax                                # 004d4812
    je.d8 L_004d4822                             # 004d4814
    # block 0x004d4816: entered by fall-through of je at 0x004d4814, 2 instruction(s), calls FUN_00425fc0, falls into the block at 0x004d4822
    mov byte ptr [0x58320d], 0x0                 # 004d4816
    call FUN_00425fc0                            # 004d481d
L_004d4822:
    # block 0x004d4822: entered by je at 0x004d4814, 11 instruction(s), calls FUN_004dad60, FUN_0043da93, ends with jne to 0x004d4894 (forward)
    mov ecx, 0x5830a6                            # 004d4822
    call FUN_004dad60                            # 004d4827
    mov dword ptr [0x5b0006], 0x0                # 004d482c
    mov dword ptr [0x5b000a], 0x0                # 004d4836
    mov word ptr [0x5b000e], 0xffff              # 004d4840
    mov word ptr [0x5b0010], 0xffff              # 004d4849
    mov dword ptr [0x5830da], 0x0                # 004d4852
    call FUN_0043da93                            # 004d485c
    mov dword ptr [0x5d17f5], 0x0                # 004d4861
    cmp dword ptr [0x5d037f], 0x0                # 004d486b
    jne.d8 L_004d4894                            # 004d4872
    # block 0x004d4874: entered by fall-through of jne at 0x004d4872, 7 instruction(s), calls FUN_004c2790, falls into the block at 0x004d4894
    push 0x55a5b0                                # 004d4874
    push 0x6                                     # 004d4879
    push 0x5aff9d                                # 004d487b
    push 0x55a5c0                                # 004d4880
    mov ecx, 0x5cf659                            # 004d4885
    call FUN_004c2790                            # 004d488a
    mov dword ptr [0x5d037f], eax                # 004d488f
L_004d4894:
    # block 0x004d4894: entered by jne at 0x004d4872, 2 instruction(s), ends with jne to 0x004d48bd (forward)
    cmp dword ptr [0x5d0377], 0x0                # 004d4894
    jne.d8 L_004d48bd                            # 004d489b
    # block 0x004d489d: entered by fall-through of jne at 0x004d489b, 7 instruction(s), calls FUN_004c2790, falls into the block at 0x004d48bd
    push 0x55a5c8                                # 004d489d
    push 0x6                                     # 004d48a2
    push 0x5b06aa                                # 004d48a4
    push 0x55a5dc                                # 004d48a9
    mov ecx, 0x5cf659                            # 004d48ae
    call FUN_004c2790                            # 004d48b3
    mov dword ptr [0x5d0377], eax                # 004d48b8
L_004d48bd:
    # block 0x004d48bd: entered by jne at 0x004d489b, 176 instruction(s), calls FUN_004dae88, FUN_004daeb5, FUN_0043dbd5, ends with ret
    mov dword ptr [0x5b44f0], 0x4                # 004d48bd
    mov dword ptr [0x5b44f4], 0x0                # 004d48c7
    push 0x0                                     # 004d48d1
    push 0x0                                     # 004d48d3
    mov ecx, 0x5830a6                            # 004d48d5
    call FUN_004dae88                            # 004d48da
    lea ecx, [ebp - local_8]                     # 004d48df
    push ecx                                     # 004d48e2
    mov ecx, 0x5830a6                            # 004d48e3
    call FUN_004daeb5                            # 004d48e8
    mov edx, dword ptr [eax]                     # 004d48ed
    mov eax, dword ptr [eax + field_4]           # 004d48ef
    mov dword ptr [0x5830e2], edx                # 004d48f2
    mov dword ptr [0x5830e6], eax                # 004d48f8
    mov ecx, dword ptr [0x5830e2]                # 004d48fd
    mov dword ptr [0x5830ea], ecx                # 004d4903
    mov edx, dword ptr [0x5830e6]                # 004d4909
    mov dword ptr [0x5830ee], edx                # 004d490f
    mov eax, dword ptr [0x5830e6]                # 004d4915
    mov dword ptr [0x583106], eax                # 004d491a
    mov ecx, dword ptr [0x583106]                # 004d491f
    mov dword ptr [0x5830f6], ecx                # 004d4925
    mov edx, dword ptr [0x5b44f4]                # 004d492b
    shl edx, 0x2                                 # 004d4931
    mov eax, dword ptr [0x5b44f0]                # 004d4934
    movsx ecx, word ptr [edx + 8*eax + 0x5b3792] # 004d4939
    mov edx, dword ptr [0x5830e6]                # 004d4941
    lea eax, [edx + ecx - field_minus_1]         # 004d4947
    mov dword ptr [0x58310e], eax                # 004d494b
    mov ecx, dword ptr [0x58310e]                # 004d4950
    mov dword ptr [0x5830fe], ecx                # 004d4956
    mov edx, dword ptr [0x5830e2]                # 004d495c
    mov dword ptr [0x583102], edx                # 004d4962
    mov eax, dword ptr [0x583102]                # 004d4968
    mov dword ptr [0x5830f2], eax                # 004d496d
    mov ecx, dword ptr [0x5b44f4]                # 004d4972
    shl ecx, 0x2                                 # 004d4978
    mov edx, dword ptr [0x5b44f0]                # 004d497b
    movsx eax, word ptr [ecx + 8*edx + 0x5b3790] # 004d4981
    mov ecx, dword ptr [0x5830e2]                # 004d4989
    lea edx, [ecx + eax - field_minus_1]         # 004d498f
    mov dword ptr [0x58310a], edx                # 004d4993
    mov eax, dword ptr [0x58310a]                # 004d4999
    mov dword ptr [0x5830fa], eax                # 004d499e
    mov dword ptr [0x5d2bd3], 0x1                # 004d49a3
    mov dword ptr [0x5d2bd7], 0x4d0c17           # 004d49ad
    mov ecx, dword ptr [0x5d037f]                # 004d49b7
    mov dword ptr [0x5d2bdb], ecx                # 004d49bd
    mov dword ptr [0x5d2bdf], 0x5affc2           # 004d49c3
    mov dword ptr [0x5d2be3], 0x5affc2           # 004d49cd
    mov dword ptr [0x5d2be7], 0x1                # 004d49d7
    mov dword ptr [0x5d2beb], 0x1                # 004d49e1
    mov word ptr [0x5d2bef], 0x0                 # 004d49eb
    mov edi, 0x55a5e4                            # 004d49f4
    mov edx, 0x5d2bf5                            # 004d49f9
    or ecx, -0x1                                 # 004d49fe
    {load} xor eax, eax                          # 004d4a01
    repne scasb al, byte ptr es:[edi]            # 004d4a03
    not ecx                                      # 004d4a05
    {load} sub edi, ecx                          # 004d4a07
    {load} mov esi, edi                          # 004d4a09
    {load} mov eax, ecx                          # 004d4a0b
    {load} mov edi, edx                          # 004d4a0d
    shr ecx, 0x2                                 # 004d4a0f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d4a12
    {load} mov ecx, eax                          # 004d4a14
    and ecx, 0x3                                 # 004d4a16
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d4a19
    mov dword ptr [0x5d2c1d], 0x14               # 004d4a1b
    mov dword ptr [0x5d2c21], 0x0                # 004d4a25
    mov ecx, dword ptr [0x5d0377]                # 004d4a2f
    mov dword ptr [0x5d2c25], ecx                # 004d4a35
    mov edx, dword ptr [0x5b44f0]                # 004d4a3b
    shl edx, 0x5                                 # 004d4a41
    mov eax, dword ptr [0x5b44f4]                # 004d4a44
    shl eax, 0x4                                 # 004d4a49
    lea ecx, [edx + eax + 0x5b160c]              # 004d4a4c
    mov dword ptr [0x5d2c29], ecx                # 004d4a53
    mov dword ptr [0x5d2c2d], 0x583102           # 004d4a59
    mov dword ptr [0x5d2c31], 0x1                # 004d4a63
    mov dword ptr [0x5d2c35], 0x1                # 004d4a6d
    mov word ptr [0x5d2c39], 0x2                 # 004d4a77
    mov edi, 0x55a5ec                            # 004d4a80
    mov edx, 0x5d2c3f                            # 004d4a85
    or ecx, -0x1                                 # 004d4a8a
    {load} xor eax, eax                          # 004d4a8d
    repne scasb al, byte ptr es:[edi]            # 004d4a8f
    not ecx                                      # 004d4a91
    {load} sub edi, ecx                          # 004d4a93
    {load} mov esi, edi                          # 004d4a95
    {load} mov eax, ecx                          # 004d4a97
    {load} mov edi, edx                          # 004d4a99
    shr ecx, 0x2                                 # 004d4a9b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d4a9e
    {load} mov ecx, eax                          # 004d4aa0
    and ecx, 0x3                                 # 004d4aa2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d4aa5
    mov dword ptr [0x5d2c67], 0x2                # 004d4aa7
    mov dword ptr [0x5d2c6b], 0x0                # 004d4ab1
    mov ecx, dword ptr [0x5d037f]                # 004d4abb
    mov dword ptr [0x5d2c6f], ecx                # 004d4ac1
    mov dword ptr [0x5d2c73], 0x5830f2           # 004d4ac7
    mov dword ptr [0x5d2c77], 0x5830f2           # 004d4ad1
    mov dword ptr [0x5d2c7b], 0x0                # 004d4adb
    mov dword ptr [0x5d2c7f], 0x1                # 004d4ae5
    mov word ptr [0x5d2c83], 0x1                 # 004d4aef
    mov edi, 0x55a5fc                            # 004d4af8
    mov edx, 0x5d2c89                            # 004d4afd
    or ecx, -0x1                                 # 004d4b02
    {load} xor eax, eax                          # 004d4b05
    repne scasb al, byte ptr es:[edi]            # 004d4b07
    not ecx                                      # 004d4b09
    {load} sub edi, ecx                          # 004d4b0b
    {load} mov esi, edi                          # 004d4b0d
    {load} mov eax, ecx                          # 004d4b0f
    {load} mov edi, edx                          # 004d4b11
    shr ecx, 0x2                                 # 004d4b13
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d4b16
    {load} mov ecx, eax                          # 004d4b18
    and ecx, 0x3                                 # 004d4b1a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d4b1d
    mov dword ptr [0x5d2cb1], 0x8                # 004d4b1f
    mov dword ptr [0x5d2cb5], 0x0                # 004d4b29
    mov ecx, dword ptr [0x5d037f]                # 004d4b33
    mov dword ptr [0x5d2cb9], ecx                # 004d4b39
    mov dword ptr [0x5d2cbd], 0x5b0012           # 004d4b3f
    mov dword ptr [0x5d2cc1], 0x5b0022           # 004d4b49
    mov dword ptr [0x5d2cc5], 0x0                # 004d4b53
    mov dword ptr [0x5d2cc9], 0x1                # 004d4b5d
    mov word ptr [0x5d2ccd], 0x1                 # 004d4b67
    mov edi, 0x55a60c                            # 004d4b70
    mov edx, 0x5d2cd3                            # 004d4b75
    or ecx, -0x1                                 # 004d4b7a
    {load} xor eax, eax                          # 004d4b7d
    repne scasb al, byte ptr es:[edi]            # 004d4b7f
    not ecx                                      # 004d4b81
    {load} sub edi, ecx                          # 004d4b83
    {load} mov esi, edi                          # 004d4b85
    {load} mov eax, ecx                          # 004d4b87
    {load} mov edi, edx                          # 004d4b89
    shr ecx, 0x2                                 # 004d4b8b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d4b8e
    {load} mov ecx, eax                          # 004d4b90
    and ecx, 0x3                                 # 004d4b92
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d4b95
    mov dword ptr [0x5d2cfb], 0x4                # 004d4b97
    mov dword ptr [0x5d2cff], 0x4d0c57           # 004d4ba1
    mov ecx, dword ptr [0x5d037f]                # 004d4bab
    mov dword ptr [0x5d2d03], ecx                # 004d4bb1
    mov dword ptr [0x5d2d07], 0x0                # 004d4bb7
    mov dword ptr [0x5d2d0b], 0x0                # 004d4bc1
    mov dword ptr [0x5d2d0f], 0x0                # 004d4bcb
    mov dword ptr [0x5d2d13], 0x1                # 004d4bd5
    mov word ptr [0x5d2d17], 0x0                 # 004d4bdf
    mov edi, 0x55a620                            # 004d4be8
    mov edx, 0x5d2d1d                            # 004d4bed
    or ecx, -0x1                                 # 004d4bf2
    {load} xor eax, eax                          # 004d4bf5
    repne scasb al, byte ptr es:[edi]            # 004d4bf7
    not ecx                                      # 004d4bf9
    {load} sub edi, ecx                          # 004d4bfb
    {load} mov esi, edi                          # 004d4bfd
    {load} mov eax, ecx                          # 004d4bff
    {load} mov edi, edx                          # 004d4c01
    shr ecx, 0x2                                 # 004d4c03
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d4c06
    {load} mov ecx, eax                          # 004d4c08
    and ecx, 0x3                                 # 004d4c0a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d4c0d
    call FUN_0043dbd5                            # 004d4c0f
    mov dword ptr [0x5839a5], 0x1                # 004d4c14
    pop edi                                      # 004d4c1e
    pop esi                                      # 004d4c1f
    {load} mov esp, ebp                          # 004d4c20
    pop ebp                                      # 004d4c22
    ret                                          # 004d4c23

