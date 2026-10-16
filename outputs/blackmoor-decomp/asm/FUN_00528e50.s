# FUN_00528e50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528e50
# extent:       0x00528e50-0x00528e58 (8 code bytes)
# span:         0x00528e50-0x00528e58 (code 8, tables 0, padding 0)
# sha256:       cebcac9b8ed1bbc604ca19b650fccad739102c2ad2226e31f6516f6de43cdd5f
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528e50
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_005268fc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528e58
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_005268fc, .text + (0x005268fc - 0x401000)

.org 0x00528e50 - 0x401000
.globl FUN_00528e50
FUN_00528e50:
    # block 0x00528e50: entry, 2 instruction(s), ends with backward jump to 0x005268fc
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528e50
    jmp.d32 FUN_005268fc                         # 00528e53

