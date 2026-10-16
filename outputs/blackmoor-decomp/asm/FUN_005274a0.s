# FUN_005274a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005274a0
# extent:       0x005274a0-0x005274af (15 code bytes)
# span:         0x005274a0-0x005274af (code 15, tables 0, padding 0)
# sha256:       15e2233041a4d781874a399beb23d381d3a672fe2a412d4b021ff3130957abd3
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005274a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0043772f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0043772f, .text + (0x0043772f - 0x401000)

.org 0x005274a0 - 0x401000
.globl FUN_005274a0
FUN_005274a0:
    # block 0x005274a0: entry, 4 instruction(s), calls FUN_0043772f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005274a0
    add ecx, 0x12e80                             # 005274a3
    call FUN_0043772f                            # 005274a9
    ret                                          # 005274ae

