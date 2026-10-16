# FUN_00520b68
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520b68
# extent:       0x00520b68-0x00520b99 (49 code bytes)
# span:         0x00520b68-0x00520b99 (code 49, tables 0, padding 0)
# sha256:       b81bf6d8a9b29ab87a9c4d72c47d4d600be40dbef0899fe5103db81e5ef642f6
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520b68
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00520b68 - 0x401000
.globl FUN_00520b68
FUN_00520b68:
    # block 0x00520b68: entry, 9 instruction(s), ends with je to 0x00520b81 (forward)
    push ebx                                     # 00520b68
    push esi                                     # 00520b69
    {load} mov esi, ecx                          # 00520b6a
    {load} xor ebx, ebx                          # 00520b6c
    push edi                                     # 00520b6e
    mov edi, dword ptr [0x52a068]                # 00520b6f
    mov eax, dword ptr [esi + field_8]           # 00520b75
    test eax, eax                                # 00520b78
    je.d8 L_00520b81                             # 00520b7a
    # block 0x00520b7c: entered by fall-through of je at 0x00520b7a, 3 instruction(s), calls indirect edi, falls into the block at 0x00520b81
    push eax                                     # 00520b7c
    call edi                                     # 00520b7d
    {load} mov ebx, eax                          # 00520b7f
L_00520b81:
    # block 0x00520b81: entered by je at 0x00520b7a, 3 instruction(s), ends with je to 0x00520b93 (forward)
    mov eax, dword ptr [esi + field_4]           # 00520b81
    cmp eax, dword ptr [esi + field_8]           # 00520b84
    je.d8 L_00520b93                             # 00520b87
    # block 0x00520b89: entered by fall-through of je at 0x00520b87, 4 instruction(s), calls indirect edi, ends with je to 0x00520b93 (forward)
    push eax                                     # 00520b89
    call edi                                     # 00520b8a
    test eax, eax                                # 00520b8c
    je.d8 L_00520b93                             # 00520b8e
    # block 0x00520b90: entered by fall-through of je at 0x00520b8e, 1 instruction(s), falls into the block at 0x00520b93
    or ebx, -0x1                                 # 00520b90
L_00520b93:
    # block 0x00520b93: entered by je at 0x00520b87; je at 0x00520b8e, 5 instruction(s), ends with ret
    pop edi                                      # 00520b93
    {load} mov eax, ebx                          # 00520b94
    pop esi                                      # 00520b96
    pop ebx                                      # 00520b97
    ret                                          # 00520b98

