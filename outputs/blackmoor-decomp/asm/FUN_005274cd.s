# FUN_005274cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005274cd
# extent:       0x005274cd-0x005274dc (15 code bytes)
# span:         0x005274cd-0x005274dc (code 15, tables 0, padding 0)
# sha256:       2bf8a5d349af1c96cdf6321e2c9c5579db3763db8d0d351c2ced601cecb65706
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005274cd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004fa9e7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004fa9e7, .text + (0x004fa9e7 - 0x401000)

.org 0x005274cd - 0x401000
.globl FUN_005274cd
FUN_005274cd:
    # block 0x005274cd: entry, 4 instruction(s), calls FUN_004fa9e7, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005274cd
    add ecx, 0x536df                             # 005274d0
    call FUN_004fa9e7                            # 005274d6
    ret                                          # 005274db

