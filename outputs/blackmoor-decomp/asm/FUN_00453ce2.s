# FUN_00453ce2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00453ce2
# extent:       0x00453ce2-0x00453f4f (621 code bytes)
# span:         0x00453ce2-0x00453f4f (code 621, tables 0, padding 0)
# sha256:       2ff7499e5e8c3f399c75419040256dde9af2aec5d683bc42c1c82a9a10a5b041
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00453ce2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_8, field_44, field_48, field_4c, field_50, field_58, field_2a0, field_510, field_6a7, field_6d7, field_6db; [ecx + n] field_48, field_58, field_2a0, field_2a4, field_510, field_6a7, field_6d3, field_6db, field_6df; [edx + n] field_1c, field_20, field_44, field_50, field_54, field_ac, field_2a0, field_6a7, field_6d3, field_6d7, field_6db, field_6df
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004c51a5, FUN_004540bd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 156 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_ac, 0xac  # offset +0xac
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_510, 0x510  # offset +0x510
.equ field_6a7, 0x6a7  # offset +0x6a7
.equ field_6d3, 0x6d3  # offset +0x6d3
.equ field_6d7, 0x6d7  # offset +0x6d7
.equ field_6db, 0x6db  # offset +0x6db
.equ field_6df, 0x6df  # offset +0x6df

# --- external targets -----------------------------------------------
.set FUN_004540bd, .text + (0x004540bd - 0x401000)
.set FUN_004c51a5, .text + (0x004c51a5 - 0x401000)

.org 0x00453ce2 - 0x401000
.globl FUN_00453ce2
FUN_00453ce2:
    # block 0x00453ce2: entry, 7 instruction(s), ends with jne to 0x00453cfc (forward)
    push ebp                                     # 00453ce2
    {load} mov ebp, esp                          # 00453ce3
    sub esp, 0x14                                # 00453ce5
    mov dword ptr [ebp - local_14], ecx          # 00453ce8
    mov eax, dword ptr [ebp - local_14]          # 00453ceb
    cmp dword ptr [eax + field_6a7], 0x0         # 00453cee
    jne.d8 L_00453cfc                            # 00453cf5
    # block 0x00453cf7: entered by fall-through of jne at 0x00453cf5, 1 instruction(s), ends with forward jump to 0x00453f4b
    jmp.d32 L_00453f4b                           # 00453cf7
L_00453cfc:
    # block 0x00453cfc: entered by jne at 0x00453cf5, 3 instruction(s), falls into the block at 0x00453d08
    mov ecx, dword ptr [ebp - local_14]          # 00453cfc
    mov edx, dword ptr [ecx + field_6a7]         # 00453cff
    mov dword ptr [ebp - local_c], edx           # 00453d05
