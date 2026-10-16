# FUN_005105b1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005105b1
# extent:       0x005105b1-0x00510764 (435 code bytes)
# span:         0x005105b1-0x00510764 (code 435, tables 0, padding 0)
# sha256:       9bd2fc4c4caa6d3c90416c6997befd596d2c1219ed4e0564f6ac73f1e4da9530
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005105b1
# arguments:    8 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_8, field_c, field_6c, field_70; [ebx + n] field_4, field_c, field_10; [ecx + n] field_4; [esi + n] field_10, field_14, field_1c
# callees:      calls FUN_00510f3b, FUN_00510dd3, FUN_00516600, FUN_0050c8a0, FUN_0051080e, FUN_00510909, FUN_00510c8d, FUN_00510764, tail jump FUN_00510eda
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 149 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ arg_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------
.set FUN_0050c8a0, .text + (0x0050c8a0 - 0x401000)
.set FUN_00510764, .text + (0x00510764 - 0x401000)
.set FUN_0051080e, .text + (0x0051080e - 0x401000)
.set FUN_00510909, .text + (0x00510909 - 0x401000)
.set FUN_00510c8d, .text + (0x00510c8d - 0x401000)
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)
.set FUN_00510eda, .text + (0x00510eda - 0x401000)
.set FUN_00510f3b, .text + (0x00510f3b - 0x401000)
.set FUN_00516600, .text + (0x00516600 - 0x401000)

.org 0x005105b1 - 0x401000
.globl FUN_005105b1
FUN_005105b1:
    # block 0x005105b1: entry, 9 instruction(s), ends with jl to 0x005105d1 (forward)
    push ebp                                     # 005105b1
    {load} mov ebp, esp                          # 005105b2
    sub esp, 0x18                                # 005105b4
    mov eax, dword ptr [ebp + arg_c]             # 005105b7
    and byte ptr [ebp - local_14], 0x0           # 005105ba
    mov eax, dword ptr [eax + field_8]           # 005105be
    cmp eax, -0x1                                # 005105c1
    mov dword ptr [ebp - local_10], eax          # 005105c4
    jl.d8 L_005105d1                             # 005105c7
    # block 0x005105c9: entered by fall-through of jl at 0x005105c7, 3 instruction(s), ends with jl to 0x005105d6 (forward)
    mov ecx, dword ptr [ebp + arg_18]            # 005105c9
    cmp eax, dword ptr [ecx + field_4]           # 005105cc
    jl.d8 L_005105d6                             # 005105cf
L_005105d1:
    # block 0x005105d1: entered by jl at 0x005105c7; fall-through of jl at 0x005105cf, 1 instruction(s), calls FUN_00510f3b, falls into the block at 0x005105d6
    call FUN_00510f3b                            # 005105d1
