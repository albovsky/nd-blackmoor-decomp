# FUN_00449ef8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449ef8
# extent:       0x00449ef8-0x0044a0c5 (461 code bytes)
# span:         0x00449ef8-0x0044a0c5 (code 461, tables 0, padding 0)
# sha256:       ce9dec6c4bde8901dfb4cbf675125a91c464bd64e1bf642182975898ef5e57b5
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00449ef8
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_fc, local_ff, local_100, local_104
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d960
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 175 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_fc, 0xfc  # offset -0xfc
.equ local_ff, 0xff  # offset -0xff
.equ local_100, 0x100  # offset -0x100
.equ local_104, 0x104  # offset -0x104
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050d960, .text + (0x0050d960 - 0x401000)

.org 0x00449ef8 - 0x401000
.globl FUN_00449ef8
FUN_00449ef8:
    # block 0x00449ef8: entry, 43 instruction(s), ends with jne to 0x00449fcf (forward)
    push ebp                                     # 00449ef8
    {load} mov ebp, esp                          # 00449ef9
    sub esp, 0x104                               # 00449efb
    push ebx                                     # 00449f01
    push esi                                     # 00449f02
    push edi                                     # 00449f03
    mov edi, dword ptr [ebp + arg_8]             # 00449f04
    lea edx, [ebp - local_fc]                    # 00449f07
    or ecx, -0x1                                 # 00449f0d
    {load} xor eax, eax                          # 00449f10
    repne scasb al, byte ptr es:[edi]            # 00449f12
    not ecx                                      # 00449f14
    {load} sub edi, ecx                          # 00449f16
    {load} mov esi, edi                          # 00449f18
    {load} mov eax, ecx                          # 00449f1a
    {load} mov edi, edx                          # 00449f1c
    shr ecx, 0x2                                 # 00449f1e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00449f21
    {load} mov ecx, eax                          # 00449f23
    and ecx, 0x3                                 # 00449f25
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00449f28
    mov cl, byte ptr [ebp + arg_c]               # 00449f2a
    mov byte ptr [ebp - local_100], cl           # 00449f2d
    mov byte ptr [ebp - local_ff], 0x0           # 00449f33
    mov edi, dword ptr [ebp + arg_8]             # 00449f3a
    or ecx, -0x1                                 # 00449f3d
    {load} xor eax, eax                          # 00449f40
    repne scasb al, byte ptr es:[edi]            # 00449f42
    not ecx                                      # 00449f44
    add ecx, -0x1                                # 00449f46
    mov word ptr [ebp - local_104], cx           # 00449f49
    movsx ecx, word ptr [ebp - local_104]        # 00449f50
    {load} xor eax, eax                          # 00449f57
    mov edi, dword ptr [ebp + arg_8]             # 00449f59
    {load} mov edx, ecx                          # 00449f5c
    shr ecx, 0x2                                 # 00449f5e
    rep stosd dword ptr es:[edi], eax            # 00449f61
    {load} mov ecx, edx                          # 00449f63
    and ecx, 0x3                                 # 00449f65
    rep stosb byte ptr es:[edi], al              # 00449f68
    movsx eax, word ptr [ebp + arg_10]           # 00449f6a
    test eax, eax                                # 00449f6e
    jne.d8 L_00449fcf                            # 00449f70
    # block 0x00449f72: entered by fall-through of jne at 0x00449f70, 36 instruction(s), ends with forward jump to 0x0044a0be
    lea edi, [ebp - local_100]                   # 00449f72
    mov edx, dword ptr [ebp + arg_8]             # 00449f78
    or ecx, -0x1                                 # 00449f7b
    {load} xor eax, eax                          # 00449f7e
    repne scasb al, byte ptr es:[edi]            # 00449f80
    not ecx                                      # 00449f82
    {load} sub edi, ecx                          # 00449f84
    {load} mov esi, edi                          # 00449f86
    {load} mov eax, ecx                          # 00449f88
    {load} mov edi, edx                          # 00449f8a
    shr ecx, 0x2                                 # 00449f8c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00449f8f
    {load} mov ecx, eax                          # 00449f91
    and ecx, 0x3                                 # 00449f93
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00449f96
    lea edi, [ebp - local_fc]                    # 00449f98
    mov edx, dword ptr [ebp + arg_8]             # 00449f9e
    or ecx, -0x1                                 # 00449fa1
    {load} xor eax, eax                          # 00449fa4
    repne scasb al, byte ptr es:[edi]            # 00449fa6
    not ecx                                      # 00449fa8
    {load} sub edi, ecx                          # 00449faa
    {load} mov esi, edi                          # 00449fac
    {load} mov ebx, ecx                          # 00449fae
    {load} mov edi, edx                          # 00449fb0
    or ecx, -0x1                                 # 00449fb2
    {load} xor eax, eax                          # 00449fb5
    repne scasb al, byte ptr es:[edi]            # 00449fb7
    add edi, -0x1                                # 00449fb9
    {load} mov ecx, ebx                          # 00449fbc
    shr ecx, 0x2                                 # 00449fbe
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00449fc1
    {load} mov ecx, ebx                          # 00449fc3
    and ecx, 0x3                                 # 00449fc5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00449fc8
    jmp.d32 L_0044a0be                           # 00449fca
