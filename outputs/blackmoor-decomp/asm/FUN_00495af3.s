# FUN_00495af3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00495af3
# extent:       0x00495af3-0x00496410 (2333 code bytes)
# span:         0x00495af3-0x00496410 (code 2333, tables 0, padding 0)
# sha256:       a46e8cb5feb59d488cb9f89029c79084962bb14255034e656a7e56cefeec0c56
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00495af3
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_2, field_4, field_1c, field_80, field_1ef3, field_1ef7, field_1eff, field_1f27, field_1f6b, field_200b, field_201f, field_2095 and 5 more; [ecx + n] field_1c, field_1e, field_6c, field_7c, field_7e, field_80, field_82, field_84, field_88, field_8c, field_90, field_92 and 15 more; [edx + n] field_2, field_1c, field_1e, field_26, field_49, field_b6, field_1efb, field_1f03, field_1f27, field_1f2b, field_1f2f, field_1f77 and 8 more
# callees:      calls FUN_0043dbd5, FUN_004d39f9, FUN_004911ca, FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4, FUN_0049c889, FUN_0050ce04, FUN_00491db2, FUN_00491972, FUN_0049251f, FUN_00493c34, FUN_004921a1, FUN_004915e8, FUN_004dae66 and 11 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 574 instruction(s), 24 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_26, 0x26  # offset +0x26
.equ field_49, 0x49  # offset +0x49
.equ field_6c, 0x6c  # offset +0x6c
.equ field_7c, 0x7c  # offset +0x7c
.equ field_7e, 0x7e  # offset +0x7e
.equ field_80, 0x80  # offset +0x80
.equ field_82, 0x82  # offset +0x82
.equ field_84, 0x84  # offset +0x84
.equ field_88, 0x88  # offset +0x88
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_92, 0x92  # offset +0x92
.equ field_94, 0x94  # offset +0x94
.equ field_b6, 0xb6  # offset +0xb6
.equ field_1ef3, 0x1ef3  # offset +0x1ef3
.equ field_1ef7, 0x1ef7  # offset +0x1ef7
.equ field_1efb, 0x1efb  # offset +0x1efb
.equ field_1eff, 0x1eff  # offset +0x1eff
.equ field_1f03, 0x1f03  # offset +0x1f03
.equ field_1f27, 0x1f27  # offset +0x1f27
.equ field_1f2b, 0x1f2b  # offset +0x1f2b
.equ field_1f2f, 0x1f2f  # offset +0x1f2f
.equ field_1f33, 0x1f33  # offset +0x1f33
.equ field_1f37, 0x1f37  # offset +0x1f37
.equ field_1f3b, 0x1f3b  # offset +0x1f3b
.equ field_1f6b, 0x1f6b  # offset +0x1f6b
.equ field_1f77, 0x1f77  # offset +0x1f77
.equ field_2003, 0x2003  # offset +0x2003
.equ field_2007, 0x2007  # offset +0x2007
.equ field_200b, 0x200b  # offset +0x200b
.equ field_201f, 0x201f  # offset +0x201f
.equ field_2095, 0x2095  # offset +0x2095
.equ field_2099, 0x2099  # offset +0x2099
.equ field_20c1, 0x20c1  # offset +0x20c1
.equ field_20c5, 0x20c5  # offset +0x20c5
.equ field_20c9, 0x20c9  # offset +0x20c9
.equ field_45ad, 0x45ad  # offset +0x45ad
.equ field_45b1, 0x45b1  # offset +0x45b1
.equ field_45b5, 0x45b5  # offset +0x45b5
.equ field_4791, 0x4791  # offset +0x4791
.equ field_47a9, 0x47a9  # offset +0x47a9
.equ field_47ad, 0x47ad  # offset +0x47ad
.equ field_47b1, 0x47b1  # offset +0x47b1
.equ field_47b5, 0x47b5  # offset +0x47b5
.equ field_47b9, 0x47b9  # offset +0x47b9
.equ field_47cd, 0x47cd  # offset +0x47cd

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004911ca, .text + (0x004911ca - 0x401000)
.set FUN_004915e8, .text + (0x004915e8 - 0x401000)
.set FUN_00491972, .text + (0x00491972 - 0x401000)
.set FUN_00491db2, .text + (0x00491db2 - 0x401000)
.set FUN_004921a1, .text + (0x004921a1 - 0x401000)
.set FUN_0049251f, .text + (0x0049251f - 0x401000)
.set FUN_00493c34, .text + (0x00493c34 - 0x401000)
.set FUN_00494d54, .text + (0x00494d54 - 0x401000)
.set FUN_00494f1f, .text + (0x00494f1f - 0x401000)
.set FUN_0049c889, .text + (0x0049c889 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004dadff, .text + (0x004dadff - 0x401000)
.set FUN_004dae66, .text + (0x004dae66 - 0x401000)
.set FUN_004dae77, .text + (0x004dae77 - 0x401000)
.set FUN_004db993, .text + (0x004db993 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00495af3 - 0x401000
.globl FUN_00495af3
FUN_00495af3:
    # block 0x00495af3: entry, 12 instruction(s), ends with je to 0x00495b30 (forward)
    push ebp                                     # 00495af3
    {load} mov ebp, esp                          # 00495af4
    sub esp, 0x18                                # 00495af6
    push esi                                     # 00495af9
    push edi                                     # 00495afa
    mov dword ptr [ebp - local_c], ecx           # 00495afb
    movsx eax, word ptr [ebp + arg_8]            # 00495afe
    imul eax, eax, 0x8d                          # 00495b02
    mov ecx, dword ptr [eax + 0x5bb632]          # 00495b08
    mov dword ptr [ebp - local_10], ecx          # 00495b0e
    cmp dword ptr [ebp - local_10], 0x0          # 00495b11
    je.d8 L_00495b30                             # 00495b15
    # block 0x00495b17: entered by fall-through of je at 0x00495b15, 2 instruction(s), ends with je to 0x0049604f (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 00495b17
    je.d32 L_0049604f                            # 00495b1b
    # block 0x00495b21: entered by fall-through of je at 0x00495b1b, 2 instruction(s), ends with je to 0x004961b9 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 00495b21
    je.d32 L_004961b9                            # 00495b25
    # block 0x00495b2b: entered by fall-through of je at 0x00495b25, 1 instruction(s), ends with forward jump to 0x00496408
    jmp.d32 L_00496408                           # 00495b2b
L_00495b30:
    # block 0x00495b30: entered by je at 0x00495b15, 11 instruction(s), calls FUN_0043dbd5, ends with jne to 0x00495b71 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00495b30
    mov ax, word ptr [ebp + arg_8]               # 00495b33
    mov word ptr [edx + field_1e], ax            # 00495b37
    movsx ecx, word ptr [ebp + arg_8]            # 00495b3b
    imul ecx, ecx, 0x8d                          # 00495b3f
    mov edx, dword ptr [ebp - local_c]           # 00495b45
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 00495b48
    mov dword ptr [edx + field_201f], eax        # 00495b4e
    call FUN_0043dbd5                            # 00495b54
    cmp dword ptr [0x5867a1], 0x0                # 00495b59
    jne.d8 L_00495b71                            # 00495b60
    # block 0x00495b62: entered by fall-through of jne at 0x00495b60, 2 instruction(s), ends with forward jump to 0x00496408
    mov dword ptr [0x5867a1], 0x1                # 00495b62
    jmp.d32 L_00496408                           # 00495b6c
L_00495b71:
    # block 0x00495b71: entered by jne at 0x00495b60, 62 instruction(s), calls FUN_004d39f9, FUN_004911ca, ends with jg to 0x00495ca8 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00495b71
    call FUN_004d39f9                            # 00495b7b
    mov ecx, dword ptr [ebp - local_c]           # 00495b80
    mov word ptr [ecx + field_1c], ax            # 00495b83
    mov edx, dword ptr [ebp - local_c]           # 00495b87
    movsx eax, word ptr [edx + field_1c]         # 00495b8a
    imul eax, eax, 0x4a                          # 00495b8e
    mov dword ptr [eax + 0x5d1591], 0x9          # 00495b91
    mov ecx, dword ptr [ebp - local_c]           # 00495b9b
    movsx edx, word ptr [ecx + field_1c]         # 00495b9e
    imul edx, edx, 0x4a                          # 00495ba2
    mov dword ptr [edx + 0x5d1595], 0x49c46c     # 00495ba5
    mov eax, dword ptr [ebp - local_c]           # 00495baf
    movsx ecx, word ptr [eax + field_1c]         # 00495bb2
    imul ecx, ecx, 0x4a                          # 00495bb6
    mov dword ptr [ecx + 0x5d1599], 0x0          # 00495bb9
    mov edx, dword ptr [ebp - local_c]           # 00495bc3
    movsx eax, word ptr [edx + field_1c]         # 00495bc6
    imul eax, eax, 0x4a                          # 00495bca
    mov dword ptr [eax + 0x5d159d], 0x0          # 00495bcd
    mov ecx, dword ptr [ebp - local_c]           # 00495bd7
    movsx edx, word ptr [ecx + field_1c]         # 00495bda
    imul edx, edx, 0x4a                          # 00495bde
    mov dword ptr [edx + 0x5d15a1], 0x0          # 00495be1
    mov eax, dword ptr [ebp - local_c]           # 00495beb
    movsx ecx, word ptr [eax + field_1c]         # 00495bee
    imul ecx, ecx, 0x4a                          # 00495bf2
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00495bf5
    mov edx, dword ptr [ebp - local_c]           # 00495bff
    movsx eax, word ptr [edx + field_1c]         # 00495c02
    imul eax, eax, 0x4a                          # 00495c06
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00495c09
    mov ecx, dword ptr [ebp - local_c]           # 00495c13
    movsx edx, word ptr [ecx + field_1c]         # 00495c16
    imul edx, edx, 0x4a                          # 00495c1a
    mov word ptr [edx + 0x5d15ad], 0x0           # 00495c1d
    mov edi, 0x54f8ac                            # 00495c26
    mov eax, dword ptr [ebp - local_c]           # 00495c2b
    movsx ecx, word ptr [eax + field_1c]         # 00495c2e
    imul ecx, ecx, 0x4a                          # 00495c32
    add ecx, 0x5d15b3                            # 00495c35
    {load} mov edx, ecx                          # 00495c3b
    or ecx, -0x1                                 # 00495c3d
    {load} xor eax, eax                          # 00495c40
    repne scasb al, byte ptr es:[edi]            # 00495c42
    not ecx                                      # 00495c44
    {load} sub edi, ecx                          # 00495c46
    {load} mov esi, edi                          # 00495c48
    {load} mov eax, ecx                          # 00495c4a
    {load} mov edi, edx                          # 00495c4c
    shr ecx, 0x2                                 # 00495c4e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00495c51
    {load} mov ecx, eax                          # 00495c53
    and ecx, 0x3                                 # 00495c55
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00495c58
    mov ecx, dword ptr [ebp - local_c]           # 00495c5a
    call FUN_004911ca                            # 00495c5d
    mov ecx, dword ptr [ebp - local_c]           # 00495c62
    mov edx, dword ptr [ecx + field_201f]        # 00495c65
    movsx eax, word ptr [edx]                    # 00495c6b
    cmp eax, 0x28                                # 00495c6e
    jg.d8 L_00495ca8                             # 00495c71
    # block 0x00495c73: entered by fall-through of jg at 0x00495c71, 5 instruction(s), ends with jg to 0x00495ca8 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00495c73
    mov edx, dword ptr [ecx + field_201f]        # 00495c76
    movsx eax, word ptr [edx + field_2]          # 00495c7c
    cmp eax, 0x28                                # 00495c80
    jg.d8 L_00495ca8                             # 00495c83
    # block 0x00495c85: entered by fall-through of jg at 0x00495c83, 5 instruction(s), ends with jl to 0x00495ca8 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00495c85
    mov edx, dword ptr [ecx + field_201f]        # 00495c88
    movsx eax, word ptr [edx]                    # 00495c8e
    cmp eax, 0x5                                 # 00495c91
    jl.d8 L_00495ca8                             # 00495c94
    # block 0x00495c96: entered by fall-through of jl at 0x00495c94, 5 instruction(s), ends with jge to 0x00495d05 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00495c96
    mov edx, dword ptr [ecx + field_201f]        # 00495c99
    movsx eax, word ptr [edx + field_2]          # 00495c9f
    cmp eax, 0x5                                 # 00495ca3
    jge.d8 L_00495d05                            # 00495ca6
L_00495ca8:
    # block 0x00495ca8: entered by jg at 0x00495c71; jg at 0x00495c83; jl at 0x00495c94; fall-through of jge at 0x00495ca6, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x00495cfb (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00495ca8
    mov edx, dword ptr [ecx + field_201f]        # 00495cab
    movsx eax, word ptr [edx + field_2]          # 00495cb1
    push eax                                     # 00495cb5
    mov ecx, dword ptr [ebp - local_c]           # 00495cb6
    mov edx, dword ptr [ecx + field_201f]        # 00495cb9
    movsx eax, word ptr [edx]                    # 00495cbf
    push eax                                     # 00495cc2
    push 0x54f8c0                                # 00495cc3
    push 0x63888b                                # 00495cc8
    call FUN_0050ca3e                            # 00495ccd
    add esp, 0x10                                # 00495cd2
    push 0x0                                     # 00495cd5
    push 0x0                                     # 00495cd7
    push 0x63888b                                # 00495cd9
    call FUN_0052139c                            # 00495cde
    movsx ecx, word ptr [0x63a4cd]               # 00495ce3
    test ecx, ecx                                # 00495cea
    je.d8 L_00495cfb                             # 00495cec
    # block 0x00495cee: entered by fall-through of je at 0x00495cec, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00495cfb
    push 0x63888b                                # 00495cee
    call FUN_0044a2b7                            # 00495cf3
    add esp, 0x4                                 # 00495cf8
L_00495cfb:
    # block 0x00495cfb: entered by je at 0x00495cec, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x00495d05
    mov ecx, 0x5cf659                            # 00495cfb
    call FUN_004c97b4                            # 00495d00
L_00495d05:
    # block 0x00495d05: entered by jge at 0x00495ca6, 125 instruction(s), calls FUN_0049c889, FUN_0050ce04, FUN_00491db2, FUN_00491972, FUN_0049251f, FUN_00493c34, FUN_004921a1,..., ends with je to 0x00495f84 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00495d05
    mov eax, dword ptr [edx + field_201f]        # 00495d08
    {load} xor ecx, ecx                          # 00495d0e
    mov cl, byte ptr [eax + field_4]             # 00495d10
    push ecx                                     # 00495d13
    mov edx, dword ptr [ebp - local_c]           # 00495d14
    mov eax, dword ptr [edx + field_201f]        # 00495d17
    movsx ecx, word ptr [eax + field_2]          # 00495d1d
    push ecx                                     # 00495d21
    mov edx, dword ptr [ebp - local_c]           # 00495d22
    mov eax, dword ptr [edx + field_201f]        # 00495d25
    movsx ecx, word ptr [eax]                    # 00495d2b
    push ecx                                     # 00495d2e
    mov ecx, 0x635b98                            # 00495d2f
    call FUN_0049c889                            # 00495d34
    mov edx, dword ptr [ebp - local_c]           # 00495d39
    mov eax, dword ptr [ebp - local_c]           # 00495d3c
    mov ecx, dword ptr [edx + field_1f27]        # 00495d3f
    imul ecx, dword ptr [eax + field_45b1]       # 00495d45
    mov edx, dword ptr [ebp - local_c]           # 00495d4c
    mov dword ptr [edx + field_45b5], ecx        # 00495d4f
    mov eax, dword ptr [ebp - local_c]           # 00495d55
    mov ecx, dword ptr [ebp - local_c]           # 00495d58
    mov edx, dword ptr [eax + field_1f27]        # 00495d5b
    imul edx, dword ptr [ecx + field_1f3b]       # 00495d61
    mov eax, dword ptr [ebp - local_c]           # 00495d68
    mov dword ptr [eax + field_45ad], edx        # 00495d6b
    mov ecx, dword ptr [ebp - local_c]           # 00495d71
    fild dword ptr [ecx + field_45ad]            # 00495d74
    fstp dword ptr [ebp - local_14]              # 00495d7a
    mov edx, dword ptr [ebp - local_c]           # 00495d7d
    fld dword ptr [ebp - local_14]               # 00495d80
    fsub dword ptr [edx + field_47a9]            # 00495d83
    mov eax, dword ptr [ebp - local_c]           # 00495d89
    fdiv dword ptr [eax + field_47a9]            # 00495d8c
    mov ecx, dword ptr [ebp - local_c]           # 00495d92
    fstp dword ptr [ecx + field_47b1]            # 00495d95
    mov edx, dword ptr [ebp - local_c]           # 00495d9b
    mov eax, dword ptr [ebp - local_c]           # 00495d9e
    fld dword ptr [edx + field_1f2b]             # 00495da1
    fmul dword ptr [eax + field_47a9]            # 00495da7
    call FUN_0050ce04                            # 00495dad
    mov ecx, dword ptr [ebp - local_c]           # 00495db2
    mov dword ptr [ecx + field_47ad], eax        # 00495db5
    mov ecx, dword ptr [ebp - local_c]           # 00495dbb
    call FUN_00491db2                            # 00495dbe
    mov ecx, dword ptr [ebp - local_c]           # 00495dc3
    call FUN_00491972                            # 00495dc6
    mov ecx, dword ptr [ebp - local_c]           # 00495dcb
    call FUN_0049251f                            # 00495dce
    mov edx, dword ptr [ebp - local_c]           # 00495dd3
    mov dword ptr [edx + field_47b5], 0x0        # 00495dd6
    mov eax, dword ptr [ebp - local_c]           # 00495de0
    mov dword ptr [eax + field_47b9], 0x0        # 00495de3
    mov ecx, dword ptr [ebp - local_c]           # 00495ded
    mov dword ptr [ecx + field_47cd], 0x0        # 00495df0
    mov edx, dword ptr [ebp - local_c]           # 00495dfa
    mov eax, dword ptr [ebp - local_c]           # 00495dfd
    mov ecx, dword ptr [edx + field_1f2f]        # 00495e00
    imul ecx, dword ptr [eax + field_2095]       # 00495e06
    mov edx, dword ptr [ebp - local_c]           # 00495e0d
    add ecx, dword ptr [edx + field_2099]        # 00495e10
    mov eax, dword ptr [ebp - local_c]           # 00495e16
    mov dword ptr [eax + field_1ef7], ecx        # 00495e19
    mov ecx, dword ptr [ebp - local_c]           # 00495e1f
    mov edx, dword ptr [ebp - local_c]           # 00495e22
    mov eax, dword ptr [ecx + field_1f33]        # 00495e25
    imul eax, dword ptr [edx + field_2095]       # 00495e2b
    mov ecx, dword ptr [ebp - local_c]           # 00495e32
    add eax, dword ptr [ecx + field_2099]        # 00495e35
    mov edx, dword ptr [ebp - local_c]           # 00495e3b
    mov dword ptr [edx + field_1efb], eax        # 00495e3e
    mov eax, dword ptr [ebp - local_c]           # 00495e44
    mov ecx, dword ptr [ebp - local_c]           # 00495e47
    mov edx, dword ptr [ecx + field_1f37]        # 00495e4a
    mov dword ptr [eax + field_1ef3], edx        # 00495e50
    mov ecx, dword ptr [ebp - local_c]           # 00495e56
    call FUN_00493c34                            # 00495e59
    mov eax, dword ptr [ebp - local_c]           # 00495e5e
    movsx ecx, word ptr [eax + field_80]         # 00495e61
    mov edx, dword ptr [ebp - local_c]           # 00495e68
    mov dword ptr [edx + field_4791], ecx        # 00495e6b
    mov ecx, dword ptr [ebp - local_c]           # 00495e71
    call FUN_004921a1                            # 00495e74
    mov ecx, dword ptr [ebp - local_c]           # 00495e79
    call FUN_004915e8                            # 00495e7c
    mov ecx, 0x5830a6                            # 00495e81
    call FUN_004dae66                            # 00495e86
    mov ecx, dword ptr [ebp - local_c]           # 00495e8b
    mov dword ptr [ecx + field_2003], eax        # 00495e8e
    mov ecx, 0x5830a6                            # 00495e94
    call FUN_004dae77                            # 00495e99
    mov edx, dword ptr [ebp - local_c]           # 00495e9e
    mov dword ptr [edx + field_2007], eax        # 00495ea1
    mov eax, dword ptr [ebp - local_c]           # 00495ea7
    mov dword ptr [eax + field_200b], 0x0        # 00495eaa
    mov eax, dword ptr [0x583192]                # 00495eb4
    sub eax, dword ptr [0x58318a]                # 00495eb9
    cdq                                          # 00495ebf
    {load} sub eax, edx                          # 00495ec0
    sar eax                                      # 00495ec2
    push eax                                     # 00495ec4
    mov eax, dword ptr [0x58318e]                # 00495ec5
    sub eax, dword ptr [0x583186]                # 00495eca
    cdq                                          # 00495ed0
    and edx, 0x3                                 # 00495ed1
    {load} add eax, edx                          # 00495ed4
    sar eax, 0x2                                 # 00495ed6
    push eax                                     # 00495ed9
    mov ecx, 0x5830ce                            # 00495eda
    call FUN_004db993                            # 00495edf
    mov ecx, dword ptr [ebp - local_c]           # 00495ee4
    call FUN_00494f1f                            # 00495ee7
    mov ecx, 0x5830a6                            # 00495eec
    call FUN_004dadff                            # 00495ef1
    mov ecx, dword ptr [ebp - local_c]           # 00495ef6
    call FUN_00494d54                            # 00495ef9
    mov edi, 0x54f914                            # 00495efe
    mov ecx, dword ptr [ebp - local_c]           # 00495f03
    mov esi, dword ptr [ecx + field_201f]        # 00495f06
    add esi, 0x5                                 # 00495f0c
    mov ecx, 0x9                                 # 00495f0f
    {load} xor edx, edx                          # 00495f14
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00495f16
    je.d8 L_00495f84                             # 00495f18
    # block 0x00495f1a: entered by fall-through of je at 0x00495f18, 33 instruction(s), calls FUN_004fb77a, falls into the block at 0x00495f84
    mov eax, dword ptr [ebp - local_c]           # 00495f1a
    mov ecx, dword ptr [eax + field_201f]        # 00495f1d
    add ecx, 0x5                                 # 00495f23
    {load} mov edi, ecx                          # 00495f26
    mov edx, dword ptr [ebp - local_c]           # 00495f28
    mov eax, dword ptr [edx + field_201f]        # 00495f2b
    add eax, 0x4b                                # 00495f31
    {load} mov edx, eax                          # 00495f34
    or ecx, -0x1                                 # 00495f36
    {load} xor eax, eax                          # 00495f39
    repne scasb al, byte ptr es:[edi]            # 00495f3b
    not ecx                                      # 00495f3d
    {load} sub edi, ecx                          # 00495f3f
    {load} mov esi, edi                          # 00495f41
    {load} mov eax, ecx                          # 00495f43
    {load} mov edi, edx                          # 00495f45
    shr ecx, 0x2                                 # 00495f47
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00495f4a
    {load} mov ecx, eax                          # 00495f4c
    and ecx, 0x3                                 # 00495f4e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00495f51
    mov ecx, dword ptr [ebp - local_c]           # 00495f53
    mov edx, dword ptr [ecx + field_201f]        # 00495f56
    mov eax, dword ptr [ebp - local_c]           # 00495f5c
    mov ecx, dword ptr [eax + field_201f]        # 00495f5f
    mov dx, word ptr [edx + field_26]            # 00495f65
    mov word ptr [ecx + field_6c], dx            # 00495f69
    mov eax, dword ptr [ebp - local_c]           # 00495f6d
    mov ecx, dword ptr [eax + field_201f]        # 00495f70
    add ecx, 0x4b                                # 00495f76
    push ecx                                     # 00495f79
    mov ecx, 0x5c3a67                            # 00495f7a
    call FUN_004fb77a                            # 00495f7f
L_00495f84:
    # block 0x00495f84: entered by je at 0x00495f18, 8 instruction(s), ends with je to 0x0049600a (forward)
    mov edi, 0x54f920                            # 00495f84
    mov edx, dword ptr [ebp - local_c]           # 00495f89
    mov esi, dword ptr [edx + field_201f]        # 00495f8c
    add esi, 0x28                                # 00495f92
    mov ecx, 0x9                                 # 00495f95
    {load} xor eax, eax                          # 00495f9a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00495f9c
    je.d8 L_0049600a                             # 00495f9e
    # block 0x00495fa0: entered by fall-through of je at 0x00495f9e, 33 instruction(s), calls FUN_004fb77a, falls into the block at 0x0049600a
    mov ecx, dword ptr [ebp - local_c]           # 00495fa0
    mov edx, dword ptr [ecx + field_201f]        # 00495fa3
    add edx, 0x28                                # 00495fa9
    {load} mov edi, edx                          # 00495fac
    mov eax, dword ptr [ebp - local_c]           # 00495fae
    mov ecx, dword ptr [eax + field_201f]        # 00495fb1
    add ecx, 0x4b                                # 00495fb7
    {load} mov edx, ecx                          # 00495fba
    or ecx, -0x1                                 # 00495fbc
    {load} xor eax, eax                          # 00495fbf
    repne scasb al, byte ptr es:[edi]            # 00495fc1
    not ecx                                      # 00495fc3
    {load} sub edi, ecx                          # 00495fc5
    {load} mov esi, edi                          # 00495fc7
    {load} mov eax, ecx                          # 00495fc9
    {load} mov edi, edx                          # 00495fcb
    shr ecx, 0x2                                 # 00495fcd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00495fd0
    {load} mov ecx, eax                          # 00495fd2
    and ecx, 0x3                                 # 00495fd4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00495fd7
    mov ecx, dword ptr [ebp - local_c]           # 00495fd9
    mov edx, dword ptr [ecx + field_201f]        # 00495fdc
    mov eax, dword ptr [ebp - local_c]           # 00495fe2
    mov ecx, dword ptr [eax + field_201f]        # 00495fe5
    mov dx, word ptr [edx + field_49]            # 00495feb
    mov word ptr [ecx + field_6c], dx            # 00495fef
    mov eax, dword ptr [ebp - local_c]           # 00495ff3
    mov ecx, dword ptr [eax + field_201f]        # 00495ff6
    add ecx, 0x4b                                # 00495ffc
    push ecx                                     # 00495fff
    mov ecx, 0x5c3a67                            # 00496000
    call FUN_004fb77a                            # 00496005
L_0049600a:
    # block 0x0049600a: entered by je at 0x00495f9e, 11 instruction(s), calls FUN_004d36ed, ends with forward jump to 0x00496408
    mov dword ptr [0x5867a5], 0x1                # 0049600a
    mov edx, dword ptr [ebp - local_c]           # 00496014
    mov dword ptr [edx + field_1f77], 0x1        # 00496017
    call FUN_004d36ed                            # 00496021
    mov eax, dword ptr [ebp - local_c]           # 00496026
    mov dword ptr [eax + field_1f6b], 0x0        # 00496029
    mov ecx, dword ptr [ebp - local_c]           # 00496033
    movsx edx, word ptr [ecx + field_1e]         # 00496036
    imul edx, edx, 0x8d                          # 0049603a
    mov dword ptr [edx + 0x5bb632], 0x1          # 00496040
    jmp.d32 L_00496408                           # 0049604a
L_0049604f:
    # block 0x0049604f: entered by je at 0x00495b1b, 5 instruction(s), ends with je to 0x0049607a (forward)
    mov eax, dword ptr [ebp - local_c]           # 0049604f
    mov ecx, dword ptr [eax + field_1f6b]        # 00496052
    mov dword ptr [ebp - local_18], ecx          # 00496058
    cmp dword ptr [ebp - local_18], 0x0          # 0049605b
    je.d8 L_0049607a                             # 0049605f
    # block 0x00496061: entered by fall-through of je at 0x0049605f, 2 instruction(s), ends with je to 0x00496150 (forward)
    cmp dword ptr [ebp - local_18], 0x1          # 00496061
    je.d32 L_00496150                            # 00496065
    # block 0x0049606b: entered by fall-through of je at 0x00496065, 2 instruction(s), ends with je to 0x0049619d (forward)
    cmp dword ptr [ebp - local_18], 0x2          # 0049606b
    je.d32 L_0049619d                            # 0049606f
    # block 0x00496075: entered by fall-through of je at 0x0049606f, 1 instruction(s), ends with forward jump to 0x004961b4
    jmp.d32 L_004961b4                           # 00496075
L_0049607a:
    # block 0x0049607a: entered by je at 0x0049605f, 2 instruction(s), ends with forward jump to 0x0049608e
    mov word ptr [ebp - local_4], 0x0            # 0049607a
    jmp.d8 L_0049608e                            # 00496080
L_00496082:
    # block 0x00496082: entered by jmp at 0x00496149, 3 instruction(s), falls into the block at 0x0049608e
    mov dx, word ptr [ebp - local_4]             # 00496082
    add dx, 0x1                                  # 00496086
    mov word ptr [ebp - local_4], dx             # 0049608a
L_0049608e:
    # block 0x0049608e: entered by jmp at 0x00496080, 4 instruction(s), ends with jge to 0x0049614e (forward)
    movsx eax, word ptr [ebp - local_4]          # 0049608e
    mov ecx, dword ptr [ebp - local_c]           # 00496092
    cmp eax, dword ptr [ecx + field_20c1]        # 00496095
    jge.d32 L_0049614e                           # 0049609b
    # block 0x004960a1: entered by fall-through of jge at 0x0049609b, 6 instruction(s), ends with jne to 0x00496149 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004960a1
    mov eax, dword ptr [ebp - local_c]           # 004960a5
    mov ecx, dword ptr [ebp - local_c]           # 004960a8
    mov eax, dword ptr [eax + field_1eff]        # 004960ab
    cmp eax, dword ptr [ecx + 8*edx + field_20c5] # 004960b1
    jne.d32 L_00496149                           # 004960b8
    # block 0x004960be: entered by fall-through of jne at 0x004960b8, 6 instruction(s), ends with jne to 0x00496149 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004960be
    mov edx, dword ptr [ebp - local_c]           # 004960c2
    mov eax, dword ptr [ebp - local_c]           # 004960c5
    mov edx, dword ptr [edx + field_1f03]        # 004960c8
    cmp edx, dword ptr [eax + 8*ecx + field_20c9] # 004960ce
    jne.d8 L_00496149                            # 004960d5
    # block 0x004960d7: entered by fall-through of jne at 0x004960d5, 8 instruction(s), ends with je to 0x0049613a (forward)
    mov edi, 0x54f92c                            # 004960d7
    mov eax, dword ptr [ebp - local_c]           # 004960dc
    mov esi, dword ptr [eax + field_201f]        # 004960df
    add esi, 0x95                                # 004960e5
    mov ecx, 0x9                                 # 004960eb
    {load} xor edx, edx                          # 004960f0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004960f2
    je.d8 L_0049613a                             # 004960f4
    # block 0x004960f6: entered by fall-through of je at 0x004960f4, 15 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00496147
    mov eax, dword ptr [ebp - local_c]           # 004960f6
    mov dword ptr [eax + field_1f6b], 0x1        # 004960f9
    mov ecx, dword ptr [ebp - local_c]           # 00496103
    mov edx, dword ptr [ecx + field_201f]        # 00496106
    add edx, 0x95                                # 0049610c
    push edx                                     # 00496112
    mov ecx, 0x5c3a67                            # 00496113
    call FUN_004fb77a                            # 00496118
    mov eax, dword ptr [ebp - local_c]           # 0049611d
    mov ecx, dword ptr [eax + field_201f]        # 00496120
    mov dx, word ptr [ecx + field_b6]            # 00496126
    push edx                                     # 0049612d
    mov ecx, 0x5c3a67                            # 0049612e
    call FUN_004fb2e3                            # 00496133
    jmp.d8 L_00496147                            # 00496138
L_0049613a:
    # block 0x0049613a: entered by je at 0x004960f4, 2 instruction(s), falls into the block at 0x00496147
    mov eax, dword ptr [ebp - local_c]           # 0049613a
    mov dword ptr [eax + field_1f6b], 0x2        # 0049613d
L_00496147:
    # block 0x00496147: entered by jmp at 0x00496138, 1 instruction(s), ends with forward jump to 0x0049614e
    jmp.d8 L_0049614e                            # 00496147
L_00496149:
    # block 0x00496149: entered by jne at 0x004960b8; jne at 0x004960d5, 1 instruction(s), ends with backward jump to 0x00496082
    jmp.d32 L_00496082                           # 00496149
L_0049614e:
    # block 0x0049614e: entered by jge at 0x0049609b; jmp at 0x00496147, 1 instruction(s), ends with forward jump to 0x004961b4
    jmp.d8 L_004961b4                            # 0049614e
L_00496150:
    # block 0x00496150: entered by je at 0x00496065, 10 instruction(s), calls FUN_004f6334, ends with jne to 0x0049619b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00496150
    mov edx, dword ptr [ecx + field_201f]        # 00496153
    movsx eax, word ptr [edx + field_b6]         # 00496159
    mov dword ptr [ebp - local_8], eax           # 00496160
    mov ecx, dword ptr [ebp - local_8]           # 00496163
    push ecx                                     # 00496166
    mov ecx, 0x5cf1eb                            # 00496167
    call FUN_004f6334                            # 0049616c
    test eax, eax                                # 00496171
    jne.d8 L_0049619b                            # 00496173
    # block 0x00496175: entered by fall-through of jne at 0x00496173, 8 instruction(s), calls FUN_004fba69, falls into the block at 0x0049619b
    mov edx, dword ptr [ebp - local_c]           # 00496175
    mov eax, dword ptr [edx + field_201f]        # 00496178
    add eax, 0x95                                # 0049617e
    push eax                                     # 00496183
    mov ecx, 0x5c3a67                            # 00496184
    call FUN_004fba69                            # 00496189
    mov ecx, dword ptr [ebp - local_c]           # 0049618e
    mov dword ptr [ecx + field_1f6b], 0x2        # 00496191
L_0049619b:
    # block 0x0049619b: entered by jne at 0x00496173, 1 instruction(s), ends with forward jump to 0x004961b4
    jmp.d8 L_004961b4                            # 0049619b
L_0049619d:
    # block 0x0049619d: entered by je at 0x0049606f, 4 instruction(s), falls into the block at 0x004961b4
    mov edx, dword ptr [ebp - local_c]           # 0049619d
    movsx eax, word ptr [edx + field_1e]         # 004961a0
    imul eax, eax, 0x8d                          # 004961a4
    mov dword ptr [eax + 0x5bb632], 0x2          # 004961aa
L_004961b4:
    # block 0x004961b4: entered by jmp at 0x00496075; jmp at 0x0049614e; jmp at 0x0049619b, 1 instruction(s), ends with forward jump to 0x00496408
    jmp.d32 L_00496408                           # 004961b4
L_004961b9:
    # block 0x004961b9: entered by je at 0x00495b25, 9 instruction(s), ends with je to 0x00496249 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004961b9
    mov edi, 0x54f938                            # 004961c3
    mov ecx, dword ptr [ebp - local_c]           # 004961c8
    mov esi, dword ptr [ecx + field_201f]        # 004961cb
    add esi, 0x5                                 # 004961d1
    mov ecx, 0x9                                 # 004961d4
    {load} xor edx, edx                          # 004961d9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004961db
    je.d8 L_00496249                             # 004961dd
    # block 0x004961df: entered by fall-through of je at 0x004961dd, 33 instruction(s), calls FUN_004fba69, falls into the block at 0x00496249
    mov eax, dword ptr [ebp - local_c]           # 004961df
    mov ecx, dword ptr [eax + field_201f]        # 004961e2
    add ecx, 0x5                                 # 004961e8
    {load} mov edi, ecx                          # 004961eb
    mov edx, dword ptr [ebp - local_c]           # 004961ed
    mov eax, dword ptr [edx + field_201f]        # 004961f0
    add eax, 0x4b                                # 004961f6
    {load} mov edx, eax                          # 004961f9
    or ecx, -0x1                                 # 004961fb
    {load} xor eax, eax                          # 004961fe
    repne scasb al, byte ptr es:[edi]            # 00496200
    not ecx                                      # 00496202
    {load} sub edi, ecx                          # 00496204
    {load} mov esi, edi                          # 00496206
    {load} mov eax, ecx                          # 00496208
    {load} mov edi, edx                          # 0049620a
    shr ecx, 0x2                                 # 0049620c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0049620f
    {load} mov ecx, eax                          # 00496211
    and ecx, 0x3                                 # 00496213
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00496216
    mov ecx, dword ptr [ebp - local_c]           # 00496218
    mov edx, dword ptr [ecx + field_201f]        # 0049621b
    mov eax, dword ptr [ebp - local_c]           # 00496221
    mov ecx, dword ptr [eax + field_201f]        # 00496224
    mov dx, word ptr [edx + field_26]            # 0049622a
    mov word ptr [ecx + field_6c], dx            # 0049622e
    mov eax, dword ptr [ebp - local_c]           # 00496232
    mov ecx, dword ptr [eax + field_201f]        # 00496235
    add ecx, 0x4b                                # 0049623b
    push ecx                                     # 0049623e
    mov ecx, 0x5c3a67                            # 0049623f
    call FUN_004fba69                            # 00496244
L_00496249:
    # block 0x00496249: entered by je at 0x004961dd, 8 instruction(s), ends with je to 0x004962cf (forward)
    mov edi, 0x54f944                            # 00496249
    mov edx, dword ptr [ebp - local_c]           # 0049624e
    mov esi, dword ptr [edx + field_201f]        # 00496251
    add esi, 0x28                                # 00496257
    mov ecx, 0x9                                 # 0049625a
    {load} xor eax, eax                          # 0049625f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00496261
    je.d8 L_004962cf                             # 00496263
    # block 0x00496265: entered by fall-through of je at 0x00496263, 33 instruction(s), calls FUN_004fba69, falls into the block at 0x004962cf
    mov ecx, dword ptr [ebp - local_c]           # 00496265
    mov edx, dword ptr [ecx + field_201f]        # 00496268
    add edx, 0x28                                # 0049626e
    {load} mov edi, edx                          # 00496271
    mov eax, dword ptr [ebp - local_c]           # 00496273
    mov ecx, dword ptr [eax + field_201f]        # 00496276
    add ecx, 0x4b                                # 0049627c
    {load} mov edx, ecx                          # 0049627f
    or ecx, -0x1                                 # 00496281
    {load} xor eax, eax                          # 00496284
    repne scasb al, byte ptr es:[edi]            # 00496286
    not ecx                                      # 00496288
    {load} sub edi, ecx                          # 0049628a
    {load} mov esi, edi                          # 0049628c
    {load} mov eax, ecx                          # 0049628e
    {load} mov edi, edx                          # 00496290
    shr ecx, 0x2                                 # 00496292
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00496295
    {load} mov ecx, eax                          # 00496297
    and ecx, 0x3                                 # 00496299
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0049629c
    mov ecx, dword ptr [ebp - local_c]           # 0049629e
    mov edx, dword ptr [ecx + field_201f]        # 004962a1
    mov eax, dword ptr [ebp - local_c]           # 004962a7
    mov ecx, dword ptr [eax + field_201f]        # 004962aa
    mov dx, word ptr [edx + field_49]            # 004962b0
    mov word ptr [ecx + field_6c], dx            # 004962b4
    mov eax, dword ptr [ebp - local_c]           # 004962b8
    mov ecx, dword ptr [eax + field_201f]        # 004962bb
    add ecx, 0x4b                                # 004962c1
    push ecx                                     # 004962c4
    mov ecx, 0x5c3a67                            # 004962c5
    call FUN_004fba69                            # 004962ca
L_004962cf:
    # block 0x004962cf: entered by je at 0x00496263, 7 instruction(s), ends with je to 0x004963bb (forward)
    mov edx, dword ptr [ebp - local_c]           # 004962cf
    movsx eax, word ptr [edx + field_1e]         # 004962d2
    imul eax, eax, 0x8d                          # 004962d6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004962dc
    movsx edx, word ptr [ecx + field_7c]         # 004962e2
    cmp edx, 0x270f                              # 004962e6
    je.d32 L_004963bb                            # 004962ec
    # block 0x004962f2: entered by fall-through of je at 0x004962ec, 33 instruction(s), ends with jne to 0x004963a7 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004962f2
    mov ecx, dword ptr [eax + field_201f]        # 004962f5
    movsx edx, word ptr [ecx + field_7c]         # 004962fb
    mov dword ptr [0x5bb57b], edx                # 004962ff
    mov eax, dword ptr [ebp - local_c]           # 00496305
    mov ecx, dword ptr [eax + field_201f]        # 00496308
    mov dx, word ptr [ecx + field_7e]            # 0049630e
    mov word ptr [0x5bb599], dx                  # 00496312
    mov eax, dword ptr [ebp - local_c]           # 00496319
    mov ecx, dword ptr [eax + field_201f]        # 0049631c
    mov dx, word ptr [ecx + field_80]            # 00496322
    mov word ptr [0x5bb595], dx                  # 00496329
    mov eax, dword ptr [ebp - local_c]           # 00496330
    mov ecx, dword ptr [eax + field_201f]        # 00496333
    mov dx, word ptr [ecx + field_82]            # 00496339
    mov word ptr [0x5c39ff], dx                  # 00496340
    mov eax, dword ptr [ebp - local_c]           # 00496347
    mov ecx, dword ptr [eax + field_201f]        # 0049634a
    mov edx, dword ptr [ecx + field_84]          # 00496350
    mov dword ptr [0x5bb59b], edx                # 00496356
    mov eax, dword ptr [ebp - local_c]           # 0049635c
    mov ecx, dword ptr [eax + field_201f]        # 0049635f
    mov edx, dword ptr [ecx + field_88]          # 00496365
    mov dword ptr [0x5bb59f], edx                # 0049636b
    mov eax, dword ptr [ebp - local_c]           # 00496371
    mov ecx, dword ptr [eax + field_201f]        # 00496374
    mov edx, dword ptr [ecx + field_8c]          # 0049637a
    mov dword ptr [0x5bb5a3], edx                # 00496380
    mov eax, dword ptr [ebp - local_c]           # 00496386
    mov ecx, dword ptr [eax + field_201f]        # 00496389
    movsx edx, word ptr [ecx + field_90]         # 0049638f
    cmp edx, 0x1                                 # 00496396
    jne.d8 L_004963a7                            # 00496399
    # block 0x0049639b: entered by fall-through of jne at 0x00496399, 2 instruction(s), ends with forward jump to 0x004963b1
    mov dword ptr [0x5bb1ca], 0x0                # 0049639b
    jmp.d8 L_004963b1                            # 004963a5
L_004963a7:
    # block 0x004963a7: entered by jne at 0x00496399, 1 instruction(s), falls into the block at 0x004963b1
    mov dword ptr [0x5bb1ca], 0x1                # 004963a7
L_004963b1:
    # block 0x004963b1: entered by jmp at 0x004963a5, 1 instruction(s), falls into the block at 0x004963bb
    mov dword ptr [0x583999], 0x4                # 004963b1
L_004963bb:
    # block 0x004963bb: entered by je at 0x004962ec, 5 instruction(s), ends with je to 0x004963f8 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004963bb
    mov ecx, dword ptr [eax + field_201f]        # 004963be
    movsx edx, word ptr [ecx + field_92]         # 004963c4
    cmp edx, -0x1                                # 004963cb
    je.d8 L_004963f8                             # 004963ce
    # block 0x004963d0: entered by fall-through of je at 0x004963ce, 8 instruction(s), falls into the block at 0x004963f8
    mov eax, dword ptr [ebp - local_c]           # 004963d0
    mov ecx, dword ptr [eax + field_201f]        # 004963d3
    {load} xor edx, edx                          # 004963d9
    mov dl, byte ptr [ecx + field_94]            # 004963db
    mov eax, dword ptr [ebp - local_c]           # 004963e1
    mov ecx, dword ptr [eax + field_201f]        # 004963e4
    movsx eax, word ptr [ecx + field_92]         # 004963ea
    mov dword ptr [4*eax + 0x585801], edx        # 004963f1
L_004963f8:
    # block 0x004963f8: entered by je at 0x004963ce, 5 instruction(s), calls FUN_0042ba3a, falls into the block at 0x00496408
    mov ecx, dword ptr [ebp - local_c]           # 004963f8
    mov dx, word ptr [ecx + field_1e]            # 004963fb
    push edx                                     # 004963ff
    call FUN_0042ba3a                            # 00496400
    add esp, 0x4                                 # 00496405
L_00496408:
    # block 0x00496408: entered by jmp at 0x00495b2b; jmp at 0x00495b6c; jmp at 0x0049604a; jmp at 0x004961b4, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00496408
    pop esi                                      # 00496409
    {load} mov esp, ebp                          # 0049640a
    pop ebp                                      # 0049640c
    ret 0x4                                      # 0049640d

