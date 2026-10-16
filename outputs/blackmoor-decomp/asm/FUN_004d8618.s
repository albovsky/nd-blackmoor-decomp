# FUN_004d8618
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d8618
# extent:       0x004d8618-0x004d88de (710 code bytes)
# span:         0x004d8618-0x004d88de (code 710, tables 0, padding 0)
# sha256:       d8f97e86a7ce3f22b792292d1fce27f6c3592a2a7c8038e72b4a28bef8e21c1b
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d8618
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c, field_2c4, field_455, field_951e, field_9536, field_953e, field_9542, field_9546, field_955e; [ecx + n] field_4, field_8, field_c, field_2bc, field_2c8, field_44d, field_459, field_9512, field_9532, field_953e, field_9542, field_954a and 2 more; [edx + n] field_2b6, field_2c0, field_45d, field_951a, field_953a, field_953e, field_9542, field_minus_1
# callees:      calls FUN_004dad60, FUN_004d5f91, FUN_004daeb5, FUN_004dae88, FUN_0043dbd5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 142 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_2b6, 0x2b6  # offset +0x2b6
.equ field_2bc, 0x2bc  # offset +0x2bc
.equ field_2c0, 0x2c0  # offset +0x2c0
.equ field_2c4, 0x2c4  # offset +0x2c4
.equ field_2c8, 0x2c8  # offset +0x2c8
.equ field_44d, 0x44d  # offset +0x44d
.equ field_455, 0x455  # offset +0x455
.equ field_459, 0x459  # offset +0x459
.equ field_45d, 0x45d  # offset +0x45d
.equ field_9512, 0x9512  # offset +0x9512
.equ field_951a, 0x951a  # offset +0x951a
.equ field_951e, 0x951e  # offset +0x951e
.equ field_9532, 0x9532  # offset +0x9532
.equ field_9536, 0x9536  # offset +0x9536
.equ field_953a, 0x953a  # offset +0x953a
.equ field_953e, 0x953e  # offset +0x953e
.equ field_9542, 0x9542  # offset +0x9542
.equ field_9546, 0x9546  # offset +0x9546
.equ field_954a, 0x954a  # offset +0x954a
.equ field_955e, 0x955e  # offset +0x955e
.equ field_9562, 0x9562  # offset +0x9562

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004d5f91, .text + (0x004d5f91 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)

