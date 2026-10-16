# FUN_0051b403
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b403
# extent:       0x0051b403-0x0051b414 (17 code bytes)
# span:         0x0051b403-0x0051b414 (code 17, tables 0, padding 0)
# sha256:       972a6225c7ac642e265659c2698766a0a8bf7326b0408a2aead170c1436e09b6
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051b2f1 (+0x112)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b403
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_58, field_a4; [ecx + n] field_1c
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_58, 0x58  # offset +0x58
.equ field_a4, 0xa4  # offset +0xa4

# --- external targets -----------------------------------------------

.org 0x0051b403 - 0x401000
.globl FUN_0051b403
FUN_0051b403:
    # block 0x0051b403: entry, 3 instruction(s), ends with je to 0x0051b40e (forward)
    cmp dword ptr [ecx + field_1c], 0x0          # 0051b403
    mov eax, dword ptr [ecx]                     # 0051b407
    je.d8 L_0051b40e                             # 0051b409
    # block 0x0051b40b: entered by fall-through of je at 0x0051b409, 1 instruction(s), ends with indirect jump dword ptr [eax + 0x58]
    jmp dword ptr [eax + field_58]               # 0051b40b
L_0051b40e:
    # block 0x0051b40e: entered by je at 0x0051b409, 1 instruction(s), ends with indirect jump dword ptr [eax + 0xa4]
    jmp dword ptr [eax + field_a4]               # 0051b40e

