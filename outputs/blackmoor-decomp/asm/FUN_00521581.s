# FUN_00521581
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521581
# extent:       0x00521581-0x00521594 (19 code bytes)
# span:         0x00521581-0x00521594 (code 19, tables 0, padding 0)
# sha256:       164e8304d3ff421736f0409dc9fbcdb23bd8afd07a5fa655fc1e142cfd428c05
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00521522 (+0x5f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521581
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_20; [ecx + n] field_80
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00521594
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_20, 0x20  # offset +0x20
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------

.org 0x00521581 - 0x401000
.globl FUN_00521581
FUN_00521581:
    # block 0x00521581: entry, 3 instruction(s), ends with je to 0x00521590 (forward)
    mov ecx, dword ptr [ecx + field_80]          # 00521581
    test ecx, ecx                                # 00521587
    je.d8 L_00521590                             # 00521589
    # block 0x0052158b: entered by fall-through of je at 0x00521589, 2 instruction(s), ends with indirect jump dword ptr [eax + 0x20]
    mov eax, dword ptr [ecx]                     # 0052158b
    jmp dword ptr [eax + field_20]               # 0052158d
L_00521590:
    # block 0x00521590: entered by je at 0x00521589, 3 instruction(s), ends with ret
    push 0x1                                     # 00521590
    pop eax                                      # 00521592
    ret                                          # 00521593

