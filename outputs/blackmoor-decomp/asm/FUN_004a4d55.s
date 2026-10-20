# FUN_004a4d55
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a4d55
# extent:       0x004a4d55-0x004a4f58 (515 code bytes)
# span:         0x004a4d55-0x004a4f58 (code 515, tables 0, padding 0)
# sha256:       f1aff2ec16f0265ff8cd232f9af76846d303816ca102b242e6d6e9ce4daa57ac
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a4d55
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_21, field_22, field_264, field_27b, field_52f, field_56c; [ecx + n] field_21, field_22, field_4f3, field_530; [edx + n] field_264, field_27f, field_4b7
# callees:      calls FUN_004a4c15
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 140 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_264, 0x264  # offset +0x264
.equ field_27b, 0x27b  # offset +0x27b
.equ field_27f, 0x27f  # offset +0x27f
.equ field_4b7, 0x4b7  # offset +0x4b7
.equ field_4f3, 0x4f3  # offset +0x4f3
.equ field_52f, 0x52f  # offset +0x52f
.equ field_530, 0x530  # offset +0x530
.equ field_56c, 0x56c  # offset +0x56c

# --- external targets -----------------------------------------------
.set FUN_004a4c15, .text + (0x004a4c15 - 0x401000)

.org 0x004a4d55 - 0x401000
.globl FUN_004a4d55
FUN_004a4d55:
    # block 0x004a4d55: entry, 11 instruction(s), ends with forward jump to 0x004a4d86
    push ebp                                     # 004a4d55
    {load} mov ebp, esp                          # 004a4d56
    sub esp, 0x10                                # 004a4d58
    mov dword ptr [ebp - local_10], ecx          # 004a4d5b
    mov eax, dword ptr [ebp - local_10]          # 004a4d5e
    movsx ecx, word ptr [eax + field_1e]         # 004a4d61
    imul ecx, ecx, 0x8d                          # 004a4d65
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a4d6b
    mov dword ptr [ebp - local_4], edx           # 004a4d71
    mov dword ptr [ebp - local_c], 0x0           # 004a4d74
    jmp.d8 L_004a4d86                            # 004a4d7b
L_004a4d7d:
    # block 0x004a4d7d: entered by jmp at 0x004a4e58, 3 instruction(s), falls into the block at 0x004a4d86
    mov eax, dword ptr [ebp - local_c]           # 004a4d7d
    add eax, 0x1                                 # 004a4d80
    mov dword ptr [ebp - local_c], eax           # 004a4d83
L_004a4d86:
    # block 0x004a4d86: entered by jmp at 0x004a4d7b, 4 instruction(s), ends with jge to 0x004a4e5d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a4d86
    movsx edx, byte ptr [ecx + field_22]         # 004a4d89
    cmp dword ptr [ebp - local_c], edx           # 004a4d8d
    jge.d32 L_004a4e5d                           # 004a4d90
    # block 0x004a4d96: entered by fall-through of jge at 0x004a4d90, 2 instruction(s), ends with forward jump to 0x004a4da8
    mov dword ptr [ebp - local_8], 0x0           # 004a4d96
    jmp.d8 L_004a4da8                            # 004a4d9d
L_004a4d9f:
    # block 0x004a4d9f: entered by jmp at 0x004a4e53, 3 instruction(s), falls into the block at 0x004a4da8
    mov eax, dword ptr [ebp - local_8]           # 004a4d9f
    add eax, 0x1                                 # 004a4da2
    mov dword ptr [ebp - local_8], eax           # 004a4da5
