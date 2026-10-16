# FUN_0051b645
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b645
# extent:       0x0051b645-0x0051b6a8 (99 code bytes)
# span:         0x0051b645-0x0051b6a8 (code 99, tables 0, padding 0)
# sha256:       e0d472fc03ef48d4c814160f5765ad7045c3b788ef9fe0773ffc0b22e386d44c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051b61a (+0x2b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b645
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4; [esp + n] stk_c, stk_14
# callees:      calls USER32.dll!GetMenuItemCount, USER32.dll!GetSubMenu, FUN_0051fa37, FUN_0051b645, USER32.dll!GetMenuItemID, FUN_0051fa4c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051b6a8
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051fa37, .text + (0x0051fa37 - 0x401000)
.set FUN_0051fa4c, .text + (0x0051fa4c - 0x401000)

.org 0x0051b645 - 0x401000
.globl FUN_0051b645
FUN_0051b645:
L_0051b645:
    # block 0x0051b645: entry, 10 instruction(s), calls USER32.dll!GetMenuItemCount, ends with jle to 0x0051b696 (forward)
    push ebx                                     # 0051b645
    push esi                                     # 0051b646
    mov esi, dword ptr [esp + stk_c]             # 0051b647
    push edi                                     # 0051b64b
    push dword ptr [esi + field_4]               # 0051b64c
    call dword ptr [0x52a3f8]                    # 0051b64f
    {load} mov ebx, eax                          # 0051b655
    {load} xor edi, edi                          # 0051b657
    test ebx, ebx                                # 0051b659
    jle.d8 L_0051b696                            # 0051b65b
L_0051b65d:
    # block 0x0051b65d: entered by jl at 0x0051b694; fall-through of jle at 0x0051b65b, 7 instruction(s), calls USER32.dll!GetSubMenu, FUN_0051fa37, ends with je to 0x0051b681 (forward)
    push edi                                     # 0051b65d
    push dword ptr [esi + field_4]               # 0051b65e
    call dword ptr [0x52a3fc]                    # 0051b661
    push eax                                     # 0051b667
    call FUN_0051fa37                            # 0051b668
    test eax, eax                                # 0051b66d
    je.d8 L_0051b681                             # 0051b66f
    # block 0x0051b671: entered by fall-through of je at 0x0051b66f, 5 instruction(s), calls FUN_0051b645, ends with jne to 0x0051b698 (forward)
    push dword ptr [esp + stk_14]                # 0051b671
    push eax                                     # 0051b675
    call L_0051b645                              # 0051b676
    test eax, eax                                # 0051b67b
    jne.d8 L_0051b698                            # 0051b67d
    # block 0x0051b67f: entered by fall-through of jne at 0x0051b67d, 1 instruction(s), ends with forward jump to 0x0051b691
    jmp.d8 L_0051b691                            # 0051b67f
L_0051b681:
    # block 0x0051b681: entered by je at 0x0051b66f, 5 instruction(s), calls USER32.dll!GetMenuItemID, ends with je to 0x0051b69e (forward)
    push edi                                     # 0051b681
    push dword ptr [esi + field_4]               # 0051b682
    call dword ptr [0x52a400]                    # 0051b685
    cmp eax, dword ptr [esp + stk_14]            # 0051b68b
    je.d8 L_0051b69e                             # 0051b68f
L_0051b691:
    # block 0x0051b691: entered by jmp at 0x0051b67f; fall-through of je at 0x0051b68f, 3 instruction(s), ends with jl to 0x0051b65d (backward)
    inc edi                                      # 0051b691
    {load} cmp edi, ebx                          # 0051b692
    jl.d8 L_0051b65d                             # 0051b694
L_0051b696:
    # block 0x0051b696: entered by jle at 0x0051b65b; fall-through of jl at 0x0051b694, 1 instruction(s), falls into the block at 0x0051b698
    {load} xor eax, eax                          # 0051b696
L_0051b698:
    # block 0x0051b698: entered by jne at 0x0051b67d; jmp at 0x0051b6a6, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 0051b698
    pop esi                                      # 0051b699
    pop ebx                                      # 0051b69a
    ret 0x8                                      # 0051b69b
L_0051b69e:
    # block 0x0051b69e: entered by je at 0x0051b68f, 3 instruction(s), calls FUN_0051fa4c, ends with backward jump to 0x0051b698
    push dword ptr [esi + field_4]               # 0051b69e
    call FUN_0051fa4c                            # 0051b6a1
    jmp.d8 L_0051b698                            # 0051b6a6

