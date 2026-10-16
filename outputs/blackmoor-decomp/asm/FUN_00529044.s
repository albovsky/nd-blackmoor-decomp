# FUN_00529044
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529044
# extent:       0x00529044-0x0052904c (8 code bytes)
# span:         0x00529044-0x0052904c (code 8, tables 0, padding 0)
# sha256:       e20d7aec85d2511954de7ef0243607537b2083daac98e07d792b3a15b2572da8
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00529044
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_004caec0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052904c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004caec0, .text + (0x004caec0 - 0x401000)

.org 0x00529044 - 0x401000
.globl FUN_00529044
FUN_00529044:
    # block 0x00529044: entry, 2 instruction(s), ends with backward jump to 0x004caec0
    mov ecx, dword ptr [ebp - field_minus_10]    # 00529044
    jmp.d32 FUN_004caec0                         # 00529047

