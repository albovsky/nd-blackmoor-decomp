# FUN_00514a77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514a77
# extent:       0x00514a77-0x00514c2b (436 code bytes)
# span:         0x00514a77-0x00514c2b (code 436, tables 0, padding 0)
# sha256:       ff48158e762f8f731303d0beaf90d86652a6f986a1327a51f52255c4835bcd36
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514a77
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_1; [esi + n] field_minus_1
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 187 instruction(s), 40 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x00514a77 - 0x401000
.globl FUN_00514a77
FUN_00514a77:
    # block 0x00514a77: entry, 14 instruction(s), ends with je to 0x00514aa1 (forward)
    push ebp                                     # 00514a77
    {load} mov ebp, esp                          # 00514a78
    mov ecx, dword ptr [ebp + arg_18]            # 00514a7a
    mov eax, dword ptr [ebp + arg_14]            # 00514a7d
    push ebx                                     # 00514a80
    push esi                                     # 00514a81
    and dword ptr [ecx], 0x0                     # 00514a82
    mov esi, dword ptr [ebp + arg_10]            # 00514a85
    push edi                                     # 00514a88
    mov edi, dword ptr [ebp + arg_c]             # 00514a89
    mov dword ptr [eax], 0x1                     # 00514a8c
    mov eax, dword ptr [ebp + arg_8]             # 00514a92
    test edi, edi                                # 00514a95
    je.d8 L_00514aa1                             # 00514a97
    # block 0x00514a99: entered by fall-through of je at 0x00514a97, 3 instruction(s), falls into the block at 0x00514aa1
    mov dword ptr [edi], esi                     # 00514a99
    add edi, 0x4                                 # 00514a9b
    mov dword ptr [ebp + arg_c], edi             # 00514a9e
L_00514aa1:
    # block 0x00514aa1: entered by je at 0x00514a97, 2 instruction(s), ends with jne to 0x00514aea (forward)
    cmp byte ptr [eax], 0x22                     # 00514aa1
    jne.d8 L_00514aea                            # 00514aa4
L_00514aa6:
    # block 0x00514aa6: entered by je at 0x00514acf; jmp at 0x00514ad6; fall-through of jne at 0x00514aa4, 4 instruction(s), ends with je to 0x00514ad8 (forward)
    mov dl, byte ptr [eax + field_1]             # 00514aa6
    inc eax                                      # 00514aa9
    cmp dl, 0x22                                 # 00514aaa
    je.d8 L_00514ad8                             # 00514aad
    # block 0x00514aaf: entered by fall-through of je at 0x00514aad, 2 instruction(s), ends with je to 0x00514ad8 (forward)
    test dl, dl                                  # 00514aaf
    je.d8 L_00514ad8                             # 00514ab1
    # block 0x00514ab3: entered by fall-through of je at 0x00514ab1, 3 instruction(s), ends with je to 0x00514acb (forward)
    movzx edx, dl                                # 00514ab3
    test byte ptr [edx + 0x63e021], 0x4          # 00514ab6
    je.d8 L_00514acb                             # 00514abd
    # block 0x00514abf: entered by fall-through of je at 0x00514abd, 3 instruction(s), ends with je to 0x00514acb (forward)
    inc dword ptr [ecx]                          # 00514abf
    test esi, esi                                # 00514ac1
    je.d8 L_00514acb                             # 00514ac3
    # block 0x00514ac5: entered by fall-through of je at 0x00514ac3, 4 instruction(s), falls into the block at 0x00514acb
    mov dl, byte ptr [eax]                       # 00514ac5
    mov byte ptr [esi], dl                       # 00514ac7
    inc esi                                      # 00514ac9
    inc eax                                      # 00514aca
L_00514acb:
    # block 0x00514acb: entered by je at 0x00514abd; je at 0x00514ac3, 3 instruction(s), ends with je to 0x00514aa6 (backward)
    inc dword ptr [ecx]                          # 00514acb
    test esi, esi                                # 00514acd
    je.d8 L_00514aa6                             # 00514acf
    # block 0x00514ad1: entered by fall-through of je at 0x00514acf, 4 instruction(s), ends with backward jump to 0x00514aa6
    mov dl, byte ptr [eax]                       # 00514ad1
    mov byte ptr [esi], dl                       # 00514ad3
    inc esi                                      # 00514ad5
    jmp.d8 L_00514aa6                            # 00514ad6
