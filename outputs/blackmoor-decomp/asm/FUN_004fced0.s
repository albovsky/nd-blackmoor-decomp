# FUN_004fced0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fced0
# extent:       0x004fced0-0x004fced6 (6 code bytes)
# span:         0x004fced0-0x004fced6 (code 6, tables 0, padding 0)
# sha256:       3de28dee63bdc5eb46d6ff6eaf3a6f52651d267915125e108ef30d6ac0d9c18a
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_004fce90 (+0x40)
# region:       game
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         import_thunk_DSOUND_ordinal_2
# naming:       function-xrefs.json thunks entry (kind import, container 0x004fce90); a structural fact about the bytes
# name-note:    A 6-byte indirect jump through the import address table slot of DSOUND.dll!#2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump DSOUND.dll!#2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name states a structural role that function-xrefs.json records about the bytes; it is not read from this code and not a recovered name
# note:         further_unindexed_code_at:0x004fced6
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004fced0 - 0x401000
.globl FUN_004fced0
FUN_004fced0:
    # block 0x004fced0: entry, 1 instruction(s), ends with indirect jump dword ptr [0x52a044]
    jmp dword ptr [0x52a044]                     # 004fced0

