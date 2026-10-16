# FUN_004497a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004497a0
# extent:       0x004497a0-0x00449a78 (728 code bytes)
# span:         0x004497a0-0x00449a78 (code 728, tables 0, padding 0)
# sha256:       93bbc611d8ae76a24de81d370be047ef43729ad73acb209c2284cb1aebf94586
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004497a0
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_c, local_70, local_74, local_78, local_7c, local_80, local_84, local_88, local_8c, local_90
# fields:       [eax + n] field_28, field_2c, field_36, field_3a, field_42, field_78; [ecx + n] field_24, field_28, field_36, field_3a, field_42; [edx + n] field_36, field_42, field_78
# callees:      calls FUN_0051dc43, FUN_00524aff, FUN_004264e8, FUN_004c97b4, FUN_0051ed8c, KERNEL32.dll!SetThreadPriority, KERNEL32.dll!ResumeThread, FUN_0050ca3e, FUN_0044a2b7; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 187 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_42, 0x42  # offset +0x42
.equ field_78, 0x78  # offset +0x78

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051ed8c, .text + (0x0051ed8c - 0x401000)
.set FUN_00524aff, .text + (0x00524aff - 0x401000)

.org 0x004497a0 - 0x401000
.globl FUN_004497a0
FUN_004497a0:
    # block 0x004497a0: entry, 47 instruction(s), calls FUN_0051dc43, ends with je to 0x00449869 (forward)
    push ebp                                     # 004497a0
    {load} mov ebp, esp                          # 004497a1
    push -0x1                                    # 004497a3
    push 0x527f1a                                # 004497a5
    mov eax, dword ptr fs:[0x0]                  # 004497aa
    push eax                                     # 004497b0
    mov dword ptr fs:[0x0], esp                  # 004497b1
    sub esp, 0x84                                # 004497b8
    push esi                                     # 004497be
    push edi                                     # 004497bf
    mov dword ptr [ebp - local_8c], ecx          # 004497c0
    mov eax, dword ptr [ebp - local_8c]          # 004497c6
    mov dword ptr [eax], 0x52cb5c                # 004497cc
    mov ecx, dword ptr [ebp - local_8c]          # 004497d2
    mov dword ptr [ecx + field_36], 0x0          # 004497d8
    mov edx, dword ptr [ebp - local_8c]          # 004497df
    mov dword ptr [edx + field_42], 0x3          # 004497e5
    mov eax, dword ptr [ebp - local_8c]          # 004497ec
    mov dword ptr [eax + field_3a], 0xffffffff   # 004497f2
    {load} xor ecx, ecx                          # 004497f9
    mov edx, dword ptr [ebp - local_8c]          # 004497fb
    add edx, 0x3e                                # 00449801
    mov dword ptr [edx], ecx                     # 00449804
    mov edi, dword ptr [ebp + arg_c]             # 00449806
    mov eax, dword ptr [ebp - local_8c]          # 00449809
    add eax, 0x4                                 # 0044980f
    {load} mov edx, eax                          # 00449812
    or ecx, -0x1                                 # 00449814
    {load} xor eax, eax                          # 00449817
    repne scasb al, byte ptr es:[edi]            # 00449819
    not ecx                                      # 0044981b
    {load} sub edi, ecx                          # 0044981d
    {load} mov esi, edi                          # 0044981f
    {load} mov eax, ecx                          # 00449821
    {load} mov edi, edx                          # 00449823
    shr ecx, 0x2                                 # 00449825
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00449828
    {load} mov ecx, eax                          # 0044982a
    and ecx, 0x3                                 # 0044982c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044982f
    push 0x68                                    # 00449831
    call FUN_0051dc43                            # 00449833
    add esp, 0x4                                 # 00449838
    mov dword ptr [ebp - local_78], eax          # 0044983b
    mov dword ptr [ebp - local_4], 0x0           # 0044983e
    cmp dword ptr [ebp - local_78], 0x0          # 00449845
    je.d8 L_00449869                             # 00449849
    # block 0x0044984b: entered by fall-through of je at 0x00449849, 9 instruction(s), calls FUN_00524aff, ends with forward jump to 0x00449873
    mov ecx, dword ptr [ebp - local_8c]          # 0044984b
    add ecx, 0x3e                                # 00449851
    push ecx                                     # 00449854
    mov edx, dword ptr [ebp + arg_8]             # 00449855
    push edx                                     # 00449858
    mov ecx, dword ptr [ebp - local_78]          # 00449859
    call FUN_00524aff                            # 0044985c
    mov dword ptr [ebp - local_90], eax          # 00449861
    jmp.d8 L_00449873                            # 00449867
L_00449869:
    # block 0x00449869: entered by je at 0x00449849, 1 instruction(s), falls into the block at 0x00449873
    mov dword ptr [ebp - local_90], 0x0          # 00449869
