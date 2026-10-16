# FUN_00524568
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524568
# extent:       0x00524568-0x00524655 (237 code bytes)
# span:         0x00524568-0x00524655 (code 237, tables 0, padding 0)
# sha256:       328b832317c887e5eb6bada2d8c4b06303dd57b7c92699907543244a7e303082
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524568
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_50, field_60; [esi + n] field_58, field_68, field_b0, field_b8
# callees:      calls FUN_0051d526, FUN_0051c2ab, FUN_0051d5e1; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 94 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_50, 0x50  # offset +0x50
.equ field_58, 0x58  # offset +0x58
.equ field_60, 0x60  # offset +0x60
.equ field_68, 0x68  # offset +0x68
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------
.set FUN_0051c2ab, .text + (0x0051c2ab - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051d5e1, .text + (0x0051d5e1 - 0x401000)

.org 0x00524568 - 0x401000
.globl FUN_00524568
FUN_00524568:
    # block 0x00524568: entry, 9 instruction(s), ends with jne to 0x0052464f (forward)
    push ebp                                     # 00524568
    {load} mov ebp, esp                          # 00524569
    sub esp, 0x10                                # 0052456b
    push esi                                     # 0052456e
    push edi                                     # 0052456f
    {load} mov esi, ecx                          # 00524570
    {load} xor edi, edi                          # 00524572
    cmp dword ptr [esi + field_b0], edi          # 00524574
    jne.d32 L_0052464f                           # 0052457a
    # block 0x00524580: entered by fall-through of jne at 0x0052457a, 8 instruction(s), ends with je to 0x0052459d (forward)
    mov eax, dword ptr [esi + field_b8]          # 00524580
    lea ecx, [esi + field_b8]                    # 00524586
    push ebx                                     # 0052458c
    push 0x1                                     # 0052458d
    pop ebx                                      # 0052458f
    test al, 0x4                                 # 00524590
    mov dword ptr [esi + field_b0], ebx          # 00524592
    je.d8 L_0052459d                             # 00524598
    # block 0x0052459a: entered by fall-through of je at 0x00524598, 1 instruction(s), falls into the block at 0x0052459d
    mov dword ptr [ebp + arg_8], ebx             # 0052459a
L_0052459d:
    # block 0x0052459d: entered by je at 0x00524598, 4 instruction(s), ends with je to 0x005245b2 (forward)
    and al, -0xd                                 # 0052459d
    cmp dword ptr [ebp + arg_8], edi             # 0052459f
    mov dword ptr [ecx], eax                     # 005245a2
    je.d8 L_005245b2                             # 005245a4
    # block 0x005245a6: entered by fall-through of je at 0x005245a4, 3 instruction(s), ends with je to 0x005245b2 (forward)
    mov ecx, dword ptr [esi + field_68]          # 005245a6
    {load} cmp ecx, edi                          # 005245a9
    je.d8 L_005245b2                             # 005245ab
    # block 0x005245ad: entered by fall-through of je at 0x005245ab, 2 instruction(s), calls indirect dword ptr [eax + 0x50], falls into the block at 0x005245b2
    mov eax, dword ptr [ecx]                     # 005245ad
    call dword ptr [eax + field_50]              # 005245af
L_005245b2:
    # block 0x005245b2: entered by je at 0x005245a4; je at 0x005245ab, 4 instruction(s), calls FUN_0051d526, ends with je to 0x0052462e (forward)
    {load} mov ecx, esi                          # 005245b2
    call FUN_0051d526                            # 005245b4
    test ah, 0x20                                # 005245b9
    je.d8 L_0052462e                             # 005245bc
    # block 0x005245be: entered by fall-through of je at 0x005245bc, 47 instruction(s), calls FUN_0051c2ab, indirect dword ptr [eax + 0x60], FUN_0051d5e1, ends with forward jump to 0x00524648
    mov eax, 0x7fff                              # 005245be
    push edi                                     # 005245c3
    mov dword ptr [ebp - local_8], eax           # 005245c4
    mov dword ptr [ebp - local_4], eax           # 005245c7
    lea eax, [ebp - local_10]                    # 005245ca
    {load} mov ecx, esi                          # 005245cd
    push eax                                     # 005245cf
    lea eax, [ebp - local_10]                    # 005245d0
    push eax                                     # 005245d3
    push ebx                                     # 005245d4
    mov ebx, 0xffff                              # 005245d5
    push 0xe900                                  # 005245da
    push ebx                                     # 005245df
    push edi                                     # 005245e0
    mov dword ptr [ebp - local_10], edi          # 005245e1
    mov dword ptr [ebp - local_c], edi           # 005245e4
    call FUN_0051c2ab                            # 005245e7
    lea eax, [ebp - local_10]                    # 005245ec
    push 0x1                                     # 005245ef
    push eax                                     # 005245f1
    lea eax, [esi + field_58]                    # 005245f2
    push eax                                     # 005245f5
    push 0x2                                     # 005245f6
    push 0xe900                                  # 005245f8
    push ebx                                     # 005245fd
    push edi                                     # 005245fe
    {load} mov ecx, esi                          # 005245ff
    call FUN_0051c2ab                            # 00524601
    mov eax, dword ptr [esi]                     # 00524606
    lea ecx, [ebp - local_10]                    # 00524608
    push edi                                     # 0052460b
    push ecx                                     # 0052460c
    {load} mov ecx, esi                          # 0052460d
    call dword ptr [eax + field_60]              # 0052460f
    mov eax, dword ptr [ebp - local_4]           # 00524612
    push 0x16                                    # 00524615
    sub eax, dword ptr [ebp - local_c]           # 00524617
    {load} mov ecx, esi                          # 0052461a
    push eax                                     # 0052461c
    mov eax, dword ptr [ebp - local_8]           # 0052461d
    sub eax, dword ptr [ebp - local_10]          # 00524620
    push eax                                     # 00524623
    push edi                                     # 00524624
    push edi                                     # 00524625
    push edi                                     # 00524626
    call FUN_0051d5e1                            # 00524627
    jmp.d8 L_00524648                            # 0052462c
L_0052462e:
    # block 0x0052462e: entered by je at 0x005245bc, 10 instruction(s), calls FUN_0051c2ab, falls into the block at 0x00524648
    push ebx                                     # 0052462e
    lea eax, [esi + field_58]                    # 0052462f
    push edi                                     # 00524632
    push eax                                     # 00524633
    push 0x2                                     # 00524634
    push 0xe900                                  # 00524636
    push 0xffff                                  # 0052463b
    push edi                                     # 00524640
    {load} mov ecx, esi                          # 00524641
    call FUN_0051c2ab                            # 00524643
L_00524648:
    # block 0x00524648: entered by jmp at 0x0052462c, 2 instruction(s), falls into the block at 0x0052464f
    mov dword ptr [esi + field_b0], edi          # 00524648
    pop ebx                                      # 0052464e
L_0052464f:
    # block 0x0052464f: entered by jne at 0x0052457a, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 0052464f
    pop esi                                      # 00524650
    leave                                        # 00524651
    ret 0x4                                      # 00524652

