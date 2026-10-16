# FUN_004fcec4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcec4
# extent:       0x004fcec4-0x004fceca (6 code bytes)
# span:         0x004fcec4-0x004fceca (code 6, tables 0, padding 0)
# sha256:       d40bfd3a6cc5f1ce8abf7d24ca7654f0035efd9e8f4eab940d3fcff44266eeda
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_004fce90 (+0x34)
# region:       game
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fcec4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump DDRAW.dll!DirectDrawEnumerateExA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x004fceca
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004fcec4 - 0x401000
.globl FUN_004fcec4
FUN_004fcec4:
    # block 0x004fcec4: entry, 1 instruction(s), ends with indirect jump dword ptr [0x52a034]
    jmp dword ptr [0x52a034]                     # 004fcec4

