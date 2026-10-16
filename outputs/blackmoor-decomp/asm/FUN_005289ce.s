# FUN_005289ce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005289ce
# extent:       0x005289ce-0x005289d7 (9 code bytes)
# span:         0x005289ce-0x005289d7 (code 9, tables 0, padding 0)
# sha256:       99595e3a1dfefb2697c58465eb4f6d6e58481ce71b72b5b4458cac0be1d6002a
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005289ce
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

.org 0x005289ce - 0x401000
.globl FUN_005289ce
FUN_005289ce:
    # block 0x005289ce: entry, 3 instruction(s), calls FUN_004eda7c, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005289ce
    call FUN_004eda7c                            # 005289d1
    ret                                          # 005289d6

