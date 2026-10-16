# FUN_0050c366
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c366
# extent:       0x0050c366-0x0050c382 (28 code bytes)
# span:         0x0050c366-0x0050c382 (code 28, tables 0, padding 0)
# sha256:       e3daaef834b0f6876877e08a5569ef63947ce44a1d09ce256c68d7da2ac76246
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c32e (+0x38)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c366
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_10
# callees:      calls USER32.dll!DrawTextA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050c366 - 0x401000
.globl FUN_0050c366
FUN_0050c366:
    # block 0x0050c366: entry, 7 instruction(s), calls USER32.dll!DrawTextA, ends with ret 0x10
    push dword ptr [esp + stk_10]                # 0050c366
    push dword ptr [esp + stk_10]                # 0050c36a
    push dword ptr [esp + stk_10]                # 0050c36e
    push dword ptr [esp + stk_10]                # 0050c372
    push dword ptr [ecx + field_4]               # 0050c376
    call dword ptr [0x52a3b0]                    # 0050c379
    ret 0x10                                     # 0050c37f

