# FUN_005187fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005187fb
# extent:       0x005187fb-0x005188cb (208 code bytes)
# span:         0x005187fb-0x005188cb (code 208, tables 0, padding 0)
# sha256:       fdc9a1a0008572564196579be445ad049abbac26bf89c57b307b47cfa8ec2309
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005187fb
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_20, local_30, local_58
# fields:       [esi + n] field_8, field_10, field_18
# callees:      calls FUN_00514250, FUN_00513f9d, FUN_005146dc, FUN_005188cb, FUN_005144ef
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 94 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_20, 0x20  # offset -0x20
.equ local_30, 0x30  # offset -0x30
.equ local_58, 0x58  # offset -0x58
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00513f9d, .text + (0x00513f9d - 0x401000)
.set FUN_00514250, .text + (0x00514250 - 0x401000)
.set FUN_005144ef, .text + (0x005144ef - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)
.set FUN_005188cb, .text + (0x005188cb - 0x401000)

.org 0x005187fb - 0x401000
.globl FUN_005187fb
FUN_005187fb:
    # block 0x005187fb: entry, 13 instruction(s), ends with je to 0x00518840 (forward)
    push ebp                                     # 005187fb
    {load} mov ebp, esp                          # 005187fc
    sub esp, 0x58                                # 005187fe
    mov eax, dword ptr [ebp + arg_10]            # 00518801
    push ebx                                     # 00518804
    push esi                                     # 00518805
    mov esi, dword ptr [ebp + arg_c]             # 00518806
    movzx ecx, word ptr [eax]                    # 00518809
    mov eax, dword ptr [esi]                     # 0051880c
    push edi                                     # 0051880e
    dec eax                                      # 0051880f
    mov dword ptr [ebp + arg_10], ecx            # 00518810
    je.d8 L_00518840                             # 00518813
    # block 0x00518815: entered by fall-through of je at 0x00518813, 2 instruction(s), ends with je to 0x0051883c (forward)
    dec eax                                      # 00518815
    je.d8 L_0051883c                             # 00518816
    # block 0x00518818: entered by fall-through of je at 0x00518816, 2 instruction(s), ends with je to 0x00518838 (forward)
    dec eax                                      # 00518818
    je.d8 L_00518838                             # 00518819
    # block 0x0051881b: entered by fall-through of je at 0x00518819, 2 instruction(s), ends with je to 0x00518834 (forward)
    dec eax                                      # 0051881b
    je.d8 L_00518834                             # 0051881c
    # block 0x0051881e: entered by fall-through of je at 0x0051881c, 2 instruction(s), ends with je to 0x00518840 (forward)
    dec eax                                      # 0051881e
    je.d8 L_00518840                             # 0051881f
    # block 0x00518821: entered by fall-through of je at 0x0051881f, 3 instruction(s), ends with je to 0x0051882c (forward)
    dec eax                                      # 00518821
    dec eax                                      # 00518822
    je.d8 L_0051882c                             # 00518823
    # block 0x00518825: entered by fall-through of je at 0x00518823, 2 instruction(s), ends with jne to 0x00518896 (forward)
    dec eax                                      # 00518825
    jne.d8 L_00518896                            # 00518826
    # block 0x00518828: entered by fall-through of jne at 0x00518826, 2 instruction(s), ends with forward jump to 0x00518842
    push 0x10                                    # 00518828
    jmp.d8 L_00518842                            # 0051882a
L_0051882c:
    # block 0x0051882c: entered by je at 0x00518823, 2 instruction(s), ends with forward jump to 0x00518896
    mov dword ptr [esi], 0x1                     # 0051882c
    jmp.d8 L_00518896                            # 00518832
L_00518834:
    # block 0x00518834: entered by je at 0x0051881c, 2 instruction(s), ends with forward jump to 0x00518842
    push 0x12                                    # 00518834
    jmp.d8 L_00518842                            # 00518836
L_00518838:
    # block 0x00518838: entered by je at 0x00518819, 2 instruction(s), ends with forward jump to 0x00518842
    push 0x11                                    # 00518838
    jmp.d8 L_00518842                            # 0051883a
L_0051883c:
    # block 0x0051883c: entered by je at 0x00518816, 2 instruction(s), ends with forward jump to 0x00518842
    push 0x4                                     # 0051883c
    jmp.d8 L_00518842                            # 0051883e
L_00518840:
    # block 0x00518840: entered by je at 0x00518813; je at 0x0051881f, 1 instruction(s), falls into the block at 0x00518842
    push 0x8                                     # 00518840
