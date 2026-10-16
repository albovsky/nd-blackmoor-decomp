# FUN_0051fa4c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fa4c
# extent:       0x0051fa4c-0x0051fa6a (30 code bytes)
# span:         0x0051fa4c-0x0051fa6a (code 30, tables 0, padding 0)
# sha256:       5bf8acea3beeda5ac8f41cca18f4af925bb5c2c4c0a55eb8ca474056ee7a4e3e
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fa4c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0051f9c5, FUN_0051a57e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051a57e, .text + (0x0051a57e - 0x401000)
.set FUN_0051f9c5, .text + (0x0051f9c5 - 0x401000)

.org 0x0051fa4c - 0x401000
.globl FUN_0051fa4c
FUN_0051fa4c:
    # block 0x0051fa4c: entry, 6 instruction(s), calls FUN_0051f9c5, ends with je to 0x0051fa67 (forward)
    push 0x0                                     # 0051fa4c
    call FUN_0051f9c5                            # 0051fa4e
    {load} mov ecx, eax                          # 0051fa53
    {load} xor eax, eax                          # 0051fa55
    test ecx, ecx                                # 0051fa57
    je.d8 L_0051fa67                             # 0051fa59
    # block 0x0051fa5b: entered by fall-through of je at 0x0051fa59, 3 instruction(s), calls FUN_0051a57e, falls into the block at 0x0051fa67
    push dword ptr [esp + stk_4]                 # 0051fa5b
    add ecx, 0x4                                 # 0051fa5f
    call FUN_0051a57e                            # 0051fa62
L_0051fa67:
    # block 0x0051fa67: entered by je at 0x0051fa59, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051fa67

