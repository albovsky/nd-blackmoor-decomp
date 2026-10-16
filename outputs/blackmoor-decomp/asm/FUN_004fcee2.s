# FUN_004fcee2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcee2
# extent:       0x004fcee2-0x004fcee8 (6 code bytes)
# span:         0x004fcee2-0x004fcef0 (code 6, tables 0, padding 8)
# sha256:       eb695c13ae340ab649851d5b73721a3f748efa79bed00cde2d7559d496ba3847
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_004fce90 (+0x52)
# region:       game
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fcee2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump VERSION.dll!GetFileVersionInfoSizeA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004fcee2 - 0x401000
.globl FUN_004fcee2
FUN_004fcee2:
    # block 0x004fcee2: entry, 1 instruction(s), ends with indirect jump dword ptr [0x52a4ec]
    jmp dword ptr [0x52a4ec]                     # 004fcee2

# --- data items (not part of the function) -------------------------
.org 0x004fcee8 - 0x401000
PAD_004fcee8:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

