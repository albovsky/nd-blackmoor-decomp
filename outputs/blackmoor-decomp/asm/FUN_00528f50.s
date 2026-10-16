# FUN_00528f50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528f50
# extent:       0x00528f50-0x00528f58 (8 code bytes)
# span:         0x00528f50-0x00528f58 (code 8, tables 0, padding 0)
# sha256:       e26b439a6e3dffe5abfed7e4a9deac3ecc11e8ba429e940ff252ad5e3e85333d
# evidence:     ev_911401004da6a50fe2c6da2a1636d1d967e1d217200235f8b7d699d8e6aaea05
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528f50
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls tail jump FUN_0050c1de
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00528f58
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0050c1de, .text + (0x0050c1de - 0x401000)

.org 0x00528f50 - 0x401000
.globl FUN_00528f50
FUN_00528f50:
    # block 0x00528f50: entry, 2 instruction(s), ends with backward jump to 0x0050c1de
    lea ecx, [ebp - field_minus_14]              # 00528f50
    jmp.d32 FUN_0050c1de                         # 00528f53

