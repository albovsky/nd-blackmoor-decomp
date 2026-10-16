# FUN_00524936
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524936
# extent:       0x00524936-0x00524945 (15 code bytes)
# span:         0x00524936-0x00524945 (code 15, tables 0, padding 0)
# sha256:       19c8a788a7119bc732b6bd2bbe480341629a1bd01dff43c2f239095f552b224b
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524936
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c511
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c511, .text + (0x0050c511 - 0x401000)

.org 0x00524936 - 0x401000
.globl FUN_00524936
FUN_00524936:
    # block 0x00524936: entry, 5 instruction(s), calls FUN_0050c511, ends with ret
    push 0x40                                    # 00524936
    push 0x3c                                    # 00524938
    mov ecx, 0x63c230                            # 0052493a
    call FUN_0050c511                            # 0052493f
    ret                                          # 00524944

