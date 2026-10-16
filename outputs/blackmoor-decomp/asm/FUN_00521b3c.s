# FUN_00521b3c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521b3c
# extent:       0x00521b3c-0x00521b4a (14 code bytes)
# span:         0x00521b3c-0x00521b4a (code 14, tables 0, padding 0)
# sha256:       d6b19249ef3d368633a4615bcaf91dc3fd51c6f7a68c4ade8f857c045e57c513
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00521b22 (+0x1a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521b3c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051cab3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00521b4a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051cab3, .text + (0x0051cab3 - 0x401000)

.org 0x00521b3c - 0x401000
.globl FUN_00521b3c
FUN_00521b3c:
    # block 0x00521b3c: entry, 6 instruction(s), calls FUN_0051cab3, ends with ret
    push 0x1                                     # 00521b3c
    call FUN_0051cab3                            # 00521b3e
    neg eax                                      # 00521b43
    {load} sbb eax, eax                          # 00521b45
    neg eax                                      # 00521b47
    ret                                          # 00521b49

