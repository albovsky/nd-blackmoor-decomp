# FUN_004ad310
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ad310
# extent:       0x004ad310-0x004ad590 (640 code bytes)
# span:         0x004ad310-0x004ad590 (code 640, tables 0, padding 0)
# sha256:       ba3fb67fcc07a37f81f17bfad755ad1d83558d162269720ea1dedc8d0cbc4bb6
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ad310
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_28, local_2c, local_30, local_34, local_38, local_3a
# fields:       [eax + n] field_20, field_26, field_c1b, field_c20; [ecx + n] field_1e, field_20, field_24, field_6a, field_6e, field_c17, field_c1f, field_c24; [edx + n] field_1e, field_24, field_27, field_42
# callees:      calls FUN_004af96e, FUN_004ada56, FUN_004ae683, FUN_004ae495, FUN_004ada9f, FUN_004ae96c, FUN_004aef4a, FUN_004adae8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 173 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3a, 0x3a  # offset -0x3a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_42, 0x42  # offset +0x42
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6e, 0x6e  # offset +0x6e
.equ field_c17, 0xc17  # offset +0xc17
.equ field_c1b, 0xc1b  # offset +0xc1b
.equ field_c1f, 0xc1f  # offset +0xc1f
.equ field_c20, 0xc20  # offset +0xc20
.equ field_c24, 0xc24  # offset +0xc24

# --- external targets -----------------------------------------------
.set FUN_004ada56, .text + (0x004ada56 - 0x401000)
.set FUN_004ada9f, .text + (0x004ada9f - 0x401000)
.set FUN_004adae8, .text + (0x004adae8 - 0x401000)
.set FUN_004ae495, .text + (0x004ae495 - 0x401000)
.set FUN_004ae683, .text + (0x004ae683 - 0x401000)
.set FUN_004ae96c, .text + (0x004ae96c - 0x401000)
.set FUN_004aef4a, .text + (0x004aef4a - 0x401000)
.set FUN_004af96e, .text + (0x004af96e - 0x401000)

.org 0x004ad310 - 0x401000
.globl FUN_004ad310
FUN_004ad310:
    # block 0x004ad310: entry, 8 instruction(s), ends with je to 0x004ad58b (forward)
    push ebp                                     # 004ad310
    {load} mov ebp, esp                          # 004ad311
    sub esp, 0x3c                                # 004ad313
    push edi                                     # 004ad316
    mov dword ptr [ebp - local_38], ecx          # 004ad317
    mov eax, dword ptr [ebp - local_38]          # 004ad31a
    cmp dword ptr [eax + field_c1b], 0x0         # 004ad31d
    je.d32 L_004ad58b                            # 004ad324
    # block 0x004ad32a: entered by fall-through of je at 0x004ad324, 5 instruction(s), ends with jne to 0x004ad58b (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004ad32a
    {load} xor edx, edx                          # 004ad32d
    mov dl, byte ptr [ecx + field_c24]           # 004ad32f
    test edx, edx                                # 004ad335
    jne.d32 L_004ad58b                           # 004ad337
    # block 0x004ad33d: entered by fall-through of jne at 0x004ad337, 3 instruction(s), ends with jne to 0x004ad58b (forward)
    mov eax, dword ptr [ebp - local_38]          # 004ad33d
    cmp dword ptr [eax + field_c20], 0x0         # 004ad340
    jne.d32 L_004ad58b                           # 004ad347
    # block 0x004ad34d: entered by fall-through of jne at 0x004ad347, 5 instruction(s), ends with jne to 0x004ad58b (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004ad34d
    movsx edx, word ptr [ecx + field_1e]         # 004ad350
    imul edx, edx, 0x8d                          # 004ad354
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004ad35a
    jne.d32 L_004ad58b                           # 004ad361
    # block 0x004ad367: entered by fall-through of jne at 0x004ad361, 3 instruction(s), ends with jne to 0x004ad402 (forward)
    mov eax, dword ptr [ebp - local_38]          # 004ad367
    cmp dword ptr [eax + field_20], 0x0          # 004ad36a
    jne.d32 L_004ad402                           # 004ad36e
    # block 0x004ad374: entered by fall-through of jne at 0x004ad36e, 2 instruction(s), ends with jne to 0x004ad3a3 (forward)
    cmp dword ptr [0x5c39e5], 0x2775             # 004ad374
    jne.d8 L_004ad3a3                            # 004ad37e
    # block 0x004ad380: entered by fall-through of jne at 0x004ad37e, 7 instruction(s), ends with forward jump to 0x004ad3fd
    mov ecx, dword ptr [ebp - local_38]          # 004ad380
    mov byte ptr [ecx + field_c1f], 0x1          # 004ad383
    mov edx, dword ptr [ebp - local_38]          # 004ad38a
    movsx eax, word ptr [edx + field_1e]         # 004ad38d
    imul eax, eax, 0x8d                          # 004ad391
    mov dword ptr [eax + 0x5bb632], 0x2          # 004ad397
    jmp.d8 L_004ad3fd                            # 004ad3a1
