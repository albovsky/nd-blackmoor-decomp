# FUN_004bb775
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bb775
# extent:       0x004bb775-0x004bbb3e (969 code bytes)
# span:         0x004bb775-0x004bbb3e (code 969, tables 0, padding 0)
# sha256:       75e6f57db0b5f7069a7e717f5bbda611f12200e05a56d3335f7a7e606915c9d8
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bb775
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       22 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 10 more
# fields:       [eax + n] field_20, field_38, field_3c, field_4c, field_d8, field_128, field_12c, field_1c4, field_1c8, field_1f4, field_200, field_902; [ecx + n] field_18, field_20, field_30, field_40, field_4c, field_dc, field_e0, field_e4, field_e8, field_128, field_1bc, field_1c0 and 3 more; [edx + n] field_18, field_38, field_48, field_88, field_12c, field_150, field_1bc, field_1c0, field_1c4, field_91e
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004be3d3, FUN_0050ce04, FUN_004be410
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 274 instruction(s), 46 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ field_18, 0x18  # offset +0x18
.equ field_20, 0x20  # offset +0x20
.equ field_30, 0x30  # offset +0x30
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_88, 0x88  # offset +0x88
.equ field_d8, 0xd8  # offset +0xd8
.equ field_dc, 0xdc  # offset +0xdc
.equ field_e0, 0xe0  # offset +0xe0
.equ field_e4, 0xe4  # offset +0xe4
.equ field_e8, 0xe8  # offset +0xe8
.equ field_128, 0x128  # offset +0x128
.equ field_12c, 0x12c  # offset +0x12c
.equ field_150, 0x150  # offset +0x150
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8
.equ field_1f4, 0x1f4  # offset +0x1f4
.equ field_200, 0x200  # offset +0x200
.equ field_2d8, 0x2d8  # offset +0x2d8
.equ field_902, 0x902  # offset +0x902
.equ field_91e, 0x91e  # offset +0x91e

