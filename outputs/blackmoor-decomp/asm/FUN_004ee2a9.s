# FUN_004ee2a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee2a9
# extent:       0x004ee2a9-0x004ee517 (622 code bytes)
# span:         0x004ee2a9-0x004ee517 (code 622, tables 0, padding 0)
# sha256:       572e87495891dfe755240e8a24362c8eb9d0008bc31e06132941368fcf814c34
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ee2a9_hit_slots
# naming:       native port src/original_methods_fl19a.c:m4ee2a9_hit_slots (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4ee2a9_hit_slots. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 622 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_c, field_14, field_4af, field_minus_1; [ecx + n] field_4, field_10, field_252, field_4af, field_minus_1; [edx + n] field_4, field_8, field_c, field_10, field_18, field_15f
# callees:      calls FUN_004e22fd, FUN_004ef2d1
# track-n:      outputs/blackmoor-decomp/src/caption_lifecycle.c:popup_hover (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 143 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_15f, 0x15f  # offset +0x15f
.equ field_252, 0x252  # offset +0x252
.equ field_4af, 0x4af  # offset +0x4af

# --- external targets -----------------------------------------------
.set FUN_004e22fd, .text + (0x004e22fd - 0x401000)
.set FUN_004ef2d1, .text + (0x004ef2d1 - 0x401000)

.org 0x004ee2a9 - 0x401000
.globl FUN_004ee2a9
FUN_004ee2a9:
    # block 0x004ee2a9: entry, 6 instruction(s), ends with je to 0x004ee2dc (forward)
    push ebp                                     # 004ee2a9
    {load} mov ebp, esp                          # 004ee2aa
    push ecx                                     # 004ee2ac
    mov dword ptr [ebp - local_4], ecx           # 004ee2ad
    cmp dword ptr [0x5c39e9], 0x0                # 004ee2b0
    je.d8 L_004ee2dc                             # 004ee2b7
    # block 0x004ee2b9: entered by fall-through of je at 0x004ee2b7, 5 instruction(s), ends with forward jump to 0x004ee37b
    mov dword ptr [0x5b44f0], 0x4                # 004ee2b9
    mov dword ptr [0x5b44f4], 0x0                # 004ee2c3
    mov eax, dword ptr [0x5d0377]                # 004ee2cd
    mov dword ptr [0x5d162d], eax                # 004ee2d2
    jmp.d32 L_004ee37b                           # 004ee2d7
L_004ee2dc:
    # block 0x004ee2dc: entered by je at 0x004ee2b7, 3 instruction(s), ends with jne to 0x004ee30a (forward)
    movsx ecx, word ptr [0x583a29]               # 004ee2dc
    cmp ecx, -0x1                                # 004ee2e3
    jne.d8 L_004ee30a                            # 004ee2e6
    # block 0x004ee2e8: entered by fall-through of jne at 0x004ee2e6, 5 instruction(s), ends with forward jump to 0x004ee37b
    mov dword ptr [0x5b44f0], 0x4                # 004ee2e8
    mov dword ptr [0x5b44f4], 0x0                # 004ee2f2
    mov edx, dword ptr [0x5d0377]                # 004ee2fc
    mov dword ptr [0x5d162d], edx                # 004ee302
    jmp.d8 L_004ee37b                            # 004ee308
L_004ee30a:
    # block 0x004ee30a: entered by jne at 0x004ee2e6, 3 instruction(s), ends with je to 0x004ee341 (forward)
    movsx eax, word ptr [0x583a29]               # 004ee30a
    cmp eax, -0x1                                # 004ee311
    je.d8 L_004ee341                             # 004ee314
    # block 0x004ee316: entered by fall-through of je at 0x004ee314, 2 instruction(s), ends with je to 0x004ee341 (forward)
    cmp dword ptr [0x5b44f8], 0x0                # 004ee316
    je.d8 L_004ee341                             # 004ee31d
    # block 0x004ee31f: entered by fall-through of je at 0x004ee31d, 5 instruction(s), ends with forward jump to 0x004ee37b
    mov dword ptr [0x5b44f0], 0x9                # 004ee31f
    mov dword ptr [0x5b44f4], 0x0                # 004ee329
    mov ecx, dword ptr [0x5d0377]                # 004ee333
    mov dword ptr [0x5d162d], ecx                # 004ee339
    jmp.d8 L_004ee37b                            # 004ee33f
