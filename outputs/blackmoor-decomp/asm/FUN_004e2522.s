# FUN_004e2522
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2522
# extent:       0x004e2522-0x004e26fc (474 code bytes)
# span:         0x004e2522-0x004e26fc (code 474, tables 0, padding 0)
# sha256:       0e808b0f9c13ba72d4e7448479cea007ae7b9f0ad2314f5753df5c1e533193f2
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e2522_lifted
# naming:       native port src/original_methods_fl41.c:m4e2522_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 44 seeds; oracle: 115/115 instructions, 34/34 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c, field_30, field_e2, field_e6, field_183; [ecx + n] field_30, field_e2; [edx + n] field_18, field_30, field_e6, field_183
# callees:      calls FUN_004d5316
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4e2522_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 115 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_30, 0x30  # offset +0x30
.equ field_e2, 0xe2  # offset +0xe2
.equ field_e6, 0xe6  # offset +0xe6
.equ field_183, 0x183  # offset +0x183

# --- external targets -----------------------------------------------
.set FUN_004d5316, .text + (0x004d5316 - 0x401000)

.org 0x004e2522 - 0x401000
.globl FUN_004e2522
FUN_004e2522:
    # block 0x004e2522: entry, 9 instruction(s), ends with jne to 0x004e2548 (forward)
    push ebp                                     # 004e2522
    {load} mov ebp, esp                          # 004e2523
    sub esp, 0x8                                 # 004e2525
    mov dword ptr [ebp - local_4], ecx           # 004e2528
    mov eax, dword ptr [ebp - local_4]           # 004e252b
    mov dword ptr [eax + field_183], 0x0         # 004e252e
    mov ecx, dword ptr [ebp - local_4]           # 004e2538
    cmp dword ptr [ecx + field_30], 0x4          # 004e253b
    jne.d8 L_004e2548                            # 004e253f
    # block 0x004e2541: entered by fall-through of jne at 0x004e253f, 2 instruction(s), ends with forward jump to 0x004e26f6
    {load} xor eax, eax                          # 004e2541
    jmp.d32 L_004e26f6                           # 004e2543
L_004e2548:
    # block 0x004e2548: entered by jne at 0x004e253f, 5 instruction(s), ends with je to 0x004e2566 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e2548
    mov eax, dword ptr [edx + field_18]          # 004e254b
    mov dword ptr [ebp - local_8], eax           # 004e254e
    cmp dword ptr [ebp - local_8], 0x0           # 004e2551
    je.d8 L_004e2566                             # 004e2555
    # block 0x004e2557: entered by fall-through of je at 0x004e2555, 2 instruction(s), ends with je to 0x004e262b (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004e2557
    je.d32 L_004e262b                            # 004e255b
    # block 0x004e2561: entered by fall-through of je at 0x004e255b, 1 instruction(s), ends with forward jump to 0x004e26f4
    jmp.d32 L_004e26f4                           # 004e2561
L_004e2566:
    # block 0x004e2566: entered by je at 0x004e2555, 3 instruction(s), ends with je to 0x004e2585 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e2566
    cmp dword ptr [ecx + field_30], 0x0          # 004e2569
    je.d8 L_004e2585                             # 004e256d
    # block 0x004e256f: entered by fall-through of je at 0x004e256d, 3 instruction(s), ends with je to 0x004e2585 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e256f
    cmp dword ptr [edx + field_30], 0x1          # 004e2572
    je.d8 L_004e2585                             # 004e2576
    # block 0x004e2578: entered by fall-through of je at 0x004e2576, 3 instruction(s), ends with jne to 0x004e2626 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e2578
    cmp dword ptr [eax + field_30], 0x3          # 004e257b
    jne.d32 L_004e2626                           # 004e257f
