# FUN_004484ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004484ba
# extent:       0x004484ba-0x004487de (804 code bytes)
# span:         0x004484ba-0x004487de (code 804, tables 0, padding 0)
# sha256:       9de0f60086789e8cf3a191fd1c9ff9dd1e8176cfba74ebf74cc77b2a364e4827
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004484ba
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_5, field_1e, field_36; [ecx + n] field_2, field_3, field_2a, field_2c, field_2e, field_3a; [edx + n] field_2, field_32
# callees:      calls FUN_0042ba3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 190 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_5, 0x5  # offset +0x5
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)

.org 0x004484ba - 0x401000
.globl FUN_004484ba
FUN_004484ba:
    # block 0x004484ba: entry, 7 instruction(s), ends with je to 0x004487d8 (forward)
    push ebp                                     # 004484ba
    {load} mov ebp, esp                          # 004484bb
    sub esp, 0x20                                # 004484bd
    mov dword ptr [ebp - local_1c], ecx          # 004484c0
    mov eax, dword ptr [ebp - local_1c]          # 004484c3
    cmp dword ptr [eax + field_1e], 0x0          # 004484c6
    je.d32 L_004487d8                            # 004484ca
    # block 0x004484d0: entered by fall-through of je at 0x004484ca, 13 instruction(s), ends with je to 0x0044851a (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004484d0
    imul ecx, ecx, 0x8d                          # 004484d4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004484da
    mov dword ptr [ebp - local_10], edx          # 004484e0
    mov eax, dword ptr [ebp - local_10]          # 004484e3
    add eax, 0x7                                 # 004484e6
    mov dword ptr [ebp - local_14], eax          # 004484e9
    movsx ecx, word ptr [ebp + arg_8]            # 004484ec
    imul ecx, ecx, 0x8d                          # 004484f0
    mov edx, dword ptr [ecx + 0x5bb632]          # 004484f6
    mov dword ptr [ebp - local_20], edx          # 004484fc
    cmp dword ptr [ebp - local_20], 0x0          # 004484ff
    je.d8 L_0044851a                             # 00448503
    # block 0x00448505: entered by fall-through of je at 0x00448503, 2 instruction(s), ends with je to 0x00448538 (forward)
    cmp dword ptr [ebp - local_20], 0x1          # 00448505
    je.d8 L_00448538                             # 00448509
    # block 0x0044850b: entered by fall-through of je at 0x00448509, 2 instruction(s), ends with je to 0x00448631 (forward)
    cmp dword ptr [ebp - local_20], 0x2          # 0044850b
    je.d32 L_00448631                            # 0044850f
    # block 0x00448515: entered by fall-through of je at 0x0044850f, 1 instruction(s), ends with forward jump to 0x004487d8
    jmp.d32 L_004487d8                           # 00448515
L_0044851a:
    # block 0x0044851a: entered by je at 0x00448503, 4 instruction(s), falls into the block at 0x00448538
    mov dword ptr [0x5bb1ca], 0x1                # 0044851a
    movsx eax, word ptr [ebp + arg_8]            # 00448524
    imul eax, eax, 0x8d                          # 00448528
    mov dword ptr [eax + 0x5bb632], 0x1          # 0044852e
L_00448538:
    # block 0x00448538: entered by je at 0x00448509, 5 instruction(s), ends with forward jump to 0x00448560
    movsx ecx, word ptr [ebp + arg_8]            # 00448538
    imul ecx, ecx, 0x8d                          # 0044853c
    mov dword ptr [ecx + 0x5bb626], 0x0          # 00448542
    mov word ptr [ebp - local_18], 0x0           # 0044854c
    jmp.d8 L_00448560                            # 00448552
L_00448554:
    # block 0x00448554: entered by jmp at 0x00448627, 3 instruction(s), falls into the block at 0x00448560
    mov dx, word ptr [ebp - local_18]            # 00448554
    add dx, 0x1                                  # 00448558
    mov word ptr [ebp - local_18], dx            # 0044855c
