# FUN_0051ebf2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ebf2
# extent:       0x0051ebf2-0x0051ebf8 (6 code bytes)
# span:         0x0051ebf2-0x0051ebf8 (code 6, tables 0, padding 0)
# sha256:       72b8fef03548e78c4871c40d8fb34a796dff1ce5c00c079386f1ced070676516
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051ebc8 (+0x2a)
# region:       crt_mfc
# frame:        none
# ending:       fall-through into 0x0051ebf8 (counted only bound together with the range it falls into, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ebf2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_14
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part is a fragment that falls through into 0x0051ebf8 and is counted only bound together with that range (owner ruling of 2026-10-16)
# note:         falls_through_to:0x0051ebf8
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0051ebf2 - 0x401000
.globl FUN_0051ebf2
FUN_0051ebf2:
    # block 0x0051ebf2: entry, 2 instruction(s), falls through into the entry at 0x0051ebf8, which is bound together with this one
    mov edi, dword ptr [ebp + field_8]           # 0051ebf2
    mov esi, dword ptr [ebp - field_minus_14]    # 0051ebf5

