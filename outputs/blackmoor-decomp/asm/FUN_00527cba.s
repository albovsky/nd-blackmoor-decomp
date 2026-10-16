# FUN_00527cba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527cba
# extent:       0x00527cba-0x00527cc9 (15 code bytes)
# span:         0x00527cba-0x00527cc9 (code 15, tables 0, padding 0)
# sha256:       392a63c539b2c34727fb8ca83487934e1d7b0ca8585078301049b062011d0c40
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527cba
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0048215e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048215e, .text + (0x0048215e - 0x401000)

.org 0x00527cba - 0x401000
.globl FUN_00527cba
FUN_00527cba:
    # block 0x00527cba: entry, 4 instruction(s), calls FUN_0048215e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527cba
    add ecx, 0xb498a                             # 00527cbd
    call FUN_0048215e                            # 00527cc3
    ret                                          # 00527cc8