# --- external targets -----------------------------------------------
.set FUN_004be3d3, .text + (0x004be3d3 - 0x401000)
.set FUN_004be410, .text + (0x004be410 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004bb775 - 0x401000
.globl FUN_004bb775
FUN_004bb775:
    # block 0x004bb775: entry, 7 instruction(s), ends with jne to 0x004bb7a2 (forward)
    push ebp                                     # 004bb775
    {load} mov ebp, esp                          # 004bb776
    sub esp, 0x58                                # 004bb778
    mov dword ptr [ebp - local_50], ecx          # 004bb77b
    mov eax, dword ptr [ebp - local_50]          # 004bb77e
    cmp dword ptr [eax + field_20], 0x0          # 004bb781
    jne.d8 L_004bb7a2                            # 004bb785
    # block 0x004bb787: entered by fall-through of jne at 0x004bb785, 3 instruction(s), ends with jne to 0x004bb7a2 (forward)
    mov ecx, dword ptr [ebp - local_50]          # 004bb787
    cmp dword ptr [ecx + field_40], 0x0          # 004bb78a
    jne.d8 L_004bb7a2                            # 004bb78e
    # block 0x004bb790: entered by fall-through of jne at 0x004bb78e, 3 instruction(s), ends with jne to 0x004bb7a2 (forward)
    mov edx, dword ptr [ebp - local_50]          # 004bb790
    cmp dword ptr [edx + field_38], 0x0          # 004bb793
    jne.d8 L_004bb7a2                            # 004bb797
    # block 0x004bb799: entered by fall-through of jne at 0x004bb797, 3 instruction(s), ends with je to 0x004bb7a7 (forward)
    mov eax, dword ptr [ebp - local_50]          # 004bb799
    cmp dword ptr [eax + field_3c], 0x0          # 004bb79c
    je.d8 L_004bb7a7                             # 004bb7a0
L_004bb7a2:
    # block 0x004bb7a2: entered by jne at 0x004bb785; jne at 0x004bb78e; jne at 0x004bb797; fall-through of je at 0x004bb7a0, 1 instruction(s), ends with forward jump to 0x004bbb3a
    jmp.d32 L_004bbb3a                           # 004bb7a2
L_004bb7a7:
    # block 0x004bb7a7: entered by je at 0x004bb7a0, 30 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004bbb3a (forward)
    call dword ptr [0x52a23c]                    # 004bb7a7
    mov ecx, dword ptr [ebp - local_50]          # 004bb7ad
    mov dword ptr [ecx + field_2d8], eax         # 004bb7b0
    mov edx, dword ptr [ebp - local_50]          # 004bb7b6
    mov eax, dword ptr [edx + field_1bc]         # 004bb7b9
    mov dword ptr [ebp - local_8], eax           # 004bb7bf
    mov ecx, dword ptr [ebp - local_50]          # 004bb7c2
    mov edx, dword ptr [ecx + field_1c0]         # 004bb7c5
    mov dword ptr [ebp - local_4], edx           # 004bb7cb
    mov eax, dword ptr [ebp - local_50]          # 004bb7ce
    mov ecx, dword ptr [eax + field_1c4]         # 004bb7d1
    mov dword ptr [ebp - local_10], ecx          # 004bb7d7
    mov edx, dword ptr [ebp - local_50]          # 004bb7da
    mov eax, dword ptr [edx + field_1c0]         # 004bb7dd
    mov dword ptr [ebp - local_c], eax           # 004bb7e3
    mov ecx, dword ptr [ebp - local_50]          # 004bb7e6
    mov edx, dword ptr [ecx + field_1bc]         # 004bb7e9
    mov dword ptr [ebp - local_18], edx          # 004bb7ef
    mov eax, dword ptr [ebp - local_50]          # 004bb7f2
    mov ecx, dword ptr [eax + field_1c8]         # 004bb7f5
    mov dword ptr [ebp - local_14], ecx          # 004bb7fb
    mov edx, dword ptr [ebp - local_50]          # 004bb7fe
    mov eax, dword ptr [edx + field_1c4]         # 004bb801
    mov dword ptr [ebp - local_20], eax          # 004bb807
    mov ecx, dword ptr [ebp - local_50]          # 004bb80a
    mov edx, dword ptr [ecx + field_1c8]         # 004bb80d
    mov dword ptr [ebp - local_1c], edx          # 004bb813
    mov eax, dword ptr [ebp - local_50]          # 004bb816
    cmp dword ptr [eax + field_4c], 0x0          # 004bb819
    je.d32 L_004bbb3a                            # 004bb81d
    # block 0x004bb823: entered by fall-through of je at 0x004bb81d, 3 instruction(s), falls into the block at 0x004bb82c
    mov ecx, dword ptr [ebp - local_50]          # 004bb823
    mov edx, dword ptr [ecx + field_4c]          # 004bb826
    mov dword ptr [ebp - local_38], edx          # 004bb829
L_004bb82c:
    # block 0x004bb82c: entered by jmp at 0x004bbb35, 2 instruction(s), ends with je to 0x004bbb3a (forward)
    cmp dword ptr [ebp - local_38], 0x0          # 004bb82c
    je.d32 L_004bbb3a                            # 004bb830
    # block 0x004bb836: entered by fall-through of je at 0x004bb830, 3 instruction(s), ends with jne to 0x004bbb29 (forward)
    mov eax, dword ptr [ebp - local_38]          # 004bb836
    cmp dword ptr [eax + field_12c], 0x0         # 004bb839
    jne.d32 L_004bbb29                           # 004bb840
    # block 0x004bb846: entered by fall-through of jne at 0x004bb840, 3 instruction(s), ends with forward jump to 0x004bb85f
    mov dword ptr [ebp - local_4c], 0x0          # 004bb846
    mov dword ptr [ebp - local_34], 0x0          # 004bb84d
    jmp.d8 L_004bb85f                            # 004bb854
L_004bb856:
    # block 0x004bb856: entered by jmp at 0x004bb88f; jmp at 0x004bba3e, 3 instruction(s), falls into the block at 0x004bb85f
    mov ecx, dword ptr [ebp - local_34]          # 004bb856
    add ecx, 0x1                                 # 004bb859
    mov dword ptr [ebp - local_34], ecx          # 004bb85c
L_004bb85f:
    # block 0x004bb85f: entered by jmp at 0x004bb854, 2 instruction(s), ends with jge to 0x004bba43 (forward)
    cmp dword ptr [ebp - local_34], 0x4          # 004bb85f
    jge.d32 L_004bba43                           # 004bb863
    # block 0x004bb869: entered by fall-through of jge at 0x004bb863, 5 instruction(s), ends with je to 0x004bb88f (forward)
    mov edx, dword ptr [ebp - local_34]          # 004bb869
    imul edx, edx, 0x14                          # 004bb86c
    mov eax, dword ptr [ebp - local_38]          # 004bb86f
    cmp dword ptr [eax + edx + field_d8], 0x0    # 004bb872
    je.d8 L_004bb88f                             # 004bb87a
    # block 0x004bb87c: entered by fall-through of je at 0x004bb87a, 5 instruction(s), ends with jne to 0x004bb891 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004bb87c
    imul ecx, ecx, 0x14                          # 004bb87f
    mov edx, dword ptr [ebp - local_38]          # 004bb882
    cmp dword ptr [edx + ecx + field_88], 0x0    # 004bb885
    jne.d8 L_004bb891                            # 004bb88d
L_004bb88f:
    # block 0x004bb88f: entered by je at 0x004bb87a; fall-through of jne at 0x004bb88d, 1 instruction(s), ends with backward jump to 0x004bb856
    jmp.d8 L_004bb856                            # 004bb88f
L_004bb891:
    # block 0x004bb891: entered by jne at 0x004bb88d, 43 instruction(s), ends with jl to 0x004bb949 (forward)
    mov eax, dword ptr [ebp - local_34]          # 004bb891
    imul eax, eax, 0x14                          # 004bb894
    mov ecx, dword ptr [ebp - local_38]          # 004bb897
    mov edx, dword ptr [ecx + eax + field_dc]    # 004bb89a
    mov dword ptr [ebp - local_48], edx          # 004bb8a1
    mov eax, dword ptr [ebp - local_34]          # 004bb8a4
    imul eax, eax, 0x14                          # 004bb8a7
    mov ecx, dword ptr [ebp - local_38]          # 004bb8aa
    mov edx, dword ptr [ecx + eax + field_e0]    # 004bb8ad
    mov dword ptr [ebp - local_44], edx          # 004bb8b4
    mov eax, dword ptr [ebp - local_34]          # 004bb8b7
    imul eax, eax, 0x14                          # 004bb8ba
    mov ecx, dword ptr [ebp - local_38]          # 004bb8bd
    mov edx, dword ptr [ecx + eax + field_e4]    # 004bb8c0
    mov dword ptr [ebp - local_40], edx          # 004bb8c7
    mov eax, dword ptr [ebp - local_34]          # 004bb8ca
    imul eax, eax, 0x14                          # 004bb8cd
    mov ecx, dword ptr [ebp - local_38]          # 004bb8d0
    mov edx, dword ptr [ecx + eax + field_e0]    # 004bb8d3
    mov dword ptr [ebp - local_3c], edx          # 004bb8da
    mov eax, dword ptr [ebp - local_34]          # 004bb8dd
    imul eax, eax, 0x14                          # 004bb8e0
    mov ecx, dword ptr [ebp - local_38]          # 004bb8e3
    mov edx, dword ptr [ecx + eax + field_dc]    # 004bb8e6
    mov dword ptr [ebp - local_30], edx          # 004bb8ed
    mov eax, dword ptr [ebp - local_34]          # 004bb8f0
    imul eax, eax, 0x14                          # 004bb8f3
    mov ecx, dword ptr [ebp - local_38]          # 004bb8f6
    mov edx, dword ptr [ecx + eax + field_e8]    # 004bb8f9
    mov dword ptr [ebp - local_2c], edx          # 004bb900
    mov eax, dword ptr [ebp - local_34]          # 004bb903
    imul eax, eax, 0x14                          # 004bb906
    mov ecx, dword ptr [ebp - local_38]          # 004bb909
    mov edx, dword ptr [ecx + eax + field_e4]    # 004bb90c
    mov dword ptr [ebp - local_28], edx          # 004bb913
    mov eax, dword ptr [ebp - local_34]          # 004bb916
    imul eax, eax, 0x14                          # 004bb919
    mov ecx, dword ptr [ebp - local_38]          # 004bb91c
    mov edx, dword ptr [ecx + eax + field_e8]    # 004bb91f
    mov dword ptr [ebp - local_24], edx          # 004bb926
    mov eax, dword ptr [ebp - local_8]           # 004bb929
    cmp eax, dword ptr [ebp - local_48]          # 004bb92c
    jl.d8 L_004bb949                             # 004bb92f
    # block 0x004bb931: entered by fall-through of jl at 0x004bb92f, 3 instruction(s), ends with jg to 0x004bb949 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004bb931
    cmp ecx, dword ptr [ebp - local_40]          # 004bb934
    jg.d8 L_004bb949                             # 004bb937
    # block 0x004bb939: entered by fall-through of jg at 0x004bb937, 3 instruction(s), ends with jl to 0x004bb949 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004bb939
    cmp edx, dword ptr [ebp - local_44]          # 004bb93c
    jl.d8 L_004bb949                             # 004bb93f
    # block 0x004bb941: entered by fall-through of jl at 0x004bb93f, 3 instruction(s), ends with jle to 0x004bb9a9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bb941
    cmp eax, dword ptr [ebp - local_2c]          # 004bb944
    jle.d8 L_004bb9a9                            # 004bb947
L_004bb949:
    # block 0x004bb949: entered by jl at 0x004bb92f; jg at 0x004bb937; jl at 0x004bb93f; fall-through of jle at 0x004bb947, 3 instruction(s), ends with jl to 0x004bb969 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004bb949
    cmp ecx, dword ptr [ebp - local_48]          # 004bb94c
    jl.d8 L_004bb969                             # 004bb94f
    # block 0x004bb951: entered by fall-through of jl at 0x004bb94f, 3 instruction(s), ends with jg to 0x004bb969 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004bb951
    cmp edx, dword ptr [ebp - local_40]          # 004bb954
    jg.d8 L_004bb969                             # 004bb957
    # block 0x004bb959: entered by fall-through of jg at 0x004bb957, 3 instruction(s), ends with jl to 0x004bb969 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004bb959
    cmp eax, dword ptr [ebp - local_44]          # 004bb95c
    jl.d8 L_004bb969                             # 004bb95f
    # block 0x004bb961: entered by fall-through of jl at 0x004bb95f, 3 instruction(s), ends with jle to 0x004bb9a9 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004bb961
    cmp ecx, dword ptr [ebp - local_2c]          # 004bb964
    jle.d8 L_004bb9a9                            # 004bb967
L_004bb969:
    # block 0x004bb969: entered by jl at 0x004bb94f; jg at 0x004bb957; jl at 0x004bb95f; fall-through of jle at 0x004bb967, 3 instruction(s), ends with jl to 0x004bb989 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004bb969
    cmp edx, dword ptr [ebp - local_48]          # 004bb96c
    jl.d8 L_004bb989                             # 004bb96f
    # block 0x004bb971: entered by fall-through of jl at 0x004bb96f, 3 instruction(s), ends with jg to 0x004bb989 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004bb971
    cmp eax, dword ptr [ebp - local_40]          # 004bb974
    jg.d8 L_004bb989                             # 004bb977
    # block 0x004bb979: entered by fall-through of jg at 0x004bb977, 3 instruction(s), ends with jl to 0x004bb989 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004bb979
    cmp ecx, dword ptr [ebp - local_44]          # 004bb97c
    jl.d8 L_004bb989                             # 004bb97f
    # block 0x004bb981: entered by fall-through of jl at 0x004bb97f, 3 instruction(s), ends with jle to 0x004bb9a9 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004bb981
    cmp edx, dword ptr [ebp - local_2c]          # 004bb984
    jle.d8 L_004bb9a9                            # 004bb987
L_004bb989:
    # block 0x004bb989: entered by jl at 0x004bb96f; jg at 0x004bb977; jl at 0x004bb97f; fall-through of jle at 0x004bb987, 3 instruction(s), ends with jl to 0x004bb9b5 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004bb989
    cmp eax, dword ptr [ebp - local_48]          # 004bb98c
    jl.d8 L_004bb9b5                             # 004bb98f
    # block 0x004bb991: entered by fall-through of jl at 0x004bb98f, 3 instruction(s), ends with jg to 0x004bb9b5 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004bb991
    cmp ecx, dword ptr [ebp - local_40]          # 004bb994
    jg.d8 L_004bb9b5                             # 004bb997
    # block 0x004bb999: entered by fall-through of jg at 0x004bb997, 3 instruction(s), ends with jl to 0x004bb9b5 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004bb999
    cmp edx, dword ptr [ebp - local_44]          # 004bb99c
    jl.d8 L_004bb9b5                             # 004bb99f
    # block 0x004bb9a1: entered by fall-through of jl at 0x004bb99f, 3 instruction(s), ends with jg to 0x004bb9b5 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004bb9a1
    cmp eax, dword ptr [ebp - local_2c]          # 004bb9a4
    jg.d8 L_004bb9b5                             # 004bb9a7
L_004bb9a9:
    # block 0x004bb9a9: entered by jle at 0x004bb947; jle at 0x004bb967; jle at 0x004bb987; fall-through of jg at 0x004bb9a7, 2 instruction(s), ends with forward jump to 0x004bba43
    mov dword ptr [ebp - local_4c], 0x1          # 004bb9a9
    jmp.d32 L_004bba43                           # 004bb9b0
L_004bb9b5:
    # block 0x004bb9b5: entered by jl at 0x004bb98f; jg at 0x004bb997; jl at 0x004bb99f; jg at 0x004bb9a7, 3 instruction(s), ends with jl to 0x004bb9d5 (forward)
    mov ecx, dword ptr [ebp - local_48]          # 004bb9b5
    cmp ecx, dword ptr [ebp - local_8]           # 004bb9b8
    jl.d8 L_004bb9d5                             # 004bb9bb
    # block 0x004bb9bd: entered by fall-through of jl at 0x004bb9bb, 3 instruction(s), ends with jg to 0x004bb9d5 (forward)
    mov edx, dword ptr [ebp - local_48]          # 004bb9bd
    cmp edx, dword ptr [ebp - local_10]          # 004bb9c0
    jg.d8 L_004bb9d5                             # 004bb9c3
    # block 0x004bb9c5: entered by fall-through of jg at 0x004bb9c3, 3 instruction(s), ends with jl to 0x004bb9d5 (forward)
    mov eax, dword ptr [ebp - local_44]          # 004bb9c5
    cmp eax, dword ptr [ebp - local_4]           # 004bb9c8
    jl.d8 L_004bb9d5                             # 004bb9cb
    # block 0x004bb9cd: entered by fall-through of jl at 0x004bb9cb, 3 instruction(s), ends with jle to 0x004bba35 (forward)
    mov ecx, dword ptr [ebp - local_44]          # 004bb9cd
    cmp ecx, dword ptr [ebp - local_14]          # 004bb9d0
    jle.d8 L_004bba35                            # 004bb9d3
L_004bb9d5:
    # block 0x004bb9d5: entered by jl at 0x004bb9bb; jg at 0x004bb9c3; jl at 0x004bb9cb; fall-through of jle at 0x004bb9d3, 3 instruction(s), ends with jl to 0x004bb9f5 (forward)
    mov edx, dword ptr [ebp - local_40]          # 004bb9d5
    cmp edx, dword ptr [ebp - local_8]           # 004bb9d8
    jl.d8 L_004bb9f5                             # 004bb9db
    # block 0x004bb9dd: entered by fall-through of jl at 0x004bb9db, 3 instruction(s), ends with jg to 0x004bb9f5 (forward)
    mov eax, dword ptr [ebp - local_40]          # 004bb9dd
    cmp eax, dword ptr [ebp - local_10]          # 004bb9e0
    jg.d8 L_004bb9f5                             # 004bb9e3
    # block 0x004bb9e5: entered by fall-through of jg at 0x004bb9e3, 3 instruction(s), ends with jl to 0x004bb9f5 (forward)
    mov ecx, dword ptr [ebp - local_3c]          # 004bb9e5
    cmp ecx, dword ptr [ebp - local_4]           # 004bb9e8
    jl.d8 L_004bb9f5                             # 004bb9eb
    # block 0x004bb9ed: entered by fall-through of jl at 0x004bb9eb, 3 instruction(s), ends with jle to 0x004bba35 (forward)
    mov edx, dword ptr [ebp - local_3c]          # 004bb9ed
    cmp edx, dword ptr [ebp - local_14]          # 004bb9f0
    jle.d8 L_004bba35                            # 004bb9f3
L_004bb9f5:
    # block 0x004bb9f5: entered by jl at 0x004bb9db; jg at 0x004bb9e3; jl at 0x004bb9eb; fall-through of jle at 0x004bb9f3, 3 instruction(s), ends with jl to 0x004bba15 (forward)
    mov eax, dword ptr [ebp - local_30]          # 004bb9f5
    cmp eax, dword ptr [ebp - local_8]           # 004bb9f8
    jl.d8 L_004bba15                             # 004bb9fb
    # block 0x004bb9fd: entered by fall-through of jl at 0x004bb9fb, 3 instruction(s), ends with jg to 0x004bba15 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 004bb9fd
    cmp ecx, dword ptr [ebp - local_10]          # 004bba00
    jg.d8 L_004bba15                             # 004bba03
    # block 0x004bba05: entered by fall-through of jg at 0x004bba03, 3 instruction(s), ends with jl to 0x004bba15 (forward)
    mov edx, dword ptr [ebp - local_2c]          # 004bba05
    cmp edx, dword ptr [ebp - local_4]           # 004bba08
    jl.d8 L_004bba15                             # 004bba0b
    # block 0x004bba0d: entered by fall-through of jl at 0x004bba0b, 3 instruction(s), ends with jle to 0x004bba35 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 004bba0d
    cmp eax, dword ptr [ebp - local_14]          # 004bba10
    jle.d8 L_004bba35                            # 004bba13
L_004bba15:
    # block 0x004bba15: entered by jl at 0x004bb9fb; jg at 0x004bba03; jl at 0x004bba0b; fall-through of jle at 0x004bba13, 3 instruction(s), ends with jl to 0x004bba3e (forward)
    mov ecx, dword ptr [ebp - local_28]          # 004bba15
    cmp ecx, dword ptr [ebp - local_8]           # 004bba18
    jl.d8 L_004bba3e                             # 004bba1b
    # block 0x004bba1d: entered by fall-through of jl at 0x004bba1b, 3 instruction(s), ends with jg to 0x004bba3e (forward)
    mov edx, dword ptr [ebp - local_28]          # 004bba1d
    cmp edx, dword ptr [ebp - local_10]          # 004bba20
    jg.d8 L_004bba3e                             # 004bba23
    # block 0x004bba25: entered by fall-through of jg at 0x004bba23, 3 instruction(s), ends with jl to 0x004bba3e (forward)
    mov eax, dword ptr [ebp - local_24]          # 004bba25
    cmp eax, dword ptr [ebp - local_4]           # 004bba28
    jl.d8 L_004bba3e                             # 004bba2b
    # block 0x004bba2d: entered by fall-through of jl at 0x004bba2b, 3 instruction(s), ends with jg to 0x004bba3e (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004bba2d
    cmp ecx, dword ptr [ebp - local_14]          # 004bba30
    jg.d8 L_004bba3e                             # 004bba33
L_004bba35:
    # block 0x004bba35: entered by jle at 0x004bb9d3; jle at 0x004bb9f3; jle at 0x004bba13; fall-through of jg at 0x004bba33, 2 instruction(s), ends with forward jump to 0x004bba43
    mov dword ptr [ebp - local_4c], 0x1          # 004bba35
    jmp.d8 L_004bba43                            # 004bba3c
L_004bba3e:
    # block 0x004bba3e: entered by jl at 0x004bba1b; jg at 0x004bba23; jl at 0x004bba2b; jg at 0x004bba33, 1 instruction(s), ends with backward jump to 0x004bb856
    jmp.d32 L_004bb856                           # 004bba3e
L_004bba43:
    # block 0x004bba43: entered by jge at 0x004bb863; jmp at 0x004bb9b0; jmp at 0x004bba3c, 2 instruction(s), ends with je to 0x004bbb29 (forward)
    cmp dword ptr [ebp - local_4c], 0x0          # 004bba43
    je.d32 L_004bbb29                            # 004bba47
    # block 0x004bba4d: entered by fall-through of je at 0x004bba47, 3 instruction(s), ends with jne to 0x004bbae8 (forward)
    mov edx, dword ptr [ebp - local_38]          # 004bba4d
    cmp dword ptr [edx + field_38], 0x0          # 004bba50
    jne.d32 L_004bbae8                           # 004bba54
    # block 0x004bba5a: entered by fall-through of jne at 0x004bba54, 30 instruction(s), calls FUN_004be3d3, FUN_0050ce04, ends with jl to 0x004bbae6 (forward)
    mov eax, dword ptr [ebp - local_50]          # 004bba5a
    mov dword ptr [eax + field_20], 0x2          # 004bba5d
    mov ecx, dword ptr [ebp - local_50]          # 004bba64
    call FUN_004be3d3                            # 004bba67
    mov ecx, dword ptr [ebp - local_50]          # 004bba6c
    fild dword ptr [ecx + field_1f4]             # 004bba6f
    fstp dword ptr [ebp - local_54]              # 004bba75
    mov edx, dword ptr [ebp - local_50]          # 004bba78
    mov eax, dword ptr [edx + field_18]          # 004bba7b
    mov ecx, dword ptr [ebp - local_38]          # 004bba7e
    mov edx, dword ptr [ecx + field_30]          # 004bba81
    fild dword ptr [eax + 4*edx + field_902]     # 004bba84
    fstp dword ptr [ebp - local_58]              # 004bba8b
    mov eax, dword ptr [ebp - local_50]          # 004bba8e
    fld dword ptr [ebp - local_58]               # 004bba91
    fmul dword ptr [eax + field_200]             # 004bba94
    fadd dword ptr [ebp - local_54]              # 004bba9a
    call FUN_0050ce04                            # 004bba9d
    mov ecx, dword ptr [ebp - local_50]          # 004bbaa2
    mov dword ptr [ecx + field_1f4], eax         # 004bbaa5
    mov edx, dword ptr [ebp - local_38]          # 004bbaab
    mov dword ptr [edx + field_12c], 0x1         # 004bbaae
    mov eax, dword ptr [ebp - local_38]          # 004bbab8
    mov dword ptr [eax + field_128], 0x1         # 004bbabb
    mov ecx, dword ptr [ebp - local_50]          # 004bbac5
    mov edx, dword ptr [ecx + field_18]          # 004bbac8
    mov eax, dword ptr [ebp - local_50]          # 004bbacb
    mov ecx, dword ptr [eax + field_1f4]         # 004bbace
    cmp ecx, dword ptr [edx + field_91e]         # 004bbad4
    jl.d8 L_004bbae6                             # 004bbada
    # block 0x004bbadc: entered by fall-through of jl at 0x004bbada, 2 instruction(s), falls into the block at 0x004bbae6
    mov edx, dword ptr [ebp - local_50]          # 004bbadc
    mov dword ptr [edx + field_38], 0x1          # 004bbadf
L_004bbae6:
    # block 0x004bbae6: entered by jl at 0x004bbada, 1 instruction(s), ends with forward jump to 0x004bbb3a
    jmp.d8 L_004bbb3a                            # 004bbae6
L_004bbae8:
    # block 0x004bbae8: entered by jne at 0x004bba54, 3 instruction(s), ends with jne to 0x004bbb29 (forward)
    mov eax, dword ptr [ebp - local_38]          # 004bbae8
    cmp dword ptr [eax + field_38], 0x1          # 004bbaeb
    jne.d8 L_004bbb29                            # 004bbaef
    # block 0x004bbaf1: entered by fall-through of jne at 0x004bbaef, 11 instruction(s), calls FUN_004be410, ends with forward jump to 0x004bbb3a
    mov ecx, dword ptr [ebp - local_50]          # 004bbaf1
    mov dword ptr [ecx + field_20], 0x3          # 004bbaf4
    mov edx, dword ptr [ebp - local_50]          # 004bbafb
    mov dword ptr [edx + field_48], 0x1          # 004bbafe
    mov ecx, dword ptr [ebp - local_50]          # 004bbb05
    call FUN_004be410                            # 004bbb08
    mov eax, dword ptr [ebp - local_38]          # 004bbb0d
    mov dword ptr [eax + field_12c], 0x1         # 004bbb10
    mov ecx, dword ptr [ebp - local_38]          # 004bbb1a
    mov dword ptr [ecx + field_128], 0x1         # 004bbb1d
    jmp.d8 L_004bbb3a                            # 004bbb27
L_004bbb29:
    # block 0x004bbb29: entered by jne at 0x004bb840; je at 0x004bba47; jne at 0x004bbaef, 4 instruction(s), ends with backward jump to 0x004bb82c
    mov edx, dword ptr [ebp - local_38]          # 004bbb29
    mov eax, dword ptr [edx + field_150]         # 004bbb2c
    mov dword ptr [ebp - local_38], eax          # 004bbb32
    jmp.d32 L_004bb82c                           # 004bbb35
L_004bbb3a:
    # block 0x004bbb3a: entered by jmp at 0x004bb7a2; je at 0x004bb81d; je at 0x004bb830; jmp at 0x004bbae6; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004bbb3a
    pop ebp                                      # 004bbb3c
    ret                                          # 004bbb3d

