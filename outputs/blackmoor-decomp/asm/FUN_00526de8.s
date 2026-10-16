# FUN_00526de8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526de8
# extent:       0x00526de8-0x00526df7 (15 code bytes)
# span:         0x00526de8-0x00526df7 (code 15, tables 0, padding 0)
# sha256:       be04de9571fb67875526644676d77ed83252662981e38aea03390e9aec41bcdd
# evidence:     ev_a2e1e77de9fed89c1dc4e9b46441a378acf5d34515bb0884d2eb66c2fc053227
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00526de8
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

.org 0x00526de8 - 0x401000
.globl FUN_00526de8
FUN_00526de8:
    # block 0x00526de8: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00526de8
    add ecx, 0x1cc                               # 00526deb
    call FUN_00401032                            # 00526df1
    ret                                          # 00526df6

