# FUN_005274fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005274fa
# extent:       0x005274fa-0x00527509 (15 code bytes)
# span:         0x005274fa-0x00527509 (code 15, tables 0, padding 0)
# sha256:       4d5b029fc37fd139730d736e7576abbff64805163081b6ea8c3b143ddbd31079
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005274fa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00416f2d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00416f2d, .text + (0x00416f2d - 0x401000)

.org 0x005274fa - 0x401000
.globl FUN_005274fa
FUN_005274fa:
    # block 0x005274fa: entry, 4 instruction(s), calls FUN_00416f2d, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005274fa
    add ecx, 0x62ba9                             # 005274fd
    call FUN_00416f2d                            # 00527503
    ret                                          # 00527508

