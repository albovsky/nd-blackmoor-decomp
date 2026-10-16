# FUN_005215d2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005215d2
# extent:       0x005215d2-0x005215f4 (34 code bytes)
# span:         0x005215d2-0x005215f4 (code 34, tables 0, padding 0)
# sha256:       a831b28853f53a075b5e1beee0b4146d72355b4701c2061085b986f1600cdba3
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005215bc (+0x16)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005215d2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8; [ecx + n] field_a8; [esp + n] stk_4
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005215f4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_a8, 0xa8  # offset +0xa8

# --- external targets -----------------------------------------------

.org 0x005215d2 - 0x401000
.globl FUN_005215d2
FUN_005215d2:
    # block 0x005215d2: entry, 3 instruction(s), ends with jne to 0x005215e8 (forward)
    mov ecx, dword ptr [ecx + field_a8]          # 005215d2
    test ecx, ecx                                # 005215d8
    jne.d8 L_005215e8                            # 005215da
    # block 0x005215dc: entered by fall-through of jne at 0x005215da, 5 instruction(s), calls indirect dword ptr [eax], ends with forward jump to 0x005215f1
    mov ecx, dword ptr [esp + stk_4]             # 005215dc
    push 0x0                                     # 005215e0
    mov eax, dword ptr [ecx]                     # 005215e2
    call dword ptr [eax]                         # 005215e4
    jmp.d8 L_005215f1                            # 005215e6
L_005215e8:
    # block 0x005215e8: entered by jne at 0x005215da, 3 instruction(s), calls indirect dword ptr [eax + 0x8], falls into the block at 0x005215f1
    mov eax, dword ptr [ecx]                     # 005215e8
    push dword ptr [esp + stk_4]                 # 005215ea
    call dword ptr [eax + field_8]               # 005215ee
L_005215f1:
    # block 0x005215f1: entered by jmp at 0x005215e6, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 005215f1

