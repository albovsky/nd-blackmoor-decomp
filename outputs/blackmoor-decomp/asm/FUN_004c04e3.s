# FUN_004c04e3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c04e3
# extent:       0x004c04e3-0x004c0774 (657 code bytes)
# span:         0x004c04e3-0x004c0774 (code 657, tables 0, padding 0)
# sha256:       588bc16e5e4db5b1326a0feb1056f789c634a7af0d72464a96b04aef5ac2c1c0
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c04e3_start_movie
# naming:       native port src/original_methods_fl27b.c:m4c04e3_start_movie (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4c04e3_start_movie: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_18e, field_1da, field_216; [ecx + n] field_18e, field_222, field_240; [edx + n] field_2d, field_2f, field_18e, field_1da, field_21a, field_244
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004bef85, FUN_004befc8, FUN_004bf098, FUN_004bee2c, FUN_004c0ab1, FUN_004c08d3, FUN_004bf10f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27b.c:m4c04e3_start_movie (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 163 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_18e, 0x18e  # offset +0x18e
.equ field_1da, 0x1da  # offset +0x1da
.equ field_216, 0x216  # offset +0x216
.equ field_21a, 0x21a  # offset +0x21a
.equ field_222, 0x222  # offset +0x222
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004bee2c, .text + (0x004bee2c - 0x401000)
.set FUN_004bef85, .text + (0x004bef85 - 0x401000)
.set FUN_004befc8, .text + (0x004befc8 - 0x401000)
.set FUN_004bf098, .text + (0x004bf098 - 0x401000)
.set FUN_004bf10f, .text + (0x004bf10f - 0x401000)
.set FUN_004c08d3, .text + (0x004c08d3 - 0x401000)
.set FUN_004c0ab1, .text + (0x004c0ab1 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c04e3 - 0x401000
.globl FUN_004c04e3
FUN_004c04e3:
    # block 0x004c04e3: entry, 9 instruction(s), ends with je to 0x004c050d (forward)
    push ebp                                     # 004c04e3
    {load} mov ebp, esp                          # 004c04e4
    sub esp, 0x8                                 # 004c04e6
    mov dword ptr [ebp - local_4], ecx           # 004c04e9
    mov eax, dword ptr [ebp - local_4]           # 004c04ec
    mov ecx, dword ptr [eax + field_1da]         # 004c04ef
    mov dword ptr [ebp - local_8], ecx           # 004c04f5
    cmp dword ptr [ebp - local_8], 0x0           # 004c04f8
    je.d8 L_004c050d                             # 004c04fc
    # block 0x004c04fe: entered by fall-through of je at 0x004c04fc, 2 instruction(s), ends with je to 0x004c066f (forward)
    cmp dword ptr [ebp - local_8], 0x4           # 004c04fe
    je.d32 L_004c066f                            # 004c0502
    # block 0x004c0508: entered by fall-through of je at 0x004c0502, 1 instruction(s), ends with forward jump to 0x004c076e
    jmp.d32 L_004c076e                           # 004c0508
L_004c050d:
    # block 0x004c050d: entered by je at 0x004c04fc, 3 instruction(s), ends with je to 0x004c0537 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004c050d
    test edx, edx                                # 004c0514
    je.d8 L_004c0537                             # 004c0516
    # block 0x004c0518: entered by fall-through of je at 0x004c0516, 7 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004c0537
    push 0x5529e0                                # 004c0518
    push 0x63888b                                # 004c051d
    call FUN_0050ca3e                            # 004c0522
    add esp, 0x8                                 # 004c0527
    push 0x63888b                                # 004c052a
    call FUN_0044a2b7                            # 004c052f
    add esp, 0x4                                 # 004c0534
L_004c0537:
    # block 0x004c0537: entered by je at 0x004c0516, 7 instruction(s), calls FUN_004bef85, ends with je to 0x004c066a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c0537
    mov ecx, dword ptr [eax + field_18e]         # 004c053a
    push ecx                                     # 004c0540
    mov ecx, 0x6201f9                            # 004c0541
    call FUN_004bef85                            # 004c0546
    test eax, eax                                # 004c054b
    je.d32 L_004c066a                            # 004c054d
    # block 0x004c0553: entered by fall-through of je at 0x004c054d, 49 instruction(s), calls FUN_004befc8, FUN_004bf098, FUN_004bee2c, FUN_004c0ab1, FUN_004c08d3, FUN_004bf10f, ends with je to 0x004c063e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c0553
    mov eax, dword ptr [edx + field_18e]         # 004c0556
    push eax                                     # 004c055c
    mov ecx, 0x6201f9                            # 004c055d
    call FUN_004befc8                            # 004c0562
    push 0x0                                     # 004c0567
    push 0x0                                     # 004c0569
    mov ecx, dword ptr [ebp - local_4]           # 004c056b
    mov edx, dword ptr [ecx + field_222]         # 004c056e
    movsx eax, word ptr [edx + field_2d]         # 004c0574
    push eax                                     # 004c0578
    mov ecx, dword ptr [ebp - local_4]           # 004c0579
    mov edx, dword ptr [ecx + field_222]         # 004c057c
    movsx eax, word ptr [edx + field_2f]         # 004c0582
    push eax                                     # 004c0586
    mov ecx, dword ptr [ebp - local_4]           # 004c0587
    mov edx, dword ptr [ecx + field_222]         # 004c058a
    mov eax, dword ptr [edx]                     # 004c0590
    push eax                                     # 004c0592
    mov ecx, dword ptr [ebp - local_4]           # 004c0593
    mov edx, dword ptr [ecx + field_18e]         # 004c0596
    push edx                                     # 004c059c
    mov ecx, 0x6201f9                            # 004c059d
    call FUN_004bf098                            # 004c05a2
    mov eax, dword ptr [ebp - local_4]           # 004c05a7
    mov ecx, dword ptr [eax + field_18e]         # 004c05aa
    push ecx                                     # 004c05b0
    mov ecx, 0x6201f9                            # 004c05b1
    call FUN_004bee2c                            # 004c05b6
    sub eax, 0x1                                 # 004c05bb
    mov edx, dword ptr [ebp - local_4]           # 004c05be
    mov word ptr [edx + field_244], ax           # 004c05c1
    mov ecx, dword ptr [ebp - local_4]           # 004c05c8
    call FUN_004c0ab1                            # 004c05cb
    mov eax, dword ptr [ebp - local_4]           # 004c05d0
    mov dword ptr [eax + field_216], 0x1         # 004c05d3
    mov ecx, dword ptr [ebp - local_4]           # 004c05dd
    mov dword ptr [ecx + field_240], 0x2         # 004c05e0
    mov edx, dword ptr [ebp - local_4]           # 004c05ea
    mov dword ptr [edx + field_21a], 0x1         # 004c05ed
    mov ecx, dword ptr [ebp - local_4]           # 004c05f7
    call FUN_004c08d3                            # 004c05fa
    mov eax, dword ptr [ebp - local_4]           # 004c05ff
    mov ecx, dword ptr [eax + field_18e]         # 004c0602
    push ecx                                     # 004c0608
    mov ecx, 0x6201f9                            # 004c0609
    call FUN_004bf10f                            # 004c060e
    test eax, eax                                # 004c0613
    je.d8 L_004c063e                             # 004c0615
    # block 0x004c0617: entered by fall-through of je at 0x004c0615, 5 instruction(s), ends with je to 0x004c063c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c0617
    mov dword ptr [edx + field_1da], 0x4         # 004c061a
    movsx eax, word ptr [0x63a4cd]               # 004c0624
    test eax, eax                                # 004c062b
    je.d8 L_004c063c                             # 004c062d
    # block 0x004c062f: entered by fall-through of je at 0x004c062d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c063c
    push 0x552a14                                # 004c062f
    call FUN_0044a2b7                            # 004c0634
    add esp, 0x4                                 # 004c0639
L_004c063c:
    # block 0x004c063c: entered by je at 0x004c062d, 1 instruction(s), ends with forward jump to 0x004c066a
    jmp.d8 L_004c066a                            # 004c063c
L_004c063e:
    # block 0x004c063e: entered by je at 0x004c0615, 6 instruction(s), ends with je to 0x004c066a (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004c063e
    imul ecx, ecx, 0x8d                          # 004c0642
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004c0648
    movsx edx, word ptr [0x63a4cd]               # 004c0652
    test edx, edx                                # 004c0659
    je.d8 L_004c066a                             # 004c065b
    # block 0x004c065d: entered by fall-through of je at 0x004c065b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c066a
    push 0x552a58                                # 004c065d
    call FUN_0044a2b7                            # 004c0662
    add esp, 0x4                                 # 004c0667
L_004c066a:
    # block 0x004c066a: entered by je at 0x004c054d; jmp at 0x004c063c; je at 0x004c065b, 1 instruction(s), ends with forward jump to 0x004c076e
    jmp.d32 L_004c076e                           # 004c066a
L_004c066f:
    # block 0x004c066f: entered by je at 0x004c0502, 7 instruction(s), calls FUN_004bef85, ends with je to 0x004c076e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c066f
    mov ecx, dword ptr [eax + field_18e]         # 004c0672
    push ecx                                     # 004c0678
    mov ecx, 0x6201f9                            # 004c0679
    call FUN_004bef85                            # 004c067e
    test eax, eax                                # 004c0683
    je.d32 L_004c076e                            # 004c0685
    # block 0x004c068b: entered by fall-through of je at 0x004c0685, 47 instruction(s), calls FUN_004befc8, FUN_004bf098, FUN_004bee2c, FUN_004c0ab1, FUN_004c08d3, FUN_004bf10f, ends with jne to 0x004c076e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004c068b
    mov eax, dword ptr [edx + field_18e]         # 004c068e
    push eax                                     # 004c0694
    mov ecx, 0x6201f9                            # 004c0695
    call FUN_004befc8                            # 004c069a
    push 0x0                                     # 004c069f
    push 0x0                                     # 004c06a1
    mov ecx, dword ptr [ebp - local_4]           # 004c06a3
    mov edx, dword ptr [ecx + field_222]         # 004c06a6
    movsx eax, word ptr [edx + field_2d]         # 004c06ac
    push eax                                     # 004c06b0
    mov ecx, dword ptr [ebp - local_4]           # 004c06b1
    mov edx, dword ptr [ecx + field_222]         # 004c06b4
    movsx eax, word ptr [edx + field_2f]         # 004c06ba
    push eax                                     # 004c06be
    mov ecx, dword ptr [ebp - local_4]           # 004c06bf
    mov edx, dword ptr [ecx + field_222]         # 004c06c2
    mov eax, dword ptr [edx]                     # 004c06c8
    push eax                                     # 004c06ca
    mov ecx, dword ptr [ebp - local_4]           # 004c06cb
    mov edx, dword ptr [ecx + field_18e]         # 004c06ce
    push edx                                     # 004c06d4
    mov ecx, 0x6201f9                            # 004c06d5
    call FUN_004bf098                            # 004c06da
    mov eax, dword ptr [ebp - local_4]           # 004c06df
    mov ecx, dword ptr [eax + field_18e]         # 004c06e2
    push ecx                                     # 004c06e8
    mov ecx, 0x6201f9                            # 004c06e9
    call FUN_004bee2c                            # 004c06ee
    sub eax, 0x1                                 # 004c06f3
    mov edx, dword ptr [ebp - local_4]           # 004c06f6
    mov word ptr [edx + field_244], ax           # 004c06f9
    mov ecx, dword ptr [ebp - local_4]           # 004c0700
    call FUN_004c0ab1                            # 004c0703
    mov eax, dword ptr [ebp - local_4]           # 004c0708
    mov dword ptr [eax + field_216], 0x1         # 004c070b
    mov ecx, dword ptr [ebp - local_4]           # 004c0715
    mov dword ptr [ecx + field_240], 0x2         # 004c0718
    mov ecx, dword ptr [ebp - local_4]           # 004c0722
    call FUN_004c08d3                            # 004c0725
    mov edx, dword ptr [ebp - local_4]           # 004c072a
    mov eax, dword ptr [edx + field_18e]         # 004c072d
    push eax                                     # 004c0733
    mov ecx, 0x6201f9                            # 004c0734
    call FUN_004bf10f                            # 004c0739
    test eax, eax                                # 004c073e
    jne.d8 L_004c076e                            # 004c0740
    # block 0x004c0742: entered by fall-through of jne at 0x004c0740, 6 instruction(s), ends with je to 0x004c076e (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004c0742
    imul ecx, ecx, 0x8d                          # 004c0746
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004c074c
    movsx edx, word ptr [0x63a4cd]               # 004c0756
    test edx, edx                                # 004c075d
    je.d8 L_004c076e                             # 004c075f
    # block 0x004c0761: entered by fall-through of je at 0x004c075f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c076e
    push 0x552ac4                                # 004c0761
    call FUN_0044a2b7                            # 004c0766
    add esp, 0x4                                 # 004c076b
L_004c076e:
    # block 0x004c076e: entered by jmp at 0x004c0508; jmp at 0x004c066a; je at 0x004c0685; jne at 0x004c0740; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004c076e
    pop ebp                                      # 004c0770
    ret 0x4                                      # 004c0771