L_005105d6:
    # block 0x005105d6: entered by jl at 0x005105cf, 8 instruction(s), ends with jne to 0x00510739 (forward)
    push ebx                                     # 005105d6
    push esi                                     # 005105d7
    mov esi, dword ptr [ebp + arg_8]             # 005105d8
    mov ebx, 0xe06d7363                          # 005105db
    push edi                                     # 005105e0
    mov edi, 0x19930520                          # 005105e1
    cmp dword ptr [esi], ebx                     # 005105e6
    jne.d32 L_00510739                           # 005105e8
    # block 0x005105ee: entered by fall-through of jne at 0x005105e8, 2 instruction(s), ends with jne to 0x00510656 (forward)
    cmp dword ptr [esi + field_10], 0x3          # 005105ee
    jne.d8 L_00510656                            # 005105f2
    # block 0x005105f4: entered by fall-through of jne at 0x005105f2, 2 instruction(s), ends with jne to 0x00510656 (forward)
    cmp dword ptr [esi + field_14], edi          # 005105f4
    jne.d8 L_00510656                            # 005105f7
    # block 0x005105f9: entered by fall-through of jne at 0x005105f7, 2 instruction(s), ends with jne to 0x00510656 (forward)
    cmp dword ptr [esi + field_1c], 0x0          # 005105f9
    jne.d8 L_00510656                            # 005105fd
    # block 0x005105ff: entered by fall-through of jne at 0x005105fd, 3 instruction(s), calls FUN_00510dd3, ends with je to 0x00510734 (forward)
    call FUN_00510dd3                            # 005105ff
    cmp dword ptr [eax + field_6c], 0x0          # 00510604
    je.d32 L_00510734                            # 00510608
    # block 0x0051060e: entered by fall-through of je at 0x00510608, 13 instruction(s), calls FUN_00510dd3, FUN_00516600, ends with jne to 0x00510638 (forward)
    call FUN_00510dd3                            # 0051060e
    mov esi, dword ptr [eax + field_6c]          # 00510613
    call FUN_00510dd3                            # 00510616
    mov eax, dword ptr [eax + field_70]          # 0051061b
    push 0x1                                     # 0051061e
    push esi                                     # 00510620
    mov dword ptr [ebp + arg_10], eax            # 00510621
    mov byte ptr [ebp - local_14], 0x1           # 00510624
    call FUN_00516600                            # 00510628
    pop ecx                                      # 0051062d
    test eax, eax                                # 0051062e
    pop ecx                                      # 00510630
    jne.d8 L_00510638                            # 00510631
    # block 0x00510633: entered by fall-through of jne at 0x00510631, 1 instruction(s), calls FUN_00510f3b, falls into the block at 0x00510638
    call FUN_00510f3b                            # 00510633
L_00510638:
    # block 0x00510638: entered by jne at 0x00510631, 2 instruction(s), ends with jne to 0x00510739 (forward)
    cmp dword ptr [esi], ebx                     # 00510638
    jne.d32 L_00510739                           # 0051063a
    # block 0x00510640: entered by fall-through of jne at 0x0051063a, 2 instruction(s), ends with jne to 0x00510656 (forward)
    cmp dword ptr [esi + field_10], 0x3          # 00510640
    jne.d8 L_00510656                            # 00510644
    # block 0x00510646: entered by fall-through of jne at 0x00510644, 2 instruction(s), ends with jne to 0x00510656 (forward)
    cmp dword ptr [esi + field_14], edi          # 00510646
    jne.d8 L_00510656                            # 00510649
    # block 0x0051064b: entered by fall-through of jne at 0x00510649, 2 instruction(s), ends with jne to 0x00510656 (forward)
    cmp dword ptr [esi + field_1c], 0x0          # 0051064b
    jne.d8 L_00510656                            # 0051064f
    # block 0x00510651: entered by fall-through of jne at 0x0051064f, 1 instruction(s), calls FUN_00510f3b, falls into the block at 0x00510656
    call FUN_00510f3b                            # 00510651
L_00510656:
    # block 0x00510656: entered by jne at 0x005105f2; jne at 0x005105f7; jne at 0x005105fd; jne at 0x00510644; more, 2 instruction(s), ends with jne to 0x00510739 (forward)
    cmp dword ptr [esi], ebx                     # 00510656
    jne.d32 L_00510739                           # 00510658
    # block 0x0051065e: entered by fall-through of jne at 0x00510658, 2 instruction(s), ends with jne to 0x00510739 (forward)
    cmp dword ptr [esi + field_10], 0x3          # 0051065e
    jne.d32 L_00510739                           # 00510662
    # block 0x00510668: entered by fall-through of jne at 0x00510662, 2 instruction(s), ends with jne to 0x00510739 (forward)
    cmp dword ptr [esi + field_14], edi          # 00510668
    jne.d32 L_00510739                           # 0051066b
    # block 0x00510671: entered by fall-through of jne at 0x0051066b, 11 instruction(s), calls FUN_0050c8a0, falls into the block at 0x0051068d
    mov edi, dword ptr [ebp - local_10]          # 00510671
    lea eax, [ebp - local_18]                    # 00510674
    push eax                                     # 00510677
    lea eax, [ebp - local_4]                     # 00510678
    push eax                                     # 0051067b
    push edi                                     # 0051067c
    push dword ptr [ebp + arg_20]                # 0051067d
    push dword ptr [ebp + arg_18]                # 00510680
    call FUN_0050c8a0                            # 00510683
    add esp, 0x14                                # 00510688
    {load} mov ebx, eax                          # 0051068b
