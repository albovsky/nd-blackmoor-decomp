# FUN_00463392
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00463392
# extent:       0x00463392-0x00463aec (1882 code bytes)
# span:         0x00463392-0x00463b00 (code 1882, tables 20, padding 0)
# sha256:       330d5e9ae87e73fdcba5653a3ce5c8b0d8f0fb1ff52180d78deae802ea3096e1
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m463392_step_scene
# naming:       native port src/original_methods_fl22a.c:m463392_step_scene (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m463392_step_scene (states 0-2, five-arm jump table in direct test). Direct: objects, ordered calls, probes. Unicorn differential: 600 fixtures, 456/456 instructions. Window covers all 1882 bytes. Details: tasks/fl22a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1c, field_1e, field_24, field_39, field_3b, field_3f, field_4f, field_57, field_d8, field_2a1, field_2d2, field_2e2 and 8 more; [ecx + n] field_1c, field_1e, field_20, field_21, field_43, field_47, field_4b, field_53, field_57, field_5b, field_d0, field_dc and 10 more; [edx + n] field_4, field_8, field_c, field_1c, field_24, field_28, field_43, field_47, field_59, field_5d, field_d4, field_2e2 and 7 more
# callees:      calls FUN_004618df, FUN_004e8d96, FUN_00462577, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_004632bf, FUN_00461d82, FUN_004619be, FUN_00461d4b, FUN_004fb2e3, KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_00461862
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.h:cpz_step (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 456 instruction(s), 29 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_39, 0x39  # offset +0x39
.equ field_3b, 0x3b  # offset +0x3b
.equ field_3f, 0x3f  # offset +0x3f
.equ field_43, 0x43  # offset +0x43
.equ field_47, 0x47  # offset +0x47
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4f, 0x4f  # offset +0x4f
.equ field_53, 0x53  # offset +0x53
.equ field_57, 0x57  # offset +0x57
.equ field_59, 0x59  # offset +0x59
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5d, 0x5d  # offset +0x5d
.equ field_d0, 0xd0  # offset +0xd0
.equ field_d4, 0xd4  # offset +0xd4
.equ field_d8, 0xd8  # offset +0xd8
.equ field_dc, 0xdc  # offset +0xdc
.equ field_2a1, 0x2a1  # offset +0x2a1
.equ field_2d2, 0x2d2  # offset +0x2d2
.equ field_2e2, 0x2e2  # offset +0x2e2
.equ field_2e4, 0x2e4  # offset +0x2e4
.equ field_2e6, 0x2e6  # offset +0x2e6
.equ field_2e8, 0x2e8  # offset +0x2e8
.equ field_2ea, 0x2ea  # offset +0x2ea
.equ field_2ee, 0x2ee  # offset +0x2ee
.equ field_2f2, 0x2f2  # offset +0x2f2
.equ field_2f6, 0x2f6  # offset +0x2f6
.equ field_2f8, 0x2f8  # offset +0x2f8
.equ field_2fa, 0x2fa  # offset +0x2fa
.equ field_2fb, 0x2fb  # offset +0x2fb
.equ field_31e, 0x31e  # offset +0x31e
.equ field_32e, 0x32e  # offset +0x32e
.equ field_330, 0x330  # offset +0x330
.equ field_332, 0x332  # offset +0x332
.equ field_334, 0x334  # offset +0x334
.equ field_336, 0x336  # offset +0x336
.equ field_33a, 0x33a  # offset +0x33a
.equ field_33e, 0x33e  # offset +0x33e
.equ field_342, 0x342  # offset +0x342
.equ field_344, 0x344  # offset +0x344
.equ field_346, 0x346  # offset +0x346

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00461862, .text + (0x00461862 - 0x401000)
.set FUN_004618df, .text + (0x004618df - 0x401000)
.set FUN_004619be, .text + (0x004619be - 0x401000)
.set FUN_00461d4b, .text + (0x00461d4b - 0x401000)
.set FUN_00461d82, .text + (0x00461d82 - 0x401000)
.set FUN_00462577, .text + (0x00462577 - 0x401000)
.set FUN_004632bf, .text + (0x004632bf - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x00463392 - 0x401000
.globl FUN_00463392
FUN_00463392:
    # block 0x00463392: entry, 16 instruction(s), ends with je to 0x004633e2 (forward)
    push ebp                                     # 00463392
    {load} mov ebp, esp                          # 00463393
    sub esp, 0x14                                # 00463395
    push esi                                     # 00463398
    push edi                                     # 00463399
    mov dword ptr [ebp - local_c], ecx           # 0046339a
    movsx eax, word ptr [ebp + arg_8]            # 0046339d
    imul eax, eax, 0x8d                          # 004633a1
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004633a7
    mov dword ptr [ebp - local_4], ecx           # 004633ad
    movsx edx, word ptr [ebp + arg_8]            # 004633b0
    imul edx, edx, 0x8d                          # 004633b4
    mov eax, dword ptr [edx + 0x5bb632]          # 004633ba
    mov dword ptr [ebp - local_10], eax          # 004633c0
    cmp dword ptr [ebp - local_10], 0x0          # 004633c3
    je.d8 L_004633e2                             # 004633c7
    # block 0x004633c9: entered by fall-through of je at 0x004633c7, 2 instruction(s), ends with je to 0x00463673 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004633c9
    je.d32 L_00463673                            # 004633cd
    # block 0x004633d3: entered by fall-through of je at 0x004633cd, 2 instruction(s), ends with je to 0x00463864 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 004633d3
    je.d32 L_00463864                            # 004633d7
    # block 0x004633dd: entered by fall-through of je at 0x004633d7, 1 instruction(s), ends with forward jump to 0x00463ae4
    jmp.d32 L_00463ae4                           # 004633dd
L_004633e2:
    # block 0x004633e2: entered by je at 0x004633c7, 11 instruction(s), ends with jne to 0x00463415 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004633e2
    mov dx, word ptr [ebp + arg_8]               # 004633e5
    mov word ptr [ecx + field_1e], dx            # 004633e9
    mov eax, dword ptr [ebp - local_c]           # 004633ed
    mov dword ptr [eax + field_3f], 0x1          # 004633f0
    mov dword ptr [0x5bb1ca], 0x1                # 004633f7
    mov ecx, dword ptr [ebp - local_4]           # 00463401
    {load} xor edx, edx                          # 00463404
    mov dl, byte ptr [ecx + field_21]            # 00463406
    test edx, edx                                # 00463409
    jne.d8 L_00463415                            # 0046340b
    # block 0x0046340d: entered by fall-through of jne at 0x0046340b, 2 instruction(s), calls FUN_004618df, falls into the block at 0x00463415
    mov ecx, dword ptr [ebp - local_c]           # 0046340d
    call FUN_004618df                            # 00463410
L_00463415:
    # block 0x00463415: entered by jne at 0x0046340b, 75 instruction(s), calls FUN_004e8d96, FUN_00462577, FUN_004d39f9, ends with jne to 0x00463566 (forward)
    mov ecx, 0x571442                            # 00463415
    call FUN_004e8d96                            # 0046341a
    mov eax, dword ptr [ebp - local_4]           # 0046341f
    mov ecx, dword ptr [ebp - local_4]           # 00463422
    mov edx, dword ptr [eax + field_d8]          # 00463425
    sub edx, dword ptr [ecx + field_d0]          # 0046342b
    mov eax, dword ptr [ebp - local_c]           # 00463431
    mov dword ptr [eax + field_4f], edx          # 00463434
    mov ecx, dword ptr [ebp - local_4]           # 00463437
    mov edx, dword ptr [ebp - local_4]           # 0046343a
    mov eax, dword ptr [ecx + field_dc]          # 0046343d
    sub eax, dword ptr [edx + field_d4]          # 00463443
    mov ecx, dword ptr [ebp - local_c]           # 00463449
    mov dword ptr [ecx + field_53], eax          # 0046344c
    mov ecx, dword ptr [ebp - local_c]           # 0046344f
    call FUN_00462577                            # 00463452
    mov edx, dword ptr [ebp - local_c]           # 00463457
    mov byte ptr [edx + field_28], 0x1           # 0046345a
    call FUN_004d39f9                            # 0046345e
    mov ecx, dword ptr [ebp - local_c]           # 00463463
    mov word ptr [ecx + field_1c], ax            # 00463466
    mov edx, dword ptr [ebp - local_c]           # 0046346a
    movsx eax, word ptr [edx + field_1c]         # 0046346d
    imul eax, eax, 0x4a                          # 00463471
    mov dword ptr [eax + 0x5d1591], 0xa          # 00463474
    mov ecx, dword ptr [ebp - local_c]           # 0046347e
    movsx edx, word ptr [ecx + field_1c]         # 00463481
    imul edx, edx, 0x4a                          # 00463485
    mov dword ptr [edx + 0x5d1595], 0x463b10     # 00463488
    mov eax, dword ptr [ebp - local_c]           # 00463492
    movsx ecx, word ptr [eax + field_1c]         # 00463495
    imul ecx, ecx, 0x4a                          # 00463499
    mov dword ptr [ecx + 0x5d1599], 0x0          # 0046349c
    mov edx, dword ptr [ebp - local_c]           # 004634a6
    movsx eax, word ptr [edx + field_1c]         # 004634a9
    imul eax, eax, 0x4a                          # 004634ad
    mov dword ptr [eax + 0x5d159d], 0x0          # 004634b0
    mov ecx, dword ptr [ebp - local_c]           # 004634ba
    movsx edx, word ptr [ecx + field_1c]         # 004634bd
    imul edx, edx, 0x4a                          # 004634c1
    mov dword ptr [edx + 0x5d15a1], 0x0          # 004634c4
    mov eax, dword ptr [ebp - local_c]           # 004634ce
    movsx ecx, word ptr [eax + field_1c]         # 004634d1
    imul ecx, ecx, 0x4a                          # 004634d5
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004634d8
    mov edx, dword ptr [ebp - local_c]           # 004634e2
    movsx eax, word ptr [edx + field_1c]         # 004634e5
    imul eax, eax, 0x4a                          # 004634e9
    mov dword ptr [eax + 0x5d15a9], 0x1          # 004634ec
    mov ecx, dword ptr [ebp - local_c]           # 004634f6
    movsx edx, word ptr [ecx + field_1c]         # 004634f9
    imul edx, edx, 0x4a                          # 004634fd
    mov word ptr [edx + 0x5d15ad], 0x0           # 00463500
    mov edi, 0x54b164                            # 00463509
    mov eax, dword ptr [ebp - local_c]           # 0046350e
    movsx ecx, word ptr [eax + field_1c]         # 00463511
    imul ecx, ecx, 0x4a                          # 00463515
    add ecx, 0x5d15b3                            # 00463518
    {load} mov edx, ecx                          # 0046351e
    or ecx, -0x1                                 # 00463520
    {load} xor eax, eax                          # 00463523
    repne scasb al, byte ptr es:[edi]            # 00463525
    not ecx                                      # 00463527
    {load} sub edi, ecx                          # 00463529
    {load} mov esi, edi                          # 0046352b
    {load} mov eax, ecx                          # 0046352d
    {load} mov edi, edx                          # 0046352f
    shr ecx, 0x2                                 # 00463531
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00463534
    {load} mov ecx, eax                          # 00463536
    and ecx, 0x3                                 # 00463538
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0046353b
    mov ecx, dword ptr [ebp - local_c]           # 0046353d
    cmp dword ptr [ecx + field_20], 0x0          # 00463540
    jne.d8 L_00463566                            # 00463544
    # block 0x00463546: entered by fall-through of jne at 0x00463544, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x00463566
    push 0x54b180                                # 00463546
    push 0x6                                     # 0046354b
    mov edx, dword ptr [ebp - local_4]           # 0046354d
    push edx                                     # 00463550
    push 0x54b19c                                # 00463551
    mov ecx, 0x5cf659                            # 00463556
    call FUN_004c2790                            # 0046355b
    mov ecx, dword ptr [ebp - local_c]           # 00463560
    mov dword ptr [ecx + field_20], eax          # 00463563
L_00463566:
    # block 0x00463566: entered by jne at 0x00463544, 13 instruction(s), ends with je to 0x004635a9 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00463566
    movsx eax, word ptr [edx + field_1c]         # 00463569
    imul eax, eax, 0x4a                          # 0046356d
    mov ecx, dword ptr [ebp - local_c]           # 00463570
    mov edx, dword ptr [ecx + field_20]          # 00463573
    mov dword ptr [eax + 0x5d1599], edx          # 00463576
    mov edi, 0x54b1a4                            # 0046357c
    mov esi, dword ptr [ebp - local_4]           # 00463581
    add esi, 0x24f                               # 00463584
    mov ecx, 0x9                                 # 0046358a
    {load} xor eax, eax                          # 0046358f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00463591
    je.d8 L_004635a9                             # 00463593
    # block 0x00463595: entered by fall-through of je at 0x00463593, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004635a9
    mov ecx, dword ptr [ebp - local_4]           # 00463595
    add ecx, 0x24f                               # 00463598
    push ecx                                     # 0046359e
    mov ecx, 0x5c3a67                            # 0046359f
    call FUN_004fb77a                            # 004635a4
L_004635a9:
    # block 0x004635a9: entered by je at 0x00463593, 7 instruction(s), ends with je to 0x004635d5 (forward)
    mov edi, 0x54b1b0                            # 004635a9
    mov esi, dword ptr [ebp - local_4]           # 004635ae
    add esi, 0x280                               # 004635b1
    mov ecx, 0x9                                 # 004635b7
    {load} xor edx, edx                          # 004635bc
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004635be
    je.d8 L_004635d5                             # 004635c0
    # block 0x004635c2: entered by fall-through of je at 0x004635c0, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004635d5
    mov eax, dword ptr [ebp - local_4]           # 004635c2
    add eax, 0x280                               # 004635c5
    push eax                                     # 004635ca
    mov ecx, 0x5c3a67                            # 004635cb
    call FUN_004fb77a                            # 004635d0
L_004635d5:
    # block 0x004635d5: entered by je at 0x004635c0, 7 instruction(s), ends with je to 0x00463601 (forward)
    mov edi, 0x54b1bc                            # 004635d5
    mov esi, dword ptr [ebp - local_4]           # 004635da
    add esi, 0x2b1                               # 004635dd
    mov ecx, 0x9                                 # 004635e3
    {load} xor edx, edx                          # 004635e8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004635ea
    je.d8 L_00463601                             # 004635ec
    # block 0x004635ee: entered by fall-through of je at 0x004635ec, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00463601
    mov eax, dword ptr [ebp - local_4]           # 004635ee
    add eax, 0x2b1                               # 004635f1
    push eax                                     # 004635f6
    mov ecx, 0x5c3a67                            # 004635f7
    call FUN_004fb77a                            # 004635fc
L_00463601:
    # block 0x00463601: entered by je at 0x004635ec, 26 instruction(s), ends with forward jump to 0x00463ae4
    mov ecx, dword ptr [ebp - local_c]           # 00463601
    mov dword ptr [ecx + field_47], 0x0          # 00463604
    mov edx, dword ptr [ebp - local_c]           # 0046360b
    mov dword ptr [edx + field_43], 0x0          # 0046360e
    mov eax, dword ptr [ebp - local_c]           # 00463615
    mov dword ptr [eax + field_24], 0x0          # 00463618
    mov ecx, dword ptr [ebp - local_c]           # 0046361f
    movsx edx, word ptr [ecx + field_1e]         # 00463622
    imul edx, edx, 0x8d                          # 00463626
    mov dword ptr [edx + 0x5bb632], 0x1          # 0046362c
    mov eax, dword ptr [ebp - local_c]           # 00463636
    mov word ptr [eax + field_39], 0x0           # 00463639
    mov ecx, dword ptr [ebp - local_c]           # 0046363f
    mov word ptr [ecx + field_57], 0x0           # 00463642
    mov edx, dword ptr [ebp - local_c]           # 00463648
    mov word ptr [edx + field_59], 0x0           # 0046364b
    mov eax, dword ptr [ebp - local_c]           # 00463651
    mov dword ptr [eax + field_3b], 0x0          # 00463654
    {load} xor ecx, ecx                          # 0046365b
    mov edx, dword ptr [ebp - local_c]           # 0046365d
    add edx, 0x29                                # 00463660
    mov dword ptr [edx], ecx                     # 00463663
    mov dword ptr [edx + field_4], ecx           # 00463665
    mov dword ptr [edx + field_8], ecx           # 00463668
    mov dword ptr [edx + field_c], ecx           # 0046366b
    jmp.d32 L_00463ae4                           # 0046366e
L_00463673:
    # block 0x00463673: entered by je at 0x004633cd, 5 instruction(s), ends with ja to 0x0046385f (forward)
    mov eax, dword ptr [ebp - local_c]           # 00463673
    mov ecx, dword ptr [eax + field_24]          # 00463676
    mov dword ptr [ebp - local_14], ecx          # 00463679
    cmp dword ptr [ebp - local_14], 0x4          # 0046367c
    ja.d32 L_0046385f                            # 00463680
    # block 0x00463686: entered by fall-through of ja at 0x00463680, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x463aec]
    mov edx, dword ptr [ebp - local_14]          # 00463686
    jmp dword ptr [4*edx + SWTAB_00463aec_VA]    # 00463689
L_00463690:
    # block 0x00463690: entered by switch case, 5 instruction(s), ends with je to 0x004636af (forward)
    mov eax, dword ptr [ebp - local_c]           # 00463690
    mov dword ptr [eax + field_3b], 0x0          # 00463693
    mov ecx, dword ptr [ebp - local_c]           # 0046369a
    cmp dword ptr [ecx + field_47], 0x0          # 0046369d
    je.d8 L_004636af                             # 004636a1
    # block 0x004636a3: entered by fall-through of je at 0x004636a1, 3 instruction(s), ends with forward jump to 0x004636b7
    mov edx, dword ptr [ebp - local_c]           # 004636a3
    mov dword ptr [edx + field_24], 0x1          # 004636a6
    jmp.d8 L_004636b7                            # 004636ad
L_004636af:
    # block 0x004636af: entered by je at 0x004636a1, 2 instruction(s), calls FUN_004632bf, falls into the block at 0x004636b7
    mov ecx, dword ptr [ebp - local_c]           # 004636af
    call FUN_004632bf                            # 004636b2
L_004636b7:
    # block 0x004636b7: entered by jmp at 0x004636ad, 1 instruction(s), ends with forward jump to 0x0046385f
    jmp.d32 L_0046385f                           # 004636b7
L_004636bc:
    # block 0x004636bc: entered by switch case, 4 instruction(s), calls FUN_00461d82, ends with je to 0x00463770 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004636bc
    call FUN_00461d82                            # 004636bf
    test eax, eax                                # 004636c4
    je.d32 L_00463770                            # 004636c6
    # block 0x004636cc: entered by fall-through of je at 0x004636c6, 7 instruction(s), calls FUN_004619be, ends with jne to 0x00463770 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004636cc
    mov cx, word ptr [eax + field_57]            # 004636cf
    push ecx                                     # 004636d3
    mov ecx, dword ptr [ebp - local_c]           # 004636d4
    call FUN_004619be                            # 004636d7
    test eax, eax                                # 004636dc
    jne.d32 L_00463770                           # 004636de
    # block 0x004636e4: entered by fall-through of jne at 0x004636de, 13 instruction(s), calls FUN_00461d4b, ends with je to 0x00463738 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004636e4
    mov ax, word ptr [edx + field_5d]            # 004636e7
    push eax                                     # 004636eb
    mov ecx, dword ptr [ebp - local_c]           # 004636ec
    mov dx, word ptr [ecx + field_5b]            # 004636ef
    push edx                                     # 004636f3
    mov eax, dword ptr [ebp - local_c]           # 004636f4
    mov cx, word ptr [eax + field_39]            # 004636f7
    push ecx                                     # 004636fb
    mov ecx, dword ptr [ebp - local_c]           # 004636fc
    call FUN_00461d4b                            # 004636ff
    test eax, eax                                # 00463704
    je.d8 L_00463738                             # 00463706
    # block 0x00463708: entered by fall-through of je at 0x00463706, 7 instruction(s), ends with je to 0x00463736 (forward)
    mov edi, 0x54b1c8                            # 00463708
    mov esi, dword ptr [ebp - local_4]           # 0046370d
    add esi, 0x280                               # 00463710
    mov ecx, 0x9                                 # 00463716
    {load} xor edx, edx                          # 0046371b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046371d
    je.d8 L_00463736                             # 0046371f
    # block 0x00463721: entered by fall-through of je at 0x0046371f, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00463736
    mov eax, dword ptr [ebp - local_4]           # 00463721
    mov cx, word ptr [eax + field_2a1]           # 00463724
    push ecx                                     # 0046372b
    mov ecx, 0x5c3a67                            # 0046372c
    call FUN_004fb2e3                            # 00463731
L_00463736:
    # block 0x00463736: entered by je at 0x0046371f, 1 instruction(s), ends with forward jump to 0x00463766
    jmp.d8 L_00463766                            # 00463736
L_00463738:
    # block 0x00463738: entered by je at 0x00463706, 7 instruction(s), ends with je to 0x00463766 (forward)
    mov edi, 0x54b1d4                            # 00463738
    mov esi, dword ptr [ebp - local_4]           # 0046373d
    add esi, 0x2b1                               # 00463740
    mov ecx, 0x9                                 # 00463746
    {load} xor edx, edx                          # 0046374b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046374d
    je.d8 L_00463766                             # 0046374f
    # block 0x00463751: entered by fall-through of je at 0x0046374f, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00463766
    mov eax, dword ptr [ebp - local_4]           # 00463751
    mov cx, word ptr [eax + field_2d2]           # 00463754
    push ecx                                     # 0046375b
    mov ecx, 0x5c3a67                            # 0046375c
    call FUN_004fb2e3                            # 00463761
L_00463766:
    # block 0x00463766: entered by jmp at 0x00463736; je at 0x0046374f, 2 instruction(s), falls into the block at 0x00463770
    mov edx, dword ptr [ebp - local_c]           # 00463766
    mov dword ptr [edx + field_24], 0x0          # 00463769
L_00463770:
    # block 0x00463770: entered by je at 0x004636c6; jne at 0x004636de, 1 instruction(s), ends with forward jump to 0x0046385f
    jmp.d32 L_0046385f                           # 00463770
L_00463775:
    # block 0x00463775: entered by switch case, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0046385f
    call dword ptr [0x52a23c]                    # 00463775
    mov ecx, dword ptr [ebp - local_4]           # 0046377b
    movsx edx, word ptr [ecx + field_2fb]        # 0046377e
    imul edx, edx, 0x3e8                         # 00463785
    {load} add eax, edx                          # 0046378b
    mov ecx, dword ptr [ebp - local_c]           # 0046378d
    mov dword ptr [ecx + field_4b], eax          # 00463790
    mov edx, dword ptr [ebp - local_c]           # 00463793
    mov dword ptr [edx + field_24], 0x4          # 00463796
    jmp.d32 L_0046385f                           # 0046379d
L_004637a2:
    # block 0x004637a2: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00463814 (forward)
    call dword ptr [0x52a23c]                    # 004637a2
    mov ecx, dword ptr [ebp - local_c]           # 004637a8
    cmp eax, dword ptr [ecx + field_4b]          # 004637ab
    jb.d8 L_00463814                             # 004637ae
    # block 0x004637b0: entered by fall-through of jb at 0x004637ae, 7 instruction(s), ends with je to 0x004637fd (forward)
    mov edi, 0x54b1e0                            # 004637b0
    mov esi, dword ptr [ebp - local_4]           # 004637b5
    add esi, 0x2fd                               # 004637b8
    mov ecx, 0x9                                 # 004637be
    {load} xor edx, edx                          # 004637c3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004637c5
    je.d8 L_004637fd                             # 004637c7
    # block 0x004637c9: entered by fall-through of je at 0x004637c7, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00463814
    mov eax, dword ptr [ebp - local_4]           # 004637c9
    add eax, 0x2fd                               # 004637cc
    push eax                                     # 004637d1
    mov ecx, 0x5c3a67                            # 004637d2
    call FUN_004fb77a                            # 004637d7
    mov ecx, dword ptr [ebp - local_4]           # 004637dc
    mov dx, word ptr [ecx + field_31e]           # 004637df
    push edx                                     # 004637e6
    mov ecx, 0x5c3a67                            # 004637e7
    call FUN_004fb2e3                            # 004637ec
    mov eax, dword ptr [ebp - local_c]           # 004637f1
    mov dword ptr [eax + field_24], 0x3          # 004637f4
    jmp.d8 L_00463814                            # 004637fb
L_004637fd:
    # block 0x004637fd: entered by je at 0x004637c7, 4 instruction(s), falls into the block at 0x00463814
    mov ecx, dword ptr [ebp - local_c]           # 004637fd
    movsx edx, word ptr [ecx + field_1e]         # 00463800
    imul edx, edx, 0x8d                          # 00463804
    mov dword ptr [edx + 0x5bb632], 0x2          # 0046380a
L_00463814:
    # block 0x00463814: entered by jb at 0x004637ae; jmp at 0x004637fb, 1 instruction(s), ends with forward jump to 0x0046385f
    jmp.d8 L_0046385f                            # 00463814
L_00463816:
    # block 0x00463816: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0046385f (forward)
    mov eax, dword ptr [ebp - local_4]           # 00463816
    movsx ecx, word ptr [eax + field_31e]        # 00463819
    mov dword ptr [ebp - local_8], ecx           # 00463820
    mov edx, dword ptr [ebp - local_8]           # 00463823
    push edx                                     # 00463826
    mov ecx, 0x5cf1eb                            # 00463827
    call FUN_004f6334                            # 0046382c
    test eax, eax                                # 00463831
    jne.d8 L_0046385f                            # 00463833
    # block 0x00463835: entered by fall-through of jne at 0x00463833, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x0046385f
    mov eax, dword ptr [ebp - local_4]           # 00463835
    add eax, 0x2fd                               # 00463838
    push eax                                     # 0046383d
    mov ecx, 0x5c3a67                            # 0046383e
    call FUN_004fba69                            # 00463843
    mov ecx, dword ptr [ebp - local_c]           # 00463848
    movsx edx, word ptr [ecx + field_1e]         # 0046384b
    imul edx, edx, 0x8d                          # 0046384f
    mov dword ptr [edx + 0x5bb632], 0x2          # 00463855
L_0046385f:
    # block 0x0046385f: entered by ja at 0x00463680; jmp at 0x004636b7; jmp at 0x00463770; jmp at 0x0046379d; more, 1 instruction(s), ends with forward jump to 0x00463ae4
    jmp.d32 L_00463ae4                           # 0046385f
L_00463864:
    # block 0x00463864: entered by je at 0x004633d7, 8 instruction(s), ends with je to 0x0046389b (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00463864
    mov edi, 0x54b1ec                            # 0046386e
    mov esi, dword ptr [ebp - local_4]           # 00463873
    add esi, 0x24f                               # 00463876
    mov ecx, 0x9                                 # 0046387c
    {load} xor eax, eax                          # 00463881
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00463883
    je.d8 L_0046389b                             # 00463885
    # block 0x00463887: entered by fall-through of je at 0x00463885, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0046389b
    mov ecx, dword ptr [ebp - local_4]           # 00463887
    add ecx, 0x24f                               # 0046388a
    push ecx                                     # 00463890
    mov ecx, 0x5c3a67                            # 00463891
    call FUN_004fba69                            # 00463896
L_0046389b:
    # block 0x0046389b: entered by je at 0x00463885, 7 instruction(s), ends with je to 0x004638c7 (forward)
    mov edi, 0x54b1f8                            # 0046389b
    mov esi, dword ptr [ebp - local_4]           # 004638a0
    add esi, 0x280                               # 004638a3
    mov ecx, 0x9                                 # 004638a9
    {load} xor edx, edx                          # 004638ae
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004638b0
    je.d8 L_004638c7                             # 004638b2
    # block 0x004638b4: entered by fall-through of je at 0x004638b2, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004638c7
    mov eax, dword ptr [ebp - local_4]           # 004638b4
    add eax, 0x280                               # 004638b7
    push eax                                     # 004638bc
    mov ecx, 0x5c3a67                            # 004638bd
    call FUN_004fba69                            # 004638c2
L_004638c7:
    # block 0x004638c7: entered by je at 0x004638b2, 7 instruction(s), ends with je to 0x004638f3 (forward)
    mov edi, 0x54b204                            # 004638c7
    mov esi, dword ptr [ebp - local_4]           # 004638cc
    add esi, 0x2b1                               # 004638cf
    mov ecx, 0x9                                 # 004638d5
    {load} xor edx, edx                          # 004638da
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004638dc
    je.d8 L_004638f3                             # 004638de
    # block 0x004638e0: entered by fall-through of je at 0x004638de, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004638f3
    mov eax, dword ptr [ebp - local_4]           # 004638e0
    add eax, 0x2b1                               # 004638e3
    push eax                                     # 004638e8
    mov ecx, 0x5c3a67                            # 004638e9
    call FUN_004fba69                            # 004638ee
L_004638f3:
    # block 0x004638f3: entered by je at 0x004638de, 3 instruction(s), ends with je to 0x004639e2 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004638f3
    cmp dword ptr [ecx + field_43], 0x0          # 004638f6
    je.d32 L_004639e2                            # 004638fa
    # block 0x00463900: entered by fall-through of je at 0x004638fa, 4 instruction(s), ends with je to 0x004639b2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00463900
    movsx eax, word ptr [edx + field_32e]        # 00463903
    cmp eax, 0x270f                              # 0046390a
    je.d32 L_004639b2                            # 0046390f
    # block 0x00463915: entered by fall-through of je at 0x0046390f, 25 instruction(s), ends with jne to 0x0046399e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00463915
    movsx edx, word ptr [ecx + field_32e]        # 00463918
    mov dword ptr [0x5bb57b], edx                # 0046391f
    mov eax, dword ptr [ebp - local_4]           # 00463925
    mov cx, word ptr [eax + field_330]           # 00463928
    mov word ptr [0x5bb599], cx                  # 0046392f
    mov edx, dword ptr [ebp - local_4]           # 00463936
    mov ax, word ptr [edx + field_332]           # 00463939
    mov word ptr [0x5bb595], ax                  # 00463940
    mov ecx, dword ptr [ebp - local_4]           # 00463946
    mov dx, word ptr [ecx + field_334]           # 00463949
    mov word ptr [0x5c39ff], dx                  # 00463950
    mov eax, dword ptr [ebp - local_4]           # 00463957
    mov ecx, dword ptr [eax + field_336]         # 0046395a
    mov dword ptr [0x5bb59b], ecx                # 00463960
    mov edx, dword ptr [ebp - local_4]           # 00463966
    mov eax, dword ptr [edx + field_33a]         # 00463969
    mov dword ptr [0x5bb59f], eax                # 0046396f
    mov ecx, dword ptr [ebp - local_4]           # 00463974
    mov edx, dword ptr [ecx + field_33e]         # 00463977
    mov dword ptr [0x5bb5a3], edx                # 0046397d
    mov eax, dword ptr [ebp - local_4]           # 00463983
    movsx ecx, word ptr [eax + field_342]        # 00463986
    cmp ecx, 0x1                                 # 0046398d
    jne.d8 L_0046399e                            # 00463990
    # block 0x00463992: entered by fall-through of jne at 0x00463990, 2 instruction(s), ends with forward jump to 0x004639a8
    mov dword ptr [0x5bb1ca], 0x0                # 00463992
    jmp.d8 L_004639a8                            # 0046399c
L_0046399e:
    # block 0x0046399e: entered by jne at 0x00463990, 1 instruction(s), falls into the block at 0x004639a8
    mov dword ptr [0x5bb1ca], 0x1                # 0046399e
L_004639a8:
    # block 0x004639a8: entered by jmp at 0x0046399c, 1 instruction(s), falls into the block at 0x004639b2
    mov dword ptr [0x583999], 0x4                # 004639a8
L_004639b2:
    # block 0x004639b2: entered by je at 0x0046390f, 4 instruction(s), ends with je to 0x004639dd (forward)
    mov edx, dword ptr [ebp - local_4]           # 004639b2
    movsx eax, word ptr [edx + field_344]        # 004639b5
    cmp eax, -0x1                                # 004639bc
    je.d8 L_004639dd                             # 004639bf
    # block 0x004639c1: entered by fall-through of je at 0x004639bf, 6 instruction(s), falls into the block at 0x004639dd
    mov ecx, dword ptr [ebp - local_4]           # 004639c1
    {load} xor edx, edx                          # 004639c4
    mov dl, byte ptr [ecx + field_346]           # 004639c6
    mov eax, dword ptr [ebp - local_4]           # 004639cc
    movsx ecx, word ptr [eax + field_344]        # 004639cf
    mov dword ptr [4*ecx + 0x585801], edx        # 004639d6
L_004639dd:
    # block 0x004639dd: entered by je at 0x004639bf, 1 instruction(s), ends with forward jump to 0x00463acc
    jmp.d32 L_00463acc                           # 004639dd
L_004639e2:
    # block 0x004639e2: entered by je at 0x004638fa, 3 instruction(s), ends with je to 0x00463acc (forward)
    mov edx, dword ptr [ebp - local_c]           # 004639e2
    cmp dword ptr [edx + field_47], 0x0          # 004639e5
    je.d32 L_00463acc                            # 004639e9
    # block 0x004639ef: entered by fall-through of je at 0x004639e9, 4 instruction(s), ends with je to 0x00463aa1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004639ef
    movsx ecx, word ptr [eax + field_2e2]        # 004639f2
    cmp ecx, 0x270f                              # 004639f9
    je.d32 L_00463aa1                            # 004639ff
    # block 0x00463a05: entered by fall-through of je at 0x004639ff, 25 instruction(s), ends with jne to 0x00463a8d (forward)
    mov edx, dword ptr [ebp - local_4]           # 00463a05
    movsx eax, word ptr [edx + field_2e2]        # 00463a08
    mov dword ptr [0x5bb57b], eax                # 00463a0f
    mov ecx, dword ptr [ebp - local_4]           # 00463a14
    mov dx, word ptr [ecx + field_2e4]           # 00463a17
    mov word ptr [0x5bb599], dx                  # 00463a1e
    mov eax, dword ptr [ebp - local_4]           # 00463a25
    mov cx, word ptr [eax + field_2e6]           # 00463a28
    mov word ptr [0x5bb595], cx                  # 00463a2f
    mov edx, dword ptr [ebp - local_4]           # 00463a36
    mov ax, word ptr [edx + field_2e8]           # 00463a39
    mov word ptr [0x5c39ff], ax                  # 00463a40
    mov ecx, dword ptr [ebp - local_4]           # 00463a46
    mov edx, dword ptr [ecx + field_2ea]         # 00463a49
    mov dword ptr [0x5bb59b], edx                # 00463a4f
    mov eax, dword ptr [ebp - local_4]           # 00463a55
    mov ecx, dword ptr [eax + field_2ee]         # 00463a58
    mov dword ptr [0x5bb59f], ecx                # 00463a5e
    mov edx, dword ptr [ebp - local_4]           # 00463a64
    mov eax, dword ptr [edx + field_2f2]         # 00463a67
    mov dword ptr [0x5bb5a3], eax                # 00463a6d
    mov ecx, dword ptr [ebp - local_4]           # 00463a72
    movsx edx, word ptr [ecx + field_2f6]        # 00463a75
    cmp edx, 0x1                                 # 00463a7c
    jne.d8 L_00463a8d                            # 00463a7f
    # block 0x00463a81: entered by fall-through of jne at 0x00463a7f, 2 instruction(s), ends with forward jump to 0x00463a97
    mov dword ptr [0x5bb1ca], 0x0                # 00463a81
    jmp.d8 L_00463a97                            # 00463a8b
L_00463a8d:
    # block 0x00463a8d: entered by jne at 0x00463a7f, 1 instruction(s), falls into the block at 0x00463a97
    mov dword ptr [0x5bb1ca], 0x1                # 00463a8d
L_00463a97:
    # block 0x00463a97: entered by jmp at 0x00463a8b, 1 instruction(s), falls into the block at 0x00463aa1
    mov dword ptr [0x583999], 0x4                # 00463a97
L_00463aa1:
    # block 0x00463aa1: entered by je at 0x004639ff, 4 instruction(s), ends with je to 0x00463acc (forward)
    mov eax, dword ptr [ebp - local_4]           # 00463aa1
    movsx ecx, word ptr [eax + field_2f8]        # 00463aa4
    cmp ecx, -0x1                                # 00463aab
    je.d8 L_00463acc                             # 00463aae
    # block 0x00463ab0: entered by fall-through of je at 0x00463aae, 6 instruction(s), falls into the block at 0x00463acc
    mov edx, dword ptr [ebp - local_4]           # 00463ab0
    {load} xor eax, eax                          # 00463ab3
    mov al, byte ptr [edx + field_2fa]           # 00463ab5
    mov ecx, dword ptr [ebp - local_4]           # 00463abb
    movsx edx, word ptr [ecx + field_2f8]        # 00463abe
    mov dword ptr [4*edx + 0x585801], eax        # 00463ac5
L_00463acc:
    # block 0x00463acc: entered by jmp at 0x004639dd; je at 0x004639e9; je at 0x00463aae, 7 instruction(s), calls FUN_0042ba3a, FUN_00461862, falls into the block at 0x00463ae4
    mov eax, dword ptr [ebp - local_c]           # 00463acc
    mov cx, word ptr [eax + field_1e]            # 00463acf
    push ecx                                     # 00463ad3
    call FUN_0042ba3a                            # 00463ad4
    add esp, 0x4                                 # 00463ad9
    mov ecx, dword ptr [ebp - local_c]           # 00463adc
    call FUN_00461862                            # 00463adf
L_00463ae4:
    # block 0x00463ae4: entered by jmp at 0x004633dd; jmp at 0x0046366e; jmp at 0x0046385f, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00463ae4
    pop esi                                      # 00463ae5
    {load} mov esp, ebp                          # 00463ae6
    pop ebp                                      # 00463ae8
    ret 0x4                                      # 00463ae9

# --- data items (not part of the function) -------------------------
.org 0x00463aec - 0x401000
SWTAB_00463aec:  # 5 case address(es)
    .long L_00463690 - .text + 0x401000
    .long L_00463775 - .text + 0x401000
    .long L_004636bc - .text + 0x401000
    .long L_00463816 - .text + 0x401000
    .long L_004637a2 - .text + 0x401000
.set SWTAB_00463aec_VA, SWTAB_00463aec - .text + 0x401000

