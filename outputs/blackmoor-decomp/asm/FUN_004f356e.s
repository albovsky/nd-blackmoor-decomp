# FUN_004f356e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f356e
# extent:       0x004f356e-0x004f379c (558 code bytes)
# span:         0x004f356e-0x004f379c (code 558, tables 0, padding 0)
# sha256:       e36ab4c8e70a7625c53b6b06af62d83c5e40f00d812a94596afe555bf51b489f
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f356e_unload
# naming:       native port src/original_methods_fl28a.c:m4f356e_unload (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4f356e_unload: the oracle runs every instruction of 0x4f356e..0x4f379c and both jump directions, comparing ordered host calls and memory. See tasks/fl28a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_8, field_152, field_28b, field_28f, field_297, field_29b, field_2f1, field_3c2, field_3d6; [ecx + n] field_8, field_156, field_162, field_166, field_28b, field_28f, field_293, field_29b, field_2f1; [edx + n] field_8, field_156, field_162, field_28f, field_293, field_297, field_29b, field_3ce, field_3d6
# callees:      calls FUN_004f709c, FUN_004f6334, FUN_004f61e7, FUN_0051dc6c, FUN_004fcef0, FUN_0050cee4; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28a.c:m4f356e_unload (function ledger class native_oracle_verified; also m4fc808_clear_slot, release_field; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 140 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_152, 0x152  # offset +0x152
.equ field_156, 0x156  # offset +0x156
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_28b, 0x28b  # offset +0x28b
.equ field_28f, 0x28f  # offset +0x28f
.equ field_293, 0x293  # offset +0x293
.equ field_297, 0x297  # offset +0x297
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2f1, 0x2f1  # offset +0x2f1
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d6, 0x3d6  # offset +0x3d6

