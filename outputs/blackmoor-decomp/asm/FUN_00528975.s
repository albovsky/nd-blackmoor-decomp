# FUN_00528975
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528975
# extent:       0x00528975-0x00528990 (27 code bytes)
# span:         0x00528975-0x00528990 (code 27, tables 0, padding 0)
# sha256:       e26d0380593a73088a4c7e38c2856a5e13f56e642ddca061edf1a5c42cc23781
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528975
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0050cba8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00528990
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x00528975 - 0x401000
.globl FUN_00528975
FUN_00528975:
    # block 0x00528975: entry, 8 instruction(s), calls FUN_0050cba8, ends with ret
    push 0x4e1c83                                # 00528975
    push 0x5                                     # 0052897a
    push 0x18f                                   # 0052897c
    mov eax, dword ptr [ebp - field_minus_10]    # 00528981
    add eax, 0x757                               # 00528984
    push eax                                     # 00528989
    call FUN_0050cba8                            # 0052898a
    ret                                          # 0052898f

