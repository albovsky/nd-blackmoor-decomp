# FUN_004d65e9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d65e9
# extent:       0x004d65e9-0x004d6705 (284 code bytes)
# span:         0x004d65e9-0x004d6705 (code 284, tables 0, padding 0)
# sha256:       760482d1902d8d7d0e9ef9185ce144ccfa02554fb79aee8fbf69aebf4dd12cfd
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d65e9_lifted
# naming:       native port src/original_methods_fl41.c:m4d65e9_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 10 seeds; oracle: 80/80 instructions, 6/6 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_94e2; [ecx + n] field_35, field_41, field_94e2, field_3390b; [edx + n] field_2b4, field_2b6, field_2b8, field_2ba, field_94e2, field_3390b
# callees:      calls FUN_004c4b12, FUN_004d270b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d65e9_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 80 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_35, 0x35  # offset +0x35
.equ field_41, 0x41  # offset +0x41
.equ field_2b4, 0x2b4  # offset +0x2b4
.equ field_2b6, 0x2b6  # offset +0x2b6
.equ field_2b8, 0x2b8  # offset +0x2b8
.equ field_2ba, 0x2ba  # offset +0x2ba
.equ field_94e2, 0x94e2  # offset +0x94e2
.equ field_3390b, 0x3390b  # offset +0x3390b

# --- external targets -----------------------------------------------
.set FUN_004c4b12, .text + (0x004c4b12 - 0x401000)
.set FUN_004d270b, .text + (0x004d270b - 0x401000)

.org 0x004d65e9 - 0x401000
.globl FUN_004d65e9
FUN_004d65e9:
    # block 0x004d65e9: entry, 19 instruction(s), calls FUN_004c4b12, ends with jne to 0x004d662d (forward)
    push ebp                                     # 004d65e9
    {load} mov ebp, esp                          # 004d65ea
    sub esp, 0x8                                 # 004d65ec
    mov dword ptr [ebp - local_4], ecx           # 004d65ef
    mov eax, dword ptr [ebp + arg_8]             # 004d65f2
    mov ecx, dword ptr [ebp - local_4]           # 004d65f5
    mov edx, dword ptr [ecx + 4*eax + field_94e2] # 004d65f8
    add edx, 0x35                                # 004d65ff
    push edx                                     # 004d6602
    mov ax, word ptr [0x5d2f29]                  # 004d6603
    push eax                                     # 004d6609
    mov ecx, dword ptr [ebp + arg_8]             # 004d660a
    mov edx, dword ptr [ebp - local_4]           # 004d660d
    mov eax, dword ptr [edx + 4*ecx + field_94e2] # 004d6610
    push eax                                     # 004d6617
    mov ecx, 0x5cf659                            # 004d6618
    call FUN_004c4b12                            # 004d661d
    cmp dword ptr [ebp + arg_c], 0x0             # 004d6622
    jne.d8 L_004d662d                            # 004d6626
    # block 0x004d6628: entered by fall-through of jne at 0x004d6626, 1 instruction(s), ends with forward jump to 0x004d66ff
    jmp.d32 L_004d66ff                           # 004d6628
L_004d662d:
    # block 0x004d662d: entered by jne at 0x004d6626, 4 instruction(s), ends with je to 0x004d6641 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004d662d
    mov dword ptr [ebp - local_8], ecx           # 004d6630
    cmp dword ptr [ebp - local_8], 0x1           # 004d6633
    je.d8 L_004d6641                             # 004d6637
    # block 0x004d6639: entered by fall-through of je at 0x004d6637, 2 instruction(s), ends with je to 0x004d6656 (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004d6639
    je.d8 L_004d6656                             # 004d663d
    # block 0x004d663f: entered by fall-through of je at 0x004d663d, 1 instruction(s), ends with forward jump to 0x004d6669
    jmp.d8 L_004d6669                            # 004d663f
