# FUN_00515673
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515673
# extent:       0x00515673-0x0051576e (251 code bytes)
# span:         0x00515673-0x0051576e (code 251, tables 0, padding 0)
# sha256:       87d5459bdbb32a56da779f3c22882512e9c14f63ca65456fcfc90dfff2fe9612
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515673
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_144, field_fe8, field_fec, field_ffc, field_minus_4, field_minus_8, field_minus_10, field_minus_1004; [ecx + n] field_4, field_8, field_c, field_10; [edi + n] field_c, field_10, field_7000; [edx + n] field_c; [esi + n] field_43, field_44, field_c4
# callees:      calls KERNEL32.dll!VirtualAlloc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 85 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_1004, 0x1004  # offset -0x1004
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_43, 0x43  # offset +0x43
.equ field_44, 0x44  # offset +0x44
.equ field_c4, 0xc4  # offset +0xc4
.equ field_144, 0x144  # offset +0x144
.equ field_fe8, 0xfe8  # offset +0xfe8
.equ field_fec, 0xfec  # offset +0xfec
.equ field_ffc, 0xffc  # offset +0xffc
.equ field_7000, 0x7000  # offset +0x7000

# --- external targets -----------------------------------------------

.org 0x00515673 - 0x401000
.globl FUN_00515673
FUN_00515673:
    # block 0x00515673: entry, 10 instruction(s), falls into the block at 0x00515685
    push ebp                                     # 00515673
    {load} mov ebp, esp                          # 00515674
    push ecx                                     # 00515676
    mov ecx, dword ptr [ebp + arg_8]             # 00515677
    push ebx                                     # 0051567a
    push esi                                     # 0051567b
    push edi                                     # 0051567c
    mov esi, dword ptr [ecx + field_10]          # 0051567d
    mov eax, dword ptr [ecx + field_8]           # 00515680
    {load} xor ebx, ebx                          # 00515683
L_00515685:
    # block 0x00515685: entered by jmp at 0x0051568c, 2 instruction(s), ends with jl to 0x0051568e (forward)
    test eax, eax                                # 00515685
    jl.d8 L_0051568e                             # 00515687
    # block 0x00515689: entered by fall-through of jl at 0x00515687, 3 instruction(s), ends with backward jump to 0x00515685
    shl eax                                      # 00515689
    inc ebx                                      # 0051568b
    jmp.d8 L_00515685                            # 0051568c
L_0051568e:
    # block 0x0051568e: entered by jl at 0x00515687, 6 instruction(s), falls into the block at 0x005156a3
    {load} mov eax, ebx                          # 0051568e
    push 0x3f                                    # 00515690
    imul eax, eax, 0x204                         # 00515692
    pop edx                                      # 00515698
    lea eax, [eax + esi + field_144]             # 00515699
    mov dword ptr [ebp - local_4], eax           # 005156a0
L_005156a3:
    # block 0x005156a3: entered by jne at 0x005156ad, 5 instruction(s), ends with jne to 0x005156a3 (backward)
    mov dword ptr [eax + field_8], eax           # 005156a3
    mov dword ptr [eax + field_4], eax           # 005156a6
    add eax, 0x8                                 # 005156a9
    dec edx                                      # 005156ac
    jne.d8 L_005156a3                            # 005156ad
    # block 0x005156af: entered by fall-through of jne at 0x005156ad, 10 instruction(s), calls KERNEL32.dll!VirtualAlloc, ends with jne to 0x005156d6 (forward)
    {load} mov edi, ebx                          # 005156af
    push 0x4                                     # 005156b1
    shl edi, 0xf                                 # 005156b3
    add edi, dword ptr [ecx + field_c]           # 005156b6
    push 0x1000                                  # 005156b9
    push 0x8000                                  # 005156be
    push edi                                     # 005156c3
    call dword ptr [0x52a1a0]                    # 005156c4
    test eax, eax                                # 005156ca
    jne.d8 L_005156d6                            # 005156cc
    # block 0x005156ce: entered by fall-through of jne at 0x005156cc, 2 instruction(s), ends with forward jump to 0x00515769
    or eax, -0x1                                 # 005156ce
    jmp.d32 L_00515769                           # 005156d1
