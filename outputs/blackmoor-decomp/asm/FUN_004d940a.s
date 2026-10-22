# FUN_004d940a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d940a
# extent:       0x004d940a-0x004d9632 (552 code bytes)
# span:         0x004d940a-0x004d9632 (code 552, tables 0, padding 0)
# sha256:       bd8280b4b16bd83148693d1463763de7ae9a33bf7d996e6f5aea7993caa2c699
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d940a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_94ca, field_94cc, field_98a8; [ecx + n] field_94d0, field_98a8; [edx + n] field_9414, field_9418, field_94ce, field_94d2, field_98a8
# callees:      calls FUN_004e9e84, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 124 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_9414, 0x9414  # offset +0x9414
.equ field_9418, 0x9418  # offset +0x9418
.equ field_94ca, 0x94ca  # offset +0x94ca
.equ field_94cc, 0x94cc  # offset +0x94cc
.equ field_94ce, 0x94ce  # offset +0x94ce
.equ field_94d0, 0x94d0  # offset +0x94d0
.equ field_94d2, 0x94d2  # offset +0x94d2
.equ field_98a8, 0x98a8  # offset +0x98a8

# --- external targets -----------------------------------------------
.set FUN_004e9e84, .text + (0x004e9e84 - 0x401000)

.org 0x004d940a - 0x401000
.globl FUN_004d940a
FUN_004d940a:
    # block 0x004d940a: entry, 56 instruction(s), ends with je to 0x004d9520 (forward)
    push ebp                                     # 004d940a
    {load} mov ebp, esp                          # 004d940b
    push ecx                                     # 004d940d
    push esi                                     # 004d940e
    push edi                                     # 004d940f
    mov dword ptr [ebp - local_4], ecx           # 004d9410
    mov esi, dword ptr [ebp - local_4]           # 004d9413
    add esi, 0x476                               # 004d9416
    mov ecx, 0x1e                                # 004d941c
    mov edi, 0x5839b1                            # 004d9421
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d9426
    mov ecx, 0x8c2                               # 004d9428
    mov esi, dword ptr [ebp - local_4]           # 004d942d
    add esi, 0x4ee                               # 004d9430
    mov edi, 0x583a29                            # 004d9436
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d943b
    movsw word ptr es:[edi], word ptr [esi]      # 004d943d
    mov esi, dword ptr [ebp - local_4]           # 004d943f
    add esi, 0x27f8                              # 004d9442
    mov ecx, 0x29b                               # 004d9448
    mov edi, 0x585d33                            # 004d944d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d9452
    movsw word ptr es:[edi], word ptr [esi]      # 004d9454
    mov ecx, 0x4e3                               # 004d9456
    mov esi, dword ptr [ebp - local_4]           # 004d945b
    add esi, 0x3266                              # 004d945e
    mov edi, 0x5867a1                            # 004d9464
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d9469
    mov ecx, 0x1388                              # 004d946b
    mov esi, dword ptr [ebp - local_4]           # 004d9470
    add esi, 0x45f2                              # 004d9473
    mov edi, 0x587b2d                            # 004d9479
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d947e
    movsw word ptr es:[edi], word ptr [esi]      # 004d9480
    mov esi, dword ptr [ebp - local_4]           # 004d9482
    add esi, 0x941c                              # 004d9485
    mov ecx, 0x12                                # 004d948b
    mov edi, 0x591990                            # 004d9490
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d9495
    movsw word ptr es:[edi], word ptr [esi]      # 004d9497
    mov eax, dword ptr [ebp - local_4]           # 004d9499
    mov cx, word ptr [eax + field_94ca]          # 004d949c
    mov word ptr [0x58c94f], cx                  # 004d94a3
    mov edx, dword ptr [ebp - local_4]           # 004d94aa
    mov eax, dword ptr [edx + field_9414]        # 004d94ad
    mov dword ptr [0x58c951], eax                # 004d94b3
    mov ecx, dword ptr [edx + field_9418]        # 004d94b8
    mov dword ptr [0x58c955], ecx                # 004d94be
    mov esi, dword ptr [ebp - local_4]           # 004d94c4
    add esi, 0x9466                              # 004d94c7
    mov ecx, 0x19                                # 004d94cd
    mov edi, 0x58c959                            # 004d94d2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d94d7
    mov edx, dword ptr [ebp - local_4]           # 004d94d9
    cmp dword ptr [edx + field_94d2], 0x0        # 004d94dc
    je.d8 L_004d9520                             # 004d94e3
    # block 0x004d94e5: entered by fall-through of je at 0x004d94e3, 10 instruction(s), falls into the block at 0x004d9520
    mov eax, dword ptr [ebp - local_4]           # 004d94e5
    movsx ecx, word ptr [eax + field_94cc]       # 004d94e8
    mov dword ptr [0x5bb57b], ecx                # 004d94ef
    mov edx, dword ptr [ebp - local_4]           # 004d94f5
    mov ax, word ptr [edx + field_94ce]          # 004d94f8
    mov word ptr [0x5bb599], ax                  # 004d94ff
    mov ecx, dword ptr [ebp - local_4]           # 004d9505
    mov dx, word ptr [ecx + field_94d0]          # 004d9508
    mov word ptr [0x5bb595], dx                  # 004d950f
    mov dword ptr [0x583999], 0x4                # 004d9516
