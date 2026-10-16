# FUN_0051ef5c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ef5c
# extent:       0x0051ef5c-0x0051f067 (267 code bytes)
# span:         0x0051ef5c-0x0051f067 (code 267, tables 0, padding 0)
# sha256:       670e0bf28cba5ea8eabf56c5707841b374d337329d5ed618e7cf850306f410f6
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ef5c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_10; [ecx + n] field_1c; [edi + n] field_1c; [esi + n] field_1c, field_54, field_88; [esp + n] stk_10, stk_14
# callees:      calls USER32.dll!IsWindowVisible, FUN_0051aa23, FUN_0051c22e, FUN_00525371, FUN_00525b0f, FUN_0051d630, FUN_0051f69d, FUN_0051f6a6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 96 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_54, 0x54  # offset +0x54
.equ field_88, 0x88  # offset +0x88

# --- external targets -----------------------------------------------
.set FUN_0051aa23, .text + (0x0051aa23 - 0x401000)
.set FUN_0051c22e, .text + (0x0051c22e - 0x401000)
.set FUN_0051d630, .text + (0x0051d630 - 0x401000)
.set FUN_0051f69d, .text + (0x0051f69d - 0x401000)
.set FUN_0051f6a6, .text + (0x0051f6a6 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051ef5c - 0x401000
.globl FUN_0051ef5c
FUN_0051ef5c:
    # block 0x0051ef5c: entry, 7 instruction(s), ends with jg to 0x0051f030 (forward)
    push ebx                                     # 0051ef5c
    push ebp                                     # 0051ef5d
    {load} xor ebp, ebp                          # 0051ef5e
    push esi                                     # 0051ef60
    cmp dword ptr [esp + stk_10], ebp            # 0051ef61
    push edi                                     # 0051ef65
    jg.d32 L_0051f030                            # 0051ef66
    # block 0x0051ef6c: entered by fall-through of jg at 0x0051ef66, 4 instruction(s), ends with je to 0x0051efa6 (forward)
    mov edi, dword ptr [ecx + field_1c]          # 0051ef6c
    mov ebx, 0x363                               # 0051ef6f
    {load} cmp edi, ebp                          # 0051ef74
    je.d8 L_0051efa6                             # 0051ef76
    # block 0x0051ef78: entered by fall-through of je at 0x0051ef76, 3 instruction(s), ends with je to 0x0051efa6 (forward)
    mov eax, dword ptr [edi + field_1c]          # 0051ef78
    {load} cmp eax, ebp                          # 0051ef7b
    je.d8 L_0051efa6                             # 0051ef7d
    # block 0x0051ef7f: entered by fall-through of je at 0x0051ef7d, 4 instruction(s), calls USER32.dll!IsWindowVisible, ends with je to 0x0051efa6 (forward)
    push eax                                     # 0051ef7f
    call dword ptr [0x52a2e8]                    # 0051ef80
    test eax, eax                                # 0051ef86
    je.d8 L_0051efa6                             # 0051ef88
    # block 0x0051ef8a: entered by fall-through of je at 0x0051ef88, 15 instruction(s), calls FUN_0051aa23, FUN_0051c22e, falls into the block at 0x0051efa6
    push ebp                                     # 0051ef8a
    push 0x1                                     # 0051ef8b
    pop esi                                      # 0051ef8d
    push esi                                     # 0051ef8e
    push ebx                                     # 0051ef8f
    push dword ptr [edi + field_1c]              # 0051ef90
    push edi                                     # 0051ef93
    call FUN_0051aa23                            # 0051ef94
    push esi                                     # 0051ef99
    push esi                                     # 0051ef9a
    push ebp                                     # 0051ef9b
    push esi                                     # 0051ef9c
    push ebx                                     # 0051ef9d
    push dword ptr [edi + field_1c]              # 0051ef9e
    call FUN_0051c22e                            # 0051efa1
L_0051efa6:
    # block 0x0051efa6: entered by je at 0x0051ef76; je at 0x0051ef7d; je at 0x0051ef88, 6 instruction(s), calls FUN_00525371, FUN_00525b0f, falls into the block at 0x0051efbf
    call FUN_00525371                            # 0051efa6
    add eax, 0x1070                              # 0051efab
    push 0x524bd4                                # 0051efb0
    {load} mov ecx, eax                          # 0051efb5
    call FUN_00525b0f                            # 0051efb7
    mov esi, dword ptr [eax + field_8]           # 0051efbc
L_0051efbf:
    # block 0x0051efbf: entered by jmp at 0x0051f02e, 2 instruction(s), ends with je to 0x0051f057 (forward)
    {load} cmp esi, ebp                          # 0051efbf
    je.d32 L_0051f057                            # 0051efc1
    # block 0x0051efc7: entered by fall-through of je at 0x0051efc1, 2 instruction(s), ends with je to 0x0051f02b (forward)
    cmp dword ptr [esi + field_1c], ebp          # 0051efc7
    je.d8 L_0051f02b                             # 0051efca
    # block 0x0051efcc: entered by fall-through of je at 0x0051efca, 2 instruction(s), ends with je to 0x0051f02b (forward)
    {load} cmp esi, edi                          # 0051efcc
    je.d8 L_0051f02b                             # 0051efce
    # block 0x0051efd0: entered by fall-through of je at 0x0051efce, 2 instruction(s), ends with jne to 0x0051efe0 (forward)
    cmp dword ptr [esi + field_88], ebp          # 0051efd0
    jne.d8 L_0051efe0                            # 0051efd6
    # block 0x0051efd8: entered by fall-through of jne at 0x0051efd6, 3 instruction(s), calls FUN_0051d630, falls into the block at 0x0051efe0
    push ebp                                     # 0051efd8
    {load} mov ecx, esi                          # 0051efd9
    call FUN_0051d630                            # 0051efdb
L_0051efe0:
    # block 0x0051efe0: entered by jne at 0x0051efd6, 4 instruction(s), calls USER32.dll!IsWindowVisible, ends with jne to 0x0051eff5 (forward)
    push dword ptr [esi + field_1c]              # 0051efe0
    call dword ptr [0x52a2e8]                    # 0051efe3
    test eax, eax                                # 0051efe9
    jne.d8 L_0051eff5                            # 0051efeb
    # block 0x0051efed: entered by fall-through of jne at 0x0051efeb, 2 instruction(s), ends with jl to 0x0051f012 (forward)
    cmp dword ptr [esi + field_88], ebp          # 0051efed
    jl.d8 L_0051f012                             # 0051eff3
L_0051eff5:
    # block 0x0051eff5: entered by jne at 0x0051efeb; fall-through of jl at 0x0051eff3, 13 instruction(s), calls FUN_0051aa23, FUN_0051c22e, falls into the block at 0x0051f012
    push ebp                                     # 0051eff5
    push 0x1                                     # 0051eff6
    push ebx                                     # 0051eff8
    push dword ptr [esi + field_1c]              # 0051eff9
    push esi                                     # 0051effc
    call FUN_0051aa23                            # 0051effd
    push 0x1                                     # 0051f002
    push 0x1                                     # 0051f004
    push ebp                                     # 0051f006
    push 0x1                                     # 0051f007
    push ebx                                     # 0051f009
    push dword ptr [esi + field_1c]              # 0051f00a
    call FUN_0051c22e                            # 0051f00d
L_0051f012:
    # block 0x0051f012: entered by jl at 0x0051eff3, 3 instruction(s), ends with jle to 0x0051f024 (forward)
    mov eax, dword ptr [esi + field_88]          # 0051f012
    {load} cmp eax, ebp                          # 0051f018
    jle.d8 L_0051f024                            # 0051f01a
    # block 0x0051f01c: entered by fall-through of jle at 0x0051f01a, 3 instruction(s), calls FUN_0051d630, falls into the block at 0x0051f024
    push eax                                     # 0051f01c
    {load} mov ecx, esi                          # 0051f01d
    call FUN_0051d630                            # 0051f01f
L_0051f024:
    # block 0x0051f024: entered by jle at 0x0051f01a, 1 instruction(s), falls into the block at 0x0051f02b
    or dword ptr [esi + field_88], -0x1          # 0051f024
L_0051f02b:
    # block 0x0051f02b: entered by je at 0x0051efca; je at 0x0051efce, 2 instruction(s), ends with backward jump to 0x0051efbf
    mov esi, dword ptr [esi + field_54]          # 0051f02b
    jmp.d8 L_0051efbf                            # 0051f02e
L_0051f030:
    # block 0x0051f030: entered by jg at 0x0051ef66, 7 instruction(s), calls FUN_00525371, FUN_00525b0f, ends with jne to 0x0051f057 (forward)
    call FUN_00525371                            # 0051f030
    add eax, 0x1070                              # 0051f035
    push 0x524bd4                                # 0051f03a
    {load} mov ecx, eax                          # 0051f03f
    call FUN_00525b0f                            # 0051f041
    cmp dword ptr [eax + field_10], ebp          # 0051f046
    jne.d8 L_0051f057                            # 0051f049
    # block 0x0051f04b: entered by fall-through of jne at 0x0051f049, 3 instruction(s), calls FUN_0051f69d, FUN_0051f6a6, falls into the block at 0x0051f057
    call FUN_0051f69d                            # 0051f04b
    push 0x1                                     # 0051f050
    call FUN_0051f6a6                            # 0051f052
L_0051f057:
    # block 0x0051f057: entered by je at 0x0051efc1; jne at 0x0051f049, 8 instruction(s), ends with ret 0x4
    {load} xor eax, eax                          # 0051f057
    cmp dword ptr [esp + stk_14], ebp            # 0051f059
    pop edi                                      # 0051f05d
    pop esi                                      # 0051f05e
    pop ebp                                      # 0051f05f
    pop ebx                                      # 0051f060
    setl al                                      # 0051f061
    ret 0x4                                      # 0051f064

