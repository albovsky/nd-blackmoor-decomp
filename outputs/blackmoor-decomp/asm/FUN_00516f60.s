# FUN_00516f60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516f60
# extent:       0x00516f60-0x00516f69 (9 code bytes)
# span:         0x00516f60-0x00516f69 (code 9, tables 0, padding 0)
# sha256:       41d51bbcfd46794c26a56c7e208fdc9a0f56577aca3b684c9bf65bf5df8884b8
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516f60
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050e8ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)

.org 0x00516f60 - 0x401000
.globl FUN_00516f60
FUN_00516f60:
    # block 0x00516f60: entry, 4 instruction(s), calls FUN_0050e8ed, ends with ret
    push 0x2                                     # 00516f60
    call FUN_0050e8ed                            # 00516f62
    pop ecx                                      # 00516f67
    ret                                          # 00516f68

