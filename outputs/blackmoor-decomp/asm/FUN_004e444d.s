# FUN_004e444d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e444d
# extent:       0x004e444d-0x004e45be (369 code bytes)
# span:         0x004e444d-0x004e45be (code 369, tables 0, padding 0)
# sha256:       e5b468ab8c7a3de38a28edc4a12f30cea0077aae11b1e63e79be02648e34c329
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e444d
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_11, local_12, local_18, local_1c, local_20, local_24, local_25, local_26 and 2 more
# fields:       [eax + n] field_1; [edx + n] field_1
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_83_runtime.c:action83_runtime_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 110 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_11, 0x11  # offset -0x11
.equ local_12, 0x12  # offset -0x12
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_25, 0x25  # offset -0x25
.equ local_26, 0x26  # offset -0x26
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x004e444d - 0x401000
.globl FUN_004e444d
FUN_004e444d:
    # block 0x004e444d: entry, 7 instruction(s), ends with jne to 0x004e450e (forward)
    push ebp                                     # 004e444d
    {load} mov ebp, esp                          # 004e444e
    sub esp, 0x30                                # 004e4450
    mov dword ptr [ebp - local_8], ecx           # 004e4453
    movsx eax, word ptr [ebp + arg_8]            # 004e4456
    test eax, eax                                # 004e445a
    jne.d32 L_004e450e                           # 004e445c
    # block 0x004e4462: entered by fall-through of jne at 0x004e445c, 2 instruction(s), ends with forward jump to 0x004e4476
    mov word ptr [ebp - local_4], 0x0            # 004e4462
    jmp.d8 L_004e4476                            # 004e4468
L_004e446a:
    # block 0x004e446a: entered by jmp at 0x004e4504, 3 instruction(s), falls into the block at 0x004e4476
    mov cx, word ptr [ebp - local_4]             # 004e446a
    add cx, 0x1                                  # 004e446e
    mov word ptr [ebp - local_4], cx             # 004e4472
L_004e4476:
    # block 0x004e4476: entered by jmp at 0x004e4468, 4 instruction(s), ends with jge to 0x004e4509 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e4476
    movsx eax, word ptr [0x5a1e5e]               # 004e447a
    {load} cmp edx, eax                          # 004e4481
    jge.d32 L_004e4509                           # 004e4483
    # block 0x004e4489: entered by fall-through of jge at 0x004e4483, 6 instruction(s), falls into the block at 0x004e449f
    mov ecx, dword ptr [ebp + arg_10]            # 004e4489
    mov dword ptr [ebp - local_c], ecx           # 004e448c
    movsx edx, word ptr [ebp - local_4]          # 004e448f
    imul edx, edx, 0x4a                          # 004e4493
    add edx, 0x5a2664                            # 004e4496
    mov dword ptr [ebp - local_10], edx          # 004e449c
L_004e449f:
    # block 0x004e449f: entered by jne at 0x004e44d1, 6 instruction(s), ends with jne to 0x004e44dc (forward)
    mov eax, dword ptr [ebp - local_10]          # 004e449f
    mov cl, byte ptr [eax]                       # 004e44a2
    mov byte ptr [ebp - local_11], cl            # 004e44a4
    mov edx, dword ptr [ebp - local_c]           # 004e44a7
    cmp cl, byte ptr [edx]                       # 004e44aa
    jne.d8 L_004e44dc                            # 004e44ac
    # block 0x004e44ae: entered by fall-through of jne at 0x004e44ac, 2 instruction(s), ends with je to 0x004e44d3 (forward)
    cmp byte ptr [ebp - local_11], 0x0           # 004e44ae
    je.d8 L_004e44d3                             # 004e44b2
    # block 0x004e44b4: entered by fall-through of je at 0x004e44b2, 6 instruction(s), ends with jne to 0x004e44dc (forward)
    mov eax, dword ptr [ebp - local_10]          # 004e44b4
    mov cl, byte ptr [eax + field_1]             # 004e44b7
    mov byte ptr [ebp - local_12], cl            # 004e44ba
    mov edx, dword ptr [ebp - local_c]           # 004e44bd
    cmp cl, byte ptr [edx + field_1]             # 004e44c0
    jne.d8 L_004e44dc                            # 004e44c3
    # block 0x004e44c5: entered by fall-through of jne at 0x004e44c3, 4 instruction(s), ends with jne to 0x004e449f (backward)
    add dword ptr [ebp - local_10], 0x2          # 004e44c5
    add dword ptr [ebp - local_c], 0x2           # 004e44c9
    cmp byte ptr [ebp - local_12], 0x0           # 004e44cd
    jne.d8 L_004e449f                            # 004e44d1