L_004ad3a3:
    # block 0x004ad3a3: entered by jne at 0x004ad37e, 2 instruction(s), ends with jne to 0x004ad3fd (forward)
    cmp dword ptr [0x5c39e5], 0x2774             # 004ad3a3
    jne.d8 L_004ad3fd                            # 004ad3ad
    # block 0x004ad3af: entered by fall-through of jne at 0x004ad3ad, 6 instruction(s), calls FUN_004af96e, ends with jne to 0x004ad3c8 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004ad3af
    call FUN_004af96e                            # 004ad3b2
    movsx ecx, ax                                # 004ad3b7
    mov dword ptr [ebp - local_2c], ecx          # 004ad3ba
    cmp dword ptr [ebp - local_2c], -0x1         # 004ad3bd
    jne.d8 L_004ad3c8                            # 004ad3c1
    # block 0x004ad3c3: entered by fall-through of jne at 0x004ad3c1, 1 instruction(s), ends with forward jump to 0x004ad58b
    jmp.d32 L_004ad58b                           # 004ad3c3
L_004ad3c8:
    # block 0x004ad3c8: entered by jne at 0x004ad3c1, 15 instruction(s), calls FUN_004ada56, FUN_004ae683, FUN_004ae495, falls into the block at 0x004ad3fd
    mov ecx, dword ptr [ebp - local_38]          # 004ad3c8
    call FUN_004ada56                            # 004ad3cb
    mov edx, dword ptr [ebp - local_2c]          # 004ad3d0
    push edx                                     # 004ad3d3
    mov ecx, dword ptr [ebp - local_38]          # 004ad3d4
    call FUN_004ae683                            # 004ad3d7
    mov eax, dword ptr [ebp - local_38]          # 004ad3dc
    mov dword ptr [eax + field_20], 0x1          # 004ad3df
    mov ecx, dword ptr [ebp - local_38]          # 004ad3e6
    mov dx, word ptr [ebp - local_2c]            # 004ad3e9
    mov word ptr [ecx + field_24], dx            # 004ad3ed
    mov eax, dword ptr [ebp - local_2c]          # 004ad3f1
    push eax                                     # 004ad3f4
    mov ecx, dword ptr [ebp - local_38]          # 004ad3f5
    call FUN_004ae495                            # 004ad3f8
L_004ad3fd:
    # block 0x004ad3fd: entered by jmp at 0x004ad3a1; jne at 0x004ad3ad, 1 instruction(s), ends with forward jump to 0x004ad58b
    jmp.d32 L_004ad58b                           # 004ad3fd
L_004ad402:
    # block 0x004ad402: entered by jne at 0x004ad36e, 3 instruction(s), ends with je to 0x004ad58b (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004ad402
    cmp dword ptr [ecx + field_20], 0x0          # 004ad405
    je.d32 L_004ad58b                            # 004ad409
    # block 0x004ad40f: entered by fall-through of je at 0x004ad409, 2 instruction(s), ends with jne to 0x004ad58b (forward)
    cmp dword ptr [0x5c39e5], 0x2776             # 004ad40f
    jne.d32 L_004ad58b                           # 004ad419
    # block 0x004ad41f: entered by fall-through of jne at 0x004ad419, 28 instruction(s), calls FUN_004ada9f, FUN_004ae96c, ends with forward jump to 0x004ad48b
    mov edx, dword ptr [ebp - local_38]          # 004ad41f
    movsx eax, word ptr [edx + field_24]         # 004ad422
    imul eax, eax, 0xc7                          # 004ad426
    mov ecx, dword ptr [ebp - local_38]          # 004ad42c
    lea edx, [ecx + eax + field_6e]              # 004ad42f
    mov dword ptr [ebp - local_34], edx          # 004ad433
    mov eax, dword ptr [ebp - local_34]          # 004ad436
    {load} xor ecx, ecx                          # 004ad439
    mov cl, byte ptr [eax + field_26]            # 004ad43b
    imul ecx, ecx, 0x28                          # 004ad43e
    mov edx, dword ptr [ebp - local_34]          # 004ad441
    lea eax, [edx + ecx + field_27]              # 004ad444
    mov dword ptr [ebp - local_8], eax           # 004ad448
    mov ecx, dword ptr [ebp - local_38]          # 004ad44b
    call FUN_004ada9f                            # 004ad44e
    mov ecx, dword ptr [ebp - local_38]          # 004ad453
    movsx edx, word ptr [ecx + field_24]         # 004ad456
    push edx                                     # 004ad45a
    mov ecx, dword ptr [ebp - local_38]          # 004ad45b
    call FUN_004ae96c                            # 004ad45e
    mov ecx, 0x7                                 # 004ad463
    or eax, -0x1                                 # 004ad468
    lea edi, [ebp - local_28]                    # 004ad46b
    rep stosd dword ptr es:[edi], eax            # 004ad46e
    stosw word ptr es:[edi], ax                  # 004ad470
    mov dword ptr [ebp - local_30], 0x0          # 004ad472
    mov dword ptr [ebp - local_4], 0x0           # 004ad479
    jmp.d8 L_004ad48b                            # 004ad480
