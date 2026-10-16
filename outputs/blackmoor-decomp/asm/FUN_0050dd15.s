# FUN_0050dd15
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050dd15
# extent:       0x0050dd15-0x0050ddb9 (164 code bytes)
# span:         0x0050dd15-0x0050ddb9 (code 164, tables 0, padding 0)
# sha256:       d21a378a01a4459417352a5095f70fddd2292ed80d2a2e0872d62509326aff8f
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050dd15
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [esp + n] stk_10, stk_14
# callees:      calls FUN_00512c18, FUN_00512103, FUN_0050dc82, FUN_00512155, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 66 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050dc82, .text + (0x0050dc82 - 0x401000)
.set FUN_00512103, .text + (0x00512103 - 0x401000)
.set FUN_00512155, .text + (0x00512155 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x0050dd15 - 0x401000
.globl FUN_0050dd15
FUN_0050dd15:
    # block 0x0050dd15: entry, 11 instruction(s), calls FUN_00512c18, ends with jle to 0x0050dda2 (forward)
    push ebx                                     # 0050dd15
    push esi                                     # 0050dd16
    push edi                                     # 0050dd17
    push 0x2                                     # 0050dd18
    {load} xor ebx, ebx                          # 0050dd1a
    {load} xor edi, edi                          # 0050dd1c
    call FUN_00512c18                            # 0050dd1e
    {load} xor esi, esi                          # 0050dd23
    pop ecx                                      # 0050dd25
    cmp dword ptr [0x63df00], esi                # 0050dd26
    jle.d8 L_0050dda2                            # 0050dd2c
L_0050dd2e:
    # block 0x0050dd2e: entered by jl at 0x0050dda0; fall-through of jle at 0x0050dd2c, 4 instruction(s), ends with je to 0x0050dd99 (forward)
    mov eax, dword ptr [0x63ceec]                # 0050dd2e
    mov eax, dword ptr [eax + 4*esi]             # 0050dd33
    test eax, eax                                # 0050dd36
    je.d8 L_0050dd99                             # 0050dd38
    # block 0x0050dd3a: entered by fall-through of je at 0x0050dd38, 2 instruction(s), ends with je to 0x0050dd99 (forward)
    test byte ptr [eax + field_c], -0x7d         # 0050dd3a
    je.d8 L_0050dd99                             # 0050dd3e
    # block 0x0050dd40: entered by fall-through of je at 0x0050dd3e, 10 instruction(s), calls FUN_00512103, ends with je to 0x0050dd89 (forward)
    push eax                                     # 0050dd40
    push esi                                     # 0050dd41
    call FUN_00512103                            # 0050dd42
    mov eax, dword ptr [0x63ceec]                # 0050dd47
    pop ecx                                      # 0050dd4c
    pop ecx                                      # 0050dd4d
    mov eax, dword ptr [eax + 4*esi]             # 0050dd4e
    mov ecx, dword ptr [eax + field_c]           # 0050dd51
    test cl, -0x7d                               # 0050dd54
    je.d8 L_0050dd89                             # 0050dd57
    # block 0x0050dd59: entered by fall-through of je at 0x0050dd57, 2 instruction(s), ends with jne to 0x0050dd6f (forward)
    cmp dword ptr [esp + stk_10], 0x1            # 0050dd59
    jne.d8 L_0050dd6f                            # 0050dd5e
    # block 0x0050dd60: entered by fall-through of jne at 0x0050dd5e, 5 instruction(s), calls FUN_0050dc82, ends with je to 0x0050dd89 (forward)
    push eax                                     # 0050dd60
    call FUN_0050dc82                            # 0050dd61
    cmp eax, -0x1                                # 0050dd66
    pop ecx                                      # 0050dd69
    je.d8 L_0050dd89                             # 0050dd6a
    # block 0x0050dd6c: entered by fall-through of je at 0x0050dd6a, 2 instruction(s), ends with forward jump to 0x0050dd89
    inc ebx                                      # 0050dd6c
    jmp.d8 L_0050dd89                            # 0050dd6d
L_0050dd6f:
    # block 0x0050dd6f: entered by jne at 0x0050dd5e, 2 instruction(s), ends with jne to 0x0050dd89 (forward)
    cmp dword ptr [esp + stk_10], 0x0            # 0050dd6f
    jne.d8 L_0050dd89                            # 0050dd74
    # block 0x0050dd76: entered by fall-through of jne at 0x0050dd74, 2 instruction(s), ends with je to 0x0050dd89 (forward)
    test cl, 0x2                                 # 0050dd76
    je.d8 L_0050dd89                             # 0050dd79
    # block 0x0050dd7b: entered by fall-through of je at 0x0050dd79, 5 instruction(s), calls FUN_0050dc82, ends with jne to 0x0050dd89 (forward)
    push eax                                     # 0050dd7b
    call FUN_0050dc82                            # 0050dd7c
    cmp eax, -0x1                                # 0050dd81
    pop ecx                                      # 0050dd84
    jne.d8 L_0050dd89                            # 0050dd85
    # block 0x0050dd87: entered by fall-through of jne at 0x0050dd85, 1 instruction(s), falls into the block at 0x0050dd89
    {load} or edi, eax                           # 0050dd87
L_0050dd89:
    # block 0x0050dd89: entered by je at 0x0050dd57; je at 0x0050dd6a; jmp at 0x0050dd6d; jne at 0x0050dd74; more, 6 instruction(s), calls FUN_00512155, falls into the block at 0x0050dd99
    mov eax, dword ptr [0x63ceec]                # 0050dd89
    push dword ptr [eax + 4*esi]                 # 0050dd8e
    push esi                                     # 0050dd91
    call FUN_00512155                            # 0050dd92
    pop ecx                                      # 0050dd97
    pop ecx                                      # 0050dd98
L_0050dd99:
    # block 0x0050dd99: entered by je at 0x0050dd38; je at 0x0050dd3e, 3 instruction(s), ends with jl to 0x0050dd2e (backward)
    inc esi                                      # 0050dd99
    cmp esi, dword ptr [0x63df00]                # 0050dd9a
    jl.d8 L_0050dd2e                             # 0050dda0
L_0050dda2:
    # block 0x0050dda2: entered by jle at 0x0050dd2c; fall-through of jl at 0x0050dda0, 6 instruction(s), calls FUN_00512c79, ends with je to 0x0050ddb5 (forward)
    push 0x2                                     # 0050dda2
    call FUN_00512c79                            # 0050dda4
    cmp dword ptr [esp + stk_14], 0x1            # 0050dda9
    pop ecx                                      # 0050ddae
    {load} mov eax, ebx                          # 0050ddaf
    je.d8 L_0050ddb5                             # 0050ddb1
    # block 0x0050ddb3: entered by fall-through of je at 0x0050ddb1, 1 instruction(s), falls into the block at 0x0050ddb5
    {load} mov eax, edi                          # 0050ddb3
L_0050ddb5:
    # block 0x0050ddb5: entered by je at 0x0050ddb1, 4 instruction(s), ends with ret
    pop edi                                      # 0050ddb5
    pop esi                                      # 0050ddb6
    pop ebx                                      # 0050ddb7
    ret                                          # 0050ddb8

