# FUN_0050d078
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d078
# extent:       0x0050d078-0x0050d0a9 (49 code bytes)
# span:         0x0050d078-0x0050d0a9 (code 49, tables 0, padding 0)
# sha256:       5d8a3d3611600c58d489e90b917e1f61f5a44f3a5d2d7f963739c74d3ad3633b
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d078
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_18
# callees:      calls FUN_005127e5, FUN_00512675, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00512126, .text + (0x00512126 - 0x401000)
.set FUN_00512675, .text + (0x00512675 - 0x401000)
.set FUN_005127e5, .text + (0x005127e5 - 0x401000)

.org 0x0050d078 - 0x401000
.globl FUN_0050d078
FUN_0050d078:
    # block 0x0050d078: entry, 5 instruction(s), calls FUN_005127e5, ends with jne to 0x0050d086 (forward)
    push esi                                     # 0050d078
    call FUN_005127e5                            # 0050d079
    {load} mov esi, eax                          # 0050d07e
    test esi, esi                                # 0050d080
    jne.d8 L_0050d086                            # 0050d082
    # block 0x0050d084: entered by fall-through of jne at 0x0050d082, 2 instruction(s), ends with ret
    pop esi                                      # 0050d084
    ret                                          # 0050d085
L_0050d086:
    # block 0x0050d086: entered by jne at 0x0050d082, 14 instruction(s), calls FUN_00512675, FUN_00512126, ends with ret
    push edi                                     # 0050d086
    push esi                                     # 0050d087
    push dword ptr [esp + stk_18]                # 0050d088
    push dword ptr [esp + stk_18]                # 0050d08c
    push dword ptr [esp + stk_18]                # 0050d090
    call FUN_00512675                            # 0050d094
    push esi                                     # 0050d099
    {load} mov edi, eax                          # 0050d09a
    call FUN_00512126                            # 0050d09c
    add esp, 0x14                                # 0050d0a1
    {load} mov eax, edi                          # 0050d0a4
    pop edi                                      # 0050d0a6
    pop esi                                      # 0050d0a7
    ret                                          # 0050d0a8