L_004ad482:
    # block 0x004ad482: entered by jmp at 0x004ad4a9; jmp at 0x004ad4d8, 3 instruction(s), falls into the block at 0x004ad48b
    mov eax, dword ptr [ebp - local_4]           # 004ad482
    add eax, 0x1                                 # 004ad485
    mov dword ptr [ebp - local_4], eax           # 004ad488
L_004ad48b:
    # block 0x004ad48b: entered by jmp at 0x004ad480, 5 instruction(s), ends with jge to 0x004ad4da (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004ad48b
    mov edx, dword ptr [ecx + field_c17]         # 004ad48e
    movsx eax, word ptr [edx + field_42]         # 004ad494
    cmp dword ptr [ebp - local_4], eax           # 004ad498
    jge.d8 L_004ad4da                            # 004ad49b
    # block 0x004ad49d: entered by fall-through of jge at 0x004ad49b, 4 instruction(s), ends with jne to 0x004ad4ab (forward)
    mov ecx, dword ptr [ebp - local_38]          # 004ad49d
    movsx edx, word ptr [ecx + field_24]         # 004ad4a0
    cmp dword ptr [ebp - local_4], edx           # 004ad4a4
    jne.d8 L_004ad4ab                            # 004ad4a7
    # block 0x004ad4a9: entered by fall-through of jne at 0x004ad4a7, 1 instruction(s), ends with backward jump to 0x004ad482
    jmp.d8 L_004ad482                            # 004ad4a9
L_004ad4ab:
    # block 0x004ad4ab: entered by jne at 0x004ad4a7, 9 instruction(s), calls FUN_004aef4a, ends with je to 0x004ad4d8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ad4ab
    push eax                                     # 004ad4ae
    mov ecx, dword ptr [ebp - local_38]          # 004ad4af
    movsx edx, word ptr [ecx + field_24]         # 004ad4b2
    push edx                                     # 004ad4b6
    mov ecx, dword ptr [ebp - local_38]          # 004ad4b7
    call FUN_004aef4a                            # 004ad4ba
    test eax, eax                                # 004ad4bf
    je.d8 L_004ad4d8                             # 004ad4c1
    # block 0x004ad4c3: entered by fall-through of je at 0x004ad4c1, 6 instruction(s), falls into the block at 0x004ad4d8
    mov eax, dword ptr [ebp - local_30]          # 004ad4c3
    mov cx, word ptr [ebp - local_4]             # 004ad4c6
    mov word ptr [ebp + 2*eax - local_28], cx    # 004ad4ca
    mov edx, dword ptr [ebp - local_30]          # 004ad4cf
    add edx, 0x1                                 # 004ad4d2
    mov dword ptr [ebp - local_30], edx          # 004ad4d5
L_004ad4d8:
    # block 0x004ad4d8: entered by je at 0x004ad4c1, 1 instruction(s), ends with backward jump to 0x004ad482
    jmp.d8 L_004ad482                            # 004ad4d8
L_004ad4da:
    # block 0x004ad4da: entered by jge at 0x004ad49b, 2 instruction(s), ends with forward jump to 0x004ad4ec
    mov dword ptr [ebp - local_4], 0x0           # 004ad4da
    jmp.d8 L_004ad4ec                            # 004ad4e1
