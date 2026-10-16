# FUN_004be504
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be504
# extent:       0x004be504-0x004be619 (277 code bytes)
# span:         0x004be504-0x004be619 (code 277, tables 0, padding 0)
# sha256:       17579db3df9fcd801437ab8a72ee20b4d06e6f5be4f0de0279c4a9ff46af8d9d
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004be504
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1f4, field_1fc; [ecx + n] field_1f4, field_1f8, field_1fc; [edx + n] field_1f4, field_1fc
# callees:      calls FUN_004be4c7, FUN_0044655e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 80 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1f4, 0x1f4  # offset +0x1f4
.equ field_1f8, 0x1f8  # offset +0x1f8
.equ field_1fc, 0x1fc  # offset +0x1fc

# --- external targets -----------------------------------------------
.set FUN_0044655e, .text + (0x0044655e - 0x401000)
.set FUN_004be4c7, .text + (0x004be4c7 - 0x401000)

.org 0x004be504 - 0x401000
.globl FUN_004be504
FUN_004be504:
    # block 0x004be504: entry, 11 instruction(s), ends with je to 0x004be613 (forward)
    push ebp                                     # 004be504
    {load} mov ebp, esp                          # 004be505
    sub esp, 0x10                                # 004be507
    push esi                                     # 004be50a
    push edi                                     # 004be50b
    mov dword ptr [ebp - local_c], ecx           # 004be50c
    mov eax, dword ptr [ebp - local_c]           # 004be50f
    mov ecx, dword ptr [ebp - local_c]           # 004be512
    mov edx, dword ptr [eax + field_1f4]         # 004be515
    cmp edx, dword ptr [ecx + field_1fc]         # 004be51b
    je.d32 L_004be613                            # 004be521
    # block 0x004be527: entered by fall-through of je at 0x004be521, 3 instruction(s), ends with jge to 0x004be544 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004be527
    cmp dword ptr [eax + field_1f4], 0xb71b00    # 004be52a
    jge.d8 L_004be544                            # 004be534
    # block 0x004be536: entered by fall-through of jge at 0x004be534, 4 instruction(s), ends with forward jump to 0x004be54b
    mov ecx, dword ptr [ebp - local_c]           # 004be536
    mov edx, dword ptr [ecx + field_1f4]         # 004be539
    mov dword ptr [ebp - local_10], edx          # 004be53f
    jmp.d8 L_004be54b                            # 004be542
L_004be544:
    # block 0x004be544: entered by jge at 0x004be534, 1 instruction(s), falls into the block at 0x004be54b
    mov dword ptr [ebp - local_10], 0xb71b00     # 004be544
L_004be54b:
    # block 0x004be54b: entered by jmp at 0x004be542, 6 instruction(s), ends with jle to 0x004be57b (forward)
    mov eax, dword ptr [ebp - local_c]           # 004be54b
    mov ecx, dword ptr [ebp - local_10]          # 004be54e
    mov dword ptr [eax + field_1f4], ecx         # 004be551
    mov edx, dword ptr [ebp - local_c]           # 004be557
    cmp dword ptr [edx + field_1fc], 0x0         # 004be55a
    jle.d8 L_004be57b                            # 004be561
    # block 0x004be563: entered by fall-through of jle at 0x004be561, 7 instruction(s), ends with forward jump to 0x004be582
    mov eax, dword ptr [ebp - local_c]           # 004be563
    mov ecx, dword ptr [ebp - local_c]           # 004be566
    mov eax, dword ptr [eax + field_1fc]         # 004be569
    cdq                                          # 004be56f
    idiv dword ptr [ecx + field_1f8]             # 004be570
    mov dword ptr [ebp - local_4], eax           # 004be576
    jmp.d8 L_004be582                            # 004be579
L_004be57b:
    # block 0x004be57b: entered by jle at 0x004be561, 1 instruction(s), falls into the block at 0x004be582
    mov dword ptr [ebp - local_4], 0x0           # 004be57b
