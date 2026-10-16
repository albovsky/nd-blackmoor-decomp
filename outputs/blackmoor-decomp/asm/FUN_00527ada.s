# FUN_00527ada
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527ada
# extent:       0x00527ada-0x00527ae9 (15 code bytes)
# span:         0x00527ada-0x00527ae9 (code 15, tables 0, padding 0)
# sha256:       be9c5387ddd2499c8bf0e1c14fd3ac2553fe4bbc9c650a46ad8c53a44d7ee63b
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527ada
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0048d04b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048d04b, .text + (0x0048d04b - 0x401000)

.org 0x00527ada - 0x401000
.globl FUN_00527ada
FUN_00527ada:
    # block 0x00527ada: entry, 4 instruction(s), calls FUN_0048d04b, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527ada
    add ecx, 0xacfbd                             # 00527add
    call FUN_0048d04b                            # 00527ae3
    ret                                          # 00527ae8