L_004e44d3:
    # block 0x004e44d3: entered by je at 0x004e44b2; fall-through of jne at 0x004e44d1, 2 instruction(s), ends with forward jump to 0x004e44e4
    mov dword ptr [ebp - local_18], 0x0          # 004e44d3
    jmp.d8 L_004e44e4                            # 004e44da
L_004e44dc:
    # block 0x004e44dc: entered by jne at 0x004e44ac; jne at 0x004e44c3, 3 instruction(s), falls into the block at 0x004e44e4
    {load} sbb eax, eax                          # 004e44dc
    sbb eax, -0x1                                # 004e44de
    mov dword ptr [ebp - local_18], eax          # 004e44e1
L_004e44e4:
    # block 0x004e44e4: entered by jmp at 0x004e44da, 4 instruction(s), ends with jne to 0x004e4504 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004e44e4
    mov dword ptr [ebp - local_1c], ecx          # 004e44e7
    cmp dword ptr [ebp - local_1c], 0x0          # 004e44ea
    jne.d8 L_004e4504                            # 004e44ee
    # block 0x004e44f0: entered by fall-through of jne at 0x004e44ee, 5 instruction(s), ends with forward jump to 0x004e45b8
    mov edx, dword ptr [ebp + arg_c]             # 004e44f0
    mov ax, word ptr [ebp - local_4]             # 004e44f3
    mov word ptr [edx], ax                       # 004e44f7
    mov eax, 0x1                                 # 004e44fa
    jmp.d32 L_004e45b8                           # 004e44ff
L_004e4504:
    # block 0x004e4504: entered by jne at 0x004e44ee, 1 instruction(s), ends with backward jump to 0x004e446a
    jmp.d32 L_004e446a                           # 004e4504
L_004e4509:
    # block 0x004e4509: entered by jge at 0x004e4483, 1 instruction(s), ends with forward jump to 0x004e45ae
    jmp.d32 L_004e45ae                           # 004e4509
L_004e450e:
    # block 0x004e450e: entered by jne at 0x004e445c, 2 instruction(s), ends with forward jump to 0x004e4522
    mov word ptr [ebp - local_4], 0x0            # 004e450e
    jmp.d8 L_004e4522                            # 004e4514
L_004e4516:
    # block 0x004e4516: entered by jmp at 0x004e45a9, 3 instruction(s), falls into the block at 0x004e4522
    mov cx, word ptr [ebp - local_4]             # 004e4516
    add cx, 0x1                                  # 004e451a
    mov word ptr [ebp - local_4], cx             # 004e451e
L_004e4522:
    # block 0x004e4522: entered by jmp at 0x004e4514, 4 instruction(s), ends with jge to 0x004e45ae (forward)
    movsx edx, word ptr [ebp - local_4]          # 004e4522
    movsx eax, word ptr [0x5a1e60]               # 004e4526
    {load} cmp edx, eax                          # 004e452d
    jge.d8 L_004e45ae                            # 004e452f
    # block 0x004e4531: entered by fall-through of jge at 0x004e452f, 6 instruction(s), falls into the block at 0x004e4547
    mov ecx, dword ptr [ebp + arg_10]            # 004e4531
    mov dword ptr [ebp - local_20], ecx          # 004e4534
    movsx edx, word ptr [ebp - local_4]          # 004e4537
    imul edx, edx, 0x29                          # 004e453b
    add edx, 0x5a434c                            # 004e453e
    mov dword ptr [ebp - local_24], edx          # 004e4544
