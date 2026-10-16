# FUN_004ebb5b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ebb5b
# extent:       0x004ebb5b-0x004ebd2e (467 code bytes)
# span:         0x004ebb5b-0x004ebd2e (code 467, tables 0, padding 0)
# sha256:       363a6d418ba687de5ade49572d9741278407e52410c1d7e97a4ef7860fd8bb8f
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ebb5b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_985, field_989, field_98d, field_ca8, field_fc6; [ecx + n] field_ca8, field_fc6, field_fce; [edx + n] field_989, field_fc6, field_fca
# callees:      calls FUN_004ee572, FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_004edcb1, FUN_004ee6c7, FUN_004ee673, FUN_004e1db3, FUN_004e2990, FUN_004e29b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 111 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_985, 0x985  # offset +0x985
.equ field_989, 0x989  # offset +0x989
.equ field_98d, 0x98d  # offset +0x98d
.equ field_ca8, 0xca8  # offset +0xca8
.equ field_fc6, 0xfc6  # offset +0xfc6
.equ field_fca, 0xfca  # offset +0xfca
.equ field_fce, 0xfce  # offset +0xfce

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004e1db3, .text + (0x004e1db3 - 0x401000)
.set FUN_004e2990, .text + (0x004e2990 - 0x401000)
.set FUN_004e29b7, .text + (0x004e29b7 - 0x401000)
.set FUN_004edcb1, .text + (0x004edcb1 - 0x401000)
.set FUN_004ee572, .text + (0x004ee572 - 0x401000)
.set FUN_004ee5f2, .text + (0x004ee5f2 - 0x401000)
.set FUN_004ee673, .text + (0x004ee673 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004ebb5b - 0x401000
.globl FUN_004ebb5b
FUN_004ebb5b:
    # block 0x004ebb5b: entry, 8 instruction(s), calls FUN_004ee572, ends with je to 0x004ebbbf (forward)
    push ebp                                     # 004ebb5b
    {load} mov ebp, esp                          # 004ebb5c
    push ecx                                     # 004ebb5e
    mov dword ptr [ebp - local_4], ecx           # 004ebb5f
    mov ecx, dword ptr [ebp - local_4]           # 004ebb62
    call FUN_004ee572                            # 004ebb65
    test eax, eax                                # 004ebb6a
    je.d8 L_004ebbbf                             # 004ebb6c
    # block 0x004ebb6e: entered by fall-through of je at 0x004ebb6c, 13 instruction(s), calls FUN_004ee5f2, FUN_0050ca3e, FUN_004264e8, ends with je to 0x004ebbb0 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ebb6e
    call FUN_004ee5f2                            # 004ebb71
    push eax                                     # 004ebb76
    push 0x55cbfc                                # 004ebb77
    push 0x63888b                                # 004ebb7c
    call FUN_0050ca3e                            # 004ebb81
    add esp, 0xc                                 # 004ebb86
    push 0x63888b                                # 004ebb89
    mov ecx, 0x583979                            # 004ebb8e
    call FUN_004264e8                            # 004ebb93
    movsx eax, word ptr [0x63a4cd]               # 004ebb98
    test eax, eax                                # 004ebb9f
    je.d8 L_004ebbb0                             # 004ebba1
    # block 0x004ebba3: entered by fall-through of je at 0x004ebba1, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ebbb0
    push 0x63888b                                # 004ebba3
    call FUN_0044a2b7                            # 004ebba8
    add esp, 0x4                                 # 004ebbad
L_004ebbb0:
    # block 0x004ebbb0: entered by je at 0x004ebba1, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004ebd2a
    mov ecx, 0x5cf659                            # 004ebbb0
    call FUN_004c97b4                            # 004ebbb5
    jmp.d32 L_004ebd2a                           # 004ebbba
L_004ebbbf:
    # block 0x004ebbbf: entered by je at 0x004ebb6c, 15 instruction(s), calls FUN_004edcb1, FUN_004ee6c7, FUN_004ee673, ends with forward jump to 0x004ebc0b
    push 0x1                                     # 004ebbbf
    mov ecx, dword ptr [ebp - local_4]           # 004ebbc1
    add ecx, 0x695                               # 004ebbc4
    push ecx                                     # 004ebbca
    mov ecx, dword ptr [ebp - local_4]           # 004ebbcb
    call FUN_004edcb1                            # 004ebbce
    push 0x1                                     # 004ebbd3
    mov ecx, dword ptr [ebp - local_4]           # 004ebbd5
    call FUN_004ee6c7                            # 004ebbd8
    push 0x0                                     # 004ebbdd
    mov ecx, dword ptr [ebp - local_4]           # 004ebbdf
    call FUN_004ee673                            # 004ebbe2
    mov edx, dword ptr [ebp - local_4]           # 004ebbe7
    mov dword ptr [edx + field_fc6], 0x0         # 004ebbea
    jmp.d8 L_004ebc0b                            # 004ebbf4
L_004ebbf6:
    # block 0x004ebbf6: entered by jmp at 0x004ebd25, 5 instruction(s), falls into the block at 0x004ebc0b
    mov eax, dword ptr [ebp - local_4]           # 004ebbf6
    mov ecx, dword ptr [eax + field_fc6]         # 004ebbf9
    add ecx, 0x1                                 # 004ebbff
    mov edx, dword ptr [ebp - local_4]           # 004ebc02
    mov dword ptr [edx + field_fc6], ecx         # 004ebc05
L_004ebc0b:
    # block 0x004ebc0b: entered by jmp at 0x004ebbf4, 3 instruction(s), ends with jge to 0x004ebd2a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ebc0b
    cmp dword ptr [eax + field_fc6], 0x2         # 004ebc0e
    jge.d32 L_004ebd2a                           # 004ebc15
    # block 0x004ebc1b: entered by fall-through of jge at 0x004ebc15, 6 instruction(s), ends with je to 0x004ebd25 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ebc1b
    mov edx, dword ptr [ecx + field_fc6]         # 004ebc1e
    imul edx, edx, 0xf7                          # 004ebc24
    mov eax, dword ptr [ebp - local_4]           # 004ebc2a
    cmp dword ptr [eax + edx + field_985], 0x0   # 004ebc2d
    je.d32 L_004ebd25                            # 004ebc35
    # block 0x004ebc3b: entered by fall-through of je at 0x004ebc35, 22 instruction(s), calls FUN_004e1db3, FUN_004e2990, ends with jne to 0x004ebd05 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ebc3b
    mov edx, dword ptr [ecx + field_fc6]         # 004ebc3e
    imul edx, edx, 0xf7                          # 004ebc44
    mov eax, dword ptr [ebp - local_4]           # 004ebc4a
    lea ecx, [eax + edx + field_98d]             # 004ebc4d
    push ecx                                     # 004ebc54
    mov edx, dword ptr [ebp - local_4]           # 004ebc55
    mov eax, dword ptr [edx + field_fc6]         # 004ebc58
    imul eax, eax, 0x18f                         # 004ebc5e
    mov ecx, dword ptr [ebp - local_4]           # 004ebc64
    lea ecx, [ecx + eax + field_ca8]             # 004ebc67
    call FUN_004e1db3                            # 004ebc6e
    push 0x1                                     # 004ebc73
    mov edx, dword ptr [ebp - local_4]           # 004ebc75
    mov eax, dword ptr [edx + field_fc6]         # 004ebc78
    imul eax, eax, 0x18f                         # 004ebc7e
    mov ecx, dword ptr [ebp - local_4]           # 004ebc84
    lea ecx, [ecx + eax + field_ca8]             # 004ebc87
    call FUN_004e2990                            # 004ebc8e
    mov edx, dword ptr [ebp - local_4]           # 004ebc93
    cmp dword ptr [edx + field_fca], -0x1        # 004ebc96
    jne.d8 L_004ebd05                            # 004ebc9d
    # block 0x004ebc9f: entered by fall-through of jne at 0x004ebc9d, 22 instruction(s), calls FUN_004e29b7, ends with forward jump to 0x004ebd25
    mov eax, dword ptr [ebp - local_4]           # 004ebc9f
    mov ecx, dword ptr [eax + field_fc6]         # 004ebca2
    imul ecx, ecx, 0xf7                          # 004ebca8
    mov edx, dword ptr [ebp - local_4]           # 004ebcae
    mov eax, dword ptr [ebp - local_4]           # 004ebcb1
    mov ecx, dword ptr [eax + ecx + field_989]   # 004ebcb4
    mov dword ptr [edx + field_fca], ecx         # 004ebcbb
    mov edx, dword ptr [ebp - local_4]           # 004ebcc1
    mov eax, dword ptr [edx + field_fc6]         # 004ebcc4
    imul eax, eax, 0xf7                          # 004ebcca
    mov ecx, dword ptr [ebp - local_4]           # 004ebcd0
    mov edx, dword ptr [ebp - local_4]           # 004ebcd3
    mov eax, dword ptr [edx + eax + field_989]   # 004ebcd6
    mov dword ptr [ecx + field_fce], eax         # 004ebcdd
    push 0x1                                     # 004ebce3
    mov ecx, dword ptr [ebp - local_4]           # 004ebce5
    mov edx, dword ptr [ecx + field_fc6]         # 004ebce8
    imul edx, edx, 0x18f                         # 004ebcee
    mov eax, dword ptr [ebp - local_4]           # 004ebcf4
    lea ecx, [eax + edx + field_ca8]             # 004ebcf7
    call FUN_004e29b7                            # 004ebcfe
    jmp.d8 L_004ebd25                            # 004ebd03
L_004ebd05:
    # block 0x004ebd05: entered by jne at 0x004ebc9d, 7 instruction(s), calls FUN_004e29b7, falls into the block at 0x004ebd25
    push 0x0                                     # 004ebd05
    mov ecx, dword ptr [ebp - local_4]           # 004ebd07
    mov edx, dword ptr [ecx + field_fc6]         # 004ebd0a
    imul edx, edx, 0x18f                         # 004ebd10
    mov eax, dword ptr [ebp - local_4]           # 004ebd16
    lea ecx, [eax + edx + field_ca8]             # 004ebd19
    call FUN_004e29b7                            # 004ebd20
L_004ebd25:
    # block 0x004ebd25: entered by je at 0x004ebc35; jmp at 0x004ebd03, 1 instruction(s), ends with backward jump to 0x004ebbf6
    jmp.d32 L_004ebbf6                           # 004ebd25
L_004ebd2a:
    # block 0x004ebd2a: entered by jmp at 0x004ebbba; jge at 0x004ebc15, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ebd2a
    pop ebp                                      # 004ebd2c
    ret                                          # 004ebd2d

