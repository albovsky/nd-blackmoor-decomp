# FUN_004641bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004641bb
# extent:       0x004641bb-0x0046453b (896 code bytes)
# span:         0x004641bb-0x0046453b (code 896, tables 0, padding 0)
# sha256:       2d5ca042238618e133d66930043b328460a33eb5601433bedc129c0f4ff6ebe9
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4641bb_lifted
# naming:       native port src/original_methods_fl40.c:m4641bb_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 12 seeds; oracle: 235/235 instructions executed, 30/30 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_1e, field_8a, field_98, field_121, field_131, field_141, field_161; [ecx + n] field_4, field_8, field_c, field_8a, field_90, field_98, field_101, field_151; [edx + n] field_4, field_8, field_c, field_8a, field_8c, field_98, field_f1, field_111, field_171
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4641bb_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 235 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_98, 0x98  # offset +0x98
.equ field_f1, 0xf1  # offset +0xf1
.equ field_101, 0x101  # offset +0x101
.equ field_111, 0x111  # offset +0x111
.equ field_121, 0x121  # offset +0x121
.equ field_131, 0x131  # offset +0x131
.equ field_141, 0x141  # offset +0x141
.equ field_151, 0x151  # offset +0x151
.equ field_161, 0x161  # offset +0x161
.equ field_171, 0x171  # offset +0x171

# --- external targets -----------------------------------------------

.org 0x004641bb - 0x401000
.globl FUN_004641bb
FUN_004641bb:
    # block 0x004641bb: entry, 19 instruction(s), ends with je to 0x0046423a (forward)
    push ebp                                     # 004641bb
    {load} mov ebp, esp                          # 004641bc
    sub esp, 0x14                                # 004641be
    mov dword ptr [ebp - local_14], ecx          # 004641c1
    mov eax, dword ptr [ebp - local_14]          # 004641c4
    movsx ecx, word ptr [eax + field_1e]         # 004641c7
    imul ecx, ecx, 0x8d                          # 004641cb
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004641d1
    mov dword ptr [ebp - local_10], edx          # 004641d7
    {load} xor eax, eax                          # 004641da
    mov ecx, dword ptr [ebp - local_14]          # 004641dc
    add ecx, 0xa8                                # 004641df
    mov dword ptr [ecx], eax                     # 004641e5
    mov dword ptr [ecx + field_4], eax           # 004641e7
    mov dword ptr [ecx + field_8], eax           # 004641ea
    mov dword ptr [ecx + field_c], eax           # 004641ed
    mov edx, dword ptr [ebp - local_14]          # 004641f0
    cmp dword ptr [edx + field_8c], 0x0          # 004641f3
    je.d8 L_0046423a                             # 004641fa
    # block 0x004641fc: entered by fall-through of je at 0x004641fa, 16 instruction(s), ends with forward jump to 0x00464537
    mov eax, dword ptr [ebp - local_14]          # 004641fc
    movsx ecx, word ptr [eax + field_8a]         # 004641ff
    imul ecx, ecx, 0x90                          # 00464206
    mov edx, dword ptr [ebp - local_10]          # 0046420c
    lea eax, [edx + ecx + field_f1]              # 0046420f
    mov ecx, dword ptr [ebp - local_14]          # 00464216
    add ecx, 0xa8                                # 00464219
    mov edx, dword ptr [eax]                     # 0046421f
    mov dword ptr [ecx], edx                     # 00464221
    mov edx, dword ptr [eax + field_4]           # 00464223
    mov dword ptr [ecx + field_4], edx           # 00464226
    mov edx, dword ptr [eax + field_8]           # 00464229
    mov dword ptr [ecx + field_8], edx           # 0046422c
    mov eax, dword ptr [eax + field_c]           # 0046422f
    mov dword ptr [ecx + field_c], eax           # 00464232
    jmp.d32 L_00464537                           # 00464235
