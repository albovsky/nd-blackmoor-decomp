# FUN_005188ce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005188ce
# extent:       0x005188ce-0x005188df (17 code bytes)
# span:         0x005188ce-0x005188df (code 17, tables 0, padding 0)
# sha256:       90b331c1b14a5595fa73c6ee3147aecee5c3ee033fa5a3fd5a61d4ec5b7996e8
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005188ce
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_005188df
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_005188df, .text + (0x005188df - 0x401000)

.org 0x005188ce - 0x401000
.globl FUN_005188ce
FUN_005188ce:
    # block 0x005188ce: entry, 6 instruction(s), calls FUN_005188df, ends with ret
    push 0x4                                     # 005188ce
    push 0x0                                     # 005188d0
    push dword ptr [esp + stk_c]                 # 005188d2
    call FUN_005188df                            # 005188d6
    add esp, 0xc                                 # 005188db
    ret                                          # 005188de

