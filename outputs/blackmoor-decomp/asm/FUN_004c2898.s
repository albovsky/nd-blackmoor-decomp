# FUN_004c2898
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c2898
# extent:       0x004c2898-0x004c2a8d (501 code bytes)
# span:         0x004c2898-0x004c2a8d (code 501, tables 0, padding 0)
# sha256:       a8cd1b424b3b67a98f9faafd1f7222f31ba5213bd840ff64beae0106ed998c43
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c2898
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_31, field_33, field_55; [ecx + n] field_4, field_8, field_c, field_23, field_2b, field_2d, field_2f, field_39, field_3d, field_41; [edx + n] field_4, field_18, field_21, field_27, field_35
# callees:      calls FUN_0042639d, FUN_004c97b4, FUN_0051dc43
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 163 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_27, 0x27  # offset +0x27
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_55, 0x55  # offset +0x55

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004c2898 - 0x401000
.globl FUN_004c2898
FUN_004c2898:
    # block 0x004c2898: entry, 9 instruction(s), ends with je to 0x004c28cb (forward)
    push ebp                                     # 004c2898
    {load} mov ebp, esp                          # 004c2899
    sub esp, 0x10                                # 004c289b
    push esi                                     # 004c289e
    push edi                                     # 004c289f
    mov dword ptr [ebp - local_10], ecx          # 004c28a0
    mov eax, dword ptr [ebp + arg_8]             # 004c28a3
    cmp dword ptr [eax], 0x0                     # 004c28a6
    je.d8 L_004c28cb                             # 004c28a9
    # block 0x004c28ab: entered by fall-through of je at 0x004c28a9, 8 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2a85
    mov ecx, dword ptr [ebp + arg_18]            # 004c28ab
    push ecx                                     # 004c28ae
    push 0x553c94                                # 004c28af
    mov ecx, 0x583979                            # 004c28b4
    call FUN_0042639d                            # 004c28b9
    mov ecx, dword ptr [ebp - local_10]          # 004c28be
    call FUN_004c97b4                            # 004c28c1
    jmp.d32 L_004c2a85                           # 004c28c6
L_004c28cb:
    # block 0x004c28cb: entered by je at 0x004c28a9, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c2906 (forward)
    push 0x59                                    # 004c28cb
    call FUN_0051dc43                            # 004c28cd
    add esp, 0x4                                 # 004c28d2
    mov dword ptr [ebp - local_8], eax           # 004c28d5
    mov edx, dword ptr [ebp + arg_8]             # 004c28d8
    mov eax, dword ptr [ebp - local_8]           # 004c28db
    mov dword ptr [edx], eax                     # 004c28de
    cmp dword ptr [ebp - local_8], 0x0           # 004c28e0
    jne.d8 L_004c2906                            # 004c28e4
    # block 0x004c28e6: entered by fall-through of jne at 0x004c28e4, 8 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2a85
    mov ecx, dword ptr [ebp + arg_18]            # 004c28e6
    push ecx                                     # 004c28e9
    push 0x553d10                                # 004c28ea
    mov ecx, 0x583979                            # 004c28ef
    call FUN_0042639d                            # 004c28f4
    mov ecx, dword ptr [ebp - local_10]          # 004c28f9
    call FUN_004c97b4                            # 004c28fc
    jmp.d32 L_004c2a85                           # 004c2901
