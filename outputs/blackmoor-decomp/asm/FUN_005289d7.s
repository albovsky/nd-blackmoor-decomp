# FUN_005289d7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005289d7
# extent:       0x005289d7-0x005289f2 (27 code bytes)
# span:         0x005289d7-0x005289f2 (code 27, tables 0, padding 0)
# sha256:       28f40d6f552d6055bb181eadd6d4a4c15668c980355c0e604d1e3524791167a0
# evidence:     ev_1c49ee683c41b8d08be97ebfd78da204c088477a53f31c5eaf5747d764ad29f8
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005289d7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0050cba8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005289f2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x005289d7 - 0x401000
.globl FUN_005289d7
FUN_005289d7:
    # block 0x005289d7: entry, 8 instruction(s), calls FUN_0050cba8, ends with ret
    push 0x4e1c83                                # 005289d7
    push 0x1a                                    # 005289dc
    push 0x18f                                   # 005289de
    mov eax, dword ptr [ebp - field_minus_10]    # 005289e3
    add eax, 0x1ca2                              # 005289e6
    push eax                                     # 005289eb
    call FUN_0050cba8                            # 005289ec
    ret                                          # 005289f1