L_004ad4e3:
    # block 0x004ad4e3: entered by jmp at 0x004ad544, 3 instruction(s), falls into the block at 0x004ad4ec
    mov eax, dword ptr [ebp - local_4]           # 004ad4e3
    add eax, 0x1                                 # 004ad4e6
    mov dword ptr [ebp - local_4], eax           # 004ad4e9
L_004ad4ec:
    # block 0x004ad4ec: entered by jmp at 0x004ad4e1, 3 instruction(s), ends with jge to 0x004ad546 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ad4ec
    cmp ecx, dword ptr [ebp - local_30]          # 004ad4ef
    jge.d8 L_004ad546                            # 004ad4f2
    # block 0x004ad4f4: entered by fall-through of jge at 0x004ad4f2, 9 instruction(s), ends with jle to 0x004ad520 (forward)
    mov edx, dword ptr [ebp - local_34]          # 004ad4f4
    movsx eax, word ptr [edx]                    # 004ad4f7
    mov ecx, dword ptr [ebp - local_4]           # 004ad4fa
    movsx edx, word ptr [ebp + 2*ecx - local_28] # 004ad4fd
    imul edx, edx, 0xc7                          # 004ad502
    mov ecx, dword ptr [ebp - local_38]          # 004ad508
    movsx edx, word ptr [ecx + edx + field_6e]   # 004ad50b
    {load} cmp eax, edx                          # 004ad510
    jle.d8 L_004ad520                            # 004ad512
    # block 0x004ad514: entered by fall-through of jle at 0x004ad512, 4 instruction(s), ends with forward jump to 0x004ad53a
    mov eax, dword ptr [ebp - local_34]          # 004ad514
    mov cx, word ptr [eax]                       # 004ad517
    mov word ptr [ebp - local_3a], cx            # 004ad51a
    jmp.d8 L_004ad53a                            # 004ad51e
L_004ad520:
    # block 0x004ad520: entered by jle at 0x004ad512, 6 instruction(s), falls into the block at 0x004ad53a
    mov edx, dword ptr [ebp - local_4]           # 004ad520
    movsx eax, word ptr [ebp + 2*edx - local_28] # 004ad523
    imul eax, eax, 0xc7                          # 004ad528
    mov ecx, dword ptr [ebp - local_38]          # 004ad52e
    mov dx, word ptr [ecx + eax + field_6e]      # 004ad531
    mov word ptr [ebp - local_3a], dx            # 004ad536
L_004ad53a:
    # block 0x004ad53a: entered by jmp at 0x004ad51e, 4 instruction(s), ends with backward jump to 0x004ad4e3
    mov eax, dword ptr [ebp - local_34]          # 004ad53a
    mov cx, word ptr [ebp - local_3a]            # 004ad53d
    mov word ptr [eax], cx                       # 004ad541
    jmp.d8 L_004ad4e3                            # 004ad544
L_004ad546:
    # block 0x004ad546: entered by jge at 0x004ad4f2, 18 instruction(s), calls FUN_004ae495, FUN_004adae8, falls into the block at 0x004ad58b
    mov edx, dword ptr [ebp - local_34]          # 004ad546
    mov ax, word ptr [edx]                       # 004ad549
    .insn 0x66, 0x05, 0x0001{:u16}               # 004ad54c
    mov ecx, dword ptr [ebp - local_34]          # 004ad550
    mov word ptr [ecx], ax                       # 004ad553
    mov edx, dword ptr [ebp - local_38]          # 004ad556
    movsx eax, word ptr [edx + field_24]         # 004ad559
    push eax                                     # 004ad55d
    mov ecx, dword ptr [ebp - local_38]          # 004ad55e
    call FUN_004ae495                            # 004ad561
    mov ecx, dword ptr [ebp - local_38]          # 004ad566
    mov dword ptr [ecx + field_6a], 0x1          # 004ad569
    mov edx, dword ptr [ebp - local_38]          # 004ad570
    mov word ptr [edx + field_24], 0xffff        # 004ad573
    mov eax, dword ptr [ebp - local_38]          # 004ad579
    mov dword ptr [eax + field_20], 0x0          # 004ad57c
    mov ecx, dword ptr [ebp - local_38]          # 004ad583
    call FUN_004adae8                            # 004ad586
L_004ad58b:
    # block 0x004ad58b: entered by je at 0x004ad324; jne at 0x004ad337; jne at 0x004ad347; jne at 0x004ad361; more, 4 instruction(s), ends with ret
    pop edi                                      # 004ad58b
    {load} mov esp, ebp                          # 004ad58c
    pop ebp                                      # 004ad58e
    ret                                          # 004ad58f