L_0046423a:
    # block 0x0046423a: entered by je at 0x004641fa, 3 instruction(s), ends with je to 0x00464283 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0046423a
    cmp dword ptr [ecx + field_90], 0x0          # 0046423d
    je.d8 L_00464283                             # 00464244
    # block 0x00464246: entered by fall-through of je at 0x00464244, 16 instruction(s), ends with forward jump to 0x00464537
    mov edx, dword ptr [ebp - local_14]          # 00464246
    movsx eax, word ptr [edx + field_8a]         # 00464249
    imul eax, eax, 0x90                          # 00464250
    mov ecx, dword ptr [ebp - local_10]          # 00464256
    lea edx, [ecx + eax + field_101]             # 00464259
    mov eax, dword ptr [ebp - local_14]          # 00464260
    add eax, 0xa8                                # 00464263
    mov ecx, dword ptr [edx]                     # 00464268
    mov dword ptr [eax], ecx                     # 0046426a
    mov ecx, dword ptr [edx + field_4]           # 0046426c
    mov dword ptr [eax + field_4], ecx           # 0046426f
    mov ecx, dword ptr [edx + field_8]           # 00464272
    mov dword ptr [eax + field_8], ecx           # 00464275
    mov edx, dword ptr [edx + field_c]           # 00464278
    mov dword ptr [eax + field_c], edx           # 0046427b
    jmp.d32 L_00464537                           # 0046427e
L_00464283:
    # block 0x00464283: entered by je at 0x00464244, 5 instruction(s), ends with je to 0x004642d8 (forward)
    mov eax, dword ptr [ebp - local_14]          # 00464283
    movsx ecx, word ptr [eax + field_8a]         # 00464286
    mov edx, dword ptr [ebp - local_14]          # 0046428d
    cmp dword ptr [edx + 4*ecx + field_98], 0x0  # 00464290
    je.d8 L_004642d8                             # 00464298
    # block 0x0046429a: entered by fall-through of je at 0x00464298, 16 instruction(s), ends with forward jump to 0x00464537
    mov eax, dword ptr [ebp - local_14]          # 0046429a
    movsx ecx, word ptr [eax + field_8a]         # 0046429d
    imul ecx, ecx, 0x90                          # 004642a4
    mov edx, dword ptr [ebp - local_10]          # 004642aa
    lea eax, [edx + ecx + field_111]             # 004642ad
    mov ecx, dword ptr [ebp - local_14]          # 004642b4
    add ecx, 0xa8                                # 004642b7
    mov edx, dword ptr [eax]                     # 004642bd
    mov dword ptr [ecx], edx                     # 004642bf
    mov edx, dword ptr [eax + field_4]           # 004642c1
    mov dword ptr [ecx + field_4], edx           # 004642c4
    mov edx, dword ptr [eax + field_8]           # 004642c7
    mov dword ptr [ecx + field_8], edx           # 004642ca
    mov eax, dword ptr [eax + field_c]           # 004642cd
    mov dword ptr [ecx + field_c], eax           # 004642d0
    jmp.d32 L_00464537                           # 004642d3
L_004642d8:
    # block 0x004642d8: entered by je at 0x00464298, 5 instruction(s), ends with jns to 0x004642f2 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004642d8
    movsx edx, word ptr [ecx + field_8a]         # 004642db
    add edx, 0x1                                 # 004642e2
    and edx, 0x80000003                          # 004642e5
    jns.d8 L_004642f2                            # 004642eb
    # block 0x004642ed: entered by fall-through of jns at 0x004642eb, 3 instruction(s), falls into the block at 0x004642f2
    dec edx                                      # 004642ed
    or edx, -0x4                                 # 004642ee
    inc edx                                      # 004642f1
