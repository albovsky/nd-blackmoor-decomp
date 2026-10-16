# FUN_00525426
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525426
# extent:       0x00525426-0x0052542b (5 code bytes)
# span:         0x00525426-0x0052542b (code 5, tables 0, padding 0)
# sha256:       67caf635e697aa8b4372663f9ec1aeb2a712427554f53e4dd40d12b57ebfea85
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052540b (+0x1b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525426
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_005251ee
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052542b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_005251ee, .text + (0x005251ee - 0x401000)

.org 0x00525426 - 0x401000
.globl FUN_00525426
FUN_00525426:
    # block 0x00525426: entry, 1 instruction(s), ends with backward jump to 0x005251ee
    jmp.d32 FUN_005251ee                         # 00525426

