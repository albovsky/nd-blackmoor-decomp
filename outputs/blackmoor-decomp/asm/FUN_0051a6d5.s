# FUN_0051a6d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a6d5
# extent:       0x0051a6d5-0x0051a6e2 (13 code bytes)
# span:         0x0051a6d5-0x0051a6e2 (code 13, tables 0, padding 0)
# sha256:       a2b7e53743773de7204112987e3382caebc3d205af84a8c787d333fb234295cd
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a6d5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051a801
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051a801, .text + (0x0051a801 - 0x401000)

.org 0x0051a6d5 - 0x401000
.globl FUN_0051a6d5
FUN_0051a6d5:
    # block 0x0051a6d5: entry, 4 instruction(s), calls FUN_0051a801, ends with ret
    push 0x0                                     # 0051a6d5
    mov ecx, 0x63c318                            # 0051a6d7
    call FUN_0051a801                            # 0051a6dc
    ret                                          # 0051a6e1