L_00453d08:
    # block 0x00453d08: entered by jmp at 0x00453ec4, 2 instruction(s), ends with je to 0x00453ec9 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 00453d08
    je.d32 L_00453ec9                            # 00453d0c
    # block 0x00453d12: entered by fall-through of je at 0x00453d0c, 13 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x00453ebe (forward)
    mov eax, dword ptr [ebp - local_c]           # 00453d12
    mov ecx, dword ptr [eax + field_8]           # 00453d15
    mov dword ptr [ebp - local_10], ecx          # 00453d18
    mov edx, dword ptr [ebp - local_c]           # 00453d1b
    mov eax, dword ptr [edx]                     # 00453d1e
    mov dword ptr [ebp - local_4], eax           # 00453d20
    call dword ptr [0x52a23c]                    # 00453d23
    mov ecx, dword ptr [ebp - local_4]           # 00453d29
    imul ecx, ecx, 0x5c                          # 00453d2c
    mov edx, dword ptr [ebp - local_14]          # 00453d2f
    mov edx, dword ptr [edx + field_2a0]         # 00453d32
    cmp eax, dword ptr [edx + ecx + field_54]    # 00453d38
    jbe.d32 L_00453ebe                           # 00453d3c
    # block 0x00453d42: entered by fall-through of jbe at 0x00453d3c, 56 instruction(s), calls FUN_004c51a5, ends with je to 0x00453e37 (forward)
    push 0x549d54                                # 00453d42
    mov eax, dword ptr [ebp - local_4]           # 00453d47
    imul eax, eax, 0x5c                          # 00453d4a
    mov ecx, dword ptr [ebp - local_14]          # 00453d4d
    mov edx, dword ptr [ecx + field_2a0]         # 00453d50
    {load} add edx, eax                          # 00453d56
    push edx                                     # 00453d58
    mov eax, dword ptr [ebp - local_4]           # 00453d59
    imul eax, eax, 0x5c                          # 00453d5c
    mov ecx, dword ptr [ebp - local_14]          # 00453d5f
    mov edx, dword ptr [ecx + field_2a0]         # 00453d62
    lea eax, [edx + eax + field_20]              # 00453d68
    push eax                                     # 00453d6c
    mov ecx, dword ptr [ebp - local_14]          # 00453d6d
    mov edx, dword ptr [ecx + field_2a4]         # 00453d70
    push edx                                     # 00453d76
    mov eax, dword ptr [0x5d15e3]                # 00453d77
    push eax                                     # 00453d7c
    mov ecx, 0x5cf659                            # 00453d7d
    call FUN_004c51a5                            # 00453d82
    mov ecx, dword ptr [ebp - local_4]           # 00453d87
    imul ecx, ecx, 0x5c                          # 00453d8a
    mov edx, dword ptr [ebp - local_14]          # 00453d8d
    mov eax, dword ptr [edx + field_2a0]         # 00453d90
    mov dword ptr [eax + ecx + field_58], 0x0    # 00453d96
    mov ecx, dword ptr [ebp - local_4]           # 00453d9e
    imul ecx, ecx, 0x5c                          # 00453da1
    mov edx, dword ptr [ebp - local_14]          # 00453da4
    mov eax, dword ptr [edx + field_2a0]         # 00453da7
    mov edx, dword ptr [ebp - local_14]          # 00453dad
    mov eax, dword ptr [eax + ecx + field_48]    # 00453db0
    mov dword ptr [edx + field_6d3], eax         # 00453db4
    mov ecx, dword ptr [ebp - local_4]           # 00453dba
    imul ecx, ecx, 0x5c                          # 00453dbd
    mov edx, dword ptr [ebp - local_14]          # 00453dc0
    mov eax, dword ptr [edx + field_2a0]         # 00453dc3
    mov edx, dword ptr [ebp - local_14]          # 00453dc9
    mov eax, dword ptr [eax + ecx + field_50]    # 00453dcc
    mov dword ptr [edx + field_6db], eax         # 00453dd0
    mov ecx, dword ptr [ebp - local_4]           # 00453dd6
    imul ecx, ecx, 0x5c                          # 00453dd9
    mov edx, dword ptr [ebp - local_14]          # 00453ddc
    mov eax, dword ptr [edx + field_2a0]         # 00453ddf
    mov edx, dword ptr [ebp - local_14]          # 00453de5
    mov eax, dword ptr [eax + ecx + field_44]    # 00453de8
    mov dword ptr [edx + field_6d7], eax         # 00453dec
    mov ecx, dword ptr [ebp - local_4]           # 00453df2
    imul ecx, ecx, 0x5c                          # 00453df5
    mov edx, dword ptr [ebp - local_14]          # 00453df8
    mov eax, dword ptr [edx + field_2a0]         # 00453dfb
    mov edx, dword ptr [ebp - local_14]          # 00453e01
    mov eax, dword ptr [eax + ecx + field_4c]    # 00453e04
    mov dword ptr [edx + field_6df], eax         # 00453e08
    mov ecx, dword ptr [ebp - local_14]          # 00453e0e
    cmp dword ptr [ecx + field_6d3], -0x1        # 00453e11
    je.d8 L_00453e37                             # 00453e18
    # block 0x00453e1a: entered by fall-through of je at 0x00453e18, 6 instruction(s), falls into the block at 0x00453e37
    mov edx, dword ptr [ebp - local_14]          # 00453e1a
    mov eax, dword ptr [edx + field_6d3]         # 00453e1d
    imul eax, eax, 0x5c                          # 00453e23
    mov ecx, dword ptr [ebp - local_14]          # 00453e26
    mov edx, dword ptr [ecx + field_2a0]         # 00453e29
    mov dword ptr [edx + eax + field_50], 0xffffffff # 00453e2f
