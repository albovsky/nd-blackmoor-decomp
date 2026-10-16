# FUN_0050c468
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c468
# extent:       0x0050c468-0x0050c484 (28 code bytes)
# span:         0x0050c468-0x0050c484 (code 28, tables 0, padding 0)
# sha256:       0445b8f441314812dc4575e4fa5078b1792b93fce83fb701ee598d2cd1927daf
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c468
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050c484, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050c484, .text + (0x0050c484 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0050c468 - 0x401000
.globl FUN_0050c468
FUN_0050c468:
    # block 0x0050c468: entry, 5 instruction(s), calls FUN_0050c484, ends with je to 0x0050c47e (forward)
    push esi                                     # 0050c468
    {load} mov esi, ecx                          # 0050c469
    call FUN_0050c484                            # 0050c46b
    test byte ptr [esp + stk_8], 0x1             # 0050c470
    je.d8 L_0050c47e                             # 0050c475
    # block 0x0050c477: entered by fall-through of je at 0x0050c475, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0050c47e
    push esi                                     # 0050c477
    call FUN_0051dc6c                            # 0050c478
    pop ecx                                      # 0050c47d
L_0050c47e:
    # block 0x0050c47e: entered by je at 0x0050c475, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0050c47e
    pop esi                                      # 0050c480
    ret 0x4                                      # 0050c481

