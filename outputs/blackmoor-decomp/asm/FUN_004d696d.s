# FUN_004d696d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d696d
# extent:       0x004d696d-0x004d6ad1 (356 code bytes)
# span:         0x004d696d-0x004d6ad1 (code 356, tables 0, padding 0)
# sha256:       387afb9276c31f2c6224ed7fde11e51d0f0e0dc3f2c5ba4e95ee6414c23b0b6a
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d696d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_9552; [ecx + n] field_1ff, field_207, field_9552, field_9582, field_95aa; [edx + n] field_1fb, field_203, field_9552, field_9562
# callees:      calls FUN_004d65e9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 89 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1fb, 0x1fb  # offset +0x1fb
.equ field_1ff, 0x1ff  # offset +0x1ff
.equ field_203, 0x203  # offset +0x203
.equ field_207, 0x207  # offset +0x207
.equ field_9552, 0x9552  # offset +0x9552
.equ field_9562, 0x9562  # offset +0x9562
.equ field_9582, 0x9582  # offset +0x9582
.equ field_95aa, 0x95aa  # offset +0x95aa

# --- external targets -----------------------------------------------
.set FUN_004d65e9, .text + (0x004d65e9 - 0x401000)

.org 0x004d696d - 0x401000
.globl FUN_004d696d
FUN_004d696d:
    # block 0x004d696d: entry, 8 instruction(s), ends with forward jump to 0x004d69a1
    push ebp                                     # 004d696d
    {load} mov ebp, esp                          # 004d696e
    sub esp, 0x8                                 # 004d6970
    mov dword ptr [ebp - local_8], ecx           # 004d6973
    mov dword ptr [ebp - local_4], 0xffffffff    # 004d6976
    mov eax, dword ptr [ebp - local_8]           # 004d697d
    mov dword ptr [eax + field_9552], 0x0        # 004d6980
    jmp.d8 L_004d69a1                            # 004d698a
L_004d698c:
    # block 0x004d698c: entered by jmp at 0x004d69c7; jmp at 0x004d6ac5, 5 instruction(s), falls into the block at 0x004d69a1
    mov ecx, dword ptr [ebp - local_8]           # 004d698c
    mov edx, dword ptr [ecx + field_9552]        # 004d698f
    add edx, 0x1                                 # 004d6995
    mov eax, dword ptr [ebp - local_8]           # 004d6998
    mov dword ptr [eax + field_9552], edx        # 004d699b
L_004d69a1:
    # block 0x004d69a1: entered by jmp at 0x004d698a, 3 instruction(s), ends with jge to 0x004d6aca (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004d69a1
    cmp dword ptr [ecx + field_9552], 0xa        # 004d69a4
    jge.d32 L_004d6aca                           # 004d69ab
    # block 0x004d69b1: entered by fall-through of jge at 0x004d69ab, 5 instruction(s), ends with jne to 0x004d69c9 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d69b1
    mov eax, dword ptr [edx + field_9552]        # 004d69b4
    mov ecx, dword ptr [ebp - local_8]           # 004d69ba
    cmp dword ptr [ecx + 4*eax + field_9582], 0x0 # 004d69bd
    jne.d8 L_004d69c9                            # 004d69c5
    # block 0x004d69c7: entered by fall-through of jne at 0x004d69c5, 1 instruction(s), ends with backward jump to 0x004d698c
    jmp.d8 L_004d698c                            # 004d69c7
L_004d69c9:
    # block 0x004d69c9: entered by jne at 0x004d69c5, 5 instruction(s), ends with jne to 0x004d6a35 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d69c9
    mov eax, dword ptr [edx + field_9552]        # 004d69cc
    mov ecx, dword ptr [ebp - local_8]           # 004d69d2
    cmp dword ptr [ecx + 4*eax + field_9582], 0x2 # 004d69d5
    jne.d8 L_004d6a35                            # 004d69dd
    # block 0x004d69df: entered by fall-through of jne at 0x004d69dd, 5 instruction(s), ends with je to 0x004d6a35 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d69df
    mov eax, dword ptr [ebp - local_8]           # 004d69e2
    mov ecx, dword ptr [edx + field_9562]        # 004d69e5
    cmp ecx, dword ptr [eax + field_9552]        # 004d69eb
    je.d8 L_004d6a35                             # 004d69f1
    # block 0x004d69f3: entered by fall-through of je at 0x004d69f1, 16 instruction(s), calls FUN_004d65e9, falls into the block at 0x004d6a35
    mov edx, dword ptr [ebp - local_8]           # 004d69f3
    mov eax, dword ptr [edx + field_9552]        # 004d69f6
    mov ecx, dword ptr [ebp - local_8]           # 004d69fc
    mov dword ptr [ecx + 4*eax + field_9582], 0x1 # 004d69ff
    mov edx, dword ptr [ebp - local_8]           # 004d6a0a
    mov eax, dword ptr [edx + field_9552]        # 004d6a0d
    imul eax, eax, 0x21                          # 004d6a13
    mov ecx, dword ptr [ebp - local_8]           # 004d6a16
    lea edx, [ecx + eax + field_95aa]            # 004d6a19
    push edx                                     # 004d6a20
    push 0x1                                     # 004d6a21
    mov eax, dword ptr [ebp - local_8]           # 004d6a23
    mov ecx, dword ptr [eax + field_9552]        # 004d6a26
    push ecx                                     # 004d6a2c
    mov ecx, dword ptr [ebp - local_8]           # 004d6a2d
    call FUN_004d65e9                            # 004d6a30
