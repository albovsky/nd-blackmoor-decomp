# FUN_004911ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004911ca
# extent:       0x004911ca-0x00491422 (600 code bytes)
# span:         0x004911ca-0x00491422 (code 600, tables 0, padding 0)
# sha256:       2f6efb01b866190257a4c79dc60cd8020e8670d548ee87121dc6552bdf21283c
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4911ca_lifted
# naming:       native port src/original_methods_fl39d.c:m4911ca_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (18 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_1f3f, field_1f4b, field_1f57, field_1f63; [ecx + n] field_1f3f, field_1f4f, field_1f5b, field_1f67; [edx + n] field_1f3f, field_1f47, field_1f53, field_1f5f
# callees:      calls FUN_0051dc43, FUN_0052139c, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4911ca_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 169 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_1f3f, 0x1f3f  # offset +0x1f3f
.equ field_1f47, 0x1f47  # offset +0x1f47
.equ field_1f4b, 0x1f4b  # offset +0x1f4b
.equ field_1f4f, 0x1f4f  # offset +0x1f4f
.equ field_1f53, 0x1f53  # offset +0x1f53
.equ field_1f57, 0x1f57  # offset +0x1f57
.equ field_1f5b, 0x1f5b  # offset +0x1f5b
.equ field_1f5f, 0x1f5f  # offset +0x1f5f
.equ field_1f63, 0x1f63  # offset +0x1f63
.equ field_1f67, 0x1f67  # offset +0x1f67

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004911ca - 0x401000
.globl FUN_004911ca
FUN_004911ca:
    # block 0x004911ca: entry, 16 instruction(s), calls FUN_0051dc43, ends with jne to 0x00491215 (forward)
    push ebp                                     # 004911ca
    {load} mov ebp, esp                          # 004911cb
    sub esp, 0x28                                # 004911cd
    mov dword ptr [ebp - local_28], ecx          # 004911d0
    mov eax, dword ptr [ebp - local_28]          # 004911d3
    mov ecx, dword ptr [eax + field_1f3f]        # 004911d6
    shl ecx, 0x2                                 # 004911dc
    push ecx                                     # 004911df
    call FUN_0051dc43                            # 004911e0
    add esp, 0x4                                 # 004911e5
    mov dword ptr [ebp - local_4], eax           # 004911e8
    mov edx, dword ptr [ebp - local_28]          # 004911eb
    mov eax, dword ptr [ebp - local_4]           # 004911ee
    mov dword ptr [edx + field_1f47], eax        # 004911f1
    cmp dword ptr [ebp - local_4], 0x0           # 004911f7
    jne.d8 L_00491215                            # 004911fb
    # block 0x004911fd: entered by fall-through of jne at 0x004911fb, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x00491215
    push 0x0                                     # 004911fd
    push 0x0                                     # 004911ff
    push 0x54ea90                                # 00491201
    call FUN_0052139c                            # 00491206
    mov ecx, 0x5cf659                            # 0049120b
    call FUN_004c97b4                            # 00491210
L_00491215:
    # block 0x00491215: entered by jne at 0x004911fb, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x00491256 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00491215
    mov edx, dword ptr [ecx + field_1f3f]        # 00491218
    shl edx                                      # 0049121e
    push edx                                     # 00491220
    call FUN_0051dc43                            # 00491221
    add esp, 0x4                                 # 00491226
    mov dword ptr [ebp - local_8], eax           # 00491229
    mov eax, dword ptr [ebp - local_28]          # 0049122c
    mov ecx, dword ptr [ebp - local_8]           # 0049122f
    mov dword ptr [eax + field_1f4b], ecx        # 00491232
    cmp dword ptr [ebp - local_8], 0x0           # 00491238
    jne.d8 L_00491256                            # 0049123c
    # block 0x0049123e: entered by fall-through of jne at 0x0049123c, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x00491256
    push 0x0                                     # 0049123e
    push 0x0                                     # 00491240
    push 0x54ead8                                # 00491242
    call FUN_0052139c                            # 00491247
    mov ecx, 0x5cf659                            # 0049124c
    call FUN_004c97b4                            # 00491251
