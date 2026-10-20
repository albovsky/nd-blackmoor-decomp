# FUN_0041c3ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041c3ba
# extent:       0x0041c3ba-0x0041c509 (335 code bytes)
# span:         0x0041c3ba-0x0041c509 (code 335, tables 0, padding 0)
# sha256:       7ddcc1294d5cf10b2fa57729989f349ab51ffa07f9d02a0c7d72a572a4849283
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         action_family_3e_write_defaults
# naming:       native port src/action_family_3e.c:action_family_3e_write_defaults (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the summary is the acceptance note
# summary:      Extracted from the 3e constructor here (code move). The two copied globals 0x570378/0x57037c are .bss, referenced by no other code, so always empty. 3e oracle compares the whole object, 0 mismatches.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_a7, field_ae, field_b3, field_15d, field_163; [ecx + n] field_a5, field_a8, field_b0, field_b4, field_15f; [edx + n] field_a6, field_ac, field_b2, field_b5, field_15b, field_161
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_3e.c:action_family_3e_write_defaults (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 91 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_a5, 0xa5  # offset +0xa5
.equ field_a6, 0xa6  # offset +0xa6
.equ field_a7, 0xa7  # offset +0xa7
.equ field_a8, 0xa8  # offset +0xa8
.equ field_ac, 0xac  # offset +0xac
.equ field_ae, 0xae  # offset +0xae
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2
.equ field_b3, 0xb3  # offset +0xb3
.equ field_b4, 0xb4  # offset +0xb4
.equ field_b5, 0xb5  # offset +0xb5
.equ field_15b, 0x15b  # offset +0x15b
.equ field_15d, 0x15d  # offset +0x15d
.equ field_15f, 0x15f  # offset +0x15f
.equ field_161, 0x161  # offset +0x161
.equ field_163, 0x163  # offset +0x163

# --- external targets -----------------------------------------------

.org 0x0041c3ba - 0x401000
.globl FUN_0041c3ba
FUN_0041c3ba:
    # block 0x0041c3ba: entry, 91 instruction(s), ends with ret 0x4
    push ebp                                     # 0041c3ba
    {load} mov ebp, esp                          # 0041c3bb
    push ecx                                     # 0041c3bd
    push esi                                     # 0041c3be
    push edi                                     # 0041c3bf
    mov dword ptr [ebp - local_4], ecx           # 0041c3c0
    mov edi, 0x570378                            # 0041c3c3
    mov eax, dword ptr [ebp + arg_8]             # 0041c3c8
    add eax, 0x63                                # 0041c3cb
    {load} mov edx, eax                          # 0041c3ce
    or ecx, -0x1                                 # 0041c3d0
    {load} xor eax, eax                          # 0041c3d3
    repne scasb al, byte ptr es:[edi]            # 0041c3d5
    not ecx                                      # 0041c3d7
    {load} sub edi, ecx                          # 0041c3d9
    {load} mov esi, edi                          # 0041c3db
    {load} mov eax, ecx                          # 0041c3dd
    {load} mov edi, edx                          # 0041c3df
    shr ecx, 0x2                                 # 0041c3e1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c3e4
    {load} mov ecx, eax                          # 0041c3e6
    and ecx, 0x3                                 # 0041c3e8
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041c3eb
    mov edi, 0x57037c                            # 0041c3ed
    mov ecx, dword ptr [ebp + arg_8]             # 0041c3f2
    add ecx, 0x84                                # 0041c3f5
    {load} mov edx, ecx                          # 0041c3fb
    or ecx, -0x1                                 # 0041c3fd
    {load} xor eax, eax                          # 0041c400
    repne scasb al, byte ptr es:[edi]            # 0041c402
    not ecx                                      # 0041c404
    {load} sub edi, ecx                          # 0041c406
    {load} mov esi, edi                          # 0041c408
    {load} mov eax, ecx                          # 0041c40a
    {load} mov edi, edx                          # 0041c40c
    shr ecx, 0x2                                 # 0041c40e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c411
    {load} mov ecx, eax                          # 0041c413
    and ecx, 0x3                                 # 0041c415
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041c418
    mov ecx, dword ptr [ebp + arg_8]             # 0041c41a
    mov byte ptr [ecx + field_a5], 0x1           # 0041c41d
    mov edx, dword ptr [ebp + arg_8]             # 0041c424
    mov byte ptr [edx + field_a6], 0x2           # 0041c427
    mov eax, dword ptr [ebp + arg_8]             # 0041c42e
    mov byte ptr [eax + field_a7], 0x3           # 0041c431
    mov ecx, dword ptr [ebp + arg_8]             # 0041c438
    mov word ptr [ecx + field_a8], 0x0           # 0041c43b
    mov edx, dword ptr [ebp + arg_8]             # 0041c444
    mov word ptr [edx + field_ac], 0x1           # 0041c447
    mov eax, dword ptr [ebp + arg_8]             # 0041c450
    mov word ptr [eax + field_ae], 0x2           # 0041c453
    mov ecx, dword ptr [ebp + arg_8]             # 0041c45c
    mov word ptr [ecx + field_b0], 0x3           # 0041c45f
    mov edx, dword ptr [ebp + arg_8]             # 0041c468
    mov byte ptr [edx + field_b2], 0x1           # 0041c46b
    mov eax, dword ptr [ebp + arg_8]             # 0041c472
    mov byte ptr [eax + field_b3], 0x0           # 0041c475
    mov ecx, dword ptr [ebp + arg_8]             # 0041c47c
    mov byte ptr [ecx + field_b4], 0x2           # 0041c47f
    mov edx, dword ptr [ebp + arg_8]             # 0041c486
    mov byte ptr [edx + field_b5], 0x3           # 0041c489
    mov eax, 0x1010101                           # 0041c490
    mov ecx, dword ptr [ebp + arg_8]             # 0041c495
    add ecx, 0xb6                                # 0041c498
    mov dword ptr [ecx], eax                     # 0041c49e
    mov ecx, 0x10                                # 0041c4a0
    {load} xor eax, eax                          # 0041c4a5
    mov edi, dword ptr [ebp + arg_8]             # 0041c4a7
    add edi, 0xfa                                # 0041c4aa
    rep stosd dword ptr es:[edi], eax            # 0041c4b0
    mov ecx, 0x10                                # 0041c4b2
    {load} xor eax, eax                          # 0041c4b7
    mov edi, dword ptr [ebp + arg_8]             # 0041c4b9
    add edi, 0xba                                # 0041c4bc
    rep stosd dword ptr es:[edi], eax            # 0041c4c2
    mov edx, dword ptr [ebp + arg_8]             # 0041c4c4
    mov word ptr [edx + field_15b], 0xc          # 0041c4c7
    mov eax, dword ptr [ebp + arg_8]             # 0041c4d0
    mov word ptr [eax + field_15d], 0x2          # 0041c4d3
    mov ecx, dword ptr [ebp + arg_8]             # 0041c4dc
    mov word ptr [ecx + field_15f], 0x1          # 0041c4df
    mov edx, dword ptr [ebp + arg_8]             # 0041c4e8
    mov word ptr [edx + field_161], 0x1          # 0041c4eb
    mov eax, dword ptr [ebp + arg_8]             # 0041c4f4
    mov dword ptr [eax + field_163], 0x1         # 0041c4f7
    pop edi                                      # 0041c501
    pop esi                                      # 0041c502
    {load} mov esp, ebp                          # 0041c503
    pop ebp                                      # 0041c505
    ret 0x4                                      # 0041c506