L_004d9520:
    # block 0x004d9520: entered by je at 0x004d94e3, 6 instruction(s), ends with forward jump to 0x004d955f
    mov word ptr [0x583a2b], 0x0                 # 004d9520
    mov word ptr [0x583a2d], 0x0                 # 004d9529
    mov word ptr [0x583a2f], 0x0                 # 004d9532
    mov eax, dword ptr [ebp - local_4]           # 004d953b
    mov dword ptr [eax + field_98a8], 0x0        # 004d953e
    jmp.d8 L_004d955f                            # 004d9548
L_004d954a:
    # block 0x004d954a: entered by jmp at 0x004d95a4, 5 instruction(s), falls into the block at 0x004d955f
    mov ecx, dword ptr [ebp - local_4]           # 004d954a
    mov edx, dword ptr [ecx + field_98a8]        # 004d954d
    add edx, 0x1                                 # 004d9553
    mov eax, dword ptr [ebp - local_4]           # 004d9556
    mov dword ptr [eax + field_98a8], edx        # 004d9559
L_004d955f:
    # block 0x004d955f: entered by jmp at 0x004d9548, 3 instruction(s), ends with jge to 0x004d95a6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d955f
    cmp dword ptr [ecx + field_98a8], 0x46       # 004d9562
    jge.d8 L_004d95a6                            # 004d9569
    # block 0x004d956b: entered by fall-through of jge at 0x004d9569, 10 instruction(s), ends with backward jump to 0x004d954a
    mov edx, dword ptr [ebp - local_4]           # 004d956b
    mov eax, dword ptr [edx + field_98a8]        # 004d956e
    mov word ptr [2*eax + 0x583a31], 0xffff      # 004d9574
    mov ecx, dword ptr [ebp - local_4]           # 004d957e
    mov edx, dword ptr [ecx + field_98a8]        # 004d9581
    mov word ptr [2*edx + 0x583abd], 0xffff      # 004d9587
    mov eax, dword ptr [ebp - local_4]           # 004d9591
    mov ecx, dword ptr [eax + field_98a8]        # 004d9594
    mov word ptr [2*ecx + 0x583b49], 0xffff      # 004d959a
    jmp.d8 L_004d954a                            # 004d95a4
L_004d95a6:
    # block 0x004d95a6: entered by jge at 0x004d9569, 3 instruction(s), ends with forward jump to 0x004d95ca
    mov edx, dword ptr [ebp - local_4]           # 004d95a6
    mov dword ptr [edx + field_98a8], 0x0        # 004d95a9
    jmp.d8 L_004d95ca                            # 004d95b3
L_004d95b5:
    # block 0x004d95b5: entered by jmp at 0x004d9600, 5 instruction(s), falls into the block at 0x004d95ca
    mov eax, dword ptr [ebp - local_4]           # 004d95b5
    mov ecx, dword ptr [eax + field_98a8]        # 004d95b8
    add ecx, 0x1                                 # 004d95be
    mov edx, dword ptr [ebp - local_4]           # 004d95c1
    mov dword ptr [edx + field_98a8], ecx        # 004d95c4
L_004d95ca:
    # block 0x004d95ca: entered by jmp at 0x004d95b3, 3 instruction(s), ends with jge to 0x004d9602 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d95ca
    cmp dword ptr [eax + field_98a8], 0x46       # 004d95cd
    jge.d8 L_004d9602                            # 004d95d4
    # block 0x004d95d6: entered by fall-through of jge at 0x004d95d4, 4 instruction(s), ends with jne to 0x004d9600 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d95d6
    mov edx, dword ptr [ecx + field_98a8]        # 004d95d9
    cmp dword ptr [4*edx + 0x583bd5], 0x1        # 004d95df
    jne.d8 L_004d9600                            # 004d95e7
    # block 0x004d95e9: entered by fall-through of jne at 0x004d95e7, 6 instruction(s), calls FUN_004e9e84, falls into the block at 0x004d9600
    push 0x1                                     # 004d95e9
    mov eax, dword ptr [ebp - local_4]           # 004d95eb
    mov cx, word ptr [eax + field_98a8]          # 004d95ee
    push ecx                                     # 004d95f5
    mov ecx, 0x571442                            # 004d95f6
    call FUN_004e9e84                            # 004d95fb
L_004d9600:
    # block 0x004d9600: entered by jne at 0x004d95e7, 1 instruction(s), ends with backward jump to 0x004d95b5
    jmp.d8 L_004d95b5                            # 004d9600
L_004d9602:
    # block 0x004d9602: entered by jge at 0x004d95d4, 2 instruction(s), ends with jne to 0x004d9617 (forward)
    cmp dword ptr [0x586825], 0x1                # 004d9602
    jne.d8 L_004d9617                            # 004d9609
    # block 0x004d960b: entered by fall-through of jne at 0x004d9609, 2 instruction(s), ends with forward jump to 0x004d9621
    mov dword ptr [0x5a4c1c], 0x0                # 004d960b
    jmp.d8 L_004d9621                            # 004d9615
L_004d9617:
    # block 0x004d9617: entered by jne at 0x004d9609, 1 instruction(s), falls into the block at 0x004d9621
    mov dword ptr [0x5a4c1c], 0x1                # 004d9617
L_004d9621:
    # block 0x004d9621: entered by jmp at 0x004d9615, 7 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ret
    call dword ptr [0x52a23c]                    # 004d9621
    mov dword ptr [0x585d33], eax                # 004d9627
    pop edi                                      # 004d962c
    pop esi                                      # 004d962d
    {load} mov esp, ebp                          # 004d962e
    pop ebp                                      # 004d9630
    ret                                          # 004d9631

