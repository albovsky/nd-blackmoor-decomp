# FUN_0051f636
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f636
# extent:       0x0051f636-0x0051f648 (18 code bytes)
# span:         0x0051f636-0x0051f648 (code 18, tables 0, padding 0)
# sha256:       7431e270e36d838ac9a25032468af47ae3a0d09f0943fd7b359618dcf6ae51d8
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f636
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ecx + n] field_4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0051f636 - 0x401000
.globl FUN_0051f636
FUN_0051f636:
    # block 0x0051f636: entry, 2 instruction(s), ends with jle to 0x0051f647 (forward)
    cmp dword ptr [ecx + field_4], 0x0           # 0051f636
    jle.d8 L_0051f647                            # 0051f63a
    # block 0x0051f63c: entered by fall-through of jle at 0x0051f63a, 2 instruction(s), ends with je to 0x0051f647 (forward)
    test ecx, ecx                                # 0051f63c
    je.d8 L_0051f647                             # 0051f63e
    # block 0x0051f640: entered by fall-through of je at 0x0051f63e, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x0051f647
    mov eax, dword ptr [ecx]                     # 0051f640
    push 0x1                                     # 0051f642
    call dword ptr [eax + field_4]               # 0051f644
L_0051f647:
    # block 0x0051f647: entered by jle at 0x0051f63a; je at 0x0051f63e, 1 instruction(s), ends with ret
    ret                                          # 0051f647