L_00491256:
    # block 0x00491256: entered by jne at 0x0049123c, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x00491297 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00491256
    mov eax, dword ptr [edx + field_1f3f]        # 00491259
    shl eax                                      # 0049125f
    push eax                                     # 00491261
    call FUN_0051dc43                            # 00491262
    add esp, 0x4                                 # 00491267
    mov dword ptr [ebp - local_c], eax           # 0049126a
    mov ecx, dword ptr [ebp - local_28]          # 0049126d
    mov edx, dword ptr [ebp - local_c]           # 00491270
    mov dword ptr [ecx + field_1f4f], edx        # 00491273
    cmp dword ptr [ebp - local_c], 0x0           # 00491279
    jne.d8 L_00491297                            # 0049127d
    # block 0x0049127f: entered by fall-through of jne at 0x0049127d, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x00491297
    push 0x0                                     # 0049127f
    push 0x0                                     # 00491281
    push 0x54eb20                                # 00491283
    call FUN_0052139c                            # 00491288
    mov ecx, 0x5cf659                            # 0049128d
    call FUN_004c97b4                            # 00491292
L_00491297:
    # block 0x00491297: entered by jne at 0x0049127d, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x004912d9 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00491297
    mov ecx, dword ptr [eax + field_1f3f]        # 0049129a
    shl ecx, 0x2                                 # 004912a0
    push ecx                                     # 004912a3
    call FUN_0051dc43                            # 004912a4
    add esp, 0x4                                 # 004912a9
    mov dword ptr [ebp - local_10], eax          # 004912ac
    mov edx, dword ptr [ebp - local_28]          # 004912af
    mov eax, dword ptr [ebp - local_10]          # 004912b2
    mov dword ptr [edx + field_1f53], eax        # 004912b5
    cmp dword ptr [ebp - local_10], 0x0          # 004912bb
    jne.d8 L_004912d9                            # 004912bf
    # block 0x004912c1: entered by fall-through of jne at 0x004912bf, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004912d9
    push 0x0                                     # 004912c1
    push 0x0                                     # 004912c3
    push 0x54eb68                                # 004912c5
    call FUN_0052139c                            # 004912ca
    mov ecx, 0x5cf659                            # 004912cf
    call FUN_004c97b4                            # 004912d4
L_004912d9:
    # block 0x004912d9: entered by jne at 0x004912bf, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049131a (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004912d9
    mov edx, dword ptr [ecx + field_1f3f]        # 004912dc
    shl edx                                      # 004912e2
    push edx                                     # 004912e4
    call FUN_0051dc43                            # 004912e5
    add esp, 0x4                                 # 004912ea
    mov dword ptr [ebp - local_14], eax          # 004912ed
    mov eax, dword ptr [ebp - local_28]          # 004912f0
    mov ecx, dword ptr [ebp - local_14]          # 004912f3
    mov dword ptr [eax + field_1f57], ecx        # 004912f6
    cmp dword ptr [ebp - local_14], 0x0          # 004912fc
    jne.d8 L_0049131a                            # 00491300
    # block 0x00491302: entered by fall-through of jne at 0x00491300, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049131a
    push 0x0                                     # 00491302
    push 0x0                                     # 00491304
    push 0x54ebb0                                # 00491306
    call FUN_0052139c                            # 0049130b
    mov ecx, 0x5cf659                            # 00491310
    call FUN_004c97b4                            # 00491315
L_0049131a:
    # block 0x0049131a: entered by jne at 0x00491300, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049135b (forward)
    mov edx, dword ptr [ebp - local_28]          # 0049131a
    mov eax, dword ptr [edx + field_1f3f]        # 0049131d
    shl eax                                      # 00491323
    push eax                                     # 00491325
    call FUN_0051dc43                            # 00491326
    add esp, 0x4                                 # 0049132b
    mov dword ptr [ebp - local_18], eax          # 0049132e
    mov ecx, dword ptr [ebp - local_28]          # 00491331
    mov edx, dword ptr [ebp - local_18]          # 00491334
    mov dword ptr [ecx + field_1f5b], edx        # 00491337
    cmp dword ptr [ebp - local_18], 0x0          # 0049133d
    jne.d8 L_0049135b                            # 00491341
    # block 0x00491343: entered by fall-through of jne at 0x00491341, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049135b
    push 0x0                                     # 00491343
    push 0x0                                     # 00491345
    push 0x54ebfc                                # 00491347
    call FUN_0052139c                            # 0049134c
    mov ecx, 0x5cf659                            # 00491351
    call FUN_004c97b4                            # 00491356
