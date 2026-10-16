# FUN_005273f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005273f0
# extent:       0x005273f0-0x005273f9 (9 code bytes)
# span:         0x005273f0-0x005273f9 (code 9, tables 0, padding 0)
# sha256:       79e61c75907ef298e6d1c7228e19ee1f272125a95008ea26dabe5590d9b6bd97
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005273f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_c
# callees:      calls FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005273f9
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x005273f0 - 0x401000
.globl FUN_005273f0
FUN_005273f0:
    # block 0x005273f0: entry, 3 instruction(s), calls FUN_0051e7ba, ends with ret
    lea ecx, [ebp + field_c]                     # 005273f0
    call FUN_0051e7ba                            # 005273f3
    ret                                          # 005273f8

