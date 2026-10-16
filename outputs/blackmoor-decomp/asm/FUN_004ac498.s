# FUN_004ac498
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac498
# extent:       0x004ac498-0x004ac7b7 (799 code bytes)
# span:         0x004ac498-0x004ac7c0 (code 799, tables 0, padding 9)
# sha256:       bc8a210258aa21af5cee8511c049410fc300752f12e4b5564fe59f52fa7e8e94
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ac498
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_10, local_14, local_18, local_1c, local_2c
# fields:       [eax + n] field_21, field_509, field_569; [ecx + n] field_21, field_3f, field_15f, field_1bf; [edx + n] field_25, field_ff, field_1bf, field_269
# callees:      calls FUN_004ac3d2, FUN_004ac37f, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 217 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_2c, 0x2c  # offset -0x2c
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_3f, 0x3f  # offset +0x3f
.equ field_ff, 0xff  # offset +0xff
.equ field_15f, 0x15f  # offset +0x15f
.equ field_1bf, 0x1bf  # offset +0x1bf
.equ field_269, 0x269  # offset +0x269
.equ field_509, 0x509  # offset +0x509
.equ field_569, 0x569  # offset +0x569

# --- external targets -----------------------------------------------
.set FUN_004ac37f, .text + (0x004ac37f - 0x401000)
.set FUN_004ac3d2, .text + (0x004ac3d2 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004ac498 - 0x401000
.globl FUN_004ac498
FUN_004ac498:
    # block 0x004ac498: entry, 12 instruction(s), ends with je to 0x004ac522 (forward)
    push ebp                                     # 004ac498
    {load} mov ebp, esp                          # 004ac499
    sub esp, 0x2c                                # 004ac49b
    push esi                                     # 004ac49e
    movsx eax, word ptr [0x61d6df]               # 004ac49f
    imul eax, eax, 0x8d                          # 004ac4a6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ac4ac
    mov dword ptr [ebp - local_18], ecx          # 004ac4b2
    {load} xor edx, edx                          # 004ac4b5
    mov dl, byte ptr [0x61d6fb]                  # 004ac4b7
    test edx, edx                                # 004ac4bd
    je.d8 L_004ac522                             # 004ac4bf
    # block 0x004ac4c1: entered by fall-through of je at 0x004ac4bf, 28 instruction(s), calls FUN_004ac3d2, FUN_004ac37f, FUN_004c5377, falls into the block at 0x004ac522
    mov eax, dword ptr [ebp - local_18]          # 004ac4c1
    push eax                                     # 004ac4c4
    lea ecx, [ebp - local_10]                    # 004ac4c5
    push ecx                                     # 004ac4c8
    mov ecx, 0x61d6c1                            # 004ac4c9
    call FUN_004ac3d2                            # 004ac4ce
    lea edx, [ebp - local_2c]                    # 004ac4d3
    push edx                                     # 004ac4d6
    movsx eax, word ptr [0x61d6f3]               # 004ac4d7
    shl eax, 0x4                                 # 004ac4de
    mov ecx, dword ptr [ebp - local_18]          # 004ac4e1
    lea edx, [ecx + eax + field_3f]              # 004ac4e4
    push edx                                     # 004ac4e8
    mov ecx, 0x61d6c1                            # 004ac4e9
    call FUN_004ac37f                            # 004ac4ee
    push 0x551080                                # 004ac4f3
    lea eax, [ebp - local_2c]                    # 004ac4f8
    push eax                                     # 004ac4fb
    lea ecx, [ebp - local_10]                    # 004ac4fc
    push ecx                                     # 004ac4ff
    mov edx, dword ptr [0x5cf665]                # 004ac500
    push edx                                     # 004ac506
    movsx eax, word ptr [0x61d6dd]               # 004ac507
    imul eax, eax, 0x4a                          # 004ac50e
    mov ecx, dword ptr [eax + 0x5d1599]          # 004ac511
    push ecx                                     # 004ac517
    mov ecx, 0x5cf659                            # 004ac518
    call FUN_004c5377                            # 004ac51d
L_004ac522:
    # block 0x004ac522: entered by je at 0x004ac4bf, 4 instruction(s), ends with je to 0x004ac5d1 (forward)
    {load} xor edx, edx                          # 004ac522
    mov dl, byte ptr [0x61d6fc]                  # 004ac524
    test edx, edx                                # 004ac52a
    je.d32 L_004ac5d1                            # 004ac52c
    # block 0x004ac532: entered by fall-through of je at 0x004ac52c, 43 instruction(s), calls FUN_004ac37f, FUN_004c5377, ends with forward jump to 0x004ac66b
    movsx eax, word ptr [0x61d6f3]               # 004ac532
    mov dword ptr [ebp - local_14], eax          # 004ac539
    mov ecx, dword ptr [ebp - local_14]          # 004ac53c
    movsx ecx, word ptr [2*ecx + 0x61d709]       # 004ac53f
    mov edx, dword ptr [ebp - local_18]          # 004ac547
    movsx eax, word ptr [edx + field_25]         # 004ac54a
    imul ecx, eax                                # 004ac54e
    movsx eax, word ptr [0x61d6f9]               # 004ac551
    mov edx, dword ptr [ebp - local_18]          # 004ac558
    movsx esi, word ptr [edx + field_25]         # 004ac55b
    cdq                                          # 004ac55f
    idiv esi                                     # 004ac560
    {load} add ecx, edx                          # 004ac562
    mov dword ptr [ebp - local_1c], ecx          # 004ac564
    lea eax, [ebp - local_2c]                    # 004ac567
    push eax                                     # 004ac56a
    mov ecx, dword ptr [ebp - local_14]          # 004ac56b
    shl ecx, 0x4                                 # 004ac56e
    mov edx, dword ptr [ebp - local_18]          # 004ac571
    lea eax, [edx + ecx + field_ff]              # 004ac574
    push eax                                     # 004ac57b
    mov ecx, 0x61d6c1                            # 004ac57c
    call FUN_004ac37f                            # 004ac581
    push 0x551098                                # 004ac586
    lea ecx, [ebp - local_2c]                    # 004ac58b
    push ecx                                     # 004ac58e
    mov edx, dword ptr [ebp - local_14]          # 004ac58f
    imul edx, edx, 0xe0                          # 004ac592
    mov eax, dword ptr [ebp - local_18]          # 004ac598
    lea ecx, [eax + edx + field_569]             # 004ac59b
    mov edx, dword ptr [ebp - local_1c]          # 004ac5a2
    shl edx, 0x4                                 # 004ac5a5
    {load} add ecx, edx                          # 004ac5a8
    push ecx                                     # 004ac5aa
    mov eax, dword ptr [0x5cf665]                # 004ac5ab
    push eax                                     # 004ac5b0
    movsx ecx, word ptr [0x61d6dd]               # 004ac5b1
    imul ecx, ecx, 0x4a                          # 004ac5b8
    mov edx, dword ptr [ecx + 0x5d1599]          # 004ac5bb
    push edx                                     # 004ac5c1
    mov ecx, 0x5cf659                            # 004ac5c2
    call FUN_004c5377                            # 004ac5c7
    jmp.d32 L_004ac66b                           # 004ac5cc
L_004ac5d1:
    # block 0x004ac5d1: entered by je at 0x004ac52c, 2 instruction(s), ends with forward jump to 0x004ac5e3
    mov dword ptr [ebp - local_14], 0x0          # 004ac5d1
    jmp.d8 L_004ac5e3                            # 004ac5d8
L_004ac5da:
    # block 0x004ac5da: entered by jmp at 0x004ac666, 3 instruction(s), falls into the block at 0x004ac5e3
    mov eax, dword ptr [ebp - local_14]          # 004ac5da
    add eax, 0x1                                 # 004ac5dd
    mov dword ptr [ebp - local_14], eax          # 004ac5e0
L_004ac5e3:
    # block 0x004ac5e3: entered by jmp at 0x004ac5d8, 4 instruction(s), ends with jge to 0x004ac66b (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004ac5e3
    movsx edx, word ptr [ecx + field_21]         # 004ac5e6
    cmp dword ptr [ebp - local_14], edx          # 004ac5ea
    jge.d8 L_004ac66b                            # 004ac5ed
    # block 0x004ac5ef: entered by fall-through of jge at 0x004ac5ed, 33 instruction(s), calls FUN_004ac37f, FUN_004c5377, ends with backward jump to 0x004ac5da
    lea eax, [ebp - local_2c]                    # 004ac5ef
    push eax                                     # 004ac5f2
    mov ecx, dword ptr [ebp - local_14]          # 004ac5f3
    shl ecx, 0x4                                 # 004ac5f6
    mov edx, dword ptr [ebp - local_18]          # 004ac5f9
    lea eax, [edx + ecx + field_ff]              # 004ac5fc
    push eax                                     # 004ac603
    mov ecx, 0x61d6c1                            # 004ac604
    call FUN_004ac37f                            # 004ac609
    push 0x5510b4                                # 004ac60e
    lea ecx, [ebp - local_2c]                    # 004ac613
    push ecx                                     # 004ac616
    mov edx, dword ptr [ebp - local_14]          # 004ac617
    imul edx, edx, 0xe0                          # 004ac61a
    mov eax, dword ptr [ebp - local_18]          # 004ac620
    lea ecx, [eax + edx + field_569]             # 004ac623
    mov edx, dword ptr [ebp - local_14]          # 004ac62a
    movsx eax, word ptr [2*edx + 0x61d709]       # 004ac62d
    mov edx, dword ptr [ebp - local_18]          # 004ac635
    movsx edx, word ptr [edx + field_25]         # 004ac638
    imul eax, edx                                # 004ac63c
    shl eax, 0x4                                 # 004ac63f
    {load} add ecx, eax                          # 004ac642
    push ecx                                     # 004ac644
    mov eax, dword ptr [0x5cf665]                # 004ac645
    push eax                                     # 004ac64a
    movsx ecx, word ptr [0x61d6dd]               # 004ac64b
    imul ecx, ecx, 0x4a                          # 004ac652
    mov edx, dword ptr [ecx + 0x5d1599]          # 004ac655
    push edx                                     # 004ac65b
    mov ecx, 0x5cf659                            # 004ac65c
    call FUN_004c5377                            # 004ac661
    jmp.d32 L_004ac5da                           # 004ac666
L_004ac66b:
    # block 0x004ac66b: entered by jmp at 0x004ac5cc; jge at 0x004ac5ed, 2 instruction(s), ends with je to 0x004ac725 (forward)
    cmp dword ptr [0x61d6e5], 0x0                # 004ac66b
    je.d32 L_004ac725                            # 004ac672
    # block 0x004ac678: entered by fall-through of je at 0x004ac672, 11 instruction(s), calls FUN_004ac37f, ends with je to 0x004ac6e6 (forward)
    lea eax, [ebp - local_2c]                    # 004ac678
    push eax                                     # 004ac67b
    movsx ecx, word ptr [0x61d6f3]               # 004ac67c
    shl ecx, 0x4                                 # 004ac683
    mov edx, dword ptr [ebp - local_18]          # 004ac686
    lea eax, [edx + ecx + field_1bf]             # 004ac689
    push eax                                     # 004ac690
    mov ecx, 0x61d6c1                            # 004ac691
    call FUN_004ac37f                            # 004ac696
    cmp dword ptr [0x61d6ef], 0x0                # 004ac69b
    je.d8 L_004ac6e6                             # 004ac6a2
    # block 0x004ac6a4: entered by fall-through of je at 0x004ac6a2, 17 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004ac725
    push 0x5510c4                                # 004ac6a4
    lea ecx, [ebp - local_2c]                    # 004ac6a9
    push ecx                                     # 004ac6ac
    movsx edx, word ptr [0x61d6f3]               # 004ac6ad
    shl edx, 0x4                                 # 004ac6b4
    mov eax, dword ptr [ebp - local_18]          # 004ac6b7
    lea ecx, [eax + edx + field_509]             # 004ac6ba
    push ecx                                     # 004ac6c1
    mov edx, dword ptr [0x5cf665]                # 004ac6c2
    push edx                                     # 004ac6c8
    movsx eax, word ptr [0x61d6dd]               # 004ac6c9
    imul eax, eax, 0x4a                          # 004ac6d0
    mov ecx, dword ptr [eax + 0x5d1599]          # 004ac6d3
    push ecx                                     # 004ac6d9
    mov ecx, 0x5cf659                            # 004ac6da
    call FUN_004c5377                            # 004ac6df
    jmp.d8 L_004ac725                            # 004ac6e4
L_004ac6e6:
    # block 0x004ac6e6: entered by je at 0x004ac6a2, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x004ac725
    push 0x5510f4                                # 004ac6e6
    lea edx, [ebp - local_2c]                    # 004ac6eb
    push edx                                     # 004ac6ee
    movsx eax, word ptr [0x61d6f3]               # 004ac6ef
    shl eax, 0x4                                 # 004ac6f6
    mov ecx, dword ptr [ebp - local_18]          # 004ac6f9
    lea edx, [ecx + eax + field_1bf]             # 004ac6fc
    push edx                                     # 004ac703
    mov eax, dword ptr [0x5cf665]                # 004ac704
    push eax                                     # 004ac709
    mov ecx, dword ptr [0x5d15e3]                # 004ac70a
    push ecx                                     # 004ac710
    mov ecx, 0x5cf659                            # 004ac711
    call FUN_004c5377                            # 004ac716
    mov dword ptr [0x61d6e5], 0x0                # 004ac71b
L_004ac725:
    # block 0x004ac725: entered by je at 0x004ac672; jmp at 0x004ac6e4, 2 instruction(s), ends with forward jump to 0x004ac737
    mov dword ptr [ebp - local_14], 0x0          # 004ac725
    jmp.d8 L_004ac737                            # 004ac72c
L_004ac72e:
    # block 0x004ac72e: entered by jmp at 0x004ac7ad, 3 instruction(s), falls into the block at 0x004ac737
    mov edx, dword ptr [ebp - local_14]          # 004ac72e
    add edx, 0x1                                 # 004ac731
    mov dword ptr [ebp - local_14], edx          # 004ac734
L_004ac737:
    # block 0x004ac737: entered by jmp at 0x004ac72c, 4 instruction(s), ends with jge to 0x004ac7b2 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004ac737
    movsx ecx, word ptr [eax + field_21]         # 004ac73a
    cmp dword ptr [ebp - local_14], ecx          # 004ac73e
    jge.d8 L_004ac7b2                            # 004ac741
    # block 0x004ac743: entered by fall-through of jge at 0x004ac741, 30 instruction(s), calls FUN_004ac37f, FUN_004c5377, ends with backward jump to 0x004ac72e
    lea edx, [ebp - local_2c]                    # 004ac743
    push edx                                     # 004ac746
    mov eax, dword ptr [ebp - local_14]          # 004ac747
    shl eax, 0x4                                 # 004ac74a
    mov ecx, dword ptr [ebp - local_18]          # 004ac74d
    lea edx, [ecx + eax + field_15f]             # 004ac750
    push edx                                     # 004ac757
    mov ecx, 0x61d6c1                            # 004ac758
    call FUN_004ac37f                            # 004ac75d
    push 0x551118                                # 004ac762
    lea eax, [ebp - local_2c]                    # 004ac767
    push eax                                     # 004ac76a
    mov ecx, dword ptr [ebp - local_14]          # 004ac76b
    imul ecx, ecx, 0x70                          # 004ac76e
    mov edx, dword ptr [ebp - local_18]          # 004ac771
    lea eax, [edx + ecx + field_269]             # 004ac774
    mov ecx, dword ptr [ebp - local_14]          # 004ac77b
    movsx edx, word ptr [2*ecx + 0x61d6fd]       # 004ac77e
    shl edx, 0x4                                 # 004ac786
    {load} add eax, edx                          # 004ac789
    push eax                                     # 004ac78b
    mov eax, dword ptr [0x5cf665]                # 004ac78c
    push eax                                     # 004ac791
    movsx ecx, word ptr [0x61d6dd]               # 004ac792
    imul ecx, ecx, 0x4a                          # 004ac799
    mov edx, dword ptr [ecx + 0x5d1599]          # 004ac79c
    push edx                                     # 004ac7a2
    mov ecx, 0x5cf659                            # 004ac7a3
    call FUN_004c5377                            # 004ac7a8
    jmp.d32 L_004ac72e                           # 004ac7ad
L_004ac7b2:
    # block 0x004ac7b2: entered by jge at 0x004ac741, 4 instruction(s), ends with ret
    pop esi                                      # 004ac7b2
    {load} mov esp, ebp                          # 004ac7b3
    pop ebp                                      # 004ac7b5
    ret                                          # 004ac7b6

# --- data items (not part of the function) -------------------------
.org 0x004ac7b7 - 0x401000
PAD_004ac7b7:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

