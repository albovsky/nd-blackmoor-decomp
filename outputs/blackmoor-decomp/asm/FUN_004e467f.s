# FUN_004e467f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e467f
# extent:       0x004e467f-0x004e498d (782 code bytes)
# span:         0x004e467f-0x004e498d (code 782, tables 0, padding 0)
# sha256:       09b7c5e06d0a168981f99e350b68b43eb17554a7c291b2ee541d5cf892ecfd74
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e467f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c, field_1477, field_4528, field_456d, field_4577, field_53bf; [ecx + n] field_4, field_8, field_a, field_c, field_4528, field_4530, field_456d, field_4577, field_53bf, field_65d6; [edx + n] field_4, field_8, field_a, field_c, field_1ca2, field_4530, field_4577, field_53bf, field_65cc
# callees:      calls FUN_004ee517, FUN_004e26fc, FUN_004e40a6, KERNEL32.dll!GetTickCount, FUN_004e3cd7, FUN_004e7512
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 201 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_1477, 0x1477  # offset +0x1477
.equ field_1ca2, 0x1ca2  # offset +0x1ca2
.equ field_4528, 0x4528  # offset +0x4528
.equ field_4530, 0x4530  # offset +0x4530
.equ field_456d, 0x456d  # offset +0x456d
.equ field_4577, 0x4577  # offset +0x4577
.equ field_53bf, 0x53bf  # offset +0x53bf
.equ field_65cc, 0x65cc  # offset +0x65cc
.equ field_65d6, 0x65d6  # offset +0x65d6

# --- external targets -----------------------------------------------
.set FUN_004e26fc, .text + (0x004e26fc - 0x401000)
.set FUN_004e3cd7, .text + (0x004e3cd7 - 0x401000)
.set FUN_004e40a6, .text + (0x004e40a6 - 0x401000)
.set FUN_004e7512, .text + (0x004e7512 - 0x401000)
.set FUN_004ee517, .text + (0x004ee517 - 0x401000)

.org 0x004e467f - 0x401000
.globl FUN_004e467f
FUN_004e467f:
    # block 0x004e467f: entry, 7 instruction(s), ends with je to 0x004e46a5 (forward)
    push ebp                                     # 004e467f
    {load} mov ebp, esp                          # 004e4680
    sub esp, 0xc                                 # 004e4682
    mov dword ptr [ebp - local_c], ecx           # 004e4685
    mov eax, dword ptr [ebp - local_c]           # 004e4688
    cmp dword ptr [eax + field_4528], 0x2        # 004e468b
    je.d8 L_004e46a5                             # 004e4692
    # block 0x004e4694: entered by fall-through of je at 0x004e4692, 3 instruction(s), ends with je to 0x004e46a5 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004e4694
    cmp dword ptr [ecx + field_4528], 0x3        # 004e4697
    je.d8 L_004e46a5                             # 004e469e
    # block 0x004e46a0: entered by fall-through of je at 0x004e469e, 1 instruction(s), ends with forward jump to 0x004e4989
    jmp.d32 L_004e4989                           # 004e46a0
L_004e46a5:
    # block 0x004e46a5: entered by je at 0x004e4692; je at 0x004e469e, 4 instruction(s), calls FUN_004ee517, ends with je to 0x004e46b6 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004e46a5
    call FUN_004ee517                            # 004e46a8
    test eax, eax                                # 004e46ad
    je.d8 L_004e46b6                             # 004e46af
    # block 0x004e46b1: entered by fall-through of je at 0x004e46af, 1 instruction(s), ends with forward jump to 0x004e4989
    jmp.d32 L_004e4989                           # 004e46b1
L_004e46b6:
    # block 0x004e46b6: entered by je at 0x004e46af, 2 instruction(s), ends with forward jump to 0x004e46ca
    mov word ptr [ebp - local_4], 0x0            # 004e46b6
    jmp.d8 L_004e46ca                            # 004e46bc
L_004e46be:
    # block 0x004e46be: entered by jmp at 0x004e46f5, 3 instruction(s), falls into the block at 0x004e46ca
    mov dx, word ptr [ebp - local_4]             # 004e46be
    add dx, 0x1                                  # 004e46c2
    mov word ptr [ebp - local_4], dx             # 004e46c6
