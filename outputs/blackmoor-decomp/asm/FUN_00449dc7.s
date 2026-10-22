# FUN_00449dc7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449dc7
# extent:       0x00449dc7-0x00449ef8 (305 code bytes)
# span:         0x00449dc7-0x00449ef8 (code 305, tables 0, padding 0)
# sha256:       761bc0fb19754269d4a11f6fe8168d465764614775887e1e316094c4d346dbe2
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00449dc7
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_fb, local_fc, local_ff, local_100, local_104
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d960
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m449dc7_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 111 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_fb, 0xfb  # offset -0xfb
.equ local_fc, 0xfc  # offset -0xfc
.equ local_ff, 0xff  # offset -0xff
.equ local_100, 0x100  # offset -0x100
.equ local_104, 0x104  # offset -0x104
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050d960, .text + (0x0050d960 - 0x401000)

.org 0x00449dc7 - 0x401000
.globl FUN_00449dc7
FUN_00449dc7:
    # block 0x00449dc7: entry, 43 instruction(s), ends with jne to 0x00449e6e (forward)
    push ebp                                     # 00449dc7
    {load} mov ebp, esp                          # 00449dc8
    sub esp, 0x104                               # 00449dca
    push ebx                                     # 00449dd0
    push esi                                     # 00449dd1
    push edi                                     # 00449dd2
    mov edi, dword ptr [ebp + arg_8]             # 00449dd3
    lea edx, [ebp - local_fc]                    # 00449dd6
    or ecx, -0x1                                 # 00449ddc
    {load} xor eax, eax                          # 00449ddf
    repne scasb al, byte ptr es:[edi]            # 00449de1
    not ecx                                      # 00449de3
    {load} sub edi, ecx                          # 00449de5
    {load} mov esi, edi                          # 00449de7
    {load} mov eax, ecx                          # 00449de9
    {load} mov edi, edx                          # 00449deb
    shr ecx, 0x2                                 # 00449ded
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00449df0
    {load} mov ecx, eax                          # 00449df2
    and ecx, 0x3                                 # 00449df4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00449df7
    mov cl, byte ptr [ebp + arg_c]               # 00449df9
    mov byte ptr [ebp - local_100], cl           # 00449dfc
    mov byte ptr [ebp - local_ff], 0x0           # 00449e02
    mov edi, dword ptr [ebp + arg_8]             # 00449e09
    or ecx, -0x1                                 # 00449e0c
    {load} xor eax, eax                          # 00449e0f
    repne scasb al, byte ptr es:[edi]            # 00449e11
    not ecx                                      # 00449e13
    add ecx, -0x1                                # 00449e15
    mov word ptr [ebp - local_104], cx           # 00449e18
    movsx ecx, word ptr [ebp - local_104]        # 00449e1f
    {load} xor eax, eax                          # 00449e26
    mov edi, dword ptr [ebp + arg_8]             # 00449e28
    {load} mov edx, ecx                          # 00449e2b
    shr ecx, 0x2                                 # 00449e2d
    rep stosd dword ptr es:[edi], eax            # 00449e30
    {load} mov ecx, edx                          # 00449e32
    and ecx, 0x3                                 # 00449e34
    rep stosb byte ptr es:[edi], al              # 00449e37
    movsx eax, word ptr [ebp + arg_10]           # 00449e39
    test eax, eax                                # 00449e3d
    jne.d8 L_00449e6e                            # 00449e3f
    # block 0x00449e41: entered by fall-through of jne at 0x00449e3f, 17 instruction(s), ends with forward jump to 0x00449ef1
    lea ecx, [ebp - local_fb]                    # 00449e41
    {load} mov edi, ecx                          # 00449e47
    mov edx, dword ptr [ebp + arg_8]             # 00449e49
    or ecx, -0x1                                 # 00449e4c
    {load} xor eax, eax                          # 00449e4f
    repne scasb al, byte ptr es:[edi]            # 00449e51
    not ecx                                      # 00449e53
    {load} sub edi, ecx                          # 00449e55
    {load} mov esi, edi                          # 00449e57
    {load} mov eax, ecx                          # 00449e59
    {load} mov edi, edx                          # 00449e5b
    shr ecx, 0x2                                 # 00449e5d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00449e60
    {load} mov ecx, eax                          # 00449e62
    and ecx, 0x3                                 # 00449e64
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00449e67
    jmp.d32 L_00449ef1                           # 00449e69
