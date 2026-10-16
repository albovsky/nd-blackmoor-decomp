# FUN_00523970
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523970
# extent:       0x00523970-0x0052398b (27 code bytes)
# span:         0x00523970-0x0052398b (code 27, tables 0, padding 0)
# sha256:       521f6168ccb3039de0be05fba58596ee62756fae601b4f206e047fb4f4b3f006
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005238d5 (+0x9b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523970
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c; [esp + n] stk_8, stk_10
# callees:      calls USER32.dll!PostMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x00523970 - 0x401000
.globl FUN_00523970
FUN_00523970:
    # block 0x00523970: entry, 7 instruction(s), calls USER32.dll!PostMessageA, ends with ret 0x8
    push dword ptr [esp + stk_8]                 # 00523970
    push dword ptr [ecx + field_1c]              # 00523974
    push 0x3e1                                   # 00523977
    push dword ptr [esp + stk_10]                # 0052397c
    call dword ptr [0x52a31c]                    # 00523980
    {load} xor eax, eax                          # 00523986
    ret 0x8                                      # 00523988

