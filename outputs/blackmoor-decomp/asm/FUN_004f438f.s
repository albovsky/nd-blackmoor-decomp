# FUN_004f438f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f438f
# extent:       0x004f438f-0x004f4b9f (2064 code bytes)
# span:         0x004f438f-0x004f4b9f (code 2064, tables 0, padding 0)
# sha256:       b1167ae55dfc13c0917c9490128c18f070a90987661048c2c40afb9c6e4aa04a
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_his_streaming_sound_path
# naming:       INFERRED (lower confidence, not verified): the repository text his-audio-recovery.md:14 says "otherwise the streaming path at `0x4f438f`"; src/live_audio.c:43 says "loader (0x4f438f) with stream_state"
# name-note:    Streaming load path (16-chunk ring) for larger HIS sounds.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_15e, field_28f, field_293, field_297, field_29b, field_2a7, field_2b7, field_2d7 and 3 more; [ecx + n] field_4, field_8, field_c, field_144, field_15e, field_28f, field_293, field_297, field_29b, field_2a3, field_2b3, field_2d3 and 6 more; [edx + n] field_4, field_8, field_c, field_10, field_116, field_122, field_126, field_156, field_28f, field_293, field_297, field_29f and 5 more; [esi + n] field_2ba
# callees:      calls FUN_004f5f69, FUN_004f356e, FUN_0050ca3e, FUN_0044a2b7, FUN_004f95a4, FUN_0051dc43, FUN_004fdb90, FUN_0052139c, FUN_004f594d, KERNEL32.dll!GetTickCount, FUN_004f684a; plus 5 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36a.c:m4f379c_open_entry (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 526 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_116, 0x116  # offset +0x116
.equ field_122, 0x122  # offset +0x122
.equ field_126, 0x126  # offset +0x126
.equ field_144, 0x144  # offset +0x144
.equ field_156, 0x156  # offset +0x156
.equ field_15e, 0x15e  # offset +0x15e
.equ field_28f, 0x28f  # offset +0x28f
.equ field_293, 0x293  # offset +0x293
.equ field_297, 0x297  # offset +0x297
.equ field_29b, 0x29b  # offset +0x29b
.equ field_29f, 0x29f  # offset +0x29f
.equ field_2a3, 0x2a3  # offset +0x2a3
.equ field_2a7, 0x2a7  # offset +0x2a7
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_2af, 0x2af  # offset +0x2af
.equ field_2b3, 0x2b3  # offset +0x2b3
.equ field_2b7, 0x2b7  # offset +0x2b7
.equ field_2ba, 0x2ba  # offset +0x2ba
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_2db, 0x2db  # offset +0x2db
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_5af, 0x5af  # offset +0x5af

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f356e, .text + (0x004f356e - 0x401000)
.set FUN_004f594d, .text + (0x004f594d - 0x401000)
.set FUN_004f5f69, .text + (0x004f5f69 - 0x401000)
.set FUN_004f684a, .text + (0x004f684a - 0x401000)
.set FUN_004f95a4, .text + (0x004f95a4 - 0x401000)
.set FUN_004fdb90, .text + (0x004fdb90 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004f438f - 0x401000
.globl FUN_004f438f
FUN_004f438f:
    # block 0x004f438f: entry, 43 instruction(s), ends with je to 0x004f4470 (forward)
    push ebp                                     # 004f438f
    {load} mov ebp, esp                          # 004f4390
    sub esp, 0x1c                                # 004f4392
    push esi                                     # 004f4395
    push edi                                     # 004f4396
    mov dword ptr [ebp - local_1c], ecx          # 004f4397
    mov eax, dword ptr [ebp - local_1c]          # 004f439a
    mov dword ptr [eax + field_3be], 0x1         # 004f439d
    mov ecx, dword ptr [ebp - local_1c]          # 004f43a7
    mov dword ptr [ecx + field_3c2], 0x3e8       # 004f43aa
    mov edx, dword ptr [ebp - local_1c]          # 004f43b4
    mov dword ptr [edx + field_3ca], 0x0         # 004f43b7
    mov eax, dword ptr [ebp + arg_8]             # 004f43c1
    and eax, 0xffff                              # 004f43c4
    imul eax, eax, 0x5bb                         # 004f43c9
    mov ecx, dword ptr [ebp - local_1c]          # 004f43cf
    mov edx, dword ptr [ecx + field_3ce]         # 004f43d2
    {load} add edx, eax                          # 004f43d8
    mov dword ptr [ebp - local_14], edx          # 004f43da
    mov eax, dword ptr [ebp - local_14]          # 004f43dd
    add eax, 0x18a                               # 004f43e0
    mov dword ptr [ebp - local_4], eax           # 004f43e5
    mov ecx, dword ptr [ebp - local_14]          # 004f43e8
    mov edx, dword ptr [ebp - local_14]          # 004f43eb
    mov ax, word ptr [edx + field_116]           # 004f43ee
    mov word ptr [ecx + field_144], ax           # 004f43f5
    mov ecx, dword ptr [ebp - local_4]           # 004f43fc
    mov dword ptr [ecx], 0x0                     # 004f43ff
    mov edx, dword ptr [ebp - local_4]           # 004f4405
    mov dword ptr [edx + field_4], 0x0           # 004f4408
    mov eax, dword ptr [ebp - local_4]           # 004f440f
    mov dword ptr [eax + field_8], 0x0           # 004f4412
    mov ecx, dword ptr [ebp - local_14]          # 004f4419
    mov edx, dword ptr [ebp - local_14]          # 004f441c
    mov eax, dword ptr [edx + field_122]         # 004f441f
    mov dword ptr [ecx + field_15e], eax         # 004f4425
    mov ecx, dword ptr [ebp - local_4]           # 004f442b
    mov dword ptr [ecx + field_c], 0x0           # 004f442e
    mov edx, dword ptr [ebp - local_4]           # 004f4435
    mov dword ptr [edx + field_10], 0x0          # 004f4438
    mov eax, dword ptr [ebp - local_14]          # 004f443f
    cmp dword ptr [eax + field_293], 0x0         # 004f4442
    je.d8 L_004f4470                             # 004f4449
    # block 0x004f444b: entered by fall-through of je at 0x004f4449, 9 instruction(s), calls indirect dword ptr [eax + 0x8], falls into the block at 0x004f4470
    mov ecx, dword ptr [ebp - local_14]          # 004f444b
    mov edx, dword ptr [ecx + field_293]         # 004f444e
    mov eax, dword ptr [ebp - local_14]          # 004f4454
    mov ecx, dword ptr [eax + field_293]         # 004f4457
    mov eax, dword ptr [ecx]                     # 004f445d
    push edx                                     # 004f445f
    call dword ptr [eax + field_8]               # 004f4460
    mov ecx, dword ptr [ebp - local_14]          # 004f4463
    mov dword ptr [ecx + field_293], 0x0         # 004f4466
L_004f4470:
    # block 0x004f4470: entered by je at 0x004f4449, 46 instruction(s), calls FUN_004f5f69, ends with jne to 0x004f454f (forward)
    {load} xor edx, edx                          # 004f4470
    mov eax, dword ptr [ebp - local_1c]          # 004f4472
    add eax, 0x288                               # 004f4475
    mov dword ptr [eax], edx                     # 004f447a
    mov dword ptr [eax + field_4], edx           # 004f447c
    mov dword ptr [eax + field_8], edx           # 004f447f
    mov dword ptr [eax + field_c], edx           # 004f4482
    mov word ptr [eax + field_10], dx            # 004f4485
    mov ecx, dword ptr [ebp - local_14]          # 004f4489
    add ecx, 0x112                               # 004f448c
    mov edx, dword ptr [ebp - local_1c]          # 004f4492
    add edx, 0x288                               # 004f4495
    mov eax, dword ptr [ecx]                     # 004f449b
    mov dword ptr [edx], eax                     # 004f449d
    mov eax, dword ptr [ecx + field_4]           # 004f449f
    mov dword ptr [edx + field_4], eax           # 004f44a2
    mov eax, dword ptr [ecx + field_8]           # 004f44a5
    mov dword ptr [edx + field_8], eax           # 004f44a8
    mov ecx, dword ptr [ecx + field_c]           # 004f44ab
    mov dword ptr [edx + field_c], ecx           # 004f44ae
    mov edx, dword ptr [ebp - local_1c]          # 004f44b1
    add edx, 0x288                               # 004f44b4
    mov eax, dword ptr [ebp - local_14]          # 004f44ba
    add eax, 0x2df                               # 004f44bd
    mov ecx, dword ptr [edx]                     # 004f44c2
    mov dword ptr [eax], ecx                     # 004f44c4
    mov ecx, dword ptr [edx + field_4]           # 004f44c6
    mov dword ptr [eax + field_4], ecx           # 004f44c9
    mov ecx, dword ptr [edx + field_8]           # 004f44cc
    mov dword ptr [eax + field_8], ecx           # 004f44cf
    mov ecx, dword ptr [edx + field_c]           # 004f44d2
    mov dword ptr [eax + field_c], ecx           # 004f44d5
    mov dx, word ptr [edx + field_10]            # 004f44d8
    mov word ptr [eax + field_10], dx            # 004f44dc
    mov eax, dword ptr [ebp - local_1c]          # 004f44e0
    add eax, 0x288                               # 004f44e3
    push eax                                     # 004f44e8
    push 0x301b8                                 # 004f44e9
    push 0x56220                                 # 004f44ee
    mov ecx, dword ptr [ebp - local_14]          # 004f44f3
    add ecx, 0x28f                               # 004f44f6
    push ecx                                     # 004f44fc
    mov ecx, dword ptr [ebp - local_1c]          # 004f44fd
    call FUN_004f5f69                            # 004f4500
    test eax, eax                                # 004f4505
    jne.d8 L_004f454f                            # 004f4507
    # block 0x004f4509: entered by fall-through of jne at 0x004f4507, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4b97
    mov edx, dword ptr [ebp - local_14]          # 004f4509
    mov dword ptr [edx + field_28f], 0x0         # 004f450c
    mov eax, dword ptr [ebp + arg_8]             # 004f4516
    and eax, 0xffff                              # 004f4519
    push eax                                     # 004f451e
    mov ecx, dword ptr [ebp - local_1c]          # 004f451f
    call FUN_004f356e                            # 004f4522
    mov ecx, dword ptr [ebp - local_1c]          # 004f4527
    mov dword ptr [ecx + field_3c2], 0x404       # 004f452a
    mov edx, dword ptr [ebp - local_1c]          # 004f4534
    mov dword ptr [edx + field_3be], 0x0         # 004f4537
    mov eax, dword ptr [ebp - local_1c]          # 004f4541
    mov eax, dword ptr [eax + field_3be]         # 004f4544
    jmp.d32 L_004f4b97                           # 004f454a
L_004f454f:
    # block 0x004f454f: entered by jne at 0x004f4507, 3 instruction(s), ends with je to 0x004f4599 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f454f
    test ecx, ecx                                # 004f4556
    je.d8 L_004f4599                             # 004f4558
    # block 0x004f455a: entered by fall-through of je at 0x004f4558, 17 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f4599
    mov edx, dword ptr [ebp - local_14]          # 004f455a
    add edx, 0x4                                 # 004f455d
    push edx                                     # 004f4560
    mov eax, dword ptr [ebp - local_14]          # 004f4561
    mov ecx, dword ptr [eax + field_15e]         # 004f4564
    push ecx                                     # 004f456a
    mov edx, dword ptr [ebp + arg_8]             # 004f456b
    and edx, 0xffff                              # 004f456e
    push edx                                     # 004f4574
    push 0x56220                                 # 004f4575
    push 0x55ddf4                                # 004f457a
    push 0x63888b                                # 004f457f
    call FUN_0050ca3e                            # 004f4584
    add esp, 0x18                                # 004f4589
    push 0x63888b                                # 004f458c
    call FUN_0044a2b7                            # 004f4591
    add esp, 0x4                                 # 004f4596
L_004f4599:
    # block 0x004f4599: entered by je at 0x004f4558, 16 instruction(s), calls indirect dword ptr [eax], ends with je to 0x004f461a (forward)
    mov eax, dword ptr [ebp - local_14]          # 004f4599
    add eax, 0x29b                               # 004f459c
    push eax                                     # 004f45a1
    push 0x52e53c                                # 004f45a2
    mov ecx, dword ptr [ebp - local_14]          # 004f45a7
    mov edx, dword ptr [ecx + field_28f]         # 004f45aa
    mov eax, dword ptr [ebp - local_14]          # 004f45b0
    mov ecx, dword ptr [eax + field_28f]         # 004f45b3
    mov eax, dword ptr [ecx]                     # 004f45b9
    push edx                                     # 004f45bb
    call dword ptr [eax]                         # 004f45bc
    mov ecx, dword ptr [ebp - local_1c]          # 004f45be
    mov dword ptr [ecx + field_3ca], eax         # 004f45c1
    mov edx, dword ptr [ebp - local_1c]          # 004f45c7
    cmp dword ptr [edx + field_3ca], 0x0         # 004f45ca
    je.d8 L_004f461a                             # 004f45d1
    # block 0x004f45d3: entered by fall-through of je at 0x004f45d1, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4b97
    mov eax, dword ptr [ebp - local_14]          # 004f45d3
    mov dword ptr [eax + field_29b], 0x0         # 004f45d6
    mov ecx, dword ptr [ebp + arg_8]             # 004f45e0
    and ecx, 0xffff                              # 004f45e3
    push ecx                                     # 004f45e9
    mov ecx, dword ptr [ebp - local_1c]          # 004f45ea
    call FUN_004f356e                            # 004f45ed
    mov edx, dword ptr [ebp - local_1c]          # 004f45f2
    mov dword ptr [edx + field_3c2], 0x417       # 004f45f5
    mov eax, dword ptr [ebp - local_1c]          # 004f45ff
    mov dword ptr [eax + field_3be], 0x0         # 004f4602
    mov ecx, dword ptr [ebp - local_1c]          # 004f460c
    mov eax, dword ptr [ecx + field_3be]         # 004f460f
    jmp.d32 L_004f4b97                           # 004f4615
L_004f461a:
    # block 0x004f461a: entered by je at 0x004f45d1, 3 instruction(s), ends with je to 0x004f4655 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004f461a
    test edx, edx                                # 004f4621
    je.d8 L_004f4655                             # 004f4623
    # block 0x004f4625: entered by fall-through of je at 0x004f4623, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f4655
    mov eax, dword ptr [ebp - local_14]          # 004f4625
    add eax, 0x4                                 # 004f4628
    push eax                                     # 004f462b
    mov ecx, dword ptr [ebp + arg_8]             # 004f462c
    and ecx, 0xffff                              # 004f462f
    push ecx                                     # 004f4635
    push 0x55de5c                                # 004f4636
    push 0x63888b                                # 004f463b
    call FUN_0050ca3e                            # 004f4640
    add esp, 0x10                                # 004f4645
    push 0x63888b                                # 004f4648
    call FUN_0044a2b7                            # 004f464d
    add esp, 0x4                                 # 004f4652
L_004f4655:
    # block 0x004f4655: entered by je at 0x004f4623, 22 instruction(s), calls indirect dword ptr [eax + 0xc], ends with je to 0x004f46d2 (forward)
    mov ecx, 0x10                                # 004f4655
    {load} xor eax, eax                          # 004f465a
    mov edi, dword ptr [ebp - local_14]          # 004f465c
    add edi, 0x29f                               # 004f465f
    rep stosd dword ptr es:[edi], eax            # 004f4665
    mov edx, dword ptr [ebp - local_14]          # 004f4667
    mov dword ptr [edx + field_29f], 0x40        # 004f466a
    mov eax, dword ptr [ebp - local_14]          # 004f4674
    add eax, 0x29f                               # 004f4677
    push eax                                     # 004f467c
    mov ecx, dword ptr [ebp - local_14]          # 004f467d
    mov edx, dword ptr [ecx + field_29b]         # 004f4680
    mov eax, dword ptr [ebp - local_14]          # 004f4686
    mov ecx, dword ptr [eax + field_29b]         # 004f4689
    mov eax, dword ptr [ecx]                     # 004f468f
    push edx                                     # 004f4691
    call dword ptr [eax + field_c]               # 004f4692
    mov ecx, dword ptr [ebp - local_1c]          # 004f4695
    mov dword ptr [ecx + field_3ca], eax         # 004f4698
    mov edx, dword ptr [ebp - local_1c]          # 004f469e
    cmp dword ptr [edx + field_3ca], 0x0         # 004f46a1
    je.d8 L_004f46d2                             # 004f46a8
    # block 0x004f46aa: entered by fall-through of je at 0x004f46a8, 7 instruction(s), ends with forward jump to 0x004f4b97
    mov eax, dword ptr [ebp - local_1c]          # 004f46aa
    mov dword ptr [eax + field_3c2], 0x418       # 004f46ad
    mov ecx, dword ptr [ebp - local_1c]          # 004f46b7
    mov dword ptr [ecx + field_3be], 0x0         # 004f46ba
    mov edx, dword ptr [ebp - local_1c]          # 004f46c4
    mov eax, dword ptr [edx + field_3be]         # 004f46c7
    jmp.d32 L_004f4b97                           # 004f46cd
L_004f46d2:
    # block 0x004f46d2: entered by je at 0x004f46a8, 8 instruction(s), calls FUN_004f95a4, ends with je to 0x004f47ee (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f46d2
    and eax, 0xffff                              # 004f46d5
    push eax                                     # 004f46da
    mov ecx, dword ptr [ebp - local_1c]          # 004f46db
    call FUN_004f95a4                            # 004f46de
    movsx ecx, word ptr [0x63a4cd]               # 004f46e3
    test ecx, ecx                                # 004f46ea
    je.d32 L_004f47ee                            # 004f46ec
    # block 0x004f46f2: entered by fall-through of je at 0x004f46ec, 65 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f47ee
    mov edx, dword ptr [ebp - local_14]          # 004f46f2
    fld dword ptr [edx + field_2ab]              # 004f46f5
    sub esp, 0x8                                 # 004f46fb
    fstp qword ptr [esp]                         # 004f46fe
    mov eax, dword ptr [ebp - local_14]          # 004f4701
    fld dword ptr [eax + field_2a7]              # 004f4704
    sub esp, 0x8                                 # 004f470a
    fstp qword ptr [esp]                         # 004f470d
    mov ecx, dword ptr [ebp - local_14]          # 004f4710
    fld dword ptr [ecx + field_2a3]              # 004f4713
    sub esp, 0x8                                 # 004f4719
    fstp qword ptr [esp]                         # 004f471c
    mov edx, dword ptr [ebp + arg_8]             # 004f471f
    and edx, 0xffff                              # 004f4722
    push edx                                     # 004f4728
    push 0x55deac                                # 004f4729
    push 0x63888b                                # 004f472e
    call FUN_0050ca3e                            # 004f4733
    add esp, 0x24                                # 004f4738
    push 0x63888b                                # 004f473b
    call FUN_0044a2b7                            # 004f4740
    add esp, 0x4                                 # 004f4745
    mov eax, dword ptr [ebp - local_14]          # 004f4748
    fld dword ptr [eax + field_2b7]              # 004f474b
    sub esp, 0x8                                 # 004f4751
    fstp qword ptr [esp]                         # 004f4754
    mov ecx, dword ptr [ebp - local_14]          # 004f4757
    fld dword ptr [ecx + field_2b3]              # 004f475a
    sub esp, 0x8                                 # 004f4760
    fstp qword ptr [esp]                         # 004f4763
    mov edx, dword ptr [ebp - local_14]          # 004f4766
    fld dword ptr [edx + field_2af]              # 004f4769
    sub esp, 0x8                                 # 004f476f
    fstp qword ptr [esp]                         # 004f4772
    mov eax, dword ptr [ebp + arg_8]             # 004f4775
    and eax, 0xffff                              # 004f4778
    push eax                                     # 004f477d
    push 0x55df18                                # 004f477e
    push 0x63888b                                # 004f4783
    call FUN_0050ca3e                            # 004f4788
    add esp, 0x24                                # 004f478d
    push 0x63888b                                # 004f4790
    call FUN_0044a2b7                            # 004f4795
    add esp, 0x4                                 # 004f479a
    mov ecx, dword ptr [ebp - local_14]          # 004f479d
    mov edx, dword ptr [ecx + field_2db]         # 004f47a0
    push edx                                     # 004f47a6
    mov eax, dword ptr [ebp - local_14]          # 004f47a7
    fld dword ptr [eax + field_2d7]              # 004f47aa
    sub esp, 0x8                                 # 004f47b0
    fstp qword ptr [esp]                         # 004f47b3
    mov ecx, dword ptr [ebp - local_14]          # 004f47b6
    fld dword ptr [ecx + field_2d3]              # 004f47b9
    sub esp, 0x8                                 # 004f47bf
    fstp qword ptr [esp]                         # 004f47c2
    mov edx, dword ptr [ebp + arg_8]             # 004f47c5
    and edx, 0xffff                              # 004f47c8
    push edx                                     # 004f47ce
    push 0x55df84                                # 004f47cf
    push 0x63888b                                # 004f47d4
    call FUN_0050ca3e                            # 004f47d9
    add esp, 0x20                                # 004f47de
    push 0x63888b                                # 004f47e1
    call FUN_0044a2b7                            # 004f47e6
    add esp, 0x4                                 # 004f47eb
L_004f47ee:
    # block 0x004f47ee: entered by je at 0x004f46ec, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x004f4856 (forward)
    push 0x90                                    # 004f47ee
    call FUN_0051dc43                            # 004f47f3
    add esp, 0x4                                 # 004f47f8
    mov dword ptr [ebp - local_18], eax          # 004f47fb
    mov eax, dword ptr [ebp - local_14]          # 004f47fe
    mov ecx, dword ptr [ebp - local_18]          # 004f4801
    mov dword ptr [eax + field_297], ecx         # 004f4804
    cmp dword ptr [ebp - local_18], 0x0          # 004f480a
    jne.d8 L_004f4856                            # 004f480e
    # block 0x004f4810: entered by fall-through of jne at 0x004f480e, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4b97
    mov edx, dword ptr [ebp - local_14]          # 004f4810
    mov dword ptr [edx + field_297], 0x0         # 004f4813
    mov eax, dword ptr [ebp + arg_8]             # 004f481d
    and eax, 0xffff                              # 004f4820
    push eax                                     # 004f4825
    mov ecx, dword ptr [ebp - local_1c]          # 004f4826
    call FUN_004f356e                            # 004f4829
    mov ecx, dword ptr [ebp - local_1c]          # 004f482e
    mov dword ptr [ecx + field_3c2], 0x3ee       # 004f4831
    mov edx, dword ptr [ebp - local_1c]          # 004f483b
    mov dword ptr [edx + field_3be], 0x0         # 004f483e
    mov eax, dword ptr [ebp - local_1c]          # 004f4848
    mov eax, dword ptr [eax + field_3be]         # 004f484b
    jmp.d32 L_004f4b97                           # 004f4851
L_004f4856:
    # block 0x004f4856: entered by jne at 0x004f480e, 7 instruction(s), ends with forward jump to 0x004f4888
    mov ecx, dword ptr [ebp + arg_8]             # 004f4856
    and ecx, 0xffff                              # 004f4859
    shl ecx                                      # 004f485f
    mov dword ptr [ebp - local_10], ecx          # 004f4861
    mov dword ptr [ebp - local_c], 0x5621        # 004f4864
    mov dword ptr [ebp - local_8], 0x0           # 004f486b
    jmp.d8 L_004f4888                            # 004f4872
L_004f4874:
    # block 0x004f4874: entered by jmp at 0x004f48bd, 6 instruction(s), falls into the block at 0x004f4888
    mov edx, dword ptr [ebp - local_8]           # 004f4874
    add edx, 0x1                                 # 004f4877
    mov dword ptr [ebp - local_8], edx           # 004f487a
    mov eax, dword ptr [ebp - local_c]           # 004f487d
    add eax, 0x5622                              # 004f4880
    mov dword ptr [ebp - local_c], eax           # 004f4885
L_004f4888:
    # block 0x004f4888: entered by jmp at 0x004f4872, 2 instruction(s), ends with jge to 0x004f48bf (forward)
    cmp dword ptr [ebp - local_8], 0x10          # 004f4888
    jge.d8 L_004f48bf                            # 004f488c
    # block 0x004f488e: entered by fall-through of jge at 0x004f488c, 13 instruction(s), ends with backward jump to 0x004f4874
    mov ecx, dword ptr [ebp - local_14]          # 004f488e
    mov edx, dword ptr [ecx + field_297]         # 004f4891
    mov eax, dword ptr [ebp - local_8]           # 004f4897
    mov ecx, dword ptr [ebp - local_c]           # 004f489a
    mov dword ptr [edx + 8*eax], ecx             # 004f489d
    mov edx, dword ptr [ebp - local_14]          # 004f48a0
    mov eax, dword ptr [edx + field_297]         # 004f48a3
    mov ecx, dword ptr [ebp - local_8]           # 004f48a9
    mov edx, dword ptr [ebp - local_10]          # 004f48ac
    mov esi, dword ptr [ebp - local_1c]          # 004f48af
    mov edx, dword ptr [esi + 4*edx + field_2ba] # 004f48b2
    mov dword ptr [eax + 8*ecx + field_4], edx   # 004f48b9
    jmp.d8 L_004f4874                            # 004f48bd
L_004f48bf:
    # block 0x004f48bf: entered by jge at 0x004f488c, 19 instruction(s), ends with je to 0x004f4936 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004f48bf
    mov eax, dword ptr [eax + field_15e]         # 004f48c2
    cdq                                          # 004f48c8
    mov ecx, 0x56220                             # 004f48c9
    idiv ecx                                     # 004f48ce
    mov eax, dword ptr [ebp - local_14]          # 004f48d0
    mov ecx, dword ptr [eax + field_297]         # 004f48d3
    mov eax, dword ptr [ebp - local_8]           # 004f48d9
    mov dword ptr [ecx + 8*eax], edx             # 004f48dc
    mov ecx, dword ptr [ebp - local_14]          # 004f48df
    mov edx, dword ptr [ecx + field_297]         # 004f48e2
    mov eax, dword ptr [ebp - local_8]           # 004f48e8
    mov ecx, dword ptr [ebp - local_10]          # 004f48eb
    mov esi, dword ptr [ebp - local_1c]          # 004f48ee
    mov ecx, dword ptr [esi + 4*ecx + field_2ba] # 004f48f1
    mov dword ptr [edx + 8*eax + field_4], ecx   # 004f48f8
    movsx edx, word ptr [0x63a4cd]               # 004f48fc
    test edx, edx                                # 004f4903
    je.d8 L_004f4936                             # 004f4905
    # block 0x004f4907: entered by fall-through of je at 0x004f4905, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f4936
    mov eax, dword ptr [ebp - local_14]          # 004f4907
    mov ecx, dword ptr [eax + field_297]         # 004f490a
    mov edx, dword ptr [ebp - local_8]           # 004f4910
    mov eax, dword ptr [ecx + 8*edx]             # 004f4913
    push eax                                     # 004f4916
    push 0x55dffc                                # 004f4917
    push 0x63888b                                # 004f491c
    call FUN_0050ca3e                            # 004f4921
    add esp, 0xc                                 # 004f4926
    push 0x63888b                                # 004f4929
    call FUN_0044a2b7                            # 004f492e
    add esp, 0x4                                 # 004f4933
L_004f4936:
    # block 0x004f4936: entered by je at 0x004f4905, 17 instruction(s), ends with je to 0x004f4988 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004f4936
    add ecx, 0x1                                 # 004f4939
    mov dword ptr [ebp - local_10], ecx          # 004f493c
    mov edx, dword ptr [ebp - local_14]          # 004f493f
    mov eax, dword ptr [edx + field_297]         # 004f4942
    mov ecx, dword ptr [ebp - local_8]           # 004f4948
    mov dword ptr [eax + 8*ecx + field_8], 0xffffffff # 004f494b
    mov edx, dword ptr [ebp - local_14]          # 004f4953
    mov eax, dword ptr [edx + field_297]         # 004f4956
    mov ecx, dword ptr [ebp - local_8]           # 004f495c
    mov edx, dword ptr [ebp - local_10]          # 004f495f
    mov esi, dword ptr [ebp - local_1c]          # 004f4962
    mov edx, dword ptr [esi + 4*edx + field_2ba] # 004f4965
    mov dword ptr [eax + 8*ecx + field_c], edx   # 004f496c
    movsx eax, word ptr [0x63a4cd]               # 004f4970
    test eax, eax                                # 004f4977
    je.d8 L_004f4988                             # 004f4979
    # block 0x004f497b: entered by fall-through of je at 0x004f4979, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f4988
    push 0x55e03c                                # 004f497b
    call FUN_0044a2b7                            # 004f4980
    add esp, 0x4                                 # 004f4985
L_004f4988:
    # block 0x004f4988: entered by je at 0x004f4979, 16 instruction(s), calls indirect dword ptr [ecx], ends with je to 0x004f4a0a (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004f4988
    add ecx, 0x293                               # 004f498b
    push ecx                                     # 004f4991
    push 0x52e52c                                # 004f4992
    mov edx, dword ptr [ebp - local_14]          # 004f4997
    mov eax, dword ptr [edx + field_28f]         # 004f499a
    mov ecx, dword ptr [ebp - local_14]          # 004f49a0
    mov edx, dword ptr [ecx + field_28f]         # 004f49a3
    mov ecx, dword ptr [edx]                     # 004f49a9
    push eax                                     # 004f49ab
    call dword ptr [ecx]                         # 004f49ac
    mov edx, dword ptr [ebp - local_1c]          # 004f49ae
    mov dword ptr [edx + field_3ca], eax         # 004f49b1
    mov eax, dword ptr [ebp - local_1c]          # 004f49b7
    cmp dword ptr [eax + field_3ca], 0x0         # 004f49ba
    je.d8 L_004f4a0a                             # 004f49c1
    # block 0x004f49c3: entered by fall-through of je at 0x004f49c1, 14 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4b97
    mov ecx, dword ptr [ebp - local_14]          # 004f49c3
    mov dword ptr [ecx + field_293], 0x0         # 004f49c6
    mov edx, dword ptr [ebp + arg_8]             # 004f49d0
    and edx, 0xffff                              # 004f49d3
    push edx                                     # 004f49d9
    mov ecx, dword ptr [ebp - local_1c]          # 004f49da
    call FUN_004f356e                            # 004f49dd
    mov eax, dword ptr [ebp - local_1c]          # 004f49e2
    mov dword ptr [eax + field_3c2], 0x412       # 004f49e5
    mov ecx, dword ptr [ebp - local_1c]          # 004f49ef
    mov dword ptr [ecx + field_3be], 0x0         # 004f49f2
    mov edx, dword ptr [ebp - local_1c]          # 004f49fc
    mov eax, dword ptr [edx + field_3be]         # 004f49ff
    jmp.d32 L_004f4b97                           # 004f4a05
L_004f4a0a:
    # block 0x004f4a0a: entered by je at 0x004f49c1, 16 instruction(s), calls indirect dword ptr [ecx + 0xc], ends with je to 0x004f4a7d (forward)
    mov eax, dword ptr [ebp - local_14]          # 004f4a0a
    mov ecx, dword ptr [eax + field_297]         # 004f4a0d
    push ecx                                     # 004f4a13
    push 0x12                                    # 004f4a14
    mov edx, dword ptr [ebp - local_14]          # 004f4a16
    mov eax, dword ptr [edx + field_293]         # 004f4a19
    mov ecx, dword ptr [ebp - local_14]          # 004f4a1f
    mov edx, dword ptr [ecx + field_293]         # 004f4a22
    mov ecx, dword ptr [edx]                     # 004f4a28
    push eax                                     # 004f4a2a
    call dword ptr [ecx + field_c]               # 004f4a2b
    mov edx, dword ptr [ebp - local_1c]          # 004f4a2e
    mov dword ptr [edx + field_3ca], eax         # 004f4a31
    mov eax, dword ptr [ebp - local_1c]          # 004f4a37
    cmp dword ptr [eax + field_3ca], 0x0         # 004f4a3a
    je.d8 L_004f4a7d                             # 004f4a41
    # block 0x004f4a43: entered by fall-through of je at 0x004f4a41, 12 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4b97
    mov ecx, dword ptr [ebp + arg_8]             # 004f4a43
    and ecx, 0xffff                              # 004f4a46
    push ecx                                     # 004f4a4c
    mov ecx, dword ptr [ebp - local_1c]          # 004f4a4d
    call FUN_004f356e                            # 004f4a50
    mov edx, dword ptr [ebp - local_1c]          # 004f4a55
    mov dword ptr [edx + field_3c2], 0x414       # 004f4a58
    mov eax, dword ptr [ebp - local_1c]          # 004f4a62
    mov dword ptr [eax + field_3be], 0x0         # 004f4a65
    mov ecx, dword ptr [ebp - local_1c]          # 004f4a6f
    mov eax, dword ptr [ecx + field_3be]         # 004f4a72
    jmp.d32 L_004f4b97                           # 004f4a78
L_004f4a7d:
    # block 0x004f4a7d: entered by je at 0x004f4a41, 3 instruction(s), ends with je to 0x004f4ab8 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004f4a7d
    test edx, edx                                # 004f4a84
    je.d8 L_004f4ab8                             # 004f4a86
    # block 0x004f4a88: entered by fall-through of je at 0x004f4a86, 13 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f4ab8
    mov eax, dword ptr [ebp - local_14]          # 004f4a88
    add eax, 0x4                                 # 004f4a8b
    push eax                                     # 004f4a8e
    mov ecx, dword ptr [ebp + arg_8]             # 004f4a8f
    and ecx, 0xffff                              # 004f4a92
    push ecx                                     # 004f4a98
    push 0x55e09c                                # 004f4a99
    push 0x63888b                                # 004f4a9e
    call FUN_0050ca3e                            # 004f4aa3
    add esp, 0x10                                # 004f4aa8
    push 0x63888b                                # 004f4aab
    call FUN_0044a2b7                            # 004f4ab0
    add esp, 0x4                                 # 004f4ab5
L_004f4ab8:
    # block 0x004f4ab8: entered by je at 0x004f4a86, 4 instruction(s), ends with jne to 0x004f4b33 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004f4ab8
    movsx eax, word ptr [edx + field_126]        # 004f4abb
    cmp eax, 0x2                                 # 004f4ac2
    jne.d8 L_004f4b33                            # 004f4ac5
    # block 0x004f4ac7: entered by fall-through of jne at 0x004f4ac5, 12 instruction(s), calls FUN_004fdb90, ends with jge to 0x004f4b33 (forward)
    push 0x0                                     # 004f4ac7
    push 0x0                                     # 004f4ac9
    mov ecx, dword ptr [ebp - local_14]          # 004f4acb
    add ecx, 0x2f1                               # 004f4ace
    push ecx                                     # 004f4ad4
    mov edx, dword ptr [ebp - local_14]          # 004f4ad5
    mov eax, dword ptr [edx + field_156]         # 004f4ad8
    push eax                                     # 004f4ade
    call FUN_004fdb90                            # 004f4adf
    add esp, 0x10                                # 004f4ae4
    test eax, eax                                # 004f4ae7
    jge.d8 L_004f4b33                            # 004f4ae9
    # block 0x004f4aeb: entered by fall-through of jge at 0x004f4ae9, 8 instruction(s), calls FUN_004f356e, ends with je to 0x004f4b2f (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004f4aeb
    and ecx, 0xffff                              # 004f4aee
    push ecx                                     # 004f4af4
    mov ecx, dword ptr [ebp - local_1c]          # 004f4af5
    call FUN_004f356e                            # 004f4af8
    movsx edx, word ptr [0x63a4cd]               # 004f4afd
    test edx, edx                                # 004f4b04
    je.d8 L_004f4b2f                             # 004f4b06
    # block 0x004f4b08: entered by fall-through of je at 0x004f4b06, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, falls into the block at 0x004f4b2f
    mov eax, dword ptr [ebp - local_14]          # 004f4b08
    add eax, 0x4                                 # 004f4b0b
    push eax                                     # 004f4b0e
    push 0x55e0fc                                # 004f4b0f
    push 0x63888b                                # 004f4b14
    call FUN_0050ca3e                            # 004f4b19
    add esp, 0xc                                 # 004f4b1e
    push 0x0                                     # 004f4b21
    push 0x0                                     # 004f4b23
    push 0x63888b                                # 004f4b25
    call FUN_0052139c                            # 004f4b2a
L_004f4b2f:
    # block 0x004f4b2f: entered by je at 0x004f4b06, 2 instruction(s), ends with forward jump to 0x004f4b97
    {load} xor eax, eax                          # 004f4b2f
    jmp.d8 L_004f4b97                            # 004f4b31
L_004f4b33:
    # block 0x004f4b33: entered by jne at 0x004f4ac5; jge at 0x004f4ae9, 9 instruction(s), calls FUN_004f594d, ends with jne to 0x004f4b66 (forward)
    push 0x56220                                 # 004f4b33
    push 0x0                                     # 004f4b38
    mov ecx, dword ptr [ebp + arg_8]             # 004f4b3a
    and ecx, 0xffff                              # 004f4b3d
    push ecx                                     # 004f4b43
    mov ecx, dword ptr [ebp - local_1c]          # 004f4b44
    call FUN_004f594d                            # 004f4b47
    test eax, eax                                # 004f4b4c
    jne.d8 L_004f4b66                            # 004f4b4e
    # block 0x004f4b50: entered by fall-through of jne at 0x004f4b4e, 7 instruction(s), calls FUN_004f356e, ends with forward jump to 0x004f4b97
    mov edx, dword ptr [ebp + arg_8]             # 004f4b50
    and edx, 0xffff                              # 004f4b53
    push edx                                     # 004f4b59
    mov ecx, dword ptr [ebp - local_1c]          # 004f4b5a
    call FUN_004f356e                            # 004f4b5d
    {load} xor eax, eax                          # 004f4b62
    jmp.d8 L_004f4b97                            # 004f4b64
L_004f4b66:
    # block 0x004f4b66: entered by jne at 0x004f4b4e, 3 instruction(s), ends with je to 0x004f4b80 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f4b66
    test eax, eax                                # 004f4b6d
    je.d8 L_004f4b80                             # 004f4b6f
    # block 0x004f4b71: entered by fall-through of je at 0x004f4b6f, 3 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004f4b80
    call dword ptr [0x52a23c]                    # 004f4b71
    mov ecx, dword ptr [ebp - local_14]          # 004f4b77
    mov dword ptr [ecx + field_5af], eax         # 004f4b7a
L_004f4b80:
    # block 0x004f4b80: entered by je at 0x004f4b6f, 6 instruction(s), calls FUN_004f684a, falls into the block at 0x004f4b97
    mov edx, dword ptr [ebp + arg_8]             # 004f4b80
    and edx, 0xffff                              # 004f4b83
    push edx                                     # 004f4b89
    mov ecx, dword ptr [ebp - local_1c]          # 004f4b8a
    call FUN_004f684a                            # 004f4b8d
    mov eax, 0x1                                 # 004f4b92
L_004f4b97:
    # block 0x004f4b97: entered by jmp at 0x004f454a; jmp at 0x004f4615; jmp at 0x004f46cd; jmp at 0x004f4851; more, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004f4b97
    pop esi                                      # 004f4b98
    {load} mov esp, ebp                          # 004f4b99
    pop ebp                                      # 004f4b9b
    ret 0x4                                      # 004f4b9c

