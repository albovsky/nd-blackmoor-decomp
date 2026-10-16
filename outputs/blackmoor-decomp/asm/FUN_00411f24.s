# FUN_00411f24
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00411f24
# extent:       0x00411f24-0x004121b8 (660 code bytes)
# span:         0x00411f24-0x004121b8 (code 660, tables 0, padding 0)
# sha256:       fb55837c218fe7fb72c2f3eaa899d8061c0f2cdd32c5550b6868551bf76e8635
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00411f24
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_4, field_8, field_c, field_23, field_27; [ecx + n] field_4, field_8, field_c; [edx + n] field_2
# callees:      calls FUN_00413187, FUN_0042ba3a, FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0048945b, FUN_005193ca, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 191 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_23, 0x23  # offset +0x23
.equ field_27, 0x27  # offset +0x27

# --- external targets -----------------------------------------------
.set FUN_00413187, .text + (0x00413187 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0048945b, .text + (0x0048945b - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_005193ca, .text + (0x005193ca - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00411f24 - 0x401000
.globl FUN_00411f24
FUN_00411f24:
    # block 0x00411f24: entry, 35 instruction(s), calls FUN_00413187, FUN_0042ba3a, FUN_0051dc43, ends with jne to 0x00411fd0 (forward)
    push ebp                                     # 00411f24
    {load} mov ebp, esp                          # 00411f25
    sub esp, 0x28                                # 00411f27
    push ebx                                     # 00411f2a
    push esi                                     # 00411f2b
    push edi                                     # 00411f2c
    mov dword ptr [ebp - local_28], ecx          # 00411f2d
    movsx eax, word ptr [ebp + arg_8]            # 00411f30
    imul eax, eax, 0x8d                          # 00411f34
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00411f3a
    mov dword ptr [ebp - local_c], ecx           # 00411f40
    mov edx, dword ptr [ebp - local_c]           # 00411f43
    add edx, 0xe7                                # 00411f46
    mov dword ptr [ebp - local_8], edx           # 00411f4c
    push 0x0                                     # 00411f4f
    push 0x0                                     # 00411f51
    mov eax, dword ptr [ebp - local_c]           # 00411f53
    add eax, 0x12d                               # 00411f56
    push eax                                     # 00411f5b
    mov ecx, dword ptr [ebp - local_c]           # 00411f5c
    push ecx                                     # 00411f5f
    mov ecx, dword ptr [ebp - local_28]          # 00411f60
    call FUN_00413187                            # 00411f63
    mov dx, word ptr [ebp + arg_8]               # 00411f68
    push edx                                     # 00411f6c
    call FUN_0042ba3a                            # 00411f6d
    add esp, 0x4                                 # 00411f72
    push 0xaba                                   # 00411f75
    call FUN_0051dc43                            # 00411f7a
    add esp, 0x4                                 # 00411f7f
    mov dword ptr [ebp - local_18], eax          # 00411f82
    mov eax, dword ptr [ebp - local_18]          # 00411f85
    mov dword ptr [ebp - local_4], eax           # 00411f88
    cmp dword ptr [ebp - local_4], 0x0           # 00411f8b
    jne.d8 L_00411fd0                            # 00411f8f
    # block 0x00411f91: entered by fall-through of jne at 0x00411f8f, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00411fd0
    movsx ecx, word ptr [0x5c39e3]               # 00411f91
    push ecx                                     # 00411f98
    mov edx, dword ptr [0x5bb57b]                # 00411f99
    push edx                                     # 00411f9f
    push 0x541564                                # 00411fa0
    push 0x63888b                                # 00411fa5
    call FUN_0050ca3e                            # 00411faa
    add esp, 0x10                                # 00411faf
    push 0x63888b                                # 00411fb2
    push 0x5415ac                                # 00411fb7
    mov ecx, 0x583979                            # 00411fbc
    call FUN_0042639d                            # 00411fc1
    mov ecx, 0x5cf659                            # 00411fc6
    call FUN_004c97b4                            # 00411fcb
L_00411fd0:
    # block 0x00411fd0: entered by jne at 0x00411f8f, 97 instruction(s), calls FUN_0048945b, FUN_005193ca, FUN_0051dc6c, FUN_0051dc43, ends with jne to 0x0041213a (forward)
    mov ecx, 0x2ae                               # 00411fd0
    {load} xor eax, eax                          # 00411fd5
    mov edi, dword ptr [ebp - local_4]           # 00411fd7
    rep stosd dword ptr es:[edi], eax            # 00411fda
    stosw word ptr es:[edi], ax                  # 00411fdc
    mov eax, dword ptr [ebp - local_8]           # 00411fde
    add eax, 0x2                                 # 00411fe1
    push eax                                     # 00411fe4
    mov ecx, dword ptr [ebp - local_4]           # 00411fe5
    push ecx                                     # 00411fe8
    mov ecx, 0x619935                            # 00411fe9
    call FUN_0048945b                            # 00411fee
    mov edi, 0x5415c8                            # 00411ff3
    mov edx, dword ptr [ebp - local_4]           # 00411ff8
    or ecx, -0x1                                 # 00411ffb
    {load} xor eax, eax                          # 00411ffe
    repne scasb al, byte ptr es:[edi]            # 00412000
    not ecx                                      # 00412002
    {load} sub edi, ecx                          # 00412004
    {load} mov esi, edi                          # 00412006
    {load} mov eax, ecx                          # 00412008
    {load} mov edi, edx                          # 0041200a
    shr ecx, 0x2                                 # 0041200c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041200f
    {load} mov ecx, eax                          # 00412011
    and ecx, 0x3                                 # 00412013
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00412016
    push 0xa                                     # 00412018
    lea ecx, [ebp - local_14]                    # 0041201a
    push ecx                                     # 0041201d
    mov edx, dword ptr [ebp - local_c]           # 0041201e
    movsx eax, word ptr [edx + field_2]          # 00412021
    add eax, 0x1                                 # 00412025
    push eax                                     # 00412028
    call FUN_005193ca                            # 00412029
    add esp, 0xc                                 # 0041202e
    lea edi, [ebp - local_14]                    # 00412031
    mov edx, dword ptr [ebp - local_4]           # 00412034
    or ecx, -0x1                                 # 00412037
    {load} xor eax, eax                          # 0041203a
    repne scasb al, byte ptr es:[edi]            # 0041203c
    not ecx                                      # 0041203e
    {load} sub edi, ecx                          # 00412040
    {load} mov esi, edi                          # 00412042
    {load} mov ebx, ecx                          # 00412044
    {load} mov edi, edx                          # 00412046
    or ecx, -0x1                                 # 00412048
    {load} xor eax, eax                          # 0041204b
    repne scasb al, byte ptr es:[edi]            # 0041204d
    add edi, -0x1                                # 0041204f
    {load} mov ecx, ebx                          # 00412052
    shr ecx, 0x2                                 # 00412054
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00412057
    {load} mov ecx, ebx                          # 00412059
    and ecx, 0x3                                 # 0041205b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041205e
    mov eax, dword ptr [ebp - local_4]           # 00412060
    mov ecx, dword ptr [ebp - local_c]           # 00412063
    mov dx, word ptr [ecx]                       # 00412066
    mov word ptr [eax + field_23], dx            # 00412069
    mov eax, dword ptr [ebp - local_4]           # 0041206d
    mov ecx, dword ptr [ebp - local_8]           # 00412070
    mov dx, word ptr [ecx]                       # 00412073
    mov word ptr [eax + field_27], dx            # 00412076
    mov eax, dword ptr [ebp - local_8]           # 0041207a
    add eax, 0x12                                # 0041207d
    mov ecx, dword ptr [ebp - local_4]           # 00412080
    add ecx, 0xac                                # 00412083
    mov edx, dword ptr [eax]                     # 00412089
    mov dword ptr [ecx], edx                     # 0041208b
    mov edx, dword ptr [eax + field_4]           # 0041208d
    mov dword ptr [ecx + field_4], edx           # 00412090
    mov edx, dword ptr [eax + field_8]           # 00412093
    mov dword ptr [ecx + field_8], edx           # 00412096
    mov eax, dword ptr [eax + field_c]           # 00412099
    mov dword ptr [ecx + field_c], eax           # 0041209c
    movsx ecx, word ptr [ebp + arg_8]            # 0041209f
    imul ecx, ecx, 0x8d                          # 004120a3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004120a9
    mov dword ptr [ebp - local_1c], edx          # 004120af
    mov eax, dword ptr [ebp - local_1c]          # 004120b2
    push eax                                     # 004120b5
    call FUN_0051dc6c                            # 004120b6
    add esp, 0x4                                 # 004120bb
    movsx ecx, word ptr [ebp + arg_8]            # 004120be
    imul ecx, ecx, 0x8d                          # 004120c2
    mov dword ptr [ecx + 0x5bb5e5], 0x0          # 004120c8
    push 0xaba                                   # 004120d2
    call FUN_0051dc43                            # 004120d7
    add esp, 0x4                                 # 004120dc
    mov dword ptr [ebp - local_20], eax          # 004120df
    movsx edx, word ptr [ebp + arg_8]            # 004120e2
    imul edx, edx, 0x8d                          # 004120e6
    mov eax, dword ptr [ebp - local_20]          # 004120ec
    mov dword ptr [edx + 0x5bb5e5], eax          # 004120ef
    cmp dword ptr [ebp - local_20], 0x0          # 004120f5
    jne.d8 L_0041213a                            # 004120f9
    # block 0x004120fb: entered by fall-through of jne at 0x004120f9, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0041213a
    movsx ecx, word ptr [0x5c39e3]               # 004120fb
    push ecx                                     # 00412102
    mov edx, dword ptr [0x5bb57b]                # 00412103
    push edx                                     # 00412109
    push 0x5415d8                                # 0041210a
    push 0x63888b                                # 0041210f
    call FUN_0050ca3e                            # 00412114
    add esp, 0x10                                # 00412119
    push 0x63888b                                # 0041211c
    push 0x54161c                                # 00412121
    mov ecx, 0x583979                            # 00412126
    call FUN_0042639d                            # 0041212b
    mov ecx, 0x5cf659                            # 00412130
    call FUN_004c97b4                            # 00412135
L_0041213a:
    # block 0x0041213a: entered by jne at 0x004120f9, 31 instruction(s), calls FUN_0051dc6c, ends with ret 0x4
    movsx eax, word ptr [ebp + arg_8]            # 0041213a
    imul eax, eax, 0x8d                          # 0041213e
    mov edi, dword ptr [eax + 0x5bb5e5]          # 00412144
    mov ecx, 0x2ae                               # 0041214a
    mov esi, dword ptr [ebp - local_4]           # 0041214f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00412152
    movsw word ptr es:[edi], word ptr [esi]      # 00412154
    movsx ecx, word ptr [ebp + arg_8]            # 00412156
    imul ecx, ecx, 0x8d                          # 0041215a
    mov byte ptr [ecx + 0x5bb625], 0x0           # 00412160
    movsx edx, word ptr [ebp + arg_8]            # 00412167
    imul edx, edx, 0x8d                          # 0041216b
    mov byte ptr [edx + 0x5bb5e3], 0x36          # 00412171
    movsx eax, word ptr [ebp + arg_8]            # 00412178
    imul eax, eax, 0x8d                          # 0041217c
    mov byte ptr [eax + 0x5bb5e4], 0x1           # 00412182
    movsx ecx, word ptr [ebp + arg_8]            # 00412189
    imul ecx, ecx, 0x8d                          # 0041218d
    mov dword ptr [ecx + 0x5bb632], 0x0          # 00412193
    mov edx, dword ptr [ebp - local_4]           # 0041219d
    mov dword ptr [ebp - local_24], edx          # 004121a0
    mov eax, dword ptr [ebp - local_24]          # 004121a3
    push eax                                     # 004121a6
    call FUN_0051dc6c                            # 004121a7
    add esp, 0x4                                 # 004121ac
    pop edi                                      # 004121af
    pop esi                                      # 004121b0
    pop ebx                                      # 004121b1
    {load} mov esp, ebp                          # 004121b2
    pop ebp                                      # 004121b4
    ret 0x4                                      # 004121b5

