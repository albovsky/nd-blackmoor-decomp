# FUN_00522af2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522af2
# extent:       0x00522af2-0x00522b4a (88 code bytes)
# span:         0x00522af2-0x00522b4a (code 88, tables 0, padding 0)
# sha256:       32e3433ce0cccbecbdb9871a469acb8bbcdae4fcfc15a1c63bd785bcf07cc9dd
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522af2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [edi + n] field_8c, field_90; [edx + n] field_98; [esp + n] stk_c
# callees:      calls FUN_0051d373, FUN_00525371; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00522b4a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_98, 0x98  # offset +0x98

# --- external targets -----------------------------------------------
.set FUN_0051d373, .text + (0x0051d373 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00522af2 - 0x401000
.globl FUN_00522af2
FUN_00522af2:
    # block 0x00522af2: entry, 6 instruction(s), ends with jne to 0x00522b25 (forward)
    push esi                                     # 00522af2
    mov esi, dword ptr [esp + stk_c]             # 00522af3
    push edi                                     # 00522af7
    {load} mov edi, ecx                          # 00522af8
    test esi, esi                                # 00522afa
    jne.d8 L_00522b25                            # 00522afc
    # block 0x00522afe: entered by fall-through of jne at 0x00522afc, 3 instruction(s), calls FUN_0051d373, ends with je to 0x00522b15 (forward)
    call FUN_0051d373                            # 00522afe
    test eax, eax                                # 00522b03
    je.d8 L_00522b15                             # 00522b05
    # block 0x00522b07: entered by fall-through of je at 0x00522b05, 3 instruction(s), ends with forward jump to 0x00522b21
    mov esi, dword ptr [edi + field_90]          # 00522b07
    add esi, 0x10000                             # 00522b0d
    jmp.d8 L_00522b21                            # 00522b13
L_00522b15:
    # block 0x00522b15: entered by je at 0x00522b05, 2 instruction(s), falls into the block at 0x00522b21
    mov esi, dword ptr [edi + field_8c]          # 00522b15
    add esi, 0x20000                             # 00522b1b
L_00522b21:
    # block 0x00522b21: entered by jmp at 0x00522b13, 2 instruction(s), ends with je to 0x00522b43 (forward)
    test esi, esi                                # 00522b21
    je.d8 L_00522b43                             # 00522b23
L_00522b25:
    # block 0x00522b25: entered by jne at 0x00522afc; fall-through of je at 0x00522b23, 4 instruction(s), calls FUN_00525371, ends with je to 0x00522b3e (forward)
    call FUN_00525371                            # 00522b25
    mov eax, dword ptr [eax + field_4]           # 00522b2a
    test eax, eax                                # 00522b2d
    je.d8 L_00522b3e                             # 00522b2f
    # block 0x00522b31: entered by fall-through of je at 0x00522b2f, 5 instruction(s), calls indirect dword ptr [edx + 0x98], falls into the block at 0x00522b3e
    mov edx, dword ptr [eax]                     # 00522b31
    push 0x1                                     # 00522b33
    push esi                                     # 00522b35
    {load} mov ecx, eax                          # 00522b36
    call dword ptr [edx + field_98]              # 00522b38
L_00522b3e:
    # block 0x00522b3e: entered by je at 0x00522b2f, 3 instruction(s), ends with forward jump to 0x00522b45
    push 0x1                                     # 00522b3e
    pop eax                                      # 00522b40
    jmp.d8 L_00522b45                            # 00522b41
L_00522b43:
    # block 0x00522b43: entered by je at 0x00522b23, 1 instruction(s), falls into the block at 0x00522b45
    {load} xor eax, eax                          # 00522b43
L_00522b45:
    # block 0x00522b45: entered by jmp at 0x00522b41, 3 instruction(s), ends with ret 0x8
    pop edi                                      # 00522b45
    pop esi                                      # 00522b46
    ret 0x8                                      # 00522b47