L_00518842:
    # block 0x00518842: entered by jmp at 0x0051882a; jmp at 0x00518836; jmp at 0x0051883a; jmp at 0x0051883e, 9 instruction(s), calls FUN_00514250, ends with jne to 0x00518896 (forward)
    pop ebx                                      # 00518842
    lea edi, [esi + field_18]                    # 00518843
    push ecx                                     # 00518846
    push edi                                     # 00518847
    push ebx                                     # 00518848
    call FUN_00514250                            # 00518849
    add esp, 0xc                                 # 0051884e
    test eax, eax                                # 00518851
    jne.d8 L_00518896                            # 00518853
    # block 0x00518855: entered by fall-through of jne at 0x00518853, 3 instruction(s), ends with je to 0x0051886d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00518855
    cmp eax, 0x10                                # 00518858
    je.d8 L_0051886d                             # 0051885b
    # block 0x0051885d: entered by fall-through of je at 0x0051885b, 2 instruction(s), ends with je to 0x0051886d (forward)
    cmp eax, 0x16                                # 0051885d
    je.d8 L_0051886d                             # 00518860
    # block 0x00518862: entered by fall-through of je at 0x00518860, 2 instruction(s), ends with je to 0x0051886d (forward)
    cmp eax, 0x1d                                # 00518862
    je.d8 L_0051886d                             # 00518865
    # block 0x00518867: entered by fall-through of je at 0x00518865, 2 instruction(s), ends with forward jump to 0x0051887f
    and dword ptr [ebp - local_20], -0x2         # 00518867
    jmp.d8 L_0051887f                            # 0051886b
L_0051886d:
    # block 0x0051886d: entered by je at 0x0051885b; je at 0x00518860; je at 0x00518865, 6 instruction(s), falls into the block at 0x0051887f
    mov ecx, dword ptr [ebp - local_20]          # 0051886d
    fld qword ptr [esi + field_10]               # 00518870
    and ecx, -0x1d                               # 00518873
    fstp qword ptr [ebp - local_30]              # 00518876
    or ecx, 0x3                                  # 00518879
    mov dword ptr [ebp - local_20], ecx          # 0051887c
L_0051887f:
    # block 0x0051887f: entered by jmp at 0x0051886b, 11 instruction(s), calls FUN_00513f9d, falls into the block at 0x00518896
    lea ecx, [esi + field_8]                     # 0051887f
    push edi                                     # 00518882
    push ecx                                     # 00518883
    push eax                                     # 00518884
    lea eax, [ebp + arg_10]                      # 00518885
    push ebx                                     # 00518888
    push eax                                     # 00518889
    lea eax, [ebp - local_58]                    # 0051888a
    push eax                                     # 0051888d
    call FUN_00513f9d                            # 0051888e
    add esp, 0x18                                # 00518893
L_00518896:
    # block 0x00518896: entered by jne at 0x00518826; jmp at 0x00518832; jne at 0x00518853, 7 instruction(s), calls FUN_005146dc, ends with je to 0x005188be (forward)
    push 0xffff                                  # 00518896
    push dword ptr [ebp + arg_10]                # 0051889b
    call FUN_005146dc                            # 0051889e
    cmp dword ptr [esi], 0x8                     # 005188a3
    pop ecx                                      # 005188a6
    pop ecx                                      # 005188a7
    je.d8 L_005188be                             # 005188a8
    # block 0x005188aa: entered by fall-through of je at 0x005188a8, 2 instruction(s), ends with jne to 0x005188be (forward)
    cmp dword ptr [0x568e30], 0x0                # 005188aa
    jne.d8 L_005188be                            # 005188b1
    # block 0x005188b3: entered by fall-through of jne at 0x005188b1, 5 instruction(s), calls FUN_005188cb, ends with jne to 0x005188c6 (forward)
    push esi                                     # 005188b3
    call FUN_005188cb                            # 005188b4
    test eax, eax                                # 005188b9
    pop ecx                                      # 005188bb
    jne.d8 L_005188c6                            # 005188bc
L_005188be:
    # block 0x005188be: entered by je at 0x005188a8; jne at 0x005188b1; fall-through of jne at 0x005188bc, 3 instruction(s), calls FUN_005144ef, falls into the block at 0x005188c6
    push dword ptr [esi]                         # 005188be
    call FUN_005144ef                            # 005188c0
    pop ecx                                      # 005188c5
L_005188c6:
    # block 0x005188c6: entered by jne at 0x005188bc, 5 instruction(s), ends with ret
    pop edi                                      # 005188c6
    pop esi                                      # 005188c7
    pop ebx                                      # 005188c8
    leave                                        # 005188c9
    ret                                          # 005188ca