L_00514ad8:
    # block 0x00514ad8: entered by je at 0x00514aad; je at 0x00514ab1, 3 instruction(s), ends with je to 0x00514ae2 (forward)
    inc dword ptr [ecx]                          # 00514ad8
    test esi, esi                                # 00514ada
    je.d8 L_00514ae2                             # 00514adc
    # block 0x00514ade: entered by fall-through of je at 0x00514adc, 2 instruction(s), falls into the block at 0x00514ae2
    and byte ptr [esi], 0x0                      # 00514ade
    inc esi                                      # 00514ae1
L_00514ae2:
    # block 0x00514ae2: entered by je at 0x00514adc, 2 instruction(s), ends with jne to 0x00514b2d (forward)
    cmp byte ptr [eax], 0x22                     # 00514ae2
    jne.d8 L_00514b2d                            # 00514ae5
    # block 0x00514ae7: entered by fall-through of jne at 0x00514ae5, 2 instruction(s), ends with forward jump to 0x00514b2d
    inc eax                                      # 00514ae7
    jmp.d8 L_00514b2d                            # 00514ae8
L_00514aea:
    # block 0x00514aea: entered by jne at 0x00514aa4; jne at 0x00514b1c, 3 instruction(s), ends with je to 0x00514af5 (forward)
    inc dword ptr [ecx]                          # 00514aea
    test esi, esi                                # 00514aec
    je.d8 L_00514af5                             # 00514aee
    # block 0x00514af0: entered by fall-through of je at 0x00514aee, 3 instruction(s), falls into the block at 0x00514af5
    mov dl, byte ptr [eax]                       # 00514af0
    mov byte ptr [esi], dl                       # 00514af2
    inc esi                                      # 00514af4
L_00514af5:
    # block 0x00514af5: entered by je at 0x00514aee, 5 instruction(s), ends with je to 0x00514b10 (forward)
    mov dl, byte ptr [eax]                       # 00514af5
    inc eax                                      # 00514af7
    movzx ebx, dl                                # 00514af8
    test byte ptr [ebx + 0x63e021], 0x4          # 00514afb
    je.d8 L_00514b10                             # 00514b02
    # block 0x00514b04: entered by fall-through of je at 0x00514b02, 3 instruction(s), ends with je to 0x00514b0f (forward)
    inc dword ptr [ecx]                          # 00514b04
    test esi, esi                                # 00514b06
    je.d8 L_00514b0f                             # 00514b08
    # block 0x00514b0a: entered by fall-through of je at 0x00514b08, 3 instruction(s), falls into the block at 0x00514b0f
    mov bl, byte ptr [eax]                       # 00514b0a
    mov byte ptr [esi], bl                       # 00514b0c
    inc esi                                      # 00514b0e
L_00514b0f:
    # block 0x00514b0f: entered by je at 0x00514b08, 1 instruction(s), falls into the block at 0x00514b10
    inc eax                                      # 00514b0f
L_00514b10:
    # block 0x00514b10: entered by je at 0x00514b02, 2 instruction(s), ends with je to 0x00514b1e (forward)
    cmp dl, 0x20                                 # 00514b10
    je.d8 L_00514b1e                             # 00514b13
    # block 0x00514b15: entered by fall-through of je at 0x00514b13, 2 instruction(s), ends with je to 0x00514b22 (forward)
    test dl, dl                                  # 00514b15
    je.d8 L_00514b22                             # 00514b17
    # block 0x00514b19: entered by fall-through of je at 0x00514b17, 2 instruction(s), ends with jne to 0x00514aea (backward)
    cmp dl, 0x9                                  # 00514b19
    jne.d8 L_00514aea                            # 00514b1c
L_00514b1e:
    # block 0x00514b1e: entered by je at 0x00514b13; fall-through of jne at 0x00514b1c, 2 instruction(s), ends with jne to 0x00514b25 (forward)
    test dl, dl                                  # 00514b1e
    jne.d8 L_00514b25                            # 00514b20
L_00514b22:
    # block 0x00514b22: entered by je at 0x00514b17; fall-through of jne at 0x00514b20, 2 instruction(s), ends with forward jump to 0x00514b2d
    dec eax                                      # 00514b22
    jmp.d8 L_00514b2d                            # 00514b23
