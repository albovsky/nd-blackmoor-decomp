# FUN_005215aa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005215aa
# extent:       0x005215aa-0x005215bc (18 code bytes)
# span:         0x005215aa-0x005215bc (code 18, tables 0, padding 0)
# sha256:       0363616cd50e1e2c7446f96aa5ab464b07b2133dad4f27c8fb3796a340f1f514
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00521522 (+0x88)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005215aa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [ecx + n] field_80; [esp + n] stk_4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------

.org 0x005215aa - 0x401000
.globl FUN_005215aa
FUN_005215aa:
    # block 0x005215aa: entry, 5 instruction(s), calls indirect dword ptr [eax + 0x1c], ends with ret 0x4
    mov ecx, dword ptr [ecx + field_80]          # 005215aa
    push dword ptr [esp + stk_4]                 # 005215b0
    mov eax, dword ptr [ecx]                     # 005215b4
    call dword ptr [eax + field_1c]              # 005215b6
    ret 0x4                                      # 005215b9

