# FUN_004f88de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f88de
# extent:       0x004f88de-0x004f8a17 (313 code bytes)
# span:         0x004f88de-0x004f8a17 (code 313, tables 0, padding 0)
# sha256:       146884d2e81ad378dbaa2bfde710c1be4d62a180d7f513cd8b8ab25876210ad9
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f88de
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_34, field_19c, field_25c, field_268, field_3ca, field_3d2; [ecx + n] field_19c, field_258, field_264, field_3ca; [edx + n] field_260, field_26c, field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 93 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_34, 0x34  # offset +0x34
.equ field_19c, 0x19c  # offset +0x19c
.equ field_258, 0x258  # offset +0x258
.equ field_25c, 0x25c  # offset +0x25c
.equ field_260, 0x260  # offset +0x260
.equ field_264, 0x264  # offset +0x264
.equ field_268, 0x268  # offset +0x268
.equ field_26c, 0x26c  # offset +0x26c
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f88de - 0x401000
.globl FUN_004f88de
FUN_004f88de:
    # block 0x004f88de: entry, 9 instruction(s), ends with je to 0x004f8a0f (forward)
    push ebp                                     # 004f88de
    {load} mov ebp, esp                          # 004f88df
    push ecx                                     # 004f88e1
    mov dword ptr [ebp - local_4], ecx           # 004f88e2
    mov eax, dword ptr [ebp - local_4]           # 004f88e5
    mov dword ptr [eax + field_3ca], 0x0         # 004f88e8
    mov ecx, dword ptr [ebp - local_4]           # 004f88f2
    cmp dword ptr [ecx + field_19c], 0x0         # 004f88f5
    je.d32 L_004f8a0f                            # 004f88fc
    # block 0x004f8902: entered by fall-through of je at 0x004f88fc, 3 instruction(s), ends with je to 0x004f8915 (forward)
    {load} xor edx, edx                          # 004f8902
    test edx, edx                                # 004f8904
    je.d8 L_004f8915                             # 004f8906
    # block 0x004f8908: entered by fall-through of je at 0x004f8906, 2 instruction(s), falls into the block at 0x004f8915
    mov eax, dword ptr [ebp - local_4]           # 004f8908
    mov dword ptr [eax + field_3d2], 0x1         # 004f890b
