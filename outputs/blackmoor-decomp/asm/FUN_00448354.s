# FUN_00448354
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00448354
# extent:       0x00448354-0x004484ba (358 code bytes)
# span:         0x00448354-0x004484ba (code 358, tables 0, padding 0)
# sha256:       ae6c9ddd3b1f694738e3ce55fb0b983dcc42dba07a3a5d2677b30908b8850ef2
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00448354
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_30, local_34, local_38
# fields:       [eax + n] field_1e; [ecx + n] field_21
# callees:      calls FUN_0050ca3e, FUN_004f6334, FUN_00448d11, FUN_00432d1a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m448354_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 126 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21

# --- external targets -----------------------------------------------
.set FUN_00432d1a, .text + (0x00432d1a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00448354 - 0x401000
.globl FUN_00448354
FUN_00448354:
    # block 0x00448354: entry, 10 instruction(s), ends with je to 0x004484b1 (forward)
    push ebp                                     # 00448354
    {load} mov ebp, esp                          # 00448355
    sub esp, 0x38                                # 00448357
    push ebx                                     # 0044835a
    push esi                                     # 0044835b
    push edi                                     # 0044835c
    mov dword ptr [ebp - local_38], ecx          # 0044835d
    mov eax, dword ptr [ebp - local_38]          # 00448360
    cmp dword ptr [eax + field_1e], 0x0          # 00448363
    je.d32 L_004484b1                            # 00448367
    # block 0x0044836d: entered by fall-through of je at 0x00448367, 79 instruction(s), calls FUN_0050ca3e, FUN_004f6334, ends with jne to 0x004484b1 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044836d
    imul ecx, ecx, 0x8d                          # 00448371
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00448377
    mov dword ptr [ebp - local_10], edx          # 0044837d
    mov eax, dword ptr [ebp - local_10]          # 00448380
    add eax, 0x2                                 # 00448383
    mov dword ptr [ebp - local_8], eax           # 00448386
    mov ecx, dword ptr [ebp - local_10]          # 00448389
    movsx edx, word ptr [ecx]                    # 0044838c
    mov ax, word ptr [2*edx + 0x58c9de]          # 0044838f
    mov word ptr [ebp - local_c], ax             # 00448397
    movsx ecx, word ptr [ebp - local_c]          # 0044839b
    push ecx                                     # 0044839f
    push 0x5487b4                                # 004483a0
    lea edx, [ebp - local_4]                     # 004483a5
    push edx                                     # 004483a8
    call FUN_0050ca3e                            # 004483a9
    add esp, 0xc                                 # 004483ae
    mov edi, 0x58c9bf                            # 004483b1
    lea edx, [ebp - local_30]                    # 004483b6
    or ecx, -0x1                                 # 004483b9
    {load} xor eax, eax                          # 004483bc
    repne scasb al, byte ptr es:[edi]            # 004483be
    not ecx                                      # 004483c0
    {load} sub edi, ecx                          # 004483c2
    {load} mov esi, edi                          # 004483c4
    {load} mov eax, ecx                          # 004483c6
    {load} mov edi, edx                          # 004483c8
    shr ecx, 0x2                                 # 004483ca
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004483cd
    {load} mov ecx, eax                          # 004483cf
    and ecx, 0x3                                 # 004483d1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004483d4
    lea edi, [ebp - local_4]                     # 004483d6
    lea edx, [ebp - local_30]                    # 004483d9
    or ecx, -0x1                                 # 004483dc
    {load} xor eax, eax                          # 004483df
    repne scasb al, byte ptr es:[edi]            # 004483e1
    not ecx                                      # 004483e3
    {load} sub edi, ecx                          # 004483e5
    {load} mov esi, edi                          # 004483e7
    {load} mov ebx, ecx                          # 004483e9
    {load} mov edi, edx                          # 004483eb
    or ecx, -0x1                                 # 004483ed
    {load} xor eax, eax                          # 004483f0
    repne scasb al, byte ptr es:[edi]            # 004483f2
    add edi, -0x1                                # 004483f4
    {load} mov ecx, ebx                          # 004483f7
    shr ecx, 0x2                                 # 004483f9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004483fc
    {load} mov ecx, ebx                          # 004483fe
    and ecx, 0x3                                 # 00448400
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00448403
    lea edi, [ebp - local_30]                    # 00448405
    mov eax, dword ptr [ebp - local_10]          # 00448408
    add eax, 0x2                                 # 0044840b
    {load} mov edx, eax                          # 0044840e
    or ecx, -0x1                                 # 00448410
    {load} xor eax, eax                          # 00448413
    repne scasb al, byte ptr es:[edi]            # 00448415
    not ecx                                      # 00448417
    {load} sub edi, ecx                          # 00448419
    {load} mov esi, edi                          # 0044841b
    {load} mov eax, ecx                          # 0044841d
    {load} mov edi, edx                          # 0044841f
    shr ecx, 0x2                                 # 00448421
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00448424
    {load} mov ecx, eax                          # 00448426
    and ecx, 0x3                                 # 00448428
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044842b
    mov ecx, dword ptr [ebp - local_8]           # 0044842d
    movsx edx, word ptr [ecx + field_21]         # 00448430
    mov dword ptr [ebp - local_34], edx          # 00448434
    mov eax, dword ptr [ebp - local_34]          # 00448437
    push eax                                     # 0044843a
    mov ecx, 0x5cf1eb                            # 0044843b
    call FUN_004f6334                            # 00448440
    test eax, eax                                # 00448445
    jne.d8 L_004484b1                            # 00448447
    # block 0x00448449: entered by fall-through of jne at 0x00448447, 2 instruction(s), ends with je to 0x0044849e (forward)
    cmp dword ptr [0x5bb202], 0x0                # 00448449
    je.d8 L_0044849e                             # 00448450
    # block 0x00448452: entered by fall-through of je at 0x00448450, 11 instruction(s), ends with jbe to 0x0044849e (forward)
    movsx edi, word ptr [ebp - local_c]          # 00448452
    sub edi, 0x1                                 # 00448456
    imul edi, edi, 0x3e8                         # 00448459
    add edi, 0x58ca30                            # 0044845f
    or ecx, -0x1                                 # 00448465
    {load} xor eax, eax                          # 00448468
    repne scasb al, byte ptr es:[edi]            # 0044846a
    not ecx                                      # 0044846c
    add ecx, -0x1                                # 0044846e
    test ecx, ecx                                # 00448471
    jbe.d8 L_0044849e                            # 00448473
    # block 0x00448475: entered by fall-through of jbe at 0x00448473, 11 instruction(s), calls FUN_00448d11, falls into the block at 0x0044849e
    push 0x0                                     # 00448475
    push -0x1                                    # 00448477
    movsx ecx, word ptr [ebp - local_c]          # 00448479
    sub ecx, 0x1                                 # 0044847d
    imul ecx, ecx, 0x3e8                         # 00448480
    add ecx, 0x58ca30                            # 00448486
    push ecx                                     # 0044848c
    mov edx, dword ptr [0x5d03b3]                # 0044848d
    push edx                                     # 00448493
    mov ecx, 0x619a05                            # 00448494
    call FUN_00448d11                            # 00448499
L_0044849e:
    # block 0x0044849e: entered by je at 0x00448450; jbe at 0x00448473, 7 instruction(s), calls FUN_00432d1a, falls into the block at 0x004484b1
    mov eax, dword ptr [ebp - local_8]           # 0044849e
    push eax                                     # 004484a1
    push 0x0                                     # 004484a2
    mov cx, word ptr [ebp + arg_8]               # 004484a4
    push ecx                                     # 004484a8
    call FUN_00432d1a                            # 004484a9
    add esp, 0xc                                 # 004484ae
L_004484b1:
    # block 0x004484b1: entered by je at 0x00448367; jne at 0x00448447, 6 instruction(s), ends with ret 0x4
    pop edi                                      # 004484b1
    pop esi                                      # 004484b2
    pop ebx                                      # 004484b3
    {load} mov esp, ebp                          # 004484b4
    pop ebp                                      # 004484b6
    ret 0x4                                      # 004484b7

