# FUN_00521594
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521594
# extent:       0x00521594-0x005215aa (22 code bytes)
# span:         0x00521594-0x005215aa (code 22, tables 0, padding 0)
# sha256:       08dae41c54a4a705963a8ed0f6c4bcfdb7b928e1b45911b6112bb783134575b6
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00521522 (+0x72)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521594
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ecx + n] field_a8; [esp + n] stk_4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005215aa
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_a8, 0xa8  # offset +0xa8

# --- external targets -----------------------------------------------

.org 0x00521594 - 0x401000
.globl FUN_00521594
FUN_00521594:
    # block 0x00521594: entry, 3 instruction(s), ends with je to 0x005215a7 (forward)
    mov ecx, dword ptr [ecx + field_a8]          # 00521594
    test ecx, ecx                                # 0052159a
    je.d8 L_005215a7                             # 0052159c
    # block 0x0052159e: entered by fall-through of je at 0x0052159c, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x005215a7
    mov eax, dword ptr [ecx]                     # 0052159e
    push dword ptr [esp + stk_4]                 # 005215a0
    call dword ptr [eax + field_4]               # 005215a4
L_005215a7:
    # block 0x005215a7: entered by je at 0x0052159c, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 005215a7