L_004642f2:
    # block 0x004642f2: entered by jns at 0x004642eb, 8 instruction(s), ends with jge to 0x00464315 (forward)
    mov word ptr [ebp - local_c], dx             # 004642f2
    mov eax, dword ptr [ebp - local_14]          # 004642f6
    movsx ecx, word ptr [eax + field_8a]         # 004642f9
    sub ecx, 0x1                                 # 00464300
    mov word ptr [ebp - local_4], cx             # 00464303
    movsx edx, word ptr [ebp - local_4]          # 00464307
    test edx, edx                                # 0046430b
    jge.d8 L_00464315                            # 0046430d
    # block 0x0046430f: entered by fall-through of jge at 0x0046430d, 1 instruction(s), falls into the block at 0x00464315
    mov word ptr [ebp - local_4], 0x3            # 0046430f
L_00464315:
    # block 0x00464315: entered by jge at 0x0046430d, 5 instruction(s), ends with jns to 0x0046432f (forward)
    mov eax, dword ptr [ebp - local_14]          # 00464315
    movsx ecx, word ptr [eax + field_8a]         # 00464318
    add ecx, 0x2                                 # 0046431f
    and ecx, 0x80000003                          # 00464322
    jns.d8 L_0046432f                            # 00464328
    # block 0x0046432a: entered by fall-through of jns at 0x00464328, 3 instruction(s), falls into the block at 0x0046432f
    dec ecx                                      # 0046432a
    or ecx, -0x4                                 # 0046432b
    inc ecx                                      # 0046432e
L_0046432f:
    # block 0x0046432f: entered by jns at 0x00464328, 5 instruction(s), ends with je to 0x00464393 (forward)
    mov word ptr [ebp - local_8], cx             # 0046432f
    movsx edx, word ptr [ebp - local_c]          # 00464333
    mov eax, dword ptr [ebp - local_14]          # 00464337
    cmp dword ptr [eax + 4*edx + field_98], 0x0  # 0046433a
    je.d8 L_00464393                             # 00464342
    # block 0x00464344: entered by fall-through of je at 0x00464342, 4 instruction(s), ends with je to 0x00464393 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00464344
    mov edx, dword ptr [ebp - local_14]          # 00464348
    cmp dword ptr [edx + 4*ecx + field_98], 0x0  # 0046434b
    je.d8 L_00464393                             # 00464353
    # block 0x00464355: entered by fall-through of je at 0x00464353, 16 instruction(s), ends with forward jump to 0x00464537
    mov eax, dword ptr [ebp - local_14]          # 00464355
    movsx ecx, word ptr [eax + field_8a]         # 00464358
    imul ecx, ecx, 0x90                          # 0046435f
    mov edx, dword ptr [ebp - local_10]          # 00464365
    lea eax, [edx + ecx + field_171]             # 00464368
    mov ecx, dword ptr [ebp - local_14]          # 0046436f
    add ecx, 0xa8                                # 00464372
    mov edx, dword ptr [eax]                     # 00464378
    mov dword ptr [ecx], edx                     # 0046437a
    mov edx, dword ptr [eax + field_4]           # 0046437c
    mov dword ptr [ecx + field_4], edx           # 0046437f
    mov edx, dword ptr [eax + field_8]           # 00464382
    mov dword ptr [ecx + field_8], edx           # 00464385
    mov eax, dword ptr [eax + field_c]           # 00464388
    mov dword ptr [ecx + field_c], eax           # 0046438b
    jmp.d32 L_00464537                           # 0046438e
