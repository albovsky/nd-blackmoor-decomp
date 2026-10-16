# FUN_0051d44b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d44b
# extent:       0x0051d44b-0x0051d462 (23 code bytes)
# span:         0x0051d44b-0x0051d462 (code 23, tables 0, padding 0)
# sha256:       591358b4c2e8bf2188ed166518b1150db5cf8460980d185eb4b571d4b61fe6bf
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051d43c (+0xf)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d44b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_54; [ecx + n] field_34; [esp + n] stk_c
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_34, 0x34  # offset +0x34
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------

.org 0x0051d44b - 0x401000
.globl FUN_0051d44b
FUN_0051d44b:
    # block 0x0051d44b: entry, 7 instruction(s), calls indirect dword ptr [eax + 0x54], ends with ret 0xc
    push dword ptr [esp + stk_c]                 # 0051d44b
    mov ecx, dword ptr [ecx + field_34]          # 0051d44f
    push dword ptr [esp + stk_c]                 # 0051d452
    mov eax, dword ptr [ecx]                     # 0051d456
    push dword ptr [esp + stk_c]                 # 0051d458
    call dword ptr [eax + field_54]              # 0051d45c
    ret 0xc                                      # 0051d45f