.org 0x004d8618 - 0x401000
.globl FUN_004d8618
FUN_004d8618:
    # block 0x004d8618: entry, 76 instruction(s), calls FUN_004dad60, FUN_004d5f91, FUN_004daeb5, ends with jle to 0x004d87b0 (forward)
    push ebp                                     # 004d8618
    {load} mov ebp, esp                          # 004d8619
    sub esp, 0xc                                 # 004d861b
    mov dword ptr [ebp - local_c], ecx           # 004d861e
    mov ecx, 0x5830a6                            # 004d8621
    call FUN_004dad60                            # 004d8626
    mov eax, dword ptr [ebp - local_c]           # 004d862b
    mov dword ptr [eax + field_455], 0x0         # 004d862e
    mov ecx, dword ptr [ebp - local_c]           # 004d8638
    mov dword ptr [ecx + field_459], 0x0         # 004d863b
    mov edx, dword ptr [ebp - local_c]           # 004d8645
    mov dword ptr [edx + field_45d], 0x0         # 004d8648
    mov eax, dword ptr [ebp - local_c]           # 004d8652
    mov dword ptr [eax + field_955e], 0xffffffff # 004d8655
    mov ecx, dword ptr [ebp - local_c]           # 004d865f
    mov dword ptr [ecx + field_9562], 0xffffffff # 004d8662
    mov edx, dword ptr [ebp - local_c]           # 004d866c
    mov dword ptr [edx + field_951a], 0x0        # 004d866f
    mov eax, dword ptr [ebp - local_c]           # 004d8679
    mov dword ptr [eax + field_951e], 0x0        # 004d867c
    mov ecx, dword ptr [ebp - local_c]           # 004d8686
    mov dword ptr [ecx + field_9532], 0x1        # 004d8689
    mov edx, dword ptr [ebp - local_c]           # 004d8693
    mov dword ptr [edx + field_953a], 0x1        # 004d8696
    mov eax, dword ptr [ebp - local_c]           # 004d86a0
    mov dword ptr [eax + field_9536], 0x0        # 004d86a3
    mov ecx, dword ptr [ebp - local_c]           # 004d86ad
    mov dword ptr [ecx + field_44d], 0x0         # 004d86b0
    mov ecx, dword ptr [ebp - local_c]           # 004d86ba
    call FUN_004d5f91                            # 004d86bd
    mov dword ptr [0x5b44f0], 0x4                # 004d86c2
    mov dword ptr [0x5b44f4], 0x0                # 004d86cc
    mov edx, dword ptr [0x5b44f4]                # 004d86d6
    shl edx, 0x2                                 # 004d86dc
    mov eax, dword ptr [0x5b44f0]                # 004d86df
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004d86e4
    mov edx, dword ptr [ebp - local_c]           # 004d86ec
    mov dword ptr [edx + field_953e], ecx        # 004d86ef
    mov eax, dword ptr [0x5b44f4]                # 004d86f5
    shl eax, 0x2                                 # 004d86fa
    mov ecx, dword ptr [0x5b44f0]                # 004d86fd
    movsx edx, word ptr [eax + 8*ecx + 0x5b3792] # 004d8703
    mov eax, dword ptr [ebp - local_c]           # 004d870b
    mov dword ptr [eax + field_9542], edx        # 004d870e
    mov ecx, dword ptr [0x5b44f0]                # 004d8714
    shl ecx, 0x5                                 # 004d871a
    mov edx, dword ptr [0x5b44f4]                # 004d871d
    shl edx, 0x4                                 # 004d8723
    lea eax, [ecx + edx + 0x5b160c]              # 004d8726
    mov ecx, dword ptr [ebp - local_c]           # 004d872d
    add ecx, 0x96f4                              # 004d8730
    mov edx, dword ptr [eax]                     # 004d8736
    mov dword ptr [ecx], edx                     # 004d8738
    mov edx, dword ptr [eax + field_4]           # 004d873a
    mov dword ptr [ecx + field_4], edx           # 004d873d
    mov edx, dword ptr [eax + field_8]           # 004d8740
    mov dword ptr [ecx + field_8], edx           # 004d8743
    mov eax, dword ptr [eax + field_c]           # 004d8746
    mov dword ptr [ecx + field_c], eax           # 004d8749
    lea ecx, [ebp - local_8]                     # 004d874c
    push ecx                                     # 004d874f
    mov ecx, 0x5830a6                            # 004d8750
    call FUN_004daeb5                            # 004d8755
    mov edx, dword ptr [eax]                     # 004d875a
    mov eax, dword ptr [eax + field_4]           # 004d875c
    mov dword ptr [0x5830e2], edx                # 004d875f
    mov dword ptr [0x5830e6], eax                # 004d8765
    mov ecx, dword ptr [0x5830e2]                # 004d876a
    mov dword ptr [0x5830ea], ecx                # 004d8770
    mov edx, dword ptr [0x5830e6]                # 004d8776
    mov dword ptr [0x5830ee], edx                # 004d877c
    movsx eax, word ptr [0x63988b]               # 004d8782
    mov ecx, dword ptr [ebp - local_c]           # 004d8789
    sub eax, dword ptr [ecx + field_953e]        # 004d878c
    cmp dword ptr [0x5830e2], eax                # 004d8792
    jle.d8 L_004d87b0                            # 004d8798
    # block 0x004d879a: entered by fall-through of jle at 0x004d8798, 4 instruction(s), falls into the block at 0x004d87b0
    movsx edx, word ptr [0x63988b]               # 004d879a
    mov eax, dword ptr [ebp - local_c]           # 004d87a1
    sub edx, dword ptr [eax + field_953e]        # 004d87a4
    mov dword ptr [0x5830e2], edx                # 004d87aa
