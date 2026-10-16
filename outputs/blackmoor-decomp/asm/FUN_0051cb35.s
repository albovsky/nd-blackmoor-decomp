# FUN_0051cb35
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cb35
# extent:       0x0051cb35-0x0051cb38 (3 code bytes)
# span:         0x0051cb35-0x0051cb38 (code 3, tables 0, padding 0)
# sha256:       d523e9054bf797823934bb4383bc4f5583eab0b833cbc5b0d1f5a77178781e9b
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051cb17 (+0x1e)
# region:       crt_mfc
# frame:        none
# ending:       fall-through into 0x0051cb38 (counted only bound together with the range it falls into, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cb35
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part is a fragment that falls through into 0x0051cb38 and is counted only bound together with that range (owner ruling of 2026-10-16)
# note:         falls_through_to:0x0051cb38
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------

.org 0x0051cb35 - 0x401000
.globl FUN_0051cb35
FUN_0051cb35:
    # block 0x0051cb35: entry, 1 instruction(s), falls through into the entry at 0x0051cb38, which is bound together with this one
    mov edi, dword ptr [ebp - field_minus_14]    # 0051cb35

