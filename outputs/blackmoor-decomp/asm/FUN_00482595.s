# FUN_00482595
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00482595
# extent:       0x00482595-0x00482724 (399 code bytes)
# span:         0x00482595-0x00482724 (code 399, tables 0, padding 0)
# sha256:       7a4198cc008e8099cf8cac4d8c4edcf94c1eb8cb1b6de38f18d3709e3d34bd41
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00482595
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_a, field_1e, field_8f, field_39e, field_87c, field_87e; [ecx + n] field_4, field_8, field_a, field_8f, field_87c; [edx + n] field_8f, field_87e, field_880
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 101 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_8f, 0x8f  # offset +0x8f
.equ field_39e, 0x39e  # offset +0x39e
.equ field_87c, 0x87c  # offset +0x87c
.equ field_87e, 0x87e  # offset +0x87e
.equ field_880, 0x880  # offset +0x880

# --- external targets -----------------------------------------------

.org 0x00482595 - 0x401000
.globl FUN_00482595
FUN_00482595:
    # block 0x00482595: entry, 11 instruction(s), falls into the block at 0x004825c1
    push ebp                                     # 00482595
    {load} mov ebp, esp                          # 00482596
    sub esp, 0x10                                # 00482598
    mov dword ptr [ebp - local_10], ecx          # 0048259b
    mov eax, dword ptr [ebp - local_10]          # 0048259e
    movsx ecx, word ptr [eax + field_1e]         # 004825a1
    imul ecx, ecx, 0x8d                          # 004825a5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004825ab
    mov dword ptr [ebp - local_4], edx           # 004825b1
    mov word ptr [ebp - local_8], 0x0            # 004825b4
    mov dword ptr [ebp - local_c], 0x0           # 004825ba
L_004825c1:
    # block 0x004825c1: entered by jmp at 0x004826c6, 2 instruction(s), ends with jne to 0x004826cb (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004825c1
    jne.d32 L_004826cb                           # 004825c5
    # block 0x004825cb: entered by fall-through of jne at 0x004825c5, 5 instruction(s), ends with jge to 0x004826cb (forward)
    movsx eax, word ptr [ebp - local_8]          # 004825cb
    mov ecx, dword ptr [ebp - local_4]           # 004825cf
    movsx edx, word ptr [ecx + field_87c]        # 004825d2
    {load} cmp eax, edx                          # 004825d9
    jge.d32 L_004826cb                           # 004825db
    # block 0x004825e1: entered by fall-through of jge at 0x004825db, 2 instruction(s), ends with je to 0x004825fd (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004825e1
    je.d8 L_004825fd                             # 004825e5
    # block 0x004825e7: entered by fall-through of je at 0x004825e5, 3 instruction(s), ends with jne to 0x004825fd (forward)
    movsx eax, word ptr [ebp - local_8]          # 004825e7
    test eax, eax                                # 004825eb
    jne.d8 L_004825fd                            # 004825ed
    # block 0x004825ef: entered by fall-through of jne at 0x004825ed, 3 instruction(s), ends with forward jump to 0x00482674
    mov ecx, dword ptr [ebp - local_10]          # 004825ef
    mov word ptr [ecx + field_8f], 0x0           # 004825f2
    jmp.d8 L_00482674                            # 004825fb
L_004825fd:
    # block 0x004825fd: entered by je at 0x004825e5; jne at 0x004825ed, 5 instruction(s), ends with jne to 0x00482635 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004825fd
    mov eax, dword ptr [ebp - local_4]           # 00482601
    movsx ecx, word ptr [eax + field_39e]        # 00482604
    {load} cmp edx, ecx                          # 0048260b
    jne.d8 L_00482635                            # 0048260d
    # block 0x0048260f: entered by fall-through of jne at 0x0048260d, 10 instruction(s), ends with forward jump to 0x00482674
    mov edx, dword ptr [ebp - local_10]          # 0048260f
    movsx eax, word ptr [edx + field_8f]         # 00482612
    add eax, 0x1                                 # 00482619
    mov ecx, dword ptr [ebp - local_4]           # 0048261c
    movsx ecx, word ptr [ecx + field_87c]        # 0048261f
    cdq                                          # 00482626
    idiv ecx                                     # 00482627
    mov eax, dword ptr [ebp - local_10]          # 00482629
    mov word ptr [eax + field_8f], dx            # 0048262c
    jmp.d8 L_00482674                            # 00482633
