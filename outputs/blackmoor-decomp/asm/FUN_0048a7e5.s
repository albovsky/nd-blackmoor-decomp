# FUN_0048a7e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a7e5
# extent:       0x0048a7e5-0x0048a82e (73 code bytes)
# span:         0x0048a7e5-0x0048a82e (code 73, tables 0, padding 0)
# sha256:       086cac9e823575bde139ca5d54e4c9b714a8e70df38ead9dc4e1667b9904c356
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048a7e5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0048a70a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0048a70a, .text + (0x0048a70a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0048a7e5 - 0x401000
.globl FUN_0048a7e5
FUN_0048a7e5:
    # block 0x0048a7e5: entry, 7 instruction(s), ends with je to 0x0048a806 (forward)
    push ebp                                     # 0048a7e5
    {load} mov ebp, esp                          # 0048a7e6
    push ecx                                     # 0048a7e8
    mov dword ptr [ebp - local_4], ecx           # 0048a7e9
    mov eax, dword ptr [ebp - local_4]           # 0048a7ec
    cmp dword ptr [eax + field_20], 0x0          # 0048a7ef
    je.d8 L_0048a806                             # 0048a7f3
    # block 0x0048a7f5: entered by fall-through of je at 0x0048a7f3, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0048a806
    mov ecx, dword ptr [ebp - local_4]           # 0048a7f5
    add ecx, 0x20                                # 0048a7f8
    push ecx                                     # 0048a7fb
    mov ecx, 0x5cf659                            # 0048a7fc
    call FUN_004c2dfb                            # 0048a801
L_0048a806:
    # block 0x0048a806: entered by je at 0x0048a7f3, 4 instruction(s), ends with je to 0x0048a822 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048a806
    movsx eax, word ptr [edx + field_1c]         # 0048a809
    cmp eax, -0x1                                # 0048a80d
    je.d8 L_0048a822                             # 0048a810
    # block 0x0048a812: entered by fall-through of je at 0x0048a810, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0048a822
    mov ecx, dword ptr [ebp - local_4]           # 0048a812
    mov dx, word ptr [ecx + field_1c]            # 0048a815
    push edx                                     # 0048a819
    call FUN_004d3992                            # 0048a81a
    add esp, 0x4                                 # 0048a81f
L_0048a822:
    # block 0x0048a822: entered by je at 0x0048a810, 5 instruction(s), calls FUN_0048a70a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0048a822
    call FUN_0048a70a                            # 0048a825
    {load} mov esp, ebp                          # 0048a82a
    pop ebp                                      # 0048a82c
    ret                                          # 0048a82d