L_00514b25:
    # block 0x00514b25: entered by jne at 0x00514b20, 2 instruction(s), ends with je to 0x00514b2d (forward)
    test esi, esi                                # 00514b25
    je.d8 L_00514b2d                             # 00514b27
    # block 0x00514b29: entered by fall-through of je at 0x00514b27, 1 instruction(s), falls into the block at 0x00514b2d
    and byte ptr [esi - field_minus_1], 0x0      # 00514b29
L_00514b2d:
    # block 0x00514b2d: entered by jne at 0x00514ae5; jmp at 0x00514ae8; jmp at 0x00514b23; je at 0x00514b27, 1 instruction(s), falls into the block at 0x00514b31
    and dword ptr [ebp + arg_18], 0x0            # 00514b2d
L_00514b31:
    # block 0x00514b31: entered by jmp at 0x00514c15, 2 instruction(s), ends with je to 0x00514c1a (forward)
    cmp byte ptr [eax], 0x0                      # 00514b31
    je.d32 L_00514c1a                            # 00514b34
L_00514b3a:
    # block 0x00514b3a: entered by jmp at 0x00514b47; fall-through of je at 0x00514b34, 3 instruction(s), ends with je to 0x00514b46 (forward)
    mov dl, byte ptr [eax]                       # 00514b3a
    cmp dl, 0x20                                 # 00514b3c
    je.d8 L_00514b46                             # 00514b3f
    # block 0x00514b41: entered by fall-through of je at 0x00514b3f, 2 instruction(s), ends with jne to 0x00514b49 (forward)
    cmp dl, 0x9                                  # 00514b41
    jne.d8 L_00514b49                            # 00514b44
L_00514b46:
    # block 0x00514b46: entered by je at 0x00514b3f; fall-through of jne at 0x00514b44, 2 instruction(s), ends with backward jump to 0x00514b3a
    inc eax                                      # 00514b46
    jmp.d8 L_00514b3a                            # 00514b47
L_00514b49:
    # block 0x00514b49: entered by jne at 0x00514b44, 2 instruction(s), ends with je to 0x00514c1a (forward)
    cmp byte ptr [eax], 0x0                      # 00514b49
    je.d32 L_00514c1a                            # 00514b4c
    # block 0x00514b52: entered by fall-through of je at 0x00514b4c, 2 instruction(s), ends with je to 0x00514b5e (forward)
    test edi, edi                                # 00514b52
    je.d8 L_00514b5e                             # 00514b54
    # block 0x00514b56: entered by fall-through of je at 0x00514b54, 3 instruction(s), falls into the block at 0x00514b5e
    mov dword ptr [edi], esi                     # 00514b56
    add edi, 0x4                                 # 00514b58
    mov dword ptr [ebp + arg_c], edi             # 00514b5b
L_00514b5e:
    # block 0x00514b5e: entered by je at 0x00514b54, 2 instruction(s), falls into the block at 0x00514b63
    mov edx, dword ptr [ebp + arg_14]            # 00514b5e
    inc dword ptr [edx]                          # 00514b61
L_00514b63:
    # block 0x00514b63: entered by jmp at 0x00514c06, 2 instruction(s), falls into the block at 0x00514b6c
    mov dword ptr [ebp + arg_8], 0x1             # 00514b63
    {load} xor ebx, ebx                          # 00514b6a
L_00514b6c:
    # block 0x00514b6c: entered by jmp at 0x00514b73, 2 instruction(s), ends with jne to 0x00514b75 (forward)
    cmp byte ptr [eax], 0x5c                     # 00514b6c
    jne.d8 L_00514b75                            # 00514b6f
    # block 0x00514b71: entered by fall-through of jne at 0x00514b6f, 3 instruction(s), ends with backward jump to 0x00514b6c
    inc eax                                      # 00514b71
    inc ebx                                      # 00514b72
    jmp.d8 L_00514b6c                            # 00514b73
