# FUN_005217be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005217be
# extent:       0x005217be-0x005217c4 (6 code bytes)
# span:         0x005217be-0x005217c4 (code 6, tables 0, padding 0)
# sha256:       b0ffd6111c7356f87479fa5e58097f4c9734d2098e93f70a3b7704f45512a035
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Catch@005217be
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated C++ catch handler funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x005217c4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x005217be - 0x401000
.globl FUN_005217be
FUN_005217be:
    # block 0x005217be: entry, 2 instruction(s), ends with ret
    mov eax, 0x5217cb                            # 005217be
    ret                                          # 005217c3

