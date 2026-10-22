# FUN_004c952f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c952f
# extent:       0x004c952f-0x004c97b4 (645 code bytes)
# span:         0x004c952f-0x004c97b4 (code 645, tables 0, padding 0)
# sha256:       f94d1bfa5c2721adb8ee35614b28d56f842ba8dfbcd3a1fb08eb148fc74f5387
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c952f
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4, field_8, field_c, field_e88, field_38b0; [ecx + n] field_4, field_8, field_f84, field_f88, field_f8c, field_f90, field_38b0; [edx + n] field_e88, field_e8a, field_f84, field_f88, field_f8c, field_f90
# callees:      calls FUN_004c94ec, FUN_0052139c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27b.c:m4c5377_blit_rows (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 167 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_e88, 0xe88  # offset +0xe88
.equ field_e8a, 0xe8a  # offset +0xe8a
.equ field_f84, 0xf84  # offset +0xf84
.equ field_f88, 0xf88  # offset +0xf88
.equ field_f8c, 0xf8c  # offset +0xf8c
.equ field_f90, 0xf90  # offset +0xf90
.equ field_38b0, 0x38b0  # offset +0x38b0

# --- external targets -----------------------------------------------
.set FUN_004c94ec, .text + (0x004c94ec - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c952f - 0x401000
.globl FUN_004c952f
FUN_004c952f:
    # block 0x004c952f: entry, 7 instruction(s), ends with je to 0x004c957f (forward)
    push ebp                                     # 004c952f
    {load} mov ebp, esp                          # 004c9530
    sub esp, 0x1c                                # 004c9532
    mov dword ptr [ebp - local_1c], ecx          # 004c9535
    mov eax, dword ptr [ebp - local_1c]          # 004c9538
    cmp dword ptr [eax + field_38b0], 0x0        # 004c953b
    je.d8 L_004c957f                             # 004c9542
    # block 0x004c9544: entered by fall-through of je at 0x004c9542, 12 instruction(s), calls FUN_004c94ec, ends with forward jump to 0x004c97ac
    mov ecx, dword ptr [ebp - local_1c]          # 004c9544
    call FUN_004c94ec                            # 004c9547
    mov ecx, dword ptr [ebp - local_1c]          # 004c954c
    mov dword ptr [ecx + field_38b0], 0x0        # 004c954f
    mov dword ptr [ebp - local_14], 0x0          # 004c9559
    mov edx, dword ptr [ebp - local_14]          # 004c9560
    mov dword ptr [ebp - local_10], edx          # 004c9563
    movsx eax, word ptr [0x63988b]               # 004c9566
    mov dword ptr [ebp - local_c], eax           # 004c956d
    movsx ecx, word ptr [0x63988d]               # 004c9570
    mov dword ptr [ebp - local_8], ecx           # 004c9577
    jmp.d32 L_004c97ac                           # 004c957a
L_004c957f:
    # block 0x004c957f: entered by je at 0x004c9542, 4 instruction(s), ends with jl to 0x004c95a3 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004c957f
    movsx eax, word ptr [edx + field_e88]        # 004c9582
    cmp eax, 0xfa                                # 004c9589
    jl.d8 L_004c95a3                             # 004c958e
    # block 0x004c9590: entered by fall-through of jl at 0x004c958e, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x004c97ae
    push 0x0                                     # 004c9590
    push 0x0                                     # 004c9592
    push 0x557b30                                # 004c9594
    call FUN_0052139c                            # 004c9599
    jmp.d32 L_004c97ae                           # 004c959e
L_004c95a3:
    # block 0x004c95a3: entered by jl at 0x004c958e, 17 instruction(s), ends with forward jump to 0x004c95e7
    mov ecx, dword ptr [ebp + arg_8]             # 004c95a3
    mov edx, dword ptr [ecx + field_4]           # 004c95a6
    mov dword ptr [ebp - local_10], edx          # 004c95a9
    mov eax, dword ptr [ebp + arg_8]             # 004c95ac
    mov ecx, dword ptr [eax + field_c]           # 004c95af
    add ecx, 0x1                                 # 004c95b2
    mov dword ptr [ebp - local_8], ecx           # 004c95b5
    mov edx, dword ptr [ebp + arg_8]             # 004c95b8
    mov eax, dword ptr [edx]                     # 004c95bb
    mov dword ptr [ebp - local_14], eax          # 004c95bd
    mov ecx, dword ptr [ebp + arg_8]             # 004c95c0
    mov edx, dword ptr [ecx + field_8]           # 004c95c3
    add edx, 0x1                                 # 004c95c6
    mov dword ptr [ebp - local_c], edx           # 004c95c9
    mov dword ptr [ebp - local_18], 0x0          # 004c95cc
    mov word ptr [ebp - local_4], 0x0            # 004c95d3
    jmp.d8 L_004c95e7                            # 004c95d9
L_004c95db:
    # block 0x004c95db: entered by jmp at 0x004c9611; jmp at 0x004c9742, 3 instruction(s), falls into the block at 0x004c95e7
    mov ax, word ptr [ebp - local_4]             # 004c95db
    .insn 0x66, 0x05, 0x0001{:u16}               # 004c95df
    mov word ptr [ebp - local_4], ax             # 004c95e3
L_004c95e7:
    # block 0x004c95e7: entered by jmp at 0x004c95d9, 5 instruction(s), ends with jge to 0x004c9747 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c95e7
    mov edx, dword ptr [ebp - local_1c]          # 004c95eb
    movsx eax, word ptr [edx + field_e88]        # 004c95ee
    {load} cmp ecx, eax                          # 004c95f5
    jge.d32 L_004c9747                           # 004c95f7
    # block 0x004c95fd: entered by fall-through of jge at 0x004c95f7, 6 instruction(s), ends with jne to 0x004c9613 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c95fd
    mov edx, dword ptr [ebp - local_1c]          # 004c9601
    {load} xor eax, eax                          # 004c9604
    mov al, byte ptr [edx + ecx + field_e8a]     # 004c9606
    test eax, eax                                # 004c960d
    jne.d8 L_004c9613                            # 004c960f
    # block 0x004c9611: entered by fall-through of jne at 0x004c960f, 1 instruction(s), ends with backward jump to 0x004c95db
    jmp.d8 L_004c95db                            # 004c9611
L_004c9613:
    # block 0x004c9613: entered by jne at 0x004c960f, 6 instruction(s), ends with jl to 0x004c9670 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c9613
    shl ecx, 0x4                                 # 004c9617
    mov edx, dword ptr [ebp - local_1c]          # 004c961a
    mov eax, dword ptr [ebp - local_10]          # 004c961d
    cmp eax, dword ptr [edx + ecx + field_f88]   # 004c9620
    jl.d8 L_004c9670                             # 004c9627
    # block 0x004c9629: entered by fall-through of jl at 0x004c9627, 6 instruction(s), ends with jg to 0x004c9670 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c9629
    shl ecx, 0x4                                 # 004c962d
    mov edx, dword ptr [ebp - local_1c]          # 004c9630
    mov eax, dword ptr [ebp - local_8]           # 004c9633
    cmp eax, dword ptr [edx + ecx + field_f90]   # 004c9636
    jg.d8 L_004c9670                             # 004c963d
    # block 0x004c963f: entered by fall-through of jg at 0x004c963d, 6 instruction(s), ends with jl to 0x004c9670 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c963f
    shl ecx, 0x4                                 # 004c9643
    mov edx, dword ptr [ebp - local_1c]          # 004c9646
    mov eax, dword ptr [ebp - local_14]          # 004c9649
    cmp eax, dword ptr [edx + ecx + field_f84]   # 004c964c
    jl.d8 L_004c9670                             # 004c9653
    # block 0x004c9655: entered by fall-through of jl at 0x004c9653, 6 instruction(s), ends with jg to 0x004c9670 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c9655
    shl ecx, 0x4                                 # 004c9659
    mov edx, dword ptr [ebp - local_1c]          # 004c965c
    mov eax, dword ptr [ebp - local_c]           # 004c965f
    cmp eax, dword ptr [edx + ecx + field_f8c]   # 004c9662
    jg.d8 L_004c9670                             # 004c9669
    # block 0x004c966b: entered by fall-through of jg at 0x004c9669, 1 instruction(s), ends with forward jump to 0x004c97ae
    jmp.d32 L_004c97ae                           # 004c966b
L_004c9670:
    # block 0x004c9670: entered by jl at 0x004c9627; jg at 0x004c963d; jl at 0x004c9653; jg at 0x004c9669, 6 instruction(s), ends with jg to 0x004c9742 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c9670
    shl ecx, 0x4                                 # 004c9674
    mov edx, dword ptr [ebp - local_1c]          # 004c9677
    mov eax, dword ptr [ebp - local_10]          # 004c967a
    cmp eax, dword ptr [edx + ecx + field_f88]   # 004c967d
    jg.d32 L_004c9742                            # 004c9684
    # block 0x004c968a: entered by fall-through of jg at 0x004c9684, 6 instruction(s), ends with jl to 0x004c9742 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c968a
    shl ecx, 0x4                                 # 004c968e
    mov edx, dword ptr [ebp - local_1c]          # 004c9691
    mov eax, dword ptr [ebp - local_8]           # 004c9694
    cmp eax, dword ptr [edx + ecx + field_f90]   # 004c9697
    jl.d32 L_004c9742                            # 004c969e
    # block 0x004c96a4: entered by fall-through of jl at 0x004c969e, 6 instruction(s), ends with jg to 0x004c9742 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c96a4
    shl ecx, 0x4                                 # 004c96a8
    mov edx, dword ptr [ebp - local_1c]          # 004c96ab
    mov eax, dword ptr [ebp - local_14]          # 004c96ae
    cmp eax, dword ptr [edx + ecx + field_f84]   # 004c96b1
    jg.d32 L_004c9742                            # 004c96b8
    # block 0x004c96be: entered by fall-through of jg at 0x004c96b8, 6 instruction(s), ends with jl to 0x004c9742 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004c96be
    shl ecx, 0x4                                 # 004c96c2
    mov edx, dword ptr [ebp - local_1c]          # 004c96c5
    mov eax, dword ptr [ebp - local_c]           # 004c96c8
    cmp eax, dword ptr [edx + ecx + field_f8c]   # 004c96cb
    jl.d8 L_004c9742                             # 004c96d2
    # block 0x004c96d4: entered by fall-through of jl at 0x004c96d2, 2 instruction(s), ends with je to 0x004c96eb (forward)
    cmp dword ptr [ebp - local_18], 0x0          # 004c96d4
    je.d8 L_004c96eb                             # 004c96d8
    # block 0x004c96da: entered by fall-through of je at 0x004c96d8, 4 instruction(s), ends with forward jump to 0x004c9742
    movsx ecx, word ptr [ebp - local_4]          # 004c96da
    mov edx, dword ptr [ebp - local_1c]          # 004c96de
    mov byte ptr [edx + ecx + field_e8a], 0x0    # 004c96e1
    jmp.d8 L_004c9742                            # 004c96e9
L_004c96eb:
    # block 0x004c96eb: entered by je at 0x004c96d8, 21 instruction(s), falls into the block at 0x004c9742
    movsx eax, word ptr [ebp - local_4]          # 004c96eb
    shl eax, 0x4                                 # 004c96ef
    mov ecx, dword ptr [ebp - local_1c]          # 004c96f2
    mov edx, dword ptr [ebp - local_10]          # 004c96f5
    mov dword ptr [ecx + eax + field_f88], edx   # 004c96f8
    movsx eax, word ptr [ebp - local_4]          # 004c96ff
    shl eax, 0x4                                 # 004c9703
    mov ecx, dword ptr [ebp - local_1c]          # 004c9706
    mov edx, dword ptr [ebp - local_8]           # 004c9709
    mov dword ptr [ecx + eax + field_f90], edx   # 004c970c
    movsx eax, word ptr [ebp - local_4]          # 004c9713
    shl eax, 0x4                                 # 004c9717
    mov ecx, dword ptr [ebp - local_1c]          # 004c971a
    mov edx, dword ptr [ebp - local_14]          # 004c971d
    mov dword ptr [ecx + eax + field_f84], edx   # 004c9720
    movsx eax, word ptr [ebp - local_4]          # 004c9727
    shl eax, 0x4                                 # 004c972b
    mov ecx, dword ptr [ebp - local_1c]          # 004c972e
    mov edx, dword ptr [ebp - local_c]           # 004c9731
    mov dword ptr [ecx + eax + field_f8c], edx   # 004c9734
    mov dword ptr [ebp - local_18], 0x1          # 004c973b
L_004c9742:
    # block 0x004c9742: entered by jg at 0x004c9684; jl at 0x004c969e; jg at 0x004c96b8; jl at 0x004c96d2; jmp at 0x004c96e9, 1 instruction(s), ends with backward jump to 0x004c95db
    jmp.d32 L_004c95db                           # 004c9742
L_004c9747:
    # block 0x004c9747: entered by jge at 0x004c95f7, 2 instruction(s), ends with je to 0x004c974f (forward)
    cmp dword ptr [ebp - local_18], 0x0          # 004c9747
    je.d8 L_004c974f                             # 004c974b
    # block 0x004c974d: entered by fall-through of je at 0x004c974b, 1 instruction(s), ends with forward jump to 0x004c97ae
    jmp.d8 L_004c97ae                            # 004c974d
L_004c974f:
    # block 0x004c974f: entered by je at 0x004c974b; jmp at 0x004c97ac, 23 instruction(s), ends with forward jump to 0x004c97ae
    mov eax, dword ptr [ebp - local_1c]          # 004c974f
    movsx ecx, word ptr [eax + field_e88]        # 004c9752
    shl ecx, 0x4                                 # 004c9759
    mov edx, dword ptr [ebp - local_1c]          # 004c975c
    lea eax, [edx + ecx + field_f84]             # 004c975f
    mov ecx, dword ptr [ebp - local_14]          # 004c9766
    mov dword ptr [eax], ecx                     # 004c9769
    mov edx, dword ptr [ebp - local_10]          # 004c976b
    mov dword ptr [eax + field_4], edx           # 004c976e
    mov ecx, dword ptr [ebp - local_c]           # 004c9771
    mov dword ptr [eax + field_8], ecx           # 004c9774
    mov edx, dword ptr [ebp - local_8]           # 004c9777
    mov dword ptr [eax + field_c], edx           # 004c977a
    mov eax, dword ptr [ebp - local_1c]          # 004c977d
    movsx ecx, word ptr [eax + field_e88]        # 004c9780
    mov edx, dword ptr [ebp - local_1c]          # 004c9787
    mov byte ptr [edx + ecx + field_e8a], 0x1    # 004c978a
    mov eax, dword ptr [ebp - local_1c]          # 004c9792
    mov cx, word ptr [eax + field_e88]           # 004c9795
    add cx, 0x1                                  # 004c979c
    mov edx, dword ptr [ebp - local_1c]          # 004c97a0
    mov word ptr [edx + field_e88], cx           # 004c97a3
    jmp.d8 L_004c97ae                            # 004c97aa
L_004c97ac:
    # block 0x004c97ac: entered by jmp at 0x004c957a, 1 instruction(s), ends with backward jump to 0x004c974f
    jmp.d8 L_004c974f                            # 004c97ac
L_004c97ae:
    # block 0x004c97ae: entered by jmp at 0x004c959e; jmp at 0x004c966b; jmp at 0x004c974d; jmp at 0x004c97aa, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004c97ae
    pop ebp                                      # 004c97b0
    ret 0x4                                      # 004c97b1