L_00464393:
    # block 0x00464393: entered by je at 0x00464342; je at 0x00464353, 4 instruction(s), ends with je to 0x004643f2 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00464393
    mov edx, dword ptr [ebp - local_14]          # 00464397
    cmp dword ptr [edx + 4*ecx + field_98], 0x0  # 0046439a
    je.d8 L_004643f2                             # 004643a2
    # block 0x004643a4: entered by fall-through of je at 0x004643a2, 4 instruction(s), ends with je to 0x004643f2 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004643a4
    mov ecx, dword ptr [ebp - local_14]          # 004643a8
    cmp dword ptr [ecx + 4*eax + field_98], 0x0  # 004643ab
    je.d8 L_004643f2                             # 004643b3
    # block 0x004643b5: entered by fall-through of je at 0x004643b3, 16 instruction(s), ends with forward jump to 0x00464537
    mov edx, dword ptr [ebp - local_14]          # 004643b5
    movsx eax, word ptr [edx + field_8a]         # 004643b8
    imul eax, eax, 0x90                          # 004643bf
    mov ecx, dword ptr [ebp - local_10]          # 004643c5
    lea edx, [ecx + eax + field_151]             # 004643c8
    mov eax, dword ptr [ebp - local_14]          # 004643cf
    add eax, 0xa8                                # 004643d2
    mov ecx, dword ptr [edx]                     # 004643d7
    mov dword ptr [eax], ecx                     # 004643d9
    mov ecx, dword ptr [edx + field_4]           # 004643db
    mov dword ptr [eax + field_4], ecx           # 004643de
    mov ecx, dword ptr [edx + field_8]           # 004643e1
    mov dword ptr [eax + field_8], ecx           # 004643e4
    mov edx, dword ptr [edx + field_c]           # 004643e7
    mov dword ptr [eax + field_c], edx           # 004643ea
    jmp.d32 L_00464537                           # 004643ed
L_004643f2:
    # block 0x004643f2: entered by je at 0x004643a2; je at 0x004643b3, 4 instruction(s), ends with je to 0x00464452 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004643f2
    mov ecx, dword ptr [ebp - local_14]          # 004643f6
    cmp dword ptr [ecx + 4*eax + field_98], 0x0  # 004643f9
    je.d8 L_00464452                             # 00464401
    # block 0x00464403: entered by fall-through of je at 0x00464401, 4 instruction(s), ends with je to 0x00464452 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00464403
    mov eax, dword ptr [ebp - local_14]          # 00464407
    cmp dword ptr [eax + 4*edx + field_98], 0x0  # 0046440a
    je.d8 L_00464452                             # 00464412
    # block 0x00464414: entered by fall-through of je at 0x00464412, 16 instruction(s), ends with forward jump to 0x00464537
    mov ecx, dword ptr [ebp - local_14]          # 00464414
    movsx edx, word ptr [ecx + field_8a]         # 00464417
    imul edx, edx, 0x90                          # 0046441e
    mov eax, dword ptr [ebp - local_10]          # 00464424
    lea ecx, [eax + edx + field_161]             # 00464427
    mov edx, dword ptr [ebp - local_14]          # 0046442e
    add edx, 0xa8                                # 00464431
    mov eax, dword ptr [ecx]                     # 00464437
    mov dword ptr [edx], eax                     # 00464439
    mov eax, dword ptr [ecx + field_4]           # 0046443b
    mov dword ptr [edx + field_4], eax           # 0046443e
    mov eax, dword ptr [ecx + field_8]           # 00464441
    mov dword ptr [edx + field_8], eax           # 00464444
    mov ecx, dword ptr [ecx + field_c]           # 00464447
    mov dword ptr [edx + field_c], ecx           # 0046444a
    jmp.d32 L_00464537                           # 0046444d
L_00464452:
    # block 0x00464452: entered by je at 0x00464401; je at 0x00464412, 4 instruction(s), ends with je to 0x004644a1 (forward)
    movsx edx, word ptr [ebp - local_c]          # 00464452
    mov eax, dword ptr [ebp - local_14]          # 00464456
    cmp dword ptr [eax + 4*edx + field_98], 0x0  # 00464459
    je.d8 L_004644a1                             # 00464461
    # block 0x00464463: entered by fall-through of je at 0x00464461, 16 instruction(s), ends with forward jump to 0x00464537
    mov ecx, dword ptr [ebp - local_14]          # 00464463
    movsx edx, word ptr [ecx + field_8a]         # 00464466
    imul edx, edx, 0x90                          # 0046446d
    mov eax, dword ptr [ebp - local_10]          # 00464473
    lea ecx, [eax + edx + field_121]             # 00464476
    mov edx, dword ptr [ebp - local_14]          # 0046447d
    add edx, 0xa8                                # 00464480
    mov eax, dword ptr [ecx]                     # 00464486
    mov dword ptr [edx], eax                     # 00464488
    mov eax, dword ptr [ecx + field_4]           # 0046448a
    mov dword ptr [edx + field_4], eax           # 0046448d
    mov eax, dword ptr [ecx + field_8]           # 00464490
    mov dword ptr [edx + field_8], eax           # 00464493
    mov ecx, dword ptr [ecx + field_c]           # 00464496
    mov dword ptr [edx + field_c], ecx           # 00464499
    jmp.d32 L_00464537                           # 0046449c
