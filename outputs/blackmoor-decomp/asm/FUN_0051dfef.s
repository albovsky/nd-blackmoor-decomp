# FUN_0051dfef
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dfef
# extent:       0x0051dfef-0x0051dff7 (8 code bytes)
# span:         0x0051dfef-0x0051dff7 (code 8, tables 0, padding 0)
# sha256:       40f6a2c178da64551162241d34de30cd340c3d32aacd13ee7b9c0c797e5ca06d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051dfda (+0x15)
# region:       crt_mfc
# frame:        none
# ending:       fall-through into 0x0051dff7 (counted only bound together with the range it falls into, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dfef
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_24, field_minus_28
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part is a fragment that falls through into 0x0051dff7 and is counted only bound together with that range (owner ruling of 2026-10-16)
# note:         falls_through_to:0x0051dff7
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_24, 0x24  # offset -0x24
.equ field_minus_28, 0x28  # offset -0x28

# --- external targets -----------------------------------------------

.org 0x0051dfef - 0x401000
.globl FUN_0051dfef
FUN_0051dfef:
    # block 0x0051dfef: entry, 3 instruction(s), falls through into the entry at 0x0051dff7, which is bound together with this one
    mov esi, dword ptr [ebp - field_minus_24]    # 0051dfef
    mov edi, dword ptr [ebp - field_minus_28]    # 0051dff2
    {load} xor ebx, ebx                          # 0051dff5

