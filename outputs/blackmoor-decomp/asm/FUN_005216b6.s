# FUN_005216b6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005216b6
# extent:       0x005216b6-0x00521756 (160 code bytes)
# span:         0x005216b6-0x00521756 (code 160, tables 0, padding 0)
# sha256:       02f4c2f70e46c503be3060ea0ab7c16706fd0644bd2c8be5ae6e457b1c3add9f
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005216b6
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [ecx + n] field_7c, field_90
# callees:      calls FUN_005261b1, ADVAPI32.dll!RegDeleteKeyA, FUN_00526245, ADVAPI32.dll!RegDeleteValueA, KERNEL32.dll!lstrlenA, ADVAPI32.dll!RegSetValueExA, ADVAPI32.dll!RegCloseKey, KERNEL32.dll!WritePrivateProfileStringA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 59 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_7c, 0x7c  # offset +0x7c
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------
.set FUN_005261b1, .text + (0x005261b1 - 0x401000)
.set FUN_00526245, .text + (0x00526245 - 0x401000)

.org 0x005216b6 - 0x401000
.globl FUN_005216b6
FUN_005216b6:
    # block 0x005216b6: entry, 6 instruction(s), ends with je to 0x0052173b (forward)
    push ebp                                     # 005216b6
    {load} mov ebp, esp                          # 005216b7
    cmp dword ptr [ecx + field_7c], 0x0          # 005216b9
    push esi                                     # 005216bd
    push edi                                     # 005216be
    je.d8 L_0052173b                             # 005216bf
    # block 0x005216c1: entered by fall-through of je at 0x005216bf, 2 instruction(s), ends with jne to 0x005216e2 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 005216c1
    jne.d8 L_005216e2                            # 005216c5
    # block 0x005216c7: entered by fall-through of jne at 0x005216c5, 4 instruction(s), calls FUN_005261b1, ends with jne to 0x005216d6 (forward)
    call FUN_005261b1                            # 005216c7
    {load} mov esi, eax                          # 005216cc
    test esi, esi                                # 005216ce
    jne.d8 L_005216d6                            # 005216d0
L_005216d2:
    # block 0x005216d2: entered by je at 0x005216f4; je at 0x0052170b; fall-through of jne at 0x005216d0, 2 instruction(s), ends with forward jump to 0x00521750
    {load} xor eax, eax                          # 005216d2
    jmp.d8 L_00521750                            # 005216d4
L_005216d6:
    # block 0x005216d6: entered by jne at 0x005216d0, 4 instruction(s), calls ADVAPI32.dll!RegDeleteKeyA, ends with forward jump to 0x00521729
    push dword ptr [ebp + arg_8]                 # 005216d6
    push esi                                     # 005216d9
    call dword ptr [0x52a004]                    # 005216da
    jmp.d8 L_00521729                            # 005216e0
L_005216e2:
    # block 0x005216e2: entered by jne at 0x005216c5, 3 instruction(s), ends with jne to 0x00521702 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 005216e2
    push dword ptr [ebp + arg_8]                 # 005216e6
    jne.d8 L_00521702                            # 005216e9
    # block 0x005216eb: entered by fall-through of jne at 0x005216e9, 4 instruction(s), calls FUN_00526245, ends with je to 0x005216d2 (backward)
    call FUN_00526245                            # 005216eb
    {load} mov esi, eax                          # 005216f0
    test esi, esi                                # 005216f2
    je.d8 L_005216d2                             # 005216f4
    # block 0x005216f6: entered by fall-through of je at 0x005216f4, 4 instruction(s), calls ADVAPI32.dll!RegDeleteValueA, ends with forward jump to 0x00521729
    push dword ptr [ebp + arg_c]                 # 005216f6
    push esi                                     # 005216f9
    call dword ptr [0x52a00c]                    # 005216fa
    jmp.d8 L_00521729                            # 00521700
L_00521702:
    # block 0x00521702: entered by jne at 0x005216e9, 4 instruction(s), calls FUN_00526245, ends with je to 0x005216d2 (backward)
    call FUN_00526245                            # 00521702
    {load} mov esi, eax                          # 00521707
    test esi, esi                                # 00521709
    je.d8 L_005216d2                             # 0052170b
    # block 0x0052170d: entered by fall-through of je at 0x0052170b, 10 instruction(s), calls KERNEL32.dll!lstrlenA, ADVAPI32.dll!RegSetValueExA, falls into the block at 0x00521729
    push dword ptr [ebp + arg_10]                # 0052170d
    call dword ptr [0x52a1f8]                    # 00521710
    inc eax                                      # 00521716
    push eax                                     # 00521717
    push dword ptr [ebp + arg_10]                # 00521718
    push 0x1                                     # 0052171b
    push 0x0                                     # 0052171d
    push dword ptr [ebp + arg_c]                 # 0052171f
    push esi                                     # 00521722
    call dword ptr [0x52a014]                    # 00521723
L_00521729:
    # block 0x00521729: entered by jmp at 0x005216e0; jmp at 0x00521700, 7 instruction(s), calls ADVAPI32.dll!RegCloseKey, ends with forward jump to 0x00521750
    push esi                                     # 00521729
    {load} mov edi, eax                          # 0052172a
    call dword ptr [0x52a000]                    # 0052172c
    {load} xor eax, eax                          # 00521732
    test edi, edi                                # 00521734
    sete al                                      # 00521736
    jmp.d8 L_00521750                            # 00521739
L_0052173b:
    # block 0x0052173b: entered by je at 0x005216bf, 5 instruction(s), calls KERNEL32.dll!WritePrivateProfileStringA, falls into the block at 0x00521750
    push dword ptr [ecx + field_90]              # 0052173b
    push dword ptr [ebp + arg_10]                # 00521741
    push dword ptr [ebp + arg_c]                 # 00521744
    push dword ptr [ebp + arg_8]                 # 00521747
    call dword ptr [0x52a26c]                    # 0052174a
L_00521750:
    # block 0x00521750: entered by jmp at 0x005216d4; jmp at 0x00521739, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 00521750
    pop esi                                      # 00521751
    pop ebp                                      # 00521752
    ret 0xc                                      # 00521753

