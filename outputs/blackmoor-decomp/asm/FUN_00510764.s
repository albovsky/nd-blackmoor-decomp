# FUN_00510764
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510764
# extent:       0x00510764-0x0051080e (170 code bytes)
# span:         0x00510764-0x0051080e (code 170, tables 0, padding 0)
# sha256:       6b6f4ba8f66da6de9ee0c837ac0303a158f7a2deae507ac5b643ce26ff15289b
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510764
# arguments:    8 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_68, field_minus_c; [ecx + n] field_8; [esi + n] field_4, field_c, field_10
# callees:      calls FUN_00510dd3, FUN_0050c775, FUN_0050c8a0, FUN_00510909
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_0050c775, .text + (0x0050c775 - 0x401000)
.set FUN_0050c8a0, .text + (0x0050c8a0 - 0x401000)
.set FUN_00510909, .text + (0x00510909 - 0x401000)
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)

.org 0x00510764 - 0x401000
.globl FUN_00510764
FUN_00510764:
    # block 0x00510764: entry, 9 instruction(s), calls FUN_00510dd3, ends with je to 0x00510797 (forward)
    push ebp                                     # 00510764
    {load} mov ebp, esp                          # 00510765
    push ecx                                     # 00510767
    push ecx                                     # 00510768
    push esi                                     # 00510769
    push edi                                     # 0051076a
    call FUN_00510dd3                            # 0051076b
    cmp dword ptr [eax + field_68], 0x0          # 00510770
    je.d8 L_00510797                             # 00510774
    # block 0x00510776: entered by fall-through of je at 0x00510774, 11 instruction(s), calls FUN_0050c775, ends with jne to 0x0051080a (forward)
    push dword ptr [ebp + arg_24]                # 00510776
    push dword ptr [ebp + arg_20]                # 00510779
    push dword ptr [ebp + arg_18]                # 0051077c
    push dword ptr [ebp + arg_14]                # 0051077f
    push dword ptr [ebp + arg_10]                # 00510782
    push dword ptr [ebp + arg_c]                 # 00510785
    push dword ptr [ebp + arg_8]                 # 00510788
    call FUN_0050c775                            # 0051078b
    add esp, 0x1c                                # 00510790
    test eax, eax                                # 00510793
    jne.d8 L_0051080a                            # 00510795
L_00510797:
    # block 0x00510797: entered by je at 0x00510774; fall-through of jne at 0x00510795, 11 instruction(s), calls FUN_0050c8a0, falls into the block at 0x005107b3
    mov edi, dword ptr [ebp + arg_1c]            # 00510797
    lea eax, [ebp - local_8]                     # 0051079a
    push eax                                     # 0051079d
    lea eax, [ebp - local_4]                     # 0051079e
    push eax                                     # 005107a1
    push edi                                     # 005107a2
    push dword ptr [ebp + arg_20]                # 005107a3
    push dword ptr [ebp + arg_18]                # 005107a6
    call FUN_0050c8a0                            # 005107a9
    add esp, 0x14                                # 005107ae
    {load} mov esi, eax                          # 005107b1
L_005107b3:
    # block 0x005107b3: entered by jmp at 0x00510808, 3 instruction(s), ends with jae to 0x0051080a (forward)
    mov eax, dword ptr [ebp - local_4]           # 005107b3
    cmp eax, dword ptr [ebp - local_8]           # 005107b6
    jae.d8 L_0051080a                            # 005107b9
    # block 0x005107bb: entered by fall-through of jae at 0x005107b9, 2 instruction(s), ends with jl to 0x00510802 (forward)
    cmp edi, dword ptr [esi]                     # 005107bb
    jl.d8 L_00510802                             # 005107bd
    # block 0x005107bf: entered by fall-through of jl at 0x005107bd, 2 instruction(s), ends with jg to 0x00510802 (forward)
    cmp edi, dword ptr [esi + field_4]           # 005107bf
    jg.d8 L_00510802                             # 005107c2
    # block 0x005107c4: entered by fall-through of jg at 0x005107c2, 7 instruction(s), ends with je to 0x005107dc (forward)
    mov eax, dword ptr [esi + field_c]           # 005107c4
    mov ecx, dword ptr [esi + field_10]          # 005107c7
    shl eax, 0x4                                 # 005107ca
    {load} add eax, ecx                          # 005107cd
    mov ecx, dword ptr [eax - field_minus_c]     # 005107cf
    test ecx, ecx                                # 005107d2
    je.d8 L_005107dc                             # 005107d4
    # block 0x005107d6: entered by fall-through of je at 0x005107d4, 2 instruction(s), ends with jne to 0x00510802 (forward)
    cmp byte ptr [ecx + field_8], 0x0            # 005107d6
    jne.d8 L_00510802                            # 005107da
L_005107dc:
    # block 0x005107dc: entered by je at 0x005107d4; fall-through of jne at 0x005107da, 14 instruction(s), calls FUN_00510909, falls into the block at 0x00510802
    push 0x1                                     # 005107dc
    add eax, -0x10                               # 005107de
    push dword ptr [ebp + arg_24]                # 005107e1
    push dword ptr [ebp + arg_20]                # 005107e4
    push esi                                     # 005107e7
    push 0x0                                     # 005107e8
    push eax                                     # 005107ea
    push dword ptr [ebp + arg_18]                # 005107eb
    push dword ptr [ebp + arg_14]                # 005107ee
    push dword ptr [ebp + arg_10]                # 005107f1
    push dword ptr [ebp + arg_c]                 # 005107f4
    push dword ptr [ebp + arg_8]                 # 005107f7
    call FUN_00510909                            # 005107fa
    add esp, 0x2c                                # 005107ff
L_00510802:
    # block 0x00510802: entered by jl at 0x005107bd; jg at 0x005107c2; jne at 0x005107da, 3 instruction(s), ends with backward jump to 0x005107b3
    inc dword ptr [ebp - local_4]                # 00510802
    add esi, 0x14                                # 00510805
    jmp.d8 L_005107b3                            # 00510808
L_0051080a:
    # block 0x0051080a: entered by jne at 0x00510795; jae at 0x005107b9, 4 instruction(s), ends with ret
    pop edi                                      # 0051080a
    pop esi                                      # 0051080b
    leave                                        # 0051080c
    ret                                          # 0051080d

