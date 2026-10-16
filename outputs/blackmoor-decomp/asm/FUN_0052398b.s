# FUN_0052398b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052398b
# extent:       0x0052398b-0x00523992 (7 code bytes)
# span:         0x0052398b-0x00523992 (code 7, tables 0, padding 0)
# sha256:       84358b64bfaccfd336ed4b2ce706f45729f875f610a80f96346cc982b5cad304
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052398b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_98
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00523992
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_98, 0x98  # offset +0x98

# --- external targets -----------------------------------------------

.org 0x0052398b - 0x401000
.globl FUN_0052398b
FUN_0052398b:
    # block 0x0052398b: entry, 2 instruction(s), ends with ret
    mov eax, dword ptr [ecx + field_98]          # 0052398b
    ret                                          # 00523991

