# FUN_00528a30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528a30
# extent:       0x00528a30-0x00528a39 (9 code bytes)
# span:         0x00528a30-0x00528a39 (code 9, tables 0, padding 0)
# sha256:       cb1e5f34a4fecfc697604e10bf2c5e80ef046173de08abd9976f991dd8824ac4
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528a30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004eda7c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004eda7c, .text + (0x004eda7c - 0x401000)

.org 0x00528a30 - 0x401000
.globl FUN_00528a30
FUN_00528a30:
    # block 0x00528a30: entry, 3 instruction(s), calls FUN_004eda7c, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528a30
    call FUN_004eda7c                            # 00528a33
    ret                                          # 00528a38

