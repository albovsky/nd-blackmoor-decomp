# FUN_004595f1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004595f1
# extent:       0x004595f1-0x004599c4 (979 code bytes)
# span:         0x004595f1-0x004599d0 (code 979, tables 0, padding 12)
# sha256:       2ccb091ab3882e59b72368d4f0c152756775493590f78de8550a69266a8d0634
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4595f1_lifted
# naming:       native port src/original_methods_fl40.c:m4595f1_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 17 seeds; oracle 243/243 instructions, 32/32 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_21, field_25, field_f5, field_1a5, field_1a9, field_1ad, field_1b1; [ecx + n] field_21, field_101, field_1a5, field_335; [edx + n] field_21, field_25, field_f9, field_fd, field_1a5
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4595f1_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 243 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_f5, 0xf5  # offset +0xf5
.equ field_f9, 0xf9  # offset +0xf9
.equ field_fd, 0xfd  # offset +0xfd
.equ field_101, 0x101  # offset +0x101
.equ field_1a5, 0x1a5  # offset +0x1a5
.equ field_1a9, 0x1a9  # offset +0x1a9
.equ field_1ad, 0x1ad  # offset +0x1ad
.equ field_1b1, 0x1b1  # offset +0x1b1
.equ field_335, 0x335  # offset +0x335

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004595f1 - 0x401000
.globl FUN_004595f1
FUN_004595f1:
    # block 0x004595f1: entry, 10 instruction(s), ends with je to 0x00459699 (forward)
    push ebp                                     # 004595f1
    {load} mov ebp, esp                          # 004595f2
    sub esp, 0x20                                # 004595f4
    mov dword ptr [ebp - local_1c], 0x0          # 004595f7
    movsx eax, word ptr [0x61eda1]               # 004595fe
    imul eax, eax, 0x8d                          # 00459605
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045960b
    mov dword ptr [ebp - local_20], ecx          # 00459611
    cmp dword ptr [0x61ee0f], 0x0                # 00459614
    je.d8 L_00459699                             # 0045961b
    # block 0x0045961d: entered by fall-through of je at 0x0045961b, 29 instruction(s), calls FUN_004c5377, falls into the block at 0x00459699
    mov edx, dword ptr [ebp - local_20]          # 0045961d
    mov eax, dword ptr [edx + field_f9]          # 00459620
    sub eax, dword ptr [0x58318a]                # 00459626
    mov dword ptr [ebp - local_10], eax          # 0045962c
    mov ecx, dword ptr [ebp - local_20]          # 0045962f
    mov edx, dword ptr [ecx + field_101]         # 00459632
    sub edx, dword ptr [0x58318a]                # 00459638
    mov dword ptr [ebp - local_8], edx           # 0045963e
    mov eax, dword ptr [ebp - local_20]          # 00459641
    mov ecx, dword ptr [eax + field_f5]          # 00459644
    sub ecx, dword ptr [0x583186]                # 0045964a
    mov dword ptr [ebp - local_14], ecx          # 00459650
    mov edx, dword ptr [ebp - local_20]          # 00459653
    mov eax, dword ptr [edx + field_fd]          # 00459656
    sub eax, dword ptr [0x583186]                # 0045965c
    mov dword ptr [ebp - local_c], eax           # 00459662
    push 0x54a664                                # 00459665
    mov ecx, dword ptr [ebp - local_20]          # 0045966a
    add ecx, 0xf5                                # 0045966d
    push ecx                                     # 00459673
    lea edx, [ebp - local_14]                    # 00459674
    push edx                                     # 00459677
    mov eax, dword ptr [0x5cf665]                # 00459678
    push eax                                     # 0045967d
    mov ecx, dword ptr [0x5d15e3]                # 0045967e
    push ecx                                     # 00459684
    mov ecx, 0x5cf659                            # 00459685
    call FUN_004c5377                            # 0045968a
    mov dword ptr [0x61ee0f], 0x0                # 0045968f
