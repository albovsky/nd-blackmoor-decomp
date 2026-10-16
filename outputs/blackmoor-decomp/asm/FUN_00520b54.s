# FUN_00520b54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520b54
# extent:       0x00520b54-0x00520b5e (10 code bytes)
# span:         0x00520b54-0x00520b5e (code 10, tables 0, padding 0)
# sha256:       01caaa228fe4f4c7fe4269994a79702b290762107c5e6b67c17e8d8525fc7585
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00520b14 (+0x40)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520b54
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00520b5e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00520b54 - 0x401000
.globl FUN_00520b54
FUN_00520b54:
    # block 0x00520b54: entry, 3 instruction(s), ends with ret 0x4
    mov eax, dword ptr [esp + stk_4]             # 00520b54
    mov dword ptr [ecx + field_4], eax           # 00520b58
    ret 0x4                                      # 00520b5b

