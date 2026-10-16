# FUN_0051b593
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b593
# extent:       0x0051b593-0x0051b5d0 (61 code bytes)
# span:         0x0051b593-0x0051b5d0 (code 61, tables 0, padding 0)
# sha256:       70aae7d60029c9f9ae7ec14c5f01b3f6b38ffbb6fdd2e97f61be4a9a2e845ade
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b593
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_c; [esi + n] field_14; [esp + n] stk_c
# callees:      calls FUN_0051fa4c, FUN_0051c519, FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c519, .text + (0x0051c519 - 0x401000)
.set FUN_0051fa4c, .text + (0x0051fa4c - 0x401000)

.org 0x0051b593 - 0x401000
.globl FUN_0051b593
FUN_0051b593:
    # block 0x0051b593: entry, 6 instruction(s), ends with jne to 0x0051b5b6 (forward)
    push esi                                     # 0051b593
    mov esi, dword ptr [esp + stk_c]             # 0051b594
    push edi                                     # 0051b598
    {load} mov edi, ecx                          # 0051b599
    cmp dword ptr [esi], 0x1                     # 0051b59b
    jne.d8 L_0051b5b6                            # 0051b59e
    # block 0x0051b5a0: entered by fall-through of jne at 0x0051b59e, 4 instruction(s), calls FUN_0051fa4c, ends with je to 0x0051b5c4 (forward)
    push dword ptr [esi + field_14]              # 0051b5a0
    call FUN_0051fa4c                            # 0051b5a3
    test eax, eax                                # 0051b5a8
    je.d8 L_0051b5c4                             # 0051b5aa
    # block 0x0051b5ac: entered by fall-through of je at 0x0051b5aa, 5 instruction(s), calls indirect dword ptr [edx + 0xc], ends with forward jump to 0x0051b5cb
    mov edx, dword ptr [eax]                     # 0051b5ac
    push esi                                     # 0051b5ae
    {load} mov ecx, eax                          # 0051b5af
    call dword ptr [edx + field_c]               # 0051b5b1
    jmp.d8 L_0051b5cb                            # 0051b5b4
L_0051b5b6:
    # block 0x0051b5b6: entered by jne at 0x0051b59e, 5 instruction(s), calls FUN_0051c519, ends with jne to 0x0051b5cb (forward)
    push 0x0                                     # 0051b5b6
    push dword ptr [esi + field_14]              # 0051b5b8
    call FUN_0051c519                            # 0051b5bb
    test eax, eax                                # 0051b5c0
    jne.d8 L_0051b5cb                            # 0051b5c2
L_0051b5c4:
    # block 0x0051b5c4: entered by je at 0x0051b5aa; fall-through of jne at 0x0051b5c2, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051b5cb
    {load} mov ecx, edi                          # 0051b5c4
    call FUN_0051ab4b                            # 0051b5c6
L_0051b5cb:
    # block 0x0051b5cb: entered by jmp at 0x0051b5b4; jne at 0x0051b5c2, 3 instruction(s), ends with ret 0x8
    pop edi                                      # 0051b5cb
    pop esi                                      # 0051b5cc
    ret 0x8                                      # 0051b5cd

