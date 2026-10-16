# FUN_0051ea75
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ea75
# extent:       0x0051ea75-0x0051eac4 (79 code bytes)
# span:         0x0051ea75-0x0051eac4 (code 79, tables 0, padding 0)
# sha256:       6ea15976c02949015ef4a2c4700039802f66f7110ab072a22d2a52d4b5717e9d
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ea75
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4, field_minus_8, field_minus_c; [ebx + n] field_c; [edi + n] field_1; [esp + n] stk_c
# callees:      calls FUN_0051e627, FUN_0050fa90, FUN_0051e722
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:replace_response (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ field_1, 0x1  # offset +0x1
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051e627, .text + (0x0051e627 - 0x401000)
.set FUN_0051e722, .text + (0x0051e722 - 0x401000)

.org 0x0051ea75 - 0x401000
.globl FUN_0051ea75
FUN_0051ea75:
    # block 0x0051ea75: entry, 8 instruction(s), ends with jg to 0x0051ea8d (forward)
    push ebx                                     # 0051ea75
    push esi                                     # 0051ea76
    {load} mov esi, ecx                          # 0051ea77
    mov ecx, dword ptr [esp + stk_c]             # 0051ea79
    mov eax, dword ptr [esi]                     # 0051ea7d
    cmp dword ptr [eax - field_minus_c], 0x1     # 0051ea7f
    lea ebx, [eax - field_minus_c]               # 0051ea83
    jg.d8 L_0051ea8d                             # 0051ea86
    # block 0x0051ea88: entered by fall-through of jg at 0x0051ea86, 2 instruction(s), ends with jle to 0x0051eabd (forward)
    cmp ecx, dword ptr [eax - field_minus_4]     # 0051ea88
    jle.d8 L_0051eabd                            # 0051ea8b
L_0051ea8d:
    # block 0x0051ea8d: entered by jg at 0x0051ea86; fall-through of jle at 0x0051ea8b, 4 instruction(s), ends with jge to 0x0051ea97 (forward)
    push edi                                     # 0051ea8d
    mov edi, dword ptr [eax - field_minus_8]     # 0051ea8e
    {load} cmp ecx, edi                          # 0051ea91
    jge.d8 L_0051ea97                            # 0051ea93
    # block 0x0051ea95: entered by fall-through of jge at 0x0051ea93, 1 instruction(s), falls into the block at 0x0051ea97
    {load} mov ecx, edi                          # 0051ea95
L_0051ea97:
    # block 0x0051ea97: entered by jge at 0x0051ea93, 15 instruction(s), calls FUN_0051e627, FUN_0050fa90, FUN_0051e722, falls into the block at 0x0051eabd
    push ecx                                     # 0051ea97
    {load} mov ecx, esi                          # 0051ea98
    call FUN_0051e627                            # 0051ea9a
    lea eax, [edi + field_1]                     # 0051ea9f
    push eax                                     # 0051eaa2
    lea eax, [ebx + field_c]                     # 0051eaa3
    push eax                                     # 0051eaa6
    push dword ptr [esi]                         # 0051eaa7
    call FUN_0050fa90                            # 0051eaa9
    mov eax, dword ptr [esi]                     # 0051eaae
    add esp, 0xc                                 # 0051eab0
    push ebx                                     # 0051eab3
    mov dword ptr [eax - field_minus_8], edi     # 0051eab4
    call FUN_0051e722                            # 0051eab7
    pop edi                                      # 0051eabc
L_0051eabd:
    # block 0x0051eabd: entered by jle at 0x0051ea8b, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [esi]                     # 0051eabd
    pop esi                                      # 0051eabf
    pop ebx                                      # 0051eac0
    ret 0x4                                      # 0051eac1

