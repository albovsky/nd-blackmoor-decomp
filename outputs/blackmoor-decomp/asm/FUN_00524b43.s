# FUN_00524b43
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524b43
# extent:       0x00524b43-0x00524b5f (28 code bytes)
# span:         0x00524b43-0x00524b5f (code 28, tables 0, padding 0)
# sha256:       8aa04ac62e27d41db861819532382b6d307e9d4f97c3b28ac05d96bf08f624c2
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CWinThread::`scalar_deleting_destructor'
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_005268fc, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_005268fc, .text + (0x005268fc - 0x401000)

.org 0x00524b43 - 0x401000
.globl FUN_00524b43
FUN_00524b43:
    # block 0x00524b43: entry, 5 instruction(s), calls FUN_005268fc, ends with je to 0x00524b59 (forward)
    push esi                                     # 00524b43
    {load} mov esi, ecx                          # 00524b44
    call FUN_005268fc                            # 00524b46
    test byte ptr [esp + stk_8], 0x1             # 00524b4b
    je.d8 L_00524b59                             # 00524b50
    # block 0x00524b52: entered by fall-through of je at 0x00524b50, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00524b59
    push esi                                     # 00524b52
    call FUN_0051dc6c                            # 00524b53
    pop ecx                                      # 00524b58
L_00524b59:
    # block 0x00524b59: entered by je at 0x00524b50, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00524b59
    pop esi                                      # 00524b5b
    ret 0x4                                      # 00524b5c

