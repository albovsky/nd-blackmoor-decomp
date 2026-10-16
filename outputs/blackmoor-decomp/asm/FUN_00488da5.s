# FUN_00488da5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00488da5
# extent:       0x00488da5-0x00488e54 (175 code bytes)
# span:         0x00488da5-0x00488e54 (code 175, tables 0, padding 0)
# sha256:       dd44ee8e7d560ae4099773513fbf877693dc9c8179800ac16b738866915dbba2
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00488da5
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_20, field_aa4; [ecx + n] field_1c, field_aa2; [edx + n] field_1c, field_ab2
# callees:      calls FUN_004d3992, FUN_004c946b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_aa2, 0xaa2  # offset +0xaa2
.equ field_aa4, 0xaa4  # offset +0xaa4
.equ field_ab2, 0xab2  # offset +0xab2

# --- external targets -----------------------------------------------
.set FUN_004c946b, .text + (0x004c946b - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00488da5 - 0x401000
.globl FUN_00488da5
FUN_00488da5:
    # block 0x00488da5: entry, 18 instruction(s), ends with je to 0x00488e05 (forward)
    push ebp                                     # 00488da5
    {load} mov ebp, esp                          # 00488da6
    push ecx                                     # 00488da8
    mov dword ptr [ebp - local_4], ecx           # 00488da9
    movsx eax, word ptr [ebp + arg_8]            # 00488dac
    imul eax, eax, 0x8d                          # 00488db0
    mov ecx, dword ptr [ebp - local_4]           # 00488db6
    mov edx, dword ptr [eax + 0x5bb5e5]          # 00488db9
    mov dword ptr [ecx + field_1c], edx          # 00488dbf
    mov eax, dword ptr [ebp - local_4]           # 00488dc2
    mov ecx, dword ptr [ebp - local_4]           # 00488dc5
    mov edx, dword ptr [ecx + field_1c]          # 00488dc8
    mov dword ptr [eax + field_20], edx          # 00488dcb
    mov eax, dword ptr [ebp - local_4]           # 00488dce
    mov ecx, dword ptr [eax + field_1c]          # 00488dd1
    movsx edx, word ptr [ecx + field_aa2]        # 00488dd4
    cmp edx, -0x1                                # 00488ddb
    je.d8 L_00488e05                             # 00488dde
    # block 0x00488de0: entered by fall-through of je at 0x00488dde, 9 instruction(s), calls FUN_004d3992, falls into the block at 0x00488e05
    mov eax, dword ptr [ebp - local_4]           # 00488de0
    mov ecx, dword ptr [eax + field_1c]          # 00488de3
    mov dx, word ptr [ecx + field_aa2]           # 00488de6
    push edx                                     # 00488ded
    call FUN_004d3992                            # 00488dee
    add esp, 0x4                                 # 00488df3
    mov eax, dword ptr [ebp - local_4]           # 00488df6
    mov ecx, dword ptr [eax + field_1c]          # 00488df9
    mov word ptr [ecx + field_aa2], 0xffff       # 00488dfc
L_00488e05:
    # block 0x00488e05: entered by je at 0x00488dde, 5 instruction(s), ends with je to 0x00488e3e (forward)
    mov edx, dword ptr [ebp - local_4]           # 00488e05
    mov eax, dword ptr [edx + field_1c]          # 00488e08
    movsx ecx, word ptr [eax + field_aa4]        # 00488e0b
    cmp ecx, -0x1                                # 00488e12
    je.d8 L_00488e3e                             # 00488e15
    # block 0x00488e17: entered by fall-through of je at 0x00488e15, 9 instruction(s), calls FUN_004c946b, falls into the block at 0x00488e3e
    mov edx, dword ptr [ebp - local_4]           # 00488e17
    mov eax, dword ptr [edx + field_1c]          # 00488e1a
    mov cx, word ptr [eax + field_aa4]           # 00488e1d
    push ecx                                     # 00488e24
    mov ecx, 0x5cf659                            # 00488e25
    call FUN_004c946b                            # 00488e2a
    mov edx, dword ptr [ebp - local_4]           # 00488e2f
    mov eax, dword ptr [edx + field_1c]          # 00488e32
    mov word ptr [eax + field_aa4], 0xffff       # 00488e35
L_00488e3e:
    # block 0x00488e3e: entered by je at 0x00488e15, 6 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - local_4]           # 00488e3e
    mov edx, dword ptr [ecx + field_1c]          # 00488e41
    mov dword ptr [edx + field_ab2], 0x0         # 00488e44
    {load} mov esp, ebp                          # 00488e4e
    pop ebp                                      # 00488e50
    ret 0x4                                      # 00488e51

