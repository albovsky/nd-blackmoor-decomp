# FUN_0050cd43
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cd43
# extent:       0x0050cd43-0x0050cd50 (13 code bytes)
# span:         0x0050cd43-0x0050cd50 (code 13, tables 0, padding 0)
# sha256:       3dda0c6059f85703ba5a756121b19e9c39fb81c96efe658c9a711a6e52371e19
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cd43
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14; [esp + n] stk_4
# callees:      calls FUN_00510dd3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)

.org 0x0050cd43 - 0x401000
.globl FUN_0050cd43
FUN_0050cd43:
    # block 0x0050cd43: entry, 4 instruction(s), calls FUN_00510dd3, ends with ret
    call FUN_00510dd3                            # 0050cd43
    mov ecx, dword ptr [esp + stk_4]             # 0050cd48
    mov dword ptr [eax + field_14], ecx          # 0050cd4c
    ret                                          # 0050cd4f