L_004ee341:
    # block 0x004ee341: entered by je at 0x004ee314; je at 0x004ee31d, 3 instruction(s), ends with je to 0x004ee37b (forward)
    movsx edx, word ptr [0x583a29]               # 004ee341
    cmp edx, -0x1                                # 004ee348
    je.d8 L_004ee37b                             # 004ee34b
    # block 0x004ee34d: entered by fall-through of je at 0x004ee34b, 2 instruction(s), ends with jne to 0x004ee37b (forward)
    cmp dword ptr [0x5b44f8], 0x0                # 004ee34d
    jne.d8 L_004ee37b                            # 004ee354
    # block 0x004ee356: entered by fall-through of jne at 0x004ee354, 6 instruction(s), falls into the block at 0x004ee37b
    movsx eax, word ptr [0x583a29]               # 004ee356
    add eax, 0x25                                # 004ee35d
    mov dword ptr [0x5b44f0], eax                # 004ee360
    mov dword ptr [0x5b44f4], 0x0                # 004ee365
    mov ecx, dword ptr [0x571ad3]                # 004ee36f
    mov dword ptr [0x5d162d], ecx                # 004ee375
L_004ee37b:
    # block 0x004ee37b: entered by jmp at 0x004ee2d7; jmp at 0x004ee308; jmp at 0x004ee33f; je at 0x004ee34b; more, 62 instruction(s), ends with je to 0x004ee4a7 (forward)
    mov edx, dword ptr [0x5b44f0]                # 004ee37b
    shl edx, 0x5                                 # 004ee381
    mov eax, dword ptr [0x5b44f4]                # 004ee384
    shl eax, 0x4                                 # 004ee389
    lea ecx, [edx + eax + 0x5b160c]              # 004ee38c
    mov dword ptr [0x5d1631], ecx                # 004ee393
    mov dword ptr [0x5d1639], 0x1                # 004ee399
    mov edx, dword ptr [0x5b44f0]                # 004ee3a3
    shl edx, 0x4                                 # 004ee3a9
    mov eax, dword ptr [0x5b44f4]                # 004ee3ac
    mov ecx, dword ptr [0x583102]                # 004ee3b1
    add ecx, dword ptr [edx + 8*eax + 0x5b30cc]  # 004ee3b7
    mov edx, dword ptr [ebp - local_4]           # 004ee3be
    mov dword ptr [edx + field_4], ecx           # 004ee3c1
    mov eax, dword ptr [0x5b44f0]                # 004ee3c4
    shl eax, 0x4                                 # 004ee3c9
    mov ecx, dword ptr [0x5b44f4]                # 004ee3cc
    mov edx, dword ptr [0x583106]                # 004ee3d2
    add edx, dword ptr [eax + 8*ecx + 0x5b30d0]  # 004ee3d8
    mov eax, dword ptr [ebp - local_4]           # 004ee3df
    mov dword ptr [eax + field_8], edx           # 004ee3e2
    mov ecx, dword ptr [ebp - local_4]           # 004ee3e5
    mov edx, dword ptr [ecx + field_4]           # 004ee3e8
    mov dword ptr [0x5c3a5b], edx                # 004ee3eb
    mov eax, dword ptr [ebp - local_4]           # 004ee3f1
    mov ecx, dword ptr [eax + field_8]           # 004ee3f4
    mov dword ptr [0x5c3a5f], ecx                # 004ee3f7
    mov edx, dword ptr [0x5b44f0]                # 004ee3fd
    shl edx, 0x4                                 # 004ee403
    mov eax, dword ptr [0x5b44f4]                # 004ee406
    mov ecx, dword ptr [0x583102]                # 004ee40b
    add ecx, dword ptr [edx + 8*eax + 0x5b3e40]  # 004ee411
    mov edx, dword ptr [ebp - local_4]           # 004ee418
    mov dword ptr [edx + field_c], ecx           # 004ee41b
    mov eax, dword ptr [0x5b44f4]                # 004ee41e
    shl eax, 0x2                                 # 004ee423
    mov ecx, dword ptr [0x5b44f0]                # 004ee426
    movsx edx, word ptr [eax + 8*ecx + 0x5b3ae8] # 004ee42c
    mov eax, dword ptr [ebp - local_4]           # 004ee434
    mov ecx, dword ptr [eax + field_c]           # 004ee437
    lea edx, [ecx + edx - field_minus_1]         # 004ee43a
    mov eax, dword ptr [ebp - local_4]           # 004ee43e
    mov dword ptr [eax + field_14], edx          # 004ee441
    mov ecx, dword ptr [0x5b44f0]                # 004ee444
    shl ecx, 0x4                                 # 004ee44a
    mov edx, dword ptr [0x5b44f4]                # 004ee44d
    mov eax, dword ptr [0x583106]                # 004ee453
    add eax, dword ptr [ecx + 8*edx + 0x5b3e44]  # 004ee458
    mov ecx, dword ptr [ebp - local_4]           # 004ee45f
    mov dword ptr [ecx + field_10], eax          # 004ee462
    mov edx, dword ptr [0x5b44f4]                # 004ee465
    shl edx, 0x2                                 # 004ee46b
    mov eax, dword ptr [0x5b44f0]                # 004ee46e
    movsx ecx, word ptr [edx + 8*eax + 0x5b3aea] # 004ee473
    mov edx, dword ptr [ebp - local_4]           # 004ee47b
    mov eax, dword ptr [edx + field_10]          # 004ee47e
    lea ecx, [eax + ecx - field_minus_1]         # 004ee481
    mov edx, dword ptr [ebp - local_4]           # 004ee485
    mov dword ptr [edx + field_18], ecx          # 004ee488
    mov eax, dword ptr [ebp - local_4]           # 004ee48b
    cmp dword ptr [eax + field_4af], 0x2         # 004ee48e
    je.d8 L_004ee4a7                             # 004ee495
    # block 0x004ee497: entered by fall-through of je at 0x004ee495, 3 instruction(s), ends with je to 0x004ee4a7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ee497
    cmp dword ptr [ecx + field_4af], 0x3         # 004ee49a
    je.d8 L_004ee4a7                             # 004ee4a1
    # block 0x004ee4a3: entered by fall-through of je at 0x004ee4a1, 2 instruction(s), ends with forward jump to 0x004ee513
    {load} xor eax, eax                          # 004ee4a3
    jmp.d8 L_004ee513                            # 004ee4a5