L_00482635:
    # block 0x00482635: entered by jne at 0x0048260d, 4 instruction(s), ends with jle to 0x0048265d (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00482635
    movsx edx, word ptr [ecx + field_8f]         # 00482638
    test edx, edx                                # 0048263f
    jle.d8 L_0048265d                            # 00482641
    # block 0x00482643: entered by fall-through of jle at 0x00482641, 6 instruction(s), ends with forward jump to 0x00482674
    mov eax, dword ptr [ebp - local_10]          # 00482643
    mov cx, word ptr [eax + field_8f]            # 00482646
    sub cx, 0x1                                  # 0048264d
    mov edx, dword ptr [ebp - local_10]          # 00482651
    mov word ptr [edx + field_8f], cx            # 00482654
    jmp.d8 L_00482674                            # 0048265b
L_0048265d:
    # block 0x0048265d: entered by jle at 0x00482641, 5 instruction(s), falls into the block at 0x00482674
    mov eax, dword ptr [ebp - local_4]           # 0048265d
    movsx ecx, word ptr [eax + field_87c]        # 00482660
    sub ecx, 0x1                                 # 00482667
    mov edx, dword ptr [ebp - local_10]          # 0048266a
    mov word ptr [edx + field_8f], cx            # 0048266d
L_00482674:
    # block 0x00482674: entered by jmp at 0x004825fb; jmp at 0x00482633; jmp at 0x0048265b, 7 instruction(s), ends with je to 0x004826b3 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00482674
    movsx ecx, word ptr [eax + field_8f]         # 00482677
    imul ecx, ecx, 0x37                          # 0048267e
    mov edx, dword ptr [ebp - local_4]           # 00482681
    movsx eax, word ptr [edx + ecx + field_87e]  # 00482684
    cmp eax, -0x1                                # 0048268c
    je.d8 L_004826b3                             # 0048268f
    # block 0x00482691: entered by fall-through of je at 0x0048268f, 7 instruction(s), ends with jne to 0x004826ba (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00482691
    movsx edx, word ptr [ecx + field_8f]         # 00482694
    imul edx, edx, 0x37                          # 0048269b
    mov eax, dword ptr [ebp - local_4]           # 0048269e
    movsx ecx, word ptr [eax + edx + field_87e]  # 004826a1
    cmp dword ptr [4*ecx + 0x585801], 0x1        # 004826a9
    jne.d8 L_004826ba                            # 004826b1
L_004826b3:
    # block 0x004826b3: entered by je at 0x0048268f; fall-through of jne at 0x004826b1, 1 instruction(s), falls into the block at 0x004826ba
    mov dword ptr [ebp - local_c], 0x1           # 004826b3
L_004826ba:
    # block 0x004826ba: entered by jne at 0x004826b1, 4 instruction(s), ends with backward jump to 0x004825c1
    mov dx, word ptr [ebp - local_8]             # 004826ba
    add dx, 0x1                                  # 004826be
    mov word ptr [ebp - local_8], dx             # 004826c2
    jmp.d32 L_004825c1                           # 004826c6
L_004826cb:
    # block 0x004826cb: entered by jne at 0x004825c5; jge at 0x004825db, 5 instruction(s), ends with jg to 0x0048271c (forward)
    movsx eax, word ptr [ebp - local_8]          # 004826cb
    mov ecx, dword ptr [ebp - local_4]           # 004826cf
    movsx edx, word ptr [ecx + field_87c]        # 004826d2
    {load} cmp eax, edx                          # 004826d9
    jg.d8 L_0048271c                             # 004826db
    # block 0x004826dd: entered by fall-through of jg at 0x004826db, 17 instruction(s), ends with forward jump to 0x0048271e
    mov eax, dword ptr [ebp - local_10]          # 004826dd
    movsx ecx, word ptr [eax + field_8f]         # 004826e0
    imul ecx, ecx, 0x37                          # 004826e7
    mov edx, dword ptr [ebp - local_4]           # 004826ea
    lea eax, [edx + ecx + field_880]             # 004826ed
    mov ecx, dword ptr [ebp - local_10]          # 004826f4
    add ecx, 0x95                                # 004826f7
    mov edx, dword ptr [eax]                     # 004826fd
    mov dword ptr [ecx], edx                     # 004826ff
    mov edx, dword ptr [eax + field_4]           # 00482701
    mov dword ptr [ecx + field_4], edx           # 00482704
    mov dx, word ptr [eax + field_8]             # 00482707
    mov word ptr [ecx + field_8], dx             # 0048270b
    mov al, byte ptr [eax + field_a]             # 0048270f
    mov byte ptr [ecx + field_a], al             # 00482712
    mov eax, 0x1                                 # 00482715
    jmp.d8 L_0048271e                            # 0048271a
L_0048271c:
    # block 0x0048271c: entered by jg at 0x004826db, 1 instruction(s), falls into the block at 0x0048271e
    {load} xor eax, eax                          # 0048271c
L_0048271e:
    # block 0x0048271e: entered by jmp at 0x0048271a, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0048271e
    pop ebp                                      # 00482720
    ret 0x8                                      # 00482721