L_00514b75:
    # block 0x00514b75: entered by jne at 0x00514b6f, 2 instruction(s), ends with jne to 0x00514ba6 (forward)
    cmp byte ptr [eax], 0x22                     # 00514b75
    jne.d8 L_00514ba6                            # 00514b78
    # block 0x00514b7a: entered by fall-through of jne at 0x00514b78, 2 instruction(s), ends with jne to 0x00514ba4 (forward)
    test bl, 0x1                                 # 00514b7a
    jne.d8 L_00514ba4                            # 00514b7d
    # block 0x00514b7f: entered by fall-through of jne at 0x00514b7d, 3 instruction(s), ends with je to 0x00514b93 (forward)
    {load} xor edi, edi                          # 00514b7f
    cmp dword ptr [ebp + arg_18], edi            # 00514b81
    je.d8 L_00514b93                             # 00514b84
    # block 0x00514b86: entered by fall-through of je at 0x00514b84, 3 instruction(s), ends with jne to 0x00514b93 (forward)
    cmp byte ptr [eax + field_1], 0x22           # 00514b86
    lea edx, [eax + field_1]                     # 00514b8a
    jne.d8 L_00514b93                            # 00514b8d
    # block 0x00514b8f: entered by fall-through of jne at 0x00514b8d, 2 instruction(s), ends with forward jump to 0x00514b96
    {load} mov eax, edx                          # 00514b8f
    jmp.d8 L_00514b96                            # 00514b91
L_00514b93:
    # block 0x00514b93: entered by je at 0x00514b84; jne at 0x00514b8d, 1 instruction(s), falls into the block at 0x00514b96
    mov dword ptr [ebp + arg_8], edi             # 00514b93
L_00514b96:
    # block 0x00514b96: entered by jmp at 0x00514b91, 5 instruction(s), falls into the block at 0x00514ba4
    mov edi, dword ptr [ebp + arg_c]             # 00514b96
    {load} xor edx, edx                          # 00514b99
    cmp dword ptr [ebp + arg_18], edx            # 00514b9b
    sete dl                                      # 00514b9e
    mov dword ptr [ebp + arg_18], edx            # 00514ba1
L_00514ba4:
    # block 0x00514ba4: entered by jne at 0x00514b7d, 1 instruction(s), falls into the block at 0x00514ba6
    shr ebx                                      # 00514ba4
L_00514ba6:
    # block 0x00514ba6: entered by jne at 0x00514b78, 4 instruction(s), ends with je to 0x00514bbb (forward)
    {load} mov edx, ebx                          # 00514ba6
    dec ebx                                      # 00514ba8
    test edx, edx                                # 00514ba9
    je.d8 L_00514bbb                             # 00514bab
    # block 0x00514bad: entered by fall-through of je at 0x00514bab, 1 instruction(s), falls into the block at 0x00514bae
    inc ebx                                      # 00514bad
L_00514bae:
    # block 0x00514bae: entered by jne at 0x00514bb9, 2 instruction(s), ends with je to 0x00514bb6 (forward)
    test esi, esi                                # 00514bae
    je.d8 L_00514bb6                             # 00514bb0
    # block 0x00514bb2: entered by fall-through of je at 0x00514bb0, 2 instruction(s), falls into the block at 0x00514bb6
    mov byte ptr [esi], 0x5c                     # 00514bb2
    inc esi                                      # 00514bb5
L_00514bb6:
    # block 0x00514bb6: entered by je at 0x00514bb0, 3 instruction(s), ends with jne to 0x00514bae (backward)
    inc dword ptr [ecx]                          # 00514bb6
    dec ebx                                      # 00514bb8
    jne.d8 L_00514bae                            # 00514bb9
L_00514bbb:
    # block 0x00514bbb: entered by je at 0x00514bab; fall-through of jne at 0x00514bb9, 3 instruction(s), ends with je to 0x00514c0b (forward)
    mov dl, byte ptr [eax]                       # 00514bbb
    test dl, dl                                  # 00514bbd
    je.d8 L_00514c0b                             # 00514bbf
    # block 0x00514bc1: entered by fall-through of je at 0x00514bbf, 2 instruction(s), ends with jne to 0x00514bd1 (forward)
    cmp dword ptr [ebp + arg_18], 0x0            # 00514bc1
    jne.d8 L_00514bd1                            # 00514bc5
    # block 0x00514bc7: entered by fall-through of jne at 0x00514bc5, 2 instruction(s), ends with je to 0x00514c0b (forward)
    cmp dl, 0x20                                 # 00514bc7
    je.d8 L_00514c0b                             # 00514bca
    # block 0x00514bcc: entered by fall-through of je at 0x00514bca, 2 instruction(s), ends with je to 0x00514c0b (forward)
    cmp dl, 0x9                                  # 00514bcc
    je.d8 L_00514c0b                             # 00514bcf
