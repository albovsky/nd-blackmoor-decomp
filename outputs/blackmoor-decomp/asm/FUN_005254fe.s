# FUN_005254fe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005254fe
# extent:       0x005254fe-0x0052551e (32 code bytes)
# span:         0x005254fe-0x0052551e (code 32, tables 0, padding 0)
# sha256:       6fd74ac7cd3c9540d4aee55b2e249645cab14f35931bfaa41fff3183f58c8085
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005254fe
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0052551e, FUN_0050c604
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052551e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050c604, .text + (0x0050c604 - 0x401000)
.set FUN_0052551e, .text + (0x0052551e - 0x401000)

.org 0x005254fe - 0x401000
.globl FUN_005254fe
FUN_005254fe:
    # block 0x005254fe: entry, 5 instruction(s), calls FUN_0052551e, ends with je to 0x00525518 (forward)
    push esi                                     # 005254fe
    {load} mov esi, ecx                          # 005254ff
    call FUN_0052551e                            # 00525501
    test byte ptr [esp + stk_8], 0x1             # 00525506
    je.d8 L_00525518                             # 0052550b
    # block 0x0052550d: entered by fall-through of je at 0x0052550b, 3 instruction(s), calls FUN_0050c604, falls into the block at 0x00525518
    push esi                                     # 0052550d
    mov ecx, 0x63c5a8                            # 0052550e
    call FUN_0050c604                            # 00525513
L_00525518:
    # block 0x00525518: entered by je at 0x0052550b, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00525518
    pop esi                                      # 0052551a
    ret 0x4                                      # 0052551b

