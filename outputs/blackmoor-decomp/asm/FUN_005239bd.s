# FUN_005239bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005239bd
# extent:       0x005239bd-0x00523ab8 (251 code bytes)
# span:         0x005239bd-0x00523ab8 (code 251, tables 0, padding 0)
# sha256:       90c108c6e81de76736e24623a65a57ce8486946c8884bef1099183c5d914395b
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005239bd
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_c4, field_c8, field_e0; [edi + n] field_70; [esi + n] field_88, field_b8
# callees:      calls FUN_00524826, FUN_0051d5e1, FUN_00524837, FUN_0051d630; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 94 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_70, 0x70  # offset +0x70
.equ field_88, 0x88  # offset +0x88
.equ field_b8, 0xb8  # offset +0xb8
.equ field_c4, 0xc4  # offset +0xc4
.equ field_c8, 0xc8  # offset +0xc8
.equ field_e0, 0xe0  # offset +0xe0

# --- external targets -----------------------------------------------
.set FUN_0051d5e1, .text + (0x0051d5e1 - 0x401000)
.set FUN_0051d630, .text + (0x0051d630 - 0x401000)
.set FUN_00524826, .text + (0x00524826 - 0x401000)
.set FUN_00524837, .text + (0x00524837 - 0x401000)

.org 0x005239bd - 0x401000
.globl FUN_005239bd
FUN_005239bd:
    # block 0x005239bd: entry, 12 instruction(s), calls FUN_00524826, ends with je to 0x005239ec (forward)
    push ebp                                     # 005239bd
    {load} mov ebp, esp                          # 005239be
    push ebx                                     # 005239c0
    push esi                                     # 005239c1
    push edi                                     # 005239c2
    mov edi, dword ptr [ebp + arg_8]             # 005239c3
    {load} mov ecx, edi                          # 005239c6
    call FUN_00524826                            # 005239c8
    {load} xor ebx, ebx                          # 005239cd
    {load} mov esi, eax                          # 005239cf
    cmp dword ptr [ebp + arg_10], ebx            # 005239d1
    je.d8 L_005239ec                             # 005239d4
    # block 0x005239d6: entered by fall-through of je at 0x005239d4, 6 instruction(s), calls indirect dword ptr [eax + 0xc4], ends with forward jump to 0x00523a31
    mov eax, dword ptr [edi]                     # 005239d6
    push dword ptr [ebp + arg_c]                 # 005239d8
    {load} mov ecx, edi                          # 005239db
    call dword ptr [eax + field_c4]              # 005239dd
    or dword ptr [esi + field_b8], 0xc           # 005239e3
    jmp.d8 L_00523a31                            # 005239ea
L_005239ec:
    # block 0x005239ec: entered by je at 0x005239d4, 20 instruction(s), calls FUN_0051d5e1, indirect dword ptr [eax + 0xc4], ends with jne to 0x00523a26 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 005239ec
    {load} mov ecx, edi                          # 005239ef
    neg eax                                      # 005239f1
    {load} sbb eax, eax                          # 005239f3
    and al, -0x40                                # 005239f5
    add eax, 0x80                                # 005239f7
    or al, 0x17                                  # 005239fc
    push eax                                     # 005239fe
    push ebx                                     # 005239ff
    push ebx                                     # 00523a00
    push ebx                                     # 00523a01
    push ebx                                     # 00523a02
    push ebx                                     # 00523a03
    call FUN_0051d5e1                            # 00523a04
    mov eax, dword ptr [edi]                     # 00523a09
    push dword ptr [ebp + arg_c]                 # 00523a0b
    {load} mov ecx, edi                          # 00523a0e
    call dword ptr [eax + field_c4]              # 00523a10
    cmp dword ptr [ebp + arg_c], ebx             # 00523a16
    jne.d8 L_00523a26                            # 00523a19
    # block 0x00523a1b: entered by fall-through of jne at 0x00523a19, 4 instruction(s), calls FUN_00524837, ends with jne to 0x00523a31 (forward)
    {load} mov ecx, edi                          # 00523a1b
    call FUN_00524837                            # 00523a1d
    test eax, eax                                # 00523a22
    jne.d8 L_00523a31                            # 00523a24
L_00523a26:
    # block 0x00523a26: entered by jne at 0x00523a19; fall-through of jne at 0x00523a24, 4 instruction(s), calls indirect dword ptr [eax + 0xc8], falls into the block at 0x00523a31
    mov eax, dword ptr [esi]                     # 00523a26
    push ebx                                     # 00523a28
    {load} mov ecx, esi                          # 00523a29
    call dword ptr [eax + field_c8]              # 00523a2b