L_004be582:
    # block 0x004be582: entered by jmp at 0x004be579, 3 instruction(s), ends with jle to 0x004be5a6 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004be582
    cmp dword ptr [edx + field_1f4], 0x0         # 004be585
    jle.d8 L_004be5a6                            # 004be58c
    # block 0x004be58e: entered by fall-through of jle at 0x004be58c, 7 instruction(s), ends with forward jump to 0x004be5ad
    mov eax, dword ptr [ebp - local_c]           # 004be58e
    mov ecx, dword ptr [ebp - local_c]           # 004be591
    mov eax, dword ptr [eax + field_1f4]         # 004be594
    cdq                                          # 004be59a
    idiv dword ptr [ecx + field_1f8]             # 004be59b
    mov dword ptr [ebp - local_8], eax           # 004be5a1
    jmp.d8 L_004be5ad                            # 004be5a4
L_004be5a6:
    # block 0x004be5a6: entered by jle at 0x004be58c, 1 instruction(s), falls into the block at 0x004be5ad
    mov dword ptr [ebp - local_8], 0x0           # 004be5a6
L_004be5ad:
    # block 0x004be5ad: entered by jmp at 0x004be5a4, 3 instruction(s), ends with jle to 0x004be5bd (forward)
    mov edx, dword ptr [ebp - local_8]           # 004be5ad
    cmp edx, dword ptr [ebp - local_4]           # 004be5b0
    jle.d8 L_004be5bd                            # 004be5b3
    # block 0x004be5b5: entered by fall-through of jle at 0x004be5b3, 2 instruction(s), calls FUN_004be4c7, falls into the block at 0x004be5bd
    mov ecx, dword ptr [ebp - local_c]           # 004be5b5
    call FUN_004be4c7                            # 004be5b8
L_004be5bd:
    # block 0x004be5bd: entered by jle at 0x004be5b3, 7 instruction(s), calls FUN_0044655e, ends with jne to 0x004be601 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004be5bd
    mov ecx, dword ptr [eax + field_1f4]         # 004be5c0
    push ecx                                     # 004be5c6
    mov ecx, 0x638603                            # 004be5c7
    call FUN_0044655e                            # 004be5cc
    cmp dword ptr [0x63883f], 0x0                # 004be5d1
    jne.d8 L_004be601                            # 004be5d8
    # block 0x004be5da: entered by fall-through of jne at 0x004be5d8, 15 instruction(s), falls into the block at 0x004be601
    mov edi, 0x552188                            # 004be5da
    mov edx, 0x63885f                            # 004be5df
    or ecx, -0x1                                 # 004be5e4
    {load} xor eax, eax                          # 004be5e7
    repne scasb al, byte ptr es:[edi]            # 004be5e9
    not ecx                                      # 004be5eb
    {load} sub edi, ecx                          # 004be5ed
    {load} mov esi, edi                          # 004be5ef
    {load} mov eax, ecx                          # 004be5f1
    {load} mov edi, edx                          # 004be5f3
    shr ecx, 0x2                                 # 004be5f5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004be5f8
    {load} mov ecx, eax                          # 004be5fa
    and ecx, 0x3                                 # 004be5fc
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004be5ff
L_004be601:
    # block 0x004be601: entered by jne at 0x004be5d8, 4 instruction(s), falls into the block at 0x004be613
    mov ecx, dword ptr [ebp - local_c]           # 004be601
    mov edx, dword ptr [ebp - local_c]           # 004be604
    mov eax, dword ptr [edx + field_1f4]         # 004be607
    mov dword ptr [ecx + field_1fc], eax         # 004be60d
L_004be613:
    # block 0x004be613: entered by je at 0x004be521, 5 instruction(s), ends with ret
    pop edi                                      # 004be613
    pop esi                                      # 004be614
    {load} mov esp, ebp                          # 004be615
    pop ebp                                      # 004be617
    ret                                          # 004be618