L_00448560:
    # block 0x00448560: entered by jmp at 0x00448552, 5 instruction(s), ends with jge to 0x0044862c (forward)
    movsx eax, word ptr [ebp - local_18]         # 00448560
    mov ecx, dword ptr [ebp - local_14]          # 00448564
    movsx edx, word ptr [ecx + field_2a]         # 00448567
    {load} cmp eax, edx                          # 0044856b
    jge.d32 L_0044862c                           # 0044856d
    # block 0x00448573: entered by fall-through of jge at 0x0044856d, 7 instruction(s), ends with jne to 0x00448627 (forward)
    movsx eax, word ptr [ebp - local_18]         # 00448573
    imul eax, eax, 0x12                          # 00448577
    mov ecx, dword ptr [ebp - local_14]          # 0044857a
    movsx edx, word ptr [ecx + eax + field_2c]   # 0044857d
    movsx eax, word ptr [0x5bb50b]               # 00448582
    {load} cmp edx, eax                          # 00448589
    jne.d32 L_00448627                           # 0044858b
    # block 0x00448591: entered by fall-through of jne at 0x0044858b, 32 instruction(s), ends with forward jump to 0x0044862c
    movsx ecx, word ptr [ebp + arg_8]            # 00448591
    imul ecx, ecx, 0x8d                          # 00448595
    mov dword ptr [ecx + 0x5bb626], 0x1          # 0044859b
    movsx edx, word ptr [ebp - local_18]         # 004485a5
    imul edx, edx, 0x12                          # 004485a9
    movsx eax, word ptr [ebp + arg_8]            # 004485ac
    imul eax, eax, 0x8d                          # 004485b0
    mov ecx, dword ptr [ebp - local_14]          # 004485b6
    mov dx, word ptr [ecx + edx + field_2e]      # 004485b9
    mov word ptr [eax + 0x5bb62a], dx            # 004485be
    movsx eax, word ptr [ebp - local_18]         # 004485c5
    imul eax, eax, 0x12                          # 004485c9
    movsx ecx, word ptr [ebp + arg_8]            # 004485cc
    imul ecx, ecx, 0x8d                          # 004485d0
    mov edx, dword ptr [ebp - local_14]          # 004485d6
    mov ax, word ptr [edx + eax + field_32]      # 004485d9
    mov word ptr [ecx + 0x5bb62c], ax            # 004485de
    movsx ecx, word ptr [ebp - local_18]         # 004485e5
    imul ecx, ecx, 0x12                          # 004485e9
    movsx edx, word ptr [ebp + arg_8]            # 004485ec
    imul edx, edx, 0x8d                          # 004485f0
    mov eax, dword ptr [ebp - local_14]          # 004485f6
    mov cx, word ptr [eax + ecx + field_36]      # 004485f9
    mov word ptr [edx + 0x5bb62e], cx            # 004485fe
    movsx edx, word ptr [ebp - local_18]         # 00448605
    imul edx, edx, 0x12                          # 00448609
    movsx eax, word ptr [ebp + arg_8]            # 0044860c
    imul eax, eax, 0x8d                          # 00448610
    mov ecx, dword ptr [ebp - local_14]          # 00448616
    mov dx, word ptr [ecx + edx + field_3a]      # 00448619
    mov word ptr [eax + 0x5bb630], dx            # 0044861e
    jmp.d8 L_0044862c                            # 00448625
L_00448627:
    # block 0x00448627: entered by jne at 0x0044858b, 1 instruction(s), ends with backward jump to 0x00448554
    jmp.d32 L_00448554                           # 00448627
L_0044862c:
    # block 0x0044862c: entered by jge at 0x0044856d; jmp at 0x00448625, 1 instruction(s), ends with forward jump to 0x004487d8
    jmp.d32 L_004487d8                           # 0044862c
L_00448631:
    # block 0x00448631: entered by je at 0x0044850f, 8 instruction(s), ends with forward jump to 0x0044866a
    movsx eax, word ptr [ebp + arg_8]            # 00448631
    imul eax, eax, 0x8d                          # 00448635
    mov byte ptr [eax + 0x5bb625], 0x1           # 0044863b
    movsx ecx, word ptr [ebp + arg_8]            # 00448642
    imul ecx, ecx, 0x8d                          # 00448646
    mov dword ptr [ecx + 0x5bb626], 0x0          # 0044864c
    mov word ptr [ebp - local_c], 0x0            # 00448656
    jmp.d8 L_0044866a                            # 0044865c
L_0044865e:
    # block 0x0044865e: entered by jmp at 0x004486a1, 3 instruction(s), falls into the block at 0x0044866a
    mov dx, word ptr [ebp - local_c]             # 0044865e
    add dx, 0x1                                  # 00448662
    mov word ptr [ebp - local_c], dx             # 00448666
