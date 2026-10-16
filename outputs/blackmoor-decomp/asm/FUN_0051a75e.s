# FUN_0051a75e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a75e
# extent:       0x0051a75e-0x0051a76a (12 code bytes)
# span:         0x0051a75e-0x0051a76a (code 12, tables 0, padding 0)
# sha256:       df9b959e1cb829fa3192e54d177c9344152a2b0dc6efe26d51baa3f6cc2d23d0
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a75e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051a76a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x0051a75e - 0x401000
.globl FUN_0051a75e
FUN_0051a75e:
    # block 0x0051a75e: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x51a76a                                # 0051a75e
    call FUN_0050d775                            # 0051a763
    pop ecx                                      # 0051a768
    ret                                          # 0051a769

