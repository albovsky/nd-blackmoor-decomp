# FUN_0052890f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052890f
# extent:       0x0052890f-0x0052891e (15 code bytes)
# span:         0x0052890f-0x0052891e (code 15, tables 0, padding 0)
# sha256:       9cddc5ea6e2b3a9f7f5a6592fa87710fa87f4ce1add65b0a2844a4c839c2673e
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052890f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004ee99f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052891e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004ee99f, .text + (0x004ee99f - 0x401000)

.org 0x0052890f - 0x401000
.globl FUN_0052890f
FUN_0052890f:
    # block 0x0052890f: entry, 4 instruction(s), calls FUN_004ee99f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052890f
    add ecx, 0x57e                               # 00528912
    call FUN_004ee99f                            # 00528918
    ret                                          # 0052891d