L_005156d6:
    # block 0x005156d6: entered by jne at 0x005156cc, 3 instruction(s), ends with ja to 0x0051571c (forward)
    lea edx, [edi + field_7000]                  # 005156d6
    {load} cmp edi, edx                          # 005156dc
    ja.d8 L_0051571c                             # 005156de
    # block 0x005156e0: entered by fall-through of ja at 0x005156de, 1 instruction(s), falls into the block at 0x005156e3
    lea eax, [edi + field_10]                    # 005156e0
L_005156e3:
    # block 0x005156e3: entered by jbe at 0x0051571a, 12 instruction(s), ends with jbe to 0x005156e3 (backward)
    or dword ptr [eax - field_minus_8], -0x1     # 005156e3
    or dword ptr [eax + field_fec], -0x1         # 005156e7
    lea ecx, [eax + field_ffc]                   # 005156ee
    mov dword ptr [eax - field_minus_4], 0xff0   # 005156f4
    mov dword ptr [eax], ecx                     # 005156fb
    lea ecx, [eax - field_minus_1004]            # 005156fd
    mov dword ptr [eax + field_4], ecx           # 00515703
    mov dword ptr [eax + field_fe8], 0xff0       # 00515706
    add eax, 0x1000                              # 00515710
    lea ecx, [eax - field_minus_10]              # 00515715
    {load} cmp ecx, edx                          # 00515718
    jbe.d8 L_005156e3                            # 0051571a
L_0051571c:
    # block 0x0051571c: entered by ja at 0x005156de; fall-through of jbe at 0x0051571a, 19 instruction(s), ends with jne to 0x00515759 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0051571c
    lea ecx, [edi + field_c]                     # 0051571f
    add eax, 0x1f8                               # 00515722
    push 0x1                                     # 00515727
    pop edi                                      # 00515729
    mov dword ptr [eax + field_4], ecx           # 0051572a
    mov dword ptr [ecx + field_8], eax           # 0051572d
    lea ecx, [edx + field_c]                     # 00515730
    mov dword ptr [eax + field_8], ecx           # 00515733
    mov dword ptr [ecx + field_4], eax           # 00515736
    and dword ptr [esi + 4*ebx + field_44], 0x0  # 00515739
    mov dword ptr [esi + 4*ebx + field_c4], edi  # 0051573e
    mov al, byte ptr [esi + field_43]            # 00515745
    {load} mov cl, al                            # 00515748
    inc cl                                       # 0051574a
    test al, al                                  # 0051574c
    mov eax, dword ptr [ebp + arg_8]             # 0051574e
    mov byte ptr [esi + field_43], cl            # 00515751
    jne.d8 L_00515759                            # 00515754
    # block 0x00515756: entered by fall-through of jne at 0x00515754, 1 instruction(s), falls into the block at 0x00515759
    or dword ptr [eax + field_4], edi            # 00515756
L_00515759:
    # block 0x00515759: entered by jne at 0x00515754, 6 instruction(s), falls into the block at 0x00515769
    mov edx, 0x80000000                          # 00515759
    {load} mov ecx, ebx                          # 0051575e
    shr edx, cl                                  # 00515760
    not edx                                      # 00515762
    and dword ptr [eax + field_8], edx           # 00515764
    {load} mov eax, ebx                          # 00515767
L_00515769:
    # block 0x00515769: entered by jmp at 0x005156d1, 5 instruction(s), ends with ret
    pop edi                                      # 00515769
    pop esi                                      # 0051576a
    pop ebx                                      # 0051576b
    leave                                        # 0051576c
    ret                                          # 0051576d

