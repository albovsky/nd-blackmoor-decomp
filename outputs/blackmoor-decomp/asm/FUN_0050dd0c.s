# FUN_0050dd0c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050dd0c
# extent:       0x0050dd0c-0x0050dd15 (9 code bytes)
# span:         0x0050dd0c-0x0050dd15 (code 9, tables 0, padding 0)
# sha256:       7727cf1cb5a5144037ec6202bde31bb3f9b026e35b009c17c76e42132ed915b7
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050dcb0 (+0x5c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050dd0c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050dd15
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050dd15, .text + (0x0050dd15 - 0x401000)

.org 0x0050dd0c - 0x401000
.globl FUN_0050dd0c
FUN_0050dd0c:
    # block 0x0050dd0c: entry, 4 instruction(s), calls FUN_0050dd15, ends with ret
    push 0x1                                     # 0050dd0c
    call FUN_0050dd15                            # 0050dd0e
    pop ecx                                      # 0050dd13
    ret                                          # 0050dd14