L_004c2906:
    # block 0x004c2906: entered by jne at 0x004c28e4, 23 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c296c (forward)
    mov ecx, 0x16                                # 004c2906
    {load} xor eax, eax                          # 004c290b
    mov edx, dword ptr [ebp + arg_8]             # 004c290d
    mov edi, dword ptr [edx]                     # 004c2910
    rep stosd dword ptr es:[edi], eax            # 004c2912
    stosb byte ptr es:[edi], al                  # 004c2914
    movsx eax, word ptr [ebp + arg_c]            # 004c2915
    movsx ecx, word ptr [0x639895]               # 004c2919
    imul eax, ecx                                # 004c2920
    movsx edx, word ptr [ebp + arg_10]           # 004c2923
    imul eax, edx                                # 004c2927
    mov dword ptr [ebp - local_4], eax           # 004c292a
    mov eax, dword ptr [ebp - local_4]           # 004c292d
    push eax                                     # 004c2930
    call FUN_0051dc43                            # 004c2931
    add esp, 0x4                                 # 004c2936
    mov dword ptr [ebp - local_c], eax           # 004c2939
    mov ecx, dword ptr [ebp + arg_8]             # 004c293c
    mov edx, dword ptr [ecx]                     # 004c293f
    mov eax, dword ptr [ebp - local_c]           # 004c2941
    mov dword ptr [edx], eax                     # 004c2944
    cmp dword ptr [ebp - local_c], 0x0           # 004c2946
    jne.d8 L_004c296c                            # 004c294a
    # block 0x004c294c: entered by fall-through of jne at 0x004c294a, 8 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c2a85
    mov ecx, dword ptr [ebp + arg_18]            # 004c294c
    push ecx                                     # 004c294f
    push 0x553d68                                # 004c2950
    mov ecx, 0x583979                            # 004c2955
    call FUN_0042639d                            # 004c295a
    mov ecx, dword ptr [ebp - local_10]          # 004c295f
    call FUN_004c97b4                            # 004c2962
    jmp.d32 L_004c2a85                           # 004c2967
L_004c296c:
    # block 0x004c296c: entered by jne at 0x004c294a, 8 instruction(s), ends with jb to 0x004c2987 (forward)
    mov edi, dword ptr [ebp + arg_18]            # 004c296c
    or ecx, -0x1                                 # 004c296f
    {load} xor eax, eax                          # 004c2972
    repne scasb al, byte ptr es:[edi]            # 004c2974
    not ecx                                      # 004c2976
    add ecx, -0x1                                # 004c2978
    cmp ecx, 0x19                                # 004c297b
    jb.d8 L_004c2987                             # 004c297e
    # block 0x004c2980: entered by fall-through of jb at 0x004c297e, 2 instruction(s), falls into the block at 0x004c2987
    mov edx, dword ptr [ebp + arg_18]            # 004c2980
    mov byte ptr [edx + field_18], 0x0           # 004c2983
