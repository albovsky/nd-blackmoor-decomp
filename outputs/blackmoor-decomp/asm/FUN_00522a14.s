# FUN_00522a14
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522a14
# extent:       0x00522a14-0x00522a20 (12 code bytes)
# span:         0x00522a14-0x00522a20 (code 12, tables 0, padding 0)
# sha256:       7a6f54cf7f329a18f0079658508906edc55989370606754d21ad5edb6eb51888
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00522953 (+0xc1)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522a14
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00522a14 - 0x401000
.globl FUN_00522a14
FUN_00522a14:
    # block 0x00522a14: entry, 2 instruction(s), ends with je to 0x00522a1f (forward)
    test ecx, ecx                                # 00522a14
    je.d8 L_00522a1f                             # 00522a16
    # block 0x00522a18: entered by fall-through of je at 0x00522a16, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00522a1f
    mov eax, dword ptr [ecx]                     # 00522a18
    push 0x1                                     # 00522a1a
    call dword ptr [eax + field_4]               # 00522a1c
L_00522a1f:
    # block 0x00522a1f: entered by je at 0x00522a16, 1 instruction(s), ends with ret
    ret                                          # 00522a1f

