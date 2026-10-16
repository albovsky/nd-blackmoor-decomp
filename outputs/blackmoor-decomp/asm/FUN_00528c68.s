# FUN_00528c68
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528c68
# extent:       0x00528c68-0x00528c70 (8 code bytes)
# span:         0x00528c68-0x00528c70 (code 8, tables 0, padding 0)
# sha256:       e64967165b0731225a9cdfa7fa19d95fc953c63ff17df655f36d7cda1562edfb
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528c68
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls tail jump FUN_0051de13
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_rule is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)

.org 0x00528c68 - 0x401000
.globl FUN_00528c68
FUN_00528c68:
    # block 0x00528c68: entry, 2 instruction(s), ends with backward jump to 0x0051de13
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528c68
    jmp.d32 FUN_0051de13                         # 00528c6b

