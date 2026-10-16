# FUN_004fceca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fceca
# extent:       0x004fceca-0x004fced0 (6 code bytes)
# span:         0x004fceca-0x004fced0 (code 6, tables 0, padding 0)
# sha256:       05732a885e87316c3c09c3fcfaca97748ff63148b6fb6dc8219576d14d446b35
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_004fce90 (+0x3a)
# region:       game
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fceca
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump DSOUND.dll!#1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x004fced0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004fceca - 0x401000
.globl FUN_004fceca
FUN_004fceca:
    # block 0x004fceca: entry, 1 instruction(s), ends with indirect jump dword ptr [0x52a040]
    jmp dword ptr [0x52a040]                     # 004fceca

