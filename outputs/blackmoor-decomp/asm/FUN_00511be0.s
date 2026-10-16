# FUN_00511be0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511be0
# extent:       0x00511be0-0x00511ca2 (194 code bytes)
# span:         0x00511be0-0x00511ca2 (code 194, tables 0, padding 0)
# sha256:       e3ed0295ab709fa016d32cb4f1d8407b5c4fcbd9cd426b588716f529dd636c60
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511be0
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1; [ecx + n] field_1; [edi + n] field_1; [esi + n] field_4, field_c
# callees:      calls FUN_00511e82, FUN_005128b0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 91 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00511e82, .text + (0x00511e82 - 0x401000)
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)

.org 0x00511be0 - 0x401000
.globl FUN_00511be0
FUN_00511be0:
    # block 0x00511be0: entry, 10 instruction(s), ends with je to 0x00511c0e (forward)
    push ebp                                     # 00511be0
    {load} mov ebp, esp                          # 00511be1
    push ebx                                     # 00511be3
    {load} xor ebx, ebx                          # 00511be4
    cmp byte ptr [ebp + arg_18], bl              # 00511be6
    push esi                                     # 00511be9
    mov esi, dword ptr [ebp + arg_14]            # 00511bea
    push edi                                     # 00511bed
    mov edi, dword ptr [ebp + arg_8]             # 00511bee
    je.d8 L_00511c0e                             # 00511bf1
    # block 0x00511bf3: entered by fall-through of je at 0x00511bf1, 12 instruction(s), calls FUN_00511e82, falls into the block at 0x00511c0e
    {load} xor eax, eax                          # 00511bf3
    cmp dword ptr [ebp + arg_c], ebx             # 00511bf5
    setg al                                      # 00511bf8
    push eax                                     # 00511bfb
    {load} xor eax, eax                          # 00511bfc
    cmp dword ptr [esi], 0x2d                    # 00511bfe
    sete al                                      # 00511c01
    {load} add eax, edi                          # 00511c04
    push eax                                     # 00511c06
    call FUN_00511e82                            # 00511c07
    pop ecx                                      # 00511c0c
    pop ecx                                      # 00511c0d
L_00511c0e:
    # block 0x00511c0e: entered by je at 0x00511bf1, 3 instruction(s), ends with jne to 0x00511c1b (forward)
    cmp dword ptr [esi], 0x2d                    # 00511c0e
    {load} mov eax, edi                          # 00511c11
    jne.d8 L_00511c1b                            # 00511c13
    # block 0x00511c15: entered by fall-through of jne at 0x00511c13, 2 instruction(s), falls into the block at 0x00511c1b
    mov byte ptr [edi], 0x2d                     # 00511c15
    lea eax, [edi + field_1]                     # 00511c18
L_00511c1b:
    # block 0x00511c1b: entered by jne at 0x00511c13, 2 instruction(s), ends with jle to 0x00511c32 (forward)
    cmp dword ptr [ebp + arg_c], ebx             # 00511c1b
    jle.d8 L_00511c32                            # 00511c1e
    # block 0x00511c20: entered by fall-through of jle at 0x00511c1e, 6 instruction(s), falls into the block at 0x00511c32
    mov dl, byte ptr [eax + field_1]             # 00511c20
    lea ecx, [eax + field_1]                     # 00511c23
    mov byte ptr [eax], dl                       # 00511c26
    {load} mov eax, ecx                          # 00511c28
    mov cl, byte ptr [0x568410]                  # 00511c2a
    mov byte ptr [eax], cl                       # 00511c30