L_00449fcf:
    # block 0x00449fcf: entered by jne at 0x00449f70, 4 instruction(s), ends with jne to 0x0044a03b (forward)
    movsx eax, word ptr [ebp + arg_10]           # 00449fcf
    movsx ecx, word ptr [ebp - local_104]        # 00449fd3
    {load} cmp eax, ecx                          # 00449fda
    jne.d8 L_0044a03b                            # 00449fdc
    # block 0x00449fde: entered by fall-through of jne at 0x00449fdc, 36 instruction(s), ends with forward jump to 0x0044a0be
    lea edi, [ebp - local_fc]                    # 00449fde
    mov edx, dword ptr [ebp + arg_8]             # 00449fe4
    or ecx, -0x1                                 # 00449fe7
    {load} xor eax, eax                          # 00449fea
    repne scasb al, byte ptr es:[edi]            # 00449fec
    not ecx                                      # 00449fee
    {load} sub edi, ecx                          # 00449ff0
    {load} mov esi, edi                          # 00449ff2
    {load} mov eax, ecx                          # 00449ff4
    {load} mov edi, edx                          # 00449ff6
    shr ecx, 0x2                                 # 00449ff8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00449ffb
    {load} mov ecx, eax                          # 00449ffd
    and ecx, 0x3                                 # 00449fff
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044a002
    lea edi, [ebp - local_100]                   # 0044a004
    mov edx, dword ptr [ebp + arg_8]             # 0044a00a
    or ecx, -0x1                                 # 0044a00d
    {load} xor eax, eax                          # 0044a010
    repne scasb al, byte ptr es:[edi]            # 0044a012
    not ecx                                      # 0044a014
    {load} sub edi, ecx                          # 0044a016
    {load} mov esi, edi                          # 0044a018
    {load} mov ebx, ecx                          # 0044a01a
    {load} mov edi, edx                          # 0044a01c
    or ecx, -0x1                                 # 0044a01e
    {load} xor eax, eax                          # 0044a021
    repne scasb al, byte ptr es:[edi]            # 0044a023
    add edi, -0x1                                # 0044a025
    {load} mov ecx, ebx                          # 0044a028
    shr ecx, 0x2                                 # 0044a02a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044a02d
    {load} mov ecx, ebx                          # 0044a02f
    and ecx, 0x3                                 # 0044a031
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044a034
    jmp.d32 L_0044a0be                           # 0044a036
L_0044a03b:
    # block 0x0044a03b: entered by jne at 0x00449fdc, 50 instruction(s), calls FUN_0050d960, falls into the block at 0x0044a0be
    movsx eax, word ptr [ebp + arg_10]           # 0044a03b
    push eax                                     # 0044a03f
    lea ecx, [ebp - local_fc]                    # 0044a040
    push ecx                                     # 0044a046
    mov edx, dword ptr [ebp + arg_8]             # 0044a047
    push edx                                     # 0044a04a
    call FUN_0050d960                            # 0044a04b
    add esp, 0xc                                 # 0044a050
    lea edi, [ebp - local_100]                   # 0044a053
    mov edx, dword ptr [ebp + arg_8]             # 0044a059
    or ecx, -0x1                                 # 0044a05c
    {load} xor eax, eax                          # 0044a05f
    repne scasb al, byte ptr es:[edi]            # 0044a061
    not ecx                                      # 0044a063
    {load} sub edi, ecx                          # 0044a065
    {load} mov esi, edi                          # 0044a067
    {load} mov ebx, ecx                          # 0044a069
    {load} mov edi, edx                          # 0044a06b
    or ecx, -0x1                                 # 0044a06d
    {load} xor eax, eax                          # 0044a070
    repne scasb al, byte ptr es:[edi]            # 0044a072
    add edi, -0x1                                # 0044a074
    {load} mov ecx, ebx                          # 0044a077
    shr ecx, 0x2                                 # 0044a079
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044a07c
    {load} mov ecx, ebx                          # 0044a07e
    and ecx, 0x3                                 # 0044a080
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044a083
    movsx eax, word ptr [ebp + arg_10]           # 0044a085
    lea ecx, [ebp + eax - local_fc]              # 0044a089
    {load} mov edi, ecx                          # 0044a090
    mov edx, dword ptr [ebp + arg_8]             # 0044a092
    or ecx, -0x1                                 # 0044a095
    {load} xor eax, eax                          # 0044a098
    repne scasb al, byte ptr es:[edi]            # 0044a09a
    not ecx                                      # 0044a09c
    {load} sub edi, ecx                          # 0044a09e
    {load} mov esi, edi                          # 0044a0a0
    {load} mov ebx, ecx                          # 0044a0a2
    {load} mov edi, edx                          # 0044a0a4
    or ecx, -0x1                                 # 0044a0a6
    {load} xor eax, eax                          # 0044a0a9
    repne scasb al, byte ptr es:[edi]            # 0044a0ab
    add edi, -0x1                                # 0044a0ad
    {load} mov ecx, ebx                          # 0044a0b0
    shr ecx, 0x2                                 # 0044a0b2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044a0b5
    {load} mov ecx, ebx                          # 0044a0b7
    and ecx, 0x3                                 # 0044a0b9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044a0bc
L_0044a0be:
    # block 0x0044a0be: entered by jmp at 0x00449fca; jmp at 0x0044a036, 6 instruction(s), ends with ret
    pop edi                                      # 0044a0be
    pop esi                                      # 0044a0bf
    pop ebx                                      # 0044a0c0
    {load} mov esp, ebp                          # 0044a0c1
    pop ebp                                      # 0044a0c3
    ret                                          # 0044a0c4

