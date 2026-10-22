# FUN_0045eb76
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045eb76
# extent:       0x0045eb76-0x0045ed60 (490 code bytes)
# span:         0x0045eb76-0x0045ed60 (code 490, tables 0, padding 0)
# sha256:       91a10fa18573088bcc6e34fd3edc19d5f917dda21f956711715ea14b58cd263e
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045eb76
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_25, field_f4, field_31d, field_381; [ecx + n] field_21, field_f4, field_31d, field_381; [edx + n] field_25, field_f4, field_31d, field_381, field_383
# callees:      calls FUN_0050cd50
# track-n:      outputs/blackmoor-decomp/src/action_family_f6_runtime.c:computer_pick (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 127 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_f4, 0xf4  # offset +0xf4
.equ field_31d, 0x31d  # offset +0x31d
.equ field_381, 0x381  # offset +0x381
.equ field_383, 0x383  # offset +0x383

# --- external targets -----------------------------------------------
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0045eb76 - 0x401000
.globl FUN_0045eb76
FUN_0045eb76:
    # block 0x0045eb76: entry, 13 instruction(s), ends with je to 0x0045ec1e (forward)
    push ebp                                     # 0045eb76
    {load} mov ebp, esp                          # 0045eb77
    sub esp, 0x1c                                # 0045eb79
    mov dword ptr [ebp - local_1c], ecx          # 0045eb7c
    mov word ptr [ebp - local_14], 0x0           # 0045eb7f
    mov dword ptr [ebp - local_4], 0x0           # 0045eb85
    mov dword ptr [ebp - local_c], 0x0           # 0045eb8c
    mov eax, dword ptr [ebp - local_1c]          # 0045eb93
    mov ecx, dword ptr [eax + field_31d]         # 0045eb96
    {load} xor edx, edx                          # 0045eb9c
    mov dl, byte ptr [ecx + field_21]            # 0045eb9e
    test edx, edx                                # 0045eba1
    je.d8 L_0045ec1e                             # 0045eba3
    # block 0x0045eba5: entered by fall-through of je at 0x0045eba3, 2 instruction(s), ends with forward jump to 0x0045ebb9
    mov word ptr [ebp - local_18], 0x0           # 0045eba5
    jmp.d8 L_0045ebb9                            # 0045ebab
L_0045ebad:
    # block 0x0045ebad: entered by jmp at 0x0045ec1c, 3 instruction(s), falls into the block at 0x0045ebb9
    mov ax, word ptr [ebp - local_18]            # 0045ebad
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045ebb1
    mov word ptr [ebp - local_18], ax            # 0045ebb5
L_0045ebb9:
    # block 0x0045ebb9: entered by jmp at 0x0045ebab, 6 instruction(s), ends with jge to 0x0045ec1e (forward)
    movsx ecx, word ptr [ebp - local_18]         # 0045ebb9
    mov edx, dword ptr [ebp - local_1c]          # 0045ebbd
    mov eax, dword ptr [edx + field_31d]         # 0045ebc0
    movsx edx, word ptr [eax + field_25]         # 0045ebc6
    {load} cmp ecx, edx                          # 0045ebca
    jge.d8 L_0045ec1e                            # 0045ebcc
    # block 0x0045ebce: entered by fall-through of jge at 0x0045ebcc, 5 instruction(s), ends with jle to 0x0045ebe9 (forward)
    movsx eax, word ptr [ebp - local_18]         # 0045ebce
    mov ecx, dword ptr [ebp - local_1c]          # 0045ebd2
    movsx edx, word ptr [ecx + 2*eax + field_f4] # 0045ebd5
    cmp edx, 0x1                                 # 0045ebdd
    jle.d8 L_0045ebe9                            # 0045ebe0
    # block 0x0045ebe2: entered by fall-through of jle at 0x0045ebe0, 1 instruction(s), falls into the block at 0x0045ebe9
    mov dword ptr [ebp - local_4], 0x1           # 0045ebe2
L_0045ebe9:
    # block 0x0045ebe9: entered by jle at 0x0045ebe0, 5 instruction(s), ends with jle to 0x0045ec1c (forward)
    movsx eax, word ptr [ebp - local_18]         # 0045ebe9
    mov ecx, dword ptr [ebp - local_1c]          # 0045ebed
    movsx edx, word ptr [ecx + 2*eax + field_f4] # 0045ebf0
    test edx, edx                                # 0045ebf8
    jle.d8 L_0045ec1c                            # 0045ebfa
    # block 0x0045ebfc: entered by fall-through of jle at 0x0045ebfa, 5 instruction(s), ends with jge to 0x0045ec1c (forward)
    movsx eax, word ptr [ebp - local_18]         # 0045ebfc
    mov ecx, dword ptr [ebp - local_1c]          # 0045ec00
    movsx edx, word ptr [ecx + 2*eax + field_f4] # 0045ec03
    cmp edx, 0x3                                 # 0045ec0b
    jge.d8 L_0045ec1c                            # 0045ec0e
    # block 0x0045ec10: entered by fall-through of jge at 0x0045ec0e, 3 instruction(s), falls into the block at 0x0045ec1c
    mov ax, word ptr [ebp - local_14]            # 0045ec10
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045ec14
    mov word ptr [ebp - local_14], ax            # 0045ec18