L_00459699:
    # block 0x00459699: entered by je at 0x0045961b, 2 instruction(s), ends with je to 0x004596ab (forward)
    cmp dword ptr [0x61ed9b], 0x4                # 00459699
    je.d8 L_004596ab                             # 004596a0
    # block 0x004596a2: entered by fall-through of je at 0x004596a0, 2 instruction(s), ends with jne to 0x0045971b (forward)
    cmp dword ptr [0x61ed9b], 0x5                # 004596a2
    jne.d8 L_0045971b                            # 004596a9
L_004596ab:
    # block 0x004596ab: entered by je at 0x004596a0; fall-through of jne at 0x004596a9, 2 instruction(s), ends with forward jump to 0x004596bf
    mov word ptr [ebp - local_18], 0x0           # 004596ab
    jmp.d8 L_004596bf                            # 004596b1
L_004596b3:
    # block 0x004596b3: entered by jmp at 0x00459714, 3 instruction(s), falls into the block at 0x004596bf
    mov dx, word ptr [ebp - local_18]            # 004596b3
    add dx, 0x1                                  # 004596b7
    mov word ptr [ebp - local_18], dx            # 004596bb
L_004596bf:
    # block 0x004596bf: entered by jmp at 0x004596b1, 5 instruction(s), ends with jge to 0x00459716 (forward)
    movsx eax, word ptr [ebp - local_18]         # 004596bf
    mov ecx, dword ptr [ebp - local_20]          # 004596c3
    movsx edx, word ptr [ecx + field_21]         # 004596c6
    {load} cmp eax, edx                          # 004596ca
    jge.d8 L_00459716                            # 004596cc
    # block 0x004596ce: entered by fall-through of jge at 0x004596cc, 19 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x004596b3
    push 0x54a680                                # 004596ce
    movsx eax, word ptr [ebp - local_18]         # 004596d3
    shl eax, 0x4                                 # 004596d7
    mov ecx, dword ptr [ebp - local_20]          # 004596da
    lea edx, [ecx + eax + field_335]             # 004596dd
    push edx                                     # 004596e4
    movsx eax, word ptr [ebp - local_18]         # 004596e5
    movsx ecx, word ptr [2*eax + 0x5a4bd6]       # 004596e9
    shl ecx, 0x4                                 # 004596f1
    mov edx, dword ptr [ebp - local_20]          # 004596f4
    lea eax, [edx + ecx + field_25]              # 004596f7
    push eax                                     # 004596fb
    mov ecx, dword ptr [0x5cf665]                # 004596fc
    push ecx                                     # 00459702
    mov edx, dword ptr [0x61ed97]                # 00459703
    push edx                                     # 00459709
    mov ecx, 0x5cf659                            # 0045970a
    call FUN_004c5d4b                            # 0045970f
    jmp.d8 L_004596b3                            # 00459714
L_00459716:
    # block 0x00459716: entered by jge at 0x004596cc, 1 instruction(s), ends with forward jump to 0x004599c0
    jmp.d32 L_004599c0                           # 00459716
L_0045971b:
    # block 0x0045971b: entered by jne at 0x004596a9, 2 instruction(s), ends with jne to 0x0045972d (forward)
    cmp dword ptr [0x61edad], 0x0                # 0045971b
    jne.d8 L_0045972d                            # 00459722
    # block 0x00459724: entered by fall-through of jne at 0x00459722, 2 instruction(s), ends with je to 0x0045975d (forward)
    cmp dword ptr [0x61eda9], 0x0                # 00459724
    je.d8 L_0045975d                             # 0045972b
L_0045972d:
    # block 0x0045972d: entered by jne at 0x00459722; fall-through of je at 0x0045972b, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x0045975d
    push 0x54a698                                # 0045972d
    push 0x61edd9                                # 00459732
    push 0x61edb9                                # 00459737
    mov eax, dword ptr [0x5cf665]                # 0045973c
    push eax                                     # 00459741
    mov ecx, dword ptr [0x5d15e3]                # 00459742
    push ecx                                     # 00459748
    mov ecx, 0x5cf659                            # 00459749
    call FUN_004c5377                            # 0045974e
    mov dword ptr [0x61edad], 0x0                # 00459753
