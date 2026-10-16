# FUN_00511cf7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511cf7
# extent:       0x00511cf7-0x00511d9e (167 code bytes)
# span:         0x00511cf7-0x00511d9e (code 167, tables 0, padding 0)
# sha256:       f2c354fa8166a3b659d23d3a9180674b01b9aa78183b01ad7bc7b7b7ca307c40
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511cf7
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1; [ebx + n] field_1; [esi + n] field_4
# callees:      calls FUN_00511e82, FUN_0050f920
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 73 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_00511e82, .text + (0x00511e82 - 0x401000)

.org 0x00511cf7 - 0x401000
.globl FUN_00511cf7
FUN_00511cf7:
    # block 0x00511cf7: entry, 11 instruction(s), ends with je to 0x00511d27 (forward)
    push ebp                                     # 00511cf7
    {load} mov ebp, esp                          # 00511cf8
    push ebx                                     # 00511cfa
    push esi                                     # 00511cfb
    mov esi, dword ptr [ebp + arg_10]            # 00511cfc
    mov ebx, dword ptr [ebp + arg_8]             # 00511cff
    push edi                                     # 00511d02
    mov eax, dword ptr [esi + field_4]           # 00511d03
    dec eax                                      # 00511d06
    cmp byte ptr [ebp + arg_14], 0x0             # 00511d07
    je.d8 L_00511d27                             # 00511d0b
    # block 0x00511d0d: entered by fall-through of je at 0x00511d0b, 2 instruction(s), ends with jne to 0x00511d27 (forward)
    cmp eax, dword ptr [ebp + arg_c]             # 00511d0d
    jne.d8 L_00511d27                            # 00511d10
    # block 0x00511d12: entered by fall-through of jne at 0x00511d10, 8 instruction(s), falls into the block at 0x00511d27
    {load} xor ecx, ecx                          # 00511d12
    cmp dword ptr [esi], 0x2d                    # 00511d14
    sete cl                                      # 00511d17
    {load} add ecx, eax                          # 00511d1a
    {load} add ecx, ebx                          # 00511d1c
    {load} mov eax, ecx                          # 00511d1e
    mov byte ptr [eax], 0x30                     # 00511d20
    and byte ptr [eax + field_1], 0x0            # 00511d23
L_00511d27:
    # block 0x00511d27: entered by je at 0x00511d0b; jne at 0x00511d10, 3 instruction(s), ends with jne to 0x00511d34 (forward)
    cmp dword ptr [esi], 0x2d                    # 00511d27
    {load} mov edi, ebx                          # 00511d2a
    jne.d8 L_00511d34                            # 00511d2c
    # block 0x00511d2e: entered by fall-through of jne at 0x00511d2c, 2 instruction(s), falls into the block at 0x00511d34
    mov byte ptr [ebx], 0x2d                     # 00511d2e
    lea edi, [ebx + field_1]                     # 00511d31
L_00511d34:
    # block 0x00511d34: entered by jne at 0x00511d2c, 3 instruction(s), ends with jg to 0x00511d4b (forward)
    mov eax, dword ptr [esi + field_4]           # 00511d34
    test eax, eax                                # 00511d37
    jg.d8 L_00511d4b                             # 00511d39
    # block 0x00511d3b: entered by fall-through of jg at 0x00511d39, 8 instruction(s), calls FUN_00511e82, ends with forward jump to 0x00511d4d
    push 0x1                                     # 00511d3b
    push edi                                     # 00511d3d
    call FUN_00511e82                            # 00511d3e
    pop ecx                                      # 00511d43
    mov byte ptr [edi], 0x30                     # 00511d44
    pop ecx                                      # 00511d47
    inc edi                                      # 00511d48
    jmp.d8 L_00511d4d                            # 00511d49
L_00511d4b:
    # block 0x00511d4b: entered by jg at 0x00511d39, 1 instruction(s), falls into the block at 0x00511d4d
    {load} add edi, eax                          # 00511d4b
L_00511d4d:
    # block 0x00511d4d: entered by jmp at 0x00511d49, 2 instruction(s), ends with jle to 0x00511d97 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 00511d4d
    jle.d8 L_00511d97                            # 00511d51
    # block 0x00511d53: entered by fall-through of jle at 0x00511d51, 11 instruction(s), calls FUN_00511e82, ends with jge to 0x00511d97 (forward)
    push 0x1                                     # 00511d53
    push edi                                     # 00511d55
    call FUN_00511e82                            # 00511d56
    mov al, byte ptr [0x568410]                  # 00511d5b
    pop ecx                                      # 00511d60
    mov byte ptr [edi], al                       # 00511d61
    mov esi, dword ptr [esi + field_4]           # 00511d63
    inc edi                                      # 00511d66
    pop ecx                                      # 00511d67
    test esi, esi                                # 00511d68
    jge.d8 L_00511d97                            # 00511d6a
    # block 0x00511d6c: entered by fall-through of jge at 0x00511d6a, 2 instruction(s), ends with je to 0x00511d76 (forward)
    cmp byte ptr [ebp + arg_14], 0x0             # 00511d6c
    je.d8 L_00511d76                             # 00511d70
    # block 0x00511d72: entered by fall-through of je at 0x00511d70, 2 instruction(s), ends with forward jump to 0x00511d7d
    neg esi                                      # 00511d72
    jmp.d8 L_00511d7d                            # 00511d74
L_00511d76:
    # block 0x00511d76: entered by je at 0x00511d70, 3 instruction(s), ends with jl to 0x00511d80 (forward)
    neg esi                                      # 00511d76
    cmp dword ptr [ebp + arg_c], esi             # 00511d78
    jl.d8 L_00511d80                             # 00511d7b
L_00511d7d:
    # block 0x00511d7d: entered by jmp at 0x00511d74; fall-through of jl at 0x00511d7b, 1 instruction(s), falls into the block at 0x00511d80
    mov dword ptr [ebp + arg_c], esi             # 00511d7d
L_00511d80:
    # block 0x00511d80: entered by jl at 0x00511d7b, 8 instruction(s), calls FUN_00511e82, FUN_0050f920, falls into the block at 0x00511d97
    push dword ptr [ebp + arg_c]                 # 00511d80
    push edi                                     # 00511d83
    call FUN_00511e82                            # 00511d84
    push dword ptr [ebp + arg_c]                 # 00511d89
    push 0x30                                    # 00511d8c
    push edi                                     # 00511d8e
    call FUN_0050f920                            # 00511d8f
    add esp, 0x14                                # 00511d94
L_00511d97:
    # block 0x00511d97: entered by jle at 0x00511d51; jge at 0x00511d6a, 6 instruction(s), ends with ret
    pop edi                                      # 00511d97
    {load} mov eax, ebx                          # 00511d98
    pop esi                                      # 00511d9a
    pop ebx                                      # 00511d9b
    pop ebp                                      # 00511d9c
    ret                                          # 00511d9d