L_00449e6e:
    # block 0x00449e6e: entered by jne at 0x00449e3f, 5 instruction(s), ends with jne to 0x00449ea0 (forward)
    movsx ecx, word ptr [ebp + arg_10]           # 00449e6e
    movsx edx, word ptr [ebp - local_104]        # 00449e72
    sub edx, 0x1                                 # 00449e79
    {load} cmp ecx, edx                          # 00449e7c
    jne.d8 L_00449ea0                            # 00449e7e
    # block 0x00449e80: entered by fall-through of jne at 0x00449e7e, 10 instruction(s), calls FUN_0050d960, ends with forward jump to 0x00449ef1
    movsx eax, word ptr [ebp - local_104]        # 00449e80
    sub eax, 0x1                                 # 00449e87
    push eax                                     # 00449e8a
    lea ecx, [ebp - local_fc]                    # 00449e8b
    push ecx                                     # 00449e91
    mov edx, dword ptr [ebp + arg_8]             # 00449e92
    push edx                                     # 00449e95
    call FUN_0050d960                            # 00449e96
    add esp, 0xc                                 # 00449e9b
    jmp.d8 L_00449ef1                            # 00449e9e
L_00449ea0:
    # block 0x00449ea0: entered by jne at 0x00449e7e, 30 instruction(s), calls FUN_0050d960, falls into the block at 0x00449ef1
    movsx eax, word ptr [ebp + arg_10]           # 00449ea0
    push eax                                     # 00449ea4
    lea ecx, [ebp - local_fc]                    # 00449ea5
    push ecx                                     # 00449eab
    mov edx, dword ptr [ebp + arg_8]             # 00449eac
    push edx                                     # 00449eaf
    call FUN_0050d960                            # 00449eb0
    add esp, 0xc                                 # 00449eb5
    movsx eax, word ptr [ebp + arg_10]           # 00449eb8
    lea ecx, [ebp + eax - local_fb]              # 00449ebc
    {load} mov edi, ecx                          # 00449ec3
    mov edx, dword ptr [ebp + arg_8]             # 00449ec5
    or ecx, -0x1                                 # 00449ec8
    {load} xor eax, eax                          # 00449ecb
    repne scasb al, byte ptr es:[edi]            # 00449ecd
    not ecx                                      # 00449ecf
    {load} sub edi, ecx                          # 00449ed1
    {load} mov esi, edi                          # 00449ed3
    {load} mov ebx, ecx                          # 00449ed5
    {load} mov edi, edx                          # 00449ed7
    or ecx, -0x1                                 # 00449ed9
    {load} xor eax, eax                          # 00449edc
    repne scasb al, byte ptr es:[edi]            # 00449ede
    add edi, -0x1                                # 00449ee0
    {load} mov ecx, ebx                          # 00449ee3
    shr ecx, 0x2                                 # 00449ee5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00449ee8
    {load} mov ecx, ebx                          # 00449eea
    and ecx, 0x3                                 # 00449eec
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00449eef
L_00449ef1:
    # block 0x00449ef1: entered by jmp at 0x00449e69; jmp at 0x00449e9e, 6 instruction(s), ends with ret
    pop edi                                      # 00449ef1
    pop esi                                      # 00449ef2
    pop ebx                                      # 00449ef3
    {load} mov esp, ebp                          # 00449ef4
    pop ebp                                      # 00449ef6
    ret                                          # 00449ef7

