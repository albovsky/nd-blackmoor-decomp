# FUN_0051e24e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e24e
# extent:       0x0051e24e-0x0051e253 (5 code bytes)
# span:         0x0051e24e-0x0051e253 (code 5, tables 0, padding 0)
# sha256:       be24ce65899035dd6940c2a54f34b5f84118b8fdf138987b6b2e321f22091648
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051e239 (+0x15)
# region:       crt_mfc
# frame:        none
# ending:       fall-through into 0x0051e253 (counted only bound together with the range it falls into, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e24e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part is a fragment that falls through into 0x0051e253 and is counted only bound together with that range (owner ruling of 2026-10-16)
# note:         falls_through_to:0x0051e253
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c

# --- external targets -----------------------------------------------

.org 0x0051e24e - 0x401000
.globl FUN_0051e24e
FUN_0051e24e:
    # block 0x0051e24e: entry, 2 instruction(s), falls through into the entry at 0x0051e253, which is bound together with this one
    mov esi, dword ptr [ebp - field_minus_1c]    # 0051e24e
    {load} xor edi, edi                          # 0051e251

