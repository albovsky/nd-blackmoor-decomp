# FUN_00515a64
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515a64
# extent:       0x00515a64-0x00515a7f (27 code bytes)
# span:         0x00515a64-0x00515a7f (code 27, tables 0, padding 0)
# sha256:       07f63551c8c6f5f134f917f80291e2945f4d929dbdc820994476d37dcf47da70
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515a64
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00515a64 - 0x401000
.globl FUN_00515a64
FUN_00515a64:
    # block 0x00515a64: entry, 3 instruction(s), ends with je to 0x00515a7c (forward)
    mov eax, dword ptr [0x63cc48]                # 00515a64
    test eax, eax                                # 00515a69
    je.d8 L_00515a7c                             # 00515a6b
    # block 0x00515a6d: entered by fall-through of je at 0x00515a6b, 5 instruction(s), calls indirect eax, ends with je to 0x00515a7c (forward)
    push dword ptr [esp + stk_4]                 # 00515a6d
    call eax                                     # 00515a71
    test eax, eax                                # 00515a73
    pop ecx                                      # 00515a75
    je.d8 L_00515a7c                             # 00515a76
    # block 0x00515a78: entered by fall-through of je at 0x00515a76, 3 instruction(s), ends with ret
    push 0x1                                     # 00515a78
    pop eax                                      # 00515a7a
    ret                                          # 00515a7b
L_00515a7c:
    # block 0x00515a7c: entered by je at 0x00515a6b; je at 0x00515a76, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00515a7c
    ret                                          # 00515a7e

