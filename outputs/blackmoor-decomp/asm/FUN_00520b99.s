# FUN_00520b99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520b99
# extent:       0x00520b99-0x00520bd7 (62 code bytes)
# span:         0x00520b99-0x00520bd7 (code 62, tables 0, padding 0)
# sha256:       3c2dbeadc4e2dc8f519a82498274ac43eceb32d82482bb4b0fee267c1d015e43
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520b99
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8; [esp + n] stk_c
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00520b99 - 0x401000
.globl FUN_00520b99
FUN_00520b99:
    # block 0x00520b99: entry, 9 instruction(s), ends with je to 0x00520bb5 (forward)
    push esi                                     # 00520b99
    {load} mov esi, ecx                          # 00520b9a
    push edi                                     # 00520b9c
    mov edi, dword ptr [0x52a06c]                # 00520b9d
    mov ecx, dword ptr [esi + field_4]           # 00520ba3
    push 0x1                                     # 00520ba6
    cmp ecx, dword ptr [esi + field_8]           # 00520ba8
    pop eax                                      # 00520bab
    je.d8 L_00520bb5                             # 00520bac
    # block 0x00520bae: entered by fall-through of je at 0x00520bac, 3 instruction(s), calls indirect edi, falls into the block at 0x00520bb5
    push dword ptr [esp + stk_c]                 # 00520bae
    push ecx                                     # 00520bb2
    call edi                                     # 00520bb3
L_00520bb5:
    # block 0x00520bb5: entered by je at 0x00520bac, 3 instruction(s), ends with je to 0x00520bd2 (forward)
    mov esi, dword ptr [esi + field_8]           # 00520bb5
    test esi, esi                                # 00520bb8
    je.d8 L_00520bd2                             # 00520bba
    # block 0x00520bbc: entered by fall-through of je at 0x00520bba, 2 instruction(s), ends with je to 0x00520bd0 (forward)
    test eax, eax                                # 00520bbc
    je.d8 L_00520bd0                             # 00520bbe
    # block 0x00520bc0: entered by fall-through of je at 0x00520bbe, 5 instruction(s), calls indirect edi, ends with je to 0x00520bd0 (forward)
    push dword ptr [esp + stk_c]                 # 00520bc0
    push esi                                     # 00520bc4
    call edi                                     # 00520bc5
    test eax, eax                                # 00520bc7
    je.d8 L_00520bd0                             # 00520bc9
    # block 0x00520bcb: entered by fall-through of je at 0x00520bc9, 3 instruction(s), ends with forward jump to 0x00520bd2
    push 0x1                                     # 00520bcb
    pop eax                                      # 00520bcd
    jmp.d8 L_00520bd2                            # 00520bce
L_00520bd0:
    # block 0x00520bd0: entered by je at 0x00520bbe; je at 0x00520bc9, 1 instruction(s), falls into the block at 0x00520bd2
    {load} xor eax, eax                          # 00520bd0
L_00520bd2:
    # block 0x00520bd2: entered by je at 0x00520bba; jmp at 0x00520bce, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 00520bd2
    pop esi                                      # 00520bd3
    ret 0x4                                      # 00520bd4