L_004ee4a7:
    # block 0x004ee4a7: entered by je at 0x004ee495; je at 0x004ee4a1, 3 instruction(s), ends with je to 0x004ee4dc (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ee4a7
    cmp dword ptr [edx + field_15f], 0x0         # 004ee4aa
    je.d8 L_004ee4dc                             # 004ee4b1
    # block 0x004ee4b3: entered by fall-through of je at 0x004ee4b1, 11 instruction(s), calls FUN_004e22fd, ends with je to 0x004ee4dc (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ee4b3
    mov cx, word ptr [eax + field_8]             # 004ee4b6
    push ecx                                     # 004ee4ba
    mov edx, dword ptr [ebp - local_4]           # 004ee4bb
    mov ax, word ptr [edx + field_4]             # 004ee4be
    push eax                                     # 004ee4c2
    mov ecx, dword ptr [ebp - local_4]           # 004ee4c3
    add ecx, 0x31c                               # 004ee4c6
    call FUN_004e22fd                            # 004ee4cc
    test eax, eax                                # 004ee4d1
    je.d8 L_004ee4dc                             # 004ee4d3
    # block 0x004ee4d5: entered by fall-through of je at 0x004ee4d3, 2 instruction(s), ends with forward jump to 0x004ee513
    mov eax, 0x1                                 # 004ee4d5
    jmp.d8 L_004ee513                            # 004ee4da
L_004ee4dc:
    # block 0x004ee4dc: entered by je at 0x004ee4b1; je at 0x004ee4d3, 3 instruction(s), ends with je to 0x004ee511 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ee4dc
    cmp dword ptr [ecx + field_252], 0x0         # 004ee4df
    je.d8 L_004ee511                             # 004ee4e6
    # block 0x004ee4e8: entered by fall-through of je at 0x004ee4e6, 11 instruction(s), calls FUN_004ef2d1, ends with je to 0x004ee511 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ee4e8
    mov ax, word ptr [edx + field_8]             # 004ee4eb
    push eax                                     # 004ee4ef
    mov ecx, dword ptr [ebp - local_4]           # 004ee4f0
    mov dx, word ptr [ecx + field_4]             # 004ee4f3
    push edx                                     # 004ee4f7
    mov ecx, dword ptr [ebp - local_4]           # 004ee4f8
    add ecx, 0x4b7                               # 004ee4fb
    call FUN_004ef2d1                            # 004ee501
    test eax, eax                                # 004ee506
    je.d8 L_004ee511                             # 004ee508
    # block 0x004ee50a: entered by fall-through of je at 0x004ee508, 2 instruction(s), ends with forward jump to 0x004ee513
    mov eax, 0x1                                 # 004ee50a
    jmp.d8 L_004ee513                            # 004ee50f
L_004ee511:
    # block 0x004ee511: entered by je at 0x004ee4e6; je at 0x004ee508, 1 instruction(s), falls into the block at 0x004ee513
    {load} xor eax, eax                          # 004ee511
L_004ee513:
    # block 0x004ee513: entered by jmp at 0x004ee4a5; jmp at 0x004ee4da; jmp at 0x004ee50f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ee513
    pop ebp                                      # 004ee515
    ret                                          # 004ee516