L_0051068d:
    # block 0x0051068d: entered by jmp at 0x0051071f, 3 instruction(s), ends with jae to 0x00510724 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0051068d
    cmp eax, dword ptr [ebp - local_18]          # 00510690
    jae.d32 L_00510724                           # 00510693
    # block 0x00510699: entered by fall-through of jae at 0x00510693, 2 instruction(s), ends with jg to 0x00510719 (forward)
    cmp dword ptr [ebx], edi                     # 00510699
    jg.d8 L_00510719                             # 0051069b
    # block 0x0051069d: entered by fall-through of jg at 0x0051069b, 2 instruction(s), ends with jg to 0x00510719 (forward)
    cmp edi, dword ptr [ebx + field_4]           # 0051069d
    jg.d8 L_00510719                             # 005106a0
    # block 0x005106a2: entered by fall-through of jg at 0x005106a0, 6 instruction(s), ends with jle to 0x00510716 (forward)
    mov eax, dword ptr [ebx + field_10]          # 005106a2
    mov dword ptr [ebp + arg_8], eax             # 005106a5
    mov eax, dword ptr [ebx + field_c]           # 005106a8
    test eax, eax                                # 005106ab
    mov dword ptr [ebp - local_c], eax           # 005106ad
    jle.d8 L_00510716                            # 005106b0
L_005106b2:
    # block 0x005106b2: entered by jg at 0x005106ee; fall-through of jle at 0x005106b0, 7 instruction(s), ends with jle to 0x005106e3 (forward)
    mov eax, dword ptr [esi + field_1c]          # 005106b2
    mov eax, dword ptr [eax + field_c]           # 005106b5
    lea edi, [eax + field_4]                     # 005106b8
    mov eax, dword ptr [eax]                     # 005106bb
    test eax, eax                                # 005106bd
    mov dword ptr [ebp - local_8], eax           # 005106bf
    jle.d8 L_005106e3                            # 005106c2
L_005106c4:
    # block 0x005106c4: entered by jg at 0x005106e1; fall-through of jle at 0x005106c2, 7 instruction(s), calls FUN_0051080e, ends with jne to 0x005106f2 (forward)
    push dword ptr [esi + field_1c]              # 005106c4
    push dword ptr [edi]                         # 005106c7
    push dword ptr [ebp + arg_8]                 # 005106c9
    call FUN_0051080e                            # 005106cc
    add esp, 0xc                                 # 005106d1
    test eax, eax                                # 005106d4
    jne.d8 L_005106f2                            # 005106d6
    # block 0x005106d8: entered by fall-through of jne at 0x005106d6, 4 instruction(s), ends with jg to 0x005106c4 (backward)
    dec dword ptr [ebp - local_8]                # 005106d8
    add edi, 0x4                                 # 005106db
    cmp dword ptr [ebp - local_8], eax           # 005106de
    jg.d8 L_005106c4                             # 005106e1
L_005106e3:
    # block 0x005106e3: entered by jle at 0x005106c2; fall-through of jg at 0x005106e1, 4 instruction(s), ends with jg to 0x005106b2 (backward)
    dec dword ptr [ebp - local_c]                # 005106e3
    add dword ptr [ebp + arg_8], 0x10            # 005106e6
    cmp dword ptr [ebp - local_c], 0x0           # 005106ea
    jg.d8 L_005106b2                             # 005106ee
    # block 0x005106f0: entered by fall-through of jg at 0x005106ee, 1 instruction(s), ends with forward jump to 0x00510716
    jmp.d8 L_00510716                            # 005106f0