L_004644a1:
    # block 0x004644a1: entered by je at 0x00464461, 4 instruction(s), ends with je to 0x004644ed (forward)
    movsx edx, word ptr [ebp - local_4]          # 004644a1
    mov eax, dword ptr [ebp - local_14]          # 004644a5
    cmp dword ptr [eax + 4*edx + field_98], 0x0  # 004644a8
    je.d8 L_004644ed                             # 004644b0
    # block 0x004644b2: entered by fall-through of je at 0x004644b0, 16 instruction(s), ends with forward jump to 0x00464537
    mov ecx, dword ptr [ebp - local_14]          # 004644b2
    movsx edx, word ptr [ecx + field_8a]         # 004644b5
    imul edx, edx, 0x90                          # 004644bc
    mov eax, dword ptr [ebp - local_10]          # 004644c2
    lea ecx, [eax + edx + field_131]             # 004644c5
    mov edx, dword ptr [ebp - local_14]          # 004644cc
    add edx, 0xa8                                # 004644cf
    mov eax, dword ptr [ecx]                     # 004644d5
    mov dword ptr [edx], eax                     # 004644d7
    mov eax, dword ptr [ecx + field_4]           # 004644d9
    mov dword ptr [edx + field_4], eax           # 004644dc
    mov eax, dword ptr [ecx + field_8]           # 004644df
    mov dword ptr [edx + field_8], eax           # 004644e2
    mov ecx, dword ptr [ecx + field_c]           # 004644e5
    mov dword ptr [edx + field_c], ecx           # 004644e8
    jmp.d8 L_00464537                            # 004644eb
L_004644ed:
    # block 0x004644ed: entered by je at 0x004644b0, 4 instruction(s), ends with je to 0x00464537 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004644ed
    mov eax, dword ptr [ebp - local_14]          # 004644f1
    cmp dword ptr [eax + 4*edx + field_98], 0x0  # 004644f4
    je.d8 L_00464537                             # 004644fc
    # block 0x004644fe: entered by fall-through of je at 0x004644fc, 15 instruction(s), falls into the block at 0x00464537
    mov ecx, dword ptr [ebp - local_14]          # 004644fe
    movsx edx, word ptr [ecx + field_8a]         # 00464501
    imul edx, edx, 0x90                          # 00464508
    mov eax, dword ptr [ebp - local_10]          # 0046450e
    lea ecx, [eax + edx + field_141]             # 00464511
    mov edx, dword ptr [ebp - local_14]          # 00464518
    add edx, 0xa8                                # 0046451b
    mov eax, dword ptr [ecx]                     # 00464521
    mov dword ptr [edx], eax                     # 00464523
    mov eax, dword ptr [ecx + field_4]           # 00464525
    mov dword ptr [edx + field_4], eax           # 00464528
    mov eax, dword ptr [ecx + field_8]           # 0046452b
    mov dword ptr [edx + field_8], eax           # 0046452e
    mov ecx, dword ptr [ecx + field_c]           # 00464531
    mov dword ptr [edx + field_c], ecx           # 00464534
L_00464537:
    # block 0x00464537: entered by jmp at 0x00464235; jmp at 0x0046427e; jmp at 0x004642d3; jmp at 0x0046438e; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00464537
    pop ebp                                      # 00464539
    ret                                          # 0046453a

