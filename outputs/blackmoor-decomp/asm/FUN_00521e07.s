# FUN_00521e07
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521e07
# extent:       0x00521e07-0x00521ed5 (206 code bytes)
# span:         0x00521e07-0x00521ed5 (code 206, tables 0, padding 0)
# sha256:       6a4f66b0a25cd5de3c818b2237b322c3b29ad3501dbdf29483e7d19d49362ade
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00521de7 (+0x20)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521e07
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_a0; [esi + n] field_1c; [esp + n] stk_10, stk_18, stk_1c
# callees:      calls FUN_00521de7, USER32.dll!IsWindowEnabled, FUN_0051ab4b, USER32.dll!GetFocus, USER32.dll!SetFocus; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_a0, 0xa0  # offset +0xa0

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_00521de7, .text + (0x00521de7 - 0x401000)

.org 0x00521e07 - 0x401000
.globl FUN_00521e07
FUN_00521e07:
    # block 0x00521e07: entry, 9 instruction(s), calls FUN_00521de7, ends with je to 0x00521e8b (forward)
    push ecx                                     # 00521e07
    push ebx                                     # 00521e08
    push ebp                                     # 00521e09
    push esi                                     # 00521e0a
    push edi                                     # 00521e0b
    {load} mov esi, ecx                          # 00521e0c
    call FUN_00521de7                            # 00521e0e
    test word ptr [eax + field_4], 0x2020        # 00521e13
    je.d8 L_00521e8b                             # 00521e19
    # block 0x00521e1b: entered by fall-through of je at 0x00521e19, 8 instruction(s), calls indirect edi, ends with je to 0x00521e4d (forward)
    push dword ptr [esp + stk_18]                # 00521e1b
    mov edi, dword ptr [0x52a404]                # 00521e1f
    push dword ptr [esi + field_1c]              # 00521e25
    call edi                                     # 00521e28
    mov ebp, dword ptr [0x52a454]                # 00521e2a
    {load} mov ebx, eax                          # 00521e30
    test ebx, ebx                                # 00521e32
    je.d8 L_00521e4d                             # 00521e34
    # block 0x00521e36: entered by fall-through of je at 0x00521e34, 5 instruction(s), calls indirect ebp, ends with je to 0x00521e4d (forward)
    push -0x10                                   # 00521e36
    push ebx                                     # 00521e38
    call ebp                                     # 00521e39
    test eax, 0x10000000                         # 00521e3b
    je.d8 L_00521e4d                             # 00521e40
    # block 0x00521e42: entered by fall-through of je at 0x00521e40, 4 instruction(s), calls USER32.dll!IsWindowEnabled, ends with jne to 0x00521e8b (forward)
    push ebx                                     # 00521e42
    call dword ptr [0x52a330]                    # 00521e43
    test eax, eax                                # 00521e49
    jne.d8 L_00521e8b                            # 00521e4b
L_00521e4d:
    # block 0x00521e4d: entered by je at 0x00521e34; je at 0x00521e40; fall-through of jne at 0x00521e4b, 2 instruction(s), falls into the block at 0x00521e57
    and dword ptr [esp + stk_18], 0x0            # 00521e4d
    mov ebx, 0x52eea8                            # 00521e52
L_00521e57:
    # block 0x00521e57: entered by jl at 0x00521e89, 9 instruction(s), calls indirect edi, indirect ebp, ends with je to 0x00521e7c (forward)
    push dword ptr [ebx]                         # 00521e57
    push dword ptr [esi + field_1c]              # 00521e59
    call edi                                     # 00521e5c
    push -0x10                                   # 00521e5e
    push eax                                     # 00521e60
    mov dword ptr [esp + stk_18], eax            # 00521e61
    call ebp                                     # 00521e65
    test eax, 0x10000000                         # 00521e67
    je.d8 L_00521e7c                             # 00521e6c
    # block 0x00521e6e: entered by fall-through of je at 0x00521e6c, 4 instruction(s), calls USER32.dll!IsWindowEnabled, ends with jne to 0x00521e9a (forward)
    push dword ptr [esp + stk_10]                # 00521e6e
    call dword ptr [0x52a330]                    # 00521e72
    test eax, eax                                # 00521e78
    jne.d8 L_00521e9a                            # 00521e7a
L_00521e7c:
    # block 0x00521e7c: entered by je at 0x00521e6c; fall-through of jne at 0x00521e7a, 4 instruction(s), ends with jl to 0x00521e57 (backward)
    inc dword ptr [esp + stk_18]                 # 00521e7c
    add ebx, 0x4                                 # 00521e80
    cmp ebx, 0x52eeb8                            # 00521e83
    jl.d8 L_00521e57                             # 00521e89
L_00521e8b:
    # block 0x00521e8b: entered by je at 0x00521e19; jne at 0x00521e4b; fall-through of jl at 0x00521e89, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x00521e92
    {load} mov ecx, esi                          # 00521e8b
    call FUN_0051ab4b                            # 00521e8d
L_00521e92:
    # block 0x00521e92: entered by jmp at 0x00521ed3, 6 instruction(s), ends with ret 0x8
    pop edi                                      # 00521e92
    pop esi                                      # 00521e93
    pop ebp                                      # 00521e94
    pop ebx                                      # 00521e95
    pop ecx                                      # 00521e96
    ret 0x8                                      # 00521e97
L_00521e9a:
    # block 0x00521e9a: entered by jne at 0x00521e7a, 5 instruction(s), calls USER32.dll!GetFocus, USER32.dll!IsWindowEnabled, ends with jne to 0x00521eb5 (forward)
    call dword ptr [0x52a308]                    # 00521e9a
    push eax                                     # 00521ea0
    call dword ptr [0x52a330]                    # 00521ea1
    test eax, eax                                # 00521ea7
    jne.d8 L_00521eb5                            # 00521ea9
    # block 0x00521eab: entered by fall-through of jne at 0x00521ea9, 2 instruction(s), calls USER32.dll!SetFocus, falls into the block at 0x00521eb5
    push dword ptr [esp + stk_10]                # 00521eab
    call dword ptr [0x52a2fc]                    # 00521eaf
L_00521eb5:
    # block 0x00521eb5: entered by jne at 0x00521ea9, 8 instruction(s), calls indirect dword ptr [eax + 0xa0], ends with backward jump to 0x00521e92
    push dword ptr [esp + stk_1c]                # 00521eb5
    mov ecx, dword ptr [esp + stk_1c]            # 00521eb9
    mov eax, dword ptr [esi]                     # 00521ebd
    push dword ptr [4*ecx + 0x52eea8]            # 00521ebf
    {load} mov ecx, esi                          # 00521ec6
    push 0x401                                   # 00521ec8
    call dword ptr [eax + field_a0]              # 00521ecd
    jmp.d8 L_00521e92                            # 00521ed3