L_0045ec1c:
    # block 0x0045ec1c: entered by jle at 0x0045ebfa; jge at 0x0045ec0e, 1 instruction(s), ends with backward jump to 0x0045ebad
    jmp.d8 L_0045ebad                            # 0045ec1c
L_0045ec1e:
    # block 0x0045ec1e: entered by je at 0x0045eba3; jge at 0x0045ebcc; jmp at 0x0045ed22, 2 instruction(s), ends with jne to 0x0045ed27 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 0045ec1e
    jne.d32 L_0045ed27                           # 0045ec22
    # block 0x0045ec28: entered by fall-through of jne at 0x0045ec22, 12 instruction(s), calls FUN_0050cd50, ends with jl to 0x0045ecb7 (forward)
    call FUN_0050cd50                            # 0045ec28
    mov ecx, dword ptr [ebp - local_1c]          # 0045ec2d
    mov edx, dword ptr [ecx + field_31d]         # 0045ec30
    movsx ecx, word ptr [edx + field_25]         # 0045ec36
    cdq                                          # 0045ec3a
    idiv ecx                                     # 0045ec3b
    mov word ptr [ebp - local_18], dx            # 0045ec3d
    mov dword ptr [ebp - local_10], 0x0          # 0045ec41
    mov edx, dword ptr [ebp - local_1c]          # 0045ec48
    movsx eax, word ptr [edx + field_381]        # 0045ec4b
    test eax, eax                                # 0045ec52
    jl.d8 L_0045ecb7                             # 0045ec54
    # block 0x0045ec56: entered by fall-through of jl at 0x0045ec54, 3 instruction(s), ends with jle to 0x0045ecb7 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 0045ec56
    cmp ecx, 0x1                                 # 0045ec5a
    jle.d8 L_0045ecb7                            # 0045ec5d
    # block 0x0045ec5f: entered by fall-through of jle at 0x0045ec5d, 5 instruction(s), ends with jge to 0x0045ecb7 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 0045ec5f
    movsx eax, word ptr [edx + field_381]        # 0045ec62
    movsx ecx, word ptr [ebp - local_14]         # 0045ec69
    {load} cmp eax, ecx                          # 0045ec6d
    jge.d8 L_0045ecb7                            # 0045ec6f
    # block 0x0045ec71: entered by fall-through of jge at 0x0045ec6f, 2 instruction(s), ends with forward jump to 0x0045ec85
    mov word ptr [ebp - local_8], 0x0            # 0045ec71
    jmp.d8 L_0045ec85                            # 0045ec77
L_0045ec79:
    # block 0x0045ec79: entered by jmp at 0x0045ecb5, 3 instruction(s), falls into the block at 0x0045ec85
    mov dx, word ptr [ebp - local_8]             # 0045ec79
    add dx, 0x1                                  # 0045ec7d
    mov word ptr [ebp - local_8], dx             # 0045ec81
L_0045ec85:
    # block 0x0045ec85: entered by jmp at 0x0045ec77, 5 instruction(s), ends with jg to 0x0045ecb7 (forward)
    movsx eax, word ptr [ebp - local_8]          # 0045ec85
    mov ecx, dword ptr [ebp - local_1c]          # 0045ec89
    movsx edx, word ptr [ecx + field_381]        # 0045ec8c
    {load} cmp eax, edx                          # 0045ec93
    jg.d8 L_0045ecb7                             # 0045ec95
    # block 0x0045ec97: entered by fall-through of jg at 0x0045ec95, 6 instruction(s), ends with jne to 0x0045ecb5 (forward)
    movsx eax, word ptr [ebp - local_18]         # 0045ec97
    movsx ecx, word ptr [ebp - local_8]          # 0045ec9b
    mov edx, dword ptr [ebp - local_1c]          # 0045ec9f
    movsx ecx, word ptr [edx + 2*ecx + field_383] # 0045eca2
    {load} cmp eax, ecx                          # 0045ecaa
    jne.d8 L_0045ecb5                            # 0045ecac
    # block 0x0045ecae: entered by fall-through of jne at 0x0045ecac, 1 instruction(s), falls into the block at 0x0045ecb5
    mov dword ptr [ebp - local_10], 0x1          # 0045ecae
