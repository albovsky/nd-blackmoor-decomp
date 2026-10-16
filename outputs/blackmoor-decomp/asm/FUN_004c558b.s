# FUN_004c558b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c558b
# extent:       0x004c558b-0x004c5770 (485 code bytes)
# span:         0x004c558b-0x004c5770 (code 485, tables 0, padding 0)
# sha256:       7f7561a9c5dc9d605475de782825f3d840f56fbfcccb6a7673945f0e0e71afd0
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c558b
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_6c, local_80, local_90, local_94, local_190, local_194, local_198 and 2 more
# fields:       [eax + n] field_4, field_c, field_2f; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_004c4067, FUN_004c4202
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 157 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_6c, 0x6c  # offset -0x6c
.equ local_80, 0x80  # offset -0x80
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_190, 0x190  # offset -0x190
.equ local_194, 0x194  # offset -0x194
.equ local_198, 0x198  # offset -0x198
.equ local_19c, 0x19c  # offset -0x19c
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c558b - 0x401000
.globl FUN_004c558b
FUN_004c558b:
    # block 0x004c558b: entry, 9 instruction(s), ends with je to 0x004c5687 (forward)
    push ebp                                     # 004c558b
    {load} mov ebp, esp                          # 004c558c
    sub esp, 0x1a0                               # 004c558e
    push esi                                     # 004c5594
    push edi                                     # 004c5595
    mov dword ptr [ebp - local_1a0], ecx         # 004c5596
    movsx eax, word ptr [0x63a4cd]               # 004c559c
    test eax, eax                                # 004c55a3
    je.d32 L_004c5687                            # 004c55a5
    # block 0x004c55ab: entered by fall-through of je at 0x004c55a5, 23 instruction(s), ends with jne to 0x004c5619 (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c55ab
    mov edx, dword ptr [ebp + arg_10]            # 004c55ae
    mov eax, dword ptr [ecx + field_8]           # 004c55b1
    sub eax, dword ptr [edx]                     # 004c55b4
    mov dword ptr [ebp - local_19c], eax         # 004c55b6
    mov ecx, dword ptr [ebp + arg_10]            # 004c55bc
    mov edx, dword ptr [ebp + arg_10]            # 004c55bf
    mov eax, dword ptr [ecx + field_c]           # 004c55c2
    sub eax, dword ptr [edx + field_4]           # 004c55c5
    mov dword ptr [ebp - local_198], eax         # 004c55c8
    mov ecx, dword ptr [ebp + arg_14]            # 004c55ce
    mov edx, dword ptr [ebp + arg_14]            # 004c55d1
    mov eax, dword ptr [ecx + field_8]           # 004c55d4
    sub eax, dword ptr [edx]                     # 004c55d7
    mov dword ptr [ebp - local_94], eax          # 004c55d9
    mov ecx, dword ptr [ebp + arg_14]            # 004c55df
    mov edx, dword ptr [ebp + arg_14]            # 004c55e2
    mov eax, dword ptr [ecx + field_c]           # 004c55e5
    sub eax, dword ptr [edx + field_4]           # 004c55e8
    mov dword ptr [ebp - local_194], eax         # 004c55eb
    mov ecx, dword ptr [ebp - local_19c]         # 004c55f1
    cmp ecx, dword ptr [ebp - local_94]          # 004c55f7
    jne.d8 L_004c5619                            # 004c55fd
    # block 0x004c55ff: entered by fall-through of jne at 0x004c55fd, 3 instruction(s), ends with jne to 0x004c5619 (forward)
    mov edx, dword ptr [ebp - local_198]         # 004c55ff
    cmp edx, dword ptr [ebp - local_194]         # 004c5605
    jne.d8 L_004c5619                            # 004c560b
    # block 0x004c560d: entered by fall-through of jne at 0x004c560b, 2 instruction(s), ends with je to 0x004c5619 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c560d
    je.d8 L_004c5619                             # 004c5611
    # block 0x004c5613: entered by fall-through of je at 0x004c5611, 2 instruction(s), ends with jne to 0x004c5687 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c5613
    jne.d8 L_004c5687                            # 004c5617