L_004e2585:
    # block 0x004e2585: entered by je at 0x004e256d; je at 0x004e2576; fall-through of jne at 0x004e257f, 9 instruction(s), calls FUN_004d5316, ends with je to 0x004e2613 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e2585
    add ecx, 0x4                                 # 004e2588
    push ecx                                     # 004e258b
    mov edx, dword ptr [ebp + arg_8]             # 004e258c
    push edx                                     # 004e258f
    mov ecx, 0x570450                            # 004e2590
    call FUN_004d5316                            # 004e2595
    test eax, eax                                # 004e259a
    je.d8 L_004e2613                             # 004e259c
    # block 0x004e259e: entered by fall-through of je at 0x004e259c, 5 instruction(s), ends with je to 0x004e25c1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e259e
    mov dword ptr [eax + field_183], 0x1         # 004e25a1
    mov ecx, dword ptr [ebp - local_4]           # 004e25ab
    cmp dword ptr [ecx + field_e2], 0x0          # 004e25ae
    je.d8 L_004e25c1                             # 004e25b5
    # block 0x004e25b7: entered by fall-through of je at 0x004e25b5, 2 instruction(s), falls into the block at 0x004e25c1
    mov edx, dword ptr [ebp - local_4]           # 004e25b7
    mov dword ptr [edx + field_30], 0x1          # 004e25ba
L_004e25c1:
    # block 0x004e25c1: entered by je at 0x004e25b5, 3 instruction(s), ends with je to 0x004e2609 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e25c1
    cmp dword ptr [eax + field_e6], 0x0          # 004e25c4
    je.d8 L_004e2609                             # 004e25cb
    # block 0x004e25cd: entered by fall-through of je at 0x004e25cb, 9 instruction(s), falls into the block at 0x004e2609
    mov dword ptr [0x5c39e5], 0x27d8             # 004e25cd
    mov dword ptr [0x5b44f4], 0x1                # 004e25d7
    mov ecx, dword ptr [0x5b44f0]                # 004e25e1
    shl ecx, 0x5                                 # 004e25e7
    mov edx, dword ptr [0x5b44f4]                # 004e25ea
    shl edx, 0x4                                 # 004e25f0
    lea eax, [ecx + edx + 0x5b160c]              # 004e25f3
    mov dword ptr [0x5d1631], eax                # 004e25fa
    mov dword ptr [0x5d1639], 0x1                # 004e25ff
L_004e2609:
    # block 0x004e2609: entered by je at 0x004e25cb, 2 instruction(s), ends with forward jump to 0x004e26f6
    mov eax, 0x1                                 # 004e2609
    jmp.d32 L_004e26f6                           # 004e260e
L_004e2613:
    # block 0x004e2613: entered by je at 0x004e259c, 3 instruction(s), ends with jne to 0x004e2626 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e2613
    cmp dword ptr [ecx + field_30], 0x1          # 004e2616
    jne.d8 L_004e2626                            # 004e261a
    # block 0x004e261c: entered by fall-through of jne at 0x004e261a, 2 instruction(s), falls into the block at 0x004e2626
    mov edx, dword ptr [ebp - local_4]           # 004e261c
    mov dword ptr [edx + field_30], 0x0          # 004e261f
L_004e2626:
    # block 0x004e2626: entered by jne at 0x004e257f; jne at 0x004e261a, 1 instruction(s), ends with forward jump to 0x004e26f4
    jmp.d32 L_004e26f4                           # 004e2626
L_004e262b:
    # block 0x004e262b: entered by je at 0x004e255b, 3 instruction(s), ends with je to 0x004e264a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e262b
    cmp dword ptr [eax + field_30], 0x0          # 004e262e
    je.d8 L_004e264a                             # 004e2632
    # block 0x004e2634: entered by fall-through of je at 0x004e2632, 3 instruction(s), ends with je to 0x004e264a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e2634
    cmp dword ptr [ecx + field_30], 0x1          # 004e2637
    je.d8 L_004e264a                             # 004e263b
    # block 0x004e263d: entered by fall-through of je at 0x004e263b, 3 instruction(s), ends with jne to 0x004e26f4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e263d
    cmp dword ptr [edx + field_30], 0x2          # 004e2640
    jne.d32 L_004e26f4                           # 004e2644
