# FUN_004fb77a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb77a
# extent:       0x004fb77a-0x004fba69 (751 code bytes)
# span:         0x004fb77a-0x004fba69 (code 751, tables 0, padding 0)
# sha256:       2ce29dc83367fe0fbde3a901b3fc7e1c9e98397a66754680f8fa74707c8ce556
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fb77a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 6 more
# fields:       [eax + n] field_21, field_23, field_25, field_2d, field_130, field_132, field_138; [ecx + n] field_2f, field_134, field_13c, field_16a; [edx + n] field_29, field_132, field_138, field_13c
# callees:      calls FUN_004fba69, FUN_004fc62d
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:phase0_cel (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 180 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_130, 0x130  # offset +0x130
.equ field_132, 0x132  # offset +0x132
.equ field_134, 0x134  # offset +0x134
.equ field_138, 0x138  # offset +0x138
.equ field_13c, 0x13c  # offset +0x13c
.equ field_16a, 0x16a  # offset +0x16a

# --- external targets -----------------------------------------------
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)

.org 0x004fb77a - 0x401000
.globl FUN_004fb77a
FUN_004fb77a:
    # block 0x004fb77a: entry, 15 instruction(s), ends with je to 0x004fb7ba (forward)
    push ebp                                     # 004fb77a
    {load} mov ebp, esp                          # 004fb77b
    sub esp, 0x48                                # 004fb77d
    mov dword ptr [ebp - local_8], ecx           # 004fb780
    mov eax, dword ptr [ebp + arg_8]             # 004fb783
    mov cx, word ptr [eax + field_21]            # 004fb786
    mov word ptr [ebp - local_4], cx             # 004fb78a
    mov edx, dword ptr [ebp - local_4]           # 004fb78e
    and edx, 0xffff                              # 004fb791
    imul edx, edx, 0x5bb                         # 004fb797
    mov eax, dword ptr [ebp - local_8]           # 004fb79d
    {load} xor ecx, ecx                          # 004fb7a0
    mov cx, word ptr [eax + edx + field_132]     # 004fb7a2
    test ecx, ecx                                # 004fb7aa
    je.d8 L_004fb7ba                             # 004fb7ac
    # block 0x004fb7ae: entered by fall-through of je at 0x004fb7ac, 4 instruction(s), calls FUN_004fba69, falls into the block at 0x004fb7ba
    mov edx, dword ptr [ebp + arg_8]             # 004fb7ae
    push edx                                     # 004fb7b1
    mov ecx, dword ptr [ebp - local_8]           # 004fb7b2
    call FUN_004fba69                            # 004fb7b5
L_004fb7ba:
    # block 0x004fb7ba: entered by je at 0x004fb7ac, 59 instruction(s), ends with je to 0x004fb8d5 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004fb7ba
    and eax, 0xffff                              # 004fb7bd
    imul eax, eax, 0x5bb                         # 004fb7c2
    mov ecx, dword ptr [ebp - local_8]           # 004fb7c8
    mov edx, dword ptr [ebp + arg_8]             # 004fb7cb
    mov edx, dword ptr [edx + field_29]          # 004fb7ce
    mov dword ptr [ecx + eax + field_134], edx   # 004fb7d1
    mov eax, dword ptr [ebp + arg_8]             # 004fb7d8
    movsx ecx, word ptr [eax + field_2d]         # 004fb7db
    mov dword ptr [ebp - local_c], ecx           # 004fb7df
    fild dword ptr [ebp - local_c]               # 004fb7e2
    fstp dword ptr [ebp - local_10]              # 004fb7e5
    fld dword ptr [ebp - local_10]               # 004fb7e8
    fdiv dword ptr [0x52cbec]                    # 004fb7eb
    mov edx, dword ptr [ebp - local_4]           # 004fb7f1
    and edx, 0xffff                              # 004fb7f4
    imul edx, edx, 0x5bb                         # 004fb7fa
    mov eax, dword ptr [ebp - local_8]           # 004fb800
    fstp dword ptr [eax + edx + field_138]       # 004fb803
    mov ecx, dword ptr [ebp + arg_8]             # 004fb80a
    movsx edx, word ptr [ecx + field_2f]         # 004fb80d
    mov dword ptr [ebp - local_14], edx          # 004fb811
    fild dword ptr [ebp - local_14]              # 004fb814
    fstp dword ptr [ebp - local_18]              # 004fb817
    fld dword ptr [ebp - local_18]               # 004fb81a
    fdiv dword ptr [0x52cbec]                    # 004fb81d
    mov eax, dword ptr [ebp - local_4]           # 004fb823
    and eax, 0xffff                              # 004fb826
    imul eax, eax, 0x5bb                         # 004fb82b
    mov ecx, dword ptr [ebp - local_8]           # 004fb831
    fstp dword ptr [ecx + eax + field_13c]       # 004fb834
    mov edx, dword ptr [ebp - local_4]           # 004fb83b
    and edx, 0xffff                              # 004fb83e
    imul edx, edx, 0x5bb                         # 004fb844
    mov eax, dword ptr [ebp - local_8]           # 004fb84a
    mov word ptr [eax + edx + field_130], 0x1    # 004fb84d
    mov ecx, dword ptr [ebp - local_4]           # 004fb857
    and ecx, 0xffff                              # 004fb85a
    imul ecx, ecx, 0x5bb                         # 004fb860
    mov edx, dword ptr [ebp - local_8]           # 004fb866
    mov word ptr [edx + ecx + field_132], 0x0    # 004fb869
    mov eax, dword ptr [ebp + arg_8]             # 004fb873
    movsx ecx, word ptr [eax + field_25]         # 004fb876
    {load} xor edx, edx                          # 004fb87a
    cmp ecx, 0x2                                 # 004fb87c
    sete dl                                      # 004fb87f
    mov eax, dword ptr [ebp - local_4]           # 004fb882
    and eax, 0xffff                              # 004fb885
    imul eax, eax, 0x5bb                         # 004fb88a
    mov ecx, dword ptr [ebp - local_8]           # 004fb890
    mov dword ptr [ecx + eax + field_16a], edx   # 004fb893
    mov edx, dword ptr [ebp - local_4]           # 004fb89a
    and edx, 0xffff                              # 004fb89d
    imul edx, edx, 0x5bb                         # 004fb8a3
    fld dword ptr [edx + 0x5c3b9f]               # 004fb8a9
    fcomp qword ptr [0x52c598]                   # 004fb8af
    fnstsw ax                                    # 004fb8b5
    test ah, 0x1                                 # 004fb8b7
    je.d8 L_004fb8d5                             # 004fb8ba
    # block 0x004fb8bc: entered by fall-through of je at 0x004fb8ba, 6 instruction(s), ends with forward jump to 0x004fb8e3
    mov eax, dword ptr [ebp - local_4]           # 004fb8bc
    and eax, 0xffff                              # 004fb8bf
    imul eax, eax, 0x5bb                         # 004fb8c4
    fld dword ptr [eax + 0x5c3b9f]               # 004fb8ca
    fstp qword ptr [ebp - local_20]              # 004fb8d0
    jmp.d8 L_004fb8e3                            # 004fb8d3
