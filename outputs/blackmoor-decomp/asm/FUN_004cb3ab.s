# FUN_004cb3ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cb3ab
# extent:       0x004cb3ab-0x004cb586 (475 code bytes)
# span:         0x004cb3ab-0x004cb586 (code 475, tables 0, padding 0)
# sha256:       da3fefcf655fa56e0f65469e029f17b2833668ce865d5bb9a76f7751c73b8aca
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cb3ab_store_flag
# naming:       native port src/original_methods_fl24a.c:m4cb3ab_store_flag (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4cb3ab_store_flag (two arms, flag-table store, cdecl 50ca3e and 44a2b7). Unicorn differential and oracle: every instruction reached. See tasks/fl24a-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2, field_5, field_e, field_12, field_14, field_16, field_1a, field_23, field_158, field_15c; [ecx + n] field_2, field_5, field_12, field_1a, field_23, field_154, field_158; [edx + n] field_2, field_12, field_14, field_16, field_14e, field_154, field_158
# callees:      calls FUN_0050ca3e, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24a.c:m4cb3ab_store_flag (function ledger class native_oracle_verified; also store_flag_and_print; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 126 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ field_5, 0x5  # offset +0x5
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_23, 0x23  # offset +0x23
.equ field_14e, 0x14e  # offset +0x14e
.equ field_154, 0x154  # offset +0x154
.equ field_158, 0x158  # offset +0x158
.equ field_15c, 0x15c  # offset +0x15c

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004cb3ab - 0x401000
.globl FUN_004cb3ab
FUN_004cb3ab:
    # block 0x004cb3ab: entry, 7 instruction(s), ends with je to 0x004cb582 (forward)
    push ebp                                     # 004cb3ab
    {load} mov ebp, esp                          # 004cb3ac
    push ecx                                     # 004cb3ae
    mov dword ptr [ebp - local_4], ecx           # 004cb3af
    mov eax, dword ptr [ebp - local_4]           # 004cb3b2
    cmp dword ptr [eax + field_e], 0x0           # 004cb3b5
    je.d32 L_004cb582                            # 004cb3b9
    # block 0x004cb3bf: entered by fall-through of je at 0x004cb3b9, 3 instruction(s), ends with je to 0x004cb582 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cb3bf
    cmp dword ptr [ecx + field_12], 0x0          # 004cb3c2
    je.d32 L_004cb582                            # 004cb3c6
    # block 0x004cb3cc: entered by fall-through of je at 0x004cb3c6, 3 instruction(s), ends with je to 0x004cb582 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb3cc
    cmp dword ptr [edx + field_16], 0x0          # 004cb3cf
    je.d32 L_004cb582                            # 004cb3d3
    # block 0x004cb3d9: entered by fall-through of je at 0x004cb3d3, 3 instruction(s), ends with je to 0x004cb582 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cb3d9
    cmp dword ptr [eax + field_15c], 0x0         # 004cb3dc
    je.d32 L_004cb582                            # 004cb3e3
    # block 0x004cb3e9: entered by fall-through of je at 0x004cb3e3, 3 instruction(s), ends with je to 0x004cb4bb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cb3e9
    cmp dword ptr [ecx + field_154], 0x0         # 004cb3ec
    je.d32 L_004cb4bb                            # 004cb3f3
    # block 0x004cb3f9: entered by fall-through of je at 0x004cb3f3, 5 instruction(s), ends with je to 0x004cb4b6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb3f9
    mov eax, dword ptr [edx + field_154]         # 004cb3fc
    movsx ecx, word ptr [eax + field_14]         # 004cb402
    cmp ecx, -0x1                                # 004cb406
    je.d32 L_004cb4b6                            # 004cb409
    # block 0x004cb40f: entered by fall-through of je at 0x004cb409, 13 instruction(s), ends with je to 0x004cb4b6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb40f
    mov eax, dword ptr [edx + field_16]          # 004cb412
    mov ecx, dword ptr [ebp - local_4]           # 004cb415
    mov edx, dword ptr [ecx + field_154]         # 004cb418
    movsx ecx, word ptr [edx + field_14]         # 004cb41e
    lea edx, [eax + 4*ecx + field_23]            # 004cb422
    mov eax, dword ptr [ebp - local_4]           # 004cb426
    mov dword ptr [eax + field_158], edx         # 004cb429
    mov ecx, dword ptr [ebp - local_4]           # 004cb42f
    mov edx, dword ptr [ecx + field_158]         # 004cb432
    movsx eax, word ptr [edx]                    # 004cb438
    cmp eax, -0x1                                # 004cb43b
    je.d8 L_004cb4b6                             # 004cb43e
    # block 0x004cb440: entered by fall-through of je at 0x004cb43e, 10 instruction(s), ends with je to 0x004cb4b6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cb440
    mov edx, dword ptr [ecx + field_158]         # 004cb443
    movsx eax, word ptr [edx + field_2]          # 004cb449
    mov ecx, dword ptr [ebp - local_4]           # 004cb44d
    mov edx, dword ptr [ecx + field_158]         # 004cb450
    movsx ecx, word ptr [edx]                    # 004cb456
    mov dword ptr [4*ecx + 0x585801], eax        # 004cb459
    movsx edx, word ptr [0x63a4cd]               # 004cb460
    test edx, edx                                # 004cb467
    je.d8 L_004cb4b6                             # 004cb469
    # block 0x004cb46b: entered by fall-through of je at 0x004cb469, 22 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004cb4b6
    mov eax, dword ptr [ebp - local_4]           # 004cb46b
    mov ecx, dword ptr [eax + field_1a]          # 004cb46e
    push ecx                                     # 004cb471
    mov edx, dword ptr [ebp - local_4]           # 004cb472
    mov eax, dword ptr [edx + field_12]          # 004cb475
    movsx ecx, word ptr [eax]                    # 004cb478
    push ecx                                     # 004cb47b
    mov edx, dword ptr [ebp - local_4]           # 004cb47c
    mov eax, dword ptr [edx + field_158]         # 004cb47f
    movsx ecx, word ptr [eax + field_2]          # 004cb485
    push ecx                                     # 004cb489
    mov edx, dword ptr [ebp - local_4]           # 004cb48a
    mov eax, dword ptr [edx + field_158]         # 004cb48d
    movsx ecx, word ptr [eax]                    # 004cb493
    push ecx                                     # 004cb496
    push 0x558b50                                # 004cb497
    push 0x63888b                                # 004cb49c
    call FUN_0050ca3e                            # 004cb4a1
    add esp, 0x18                                # 004cb4a6
    push 0x63888b                                # 004cb4a9
    call FUN_0044a2b7                            # 004cb4ae
    add esp, 0x4                                 # 004cb4b3