L_0044866a:
    # block 0x0044866a: entered by jmp at 0x0044865c, 3 instruction(s), ends with jge to 0x004486a3 (forward)
    movsx eax, word ptr [ebp - local_c]          # 0044866a
    cmp eax, 0xa                                 # 0044866e
    jge.d8 L_004486a3                            # 00448671
    # block 0x00448673: entered by fall-through of jge at 0x00448671, 5 instruction(s), ends with je to 0x004486a1 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00448673
    mov edx, dword ptr [ebp - local_14]          # 00448677
    movsx eax, word ptr [edx + 4*ecx]            # 0044867a
    cmp eax, -0x1                                # 0044867e
    je.d8 L_004486a1                             # 00448681
    # block 0x00448683: entered by fall-through of je at 0x00448681, 7 instruction(s), falls into the block at 0x004486a1
    movsx ecx, word ptr [ebp - local_c]          # 00448683
    mov edx, dword ptr [ebp - local_14]          # 00448687
    movsx eax, word ptr [edx + 4*ecx + field_2]  # 0044868a
    movsx ecx, word ptr [ebp - local_c]          # 0044868f
    mov edx, dword ptr [ebp - local_14]          # 00448693
    movsx ecx, word ptr [edx + 4*ecx]            # 00448696
    mov dword ptr [4*ecx + 0x585801], eax        # 0044869a
L_004486a1:
    # block 0x004486a1: entered by je at 0x00448681, 1 instruction(s), ends with backward jump to 0x0044865e
    jmp.d8 L_0044865e                            # 004486a1
L_004486a3:
    # block 0x004486a3: entered by jge at 0x00448671, 9 instruction(s), ends with jne to 0x004486e7 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004486a3
    movsx eax, word ptr [edx]                    # 004486a6
    mov cx, word ptr [2*eax + 0x58c9de]          # 004486a9
    mov word ptr [ebp - local_4], cx             # 004486b1
    mov edx, dword ptr [ebp - local_10]          # 004486b5
    {load} xor eax, eax                          # 004486b8
    mov al, byte ptr [edx + field_2]             # 004486ba
    cmp eax, 0x1                                 # 004486bd
    jne.d8 L_004486e7                            # 004486c0
    # block 0x004486c2: entered by fall-through of jne at 0x004486c0, 4 instruction(s), ends with jne to 0x004486d9 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004486c2
    movsx edx, word ptr [0x58c9bd]               # 004486c6
    {load} cmp ecx, edx                          # 004486cd
    jne.d8 L_004486d9                            # 004486cf
    # block 0x004486d1: entered by fall-through of jne at 0x004486cf, 2 instruction(s), ends with forward jump to 0x004486e5
    mov word ptr [ebp - local_4], 0x1            # 004486d1
    jmp.d8 L_004486e5                            # 004486d7
L_004486d9:
    # block 0x004486d9: entered by jne at 0x004486cf, 3 instruction(s), falls into the block at 0x004486e5
    mov ax, word ptr [ebp - local_4]             # 004486d9
    .insn 0x66, 0x05, 0x0001{:u16}               # 004486dd
    mov word ptr [ebp - local_4], ax             # 004486e1
L_004486e5:
    # block 0x004486e5: entered by jmp at 0x004486d7, 1 instruction(s), ends with forward jump to 0x00448716
    jmp.d8 L_00448716                            # 004486e5
L_004486e7:
    # block 0x004486e7: entered by jne at 0x004486c0, 5 instruction(s), ends with jne to 0x00448716 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004486e7
    {load} xor edx, edx                          # 004486ea
    mov dl, byte ptr [ecx + field_2]             # 004486ec
    cmp edx, 0x2                                 # 004486ef
    jne.d8 L_00448716                            # 004486f2
    # block 0x004486f4: entered by fall-through of jne at 0x004486f2, 3 instruction(s), ends with jne to 0x0044870a (forward)
    movsx eax, word ptr [ebp - local_4]          # 004486f4
    cmp eax, 0x1                                 # 004486f8
    jne.d8 L_0044870a                            # 004486fb
    # block 0x004486fd: entered by fall-through of jne at 0x004486fb, 3 instruction(s), ends with forward jump to 0x00448716
    mov cx, word ptr [0x58c9bd]                  # 004486fd
    mov word ptr [ebp - local_4], cx             # 00448704
    jmp.d8 L_00448716                            # 00448708
L_0044870a:
    # block 0x0044870a: entered by jne at 0x004486fb, 3 instruction(s), falls into the block at 0x00448716
    mov dx, word ptr [ebp - local_4]             # 0044870a
    sub dx, 0x1                                  # 0044870e
    mov word ptr [ebp - local_4], dx             # 00448712
