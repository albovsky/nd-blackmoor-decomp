# FUN_00523fe6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523fe6
# extent:       0x00523fe6-0x0052401f (57 code bytes)
# span:         0x00523fe6-0x0052401f (code 57, tables 0, padding 0)
# sha256:       8d02ee85fea78174684b4971aa73719e75e4d1d2525f47dcde51d96af0a02df8
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00523ef2 (+0xf4)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523fe6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_00523f7d, FUN_0051d526, FUN_005239bd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_005239bd, .text + (0x005239bd - 0x401000)
.set FUN_00523f7d, .text + (0x00523f7d - 0x401000)

.org 0x00523fe6 - 0x401000
.globl FUN_00523fe6
FUN_00523fe6:
    # block 0x00523fe6: entry, 8 instruction(s), calls FUN_00523f7d, ends with je to 0x00524018 (forward)
    push esi                                     # 00523fe6
    push edi                                     # 00523fe7
    push dword ptr [esp + stk_c]                 # 00523fe8
    {load} mov edi, ecx                          # 00523fec
    call FUN_00523f7d                            # 00523fee
    {load} mov esi, eax                          # 00523ff3
    test esi, esi                                # 00523ff5
    je.d8 L_00524018                             # 00523ff7
    # block 0x00523ff9: entered by fall-through of je at 0x00523ff7, 13 instruction(s), calls FUN_0051d526, FUN_005239bd, ends with forward jump to 0x0052401a
    push 0x0                                     # 00523ff9
    {load} mov ecx, esi                          # 00523ffb
    call FUN_0051d526                            # 00523ffd
    not eax                                      # 00524002
    shr eax, 0x1c                                # 00524004
    and eax, 0x1                                 # 00524007
    {load} mov ecx, edi                          # 0052400a
    push eax                                     # 0052400c
    push esi                                     # 0052400d
    call FUN_005239bd                            # 0052400e
    push 0x1                                     # 00524013
    pop eax                                      # 00524015
    jmp.d8 L_0052401a                            # 00524016
L_00524018:
    # block 0x00524018: entered by je at 0x00523ff7, 1 instruction(s), falls into the block at 0x0052401a
    {load} xor eax, eax                          # 00524018
L_0052401a:
    # block 0x0052401a: entered by jmp at 0x00524016, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0052401a
    pop esi                                      # 0052401b
    ret 0x4                                      # 0052401c

