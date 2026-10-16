# FUN_005168d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005168d0
# extent:       0x005168d0-0x00516962 (146 code bytes)
# span:         0x005168d0-0x00516962 (code 146, tables 0, padding 0)
# sha256:       fdeb0fc605fa7e2d5dd1168f0df34b3c51cac17b5476138059aeeb7e1250f616
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005168d0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x005168d0 - 0x401000
.globl FUN_005168d0
FUN_005168d0:
    # block 0x005168d0: entry, 7 instruction(s), ends with je to 0x005168e1 (forward)
    push ebx                                     # 005168d0
    mov ebx, dword ptr [esp + stk_8]             # 005168d1
    {load} xor eax, eax                          # 005168d5
    push ebp                                     # 005168d7
    test bl, 0x1                                 # 005168d8
    push edi                                     # 005168db
    je.d8 L_005168e1                             # 005168dc
    # block 0x005168de: entered by fall-through of je at 0x005168dc, 2 instruction(s), falls into the block at 0x005168e1
    push 0x10                                    # 005168de
    pop eax                                      # 005168e0
L_005168e1:
    # block 0x005168e1: entered by je at 0x005168dc, 2 instruction(s), ends with je to 0x005168e8 (forward)
    test bl, 0x4                                 # 005168e1
    je.d8 L_005168e8                             # 005168e4
    # block 0x005168e6: entered by fall-through of je at 0x005168e4, 1 instruction(s), falls into the block at 0x005168e8
    or al, 0x8                                   # 005168e6
L_005168e8:
    # block 0x005168e8: entered by je at 0x005168e4, 2 instruction(s), ends with je to 0x005168ef (forward)
    test bl, 0x8                                 # 005168e8
    je.d8 L_005168ef                             # 005168eb
    # block 0x005168ed: entered by fall-through of je at 0x005168eb, 1 instruction(s), falls into the block at 0x005168ef
    or al, 0x4                                   # 005168ed
L_005168ef:
    # block 0x005168ef: entered by je at 0x005168eb, 2 instruction(s), ends with je to 0x005168f6 (forward)
    test bl, 0x10                                # 005168ef
    je.d8 L_005168f6                             # 005168f2
    # block 0x005168f4: entered by fall-through of je at 0x005168f2, 1 instruction(s), falls into the block at 0x005168f6
    or al, 0x2                                   # 005168f4
L_005168f6:
    # block 0x005168f6: entered by je at 0x005168f2, 2 instruction(s), ends with je to 0x005168fd (forward)
    test bl, 0x20                                # 005168f6
    je.d8 L_005168fd                             # 005168f9
    # block 0x005168fb: entered by fall-through of je at 0x005168f9, 1 instruction(s), falls into the block at 0x005168fd
    or al, 0x1                                   # 005168fb
L_005168fd:
    # block 0x005168fd: entered by je at 0x005168f9, 2 instruction(s), ends with je to 0x00516907 (forward)
    test bl, 0x2                                 # 005168fd
    je.d8 L_00516907                             # 00516900
    # block 0x00516902: entered by fall-through of je at 0x00516900, 1 instruction(s), falls into the block at 0x00516907
    or eax, 0x80000                              # 00516902
L_00516907:
    # block 0x00516907: entered by je at 0x00516900, 8 instruction(s), ends with je to 0x0051693f (forward)
    movzx ecx, bx                                # 00516907
    push esi                                     # 0051690a
    {load} mov edx, ecx                          # 0051690b
    mov esi, 0xc00                               # 0051690d
    mov edi, 0x300                               # 00516912
    {load} and edx, esi                          # 00516917
    mov ebp, 0x200                               # 00516919
    je.d8 L_0051693f                             # 0051691e
    # block 0x00516920: entered by fall-through of je at 0x0051691e, 2 instruction(s), ends with je to 0x0051693c (forward)
    cmp edx, 0x400                               # 00516920
    je.d8 L_0051693c                             # 00516926
    # block 0x00516928: entered by fall-through of je at 0x00516926, 2 instruction(s), ends with je to 0x00516938 (forward)
    cmp edx, 0x800                               # 00516928
    je.d8 L_00516938                             # 0051692e
    # block 0x00516930: entered by fall-through of je at 0x0051692e, 2 instruction(s), ends with jne to 0x0051693f (forward)
    {load} cmp edx, esi                          # 00516930
    jne.d8 L_0051693f                            # 00516932
    # block 0x00516934: entered by fall-through of jne at 0x00516932, 2 instruction(s), ends with forward jump to 0x0051693f
    {load} or eax, edi                           # 00516934
    jmp.d8 L_0051693f                            # 00516936
L_00516938:
    # block 0x00516938: entered by je at 0x0051692e, 2 instruction(s), ends with forward jump to 0x0051693f
    {load} or eax, ebp                           # 00516938
    jmp.d8 L_0051693f                            # 0051693a
L_0051693c:
    # block 0x0051693c: entered by je at 0x00516926, 1 instruction(s), falls into the block at 0x0051693f
    or ah, 0x1                                   # 0051693c
L_0051693f:
    # block 0x0051693f: entered by je at 0x0051691e; jne at 0x00516932; jmp at 0x00516936; jmp at 0x0051693a, 3 instruction(s), ends with je to 0x0051694f (forward)
    {load} and ecx, edi                          # 0051693f
    pop esi                                      # 00516941
    je.d8 L_0051694f                             # 00516942
    # block 0x00516944: entered by fall-through of je at 0x00516942, 2 instruction(s), ends with jne to 0x00516954 (forward)
    {load} cmp ecx, ebp                          # 00516944
    jne.d8 L_00516954                            # 00516946
    # block 0x00516948: entered by fall-through of jne at 0x00516946, 2 instruction(s), ends with forward jump to 0x00516954
    or eax, 0x10000                              # 00516948
    jmp.d8 L_00516954                            # 0051694d
L_0051694f:
    # block 0x0051694f: entered by je at 0x00516942, 1 instruction(s), falls into the block at 0x00516954
    or eax, 0x20000                              # 0051694f
L_00516954:
    # block 0x00516954: entered by jne at 0x00516946; jmp at 0x0051694d, 5 instruction(s), ends with je to 0x00516961 (forward)
    pop edi                                      # 00516954
    pop ebp                                      # 00516955
    test bh, 0x10                                # 00516956
    pop ebx                                      # 00516959
    je.d8 L_00516961                             # 0051695a
    # block 0x0051695c: entered by fall-through of je at 0x0051695a, 1 instruction(s), falls into the block at 0x00516961
    or eax, 0x40000                              # 0051695c
L_00516961:
    # block 0x00516961: entered by je at 0x0051695a, 1 instruction(s), ends with ret
    ret                                          # 00516961

