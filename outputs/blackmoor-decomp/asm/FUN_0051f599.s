# FUN_0051f599
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f599
# extent:       0x0051f599-0x0051f5ab (18 code bytes)
# span:         0x0051f599-0x0051f5ab (code 18, tables 0, padding 0)
# sha256:       5457d910947f8a7ca3b0f82e29ad5f4ca83a0d2dbd000f21fc45a72094b797b9
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f599
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0051f611; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051f611, .text + (0x0051f611 - 0x401000)

.org 0x0051f599 - 0x401000
.globl FUN_0051f599
FUN_0051f599:
    # block 0x0051f599: entry, 6 instruction(s), calls indirect dword ptr [eax], FUN_0051f611, ends with ret 0x4
    mov eax, dword ptr [ecx]                     # 0051f599
    call dword ptr [eax]                         # 0051f59b
    push dword ptr [esp + stk_4]                 # 0051f59d
    {load} mov ecx, eax                          # 0051f5a1
    call FUN_0051f611                            # 0051f5a3
    ret 0x4                                      # 0051f5a8

