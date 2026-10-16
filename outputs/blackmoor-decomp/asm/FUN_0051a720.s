# FUN_0051a720
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a720
# extent:       0x0051a720-0x0051a72c (12 code bytes)
# span:         0x0051a720-0x0051a72c (code 12, tables 0, padding 0)
# sha256:       16a6ee3f6bf9751c88618879c58fe7e86c01e8ac0af04c1821d06cac98f32b47
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a720
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051a72c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)

.org 0x0051a720 - 0x401000
.globl FUN_0051a720
FUN_0051a720:
    # block 0x0051a720: entry, 4 instruction(s), calls FUN_0050d775, ends with ret
    push 0x51a72c                                # 0051a720
    call FUN_0050d775                            # 0051a725
    pop ecx                                      # 0051a72a
    ret                                          # 0051a72b

