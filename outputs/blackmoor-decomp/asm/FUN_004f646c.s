# FUN_004f646c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f646c
# extent:       0x004f646c-0x004f6624 (440 code bytes)
# span:         0x004f646c-0x004f6624 (code 440, tables 0, padding 0)
# sha256:       d06ef3ada634ec74d4cb846eda452d1ea09392167e8c22c338336c9c1bd8572c
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_sound_pause
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4f646c.c.txt, not original source) refers to the data labelled s_CDirectSound__Pause_____Paused_c_0055e828, s_CDirectSound__Pause_____time_del_0055e7ec
# name-note:    Pauses a sound channel and records the pause owner; logs CDirectSound::Pause.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_172, field_28f, field_3be, field_3c2, field_3ce; [ecx + n] field_3be, field_3c2, field_3ca; [edx + n] field_48, field_162, field_16e, field_19e, field_28f, field_3be, field_3c2, field_3ca
# callees:      calls FUN_004f709c, FUN_004f6334, FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 107 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_48, 0x48  # offset +0x48
.equ field_162, 0x162  # offset +0x162
.equ field_16e, 0x16e  # offset +0x16e
.equ field_172, 0x172  # offset +0x172
.equ field_19e, 0x19e  # offset +0x19e
.equ field_28f, 0x28f  # offset +0x28f
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f646c - 0x401000
.globl FUN_004f646c
FUN_004f646c:
    # block 0x004f646c: entry, 18 instruction(s), calls FUN_004f709c, ends with jne to 0x004f64da (forward)
    push ebp                                     # 004f646c
    {load} mov ebp, esp                          # 004f646d
    sub esp, 0x8                                 # 004f646f
    mov dword ptr [ebp - local_8], ecx           # 004f6472
    mov eax, dword ptr [ebp - local_8]           # 004f6475
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f6478
    mov ecx, dword ptr [ebp - local_8]           # 004f6482
    mov dword ptr [ecx + field_3ca], 0x0         # 004f6485
    mov edx, dword ptr [ebp + arg_8]             # 004f648f
    imul edx, edx, 0x5bb                         # 004f6492
    mov eax, dword ptr [ebp - local_8]           # 004f6498
    mov ecx, dword ptr [eax + field_3ce]         # 004f649b
    {load} add ecx, edx                          # 004f64a1
    mov dword ptr [ebp - local_4], ecx           # 004f64a3
    mov ecx, dword ptr [ebp - local_8]           # 004f64a6
    call FUN_004f709c                            # 004f64a9
    test eax, eax                                # 004f64ae
    jne.d8 L_004f64da                            # 004f64b0
    # block 0x004f64b2: entered by fall-through of jne at 0x004f64b0, 7 instruction(s), ends with forward jump to 0x004f661e
    mov edx, dword ptr [ebp - local_8]           # 004f64b2
    mov dword ptr [edx + field_3c2], 0x3ea       # 004f64b5
    mov eax, dword ptr [ebp - local_8]           # 004f64bf
    mov dword ptr [eax + field_3be], 0x0         # 004f64c2
    mov ecx, dword ptr [ebp - local_8]           # 004f64cc
    mov eax, dword ptr [ecx + field_3be]         # 004f64cf
    jmp.d32 L_004f661e                           # 004f64d5
L_004f64da:
    # block 0x004f64da: entered by jne at 0x004f64b0, 3 instruction(s), ends with je to 0x004f64f2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f64da
    cmp dword ptr [edx + field_162], 0x0         # 004f64dd
    je.d8 L_004f64f2                             # 004f64e4
    # block 0x004f64e6: entered by fall-through of je at 0x004f64e4, 3 instruction(s), ends with jne to 0x004f651a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f64e6
    cmp dword ptr [eax + field_28f], 0x0         # 004f64e9
    jne.d8 L_004f651a                            # 004f64f0
L_004f64f2:
    # block 0x004f64f2: entered by je at 0x004f64e4; fall-through of jne at 0x004f64f0, 7 instruction(s), ends with forward jump to 0x004f661e
    mov ecx, dword ptr [ebp - local_8]           # 004f64f2
    mov dword ptr [ecx + field_3c2], 0x3ef       # 004f64f5
    mov edx, dword ptr [ebp - local_8]           # 004f64ff
    mov dword ptr [edx + field_3be], 0x0         # 004f6502
    mov eax, dword ptr [ebp - local_8]           # 004f650c
    mov eax, dword ptr [eax + field_3be]         # 004f650f
    jmp.d32 L_004f661e                           # 004f6515
