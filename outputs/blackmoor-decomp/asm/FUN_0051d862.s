# FUN_0051d862
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d862
# extent:       0x0051d862-0x0051d971 (271 code bytes)
# span:         0x0051d862-0x0051d971 (code 271, tables 0, padding 0)
# sha256:       c8f84c13e17ab905f30f470dd996d705a21b7396fbba00090e799b544f2f0d48
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d862
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_10, field_14, field_28, field_2c, field_1038; [ebx + n] field_4, field_30; [edi + n] field_4; [edx + n] field_4; [esi + n] field_4, field_8
# callees:      calls FUN_00525371, FUN_0050f9e0, FUN_0051b9a3, FUN_0051d75b; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 105 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051d971
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_1038, 0x1038  # offset +0x1038

# --- external targets -----------------------------------------------
.set FUN_0050f9e0, .text + (0x0050f9e0 - 0x401000)
.set FUN_0051b9a3, .text + (0x0051b9a3 - 0x401000)
.set FUN_0051d75b, .text + (0x0051d75b - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051d862 - 0x401000
.globl FUN_0051d862
FUN_0051d862:
    # block 0x0051d862: entry, 9 instruction(s), ends with jne to 0x0051d893 (forward)
    push ebp                                     # 0051d862
    {load} mov ebp, esp                          # 0051d863
    mov eax, dword ptr [ebp + arg_c]             # 0051d865
    push ebx                                     # 0051d868
    push esi                                     # 0051d869
    push edi                                     # 0051d86a
    cmp eax, -0x2                                # 0051d86b
    {load} mov edi, ecx                          # 0051d86e
    jne.d8 L_0051d893                            # 0051d870
    # block 0x0051d872: entered by fall-through of jne at 0x0051d870, 10 instruction(s), calls FUN_00525371, indirect dword ptr [edx + 0x4], ends with forward jump to 0x0051d96a
    call FUN_00525371                            # 0051d872
    push dword ptr [ebp + arg_14]                # 0051d877
    mov eax, dword ptr [eax + field_1038]        # 0051d87a
    {load} mov ecx, eax                          # 0051d880
    push dword ptr [ebp + arg_10]                # 0051d882
    mov edx, dword ptr [eax]                     # 0051d885
    push dword ptr [ebp + arg_8]                 # 0051d887
    push edi                                     # 0051d88a
    call dword ptr [edx + field_4]               # 0051d88b
    jmp.d32 L_0051d96a                           # 0051d88e
L_0051d893:
    # block 0x0051d893: entered by jne at 0x0051d870, 2 instruction(s), ends with jne to 0x0051d913 (forward)
    cmp eax, -0x3                                # 0051d893
    jne.d8 L_0051d913                            # 0051d896
    # block 0x0051d898: entered by fall-through of jne at 0x0051d896, 8 instruction(s), calls indirect dword ptr [eax + 0x2c], falls into the block at 0x0051d8ae
    mov ebx, dword ptr [ebp + arg_10]            # 0051d898
    and dword ptr [ebp + arg_c], 0x0             # 0051d89b
    {load} mov ecx, edi                          # 0051d89f
    mov eax, dword ptr [ebx + field_30]          # 0051d8a1
    mov dword ptr [ebp + arg_10], eax            # 0051d8a4
    mov eax, dword ptr [edi]                     # 0051d8a7
    call dword ptr [eax + field_2c]              # 0051d8a9
    {load} mov edi, eax                          # 0051d8ac
L_0051d8ae:
    # block 0x0051d8ae: entered by jmp at 0x0051d90c, 2 instruction(s), ends with je to 0x0051d90e (forward)
    test edi, edi                                # 0051d8ae
    je.d8 L_0051d90e                             # 0051d8b0
    # block 0x0051d8b2: entered by fall-through of je at 0x0051d8b0, 2 instruction(s), ends with jne to 0x0051d90e (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 0051d8b2
    jne.d8 L_0051d90e                            # 0051d8b6
    # block 0x0051d8b8: entered by fall-through of jne at 0x0051d8b6, 1 instruction(s), falls into the block at 0x0051d8bb
    mov esi, dword ptr [edi + field_4]           # 0051d8b8
L_0051d8bb:
    # block 0x0051d8bb: entered by jmp at 0x0051d908, 3 instruction(s), ends with je to 0x0051d90a (forward)
    mov eax, dword ptr [esi + field_4]           # 0051d8bb
    test eax, eax                                # 0051d8be
    je.d8 L_0051d90a                             # 0051d8c0
    # block 0x0051d8c2: entered by fall-through of je at 0x0051d8c0, 2 instruction(s), ends with je to 0x0051d90a (forward)
    cmp dword ptr [esi + field_8], 0x0           # 0051d8c2
    je.d8 L_0051d90a                             # 0051d8c6
    # block 0x0051d8c8: entered by fall-through of je at 0x0051d8c6, 2 instruction(s), ends with jne to 0x0051d90a (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 0051d8c8
    jne.d8 L_0051d90a                            # 0051d8cc
    # block 0x0051d8ce: entered by fall-through of jne at 0x0051d8cc, 2 instruction(s), ends with jne to 0x0051d905 (forward)
    cmp dword ptr [ebp + arg_8], eax             # 0051d8ce
    jne.d8 L_0051d905                            # 0051d8d1
    # block 0x0051d8d3: entered by fall-through of jne at 0x0051d8d1, 2 instruction(s), ends with jne to 0x0051d8e0 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 0051d8d3
    jne.d8 L_0051d8e0                            # 0051d8d7
    # block 0x0051d8d9: entered by fall-through of jne at 0x0051d8d7, 2 instruction(s), ends with je to 0x0051d8f8 (forward)
    cmp dword ptr [esi], 0x0                     # 0051d8d9
    je.d8 L_0051d8f8                             # 0051d8dc
    # block 0x0051d8de: entered by fall-through of je at 0x0051d8dc, 1 instruction(s), ends with forward jump to 0x0051d905
    jmp.d8 L_0051d905                            # 0051d8de
L_0051d8e0:
    # block 0x0051d8e0: entered by jne at 0x0051d8d7, 3 instruction(s), ends with je to 0x0051d905 (forward)
    mov eax, dword ptr [esi]                     # 0051d8e0
    test eax, eax                                # 0051d8e2
    je.d8 L_0051d905                             # 0051d8e4
    # block 0x0051d8e6: entered by fall-through of je at 0x0051d8e4, 7 instruction(s), calls FUN_0050f9e0, ends with jne to 0x0051d905 (forward)
    push 0x10                                    # 0051d8e6
    push eax                                     # 0051d8e8
    push dword ptr [ebp + arg_10]                # 0051d8e9
    call FUN_0050f9e0                            # 0051d8ec
    add esp, 0xc                                 # 0051d8f1
    test eax, eax                                # 0051d8f4
    jne.d8 L_0051d905                            # 0051d8f6
L_0051d8f8:
    # block 0x0051d8f8: entered by je at 0x0051d8dc; fall-through of jne at 0x0051d8f6, 3 instruction(s), falls into the block at 0x0051d905
    mov eax, dword ptr [esi + field_8]           # 0051d8f8
    mov dword ptr [ebp + arg_c], 0x1             # 0051d8fb
    mov dword ptr [ebx + field_4], eax           # 0051d902
L_0051d905:
    # block 0x0051d905: entered by jne at 0x0051d8d1; jmp at 0x0051d8de; je at 0x0051d8e4; jne at 0x0051d8f6, 2 instruction(s), ends with backward jump to 0x0051d8bb
    add esi, 0xc                                 # 0051d905
    jmp.d8 L_0051d8bb                            # 0051d908
L_0051d90a:
    # block 0x0051d90a: entered by je at 0x0051d8c0; je at 0x0051d8c6; jne at 0x0051d8cc, 2 instruction(s), ends with backward jump to 0x0051d8ae
    mov edi, dword ptr [edi]                     # 0051d90a
    jmp.d8 L_0051d8ae                            # 0051d90c
L_0051d90e:
    # block 0x0051d90e: entered by je at 0x0051d8b0; jne at 0x0051d8b6, 2 instruction(s), ends with forward jump to 0x0051d96a
    mov eax, dword ptr [ebp + arg_c]             # 0051d90e
    jmp.d8 L_0051d96a                            # 0051d911
L_0051d913:
    # block 0x0051d913: entered by jne at 0x0051d896, 2 instruction(s), ends with je to 0x0051d925 (forward)
    cmp eax, -0x1                                # 0051d913
    je.d8 L_0051d925                             # 0051d916
    # block 0x0051d918: entered by fall-through of je at 0x0051d916, 5 instruction(s), ends with jne to 0x0051d92a (forward)
    {load} mov ebx, eax                          # 0051d918
    movzx eax, ax                                # 0051d91a
    shr ebx, 0x10                                # 0051d91d
    mov dword ptr [ebp + arg_c], eax             # 0051d920
    jne.d8 L_0051d92a                            # 0051d923
L_0051d925:
    # block 0x0051d925: entered by je at 0x0051d916; fall-through of jne at 0x0051d923, 1 instruction(s), falls into the block at 0x0051d92a
    mov ebx, 0x111                               # 0051d925
L_0051d92a:
    # block 0x0051d92a: entered by jne at 0x0051d923, 4 instruction(s), calls indirect dword ptr [eax + 0x28], falls into the block at 0x0051d933
    mov eax, dword ptr [edi]                     # 0051d92a
    {load} mov ecx, edi                          # 0051d92c
    call dword ptr [eax + field_28]              # 0051d92e
    {load} mov esi, eax                          # 0051d931
L_0051d933:
    # block 0x0051d933: entered by jmp at 0x0051d94c, 2 instruction(s), ends with je to 0x0051d968 (forward)
    test esi, esi                                # 0051d933
    je.d8 L_0051d968                             # 0051d935
    # block 0x0051d937: entered by fall-through of je at 0x0051d935, 7 instruction(s), calls FUN_0051b9a3, ends with jne to 0x0051d94e (forward)
    push dword ptr [ebp + arg_8]                 # 0051d937
    push dword ptr [ebp + arg_c]                 # 0051d93a
    push ebx                                     # 0051d93d
    push dword ptr [esi + field_4]               # 0051d93e
    call FUN_0051b9a3                            # 0051d941
    test eax, eax                                # 0051d946
    jne.d8 L_0051d94e                            # 0051d948
    # block 0x0051d94a: entered by fall-through of jne at 0x0051d948, 2 instruction(s), ends with backward jump to 0x0051d933
    mov esi, dword ptr [esi]                     # 0051d94a
    jmp.d8 L_0051d933                            # 0051d94c
L_0051d94e:
    # block 0x0051d94e: entered by jne at 0x0051d948, 9 instruction(s), calls FUN_0051d75b, ends with forward jump to 0x0051d96a
    push dword ptr [ebp + arg_14]                # 0051d94e
    push dword ptr [eax + field_10]              # 0051d951
    push dword ptr [ebp + arg_10]                # 0051d954
    push dword ptr [eax + field_14]              # 0051d957
    push dword ptr [ebp + arg_c]                 # 0051d95a
    push dword ptr [ebp + arg_8]                 # 0051d95d
    push edi                                     # 0051d960
    call FUN_0051d75b                            # 0051d961
    jmp.d8 L_0051d96a                            # 0051d966
L_0051d968:
    # block 0x0051d968: entered by je at 0x0051d935, 1 instruction(s), falls into the block at 0x0051d96a
    {load} xor eax, eax                          # 0051d968
L_0051d96a:
    # block 0x0051d96a: entered by jmp at 0x0051d88e; jmp at 0x0051d911; jmp at 0x0051d966, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 0051d96a
    pop esi                                      # 0051d96b
    pop ebx                                      # 0051d96c
    pop ebp                                      # 0051d96d
    ret 0x10                                     # 0051d96e