L_004e264a:
    # block 0x004e264a: entered by je at 0x004e2632; je at 0x004e263b; fall-through of jne at 0x004e2644, 9 instruction(s), calls FUN_004d5316, ends with je to 0x004e26d5 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e264a
    add eax, 0x4                                 # 004e264d
    push eax                                     # 004e2650
    mov ecx, dword ptr [ebp + arg_8]             # 004e2651
    push ecx                                     # 004e2654
    mov ecx, 0x570450                            # 004e2655
    call FUN_004d5316                            # 004e265a
    test eax, eax                                # 004e265f
    je.d8 L_004e26d5                             # 004e2661
    # block 0x004e2663: entered by fall-through of je at 0x004e2661, 5 instruction(s), ends with je to 0x004e2686 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e2663
    mov dword ptr [edx + field_183], 0x1         # 004e2666
    mov eax, dword ptr [ebp - local_4]           # 004e2670
    cmp dword ptr [eax + field_e2], 0x0          # 004e2673
    je.d8 L_004e2686                             # 004e267a
    # block 0x004e267c: entered by fall-through of je at 0x004e267a, 2 instruction(s), falls into the block at 0x004e2686
    mov ecx, dword ptr [ebp - local_4]           # 004e267c
    mov dword ptr [ecx + field_30], 0x1          # 004e267f
L_004e2686:
    # block 0x004e2686: entered by je at 0x004e267a, 3 instruction(s), ends with je to 0x004e26ce (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e2686
    cmp dword ptr [edx + field_e6], 0x0          # 004e2689
    je.d8 L_004e26ce                             # 004e2690
    # block 0x004e2692: entered by fall-through of je at 0x004e2690, 9 instruction(s), falls into the block at 0x004e26ce
    mov dword ptr [0x5c39e5], 0x27d8             # 004e2692
    mov dword ptr [0x5b44f4], 0x1                # 004e269c
    mov eax, dword ptr [0x5b44f0]                # 004e26a6
    shl eax, 0x5                                 # 004e26ab
    mov ecx, dword ptr [0x5b44f4]                # 004e26ae
    shl ecx, 0x4                                 # 004e26b4
    lea edx, [eax + ecx + 0x5b160c]              # 004e26b7
    mov dword ptr [0x5d1631], edx                # 004e26be
    mov dword ptr [0x5d1639], 0x1                # 004e26c4
L_004e26ce:
    # block 0x004e26ce: entered by je at 0x004e2690, 2 instruction(s), ends with forward jump to 0x004e26f6
    mov eax, 0x1                                 # 004e26ce
    jmp.d8 L_004e26f6                            # 004e26d3
L_004e26d5:
    # block 0x004e26d5: entered by je at 0x004e2661, 3 instruction(s), ends with je to 0x004e26ea (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e26d5
    cmp dword ptr [eax + field_1c], 0x0          # 004e26d8
    je.d8 L_004e26ea                             # 004e26dc
    # block 0x004e26de: entered by fall-through of je at 0x004e26dc, 3 instruction(s), ends with forward jump to 0x004e26f4
    mov ecx, dword ptr [ebp - local_4]           # 004e26de
    mov dword ptr [ecx + field_30], 0x0          # 004e26e1
    jmp.d8 L_004e26f4                            # 004e26e8
L_004e26ea:
    # block 0x004e26ea: entered by je at 0x004e26dc, 2 instruction(s), falls into the block at 0x004e26f4
    mov edx, dword ptr [ebp - local_4]           # 004e26ea
    mov dword ptr [edx + field_30], 0x2          # 004e26ed
L_004e26f4:
    # block 0x004e26f4: entered by jmp at 0x004e2561; jmp at 0x004e2626; jne at 0x004e2644; jmp at 0x004e26e8, 1 instruction(s), falls into the block at 0x004e26f6
    {load} xor eax, eax                          # 004e26f4
L_004e26f6:
    # block 0x004e26f6: entered by jmp at 0x004e2543; jmp at 0x004e260e; jmp at 0x004e26d3, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004e26f6
    pop ebp                                      # 004e26f8
    ret 0x4                                      # 004e26f9