# --- external targets -----------------------------------------------
.set FUN_004f61e7, .text + (0x004f61e7 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004fcef0, .text + (0x004fcef0 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004f356e - 0x401000
.globl FUN_004f356e
FUN_004f356e:
    # block 0x004f356e: entry, 16 instruction(s), calls FUN_004f709c, ends with jne to 0x004f35b1 (forward)
    push ebp                                     # 004f356e
    {load} mov ebp, esp                          # 004f356f
    sub esp, 0x10                                # 004f3571
    mov dword ptr [ebp - local_10], ecx          # 004f3574
    mov eax, dword ptr [ebp - local_10]          # 004f3577
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f357a
    mov ecx, dword ptr [ebp + arg_8]             # 004f3584
    imul ecx, ecx, 0x5bb                         # 004f3587
    mov edx, dword ptr [ebp - local_10]          # 004f358d
    mov eax, dword ptr [edx + field_3ce]         # 004f3590
    {load} add eax, ecx                          # 004f3596
    mov dword ptr [ebp - local_4], eax           # 004f3598
    mov ecx, dword ptr [ebp - local_10]          # 004f359b
    call FUN_004f709c                            # 004f359e
    test eax, eax                                # 004f35a3
    jne.d8 L_004f35b1                            # 004f35a5
    # block 0x004f35a7: entered by fall-through of jne at 0x004f35a5, 2 instruction(s), ends with forward jump to 0x004f3796
    mov eax, 0x1                                 # 004f35a7
    jmp.d32 L_004f3796                           # 004f35ac
L_004f35b1:
    # block 0x004f35b1: entered by jne at 0x004f35a5, 3 instruction(s), ends with je to 0x004f360f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f35b1
    cmp dword ptr [ecx + field_162], 0x0         # 004f35b4
    je.d8 L_004f360f                             # 004f35bb
    # block 0x004f35bd: entered by fall-through of je at 0x004f35bb, 3 instruction(s), ends with je to 0x004f360f (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f35bd
    cmp dword ptr [edx + field_29b], 0x0         # 004f35c0
    je.d8 L_004f360f                             # 004f35c7
    # block 0x004f35c9: entered by fall-through of je at 0x004f35c7, 3 instruction(s), ends with je to 0x004f360f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f35c9
    cmp dword ptr [eax + field_28f], 0x0         # 004f35cc
    je.d8 L_004f360f                             # 004f35d3
    # block 0x004f35d5: entered by fall-through of je at 0x004f35d3, 3 instruction(s), ends with je to 0x004f360f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f35d5
    cmp dword ptr [ecx + field_28b], 0x0         # 004f35d8
    je.d8 L_004f360f                             # 004f35df
    # block 0x004f35e1: entered by fall-through of je at 0x004f35df, 3 instruction(s), ends with jbe to 0x004f360f (forward)
    mov edx, dword ptr [ebp - local_10]          # 004f35e1
    cmp dword ptr [edx + field_3d6], 0x0         # 004f35e4
    jbe.d8 L_004f360f                            # 004f35eb
    # block 0x004f35ed: entered by fall-through of jbe at 0x004f35eb, 7 instruction(s), falls into the block at 0x004f360f
    mov eax, dword ptr [ebp - local_10]          # 004f35ed
    mov ecx, dword ptr [eax + field_3d6]         # 004f35f0
    sub ecx, 0x1                                 # 004f35f6
    mov edx, dword ptr [ebp - local_10]          # 004f35f9
    mov dword ptr [edx + field_3d6], ecx         # 004f35fc
    mov eax, dword ptr [ebp - local_4]           # 004f3602
    mov dword ptr [eax + field_28b], 0x0         # 004f3605
L_004f360f:
    # block 0x004f360f: entered by je at 0x004f35bb; je at 0x004f35c7; je at 0x004f35d3; je at 0x004f35df; jbe at 0x004f35eb, 3 instruction(s), ends with je to 0x004f3637 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f360f
    cmp dword ptr [ecx + field_28f], 0x0         # 004f3612
    je.d8 L_004f3637                             # 004f3619
    # block 0x004f361b: entered by fall-through of je at 0x004f3619, 6 instruction(s), calls FUN_004f6334, ends with je to 0x004f3637 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004f361b
    push edx                                     # 004f361e
    mov ecx, dword ptr [ebp - local_10]          # 004f361f
    call FUN_004f6334                            # 004f3622
    test eax, eax                                # 004f3627
    je.d8 L_004f3637                             # 004f3629
    # block 0x004f362b: entered by fall-through of je at 0x004f3629, 4 instruction(s), calls FUN_004f61e7, falls into the block at 0x004f3637
    mov eax, dword ptr [ebp + arg_8]             # 004f362b
    push eax                                     # 004f362e
    mov ecx, dword ptr [ebp - local_10]          # 004f362f
    call FUN_004f61e7                            # 004f3632
L_004f3637:
    # block 0x004f3637: entered by je at 0x004f3619; je at 0x004f3629, 3 instruction(s), ends with je to 0x004f3668 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f3637
    cmp dword ptr [ecx + field_293], 0x0         # 004f363a
    je.d8 L_004f3668                             # 004f3641
    # block 0x004f3643: entered by fall-through of je at 0x004f3641, 9 instruction(s), calls indirect dword ptr [ecx + 0x8], falls into the block at 0x004f3668
    mov edx, dword ptr [ebp - local_4]           # 004f3643
    mov eax, dword ptr [edx + field_293]         # 004f3646
    mov ecx, dword ptr [ebp - local_4]           # 004f364c
    mov edx, dword ptr [ecx + field_293]         # 004f364f
    mov ecx, dword ptr [edx]                     # 004f3655
    push eax                                     # 004f3657
    call dword ptr [ecx + field_8]               # 004f3658
    mov edx, dword ptr [ebp - local_4]           # 004f365b
    mov dword ptr [edx + field_293], 0x0         # 004f365e
L_004f3668:
    # block 0x004f3668: entered by je at 0x004f3641, 3 instruction(s), ends with je to 0x004f36bf (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f3668
    cmp dword ptr [eax + field_297], 0x0         # 004f366b
    je.d8 L_004f36bf                             # 004f3672
    # block 0x004f3674: entered by fall-through of je at 0x004f3672, 3 instruction(s), ends with je to 0x004f369a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f3674
    cmp dword ptr [ecx + field_166], 0x0         # 004f3677
    je.d8 L_004f369a                             # 004f367e
    # block 0x004f3680: entered by fall-through of je at 0x004f367e, 8 instruction(s), calls FUN_0051dc6c, ends with forward jump to 0x004f36b2
    mov edx, dword ptr [ebp - local_4]           # 004f3680
    mov eax, dword ptr [edx + field_297]         # 004f3683
    mov dword ptr [ebp - local_8], eax           # 004f3689
    mov ecx, dword ptr [ebp - local_8]           # 004f368c
    push ecx                                     # 004f368f
    call FUN_0051dc6c                            # 004f3690
    add esp, 0x4                                 # 004f3695
    jmp.d8 L_004f36b2                            # 004f3698
L_004f369a:
    # block 0x004f369a: entered by je at 0x004f367e, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004f36b2
    mov edx, dword ptr [ebp - local_4]           # 004f369a
    mov eax, dword ptr [edx + field_297]         # 004f369d
    mov dword ptr [ebp - local_c], eax           # 004f36a3
    mov ecx, dword ptr [ebp - local_c]           # 004f36a6
    push ecx                                     # 004f36a9
    call FUN_0051dc6c                            # 004f36aa
    add esp, 0x4                                 # 004f36af
L_004f36b2:
    # block 0x004f36b2: entered by jmp at 0x004f3698, 2 instruction(s), falls into the block at 0x004f36bf
    mov edx, dword ptr [ebp - local_4]           # 004f36b2
    mov dword ptr [edx + field_297], 0x0         # 004f36b5
L_004f36bf:
    # block 0x004f36bf: entered by je at 0x004f3672, 3 instruction(s), ends with je to 0x004f36f0 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f36bf
    cmp dword ptr [eax + field_29b], 0x0         # 004f36c2
    je.d8 L_004f36f0                             # 004f36c9
    # block 0x004f36cb: entered by fall-through of je at 0x004f36c9, 9 instruction(s), calls indirect dword ptr [eax + 0x8], falls into the block at 0x004f36f0
    mov ecx, dword ptr [ebp - local_4]           # 004f36cb
    mov edx, dword ptr [ecx + field_29b]         # 004f36ce
    mov eax, dword ptr [ebp - local_4]           # 004f36d4
    mov ecx, dword ptr [eax + field_29b]         # 004f36d7
    mov eax, dword ptr [ecx]                     # 004f36dd
    push edx                                     # 004f36df
    call dword ptr [eax + field_8]               # 004f36e0
    mov ecx, dword ptr [ebp - local_4]           # 004f36e3
    mov dword ptr [ecx + field_29b], 0x0         # 004f36e6
L_004f36f0:
    # block 0x004f36f0: entered by je at 0x004f36c9, 3 instruction(s), ends with je to 0x004f3721 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f36f0
    cmp dword ptr [edx + field_28f], 0x0         # 004f36f3
    je.d8 L_004f3721                             # 004f36fa
    # block 0x004f36fc: entered by fall-through of je at 0x004f36fa, 9 instruction(s), calls indirect dword ptr [edx + 0x8], falls into the block at 0x004f3721
    mov eax, dword ptr [ebp - local_4]           # 004f36fc
    mov ecx, dword ptr [eax + field_28f]         # 004f36ff
    mov edx, dword ptr [ebp - local_4]           # 004f3705
    mov eax, dword ptr [edx + field_28f]         # 004f3708
    mov edx, dword ptr [eax]                     # 004f370e
    push ecx                                     # 004f3710
    call dword ptr [edx + field_8]               # 004f3711
    mov eax, dword ptr [ebp - local_4]           # 004f3714
    mov dword ptr [eax + field_28f], 0x0         # 004f3717
L_004f3721:
    # block 0x004f3721: entered by je at 0x004f36fa, 3 instruction(s), ends with je to 0x004f374c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f3721
    cmp dword ptr [ecx + field_2f1], 0x0         # 004f3724
    je.d8 L_004f374c                             # 004f372b
    # block 0x004f372d: entered by fall-through of je at 0x004f372b, 7 instruction(s), calls FUN_004fcef0, falls into the block at 0x004f374c
    mov edx, dword ptr [ebp - local_4]           # 004f372d
    add edx, 0x2f1                               # 004f3730
    push edx                                     # 004f3736
    call FUN_004fcef0                            # 004f3737
    add esp, 0x4                                 # 004f373c
    mov eax, dword ptr [ebp - local_4]           # 004f373f
    mov dword ptr [eax + field_2f1], 0x0         # 004f3742
L_004f374c:
    # block 0x004f374c: entered by je at 0x004f372b, 3 instruction(s), ends with je to 0x004f3777 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f374c
    cmp dword ptr [ecx + field_156], 0x0         # 004f374f
    je.d8 L_004f3777                             # 004f3756
    # block 0x004f3758: entered by fall-through of je at 0x004f3756, 7 instruction(s), calls FUN_0050cee4, falls into the block at 0x004f3777
    mov edx, dword ptr [ebp - local_4]           # 004f3758
    mov eax, dword ptr [edx + field_156]         # 004f375b
    push eax                                     # 004f3761
    call FUN_0050cee4                            # 004f3762
    add esp, 0x4                                 # 004f3767
    mov ecx, dword ptr [ebp - local_4]           # 004f376a
    mov dword ptr [ecx + field_156], 0x0         # 004f376d
L_004f3777:
    # block 0x004f3777: entered by je at 0x004f3756, 5 instruction(s), falls into the block at 0x004f3796
    mov edx, dword ptr [ebp - local_4]           # 004f3777
    mov dword ptr [edx + field_162], 0x0         # 004f377a
    mov eax, dword ptr [ebp - local_4]           # 004f3784
    mov dword ptr [eax + field_152], 0x0         # 004f3787
    mov eax, 0x1                                 # 004f3791
L_004f3796:
    # block 0x004f3796: entered by jmp at 0x004f35ac, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f3796
    pop ebp                                      # 004f3798
    ret 0x4                                      # 004f3799

