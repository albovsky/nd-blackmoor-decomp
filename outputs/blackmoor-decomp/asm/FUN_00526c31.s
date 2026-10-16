# FUN_00526c31
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526c31
# extent:       0x00526c31-0x00526c40 (15 code bytes)
# span:         0x00526c31-0x00526c40 (code 15, tables 0, padding 0)
# sha256:       32a3eb1acc31efa006a2aceb512bd78a528a3f3b09f30d40f97468d22d81bb08
# evidence:     ev_0bbbc573516b7688334fa3c5789e28ab705dc141b3b8d4358815cff5668572a9
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526c31
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00401032
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401032, .text + (0x00401032 - 0x401000)

.org 0x00526c31 - 0x401000
.globl FUN_00526c31
FUN_00526c31:
    # block 0x00526c31: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526c31
    add ecx, 0x8c                                # 00526c34
    call FUN_00401032                            # 00526c3a
    ret                                          # 00526c3f

