# FUN_005288ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005288ba
# extent:       0x005288ba-0x005288c5 (11 code bytes)
# span:         0x005288ba-0x005288c5 (code 11, tables 0, padding 0)
# sha256:       a95055f9972f4895a5f869cac35c9ddf555d6922679f9f75277bcd0540ca8733
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005288ba
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005288c5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x005288ba - 0x401000
.globl FUN_005288ba
FUN_005288ba:
    # block 0x005288ba: entry, 5 instruction(s), calls FUN_0051dc6c, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 005288ba
    push eax                                     # 005288bd
    call FUN_0051dc6c                            # 005288be
    pop ecx                                      # 005288c3
    ret                                          # 005288c4

