# FUN_00518a16
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518a16
# extent:       0x00518a16-0x00518b98 (386 code bytes)
# span:         0x00518a16-0x00518b98 (code 386, tables 0, padding 0)
# sha256:       fcdc431550d77b6af76e260f933866216b1618e2305153c4e0291419b78023e5
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518a16
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [edx + n] field_minus_4; [esi + n] field_50, field_54, field_58
# callees:      calls FUN_00510dd3, FUN_00518b98, FUN_00512c18, FUN_00512c79, FUN_0050d7f4; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 138 instruction(s), 23 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58

# --- external targets -----------------------------------------------
.set FUN_0050d7f4, .text + (0x0050d7f4 - 0x401000)
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00518b98, .text + (0x00518b98 - 0x401000)

.org 0x00518a16 - 0x401000
.globl FUN_00518a16
FUN_00518a16:
    # block 0x00518a16: entry, 11 instruction(s), ends with je to 0x00518a91 (forward)
    push ebp                                     # 00518a16
    {load} mov ebp, esp                          # 00518a17
    sub esp, 0xc                                 # 00518a19
    mov eax, dword ptr [ebp + arg_8]             # 00518a1c
    and dword ptr [ebp - local_4], 0x0           # 00518a1f
    dec eax                                      # 00518a23
    push ebx                                     # 00518a24
    push esi                                     # 00518a25
    dec eax                                      # 00518a26
    push edi                                     # 00518a27
    je.d8 L_00518a91                             # 00518a28
    # block 0x00518a2a: entered by fall-through of je at 0x00518a28, 3 instruction(s), ends with je to 0x00518a74 (forward)
    dec eax                                      # 00518a2a
    dec eax                                      # 00518a2b
    je.d8 L_00518a74                             # 00518a2c
    # block 0x00518a2e: entered by fall-through of je at 0x00518a2c, 2 instruction(s), ends with je to 0x00518a74 (forward)
    sub eax, 0x4                                 # 00518a2e
    je.d8 L_00518a74                             # 00518a31
    # block 0x00518a33: entered by fall-through of je at 0x00518a31, 2 instruction(s), ends with je to 0x00518a74 (forward)
    sub eax, 0x3                                 # 00518a33
    je.d8 L_00518a74                             # 00518a36
    # block 0x00518a38: entered by fall-through of je at 0x00518a36, 2 instruction(s), ends with je to 0x00518a67 (forward)
    sub eax, 0x4                                 # 00518a38
    je.d8 L_00518a67                             # 00518a3b
    # block 0x00518a3d: entered by fall-through of je at 0x00518a3b, 2 instruction(s), ends with je to 0x00518a5a (forward)
    sub eax, 0x6                                 # 00518a3d
    je.d8 L_00518a5a                             # 00518a40
    # block 0x00518a42: entered by fall-through of je at 0x00518a40, 2 instruction(s), ends with je to 0x00518a4d (forward)
    dec eax                                      # 00518a42
    je.d8 L_00518a4d                             # 00518a43
    # block 0x00518a45: entered by fall-through of je at 0x00518a43, 2 instruction(s), ends with forward jump to 0x00518b93
    or eax, -0x1                                 # 00518a45
    jmp.d32 L_00518b93                           # 00518a48
L_00518a4d:
    # block 0x00518a4d: entered by je at 0x00518a43, 3 instruction(s), ends with forward jump to 0x00518a9c
    mov ebx, dword ptr [0x63cd90]                # 00518a4d
    mov edi, 0x63cd90                            # 00518a53
    jmp.d8 L_00518a9c                            # 00518a58
L_00518a5a:
    # block 0x00518a5a: entered by je at 0x00518a40, 3 instruction(s), ends with forward jump to 0x00518a9c
    mov ebx, dword ptr [0x63cd8c]                # 00518a5a
    mov edi, 0x63cd8c                            # 00518a60
    jmp.d8 L_00518a9c                            # 00518a65
L_00518a67:
    # block 0x00518a67: entered by je at 0x00518a3b, 3 instruction(s), ends with forward jump to 0x00518a9c
    mov ebx, dword ptr [0x63cd94]                # 00518a67
    mov edi, 0x63cd94                            # 00518a6d
    jmp.d8 L_00518a9c                            # 00518a72
L_00518a74:
    # block 0x00518a74: entered by je at 0x00518a2c; je at 0x00518a31; je at 0x00518a36, 11 instruction(s), calls FUN_00510dd3, FUN_00518b98, ends with forward jump to 0x00518aae
    call FUN_00510dd3                            # 00518a74
    {load} mov esi, eax                          # 00518a79
    push dword ptr [esi + field_50]              # 00518a7b
    push dword ptr [ebp + arg_8]                 # 00518a7e
    call FUN_00518b98                            # 00518a81
    {load} mov edi, eax                          # 00518a86
    pop ecx                                      # 00518a88
    add edi, 0x8                                 # 00518a89
    pop ecx                                      # 00518a8c
    mov ebx, dword ptr [edi]                     # 00518a8d
    jmp.d8 L_00518aae                            # 00518a8f
