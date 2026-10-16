# FUN_00528730
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528730
# extent:       0x00528730-0x0052873a (10 code bytes)
# span:         0x00528730-0x0052873a (code 10, tables 0, padding 0)
# sha256:       c0fdeebff33f42322cf6e149dd08c070079894b3220f06ae1ac3f919ff1d9327
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528730
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052873a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00528730 - 0x401000
.globl FUN_00528730
FUN_00528730:
    # block 0x00528730: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 00528730
    push eax                                     # 00528733
    call FUN_00401c90                            # 00528734
    ret                                          # 00528739

