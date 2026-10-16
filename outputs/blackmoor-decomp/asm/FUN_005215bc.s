# FUN_005215bc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005215bc
# extent:       0x005215bc-0x005215d2 (22 code bytes)
# span:         0x005215bc-0x005215d2 (code 22, tables 0, padding 0)
# sha256:       5268226d53f1d0897dbe3723c5dd3453c0e372424e75a7851f3f528a1ca1c9a0
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005215bc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_24; [ecx + n] field_80; [esp + n] stk_4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005215d2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_24, 0x24  # offset +0x24
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------

.org 0x005215bc - 0x401000
.globl FUN_005215bc
FUN_005215bc:
    # block 0x005215bc: entry, 3 instruction(s), ends with je to 0x005215cf (forward)
    mov ecx, dword ptr [ecx + field_80]          # 005215bc
    test ecx, ecx                                # 005215c2
    je.d8 L_005215cf                             # 005215c4
    # block 0x005215c6: entered by fall-through of je at 0x005215c4, 3 instruction(s), calls indirect dword ptr [eax + 0x24], falls into the block at 0x005215cf
    mov eax, dword ptr [ecx]                     # 005215c6
    push dword ptr [esp + stk_4]                 # 005215c8
    call dword ptr [eax + field_24]              # 005215cc
L_005215cf:
    # block 0x005215cf: entered by je at 0x005215c4, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 005215cf

