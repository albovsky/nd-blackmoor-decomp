# FUN_004a6574
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a6574
# extent:       0x004a6574-0x004a67f3 (639 code bytes)
# span:         0x004a6574-0x004a67f3 (code 639, tables 0, padding 0)
# sha256:       f69edef4407e87c1abcbebbd9706e1d525e8c76ba01f411a396c6026a0be7b09
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a6574_hit_test
# naming:       native port src/original_methods_fl24a.c:m4a6574_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4a6574_hit_test (five rectangles, tail; the uninitialised-slot path of the original is rejected, see handoff). Differential and oracle: every instruction reached.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_20, field_2e, field_63, field_6a, field_6e, field_86, field_1ba, field_1be, field_1d6, field_2ba, field_2c2 and 2 more; [ecx + n] field_20, field_29, field_2e, field_65, field_66, field_86, field_1b6, field_1e2, field_2b2, field_2b6, field_2be, field_3d3; [edx + n] field_65, field_72, field_1c2, field_1da, field_1de, field_2ae, field_2ca, field_3cb, field_3cf
# callees:      calls FUN_004a67f3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24a.c:m4a6574_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 179 instruction(s), 32 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_29, 0x29  # offset +0x29
.equ field_2e, 0x2e  # offset +0x2e
.equ field_63, 0x63  # offset +0x63
.equ field_65, 0x65  # offset +0x65
.equ field_66, 0x66  # offset +0x66
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6e, 0x6e  # offset +0x6e
.equ field_72, 0x72  # offset +0x72
.equ field_86, 0x86  # offset +0x86
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1be, 0x1be  # offset +0x1be
.equ field_1c2, 0x1c2  # offset +0x1c2
.equ field_1d6, 0x1d6  # offset +0x1d6
.equ field_1da, 0x1da  # offset +0x1da
.equ field_1de, 0x1de  # offset +0x1de
.equ field_1e2, 0x1e2  # offset +0x1e2
.equ field_2ae, 0x2ae  # offset +0x2ae
.equ field_2b2, 0x2b2  # offset +0x2b2
.equ field_2b6, 0x2b6  # offset +0x2b6
.equ field_2ba, 0x2ba  # offset +0x2ba
.equ field_2be, 0x2be  # offset +0x2be
.equ field_2c2, 0x2c2  # offset +0x2c2
.equ field_2c6, 0x2c6  # offset +0x2c6
.equ field_2ca, 0x2ca  # offset +0x2ca
.equ field_3c7, 0x3c7  # offset +0x3c7
.equ field_3cb, 0x3cb  # offset +0x3cb
.equ field_3cf, 0x3cf  # offset +0x3cf
.equ field_3d3, 0x3d3  # offset +0x3d3

# --- external targets -----------------------------------------------
.set FUN_004a67f3, .text + (0x004a67f3 - 0x401000)

.org 0x004a6574 - 0x401000
.globl FUN_004a6574
FUN_004a6574:
    # block 0x004a6574: entry, 7 instruction(s), ends with je to 0x004a679f (forward)
    push ebp                                     # 004a6574
    {load} mov ebp, esp                          # 004a6575
    sub esp, 0x8                                 # 004a6577
    mov dword ptr [ebp - local_8], ecx           # 004a657a
    mov eax, dword ptr [ebp - local_8]           # 004a657d
    cmp dword ptr [eax + field_86], 0x0          # 004a6580
    je.d32 L_004a679f                            # 004a6587
    # block 0x004a658d: entered by fall-through of je at 0x004a6587, 5 instruction(s), ends with jne to 0x004a679f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004a658d
    {load} xor edx, edx                          # 004a6590
    mov dl, byte ptr [ecx + field_29]            # 004a6592
    test edx, edx                                # 004a6595
    jne.d32 L_004a679f                           # 004a6597
    # block 0x004a659d: entered by fall-through of jne at 0x004a6597, 9 instruction(s), ends with jl to 0x004a6629 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004a659d
    movsx ecx, word ptr [eax + field_1e]         # 004a65a0
    imul ecx, ecx, 0x8d                          # 004a65a4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a65aa
    mov dword ptr [ebp - local_4], edx           # 004a65b0
    movsx eax, word ptr [ebp + arg_c]            # 004a65b3
    mov ecx, dword ptr [ebp - local_4]           # 004a65b7
    cmp eax, dword ptr [ecx + field_2b2]         # 004a65ba
    jl.d8 L_004a6629                             # 004a65c0
    # block 0x004a65c2: entered by fall-through of jl at 0x004a65c0, 4 instruction(s), ends with jg to 0x004a6629 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004a65c2
    mov eax, dword ptr [ebp - local_4]           # 004a65c6
    cmp edx, dword ptr [eax + field_2ba]         # 004a65c9
    jg.d8 L_004a6629                             # 004a65cf
    # block 0x004a65d1: entered by fall-through of jg at 0x004a65cf, 4 instruction(s), ends with jl to 0x004a6629 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a65d1
    mov edx, dword ptr [ebp - local_4]           # 004a65d5
    cmp ecx, dword ptr [edx + field_2ae]         # 004a65d8
    jl.d8 L_004a6629                             # 004a65de
    # block 0x004a65e0: entered by fall-through of jl at 0x004a65de, 4 instruction(s), ends with jg to 0x004a6629 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004a65e0
    mov ecx, dword ptr [ebp - local_4]           # 004a65e4
    cmp eax, dword ptr [ecx + field_2b6]         # 004a65e7
    jg.d8 L_004a6629                             # 004a65ed
    # block 0x004a65ef: entered by fall-through of jg at 0x004a65ed, 5 instruction(s), ends with jne to 0x004a6610 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a65ef
    {load} xor eax, eax                          # 004a65f2
    mov al, byte ptr [edx + field_65]            # 004a65f4
    test eax, eax                                # 004a65f7
    jne.d8 L_004a6610                            # 004a65f9
    # block 0x004a65fb: entered by fall-through of jne at 0x004a65f9, 7 instruction(s), ends with jge to 0x004a6629 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004a65fb
    movsx edx, word ptr [ecx + field_2e]         # 004a65fe
    mov eax, dword ptr [ebp - local_4]           # 004a6602
    movsx ecx, word ptr [eax + field_63]         # 004a6605
    sub ecx, 0x1                                 # 004a6609
    {load} cmp edx, ecx                          # 004a660c
    jge.d8 L_004a6629                            # 004a660e
