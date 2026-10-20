# FUN_00484f42
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00484f42
# extent:       0x00484f42-0x004853b0 (1134 code bytes)
# span:         0x00484f42-0x004853b0 (code 1134, tables 0, padding 0)
# sha256:       3ff2ddbbdc87a871d5cdce79ebaa3e75c65b35d79062294f7ba36c9f9252da5d
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m484f42_pointer_move
# naming:       native port src/original_methods_fl21a.c:m484f42_pointer_move (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m484f42_pointer_move. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on 300 random fixtures, every instruction reached. Oracle window runs all 1134 bytes.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_2, field_4, field_8, field_c, field_e, field_24, field_26, field_28, field_2b, field_9f, field_a3, field_a7 and 13 more; [ecx + n] field_6, field_a, field_21, field_23, field_26, field_28, field_2b, field_5b7, field_5bb, field_5bf, field_5f8, field_a9e and 5 more; [edx + n] field_2, field_6, field_22, field_25, field_28, field_2a, field_5b7, field_604, field_a92, field_bb1, field_bb5, field_bb9 and 6 more
# callees:      calls FUN_00484d87, FUN_004854fb
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.h:ea_pointer_move (function ledger class native_oracle_verified; also ea_step; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 301 instruction(s), 37 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ arg_10, 0x10  # offset +0x10
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2b, 0x2b  # offset +0x2b
.equ field_9f, 0x9f  # offset +0x9f
.equ field_a3, 0xa3  # offset +0xa3
.equ field_a7, 0xa7  # offset +0xa7
.equ field_ab, 0xab  # offset +0xab
.equ field_5b7, 0x5b7  # offset +0x5b7
.equ field_5bb, 0x5bb  # offset +0x5bb
.equ field_5bf, 0x5bf  # offset +0x5bf
.equ field_5c3, 0x5c3  # offset +0x5c3
.equ field_5f8, 0x5f8  # offset +0x5f8
.equ field_5fc, 0x5fc  # offset +0x5fc
.equ field_600, 0x600  # offset +0x600
.equ field_604, 0x604  # offset +0x604
.equ field_a92, 0xa92  # offset +0xa92
.equ field_a9e, 0xa9e  # offset +0xa9e
.equ field_aa0, 0xaa0  # offset +0xaa0
.equ field_aa4, 0xaa4  # offset +0xaa4
.equ field_aa8, 0xaa8  # offset +0xaa8
.equ field_aac, 0xaac  # offset +0xaac
.equ field_ba7, 0xba7  # offset +0xba7
.equ field_bb1, 0xbb1  # offset +0xbb1
.equ field_bb5, 0xbb5  # offset +0xbb5
.equ field_bb9, 0xbb9  # offset +0xbb9
.equ field_bbd, 0xbbd  # offset +0xbbd
.equ field_bd1, 0xbd1  # offset +0xbd1
.equ field_bf9, 0xbf9  # offset +0xbf9
.equ field_bfb, 0xbfb  # offset +0xbfb
.equ field_c23, 0xc23  # offset +0xc23
.equ field_c27, 0xc27  # offset +0xc27
.equ field_ef7, 0xef7  # offset +0xef7
.equ field_efb, 0xefb  # offset +0xefb
.equ field_eff, 0xeff  # offset +0xeff
.equ field_f03, 0xf03  # offset +0xf03

# --- external targets -----------------------------------------------
.set FUN_00484d87, .text + (0x00484d87 - 0x401000)
.set FUN_004854fb, .text + (0x004854fb - 0x401000)

.org 0x00484f42 - 0x401000
.globl FUN_00484f42
FUN_00484f42:
    # block 0x00484f42: entry, 14 instruction(s), ends with je to 0x004853a7 (forward)
    push ebp                                     # 00484f42
    {load} mov ebp, esp                          # 00484f43
    sub esp, 0x14                                # 00484f45
    push edi                                     # 00484f48
    mov dword ptr [ebp - local_14], ecx          # 00484f49
    mov dword ptr [ebp - local_4], 0x1           # 00484f4c
    mov eax, dword ptr [ebp - local_14]          # 00484f53
    movsx ecx, word ptr [eax + field_26]         # 00484f56
    imul ecx, ecx, 0x8d                          # 00484f5a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00484f60
    mov dword ptr [ebp - local_c], edx           # 00484f66
    mov eax, dword ptr [ebp - local_14]          # 00484f69
    cmp dword ptr [eax + field_ba7], 0x0         # 00484f6c
    je.d32 L_004853a7                            # 00484f73
    # block 0x00484f79: entered by fall-through of je at 0x00484f73, 25 instruction(s), ends with je to 0x0048514b (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00484f79
    movsx edx, word ptr [ecx + field_a9e]        # 00484f7c
    imul edx, edx, 0x85                          # 00484f83
    mov eax, dword ptr [ebp - local_14]          # 00484f89
    lea ecx, [eax + edx + field_28]              # 00484f8c
    mov dword ptr [ebp - local_10], ecx          # 00484f90
    mov edx, dword ptr [ebp - local_14]          # 00484f93
    mov eax, dword ptr [ebp + arg_10]            # 00484f96
    mov ecx, dword ptr [eax + field_4]           # 00484f99
    mov dword ptr [edx + field_bb5], ecx         # 00484f9c
    mov edx, dword ptr [ebp - local_14]          # 00484fa2
    mov eax, dword ptr [ebp + arg_10]            # 00484fa5
    mov ecx, dword ptr [eax + field_c]           # 00484fa8
    mov dword ptr [edx + field_bbd], ecx         # 00484fab
    mov edx, dword ptr [ebp - local_14]          # 00484fb1
    mov eax, dword ptr [ebp + arg_10]            # 00484fb4
    mov ecx, dword ptr [eax]                     # 00484fb7
    mov dword ptr [edx + field_bb1], ecx         # 00484fb9
    mov edx, dword ptr [ebp - local_14]          # 00484fbf
    mov eax, dword ptr [ebp + arg_10]            # 00484fc2
    mov ecx, dword ptr [eax + field_8]           # 00484fc5
    mov dword ptr [edx + field_bb9], ecx         # 00484fc8
    mov edx, dword ptr [ebp - local_14]          # 00484fce
    cmp dword ptr [edx + field_a92], 0x0         # 00484fd1
    je.d32 L_0048514b                            # 00484fd8
    # block 0x00484fde: entered by fall-through of je at 0x00484fd8, 8 instruction(s), calls FUN_00484d87, ends with je to 0x0048503f (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00484fde
    call FUN_00484d87                            # 00484fe1
    mov eax, dword ptr [ebp - local_c]           # 00484fe6
    mov ecx, dword ptr [ebp - local_c]           # 00484fe9
    mov edx, dword ptr [eax + field_5bf]         # 00484fec
    sub edx, dword ptr [ecx + field_5b7]         # 00484ff2
    test edx, edx                                # 00484ff8
    je.d8 L_0048503f                             # 00484ffa
    # block 0x00484ffc: entered by fall-through of je at 0x00484ffa, 4 instruction(s), ends with jl to 0x00485038 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00484ffc
    mov ecx, dword ptr [ebp - local_c]           # 00485000
    cmp eax, dword ptr [ecx + field_5bb]         # 00485003
    jl.d8 L_00485038                             # 00485009
    # block 0x0048500b: entered by fall-through of jl at 0x00485009, 4 instruction(s), ends with jg to 0x00485038 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0048500b
    mov eax, dword ptr [ebp - local_c]           # 0048500f
    cmp edx, dword ptr [eax + field_5c3]         # 00485012
    jg.d8 L_00485038                             # 00485018
    # block 0x0048501a: entered by fall-through of jg at 0x00485018, 4 instruction(s), ends with jl to 0x00485038 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048501a
    mov edx, dword ptr [ebp - local_c]           # 0048501e
    cmp ecx, dword ptr [edx + field_5b7]         # 00485021
    jl.d8 L_00485038                             # 00485027
    # block 0x00485029: entered by fall-through of jl at 0x00485027, 4 instruction(s), ends with jle to 0x0048503f (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00485029
    mov ecx, dword ptr [ebp - local_c]           # 0048502d
    cmp eax, dword ptr [ecx + field_5bf]         # 00485030
    jle.d8 L_0048503f                            # 00485036
L_00485038:
    # block 0x00485038: entered by jl at 0x00485009; jg at 0x00485018; jl at 0x00485027; fall-through of jle at 0x00485036, 1 instruction(s), falls into the block at 0x0048503f
    mov dword ptr [ebp - local_4], 0x0           # 00485038
L_0048503f:
    # block 0x0048503f: entered by je at 0x00484ffa; jle at 0x00485036, 2 instruction(s), ends with je to 0x00485144 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0048503f
    je.d32 L_00485144                            # 00485043
    # block 0x00485049: entered by fall-through of je at 0x00485043, 5 instruction(s), ends with jne to 0x0048505e (forward)
    mov edx, dword ptr [ebp - local_c]           # 00485049
    {load} xor eax, eax                          # 0048504c
    mov al, byte ptr [edx + field_2a]            # 0048504e
    test eax, eax                                # 00485051
    jne.d8 L_0048505e                            # 00485053
    # block 0x00485055: entered by fall-through of jne at 0x00485053, 2 instruction(s), falls into the block at 0x0048505e
    mov ecx, dword ptr [ebp - local_c]           # 00485055
    mov word ptr [ecx + field_2b], 0x0           # 00485058
L_0048505e:
    # block 0x0048505e: entered by jne at 0x00485053, 5 instruction(s), ends with jne to 0x0048512d (forward)
    mov edx, dword ptr [ebp - local_10]          # 0048505e
    {load} xor eax, eax                          # 00485061
    mov al, byte ptr [edx + field_22]            # 00485063
    test eax, eax                                # 00485066
    jne.d32 L_0048512d                           # 00485068
    # block 0x0048506e: entered by fall-through of jne at 0x00485068, 11 instruction(s), ends with jl to 0x0048512d (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0048506e
    movsx edx, word ptr [ecx + field_a9e]        # 00485071
    imul edx, edx, 0x42                          # 00485078
    mov eax, dword ptr [ebp - local_c]           # 0048507b
    movsx ecx, word ptr [eax + field_2b]         # 0048507e
    mov eax, dword ptr [ebp - local_c]           # 00485082
    mov edx, dword ptr [eax + edx + field_a3]    # 00485085
    {load} sub edx, ecx                          # 0048508c
    mov eax, dword ptr [ebp - local_14]          # 0048508e
    cmp dword ptr [eax + field_aa4], edx         # 00485091
    jl.d32 L_0048512d                            # 00485097
    # block 0x0048509d: entered by fall-through of jl at 0x00485097, 11 instruction(s), ends with jg to 0x0048512d (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0048509d
    movsx edx, word ptr [ecx + field_a9e]        # 004850a0
    imul edx, edx, 0x42                          # 004850a7
    mov eax, dword ptr [ebp - local_c]           # 004850aa
    movsx ecx, word ptr [eax + field_2b]         # 004850ad
    mov eax, dword ptr [ebp - local_c]           # 004850b1
    mov edx, dword ptr [eax + edx + field_ab]    # 004850b4
    {load} add edx, ecx                          # 004850bb
    mov eax, dword ptr [ebp - local_14]          # 004850bd
    cmp dword ptr [eax + field_aac], edx         # 004850c0
    jg.d8 L_0048512d                             # 004850c6
    # block 0x004850c8: entered by fall-through of jg at 0x004850c6, 11 instruction(s), ends with jl to 0x0048512d (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004850c8
    movsx edx, word ptr [ecx + field_a9e]        # 004850cb
    imul edx, edx, 0x42                          # 004850d2
    mov eax, dword ptr [ebp - local_c]           # 004850d5
    movsx ecx, word ptr [eax + field_2b]         # 004850d8
    mov eax, dword ptr [ebp - local_c]           # 004850dc
    mov edx, dword ptr [eax + edx + field_9f]    # 004850df
    {load} sub edx, ecx                          # 004850e6
    mov eax, dword ptr [ebp - local_14]          # 004850e8
    cmp dword ptr [eax + field_aa0], edx         # 004850eb
    jl.d8 L_0048512d                             # 004850f1
    # block 0x004850f3: entered by fall-through of jl at 0x004850f1, 11 instruction(s), ends with jg to 0x0048512d (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004850f3
    movsx edx, word ptr [ecx + field_a9e]        # 004850f6
    imul edx, edx, 0x42                          # 004850fd
    mov eax, dword ptr [ebp - local_c]           # 00485100
    movsx ecx, word ptr [eax + field_2b]         # 00485103
    mov eax, dword ptr [ebp - local_c]           # 00485107
    mov edx, dword ptr [eax + edx + field_a7]    # 0048510a
    {load} add edx, ecx                          # 00485111
    mov eax, dword ptr [ebp - local_14]          # 00485113
    cmp dword ptr [eax + field_aa8], edx         # 00485116
    jg.d8 L_0048512d                             # 0048511c
    # block 0x0048511e: entered by fall-through of jg at 0x0048511c, 4 instruction(s), calls FUN_004854fb, ends with forward jump to 0x0048513a
    push 0x277b                                  # 0048511e
    mov ecx, dword ptr [ebp - local_14]          # 00485123
    call FUN_004854fb                            # 00485126
    jmp.d8 L_0048513a                            # 0048512b
L_0048512d:
    # block 0x0048512d: entered by jne at 0x00485068; jl at 0x00485097; jg at 0x004850c6; jl at 0x004850f1; jg at 0x0048511c, 3 instruction(s), calls FUN_004854fb, falls into the block at 0x0048513a
    push 0x277a                                  # 0048512d
    mov ecx, dword ptr [ebp - local_14]          # 00485132
    call FUN_004854fb                            # 00485135
L_0048513a:
    # block 0x0048513a: entered by jmp at 0x0048512b, 2 instruction(s), ends with forward jump to 0x004853a9
    mov eax, 0x1                                 # 0048513a
    jmp.d32 L_004853a9                           # 0048513f
L_00485144:
    # block 0x00485144: entered by je at 0x00485043, 2 instruction(s), ends with forward jump to 0x004853a9
    {load} xor eax, eax                          # 00485144
    jmp.d32 L_004853a9                           # 00485146
L_0048514b:
    # block 0x0048514b: entered by je at 0x00484fd8, 11 instruction(s), ends with forward jump to 0x00485187
    mov ecx, 0xa                                 # 0048514b
    {load} xor eax, eax                          # 00485150
    mov edi, dword ptr [ebp - local_14]          # 00485152
    add edi, 0xbd1                               # 00485155
    rep stosd dword ptr es:[edi], eax            # 0048515b
    mov ecx, dword ptr [ebp - local_14]          # 0048515d
    mov word ptr [ecx + field_bf9], 0x0          # 00485160
    mov edx, dword ptr [ebp - local_14]          # 00485169
    mov word ptr [edx + field_c23], 0x0          # 0048516c
    mov dword ptr [ebp - local_8], 0x0           # 00485175
    jmp.d8 L_00485187                            # 0048517c
L_0048517e:
    # block 0x0048517e: entered by jmp at 0x004852ac, 3 instruction(s), falls into the block at 0x00485187
    mov eax, dword ptr [ebp - local_8]           # 0048517e
    add eax, 0x1                                 # 00485181
    mov dword ptr [ebp - local_8], eax           # 00485184
L_00485187:
    # block 0x00485187: entered by jmp at 0x0048517c, 4 instruction(s), ends with jge to 0x004852b1 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00485187
    movsx edx, word ptr [ecx + field_21]         # 0048518a
    cmp dword ptr [ebp - local_8], edx           # 0048518e
    jge.d32 L_004852b1                           # 00485191
    # block 0x00485197: entered by fall-through of jge at 0x00485191, 10 instruction(s), ends with je to 0x0048523f (forward)
    mov eax, dword ptr [ebp - local_8]           # 00485197
    imul eax, eax, 0x85                          # 0048519a
    mov ecx, dword ptr [ebp - local_14]          # 004851a0
    lea edx, [ecx + eax + field_28]              # 004851a3
    mov dword ptr [ebp - local_10], edx          # 004851a7
    mov eax, dword ptr [ebp - local_c]           # 004851aa
    {load} xor ecx, ecx                          # 004851ad
    mov cl, byte ptr [eax + field_24]            # 004851af
    test ecx, ecx                                # 004851b2
    je.d32 L_0048523f                            # 004851b4
    # block 0x004851ba: entered by fall-through of je at 0x004851b4, 5 instruction(s), ends with je to 0x0048523f (forward)
    mov edx, dword ptr [ebp - local_c]           # 004851ba
    {load} xor eax, eax                          # 004851bd
    mov al, byte ptr [edx + field_25]            # 004851bf
    test eax, eax                                # 004851c2
    je.d8 L_0048523f                             # 004851c4
    # block 0x004851c6: entered by fall-through of je at 0x004851c4, 4 instruction(s), ends with jl to 0x0048523f (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004851c6
    mov edx, dword ptr [ebp - local_10]          # 004851ca
    cmp ecx, dword ptr [edx + field_6]           # 004851cd
    jl.d8 L_0048523f                             # 004851d0
    # block 0x004851d2: entered by fall-through of jl at 0x004851d0, 8 instruction(s), ends with jg to 0x0048523f (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004851d2
    mov ecx, dword ptr [ebp - local_c]           # 004851d6
    movsx edx, word ptr [ecx + field_26]         # 004851d9
    mov ecx, dword ptr [ebp - local_10]          # 004851dd
    mov ecx, dword ptr [ecx + field_6]           # 004851e0
    {load} add ecx, edx                          # 004851e3
    {load} cmp eax, ecx                          # 004851e5
    jg.d8 L_0048523f                             # 004851e7
    # block 0x004851e9: entered by fall-through of jg at 0x004851e7, 4 instruction(s), ends with jl to 0x0048523f (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004851e9
    mov eax, dword ptr [ebp - local_10]          # 004851ed
    cmp edx, dword ptr [eax + field_2]           # 004851f0
    jl.d8 L_0048523f                             # 004851f3
    # block 0x004851f5: entered by fall-through of jl at 0x004851f3, 8 instruction(s), ends with jg to 0x0048523f (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004851f5
    mov edx, dword ptr [ebp - local_c]           # 004851f9
    movsx eax, word ptr [edx + field_28]         # 004851fc
    mov edx, dword ptr [ebp - local_10]          # 00485200
    mov edx, dword ptr [edx + field_2]           # 00485203
    {load} add edx, eax                          # 00485206
    {load} cmp ecx, edx                          # 00485208
    jg.d8 L_0048523f                             # 0048520a
    # block 0x0048520c: entered by fall-through of jg at 0x0048520a, 11 instruction(s), ends with forward jump to 0x004852ac
    mov eax, dword ptr [ebp - local_14]          # 0048520c
    movsx ecx, word ptr [eax + field_c23]        # 0048520f
    mov edx, dword ptr [ebp - local_14]          # 00485216
    mov ax, word ptr [ebp - local_8]             # 00485219
    mov word ptr [edx + 2*ecx + field_bfb], ax   # 0048521d
    mov ecx, dword ptr [ebp - local_14]          # 00485225
    mov dx, word ptr [ecx + field_c23]           # 00485228
    add dx, 0x1                                  # 0048522f
    mov eax, dword ptr [ebp - local_14]          # 00485233
    mov word ptr [eax + field_c23], dx           # 00485236
    jmp.d8 L_004852ac                            # 0048523d
L_0048523f:
    # block 0x0048523f: entered by je at 0x004851b4; je at 0x004851c4; jl at 0x004851d0; jg at 0x004851e7; more, 5 instruction(s), ends with jne to 0x004852ac (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0048523f
    {load} xor edx, edx                          # 00485242
    mov dl, byte ptr [ecx + field_23]            # 00485244
    test edx, edx                                # 00485247
    jne.d8 L_004852ac                            # 00485249
    # block 0x0048524b: entered by fall-through of jne at 0x00485249, 4 instruction(s), ends with jl to 0x004852ac (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0048524b
    mov ecx, dword ptr [ebp - local_10]          # 0048524f
    cmp eax, dword ptr [ecx + field_6]           # 00485252
    jl.d8 L_004852ac                             # 00485255
    # block 0x00485257: entered by fall-through of jl at 0x00485255, 4 instruction(s), ends with jg to 0x004852ac (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00485257
    mov eax, dword ptr [ebp - local_10]          # 0048525b
    cmp edx, dword ptr [eax + field_e]           # 0048525e
    jg.d8 L_004852ac                             # 00485261
    # block 0x00485263: entered by fall-through of jg at 0x00485261, 4 instruction(s), ends with jl to 0x004852ac (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00485263
    mov edx, dword ptr [ebp - local_10]          # 00485267
    cmp ecx, dword ptr [edx + field_2]           # 0048526a
    jl.d8 L_004852ac                             # 0048526d
    # block 0x0048526f: entered by fall-through of jl at 0x0048526d, 4 instruction(s), ends with jg to 0x004852ac (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0048526f
    mov ecx, dword ptr [ebp - local_10]          # 00485273
    cmp eax, dword ptr [ecx + field_a]           # 00485276
    jg.d8 L_004852ac                             # 00485279
    # block 0x0048527b: entered by fall-through of jg at 0x00485279, 10 instruction(s), falls into the block at 0x004852ac
    mov edx, dword ptr [ebp - local_14]          # 0048527b
    movsx eax, word ptr [edx + field_bf9]        # 0048527e
    mov ecx, dword ptr [ebp - local_14]          # 00485285
    mov dx, word ptr [ebp - local_8]             # 00485288
    mov word ptr [ecx + 2*eax + field_bd1], dx   # 0048528c
    mov eax, dword ptr [ebp - local_14]          # 00485294
    mov cx, word ptr [eax + field_bf9]           # 00485297
    add cx, 0x1                                  # 0048529e
    mov edx, dword ptr [ebp - local_14]          # 004852a2
    mov word ptr [edx + field_bf9], cx           # 004852a5
L_004852ac:
    # block 0x004852ac: entered by jmp at 0x0048523d; jne at 0x00485249; jl at 0x00485255; jg at 0x00485261; more, 1 instruction(s), ends with backward jump to 0x0048517e
    jmp.d32 L_0048517e                           # 004852ac
L_004852b1:
    # block 0x004852b1: entered by jge at 0x00485191, 4 instruction(s), ends with je to 0x004852d6 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004852b1
    movsx ecx, word ptr [eax + field_c23]        # 004852b4
    test ecx, ecx                                # 004852bb
    je.d8 L_004852d6                             # 004852bd
    # block 0x004852bf: entered by fall-through of je at 0x004852bd, 5 instruction(s), calls FUN_004854fb, ends with forward jump to 0x004853a9
    push 0x2778                                  # 004852bf
    mov ecx, dword ptr [ebp - local_14]          # 004852c4
    call FUN_004854fb                            # 004852c7
    mov eax, 0x1                                 # 004852cc
    jmp.d32 L_004853a9                           # 004852d1
L_004852d6:
    # block 0x004852d6: entered by je at 0x004852bd, 4 instruction(s), ends with je to 0x004852fb (forward)
    mov edx, dword ptr [ebp - local_14]          # 004852d6
    movsx eax, word ptr [edx + field_bf9]        # 004852d9
    test eax, eax                                # 004852e0
    je.d8 L_004852fb                             # 004852e2
    # block 0x004852e4: entered by fall-through of je at 0x004852e2, 5 instruction(s), calls FUN_004854fb, ends with forward jump to 0x004853a9
    push 0x2777                                  # 004852e4
    mov ecx, dword ptr [ebp - local_14]          # 004852e9
    call FUN_004854fb                            # 004852ec
    mov eax, 0x1                                 # 004852f1
    jmp.d32 L_004853a9                           # 004852f6
L_004852fb:
    # block 0x004852fb: entered by je at 0x004852e2, 3 instruction(s), ends with je to 0x00485357 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004852fb
    cmp dword ptr [ecx + field_c27], 0x0         # 004852fe
    je.d8 L_00485357                             # 00485305
    # block 0x00485307: entered by fall-through of je at 0x00485305, 4 instruction(s), ends with jl to 0x00485357 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00485307
    mov eax, dword ptr [ebp - local_c]           # 0048530b
    cmp edx, dword ptr [eax + field_5fc]         # 0048530e
    jl.d8 L_00485357                             # 00485314
    # block 0x00485316: entered by fall-through of jl at 0x00485314, 4 instruction(s), ends with jg to 0x00485357 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00485316
    mov edx, dword ptr [ebp - local_c]           # 0048531a
    cmp ecx, dword ptr [edx + field_604]         # 0048531d
    jg.d8 L_00485357                             # 00485323
    # block 0x00485325: entered by fall-through of jg at 0x00485323, 4 instruction(s), ends with jl to 0x00485357 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00485325
    mov ecx, dword ptr [ebp - local_c]           # 00485329
    cmp eax, dword ptr [ecx + field_5f8]         # 0048532c
    jl.d8 L_00485357                             # 00485332
    # block 0x00485334: entered by fall-through of jl at 0x00485332, 4 instruction(s), ends with jge to 0x00485357 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00485334
    mov eax, dword ptr [ebp - local_c]           # 00485338
    cmp edx, dword ptr [eax + field_600]         # 0048533b
    jge.d8 L_00485357                            # 00485341
    # block 0x00485343: entered by fall-through of jge at 0x00485341, 5 instruction(s), calls FUN_004854fb, ends with forward jump to 0x004853a9
    push 0x277c                                  # 00485343
    mov ecx, dword ptr [ebp - local_14]          # 00485348
    call FUN_004854fb                            # 0048534b
    mov eax, 0x1                                 # 00485350
    jmp.d8 L_004853a9                            # 00485355
L_00485357:
    # block 0x00485357: entered by je at 0x00485305; jl at 0x00485314; jg at 0x00485323; jl at 0x00485332; jge at 0x00485341, 4 instruction(s), ends with jl to 0x004853a7 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00485357
    mov edx, dword ptr [ebp - local_c]           # 0048535b
    cmp ecx, dword ptr [edx + field_efb]         # 0048535e
    jl.d8 L_004853a7                             # 00485364
    # block 0x00485366: entered by fall-through of jl at 0x00485364, 4 instruction(s), ends with jg to 0x004853a7 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00485366
    mov ecx, dword ptr [ebp - local_c]           # 0048536a
    cmp eax, dword ptr [ecx + field_f03]         # 0048536d
    jg.d8 L_004853a7                             # 00485373
    # block 0x00485375: entered by fall-through of jg at 0x00485373, 4 instruction(s), ends with jl to 0x004853a7 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00485375
    mov eax, dword ptr [ebp - local_c]           # 00485379
    cmp edx, dword ptr [eax + field_ef7]         # 0048537c
    jl.d8 L_004853a7                             # 00485382
    # block 0x00485384: entered by fall-through of jl at 0x00485382, 4 instruction(s), ends with jg to 0x004853a7 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00485384
    mov edx, dword ptr [ebp - local_c]           # 00485388
    cmp ecx, dword ptr [edx + field_eff]         # 0048538b
    jg.d8 L_004853a7                             # 00485391
    # block 0x00485393: entered by fall-through of jg at 0x00485391, 5 instruction(s), calls FUN_004854fb, ends with forward jump to 0x004853a9
    push 0x2779                                  # 00485393
    mov ecx, dword ptr [ebp - local_14]          # 00485398
    call FUN_004854fb                            # 0048539b
    mov eax, 0x1                                 # 004853a0
    jmp.d8 L_004853a9                            # 004853a5
L_004853a7:
    # block 0x004853a7: entered by je at 0x00484f73; jl at 0x00485364; jg at 0x00485373; jl at 0x00485382; jg at 0x00485391, 1 instruction(s), falls into the block at 0x004853a9
    {load} xor eax, eax                          # 004853a7
L_004853a9:
    # block 0x004853a9: entered by jmp at 0x0048513f; jmp at 0x00485146; jmp at 0x004852d1; jmp at 0x004852f6; more, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 004853a9
    {load} mov esp, ebp                          # 004853aa
    pop ebp                                      # 004853ac
    ret 0xc                                      # 004853ad

