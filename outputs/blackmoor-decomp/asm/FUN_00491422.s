# FUN_00491422
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00491422
# extent:       0x00491422-0x004915e8 (454 code bytes)
# span:         0x00491422-0x004915e8 (code 454, tables 0, padding 0)
# sha256:       13e4711d83238fa52800ac6ddcd3566f6279eac6606f4b93cc4743d59fdbeec3
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m491422_lifted
# naming:       native port src/original_methods_fl39d.c:m491422_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (37 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_1f47, field_1f4b, field_1f53, field_1f57, field_1f5f, field_1f63; [ecx + n] field_1f47, field_1f4f, field_1f53, field_1f5b, field_1f5f, field_1f67; [edx + n] field_1f4b, field_1f4f, field_1f57, field_1f5b, field_1f63, field_1f67
# callees:      calls FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m491422_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 115 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00491422 - 0x401000
.globl FUN_00491422
FUN_00491422:
    # block 0x00491422: entry, 7 instruction(s), ends with je to 0x0049145c (forward)
    push ebp                                     # 00491422
    {load} mov ebp, esp                          # 00491423
    sub esp, 0x28                                # 00491425
    mov dword ptr [ebp - local_28], ecx          # 00491428
    mov eax, dword ptr [ebp - local_28]          # 0049142b
    cmp dword ptr [eax + field_1f47], 0x0        # 0049142e
    je.d8 L_0049145c                             # 00491435
    # block 0x00491437: entered by fall-through of je at 0x00491435, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049145c
    mov ecx, dword ptr [ebp - local_28]          # 00491437
    mov edx, dword ptr [ecx + field_1f47]        # 0049143a
    mov dword ptr [ebp - local_4], edx           # 00491440
    mov eax, dword ptr [ebp - local_4]           # 00491443
    push eax                                     # 00491446
    call FUN_0051dc6c                            # 00491447
    add esp, 0x4                                 # 0049144c
    mov ecx, dword ptr [ebp - local_28]          # 0049144f
    mov dword ptr [ecx + field_1f47], 0x0        # 00491452
L_0049145c:
    # block 0x0049145c: entered by je at 0x00491435, 3 instruction(s), ends with je to 0x0049148d (forward)
    mov edx, dword ptr [ebp - local_28]          # 0049145c
    cmp dword ptr [edx + field_1f4b], 0x0        # 0049145f
    je.d8 L_0049148d                             # 00491466
    # block 0x00491468: entered by fall-through of je at 0x00491466, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049148d
    mov eax, dword ptr [ebp - local_28]          # 00491468
    mov ecx, dword ptr [eax + field_1f4b]        # 0049146b
    mov dword ptr [ebp - local_8], ecx           # 00491471
    mov edx, dword ptr [ebp - local_8]           # 00491474
    push edx                                     # 00491477
    call FUN_0051dc6c                            # 00491478
    add esp, 0x4                                 # 0049147d
    mov eax, dword ptr [ebp - local_28]          # 00491480
    mov dword ptr [eax + field_1f4b], 0x0        # 00491483
L_0049148d:
    # block 0x0049148d: entered by je at 0x00491466, 3 instruction(s), ends with je to 0x004914be (forward)
    mov ecx, dword ptr [ebp - local_28]          # 0049148d
    cmp dword ptr [ecx + field_1f4f], 0x0        # 00491490
    je.d8 L_004914be                             # 00491497
    # block 0x00491499: entered by fall-through of je at 0x00491497, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004914be
    mov edx, dword ptr [ebp - local_28]          # 00491499
    mov eax, dword ptr [edx + field_1f4f]        # 0049149c
    mov dword ptr [ebp - local_c], eax           # 004914a2
    mov ecx, dword ptr [ebp - local_c]           # 004914a5
    push ecx                                     # 004914a8
    call FUN_0051dc6c                            # 004914a9
    add esp, 0x4                                 # 004914ae
    mov edx, dword ptr [ebp - local_28]          # 004914b1
    mov dword ptr [edx + field_1f4f], 0x0        # 004914b4
L_004914be:
    # block 0x004914be: entered by je at 0x00491497, 3 instruction(s), ends with je to 0x004914ef (forward)
    mov eax, dword ptr [ebp - local_28]          # 004914be
    cmp dword ptr [eax + field_1f53], 0x0        # 004914c1
    je.d8 L_004914ef                             # 004914c8
    # block 0x004914ca: entered by fall-through of je at 0x004914c8, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004914ef
    mov ecx, dword ptr [ebp - local_28]          # 004914ca
    mov edx, dword ptr [ecx + field_1f53]        # 004914cd
    mov dword ptr [ebp - local_10], edx          # 004914d3
    mov eax, dword ptr [ebp - local_10]          # 004914d6
    push eax                                     # 004914d9
    call FUN_0051dc6c                            # 004914da
    add esp, 0x4                                 # 004914df
    mov ecx, dword ptr [ebp - local_28]          # 004914e2
    mov dword ptr [ecx + field_1f53], 0x0        # 004914e5
