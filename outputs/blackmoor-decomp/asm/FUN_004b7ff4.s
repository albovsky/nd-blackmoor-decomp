# FUN_004b7ff4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7ff4
# extent:       0x004b7ff4-0x004b8087 (147 code bytes)
# span:         0x004b7ff4-0x004b8087 (code 147, tables 0, padding 0)
# sha256:       7301b469ab96ba207b725f123633e5977a39b903397f6cf07a6ecf46500cbfd7
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b7ff4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c, field_546, field_61e; [ecx + n] field_4, field_546, field_61e; [edx + n] field_4
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004c92c5, FUN_004b7f3b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_546, 0x546  # offset +0x546
.equ field_61e, 0x61e  # offset +0x61e

# --- external targets -----------------------------------------------
.set FUN_004b7f3b, .text + (0x004b7f3b - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004b7ff4 - 0x401000
.globl FUN_004b7ff4
FUN_004b7ff4:
    # block 0x004b7ff4: entry, 7 instruction(s), ends with je to 0x004b8015 (forward)
    push ebp                                     # 004b7ff4
    {load} mov ebp, esp                          # 004b7ff5
    push ecx                                     # 004b7ff7
    mov dword ptr [ebp - local_4], ecx           # 004b7ff8
    mov eax, dword ptr [ebp - local_4]           # 004b7ffb
    cmp dword ptr [eax + field_c], 0x0           # 004b7ffe
    je.d8 L_004b8015                             # 004b8002
    # block 0x004b8004: entered by fall-through of je at 0x004b8002, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004b8015
    mov ecx, dword ptr [ebp - local_4]           # 004b8004
    add ecx, 0xc                                 # 004b8007
    push ecx                                     # 004b800a
    mov ecx, 0x5cf659                            # 004b800b
    call FUN_004c2dfb                            # 004b8010
L_004b8015:
    # block 0x004b8015: entered by je at 0x004b8002, 4 instruction(s), ends with je to 0x004b8031 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b8015
    movsx eax, word ptr [edx + field_4]          # 004b8018
    cmp eax, -0x1                                # 004b801c
    je.d8 L_004b8031                             # 004b801f
    # block 0x004b8021: entered by fall-through of je at 0x004b801f, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004b8031
    mov ecx, dword ptr [ebp - local_4]           # 004b8021
    mov dx, word ptr [ecx + field_4]             # 004b8024
    push edx                                     # 004b8028
    call FUN_004d3992                            # 004b8029
    add esp, 0x4                                 # 004b802e
L_004b8031:
    # block 0x004b8031: entered by je at 0x004b801f, 3 instruction(s), ends with je to 0x004b8050 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b8031
    cmp dword ptr [eax + field_61e], -0x1        # 004b8034
    je.d8 L_004b8050                             # 004b803b
    # block 0x004b803d: entered by fall-through of je at 0x004b803b, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004b8050
    mov ecx, dword ptr [ebp - local_4]           # 004b803d
    mov dx, word ptr [ecx + field_61e]           # 004b8040
    push edx                                     # 004b8047
    call FUN_004d3992                            # 004b8048
    add esp, 0x4                                 # 004b804d
L_004b8050:
    # block 0x004b8050: entered by je at 0x004b803b, 3 instruction(s), ends with je to 0x004b806f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b8050
    cmp dword ptr [eax + field_546], -0x1        # 004b8053
    je.d8 L_004b806f                             # 004b805a
    # block 0x004b805c: entered by fall-through of je at 0x004b805a, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004b806f
    mov ecx, dword ptr [ebp - local_4]           # 004b805c
    mov dx, word ptr [ecx + field_546]           # 004b805f
    push edx                                     # 004b8066
    call FUN_004d3992                            # 004b8067
    add esp, 0x4                                 # 004b806c
L_004b806f:
    # block 0x004b806f: entered by je at 0x004b805a, 8 instruction(s), calls FUN_004c92c5, FUN_004b7f3b, ends with ret
    push 0xa                                     # 004b806f
    mov ecx, 0x5cf659                            # 004b8071
    call FUN_004c92c5                            # 004b8076
    mov ecx, dword ptr [ebp - local_4]           # 004b807b
    call FUN_004b7f3b                            # 004b807e
    {load} mov esp, ebp                          # 004b8083
    pop ebp                                      # 004b8085
    ret                                          # 004b8086