L_00518a91:
    # block 0x00518a91: entered by je at 0x00518a28, 2 instruction(s), falls into the block at 0x00518a9c
    mov ebx, dword ptr [0x63cd88]                # 00518a91
    mov edi, 0x63cd88                            # 00518a97
L_00518a9c:
    # block 0x00518a9c: entered by jmp at 0x00518a58; jmp at 0x00518a65; jmp at 0x00518a72, 5 instruction(s), calls FUN_00512c18, falls into the block at 0x00518aae
    push 0x1                                     # 00518a9c
    mov dword ptr [ebp - local_4], 0x1           # 00518a9e
    call FUN_00512c18                            # 00518aa5
    mov esi, dword ptr [ebp + arg_8]             # 00518aaa
    pop ecx                                      # 00518aad
L_00518aae:
    # block 0x00518aae: entered by jmp at 0x00518a8f, 2 instruction(s), ends with jne to 0x00518ac9 (forward)
    cmp ebx, 0x1                                 # 00518aae
    jne.d8 L_00518ac9                            # 00518ab1
    # block 0x00518ab3: entered by fall-through of jne at 0x00518ab1, 2 instruction(s), ends with je to 0x00518b91 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00518ab3
    je.d32 L_00518b91                            # 00518ab7
    # block 0x00518abd: entered by fall-through of je at 0x00518ab7, 4 instruction(s), calls FUN_00512c79, ends with forward jump to 0x00518b91
    push ebx                                     # 00518abd
    call FUN_00512c79                            # 00518abe
    pop ecx                                      # 00518ac3
    jmp.d32 L_00518b91                           # 00518ac4
L_00518ac9:
    # block 0x00518ac9: entered by jne at 0x00518ab1, 3 instruction(s), ends with jne to 0x00518ae3 (forward)
    {load} xor ecx, ecx                          # 00518ac9
    {load} cmp ebx, ecx                          # 00518acb
    jne.d8 L_00518ae3                            # 00518acd
    # block 0x00518acf: entered by fall-through of jne at 0x00518acd, 2 instruction(s), ends with je to 0x00518adc (forward)
    cmp dword ptr [ebp - local_4], ecx           # 00518acf
    je.d8 L_00518adc                             # 00518ad2
    # block 0x00518ad4: entered by fall-through of je at 0x00518ad2, 3 instruction(s), calls FUN_00512c79, falls into the block at 0x00518adc
    push 0x1                                     # 00518ad4
    call FUN_00512c79                            # 00518ad6
    pop ecx                                      # 00518adb
L_00518adc:
    # block 0x00518adc: entered by je at 0x00518ad2, 2 instruction(s), calls FUN_0050d7f4, falls into the block at 0x00518ae3
    push 0x3                                     # 00518adc
    call FUN_0050d7f4                            # 00518ade
L_00518ae3:
    # block 0x00518ae3: entered by jne at 0x00518acd, 3 instruction(s), ends with je to 0x00518af5 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00518ae3
    cmp eax, 0x8                                 # 00518ae6
    je.d8 L_00518af5                             # 00518ae9
    # block 0x00518aeb: entered by fall-through of je at 0x00518ae9, 2 instruction(s), ends with je to 0x00518af5 (forward)
    cmp eax, 0xb                                 # 00518aeb
    je.d8 L_00518af5                             # 00518aee
    # block 0x00518af0: entered by fall-through of je at 0x00518aee, 2 instruction(s), ends with jne to 0x00518b10 (forward)
    cmp eax, 0x4                                 # 00518af0
    jne.d8 L_00518b10                            # 00518af3
L_00518af5:
    # block 0x00518af5: entered by je at 0x00518ae9; je at 0x00518aee; fall-through of jne at 0x00518af3, 5 instruction(s), ends with jne to 0x00518b4c (forward)
    mov edx, dword ptr [esi + field_54]          # 00518af5
    cmp eax, 0x8                                 # 00518af8
    mov dword ptr [ebp - local_8], edx           # 00518afb
    mov dword ptr [esi + field_54], ecx          # 00518afe
    jne.d8 L_00518b4c                            # 00518b01
    # block 0x00518b03: entered by fall-through of jne at 0x00518b01, 3 instruction(s), falls into the block at 0x00518b10
    mov edx, dword ptr [esi + field_58]          # 00518b03
    mov dword ptr [esi + field_58], 0x8c         # 00518b06
    mov dword ptr [ebp - local_c], edx           # 00518b0d
