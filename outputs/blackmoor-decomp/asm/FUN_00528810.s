# FUN_00528810
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528810
# extent:       0x00528810-0x0052881a (10 code bytes)
# span:         0x00528810-0x0052881a (code 10, tables 0, padding 0)
# sha256:       fcb413799d308f91faeb9d82c69c546c75816f6c045f889300c9a113659dc158
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528810
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052881a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00528810 - 0x401000
.globl FUN_00528810
FUN_00528810:
    # block 0x00528810: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 00528810
    push eax                                     # 00528813
    call FUN_00401c90                            # 00528814
    ret                                          # 00528819