L_0045975d:
    # block 0x0045975d: entered by je at 0x0045972b, 15 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004597a1
    push 0x54a6c8                                # 0045975d
    mov edx, dword ptr [ebp - local_20]          # 00459762
    add edx, 0xd5                                # 00459765
    push edx                                     # 0045976b
    mov eax, dword ptr [ebp - local_20]          # 0045976c
    add eax, 0xc5                                # 0045976f
    push eax                                     # 00459774
    mov ecx, dword ptr [0x5cf665]                # 00459775
    push ecx                                     # 0045977b
    mov edx, dword ptr [0x61ed97]                # 0045977c
    push edx                                     # 00459782
    mov ecx, 0x5cf659                            # 00459783
    call FUN_004c5d4b                            # 00459788
    mov word ptr [ebp - local_18], 0x0           # 0045978d
    jmp.d8 L_004597a1                            # 00459793
L_00459795:
    # block 0x00459795: entered by jmp at 0x004597f6, 3 instruction(s), falls into the block at 0x004597a1
    mov ax, word ptr [ebp - local_18]            # 00459795
    .insn 0x66, 0x05, 0x0001{:u16}               # 00459799
    mov word ptr [ebp - local_18], ax            # 0045979d
L_004597a1:
    # block 0x004597a1: entered by jmp at 0x00459793, 4 instruction(s), ends with jge to 0x004597f8 (forward)
    movsx ecx, word ptr [ebp - local_18]         # 004597a1
    movsx edx, word ptr [0x5a4c08]               # 004597a5
    {load} cmp ecx, edx                          # 004597ac
    jge.d8 L_004597f8                            # 004597ae
    # block 0x004597b0: entered by fall-through of jge at 0x004597ae, 19 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x00459795
    push 0x54a6dc                                # 004597b0
    movsx eax, word ptr [ebp - local_18]         # 004597b5
    shl eax, 0x4                                 # 004597b9
    mov ecx, dword ptr [ebp - local_20]          # 004597bc
    lea edx, [ecx + eax + field_1a5]             # 004597bf
    push edx                                     # 004597c6
    movsx eax, word ptr [ebp - local_18]         # 004597c7
    movsx ecx, word ptr [2*eax + 0x5a4bd6]       # 004597cb
    shl ecx, 0x4                                 # 004597d3
    mov edx, dword ptr [ebp - local_20]          # 004597d6
    lea eax, [edx + ecx + field_25]              # 004597d9
    push eax                                     # 004597dd
    mov ecx, dword ptr [0x5cf665]                # 004597de
    push ecx                                     # 004597e4
    mov edx, dword ptr [0x61ed97]                # 004597e5
    push edx                                     # 004597eb
    mov ecx, 0x5cf659                            # 004597ec
    call FUN_004c5d4b                            # 004597f1
    jmp.d8 L_00459795                            # 004597f6
L_004597f8:
    # block 0x004597f8: entered by jge at 0x004597ae, 3 instruction(s), ends with je to 0x004598d9 (forward)
    movsx eax, word ptr [0x61edb7]               # 004597f8
    cmp eax, -0x1                                # 004597ff
    je.d32 L_004598d9                            # 00459802
    # block 0x00459808: entered by fall-through of je at 0x00459802, 5 instruction(s), ends with jge to 0x0045985e (forward)
    movsx ecx, word ptr [0x61edb7]               # 00459808
    mov edx, dword ptr [ebp - local_20]          # 0045980f
    movsx eax, word ptr [edx + field_21]         # 00459812
    {load} cmp ecx, eax                          # 00459816
    jge.d8 L_0045985e                            # 00459818
    # block 0x0045981a: entered by fall-through of jge at 0x00459818, 17 instruction(s), calls FUN_004c5d4b, falls into the block at 0x0045985e
    push 0x54a6e8                                # 0045981a
    movsx ecx, word ptr [0x61edb7]               # 0045981f
    shl ecx, 0x4                                 # 00459826
    mov edx, dword ptr [ebp - local_20]          # 00459829
    lea eax, [edx + ecx + field_1a5]             # 0045982c
    push eax                                     # 00459833
    movsx ecx, word ptr [0x61edb5]               # 00459834
    shl ecx, 0x4                                 # 0045983b
    mov edx, dword ptr [ebp - local_20]          # 0045983e
    lea eax, [edx + ecx + field_25]              # 00459841
    push eax                                     # 00459845
    mov ecx, dword ptr [0x5cf665]                # 00459846
    push ecx                                     # 0045984c
    mov edx, dword ptr [0x61ed97]                # 0045984d
    push edx                                     # 00459853
    mov ecx, 0x5cf659                            # 00459854
    call FUN_004c5d4b                            # 00459859