L_00448716:
    # block 0x00448716: entered by jmp at 0x004486e5; jne at 0x004486f2; jmp at 0x00448708, 10 instruction(s), ends with jne to 0x00448750 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00448716
    movsx ecx, word ptr [eax]                    # 00448719
    mov dx, word ptr [ebp - local_4]             # 0044871c
    mov word ptr [2*ecx + 0x58c9de], dx          # 00448720
    mov eax, dword ptr [ebp - local_10]          # 00448728
    movsx ecx, word ptr [eax]                    # 0044872b
    movsx edx, word ptr [2*ecx + 0x58ca06]       # 0044872e
    movsx eax, word ptr [ebp - local_4]          # 00448736
    {load} cmp edx, eax                          # 0044873a
    jne.d8 L_00448750                            # 0044873c
    # block 0x0044873e: entered by fall-through of jne at 0x0044873c, 3 instruction(s), falls into the block at 0x00448750
    mov ecx, dword ptr [ebp - local_10]          # 0044873e
    movsx edx, word ptr [ecx + field_3]          # 00448741
    mov dword ptr [4*edx + 0x585801], 0x1        # 00448745
L_00448750:
    # block 0x00448750: entered by jne at 0x0044873c, 6 instruction(s), ends with forward jump to 0x0044877d
    mov dword ptr [ebp - local_8], 0x1           # 00448750
    mov eax, dword ptr [ebp - local_10]          # 00448757
    movsx ecx, word ptr [eax + field_5]          # 0044875a
    mov dword ptr [4*ecx + 0x585801], 0x0        # 0044875e
    mov word ptr [ebp - local_c], 0x0            # 00448769
    jmp.d8 L_0044877d                            # 0044876f
L_00448771:
    # block 0x00448771: entered by jmp at 0x004487b1, 3 instruction(s), falls into the block at 0x0044877d
    mov dx, word ptr [ebp - local_c]             # 00448771
    add dx, 0x1                                  # 00448775
    mov word ptr [ebp - local_c], dx             # 00448779
L_0044877d:
    # block 0x0044877d: entered by jmp at 0x0044876f, 4 instruction(s), ends with jge to 0x004487b3 (forward)
    movsx eax, word ptr [ebp - local_c]          # 0044877d
    movsx ecx, word ptr [0x58c9bd]               # 00448781
    {load} cmp eax, ecx                          # 00448788
    jge.d8 L_004487b3                            # 0044878a
    # block 0x0044878c: entered by fall-through of jge at 0x0044878a, 6 instruction(s), ends with je to 0x004487b1 (forward)
    movsx edx, word ptr [ebp - local_c]          # 0044878c
    movsx eax, word ptr [2*edx + 0x58c9e0]       # 00448790
    movsx ecx, word ptr [ebp - local_c]          # 00448798
    movsx edx, word ptr [2*ecx + 0x58ca08]       # 0044879c
    {load} cmp eax, edx                          # 004487a4
    je.d8 L_004487b1                             # 004487a6
    # block 0x004487a8: entered by fall-through of je at 0x004487a6, 2 instruction(s), ends with forward jump to 0x004487b3
    mov dword ptr [ebp - local_8], 0x0           # 004487a8
    jmp.d8 L_004487b3                            # 004487af
L_004487b1:
    # block 0x004487b1: entered by je at 0x004487a6, 1 instruction(s), ends with backward jump to 0x00448771
    jmp.d8 L_00448771                            # 004487b1
L_004487b3:
    # block 0x004487b3: entered by jge at 0x0044878a; jmp at 0x004487af, 2 instruction(s), ends with je to 0x004487cb (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004487b3
    je.d8 L_004487cb                             # 004487b7
    # block 0x004487b9: entered by fall-through of je at 0x004487b7, 3 instruction(s), falls into the block at 0x004487cb
    mov eax, dword ptr [ebp - local_10]          # 004487b9
    movsx ecx, word ptr [eax + field_5]          # 004487bc
    mov dword ptr [4*ecx + 0x585801], 0x1        # 004487c0
L_004487cb:
    # block 0x004487cb: entered by je at 0x004487b7, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x004487d8
    mov dx, word ptr [ebp + arg_8]               # 004487cb
    push edx                                     # 004487cf
    call FUN_0042ba3a                            # 004487d0
    add esp, 0x4                                 # 004487d5
L_004487d8:
    # block 0x004487d8: entered by je at 0x004484ca; jmp at 0x00448515; jmp at 0x0044862c, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004487d8
    pop ebp                                      # 004487da
    ret 0x4                                      # 004487db

