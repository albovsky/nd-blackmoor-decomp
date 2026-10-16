# FUN_00529170
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00529170
# extent:       0x00529170-0x00529179 (9 code bytes)
# span:         0x00529170-0x00529179 (code 9, tables 0, padding 0)
# sha256:       9828faa186fce2efc7b3eb8cb49b8837f53ce04614d166c9d7e4af1a2b7b65d9
# evidence:     ev_103b446af90999e21d4e460ffaf2ca0eceda03f2ae40f017e023b1a6a4c96505
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00529170
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00529179
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00529170 - 0x401000
.globl FUN_00529170
FUN_00529170:
    # block 0x00529170: entry, 3 instruction(s), calls FUN_00401c90, ends with ret
    push dword ptr [ebp - field_minus_10]        # 00529170
    call FUN_00401c90                            # 00529173
    ret                                          # 00529178

