# FUN_004a0ec3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a0ec3
# extent:       0x004a0ec3-0x004a10f1 (558 code bytes)
# span:         0x004a0ec3-0x004a10f1 (code 558, tables 0, padding 0)
# sha256:       6326684831073b53f0099b7c4cc6eb33b028e4a15d484beaea815d4bd0c6dfa3
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raycast_level_exit_writer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a0ec3.c.txt, not original source) refers to the data labelled s_CRayCastLevelBuilder__WriteExitF_005501b0
# name-note:    CRayCastLevelBuilder::WriteExitF...: picks a random valid entry from a 10-entry list (error if none) and writes it into cells marked 1.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_40 and 2 more
# fields:       [eax + n] field_1c, field_a0, field_e3c, field_e44; [ecx + n] field_1c; [edx + n] field_1c, field_20, field_2c, field_e30, field_e44
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 154 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_2c, 0x2c  # offset +0x2c
.equ field_a0, 0xa0  # offset +0xa0
.equ field_e30, 0xe30  # offset +0xe30
.equ field_e3c, 0xe3c  # offset +0xe3c
.equ field_e44, 0xe44  # offset +0xe44

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004a0ec3 - 0x401000
.globl FUN_004a0ec3
FUN_004a0ec3:
    # block 0x004a0ec3: entry, 8 instruction(s), ends with forward jump to 0x004a0eec
    push ebp                                     # 004a0ec3
    {load} mov ebp, esp                          # 004a0ec4
    sub esp, 0x48                                # 004a0ec6
    mov dword ptr [ebp - local_48], ecx          # 004a0ec9
    mov dword ptr [ebp - local_14], 0x0          # 004a0ecc
    mov dword ptr [ebp - local_8], 0x0           # 004a0ed3
    mov dword ptr [ebp - local_10], 0x0          # 004a0eda
    jmp.d8 L_004a0eec                            # 004a0ee1
L_004a0ee3:
    # block 0x004a0ee3: entered by jmp at 0x004a0f1a; jmp at 0x004a0f31, 3 instruction(s), falls into the block at 0x004a0eec
    mov eax, dword ptr [ebp - local_10]          # 004a0ee3
    add eax, 0x1                                 # 004a0ee6
    mov dword ptr [ebp - local_10], eax          # 004a0ee9
L_004a0eec:
    # block 0x004a0eec: entered by jmp at 0x004a0ee1, 2 instruction(s), ends with jge to 0x004a0f33 (forward)
    cmp dword ptr [ebp - local_10], 0xa          # 004a0eec
    jge.d8 L_004a0f33                            # 004a0ef0
    # block 0x004a0ef2: entered by fall-through of jge at 0x004a0ef0, 10 instruction(s), ends with jne to 0x004a0f1c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004a0ef2
    imul ecx, ecx, 0x15e                         # 004a0ef5
    mov edx, dword ptr [ebp - local_48]          # 004a0efb
    lea eax, [edx + ecx + field_2c]              # 004a0efe
    mov ecx, dword ptr [ebp - local_10]          # 004a0f02
    mov dx, word ptr [eax + 2*ecx + field_a0]    # 004a0f05
    mov word ptr [ebp - local_18], dx            # 004a0f0d
    movsx eax, word ptr [ebp - local_18]         # 004a0f11
    cmp eax, -0x1                                # 004a0f15
    jne.d8 L_004a0f1c                            # 004a0f18
    # block 0x004a0f1a: entered by fall-through of jne at 0x004a0f18, 1 instruction(s), ends with backward jump to 0x004a0ee3
    jmp.d8 L_004a0ee3                            # 004a0f1a
L_004a0f1c:
    # block 0x004a0f1c: entered by jne at 0x004a0f18, 7 instruction(s), ends with backward jump to 0x004a0ee3
    mov ecx, dword ptr [ebp - local_8]           # 004a0f1c
    mov dx, word ptr [ebp - local_18]            # 004a0f1f
    mov word ptr [ebp + 2*ecx - local_40], dx    # 004a0f23
    mov eax, dword ptr [ebp - local_8]           # 004a0f28
    add eax, 0x1                                 # 004a0f2b
    mov dword ptr [ebp - local_8], eax           # 004a0f2e
    jmp.d8 L_004a0ee3                            # 004a0f31
