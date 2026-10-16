# FUN_0050c2dd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c2dd
# extent:       0x0050c2dd-0x0050c2ed (16 code bytes)
# span:         0x0050c2dd-0x0050c2ed (code 16, tables 0, padding 0)
# sha256:       09e13a7d075da3d1903f503c8efa3758bdca4ec4570099ab313859f23f2909b1
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c2a0 (+0x3d)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c2dd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4
# callees:      calls GDI32.dll!RectVisible
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050c2ed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0050c2dd - 0x401000
.globl FUN_0050c2dd
FUN_0050c2dd:
    # block 0x0050c2dd: entry, 4 instruction(s), calls GDI32.dll!RectVisible, ends with ret 0x4
    push dword ptr [esp + stk_4]                 # 0050c2dd
    push dword ptr [ecx + field_4]               # 0050c2e1
    call dword ptr [0x52a09c]                    # 0050c2e4
    ret 0x4                                      # 0050c2ea