L_004e4547:
    # block 0x004e4547: entered by jne at 0x004e4579, 6 instruction(s), ends with jne to 0x004e4584 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004e4547
    mov cl, byte ptr [eax]                       # 004e454a
    mov byte ptr [ebp - local_25], cl            # 004e454c
    mov edx, dword ptr [ebp - local_20]          # 004e454f
    cmp cl, byte ptr [edx]                       # 004e4552
    jne.d8 L_004e4584                            # 004e4554
    # block 0x004e4556: entered by fall-through of jne at 0x004e4554, 2 instruction(s), ends with je to 0x004e457b (forward)
    cmp byte ptr [ebp - local_25], 0x0           # 004e4556
    je.d8 L_004e457b                             # 004e455a
    # block 0x004e455c: entered by fall-through of je at 0x004e455a, 6 instruction(s), ends with jne to 0x004e4584 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004e455c
    mov cl, byte ptr [eax + field_1]             # 004e455f
    mov byte ptr [ebp - local_26], cl            # 004e4562
    mov edx, dword ptr [ebp - local_20]          # 004e4565
    cmp cl, byte ptr [edx + field_1]             # 004e4568
    jne.d8 L_004e4584                            # 004e456b
    # block 0x004e456d: entered by fall-through of jne at 0x004e456b, 4 instruction(s), ends with jne to 0x004e4547 (backward)
    add dword ptr [ebp - local_24], 0x2          # 004e456d
    add dword ptr [ebp - local_20], 0x2          # 004e4571
    cmp byte ptr [ebp - local_26], 0x0           # 004e4575
    jne.d8 L_004e4547                            # 004e4579
L_004e457b:
    # block 0x004e457b: entered by je at 0x004e455a; fall-through of jne at 0x004e4579, 2 instruction(s), ends with forward jump to 0x004e458c
    mov dword ptr [ebp - local_2c], 0x0          # 004e457b
    jmp.d8 L_004e458c                            # 004e4582
L_004e4584:
    # block 0x004e4584: entered by jne at 0x004e4554; jne at 0x004e456b, 3 instruction(s), falls into the block at 0x004e458c
    {load} sbb eax, eax                          # 004e4584
    sbb eax, -0x1                                # 004e4586
    mov dword ptr [ebp - local_2c], eax          # 004e4589
L_004e458c:
    # block 0x004e458c: entered by jmp at 0x004e4582, 4 instruction(s), ends with jne to 0x004e45a9 (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 004e458c
    mov dword ptr [ebp - local_30], ecx          # 004e458f
    cmp dword ptr [ebp - local_30], 0x0          # 004e4592
    jne.d8 L_004e45a9                            # 004e4596
    # block 0x004e4598: entered by fall-through of jne at 0x004e4596, 5 instruction(s), ends with forward jump to 0x004e45b8
    mov edx, dword ptr [ebp + arg_c]             # 004e4598
    mov ax, word ptr [ebp - local_4]             # 004e459b
    mov word ptr [edx], ax                       # 004e459f
    mov eax, 0x1                                 # 004e45a2
    jmp.d8 L_004e45b8                            # 004e45a7
L_004e45a9:
    # block 0x004e45a9: entered by jne at 0x004e4596, 1 instruction(s), ends with backward jump to 0x004e4516
    jmp.d32 L_004e4516                           # 004e45a9
L_004e45ae:
    # block 0x004e45ae: entered by jmp at 0x004e4509; jge at 0x004e452f, 3 instruction(s), falls into the block at 0x004e45b8
    mov ecx, dword ptr [ebp + arg_c]             # 004e45ae
    mov word ptr [ecx], 0x0                      # 004e45b1
    {load} xor eax, eax                          # 004e45b6
L_004e45b8:
    # block 0x004e45b8: entered by jmp at 0x004e44ff; jmp at 0x004e45a7, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004e45b8
    pop ebp                                      # 004e45ba
    ret 0xc                                      # 004e45bb