L_004c2987:
    # block 0x004c2987: entered by jb at 0x004c297e, 83 instruction(s), falls into the block at 0x004c2a85
    mov edi, dword ptr [ebp + arg_18]            # 004c2987
    mov eax, dword ptr [ebp + arg_8]             # 004c298a
    mov ecx, dword ptr [eax]                     # 004c298d
    add ecx, 0x8                                 # 004c298f
    {load} mov edx, ecx                          # 004c2992
    or ecx, -0x1                                 # 004c2994
    {load} xor eax, eax                          # 004c2997
    repne scasb al, byte ptr es:[edi]            # 004c2999
    not ecx                                      # 004c299b
    {load} sub edi, ecx                          # 004c299d
    {load} mov esi, edi                          # 004c299f
    {load} mov eax, ecx                          # 004c29a1
    {load} mov edi, edx                          # 004c29a3
    shr ecx, 0x2                                 # 004c29a5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c29a8
    {load} mov ecx, eax                          # 004c29aa
    and ecx, 0x3                                 # 004c29ac
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c29af
    mov ecx, dword ptr [ebp + arg_8]             # 004c29b1
    mov edx, dword ptr [ecx]                     # 004c29b4
    mov eax, dword ptr [ebp + arg_14]            # 004c29b6
    mov dword ptr [edx + field_4], eax           # 004c29b9
    mov ecx, dword ptr [ebp + arg_8]             # 004c29bc
    mov edx, dword ptr [ecx]                     # 004c29bf
    mov word ptr [edx + field_21], 0x59          # 004c29c1
    mov eax, dword ptr [ebp + arg_8]             # 004c29c7
    mov ecx, dword ptr [eax]                     # 004c29ca
    mov edx, dword ptr [ebp - local_4]           # 004c29cc
    mov dword ptr [ecx + field_23], edx          # 004c29cf
    mov eax, dword ptr [ebp - local_4]           # 004c29d2
    add eax, 0x59                                # 004c29d5
    mov ecx, dword ptr [ebp + arg_8]             # 004c29d8
    mov edx, dword ptr [ecx]                     # 004c29db
    mov dword ptr [edx + field_27], eax          # 004c29dd
    mov eax, dword ptr [ebp + arg_8]             # 004c29e0
    mov ecx, dword ptr [eax]                     # 004c29e3
    mov dx, word ptr [ebp + arg_c]               # 004c29e5
    mov word ptr [ecx + field_2b], dx            # 004c29e9
    mov eax, dword ptr [ebp + arg_8]             # 004c29ed
    mov ecx, dword ptr [eax]                     # 004c29f0
    mov dx, word ptr [ebp + arg_10]              # 004c29f2
    mov word ptr [ecx + field_2d], dx            # 004c29f6
    movsx eax, word ptr [ebp + arg_c]            # 004c29fa
    movsx ecx, word ptr [0x639895]               # 004c29fe
    imul eax, ecx                                # 004c2a05
    mov edx, dword ptr [ebp + arg_8]             # 004c2a08
    mov ecx, dword ptr [edx]                     # 004c2a0b
    mov word ptr [ecx + field_2f], ax            # 004c2a0d
    mov edx, dword ptr [ebp + arg_8]             # 004c2a11
    mov eax, dword ptr [edx]                     # 004c2a14
    mov cx, word ptr [ebp + arg_10]              # 004c2a16
    mov word ptr [eax + field_31], cx            # 004c2a1a
    mov edx, dword ptr [ebp + arg_8]             # 004c2a1e
    mov eax, dword ptr [edx]                     # 004c2a21
    mov cx, word ptr [0x639893]                  # 004c2a23
    mov word ptr [eax + field_33], cx            # 004c2a2a
    mov edx, dword ptr [ebp + arg_8]             # 004c2a2e
    mov eax, dword ptr [edx]                     # 004c2a31
    mov dword ptr [eax + field_55], 0x0          # 004c2a33
    mov ecx, dword ptr [ebp + arg_8]             # 004c2a3a
    mov edx, dword ptr [ecx]                     # 004c2a3d
    mov dword ptr [edx + field_35], 0x0          # 004c2a3f
    mov eax, dword ptr [ebp + arg_8]             # 004c2a46
    mov ecx, dword ptr [eax]                     # 004c2a49
    mov dword ptr [ecx + field_39], 0x0          # 004c2a4b
    movsx edx, word ptr [ebp + arg_c]            # 004c2a52
    sub edx, 0x1                                 # 004c2a56
    mov eax, dword ptr [ebp + arg_8]             # 004c2a59
    mov ecx, dword ptr [eax]                     # 004c2a5c
    mov dword ptr [ecx + field_3d], edx          # 004c2a5e
    movsx edx, word ptr [ebp + arg_10]           # 004c2a61
    sub edx, 0x1                                 # 004c2a65
    mov eax, dword ptr [ebp + arg_8]             # 004c2a68
    mov ecx, dword ptr [eax]                     # 004c2a6b
    mov dword ptr [ecx + field_41], edx          # 004c2a6d
    {load} xor edx, edx                          # 004c2a70
    mov eax, dword ptr [ebp + arg_8]             # 004c2a72
    mov ecx, dword ptr [eax]                     # 004c2a75
    add ecx, 0x45                                # 004c2a77
    mov dword ptr [ecx], edx                     # 004c2a7a
    mov dword ptr [ecx + field_4], edx           # 004c2a7c
    mov dword ptr [ecx + field_8], edx           # 004c2a7f
    mov dword ptr [ecx + field_c], edx           # 004c2a82
L_004c2a85:
    # block 0x004c2a85: entered by jmp at 0x004c28c6; jmp at 0x004c2901; jmp at 0x004c2967, 5 instruction(s), ends with ret 0x14
    pop edi                                      # 004c2a85
    pop esi                                      # 004c2a86
    {load} mov esp, ebp                          # 004c2a87
    pop ebp                                      # 004c2a89
    ret 0x14                                     # 004c2a8a