L_0049135b:
    # block 0x0049135b: entered by jne at 0x00491341, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049139c (forward)
    mov eax, dword ptr [ebp - local_28]          # 0049135b
    mov ecx, dword ptr [eax + field_1f3f]        # 0049135e
    shl ecx                                      # 00491364
    push ecx                                     # 00491366
    call FUN_0051dc43                            # 00491367
    add esp, 0x4                                 # 0049136c
    mov dword ptr [ebp - local_1c], eax          # 0049136f
    mov edx, dword ptr [ebp - local_28]          # 00491372
    mov eax, dword ptr [ebp - local_1c]          # 00491375
    mov dword ptr [edx + field_1f5f], eax        # 00491378
    cmp dword ptr [ebp - local_1c], 0x0          # 0049137e
    jne.d8 L_0049139c                            # 00491382
    # block 0x00491384: entered by fall-through of jne at 0x00491382, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049139c
    push 0x0                                     # 00491384
    push 0x0                                     # 00491386
    push 0x54ec4c                                # 00491388
    call FUN_0052139c                            # 0049138d
    mov ecx, 0x5cf659                            # 00491392
    call FUN_004c97b4                            # 00491397
L_0049139c:
    # block 0x0049139c: entered by jne at 0x00491382, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x004913dd (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0049139c
    mov edx, dword ptr [ecx + field_1f3f]        # 0049139f
    shl edx                                      # 004913a5
    push edx                                     # 004913a7
    call FUN_0051dc43                            # 004913a8
    add esp, 0x4                                 # 004913ad
    mov dword ptr [ebp - local_20], eax          # 004913b0
    mov eax, dword ptr [ebp - local_28]          # 004913b3
    mov ecx, dword ptr [ebp - local_20]          # 004913b6
    mov dword ptr [eax + field_1f63], ecx        # 004913b9
    cmp dword ptr [ebp - local_20], 0x0          # 004913bf
    jne.d8 L_004913dd                            # 004913c3
    # block 0x004913c5: entered by fall-through of jne at 0x004913c3, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004913dd
    push 0x0                                     # 004913c5
    push 0x0                                     # 004913c7
    push 0x54eca0                                # 004913c9
    call FUN_0052139c                            # 004913ce
    mov ecx, 0x5cf659                            # 004913d3
    call FUN_004c97b4                            # 004913d8
L_004913dd:
    # block 0x004913dd: entered by jne at 0x004913c3, 12 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049141e (forward)
    mov edx, dword ptr [ebp - local_28]          # 004913dd
    mov eax, dword ptr [edx + field_1f3f]        # 004913e0
    shl eax                                      # 004913e6
    push eax                                     # 004913e8
    call FUN_0051dc43                            # 004913e9
    add esp, 0x4                                 # 004913ee
    mov dword ptr [ebp - local_24], eax          # 004913f1
    mov ecx, dword ptr [ebp - local_28]          # 004913f4
    mov edx, dword ptr [ebp - local_24]          # 004913f7
    mov dword ptr [ecx + field_1f67], edx        # 004913fa
    cmp dword ptr [ebp - local_24], 0x0          # 00491400
    jne.d8 L_0049141e                            # 00491404
    # block 0x00491406: entered by fall-through of jne at 0x00491404, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049141e
    push 0x0                                     # 00491406
    push 0x0                                     # 00491408
    push 0x54ecf8                                # 0049140a
    call FUN_0052139c                            # 0049140f
    mov ecx, 0x5cf659                            # 00491414
    call FUN_004c97b4                            # 00491419
L_0049141e:
    # block 0x0049141e: entered by jne at 0x00491404, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0049141e
    pop ebp                                      # 00491420
    ret                                          # 00491421

