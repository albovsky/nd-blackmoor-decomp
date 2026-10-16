# FUN_004afd7e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afd7e
# extent:       0x004afd7e-0x004afdc7 (73 code bytes)
# span:         0x004afd7e-0x004afdc7 (code 73, tables 0, padding 0)
# sha256:       cdbf7b0767c95b2274024bac028765c00b5ad2a43ed0c63dc3e8e179918bd246
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004afd7e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004afd3a
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
.set FUN_004afd3a, .text + (0x004afd3a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004afd7e - 0x401000
.globl FUN_004afd7e
FUN_004afd7e:
    # block 0x004afd7e: entry, 7 instruction(s), ends with je to 0x004afd9f (forward)
    push ebp                                     # 004afd7e
    {load} mov ebp, esp                          # 004afd7f
    push ecx                                     # 004afd81
    mov dword ptr [ebp - local_4], ecx           # 004afd82
    mov eax, dword ptr [ebp - local_4]           # 004afd85
    cmp dword ptr [eax + field_20], 0x0          # 004afd88
    je.d8 L_004afd9f                             # 004afd8c
    # block 0x004afd8e: entered by fall-through of je at 0x004afd8c, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004afd9f
    mov ecx, dword ptr [ebp - local_4]           # 004afd8e
    add ecx, 0x20                                # 004afd91
    push ecx                                     # 004afd94
    mov ecx, 0x5cf659                            # 004afd95
    call FUN_004c2dfb                            # 004afd9a
L_004afd9f:
    # block 0x004afd9f: entered by je at 0x004afd8c, 4 instruction(s), ends with je to 0x004afdbb (forward)
    mov edx, dword ptr [ebp - local_4]           # 004afd9f
    movsx eax, word ptr [edx + field_1c]         # 004afda2
    cmp eax, -0x1                                # 004afda6
    je.d8 L_004afdbb                             # 004afda9
    # block 0x004afdab: entered by fall-through of je at 0x004afda9, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004afdbb
    mov ecx, dword ptr [ebp - local_4]           # 004afdab
    mov dx, word ptr [ecx + field_1c]            # 004afdae
    push edx                                     # 004afdb2
    call FUN_004d3992                            # 004afdb3
    add esp, 0x4                                 # 004afdb8
L_004afdbb:
    # block 0x004afdbb: entered by je at 0x004afda9, 5 instruction(s), calls FUN_004afd3a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004afdbb
    call FUN_004afd3a                            # 004afdbe
    {load} mov esp, ebp                          # 004afdc3
    pop ebp                                      # 004afdc5
    ret                                          # 004afdc6