L_004a6610:
    # block 0x004a6610: entered by jne at 0x004a65f9; fall-through of jge at 0x004a660e, 6 instruction(s), calls FUN_004a67f3, ends with forward jump to 0x004a67ed
    push 0x3                                     # 004a6610
    push 0x2772                                  # 004a6612
    mov ecx, dword ptr [ebp - local_8]           # 004a6617
    call FUN_004a67f3                            # 004a661a
    mov eax, 0x1                                 # 004a661f
    jmp.d32 L_004a67ed                           # 004a6624
L_004a6629:
    # block 0x004a6629: entered by jl at 0x004a65c0; jg at 0x004a65cf; jl at 0x004a65de; jg at 0x004a65ed; jge at 0x004a660e, 4 instruction(s), ends with jl to 0x004a6695 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004a6629
    mov eax, dword ptr [ebp - local_4]           # 004a662d
    cmp edx, dword ptr [eax + field_2c2]         # 004a6630
    jl.d8 L_004a6695                             # 004a6636
    # block 0x004a6638: entered by fall-through of jl at 0x004a6636, 4 instruction(s), ends with jg to 0x004a6695 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a6638
    mov edx, dword ptr [ebp - local_4]           # 004a663c
    cmp ecx, dword ptr [edx + field_2ca]         # 004a663f
    jg.d8 L_004a6695                             # 004a6645
    # block 0x004a6647: entered by fall-through of jg at 0x004a6645, 4 instruction(s), ends with jl to 0x004a6695 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004a6647
    mov ecx, dword ptr [ebp - local_4]           # 004a664b
    cmp eax, dword ptr [ecx + field_2be]         # 004a664e
    jl.d8 L_004a6695                             # 004a6654
    # block 0x004a6656: entered by fall-through of jl at 0x004a6654, 4 instruction(s), ends with jg to 0x004a6695 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004a6656
    mov eax, dword ptr [ebp - local_4]           # 004a665a
    cmp edx, dword ptr [eax + field_2c6]         # 004a665d
    jg.d8 L_004a6695                             # 004a6663
    # block 0x004a6665: entered by fall-through of jg at 0x004a6663, 5 instruction(s), ends with jne to 0x004a667c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a6665
    {load} xor edx, edx                          # 004a6668
    mov dl, byte ptr [ecx + field_65]            # 004a666a
    test edx, edx                                # 004a666d
    jne.d8 L_004a667c                            # 004a666f
    # block 0x004a6671: entered by fall-through of jne at 0x004a666f, 4 instruction(s), ends with jle to 0x004a6695 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004a6671
    movsx ecx, word ptr [eax + field_2e]         # 004a6674
    test ecx, ecx                                # 004a6678
    jle.d8 L_004a6695                            # 004a667a
L_004a667c:
    # block 0x004a667c: entered by jne at 0x004a666f; fall-through of jle at 0x004a667a, 6 instruction(s), calls FUN_004a67f3, ends with forward jump to 0x004a67ed
    push 0x2                                     # 004a667c
    push 0x2771                                  # 004a667e
    mov ecx, dword ptr [ebp - local_8]           # 004a6683
    call FUN_004a67f3                            # 004a6686
    mov eax, 0x1                                 # 004a668b
    jmp.d32 L_004a67ed                           # 004a6690
