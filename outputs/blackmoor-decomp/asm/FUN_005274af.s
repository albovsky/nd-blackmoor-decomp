# FUN_005274af
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005274af
# extent:       0x005274af-0x005274be (15 code bytes)
# span:         0x005274af-0x005274be (code 15, tables 0, padding 0)
# sha256:       f9abe70b27ff46ab424a2290c2d6898929b2a616a7ef06f95ac076b1869d6425
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005274af
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004de66e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004de66e, .text + (0x004de66e - 0x401000)

.org 0x005274af - 0x401000
.globl FUN_005274af
FUN_005274af:
    # block 0x005274af: entry, 4 instruction(s), calls FUN_004de66e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005274af
    add ecx, 0x12ead                             # 005274b2
    call FUN_004de66e                            # 005274b8
    ret                                          # 005274bd