L_0045985e:
    # block 0x0045985e: entered by jge at 0x00459818, 2 instruction(s), ends with jne to 0x00459893 (forward)
    cmp dword ptr [0x61ed9b], 0x1                # 0045985e
    jne.d8 L_00459893                            # 00459865
    # block 0x00459867: entered by fall-through of jne at 0x00459865, 6 instruction(s), ends with jge to 0x00459893 (forward)
    movsx eax, word ptr [0x61edb7]               # 00459867
    mov ecx, dword ptr [ebp - local_20]          # 0045986e
    movsx edx, word ptr [ecx + field_21]         # 00459871
    sub edx, 0x1                                 # 00459875
    {load} cmp eax, edx                          # 00459878
    jge.d8 L_00459893                            # 0045987a
    # block 0x0045987c: entered by fall-through of jge at 0x0045987a, 5 instruction(s), ends with forward jump to 0x004598d9
    mov dword ptr [ebp - local_1c], 0x1          # 0045987c
    movsx eax, word ptr [0x61edb7]               # 00459883
    add eax, 0x1                                 # 0045988a
    mov word ptr [ebp - local_4], ax             # 0045988d
    jmp.d8 L_004598d9                            # 00459891
L_00459893:
    # block 0x00459893: entered by jne at 0x00459865; jge at 0x0045987a, 2 instruction(s), ends with jne to 0x004598d9 (forward)
    cmp dword ptr [0x61ed9b], 0x2                # 00459893
    jne.d8 L_004598d9                            # 0045989a
    # block 0x0045989c: entered by fall-through of jne at 0x0045989a, 3 instruction(s), ends with je to 0x004598d9 (forward)
    movsx ecx, word ptr [0x61edb7]               # 0045989c
    test ecx, ecx                                # 004598a3
    je.d8 L_004598d9                             # 004598a5
    # block 0x004598a7: entered by fall-through of je at 0x004598a5, 9 instruction(s), ends with jne to 0x004598d9 (forward)
    mov dword ptr [ebp - local_1c], 0x1          # 004598a7
    movsx edx, word ptr [0x61edb7]               # 004598ae
    sub edx, 0x1                                 # 004598b5
    mov word ptr [ebp - local_4], dx             # 004598b8
    movsx eax, word ptr [ebp - local_4]          # 004598bc
    mov ecx, dword ptr [ebp - local_20]          # 004598c0
    movsx edx, word ptr [ecx + field_21]         # 004598c3
    {load} cmp eax, edx                          # 004598c7
    jne.d8 L_004598d9                            # 004598c9
    # block 0x004598cb: entered by fall-through of jne at 0x004598c9, 4 instruction(s), falls into the block at 0x004598d9
    mov eax, dword ptr [ebp - local_20]          # 004598cb
    movsx ecx, word ptr [eax + field_21]         # 004598ce
    sub ecx, 0x1                                 # 004598d2
    mov word ptr [ebp - local_4], cx             # 004598d5
