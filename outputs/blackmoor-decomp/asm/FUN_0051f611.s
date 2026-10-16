# FUN_0051f611
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f611
# extent:       0x0051f611-0x0051f62a (25 code bytes)
# span:         0x0051f611-0x0051f62a (code 25, tables 0, padding 0)
# sha256:       16cef165f47ac2bf6df3ab47ddb78ef1db955a7ff4b2a2a92e5d64633b162d4f
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f611
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_10; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0051f611 - 0x401000
.globl FUN_0051f611
FUN_0051f611:
L_0051f611:
    # block 0x0051f611: entry, 2 instruction(s), ends with je to 0x0051f625 (forward)
    test ecx, ecx                                # 0051f611
    je.d8 L_0051f625                             # 0051f613
    # block 0x0051f615: entered by fall-through of je at 0x0051f613, 2 instruction(s), ends with je to 0x0051f620 (forward)
    cmp ecx, dword ptr [esp + stk_4]             # 0051f615
    je.d8 L_0051f620                             # 0051f619
    # block 0x0051f61b: entered by fall-through of je at 0x0051f619, 2 instruction(s), ends with backward jump to 0x0051f611
    mov ecx, dword ptr [ecx + field_10]          # 0051f61b
    jmp.d8 L_0051f611                            # 0051f61e
L_0051f620:
    # block 0x0051f620: entered by je at 0x0051f619, 3 instruction(s), ends with forward jump to 0x0051f627
    push 0x1                                     # 0051f620
    pop eax                                      # 0051f622
    jmp.d8 L_0051f627                            # 0051f623
L_0051f625:
    # block 0x0051f625: entered by je at 0x0051f613, 1 instruction(s), falls into the block at 0x0051f627
    {load} xor eax, eax                          # 0051f625
L_0051f627:
    # block 0x0051f627: entered by jmp at 0x0051f623, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051f627