L_004cb4b6:
    # block 0x004cb4b6: entered by je at 0x004cb409; je at 0x004cb43e; je at 0x004cb469, 1 instruction(s), ends with forward jump to 0x004cb582
    jmp.d32 L_004cb582                           # 004cb4b6
L_004cb4bb:
    # block 0x004cb4bb: entered by je at 0x004cb3f3, 3 instruction(s), ends with je to 0x004cb582 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb4bb
    cmp dword ptr [edx + field_14e], 0x0         # 004cb4be
    je.d32 L_004cb582                            # 004cb4c5
    # block 0x004cb4cb: entered by fall-through of je at 0x004cb4c5, 5 instruction(s), ends with je to 0x004cb582 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cb4cb
    mov ecx, dword ptr [eax + field_12]          # 004cb4ce
    movsx edx, word ptr [ecx + field_5]          # 004cb4d1
    cmp edx, -0x1                                # 004cb4d5
    je.d32 L_004cb582                            # 004cb4d8
    # block 0x004cb4de: entered by fall-through of je at 0x004cb4d8, 13 instruction(s), ends with je to 0x004cb582 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cb4de
    mov ecx, dword ptr [eax + field_16]          # 004cb4e1
    mov edx, dword ptr [ebp - local_4]           # 004cb4e4
    mov eax, dword ptr [edx + field_12]          # 004cb4e7
    movsx edx, word ptr [eax + field_5]          # 004cb4ea
    lea eax, [ecx + 4*edx + field_23]            # 004cb4ee
    mov ecx, dword ptr [ebp - local_4]           # 004cb4f2
    mov dword ptr [ecx + field_158], eax         # 004cb4f5
    mov edx, dword ptr [ebp - local_4]           # 004cb4fb
    mov eax, dword ptr [edx + field_158]         # 004cb4fe
    movsx ecx, word ptr [eax]                    # 004cb504
    cmp ecx, -0x1                                # 004cb507
    je.d8 L_004cb582                             # 004cb50a
    # block 0x004cb50c: entered by fall-through of je at 0x004cb50a, 10 instruction(s), ends with je to 0x004cb582 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cb50c
    mov eax, dword ptr [edx + field_158]         # 004cb50f
    movsx ecx, word ptr [eax + field_2]          # 004cb515
    mov edx, dword ptr [ebp - local_4]           # 004cb519
    mov eax, dword ptr [edx + field_158]         # 004cb51c
    movsx edx, word ptr [eax]                    # 004cb522
    mov dword ptr [4*edx + 0x585801], ecx        # 004cb525
    movsx eax, word ptr [0x63a4cd]               # 004cb52c
    test eax, eax                                # 004cb533
    je.d8 L_004cb582                             # 004cb535
    # block 0x004cb537: entered by fall-through of je at 0x004cb535, 22 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004cb582
    mov ecx, dword ptr [ebp - local_4]           # 004cb537
    mov edx, dword ptr [ecx + field_1a]          # 004cb53a
    push edx                                     # 004cb53d
    mov eax, dword ptr [ebp - local_4]           # 004cb53e
    mov ecx, dword ptr [eax + field_12]          # 004cb541
    movsx edx, word ptr [ecx]                    # 004cb544
    push edx                                     # 004cb547
    mov eax, dword ptr [ebp - local_4]           # 004cb548
    mov ecx, dword ptr [eax + field_158]         # 004cb54b
    movsx edx, word ptr [ecx + field_2]          # 004cb551
    push edx                                     # 004cb555
    mov eax, dword ptr [ebp - local_4]           # 004cb556
    mov ecx, dword ptr [eax + field_158]         # 004cb559
    movsx edx, word ptr [ecx]                    # 004cb55f
    push edx                                     # 004cb562
    push 0x558bbc                                # 004cb563
    push 0x63888b                                # 004cb568
    call FUN_0050ca3e                            # 004cb56d
    add esp, 0x18                                # 004cb572
    push 0x63888b                                # 004cb575
    call FUN_0044a2b7                            # 004cb57a
    add esp, 0x4                                 # 004cb57f
L_004cb582:
    # block 0x004cb582: entered by je at 0x004cb3b9; je at 0x004cb3c6; je at 0x004cb3d3; je at 0x004cb3e3; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cb582
    pop ebp                                      # 004cb584
    ret                                          # 004cb585

