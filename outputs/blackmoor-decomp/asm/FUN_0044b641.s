# FUN_0044b641
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044b641
# extent:       0x0044b641-0x0044bdd8 (1943 code bytes)
# span:         0x0044b641-0x0044be44 (code 1943, tables 108, padding 0)
# sha256:       27194951c383075cc1ef5beb8d438c187e8f6d11e567ee0339cbee50bc7c93d6
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044b641
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       45 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 33 more
# fields:       [eax + n] field_1, field_3, field_4; [ecx + n] field_3, field_4, field_8; [edx + n] field_2, field_3, field_4, field_8
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/action_family_4f.h:action_family_4f_visit (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 526 instruction(s), 59 conditional branch(es) and 5 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0044b641 - 0x401000
.globl FUN_0044b641
FUN_0044b641:
    # block 0x0044b641: entry, 17 instruction(s), ends with jl to 0x0044b687 (forward)
    push ebp                                     # 0044b641
    {load} mov ebp, esp                          # 0044b642
    sub esp, 0xb4                                # 0044b644
    mov dword ptr [ebp - local_1c], ecx          # 0044b64a
    mov dword ptr [ebp - local_8], 0x0           # 0044b64d
    movsx eax, word ptr [ebp + arg_8]            # 0044b654
    imul eax, eax, 0x8d                          # 0044b658
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0044b65e
    mov dword ptr [ebp - local_18], ecx          # 0044b664
    mov edx, dword ptr [ebp - local_18]          # 0044b667
    mov al, byte ptr [edx + field_2]             # 0044b66a
    mov byte ptr [ebp - local_10], al            # 0044b66d
    mov ecx, dword ptr [ebp - local_18]          # 0044b670
    {load} xor edx, edx                          # 0044b673
    mov dl, byte ptr [ecx]                       # 0044b675
    test edx, edx                                # 0044b677
    jl.d8 L_0044b687                             # 0044b679
    # block 0x0044b67b: entered by fall-through of jl at 0x0044b679, 5 instruction(s), ends with jle to 0x0044b6bf (forward)
    mov eax, dword ptr [ebp - local_18]          # 0044b67b
    {load} xor ecx, ecx                          # 0044b67e
    mov cl, byte ptr [eax]                       # 0044b680
    cmp ecx, 0x27                                # 0044b682
    jle.d8 L_0044b6bf                            # 0044b685
L_0044b687:
    # block 0x0044b687: entered by jl at 0x0044b679; fall-through of jle at 0x0044b685, 3 instruction(s), ends with je to 0x0044b6ba (forward)
    movsx edx, word ptr [0x63a4cd]               # 0044b687
    test edx, edx                                # 0044b68e
    je.d8 L_0044b6ba                             # 0044b690
    # block 0x0044b692: entered by fall-through of je at 0x0044b690, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x0044b6ba
    mov eax, dword ptr [ebp - local_18]          # 0044b692
    {load} xor ecx, ecx                          # 0044b695
    mov cl, byte ptr [eax]                       # 0044b697
    push ecx                                     # 0044b699
    push 0x5490c8                                # 0044b69a
    push 0x63888b                                # 0044b69f
    call FUN_0050ca3e                            # 0044b6a4
    add esp, 0xc                                 # 0044b6a9
    push 0x0                                     # 0044b6ac
    push 0x0                                     # 0044b6ae
    push 0x63888b                                # 0044b6b0
    call FUN_0052139c                            # 0044b6b5
L_0044b6ba:
    # block 0x0044b6ba: entered by je at 0x0044b690, 1 instruction(s), ends with forward jump to 0x0044bdc5
    jmp.d32 L_0044bdc5                           # 0044b6ba
L_0044b6bf:
    # block 0x0044b6bf: entered by jle at 0x0044b685, 5 instruction(s), ends with jg to 0x0044b6e5 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0044b6bf
    {load} xor eax, eax                          # 0044b6c2
    mov al, byte ptr [edx]                       # 0044b6c4
    cmp eax, 0x1d                                # 0044b6c6
    jg.d8 L_0044b6e5                             # 0044b6c9
    # block 0x0044b6cb: entered by fall-through of jg at 0x0044b6c9, 8 instruction(s), ends with forward jump to 0x0044b6f6
    mov ecx, dword ptr [ebp - local_18]          # 0044b6cb
    {load} xor edx, edx                          # 0044b6ce
    mov dl, byte ptr [ecx]                       # 0044b6d0
    movsx eax, word ptr [2*edx + 0x58c959]       # 0044b6d2
    mov dword ptr [ebp - local_20], eax          # 0044b6da
    fild dword ptr [ebp - local_20]              # 0044b6dd
    fstp dword ptr [ebp - local_c]               # 0044b6e0
    jmp.d8 L_0044b6f6                            # 0044b6e3
L_0044b6e5:
    # block 0x0044b6e5: entered by jg at 0x0044b6c9, 5 instruction(s), falls into the block at 0x0044b6f6
    mov ecx, dword ptr [ebp - local_18]          # 0044b6e5
    {load} xor edx, edx                          # 0044b6e8
    mov dl, byte ptr [ecx]                       # 0044b6ea
    fld dword ptr [4*edx + 0x58c91d]             # 0044b6ec
    fstp dword ptr [ebp - local_c]               # 0044b6f3
L_0044b6f6:
    # block 0x0044b6f6: entered by jmp at 0x0044b6e3, 2 instruction(s), ends with jne to 0x0044b739 (forward)
    cmp dword ptr [ebp - local_c], 0x461c3c00    # 0044b6f6
    jne.d8 L_0044b739                            # 0044b6fd
    # block 0x0044b6ff: entered by fall-through of jne at 0x0044b6fd, 3 instruction(s), ends with je to 0x0044b734 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0044b6ff
    test eax, eax                                # 0044b706
    je.d8 L_0044b734                             # 0044b708
    # block 0x0044b70a: entered by fall-through of je at 0x0044b708, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x0044b734
    mov ecx, dword ptr [ebp - local_18]          # 0044b70a
    {load} xor edx, edx                          # 0044b70d
    mov dl, byte ptr [ecx]                       # 0044b70f
    add edx, 0x1                                 # 0044b711
    push edx                                     # 0044b714
    push 0x5490fc                                # 0044b715
    push 0x63888b                                # 0044b71a
    call FUN_0050ca3e                            # 0044b71f
    add esp, 0xc                                 # 0044b724
    push 0x63888b                                # 0044b727
    call FUN_0044a2b7                            # 0044b72c
    add esp, 0x4                                 # 0044b731
L_0044b734:
    # block 0x0044b734: entered by je at 0x0044b708, 1 instruction(s), ends with forward jump to 0x0044bda1
    jmp.d32 L_0044bda1                           # 0044b734
L_0044b739:
    # block 0x0044b739: entered by jne at 0x0044b6fd, 6 instruction(s), ends with ja to 0x0044bda1 (forward)
    mov eax, dword ptr [ebp - local_18]          # 0044b739
    {load} xor ecx, ecx                          # 0044b73c
    mov cl, byte ptr [eax + field_1]             # 0044b73e
    mov dword ptr [ebp - local_24], ecx          # 0044b741
    cmp dword ptr [ebp - local_24], 0x3          # 0044b744
    ja.d32 L_0044bda1                            # 0044b748
    # block 0x0044b74e: entered by fall-through of ja at 0x0044b748, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x44bdd8]
    mov edx, dword ptr [ebp - local_24]          # 0044b74e
    jmp dword ptr [4*edx + SWTAB_0044bdd8_VA]    # 0044b751
L_0044b758:
    # block 0x0044b758: entered by switch case, 1 instruction(s), falls into the block at 0x0044b75e
    mov word ptr [ebp - local_4], 0x1e           # 0044b758
L_0044b75e:
    # block 0x0044b75e: entered by jmp at 0x0044b878, 3 instruction(s), ends with jg to 0x0044b87d (forward)
    movsx eax, word ptr [ebp - local_4]          # 0044b75e
    cmp eax, 0x27                                # 0044b762
    jg.d32 L_0044b87d                            # 0044b765
    # block 0x0044b76b: entered by fall-through of jg at 0x0044b765, 2 instruction(s), ends with jne to 0x0044b87d (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0044b76b
    jne.d32 L_0044b87d                           # 0044b76f
    # block 0x0044b775: entered by fall-through of jne at 0x0044b76f, 5 instruction(s), ends with je to 0x0044b85e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0044b775
    fld dword ptr [4*ecx + 0x58c91d]             # 0044b779
    fstp dword ptr [ebp - local_14]              # 0044b780
    cmp dword ptr [ebp - local_14], 0x461c3c00   # 0044b783
    je.d32 L_0044b85e                            # 0044b78a
    # block 0x0044b790: entered by fall-through of je at 0x0044b78a, 6 instruction(s), ends with je to 0x0044b85e (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044b790
    mov eax, dword ptr [ebp - local_18]          # 0044b794
    {load} xor ecx, ecx                          # 0044b797
    mov cl, byte ptr [eax]                       # 0044b799
    {load} cmp edx, ecx                          # 0044b79b
    je.d32 L_0044b85e                            # 0044b79d
    # block 0x0044b7a3: entered by fall-through of je at 0x0044b79d, 5 instruction(s), ends with ja to 0x0044b85e (forward)
    mov edx, dword ptr [ebp - local_10]          # 0044b7a3
    and edx, 0xff                                # 0044b7a6
    mov dword ptr [ebp - local_28], edx          # 0044b7ac
    cmp dword ptr [ebp - local_28], 0x4          # 0044b7af
    ja.d32 L_0044b85e                            # 0044b7b3
    # block 0x0044b7b9: entered by fall-through of ja at 0x0044b7b3, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x44bde8]
    mov eax, dword ptr [ebp - local_28]          # 0044b7b9
    jmp dword ptr [4*eax + SWTAB_0044bde8_VA]    # 0044b7bc
L_0044b7c3:
    # block 0x0044b7c3: entered by switch case, 5 instruction(s), ends with je to 0x0044b7d7 (forward)
    fld dword ptr [ebp - local_c]                # 0044b7c3
    fcomp dword ptr [ebp - local_14]             # 0044b7c6
    fnstsw ax                                    # 0044b7c9
    test ah, 0x40                                # 0044b7cb
    je.d8 L_0044b7d7                             # 0044b7ce
    # block 0x0044b7d0: entered by fall-through of je at 0x0044b7ce, 1 instruction(s), falls into the block at 0x0044b7d7
    mov dword ptr [ebp - local_8], 0x1           # 0044b7d0
L_0044b7d7:
    # block 0x0044b7d7: entered by je at 0x0044b7ce, 1 instruction(s), ends with forward jump to 0x0044b85e
    jmp.d32 L_0044b85e                           # 0044b7d7
L_0044b7dc:
    # block 0x0044b7dc: entered by switch case, 5 instruction(s), ends with jne to 0x0044b7f0 (forward)
    fld dword ptr [ebp - local_c]                # 0044b7dc
    fcomp dword ptr [ebp - local_14]             # 0044b7df
    fnstsw ax                                    # 0044b7e2
    test ah, 0x41                                # 0044b7e4
    jne.d8 L_0044b7f0                            # 0044b7e7
    # block 0x0044b7e9: entered by fall-through of jne at 0x0044b7e7, 1 instruction(s), falls into the block at 0x0044b7f0
    mov dword ptr [ebp - local_8], 0x1           # 0044b7e9
L_0044b7f0:
    # block 0x0044b7f0: entered by jne at 0x0044b7e7, 1 instruction(s), ends with forward jump to 0x0044b85e
    jmp.d8 L_0044b85e                            # 0044b7f0
L_0044b7f2:
    # block 0x0044b7f2: entered by switch case, 5 instruction(s), ends with je to 0x0044b806 (forward)
    fld dword ptr [ebp - local_c]                # 0044b7f2
    fcomp dword ptr [ebp - local_14]             # 0044b7f5
    fnstsw ax                                    # 0044b7f8
    test ah, 0x1                                 # 0044b7fa
    je.d8 L_0044b806                             # 0044b7fd
    # block 0x0044b7ff: entered by fall-through of je at 0x0044b7fd, 1 instruction(s), falls into the block at 0x0044b806
    mov dword ptr [ebp - local_8], 0x1           # 0044b7ff
L_0044b806:
    # block 0x0044b806: entered by je at 0x0044b7fd, 1 instruction(s), ends with forward jump to 0x0044b85e
    jmp.d8 L_0044b85e                            # 0044b806
L_0044b808:
    # block 0x0044b808: entered by switch case, 12 instruction(s), ends with jne to 0x0044b832 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0044b808
    mov edx, dword ptr [ebp - local_18]          # 0044b80c
    {load} xor eax, eax                          # 0044b80f
    mov al, byte ptr [edx + ecx + field_3]       # 0044b811
    mov dword ptr [ebp - local_2c], eax          # 0044b815
    fild dword ptr [ebp - local_2c]              # 0044b818
    fstp dword ptr [ebp - local_30]              # 0044b81b
    fld dword ptr [ebp - local_c]                # 0044b81e
    fcomp dword ptr [ebp - local_30]             # 0044b821
    fnstsw ax                                    # 0044b824
    test ah, 0x1                                 # 0044b826
    jne.d8 L_0044b832                            # 0044b829
    # block 0x0044b82b: entered by fall-through of jne at 0x0044b829, 1 instruction(s), falls into the block at 0x0044b832
    mov dword ptr [ebp - local_8], 0x1           # 0044b82b
L_0044b832:
    # block 0x0044b832: entered by jne at 0x0044b829, 1 instruction(s), ends with forward jump to 0x0044b85e
    jmp.d8 L_0044b85e                            # 0044b832
L_0044b834:
    # block 0x0044b834: entered by switch case, 12 instruction(s), ends with je to 0x0044b85e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0044b834
    mov edx, dword ptr [ebp - local_18]          # 0044b838
    {load} xor eax, eax                          # 0044b83b
    mov al, byte ptr [edx + ecx + field_3]       # 0044b83d
    mov dword ptr [ebp - local_34], eax          # 0044b841
    fild dword ptr [ebp - local_34]              # 0044b844
    fstp dword ptr [ebp - local_38]              # 0044b847
    fld dword ptr [ebp - local_c]                # 0044b84a
    fcomp dword ptr [ebp - local_38]             # 0044b84d
    fnstsw ax                                    # 0044b850
    test ah, 0x41                                # 0044b852
    je.d8 L_0044b85e                             # 0044b855
    # block 0x0044b857: entered by fall-through of je at 0x0044b855, 1 instruction(s), falls into the block at 0x0044b85e
    mov dword ptr [ebp - local_8], 0x1           # 0044b857
L_0044b85e:
    # block 0x0044b85e: entered by je at 0x0044b78a; je at 0x0044b79d; ja at 0x0044b7b3; jmp at 0x0044b7d7; more, 2 instruction(s), ends with jne to 0x0044b86c (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 0044b85e
    jne.d8 L_0044b86c                            # 0044b862
    # block 0x0044b864: entered by fall-through of jne at 0x0044b862, 2 instruction(s), ends with forward jump to 0x0044b878
    mov word ptr [ebp - local_4], 0x5            # 0044b864
    jmp.d8 L_0044b878                            # 0044b86a
L_0044b86c:
    # block 0x0044b86c: entered by jne at 0x0044b862, 3 instruction(s), falls into the block at 0x0044b878
    mov cx, word ptr [ebp - local_4]             # 0044b86c
    add cx, 0x1                                  # 0044b870
    mov word ptr [ebp - local_4], cx             # 0044b874
L_0044b878:
    # block 0x0044b878: entered by jmp at 0x0044b86a, 1 instruction(s), ends with backward jump to 0x0044b75e
    jmp.d32 L_0044b75e                           # 0044b878
L_0044b87d:
    # block 0x0044b87d: entered by jg at 0x0044b765; jne at 0x0044b76f, 1 instruction(s), ends with forward jump to 0x0044bda1
    jmp.d32 L_0044bda1                           # 0044b87d
L_0044b882:
    # block 0x0044b882: entered by switch case, 1 instruction(s), falls into the block at 0x0044b888
    mov word ptr [ebp - local_4], 0x0            # 0044b882
L_0044b888:
    # block 0x0044b888: entered by jmp at 0x0044b9a9, 3 instruction(s), ends with jg to 0x0044b9ae (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044b888
    cmp edx, 0x1d                                # 0044b88c
    jg.d32 L_0044b9ae                            # 0044b88f
    # block 0x0044b895: entered by fall-through of jg at 0x0044b88f, 2 instruction(s), ends with jne to 0x0044b9ae (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0044b895
    jne.d32 L_0044b9ae                           # 0044b899
    # block 0x0044b89f: entered by fall-through of jne at 0x0044b899, 7 instruction(s), ends with je to 0x0044b98f (forward)
    movsx eax, word ptr [ebp - local_4]          # 0044b89f
    movsx ecx, word ptr [2*eax + 0x58c959]       # 0044b8a3
    mov dword ptr [ebp - local_3c], ecx          # 0044b8ab
    fild dword ptr [ebp - local_3c]              # 0044b8ae
    fstp dword ptr [ebp - local_14]              # 0044b8b1
    cmp dword ptr [ebp - local_14], 0x461c3c00   # 0044b8b4
    je.d32 L_0044b98f                            # 0044b8bb
    # block 0x0044b8c1: entered by fall-through of je at 0x0044b8bb, 6 instruction(s), ends with je to 0x0044b98f (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044b8c1
    mov eax, dword ptr [ebp - local_18]          # 0044b8c5
    {load} xor ecx, ecx                          # 0044b8c8
    mov cl, byte ptr [eax]                       # 0044b8ca
    {load} cmp edx, ecx                          # 0044b8cc
    je.d32 L_0044b98f                            # 0044b8ce
    # block 0x0044b8d4: entered by fall-through of je at 0x0044b8ce, 5 instruction(s), ends with ja to 0x0044b98f (forward)
    mov edx, dword ptr [ebp - local_10]          # 0044b8d4
    and edx, 0xff                                # 0044b8d7
    mov dword ptr [ebp - local_40], edx          # 0044b8dd
    cmp dword ptr [ebp - local_40], 0x4          # 0044b8e0
    ja.d32 L_0044b98f                            # 0044b8e4
    # block 0x0044b8ea: entered by fall-through of ja at 0x0044b8e4, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x44bdfc]
    mov eax, dword ptr [ebp - local_40]          # 0044b8ea
    jmp dword ptr [4*eax + SWTAB_0044bdfc_VA]    # 0044b8ed
L_0044b8f4:
    # block 0x0044b8f4: entered by switch case, 5 instruction(s), ends with je to 0x0044b908 (forward)
    fld dword ptr [ebp - local_c]                # 0044b8f4
    fcomp dword ptr [ebp - local_14]             # 0044b8f7
    fnstsw ax                                    # 0044b8fa
    test ah, 0x40                                # 0044b8fc
    je.d8 L_0044b908                             # 0044b8ff
    # block 0x0044b901: entered by fall-through of je at 0x0044b8ff, 1 instruction(s), falls into the block at 0x0044b908
    mov dword ptr [ebp - local_8], 0x1           # 0044b901
L_0044b908:
    # block 0x0044b908: entered by je at 0x0044b8ff, 1 instruction(s), ends with forward jump to 0x0044b98f
    jmp.d32 L_0044b98f                           # 0044b908
L_0044b90d:
    # block 0x0044b90d: entered by switch case, 5 instruction(s), ends with jne to 0x0044b921 (forward)
    fld dword ptr [ebp - local_c]                # 0044b90d
    fcomp dword ptr [ebp - local_14]             # 0044b910
    fnstsw ax                                    # 0044b913
    test ah, 0x41                                # 0044b915
    jne.d8 L_0044b921                            # 0044b918
    # block 0x0044b91a: entered by fall-through of jne at 0x0044b918, 1 instruction(s), falls into the block at 0x0044b921
    mov dword ptr [ebp - local_8], 0x1           # 0044b91a
L_0044b921:
    # block 0x0044b921: entered by jne at 0x0044b918, 1 instruction(s), ends with forward jump to 0x0044b98f
    jmp.d8 L_0044b98f                            # 0044b921
L_0044b923:
    # block 0x0044b923: entered by switch case, 5 instruction(s), ends with je to 0x0044b937 (forward)
    fld dword ptr [ebp - local_c]                # 0044b923
    fcomp dword ptr [ebp - local_14]             # 0044b926
    fnstsw ax                                    # 0044b929
    test ah, 0x1                                 # 0044b92b
    je.d8 L_0044b937                             # 0044b92e
    # block 0x0044b930: entered by fall-through of je at 0x0044b92e, 1 instruction(s), falls into the block at 0x0044b937
    mov dword ptr [ebp - local_8], 0x1           # 0044b930
L_0044b937:
    # block 0x0044b937: entered by je at 0x0044b92e, 1 instruction(s), ends with forward jump to 0x0044b98f
    jmp.d8 L_0044b98f                            # 0044b937
L_0044b939:
    # block 0x0044b939: entered by switch case, 12 instruction(s), ends with jne to 0x0044b963 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0044b939
    mov edx, dword ptr [ebp - local_18]          # 0044b93d
    {load} xor eax, eax                          # 0044b940
    mov al, byte ptr [edx + ecx + field_3]       # 0044b942
    mov dword ptr [ebp - local_44], eax          # 0044b946
    fild dword ptr [ebp - local_44]              # 0044b949
    fstp dword ptr [ebp - local_48]              # 0044b94c
    fld dword ptr [ebp - local_c]                # 0044b94f
    fcomp dword ptr [ebp - local_48]             # 0044b952
    fnstsw ax                                    # 0044b955
    test ah, 0x1                                 # 0044b957
    jne.d8 L_0044b963                            # 0044b95a
    # block 0x0044b95c: entered by fall-through of jne at 0x0044b95a, 1 instruction(s), falls into the block at 0x0044b963
    mov dword ptr [ebp - local_8], 0x1           # 0044b95c
L_0044b963:
    # block 0x0044b963: entered by jne at 0x0044b95a, 1 instruction(s), ends with forward jump to 0x0044b98f
    jmp.d8 L_0044b98f                            # 0044b963
L_0044b965:
    # block 0x0044b965: entered by switch case, 12 instruction(s), ends with je to 0x0044b98f (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0044b965
    mov edx, dword ptr [ebp - local_18]          # 0044b969
    {load} xor eax, eax                          # 0044b96c
    mov al, byte ptr [edx + ecx + field_3]       # 0044b96e
    mov dword ptr [ebp - local_4c], eax          # 0044b972
    fild dword ptr [ebp - local_4c]              # 0044b975
    fstp dword ptr [ebp - local_50]              # 0044b978
    fld dword ptr [ebp - local_c]                # 0044b97b
    fcomp dword ptr [ebp - local_50]             # 0044b97e
    fnstsw ax                                    # 0044b981
    test ah, 0x41                                # 0044b983
    je.d8 L_0044b98f                             # 0044b986
    # block 0x0044b988: entered by fall-through of je at 0x0044b986, 1 instruction(s), falls into the block at 0x0044b98f
    mov dword ptr [ebp - local_8], 0x1           # 0044b988
L_0044b98f:
    # block 0x0044b98f: entered by je at 0x0044b8bb; je at 0x0044b8ce; ja at 0x0044b8e4; jmp at 0x0044b908; more, 2 instruction(s), ends with jne to 0x0044b99d (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 0044b98f
    jne.d8 L_0044b99d                            # 0044b993
    # block 0x0044b995: entered by fall-through of jne at 0x0044b993, 2 instruction(s), ends with forward jump to 0x0044b9a9
    mov word ptr [ebp - local_4], 0x5            # 0044b995
    jmp.d8 L_0044b9a9                            # 0044b99b
L_0044b99d:
    # block 0x0044b99d: entered by jne at 0x0044b993, 3 instruction(s), falls into the block at 0x0044b9a9
    mov cx, word ptr [ebp - local_4]             # 0044b99d
    add cx, 0x1                                  # 0044b9a1
    mov word ptr [ebp - local_4], cx             # 0044b9a5
L_0044b9a9:
    # block 0x0044b9a9: entered by jmp at 0x0044b99b, 1 instruction(s), ends with backward jump to 0x0044b888
    jmp.d32 L_0044b888                           # 0044b9a9
L_0044b9ae:
    # block 0x0044b9ae: entered by jg at 0x0044b88f; jne at 0x0044b899, 1 instruction(s), ends with forward jump to 0x0044bda1
    jmp.d32 L_0044bda1                           # 0044b9ae
L_0044b9b3:
    # block 0x0044b9b3: entered by switch case, 2 instruction(s), falls into the block at 0x0044b9c0
    mov dword ptr [ebp - local_8], 0x0           # 0044b9b3
    mov word ptr [ebp - local_4], 0x0            # 0044b9ba
L_0044b9c0:
    # block 0x0044b9c0: entered by jmp at 0x0044bae5, 3 instruction(s), ends with jge to 0x0044baea (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044b9c0
    cmp edx, 0x5                                 # 0044b9c4
    jge.d32 L_0044baea                           # 0044b9c7
    # block 0x0044b9cd: entered by fall-through of jge at 0x0044b9c7, 2 instruction(s), ends with jne to 0x0044baea (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0044b9cd
    jne.d32 L_0044baea                           # 0044b9d1
    # block 0x0044b9d7: entered by fall-through of jne at 0x0044b9d1, 6 instruction(s), ends with je to 0x0044bacb (forward)
    movsx eax, word ptr [ebp - local_4]          # 0044b9d7
    mov ecx, dword ptr [ebp - local_18]          # 0044b9db
    {load} xor edx, edx                          # 0044b9de
    mov dl, byte ptr [ecx + eax + field_3]       # 0044b9e0
    cmp edx, 0x63                                # 0044b9e4
    je.d32 L_0044bacb                            # 0044b9e7
    # block 0x0044b9ed: entered by fall-through of je at 0x0044b9e7, 6 instruction(s), ends with jg to 0x0044ba1f (forward)
    movsx eax, word ptr [ebp - local_4]          # 0044b9ed
    mov ecx, dword ptr [ebp - local_18]          # 0044b9f1
    {load} xor edx, edx                          # 0044b9f4
    mov dl, byte ptr [ecx + eax + field_3]       # 0044b9f6
    cmp edx, 0x1d                                # 0044b9fa
    jg.d8 L_0044ba1f                             # 0044b9fd
    # block 0x0044b9ff: entered by fall-through of jg at 0x0044b9fd, 9 instruction(s), ends with forward jump to 0x0044ba36
    movsx eax, word ptr [ebp - local_4]          # 0044b9ff
    mov ecx, dword ptr [ebp - local_18]          # 0044ba03
    {load} xor edx, edx                          # 0044ba06
    mov dl, byte ptr [ecx + eax + field_3]       # 0044ba08
    movsx eax, word ptr [2*edx + 0x58c959]       # 0044ba0c
    mov dword ptr [ebp - local_54], eax          # 0044ba14
    fild dword ptr [ebp - local_54]              # 0044ba17
    fstp dword ptr [ebp - local_14]              # 0044ba1a
    jmp.d8 L_0044ba36                            # 0044ba1d
L_0044ba1f:
    # block 0x0044ba1f: entered by jg at 0x0044b9fd, 6 instruction(s), falls into the block at 0x0044ba36
    movsx ecx, word ptr [ebp - local_4]          # 0044ba1f
    mov edx, dword ptr [ebp - local_18]          # 0044ba23
    {load} xor eax, eax                          # 0044ba26
    mov al, byte ptr [edx + ecx + field_3]       # 0044ba28
    fld dword ptr [4*eax + 0x58c91d]             # 0044ba2c
    fstp dword ptr [ebp - local_14]              # 0044ba33
L_0044ba36:
    # block 0x0044ba36: entered by jmp at 0x0044ba1d, 2 instruction(s), ends with je to 0x0044bacb (forward)
    cmp dword ptr [ebp - local_14], 0x461c3c00   # 0044ba36
    je.d32 L_0044bacb                            # 0044ba3d
    # block 0x0044ba43: entered by fall-through of je at 0x0044ba3d, 5 instruction(s), ends with ja to 0x0044bacb (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0044ba43
    and ecx, 0xff                                # 0044ba46
    mov dword ptr [ebp - local_58], ecx          # 0044ba4c
    cmp dword ptr [ebp - local_58], 0x4          # 0044ba4f
    ja.d8 L_0044bacb                             # 0044ba53
    # block 0x0044ba55: entered by fall-through of ja at 0x0044ba53, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x44be10]
    mov edx, dword ptr [ebp - local_58]          # 0044ba55
    jmp dword ptr [4*edx + SWTAB_0044be10_VA]    # 0044ba58
L_0044ba5f:
    # block 0x0044ba5f: entered by switch case, 5 instruction(s), ends with je to 0x0044ba73 (forward)
    fld dword ptr [ebp - local_c]                # 0044ba5f
    fcomp dword ptr [ebp - local_14]             # 0044ba62
    fnstsw ax                                    # 0044ba65
    test ah, 0x40                                # 0044ba67
    je.d8 L_0044ba73                             # 0044ba6a
    # block 0x0044ba6c: entered by fall-through of je at 0x0044ba6a, 1 instruction(s), falls into the block at 0x0044ba73
    mov dword ptr [ebp - local_8], 0x1           # 0044ba6c
L_0044ba73:
    # block 0x0044ba73: entered by je at 0x0044ba6a, 1 instruction(s), ends with forward jump to 0x0044bacb
    jmp.d8 L_0044bacb                            # 0044ba73
L_0044ba75:
    # block 0x0044ba75: entered by switch case, 5 instruction(s), ends with jne to 0x0044ba89 (forward)
    fld dword ptr [ebp - local_c]                # 0044ba75
    fcomp dword ptr [ebp - local_14]             # 0044ba78
    fnstsw ax                                    # 0044ba7b
    test ah, 0x41                                # 0044ba7d
    jne.d8 L_0044ba89                            # 0044ba80
    # block 0x0044ba82: entered by fall-through of jne at 0x0044ba80, 1 instruction(s), falls into the block at 0x0044ba89
    mov dword ptr [ebp - local_8], 0x1           # 0044ba82
L_0044ba89:
    # block 0x0044ba89: entered by jne at 0x0044ba80, 1 instruction(s), ends with forward jump to 0x0044bacb
    jmp.d8 L_0044bacb                            # 0044ba89
L_0044ba8b:
    # block 0x0044ba8b: entered by switch case, 5 instruction(s), ends with je to 0x0044ba9f (forward)
    fld dword ptr [ebp - local_c]                # 0044ba8b
    fcomp dword ptr [ebp - local_14]             # 0044ba8e
    fnstsw ax                                    # 0044ba91
    test ah, 0x1                                 # 0044ba93
    je.d8 L_0044ba9f                             # 0044ba96
    # block 0x0044ba98: entered by fall-through of je at 0x0044ba96, 1 instruction(s), falls into the block at 0x0044ba9f
    mov dword ptr [ebp - local_8], 0x1           # 0044ba98
L_0044ba9f:
    # block 0x0044ba9f: entered by je at 0x0044ba96, 1 instruction(s), ends with forward jump to 0x0044bacb
    jmp.d8 L_0044bacb                            # 0044ba9f
L_0044baa1:
    # block 0x0044baa1: entered by switch case, 5 instruction(s), ends with jne to 0x0044bab5 (forward)
    fld dword ptr [ebp - local_c]                # 0044baa1
    fcomp dword ptr [ebp - local_14]             # 0044baa4
    fnstsw ax                                    # 0044baa7
    test ah, 0x1                                 # 0044baa9
    jne.d8 L_0044bab5                            # 0044baac
    # block 0x0044baae: entered by fall-through of jne at 0x0044baac, 1 instruction(s), falls into the block at 0x0044bab5
    mov dword ptr [ebp - local_8], 0x1           # 0044baae
L_0044bab5:
    # block 0x0044bab5: entered by jne at 0x0044baac, 1 instruction(s), ends with forward jump to 0x0044bacb
    jmp.d8 L_0044bacb                            # 0044bab5
L_0044bab7:
    # block 0x0044bab7: entered by switch case, 5 instruction(s), ends with je to 0x0044bacb (forward)
    fld dword ptr [ebp - local_c]                # 0044bab7
    fcomp dword ptr [ebp - local_14]             # 0044baba
    fnstsw ax                                    # 0044babd
    test ah, 0x41                                # 0044babf
    je.d8 L_0044bacb                             # 0044bac2
    # block 0x0044bac4: entered by fall-through of je at 0x0044bac2, 1 instruction(s), falls into the block at 0x0044bacb
    mov dword ptr [ebp - local_8], 0x1           # 0044bac4
L_0044bacb:
    # block 0x0044bacb: entered by je at 0x0044b9e7; je at 0x0044ba3d; ja at 0x0044ba53; jmp at 0x0044ba73; more, 2 instruction(s), ends with jne to 0x0044bad9 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 0044bacb
    jne.d8 L_0044bad9                            # 0044bacf
    # block 0x0044bad1: entered by fall-through of jne at 0x0044bacf, 2 instruction(s), ends with forward jump to 0x0044bae5
    mov word ptr [ebp - local_4], 0x5            # 0044bad1
    jmp.d8 L_0044bae5                            # 0044bad7
L_0044bad9:
    # block 0x0044bad9: entered by jne at 0x0044bacf, 3 instruction(s), falls into the block at 0x0044bae5
    mov ax, word ptr [ebp - local_4]             # 0044bad9
    .insn 0x66, 0x05, 0x0001{:u16}               # 0044badd
    mov word ptr [ebp - local_4], ax             # 0044bae1
L_0044bae5:
    # block 0x0044bae5: entered by jmp at 0x0044bad7, 1 instruction(s), ends with backward jump to 0x0044b9c0
    jmp.d32 L_0044b9c0                           # 0044bae5
L_0044baea:
    # block 0x0044baea: entered by jge at 0x0044b9c7; jne at 0x0044b9d1, 1 instruction(s), ends with forward jump to 0x0044bda1
    jmp.d32 L_0044bda1                           # 0044baea
L_0044baef:
    # block 0x0044baef: entered by switch case, 2 instruction(s), falls into the block at 0x0044bafc
    mov dword ptr [ebp - local_8], 0x0           # 0044baef
    mov word ptr [ebp - local_4], 0x0            # 0044baf6
L_0044bafc:
    # block 0x0044bafc: entered by jmp at 0x0044bd9c, 3 instruction(s), ends with jge to 0x0044bda1 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0044bafc
    cmp ecx, 0x5                                 # 0044bb00
    jge.d32 L_0044bda1                           # 0044bb03
    # block 0x0044bb09: entered by fall-through of jge at 0x0044bb03, 2 instruction(s), ends with jne to 0x0044bda1 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0044bb09
    jne.d32 L_0044bda1                           # 0044bb0d
    # block 0x0044bb13: entered by fall-through of jne at 0x0044bb0d, 6 instruction(s), ends with je to 0x0044bd82 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044bb13
    mov eax, dword ptr [ebp - local_18]          # 0044bb17
    {load} xor ecx, ecx                          # 0044bb1a
    mov cl, byte ptr [eax + edx + field_3]       # 0044bb1c
    cmp ecx, 0x63                                # 0044bb20
    je.d32 L_0044bd82                            # 0044bb23
    # block 0x0044bb29: entered by fall-through of je at 0x0044bb23, 5 instruction(s), ends with ja to 0x0044bd82 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0044bb29
    and edx, 0xff                                # 0044bb2c
    mov dword ptr [ebp - local_5c], edx          # 0044bb32
    cmp dword ptr [ebp - local_5c], 0x7          # 0044bb35
    ja.d32 L_0044bd82                            # 0044bb39
    # block 0x0044bb3f: entered by fall-through of ja at 0x0044bb39, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x44be24]
    mov eax, dword ptr [ebp - local_5c]          # 0044bb3f
    jmp dword ptr [4*eax + SWTAB_0044be24_VA]    # 0044bb42
L_0044bb49:
    # block 0x0044bb49: entered by switch case, 12 instruction(s), ends with je to 0x0044bb73 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0044bb49
    mov edx, dword ptr [ebp - local_18]          # 0044bb4d
    {load} xor eax, eax                          # 0044bb50
    mov al, byte ptr [edx + ecx + field_3]       # 0044bb52
    mov dword ptr [ebp - local_60], eax          # 0044bb56
    fild dword ptr [ebp - local_60]              # 0044bb59
    fstp dword ptr [ebp - local_64]              # 0044bb5c
    fld dword ptr [ebp - local_c]                # 0044bb5f
    fcomp dword ptr [ebp - local_64]             # 0044bb62
    fnstsw ax                                    # 0044bb65
    test ah, 0x40                                # 0044bb67
    je.d8 L_0044bb73                             # 0044bb6a
    # block 0x0044bb6c: entered by fall-through of je at 0x0044bb6a, 1 instruction(s), falls into the block at 0x0044bb73
    mov dword ptr [ebp - local_8], 0x1           # 0044bb6c
L_0044bb73:
    # block 0x0044bb73: entered by je at 0x0044bb6a, 1 instruction(s), ends with forward jump to 0x0044bd82
    jmp.d32 L_0044bd82                           # 0044bb73
L_0044bb78:
    # block 0x0044bb78: entered by switch case, 3 instruction(s), ends with jne to 0x0044bbcb (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0044bb78
    test ecx, ecx                                # 0044bb7c
    jne.d8 L_0044bbcb                            # 0044bb7e
    # block 0x0044bb80: entered by fall-through of jne at 0x0044bb7e, 21 instruction(s), ends with je to 0x0044bbc5 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0044bb80
    {load} xor eax, eax                          # 0044bb83
    mov al, byte ptr [edx + field_3]             # 0044bb85
    mov dword ptr [ebp - local_68], eax          # 0044bb88
    fild dword ptr [ebp - local_68]              # 0044bb8b
    fstp dword ptr [ebp - local_6c]              # 0044bb8e
    mov ecx, dword ptr [ebp - local_18]          # 0044bb91
    {load} xor edx, edx                          # 0044bb94
    mov dl, byte ptr [ecx + field_4]             # 0044bb96
    mov dword ptr [ebp - local_70], edx          # 0044bb99
    fild dword ptr [ebp - local_70]              # 0044bb9c
    fstp dword ptr [ebp - local_74]              # 0044bb9f
    fld dword ptr [ebp - local_6c]               # 0044bba2
    fmul dword ptr [ebp - local_74]              # 0044bba5
    fdiv dword ptr [0x52cbec]                    # 0044bba8
    fstp dword ptr [ebp - local_14]              # 0044bbae
    fld dword ptr [ebp - local_c]                # 0044bbb1
    fcomp dword ptr [ebp - local_14]             # 0044bbb4
    fnstsw ax                                    # 0044bbb7
    test ah, 0x40                                # 0044bbb9
    je.d8 L_0044bbc5                             # 0044bbbc
    # block 0x0044bbbe: entered by fall-through of je at 0x0044bbbc, 1 instruction(s), falls into the block at 0x0044bbc5
    mov dword ptr [ebp - local_8], 0x1           # 0044bbbe
L_0044bbc5:
    # block 0x0044bbc5: entered by je at 0x0044bbbc, 1 instruction(s), falls into the block at 0x0044bbcb
    mov word ptr [ebp - local_4], 0x5            # 0044bbc5
L_0044bbcb:
    # block 0x0044bbcb: entered by jne at 0x0044bb7e, 1 instruction(s), ends with forward jump to 0x0044bd82
    jmp.d32 L_0044bd82                           # 0044bbcb
L_0044bbd0:
    # block 0x0044bbd0: entered by switch case, 12 instruction(s), ends with jne to 0x0044bbfa (forward)
    movsx eax, word ptr [ebp - local_4]          # 0044bbd0
    mov ecx, dword ptr [ebp - local_18]          # 0044bbd4
    {load} xor edx, edx                          # 0044bbd7
    mov dl, byte ptr [ecx + eax + field_3]       # 0044bbd9
    mov dword ptr [ebp - local_78], edx          # 0044bbdd
    fild dword ptr [ebp - local_78]              # 0044bbe0
    fstp dword ptr [ebp - local_7c]              # 0044bbe3
    fld dword ptr [ebp - local_c]                # 0044bbe6
    fcomp dword ptr [ebp - local_7c]             # 0044bbe9
    fnstsw ax                                    # 0044bbec
    test ah, 0x41                                # 0044bbee
    jne.d8 L_0044bbfa                            # 0044bbf1
    # block 0x0044bbf3: entered by fall-through of jne at 0x0044bbf1, 1 instruction(s), falls into the block at 0x0044bbfa
    mov dword ptr [ebp - local_8], 0x1           # 0044bbf3
L_0044bbfa:
    # block 0x0044bbfa: entered by jne at 0x0044bbf1, 1 instruction(s), ends with forward jump to 0x0044bd82
    jmp.d32 L_0044bd82                           # 0044bbfa
L_0044bbff:
    # block 0x0044bbff: entered by switch case, 12 instruction(s), ends with je to 0x0044bc2f (forward)
    movsx eax, word ptr [ebp - local_4]          # 0044bbff
    mov ecx, dword ptr [ebp - local_18]          # 0044bc03
    {load} xor edx, edx                          # 0044bc06
    mov dl, byte ptr [ecx + eax + field_3]       # 0044bc08
    mov dword ptr [ebp - local_80], edx          # 0044bc0c
    fild dword ptr [ebp - local_80]              # 0044bc0f
    fstp dword ptr [ebp - local_84]              # 0044bc12
    fld dword ptr [ebp - local_c]                # 0044bc18
    fcomp dword ptr [ebp - local_84]             # 0044bc1b
    fnstsw ax                                    # 0044bc21
    test ah, 0x1                                 # 0044bc23
    je.d8 L_0044bc2f                             # 0044bc26
    # block 0x0044bc28: entered by fall-through of je at 0x0044bc26, 1 instruction(s), falls into the block at 0x0044bc2f
    mov dword ptr [ebp - local_8], 0x1           # 0044bc28
L_0044bc2f:
    # block 0x0044bc2f: entered by je at 0x0044bc26, 1 instruction(s), ends with forward jump to 0x0044bd82
    jmp.d32 L_0044bd82                           # 0044bc2f
L_0044bc34:
    # block 0x0044bc34: entered by switch case, 12 instruction(s), ends with jne to 0x0044bc6a (forward)
    movsx eax, word ptr [ebp - local_4]          # 0044bc34
    mov ecx, dword ptr [ebp - local_18]          # 0044bc38
    {load} xor edx, edx                          # 0044bc3b
    mov dl, byte ptr [ecx + eax + field_3]       # 0044bc3d
    mov dword ptr [ebp - local_88], edx          # 0044bc41
    fild dword ptr [ebp - local_88]              # 0044bc47
    fstp dword ptr [ebp - local_8c]              # 0044bc4d
    fld dword ptr [ebp - local_c]                # 0044bc53
    fcomp dword ptr [ebp - local_8c]             # 0044bc56
    fnstsw ax                                    # 0044bc5c
    test ah, 0x1                                 # 0044bc5e
    jne.d8 L_0044bc6a                            # 0044bc61
    # block 0x0044bc63: entered by fall-through of jne at 0x0044bc61, 1 instruction(s), falls into the block at 0x0044bc6a
    mov dword ptr [ebp - local_8], 0x1           # 0044bc63
L_0044bc6a:
    # block 0x0044bc6a: entered by jne at 0x0044bc61, 1 instruction(s), ends with forward jump to 0x0044bd82
    jmp.d32 L_0044bd82                           # 0044bc6a
L_0044bc6f:
    # block 0x0044bc6f: entered by switch case, 3 instruction(s), ends with jne to 0x0044bcda (forward)
    movsx eax, word ptr [ebp - local_4]          # 0044bc6f
    test eax, eax                                # 0044bc73
    jne.d8 L_0044bcda                            # 0044bc75
    # block 0x0044bc77: entered by fall-through of jne at 0x0044bc75, 21 instruction(s), ends with jne to 0x0044bcd4 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 0044bc77
    {load} xor edx, edx                          # 0044bc7a
    mov dl, byte ptr [ecx + field_3]             # 0044bc7c
    mov dword ptr [ebp - local_90], edx          # 0044bc7f
    fild dword ptr [ebp - local_90]              # 0044bc85
    fstp dword ptr [ebp - local_94]              # 0044bc8b
    mov eax, dword ptr [ebp - local_18]          # 0044bc91
    {load} xor ecx, ecx                          # 0044bc94
    mov cl, byte ptr [eax + field_4]             # 0044bc96
    mov dword ptr [ebp - local_98], ecx          # 0044bc99
    fild dword ptr [ebp - local_98]              # 0044bc9f
    fstp dword ptr [ebp - local_9c]              # 0044bca5
    fld dword ptr [ebp - local_94]               # 0044bcab
    fmul dword ptr [ebp - local_9c]              # 0044bcb1
    fdiv dword ptr [0x52cbec]                    # 0044bcb7
    fstp dword ptr [ebp - local_14]              # 0044bcbd
    fld dword ptr [ebp - local_c]                # 0044bcc0
    fcomp dword ptr [ebp - local_14]             # 0044bcc3
    fnstsw ax                                    # 0044bcc6
    test ah, 0x1                                 # 0044bcc8
    jne.d8 L_0044bcd4                            # 0044bccb
    # block 0x0044bccd: entered by fall-through of jne at 0x0044bccb, 1 instruction(s), falls into the block at 0x0044bcd4
    mov dword ptr [ebp - local_8], 0x1           # 0044bccd
L_0044bcd4:
    # block 0x0044bcd4: entered by jne at 0x0044bccb, 1 instruction(s), falls into the block at 0x0044bcda
    mov word ptr [ebp - local_4], 0x5            # 0044bcd4
L_0044bcda:
    # block 0x0044bcda: entered by jne at 0x0044bc75, 1 instruction(s), ends with forward jump to 0x0044bd82
    jmp.d32 L_0044bd82                           # 0044bcda
L_0044bcdf:
    # block 0x0044bcdf: entered by switch case, 12 instruction(s), ends with je to 0x0044bd15 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044bcdf
    mov eax, dword ptr [ebp - local_18]          # 0044bce3
    {load} xor ecx, ecx                          # 0044bce6
    mov cl, byte ptr [eax + edx + field_3]       # 0044bce8
    mov dword ptr [ebp - local_a0], ecx          # 0044bcec
    fild dword ptr [ebp - local_a0]              # 0044bcf2
    fstp dword ptr [ebp - local_a4]              # 0044bcf8
    fld dword ptr [ebp - local_c]                # 0044bcfe
    fcomp dword ptr [ebp - local_a4]             # 0044bd01
    fnstsw ax                                    # 0044bd07
    test ah, 0x41                                # 0044bd09
    je.d8 L_0044bd15                             # 0044bd0c
    # block 0x0044bd0e: entered by fall-through of je at 0x0044bd0c, 1 instruction(s), falls into the block at 0x0044bd15
    mov dword ptr [ebp - local_8], 0x1           # 0044bd0e
L_0044bd15:
    # block 0x0044bd15: entered by je at 0x0044bd0c, 1 instruction(s), ends with forward jump to 0x0044bd82
    jmp.d8 L_0044bd82                            # 0044bd15
L_0044bd17:
    # block 0x0044bd17: entered by switch case, 3 instruction(s), ends with jne to 0x0044bd82 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044bd17
    test edx, edx                                # 0044bd1b
    jne.d8 L_0044bd82                            # 0044bd1d
    # block 0x0044bd1f: entered by fall-through of jne at 0x0044bd1d, 21 instruction(s), ends with je to 0x0044bd7c (forward)
    mov eax, dword ptr [ebp - local_18]          # 0044bd1f
    {load} xor ecx, ecx                          # 0044bd22
    mov cl, byte ptr [eax + field_3]             # 0044bd24
    mov dword ptr [ebp - local_a8], ecx          # 0044bd27
    fild dword ptr [ebp - local_a8]              # 0044bd2d
    fstp dword ptr [ebp - local_ac]              # 0044bd33
    mov edx, dword ptr [ebp - local_18]          # 0044bd39
    {load} xor eax, eax                          # 0044bd3c
    mov al, byte ptr [edx + field_4]             # 0044bd3e
    mov dword ptr [ebp - local_b0], eax          # 0044bd41
    fild dword ptr [ebp - local_b0]              # 0044bd47
    fstp dword ptr [ebp - local_b4]              # 0044bd4d
    fld dword ptr [ebp - local_ac]               # 0044bd53
    fmul dword ptr [ebp - local_b4]              # 0044bd59
    fdiv dword ptr [0x52cbec]                    # 0044bd5f
    fstp dword ptr [ebp - local_14]              # 0044bd65
    fld dword ptr [ebp - local_c]                # 0044bd68
    fcomp dword ptr [ebp - local_14]             # 0044bd6b
    fnstsw ax                                    # 0044bd6e
    test ah, 0x41                                # 0044bd70
    je.d8 L_0044bd7c                             # 0044bd73
    # block 0x0044bd75: entered by fall-through of je at 0x0044bd73, 1 instruction(s), falls into the block at 0x0044bd7c
    mov dword ptr [ebp - local_8], 0x1           # 0044bd75
L_0044bd7c:
    # block 0x0044bd7c: entered by je at 0x0044bd73, 1 instruction(s), falls into the block at 0x0044bd82
    mov word ptr [ebp - local_4], 0x5            # 0044bd7c
L_0044bd82:
    # block 0x0044bd82: entered by je at 0x0044bb23; ja at 0x0044bb39; jmp at 0x0044bb73; jmp at 0x0044bbcb; more, 2 instruction(s), ends with jne to 0x0044bd90 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 0044bd82
    jne.d8 L_0044bd90                            # 0044bd86
    # block 0x0044bd88: entered by fall-through of jne at 0x0044bd86, 2 instruction(s), ends with forward jump to 0x0044bd9c
    mov word ptr [ebp - local_4], 0x5            # 0044bd88
    jmp.d8 L_0044bd9c                            # 0044bd8e
L_0044bd90:
    # block 0x0044bd90: entered by jne at 0x0044bd86, 3 instruction(s), falls into the block at 0x0044bd9c
    mov cx, word ptr [ebp - local_4]             # 0044bd90
    add cx, 0x1                                  # 0044bd94
    mov word ptr [ebp - local_4], cx             # 0044bd98
L_0044bd9c:
    # block 0x0044bd9c: entered by jmp at 0x0044bd8e, 1 instruction(s), ends with backward jump to 0x0044bafc
    jmp.d32 L_0044bafc                           # 0044bd9c
L_0044bda1:
    # block 0x0044bda1: entered by jmp at 0x0044b734; ja at 0x0044b748; jmp at 0x0044b87d; jmp at 0x0044b9ae; more, 2 instruction(s), ends with je to 0x0044bdc5 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0044bda1
    je.d8 L_0044bdc5                             # 0044bda5
    # block 0x0044bda7: entered by fall-through of je at 0x0044bda5, 4 instruction(s), ends with je to 0x0044bdc5 (forward)
    mov edx, dword ptr [ebp - local_18]          # 0044bda7
    movsx eax, word ptr [edx + field_8]          # 0044bdaa
    cmp eax, -0x1                                # 0044bdae
    je.d8 L_0044bdc5                             # 0044bdb1
    # block 0x0044bdb3: entered by fall-through of je at 0x0044bdb1, 3 instruction(s), falls into the block at 0x0044bdc5
    mov ecx, dword ptr [ebp - local_18]          # 0044bdb3
    movsx edx, word ptr [ecx + field_8]          # 0044bdb6
    mov dword ptr [4*edx + 0x585801], 0x1        # 0044bdba
L_0044bdc5:
    # block 0x0044bdc5: entered by jmp at 0x0044b6ba; je at 0x0044bda5; je at 0x0044bdb1, 7 instruction(s), calls FUN_0042ba3a, ends with ret 0x4
    mov ax, word ptr [ebp + arg_8]               # 0044bdc5
    push eax                                     # 0044bdc9
    call FUN_0042ba3a                            # 0044bdca
    add esp, 0x4                                 # 0044bdcf
    {load} mov esp, ebp                          # 0044bdd2
    pop ebp                                      # 0044bdd4
    ret 0x4                                      # 0044bdd5

# --- data items (not part of the function) -------------------------
.org 0x0044bdd8 - 0x401000
SWTAB_0044bdd8:  # 4 case address(es)
    .long L_0044b758 - .text + 0x401000
    .long L_0044b882 - .text + 0x401000
    .long L_0044b9b3 - .text + 0x401000
    .long L_0044baef - .text + 0x401000
.org 0x0044bde8 - 0x401000
SWTAB_0044bde8:  # 5 case address(es)
    .long L_0044b7c3 - .text + 0x401000
    .long L_0044b7f2 - .text + 0x401000
    .long L_0044b7dc - .text + 0x401000
    .long L_0044b808 - .text + 0x401000
    .long L_0044b834 - .text + 0x401000
.org 0x0044bdfc - 0x401000
SWTAB_0044bdfc:  # 5 case address(es)
    .long L_0044b8f4 - .text + 0x401000
    .long L_0044b923 - .text + 0x401000
    .long L_0044b90d - .text + 0x401000
    .long L_0044b939 - .text + 0x401000
    .long L_0044b965 - .text + 0x401000
.org 0x0044be10 - 0x401000
SWTAB_0044be10:  # 5 case address(es)
    .long L_0044ba5f - .text + 0x401000
    .long L_0044ba8b - .text + 0x401000
    .long L_0044ba75 - .text + 0x401000
    .long L_0044baa1 - .text + 0x401000
    .long L_0044bab7 - .text + 0x401000
.org 0x0044be24 - 0x401000
SWTAB_0044be24:  # 8 case address(es)
    .long L_0044bb49 - .text + 0x401000
    .long L_0044bbff - .text + 0x401000
    .long L_0044bbd0 - .text + 0x401000
    .long L_0044bc34 - .text + 0x401000
    .long L_0044bcdf - .text + 0x401000
    .long L_0044bb78 - .text + 0x401000
    .long L_0044bc6f - .text + 0x401000
    .long L_0044bd17 - .text + 0x401000
.set SWTAB_0044bdd8_VA, SWTAB_0044bdd8 - .text + 0x401000
.set SWTAB_0044bde8_VA, SWTAB_0044bde8 - .text + 0x401000
.set SWTAB_0044bdfc_VA, SWTAB_0044bdfc - .text + 0x401000
.set SWTAB_0044be10_VA, SWTAB_0044be10 - .text + 0x401000
.set SWTAB_0044be24_VA, SWTAB_0044be24 - .text + 0x401000

