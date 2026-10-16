# FUN_00521188
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521188
# extent:       0x00521188-0x005211ff (119 code bytes)
# span:         0x00521188-0x005211ff (code 119, tables 0, padding 0)
# sha256:       9149dacfbf698e224a17b9bac393e8f79bd713401058188eff60fcbc7e461e3b
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521188
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10
# callees:      calls USER32.dll!GetFocus, FUN_0052102d, USER32.dll!GetWindowLongA, USER32.dll!GetDesktopWindow, USER32.dll!SendMessageA; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0052102d, .text + (0x0052102d - 0x401000)

.org 0x00521188 - 0x401000
.globl FUN_00521188
FUN_00521188:
    # block 0x00521188: entry, 7 instruction(s), calls USER32.dll!GetFocus, ends with je to 0x005211f9 (forward)
    push ebx                                     # 00521188
    push esi                                     # 00521189
    push edi                                     # 0052118a
    call dword ptr [0x52a308]                    # 0052118b
    {load} mov esi, eax                          # 00521191
    test esi, esi                                # 00521193
    je.d8 L_005211f9                             # 00521195
    # block 0x00521197: entered by fall-through of je at 0x00521195, 3 instruction(s), ends with je to 0x005211f9 (forward)
    mov edi, dword ptr [esp + stk_10]            # 00521197
    {load} cmp esi, edi                          # 0052119b
    je.d8 L_005211f9                             # 0052119d
    # block 0x0052119f: entered by fall-through of je at 0x0052119d, 6 instruction(s), calls FUN_0052102d, ends with jne to 0x005211c6 (forward)
    push 0x3                                     # 0052119f
    push esi                                     # 005211a1
    call FUN_0052102d                            # 005211a2
    mov ebx, dword ptr [0x52a3dc]                # 005211a7
    test eax, eax                                # 005211ad
    jne.d8 L_005211c6                            # 005211af
    # block 0x005211b1: entered by fall-through of jne at 0x005211af, 5 instruction(s), calls indirect ebx, ends with je to 0x005211f9 (forward)
    push esi                                     # 005211b1
    call ebx                                     # 005211b2
    {load} mov esi, eax                          # 005211b4
    {load} cmp esi, edi                          # 005211b6
    je.d8 L_005211f9                             # 005211b8
    # block 0x005211ba: entered by fall-through of je at 0x005211b8, 5 instruction(s), calls FUN_0052102d, ends with je to 0x005211f9 (forward)
    push 0x2                                     # 005211ba
    push esi                                     # 005211bc
    call FUN_0052102d                            # 005211bd
    test eax, eax                                # 005211c2
    je.d8 L_005211f9                             # 005211c4
L_005211c6:
    # block 0x005211c6: entered by jne at 0x005211af; fall-through of je at 0x005211c4, 2 instruction(s), ends with je to 0x005211e9 (forward)
    test edi, edi                                # 005211c6
    je.d8 L_005211e9                             # 005211c8
    # block 0x005211ca: entered by fall-through of je at 0x005211c8, 5 instruction(s), calls USER32.dll!GetWindowLongA, ends with je to 0x005211e9 (forward)
    push -0x10                                   # 005211ca
    push edi                                     # 005211cc
    call dword ptr [0x52a454]                    # 005211cd
    test eax, 0x40000000                         # 005211d3
    je.d8 L_005211e9                             # 005211d8
    # block 0x005211da: entered by fall-through of je at 0x005211d8, 6 instruction(s), calls indirect ebx, USER32.dll!GetDesktopWindow, ends with je to 0x005211f9 (forward)
    push edi                                     # 005211da
    call ebx                                     # 005211db
    {load} mov edi, eax                          # 005211dd
    call dword ptr [0x52a384]                    # 005211df
    {load} cmp edi, eax                          # 005211e5
    je.d8 L_005211f9                             # 005211e7
L_005211e9:
    # block 0x005211e9: entered by je at 0x005211c8; je at 0x005211d8; fall-through of je at 0x005211e7, 5 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x005211f9
    push 0x0                                     # 005211e9
    push 0x0                                     # 005211eb
    push 0x14f                                   # 005211ed
    push esi                                     # 005211f2
    call dword ptr [0x52a4c8]                    # 005211f3
L_005211f9:
    # block 0x005211f9: entered by je at 0x00521195; je at 0x0052119d; je at 0x005211b8; je at 0x005211c4; je at 0x005211e7, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 005211f9
    pop esi                                      # 005211fa
    pop ebx                                      # 005211fb
    ret 0x4                                      # 005211fc

