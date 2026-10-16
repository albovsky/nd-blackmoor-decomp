# FUN_0052205d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052205d
# extent:       0x0052205d-0x005220e2 (133 code bytes)
# span:         0x0052205d-0x005220e2 (code 133, tables 0, padding 0)
# sha256:       92150f33a7c951fc7c2d3e6bd8d416c019f875014f31af7de4e6c7cb8eaba56c
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052205d
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [edx + n] field_c; [esi + n] field_1c
# callees:      calls FUN_0051d862, USER32.dll!GetParent, FUN_0051abe4, FUN_0051ec6f; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 59 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051d862, .text + (0x0051d862 - 0x401000)
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)

.org 0x0052205d - 0x401000
.globl FUN_0052205d
FUN_0052205d:
    # block 0x0052205d: entry, 15 instruction(s), calls FUN_0051d862, ends with jne to 0x005220d4 (forward)
    push ebp                                     # 0052205d
    {load} mov ebp, esp                          # 0052205e
    push ebx                                     # 00522060
    push esi                                     # 00522061
    mov ebx, dword ptr [ebp + arg_8]             # 00522062
    push edi                                     # 00522065
    push dword ptr [ebp + arg_14]                # 00522066
    mov edi, dword ptr [ebp + arg_c]             # 00522069
    {load} mov esi, ecx                          # 0052206c
    push dword ptr [ebp + arg_10]                # 0052206e
    push edi                                     # 00522071
    push ebx                                     # 00522072
    call FUN_0051d862                            # 00522073
    test eax, eax                                # 00522078
    jne.d8 L_005220d4                            # 0052207a
    # block 0x0052207c: entered by fall-through of jne at 0x0052207a, 2 instruction(s), ends with je to 0x00522085 (forward)
    test edi, edi                                # 0052207c
    je.d8 L_00522085                             # 0052207e
    # block 0x00522080: entered by fall-through of je at 0x0052207e, 2 instruction(s), ends with jne to 0x005220d9 (forward)
    cmp edi, -0x1                                # 00522080
    jne.d8 L_005220d9                            # 00522083
L_00522085:
    # block 0x00522085: entered by je at 0x0052207e; fall-through of jne at 0x00522083, 2 instruction(s), ends with je to 0x005220d9 (forward)
    test bh, -0x80                               # 00522085
    je.d8 L_005220d9                             # 00522088
    # block 0x0052208a: entered by fall-through of je at 0x00522088, 2 instruction(s), ends with jae to 0x005220d9 (forward)
    cmp ebx, 0xf000                              # 0052208a
    jae.d8 L_005220d9                            # 00522090
    # block 0x00522092: entered by fall-through of jae at 0x00522090, 6 instruction(s), calls USER32.dll!GetParent, FUN_0051abe4, ends with je to 0x005220b8 (forward)
    push dword ptr [esi + field_1c]              # 00522092
    call dword ptr [0x52a3dc]                    # 00522095
    push eax                                     # 0052209b
    call FUN_0051abe4                            # 0052209c
    test eax, eax                                # 005220a1
    je.d8 L_005220b8                             # 005220a3
    # block 0x005220a5: entered by fall-through of je at 0x005220a3, 9 instruction(s), calls indirect dword ptr [edx + 0xc], ends with jne to 0x005220d4 (forward)
    push dword ptr [ebp + arg_14]                # 005220a5
    mov edx, dword ptr [eax]                     # 005220a8
    {load} mov ecx, eax                          # 005220aa
    push dword ptr [ebp + arg_10]                # 005220ac
    push edi                                     # 005220af
    push ebx                                     # 005220b0
    call dword ptr [edx + field_c]               # 005220b1
    test eax, eax                                # 005220b4
    jne.d8 L_005220d4                            # 005220b6
L_005220b8:
    # block 0x005220b8: entered by je at 0x005220a3; fall-through of jne at 0x005220b6, 3 instruction(s), calls FUN_0051ec6f, ends with je to 0x005220d9 (forward)
    call FUN_0051ec6f                            # 005220b8
    test eax, eax                                # 005220bd
    je.d8 L_005220d9                             # 005220bf
    # block 0x005220c1: entered by fall-through of je at 0x005220bf, 9 instruction(s), calls indirect dword ptr [edx + 0xc], ends with je to 0x005220d9 (forward)
    push dword ptr [ebp + arg_14]                # 005220c1
    mov edx, dword ptr [eax]                     # 005220c4
    {load} mov ecx, eax                          # 005220c6
    push dword ptr [ebp + arg_10]                # 005220c8
    push edi                                     # 005220cb
    push ebx                                     # 005220cc
    call dword ptr [edx + field_c]               # 005220cd
    test eax, eax                                # 005220d0
    je.d8 L_005220d9                             # 005220d2
L_005220d4:
    # block 0x005220d4: entered by jne at 0x0052207a; jne at 0x005220b6; fall-through of je at 0x005220d2, 3 instruction(s), ends with forward jump to 0x005220db
    push 0x1                                     # 005220d4
    pop eax                                      # 005220d6
    jmp.d8 L_005220db                            # 005220d7
L_005220d9:
    # block 0x005220d9: entered by jne at 0x00522083; je at 0x00522088; jae at 0x00522090; je at 0x005220bf; je at 0x005220d2, 1 instruction(s), falls into the block at 0x005220db
    {load} xor eax, eax                          # 005220d9
L_005220db:
    # block 0x005220db: entered by jmp at 0x005220d7, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 005220db
    pop esi                                      # 005220dc
    pop ebx                                      # 005220dd
    pop ebp                                      # 005220de
    ret 0x10                                     # 005220df