L_00453e37:
    # block 0x00453e37: entered by je at 0x00453e18, 3 instruction(s), ends with je to 0x00453e60 (forward)
    mov eax, dword ptr [ebp - local_14]          # 00453e37
    cmp dword ptr [eax + field_6db], -0x1        # 00453e3a
    je.d8 L_00453e60                             # 00453e41
    # block 0x00453e43: entered by fall-through of je at 0x00453e41, 6 instruction(s), falls into the block at 0x00453e60
    mov ecx, dword ptr [ebp - local_14]          # 00453e43
    mov edx, dword ptr [ecx + field_6db]         # 00453e46
    imul edx, edx, 0x5c                          # 00453e4c
    mov eax, dword ptr [ebp - local_14]          # 00453e4f
    mov ecx, dword ptr [eax + field_2a0]         # 00453e52
    mov dword ptr [ecx + edx + field_48], 0xffffffff # 00453e58
L_00453e60:
    # block 0x00453e60: entered by je at 0x00453e41, 3 instruction(s), ends with je to 0x00453e89 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00453e60
    cmp dword ptr [edx + field_6d7], -0x1        # 00453e63
    je.d8 L_00453e89                             # 00453e6a
    # block 0x00453e6c: entered by fall-through of je at 0x00453e6a, 6 instruction(s), falls into the block at 0x00453e89
    mov eax, dword ptr [ebp - local_14]          # 00453e6c
    mov ecx, dword ptr [eax + field_6d7]         # 00453e6f
    imul ecx, ecx, 0x5c                          # 00453e75
    mov edx, dword ptr [ebp - local_14]          # 00453e78
    mov eax, dword ptr [edx + field_2a0]         # 00453e7b
    mov dword ptr [eax + ecx + field_4c], 0xffffffff # 00453e81
L_00453e89:
    # block 0x00453e89: entered by je at 0x00453e6a, 3 instruction(s), ends with je to 0x00453eb2 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00453e89
    cmp dword ptr [ecx + field_6df], -0x1        # 00453e8c
    je.d8 L_00453eb2                             # 00453e93
    # block 0x00453e95: entered by fall-through of je at 0x00453e93, 6 instruction(s), falls into the block at 0x00453eb2
    mov edx, dword ptr [ebp - local_14]          # 00453e95
    mov eax, dword ptr [edx + field_6df]         # 00453e98
    imul eax, eax, 0x5c                          # 00453e9e
    mov ecx, dword ptr [ebp - local_14]          # 00453ea1
    mov edx, dword ptr [ecx + field_2a0]         # 00453ea4
    mov dword ptr [edx + eax + field_44], 0xffffffff # 00453eaa
L_00453eb2:
    # block 0x00453eb2: entered by je at 0x00453e93, 4 instruction(s), calls FUN_004540bd, falls into the block at 0x00453ebe
    mov eax, dword ptr [ebp - local_c]           # 00453eb2
    push eax                                     # 00453eb5
    mov ecx, dword ptr [ebp - local_14]          # 00453eb6
    call FUN_004540bd                            # 00453eb9