L_004c5619:
    # block 0x004c5619: entered by jne at 0x004c55fd; jne at 0x004c560b; je at 0x004c5611; fall-through of jne at 0x004c5617, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c5768
    mov eax, dword ptr [ebp + arg_14]            # 004c5619
    mov ecx, dword ptr [eax + field_c]           # 004c561c
    push ecx                                     # 004c561f
    mov edx, dword ptr [ebp + arg_14]            # 004c5620
    mov eax, dword ptr [edx + field_8]           # 004c5623
    push eax                                     # 004c5626
    mov ecx, dword ptr [ebp + arg_14]            # 004c5627
    mov edx, dword ptr [ecx + field_4]           # 004c562a
    push edx                                     # 004c562d
    mov eax, dword ptr [ebp + arg_14]            # 004c562e
    mov ecx, dword ptr [eax]                     # 004c5631
    push ecx                                     # 004c5633
    mov edx, dword ptr [ebp + arg_10]            # 004c5634
    mov eax, dword ptr [edx + field_c]           # 004c5637
    push eax                                     # 004c563a
    mov ecx, dword ptr [ebp + arg_10]            # 004c563b
    mov edx, dword ptr [ecx + field_8]           # 004c563e
    push edx                                     # 004c5641
    mov eax, dword ptr [ebp + arg_10]            # 004c5642
    mov ecx, dword ptr [eax + field_4]           # 004c5645
    push ecx                                     # 004c5648
    mov edx, dword ptr [ebp + arg_10]            # 004c5649
    mov eax, dword ptr [edx]                     # 004c564c
    push eax                                     # 004c564e
    mov ecx, dword ptr [ebp + arg_18]            # 004c564f
    push ecx                                     # 004c5652
    push 0x5549b4                                # 004c5653
    lea edx, [ebp - local_190]                   # 004c5658
    push edx                                     # 004c565e
    call FUN_0050ca3e                            # 004c565f
    add esp, 0x2c                                # 004c5664
    push 0x0                                     # 004c5667
    push 0x0                                     # 004c5669
    lea eax, [ebp - local_190]                   # 004c566b
    push eax                                     # 004c5671
    call FUN_0052139c                            # 004c5672
    mov ecx, dword ptr [ebp - local_1a0]         # 004c5677
    call FUN_004c97b4                            # 004c567d
    jmp.d32 L_004c5768                           # 004c5682
L_004c5687:
    # block 0x004c5687: entered by je at 0x004c55a5; jne at 0x004c5617, 43 instruction(s), calls FUN_004c4067, ends with forward jump to 0x004c5717
    push 0x10                                    # 004c5687
    mov ecx, dword ptr [ebp + arg_18]            # 004c5689
    push ecx                                     # 004c568c
    lea edx, [ebp - local_90]                    # 004c568d
    push edx                                     # 004c5693
    mov eax, dword ptr [ebp + arg_10]            # 004c5694
    push eax                                     # 004c5697
    mov ecx, dword ptr [ebp + arg_8]             # 004c5698
    push ecx                                     # 004c569b
    mov ecx, dword ptr [ebp - local_1a0]         # 004c569c
    call FUN_004c4067                            # 004c56a2
    mov edx, dword ptr [ebp - local_6c]          # 004c56a7
    mov dword ptr [ebp - local_c], edx           # 004c56aa
    mov eax, dword ptr [ebp + arg_c]             # 004c56ad
    movsx ecx, word ptr [eax + field_2f]         # 004c56b0
    mov edx, dword ptr [ebp + arg_14]            # 004c56b4
    mov eax, dword ptr [edx + field_4]           # 004c56b7
    imul eax, ecx                                # 004c56ba
    mov ecx, dword ptr [ebp + arg_c]             # 004c56bd
    mov edx, dword ptr [ecx]                     # 004c56c0
    {load} add edx, eax                          # 004c56c2
    movsx eax, word ptr [0x639895]               # 004c56c4
    mov ecx, dword ptr [ebp + arg_14]            # 004c56cb
    mov ecx, dword ptr [ecx]                     # 004c56ce
    imul ecx, eax                                # 004c56d0
    {load} add edx, ecx                          # 004c56d3
    mov dword ptr [ebp - local_8], edx           # 004c56d5
    mov edx, dword ptr [ebp + arg_10]            # 004c56d8
    mov eax, dword ptr [ebp + arg_10]            # 004c56db
    mov ecx, dword ptr [edx + field_c]           # 004c56de
    sub ecx, dword ptr [eax + field_4]           # 004c56e1
    add ecx, 0x1                                 # 004c56e4
    mov dword ptr [ebp - local_10], ecx          # 004c56e7
    mov edx, dword ptr [ebp + arg_10]            # 004c56ea
    mov eax, dword ptr [ebp + arg_10]            # 004c56ed
    mov ecx, dword ptr [edx + field_8]           # 004c56f0
    sub ecx, dword ptr [eax]                     # 004c56f3
    add ecx, 0x1                                 # 004c56f5
    movsx edx, word ptr [0x639895]               # 004c56f8
    imul ecx, edx                                # 004c56ff
    mov dword ptr [ebp - local_4], ecx           # 004c5702
    mov dword ptr [ebp - local_14], 0x0          # 004c5705
    jmp.d8 L_004c5717                            # 004c570c
