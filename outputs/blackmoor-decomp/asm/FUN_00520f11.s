# FUN_00520f11
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520f11
# extent:       0x00520f11-0x00520f4d (60 code bytes)
# span:         0x00520f11-0x00520f4d (code 60, tables 0, padding 0)
# sha256:       79f1313214eb781def68edb5db96268394008210e2b70a2f45d2752c9e2815c6
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520f11
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_8; [esi + n] field_1c; [esp + n] stk_14
# callees:      calls FUN_0051d540; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051d540, .text + (0x0051d540 - 0x401000)

.org 0x00520f11 - 0x401000
.globl FUN_00520f11
FUN_00520f11:
    # block 0x00520f11: entry, 18 instruction(s), calls indirect ebp, FUN_0051d540, ends with je to 0x00520f46 (forward)
    push ebx                                     # 00520f11
    push ebp                                     # 00520f12
    mov ebp, dword ptr [0x52a478]                # 00520f13
    push esi                                     # 00520f19
    push edi                                     # 00520f1a
    mov edi, dword ptr [esp + stk_14]            # 00520f1b
    {load} mov esi, ecx                          # 00520f1f
    push edi                                     # 00520f21
    push dword ptr [esi + field_1c]              # 00520f22
    call ebp                                     # 00520f25
    lea ebx, [edi + field_8]                     # 00520f27
    push ebx                                     # 00520f2a
    push dword ptr [esi + field_1c]              # 00520f2b
    call ebp                                     # 00520f2e
    {load} mov ecx, esi                          # 00520f30
    call FUN_0051d540                            # 00520f32
    test eax, 0x400000                           # 00520f37
    je.d8 L_00520f46                             # 00520f3c
    # block 0x00520f3e: entered by fall-through of je at 0x00520f3c, 4 instruction(s), falls into the block at 0x00520f46
    mov eax, dword ptr [edi]                     # 00520f3e
    mov ecx, dword ptr [ebx]                     # 00520f40
    mov dword ptr [edi], ecx                     # 00520f42
    mov dword ptr [ebx], eax                     # 00520f44
L_00520f46:
    # block 0x00520f46: entered by je at 0x00520f3c, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00520f46
    pop esi                                      # 00520f47
    pop ebp                                      # 00520f48
    pop ebx                                      # 00520f49
    ret 0x4                                      # 00520f4a

