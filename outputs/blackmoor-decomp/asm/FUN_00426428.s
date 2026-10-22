# FUN_00426428
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426428
# extent:       0x00426428-0x004264e8 (192 code bytes)
# span:         0x00426428-0x004264e8 (code 192, tables 0, padding 0)
# sha256:       29168fde7d5c0997abab71e7af458ce77f15bd162bb4602934fa2563883619f9
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00426428
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052139c, FUN_0051e7ba
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426428_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 75 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00426428 - 0x401000
.globl FUN_00426428
FUN_00426428:
    # block 0x00426428: entry, 37 instruction(s), ends with je to 0x004264b7 (forward)
    push ebp                                     # 00426428
    {load} mov ebp, esp                          # 00426429
    push -0x1                                    # 0042642b
    push 0x5273f9                                # 0042642d
    mov eax, dword ptr fs:[0x0]                  # 00426432
    push eax                                     # 00426438
    mov dword ptr fs:[0x0], esp                  # 00426439
    push ecx                                     # 00426440
    push ebx                                     # 00426441
    push esi                                     # 00426442
    push edi                                     # 00426443
    mov dword ptr [ebp - local_10], ecx          # 00426444
    mov dword ptr [ebp - local_4], 0x0           # 00426447
    mov edi, dword ptr [ebp + arg_8]             # 0042644e
    mov eax, dword ptr [ebp - local_10]          # 00426451
    mov edx, dword ptr [eax]                     # 00426454
    or ecx, -0x1                                 # 00426456
    {load} xor eax, eax                          # 00426459
    repne scasb al, byte ptr es:[edi]            # 0042645b
    not ecx                                      # 0042645d
    {load} sub edi, ecx                          # 0042645f
    {load} mov esi, edi                          # 00426461
    {load} mov eax, ecx                          # 00426463
    {load} mov edi, edx                          # 00426465
    shr ecx, 0x2                                 # 00426467
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0042646a
    {load} mov ecx, eax                          # 0042646c
    and ecx, 0x3                                 # 0042646e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00426471
    mov edi, dword ptr [ebp + arg_c]             # 00426473
    or ecx, -0x1                                 # 00426476
    {load} xor eax, eax                          # 00426479
    repne scasb al, byte ptr es:[edi]            # 0042647b
    not ecx                                      # 0042647d
    add ecx, -0x1                                # 0042647f
    test ecx, ecx                                # 00426482
    je.d8 L_004264b7                             # 00426484
    # block 0x00426486: entered by fall-through of je at 0x00426484, 21 instruction(s), falls into the block at 0x004264b7
    mov edi, dword ptr [ebp + arg_c]             # 00426486
    mov ecx, dword ptr [ebp - local_10]          # 00426489
    mov edx, dword ptr [ecx]                     # 0042648c
    or ecx, -0x1                                 # 0042648e
    {load} xor eax, eax                          # 00426491
    repne scasb al, byte ptr es:[edi]            # 00426493
    not ecx                                      # 00426495
    {load} sub edi, ecx                          # 00426497
    {load} mov esi, edi                          # 00426499
    {load} mov ebx, ecx                          # 0042649b
    {load} mov edi, edx                          # 0042649d
    or ecx, -0x1                                 # 0042649f
    {load} xor eax, eax                          # 004264a2
    repne scasb al, byte ptr es:[edi]            # 004264a4
    add edi, -0x1                                # 004264a6
    {load} mov ecx, ebx                          # 004264a9
    shr ecx, 0x2                                 # 004264ab
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004264ae
    {load} mov ecx, ebx                          # 004264b0
    and ecx, 0x3                                 # 004264b2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004264b5
L_004264b7:
    # block 0x004264b7: entered by je at 0x00426484, 17 instruction(s), calls FUN_0052139c, FUN_0051e7ba, ends with ret 0x8
    push 0x0                                     # 004264b7
    push 0x0                                     # 004264b9
    mov eax, dword ptr [ebp - local_10]          # 004264bb
    mov ecx, dword ptr [eax]                     # 004264be
    push ecx                                     # 004264c0
    call FUN_0052139c                            # 004264c1
    mov dword ptr [ebp - local_4], 0xffffffff    # 004264c6
    lea ecx, [ebp + arg_c]                       # 004264cd
    call FUN_0051e7ba                            # 004264d0
    mov ecx, dword ptr [ebp - local_c]           # 004264d5
    mov dword ptr fs:[0x0], ecx                  # 004264d8
    pop edi                                      # 004264df
    pop esi                                      # 004264e0
    pop ebx                                      # 004264e1
    {load} mov esp, ebp                          # 004264e2
    pop ebp                                      # 004264e4
    ret 0x8                                      # 004264e5

