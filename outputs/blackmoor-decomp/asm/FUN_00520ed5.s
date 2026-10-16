# FUN_00520ed5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520ed5
# extent:       0x00520ed5-0x00520f11 (60 code bytes)
# span:         0x00520ed5-0x00520f11 (code 60, tables 0, padding 0)
# sha256:       834efac5979bcc6d5010ee21e880a5c0174eceebb6265338ac8ad50145f1b572
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520ed5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_8; [esi + n] field_1c; [esp + n] stk_14
# callees:      calls FUN_0051d540; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051d540, .text + (0x0051d540 - 0x401000)

.org 0x00520ed5 - 0x401000
.globl FUN_00520ed5
FUN_00520ed5:
    # block 0x00520ed5: entry, 18 instruction(s), calls indirect ebp, FUN_0051d540, ends with je to 0x00520f0a (forward)
    push ebx                                     # 00520ed5
    push ebp                                     # 00520ed6
    mov ebp, dword ptr [0x52a47c]                # 00520ed7
    push esi                                     # 00520edd
    push edi                                     # 00520ede
    mov edi, dword ptr [esp + stk_14]            # 00520edf
    {load} mov esi, ecx                          # 00520ee3
    push edi                                     # 00520ee5
    push dword ptr [esi + field_1c]              # 00520ee6
    call ebp                                     # 00520ee9
    lea ebx, [edi + field_8]                     # 00520eeb
    push ebx                                     # 00520eee
    push dword ptr [esi + field_1c]              # 00520eef
    call ebp                                     # 00520ef2
    {load} mov ecx, esi                          # 00520ef4
    call FUN_0051d540                            # 00520ef6
    test eax, 0x400000                           # 00520efb
    je.d8 L_00520f0a                             # 00520f00
    # block 0x00520f02: entered by fall-through of je at 0x00520f00, 4 instruction(s), falls into the block at 0x00520f0a
    mov eax, dword ptr [edi]                     # 00520f02
    mov ecx, dword ptr [ebx]                     # 00520f04
    mov dword ptr [edi], ecx                     # 00520f06
    mov dword ptr [ebx], eax                     # 00520f08
L_00520f0a:
    # block 0x00520f0a: entered by je at 0x00520f00, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00520f0a
    pop esi                                      # 00520f0b
    pop ebp                                      # 00520f0c
    pop ebx                                      # 00520f0d
    ret 0x4                                      # 00520f0e