L_00449873:
    # block 0x00449873: entered by jmp at 0x00449867, 8 instruction(s), ends with jne to 0x004498b3 (forward)
    mov eax, dword ptr [ebp - local_90]          # 00449873
    mov dword ptr [ebp - local_74], eax          # 00449879
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044987c
    mov ecx, dword ptr [ebp - local_8c]          # 00449883
    mov edx, dword ptr [ebp - local_74]          # 00449889
    mov dword ptr [ecx + field_36], edx          # 0044988c
    cmp dword ptr [ebp - local_74], 0x0          # 0044988f
    jne.d8 L_004498b3                            # 00449893
    # block 0x00449895: entered by fall-through of jne at 0x00449893, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x00449a60
    push 0x548844                                # 00449895
    mov ecx, 0x583979                            # 0044989a
    call FUN_004264e8                            # 0044989f
    mov ecx, 0x5cf659                            # 004498a4
    call FUN_004c97b4                            # 004498a9
    jmp.d32 L_00449a60                           # 004498ae
L_004498b3:
    # block 0x004498b3: entered by jne at 0x00449893, 13 instruction(s), calls FUN_0051ed8c, ends with jne to 0x00449915 (forward)
    mov eax, dword ptr [ebp - local_8c]          # 004498b3
    mov ecx, dword ptr [eax + field_36]          # 004498b9
    mov dword ptr [ecx + field_24], 0x1          # 004498bc
    push 0x0                                     # 004498c3
    push 0x0                                     # 004498c5
    mov edx, dword ptr [ebp + arg_14]            # 004498c7
    or edx, 0x4                                  # 004498ca
    push edx                                     # 004498cd
    mov eax, dword ptr [ebp - local_8c]          # 004498ce
    mov ecx, dword ptr [eax + field_36]          # 004498d4
    call FUN_0051ed8c                            # 004498d7
    test eax, eax                                # 004498dc
    jne.d8 L_00449915                            # 004498de
    # block 0x004498e0: entered by fall-through of jne at 0x004498de, 12 instruction(s), calls indirect dword ptr [edx + 0x78], FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x00449a60
    mov ecx, dword ptr [ebp - local_8c]          # 004498e0
    mov ecx, dword ptr [ecx + field_36]          # 004498e6
    mov edx, dword ptr [ebp - local_8c]          # 004498e9
    mov eax, dword ptr [edx + field_36]          # 004498ef
    mov edx, dword ptr [eax]                     # 004498f2
    call dword ptr [edx + field_78]              # 004498f4
    push 0x548894                                # 004498f7
    mov ecx, 0x583979                            # 004498fc
    call FUN_004264e8                            # 00449901
    mov ecx, 0x5cf659                            # 00449906
    call FUN_004c97b4                            # 0044990b
    jmp.d32 L_00449a60                           # 00449910
L_00449915:
    # block 0x00449915: entered by jne at 0x004498de, 12 instruction(s), calls KERNEL32.dll!SetThreadPriority, ends with jne to 0x00449970 (forward)
    mov eax, dword ptr [ebp - local_8c]          # 00449915
    mov ecx, dword ptr [eax + field_36]          # 0044991b
    mov dword ptr [ebp - local_7c], ecx          # 0044991e
    mov edx, dword ptr [ebp + arg_10]            # 00449921
    push edx                                     # 00449924
    mov eax, dword ptr [ebp - local_7c]          # 00449925
    mov ecx, dword ptr [eax + field_28]          # 00449928
    push ecx                                     # 0044992b
    call dword ptr [0x52a2ac]                    # 0044992c
    mov dword ptr [ebp - local_80], eax          # 00449932
    cmp dword ptr [ebp - local_80], 0x0          # 00449935
    jne.d8 L_00449970                            # 00449939
    # block 0x0044993b: entered by fall-through of jne at 0x00449939, 12 instruction(s), calls indirect dword ptr [eax + 0x78], FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x00449a60
    mov edx, dword ptr [ebp - local_8c]          # 0044993b
    mov ecx, dword ptr [edx + field_36]          # 00449941
    mov eax, dword ptr [ebp - local_8c]          # 00449944
    mov edx, dword ptr [eax + field_36]          # 0044994a
    mov eax, dword ptr [edx]                     # 0044994d
    call dword ptr [eax + field_78]              # 0044994f
    push 0x5488d8                                # 00449952
    mov ecx, 0x583979                            # 00449957
    call FUN_004264e8                            # 0044995c
    mov ecx, 0x5cf659                            # 00449961
    call FUN_004c97b4                            # 00449966
    jmp.d32 L_00449a60                           # 0044996b
