# FUN_004a63dc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a63dc
# extent:       0x004a63dc-0x004a6477 (155 code bytes)
# span:         0x004a63dc-0x004a6477 (code 155, tables 0, padding 0)
# sha256:       25bacba0739929f1e209b906b87a4cdf1b0f4a2391f765efbeca1b0a44161357
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a63dc_lifted
# naming:       native port src/original_methods_fl39d.c:m4a63dc_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (39 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_34; [ecx + n] field_38, field_3c; [edx + n] field_1c, field_38, field_3c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004a638a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4a63dc_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 48 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------
.set FUN_004a638a, .text + (0x004a638a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004a63dc - 0x401000
.globl FUN_004a63dc
FUN_004a63dc:
    # block 0x004a63dc: entry, 7 instruction(s), ends with je to 0x004a63fd (forward)
    push ebp                                     # 004a63dc
    {load} mov ebp, esp                          # 004a63dd
    push ecx                                     # 004a63df
    mov dword ptr [ebp - local_4], ecx           # 004a63e0
    mov eax, dword ptr [ebp - local_4]           # 004a63e3
    cmp dword ptr [eax + field_34], 0x0          # 004a63e6
    je.d8 L_004a63fd                             # 004a63ea
    # block 0x004a63ec: entered by fall-through of je at 0x004a63ea, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004a63fd
    mov ecx, dword ptr [ebp - local_4]           # 004a63ec
    add ecx, 0x34                                # 004a63ef
    push ecx                                     # 004a63f2
    mov ecx, 0x5cf659                            # 004a63f3
    call FUN_004c2dfb                            # 004a63f8
L_004a63fd:
    # block 0x004a63fd: entered by je at 0x004a63ea, 3 instruction(s), ends with je to 0x004a6417 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a63fd
    cmp dword ptr [edx + field_38], 0x0          # 004a6400
    je.d8 L_004a6417                             # 004a6404
    # block 0x004a6406: entered by fall-through of je at 0x004a6404, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004a6417
    mov eax, dword ptr [ebp - local_4]           # 004a6406
    add eax, 0x38                                # 004a6409
    push eax                                     # 004a640c
    mov ecx, 0x5cf659                            # 004a640d
    call FUN_004c2dfb                            # 004a6412
L_004a6417:
    # block 0x004a6417: entered by je at 0x004a6404, 3 instruction(s), ends with je to 0x004a6431 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a6417
    cmp dword ptr [ecx + field_3c], 0x0          # 004a641a
    je.d8 L_004a6431                             # 004a641e
    # block 0x004a6420: entered by fall-through of je at 0x004a641e, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004a6431
    mov edx, dword ptr [ebp - local_4]           # 004a6420
    add edx, 0x3c                                # 004a6423
    push edx                                     # 004a6426
    mov ecx, 0x5cf659                            # 004a6427
    call FUN_004c2dfb                            # 004a642c
L_004a6431:
    # block 0x004a6431: entered by je at 0x004a641e, 10 instruction(s), ends with je to 0x004a646b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a6431
    mov dword ptr [eax + field_34], 0x0          # 004a6434
    mov ecx, dword ptr [ebp - local_4]           # 004a643b
    mov dword ptr [ecx + field_38], 0x0          # 004a643e
    mov edx, dword ptr [ebp - local_4]           # 004a6445
    mov dword ptr [edx + field_3c], 0x0          # 004a6448
    mov eax, dword ptr [ebp - local_4]           # 004a644f
    movsx ecx, word ptr [eax + field_1c]         # 004a6452
    cmp ecx, -0x1                                # 004a6456
    je.d8 L_004a646b                             # 004a6459
    # block 0x004a645b: entered by fall-through of je at 0x004a6459, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004a646b
    mov edx, dword ptr [ebp - local_4]           # 004a645b
    mov ax, word ptr [edx + field_1c]            # 004a645e
    push eax                                     # 004a6462
    call FUN_004d3992                            # 004a6463
    add esp, 0x4                                 # 004a6468
L_004a646b:
    # block 0x004a646b: entered by je at 0x004a6459, 5 instruction(s), calls FUN_004a638a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004a646b
    call FUN_004a638a                            # 004a646e
    {load} mov esp, ebp                          # 004a6473
    pop ebp                                      # 004a6475
    ret                                          # 004a6476

