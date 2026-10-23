# FUN_00490d50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00490d50
# extent:       0x00490d50-0x004911ca (1146 code bytes)
# span:         0x00490d50-0x004911ca (code 1146, tables 0, padding 0)
# sha256:       9f105613fefff37ddfb64c2607b2c87a929621873f43cee7a2a942362e569250
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00490d50
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30
# fields:       [eax + n] field_1c, field_200f, field_2013, field_2039, field_2491, field_2f31, field_3431, field_3ed1, field_50f3; [ecx + n] field_200f, field_2017, field_2035, field_20b5, field_20e5, field_2239, field_22d9, field_242d, field_2491, field_2f31, field_3431, field_3ed1; [edx + n] field_1c, field_2013, field_2017, field_20b5, field_20e5, field_2239, field_22d9, field_242d, field_50f3
# callees:      calls FUN_00491422, FUN_004c2dfb, FUN_0051dc6c, FUN_004d3992, FUN_00490598
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m490547_destroy_with_frame (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 304 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_30, 0x30  # offset -0x30
.equ field_1c, 0x1c  # offset +0x1c
.equ field_200f, 0x200f  # offset +0x200f
.equ field_2013, 0x2013  # offset +0x2013
.equ field_2017, 0x2017  # offset +0x2017
.equ field_2035, 0x2035  # offset +0x2035
.equ field_2039, 0x2039  # offset +0x2039
.equ field_20b5, 0x20b5  # offset +0x20b5
.equ field_20e5, 0x20e5  # offset +0x20e5
.equ field_2239, 0x2239  # offset +0x2239
.equ field_22d9, 0x22d9  # offset +0x22d9
.equ field_242d, 0x242d  # offset +0x242d
.equ field_2491, 0x2491  # offset +0x2491
.equ field_2f31, 0x2f31  # offset +0x2f31
.equ field_3431, 0x3431  # offset +0x3431
.equ field_3ed1, 0x3ed1  # offset +0x3ed1
.equ field_50f3, 0x50f3  # offset +0x50f3

# --- external targets -----------------------------------------------
.set FUN_00490598, .text + (0x00490598 - 0x401000)
.set FUN_00491422, .text + (0x00491422 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00490d50 - 0x401000
.globl FUN_00490d50
FUN_00490d50:
    # block 0x00490d50: entry, 8 instruction(s), calls FUN_00491422, ends with forward jump to 0x00490d73
    push ebp                                     # 00490d50
    {load} mov ebp, esp                          # 00490d51
    sub esp, 0x30                                # 00490d53
    mov dword ptr [ebp - local_30], ecx          # 00490d56
    mov ecx, dword ptr [ebp - local_30]          # 00490d59
    call FUN_00491422                            # 00490d5c
    mov dword ptr [ebp - local_8], 0x0           # 00490d61
    jmp.d8 L_00490d73                            # 00490d68
L_00490d6a:
    # block 0x00490d6a: entered by jmp at 0x00490da1, 3 instruction(s), falls into the block at 0x00490d73
    mov eax, dword ptr [ebp - local_8]           # 00490d6a
    add eax, 0x1                                 # 00490d6d
    mov dword ptr [ebp - local_8], eax           # 00490d70
L_00490d73:
    # block 0x00490d73: entered by jmp at 0x00490d68, 2 instruction(s), ends with jge to 0x00490da3 (forward)
    cmp dword ptr [ebp - local_8], 0x55          # 00490d73
    jge.d8 L_00490da3                            # 00490d77
    # block 0x00490d79: entered by fall-through of jge at 0x00490d77, 4 instruction(s), ends with je to 0x00490da1 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00490d79
    mov edx, dword ptr [ebp - local_30]          # 00490d7c
    cmp dword ptr [edx + 4*ecx + field_20e5], 0x0 # 00490d7f
    je.d8 L_00490da1                             # 00490d87
    # block 0x00490d89: entered by fall-through of je at 0x00490d87, 6 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00490da1
    mov eax, dword ptr [ebp - local_8]           # 00490d89
    mov ecx, dword ptr [ebp - local_30]          # 00490d8c
    lea edx, [ecx + 4*eax + field_20e5]          # 00490d8f
    push edx                                     # 00490d96
    mov ecx, 0x5cf659                            # 00490d97
    call FUN_004c2dfb                            # 00490d9c
L_00490da1:
    # block 0x00490da1: entered by je at 0x00490d87, 1 instruction(s), ends with backward jump to 0x00490d6a
    jmp.d8 L_00490d6a                            # 00490da1
L_00490da3:
    # block 0x00490da3: entered by jge at 0x00490d77, 2 instruction(s), ends with forward jump to 0x00490db5
    mov dword ptr [ebp - local_8], 0x0           # 00490da3
    jmp.d8 L_00490db5                            # 00490daa
L_00490dac:
    # block 0x00490dac: entered by jmp at 0x00490de3, 3 instruction(s), falls into the block at 0x00490db5
    mov eax, dword ptr [ebp - local_8]           # 00490dac
    add eax, 0x1                                 # 00490daf
    mov dword ptr [ebp - local_8], eax           # 00490db2
L_00490db5:
    # block 0x00490db5: entered by jmp at 0x00490daa, 2 instruction(s), ends with jge to 0x00490de5 (forward)
    cmp dword ptr [ebp - local_8], 0x28          # 00490db5
    jge.d8 L_00490de5                            # 00490db9
    # block 0x00490dbb: entered by fall-through of jge at 0x00490db9, 4 instruction(s), ends with je to 0x00490de3 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00490dbb
    mov edx, dword ptr [ebp - local_30]          # 00490dbe
    cmp dword ptr [edx + 4*ecx + field_2239], 0x0 # 00490dc1
    je.d8 L_00490de3                             # 00490dc9
    # block 0x00490dcb: entered by fall-through of je at 0x00490dc9, 6 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00490de3
    mov eax, dword ptr [ebp - local_8]           # 00490dcb
    mov ecx, dword ptr [ebp - local_30]          # 00490dce
    lea edx, [ecx + 4*eax + field_2239]          # 00490dd1
    push edx                                     # 00490dd8
    mov ecx, 0x5cf659                            # 00490dd9
    call FUN_004c2dfb                            # 00490dde
L_00490de3:
    # block 0x00490de3: entered by je at 0x00490dc9, 1 instruction(s), ends with backward jump to 0x00490dac
    jmp.d8 L_00490dac                            # 00490de3
L_00490de5:
    # block 0x00490de5: entered by jge at 0x00490db9, 2 instruction(s), ends with forward jump to 0x00490df7
    mov dword ptr [ebp - local_8], 0x0           # 00490de5
    jmp.d8 L_00490df7                            # 00490dec
L_00490dee:
    # block 0x00490dee: entered by jmp at 0x00490e25, 3 instruction(s), falls into the block at 0x00490df7
    mov eax, dword ptr [ebp - local_8]           # 00490dee
    add eax, 0x1                                 # 00490df1
    mov dword ptr [ebp - local_8], eax           # 00490df4
L_00490df7:
    # block 0x00490df7: entered by jmp at 0x00490dec, 2 instruction(s), ends with jge to 0x00490e27 (forward)
    cmp dword ptr [ebp - local_8], 0x55          # 00490df7
    jge.d8 L_00490e27                            # 00490dfb
    # block 0x00490dfd: entered by fall-through of jge at 0x00490dfb, 4 instruction(s), ends with je to 0x00490e25 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00490dfd
    mov edx, dword ptr [ebp - local_30]          # 00490e00
    cmp dword ptr [edx + 4*ecx + field_22d9], 0x0 # 00490e03
    je.d8 L_00490e25                             # 00490e0b
    # block 0x00490e0d: entered by fall-through of je at 0x00490e0b, 6 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00490e25
    mov eax, dword ptr [ebp - local_8]           # 00490e0d
    mov ecx, dword ptr [ebp - local_30]          # 00490e10
    lea edx, [ecx + 4*eax + field_22d9]          # 00490e13
    push edx                                     # 00490e1a
    mov ecx, 0x5cf659                            # 00490e1b
    call FUN_004c2dfb                            # 00490e20
L_00490e25:
    # block 0x00490e25: entered by je at 0x00490e0b, 1 instruction(s), ends with backward jump to 0x00490dee
    jmp.d8 L_00490dee                            # 00490e25
L_00490e27:
    # block 0x00490e27: entered by jge at 0x00490dfb, 2 instruction(s), ends with forward jump to 0x00490e39
    mov dword ptr [ebp - local_8], 0x0           # 00490e27
    jmp.d8 L_00490e39                            # 00490e2e
L_00490e30:
    # block 0x00490e30: entered by jmp at 0x00490e67, 3 instruction(s), falls into the block at 0x00490e39
    mov eax, dword ptr [ebp - local_8]           # 00490e30
    add eax, 0x1                                 # 00490e33
    mov dword ptr [ebp - local_8], eax           # 00490e36
L_00490e39:
    # block 0x00490e39: entered by jmp at 0x00490e2e, 2 instruction(s), ends with jge to 0x00490e69 (forward)
    cmp dword ptr [ebp - local_8], 0x19          # 00490e39
    jge.d8 L_00490e69                            # 00490e3d
    # block 0x00490e3f: entered by fall-through of jge at 0x00490e3d, 4 instruction(s), ends with je to 0x00490e67 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00490e3f
    mov edx, dword ptr [ebp - local_30]          # 00490e42
    cmp dword ptr [edx + 4*ecx + field_242d], 0x0 # 00490e45
    je.d8 L_00490e67                             # 00490e4d
    # block 0x00490e4f: entered by fall-through of je at 0x00490e4d, 6 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00490e67
    mov eax, dword ptr [ebp - local_8]           # 00490e4f
    mov ecx, dword ptr [ebp - local_30]          # 00490e52
    lea edx, [ecx + 4*eax + field_242d]          # 00490e55
    push edx                                     # 00490e5c
    mov ecx, 0x5cf659                            # 00490e5d
    call FUN_004c2dfb                            # 00490e62
L_00490e67:
    # block 0x00490e67: entered by je at 0x00490e4d, 1 instruction(s), ends with backward jump to 0x00490e30
    jmp.d8 L_00490e30                            # 00490e67
L_00490e69:
    # block 0x00490e69: entered by jge at 0x00490e3d, 2 instruction(s), ends with forward jump to 0x00490e7b
    mov dword ptr [ebp - local_8], 0x1           # 00490e69
    jmp.d8 L_00490e7b                            # 00490e70
L_00490e72:
    # block 0x00490e72: entered by jmp at 0x00491068, 3 instruction(s), falls into the block at 0x00490e7b
    mov eax, dword ptr [ebp - local_8]           # 00490e72
    add eax, 0x1                                 # 00490e75
    mov dword ptr [ebp - local_8], eax           # 00490e78
L_00490e7b:
    # block 0x00490e7b: entered by jmp at 0x00490e70, 2 instruction(s), ends with jge to 0x0049106d (forward)
    cmp dword ptr [ebp - local_8], 0x8           # 00490e7b
    jge.d32 L_0049106d                           # 00490e7f
    # block 0x00490e85: entered by fall-through of jge at 0x00490e7f, 2 instruction(s), ends with forward jump to 0x00490e97
    mov dword ptr [ebp - local_4], 0x0           # 00490e85
    jmp.d8 L_00490e97                            # 00490e8c
L_00490e8e:
    # block 0x00490e8e: entered by jmp at 0x00490efe, 3 instruction(s), falls into the block at 0x00490e97
    mov ecx, dword ptr [ebp - local_4]           # 00490e8e
    add ecx, 0x1                                 # 00490e91
    mov dword ptr [ebp - local_4], ecx           # 00490e94
L_00490e97:
    # block 0x00490e97: entered by jmp at 0x00490e8c, 2 instruction(s), ends with jge to 0x00490f00 (forward)
    cmp dword ptr [ebp - local_4], 0x55          # 00490e97
    jge.d8 L_00490f00                            # 00490e9b
    # block 0x00490e9d: entered by fall-through of jge at 0x00490e9b, 7 instruction(s), ends with je to 0x00490efe (forward)
    mov edx, dword ptr [ebp - local_8]           # 00490e9d
    imul edx, edx, 0x154                         # 00490ea0
    mov eax, dword ptr [ebp - local_30]          # 00490ea6
    lea ecx, [eax + edx + field_2491]            # 00490ea9
    mov edx, dword ptr [ebp - local_4]           # 00490eb0
    cmp dword ptr [ecx + 4*edx], 0x0             # 00490eb3
    je.d8 L_00490efe                             # 00490eb7
    # block 0x00490eb9: entered by fall-through of je at 0x00490eb7, 17 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00490efe
    mov eax, dword ptr [ebp - local_8]           # 00490eb9
    imul eax, eax, 0x154                         # 00490ebc
    mov ecx, dword ptr [ebp - local_30]          # 00490ec2
    lea edx, [ecx + eax + field_2491]            # 00490ec5
    mov eax, dword ptr [ebp - local_4]           # 00490ecc
    mov ecx, dword ptr [edx + 4*eax]             # 00490ecf
    mov dword ptr [ebp - local_c], ecx           # 00490ed2
    mov edx, dword ptr [ebp - local_c]           # 00490ed5
    push edx                                     # 00490ed8
    call FUN_0051dc6c                            # 00490ed9
    add esp, 0x4                                 # 00490ede
    mov eax, dword ptr [ebp - local_8]           # 00490ee1
    imul eax, eax, 0x154                         # 00490ee4
    mov ecx, dword ptr [ebp - local_30]          # 00490eea
    lea edx, [ecx + eax + field_2491]            # 00490eed
    mov eax, dword ptr [ebp - local_4]           # 00490ef4
    mov dword ptr [edx + 4*eax], 0x0             # 00490ef7
L_00490efe:
    # block 0x00490efe: entered by je at 0x00490eb7, 1 instruction(s), ends with backward jump to 0x00490e8e
    jmp.d8 L_00490e8e                            # 00490efe
L_00490f00:
    # block 0x00490f00: entered by jge at 0x00490e9b, 2 instruction(s), ends with forward jump to 0x00490f12
    mov dword ptr [ebp - local_4], 0x0           # 00490f00
    jmp.d8 L_00490f12                            # 00490f07
L_00490f09:
    # block 0x00490f09: entered by jmp at 0x00490f79, 3 instruction(s), falls into the block at 0x00490f12
    mov ecx, dword ptr [ebp - local_4]           # 00490f09
    add ecx, 0x1                                 # 00490f0c
    mov dword ptr [ebp - local_4], ecx           # 00490f0f
L_00490f12:
    # block 0x00490f12: entered by jmp at 0x00490f07, 2 instruction(s), ends with jge to 0x00490f7b (forward)
    cmp dword ptr [ebp - local_4], 0x28          # 00490f12
    jge.d8 L_00490f7b                            # 00490f16
    # block 0x00490f18: entered by fall-through of jge at 0x00490f16, 7 instruction(s), ends with je to 0x00490f79 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00490f18
    imul edx, edx, 0xa0                          # 00490f1b
    mov eax, dword ptr [ebp - local_30]          # 00490f21
    lea ecx, [eax + edx + field_2f31]            # 00490f24
    mov edx, dword ptr [ebp - local_4]           # 00490f2b
    cmp dword ptr [ecx + 4*edx], 0x0             # 00490f2e
    je.d8 L_00490f79                             # 00490f32
    # block 0x00490f34: entered by fall-through of je at 0x00490f32, 17 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00490f79
    mov eax, dword ptr [ebp - local_8]           # 00490f34
    imul eax, eax, 0xa0                          # 00490f37
    mov ecx, dword ptr [ebp - local_30]          # 00490f3d
    lea edx, [ecx + eax + field_2f31]            # 00490f40
    mov eax, dword ptr [ebp - local_4]           # 00490f47
    mov ecx, dword ptr [edx + 4*eax]             # 00490f4a
    mov dword ptr [ebp - local_10], ecx          # 00490f4d
    mov edx, dword ptr [ebp - local_10]          # 00490f50
    push edx                                     # 00490f53
    call FUN_0051dc6c                            # 00490f54
    add esp, 0x4                                 # 00490f59
    mov eax, dword ptr [ebp - local_8]           # 00490f5c
    imul eax, eax, 0xa0                          # 00490f5f
    mov ecx, dword ptr [ebp - local_30]          # 00490f65
    lea edx, [ecx + eax + field_2f31]            # 00490f68
    mov eax, dword ptr [ebp - local_4]           # 00490f6f
    mov dword ptr [edx + 4*eax], 0x0             # 00490f72
L_00490f79:
    # block 0x00490f79: entered by je at 0x00490f32, 1 instruction(s), ends with backward jump to 0x00490f09
    jmp.d8 L_00490f09                            # 00490f79
L_00490f7b:
    # block 0x00490f7b: entered by jge at 0x00490f16, 2 instruction(s), ends with forward jump to 0x00490f8d
    mov dword ptr [ebp - local_4], 0x0           # 00490f7b
    jmp.d8 L_00490f8d                            # 00490f82
L_00490f84:
    # block 0x00490f84: entered by jmp at 0x00490ff4, 3 instruction(s), falls into the block at 0x00490f8d
    mov ecx, dword ptr [ebp - local_4]           # 00490f84
    add ecx, 0x1                                 # 00490f87
    mov dword ptr [ebp - local_4], ecx           # 00490f8a
L_00490f8d:
    # block 0x00490f8d: entered by jmp at 0x00490f82, 2 instruction(s), ends with jge to 0x00490ff6 (forward)
    cmp dword ptr [ebp - local_4], 0x55          # 00490f8d
    jge.d8 L_00490ff6                            # 00490f91
    # block 0x00490f93: entered by fall-through of jge at 0x00490f91, 7 instruction(s), ends with je to 0x00490ff4 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00490f93
    imul edx, edx, 0x154                         # 00490f96
    mov eax, dword ptr [ebp - local_30]          # 00490f9c
    lea ecx, [eax + edx + field_3431]            # 00490f9f
    mov edx, dword ptr [ebp - local_4]           # 00490fa6
    cmp dword ptr [ecx + 4*edx], 0x0             # 00490fa9
    je.d8 L_00490ff4                             # 00490fad
    # block 0x00490faf: entered by fall-through of je at 0x00490fad, 17 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00490ff4
    mov eax, dword ptr [ebp - local_8]           # 00490faf
    imul eax, eax, 0x154                         # 00490fb2
    mov ecx, dword ptr [ebp - local_30]          # 00490fb8
    lea edx, [ecx + eax + field_3431]            # 00490fbb
    mov eax, dword ptr [ebp - local_4]           # 00490fc2
    mov ecx, dword ptr [edx + 4*eax]             # 00490fc5
    mov dword ptr [ebp - local_14], ecx          # 00490fc8
    mov edx, dword ptr [ebp - local_14]          # 00490fcb
    push edx                                     # 00490fce
    call FUN_0051dc6c                            # 00490fcf
    add esp, 0x4                                 # 00490fd4
    mov eax, dword ptr [ebp - local_8]           # 00490fd7
    imul eax, eax, 0x154                         # 00490fda
    mov ecx, dword ptr [ebp - local_30]          # 00490fe0
    lea edx, [ecx + eax + field_3431]            # 00490fe3
    mov eax, dword ptr [ebp - local_4]           # 00490fea
    mov dword ptr [edx + 4*eax], 0x0             # 00490fed
L_00490ff4:
    # block 0x00490ff4: entered by je at 0x00490fad, 1 instruction(s), ends with backward jump to 0x00490f84
    jmp.d8 L_00490f84                            # 00490ff4
L_00490ff6:
    # block 0x00490ff6: entered by jge at 0x00490f91, 2 instruction(s), ends with forward jump to 0x00491008
    mov dword ptr [ebp - local_4], 0x0           # 00490ff6
    jmp.d8 L_00491008                            # 00490ffd
L_00490fff:
    # block 0x00490fff: entered by jmp at 0x00491066, 3 instruction(s), falls into the block at 0x00491008
    mov ecx, dword ptr [ebp - local_4]           # 00490fff
    add ecx, 0x1                                 # 00491002
    mov dword ptr [ebp - local_4], ecx           # 00491005
L_00491008:
    # block 0x00491008: entered by jmp at 0x00490ffd, 2 instruction(s), ends with jge to 0x00491068 (forward)
    cmp dword ptr [ebp - local_4], 0x19          # 00491008
    jge.d8 L_00491068                            # 0049100c
    # block 0x0049100e: entered by fall-through of jge at 0x0049100c, 7 instruction(s), ends with je to 0x00491066 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0049100e
    imul edx, edx, 0x64                          # 00491011
    mov eax, dword ptr [ebp - local_30]          # 00491014
    lea ecx, [eax + edx + field_3ed1]            # 00491017
    mov edx, dword ptr [ebp - local_4]           # 0049101e
    cmp dword ptr [ecx + 4*edx], 0x0             # 00491021
    je.d8 L_00491066                             # 00491025
    # block 0x00491027: entered by fall-through of je at 0x00491025, 17 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00491066
    mov eax, dword ptr [ebp - local_8]           # 00491027
    imul eax, eax, 0x64                          # 0049102a
    mov ecx, dword ptr [ebp - local_30]          # 0049102d
    lea edx, [ecx + eax + field_3ed1]            # 00491030
    mov eax, dword ptr [ebp - local_4]           # 00491037
    mov ecx, dword ptr [edx + 4*eax]             # 0049103a
    mov dword ptr [ebp - local_18], ecx          # 0049103d
    mov edx, dword ptr [ebp - local_18]          # 00491040
    push edx                                     # 00491043
    call FUN_0051dc6c                            # 00491044
    add esp, 0x4                                 # 00491049
    mov eax, dword ptr [ebp - local_8]           # 0049104c
    imul eax, eax, 0x64                          # 0049104f
    mov ecx, dword ptr [ebp - local_30]          # 00491052
    lea edx, [ecx + eax + field_3ed1]            # 00491055
    mov eax, dword ptr [ebp - local_4]           # 0049105c
    mov dword ptr [edx + 4*eax], 0x0             # 0049105f
L_00491066:
    # block 0x00491066: entered by je at 0x00491025, 1 instruction(s), ends with backward jump to 0x00490fff
    jmp.d8 L_00490fff                            # 00491066
L_00491068:
    # block 0x00491068: entered by jge at 0x0049100c, 1 instruction(s), ends with backward jump to 0x00490e72
    jmp.d32 L_00490e72                           # 00491068
L_0049106d:
    # block 0x0049106d: entered by jge at 0x00490e7f, 3 instruction(s), ends with je to 0x0049108d (forward)
    mov ecx, dword ptr [ebp - local_30]          # 0049106d
    cmp dword ptr [ecx + field_2035], 0x0        # 00491070
    je.d8 L_0049108d                             # 00491077
    # block 0x00491079: entered by fall-through of je at 0x00491077, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0049108d
    mov edx, dword ptr [ebp - local_30]          # 00491079
    add edx, 0x2035                              # 0049107c
    push edx                                     # 00491082
    mov ecx, 0x5cf659                            # 00491083
    call FUN_004c2dfb                            # 00491088
L_0049108d:
    # block 0x0049108d: entered by je at 0x00491077, 3 instruction(s), ends with je to 0x004910ad (forward)
    mov eax, dword ptr [ebp - local_30]          # 0049108d
    cmp dword ptr [eax + field_2039], 0x0        # 00491090
    je.d8 L_004910ad                             # 00491097
    # block 0x00491099: entered by fall-through of je at 0x00491097, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004910ad
    mov ecx, dword ptr [ebp - local_30]          # 00491099
    add ecx, 0x2039                              # 0049109c
    push ecx                                     # 004910a2
    mov ecx, 0x5cf659                            # 004910a3
    call FUN_004c2dfb                            # 004910a8
L_004910ad:
    # block 0x004910ad: entered by je at 0x00491097, 3 instruction(s), ends with je to 0x004910de (forward)
    mov edx, dword ptr [ebp - local_30]          # 004910ad
    cmp dword ptr [edx + field_50f3], 0x0        # 004910b0
    je.d8 L_004910de                             # 004910b7
    # block 0x004910b9: entered by fall-through of je at 0x004910b7, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004910de
    mov eax, dword ptr [ebp - local_30]          # 004910b9
    mov ecx, dword ptr [eax + field_50f3]        # 004910bc
    mov dword ptr [ebp - local_1c], ecx          # 004910c2
    mov edx, dword ptr [ebp - local_1c]          # 004910c5
    push edx                                     # 004910c8
    call FUN_0051dc6c                            # 004910c9
    add esp, 0x4                                 # 004910ce
    mov eax, dword ptr [ebp - local_30]          # 004910d1
    mov dword ptr [eax + field_50f3], 0x0        # 004910d4
L_004910de:
    # block 0x004910de: entered by je at 0x004910b7, 3 instruction(s), ends with je to 0x0049110f (forward)
    mov ecx, dword ptr [ebp - local_30]          # 004910de
    cmp dword ptr [ecx + field_20b5], 0x0        # 004910e1
    je.d8 L_0049110f                             # 004910e8
    # block 0x004910ea: entered by fall-through of je at 0x004910e8, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049110f
    mov edx, dword ptr [ebp - local_30]          # 004910ea
    mov eax, dword ptr [edx + field_20b5]        # 004910ed
    mov dword ptr [ebp - local_20], eax          # 004910f3
    mov ecx, dword ptr [ebp - local_20]          # 004910f6
    push ecx                                     # 004910f9
    call FUN_0051dc6c                            # 004910fa
    add esp, 0x4                                 # 004910ff
    mov edx, dword ptr [ebp - local_30]          # 00491102
    mov dword ptr [edx + field_20b5], 0x0        # 00491105
L_0049110f:
    # block 0x0049110f: entered by je at 0x004910e8, 3 instruction(s), ends with je to 0x00491140 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0049110f
    cmp dword ptr [eax + field_200f], 0x0        # 00491112
    je.d8 L_00491140                             # 00491119
    # block 0x0049111b: entered by fall-through of je at 0x00491119, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00491140
    mov ecx, dword ptr [ebp - local_30]          # 0049111b
    mov edx, dword ptr [ecx + field_200f]        # 0049111e
    mov dword ptr [ebp - local_24], edx          # 00491124
    mov eax, dword ptr [ebp - local_24]          # 00491127
    push eax                                     # 0049112a
    call FUN_0051dc6c                            # 0049112b
    add esp, 0x4                                 # 00491130
    mov ecx, dword ptr [ebp - local_30]          # 00491133
    mov dword ptr [ecx + field_200f], 0x0        # 00491136
L_00491140:
    # block 0x00491140: entered by je at 0x00491119, 3 instruction(s), ends with je to 0x00491171 (forward)
    mov edx, dword ptr [ebp - local_30]          # 00491140
    cmp dword ptr [edx + field_2013], 0x0        # 00491143
    je.d8 L_00491171                             # 0049114a
    # block 0x0049114c: entered by fall-through of je at 0x0049114a, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00491171
    mov eax, dword ptr [ebp - local_30]          # 0049114c
    mov ecx, dword ptr [eax + field_2013]        # 0049114f
    mov dword ptr [ebp - local_28], ecx          # 00491155
    mov edx, dword ptr [ebp - local_28]          # 00491158
    push edx                                     # 0049115b
    call FUN_0051dc6c                            # 0049115c
    add esp, 0x4                                 # 00491161
    mov eax, dword ptr [ebp - local_30]          # 00491164
    mov dword ptr [eax + field_2013], 0x0        # 00491167
L_00491171:
    # block 0x00491171: entered by je at 0x0049114a, 3 instruction(s), ends with je to 0x004911a2 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 00491171
    cmp dword ptr [ecx + field_2017], 0x0        # 00491174
    je.d8 L_004911a2                             # 0049117b
    # block 0x0049117d: entered by fall-through of je at 0x0049117b, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004911a2
    mov edx, dword ptr [ebp - local_30]          # 0049117d
    mov eax, dword ptr [edx + field_2017]        # 00491180
    mov dword ptr [ebp - local_2c], eax          # 00491186
    mov ecx, dword ptr [ebp - local_2c]          # 00491189
    push ecx                                     # 0049118c
    call FUN_0051dc6c                            # 0049118d
    add esp, 0x4                                 # 00491192
    mov edx, dword ptr [ebp - local_30]          # 00491195
    mov dword ptr [edx + field_2017], 0x0        # 00491198
L_004911a2:
    # block 0x004911a2: entered by je at 0x0049117b, 4 instruction(s), ends with je to 0x004911be (forward)
    mov eax, dword ptr [ebp - local_30]          # 004911a2
    movsx ecx, word ptr [eax + field_1c]         # 004911a5
    cmp ecx, -0x1                                # 004911a9
    je.d8 L_004911be                             # 004911ac
    # block 0x004911ae: entered by fall-through of je at 0x004911ac, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004911be
    mov edx, dword ptr [ebp - local_30]          # 004911ae
    mov ax, word ptr [edx + field_1c]            # 004911b1
    push eax                                     # 004911b5
    call FUN_004d3992                            # 004911b6
    add esp, 0x4                                 # 004911bb
L_004911be:
    # block 0x004911be: entered by je at 0x004911ac, 5 instruction(s), calls FUN_00490598, ends with ret
    mov ecx, dword ptr [ebp - local_30]          # 004911be
    call FUN_00490598                            # 004911c1
    {load} mov esp, ebp                          # 004911c6
    pop ebp                                      # 004911c8
    ret                                          # 004911c9