L_004a4da8:
    # block 0x004a4da8: entered by jmp at 0x004a4d9d, 4 instruction(s), ends with jge to 0x004a4e58 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a4da8
    movsx edx, byte ptr [ecx + field_21]         # 004a4dab
    cmp dword ptr [ebp - local_8], edx           # 004a4daf
    jge.d32 L_004a4e58                           # 004a4db2
    # block 0x004a4db8: entered by fall-through of jge at 0x004a4db2, 16 instruction(s), ends with jne to 0x004a4e53 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004a4db8
    movsx ecx, word ptr [eax + field_264]        # 004a4dbb
    imul ecx, ecx, 0x7c                          # 004a4dc2
    mov edx, dword ptr [ebp - local_c]           # 004a4dc5
    imul edx, edx, 0xc                           # 004a4dc8
    lea eax, [ecx + edx + 0x591a64]              # 004a4dcb
    mov ecx, dword ptr [ebp - local_8]           # 004a4dd2
    movsx edx, word ptr [eax + 2*ecx]            # 004a4dd5
    mov eax, dword ptr [ebp - local_c]           # 004a4dd9
    imul eax, eax, 0xc                           # 004a4ddc
    mov ecx, dword ptr [ebp - local_4]           # 004a4ddf
    lea eax, [ecx + eax + field_4f3]             # 004a4de2
    mov ecx, dword ptr [ebp - local_8]           # 004a4de9
    movsx eax, word ptr [eax + 2*ecx]            # 004a4dec
    {load} cmp edx, eax                          # 004a4df0
    jne.d8 L_004a4e53                            # 004a4df2
    # block 0x004a4df4: entered by fall-through of jne at 0x004a4df2, 20 instruction(s), calls FUN_004a4c15, ends with jne to 0x004a4e53 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004a4df4
    imul ecx, ecx, 0xc                           # 004a4df7
    mov edx, dword ptr [ebp - local_4]           # 004a4dfa
    lea eax, [edx + ecx + field_4b7]             # 004a4dfd
    mov ecx, dword ptr [ebp - local_8]           # 004a4e04
    mov dx, word ptr [eax + 2*ecx]               # 004a4e07
    push edx                                     # 004a4e0b
    mov eax, dword ptr [ebp - local_10]          # 004a4e0c
    movsx ecx, word ptr [eax + field_264]        # 004a4e0f
    imul ecx, ecx, 0x7c                          # 004a4e16
    mov edx, dword ptr [ebp - local_c]           # 004a4e19
    imul edx, edx, 0xc                           # 004a4e1c
    lea eax, [ecx + edx + 0x591a28]              # 004a4e1f
    mov ecx, dword ptr [ebp - local_8]           # 004a4e26
    mov dx, word ptr [eax + 2*ecx]               # 004a4e29
    push edx                                     # 004a4e2d
    mov ecx, dword ptr [ebp - local_10]          # 004a4e2e
    call FUN_004a4c15                            # 004a4e31
    test eax, eax                                # 004a4e36
    jne.d8 L_004a4e53                            # 004a4e38
    # block 0x004a4e3a: entered by fall-through of jne at 0x004a4e38, 5 instruction(s), ends with je to 0x004a4e4e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a4e3a
    {load} xor ecx, ecx                          # 004a4e3d
    mov cl, byte ptr [eax + field_52f]           # 004a4e3f
    test ecx, ecx                                # 004a4e45
    je.d8 L_004a4e4e                             # 004a4e47
    # block 0x004a4e49: entered by fall-through of je at 0x004a4e47, 1 instruction(s), ends with forward jump to 0x004a4f4f
    jmp.d32 L_004a4f4f                           # 004a4e49
L_004a4e4e:
    # block 0x004a4e4e: entered by je at 0x004a4e47, 1 instruction(s), ends with forward jump to 0x004a4f54
    jmp.d32 L_004a4f54                           # 004a4e4e
L_004a4e53:
    # block 0x004a4e53: entered by jne at 0x004a4df2; jne at 0x004a4e38, 1 instruction(s), ends with backward jump to 0x004a4d9f
    jmp.d32 L_004a4d9f                           # 004a4e53
L_004a4e58:
    # block 0x004a4e58: entered by jge at 0x004a4db2, 1 instruction(s), ends with backward jump to 0x004a4d7d
    jmp.d32 L_004a4d7d                           # 004a4e58
L_004a4e5d:
    # block 0x004a4e5d: entered by jge at 0x004a4d90, 1 instruction(s), ends with forward jump to 0x004a4f4d
    jmp.d32 L_004a4f4d                           # 004a4e5d
L_004a4e62:
    # block 0x004a4e62: entered by jmp at 0x004a4f4f, 2 instruction(s), ends with forward jump to 0x004a4e74
    mov dword ptr [ebp - local_c], 0x0           # 004a4e62
    jmp.d8 L_004a4e74                            # 004a4e69
L_004a4e6b:
    # block 0x004a4e6b: entered by jmp at 0x004a4f2f, 3 instruction(s), falls into the block at 0x004a4e74
    mov edx, dword ptr [ebp - local_c]           # 004a4e6b
    add edx, 0x1                                 # 004a4e6e
    mov dword ptr [ebp - local_c], edx           # 004a4e71
L_004a4e74:
    # block 0x004a4e74: entered by jmp at 0x004a4e69, 4 instruction(s), ends with jge to 0x004a4f34 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a4e74
    movsx ecx, byte ptr [eax + field_22]         # 004a4e77
    cmp dword ptr [ebp - local_c], ecx           # 004a4e7b
    jge.d32 L_004a4f34                           # 004a4e7e
    # block 0x004a4e84: entered by fall-through of jge at 0x004a4e7e, 2 instruction(s), ends with forward jump to 0x004a4e96
    mov dword ptr [ebp - local_8], 0x0           # 004a4e84
    jmp.d8 L_004a4e96                            # 004a4e8b
L_004a4e8d:
    # block 0x004a4e8d: entered by jmp at 0x004a4f2a, 3 instruction(s), falls into the block at 0x004a4e96
    mov edx, dword ptr [ebp - local_8]           # 004a4e8d
    add edx, 0x1                                 # 004a4e90
    mov dword ptr [ebp - local_8], edx           # 004a4e93
