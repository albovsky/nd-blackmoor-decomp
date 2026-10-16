# FUN_00525b0f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525b0f
# extent:       0x00525b0f-0x00525b86 (119 code bytes)
# span:         0x00525b0f-0x00525b86 (code 119, tables 0, padding 0)
# sha256:       493417eb4535753a9b0722161841a46bf9307ebd837880ceaa3673b0df6373c5
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525b0f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c; [esp + n] stk_c
# callees:      calls FUN_0052570f, FUN_005257a8, KERNEL32.dll!TlsGetValue, FUN_00525917; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0052570f, .text + (0x0052570f - 0x401000)
.set FUN_005257a8, .text + (0x005257a8 - 0x401000)
.set FUN_00525917, .text + (0x00525917 - 0x401000)

.org 0x00525b0f - 0x401000
.globl FUN_00525b0f
FUN_00525b0f:
    # block 0x00525b0f: entry, 5 instruction(s), ends with jne to 0x00525b45 (forward)
    push esi                                     # 00525b0f
    push edi                                     # 00525b10
    {load} mov edi, ecx                          # 00525b11
    cmp dword ptr [edi], 0x0                     # 00525b13
    jne.d8 L_00525b45                            # 00525b16
    # block 0x00525b18: entered by fall-through of jne at 0x00525b16, 3 instruction(s), ends with jne to 0x00525b3e (forward)
    mov ecx, dword ptr [0x63c704]                # 00525b18
    test ecx, ecx                                # 00525b1e
    jne.d8 L_00525b3e                            # 00525b20
    # block 0x00525b22: entered by fall-through of jne at 0x00525b20, 4 instruction(s), ends with je to 0x00525b36 (forward)
    mov ecx, 0x63c708                            # 00525b22
    {load} mov eax, ecx                          # 00525b27
    test eax, eax                                # 00525b29
    je.d8 L_00525b36                             # 00525b2b
    # block 0x00525b2d: entered by fall-through of je at 0x00525b2b, 3 instruction(s), calls FUN_0052570f, ends with forward jump to 0x00525b38
    call FUN_0052570f                            # 00525b2d
    {load} mov ecx, eax                          # 00525b32
    jmp.d8 L_00525b38                            # 00525b34
L_00525b36:
    # block 0x00525b36: entered by je at 0x00525b2b, 1 instruction(s), falls into the block at 0x00525b38
    {load} xor ecx, ecx                          # 00525b36
L_00525b38:
    # block 0x00525b38: entered by jmp at 0x00525b34, 1 instruction(s), falls into the block at 0x00525b3e
    mov dword ptr [0x63c704], ecx                # 00525b38
L_00525b3e:
    # block 0x00525b3e: entered by jne at 0x00525b20, 2 instruction(s), calls FUN_005257a8, falls into the block at 0x00525b45
    call FUN_005257a8                            # 00525b3e
    mov dword ptr [edi], eax                     # 00525b43
L_00525b45:
    # block 0x00525b45: entered by jne at 0x00525b16, 6 instruction(s), calls KERNEL32.dll!TlsGetValue, ends with je to 0x00525b65 (forward)
    mov eax, dword ptr [0x63c704]                # 00525b45
    mov esi, dword ptr [edi]                     # 00525b4a
    push dword ptr [eax]                         # 00525b4c
    call dword ptr [0x52a0dc]                    # 00525b4e
    test eax, eax                                # 00525b54
    je.d8 L_00525b65                             # 00525b56
    # block 0x00525b58: entered by fall-through of je at 0x00525b56, 2 instruction(s), ends with jge to 0x00525b65 (forward)
    cmp esi, dword ptr [eax + field_8]           # 00525b58
    jge.d8 L_00525b65                            # 00525b5b
    # block 0x00525b5d: entered by fall-through of jge at 0x00525b5b, 3 instruction(s), ends with forward jump to 0x00525b67
    mov eax, dword ptr [eax + field_c]           # 00525b5d
    mov esi, dword ptr [eax + 4*esi]             # 00525b60
    jmp.d8 L_00525b67                            # 00525b63
L_00525b65:
    # block 0x00525b65: entered by je at 0x00525b56; jge at 0x00525b5b, 1 instruction(s), falls into the block at 0x00525b67
    {load} xor esi, esi                          # 00525b65
L_00525b67:
    # block 0x00525b67: entered by jmp at 0x00525b63, 2 instruction(s), ends with jne to 0x00525b7f (forward)
    test esi, esi                                # 00525b67
    jne.d8 L_00525b7f                            # 00525b69
    # block 0x00525b6b: entered by fall-through of jne at 0x00525b69, 6 instruction(s), calls indirect dword ptr [esp + 0xc], FUN_00525917, falls into the block at 0x00525b7f
    call dword ptr [esp + stk_c]                 # 00525b6b
    mov ecx, dword ptr [0x63c704]                # 00525b6f
    {load} mov esi, eax                          # 00525b75
    push esi                                     # 00525b77
    push dword ptr [edi]                         # 00525b78
    call FUN_00525917                            # 00525b7a
L_00525b7f:
    # block 0x00525b7f: entered by jne at 0x00525b69, 4 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00525b7f
    pop edi                                      # 00525b81
    pop esi                                      # 00525b82
    ret 0x4                                      # 00525b83

