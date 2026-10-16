# FUN_005289a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005289a9
# extent:       0x005289a9-0x005289c4 (27 code bytes)
# span:         0x005289a9-0x005289c4 (code 27, tables 0, padding 0)
# sha256:       5994ab3e9f8af20207d3ecb7fef08ee3dcc795c0e9f76ac85218f0e75b472322
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005289a9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0050cba8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005289c4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x005289a9 - 0x401000
.globl FUN_005289a9
FUN_005289a9:
    # block 0x005289a9: entry, 8 instruction(s), calls FUN_0050cba8, ends with ret
    push 0x4e1c83                                # 005289a9
    push 0x1a                                    # 005289ae
    push 0x18f                                   # 005289b0
    mov eax, dword ptr [ebp - field_minus_10]    # 005289b5
    add eax, 0x1ca2                              # 005289b8
    push eax                                     # 005289bd
    call FUN_0050cba8                            # 005289be
    ret                                          # 005289c3

