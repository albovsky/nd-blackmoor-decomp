# FUN_0052314e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052314e
# extent:       0x0052314e-0x005231d1 (131 code bytes)
# span:         0x0052314e-0x005231d1 (code 131, tables 0, padding 0)
# sha256:       a749a694e789a9d6b0037d7d582e3482e18b726e954bfdff48b9a11d54aaeb7b
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         GetIconWndClass
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_c, local_10, local_14, local_28, local_30, local_38, local_58
# fields:       [eax + n] field_8, field_c, field_5c
# callees:      calls FUN_00525371, USER32.dll!LoadIconA, FUN_0050f920, USER32.dll!GetClassInfoA, FUN_0051b7c1; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_28, 0x28  # offset -0x28
.equ local_30, 0x30  # offset -0x30
.equ local_38, 0x38  # offset -0x38
.equ local_58, 0x58  # offset -0x58
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051b7c1, .text + (0x0051b7c1 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0052314e - 0x401000
.globl FUN_0052314e
FUN_0052314e:
    # block 0x0052314e: entry, 15 instruction(s), calls FUN_00525371, USER32.dll!LoadIconA, ends with je to 0x005231c9 (forward)
    push ebp                                     # 0052314e
    {load} mov ebp, esp                          # 0052314f
    sub esp, 0x58                                # 00523151
    push esi                                     # 00523154
    push edi                                     # 00523155
    {load} mov esi, ecx                          # 00523156
    call FUN_00525371                            # 00523158
    movzx ecx, word ptr [ebp + arg_c]            # 0052315d
    mov eax, dword ptr [eax + field_c]           # 00523161
    push ecx                                     # 00523164
    push eax                                     # 00523165
    call dword ptr [0x52a4a0]                    # 00523166
    {load} mov edi, eax                          # 0052316c
    test edi, edi                                # 0052316e
    je.d8 L_005231c9                             # 00523170
    # block 0x00523172: entered by fall-through of je at 0x00523170, 15 instruction(s), calls FUN_0050f920, indirect dword ptr [eax + 0x5c], ends with je to 0x005231c9 (forward)
    push 0x30                                    # 00523172
    lea eax, [ebp - local_58]                    # 00523174
    push 0x0                                     # 00523177
    push eax                                     # 00523179
    call FUN_0050f920                            # 0052317a
    mov eax, dword ptr [ebp + arg_8]             # 0052317f
    add esp, 0xc                                 # 00523182
    lea ecx, [ebp - local_58]                    # 00523185
    mov dword ptr [ebp - local_38], eax          # 00523188
    mov eax, dword ptr [esi]                     # 0052318b
    push ecx                                     # 0052318d
    {load} mov ecx, esi                          # 0052318e
    call dword ptr [eax + field_5c]              # 00523190
    cmp dword ptr [ebp - local_30], 0x0          # 00523193
    je.d8 L_005231c9                             # 00523197
    # block 0x00523199: entered by fall-through of je at 0x00523197, 9 instruction(s), calls FUN_00525371, USER32.dll!GetClassInfoA, ends with je to 0x005231c9 (forward)
    call FUN_00525371                            # 00523199
    mov eax, dword ptr [eax + field_8]           # 0052319e
    lea ecx, [ebp - local_28]                    # 005231a1
    push ecx                                     # 005231a4
    push dword ptr [ebp - local_30]              # 005231a5
    push eax                                     # 005231a8
    call dword ptr [0x52a3ec]                    # 005231a9
    test eax, eax                                # 005231af
    je.d8 L_005231c9                             # 005231b1
    # block 0x005231b3: entered by fall-through of je at 0x005231b1, 2 instruction(s), ends with je to 0x005231c9 (forward)
    cmp dword ptr [ebp - local_14], edi          # 005231b3
    je.d8 L_005231c9                             # 005231b6
    # block 0x005231b8: entered by fall-through of je at 0x005231b6, 6 instruction(s), calls FUN_0051b7c1, ends with forward jump to 0x005231cb
    push edi                                     # 005231b8
    push dword ptr [ebp - local_c]               # 005231b9
    push dword ptr [ebp - local_10]              # 005231bc
    push dword ptr [ebp - local_28]              # 005231bf
    call FUN_0051b7c1                            # 005231c2
    jmp.d8 L_005231cb                            # 005231c7
L_005231c9:
    # block 0x005231c9: entered by je at 0x00523170; je at 0x00523197; je at 0x005231b1; je at 0x005231b6, 1 instruction(s), falls into the block at 0x005231cb
    {load} xor eax, eax                          # 005231c9
L_005231cb:
    # block 0x005231cb: entered by jmp at 0x005231c7, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 005231cb
    pop esi                                      # 005231cc
    leave                                        # 005231cd
    ret 0x8                                      # 005231ce

