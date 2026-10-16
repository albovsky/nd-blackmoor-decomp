# FUN_005238d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005238d5
# extent:       0x005238d5-0x00523970 (155 code bytes)
# span:         0x005238d5-0x00523970 (code 155, tables 0, padding 0)
# sha256:       e30631b8984952ec6e365bf8d473ac3d5ca4425c74b18a4dc386993d506c4f8f
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005238d5
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_210
# fields:       [eax + n] field_4; [ebx + n] field_1c; [edx + n] field_94
# callees:      calls FUN_00519a30, KERNEL32.dll!GlobalLock, KERNEL32.dll!lstrcpynA, KERNEL32.dll!GlobalUnlock, FUN_00519a2a, USER32.dll!PostMessageA, FUN_0051d657, FUN_00525371; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 53 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00523970
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_210, 0x210  # offset -0x210
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_94, 0x94  # offset +0x94

# --- external targets -----------------------------------------------
.set FUN_00519a2a, .text + (0x00519a2a - 0x401000)
.set FUN_00519a30, .text + (0x00519a30 - 0x401000)
.set FUN_0051d657, .text + (0x0051d657 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x005238d5 - 0x401000
.globl FUN_005238d5
FUN_005238d5:
    # block 0x005238d5: entry, 43 instruction(s), calls FUN_00519a30, KERNEL32.dll!GlobalLock, KERNEL32.dll!lstrcpynA, KERNEL32.dll!GlobalUnlock, FUN_005..., ends with je to 0x0052396a (forward)
    push ebp                                     # 005238d5
    {load} mov ebp, esp                          # 005238d6
    sub esp, 0x210                               # 005238d8
    push ebx                                     # 005238de
    push esi                                     # 005238df
    lea eax, [ebp - local_4]                     # 005238e0
    push edi                                     # 005238e3
    push eax                                     # 005238e4
    lea eax, [ebp - local_8]                     # 005238e5
    push eax                                     # 005238e8
    mov edi, 0x3e8                               # 005238e9
    push dword ptr [ebp + arg_c]                 # 005238ee
    {load} mov ebx, ecx                          # 005238f1
    push edi                                     # 005238f3
    call FUN_00519a30                            # 005238f4
    push dword ptr [ebp - local_4]               # 005238f9
    call dword ptr [0x52a204]                    # 005238fc
    push 0x208                                   # 00523902
    push eax                                     # 00523907
    lea eax, [ebp - local_210]                   # 00523908
    push eax                                     # 0052390e
    call dword ptr [0x52a1d4]                    # 0052390f
    push dword ptr [ebp - local_4]               # 00523915
    call dword ptr [0x52a208]                    # 00523918
    push dword ptr [ebp - local_4]               # 0052391e
    mov esi, 0x3e4                               # 00523921
    push 0x8000                                  # 00523926
    push esi                                     # 0052392b
    push edi                                     # 0052392c
    push dword ptr [ebp + arg_c]                 # 0052392d
    call FUN_00519a2a                            # 00523930
    push eax                                     # 00523935
    push dword ptr [ebx + field_1c]              # 00523936
    push esi                                     # 00523939
    push dword ptr [ebp + arg_8]                 # 0052393a
    call dword ptr [0x52a31c]                    # 0052393d
    {load} mov ecx, ebx                          # 00523943
    call FUN_0051d657                            # 00523945
    pop edi                                      # 0052394a
    pop esi                                      # 0052394b
    test eax, eax                                # 0052394c
    pop ebx                                      # 0052394e
    je.d8 L_0052396a                             # 0052394f
    # block 0x00523951: entered by fall-through of je at 0x0052394f, 7 instruction(s), calls FUN_00525371, indirect dword ptr [edx + 0x94], falls into the block at 0x0052396a
    call FUN_00525371                            # 00523951
    mov eax, dword ptr [eax + field_4]           # 00523956
    lea ecx, [ebp - local_210]                   # 00523959
    push ecx                                     # 0052395f
    {load} mov ecx, eax                          # 00523960
    mov edx, dword ptr [eax]                     # 00523962
    call dword ptr [edx + field_94]              # 00523964
L_0052396a:
    # block 0x0052396a: entered by je at 0x0052394f, 3 instruction(s), ends with ret 0x8
    {load} xor eax, eax                          # 0052396a
    leave                                        # 0052396c
    ret 0x8                                      # 0052396d

