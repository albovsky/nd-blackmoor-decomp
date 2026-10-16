# FUN_00519a48
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519a48
# extent:       0x00519a48-0x00519a4e (6 code bytes)
# span:         0x00519a48-0x00519a4e (code 6, tables 0, padding 0)
# sha256:       04ab638548890875a4eb17f9dbbfdfb98321cff40badf8b27d637ba745b80dcc
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005199bd (+0x8b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519a48
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump WINSPOOL.DRV!ClosePrinter
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00519a4e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00519a48 - 0x401000
.globl FUN_00519a48
FUN_00519a48:
    # block 0x00519a48: entry, 1 instruction(s), ends with indirect jump dword ptr [0x52a4fc]
    jmp dword ptr [0x52a4fc]                     # 00519a48

