# FUN_005187f8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005187f8
# extent:       0x005187f8-0x005187fb (3 code bytes)
# span:         0x005187f8-0x005187fb (code 3, tables 0, padding 0)
# sha256:       263eaea8abb3fb5e28c92eb0d884f24153757bf9ecf6211ef860e7076cf909f3
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x105c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005187f8
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

.org 0x005187f8 - 0x401000
.globl FUN_005187f8
FUN_005187f8:
    # block 0x005187f8: entry, 2 instruction(s), ends with ret
    fptan                                        # 005187f8
    ret                                          # 005187fa

