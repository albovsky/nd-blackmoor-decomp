# FUN_0052628b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052628b
# extent:       0x0052628b-0x005262f7 (108 code bytes)
# span:         0x0052628b-0x005262f7 (code 108, tables 0, padding 0)
# sha256:       8df4e10c4ba74406023bd7dffb66bac0558dc257375af8cc316db388da0e23f0
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052628b
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_7c, field_90
# callees:      calls FUN_00526245, ADVAPI32.dll!RegQueryValueExA, ADVAPI32.dll!RegCloseKey, KERNEL32.dll!GetPrivateProfileIntA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_7c, 0x7c  # offset +0x7c
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------
.set FUN_00526245, .text + (0x00526245 - 0x401000)

.org 0x0052628b - 0x401000
.globl FUN_0052628b
FUN_0052628b:
    # block 0x0052628b: entry, 7 instruction(s), ends with je to 0x005262dd (forward)
    push ebp                                     # 0052628b
    {load} mov ebp, esp                          # 0052628c
    push ecx                                     # 0052628e
    push ecx                                     # 0052628f
    cmp dword ptr [ecx + field_7c], 0x0          # 00526290
    push esi                                     # 00526294
    je.d8 L_005262dd                             # 00526295
    # block 0x00526297: entered by fall-through of je at 0x00526295, 5 instruction(s), calls FUN_00526245, ends with jne to 0x005262aa (forward)
    push dword ptr [ebp + arg_8]                 # 00526297
    call FUN_00526245                            # 0052629a
    {load} mov esi, eax                          # 0052629f
    test esi, esi                                # 005262a1
    jne.d8 L_005262aa                            # 005262a3
L_005262a5:
    # block 0x005262a5: entered by jne at 0x005262d6; fall-through of jne at 0x005262a3, 2 instruction(s), ends with forward jump to 0x005262f2
    mov eax, dword ptr [ebp + arg_10]            # 005262a5
    jmp.d8 L_005262f2                            # 005262a8
L_005262aa:
    # block 0x005262aa: entered by jne at 0x005262a3, 18 instruction(s), calls ADVAPI32.dll!RegQueryValueExA, ADVAPI32.dll!RegCloseKey, ends with jne to 0x005262a5 (backward)
    lea eax, [ebp + arg_8]                       # 005262aa
    push edi                                     # 005262ad
    push eax                                     # 005262ae
    lea eax, [ebp - local_4]                     # 005262af
    push eax                                     # 005262b2
    lea eax, [ebp - local_8]                     # 005262b3
    push eax                                     # 005262b6
    push 0x0                                     # 005262b7
    push dword ptr [ebp + arg_c]                 # 005262b9
    mov dword ptr [ebp + arg_8], 0x4             # 005262bc
    push esi                                     # 005262c3
    call dword ptr [0x52a018]                    # 005262c4
    push esi                                     # 005262ca
    {load} mov edi, eax                          # 005262cb
    call dword ptr [0x52a000]                    # 005262cd
    test edi, edi                                # 005262d3
    pop edi                                      # 005262d5
    jne.d8 L_005262a5                            # 005262d6
    # block 0x005262d8: entered by fall-through of jne at 0x005262d6, 2 instruction(s), ends with forward jump to 0x005262f2
    mov eax, dword ptr [ebp - local_4]           # 005262d8
    jmp.d8 L_005262f2                            # 005262db
L_005262dd:
    # block 0x005262dd: entered by je at 0x00526295, 5 instruction(s), calls KERNEL32.dll!GetPrivateProfileIntA, falls into the block at 0x005262f2
    push dword ptr [ecx + field_90]              # 005262dd
    push dword ptr [ebp + arg_10]                # 005262e3
    push dword ptr [ebp + arg_c]                 # 005262e6
    push dword ptr [ebp + arg_8]                 # 005262e9
    call dword ptr [0x52a29c]                    # 005262ec
L_005262f2:
    # block 0x005262f2: entered by jmp at 0x005262a8; jmp at 0x005262db, 3 instruction(s), ends with ret 0xc
    pop esi                                      # 005262f2
    leave                                        # 005262f3
    ret 0xc                                      # 005262f4

