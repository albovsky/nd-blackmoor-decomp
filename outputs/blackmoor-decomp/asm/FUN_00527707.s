# FUN_00527707
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527707
# extent:       0x00527707-0x00527716 (15 code bytes)
# span:         0x00527707-0x00527716 (code 15, tables 0, padding 0)
# sha256:       08055d86b34e3464c34f1fb86a63a86be6695fcbe5dbd582f5c8d0d70547e7f1
# evidence:     ev_450eb38fa601afc4b84de6969079191c21baf0f40898d00aa11d7f75d3380ee5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527707
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004781de
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004781de, .text + (0x004781de - 0x401000)

.org 0x00527707 - 0x401000
.globl FUN_00527707
FUN_00527707:
    # block 0x00527707: entry, 4 instruction(s), calls FUN_004781de, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527707
    add ecx, 0xb167a                             # 0052770a
    call FUN_004781de                            # 00527710
    ret                                          # 00527715