L_0045ecb5:
    # block 0x0045ecb5: entered by jne at 0x0045ecac, 1 instruction(s), ends with backward jump to 0x0045ec79
    jmp.d8 L_0045ec79                            # 0045ecb5
L_0045ecb7:
    # block 0x0045ecb7: entered by jl at 0x0045ec54; jle at 0x0045ec5d; jge at 0x0045ec6f; jg at 0x0045ec95, 2 instruction(s), ends with jne to 0x0045ed22 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 0045ecb7
    jne.d8 L_0045ed22                            # 0045ecbb
    # block 0x0045ecbd: entered by fall-through of jne at 0x0045ecbb, 5 instruction(s), ends with jge to 0x0045ed22 (forward)
    movsx edx, word ptr [ebp - local_18]         # 0045ecbd
    mov eax, dword ptr [ebp - local_1c]          # 0045ecc1
    movsx ecx, word ptr [eax + 2*edx + field_f4] # 0045ecc4
    cmp ecx, 0x3                                 # 0045eccc
    jge.d8 L_0045ed22                            # 0045eccf
    # block 0x0045ecd1: entered by fall-through of jge at 0x0045eccf, 2 instruction(s), ends with je to 0x0045ecfe (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0045ecd1
    je.d8 L_0045ecfe                             # 0045ecd5
    # block 0x0045ecd7: entered by fall-through of je at 0x0045ecd5, 5 instruction(s), ends with jle to 0x0045ecfe (forward)
    movsx edx, word ptr [ebp - local_18]         # 0045ecd7
    mov eax, dword ptr [ebp - local_1c]          # 0045ecdb
    movsx ecx, word ptr [eax + 2*edx + field_f4] # 0045ecde
    cmp ecx, 0x1                                 # 0045ece6
    jle.d8 L_0045ecfe                            # 0045ece9
    # block 0x0045eceb: entered by fall-through of jle at 0x0045ece9, 5 instruction(s), ends with forward jump to 0x0045ed22
    mov edx, dword ptr [ebp + arg_8]             # 0045eceb
    mov ax, word ptr [ebp - local_18]            # 0045ecee
    mov word ptr [edx], ax                       # 0045ecf2
    mov dword ptr [ebp - local_c], 0x1           # 0045ecf5
    jmp.d8 L_0045ed22                            # 0045ecfc
L_0045ecfe:
    # block 0x0045ecfe: entered by je at 0x0045ecd5; jle at 0x0045ece9, 5 instruction(s), ends with jle to 0x0045ed22 (forward)
    movsx ecx, word ptr [ebp - local_18]         # 0045ecfe
    mov edx, dword ptr [ebp - local_1c]          # 0045ed02
    movsx eax, word ptr [edx + 2*ecx + field_f4] # 0045ed05
    test eax, eax                                # 0045ed0d
    jle.d8 L_0045ed22                            # 0045ed0f
    # block 0x0045ed11: entered by fall-through of jle at 0x0045ed0f, 4 instruction(s), falls into the block at 0x0045ed22
    mov ecx, dword ptr [ebp + arg_8]             # 0045ed11
    mov dx, word ptr [ebp - local_18]            # 0045ed14
    mov word ptr [ecx], dx                       # 0045ed18
    mov dword ptr [ebp - local_c], 0x1           # 0045ed1b
L_0045ed22:
    # block 0x0045ed22: entered by jne at 0x0045ecbb; jge at 0x0045eccf; jmp at 0x0045ecfc; jle at 0x0045ed0f, 1 instruction(s), ends with backward jump to 0x0045ec1e
    jmp.d32 L_0045ec1e                           # 0045ed22
L_0045ed27:
    # block 0x0045ed27: entered by jne at 0x0045ec22, 14 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_1c]          # 0045ed27
    mov cx, word ptr [eax + field_381]           # 0045ed2a
    add cx, 0x1                                  # 0045ed31
    mov edx, dword ptr [ebp - local_1c]          # 0045ed35
    mov word ptr [edx + field_381], cx           # 0045ed38
    mov eax, dword ptr [ebp - local_1c]          # 0045ed3f
    movsx ecx, word ptr [eax + field_381]        # 0045ed42
    mov edx, dword ptr [ebp - local_1c]          # 0045ed49
    mov eax, dword ptr [ebp + arg_8]             # 0045ed4c
    mov ax, word ptr [eax]                       # 0045ed4f
    mov word ptr [edx + 2*ecx + field_383], ax   # 0045ed52
    {load} mov esp, ebp                          # 0045ed5a
    pop ebp                                      # 0045ed5c
    ret 0x4                                      # 0045ed5d

