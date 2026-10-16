# FUN_0044e7d7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e7d7
# extent:       0x0044e7d7-0x0044e80b (52 code bytes)
# span:         0x0044e7d7-0x0044e80b (code 52, tables 0, padding 0)
# sha256:       6b5a2bf2dfb8c036502aef5af96325116fa3cf63e1415579be25bd228345c96d
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044e7d7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_6b; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_6b, 0x6b  # offset +0x6b

# --- external targets -----------------------------------------------

.org 0x0044e7d7 - 0x401000
.globl FUN_0044e7d7
FUN_0044e7d7:
    # block 0x0044e7d7: entry, 7 instruction(s), ends with je to 0x0044e807 (forward)
    push ebp                                     # 0044e7d7
    {load} mov ebp, esp                          # 0044e7d8
    push ecx                                     # 0044e7da
    mov dword ptr [ebp - local_4], ecx           # 0044e7db
    mov eax, dword ptr [ebp - local_4]           # 0044e7de
    cmp dword ptr [eax + field_6b], 0x0          # 0044e7e1
    je.d8 L_0044e807                             # 0044e7e5
    # block 0x0044e7e7: entered by fall-through of je at 0x0044e7e5, 4 instruction(s), ends with je to 0x0044e807 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044e7e7
    movsx edx, word ptr [ecx + field_1c]         # 0044e7ea
    cmp edx, -0x1                                # 0044e7ee
    je.d8 L_0044e807                             # 0044e7f1
    # block 0x0044e7f3: entered by fall-through of je at 0x0044e7f1, 4 instruction(s), falls into the block at 0x0044e807
    mov eax, dword ptr [ebp - local_4]           # 0044e7f3
    movsx ecx, word ptr [eax + field_1c]         # 0044e7f6
    imul ecx, ecx, 0x4a                          # 0044e7fa
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0044e7fd
L_0044e807:
    # block 0x0044e807: entered by je at 0x0044e7e5; je at 0x0044e7f1, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044e807
    pop ebp                                      # 0044e809
    ret                                          # 0044e80a