L_004e46ca:
    # block 0x004e46ca: entered by jmp at 0x004e46bc, 3 instruction(s), ends with jge to 0x004e46f7 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e46ca
    cmp eax, 0x1a                                # 004e46ce
    jge.d8 L_004e46f7                            # 004e46d1
    # block 0x004e46d3: entered by fall-through of jge at 0x004e46d1, 7 instruction(s), calls FUN_004e26fc, ends with je to 0x004e46f5 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004e46d3
    imul ecx, ecx, 0x18f                         # 004e46d7
    mov edx, dword ptr [ebp - local_c]           # 004e46dd
    lea ecx, [edx + ecx + field_1ca2]            # 004e46e0
    call FUN_004e26fc                            # 004e46e7
    test eax, eax                                # 004e46ec
    je.d8 L_004e46f5                             # 004e46ee
    # block 0x004e46f0: entered by fall-through of je at 0x004e46ee, 1 instruction(s), ends with forward jump to 0x004e4989
    jmp.d32 L_004e4989                           # 004e46f0
L_004e46f5:
    # block 0x004e46f5: entered by je at 0x004e46ee, 1 instruction(s), ends with backward jump to 0x004e46be
    jmp.d8 L_004e46be                            # 004e46f5
L_004e46f7:
    # block 0x004e46f7: entered by jge at 0x004e46d1, 4 instruction(s), ends with je to 0x004e4989 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004e46f7
    movsx ecx, word ptr [eax + field_53bf]       # 004e46fa
    cmp ecx, -0x1                                # 004e4701
    je.d32 L_004e4989                            # 004e4704
    # block 0x004e470a: entered by fall-through of je at 0x004e4704, 3 instruction(s), ends with jne to 0x004e47b9 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004e470a
    cmp dword ptr [edx + field_4530], 0x9        # 004e470d
    jne.d32 L_004e47b9                           # 004e4714
    # block 0x004e471a: entered by fall-through of jne at 0x004e4714, 44 instruction(s), calls FUN_004e40a6, ends with forward jump to 0x004e4989
    push 0x8                                     # 004e471a
    mov eax, dword ptr [ebp - local_c]           # 004e471c
    add eax, 0x695                               # 004e471f
    push eax                                     # 004e4724
    mov ecx, dword ptr [ebp - local_c]           # 004e4725
    add ecx, 0x10ed                              # 004e4728
    sub esp, 0x10                                # 004e472e
    {load} mov edx, esp                          # 004e4731
    mov eax, dword ptr [ecx]                     # 004e4733
    mov dword ptr [edx], eax                     # 004e4735
    mov eax, dword ptr [ecx + field_4]           # 004e4737
    mov dword ptr [edx + field_4], eax           # 004e473a
    mov eax, dword ptr [ecx + field_8]           # 004e473d
    mov dword ptr [edx + field_8], eax           # 004e4740
    mov ecx, dword ptr [ecx + field_c]           # 004e4743
    mov dword ptr [edx + field_c], ecx           # 004e4746
    mov edx, dword ptr [ebp - local_c]           # 004e4749
    mov ax, word ptr [edx + field_53bf]          # 004e474c
    push eax                                     # 004e4753
    mov ecx, dword ptr [ebp - local_c]           # 004e4754
    call FUN_004e40a6                            # 004e4757
    mov ecx, dword ptr [ebp - local_c]           # 004e475c
    movsx edx, word ptr [ecx + field_53bf]       # 004e475f
    mov eax, dword ptr [ebp - local_c]           # 004e4766
    movsx ecx, word ptr [eax + field_4577]       # 004e4769
    {load} add edx, ecx                          # 004e4770
    mov eax, dword ptr [ebp - local_c]           # 004e4772
    mov word ptr [eax + field_456d], dx          # 004e4775
    mov ecx, dword ptr [ebp - local_c]           # 004e477c
    movsx edx, word ptr [ecx + field_456d]       # 004e477f
    imul edx, edx, 0x29                          # 004e4786
    mov eax, dword ptr [ebp - local_c]           # 004e4789
    lea ecx, [eax + edx + field_1477]            # 004e478c
    mov edx, dword ptr [ebp - local_c]           # 004e4793
    add edx, 0x6a7                               # 004e4796
    mov eax, dword ptr [ecx]                     # 004e479c
    mov dword ptr [edx], eax                     # 004e479e
    mov eax, dword ptr [ecx + field_4]           # 004e47a0
    mov dword ptr [edx + field_4], eax           # 004e47a3
    mov ax, word ptr [ecx + field_8]             # 004e47a6
    mov word ptr [edx + field_8], ax             # 004e47aa
    mov cl, byte ptr [ecx + field_a]             # 004e47ae
    mov byte ptr [edx + field_a], cl             # 004e47b1
    jmp.d32 L_004e4989                           # 004e47b4
