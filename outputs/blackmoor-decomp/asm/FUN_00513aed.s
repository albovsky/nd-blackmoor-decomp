# FUN_00513aed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513aed
# extent:       0x00513aed-0x00513af4 (7 code bytes)
# span:         0x00513aed-0x00513af4 (code 7, tables 0, padding 0)
# sha256:       c4a9e6065264eeb23acf409855fd591aa061920a1ba71326dbf62f0d8914ca25
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513a57 (+0x96)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513aed
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls LOC_00513ba9, tail jump LOC_00513aea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513af4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set LOC_00513aea, .text + (0x00513aea - 0x401000)
.set LOC_00513ba9, .text + (0x00513ba9 - 0x401000)

.org 0x00513aed - 0x401000
.globl FUN_00513aed
FUN_00513aed:
    # block 0x00513aed: entry, 2 instruction(s), calls LOC_00513ba9, ends with backward jump to 0x00513aea
    call LOC_00513ba9                            # 00513aed
    jmp.d8 . + (-8)  # -> LOC_00513aea           # 00513af2

