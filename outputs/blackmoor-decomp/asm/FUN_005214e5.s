# FUN_005214e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005214e5
# extent:       0x005214e5-0x005214f0 (11 code bytes)
# span:         0x005214e5-0x005214f0 (code 11, tables 0, padding 0)
# sha256:       a34f8c836561c92565442e357e37ea9072f396f86e3fbe71a0805c8e3211572b
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005214c9 (+0x1c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005214e5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_38; [ecx + n] field_80
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_38, 0x38  # offset +0x38
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------

.org 0x005214e5 - 0x401000
.globl FUN_005214e5
FUN_005214e5:
    # block 0x005214e5: entry, 3 instruction(s), ends with indirect jump dword ptr [eax + 0x38]
    mov ecx, dword ptr [ecx + field_80]          # 005214e5
    mov eax, dword ptr [ecx]                     # 005214eb
    jmp dword ptr [eax + field_38]               # 005214ed

