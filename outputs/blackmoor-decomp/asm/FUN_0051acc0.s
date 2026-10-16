# FUN_0051acc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051acc0
# extent:       0x0051acc0-0x0051acc6 (6 code bytes)
# span:         0x0051acc0-0x0051acc6 (code 6, tables 0, padding 0)
# sha256:       fe2194b0ea109c7d9055f0371dbe890ae24b1d961a0c54781fda838cfac88910
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051acc0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0051acc0 - 0x401000
.globl FUN_0051acc0
FUN_0051acc0:
    # block 0x0051acc0: entry, 2 instruction(s), ends with ret
    mov eax, 0x51ac91                            # 0051acc0
    ret                                          # 0051acc5