L_004d6a35:
    # block 0x004d6a35: entered by jne at 0x004d69dd; je at 0x004d69f1, 8 instruction(s), ends with jg to 0x004d6ac5 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004d6a35
    mov eax, dword ptr [edx + field_9552]        # 004d6a38
    shl eax, 0x4                                 # 004d6a3e
    mov ecx, dword ptr [ebp - local_8]           # 004d6a41
    mov edx, dword ptr [ecx + eax + field_207]   # 004d6a44
    sub edx, 0x5                                 # 004d6a4b
    cmp dword ptr [0x583106], edx                # 004d6a4e
    jg.d8 L_004d6ac5                             # 004d6a54
    # block 0x004d6a56: entered by fall-through of jg at 0x004d6a54, 10 instruction(s), ends with jl to 0x004d6ac5 (forward)
    mov eax, dword ptr [0x58310e]                # 004d6a56
    sub eax, 0xc                                 # 004d6a5b
    mov ecx, dword ptr [ebp - local_8]           # 004d6a5e
    mov edx, dword ptr [ecx + field_9552]        # 004d6a61
    shl edx, 0x4                                 # 004d6a67
    mov ecx, dword ptr [ebp - local_8]           # 004d6a6a
    mov edx, dword ptr [ecx + edx + field_1ff]   # 004d6a6d
    add edx, 0x6                                 # 004d6a74
    {load} cmp eax, edx                          # 004d6a77
    jl.d8 L_004d6ac5                             # 004d6a79
    # block 0x004d6a7b: entered by fall-through of jl at 0x004d6a79, 7 instruction(s), ends with jg to 0x004d6ac5 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004d6a7b
    mov ecx, dword ptr [eax + field_9552]        # 004d6a7e
    shl ecx, 0x4                                 # 004d6a84
    mov edx, dword ptr [ebp - local_8]           # 004d6a87
    mov eax, dword ptr [0x583102]                # 004d6a8a
    cmp eax, dword ptr [edx + ecx + field_203]   # 004d6a8f
    jg.d8 L_004d6ac5                             # 004d6a96
    # block 0x004d6a98: entered by fall-through of jg at 0x004d6a96, 8 instruction(s), ends with jl to 0x004d6ac5 (forward)
    mov ecx, dword ptr [0x58310a]                # 004d6a98
    sub ecx, 0xa                                 # 004d6a9e
    mov edx, dword ptr [ebp - local_8]           # 004d6aa1
    mov eax, dword ptr [edx + field_9552]        # 004d6aa4
    shl eax, 0x4                                 # 004d6aaa
    mov edx, dword ptr [ebp - local_8]           # 004d6aad
    cmp ecx, dword ptr [edx + eax + field_1fb]   # 004d6ab0
    jl.d8 L_004d6ac5                             # 004d6ab7
    # block 0x004d6ab9: entered by fall-through of jl at 0x004d6ab7, 3 instruction(s), falls into the block at 0x004d6ac5
    mov eax, dword ptr [ebp - local_8]           # 004d6ab9
    mov ecx, dword ptr [eax + field_9552]        # 004d6abc
    mov dword ptr [ebp - local_4], ecx           # 004d6ac2
L_004d6ac5:
    # block 0x004d6ac5: entered by jg at 0x004d6a54; jl at 0x004d6a79; jg at 0x004d6a96; jl at 0x004d6ab7, 1 instruction(s), ends with backward jump to 0x004d698c
    jmp.d32 L_004d698c                           # 004d6ac5
L_004d6aca:
    # block 0x004d6aca: entered by jge at 0x004d69ab, 4 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_4]           # 004d6aca
    {load} mov esp, ebp                          # 004d6acd
    pop ebp                                      # 004d6acf
    ret                                          # 004d6ad0

