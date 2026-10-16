# FUN_00470ddc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470ddc
# extent:       0x00470ddc-0x00470e31 (85 code bytes)
# span:         0x00470ddc-0x00470e31 (code 85, tables 0, padding 0)
# sha256:       fa8c1414e97e8438e675689b3e9aaf52d6626c28e34358ae2f3daec2a680b4d1
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00470ddc
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_d24; [ecx + n] field_d38; [edx + n] field_d38
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00470d7a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_d24, 0xd24  # offset +0xd24
.equ field_d38, 0xd38  # offset +0xd38

# --- external targets -----------------------------------------------
.set FUN_00470d7a, .text + (0x00470d7a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00470ddc - 0x401000
.globl FUN_00470ddc
FUN_00470ddc:
    # block 0x00470ddc: entry, 7 instruction(s), ends with je to 0x00470e03 (forward)
    push ebp                                     # 00470ddc
    {load} mov ebp, esp                          # 00470ddd
    push ecx                                     # 00470ddf
    mov dword ptr [ebp - local_4], ecx           # 00470de0
    mov eax, dword ptr [ebp - local_4]           # 00470de3
    cmp dword ptr [eax + field_d24], 0x0         # 00470de6
    je.d8 L_00470e03                             # 00470ded
    # block 0x00470def: entered by fall-through of je at 0x00470ded, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00470e03
    mov ecx, dword ptr [ebp - local_4]           # 00470def
    add ecx, 0xd24                               # 00470df2
    push ecx                                     # 00470df8
    mov ecx, 0x5cf659                            # 00470df9
    call FUN_004c2dfb                            # 00470dfe
L_00470e03:
    # block 0x00470e03: entered by je at 0x00470ded, 4 instruction(s), ends with je to 0x00470e25 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00470e03
    movsx eax, word ptr [edx + field_d38]        # 00470e06
    cmp eax, -0x1                                # 00470e0d
    je.d8 L_00470e25                             # 00470e10
    # block 0x00470e12: entered by fall-through of je at 0x00470e10, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00470e25
    mov ecx, dword ptr [ebp - local_4]           # 00470e12
    mov dx, word ptr [ecx + field_d38]           # 00470e15
    push edx                                     # 00470e1c
    call FUN_004d3992                            # 00470e1d
    add esp, 0x4                                 # 00470e22
L_00470e25:
    # block 0x00470e25: entered by je at 0x00470e10, 5 instruction(s), calls FUN_00470d7a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00470e25
    call FUN_00470d7a                            # 00470e28
    {load} mov esp, ebp                          # 00470e2d
    pop ebp                                      # 00470e2f
    ret                                          # 00470e30