L_004d87b0:
    # block 0x004d87b0: entered by jle at 0x004d8798, 5 instruction(s), ends with jle to 0x004d87dd (forward)
    movsx ecx, word ptr [0x63988d]               # 004d87b0
    mov edx, dword ptr [ebp - local_c]           # 004d87b7
    sub ecx, dword ptr [edx + field_9542]        # 004d87ba
    cmp dword ptr [0x5830e6], ecx                # 004d87c0
    jle.d8 L_004d87dd                            # 004d87c6
    # block 0x004d87c8: entered by fall-through of jle at 0x004d87c6, 4 instruction(s), falls into the block at 0x004d87dd
    movsx eax, word ptr [0x63988d]               # 004d87c8
    mov ecx, dword ptr [ebp - local_c]           # 004d87cf
    sub eax, dword ptr [ecx + field_9542]        # 004d87d2
    mov dword ptr [0x5830e6], eax                # 004d87d8
L_004d87dd:
    # block 0x004d87dd: entered by jle at 0x004d87c6, 53 instruction(s), calls FUN_004dae88, FUN_0043dbd5, ends with ret
    mov edx, dword ptr [0x5830e6]                # 004d87dd
    mov dword ptr [0x583106], edx                # 004d87e3
    mov eax, dword ptr [ebp - local_c]           # 004d87e9
    mov ecx, dword ptr [eax + field_9542]        # 004d87ec
    mov edx, dword ptr [0x583106]                # 004d87f2
    lea eax, [edx + ecx - field_minus_1]         # 004d87f8
    mov dword ptr [0x58310e], eax                # 004d87fc
    mov ecx, dword ptr [0x5830e2]                # 004d8801
    mov dword ptr [0x583102], ecx                # 004d8807
    mov edx, dword ptr [ebp - local_c]           # 004d880d
    mov eax, dword ptr [edx + field_953e]        # 004d8810
    mov ecx, dword ptr [0x583102]                # 004d8816
    lea edx, [ecx + eax - field_minus_1]         # 004d881c
    mov dword ptr [0x58310a], edx                # 004d8820
    mov eax, dword ptr [0x5830e6]                # 004d8826
    push eax                                     # 004d882b
    mov ecx, dword ptr [0x5830e2]                # 004d882c
    push ecx                                     # 004d8832
    mov ecx, 0x5830a6                            # 004d8833
    call FUN_004dae88                            # 004d8838
    mov edx, dword ptr [0x583102]                # 004d883d
    mov dword ptr [0x5830f2], edx                # 004d8843
    mov eax, dword ptr [0x583106]                # 004d8849
    mov dword ptr [0x5830f6], eax                # 004d884e
    mov ecx, dword ptr [0x58310a]                # 004d8853
    mov dword ptr [0x5830fa], ecx                # 004d8859
    mov edx, dword ptr [0x58310e]                # 004d885f
    mov dword ptr [0x5830fe], edx                # 004d8865
    mov eax, dword ptr [ebp - local_c]           # 004d886b
    mov ecx, dword ptr [ebp - local_c]           # 004d886e
    mov edx, dword ptr [eax + field_2c4]         # 004d8871
    sub edx, dword ptr [ecx + field_2bc]         # 004d8877
    add edx, 0x1                                 # 004d887d
    mov eax, dword ptr [ebp - local_c]           # 004d8880
    mov dword ptr [eax + field_9546], edx        # 004d8883
    mov ecx, dword ptr [ebp - local_c]           # 004d8889
    mov edx, dword ptr [ebp - local_c]           # 004d888c
    mov eax, dword ptr [ecx + field_2c8]         # 004d888f
    sub eax, dword ptr [edx + field_2c0]         # 004d8895
    add eax, 0x1                                 # 004d889b
    mov ecx, dword ptr [ebp - local_c]           # 004d889e
    mov dword ptr [ecx + field_954a], eax        # 004d88a1
    mov edx, dword ptr [ebp - local_c]           # 004d88a7
    movsx eax, word ptr [edx + field_2b6]        # 004d88aa
    mov ecx, dword ptr [ebp - local_c]           # 004d88b1
    mov edx, dword ptr [4*eax + 0x5d032f]        # 004d88b4
    mov dword ptr [ecx + field_9512], edx        # 004d88bb
    mov dword ptr [0x5d2ecb], 0x1                # 004d88c1
    mov dword ptr [0x5d2ecf], 0x1                # 004d88cb
    call FUN_0043dbd5                            # 004d88d5
    {load} mov esp, ebp                          # 004d88da
    pop ebp                                      # 004d88dc
    ret                                          # 004d88dd

