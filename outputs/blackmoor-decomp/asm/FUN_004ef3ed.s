# FUN_004ef3ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ef3ed
# extent:       0x004ef3ed-0x004ef4c9 (220 code bytes)
# span:         0x004ef3ed-0x004ef4c9 (code 220, tables 0, padding 0)
# sha256:       6d2d2887aa2e67da822ce4b3c2c99fd81be60ba2afdde00368a9c7464b97bba0
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ef3ed_lifted
# naming:       native port src/original_methods_fl39d.c:m4ef3ed_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (455 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_10, field_19a; [ecx + n] field_10, field_ca; [edx + n] field_10, field_c2
# callees:      calls FUN_004d5316
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4ef3ed_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 54 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_c2, 0xc2  # offset +0xc2
.equ field_ca, 0xca  # offset +0xca
.equ field_19a, 0x19a  # offset +0x19a

# --- external targets -----------------------------------------------
.set FUN_004d5316, .text + (0x004d5316 - 0x401000)

.org 0x004ef3ed - 0x401000
.globl FUN_004ef3ed
FUN_004ef3ed:
    # block 0x004ef3ed: entry, 9 instruction(s), ends with je to 0x004ef420 (forward)
    push ebp                                     # 004ef3ed
    {load} mov ebp, esp                          # 004ef3ee
    push ecx                                     # 004ef3f0
    mov dword ptr [ebp - local_4], ecx           # 004ef3f1
    mov eax, dword ptr [ebp - local_4]           # 004ef3f4
    mov dword ptr [eax + field_19a], 0x0         # 004ef3f7
    mov ecx, dword ptr [ebp - local_4]           # 004ef401
    cmp dword ptr [ecx + field_10], 0x0          # 004ef404
    je.d8 L_004ef420                             # 004ef408
    # block 0x004ef40a: entered by fall-through of je at 0x004ef408, 3 instruction(s), ends with je to 0x004ef420 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ef40a
    cmp dword ptr [edx + field_10], 0x1          # 004ef40d
    je.d8 L_004ef420                             # 004ef411
    # block 0x004ef413: entered by fall-through of je at 0x004ef411, 3 instruction(s), ends with jne to 0x004ef4c1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ef413
    cmp dword ptr [eax + field_10], 0x2          # 004ef416
    jne.d32 L_004ef4c1                           # 004ef41a
L_004ef420:
    # block 0x004ef420: entered by je at 0x004ef408; je at 0x004ef411; fall-through of jne at 0x004ef41a, 9 instruction(s), calls FUN_004d5316, ends with je to 0x004ef4b7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef420
    add ecx, 0x13e                               # 004ef423
    push ecx                                     # 004ef429
    mov edx, dword ptr [ebp + arg_8]             # 004ef42a
    push edx                                     # 004ef42d
    mov ecx, 0x570450                            # 004ef42e
    call FUN_004d5316                            # 004ef433
    test eax, eax                                # 004ef438
    je.d8 L_004ef4b7                             # 004ef43a
    # block 0x004ef43c: entered by fall-through of je at 0x004ef43a, 5 instruction(s), ends with jne to 0x004ef468 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ef43c
    mov dword ptr [eax + field_19a], 0x1         # 004ef43f
    mov ecx, dword ptr [ebp - local_4]           # 004ef449
    cmp dword ptr [ecx + field_10], 0x0          # 004ef44c
    jne.d8 L_004ef468                            # 004ef450
    # block 0x004ef452: entered by fall-through of jne at 0x004ef450, 3 instruction(s), ends with je to 0x004ef468 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ef452
    cmp dword ptr [edx + field_c2], 0x0          # 004ef455
    je.d8 L_004ef468                             # 004ef45c
    # block 0x004ef45e: entered by fall-through of je at 0x004ef45c, 2 instruction(s), falls into the block at 0x004ef468
    mov eax, dword ptr [ebp - local_4]           # 004ef45e
    mov dword ptr [eax + field_10], 0x1          # 004ef461
L_004ef468:
    # block 0x004ef468: entered by jne at 0x004ef450; je at 0x004ef45c, 3 instruction(s), ends with je to 0x004ef4b0 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef468
    cmp dword ptr [ecx + field_ca], 0x0          # 004ef46b
    je.d8 L_004ef4b0                             # 004ef472
    # block 0x004ef474: entered by fall-through of je at 0x004ef472, 9 instruction(s), falls into the block at 0x004ef4b0
    mov dword ptr [0x5c39e5], 0x27d9             # 004ef474
    mov dword ptr [0x5b44f4], 0x1                # 004ef47e
    mov edx, dword ptr [0x5b44f0]                # 004ef488
    shl edx, 0x5                                 # 004ef48e
    mov eax, dword ptr [0x5b44f4]                # 004ef491
    shl eax, 0x4                                 # 004ef496
    lea ecx, [edx + eax + 0x5b160c]              # 004ef499
    mov dword ptr [0x5d1631], ecx                # 004ef4a0
    mov dword ptr [0x5d1639], 0x1                # 004ef4a6
L_004ef4b0:
    # block 0x004ef4b0: entered by je at 0x004ef472, 2 instruction(s), ends with forward jump to 0x004ef4c3
    mov eax, 0x1                                 # 004ef4b0
    jmp.d8 L_004ef4c3                            # 004ef4b5
L_004ef4b7:
    # block 0x004ef4b7: entered by je at 0x004ef43a, 2 instruction(s), falls into the block at 0x004ef4c1
    mov edx, dword ptr [ebp - local_4]           # 004ef4b7
    mov dword ptr [edx + field_10], 0x0          # 004ef4ba
L_004ef4c1:
    # block 0x004ef4c1: entered by jne at 0x004ef41a, 1 instruction(s), falls into the block at 0x004ef4c3
    {load} xor eax, eax                          # 004ef4c1
L_004ef4c3:
    # block 0x004ef4c3: entered by jmp at 0x004ef4b5, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004ef4c3
    pop ebp                                      # 004ef4c5
    ret 0x4                                      # 004ef4c6

