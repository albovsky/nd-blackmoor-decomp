# FUN_0050c3f8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c3f8
# extent:       0x0050c3f8-0x0050c414 (28 code bytes)
# span:         0x0050c3f8-0x0050c414 (code 28, tables 0, padding 0)
# sha256:       eb2cf7a20543a59581f6f6e303c484fe59887a00b4a94bd72cbe625a7db1163a
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c3f8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050c414, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050c414, .text + (0x0050c414 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0050c3f8 - 0x401000
.globl FUN_0050c3f8
FUN_0050c3f8:
    # block 0x0050c3f8: entry, 5 instruction(s), calls FUN_0050c414, ends with je to 0x0050c40e (forward)
    push esi                                     # 0050c3f8
    {load} mov esi, ecx                          # 0050c3f9
    call FUN_0050c414                            # 0050c3fb
    test byte ptr [esp + stk_8], 0x1             # 0050c400
    je.d8 L_0050c40e                             # 0050c405
    # block 0x0050c407: entered by fall-through of je at 0x0050c405, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0050c40e
    push esi                                     # 0050c407
    call FUN_0051dc6c                            # 0050c408
    pop ecx                                      # 0050c40d
L_0050c40e:
    # block 0x0050c40e: entered by je at 0x0050c405, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0050c40e
    pop esi                                      # 0050c410
    ret 0x4                                      # 0050c411