L_004fb8d5:
    # block 0x004fb8d5: entered by je at 0x004fb8ba, 2 instruction(s), falls into the block at 0x004fb8e3
    mov dword ptr [ebp - local_20], 0x0          # 004fb8d5
    mov dword ptr [ebp - local_1c], 0x3ff00000   # 004fb8dc
L_004fb8e3:
    # block 0x004fb8e3: entered by jmp at 0x004fb8d3, 16 instruction(s), ends with jne to 0x004fb940 (forward)
    fld qword ptr [ebp - local_20]               # 004fb8e3
    fstp dword ptr [ebp - local_24]              # 004fb8e6
    fld dword ptr [ebp - local_24]               # 004fb8e9
    mov ecx, dword ptr [ebp - local_4]           # 004fb8ec
    and ecx, 0xffff                              # 004fb8ef
    imul ecx, ecx, 0x5bb                         # 004fb8f5
    mov edx, dword ptr [ebp - local_8]           # 004fb8fb
    fstp dword ptr [edx + ecx + field_138]       # 004fb8fe
    mov eax, dword ptr [ebp - local_4]           # 004fb905
    and eax, 0xffff                              # 004fb908
    imul eax, eax, 0x5bb                         # 004fb90d
    fld dword ptr [eax + 0x5c3b9f]               # 004fb913
    fcomp qword ptr [0x52c7b0]                   # 004fb919
    fnstsw ax                                    # 004fb91f
    test ah, 0x41                                # 004fb921
    jne.d8 L_004fb940                            # 004fb924
    # block 0x004fb926: entered by fall-through of jne at 0x004fb924, 6 instruction(s), ends with forward jump to 0x004fb94e
    mov ecx, dword ptr [ebp - local_4]           # 004fb926
    and ecx, 0xffff                              # 004fb929
    imul ecx, ecx, 0x5bb                         # 004fb92f
    fld dword ptr [ecx + 0x5c3b9f]               # 004fb935
    fstp qword ptr [ebp - local_2c]              # 004fb93b
    jmp.d8 L_004fb94e                            # 004fb93e
L_004fb940:
    # block 0x004fb940: entered by jne at 0x004fb924, 2 instruction(s), falls into the block at 0x004fb94e
    mov dword ptr [ebp - local_2c], 0x0          # 004fb940
    mov dword ptr [ebp - local_28], 0x0          # 004fb947