L_00523a31:
    # block 0x00523a31: entered by jmp at 0x005239ea; jne at 0x00523a24, 4 instruction(s), calls FUN_00524837, ends with je to 0x00523ab1 (forward)
    {load} mov ecx, edi                          # 00523a31
    call FUN_00524837                            # 00523a33
    test eax, eax                                # 00523a38
    je.d8 L_00523ab1                             # 00523a3a
    # block 0x00523a3c: entered by fall-through of je at 0x00523a3a, 3 instruction(s), ends with je to 0x00523a4d (forward)
    mov ecx, dword ptr [edi + field_70]          # 00523a3c
    {load} cmp ecx, ebx                          # 00523a3f
    je.d8 L_00523a4d                             # 00523a41
    # block 0x00523a43: entered by fall-through of je at 0x00523a41, 3 instruction(s), calls indirect dword ptr [eax + 0xe0], ends with forward jump to 0x00523a55
    mov eax, dword ptr [ecx]                     # 00523a43
    call dword ptr [eax + field_e0]              # 00523a45
    jmp.d8 L_00523a55                            # 00523a4b
L_00523a4d:
    # block 0x00523a4d: entered by je at 0x00523a41, 3 instruction(s), falls into the block at 0x00523a55
    {load} xor eax, eax                          # 00523a4d
    cmp dword ptr [ebp + arg_c], ebx             # 00523a4f
    setne al                                     # 00523a52
L_00523a55:
    # block 0x00523a55: entered by jmp at 0x00523a4b, 2 instruction(s), ends with jne to 0x00523a84 (forward)
    cmp eax, 0x1                                 # 00523a55
    jne.d8 L_00523a84                            # 00523a58
    # block 0x00523a5a: entered by fall-through of jne at 0x00523a58, 2 instruction(s), ends with je to 0x00523aa1 (forward)
    cmp dword ptr [ebp + arg_c], ebx             # 00523a5a
    je.d8 L_00523aa1                             # 00523a5d
    # block 0x00523a5f: entered by fall-through of je at 0x00523a5d, 4 instruction(s), ends with je to 0x00523a79 (forward)
    or dword ptr [esi + field_88], -0x1          # 00523a5f
    cmp dword ptr [ebp + arg_10], ebx            # 00523a66
    lea eax, [esi + field_88]                    # 00523a69
    je.d8 L_00523a79                             # 00523a6f
    # block 0x00523a71: entered by fall-through of je at 0x00523a6f, 2 instruction(s), ends with forward jump to 0x00523aa6
    mov dword ptr [eax], 0x8                     # 00523a71
    jmp.d8 L_00523aa6                            # 00523a77
L_00523a79:
    # block 0x00523a79: entered by je at 0x00523a6f, 1 instruction(s), falls into the block at 0x00523a7b
    push 0x8                                     # 00523a79
L_00523a7b:
    # block 0x00523a7b: entered by jmp at 0x00523a9f, 3 instruction(s), calls FUN_0051d630, ends with forward jump to 0x00523ab1
    {load} mov ecx, esi                          # 00523a7b
    call FUN_0051d630                            # 00523a7d
    jmp.d8 L_00523ab1                            # 00523a82
L_00523a84:
    # block 0x00523a84: entered by jne at 0x00523a58, 2 instruction(s), ends with jne to 0x00523aa1 (forward)
    {load} cmp eax, ebx                          # 00523a84
    jne.d8 L_00523aa1                            # 00523a86
    # block 0x00523a88: entered by fall-through of jne at 0x00523a86, 4 instruction(s), ends with je to 0x00523a9e (forward)
    or dword ptr [esi + field_88], -0x1          # 00523a88
    cmp dword ptr [ebp + arg_10], ebx            # 00523a8f
    lea eax, [esi + field_88]                    # 00523a92
    je.d8 L_00523a9e                             # 00523a98
    # block 0x00523a9a: entered by fall-through of je at 0x00523a98, 2 instruction(s), ends with forward jump to 0x00523ab1
    mov dword ptr [eax], ebx                     # 00523a9a
    jmp.d8 L_00523ab1                            # 00523a9c
L_00523a9e:
    # block 0x00523a9e: entered by je at 0x00523a98, 2 instruction(s), ends with backward jump to 0x00523a7b
    push ebx                                     # 00523a9e
    jmp.d8 L_00523a7b                            # 00523a9f
L_00523aa1:
    # block 0x00523aa1: entered by je at 0x00523a5d; jne at 0x00523a86, 2 instruction(s), ends with jne to 0x00523ab1 (forward)
    cmp dword ptr [ebp + arg_10], ebx            # 00523aa1
    jne.d8 L_00523ab1                            # 00523aa4
L_00523aa6:
    # block 0x00523aa6: entered by jmp at 0x00523a77; fall-through of jne at 0x00523aa4, 4 instruction(s), calls indirect dword ptr [eax + 0xc8], falls into the block at 0x00523ab1
    mov eax, dword ptr [esi]                     # 00523aa6
    push ebx                                     # 00523aa8
    {load} mov ecx, esi                          # 00523aa9
    call dword ptr [eax + field_c8]              # 00523aab
L_00523ab1:
    # block 0x00523ab1: entered by je at 0x00523a3a; jmp at 0x00523a82; jmp at 0x00523a9c; jne at 0x00523aa4, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00523ab1
    pop esi                                      # 00523ab2
    pop ebx                                      # 00523ab3
    pop ebp                                      # 00523ab4
    ret 0xc                                      # 00523ab5

