# FUN_0042639d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042639d
# extent:       0x0042639d-0x00426428 (139 code bytes)
# span:         0x0042639d-0x00426428 (code 139, tables 0, padding 0)
# sha256:       9acdc84d64bfb67bde207af9695523f701cc7668503ec29fa5bfb25f4f978bee
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42639d_lifted
# naming:       native port src/original_methods_fl40.c:m42639d_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 7 seeds; oracle 64/64 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052139c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m42639d_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 64 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0042639d - 0x401000
.globl FUN_0042639d
FUN_0042639d:
    # block 0x0042639d: entry, 31 instruction(s), ends with je to 0x00426410 (forward)
    push ebp                                     # 0042639d
    {load} mov ebp, esp                          # 0042639e
    push ecx                                     # 004263a0
    push ebx                                     # 004263a1
    push esi                                     # 004263a2
    push edi                                     # 004263a3
    mov dword ptr [ebp - local_4], ecx           # 004263a4
    mov edi, dword ptr [ebp + arg_8]             # 004263a7
    mov eax, dword ptr [ebp - local_4]           # 004263aa
    mov edx, dword ptr [eax]                     # 004263ad
    or ecx, -0x1                                 # 004263af
    {load} xor eax, eax                          # 004263b2
    repne scasb al, byte ptr es:[edi]            # 004263b4
    not ecx                                      # 004263b6
    {load} sub edi, ecx                          # 004263b8
    {load} mov esi, edi                          # 004263ba
    {load} mov eax, ecx                          # 004263bc
    {load} mov edi, edx                          # 004263be
    shr ecx, 0x2                                 # 004263c0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004263c3
    {load} mov ecx, eax                          # 004263c5
    and ecx, 0x3                                 # 004263c7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004263ca
    mov edi, dword ptr [ebp + arg_c]             # 004263cc
    or ecx, -0x1                                 # 004263cf
    {load} xor eax, eax                          # 004263d2
    repne scasb al, byte ptr es:[edi]            # 004263d4
    not ecx                                      # 004263d6
    add ecx, -0x1                                # 004263d8
    test ecx, ecx                                # 004263db
    je.d8 L_00426410                             # 004263dd
    # block 0x004263df: entered by fall-through of je at 0x004263dd, 21 instruction(s), falls into the block at 0x00426410
    mov edi, dword ptr [ebp + arg_c]             # 004263df
    mov ecx, dword ptr [ebp - local_4]           # 004263e2
    mov edx, dword ptr [ecx]                     # 004263e5
    or ecx, -0x1                                 # 004263e7
    {load} xor eax, eax                          # 004263ea
    repne scasb al, byte ptr es:[edi]            # 004263ec
    not ecx                                      # 004263ee
    {load} sub edi, ecx                          # 004263f0
    {load} mov esi, edi                          # 004263f2
    {load} mov ebx, ecx                          # 004263f4
    {load} mov edi, edx                          # 004263f6
    or ecx, -0x1                                 # 004263f8
    {load} xor eax, eax                          # 004263fb
    repne scasb al, byte ptr es:[edi]            # 004263fd
    add edi, -0x1                                # 004263ff
    {load} mov ecx, ebx                          # 00426402
    shr ecx, 0x2                                 # 00426404
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00426407
    {load} mov ecx, ebx                          # 00426409
    and ecx, 0x3                                 # 0042640b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0042640e
L_00426410:
    # block 0x00426410: entered by je at 0x004263dd, 12 instruction(s), calls FUN_0052139c, ends with ret 0x8
    push 0x0                                     # 00426410
    push 0x0                                     # 00426412
    mov eax, dword ptr [ebp - local_4]           # 00426414
    mov ecx, dword ptr [eax]                     # 00426417
    push ecx                                     # 00426419
    call FUN_0052139c                            # 0042641a
    pop edi                                      # 0042641f
    pop esi                                      # 00426420
    pop ebx                                      # 00426421
    {load} mov esp, ebp                          # 00426422
    pop ebp                                      # 00426424
    ret 0x8                                      # 00426425

