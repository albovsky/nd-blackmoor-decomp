# FUN_00529083
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529083
# extent:       0x00529083-0x0052908e (11 code bytes)
# span:         0x00529083-0x0052908e (code 11, tables 0, padding 0)
# sha256:       ad04a89deab0410b1800a6a618087bc0907619cab4c2072a158b361bdc695fcc
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00529083
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_0051a4bd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0052908e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051a4bd, .text + (0x0051a4bd - 0x401000)

.org 0x00529083 - 0x401000
.globl FUN_00529083
FUN_00529083:
    # block 0x00529083: entry, 3 instruction(s), ends with backward jump to 0x0051a4bd
    mov ecx, dword ptr [ebp - field_minus_10]    # 00529083
    add ecx, 0x20                                # 00529086
    jmp.d32 FUN_0051a4bd                         # 00529089