L_004a6695:
    # block 0x004a6695: entered by jl at 0x004a6636; jg at 0x004a6645; jl at 0x004a6654; jg at 0x004a6663; jle at 0x004a667a, 4 instruction(s), ends with jl to 0x004a66ea (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004a6695
    mov eax, dword ptr [ebp - local_4]           # 004a6699
    cmp edx, dword ptr [eax + field_1ba]         # 004a669c
    jl.d8 L_004a66ea                             # 004a66a2
    # block 0x004a66a4: entered by fall-through of jl at 0x004a66a2, 4 instruction(s), ends with jg to 0x004a66ea (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a66a4
    mov edx, dword ptr [ebp - local_4]           # 004a66a8
    cmp ecx, dword ptr [edx + field_1c2]         # 004a66ab
    jg.d8 L_004a66ea                             # 004a66b1
    # block 0x004a66b3: entered by fall-through of jg at 0x004a66b1, 4 instruction(s), ends with jl to 0x004a66ea (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004a66b3
    mov ecx, dword ptr [ebp - local_4]           # 004a66b7
    cmp eax, dword ptr [ecx + field_1b6]         # 004a66ba
    jl.d8 L_004a66ea                             # 004a66c0
    # block 0x004a66c2: entered by fall-through of jl at 0x004a66c0, 4 instruction(s), ends with jg to 0x004a66ea (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004a66c2
    mov eax, dword ptr [ebp - local_4]           # 004a66c6
    cmp edx, dword ptr [eax + field_1be]         # 004a66c9
    jg.d8 L_004a66ea                             # 004a66cf
    # block 0x004a66d1: entered by fall-through of jg at 0x004a66cf, 6 instruction(s), calls FUN_004a67f3, ends with forward jump to 0x004a67ed
    push 0x1                                     # 004a66d1
    push 0x276f                                  # 004a66d3
    mov ecx, dword ptr [ebp - local_8]           # 004a66d8
    call FUN_004a67f3                            # 004a66db
    mov eax, 0x1                                 # 004a66e0
    jmp.d32 L_004a67ed                           # 004a66e5
L_004a66ea:
    # block 0x004a66ea: entered by jl at 0x004a66a2; jg at 0x004a66b1; jl at 0x004a66c0; jg at 0x004a66cf, 4 instruction(s), ends with jl to 0x004a6746 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a66ea
    mov edx, dword ptr [ebp - local_4]           # 004a66ee
    cmp ecx, dword ptr [edx + field_1da]         # 004a66f1
    jl.d8 L_004a6746                             # 004a66f7
    # block 0x004a66f9: entered by fall-through of jl at 0x004a66f7, 4 instruction(s), ends with jg to 0x004a6746 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004a66f9
    mov ecx, dword ptr [ebp - local_4]           # 004a66fd
    cmp eax, dword ptr [ecx + field_1e2]         # 004a6700
    jg.d8 L_004a6746                             # 004a6706
    # block 0x004a6708: entered by fall-through of jg at 0x004a6706, 4 instruction(s), ends with jl to 0x004a6746 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004a6708
    mov eax, dword ptr [ebp - local_4]           # 004a670c
    cmp edx, dword ptr [eax + field_1d6]         # 004a670f
    jl.d8 L_004a6746                             # 004a6715
    # block 0x004a6717: entered by fall-through of jl at 0x004a6715, 4 instruction(s), ends with jg to 0x004a6746 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a6717
    mov edx, dword ptr [ebp - local_4]           # 004a671b
    cmp ecx, dword ptr [edx + field_1de]         # 004a671e
    jg.d8 L_004a6746                             # 004a6724
    # block 0x004a6726: entered by fall-through of jg at 0x004a6724, 8 instruction(s), calls FUN_004a67f3, ends with forward jump to 0x004a67ed
    push 0x4                                     # 004a6726
    push 0x276f                                  # 004a6728
    mov ecx, dword ptr [ebp - local_8]           # 004a672d
    call FUN_004a67f3                            # 004a6730
    mov eax, dword ptr [ebp - local_8]           # 004a6735
    mov byte ptr [eax + field_20], 0x1           # 004a6738
    mov eax, 0x1                                 # 004a673c
    jmp.d32 L_004a67ed                           # 004a6741