L_004f651a:
    # block 0x004f651a: entered by jne at 0x004f64f0, 6 instruction(s), calls FUN_004f6334, ends with je to 0x004f65fb (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004f651a
    push ecx                                     # 004f651d
    mov ecx, dword ptr [ebp - local_8]           # 004f651e
    call FUN_004f6334                            # 004f6521
    test eax, eax                                # 004f6526
    je.d32 L_004f65fb                            # 004f6528
    # block 0x004f652e: entered by fall-through of je at 0x004f6528, 8 instruction(s), ends with je to 0x004f6592 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f652e
    mov dword ptr [edx + field_16e], 0x1         # 004f6531
    mov eax, dword ptr [ebp - local_4]           # 004f653b
    mov ecx, dword ptr [ebp + arg_c]             # 004f653e
    mov dword ptr [eax + field_172], ecx         # 004f6541
    mov edx, dword ptr [ebp - local_4]           # 004f6547
    cmp dword ptr [edx + field_19e], 0x0         # 004f654a
    je.d8 L_004f6592                             # 004f6551
    # block 0x004f6553: entered by fall-through of je at 0x004f6551, 3 instruction(s), ends with je to 0x004f6588 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f6553
    test eax, eax                                # 004f655a
    je.d8 L_004f6588                             # 004f655c
    # block 0x004f655e: entered by fall-through of je at 0x004f655c, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f6588
    mov ecx, dword ptr [ebp - local_4]           # 004f655e
    add ecx, 0x4                                 # 004f6561
    push ecx                                     # 004f6564
    mov edx, dword ptr [ebp + arg_8]             # 004f6565
    push edx                                     # 004f6568
    push 0x55e7ec                                # 004f6569
    push 0x63888b                                # 004f656e
    call FUN_0050ca3e                            # 004f6573
    add esp, 0x10                                # 004f6578
    push 0x63888b                                # 004f657b
    call FUN_0044a2b7                            # 004f6580
    add esp, 0x4                                 # 004f6585
L_004f6588:
    # block 0x004f6588: entered by je at 0x004f655c, 2 instruction(s), ends with forward jump to 0x004f661e
    mov eax, 0x1                                 # 004f6588
    jmp.d32 L_004f661e                           # 004f658d
L_004f6592:
    # block 0x004f6592: entered by je at 0x004f6551, 12 instruction(s), calls indirect dword ptr [edx + 0x48], ends with jne to 0x004f65fb (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f6592
    mov ecx, dword ptr [eax + field_28f]         # 004f6595
    mov edx, dword ptr [ebp - local_4]           # 004f659b
    mov eax, dword ptr [edx + field_28f]         # 004f659e
    mov edx, dword ptr [eax]                     # 004f65a4
    push ecx                                     # 004f65a6
    call dword ptr [edx + field_48]              # 004f65a7
    mov ecx, dword ptr [ebp - local_8]           # 004f65aa
    mov dword ptr [ecx + field_3ca], eax         # 004f65ad
    mov edx, dword ptr [ebp - local_8]           # 004f65b3
    cmp dword ptr [edx + field_3ca], 0x0         # 004f65b6
    jne.d8 L_004f65fb                            # 004f65bd
    # block 0x004f65bf: entered by fall-through of jne at 0x004f65bd, 3 instruction(s), ends with je to 0x004f65f4 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f65bf
    test eax, eax                                # 004f65c6
    je.d8 L_004f65f4                             # 004f65c8
    # block 0x004f65ca: entered by fall-through of je at 0x004f65c8, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f65f4
    mov ecx, dword ptr [ebp - local_4]           # 004f65ca
    add ecx, 0x4                                 # 004f65cd
    push ecx                                     # 004f65d0
    mov edx, dword ptr [ebp + arg_8]             # 004f65d1
    push edx                                     # 004f65d4
    push 0x55e828                                # 004f65d5
    push 0x63888b                                # 004f65da
    call FUN_0050ca3e                            # 004f65df
    add esp, 0x10                                # 004f65e4
    push 0x63888b                                # 004f65e7
    call FUN_0044a2b7                            # 004f65ec
    add esp, 0x4                                 # 004f65f1
L_004f65f4:
    # block 0x004f65f4: entered by je at 0x004f65c8, 2 instruction(s), ends with forward jump to 0x004f661e
    mov eax, 0x1                                 # 004f65f4
    jmp.d8 L_004f661e                            # 004f65f9
L_004f65fb:
    # block 0x004f65fb: entered by je at 0x004f6528; jne at 0x004f65bd, 6 instruction(s), falls into the block at 0x004f661e
    mov eax, dword ptr [ebp - local_8]           # 004f65fb
    mov dword ptr [eax + field_3c2], 0x40c       # 004f65fe
    mov ecx, dword ptr [ebp - local_8]           # 004f6608
    mov dword ptr [ecx + field_3be], 0x0         # 004f660b
    mov edx, dword ptr [ebp - local_8]           # 004f6615
    mov eax, dword ptr [edx + field_3be]         # 004f6618
L_004f661e:
    # block 0x004f661e: entered by jmp at 0x004f64d5; jmp at 0x004f6515; jmp at 0x004f658d; jmp at 0x004f65f9, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f661e
    pop ebp                                      # 004f6620
    ret 0x8                                      # 004f6621

