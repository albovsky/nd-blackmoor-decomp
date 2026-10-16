# FUN_0049d755
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049d755
# extent:       0x0049d755-0x0049d945 (496 code bytes)
# span:         0x0049d755-0x0049d945 (code 496, tables 0, padding 0)
# sha256:       2c308ff626931a2e05fbc5717de2c24d57b8621ce58eadfd178504de5d927e40
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049d755
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_1c, field_e1c, field_e24; [ecx + n] field_e1c, field_e20, field_e24, field_e28; [edx + n] field_20, field_e1c, field_e20, field_e24, field_e28
# callees:      calls FUN_0050ce04, FUN_0049d945, FUN_004a0ec3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 134 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_e1c, 0xe1c  # offset +0xe1c
.equ field_e20, 0xe20  # offset +0xe20
.equ field_e24, 0xe24  # offset +0xe24
.equ field_e28, 0xe28  # offset +0xe28

# --- external targets -----------------------------------------------
.set FUN_0049d945, .text + (0x0049d945 - 0x401000)
.set FUN_004a0ec3, .text + (0x004a0ec3 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x0049d755 - 0x401000
.globl FUN_0049d755
FUN_0049d755:
    # block 0x0049d755: entry, 25 instruction(s), calls FUN_0050ce04, ends with jle to 0x0049d7c4 (forward)
    push ebp                                     # 0049d755
    {load} mov ebp, esp                          # 0049d756
    sub esp, 0x2c                                # 0049d758
    mov dword ptr [ebp - local_c], ecx           # 0049d75b
    mov eax, dword ptr [ebp - local_c]           # 0049d75e
    fild dword ptr [eax + field_1c]              # 0049d761
    fstp dword ptr [ebp - local_10]              # 0049d764
    fld dword ptr [ebp - local_10]               # 0049d767
    fdiv qword ptr [0x52c678]                    # 0049d76a
    fadd qword ptr [0x52cac0]                    # 0049d770
    call FUN_0050ce04                            # 0049d776
    mov ecx, dword ptr [ebp - local_c]           # 0049d77b
    mov dword ptr [ecx + field_e1c], eax         # 0049d77e
    mov edx, dword ptr [ebp - local_c]           # 0049d784
    fild dword ptr [edx + field_20]              # 0049d787
    fstp dword ptr [ebp - local_14]              # 0049d78a
    fld dword ptr [ebp - local_14]               # 0049d78d
    fdiv qword ptr [0x52c678]                    # 0049d790
    fadd qword ptr [0x52cac0]                    # 0049d796
    call FUN_0050ce04                            # 0049d79c
    mov ecx, dword ptr [ebp - local_c]           # 0049d7a1
    mov dword ptr [ecx + field_e20], eax         # 0049d7a4
    mov edx, dword ptr [ebp - local_c]           # 0049d7aa
    cmp dword ptr [edx + field_e1c], 0x2         # 0049d7ad
    jle.d8 L_0049d7c4                            # 0049d7b4
    # block 0x0049d7b6: entered by fall-through of jle at 0x0049d7b4, 4 instruction(s), ends with forward jump to 0x0049d7cb
    mov eax, dword ptr [ebp - local_c]           # 0049d7b6
    mov ecx, dword ptr [eax + field_e1c]         # 0049d7b9
    mov dword ptr [ebp - local_18], ecx          # 0049d7bf
    jmp.d8 L_0049d7cb                            # 0049d7c2
L_0049d7c4:
    # block 0x0049d7c4: entered by jle at 0x0049d7b4, 1 instruction(s), falls into the block at 0x0049d7cb
    mov dword ptr [ebp - local_18], 0x2          # 0049d7c4
L_0049d7cb:
    # block 0x0049d7cb: entered by jmp at 0x0049d7c2, 6 instruction(s), ends with jle to 0x0049d7f1 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0049d7cb
    mov eax, dword ptr [ebp - local_18]          # 0049d7ce
    mov dword ptr [edx + field_e1c], eax         # 0049d7d1
    mov ecx, dword ptr [ebp - local_c]           # 0049d7d7
    cmp dword ptr [ecx + field_e20], 0x2         # 0049d7da
    jle.d8 L_0049d7f1                            # 0049d7e1
    # block 0x0049d7e3: entered by fall-through of jle at 0x0049d7e1, 4 instruction(s), ends with forward jump to 0x0049d7f8
    mov edx, dword ptr [ebp - local_c]           # 0049d7e3
    mov eax, dword ptr [edx + field_e20]         # 0049d7e6
    mov dword ptr [ebp - local_1c], eax          # 0049d7ec
    jmp.d8 L_0049d7f8                            # 0049d7ef
L_0049d7f1:
    # block 0x0049d7f1: entered by jle at 0x0049d7e1, 1 instruction(s), falls into the block at 0x0049d7f8
    mov dword ptr [ebp - local_1c], 0x2          # 0049d7f1
L_0049d7f8:
    # block 0x0049d7f8: entered by jmp at 0x0049d7ef, 24 instruction(s), calls FUN_0050ce04, ends with jle to 0x0049d870 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0049d7f8
    mov edx, dword ptr [ebp - local_1c]          # 0049d7fb
    mov dword ptr [ecx + field_e20], edx         # 0049d7fe
    mov eax, dword ptr [ebp - local_c]           # 0049d804
    fild dword ptr [eax + field_e1c]             # 0049d807
    fstp dword ptr [ebp - local_20]              # 0049d80d
    fld dword ptr [ebp - local_20]               # 0049d810
    fdiv qword ptr [0x52c678]                    # 0049d813
    fadd qword ptr [0x52cac0]                    # 0049d819
    call FUN_0050ce04                            # 0049d81f
    mov ecx, dword ptr [ebp - local_c]           # 0049d824
    mov dword ptr [ecx + field_e24], eax         # 0049d827
    mov edx, dword ptr [ebp - local_c]           # 0049d82d
    fild dword ptr [edx + field_e20]             # 0049d830
    fstp dword ptr [ebp - local_24]              # 0049d836
    fld dword ptr [ebp - local_24]               # 0049d839
    fdiv qword ptr [0x52c678]                    # 0049d83c
    fadd qword ptr [0x52cac0]                    # 0049d842
    call FUN_0050ce04                            # 0049d848
    mov ecx, dword ptr [ebp - local_c]           # 0049d84d
    mov dword ptr [ecx + field_e28], eax         # 0049d850
    mov edx, dword ptr [ebp - local_c]           # 0049d856
    cmp dword ptr [edx + field_e24], 0x1         # 0049d859
    jle.d8 L_0049d870                            # 0049d860
    # block 0x0049d862: entered by fall-through of jle at 0x0049d860, 4 instruction(s), ends with forward jump to 0x0049d877
    mov eax, dword ptr [ebp - local_c]           # 0049d862
    mov ecx, dword ptr [eax + field_e24]         # 0049d865
    mov dword ptr [ebp - local_28], ecx          # 0049d86b
    jmp.d8 L_0049d877                            # 0049d86e
L_0049d870:
    # block 0x0049d870: entered by jle at 0x0049d860, 1 instruction(s), falls into the block at 0x0049d877
    mov dword ptr [ebp - local_28], 0x1          # 0049d870
L_0049d877:
    # block 0x0049d877: entered by jmp at 0x0049d86e, 6 instruction(s), ends with jle to 0x0049d89d (forward)
    mov edx, dword ptr [ebp - local_c]           # 0049d877
    mov eax, dword ptr [ebp - local_28]          # 0049d87a
    mov dword ptr [edx + field_e24], eax         # 0049d87d
    mov ecx, dword ptr [ebp - local_c]           # 0049d883
    cmp dword ptr [ecx + field_e28], 0x1         # 0049d886
    jle.d8 L_0049d89d                            # 0049d88d
    # block 0x0049d88f: entered by fall-through of jle at 0x0049d88d, 4 instruction(s), ends with forward jump to 0x0049d8a4
    mov edx, dword ptr [ebp - local_c]           # 0049d88f
    mov eax, dword ptr [edx + field_e28]         # 0049d892
    mov dword ptr [ebp - local_2c], eax          # 0049d898
    jmp.d8 L_0049d8a4                            # 0049d89b
L_0049d89d:
    # block 0x0049d89d: entered by jle at 0x0049d88d, 1 instruction(s), falls into the block at 0x0049d8a4
    mov dword ptr [ebp - local_2c], 0x1          # 0049d89d
L_0049d8a4:
    # block 0x0049d8a4: entered by jmp at 0x0049d89b, 53 instruction(s), calls FUN_0049d945, FUN_004a0ec3, ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0049d8a4
    mov edx, dword ptr [ebp - local_2c]          # 0049d8a7
    mov dword ptr [ecx + field_e28], edx         # 0049d8aa
    mov dword ptr [ebp - local_4], 0x1           # 0049d8b0
    mov eax, dword ptr [ebp - local_4]           # 0049d8b7
    push eax                                     # 0049d8ba
    push 0x0                                     # 0049d8bb
    push 0x0                                     # 0049d8bd
    mov ecx, dword ptr [ebp - local_c]           # 0049d8bf
    call FUN_0049d945                            # 0049d8c2
    mov ecx, dword ptr [ebp - local_4]           # 0049d8c7
    add ecx, 0x1                                 # 0049d8ca
    mov dword ptr [ebp - local_4], ecx           # 0049d8cd
    mov edx, dword ptr [ebp - local_4]           # 0049d8d0
    push edx                                     # 0049d8d3
    mov eax, dword ptr [ebp - local_c]           # 0049d8d4
    mov ecx, dword ptr [eax + field_e1c]         # 0049d8d7
    push ecx                                     # 0049d8dd
    push 0x0                                     # 0049d8de
    mov ecx, dword ptr [ebp - local_c]           # 0049d8e0
    call FUN_0049d945                            # 0049d8e3
    mov edx, dword ptr [ebp - local_4]           # 0049d8e8
    add edx, 0x1                                 # 0049d8eb
    mov dword ptr [ebp - local_4], edx           # 0049d8ee
    mov eax, dword ptr [ebp - local_4]           # 0049d8f1
    push eax                                     # 0049d8f4
    push 0x0                                     # 0049d8f5
    mov ecx, dword ptr [ebp - local_c]           # 0049d8f7
    mov edx, dword ptr [ecx + field_e20]         # 0049d8fa
    push edx                                     # 0049d900
    mov ecx, dword ptr [ebp - local_c]           # 0049d901
    call FUN_0049d945                            # 0049d904
    mov eax, dword ptr [ebp - local_4]           # 0049d909
    add eax, 0x1                                 # 0049d90c
    mov dword ptr [ebp - local_4], eax           # 0049d90f
    mov ecx, dword ptr [ebp - local_4]           # 0049d912
    push ecx                                     # 0049d915
    mov edx, dword ptr [ebp - local_c]           # 0049d916
    mov eax, dword ptr [edx + field_e1c]         # 0049d919
    push eax                                     # 0049d91f
    mov ecx, dword ptr [ebp - local_c]           # 0049d920
    mov edx, dword ptr [ecx + field_e20]         # 0049d923
    push edx                                     # 0049d929
    mov ecx, dword ptr [ebp - local_c]           # 0049d92a
    call FUN_0049d945                            # 0049d92d
    mov dword ptr [ebp - local_8], eax           # 0049d932
    mov eax, dword ptr [ebp - local_8]           # 0049d935
    push eax                                     # 0049d938
    mov ecx, dword ptr [ebp - local_c]           # 0049d939
    call FUN_004a0ec3                            # 0049d93c
    {load} mov esp, ebp                          # 0049d941
    pop ebp                                      # 0049d943
    ret                                          # 0049d944