L_004914ef:
    # block 0x004914ef: entered by je at 0x004914c8, 3 instruction(s), ends with je to 0x00491520 (forward)
    mov edx, dword ptr [ebp - local_28]          # 004914ef
    cmp dword ptr [edx + field_1f57], 0x0        # 004914f2
    je.d8 L_00491520                             # 004914f9
    # block 0x004914fb: entered by fall-through of je at 0x004914f9, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00491520
    mov eax, dword ptr [ebp - local_28]          # 004914fb
    mov ecx, dword ptr [eax + field_1f57]        # 004914fe
    mov dword ptr [ebp - local_14], ecx          # 00491504
    mov edx, dword ptr [ebp - local_14]          # 00491507
    push edx                                     # 0049150a
    call FUN_0051dc6c                            # 0049150b
    add esp, 0x4                                 # 00491510
    mov eax, dword ptr [ebp - local_28]          # 00491513
    mov dword ptr [eax + field_1f57], 0x0        # 00491516
L_00491520:
    # block 0x00491520: entered by je at 0x004914f9, 3 instruction(s), ends with je to 0x00491551 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 00491520
    cmp dword ptr [ecx + field_1f5b], 0x0        # 00491523
    je.d8 L_00491551                             # 0049152a
    # block 0x0049152c: entered by fall-through of je at 0x0049152a, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00491551
    mov edx, dword ptr [ebp - local_28]          # 0049152c
    mov eax, dword ptr [edx + field_1f5b]        # 0049152f
    mov dword ptr [ebp - local_18], eax          # 00491535
    mov ecx, dword ptr [ebp - local_18]          # 00491538
    push ecx                                     # 0049153b
    call FUN_0051dc6c                            # 0049153c
    add esp, 0x4                                 # 00491541
    mov edx, dword ptr [ebp - local_28]          # 00491544
    mov dword ptr [edx + field_1f5b], 0x0        # 00491547
L_00491551:
    # block 0x00491551: entered by je at 0x0049152a, 3 instruction(s), ends with je to 0x00491582 (forward)
    mov eax, dword ptr [ebp - local_28]          # 00491551
    cmp dword ptr [eax + field_1f5f], 0x0        # 00491554
    je.d8 L_00491582                             # 0049155b
    # block 0x0049155d: entered by fall-through of je at 0x0049155b, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00491582
    mov ecx, dword ptr [ebp - local_28]          # 0049155d
    mov edx, dword ptr [ecx + field_1f5f]        # 00491560
    mov dword ptr [ebp - local_1c], edx          # 00491566
    mov eax, dword ptr [ebp - local_1c]          # 00491569
    push eax                                     # 0049156c
    call FUN_0051dc6c                            # 0049156d
    add esp, 0x4                                 # 00491572
    mov ecx, dword ptr [ebp - local_28]          # 00491575
    mov dword ptr [ecx + field_1f5f], 0x0        # 00491578
L_00491582:
    # block 0x00491582: entered by je at 0x0049155b, 3 instruction(s), ends with je to 0x004915b3 (forward)
    mov edx, dword ptr [ebp - local_28]          # 00491582
    cmp dword ptr [edx + field_1f63], 0x0        # 00491585
    je.d8 L_004915b3                             # 0049158c
    # block 0x0049158e: entered by fall-through of je at 0x0049158c, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004915b3
    mov eax, dword ptr [ebp - local_28]          # 0049158e
    mov ecx, dword ptr [eax + field_1f63]        # 00491591
    mov dword ptr [ebp - local_20], ecx          # 00491597
    mov edx, dword ptr [ebp - local_20]          # 0049159a
    push edx                                     # 0049159d
    call FUN_0051dc6c                            # 0049159e
    add esp, 0x4                                 # 004915a3
    mov eax, dword ptr [ebp - local_28]          # 004915a6
    mov dword ptr [eax + field_1f63], 0x0        # 004915a9
L_004915b3:
    # block 0x004915b3: entered by je at 0x0049158c, 3 instruction(s), ends with je to 0x004915e4 (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004915b3
    cmp dword ptr [ecx + field_1f67], 0x0        # 004915b6
    je.d8 L_004915e4                             # 004915bd
    # block 0x004915bf: entered by fall-through of je at 0x004915bd, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004915e4
    mov edx, dword ptr [ebp - local_28]          # 004915bf
    mov eax, dword ptr [edx + field_1f67]        # 004915c2
    mov dword ptr [ebp - local_24], eax          # 004915c8
    mov ecx, dword ptr [ebp - local_24]          # 004915cb
    push ecx                                     # 004915ce
    call FUN_0051dc6c                            # 004915cf
    add esp, 0x4                                 # 004915d4
    mov edx, dword ptr [ebp - local_28]          # 004915d7
    mov dword ptr [edx + field_1f67], 0x0        # 004915da
L_004915e4:
    # block 0x004915e4: entered by je at 0x004915bd, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004915e4
    pop ebp                                      # 004915e6
    ret                                          # 004915e7