L_00511c32:
    # block 0x00511c32: entered by jle at 0x00511c1e, 13 instruction(s), calls FUN_005128b0, ends with je to 0x00511c56 (forward)
    {load} xor ecx, ecx                          # 00511c32
    cmp byte ptr [ebp + arg_18], bl              # 00511c34
    push 0x5304e8                                # 00511c37
    sete cl                                      # 00511c3c
    {load} add ecx, eax                          # 00511c3f
    add ecx, dword ptr [ebp + arg_c]             # 00511c41
    push ecx                                     # 00511c44
    call FUN_005128b0                            # 00511c45
    cmp dword ptr [ebp + arg_10], ebx            # 00511c4a
    pop ecx                                      # 00511c4d
    pop ecx                                      # 00511c4e
    {load} mov ecx, eax                          # 00511c4f
    je.d8 L_00511c56                             # 00511c51
    # block 0x00511c53: entered by fall-through of je at 0x00511c51, 1 instruction(s), falls into the block at 0x00511c56
    mov byte ptr [ecx], 0x45                     # 00511c53
L_00511c56:
    # block 0x00511c56: entered by je at 0x00511c51, 4 instruction(s), ends with je to 0x00511c9b (forward)
    mov eax, dword ptr [esi + field_c]           # 00511c56
    inc ecx                                      # 00511c59
    cmp byte ptr [eax], 0x30                     # 00511c5a
    je.d8 L_00511c9b                             # 00511c5d
    # block 0x00511c5f: entered by fall-through of je at 0x00511c5d, 3 instruction(s), ends with jns to 0x00511c6a (forward)
    mov ebx, dword ptr [esi + field_4]           # 00511c5f
    dec ebx                                      # 00511c62
    jns.d8 L_00511c6a                            # 00511c63
    # block 0x00511c65: entered by fall-through of jns at 0x00511c63, 2 instruction(s), falls into the block at 0x00511c6a
    neg ebx                                      # 00511c65
    mov byte ptr [ecx], 0x2d                     # 00511c67
L_00511c6a:
    # block 0x00511c6a: entered by jns at 0x00511c63, 3 instruction(s), ends with jl to 0x00511c81 (forward)
    inc ecx                                      # 00511c6a
    cmp ebx, 0x64                                # 00511c6b
    jl.d8 L_00511c81                             # 00511c6e
    # block 0x00511c70: entered by fall-through of jl at 0x00511c6e, 10 instruction(s), falls into the block at 0x00511c81
    {load} mov eax, ebx                          # 00511c70
    push 0x64                                    # 00511c72
    cdq                                          # 00511c74
    pop esi                                      # 00511c75
    idiv esi                                     # 00511c76
    add byte ptr [ecx], al                       # 00511c78
    {load} mov eax, ebx                          # 00511c7a
    cdq                                          # 00511c7c
    idiv esi                                     # 00511c7d
    {load} mov ebx, edx                          # 00511c7f
L_00511c81:
    # block 0x00511c81: entered by jl at 0x00511c6e, 3 instruction(s), ends with jl to 0x00511c98 (forward)
    inc ecx                                      # 00511c81
    cmp ebx, 0xa                                 # 00511c82
    jl.d8 L_00511c98                             # 00511c85
    # block 0x00511c87: entered by fall-through of jl at 0x00511c85, 10 instruction(s), falls into the block at 0x00511c98
    {load} mov eax, ebx                          # 00511c87
    push 0xa                                     # 00511c89
    cdq                                          # 00511c8b
    pop esi                                      # 00511c8c
    idiv esi                                     # 00511c8d
    add byte ptr [ecx], al                       # 00511c8f
    {load} mov eax, ebx                          # 00511c91
    cdq                                          # 00511c93
    idiv esi                                     # 00511c94
    {load} mov ebx, edx                          # 00511c96
L_00511c98:
    # block 0x00511c98: entered by jl at 0x00511c85, 1 instruction(s), falls into the block at 0x00511c9b
    add byte ptr [ecx + field_1], bl             # 00511c98
L_00511c9b:
    # block 0x00511c9b: entered by je at 0x00511c5d, 6 instruction(s), ends with ret
    {load} mov eax, edi                          # 00511c9b
    pop edi                                      # 00511c9d
    pop esi                                      # 00511c9e
    pop ebx                                      # 00511c9f
    pop ebp                                      # 00511ca0
    ret                                          # 00511ca1

