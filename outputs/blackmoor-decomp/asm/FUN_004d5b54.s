# FUN_004d5b54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5b54
# extent:       0x004d5b54-0x004d5c54 (256 code bytes)
# span:         0x004d5b54-0x004d5c54 (code 256, tables 0, padding 0)
# sha256:       b284b4b806d0f6841092b7725427600a6bdf8480f34424cc7ac8803f24907353
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d5b54
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_94d6, field_94e2, field_950a, field_98a8; [ecx + n] field_94de, field_98a8; [edx + n] field_94da, field_98a8
# callees:      calls FUN_004c2dfb, FUN_004d8f0a, FUN_004d58eb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 67 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_94d6, 0x94d6  # offset +0x94d6
.equ field_94da, 0x94da  # offset +0x94da
.equ field_94de, 0x94de  # offset +0x94de
.equ field_94e2, 0x94e2  # offset +0x94e2
.equ field_950a, 0x950a  # offset +0x950a
.equ field_98a8, 0x98a8  # offset +0x98a8

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d58eb, .text + (0x004d58eb - 0x401000)
.set FUN_004d8f0a, .text + (0x004d8f0a - 0x401000)

.org 0x004d5b54 - 0x401000
.globl FUN_004d5b54
FUN_004d5b54:
    # block 0x004d5b54: entry, 7 instruction(s), ends with je to 0x004d5b7b (forward)
    push ebp                                     # 004d5b54
    {load} mov ebp, esp                          # 004d5b55
    push ecx                                     # 004d5b57
    mov dword ptr [ebp - local_4], ecx           # 004d5b58
    mov eax, dword ptr [ebp - local_4]           # 004d5b5b
    cmp dword ptr [eax + field_94d6], 0x0        # 004d5b5e
    je.d8 L_004d5b7b                             # 004d5b65
    # block 0x004d5b67: entered by fall-through of je at 0x004d5b65, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004d5b7b
    mov ecx, dword ptr [ebp - local_4]           # 004d5b67
    add ecx, 0x94d6                              # 004d5b6a
    push ecx                                     # 004d5b70
    mov ecx, 0x5cf659                            # 004d5b71
    call FUN_004c2dfb                            # 004d5b76
L_004d5b7b:
    # block 0x004d5b7b: entered by je at 0x004d5b65, 3 instruction(s), ends with je to 0x004d5b9a (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d5b7b
    cmp dword ptr [edx + field_94da], 0x0        # 004d5b7e
    je.d8 L_004d5b9a                             # 004d5b85
    # block 0x004d5b87: entered by fall-through of je at 0x004d5b85, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004d5b9a
    mov eax, dword ptr [ebp - local_4]           # 004d5b87
    add eax, 0x94da                              # 004d5b8a
    push eax                                     # 004d5b8f
    mov ecx, 0x5cf659                            # 004d5b90
    call FUN_004c2dfb                            # 004d5b95
L_004d5b9a:
    # block 0x004d5b9a: entered by je at 0x004d5b85, 3 instruction(s), ends with je to 0x004d5bba (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d5b9a
    cmp dword ptr [ecx + field_94de], 0x0        # 004d5b9d
    je.d8 L_004d5bba                             # 004d5ba4
    # block 0x004d5ba6: entered by fall-through of je at 0x004d5ba4, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004d5bba
    mov edx, dword ptr [ebp - local_4]           # 004d5ba6
    add edx, 0x94de                              # 004d5ba9
    push edx                                     # 004d5baf
    mov ecx, 0x5cf659                            # 004d5bb0
    call FUN_004c2dfb                            # 004d5bb5
L_004d5bba:
    # block 0x004d5bba: entered by je at 0x004d5ba4, 3 instruction(s), ends with je to 0x004d5bda (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d5bba
    cmp dword ptr [eax + field_950a], 0x0        # 004d5bbd
    je.d8 L_004d5bda                             # 004d5bc4
    # block 0x004d5bc6: entered by fall-through of je at 0x004d5bc4, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004d5bda
    mov ecx, dword ptr [ebp - local_4]           # 004d5bc6
    add ecx, 0x950a                              # 004d5bc9
    push ecx                                     # 004d5bcf
    mov ecx, 0x5cf659                            # 004d5bd0
    call FUN_004c2dfb                            # 004d5bd5
L_004d5bda:
    # block 0x004d5bda: entered by je at 0x004d5bc4, 3 instruction(s), ends with forward jump to 0x004d5bfe
    mov edx, dword ptr [ebp - local_4]           # 004d5bda
    mov dword ptr [edx + field_98a8], 0x0        # 004d5bdd
    jmp.d8 L_004d5bfe                            # 004d5be7
L_004d5be9:
    # block 0x004d5be9: entered by jmp at 0x004d5c3e, 5 instruction(s), falls into the block at 0x004d5bfe
    mov eax, dword ptr [ebp - local_4]           # 004d5be9
    mov ecx, dword ptr [eax + field_98a8]        # 004d5bec
    add ecx, 0x1                                 # 004d5bf2
    mov edx, dword ptr [ebp - local_4]           # 004d5bf5
    mov dword ptr [edx + field_98a8], ecx        # 004d5bf8
L_004d5bfe:
    # block 0x004d5bfe: entered by jmp at 0x004d5be7, 3 instruction(s), ends with jge to 0x004d5c40 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d5bfe
    cmp dword ptr [eax + field_98a8], 0xa        # 004d5c01
    jge.d8 L_004d5c40                            # 004d5c08
    # block 0x004d5c0a: entered by fall-through of jge at 0x004d5c08, 5 instruction(s), ends with je to 0x004d5c3e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d5c0a
    mov edx, dword ptr [ecx + field_98a8]        # 004d5c0d
    mov eax, dword ptr [ebp - local_4]           # 004d5c13
    cmp dword ptr [eax + 4*edx + field_94e2], 0x0 # 004d5c16
    je.d8 L_004d5c3e                             # 004d5c1e
    # block 0x004d5c20: entered by fall-through of je at 0x004d5c1e, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004d5c3e
    mov ecx, dword ptr [ebp - local_4]           # 004d5c20
    mov edx, dword ptr [ecx + field_98a8]        # 004d5c23
    mov eax, dword ptr [ebp - local_4]           # 004d5c29
    lea ecx, [eax + 4*edx + field_94e2]          # 004d5c2c
    push ecx                                     # 004d5c33
    mov ecx, 0x5cf659                            # 004d5c34
    call FUN_004c2dfb                            # 004d5c39
L_004d5c3e:
    # block 0x004d5c3e: entered by je at 0x004d5c1e, 1 instruction(s), ends with backward jump to 0x004d5be9
    jmp.d8 L_004d5be9                            # 004d5c3e
L_004d5c40:
    # block 0x004d5c40: entered by jge at 0x004d5c08, 7 instruction(s), calls FUN_004d8f0a, FUN_004d58eb, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004d5c40
    call FUN_004d8f0a                            # 004d5c43
    mov ecx, dword ptr [ebp - local_4]           # 004d5c48
    call FUN_004d58eb                            # 004d5c4b
    {load} mov esp, ebp                          # 004d5c50
    pop ebp                                      # 004d5c52
    ret                                          # 004d5c53

