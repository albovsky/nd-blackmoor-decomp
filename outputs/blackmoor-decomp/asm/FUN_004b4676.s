# FUN_004b4676
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b4676
# extent:       0x004b4676-0x004b4913 (669 code bytes)
# span:         0x004b4676-0x004b4913 (code 669, tables 0, padding 0)
# sha256:       4273b634785eab88e39e119129898f5ab79cc9e68f9dc4aabea9ea0cb95ef36c
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b4676
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_72a, field_74c, field_7fa; [ecx + n] field_4, field_8, field_c, field_91, field_95, field_119, field_71c, field_71e, field_720, field_722, field_724, field_728 and 1 more; [edx + n] field_89, field_8d, field_71c, field_71e, field_722, field_728, field_72a, field_752; [esi + n] field_71c
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 157 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_89, 0x89  # offset +0x89
.equ field_8d, 0x8d  # offset +0x8d
.equ field_91, 0x91  # offset +0x91
.equ field_95, 0x95  # offset +0x95
.equ field_119, 0x119  # offset +0x119
.equ field_71c, 0x71c  # offset +0x71c
.equ field_71e, 0x71e  # offset +0x71e
.equ field_720, 0x720  # offset +0x720
.equ field_722, 0x722  # offset +0x722
.equ field_724, 0x724  # offset +0x724
.equ field_728, 0x728  # offset +0x728
.equ field_72a, 0x72a  # offset +0x72a
.equ field_74c, 0x74c  # offset +0x74c
.equ field_750, 0x750  # offset +0x750
.equ field_752, 0x752  # offset +0x752
.equ field_7fa, 0x7fa  # offset +0x7fa

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004b4676 - 0x401000
.globl FUN_004b4676
FUN_004b4676:
    # block 0x004b4676: entry, 9 instruction(s), ends with jne to 0x004b4696 (forward)
    push ebp                                     # 004b4676
    {load} mov ebp, esp                          # 004b4677
    sub esp, 0xc                                 # 004b4679
    push esi                                     # 004b467c
    mov dword ptr [ebp - local_c], ecx           # 004b467d
    mov eax, dword ptr [ebp - local_c]           # 004b4680
    movsx ecx, word ptr [eax + field_72a]        # 004b4683
    cmp ecx, -0x1                                # 004b468a
    jne.d8 L_004b4696                            # 004b468d
    # block 0x004b468f: entered by fall-through of jne at 0x004b468d, 2 instruction(s), ends with forward jump to 0x004b490e
    {load} xor eax, eax                          # 004b468f
    jmp.d32 L_004b490e                           # 004b4691
L_004b4696:
    # block 0x004b4696: entered by jne at 0x004b468d, 4 instruction(s), ends with forward jump to 0x004b46b2
    movsx edx, word ptr [0x591a22]               # 004b4696
    sub edx, 0x1                                 # 004b469d
    mov word ptr [ebp - local_4], dx             # 004b46a0
    jmp.d8 L_004b46b2                            # 004b46a4
L_004b46a6:
    # block 0x004b46a6: entered by jmp at 0x004b48f7, 3 instruction(s), falls into the block at 0x004b46b2
    mov ax, word ptr [ebp - local_4]             # 004b46a6
    .insn 0x66, 0x2d, 0x0001{:u16}               # 004b46aa
    mov word ptr [ebp - local_4], ax             # 004b46ae