L_004e47b9:
    # block 0x004e47b9: entered by jne at 0x004e4714, 3 instruction(s), ends with jne to 0x004e48f7 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004e47b9
    cmp dword ptr [edx + field_4530], 0xe        # 004e47bc
    jne.d32 L_004e48f7                           # 004e47c3
    # block 0x004e47c9: entered by fall-through of jne at 0x004e47c3, 20 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jne to 0x004e4851 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004e47c9
    add eax, 0x10cd                              # 004e47cc
    mov ecx, dword ptr [ebp - local_c]           # 004e47d1
    add ecx, 0x53d7                              # 004e47d4
    mov edx, dword ptr [eax]                     # 004e47da
    mov dword ptr [ecx], edx                     # 004e47dc
    mov edx, dword ptr [eax + field_4]           # 004e47de
    mov dword ptr [ecx + field_4], edx           # 004e47e1
    mov edx, dword ptr [eax + field_8]           # 004e47e4
    mov dword ptr [ecx + field_8], edx           # 004e47e7
    mov eax, dword ptr [eax + field_c]           # 004e47ea
    mov dword ptr [ecx + field_c], eax           # 004e47ed
    mov ecx, dword ptr [ebp - local_c]           # 004e47f0
    mov dword ptr [ecx + field_4530], 0xf        # 004e47f3
    call dword ptr [0x52a23c]                    # 004e47fd
    add eax, 0x2bc                               # 004e4803
    mov edx, dword ptr [ebp - local_c]           # 004e4808
    mov dword ptr [edx + field_65cc], eax        # 004e480b
    cmp dword ptr [0x5a1e58], 0x0                # 004e4811
    jne.d8 L_004e4851                            # 004e4818
    # block 0x004e481a: entered by fall-through of jne at 0x004e4818, 14 instruction(s), calls FUN_004e3cd7, ends with forward jump to 0x004e48f2
    mov eax, dword ptr [ebp - local_c]           # 004e481a
    movsx ecx, word ptr [eax + field_53bf]       # 004e481d
    mov edx, dword ptr [ebp - local_c]           # 004e4824
    movsx eax, word ptr [edx + field_4577]       # 004e4827
    {load} add ecx, eax                          # 004e482e
    imul ecx, ecx, 0x4a                          # 004e4830
    add ecx, 0x5a2685                            # 004e4833
    push ecx                                     # 004e4839
    mov ecx, dword ptr [ebp - local_c]           # 004e483a
    add ecx, 0x53d7                              # 004e483d
    push ecx                                     # 004e4843
    mov ecx, dword ptr [ebp - local_c]           # 004e4844
    call FUN_004e3cd7                            # 004e4847
    jmp.d32 L_004e48f2                           # 004e484c
L_004e4851:
    # block 0x004e4851: entered by jne at 0x004e4818, 3 instruction(s), ends with forward jump to 0x004e486b
    mov word ptr [ebp - local_8], 0x0            # 004e4851
    mov word ptr [ebp - local_4], 0x0            # 004e4857
    jmp.d8 L_004e486b                            # 004e485d
L_004e485f:
    # block 0x004e485f: entered by jmp at 0x004e48d1, 3 instruction(s), falls into the block at 0x004e486b
    mov dx, word ptr [ebp - local_4]             # 004e485f
    add dx, 0x1                                  # 004e4863
    mov word ptr [ebp - local_4], dx             # 004e4867
L_004e486b:
    # block 0x004e486b: entered by jmp at 0x004e485d, 11 instruction(s), ends with jge to 0x004e48d3 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004e486b
    mov ecx, dword ptr [ebp - local_c]           # 004e486f
    movsx edx, word ptr [ecx + field_53bf]       # 004e4872
    mov ecx, dword ptr [ebp - local_c]           # 004e4879
    movsx ecx, word ptr [ecx + field_4577]       # 004e487c
    {load} add edx, ecx                          # 004e4883
    mov ecx, dword ptr [ebp - local_c]           # 004e4885
    movsx ecx, word ptr [ecx + field_65d6]       # 004e4888
    {load} add edx, ecx                          # 004e488f
    {load} cmp eax, edx                          # 004e4891
    jge.d8 L_004e48d3                            # 004e4893
    # block 0x004e4895: entered by fall-through of jge at 0x004e4893, 4 instruction(s), ends with je to 0x004e48b1 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e4895
    imul edx, edx, 0x4a                          # 004e4899
    cmp dword ptr [edx + 0x5a26aa], 0x0          # 004e489c
    je.d8 L_004e48b1                             # 004e48a3
    # block 0x004e48a5: entered by fall-through of je at 0x004e48a3, 3 instruction(s), falls into the block at 0x004e48b1
    mov ax, word ptr [ebp - local_8]             # 004e48a5
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e48a9
    mov word ptr [ebp - local_8], ax             # 004e48ad