L_004a0f33:
    # block 0x004a0f33: entered by jge at 0x004a0ef0, 2 instruction(s), ends with jne to 0x004a0f67 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004a0f33
    jne.d8 L_004a0f67                            # 004a0f37
    # block 0x004a0f39: entered by fall-through of jne at 0x004a0f37, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004a0f67
    mov ecx, dword ptr [ebp + arg_8]             # 004a0f39
    push ecx                                     # 004a0f3c
    push 0x5501b0                                # 004a0f3d
    push 0x63888b                                # 004a0f42
    call FUN_0050ca3e                            # 004a0f47
    add esp, 0xc                                 # 004a0f4c
    push 0x0                                     # 004a0f4f
    push 0x0                                     # 004a0f51
    push 0x63888b                                # 004a0f53
    call FUN_0052139c                            # 004a0f58
    mov ecx, 0x5cf659                            # 004a0f5d
    call FUN_004c97b4                            # 004a0f62
L_004a0f67:
    # block 0x004a0f67: entered by jne at 0x004a0f37, 9 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004a0f91
    call FUN_0050cd50                            # 004a0f67
    cdq                                          # 004a0f6c
    idiv dword ptr [ebp - local_8]               # 004a0f6d
    mov dword ptr [ebp - local_28], edx          # 004a0f70
    mov edx, dword ptr [ebp - local_28]          # 004a0f73
    mov ax, word ptr [ebp + 2*edx - local_40]    # 004a0f76
    mov word ptr [ebp - local_44], ax            # 004a0f7b
    mov dword ptr [ebp - local_20], 0x0          # 004a0f7f
    jmp.d8 L_004a0f91                            # 004a0f86
L_004a0f88:
    # block 0x004a0f88: entered by jmp at 0x004a10e6, 3 instruction(s), falls into the block at 0x004a0f91
    mov ecx, dword ptr [ebp - local_20]          # 004a0f88
    add ecx, 0x1                                 # 004a0f8b
    mov dword ptr [ebp - local_20], ecx          # 004a0f8e
L_004a0f91:
    # block 0x004a0f91: entered by jmp at 0x004a0f86, 4 instruction(s), ends with jge to 0x004a10eb (forward)
    mov edx, dword ptr [ebp - local_48]          # 004a0f91
    mov eax, dword ptr [ebp - local_20]          # 004a0f94
    cmp eax, dword ptr [edx + field_20]          # 004a0f97
    jge.d32 L_004a10eb                           # 004a0f9a
    # block 0x004a0fa0: entered by fall-through of jge at 0x004a0f9a, 2 instruction(s), ends with forward jump to 0x004a0fb2
    mov dword ptr [ebp - local_24], 0x0          # 004a0fa0
    jmp.d8 L_004a0fb2                            # 004a0fa7
L_004a0fa9:
    # block 0x004a0fa9: entered by jmp at 0x004a10e1, 3 instruction(s), falls into the block at 0x004a0fb2
    mov ecx, dword ptr [ebp - local_24]          # 004a0fa9
    add ecx, 0x1                                 # 004a0fac
    mov dword ptr [ebp - local_24], ecx          # 004a0faf