L_005106f2:
    # block 0x005106f2: entered by jne at 0x005106d6, 13 instruction(s), calls FUN_00510909, falls into the block at 0x00510716
    push dword ptr [ebp - local_14]              # 005106f2
    push dword ptr [ebp + arg_24]                # 005106f5
    push dword ptr [ebp + arg_20]                # 005106f8
    push ebx                                     # 005106fb
    push dword ptr [edi]                         # 005106fc
    push dword ptr [ebp + arg_8]                 # 005106fe
    push dword ptr [ebp + arg_18]                # 00510701
    push dword ptr [ebp + arg_14]                # 00510704
    push dword ptr [ebp + arg_10]                # 00510707
    push dword ptr [ebp + arg_c]                 # 0051070a
    push esi                                     # 0051070d
    call FUN_00510909                            # 0051070e
    add esp, 0x2c                                # 00510713
L_00510716:
    # block 0x00510716: entered by jle at 0x005106b0; jmp at 0x005106f0, 1 instruction(s), falls into the block at 0x00510719
    mov edi, dword ptr [ebp - local_10]          # 00510716
L_00510719:
    # block 0x00510719: entered by jg at 0x0051069b; jg at 0x005106a0, 3 instruction(s), ends with backward jump to 0x0051068d
    inc dword ptr [ebp - local_4]                # 00510719
    add ebx, 0x14                                # 0051071c
    jmp.d32 L_0051068d                           # 0051071f
L_00510724:
    # block 0x00510724: entered by jae at 0x00510693, 2 instruction(s), ends with je to 0x00510734 (forward)
    cmp byte ptr [ebp + arg_1c], 0x0             # 00510724
    je.d8 L_00510734                             # 00510728
    # block 0x0051072a: entered by fall-through of je at 0x00510728, 5 instruction(s), calls FUN_00510c8d, falls into the block at 0x00510734
    push 0x1                                     # 0051072a
    push esi                                     # 0051072c
    call FUN_00510c8d                            # 0051072d
    pop ecx                                      # 00510732
    pop ecx                                      # 00510733
L_00510734:
    # block 0x00510734: entered by je at 0x00510608; je at 0x00510728; jmp at 0x0051075d, 5 instruction(s), ends with ret
    pop edi                                      # 00510734
    pop esi                                      # 00510735
    pop ebx                                      # 00510736
    leave                                        # 00510737
    ret                                          # 00510738
L_00510739:
    # block 0x00510739: entered by jne at 0x005105e8; jne at 0x0051063a; jne at 0x00510658; jne at 0x00510662; more, 2 instruction(s), ends with jne to 0x0051075f (forward)
    cmp byte ptr [ebp + arg_1c], 0x0             # 00510739
    jne.d8 L_0051075f                            # 0051073d
    # block 0x0051073f: entered by fall-through of jne at 0x0051073d, 11 instruction(s), calls FUN_00510764, ends with backward jump to 0x00510734
    push dword ptr [ebp + arg_24]                # 0051073f
    push dword ptr [ebp + arg_20]                # 00510742
    push dword ptr [ebp - local_10]              # 00510745
    push dword ptr [ebp + arg_18]                # 00510748
    push dword ptr [ebp + arg_14]                # 0051074b
    push dword ptr [ebp + arg_10]                # 0051074e
    push dword ptr [ebp + arg_c]                 # 00510751
    push esi                                     # 00510754
    call FUN_00510764                            # 00510755
    add esp, 0x20                                # 0051075a
    jmp.d8 L_00510734                            # 0051075d
L_0051075f:
    # block 0x0051075f: entered by jne at 0x0051073d, 1 instruction(s), ends with forward jump to 0x00510eda
    jmp.d32 FUN_00510eda                         # 0051075f

