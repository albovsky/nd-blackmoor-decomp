# FUN_0051d9f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d9f7
# extent:       0x0051d9f7-0x0051d9fd (6 code bytes)
# span:         0x0051d9f7-0x0051d9fd (code 6, tables 0, padding 0)
# sha256:       c10b0dcf4c65f9e933c62f6c4394b53355b6434f006f77247bf090b3a11c555f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051d9c1 (+0x36)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d9f7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051d9fd
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0051d9f7 - 0x401000
.globl FUN_0051d9f7
FUN_0051d9f7:
    # block 0x0051d9f7: entry, 2 instruction(s), ends with ret
    mov eax, 0x52ed10                            # 0051d9f7
    ret                                          # 0051d9fc

