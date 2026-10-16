# FUN_004d3723
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3723
# extent:       0x004d3723-0x004d3728 (5 code bytes)
# span:         0x004d3723-0x004d3728 (code 5, tables 0, padding 0)
# sha256:       7178bc05f1e5707e6c3dae3e068488f3df05d53b0e5eb728edd1abc56533f087
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3723
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004d3723 - 0x401000
.globl FUN_004d3723
FUN_004d3723:
    # block 0x004d3723: entry, 4 instruction(s), ends with ret
    push ebp                                     # 004d3723
    {load} mov ebp, esp                          # 004d3724
    pop ebp                                      # 004d3726
    ret                                          # 004d3727

