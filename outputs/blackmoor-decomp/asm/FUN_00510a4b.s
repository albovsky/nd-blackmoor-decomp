# FUN_00510a4b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510a4b
# extent:       0x00510a4b-0x00510a51 (6 code bytes)
# span:         0x00510a4b-0x00510a51 (code 6, tables 0, padding 0)
# sha256:       496b985332945bc3755d6fc736ed679ca2f101255d1bd252d93a2a71faaf5028
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00510984 (+0xc7)
# region:       crt_mfc
# frame:        none
# ending:       fall-through into 0x00510a51 (counted only bound together with the range it falls into, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510a4b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part is a fragment that falls through into 0x00510a51 and is counted only bound together with that range (owner ruling of 2026-10-16)
# note:         falls_through_to:0x00510a51
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00510a4b - 0x401000
.globl FUN_00510a4b
FUN_00510a4b:
    # block 0x00510a4b: entry, 2 instruction(s), falls through into the entry at 0x00510a51, which is bound together with this one
    mov esi, dword ptr [ebp + field_c]           # 00510a4b
    mov edi, dword ptr [ebp + field_8]           # 00510a4e

