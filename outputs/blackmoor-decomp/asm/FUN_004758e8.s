# FUN_004758e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004758e8
# extent:       0x004758e8-0x0047591f (55 code bytes)
# span:         0x004758e8-0x0047591f (code 55, tables 0, padding 0)
# sha256:       dedf86ee712181a2589a5596d87a5b1e278b67d5e89fe8df0a8b2ed1648952f1
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004758e8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20, field_89a; [ecx + n] field_20
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_20, 0x20  # offset +0x20
.equ field_89a, 0x89a  # offset +0x89a

# --- external targets -----------------------------------------------

.org 0x004758e8 - 0x401000
.globl FUN_004758e8
FUN_004758e8:
    # block 0x004758e8: entry, 7 instruction(s), ends with je to 0x0047591b (forward)
    push ebp                                     # 004758e8
    {load} mov ebp, esp                          # 004758e9
    push ecx                                     # 004758eb
    mov dword ptr [ebp - local_4], ecx           # 004758ec
    mov eax, dword ptr [ebp - local_4]           # 004758ef
    cmp dword ptr [eax + field_89a], 0x0         # 004758f2
    je.d8 L_0047591b                             # 004758f9
    # block 0x004758fb: entered by fall-through of je at 0x004758f9, 4 instruction(s), ends with je to 0x0047591b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004758fb
    movsx edx, word ptr [ecx + field_20]         # 004758fe
    cmp edx, -0x1                                # 00475902
    je.d8 L_0047591b                             # 00475905
    # block 0x00475907: entered by fall-through of je at 0x00475905, 4 instruction(s), falls into the block at 0x0047591b
    mov eax, dword ptr [ebp - local_4]           # 00475907
    movsx ecx, word ptr [eax + field_20]         # 0047590a
    imul ecx, ecx, 0x4a                          # 0047590e
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00475911
L_0047591b:
    # block 0x0047591b: entered by je at 0x004758f9; je at 0x00475905, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047591b
    pop ebp                                      # 0047591d
    ret                                          # 0047591e