L_00449970:
    # block 0x00449970: entered by jne at 0x00449939, 4 instruction(s), ends with jne to 0x004499dd (forward)
    mov ecx, dword ptr [ebp + arg_14]            # 00449970
    and ecx, 0x4                                 # 00449973
    test ecx, ecx                                # 00449976
    jne.d8 L_004499dd                            # 00449978
    # block 0x0044997a: entered by fall-through of jne at 0x00449978, 10 instruction(s), calls KERNEL32.dll!ResumeThread, ends with jne to 0x004499dd (forward)
    mov edx, dword ptr [ebp - local_8c]          # 0044997a
    mov eax, dword ptr [edx + field_36]          # 00449980
    mov dword ptr [ebp - local_84], eax          # 00449983
    mov ecx, dword ptr [ebp - local_84]          # 00449989
    mov edx, dword ptr [ecx + field_28]          # 0044998f
    push edx                                     # 00449992
    call dword ptr [0x52a284]                    # 00449993
    mov dword ptr [ebp - local_88], eax          # 00449999
    cmp dword ptr [ebp - local_88], -0x1         # 0044999f
    jne.d8 L_004499dd                            # 004499a6
    # block 0x004499a8: entered by fall-through of jne at 0x004499a6, 12 instruction(s), calls indirect dword ptr [edx + 0x78], FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x00449a60
    mov eax, dword ptr [ebp - local_8c]          # 004499a8
    mov ecx, dword ptr [eax + field_36]          # 004499ae
    mov edx, dword ptr [ebp - local_8c]          # 004499b1
    mov eax, dword ptr [edx + field_36]          # 004499b7
    mov edx, dword ptr [eax]                     # 004499ba
    call dword ptr [edx + field_78]              # 004499bc
    push 0x548920                                # 004499bf
    mov ecx, 0x583979                            # 004499c4
    call FUN_004264e8                            # 004499c9
    mov ecx, 0x5cf659                            # 004499ce
    call FUN_004c97b4                            # 004499d3
    jmp.d32 L_00449a60                           # 004499d8
L_004499dd:
    # block 0x004499dd: entered by jne at 0x00449978; jne at 0x004499a6, 10 instruction(s), ends with jne to 0x00449a17 (forward)
    mov eax, dword ptr [ebp - local_8c]          # 004499dd
    mov ecx, dword ptr [eax + field_36]          # 004499e3
    mov dword ptr [ecx + field_24], 0x0          # 004499e6
    mov edx, dword ptr [ebp - local_8c]          # 004499ed
    mov eax, dword ptr [edx + field_36]          # 004499f3
    mov ecx, dword ptr [ebp - local_8c]          # 004499f6
    mov edx, dword ptr [eax + field_2c]          # 004499fc
    mov dword ptr [ecx + field_3a], edx          # 004499ff
    cmp dword ptr [ebp + arg_14], 0x4            # 00449a02
    jne.d8 L_00449a17                            # 00449a06
    # block 0x00449a08: entered by fall-through of jne at 0x00449a06, 3 instruction(s), ends with forward jump to 0x00449a24
    mov eax, dword ptr [ebp - local_8c]          # 00449a08
    mov dword ptr [eax + field_42], 0x1          # 00449a0e
    jmp.d8 L_00449a24                            # 00449a15
L_00449a17:
    # block 0x00449a17: entered by jne at 0x00449a06, 2 instruction(s), falls into the block at 0x00449a24
    mov ecx, dword ptr [ebp - local_8c]          # 00449a17
    mov dword ptr [ecx + field_42], 0x2          # 00449a1d
L_00449a24:
    # block 0x00449a24: entered by jmp at 0x00449a15, 3 instruction(s), ends with je to 0x00449a60 (forward)
    movsx edx, word ptr [0x63a4cd]               # 00449a24
    test edx, edx                                # 00449a2b
    je.d8 L_00449a60                             # 00449a2d
    # block 0x00449a2f: entered by fall-through of je at 0x00449a2d, 15 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00449a60
    mov eax, dword ptr [ebp - local_8c]          # 00449a2f
    add eax, 0x4                                 # 00449a35
    push eax                                     # 00449a38
    mov ecx, dword ptr [ebp - local_8c]          # 00449a39
    mov edx, dword ptr [ecx + field_3a]          # 00449a3f
    push edx                                     # 00449a42
    push 0x548968                                # 00449a43
    lea eax, [ebp - local_70]                    # 00449a48
    push eax                                     # 00449a4b
    call FUN_0050ca3e                            # 00449a4c
    add esp, 0x10                                # 00449a51
    lea ecx, [ebp - local_70]                    # 00449a54
    push ecx                                     # 00449a57
    call FUN_0044a2b7                            # 00449a58
    add esp, 0x4                                 # 00449a5d
L_00449a60:
    # block 0x00449a60: entered by jmp at 0x004498ae; jmp at 0x00449910; jmp at 0x0044996b; jmp at 0x004499d8; more, 8 instruction(s), ends with ret 0x10
    mov eax, dword ptr [ebp - local_8c]          # 00449a60
    mov ecx, dword ptr [ebp - local_c]           # 00449a66
    mov dword ptr fs:[0x0], ecx                  # 00449a69
    pop edi                                      # 00449a70
    pop esi                                      # 00449a71
    {load} mov esp, ebp                          # 00449a72
    pop ebp                                      # 00449a74
    ret 0x10                                     # 00449a75