L_00518b10:
    # block 0x00518b10: entered by jne at 0x00518af3, 2 instruction(s), ends with jne to 0x00518b4c (forward)
    cmp eax, 0x8                                 # 00518b10
    jne.d8 L_00518b4c                            # 00518b13
    # block 0x00518b15: entered by fall-through of jne at 0x00518b13, 5 instruction(s), ends with jge to 0x00518b4e (forward)
    mov ecx, dword ptr [0x568ad0]                # 00518b15
    mov eax, dword ptr [0x568ad4]                # 00518b1b
    {load} add eax, ecx                          # 00518b20
    {load} cmp ecx, eax                          # 00518b22
    jge.d8 L_00518b4e                            # 00518b24
    # block 0x00518b26: entered by fall-through of jge at 0x00518b24, 2 instruction(s), falls into the block at 0x00518b2c
    lea eax, [ecx + 2*ecx]                       # 00518b26
    shl eax, 0x2                                 # 00518b29
L_00518b2c:
    # block 0x00518b2c: entered by jl at 0x00518b48, 9 instruction(s), ends with jl to 0x00518b2c (backward)
    mov edx, dword ptr [esi + field_50]          # 00518b2c
    add eax, 0xc                                 # 00518b2f
    and dword ptr [edx + eax - field_minus_4], 0x0 # 00518b32
    mov edx, dword ptr [0x568ad0]                # 00518b37
    mov edi, dword ptr [0x568ad4]                # 00518b3d
    inc ecx                                      # 00518b43
    {load} add edi, edx                          # 00518b44
    {load} cmp ecx, edi                          # 00518b46
    jl.d8 L_00518b2c                             # 00518b48
    # block 0x00518b4a: entered by fall-through of jl at 0x00518b48, 1 instruction(s), ends with forward jump to 0x00518b4e
    jmp.d8 L_00518b4e                            # 00518b4a
L_00518b4c:
    # block 0x00518b4c: entered by jne at 0x00518b01; jne at 0x00518b13, 1 instruction(s), falls into the block at 0x00518b4e
    mov dword ptr [edi], ecx                     # 00518b4c
L_00518b4e:
    # block 0x00518b4e: entered by jge at 0x00518b24; jmp at 0x00518b4a, 2 instruction(s), ends with je to 0x00518b5c (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00518b4e
    je.d8 L_00518b5c                             # 00518b52
    # block 0x00518b54: entered by fall-through of je at 0x00518b52, 3 instruction(s), calls FUN_00512c79, falls into the block at 0x00518b5c
    push 0x1                                     # 00518b54
    call FUN_00512c79                            # 00518b56
    pop ecx                                      # 00518b5b
L_00518b5c:
    # block 0x00518b5c: entered by je at 0x00518b52, 2 instruction(s), ends with jne to 0x00518b6d (forward)
    cmp dword ptr [ebp + arg_8], 0x8             # 00518b5c
    jne.d8 L_00518b6d                            # 00518b60
    # block 0x00518b62: entered by fall-through of jne at 0x00518b60, 6 instruction(s), calls indirect ebx, ends with forward jump to 0x00518b7f
    push dword ptr [esi + field_58]              # 00518b62
    push 0x8                                     # 00518b65
    call ebx                                     # 00518b67
    pop ecx                                      # 00518b69
    pop ecx                                      # 00518b6a
    jmp.d8 L_00518b7f                            # 00518b6b
L_00518b6d:
    # block 0x00518b6d: entered by jne at 0x00518b60, 5 instruction(s), calls indirect ebx, ends with je to 0x00518b7f (forward)
    push dword ptr [ebp + arg_8]                 # 00518b6d
    call ebx                                     # 00518b70
    cmp dword ptr [ebp + arg_8], 0xb             # 00518b72
    pop ecx                                      # 00518b76
    je.d8 L_00518b7f                             # 00518b77
    # block 0x00518b79: entered by fall-through of je at 0x00518b77, 2 instruction(s), ends with jne to 0x00518b91 (forward)
    cmp dword ptr [ebp + arg_8], 0x4             # 00518b79
    jne.d8 L_00518b91                            # 00518b7d
L_00518b7f:
    # block 0x00518b7f: entered by jmp at 0x00518b6b; je at 0x00518b77; fall-through of jne at 0x00518b7d, 4 instruction(s), ends with jne to 0x00518b91 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00518b7f
    cmp dword ptr [ebp + arg_8], 0x8             # 00518b82
    mov dword ptr [esi + field_54], eax          # 00518b86
    jne.d8 L_00518b91                            # 00518b89
    # block 0x00518b8b: entered by fall-through of jne at 0x00518b89, 2 instruction(s), falls into the block at 0x00518b91
    mov eax, dword ptr [ebp - local_c]           # 00518b8b
    mov dword ptr [esi + field_58], eax          # 00518b8e
L_00518b91:
    # block 0x00518b91: entered by je at 0x00518ab7; jmp at 0x00518ac4; jne at 0x00518b7d; jne at 0x00518b89, 1 instruction(s), falls into the block at 0x00518b93
    {load} xor eax, eax                          # 00518b91
L_00518b93:
    # block 0x00518b93: entered by jmp at 0x00518a48, 5 instruction(s), ends with ret
    pop edi                                      # 00518b93
    pop esi                                      # 00518b94
    pop ebx                                      # 00518b95
    leave                                        # 00518b96
    ret                                          # 00518b97