L_004f8915:
    # block 0x004f8915: entered by je at 0x004f8906, 43 instruction(s), calls indirect dword ptr [eax + 0x34], ends with jne to 0x004f8a0b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f8915
    mov edx, dword ptr [ebp + arg_8]             # 004f8918
    mov dword ptr [ecx + field_258], edx         # 004f891b
    mov eax, dword ptr [ebp - local_4]           # 004f8921
    mov ecx, dword ptr [ebp + arg_c]             # 004f8924
    mov dword ptr [eax + field_25c], ecx         # 004f8927
    mov edx, dword ptr [ebp - local_4]           # 004f892d
    mov eax, dword ptr [ebp + arg_10]            # 004f8930
    mov dword ptr [edx + field_260], eax         # 004f8933
    mov ecx, dword ptr [ebp - local_4]           # 004f8939
    mov edx, dword ptr [ebp + arg_14]            # 004f893c
    mov dword ptr [ecx + field_264], edx         # 004f893f
    mov eax, dword ptr [ebp - local_4]           # 004f8945
    mov ecx, dword ptr [ebp + arg_18]            # 004f8948
    mov dword ptr [eax + field_268], ecx         # 004f894b
    mov edx, dword ptr [ebp - local_4]           # 004f8951
    mov eax, dword ptr [ebp + arg_1c]            # 004f8954
    mov dword ptr [edx + field_26c], eax         # 004f8957
    push 0x0                                     # 004f895d
    mov ecx, dword ptr [ebp + arg_1c]            # 004f895f
    push ecx                                     # 004f8962
    mov edx, dword ptr [ebp + arg_18]            # 004f8963
    push edx                                     # 004f8966
    mov eax, dword ptr [ebp + arg_14]            # 004f8967
    push eax                                     # 004f896a
    mov ecx, dword ptr [ebp + arg_10]            # 004f896b
    push ecx                                     # 004f896e
    mov edx, dword ptr [ebp + arg_c]             # 004f896f
    push edx                                     # 004f8972
    mov eax, dword ptr [ebp + arg_8]             # 004f8973
    push eax                                     # 004f8976
    mov ecx, dword ptr [ebp - local_4]           # 004f8977
    mov edx, dword ptr [ecx + field_19c]         # 004f897a
    mov eax, dword ptr [ebp - local_4]           # 004f8980
    mov ecx, dword ptr [eax + field_19c]         # 004f8983
    mov eax, dword ptr [ecx]                     # 004f8989
    push edx                                     # 004f898b
    call dword ptr [eax + field_34]              # 004f898c
    mov ecx, dword ptr [ebp - local_4]           # 004f898f
    mov dword ptr [ecx + field_3ca], eax         # 004f8992
    mov edx, dword ptr [ebp - local_4]           # 004f8998
    cmp dword ptr [edx + field_3ca], 0x0         # 004f899b
    jne.d8 L_004f8a0b                            # 004f89a2
    # block 0x004f89a4: entered by fall-through of jne at 0x004f89a2, 3 instruction(s), ends with je to 0x004f8a04 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f89a4
    test eax, eax                                # 004f89ab
    je.d8 L_004f8a04                             # 004f89ad
    # block 0x004f89af: entered by fall-through of je at 0x004f89ad, 25 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f8a04
    fld dword ptr [ebp + arg_1c]                 # 004f89af
    sub esp, 0x8                                 # 004f89b2
    fstp qword ptr [esp]                         # 004f89b5
    fld dword ptr [ebp + arg_18]                 # 004f89b8
    sub esp, 0x8                                 # 004f89bb
    fstp qword ptr [esp]                         # 004f89be
    fld dword ptr [ebp + arg_14]                 # 004f89c1
    sub esp, 0x8                                 # 004f89c4
    fstp qword ptr [esp]                         # 004f89c7
    fld dword ptr [ebp + arg_10]                 # 004f89ca
    sub esp, 0x8                                 # 004f89cd
    fstp qword ptr [esp]                         # 004f89d0
    fld dword ptr [ebp + arg_c]                  # 004f89d3
    sub esp, 0x8                                 # 004f89d6
    fstp qword ptr [esp]                         # 004f89d9
    fld dword ptr [ebp + arg_8]                  # 004f89dc
    sub esp, 0x8                                 # 004f89df
    fstp qword ptr [esp]                         # 004f89e2
    push 0x55ef3c                                # 004f89e5
    push 0x63888b                                # 004f89ea
    call FUN_0050ca3e                            # 004f89ef
    add esp, 0x38                                # 004f89f4
    push 0x63888b                                # 004f89f7
    call FUN_0044a2b7                            # 004f89fc
    add esp, 0x4                                 # 004f8a01
L_004f8a04:
    # block 0x004f8a04: entered by je at 0x004f89ad, 2 instruction(s), ends with forward jump to 0x004f8a11
    mov eax, 0x1                                 # 004f8a04
    jmp.d8 L_004f8a11                            # 004f8a09
L_004f8a0b:
    # block 0x004f8a0b: entered by jne at 0x004f89a2, 2 instruction(s), ends with forward jump to 0x004f8a11
    {load} xor eax, eax                          # 004f8a0b
    jmp.d8 L_004f8a11                            # 004f8a0d
L_004f8a0f:
    # block 0x004f8a0f: entered by je at 0x004f88fc, 1 instruction(s), falls into the block at 0x004f8a11
    {load} xor eax, eax                          # 004f8a0f
L_004f8a11:
    # block 0x004f8a11: entered by jmp at 0x004f8a09; jmp at 0x004f8a0d, 3 instruction(s), ends with ret 0x18
    {load} mov esp, ebp                          # 004f8a11
    pop ebp                                      # 004f8a13
    ret 0x18                                     # 004f8a14

