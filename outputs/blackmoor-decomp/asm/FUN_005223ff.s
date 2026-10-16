# FUN_005223ff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005223ff
# extent:       0x005223ff-0x00522419 (26 code bytes)
# span:         0x005223ff-0x00522419 (code 26, tables 0, padding 0)
# sha256:       6304c387b53cda55c40df4727141370b814f6e75aea380ad35ee39801bcadf0d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052233d (+0xc2)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005223ff
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_58; [ecx + n] field_2c, field_84
# callees:      calls tail jump FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00522419
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2c, 0x2c  # offset +0x2c
.equ field_58, 0x58  # offset +0x58
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x005223ff - 0x401000
.globl FUN_005223ff
FUN_005223ff:
    # block 0x005223ff: entry, 3 instruction(s), ends with je to 0x00522414 (forward)
    cmp dword ptr [ecx + field_84], 0x0          # 005223ff
    mov dword ptr [ecx + field_2c], 0x2          # 00522406
    je.d8 L_00522414                             # 0052240d
    # block 0x0052240f: entered by fall-through of je at 0x0052240d, 2 instruction(s), ends with indirect jump dword ptr [eax + 0x58]
    mov eax, dword ptr [ecx]                     # 0052240f
    jmp dword ptr [eax + field_58]               # 00522411
L_00522414:
    # block 0x00522414: entered by je at 0x0052240d, 1 instruction(s), ends with backward jump to 0x0051ab4b
    jmp.d32 FUN_0051ab4b                         # 00522414

