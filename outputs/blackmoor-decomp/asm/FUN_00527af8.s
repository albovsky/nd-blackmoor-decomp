# FUN_00527af8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527af8
# extent:       0x00527af8-0x00527b07 (15 code bytes)
# span:         0x00527af8-0x00527b07 (code 15, tables 0, padding 0)
# sha256:       4425a42e6589d9f9de96c7c68eb2b886a33c3b7647fda183aa0b8622d5bb7d56
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527af8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004b5b6e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004b5b6e, .text + (0x004b5b6e - 0x401000)

.org 0x00527af8 - 0x401000
.globl FUN_00527af8
FUN_00527af8:
    # block 0x00527af8: entry, 4 instruction(s), calls FUN_004b5b6e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527af8
    add ecx, 0xad0c1                             # 00527afb
    call FUN_004b5b6e                            # 00527b01
    ret                                          # 00527b06

