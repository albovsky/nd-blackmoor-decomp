# FUN_004f61e7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f61e7
# extent:       0x004f61e7-0x004f6334 (333 code bytes)
# span:         0x004f61e7-0x004f6334 (code 333, tables 0, padding 0)
# sha256:       91986ddd54f06b46da13ec5d43a81dbc2bda2cfc3f6816e543766d2635d664fc
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f61e7_start_record
# naming:       native port src/original_methods_fl30a.c:m4f61e7_start_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Start of a record: stores 0x3e8/0, calls 0x4f709c, checks rec+0x162/+0x28f, calls the vtable entry +0x48 and reports via 0x50ca3e/0x44a2b7; all instructions and jump directions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_28f, field_3be, field_3c2, field_3ca, field_3ce; [ecx + n] field_48, field_287, field_28f, field_3be, field_3c2, field_3ca; [edx + n] field_162, field_28f, field_3be, field_3c2, field_3ca
# callees:      calls FUN_004f709c, FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30a.c:m4f61e7_start_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 78 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_48, 0x48  # offset +0x48
.equ field_162, 0x162  # offset +0x162
.equ field_287, 0x287  # offset +0x287
.equ field_28f, 0x28f  # offset +0x28f
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f61e7 - 0x401000
.globl FUN_004f61e7
FUN_004f61e7:
    # block 0x004f61e7: entry, 18 instruction(s), calls FUN_004f709c, ends with jne to 0x004f6255 (forward)
    push ebp                                     # 004f61e7
    {load} mov ebp, esp                          # 004f61e8
    sub esp, 0x8                                 # 004f61ea
    mov dword ptr [ebp - local_8], ecx           # 004f61ed
    mov eax, dword ptr [ebp - local_8]           # 004f61f0
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f61f3
    mov ecx, dword ptr [ebp - local_8]           # 004f61fd
    mov dword ptr [ecx + field_3ca], 0x0         # 004f6200
    mov edx, dword ptr [ebp + arg_8]             # 004f620a
    imul edx, edx, 0x5bb                         # 004f620d
    mov eax, dword ptr [ebp - local_8]           # 004f6213
    mov ecx, dword ptr [eax + field_3ce]         # 004f6216
    {load} add ecx, edx                          # 004f621c
    mov dword ptr [ebp - local_4], ecx           # 004f621e
    mov ecx, dword ptr [ebp - local_8]           # 004f6221
    call FUN_004f709c                            # 004f6224
    test eax, eax                                # 004f6229
    jne.d8 L_004f6255                            # 004f622b
    # block 0x004f622d: entered by fall-through of jne at 0x004f622b, 7 instruction(s), ends with forward jump to 0x004f632e
    mov edx, dword ptr [ebp - local_8]           # 004f622d
    mov dword ptr [edx + field_3c2], 0x3ea       # 004f6230
    mov eax, dword ptr [ebp - local_8]           # 004f623a
    mov dword ptr [eax + field_3be], 0x0         # 004f623d
    mov ecx, dword ptr [ebp - local_8]           # 004f6247
    mov eax, dword ptr [ecx + field_3be]         # 004f624a
    jmp.d32 L_004f632e                           # 004f6250
L_004f6255:
    # block 0x004f6255: entered by jne at 0x004f622b, 3 instruction(s), ends with je to 0x004f626d (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f6255
    cmp dword ptr [edx + field_162], 0x0         # 004f6258
    je.d8 L_004f626d                             # 004f625f
    # block 0x004f6261: entered by fall-through of je at 0x004f625f, 3 instruction(s), ends with jne to 0x004f6295 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f6261
    cmp dword ptr [eax + field_28f], 0x0         # 004f6264
    jne.d8 L_004f6295                            # 004f626b
L_004f626d:
    # block 0x004f626d: entered by je at 0x004f625f; fall-through of jne at 0x004f626b, 7 instruction(s), ends with forward jump to 0x004f632e
    mov ecx, dword ptr [ebp - local_8]           # 004f626d
    mov dword ptr [ecx + field_3c2], 0x3ef       # 004f6270
    mov edx, dword ptr [ebp - local_8]           # 004f627a
    mov dword ptr [edx + field_3be], 0x0         # 004f627d
    mov eax, dword ptr [ebp - local_8]           # 004f6287
    mov eax, dword ptr [eax + field_3be]         # 004f628a
    jmp.d32 L_004f632e                           # 004f6290
L_004f6295:
    # block 0x004f6295: entered by jne at 0x004f626b, 14 instruction(s), calls indirect dword ptr [ecx + 0x48], ends with jne to 0x004f630b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f6295
    mov dword ptr [ecx + field_287], 0x1         # 004f6298
    mov edx, dword ptr [ebp - local_4]           # 004f62a2
    mov eax, dword ptr [edx + field_28f]         # 004f62a5
    mov ecx, dword ptr [ebp - local_4]           # 004f62ab
    mov edx, dword ptr [ecx + field_28f]         # 004f62ae
    mov ecx, dword ptr [edx]                     # 004f62b4
    push eax                                     # 004f62b6
    call dword ptr [ecx + field_48]              # 004f62b7
    mov edx, dword ptr [ebp - local_8]           # 004f62ba
    mov dword ptr [edx + field_3ca], eax         # 004f62bd
    mov eax, dword ptr [ebp - local_8]           # 004f62c3
    cmp dword ptr [eax + field_3ca], 0x0         # 004f62c6
    jne.d8 L_004f630b                            # 004f62cd
    # block 0x004f62cf: entered by fall-through of jne at 0x004f62cd, 3 instruction(s), ends with je to 0x004f6304 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f62cf
    test ecx, ecx                                # 004f62d6
    je.d8 L_004f6304                             # 004f62d8
    # block 0x004f62da: entered by fall-through of je at 0x004f62d8, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f6304
    mov edx, dword ptr [ebp - local_4]           # 004f62da
    add edx, 0x4                                 # 004f62dd
    push edx                                     # 004f62e0
    mov eax, dword ptr [ebp + arg_8]             # 004f62e1
    push eax                                     # 004f62e4
    push 0x55e7bc                                # 004f62e5
    push 0x63888b                                # 004f62ea
    call FUN_0050ca3e                            # 004f62ef
    add esp, 0x10                                # 004f62f4
    push 0x63888b                                # 004f62f7
    call FUN_0044a2b7                            # 004f62fc
    add esp, 0x4                                 # 004f6301
L_004f6304:
    # block 0x004f6304: entered by je at 0x004f62d8, 2 instruction(s), ends with forward jump to 0x004f632e
    mov eax, 0x1                                 # 004f6304
    jmp.d8 L_004f632e                            # 004f6309
L_004f630b:
    # block 0x004f630b: entered by jne at 0x004f62cd, 6 instruction(s), falls into the block at 0x004f632e
    mov ecx, dword ptr [ebp - local_8]           # 004f630b
    mov dword ptr [ecx + field_3c2], 0x40b       # 004f630e
    mov edx, dword ptr [ebp - local_8]           # 004f6318
    mov dword ptr [edx + field_3be], 0x0         # 004f631b
    mov eax, dword ptr [ebp - local_8]           # 004f6325
    mov eax, dword ptr [eax + field_3be]         # 004f6328
L_004f632e:
    # block 0x004f632e: entered by jmp at 0x004f6250; jmp at 0x004f6290; jmp at 0x004f6309, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f632e
    pop ebp                                      # 004f6330
    ret 0x4                                      # 004f6331

