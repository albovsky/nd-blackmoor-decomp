# FUN_0047d59b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d59b
# extent:       0x0047d59b-0x0047d640 (165 code bytes)
# span:         0x0047d59b-0x0047d640 (code 165, tables 0, padding 0)
# sha256:       69064fa7ea2d8f7db908498d2b9c653602941b79fa2e06cc62d1a968dafe287b
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47d59b_release_fields
# naming:       native port src/original_methods_fl31b.c:m47d59b_release_fields (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Frees the fields through 0x4c2dfb, 0x51dc6c x3 and 0x4d3992 (word != -1) and calls 0x47d4f7; 56/56 instructions, 10/10 jump directions. See tasks/fl31b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1f, field_49, field_4d; [ecx + n] field_23, field_4d, field_51; [edx + n] field_23, field_49, field_51
# callees:      calls FUN_004c2dfb, FUN_0051dc6c, FUN_004d3992, FUN_0047d4f7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31b.c:m47d59b_release_fields (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 56 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1f, 0x1f  # offset +0x1f
.equ field_23, 0x23  # offset +0x23
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_51, 0x51  # offset +0x51

# --- external targets -----------------------------------------------
.set FUN_0047d4f7, .text + (0x0047d4f7 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0047d59b - 0x401000
.globl FUN_0047d59b
FUN_0047d59b:
    # block 0x0047d59b: entry, 7 instruction(s), ends with je to 0x0047d5be (forward)
    push ebp                                     # 0047d59b
    {load} mov ebp, esp                          # 0047d59c
    sub esp, 0x10                                # 0047d59e
    mov dword ptr [ebp - local_10], ecx          # 0047d5a1
    mov eax, dword ptr [ebp - local_10]          # 0047d5a4
    cmp dword ptr [eax + field_1f], 0x0          # 0047d5a7
    je.d8 L_0047d5be                             # 0047d5ab
    # block 0x0047d5ad: entered by fall-through of je at 0x0047d5ab, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0047d5be
    mov ecx, dword ptr [ebp - local_10]          # 0047d5ad
    add ecx, 0x1f                                # 0047d5b0
    push ecx                                     # 0047d5b3
    mov ecx, 0x5cf659                            # 0047d5b4
    call FUN_004c2dfb                            # 0047d5b9
L_0047d5be:
    # block 0x0047d5be: entered by je at 0x0047d5ab, 3 instruction(s), ends with je to 0x0047d5dc (forward)
    mov edx, dword ptr [ebp - local_10]          # 0047d5be
    cmp dword ptr [edx + field_49], 0x0          # 0047d5c1
    je.d8 L_0047d5dc                             # 0047d5c5
    # block 0x0047d5c7: entered by fall-through of je at 0x0047d5c5, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047d5dc
    mov eax, dword ptr [ebp - local_10]          # 0047d5c7
    mov ecx, dword ptr [eax + field_49]          # 0047d5ca
    mov dword ptr [ebp - local_4], ecx           # 0047d5cd
    mov edx, dword ptr [ebp - local_4]           # 0047d5d0
    push edx                                     # 0047d5d3
    call FUN_0051dc6c                            # 0047d5d4
    add esp, 0x4                                 # 0047d5d9
L_0047d5dc:
    # block 0x0047d5dc: entered by je at 0x0047d5c5, 3 instruction(s), ends with je to 0x0047d5fa (forward)
    mov eax, dword ptr [ebp - local_10]          # 0047d5dc
    cmp dword ptr [eax + field_4d], 0x0          # 0047d5df
    je.d8 L_0047d5fa                             # 0047d5e3
    # block 0x0047d5e5: entered by fall-through of je at 0x0047d5e3, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047d5fa
    mov ecx, dword ptr [ebp - local_10]          # 0047d5e5
    mov edx, dword ptr [ecx + field_4d]          # 0047d5e8
    mov dword ptr [ebp - local_8], edx           # 0047d5eb
    mov eax, dword ptr [ebp - local_8]           # 0047d5ee
    push eax                                     # 0047d5f1
    call FUN_0051dc6c                            # 0047d5f2
    add esp, 0x4                                 # 0047d5f7
L_0047d5fa:
    # block 0x0047d5fa: entered by je at 0x0047d5e3, 3 instruction(s), ends with je to 0x0047d618 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0047d5fa
    cmp dword ptr [ecx + field_51], 0x0          # 0047d5fd
    je.d8 L_0047d618                             # 0047d601
    # block 0x0047d603: entered by fall-through of je at 0x0047d601, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047d618
    mov edx, dword ptr [ebp - local_10]          # 0047d603
    mov eax, dword ptr [edx + field_51]          # 0047d606
    mov dword ptr [ebp - local_c], eax           # 0047d609
    mov ecx, dword ptr [ebp - local_c]           # 0047d60c
    push ecx                                     # 0047d60f
    call FUN_0051dc6c                            # 0047d610
    add esp, 0x4                                 # 0047d615
L_0047d618:
    # block 0x0047d618: entered by je at 0x0047d601, 4 instruction(s), ends with je to 0x0047d634 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0047d618
    movsx eax, word ptr [edx + field_23]         # 0047d61b
    cmp eax, -0x1                                # 0047d61f
    je.d8 L_0047d634                             # 0047d622
    # block 0x0047d624: entered by fall-through of je at 0x0047d622, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0047d634
    mov ecx, dword ptr [ebp - local_10]          # 0047d624
    mov dx, word ptr [ecx + field_23]            # 0047d627
    push edx                                     # 0047d62b
    call FUN_004d3992                            # 0047d62c
    add esp, 0x4                                 # 0047d631
L_0047d634:
    # block 0x0047d634: entered by je at 0x0047d622, 5 instruction(s), calls FUN_0047d4f7, ends with ret
    mov ecx, dword ptr [ebp - local_10]          # 0047d634
    call FUN_0047d4f7                            # 0047d637
    {load} mov esp, ebp                          # 0047d63c
    pop ebp                                      # 0047d63e
    ret                                          # 0047d63f

