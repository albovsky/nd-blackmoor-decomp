# FUN_00528790
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528790
# extent:       0x00528790-0x0052879b (11 code bytes)
# span:         0x00528790-0x0052879b (code 11, tables 0, padding 0)
# sha256:       0a69a1c3a3ce763a3ee72f81add42e83328732a184ea8b5b71f2e0fe1517a04b
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528790
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_20
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052879b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_20, 0x20  # offset -0x20

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00528790 - 0x401000
.globl FUN_00528790
FUN_00528790:
    # block 0x00528790: entry, 5 instruction(s), calls FUN_0051dc6c, ends with ret
    mov eax, dword ptr [ebp - field_minus_20]    # 00528790
    push eax                                     # 00528793
    call FUN_0051dc6c                            # 00528794
    pop ecx                                      # 00528799
    ret                                          # 0052879a