L_004a0fb2:
    # block 0x004a0fb2: entered by jmp at 0x004a0fa7, 4 instruction(s), ends with jge to 0x004a10e6 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004a0fb2
    mov eax, dword ptr [ebp - local_24]          # 004a0fb5
    cmp eax, dword ptr [edx + field_1c]          # 004a0fb8
    jge.d32 L_004a10e6                           # 004a0fbb
    # block 0x004a0fc1: entered by fall-through of jge at 0x004a0fbb, 9 instruction(s), ends with jne to 0x004a10e1 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004a0fc1
    mov edx, dword ptr [ebp - local_20]          # 004a0fc4
    imul edx, dword ptr [ecx + field_1c]         # 004a0fc7
    mov eax, dword ptr [ebp - local_48]          # 004a0fcb
    mov ecx, dword ptr [eax + field_e3c]         # 004a0fce
    lea edx, [ecx + 4*edx]                       # 004a0fd4
    mov eax, dword ptr [ebp - local_24]          # 004a0fd7
    cmp dword ptr [edx + 4*eax], 0x1             # 004a0fda
    jne.d32 L_004a10e1                           # 004a0fde
    # block 0x004a0fe4: entered by fall-through of jne at 0x004a0fde, 70 instruction(s), falls into the block at 0x004a10e1
    mov word ptr [ebp - local_1c], 0x0           # 004a0fe4
    mov ecx, dword ptr [ebp - local_1c]          # 004a0fea
    and ecx, 0xffff                              # 004a0fed
    mov dword ptr [ebp - local_2c], ecx          # 004a0ff3
    mov edx, dword ptr [ebp - local_2c]          # 004a0ff6
    mov dword ptr [ebp - local_4], edx           # 004a0ff9
    mov ax, word ptr [ebp - local_4]             # 004a0ffc
    mov word ptr [ebp - local_c], ax             # 004a1000
    mov ecx, dword ptr [ebp - local_48]          # 004a1004
    mov edx, dword ptr [ebp - local_20]          # 004a1007
    imul edx, dword ptr [ecx + field_1c]         # 004a100a
    mov eax, dword ptr [ebp - local_48]          # 004a100e
    mov ecx, dword ptr [eax + field_e44]         # 004a1011
    lea edx, [ecx + 2*edx]                       # 004a1017
    mov eax, dword ptr [ebp - local_24]          # 004a101a
    mov cx, word ptr [edx + 2*eax]               # 004a101d
    mov word ptr [ebp - local_c], cx             # 004a1021
    mov edx, dword ptr [ebp - local_c]           # 004a1025
    and edx, 0xffff                              # 004a1028
    sar edx, 0x4                                 # 004a102e
    and edx, 0xf                                 # 004a1031
    mov dword ptr [ebp - local_2c], edx          # 004a1034
    mov eax, dword ptr [ebp - local_c]           # 004a1037
    and eax, 0xffff                              # 004a103a
    and eax, 0xf                                 # 004a103f
    mov dword ptr [ebp - local_4], eax           # 004a1042
    mov ecx, dword ptr [ebp - local_c]           # 004a1045
    and ecx, 0xffff                              # 004a1048
    and ecx, 0xf000                              # 004a104e
    mov word ptr [ebp - local_1c], cx            # 004a1054
    mov edx, dword ptr [ebp - local_4]           # 004a1058
    sub edx, 0x2                                 # 004a105b
    mov dword ptr [ebp - local_4], edx           # 004a105e
    {load} xor eax, eax                          # 004a1061
    cmp dword ptr [ebp - local_4], 0x0           # 004a1063
    setle al                                     # 004a1067
    dec eax                                      # 004a106a
    and eax, dword ptr [ebp - local_4]           # 004a106b
    mov dword ptr [ebp - local_4], eax           # 004a106e
    mov ecx, dword ptr [ebp - local_2c]          # 004a1071
    shl ecx, 0x4                                 # 004a1074
    mov dword ptr [ebp - local_2c], ecx          # 004a1077
    mov word ptr [ebp - local_c], 0x0            # 004a107a
    mov edx, dword ptr [ebp - local_1c]          # 004a1080
    and edx, 0xffff                              # 004a1083
    or edx, dword ptr [ebp - local_2c]           # 004a1089
    or edx, dword ptr [ebp - local_4]            # 004a108c
    mov word ptr [ebp - local_c], dx             # 004a108f
    mov eax, dword ptr [ebp - local_48]          # 004a1093
    mov ecx, dword ptr [ebp - local_20]          # 004a1096
    imul ecx, dword ptr [eax + field_1c]         # 004a1099
    mov edx, dword ptr [ebp - local_48]          # 004a109d
    mov eax, dword ptr [edx + field_e44]         # 004a10a0
    lea ecx, [eax + 2*ecx]                       # 004a10a6
    mov edx, dword ptr [ebp - local_24]          # 004a10a9
    mov ax, word ptr [ebp - local_c]             # 004a10ac
    mov word ptr [ecx + 2*edx], ax               # 004a10b0
    movsx ecx, word ptr [ebp - local_44]         # 004a10b4
    add ecx, dword ptr [ebp - local_14]          # 004a10b8
    mov edx, dword ptr [ebp - local_48]          # 004a10bb
    mov eax, dword ptr [ebp - local_20]          # 004a10be
    imul eax, dword ptr [edx + field_1c]         # 004a10c1
    mov edx, dword ptr [ebp - local_48]          # 004a10c5
    mov edx, dword ptr [edx + field_e30]         # 004a10c8
    lea eax, [edx + 2*eax]                       # 004a10ce
    mov edx, dword ptr [ebp - local_24]          # 004a10d1
    mov word ptr [eax + 2*edx], cx               # 004a10d4
    mov eax, dword ptr [ebp - local_14]          # 004a10d8
    add eax, 0x1                                 # 004a10db
    mov dword ptr [ebp - local_14], eax          # 004a10de
L_004a10e1:
    # block 0x004a10e1: entered by jne at 0x004a0fde, 1 instruction(s), ends with backward jump to 0x004a0fa9
    jmp.d32 L_004a0fa9                           # 004a10e1
L_004a10e6:
    # block 0x004a10e6: entered by jge at 0x004a0fbb, 1 instruction(s), ends with backward jump to 0x004a0f88
    jmp.d32 L_004a0f88                           # 004a10e6
L_004a10eb:
    # block 0x004a10eb: entered by jge at 0x004a0f9a, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004a10eb
    pop ebp                                      # 004a10ed
    ret 0x4                                      # 004a10ee