L_004fb94e:
    # block 0x004fb94e: entered by jmp at 0x004fb93e, 16 instruction(s), ends with je to 0x004fb9ac (forward)
    fld qword ptr [ebp - local_2c]               # 004fb94e
    fstp dword ptr [ebp - local_30]              # 004fb951
    fld dword ptr [ebp - local_30]               # 004fb954
    mov edx, dword ptr [ebp - local_4]           # 004fb957
    and edx, 0xffff                              # 004fb95a
    imul edx, edx, 0x5bb                         # 004fb960
    mov eax, dword ptr [ebp - local_8]           # 004fb966
    fstp dword ptr [eax + edx + field_138]       # 004fb969
    mov ecx, dword ptr [ebp - local_4]           # 004fb970
    and ecx, 0xffff                              # 004fb973
    imul ecx, ecx, 0x5bb                         # 004fb979
    fld dword ptr [ecx + 0x5c3ba3]               # 004fb97f
    fcomp qword ptr [0x52c598]                   # 004fb985
    fnstsw ax                                    # 004fb98b
    test ah, 0x1                                 # 004fb98d
    je.d8 L_004fb9ac                             # 004fb990
    # block 0x004fb992: entered by fall-through of je at 0x004fb990, 6 instruction(s), ends with forward jump to 0x004fb9ba
    mov edx, dword ptr [ebp - local_4]           # 004fb992
    and edx, 0xffff                              # 004fb995
    imul edx, edx, 0x5bb                         # 004fb99b
    fld dword ptr [edx + 0x5c3ba3]               # 004fb9a1
    fstp qword ptr [ebp - local_38]              # 004fb9a7
    jmp.d8 L_004fb9ba                            # 004fb9aa
L_004fb9ac:
    # block 0x004fb9ac: entered by je at 0x004fb990, 2 instruction(s), falls into the block at 0x004fb9ba
    mov dword ptr [ebp - local_38], 0x0          # 004fb9ac
    mov dword ptr [ebp - local_34], 0x3ff00000   # 004fb9b3
L_004fb9ba:
    # block 0x004fb9ba: entered by jmp at 0x004fb9aa, 16 instruction(s), ends with jne to 0x004fba16 (forward)
    fld qword ptr [ebp - local_38]               # 004fb9ba
    fstp dword ptr [ebp - local_3c]              # 004fb9bd
    fld dword ptr [ebp - local_3c]               # 004fb9c0
    mov eax, dword ptr [ebp - local_4]           # 004fb9c3
    and eax, 0xffff                              # 004fb9c6
    imul eax, eax, 0x5bb                         # 004fb9cb
    mov ecx, dword ptr [ebp - local_8]           # 004fb9d1
    fstp dword ptr [ecx + eax + field_13c]       # 004fb9d4
    mov edx, dword ptr [ebp - local_4]           # 004fb9db
    and edx, 0xffff                              # 004fb9de
    imul edx, edx, 0x5bb                         # 004fb9e4
    fld dword ptr [edx + 0x5c3ba3]               # 004fb9ea
    fcomp qword ptr [0x52c7b0]                   # 004fb9f0
    fnstsw ax                                    # 004fb9f6
    test ah, 0x41                                # 004fb9f8
    jne.d8 L_004fba16                            # 004fb9fb
    # block 0x004fb9fd: entered by fall-through of jne at 0x004fb9fb, 6 instruction(s), ends with forward jump to 0x004fba24
    mov eax, dword ptr [ebp - local_4]           # 004fb9fd
    and eax, 0xffff                              # 004fba00
    imul eax, eax, 0x5bb                         # 004fba05
    fld dword ptr [eax + 0x5c3ba3]               # 004fba0b
    fstp qword ptr [ebp - local_44]              # 004fba11
    jmp.d8 L_004fba24                            # 004fba14
L_004fba16:
    # block 0x004fba16: entered by jne at 0x004fb9fb, 2 instruction(s), falls into the block at 0x004fba24
    mov dword ptr [ebp - local_44], 0x0          # 004fba16
    mov dword ptr [ebp - local_40], 0x0          # 004fba1d
L_004fba24:
    # block 0x004fba24: entered by jmp at 0x004fba14, 22 instruction(s), calls FUN_004fc62d, ends with ret 0x4
    fld qword ptr [ebp - local_44]               # 004fba24
    fstp dword ptr [ebp - local_48]              # 004fba27
    fld dword ptr [ebp - local_48]               # 004fba2a
    mov ecx, dword ptr [ebp - local_4]           # 004fba2d
    and ecx, 0xffff                              # 004fba30
    imul ecx, ecx, 0x5bb                         # 004fba36
    mov edx, dword ptr [ebp - local_8]           # 004fba3c
    fstp dword ptr [edx + ecx + field_13c]       # 004fba3f
    push 0x1                                     # 004fba46
    push 0x0                                     # 004fba48
    mov eax, dword ptr [ebp + arg_8]             # 004fba4a
    movsx ecx, word ptr [eax + field_23]         # 004fba4d
    push ecx                                     # 004fba51
    mov edx, dword ptr [ebp + arg_8]             # 004fba52
    push edx                                     # 004fba55
    mov ax, word ptr [ebp - local_4]             # 004fba56
    push eax                                     # 004fba5a
    mov ecx, dword ptr [ebp - local_8]           # 004fba5b
    call FUN_004fc62d                            # 004fba5e
    {load} mov esp, ebp                          # 004fba63
    pop ebp                                      # 004fba65
    ret 0x4                                      # 004fba66