L_004a6746:
    # block 0x004a6746: entered by jl at 0x004a66f7; jg at 0x004a6706; jl at 0x004a6715; jg at 0x004a6724, 4 instruction(s), ends with jl to 0x004a679f (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a6746
    mov edx, dword ptr [ebp - local_4]           # 004a674a
    cmp ecx, dword ptr [edx + field_3cb]         # 004a674d
    jl.d8 L_004a679f                             # 004a6753
    # block 0x004a6755: entered by fall-through of jl at 0x004a6753, 4 instruction(s), ends with jg to 0x004a679f (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004a6755
    mov ecx, dword ptr [ebp - local_4]           # 004a6759
    cmp eax, dword ptr [ecx + field_3d3]         # 004a675c
    jg.d8 L_004a679f                             # 004a6762
    # block 0x004a6764: entered by fall-through of jg at 0x004a6762, 4 instruction(s), ends with jl to 0x004a679f (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004a6764
    mov eax, dword ptr [ebp - local_4]           # 004a6768
    cmp edx, dword ptr [eax + field_3c7]         # 004a676b
    jl.d8 L_004a679f                             # 004a6771
    # block 0x004a6773: entered by fall-through of jl at 0x004a6771, 4 instruction(s), ends with jg to 0x004a679f (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a6773
    mov edx, dword ptr [ebp - local_4]           # 004a6777
    cmp ecx, dword ptr [edx + field_3cf]         # 004a677a
    jg.d8 L_004a679f                             # 004a6780
    # block 0x004a6782: entered by fall-through of jg at 0x004a6780, 8 instruction(s), calls FUN_004a67f3, ends with forward jump to 0x004a67ed
    push 0x0                                     # 004a6782
    push 0x2770                                  # 004a6784
    mov ecx, dword ptr [ebp - local_8]           # 004a6789
    call FUN_004a67f3                            # 004a678c
    mov eax, dword ptr [ebp - local_8]           # 004a6791
    mov byte ptr [eax + field_20], 0x1           # 004a6794
    mov eax, 0x1                                 # 004a6798
    jmp.d8 L_004a67ed                            # 004a679d
L_004a679f:
    # block 0x004a679f: entered by je at 0x004a6587; jne at 0x004a6597; jl at 0x004a6753; jg at 0x004a6762; more, 3 instruction(s), ends with je to 0x004a67eb (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004a679f
    cmp dword ptr [ecx + field_86], 0x0          # 004a67a2
    je.d8 L_004a67eb                             # 004a67a9
    # block 0x004a67ab: entered by fall-through of je at 0x004a67a9, 4 instruction(s), ends with jl to 0x004a67db (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004a67ab
    mov eax, dword ptr [ebp - local_4]           # 004a67af
    cmp edx, dword ptr [eax + field_6a]          # 004a67b2
    jl.d8 L_004a67db                             # 004a67b5
    # block 0x004a67b7: entered by fall-through of jl at 0x004a67b5, 4 instruction(s), ends with jg to 0x004a67db (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a67b7
    mov edx, dword ptr [ebp - local_4]           # 004a67bb
    cmp ecx, dword ptr [edx + field_72]          # 004a67be
    jg.d8 L_004a67db                             # 004a67c1
    # block 0x004a67c3: entered by fall-through of jg at 0x004a67c1, 4 instruction(s), ends with jl to 0x004a67db (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004a67c3
    mov ecx, dword ptr [ebp - local_4]           # 004a67c7
    cmp eax, dword ptr [ecx + field_66]          # 004a67ca
    jl.d8 L_004a67db                             # 004a67cd
    # block 0x004a67cf: entered by fall-through of jl at 0x004a67cd, 4 instruction(s), ends with jle to 0x004a67e4 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004a67cf
    mov eax, dword ptr [ebp - local_4]           # 004a67d3
    cmp edx, dword ptr [eax + field_6e]          # 004a67d6
    jle.d8 L_004a67e4                            # 004a67d9
L_004a67db:
    # block 0x004a67db: entered by jl at 0x004a67b5; jg at 0x004a67c1; jl at 0x004a67cd; fall-through of jle at 0x004a67d9, 2 instruction(s), ends with jne to 0x004a67eb (forward)
    cmp dword ptr [0x61d3c2], 0x6                # 004a67db
    jne.d8 L_004a67eb                            # 004a67e2
L_004a67e4:
    # block 0x004a67e4: entered by jle at 0x004a67d9; fall-through of jne at 0x004a67e2, 2 instruction(s), falls into the block at 0x004a67eb
    mov ecx, dword ptr [ebp - local_8]           # 004a67e4
    mov byte ptr [ecx + field_20], 0x1           # 004a67e7
L_004a67eb:
    # block 0x004a67eb: entered by je at 0x004a67a9; jne at 0x004a67e2, 1 instruction(s), falls into the block at 0x004a67ed
    {load} xor eax, eax                          # 004a67eb
L_004a67ed:
    # block 0x004a67ed: entered by jmp at 0x004a6624; jmp at 0x004a6690; jmp at 0x004a66e5; jmp at 0x004a6741; more, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004a67ed
    pop ebp                                      # 004a67ef
    ret 0x8                                      # 004a67f0

