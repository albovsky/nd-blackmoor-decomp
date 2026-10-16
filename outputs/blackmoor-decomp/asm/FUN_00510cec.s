# FUN_00510cec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510cec
# extent:       0x00510cec-0x00510cf4 (8 code bytes)
# span:         0x00510cec-0x00510cf4 (code 8, tables 0, padding 0)
# sha256:       8368f4597d6949e6c4b91e9f411d489eacc8585765d8d85b01c5ada74561b7e0
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00510c8d (+0x5f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510cec
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_18
# callees:      calls tail jump FUN_00510eda
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_00510eda, .text + (0x00510eda - 0x401000)

.org 0x00510cec - 0x401000
.globl FUN_00510cec
FUN_00510cec:
    # block 0x00510cec: entry, 2 instruction(s), ends with forward jump to 0x00510eda
    mov esp, dword ptr [ebp - field_minus_18]    # 00510cec
    jmp.d32 FUN_00510eda                         # 00510cef

