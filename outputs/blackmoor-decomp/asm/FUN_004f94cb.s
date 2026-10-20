# FUN_004f94cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f94cb
# extent:       0x004f94cb-0x004f95a4 (217 code bytes)
# span:         0x004f94cb-0x004f95a4 (code 217, tables 0, padding 0)
# sha256:       9a04e8514cae57ee225bd09c10040e8f0adfb08ca8859cbd8d0dc6daa860989f
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_sound_apply_3d_max_distance
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4f94cb.c.txt, not original source) refers to the data labelled s_CDirectSound__Set3DSoundMaxDista_0055f208
# name-note:    Re-applies the stored channel 3D maximum distance; logs CDirectSound::Set3DSoundMaxDistance.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_29b, field_3ca, field_3d2; [ecx + n] field_29b, field_2d7, field_3ca, field_3ce; [edx + n] field_40, field_29b, field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_40, 0x40  # offset +0x40
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f94cb - 0x401000
.globl FUN_004f94cb
FUN_004f94cb:
    # block 0x004f94cb: entry, 15 instruction(s), ends with je to 0x004f959c (forward)
    push ebp                                     # 004f94cb
    {load} mov ebp, esp                          # 004f94cc
    sub esp, 0x8                                 # 004f94ce
    mov dword ptr [ebp - local_8], ecx           # 004f94d1
    mov eax, dword ptr [ebp + arg_8]             # 004f94d4
    imul eax, eax, 0x5bb                         # 004f94d7
    mov ecx, dword ptr [ebp - local_8]           # 004f94dd
    mov edx, dword ptr [ecx + field_3ce]         # 004f94e0
    {load} add edx, eax                          # 004f94e6
    mov dword ptr [ebp - local_4], edx           # 004f94e8
    mov eax, dword ptr [ebp - local_8]           # 004f94eb
    mov dword ptr [eax + field_3ca], 0x0         # 004f94ee
    mov ecx, dword ptr [ebp - local_4]           # 004f94f8
    cmp dword ptr [ecx + field_29b], 0x0         # 004f94fb
    je.d32 L_004f959c                            # 004f9502
    # block 0x004f9508: entered by fall-through of je at 0x004f9502, 3 instruction(s), ends with je to 0x004f951b (forward)
    {load} xor edx, edx                          # 004f9508
    test edx, edx                                # 004f950a
    je.d8 L_004f951b                             # 004f950c
    # block 0x004f950e: entered by fall-through of je at 0x004f950c, 2 instruction(s), falls into the block at 0x004f951b
    mov eax, dword ptr [ebp - local_8]           # 004f950e
    mov dword ptr [eax + field_3d2], 0x1         # 004f9511
L_004f951b:
    # block 0x004f951b: entered by je at 0x004f950c, 16 instruction(s), calls indirect dword ptr [edx + 0x40], ends with jne to 0x004f9598 (forward)
    push 0x0                                     # 004f951b
    mov ecx, dword ptr [ebp - local_4]           # 004f951d
    mov edx, dword ptr [ecx + field_2d7]         # 004f9520
    push edx                                     # 004f9526
    mov eax, dword ptr [ebp - local_4]           # 004f9527
    mov ecx, dword ptr [eax + field_29b]         # 004f952a
    mov edx, dword ptr [ebp - local_4]           # 004f9530
    mov eax, dword ptr [edx + field_29b]         # 004f9533
    mov edx, dword ptr [eax]                     # 004f9539
    push ecx                                     # 004f953b
    call dword ptr [edx + field_40]              # 004f953c
    mov ecx, dword ptr [ebp - local_8]           # 004f953f
    mov dword ptr [ecx + field_3ca], eax         # 004f9542
    mov edx, dword ptr [ebp - local_8]           # 004f9548
    cmp dword ptr [edx + field_3ca], 0x0         # 004f954b
    jne.d8 L_004f9598                            # 004f9552
    # block 0x004f9554: entered by fall-through of jne at 0x004f9552, 3 instruction(s), ends with je to 0x004f9591 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f9554
    test eax, eax                                # 004f955b
    je.d8 L_004f9591                             # 004f955d
    # block 0x004f955f: entered by fall-through of je at 0x004f955d, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f9591
    mov ecx, dword ptr [ebp - local_4]           # 004f955f
    fld dword ptr [ecx + field_2d7]              # 004f9562
    sub esp, 0x8                                 # 004f9568
    fstp qword ptr [esp]                         # 004f956b
    mov edx, dword ptr [ebp + arg_8]             # 004f956e
    push edx                                     # 004f9571
    push 0x55f208                                # 004f9572
    push 0x63888b                                # 004f9577
    call FUN_0050ca3e                            # 004f957c
    add esp, 0x14                                # 004f9581
    push 0x63888b                                # 004f9584
    call FUN_0044a2b7                            # 004f9589
    add esp, 0x4                                 # 004f958e
L_004f9591:
    # block 0x004f9591: entered by je at 0x004f955d, 2 instruction(s), ends with forward jump to 0x004f959e
    mov eax, 0x1                                 # 004f9591
    jmp.d8 L_004f959e                            # 004f9596
L_004f9598:
    # block 0x004f9598: entered by jne at 0x004f9552, 2 instruction(s), ends with forward jump to 0x004f959e
    {load} xor eax, eax                          # 004f9598
    jmp.d8 L_004f959e                            # 004f959a
L_004f959c:
    # block 0x004f959c: entered by je at 0x004f9502, 1 instruction(s), falls into the block at 0x004f959e
    {load} xor eax, eax                          # 004f959c
L_004f959e:
    # block 0x004f959e: entered by jmp at 0x004f9596; jmp at 0x004f959a, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f959e
    pop ebp                                      # 004f95a0
    ret 0x4                                      # 004f95a1

