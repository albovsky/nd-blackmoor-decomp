# FUN_00528dac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528dac
# extent:       0x00528dac-0x00528db4 (8 code bytes)
# span:         0x00528dac-0x00528db4 (code 8, tables 0, padding 0)
# sha256:       07731df1f7a60326937589f747d11fcd6534b82e39b00d5644ea6de2a6de8f12
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528dac
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528db4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00528dac - 0x401000
.globl FUN_00528dac
FUN_00528dac:
    # block 0x00528dac: entry, 2 instruction(s), ends with backward jump to 0x0051d730
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528dac
    jmp.d32 FUN_0051d730                         # 00528daf