L_004598d9:
    # block 0x004598d9: entered by je at 0x00459802; jmp at 0x00459891; jne at 0x0045989a; je at 0x004598a5; more, 2 instruction(s), ends with je to 0x00459984 (forward)
    cmp dword ptr [ebp - local_1c], 0x0          # 004598d9
    je.d32 L_00459984                            # 004598dd
    # block 0x004598e3: entered by fall-through of je at 0x004598dd, 39 instruction(s), calls FUN_004c5377, falls into the block at 0x00459984
    movsx edx, word ptr [ebp - local_4]          # 004598e3
    shl edx, 0x4                                 # 004598e7
    mov eax, dword ptr [ebp - local_20]          # 004598ea
    mov ecx, dword ptr [eax + edx + field_1a9]   # 004598ed
    sub ecx, dword ptr [0x58318a]                # 004598f4
    mov dword ptr [ebp - local_10], ecx          # 004598fa
    movsx edx, word ptr [ebp - local_4]          # 004598fd
    shl edx, 0x4                                 # 00459901
    mov eax, dword ptr [ebp - local_20]          # 00459904
    mov ecx, dword ptr [eax + edx + field_1b1]   # 00459907
    sub ecx, dword ptr [0x58318a]                # 0045990e
    mov dword ptr [ebp - local_8], ecx           # 00459914
    movsx edx, word ptr [ebp - local_4]          # 00459917
    shl edx, 0x4                                 # 0045991b
    mov eax, dword ptr [ebp - local_20]          # 0045991e
    mov ecx, dword ptr [eax + edx + field_1a5]   # 00459921
    sub ecx, dword ptr [0x583186]                # 00459928
    mov dword ptr [ebp - local_14], ecx          # 0045992e
    movsx edx, word ptr [ebp - local_4]          # 00459931
    shl edx, 0x4                                 # 00459935
    mov eax, dword ptr [ebp - local_20]          # 00459938
    mov ecx, dword ptr [eax + edx + field_1ad]   # 0045993b
    sub ecx, dword ptr [0x583186]                # 00459942
    mov dword ptr [ebp - local_c], ecx           # 00459948
    push 0x54a6fc                                # 0045994b
    movsx edx, word ptr [ebp - local_4]          # 00459950
    shl edx, 0x4                                 # 00459954
    mov eax, dword ptr [ebp - local_20]          # 00459957
    lea ecx, [eax + edx + field_1a5]             # 0045995a
    push ecx                                     # 00459961
    lea edx, [ebp - local_14]                    # 00459962
    push edx                                     # 00459965
    mov eax, dword ptr [0x5cf665]                # 00459966
    push eax                                     # 0045996b
    mov ecx, dword ptr [0x5d15e3]                # 0045996c
    push ecx                                     # 00459972
    mov ecx, 0x5cf659                            # 00459973
    call FUN_004c5377                            # 00459978
    mov dword ptr [ebp - local_1c], 0x0          # 0045997d
L_00459984:
    # block 0x00459984: entered by je at 0x004598dd, 2 instruction(s), ends with je to 0x004599c0 (forward)
    cmp dword ptr [0x61eda9], 0x0                # 00459984
    je.d8 L_004599c0                             # 0045998b
    # block 0x0045998d: entered by fall-through of je at 0x0045998b, 13 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004599c0
    push 0x54a720                                # 0045998d
    push 0x61ede9                                # 00459992
    movsx edx, word ptr [0x61edb5]               # 00459997
    shl edx, 0x4                                 # 0045999e
    mov eax, dword ptr [ebp - local_20]          # 004599a1
    lea ecx, [eax + edx + field_25]              # 004599a4
    push ecx                                     # 004599a8
    mov edx, dword ptr [0x5cf665]                # 004599a9
    push edx                                     # 004599af
    mov eax, dword ptr [0x61ed97]                # 004599b0
    push eax                                     # 004599b5
    mov ecx, 0x5cf659                            # 004599b6
    call FUN_004c5d4b                            # 004599bb
L_004599c0:
    # block 0x004599c0: entered by jmp at 0x00459716; je at 0x0045998b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004599c0
    pop ebp                                      # 004599c2
    ret                                          # 004599c3

# --- data items (not part of the function) -------------------------
.org 0x004599c4 - 0x401000
PAD_004599c4:  # 12 byte(s) of int3 padding
    .fill 12, 1, 0xcc

