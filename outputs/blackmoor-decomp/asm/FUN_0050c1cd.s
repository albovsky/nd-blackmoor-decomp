# FUN_0050c1cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c1cd
# extent:       0x0050c1cd-0x0050c1d5 (8 code bytes)
# span:         0x0050c1cd-0x0050c1d5 (code 8, tables 0, padding 0)
# sha256:       710f00fb08bd993f1b5d0de6b3ec5702bf88071aed3098b658ae509cc51b1e91
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c1b4 (+0x19)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c1cd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0050c1d5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c4, 0xc4  # offset +0xc4

# --- external targets -----------------------------------------------

.org 0x0050c1cd - 0x401000
.globl FUN_0050c1cd
FUN_0050c1cd:
    # block 0x0050c1cd: entry, 2 instruction(s), ends with indirect jump dword ptr [eax + 0xc4]
    mov eax, dword ptr [ecx]                     # 0050c1cd
    jmp dword ptr [eax + field_c4]               # 0050c1cf

