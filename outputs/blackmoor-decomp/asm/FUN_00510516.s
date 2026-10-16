# FUN_00510516
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510516
# extent:       0x00510516-0x005105b1 (155 code bytes)
# span:         0x00510516-0x005105b1 (code 155, tables 0, padding 0)
# sha256:       ffd16cd686b801721f0eaf2b9566d1e97f8e891e23eb2a285631699ed8e482ed
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510516
# arguments:    8 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_14, field_1c; [ecx + n] field_8; [esi + n] field_4, field_c
# callees:      calls FUN_00510f3b, FUN_0051086b, FUN_005105b1; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 61 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_005105b1, .text + (0x005105b1 - 0x401000)
.set FUN_0051086b, .text + (0x0051086b - 0x401000)
.set FUN_00510f3b, .text + (0x00510f3b - 0x401000)

.org 0x00510516 - 0x401000
.globl FUN_00510516
FUN_00510516:
    # block 0x00510516: entry, 8 instruction(s), ends with je to 0x0051052c (forward)
    push ebp                                     # 00510516
    {load} mov ebp, esp                          # 00510517
    push esi                                     # 00510519
    mov esi, dword ptr [ebp + arg_18]            # 0051051a
    push edi                                     # 0051051d
    mov edi, 0x19930520                          # 0051051e
    cmp dword ptr [esi], edi                     # 00510523
    je.d8 L_0051052c                             # 00510525
    # block 0x00510527: entered by fall-through of je at 0x00510525, 1 instruction(s), calls FUN_00510f3b, falls into the block at 0x0051052c
    call FUN_00510f3b                            # 00510527
L_0051052c:
    # block 0x0051052c: entered by je at 0x00510525, 3 instruction(s), ends with je to 0x00510554 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0051052c
    test byte ptr [eax + field_4], 0x66          # 0051052f
    je.d8 L_00510554                             # 00510533
    # block 0x00510535: entered by fall-through of je at 0x00510533, 2 instruction(s), ends with je to 0x005105aa (forward)
    cmp dword ptr [esi + field_4], 0x0           # 00510535
    je.d8 L_005105aa                             # 00510539
    # block 0x0051053b: entered by fall-through of je at 0x00510539, 2 instruction(s), ends with jne to 0x005105aa (forward)
    cmp dword ptr [ebp + arg_1c], 0x0            # 0051053b
    jne.d8 L_005105aa                            # 0051053f
    # block 0x00510541: entered by fall-through of jne at 0x0051053f, 7 instruction(s), calls FUN_0051086b, ends with forward jump to 0x005105aa
    push -0x1                                    # 00510541
    push esi                                     # 00510543
    push dword ptr [ebp + arg_14]                # 00510544
    push dword ptr [ebp + arg_c]                 # 00510547
    call FUN_0051086b                            # 0051054a
    add esp, 0x10                                # 0051054f
    jmp.d8 L_005105aa                            # 00510552
L_00510554:
    # block 0x00510554: entered by je at 0x00510533, 2 instruction(s), ends with je to 0x005105aa (forward)
    cmp dword ptr [esi + field_c], 0x0           # 00510554
    je.d8 L_005105aa                             # 00510558
    # block 0x0051055a: entered by fall-through of je at 0x00510558, 2 instruction(s), ends with jne to 0x0051058e (forward)
    cmp dword ptr [eax], 0xe06d7363              # 0051055a
    jne.d8 L_0051058e                            # 00510560
    # block 0x00510562: entered by fall-through of jne at 0x00510560, 2 instruction(s), ends with jbe to 0x0051058e (forward)
    cmp dword ptr [eax + field_14], edi          # 00510562
    jbe.d8 L_0051058e                            # 00510565
    # block 0x00510567: entered by fall-through of jbe at 0x00510565, 4 instruction(s), ends with je to 0x0051058e (forward)
    mov ecx, dword ptr [eax + field_1c]          # 00510567
    mov ecx, dword ptr [ecx + field_8]           # 0051056a
    test ecx, ecx                                # 0051056d
    je.d8 L_0051058e                             # 0051056f
    # block 0x00510571: entered by fall-through of je at 0x0051056f, 12 instruction(s), calls indirect ecx, ends with forward jump to 0x005105ad
    movzx edx, byte ptr [ebp + arg_24]           # 00510571
    push edx                                     # 00510575
    push dword ptr [ebp + arg_20]                # 00510576
    push dword ptr [ebp + arg_1c]                # 00510579
    push esi                                     # 0051057c
    push dword ptr [ebp + arg_14]                # 0051057d
    push dword ptr [ebp + arg_10]                # 00510580
    push dword ptr [ebp + arg_c]                 # 00510583
    push eax                                     # 00510586
    call ecx                                     # 00510587
    add esp, 0x20                                # 00510589
    jmp.d8 L_005105ad                            # 0051058c
L_0051058e:
    # block 0x0051058e: entered by jne at 0x00510560; jbe at 0x00510565; je at 0x0051056f, 10 instruction(s), calls FUN_005105b1, falls into the block at 0x005105aa
    push dword ptr [ebp + arg_20]                # 0051058e
    push dword ptr [ebp + arg_1c]                # 00510591
    push dword ptr [ebp + arg_24]                # 00510594
    push esi                                     # 00510597
    push dword ptr [ebp + arg_14]                # 00510598
    push dword ptr [ebp + arg_10]                # 0051059b
    push dword ptr [ebp + arg_c]                 # 0051059e
    push eax                                     # 005105a1
    call FUN_005105b1                            # 005105a2
    add esp, 0x20                                # 005105a7
L_005105aa:
    # block 0x005105aa: entered by je at 0x00510539; jne at 0x0051053f; jmp at 0x00510552; je at 0x00510558, 2 instruction(s), falls into the block at 0x005105ad
    push 0x1                                     # 005105aa
    pop eax                                      # 005105ac
L_005105ad:
    # block 0x005105ad: entered by jmp at 0x0051058c, 4 instruction(s), ends with ret
    pop edi                                      # 005105ad
    pop esi                                      # 005105ae
    pop ebp                                      # 005105af
    ret                                          # 005105b0

