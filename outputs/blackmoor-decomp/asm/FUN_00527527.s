# FUN_00527527
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527527
# extent:       0x00527527-0x00527536 (15 code bytes)
# span:         0x00527527-0x00527536 (code 15, tables 0, padding 0)
# sha256:       979f18419a6b5b56bd269f59c3ef7fd61ab15551ae6cf889f1759a8810c512aa
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527527
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004dd3cf
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004dd3cf, .text + (0x004dd3cf - 0x401000)

.org 0x00527527 - 0x401000
.globl FUN_00527527
FUN_00527527:
    # block 0x00527527: entry, 4 instruction(s), calls FUN_004dd3cf, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527527
    add ecx, 0xa63f7                             # 0052752a
    call FUN_004dd3cf                            # 00527530
    ret                                          # 00527535

