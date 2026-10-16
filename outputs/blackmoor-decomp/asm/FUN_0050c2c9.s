# FUN_0050c2c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c2c9
# extent:       0x0050c2c9-0x0050c2dd (20 code bytes)
# span:         0x0050c2c9-0x0050c2dd (code 20, tables 0, padding 0)
# sha256:       2cd041f6f9e7c6a1de8f239a4e738c63fb69ee6aab6a57ccc0a41569f9e31669
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c2a0 (+0x29)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c2c9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_8
# callees:      calls GDI32.dll!PtVisible
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050c2dd
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050c2c9 - 0x401000
.globl FUN_0050c2c9
FUN_0050c2c9:
    # block 0x0050c2c9: entry, 5 instruction(s), calls GDI32.dll!PtVisible, ends with ret 0x8
    push dword ptr [esp + stk_8]                 # 0050c2c9
    push dword ptr [esp + stk_8]                 # 0050c2cd
    push dword ptr [ecx + field_4]               # 0050c2d1
    call dword ptr [0x52a098]                    # 0050c2d4
    ret 0x8                                      # 0050c2da

