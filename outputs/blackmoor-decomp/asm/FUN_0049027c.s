# FUN_0049027c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049027c
# extent:       0x0049027c-0x0049044c (464 code bytes)
# span:         0x0049027c-0x00490450 (code 464, tables 0, padding 4)
# sha256:       899889c6b46879280d5a9b7da3967cfb9a43711905143154d0c442c36fc53241
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49027c_lifted
# naming:       native port src/original_methods_fl41.c:m49027c_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 5 seeds; oracle: 124/124 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [ecx + n] field_b0, field_b2, field_b6, field_ba, field_be
# callees:      calls FUN_004c5377, FUN_004d2c20
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m49027c_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 124 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2
.equ field_b6, 0xb6  # offset +0xb6
.equ field_ba, 0xba  # offset +0xba
.equ field_be, 0xbe  # offset +0xbe

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004d2c20, .text + (0x004d2c20 - 0x401000)

.org 0x0049027c - 0x401000
.globl FUN_0049027c
FUN_0049027c:
    # block 0x0049027c: entry, 11 instruction(s), ends with forward jump to 0x004902ae
    push ebp                                     # 0049027c
    {load} mov ebp, esp                          # 0049027d
    sub esp, 0x28                                # 0049027f
    push esi                                     # 00490282
    push edi                                     # 00490283
    movsx eax, word ptr [0x624de7]               # 00490284
    imul eax, eax, 0x8d                          # 0049028b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00490291
    mov dword ptr [ebp - local_8], ecx           # 00490297
    mov word ptr [ebp - local_4], 0x0            # 0049029a
    jmp.d8 L_004902ae                            # 004902a0
L_004902a2:
    # block 0x004902a2: entered by jmp at 0x00490441, 3 instruction(s), falls into the block at 0x004902ae
    mov dx, word ptr [ebp - local_4]             # 004902a2
    add dx, 0x1                                  # 004902a6
    mov word ptr [ebp - local_4], dx             # 004902aa
