# FUN_00468f68
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468f68
# extent:       0x00468f68-0x00468f9f (55 code bytes)
# span:         0x00468f68-0x00468f9f (code 55, tables 0, padding 0)
# sha256:       df57a3b183d08f9e8adee12f454a32b76a779cb328336218e58d6ede641a3757
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00468f68
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_7c, field_55c; [ecx + n] field_7c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_7c, 0x7c  # offset +0x7c
.equ field_55c, 0x55c  # offset +0x55c

# --- external targets -----------------------------------------------

.org 0x00468f68 - 0x401000
.globl FUN_00468f68
FUN_00468f68:
    # block 0x00468f68: entry, 7 instruction(s), ends with je to 0x00468f9b (forward)
    push ebp                                     # 00468f68
    {load} mov ebp, esp                          # 00468f69
    push ecx                                     # 00468f6b
    mov dword ptr [ebp - local_4], ecx           # 00468f6c
    mov eax, dword ptr [ebp - local_4]           # 00468f6f
    cmp dword ptr [eax + field_55c], 0x0         # 00468f72
    je.d8 L_00468f9b                             # 00468f79
    # block 0x00468f7b: entered by fall-through of je at 0x00468f79, 4 instruction(s), ends with je to 0x00468f9b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00468f7b
    movsx edx, word ptr [ecx + field_7c]         # 00468f7e
    cmp edx, -0x1                                # 00468f82
    je.d8 L_00468f9b                             # 00468f85
    # block 0x00468f87: entered by fall-through of je at 0x00468f85, 4 instruction(s), falls into the block at 0x00468f9b
    mov eax, dword ptr [ebp - local_4]           # 00468f87
    movsx ecx, word ptr [eax + field_7c]         # 00468f8a
    imul ecx, ecx, 0x4a                          # 00468f8e
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00468f91
L_00468f9b:
    # block 0x00468f9b: entered by je at 0x00468f79; je at 0x00468f85, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00468f9b
    pop ebp                                      # 00468f9d
    ret                                          # 00468f9e