L_004a4e96:
    # block 0x004a4e96: entered by jmp at 0x004a4e8b, 4 instruction(s), ends with jge to 0x004a4f2f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a4e96
    movsx ecx, byte ptr [eax + field_21]         # 004a4e99
    cmp dword ptr [ebp - local_8], ecx           # 004a4e9d
    jge.d32 L_004a4f2f                           # 004a4ea0
    # block 0x004a4ea6: entered by fall-through of jge at 0x004a4ea0, 16 instruction(s), ends with jne to 0x004a4f2a (forward)
    mov edx, dword ptr [ebp - local_10]          # 004a4ea6
    movsx eax, word ptr [edx + field_264]        # 004a4ea9
    imul eax, eax, 0x7c                          # 004a4eb0
    mov ecx, dword ptr [ebp - local_c]           # 004a4eb3
    imul ecx, ecx, 0xc                           # 004a4eb6
    lea edx, [eax + ecx + 0x591a64]              # 004a4eb9
    mov eax, dword ptr [ebp - local_8]           # 004a4ec0
    movsx ecx, word ptr [edx + 2*eax]            # 004a4ec3
    mov edx, dword ptr [ebp - local_c]           # 004a4ec7
    imul edx, edx, 0xc                           # 004a4eca
    mov eax, dword ptr [ebp - local_4]           # 004a4ecd
    lea edx, [eax + edx + field_56c]             # 004a4ed0
    mov eax, dword ptr [ebp - local_8]           # 004a4ed7
    movsx edx, word ptr [edx + 2*eax]            # 004a4eda
    {load} cmp ecx, edx                          # 004a4ede
    jne.d8 L_004a4f2a                            # 004a4ee0
    # block 0x004a4ee2: entered by fall-through of jne at 0x004a4ee0, 20 instruction(s), calls FUN_004a4c15, ends with jne to 0x004a4f2a (forward)
    mov eax, dword ptr [ebp - local_c]           # 004a4ee2
    imul eax, eax, 0xc                           # 004a4ee5
    mov ecx, dword ptr [ebp - local_4]           # 004a4ee8
    lea edx, [ecx + eax + field_530]             # 004a4eeb
    mov eax, dword ptr [ebp - local_8]           # 004a4ef2
    mov cx, word ptr [edx + 2*eax]               # 004a4ef5
    push ecx                                     # 004a4ef9
    mov edx, dword ptr [ebp - local_10]          # 004a4efa
    movsx eax, word ptr [edx + field_264]        # 004a4efd
    imul eax, eax, 0x7c                          # 004a4f04
    mov ecx, dword ptr [ebp - local_c]           # 004a4f07
    imul ecx, ecx, 0xc                           # 004a4f0a
    lea edx, [eax + ecx + 0x591a28]              # 004a4f0d
    mov eax, dword ptr [ebp - local_8]           # 004a4f14
    mov cx, word ptr [edx + 2*eax]               # 004a4f17
    push ecx                                     # 004a4f1b
    mov ecx, dword ptr [ebp - local_10]          # 004a4f1c
    call FUN_004a4c15                            # 004a4f1f
    test eax, eax                                # 004a4f24
    jne.d8 L_004a4f2a                            # 004a4f26
    # block 0x004a4f28: entered by fall-through of jne at 0x004a4f26, 1 instruction(s), ends with forward jump to 0x004a4f54
    jmp.d8 L_004a4f54                            # 004a4f28
L_004a4f2a:
    # block 0x004a4f2a: entered by jne at 0x004a4ee0; jne at 0x004a4f26, 1 instruction(s), ends with backward jump to 0x004a4e8d
    jmp.d32 L_004a4e8d                           # 004a4f2a
L_004a4f2f:
    # block 0x004a4f2f: entered by jge at 0x004a4ea0, 1 instruction(s), ends with backward jump to 0x004a4e6b
    jmp.d32 L_004a4e6b                           # 004a4f2f
L_004a4f34:
    # block 0x004a4f34: entered by jge at 0x004a4e7e; jmp at 0x004a4f4d, 5 instruction(s), ends with forward jump to 0x004a4f54
    mov edx, dword ptr [ebp - local_10]          # 004a4f34
    mov byte ptr [edx + field_27f], 0x1          # 004a4f37
    mov eax, dword ptr [ebp - local_10]          # 004a4f3e
    mov dword ptr [eax + field_27b], 0x2         # 004a4f41
    jmp.d8 L_004a4f54                            # 004a4f4b
L_004a4f4d:
    # block 0x004a4f4d: entered by jmp at 0x004a4e5d, 1 instruction(s), ends with backward jump to 0x004a4f34
    jmp.d8 L_004a4f34                            # 004a4f4d
L_004a4f4f:
    # block 0x004a4f4f: entered by jmp at 0x004a4e49, 1 instruction(s), ends with backward jump to 0x004a4e62
    jmp.d32 L_004a4e62                           # 004a4f4f
L_004a4f54:
    # block 0x004a4f54: entered by jmp at 0x004a4e4e; jmp at 0x004a4f28; jmp at 0x004a4f4b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a4f54
    pop ebp                                      # 004a4f56
    ret                                          # 004a4f57

