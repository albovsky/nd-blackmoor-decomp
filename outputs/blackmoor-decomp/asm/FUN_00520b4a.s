# FUN_00520b4a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520b4a
# extent:       0x00520b4a-0x00520b54 (10 code bytes)
# span:         0x00520b4a-0x00520b54 (code 10, tables 0, padding 0)
# sha256:       b35caac991eb0d06657c3fbba49c85de5f83e8cf4de0b07b70fa4b90cb5770fd
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00520b14 (+0x36)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520b4a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_8; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00520b54
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00520b4a - 0x401000
.globl FUN_00520b4a
FUN_00520b4a:
    # block 0x00520b4a: entry, 3 instruction(s), ends with ret 0x4
    mov eax, dword ptr [esp + stk_4]             # 00520b4a
    mov dword ptr [ecx + field_8], eax           # 00520b4e
    ret 0x4                                      # 00520b51

