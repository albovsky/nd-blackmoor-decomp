# FUN_0051ee80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ee80
# extent:       0x0051ee80-0x0051eeff (127 code bytes)
# span:         0x0051ee80-0x0051eeff (code 127, tables 0, padding 0)
# sha256:       a8d2f74fbb8adacba70f242ca1610e7dc3e522872e80ee255550e3279dfc425f
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ee80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_5c, field_64, field_68; [edx + n] field_60; [esi + n] field_30; [esp + n] stk_10, stk_14
# callees:      calls USER32.dll!PeekMessageA; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051eeff
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_30, 0x30  # offset +0x30
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------

.org 0x0051ee80 - 0x401000
.globl FUN_0051ee80
FUN_0051ee80:
    # block 0x0051ee80: entry, 10 instruction(s), falls into the block at 0x0051ee90
    push ecx                                     # 0051ee80
    push ebx                                     # 0051ee81
    push ebp                                     # 0051ee82
    push esi                                     # 0051ee83
    push edi                                     # 0051ee84
    push 0x1                                     # 0051ee85
    {load} xor ebx, ebx                          # 0051ee87
    {load} mov esi, ecx                          # 0051ee89
    pop edi                                      # 0051ee8b
    mov dword ptr [esp + stk_10], ebx            # 0051ee8c
L_0051ee90:
    # block 0x0051ee90: entered by jmp at 0x0051eef0, 2 instruction(s), ends with je to 0x0051eec0 (forward)
    {load} cmp edi, ebx                          # 0051ee90
    je.d8 L_0051eec0                             # 0051ee92
    # block 0x0051ee94: entered by fall-through of je at 0x0051ee92, 1 instruction(s), falls into the block at 0x0051ee97
    lea ebp, [esi + field_30]                    # 0051ee94
L_0051ee97:
    # block 0x0051ee97: entered by jne at 0x0051eebe, 8 instruction(s), calls USER32.dll!PeekMessageA, ends with jne to 0x0051eec0 (forward)
    push ebx                                     # 0051ee97
    push ebx                                     # 0051ee98
    push ebx                                     # 0051ee99
    push ebx                                     # 0051ee9a
    push ebp                                     # 0051ee9b
    call dword ptr [0x52a4c0]                    # 0051ee9c
    test eax, eax                                # 0051eea2
    jne.d8 L_0051eec0                            # 0051eea4
    # block 0x0051eea6: entered by fall-through of jne at 0x0051eea4, 8 instruction(s), calls indirect dword ptr [edx + 0x60], ends with jne to 0x0051eebc (forward)
    mov eax, dword ptr [esp + stk_10]            # 0051eea6
    mov edx, dword ptr [esi]                     # 0051eeaa
    inc dword ptr [esp + stk_10]                 # 0051eeac
    push eax                                     # 0051eeb0
    {load} mov ecx, esi                          # 0051eeb1
    call dword ptr [edx + field_60]              # 0051eeb3
    test eax, eax                                # 0051eeb6
    jne.d8 L_0051eebc                            # 0051eeb8
    # block 0x0051eeba: entered by fall-through of jne at 0x0051eeb8, 1 instruction(s), falls into the block at 0x0051eebc
    {load} xor edi, edi                          # 0051eeba
L_0051eebc:
    # block 0x0051eebc: entered by jne at 0x0051eeb8, 2 instruction(s), ends with jne to 0x0051ee97 (backward)
    {load} cmp edi, ebx                          # 0051eebc
    jne.d8 L_0051ee97                            # 0051eebe
L_0051eec0:
    # block 0x0051eec0: entered by je at 0x0051ee92; jne at 0x0051eea4; jne at 0x0051eeee; fall-through of jne at 0x0051eebe, 5 instruction(s), calls indirect dword ptr [eax + 0x5c], ends with je to 0x0051eef2 (forward)
    mov eax, dword ptr [esi]                     # 0051eec0
    {load} mov ecx, esi                          # 0051eec2
    call dword ptr [eax + field_5c]              # 0051eec4
    test eax, eax                                # 0051eec7
    je.d8 L_0051eef2                             # 0051eec9
    # block 0x0051eecb: entered by fall-through of je at 0x0051eec9, 7 instruction(s), calls indirect dword ptr [eax + 0x64], ends with je to 0x0051eee1 (forward)
    mov eax, dword ptr [esi]                     # 0051eecb
    lea ebp, [esi + field_30]                    # 0051eecd
    push ebp                                     # 0051eed0
    {load} mov ecx, esi                          # 0051eed1
    call dword ptr [eax + field_64]              # 0051eed3
    test eax, eax                                # 0051eed6
    je.d8 L_0051eee1                             # 0051eed8
    # block 0x0051eeda: entered by fall-through of je at 0x0051eed8, 3 instruction(s), falls into the block at 0x0051eee1
    push 0x1                                     # 0051eeda
    mov dword ptr [esp + stk_14], ebx            # 0051eedc
    pop edi                                      # 0051eee0
L_0051eee1:
    # block 0x0051eee1: entered by je at 0x0051eed8, 8 instruction(s), calls USER32.dll!PeekMessageA, ends with jne to 0x0051eec0 (backward)
    push ebx                                     # 0051eee1
    push ebx                                     # 0051eee2
    push ebx                                     # 0051eee3
    push ebx                                     # 0051eee4
    push ebp                                     # 0051eee5
    call dword ptr [0x52a4c0]                    # 0051eee6
    test eax, eax                                # 0051eeec
    jne.d8 L_0051eec0                            # 0051eeee
    # block 0x0051eef0: entered by fall-through of jne at 0x0051eeee, 1 instruction(s), ends with backward jump to 0x0051ee90
    jmp.d8 L_0051ee90                            # 0051eef0
L_0051eef2:
    # block 0x0051eef2: entered by je at 0x0051eec9, 9 instruction(s), calls indirect dword ptr [eax + 0x68], ends with ret
    mov eax, dword ptr [esi]                     # 0051eef2
    {load} mov ecx, esi                          # 0051eef4
    call dword ptr [eax + field_68]              # 0051eef6
    pop edi                                      # 0051eef9
    pop esi                                      # 0051eefa
    pop ebp                                      # 0051eefb
    pop ebx                                      # 0051eefc
    pop ecx                                      # 0051eefd
    ret                                          # 0051eefe