L_004902ae:
    # block 0x004902ae: entered by jmp at 0x004902a0, 5 instruction(s), ends with jge to 0x00490446 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004902ae
    mov ecx, dword ptr [ebp - local_8]           # 004902b2
    movsx edx, word ptr [ecx + field_b0]         # 004902b5
    {load} cmp eax, edx                          # 004902bc
    jge.d32 L_00490446                           # 004902be
    # block 0x004902c4: entered by fall-through of jge at 0x004902be, 68 instruction(s), calls FUN_004c5377, ends with je to 0x00490441 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004902c4
    imul eax, eax, 0xd0                          # 004902c8
    mov ecx, dword ptr [ebp - local_8]           # 004902ce
    mov edx, dword ptr [ecx + eax + field_b6]    # 004902d1
    mov dword ptr [ebp - local_14], edx          # 004902d8
    movsx eax, word ptr [ebp - local_4]          # 004902db
    imul eax, eax, 0xd0                          # 004902df
    mov ecx, dword ptr [ebp - local_8]           # 004902e5
    mov edx, dword ptr [ecx + eax + field_be]    # 004902e8
    mov dword ptr [ebp - local_c], edx           # 004902ef
    movsx eax, word ptr [ebp - local_4]          # 004902f2
    imul eax, eax, 0xd0                          # 004902f6
    mov ecx, dword ptr [ebp - local_8]           # 004902fc
    mov edx, dword ptr [ecx + eax + field_b2]    # 004902ff
    mov dword ptr [ebp - local_18], edx          # 00490306
    movsx eax, word ptr [ebp - local_4]          # 00490309
    imul eax, eax, 0xd0                          # 0049030d
    mov ecx, dword ptr [ebp - local_8]           # 00490313
    mov edx, dword ptr [ecx + eax + field_ba]    # 00490316
    add edx, 0x8                                 # 0049031d
    mov dword ptr [ebp - local_10], edx          # 00490320
    mov eax, dword ptr [ebp - local_14]          # 00490323
    add eax, dword ptr [0x58318a]                # 00490326
    mov dword ptr [ebp - local_24], eax          # 0049032c
    mov ecx, dword ptr [ebp - local_c]           # 0049032f
    add ecx, dword ptr [0x58318a]                # 00490332
    mov dword ptr [ebp - local_1c], ecx          # 00490338
    mov edx, dword ptr [ebp - local_18]          # 0049033b
    add edx, dword ptr [0x583186]                # 0049033e
    mov dword ptr [ebp - local_28], edx          # 00490344
    mov eax, dword ptr [ebp - local_10]          # 00490347
    add eax, dword ptr [0x583186]                # 0049034a
    mov dword ptr [ebp - local_20], eax          # 00490350
    push 0x54ea24                                # 00490353
    lea ecx, [ebp - local_28]                    # 00490358
    push ecx                                     # 0049035b
    lea edx, [ebp - local_18]                    # 0049035c
    push edx                                     # 0049035f
    mov eax, dword ptr [0x5cf665]                # 00490360
    push eax                                     # 00490365
    mov ecx, dword ptr [0x5d15e3]                # 00490366
    push ecx                                     # 0049036c
    mov ecx, 0x5cf659                            # 0049036d
    call FUN_004c5377                            # 00490372
    push 0x54ea54                                # 00490377
    movsx edx, word ptr [ebp - local_4]          # 0049037c
    shl edx, 0x4                                 # 00490380
    add edx, 0x624de9                            # 00490383
    push edx                                     # 00490389
    movsx eax, word ptr [ebp - local_4]          # 0049038a
    imul eax, eax, 0xd0                          # 0049038e
    mov ecx, dword ptr [ebp - local_8]           # 00490394
    lea edx, [ecx + eax + field_b2]              # 00490397
    push edx                                     # 0049039e
    mov eax, dword ptr [0x5cf665]                # 0049039f
    push eax                                     # 004903a4
    mov ecx, dword ptr [0x5d15e3]                # 004903a5
    push ecx                                     # 004903ab
    mov ecx, 0x5cf659                            # 004903ac
    call FUN_004c5377                            # 004903b1
    mov edi, 0x63a8bc                            # 004903b6
    movsx esi, word ptr [ebp - local_4]          # 004903bb
    imul esi, esi, 0x11                          # 004903bf
    add esi, 0x624fc9                            # 004903c2
    mov ecx, 0x1                                 # 004903c8
    {load} xor edx, edx                          # 004903cd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004903cf
    je.d8 L_00490441                             # 004903d1
    # block 0x004903d3: entered by fall-through of je at 0x004903d1, 31 instruction(s), calls FUN_004d2c20, falls into the block at 0x00490441
    push 0x0                                     # 004903d3
    mov eax, dword ptr [0x5cf665]                # 004903d5
    push eax                                     # 004903da
    mov ecx, dword ptr [ebp - local_8]           # 004903db
    movsx edx, word ptr [ecx]                    # 004903de
    mov eax, dword ptr [4*edx + 0x5d032f]        # 004903e1
    push eax                                     # 004903e8
    movsx ecx, word ptr [ebp - local_4]          # 004903e9
    shl ecx, 0x4                                 # 004903ed
    mov dx, word ptr [ecx + 0x624df5]            # 004903f0
    push edx                                     # 004903f7
    movsx eax, word ptr [ebp - local_4]          # 004903f8
    shl eax, 0x4                                 # 004903fc
    mov cx, word ptr [eax + 0x624de9]            # 004903ff
    push ecx                                     # 00490406
    mov edx, dword ptr [ebp - local_8]           # 00490407
    movsx eax, word ptr [edx]                    # 0049040a
    imul eax, eax, 0x1d0                         # 0049040d
    add eax, 0x5adb3a                            # 00490413
    push eax                                     # 00490418
    mov ecx, dword ptr [ebp - local_8]           # 00490419
    movsx edx, word ptr [ecx]                    # 0049041c
    imul edx, edx, 0x7f3                         # 0049041f
    add edx, 0x5a4c24                            # 00490425
    push edx                                     # 0049042b
    movsx eax, word ptr [ebp - local_4]          # 0049042c
    imul eax, eax, 0x11                          # 00490430
    add eax, 0x624fc9                            # 00490433
    push eax                                     # 00490438
    call FUN_004d2c20                            # 00490439
    add esp, 0x20                                # 0049043e
L_00490441:
    # block 0x00490441: entered by je at 0x004903d1, 1 instruction(s), ends with backward jump to 0x004902a2
    jmp.d32 L_004902a2                           # 00490441
L_00490446:
    # block 0x00490446: entered by jge at 0x004902be, 5 instruction(s), ends with ret
    pop edi                                      # 00490446
    pop esi                                      # 00490447
    {load} mov esp, ebp                          # 00490448
    pop ebp                                      # 0049044a
    ret                                          # 0049044b

# --- data items (not part of the function) -------------------------
.org 0x0049044c - 0x401000
PAD_0049044c:  # 4 byte(s) of int3 padding
    .fill 4, 1, 0xcc