L_004c570e:
    # block 0x004c570e: entered by jmp at 0x004c574e, 3 instruction(s), falls into the block at 0x004c5717
    mov eax, dword ptr [ebp - local_14]          # 004c570e
    add eax, 0x1                                 # 004c5711
    mov dword ptr [ebp - local_14], eax          # 004c5714
L_004c5717:
    # block 0x004c5717: entered by jmp at 0x004c570c, 3 instruction(s), ends with jge to 0x004c5750 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004c5717
    cmp ecx, dword ptr [ebp - local_10]          # 004c571a
    jge.d8 L_004c5750                            # 004c571d
    # block 0x004c571f: entered by fall-through of jge at 0x004c571d, 18 instruction(s), ends with backward jump to 0x004c570e
    mov ecx, dword ptr [ebp - local_4]           # 004c571f
    mov esi, dword ptr [ebp - local_c]           # 004c5722
    mov edi, dword ptr [ebp - local_8]           # 004c5725
    {load} mov edx, ecx                          # 004c5728
    shr ecx, 0x2                                 # 004c572a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c572d
    {load} mov ecx, edx                          # 004c572f
    and ecx, 0x3                                 # 004c5731
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c5734
    mov eax, dword ptr [ebp + arg_c]             # 004c5736
    movsx ecx, word ptr [eax + field_2f]         # 004c5739
    mov edx, dword ptr [ebp - local_8]           # 004c573d
    {load} add edx, ecx                          # 004c5740
    mov dword ptr [ebp - local_8], edx           # 004c5742
    mov eax, dword ptr [ebp - local_c]           # 004c5745
    add eax, dword ptr [ebp - local_80]          # 004c5748
    mov dword ptr [ebp - local_c], eax           # 004c574b
    jmp.d8 L_004c570e                            # 004c574e
L_004c5750:
    # block 0x004c5750: entered by jge at 0x004c571d, 7 instruction(s), calls FUN_004c4202, falls into the block at 0x004c5768
    push 0x554a58                                # 004c5750
    mov ecx, dword ptr [ebp + arg_10]            # 004c5755
    push ecx                                     # 004c5758
    mov edx, dword ptr [ebp + arg_8]             # 004c5759
    push edx                                     # 004c575c
    mov ecx, dword ptr [ebp - local_1a0]         # 004c575d
    call FUN_004c4202                            # 004c5763
L_004c5768:
    # block 0x004c5768: entered by jmp at 0x004c5682, 5 instruction(s), ends with ret 0x14
    pop edi                                      # 004c5768
    pop esi                                      # 004c5769
    {load} mov esp, ebp                          # 004c576a
    pop ebp                                      # 004c576c
    ret 0x14                                     # 004c576d