L_004e48b1:
    # block 0x004e48b1: entered by je at 0x004e48a3, 8 instruction(s), ends with jle to 0x004e48d1 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e48b1
    mov edx, dword ptr [ebp - local_c]           # 004e48b5
    movsx eax, word ptr [edx + field_53bf]       # 004e48b8
    mov edx, dword ptr [ebp - local_c]           # 004e48bf
    movsx edx, word ptr [edx + field_4577]       # 004e48c2
    {load} add eax, edx                          # 004e48c9
    {load} cmp ecx, eax                          # 004e48cb
    jle.d8 L_004e48d1                            # 004e48cd
    # block 0x004e48cf: entered by fall-through of jle at 0x004e48cd, 1 instruction(s), ends with forward jump to 0x004e48d3
    jmp.d8 L_004e48d3                            # 004e48cf
L_004e48d1:
    # block 0x004e48d1: entered by jle at 0x004e48cd, 1 instruction(s), ends with backward jump to 0x004e485f
    jmp.d8 L_004e485f                            # 004e48d1
L_004e48d3:
    # block 0x004e48d3: entered by jge at 0x004e4893; jmp at 0x004e48cf, 9 instruction(s), calls FUN_004e3cd7, falls into the block at 0x004e48f2
    movsx eax, word ptr [ebp - local_4]          # 004e48d3
    imul eax, eax, 0x4a                          # 004e48d7
    add eax, 0x5a2685                            # 004e48da
    push eax                                     # 004e48df
    mov ecx, dword ptr [ebp - local_c]           # 004e48e0
    add ecx, 0x53d7                              # 004e48e3
    push ecx                                     # 004e48e9
    mov ecx, dword ptr [ebp - local_c]           # 004e48ea
    call FUN_004e3cd7                            # 004e48ed
L_004e48f2:
    # block 0x004e48f2: entered by jmp at 0x004e484c, 1 instruction(s), ends with forward jump to 0x004e4989
    jmp.d32 L_004e4989                           # 004e48f2
L_004e48f7:
    # block 0x004e48f7: entered by jne at 0x004e47c3, 3 instruction(s), ends with jne to 0x004e4989 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004e48f7
    cmp dword ptr [edx + field_4530], 0xd        # 004e48fa
    jne.d32 L_004e4989                           # 004e4901
    # block 0x004e4907: entered by fall-through of jne at 0x004e4901, 3 instruction(s), ends with je to 0x004e4989 (forward)
    mov eax, 0x1                                 # 004e4907
    test eax, eax                                # 004e490c
    je.d8 L_004e4989                             # 004e490e
    # block 0x004e4910: entered by fall-through of je at 0x004e490e, 19 instruction(s), calls FUN_004e7512, ends with je to 0x004e4989 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004e4910
    movsx edx, word ptr [ecx + field_53bf]       # 004e4913
    mov eax, dword ptr [ebp - local_c]           # 004e491a
    movsx ecx, word ptr [eax + field_4577]       # 004e491d
    {load} add edx, ecx                          # 004e4924
    imul edx, edx, 0x29                          # 004e4926
    mov dx, word ptr [edx + 0x5a4371]            # 004e4929
    push edx                                     # 004e4930
    mov ecx, dword ptr [ebp - local_c]           # 004e4931
    call FUN_004e7512                            # 004e4934
    mov eax, dword ptr [ebp - local_c]           # 004e4939
    movsx ecx, word ptr [eax + field_53bf]       # 004e493c
    mov edx, dword ptr [ebp - local_c]           # 004e4943
    movsx eax, word ptr [edx + field_4577]       # 004e4946
    {load} add ecx, eax                          # 004e494d
    imul ecx, ecx, 0x29                          # 004e494f
    movsx ecx, word ptr [ecx + 0x5a436f]         # 004e4952
    cmp ecx, -0x1                                # 004e4959
    je.d8 L_004e4989                             # 004e495c
    # block 0x004e495e: entered by fall-through of je at 0x004e495c, 8 instruction(s), falls into the block at 0x004e4989
    mov edx, dword ptr [ebp - local_c]           # 004e495e
    movsx eax, word ptr [edx + field_53bf]       # 004e4961
    mov ecx, dword ptr [ebp - local_c]           # 004e4968
    movsx edx, word ptr [ecx + field_4577]       # 004e496b
    {load} add eax, edx                          # 004e4972
    imul eax, eax, 0x29                          # 004e4974
    movsx eax, word ptr [eax + 0x5a436f]         # 004e4977
    mov dword ptr [4*eax + 0x585801], 0x1        # 004e497e
L_004e4989:
    # block 0x004e4989: entered by jmp at 0x004e46a0; jmp at 0x004e46b1; jmp at 0x004e46f0; je at 0x004e4704; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e4989
    pop ebp                                      # 004e498b
    ret                                          # 004e498c

