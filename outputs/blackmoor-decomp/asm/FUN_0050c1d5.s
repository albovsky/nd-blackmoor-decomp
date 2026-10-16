# FUN_0050c1d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c1d5
# extent:       0x0050c1d5-0x0050c1dd (8 code bytes)
# span:         0x0050c1d5-0x0050c1dd (code 8, tables 0, padding 0)
# sha256:       e17db871686b298c05930222f711e458a070410bd0972448e0e72cb4aa876b72
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c1b4 (+0x21)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c1d5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c8
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0050c1dd
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c8, 0xc8  # offset +0xc8

# --- external targets -----------------------------------------------

.org 0x0050c1d5 - 0x401000
.globl FUN_0050c1d5
FUN_0050c1d5:
    # block 0x0050c1d5: entry, 2 instruction(s), ends with indirect jump dword ptr [eax + 0xc8]
    mov eax, dword ptr [ecx]                     # 0050c1d5
    jmp dword ptr [eax + field_c8]               # 0050c1d7

