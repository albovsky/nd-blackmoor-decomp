# FUN_004fced6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fced6
# extent:       0x004fced6-0x004fcedc (6 code bytes)
# span:         0x004fced6-0x004fcedc (code 6, tables 0, padding 0)
# sha256:       2a87c4eb834ee384827d6cbbd8fd661ca43a99e5b879fab43ba152badab0d40e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_004fce90 (+0x46)
# region:       game
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fced6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump VERSION.dll!VerQueryValueA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x004fcedc
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004fced6 - 0x401000
.globl FUN_004fced6
FUN_004fced6:
    # block 0x004fced6: entry, 1 instruction(s), ends with indirect jump dword ptr [0x52a4e4]
    jmp dword ptr [0x52a4e4]                     # 004fced6