L_004b46b2:
    # block 0x004b46b2: entered by jmp at 0x004b46a4, 3 instruction(s), ends with jl to 0x004b48fc (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b46b2
    test ecx, ecx                                # 004b46b6
    jl.d32 L_004b48fc                            # 004b46b8
    # block 0x004b46be: entered by fall-through of jl at 0x004b46b8, 9 instruction(s), ends with je to 0x004b48f7 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b46be
    movsx eax, word ptr [edx + field_72a]        # 004b46c1
    imul eax, eax, 0xc                           # 004b46c8
    movsx ecx, word ptr [ebp - local_4]          # 004b46cb
    mov dx, word ptr [eax + 2*ecx + 0x5919fe]    # 004b46cf
    mov word ptr [ebp - local_8], dx             # 004b46d7
    movsx eax, word ptr [ebp - local_8]          # 004b46db
    cmp eax, -0x1                                # 004b46df
    je.d32 L_004b48f7                            # 004b46e2
    # block 0x004b46e8: entered by fall-through of je at 0x004b46e2, 116 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x004b48fc
    mov ecx, dword ptr [ebp - local_c]           # 004b46e8
    movsx edx, word ptr [ecx + field_728]        # 004b46eb
    imul edx, edx, 0x8d                          # 004b46f2
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b46f8
    mov cx, word ptr [eax + field_7fa]           # 004b46fe
    push ecx                                     # 004b4705
    mov ecx, 0x5c3a67                            # 004b4706
    call FUN_004fb2e3                            # 004b470b
    mov edx, dword ptr [ebp - local_c]           # 004b4710
    mov ax, word ptr [ebp - local_8]             # 004b4713
    mov word ptr [edx + field_71c], ax           # 004b4717
    mov ecx, dword ptr [ebp - local_c]           # 004b471e
    mov word ptr [ecx + field_750], 0x1          # 004b4721
    mov edx, dword ptr [ebp - local_c]           # 004b472a
    mov word ptr [edx + field_752], 0x0          # 004b472d
    mov eax, dword ptr [ebp - local_c]           # 004b4736
    movsx ecx, word ptr [eax + field_72a]        # 004b4739
    imul ecx, ecx, 0xc                           # 004b4740
    movsx edx, word ptr [ebp - local_4]          # 004b4743
    mov word ptr [ecx + 2*edx + 0x5919fe], 0xffff # 004b4747
    mov eax, dword ptr [ebp - local_c]           # 004b4751
    mov word ptr [eax + field_74c], 0x1          # 004b4754
    mov ecx, dword ptr [ebp - local_c]           # 004b475d
    movsx edx, word ptr [ecx + field_71c]        # 004b4760
    imul edx, edx, 0x120                         # 004b4767
    mov eax, dword ptr [ebp - local_c]           # 004b476d
    lea ecx, [eax + edx + field_1c]              # 004b4770
    mov edx, dword ptr [ebp - local_c]           # 004b4774
    movsx eax, word ptr [edx + field_72a]        # 004b4777
    imul eax, eax, 0x60                          # 004b477e
    {load} add ecx, eax                          # 004b4781
    movsx edx, word ptr [ebp - local_4]          # 004b4783
    shl edx, 0x4                                 # 004b4787
    {load} add ecx, edx                          # 004b478a
    mov eax, dword ptr [ebp - local_c]           # 004b478c
    add eax, 0x72c                               # 004b478f
    mov edx, dword ptr [ecx]                     # 004b4794
    mov dword ptr [eax], edx                     # 004b4796
    mov edx, dword ptr [ecx + field_4]           # 004b4798
    mov dword ptr [eax + field_4], edx           # 004b479b
    mov edx, dword ptr [ecx + field_8]           # 004b479e
    mov dword ptr [eax + field_8], edx           # 004b47a1
    mov ecx, dword ptr [ecx + field_c]           # 004b47a4
    mov dword ptr [eax + field_c], ecx           # 004b47a7
    mov edx, dword ptr [ebp - local_c]           # 004b47aa
    movsx eax, word ptr [edx + field_728]        # 004b47ad
    imul eax, eax, 0x8d                          # 004b47b4
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b47ba
    mov edx, dword ptr [ebp - local_c]           # 004b47c0
    movsx eax, word ptr [edx + field_71c]        # 004b47c3
    imul eax, eax, 0x120                         # 004b47ca
    lea ecx, [ecx + eax + field_119]             # 004b47d0
    mov edx, dword ptr [ebp - local_c]           # 004b47d7
    movsx eax, word ptr [edx + field_72a]        # 004b47da
    imul eax, eax, 0x60                          # 004b47e1
    {load} add ecx, eax                          # 004b47e4
    movsx edx, word ptr [ebp - local_4]          # 004b47e6
    shl edx, 0x4                                 # 004b47ea
    {load} add ecx, edx                          # 004b47ed
    mov eax, dword ptr [ebp - local_c]           # 004b47ef
    add eax, 0x73c                               # 004b47f2
    mov edx, dword ptr [ecx]                     # 004b47f7
    mov dword ptr [eax], edx                     # 004b47f9
    mov edx, dword ptr [ecx + field_4]           # 004b47fb
    mov dword ptr [eax + field_4], edx           # 004b47fe
    mov edx, dword ptr [ecx + field_8]           # 004b4801
    mov dword ptr [eax + field_8], edx           # 004b4804
    mov ecx, dword ptr [ecx + field_c]           # 004b4807
    mov dword ptr [eax + field_c], ecx           # 004b480a
    mov edx, dword ptr [ebp - local_c]           # 004b480d
    movsx eax, word ptr [edx + field_728]        # 004b4810
    imul eax, eax, 0x8d                          # 004b4817
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b481d
    mov edx, dword ptr [ebp - local_c]           # 004b4823
    movsx eax, word ptr [edx + field_71c]        # 004b4826
    shl eax, 0x4                                 # 004b482d
    mov edx, dword ptr [ebp - local_c]           # 004b4830
    movsx edx, word ptr [edx + field_728]        # 004b4833
    imul edx, edx, 0x8d                          # 004b483a
    mov edx, dword ptr [edx + 0x5bb5e5]          # 004b4840
    mov esi, dword ptr [ebp - local_c]           # 004b4846
    movsx esi, word ptr [esi + field_71c]        # 004b4849
    shl esi, 0x4                                 # 004b4850
    mov eax, dword ptr [ecx + eax + field_91]    # 004b4853
    sub eax, dword ptr [edx + esi + field_89]    # 004b485a
    mov ecx, dword ptr [ebp - local_c]           # 004b4861
    mov word ptr [ecx + field_71e], ax           # 004b4864
    mov edx, dword ptr [ebp - local_c]           # 004b486b
    movsx eax, word ptr [edx + field_728]        # 004b486e
    imul eax, eax, 0x8d                          # 004b4875
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b487b
    mov edx, dword ptr [ebp - local_c]           # 004b4881
    movsx eax, word ptr [edx + field_71c]        # 004b4884
    shl eax, 0x4                                 # 004b488b
    mov edx, dword ptr [ebp - local_c]           # 004b488e
    movsx edx, word ptr [edx + field_728]        # 004b4891
    imul edx, edx, 0x8d                          # 004b4898
    mov edx, dword ptr [edx + 0x5bb5e5]          # 004b489e
    mov esi, dword ptr [ebp - local_c]           # 004b48a4
    movsx esi, word ptr [esi + field_71c]        # 004b48a7
    shl esi, 0x4                                 # 004b48ae
    mov eax, dword ptr [ecx + eax + field_95]    # 004b48b1
    sub eax, dword ptr [edx + esi + field_8d]    # 004b48b8
    mov ecx, dword ptr [ebp - local_c]           # 004b48bf
    mov word ptr [ecx + field_722], ax           # 004b48c2
    mov edx, dword ptr [ebp - local_c]           # 004b48c9
    movsx eax, word ptr [edx + field_71e]        # 004b48cc
    sar eax                                      # 004b48d3
    mov ecx, dword ptr [ebp - local_c]           # 004b48d5
    mov word ptr [ecx + field_720], ax           # 004b48d8
    mov edx, dword ptr [ebp - local_c]           # 004b48df
    movsx eax, word ptr [edx + field_722]        # 004b48e2
    sar eax                                      # 004b48e9
    mov ecx, dword ptr [ebp - local_c]           # 004b48eb
    mov word ptr [ecx + field_724], ax           # 004b48ee
    jmp.d8 L_004b48fc                            # 004b48f5
L_004b48f7:
    # block 0x004b48f7: entered by je at 0x004b46e2, 1 instruction(s), ends with backward jump to 0x004b46a6
    jmp.d32 L_004b46a6                           # 004b48f7
L_004b48fc:
    # block 0x004b48fc: entered by jl at 0x004b46b8; jmp at 0x004b48f5, 3 instruction(s), ends with jne to 0x004b4909 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004b48fc
    cmp edx, -0x1                                # 004b4900
    jne.d8 L_004b4909                            # 004b4903
    # block 0x004b4905: entered by fall-through of jne at 0x004b4903, 2 instruction(s), ends with forward jump to 0x004b490e
    {load} xor eax, eax                          # 004b4905
    jmp.d8 L_004b490e                            # 004b4907
L_004b4909:
    # block 0x004b4909: entered by jne at 0x004b4903, 1 instruction(s), falls into the block at 0x004b490e
    mov eax, 0x1                                 # 004b4909
L_004b490e:
    # block 0x004b490e: entered by jmp at 0x004b4691; jmp at 0x004b4907, 4 instruction(s), ends with ret
    pop esi                                      # 004b490e
    {load} mov esp, ebp                          # 004b490f
    pop ebp                                      # 004b4911
    ret                                          # 004b4912