L_004d6641:
    # block 0x004d6641: entered by je at 0x004d6637, 5 instruction(s), ends with forward jump to 0x004d6669
    mov edx, dword ptr [ebp - local_4]           # 004d6641
    movsx eax, word ptr [edx + field_2b4]        # 004d6644
    mov ecx, dword ptr [ebp - local_4]           # 004d664b
    mov dword ptr [ecx + field_3390b], eax       # 004d664e
    jmp.d8 L_004d6669                            # 004d6654
L_004d6656:
    # block 0x004d6656: entered by je at 0x004d663d, 4 instruction(s), falls into the block at 0x004d6669
    mov edx, dword ptr [ebp - local_4]           # 004d6656
    movsx eax, word ptr [edx + field_2b6]        # 004d6659
    mov ecx, dword ptr [ebp - local_4]           # 004d6660
    mov dword ptr [ecx + field_3390b], eax       # 004d6663
L_004d6669:
    # block 0x004d6669: entered by jmp at 0x004d663f; jmp at 0x004d6654, 41 instruction(s), calls FUN_004d270b, falls into the block at 0x004d66ff
    push 0x0                                     # 004d6669
    push 0x0                                     # 004d666b
    push 0x0                                     # 004d666d
    mov edx, dword ptr [ebp + arg_8]             # 004d666f
    mov eax, dword ptr [ebp - local_4]           # 004d6672
    mov ecx, dword ptr [eax + 4*edx + field_94e2] # 004d6675
    push ecx                                     # 004d667c
    mov edx, dword ptr [ebp - local_4]           # 004d667d
    mov eax, dword ptr [edx + field_3390b]       # 004d6680
    mov ecx, dword ptr [4*eax + 0x5d032f]        # 004d6686
    push ecx                                     # 004d668d
    mov edx, dword ptr [ebp + arg_8]             # 004d668e
    mov eax, dword ptr [ebp - local_4]           # 004d6691
    mov ecx, dword ptr [eax + 4*edx + field_94e2] # 004d6694
    mov edx, dword ptr [ebp - local_4]           # 004d669b
    movsx eax, word ptr [edx + field_2ba]        # 004d669e
    mov ecx, dword ptr [ecx + field_41]          # 004d66a5
    {load} add ecx, eax                          # 004d66a8
    push ecx                                     # 004d66aa
    mov edx, dword ptr [ebp + arg_8]             # 004d66ab
    mov eax, dword ptr [ebp - local_4]           # 004d66ae
    mov ecx, dword ptr [eax + 4*edx + field_94e2] # 004d66b1
    mov edx, dword ptr [ebp - local_4]           # 004d66b8
    movsx eax, word ptr [edx + field_2b8]        # 004d66bb
    mov ecx, dword ptr [ecx + field_35]          # 004d66c2
    {load} add ecx, eax                          # 004d66c5
    push ecx                                     # 004d66c7
    mov edx, dword ptr [ebp - local_4]           # 004d66c8
    mov eax, dword ptr [edx + field_3390b]       # 004d66cb
    imul eax, eax, 0x1d0                         # 004d66d1
    add eax, 0x5adb3a                            # 004d66d7
    push eax                                     # 004d66dc
    mov ecx, dword ptr [ebp - local_4]           # 004d66dd
    mov edx, dword ptr [ecx + field_3390b]       # 004d66e0
    imul edx, edx, 0x7f3                         # 004d66e6
    add edx, 0x5a4c24                            # 004d66ec
    push edx                                     # 004d66f2
    mov eax, dword ptr [ebp + arg_10]            # 004d66f3
    push eax                                     # 004d66f6
    call FUN_004d270b                            # 004d66f7
    add esp, 0x28                                # 004d66fc
L_004d66ff:
    # block 0x004d66ff: entered by jmp at 0x004d6628, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004d66ff
    pop ebp                                      # 004d6701
    ret 0xc                                      # 004d6702