L_00514bd1:
    # block 0x00514bd1: entered by jne at 0x00514bc5; fall-through of je at 0x00514bcf, 2 instruction(s), ends with je to 0x00514c05 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 00514bd1
    je.d8 L_00514c05                             # 00514bd5
    # block 0x00514bd7: entered by fall-through of je at 0x00514bd5, 2 instruction(s), ends with je to 0x00514bf4 (forward)
    test esi, esi                                # 00514bd7
    je.d8 L_00514bf4                             # 00514bd9
    # block 0x00514bdb: entered by fall-through of je at 0x00514bd9, 3 instruction(s), ends with je to 0x00514bed (forward)
    movzx ebx, dl                                # 00514bdb
    test byte ptr [ebx + 0x63e021], 0x4          # 00514bde
    je.d8 L_00514bed                             # 00514be5
    # block 0x00514be7: entered by fall-through of je at 0x00514be5, 4 instruction(s), falls into the block at 0x00514bed
    mov byte ptr [esi], dl                       # 00514be7
    inc esi                                      # 00514be9
    inc eax                                      # 00514bea
    inc dword ptr [ecx]                          # 00514beb
L_00514bed:
    # block 0x00514bed: entered by je at 0x00514be5, 4 instruction(s), ends with forward jump to 0x00514c03
    mov dl, byte ptr [eax]                       # 00514bed
    mov byte ptr [esi], dl                       # 00514bef
    inc esi                                      # 00514bf1
    jmp.d8 L_00514c03                            # 00514bf2
L_00514bf4:
    # block 0x00514bf4: entered by je at 0x00514bd9, 3 instruction(s), ends with je to 0x00514c03 (forward)
    movzx edx, dl                                # 00514bf4
    test byte ptr [edx + 0x63e021], 0x4          # 00514bf7
    je.d8 L_00514c03                             # 00514bfe
    # block 0x00514c00: entered by fall-through of je at 0x00514bfe, 2 instruction(s), falls into the block at 0x00514c03
    inc eax                                      # 00514c00
    inc dword ptr [ecx]                          # 00514c01
L_00514c03:
    # block 0x00514c03: entered by jmp at 0x00514bf2; je at 0x00514bfe, 1 instruction(s), falls into the block at 0x00514c05
    inc dword ptr [ecx]                          # 00514c03
L_00514c05:
    # block 0x00514c05: entered by je at 0x00514bd5, 2 instruction(s), ends with backward jump to 0x00514b63
    inc eax                                      # 00514c05
    jmp.d32 L_00514b63                           # 00514c06
L_00514c0b:
    # block 0x00514c0b: entered by je at 0x00514bbf; je at 0x00514bca; je at 0x00514bcf, 2 instruction(s), ends with je to 0x00514c13 (forward)
    test esi, esi                                # 00514c0b
    je.d8 L_00514c13                             # 00514c0d
    # block 0x00514c0f: entered by fall-through of je at 0x00514c0d, 2 instruction(s), falls into the block at 0x00514c13
    and byte ptr [esi], 0x0                      # 00514c0f
    inc esi                                      # 00514c12
L_00514c13:
    # block 0x00514c13: entered by je at 0x00514c0d, 2 instruction(s), ends with backward jump to 0x00514b31
    inc dword ptr [ecx]                          # 00514c13
    jmp.d32 L_00514b31                           # 00514c15
L_00514c1a:
    # block 0x00514c1a: entered by je at 0x00514b34; je at 0x00514b4c, 2 instruction(s), ends with je to 0x00514c21 (forward)
    test edi, edi                                # 00514c1a
    je.d8 L_00514c21                             # 00514c1c
    # block 0x00514c1e: entered by fall-through of je at 0x00514c1c, 1 instruction(s), falls into the block at 0x00514c21
    and dword ptr [edi], 0x0                     # 00514c1e
L_00514c21:
    # block 0x00514c21: entered by je at 0x00514c1c, 7 instruction(s), ends with ret
    mov eax, dword ptr [ebp + arg_14]            # 00514c21
    pop edi                                      # 00514c24
    pop esi                                      # 00514c25
    pop ebx                                      # 00514c26
    inc dword ptr [eax]                          # 00514c27
    pop ebp                                      # 00514c29
    ret                                          # 00514c2a

