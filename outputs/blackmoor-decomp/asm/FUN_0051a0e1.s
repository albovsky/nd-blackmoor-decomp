# FUN_0051a0e1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a0e1
# extent:       0x0051a0e1-0x0051a0e6 (5 code bytes)
# span:         0x0051a0e1-0x0051a0e6 (code 5, tables 0, padding 0)
# sha256:       c9c211453b0c5d0188261df3f88b30436257fd4e6aa5d13f1f1bf7d05482b8a0
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051a0ca (+0x17)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         jump_thunk_to_0051ab4b
# naming:       function-xrefs.json thunks entry (kind jump, container 0x0051a0ca); a structural fact about the bytes
# name-note:    A 5-byte direct jump to 0x0051ab4b, the whole body of the entry
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name states a structural role that function-xrefs.json records about the bytes; it is not read from this code and not a recovered name
# note:         further_unindexed_code_at:0x0051a0e6
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0051a0e1 - 0x401000
.globl FUN_0051a0e1
FUN_0051a0e1:
    # block 0x0051a0e1: entry, 1 instruction(s), ends with forward jump to 0x0051ab4b
    jmp.d32 FUN_0051ab4b                         # 0051a0e1

