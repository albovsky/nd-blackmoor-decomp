# FUN_00528928
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528928
# extent:       0x00528928-0x00528937 (15 code bytes)
# span:         0x00528928-0x00528937 (code 15, tables 0, padding 0)
# sha256:       5838d8cb72d5385bed423006005aabf2eb7a62fe775327414ff8aa6fbc057f25
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528928
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004e1c83
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e1c83, .text + (0x004e1c83 - 0x401000)

.org 0x00528928 - 0x401000
.globl FUN_00528928
FUN_00528928:
    # block 0x00528928: entry, 4 instruction(s), calls FUN_004e1c83, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528928
    add ecx, 0x3ef                               # 0052892b
    call FUN_004e1c83                            # 00528931
    ret                                          # 00528936