L_00453ebe:
    # block 0x00453ebe: entered by jbe at 0x00453d3c, 3 instruction(s), ends with backward jump to 0x00453d08
    mov ecx, dword ptr [ebp - local_10]          # 00453ebe
    mov dword ptr [ebp - local_c], ecx           # 00453ec1
    jmp.d32 L_00453d08                           # 00453ec4
L_00453ec9:
    # block 0x00453ec9: entered by je at 0x00453d0c, 3 instruction(s), ends with jne to 0x00453f4b (forward)
    mov edx, dword ptr [ebp - local_14]          # 00453ec9
    cmp dword ptr [edx + field_6a7], 0x0         # 00453ecc
    jne.d8 L_00453f4b                            # 00453ed3
    # block 0x00453ed5: entered by fall-through of jne at 0x00453ed3, 4 instruction(s), ends with forward jump to 0x00453f00
    mov dword ptr [ebp - local_8], 0x1           # 00453ed5
    mov eax, dword ptr [ebp - local_14]          # 00453edc
    mov dword ptr [eax + field_510], 0x0         # 00453edf
    jmp.d8 L_00453f00                            # 00453ee9
L_00453eeb:
    # block 0x00453eeb: entered by jmp at 0x00453f39, 5 instruction(s), falls into the block at 0x00453f00
    mov ecx, dword ptr [ebp - local_14]          # 00453eeb
    mov edx, dword ptr [ecx + field_510]         # 00453eee
    add edx, 0x1                                 # 00453ef4
    mov eax, dword ptr [ebp - local_14]          # 00453ef7
    mov dword ptr [eax + field_510], edx         # 00453efa
L_00453f00:
    # block 0x00453f00: entered by jmp at 0x00453ee9, 5 instruction(s), ends with jge to 0x00453f3b (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00453f00
    mov edx, dword ptr [ebp - local_14]          # 00453f03
    mov eax, dword ptr [ecx + field_510]         # 00453f06
    cmp eax, dword ptr [edx + field_ac]          # 00453f0c
    jge.d8 L_00453f3b                            # 00453f12
    # block 0x00453f14: entered by fall-through of jge at 0x00453f12, 7 instruction(s), ends with je to 0x00453f39 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00453f14
    mov edx, dword ptr [ecx + field_510]         # 00453f17
    imul edx, edx, 0x5c                          # 00453f1d
    mov eax, dword ptr [ebp - local_14]          # 00453f20
    mov ecx, dword ptr [eax + field_2a0]         # 00453f23
    cmp dword ptr [ecx + edx + field_58], 0x0    # 00453f29
    je.d8 L_00453f39                             # 00453f2e
    # block 0x00453f30: entered by fall-through of je at 0x00453f2e, 2 instruction(s), ends with forward jump to 0x00453f3b
    mov dword ptr [ebp - local_8], 0x0           # 00453f30
    jmp.d8 L_00453f3b                            # 00453f37
L_00453f39:
    # block 0x00453f39: entered by je at 0x00453f2e, 1 instruction(s), ends with backward jump to 0x00453eeb
    jmp.d8 L_00453eeb                            # 00453f39
L_00453f3b:
    # block 0x00453f3b: entered by jge at 0x00453f12; jmp at 0x00453f37, 2 instruction(s), ends with je to 0x00453f4b (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00453f3b
    je.d8 L_00453f4b                             # 00453f3f
    # block 0x00453f41: entered by fall-through of je at 0x00453f3f, 2 instruction(s), falls into the block at 0x00453f4b
    mov edx, dword ptr [ebp - local_14]          # 00453f41
    mov dword ptr [edx + field_1c], 0x1          # 00453f44
L_00453f4b:
    # block 0x00453f4b: entered by jmp at 0x00453cf7; jne at 0x00453ed3; je at 0x00453f3f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00453f4b
    pop ebp                                      # 00453f4d
    ret                                          # 00453f4e

