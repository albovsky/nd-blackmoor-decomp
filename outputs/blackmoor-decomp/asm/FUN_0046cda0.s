# FUN_0046cda0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046cda0
# extent:       0x0046cda0-0x0046dea0 (4352 code bytes)
# span:         0x0046cda0-0x0046dea0 (code 4352, tables 0, padding 0)
# sha256:       3e2bbab0a169dcd9590cddf97b1d604ff40c5face5d423a2f0b6d6de338c8c83
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046cda0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_4, field_1c, field_20, field_43, field_47, field_4b, field_51, field_53, field_55, field_57, field_59, field_5b and 28 more; [ecx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_45, field_49, field_4d, field_4f, field_69, field_71 and 27 more; [edx + n] field_4, field_8, field_c, field_1c, field_1e, field_20, field_42, field_49, field_55, field_57, field_5d, field_5f and 23 more
# callees:      calls FUN_004e8d96, FUN_0046b73e, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_0046b75b, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_0046b67f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1070 instruction(s), 34 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_42, 0x42  # offset +0x42
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_47, 0x47  # offset +0x47
.equ field_49, 0x49  # offset +0x49
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4d, 0x4d  # offset +0x4d
.equ field_4f, 0x4f  # offset +0x4f
.equ field_51, 0x51  # offset +0x51
.equ field_53, 0x53  # offset +0x53
.equ field_55, 0x55  # offset +0x55
.equ field_57, 0x57  # offset +0x57
.equ field_59, 0x59  # offset +0x59
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5d, 0x5d  # offset +0x5d
.equ field_5f, 0x5f  # offset +0x5f
.equ field_61, 0x61  # offset +0x61
.equ field_63, 0x63  # offset +0x63
.equ field_65, 0x65  # offset +0x65
.equ field_67, 0x67  # offset +0x67
.equ field_69, 0x69  # offset +0x69
.equ field_6d, 0x6d  # offset +0x6d
.equ field_71, 0x71  # offset +0x71
.equ field_75, 0x75  # offset +0x75
.equ field_1a9, 0x1a9  # offset +0x1a9
.equ field_1ad, 0x1ad  # offset +0x1ad
.equ field_1b1, 0x1b1  # offset +0x1b1
.equ field_1b5, 0x1b5  # offset +0x1b5
.equ field_2e9, 0x2e9  # offset +0x2e9
.equ field_2ed, 0x2ed  # offset +0x2ed
.equ field_2f1, 0x2f1  # offset +0x2f1
.equ field_2f5, 0x2f5  # offset +0x2f5
.equ field_4a2, 0x4a2  # offset +0x4a2
.equ field_66e, 0x66e  # offset +0x66e
.equ field_670, 0x670  # offset +0x670
.equ field_672, 0x672  # offset +0x672
.equ field_674, 0x674  # offset +0x674
.equ field_676, 0x676  # offset +0x676
.equ field_67a, 0x67a  # offset +0x67a
.equ field_67e, 0x67e  # offset +0x67e
.equ field_682, 0x682  # offset +0x682
.equ field_684, 0x684  # offset +0x684
.equ field_686, 0x686  # offset +0x686
.equ field_6a8, 0x6a8  # offset +0x6a8
.equ field_6b8, 0x6b8  # offset +0x6b8
.equ field_6ba, 0x6ba  # offset +0x6ba
.equ field_6bc, 0x6bc  # offset +0x6bc
.equ field_6be, 0x6be  # offset +0x6be
.equ field_6c0, 0x6c0  # offset +0x6c0
.equ field_6c4, 0x6c4  # offset +0x6c4
.equ field_6c8, 0x6c8  # offset +0x6c8
.equ field_6cc, 0x6cc  # offset +0x6cc
.equ field_6ce, 0x6ce  # offset +0x6ce
.equ field_6d0, 0x6d0  # offset +0x6d0
.equ field_1920, 0x1920  # offset +0x1920
.equ field_3220, 0x3220  # offset +0x3220
.equ field_3860, 0x3860  # offset +0x3860
.equ field_3ea0, 0x3ea0  # offset +0x3ea0
.equ field_43a0, 0x43a0  # offset +0x43a0
.equ field_48a0, 0x48a0  # offset +0x48a0
.equ field_48a4, 0x48a4  # offset +0x48a4
.equ field_48ac, 0x48ac  # offset +0x48ac
.equ field_48ae, 0x48ae  # offset +0x48ae
.equ field_4a40, 0x4a40  # offset +0x4a40
.equ field_4a44, 0x4a44  # offset +0x4a44
.equ field_4a48, 0x4a48  # offset +0x4a48
.equ field_4a54, 0x4a54  # offset +0x4a54
.equ field_4a55, 0x4a55  # offset +0x4a55
.equ field_4a59, 0x4a59  # offset +0x4a59
.equ field_4a6a, 0x4a6a  # offset +0x4a6a
.equ field_636a, 0x636a  # offset +0x636a
.equ field_816a, 0x816a  # offset +0x816a
.equ field_816c, 0x816c  # offset +0x816c
.equ field_816e, 0x816e  # offset +0x816e
.equ field_8170, 0x8170  # offset +0x8170

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0046b67f, .text + (0x0046b67f - 0x401000)
.set FUN_0046b73e, .text + (0x0046b73e - 0x401000)
.set FUN_0046b75b, .text + (0x0046b75b - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x0046cda0 - 0x401000
.globl FUN_0046cda0
FUN_0046cda0:
    # block 0x0046cda0: entry, 16 instruction(s), ends with je to 0x0046cdf0 (forward)
    push ebp                                     # 0046cda0
    {load} mov ebp, esp                          # 0046cda1
    sub esp, 0x38                                # 0046cda3
    push esi                                     # 0046cda6
    push edi                                     # 0046cda7
    mov dword ptr [ebp - local_30], ecx          # 0046cda8
    movsx eax, word ptr [ebp + arg_8]            # 0046cdab
    imul eax, eax, 0x8d                          # 0046cdaf
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0046cdb5
    mov dword ptr [ebp - local_10], ecx          # 0046cdbb
    movsx edx, word ptr [ebp + arg_8]            # 0046cdbe
    imul edx, edx, 0x8d                          # 0046cdc2
    mov eax, dword ptr [edx + 0x5bb632]          # 0046cdc8
    mov dword ptr [ebp - local_34], eax          # 0046cdce
    cmp dword ptr [ebp - local_34], 0x0          # 0046cdd1
    je.d8 L_0046cdf0                             # 0046cdd5
    # block 0x0046cdd7: entered by fall-through of je at 0x0046cdd5, 2 instruction(s), ends with je to 0x0046db64 (forward)
    cmp dword ptr [ebp - local_34], 0x1          # 0046cdd7
    je.d32 L_0046db64                            # 0046cddb
    # block 0x0046cde1: entered by fall-through of je at 0x0046cddb, 2 instruction(s), ends with je to 0x0046dc38 (forward)
    cmp dword ptr [ebp - local_34], 0x2          # 0046cde1
    je.d32 L_0046dc38                            # 0046cde5
    # block 0x0046cdeb: entered by fall-through of je at 0x0046cde5, 1 instruction(s), ends with forward jump to 0x0046de98
    jmp.d32 L_0046de98                           # 0046cdeb
L_0046cdf0:
    # block 0x0046cdf0: entered by je at 0x0046cdd5, 11 instruction(s), calls FUN_004e8d96, ends with je to 0x0046ce61 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 0046cdf0
    mov dx, word ptr [ebp + arg_8]               # 0046cdf3
    mov word ptr [ecx + field_1e], dx            # 0046cdf7
    mov eax, dword ptr [ebp - local_30]          # 0046cdfb
    mov dword ptr [eax + field_4a48], 0x1        # 0046cdfe
    mov dword ptr [0x5bb1ca], 0x1                # 0046ce08
    mov ecx, 0x571442                            # 0046ce12
    call FUN_004e8d96                            # 0046ce17
    movsx ecx, word ptr [0x5a14db]               # 0046ce1c
    test ecx, ecx                                # 0046ce23
    je.d8 L_0046ce61                             # 0046ce25
    # block 0x0046ce27: entered by fall-through of je at 0x0046ce25, 5 instruction(s), ends with je to 0x0046ce61 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046ce27
    {load} xor eax, eax                          # 0046ce2a
    mov al, byte ptr [edx + field_42]            # 0046ce2c
    test eax, eax                                # 0046ce2f
    je.d8 L_0046ce61                             # 0046ce31
    # block 0x0046ce33: entered by fall-through of je at 0x0046ce31, 3 instruction(s), ends with je to 0x0046ce4c (forward)
    movsx ecx, word ptr [0x5a14dd]               # 0046ce33
    cmp dword ptr [0x5bb57b], ecx                # 0046ce3a
    je.d8 L_0046ce4c                             # 0046ce40
    # block 0x0046ce42: entered by fall-through of je at 0x0046ce40, 3 instruction(s), calls FUN_0046b73e, ends with forward jump to 0x0046ce61
    mov ecx, dword ptr [ebp - local_30]          # 0046ce42
    call FUN_0046b73e                            # 0046ce45
    jmp.d8 L_0046ce61                            # 0046ce4a
L_0046ce4c:
    # block 0x0046ce4c: entered by je at 0x0046ce40, 5 instruction(s), falls into the block at 0x0046ce61
    mov edi, dword ptr [ebp - local_30]          # 0046ce4c
    add edi, 0x48a0                              # 0046ce4f
    mov ecx, 0x50                                # 0046ce55
    mov esi, 0x5a14df                            # 0046ce5a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046ce5f
L_0046ce61:
    # block 0x0046ce61: entered by je at 0x0046ce25; je at 0x0046ce31; jmp at 0x0046ce4a, 2 instruction(s), ends with forward jump to 0x0046ce75
    mov word ptr [ebp - local_1c], 0x0           # 0046ce61
    jmp.d8 L_0046ce75                            # 0046ce67
L_0046ce69:
    # block 0x0046ce69: entered by jmp at 0x0046cf22, 3 instruction(s), falls into the block at 0x0046ce75
    mov dx, word ptr [ebp - local_1c]            # 0046ce69
    add dx, 0x1                                  # 0046ce6d
    mov word ptr [ebp - local_1c], dx            # 0046ce71
L_0046ce75:
    # block 0x0046ce75: entered by jmp at 0x0046ce67, 5 instruction(s), ends with jge to 0x0046cf27 (forward)
    movsx eax, word ptr [ebp - local_1c]         # 0046ce75
    mov ecx, dword ptr [ebp - local_10]          # 0046ce79
    movsx edx, word ptr [ecx + field_4f]         # 0046ce7c
    {load} cmp eax, edx                          # 0046ce80
    jge.d32 L_0046cf27                           # 0046ce82
    # block 0x0046ce88: entered by fall-through of jge at 0x0046ce82, 5 instruction(s), ends with je to 0x0046cf22 (forward)
    movsx eax, word ptr [ebp - local_1c]         # 0046ce88
    mov ecx, dword ptr [ebp - local_10]          # 0046ce8c
    movsx edx, word ptr [ecx + 2*eax + field_4a2] # 0046ce8f
    cmp edx, -0x1                                # 0046ce97
    je.d32 L_0046cf22                            # 0046ce9a
    # block 0x0046cea0: entered by fall-through of je at 0x0046ce9a, 5 instruction(s), ends with jne to 0x0046cf22 (forward)
    movsx eax, word ptr [ebp - local_1c]         # 0046cea0
    mov ecx, dword ptr [ebp - local_10]          # 0046cea4
    movsx edx, word ptr [ecx + 2*eax + field_4a2] # 0046cea7
    cmp dword ptr [4*edx + 0x585801], 0x1        # 0046ceaf
    jne.d8 L_0046cf22                            # 0046ceb7
    # block 0x0046ceb9: entered by fall-through of jne at 0x0046ceb7, 5 instruction(s), ends with jne to 0x0046cf22 (forward)
    movsx eax, word ptr [ebp - local_1c]         # 0046ceb9
    shl eax, 0x4                                 # 0046cebd
    mov ecx, dword ptr [ebp - local_30]          # 0046cec0
    cmp dword ptr [ecx + eax + field_48a0], 0x0  # 0046cec3
    jne.d8 L_0046cf22                            # 0046cecb
    # block 0x0046cecd: entered by fall-through of jne at 0x0046cecb, 22 instruction(s), falls into the block at 0x0046cf22
    movsx edx, word ptr [ebp - local_1c]         # 0046cecd
    shl edx, 0x4                                 # 0046ced1
    mov eax, dword ptr [ebp - local_30]          # 0046ced4
    mov dword ptr [eax + edx + field_48a4], 0x1  # 0046ced7
    movsx eax, word ptr [ebp - local_1c]         # 0046cee2
    mov ecx, dword ptr [ebp - local_10]          # 0046cee6
    movsx ecx, word ptr [ecx + field_49]         # 0046cee9
    cdq                                          # 0046ceed
    idiv ecx                                     # 0046ceee
    movsx edx, word ptr [ebp - local_1c]         # 0046cef0
    shl edx, 0x4                                 # 0046cef4
    mov ecx, dword ptr [ebp - local_30]          # 0046cef7
    mov word ptr [ecx + edx + field_48ac], ax    # 0046cefa
    movsx eax, word ptr [ebp - local_1c]         # 0046cf02
    mov edx, dword ptr [ebp - local_10]          # 0046cf06
    movsx ecx, word ptr [edx + field_49]         # 0046cf09
    cdq                                          # 0046cf0d
    idiv ecx                                     # 0046cf0e
    movsx eax, word ptr [ebp - local_1c]         # 0046cf10
    shl eax, 0x4                                 # 0046cf14
    mov ecx, dword ptr [ebp - local_30]          # 0046cf17
    mov word ptr [ecx + eax + field_48ae], dx    # 0046cf1a
L_0046cf22:
    # block 0x0046cf22: entered by je at 0x0046ce9a; jne at 0x0046ceb7; jne at 0x0046cecb, 1 instruction(s), ends with backward jump to 0x0046ce69
    jmp.d32 L_0046ce69                           # 0046cf22
L_0046cf27:
    # block 0x0046cf27: entered by jge at 0x0046ce82, 23 instruction(s), ends with forward jump to 0x0046cf9c
    mov esi, dword ptr [ebp - local_30]          # 0046cf27
    add esi, 0x48a0                              # 0046cf2a
    mov ecx, 0x50                                # 0046cf30
    mov edi, 0x5a14df                            # 0046cf35
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046cf3a
    mov dx, word ptr [0x5bb57b]                  # 0046cf3c
    mov word ptr [0x5a14dd], dx                  # 0046cf43
    mov word ptr [0x5a14db], 0x1                 # 0046cf4a
    mov ax, word ptr [0x5bb57b]                  # 0046cf53
    mov word ptr [0x5a14dd], ax                  # 0046cf59
    mov word ptr [0x5a14db], 0x1                 # 0046cf5f
    mov ecx, dword ptr [ebp - local_10]          # 0046cf68
    mov edx, dword ptr [ebp - local_10]          # 0046cf6b
    mov eax, dword ptr [ecx + field_71]          # 0046cf6e
    sub eax, dword ptr [edx + field_69]          # 0046cf71
    mov word ptr [ebp - local_8], ax             # 0046cf74
    mov ecx, dword ptr [ebp - local_10]          # 0046cf78
    mov edx, dword ptr [ebp - local_10]          # 0046cf7b
    mov eax, dword ptr [ecx + field_75]          # 0046cf7e
    sub eax, dword ptr [edx + field_6d]          # 0046cf81
    mov word ptr [ebp - local_24], ax            # 0046cf84
    mov word ptr [ebp - local_c], 0x0            # 0046cf88
    jmp.d8 L_0046cf9c                            # 0046cf8e
L_0046cf90:
    # block 0x0046cf90: entered by jmp at 0x0046d2f0, 3 instruction(s), falls into the block at 0x0046cf9c
    mov cx, word ptr [ebp - local_c]             # 0046cf90
    add cx, 0x1                                  # 0046cf94
    mov word ptr [ebp - local_c], cx             # 0046cf98
L_0046cf9c:
    # block 0x0046cf9c: entered by jmp at 0x0046cf8e, 5 instruction(s), ends with jge to 0x0046d2f5 (forward)
    movsx edx, word ptr [ebp - local_c]          # 0046cf9c
    mov eax, dword ptr [ebp - local_10]          # 0046cfa0
    movsx ecx, word ptr [eax + field_43]         # 0046cfa3
    {load} cmp edx, ecx                          # 0046cfa7
    jge.d32 L_0046d2f5                           # 0046cfa9
    # block 0x0046cfaf: entered by fall-through of jge at 0x0046cfa9, 2 instruction(s), ends with forward jump to 0x0046cfc3
    mov word ptr [ebp - local_14], 0x0           # 0046cfaf
    jmp.d8 L_0046cfc3                            # 0046cfb5
L_0046cfb7:
    # block 0x0046cfb7: entered by jmp at 0x0046d2eb, 3 instruction(s), falls into the block at 0x0046cfc3
    mov dx, word ptr [ebp - local_14]            # 0046cfb7
    add dx, 0x1                                  # 0046cfbb
    mov word ptr [ebp - local_14], dx            # 0046cfbf
L_0046cfc3:
    # block 0x0046cfc3: entered by jmp at 0x0046cfb5, 5 instruction(s), ends with jge to 0x0046d2f0 (forward)
    movsx eax, word ptr [ebp - local_14]         # 0046cfc3
    mov ecx, dword ptr [ebp - local_10]          # 0046cfc7
    movsx edx, word ptr [ecx + field_45]         # 0046cfca
    {load} cmp eax, edx                          # 0046cfce
    jge.d32 L_0046d2f0                           # 0046cfd0
    # block 0x0046cfd6: entered by fall-through of jge at 0x0046cfd0, 207 instruction(s), ends with backward jump to 0x0046cfb7
    mov eax, dword ptr [ebp - local_10]          # 0046cfd6
    movsx ecx, word ptr [eax + field_53]         # 0046cfd9
    movsx edx, word ptr [ebp - local_c]          # 0046cfdd
    mov eax, dword ptr [ebp - local_10]          # 0046cfe1
    movsx eax, word ptr [eax + field_55]         # 0046cfe4
    movsx esi, word ptr [ebp - local_24]         # 0046cfe8
    {load} add eax, esi                          # 0046cfec
    imul edx, eax                                # 0046cfee
    {load} add ecx, edx                          # 0046cff1
    movsx edx, word ptr [ebp - local_c]          # 0046cff3
    imul edx, edx, 0x140                         # 0046cff7
    mov eax, dword ptr [ebp - local_30]          # 0046cffd
    lea edx, [eax + edx + field_20]              # 0046d000
    movsx eax, word ptr [ebp - local_14]         # 0046d004
    shl eax, 0x4                                 # 0046d008
    mov dword ptr [edx + eax + field_4], ecx     # 0046d00b
    movsx ecx, word ptr [ebp - local_c]          # 0046d00f
    imul ecx, ecx, 0x140                         # 0046d013
    mov edx, dword ptr [ebp - local_30]          # 0046d019
    lea eax, [edx + ecx + field_20]              # 0046d01c
    movsx ecx, word ptr [ebp - local_14]         # 0046d020
    shl ecx, 0x4                                 # 0046d024
    movsx edx, word ptr [ebp - local_24]         # 0046d027
    mov eax, dword ptr [eax + ecx + field_4]     # 0046d02b
    {load} add eax, edx                          # 0046d02f
    movsx ecx, word ptr [ebp - local_c]          # 0046d031
    imul ecx, ecx, 0x140                         # 0046d035
    mov edx, dword ptr [ebp - local_30]          # 0046d03b
    lea ecx, [edx + ecx + field_20]              # 0046d03e
    movsx edx, word ptr [ebp - local_14]         # 0046d042
    shl edx, 0x4                                 # 0046d046
    mov dword ptr [ecx + edx + field_c], eax     # 0046d049
    mov eax, dword ptr [ebp - local_10]          # 0046d04d
    movsx ecx, word ptr [eax + field_51]         # 0046d050
    movsx edx, word ptr [ebp - local_14]         # 0046d054
    mov eax, dword ptr [ebp - local_10]          # 0046d058
    movsx eax, word ptr [eax + field_57]         # 0046d05b
    movsx esi, word ptr [ebp - local_8]          # 0046d05f
    {load} add eax, esi                          # 0046d063
    imul edx, eax                                # 0046d065
    {load} add ecx, edx                          # 0046d068
    movsx edx, word ptr [ebp - local_c]          # 0046d06a
    imul edx, edx, 0x140                         # 0046d06e
    mov eax, dword ptr [ebp - local_30]          # 0046d074
    lea edx, [eax + edx + field_20]              # 0046d077
    movsx eax, word ptr [ebp - local_14]         # 0046d07b
    shl eax, 0x4                                 # 0046d07f
    mov dword ptr [edx + eax], ecx               # 0046d082
    movsx ecx, word ptr [ebp - local_c]          # 0046d085
    imul ecx, ecx, 0x140                         # 0046d089
    mov edx, dword ptr [ebp - local_30]          # 0046d08f
    lea eax, [edx + ecx + field_20]              # 0046d092
    movsx ecx, word ptr [ebp - local_14]         # 0046d096
    shl ecx, 0x4                                 # 0046d09a
    movsx edx, word ptr [ebp - local_8]          # 0046d09d
    mov eax, dword ptr [eax + ecx]               # 0046d0a1
    {load} add eax, edx                          # 0046d0a4
    movsx ecx, word ptr [ebp - local_c]          # 0046d0a6
    imul ecx, ecx, 0x140                         # 0046d0aa
    mov edx, dword ptr [ebp - local_30]          # 0046d0b0
    lea ecx, [edx + ecx + field_20]              # 0046d0b3
    movsx edx, word ptr [ebp - local_14]         # 0046d0b7
    shl edx, 0x4                                 # 0046d0bb
    mov dword ptr [ecx + edx + field_8], eax     # 0046d0be
    movsx eax, word ptr [ebp - local_c]          # 0046d0c2
    imul eax, eax, 0x140                         # 0046d0c6
    mov ecx, dword ptr [ebp - local_30]          # 0046d0cc
    lea edx, [ecx + eax + field_20]              # 0046d0cf
    movsx eax, word ptr [ebp - local_14]         # 0046d0d3
    shl eax, 0x4                                 # 0046d0d7
    mov ecx, dword ptr [edx + eax + field_4]     # 0046d0da
    add ecx, dword ptr [0x58318a]                # 0046d0de
    movsx edx, word ptr [ebp - local_c]          # 0046d0e4
    imul edx, edx, 0x140                         # 0046d0e8
    mov eax, dword ptr [ebp - local_30]          # 0046d0ee
    lea edx, [eax + edx + field_1920]            # 0046d0f1
    movsx eax, word ptr [ebp - local_14]         # 0046d0f8
    shl eax, 0x4                                 # 0046d0fc
    mov dword ptr [edx + eax + field_4], ecx     # 0046d0ff
    movsx ecx, word ptr [ebp - local_c]          # 0046d103
    imul ecx, ecx, 0x140                         # 0046d107
    mov edx, dword ptr [ebp - local_30]          # 0046d10d
    lea eax, [edx + ecx + field_1920]            # 0046d110
    movsx ecx, word ptr [ebp - local_14]         # 0046d117
    shl ecx, 0x4                                 # 0046d11b
    movsx edx, word ptr [ebp - local_24]         # 0046d11e
    mov eax, dword ptr [eax + ecx + field_4]     # 0046d122
    {load} add eax, edx                          # 0046d126
    movsx ecx, word ptr [ebp - local_c]          # 0046d128
    imul ecx, ecx, 0x140                         # 0046d12c
    mov edx, dword ptr [ebp - local_30]          # 0046d132
    lea ecx, [edx + ecx + field_1920]            # 0046d135
    movsx edx, word ptr [ebp - local_14]         # 0046d13c
    shl edx, 0x4                                 # 0046d140
    mov dword ptr [ecx + edx + field_c], eax     # 0046d143
    movsx eax, word ptr [ebp - local_c]          # 0046d147
    imul eax, eax, 0x140                         # 0046d14b
    mov ecx, dword ptr [ebp - local_30]          # 0046d151
    lea edx, [ecx + eax + field_20]              # 0046d154
    movsx eax, word ptr [ebp - local_14]         # 0046d158
    shl eax, 0x4                                 # 0046d15c
    mov ecx, dword ptr [edx + eax]               # 0046d15f
    add ecx, dword ptr [0x583186]                # 0046d162
    movsx edx, word ptr [ebp - local_c]          # 0046d168
    imul edx, edx, 0x140                         # 0046d16c
    mov eax, dword ptr [ebp - local_30]          # 0046d172
    lea edx, [eax + edx + field_1920]            # 0046d175
    movsx eax, word ptr [ebp - local_14]         # 0046d17c
    shl eax, 0x4                                 # 0046d180
    mov dword ptr [edx + eax], ecx               # 0046d183
    movsx ecx, word ptr [ebp - local_c]          # 0046d186
    imul ecx, ecx, 0x140                         # 0046d18a
    mov edx, dword ptr [ebp - local_30]          # 0046d190
    lea eax, [edx + ecx + field_1920]            # 0046d193
    movsx ecx, word ptr [ebp - local_14]         # 0046d19a
    shl ecx, 0x4                                 # 0046d19e
    movsx edx, word ptr [ebp - local_8]          # 0046d1a1
    mov eax, dword ptr [eax + ecx]               # 0046d1a5
    {load} add eax, edx                          # 0046d1a8
    movsx ecx, word ptr [ebp - local_c]          # 0046d1aa
    imul ecx, ecx, 0x140                         # 0046d1ae
    mov edx, dword ptr [ebp - local_30]          # 0046d1b4
    lea ecx, [edx + ecx + field_1920]            # 0046d1b7
    movsx edx, word ptr [ebp - local_14]         # 0046d1be
    shl edx, 0x4                                 # 0046d1c2
    mov dword ptr [ecx + edx + field_8], eax     # 0046d1c5
    movsx eax, word ptr [ebp - local_c]          # 0046d1c9
    imul eax, eax, 0x140                         # 0046d1cd
    mov ecx, dword ptr [ebp - local_30]          # 0046d1d3
    lea ecx, [ecx + eax + field_20]              # 0046d1d6
    movsx esi, word ptr [ebp - local_14]         # 0046d1da
    shl esi, 0x4                                 # 0046d1de
    mov edx, dword ptr [ebp - local_10]          # 0046d1e1
    movsx eax, word ptr [edx + field_55]         # 0046d1e4
    cdq                                          # 0046d1e8
    {load} sub eax, edx                          # 0046d1e9
    sar eax                                      # 0046d1eb
    mov ecx, dword ptr [ecx + esi + field_4]     # 0046d1ed
    {load} sub ecx, eax                          # 0046d1f1
    movsx edx, word ptr [ebp - local_c]          # 0046d1f3
    imul edx, edx, 0x140                         # 0046d1f7
    mov eax, dword ptr [ebp - local_30]          # 0046d1fd
    lea edx, [eax + edx + field_4a6a]            # 0046d200
    movsx eax, word ptr [ebp - local_14]         # 0046d207
    shl eax, 0x4                                 # 0046d20b
    mov dword ptr [edx + eax + field_4], ecx     # 0046d20e
    movsx ecx, word ptr [ebp - local_c]          # 0046d212
    imul ecx, ecx, 0x140                         # 0046d216
    mov edx, dword ptr [ebp - local_30]          # 0046d21c
    lea ecx, [edx + ecx + field_20]              # 0046d21f
    movsx esi, word ptr [ebp - local_14]         # 0046d223
    shl esi, 0x4                                 # 0046d227
    mov edx, dword ptr [ebp - local_10]          # 0046d22a
    movsx eax, word ptr [edx + field_55]         # 0046d22d
    cdq                                          # 0046d231
    {load} sub eax, edx                          # 0046d232
    sar eax                                      # 0046d234
    mov ecx, dword ptr [ecx + esi + field_c]     # 0046d236
    {load} add ecx, eax                          # 0046d23a
    movsx edx, word ptr [ebp - local_c]          # 0046d23c
    imul edx, edx, 0x140                         # 0046d240
    mov eax, dword ptr [ebp - local_30]          # 0046d246
    lea edx, [eax + edx + field_4a6a]            # 0046d249
    movsx eax, word ptr [ebp - local_14]         # 0046d250
    shl eax, 0x4                                 # 0046d254
    mov dword ptr [edx + eax + field_c], ecx     # 0046d257
    movsx ecx, word ptr [ebp - local_c]          # 0046d25b
    imul ecx, ecx, 0x140                         # 0046d25f
    mov edx, dword ptr [ebp - local_30]          # 0046d265
    lea ecx, [edx + ecx + field_20]              # 0046d268
    movsx esi, word ptr [ebp - local_14]         # 0046d26c
    shl esi, 0x4                                 # 0046d270
    mov edx, dword ptr [ebp - local_10]          # 0046d273
    movsx eax, word ptr [edx + field_57]         # 0046d276
    cdq                                          # 0046d27a
    {load} sub eax, edx                          # 0046d27b
    sar eax                                      # 0046d27d
    mov ecx, dword ptr [ecx + esi]               # 0046d27f
    {load} sub ecx, eax                          # 0046d282
    movsx edx, word ptr [ebp - local_c]          # 0046d284
    imul edx, edx, 0x140                         # 0046d288
    mov eax, dword ptr [ebp - local_30]          # 0046d28e
    lea edx, [eax + edx + field_4a6a]            # 0046d291
    movsx eax, word ptr [ebp - local_14]         # 0046d298
    shl eax, 0x4                                 # 0046d29c
    mov dword ptr [edx + eax], ecx               # 0046d29f
    movsx ecx, word ptr [ebp - local_c]          # 0046d2a2
    imul ecx, ecx, 0x140                         # 0046d2a6
    mov edx, dword ptr [ebp - local_30]          # 0046d2ac
    lea ecx, [edx + ecx + field_20]              # 0046d2af
    movsx esi, word ptr [ebp - local_14]         # 0046d2b3
    shl esi, 0x4                                 # 0046d2b7
    mov edx, dword ptr [ebp - local_10]          # 0046d2ba
    movsx eax, word ptr [edx + field_57]         # 0046d2bd
    cdq                                          # 0046d2c1
    {load} sub eax, edx                          # 0046d2c2
    sar eax                                      # 0046d2c4
    mov ecx, dword ptr [ecx + esi + field_8]     # 0046d2c6
    {load} add ecx, eax                          # 0046d2ca
    movsx edx, word ptr [ebp - local_c]          # 0046d2cc
    imul edx, edx, 0x140                         # 0046d2d0
    mov eax, dword ptr [ebp - local_30]          # 0046d2d6
    lea edx, [eax + edx + field_4a6a]            # 0046d2d9
    movsx eax, word ptr [ebp - local_14]         # 0046d2e0
    shl eax, 0x4                                 # 0046d2e4
    mov dword ptr [edx + eax + field_8], ecx     # 0046d2e7
    jmp.d32 L_0046cfb7                           # 0046d2eb
L_0046d2f0:
    # block 0x0046d2f0: entered by jge at 0x0046cfd0, 1 instruction(s), ends with backward jump to 0x0046cf90
    jmp.d32 L_0046cf90                           # 0046d2f0
L_0046d2f5:
    # block 0x0046d2f5: entered by jge at 0x0046cfa9, 12 instruction(s), ends with forward jump to 0x0046d335
    mov ecx, dword ptr [ebp - local_10]          # 0046d2f5
    mov edx, dword ptr [ebp - local_10]          # 0046d2f8
    mov eax, dword ptr [ecx + field_1b1]         # 0046d2fb
    sub eax, dword ptr [edx + field_1a9]         # 0046d301
    mov word ptr [ebp - local_4], ax             # 0046d307
    mov ecx, dword ptr [ebp - local_10]          # 0046d30b
    mov edx, dword ptr [ebp - local_10]          # 0046d30e
    mov eax, dword ptr [ecx + field_1b5]         # 0046d311
    sub eax, dword ptr [edx + field_1ad]         # 0046d317
    mov word ptr [ebp - local_28], ax            # 0046d31d
    mov word ptr [ebp - local_c], 0x0            # 0046d321
    jmp.d8 L_0046d335                            # 0046d327
L_0046d329:
    # block 0x0046d329: entered by jmp at 0x0046d6ad, 3 instruction(s), falls into the block at 0x0046d335
    mov cx, word ptr [ebp - local_c]             # 0046d329
    add cx, 0x1                                  # 0046d32d
    mov word ptr [ebp - local_c], cx             # 0046d331
L_0046d335:
    # block 0x0046d335: entered by jmp at 0x0046d327, 5 instruction(s), ends with jge to 0x0046d6b2 (forward)
    movsx edx, word ptr [ebp - local_c]          # 0046d335
    mov eax, dword ptr [ebp - local_10]          # 0046d339
    movsx ecx, word ptr [eax + field_47]         # 0046d33c
    {load} cmp edx, ecx                          # 0046d340
    jge.d32 L_0046d6b2                           # 0046d342
    # block 0x0046d348: entered by fall-through of jge at 0x0046d342, 2 instruction(s), ends with forward jump to 0x0046d35c
    mov word ptr [ebp - local_14], 0x0           # 0046d348
    jmp.d8 L_0046d35c                            # 0046d34e
L_0046d350:
    # block 0x0046d350: entered by jmp at 0x0046d6a8, 3 instruction(s), falls into the block at 0x0046d35c
    mov dx, word ptr [ebp - local_14]            # 0046d350
    add dx, 0x1                                  # 0046d354
    mov word ptr [ebp - local_14], dx            # 0046d358
L_0046d35c:
    # block 0x0046d35c: entered by jmp at 0x0046d34e, 5 instruction(s), ends with jge to 0x0046d6ad (forward)
    movsx eax, word ptr [ebp - local_14]         # 0046d35c
    mov ecx, dword ptr [ebp - local_10]          # 0046d360
    movsx edx, word ptr [ecx + field_49]         # 0046d363
    {load} cmp eax, edx                          # 0046d367
    jge.d32 L_0046d6ad                           # 0046d369
    # block 0x0046d36f: entered by fall-through of jge at 0x0046d369, 207 instruction(s), ends with backward jump to 0x0046d350
    mov eax, dword ptr [ebp - local_10]          # 0046d36f
    movsx ecx, word ptr [eax + field_5b]         # 0046d372
    movsx edx, word ptr [ebp - local_c]          # 0046d376
    mov eax, dword ptr [ebp - local_10]          # 0046d37a
    movsx eax, word ptr [eax + field_5d]         # 0046d37d
    movsx esi, word ptr [ebp - local_28]         # 0046d381
    {load} add eax, esi                          # 0046d385
    imul edx, eax                                # 0046d387
    {load} add ecx, edx                          # 0046d38a
    movsx edx, word ptr [ebp - local_c]          # 0046d38c
    imul edx, edx, 0xa0                          # 0046d390
    mov eax, dword ptr [ebp - local_30]          # 0046d396
    lea edx, [eax + edx + field_3220]            # 0046d399
    movsx eax, word ptr [ebp - local_14]         # 0046d3a0
    shl eax, 0x4                                 # 0046d3a4
    mov dword ptr [edx + eax + field_4], ecx     # 0046d3a7
    movsx ecx, word ptr [ebp - local_c]          # 0046d3ab
    imul ecx, ecx, 0xa0                          # 0046d3af
    mov edx, dword ptr [ebp - local_30]          # 0046d3b5
    lea eax, [edx + ecx + field_3220]            # 0046d3b8
    movsx ecx, word ptr [ebp - local_14]         # 0046d3bf
    shl ecx, 0x4                                 # 0046d3c3
    movsx edx, word ptr [ebp - local_28]         # 0046d3c6
    mov eax, dword ptr [eax + ecx + field_4]     # 0046d3ca
    {load} add eax, edx                          # 0046d3ce
    movsx ecx, word ptr [ebp - local_c]          # 0046d3d0
    imul ecx, ecx, 0xa0                          # 0046d3d4
    mov edx, dword ptr [ebp - local_30]          # 0046d3da
    lea ecx, [edx + ecx + field_3220]            # 0046d3dd
    movsx edx, word ptr [ebp - local_14]         # 0046d3e4
    shl edx, 0x4                                 # 0046d3e8
    mov dword ptr [ecx + edx + field_c], eax     # 0046d3eb
    mov eax, dword ptr [ebp - local_10]          # 0046d3ef
    movsx ecx, word ptr [eax + field_59]         # 0046d3f2
    movsx edx, word ptr [ebp - local_14]         # 0046d3f6
    mov eax, dword ptr [ebp - local_10]          # 0046d3fa
    movsx eax, word ptr [eax + field_5f]         # 0046d3fd
    movsx esi, word ptr [ebp - local_4]          # 0046d401
    {load} add eax, esi                          # 0046d405
    imul edx, eax                                # 0046d407
    {load} add ecx, edx                          # 0046d40a
    movsx edx, word ptr [ebp - local_c]          # 0046d40c
    imul edx, edx, 0xa0                          # 0046d410
    mov eax, dword ptr [ebp - local_30]          # 0046d416
    lea edx, [eax + edx + field_3220]            # 0046d419
    movsx eax, word ptr [ebp - local_14]         # 0046d420
    shl eax, 0x4                                 # 0046d424
    mov dword ptr [edx + eax], ecx               # 0046d427
    movsx ecx, word ptr [ebp - local_c]          # 0046d42a
    imul ecx, ecx, 0xa0                          # 0046d42e
    mov edx, dword ptr [ebp - local_30]          # 0046d434
    lea eax, [edx + ecx + field_3220]            # 0046d437
    movsx ecx, word ptr [ebp - local_14]         # 0046d43e
    shl ecx, 0x4                                 # 0046d442
    movsx edx, word ptr [ebp - local_4]          # 0046d445
    mov eax, dword ptr [eax + ecx]               # 0046d449
    {load} add eax, edx                          # 0046d44c
    movsx ecx, word ptr [ebp - local_c]          # 0046d44e
    imul ecx, ecx, 0xa0                          # 0046d452
    mov edx, dword ptr [ebp - local_30]          # 0046d458
    lea ecx, [edx + ecx + field_3220]            # 0046d45b
    movsx edx, word ptr [ebp - local_14]         # 0046d462
    shl edx, 0x4                                 # 0046d466
    mov dword ptr [ecx + edx + field_8], eax     # 0046d469
    movsx eax, word ptr [ebp - local_c]          # 0046d46d
    imul eax, eax, 0xa0                          # 0046d471
    mov ecx, dword ptr [ebp - local_30]          # 0046d477
    lea edx, [ecx + eax + field_3220]            # 0046d47a
    movsx eax, word ptr [ebp - local_14]         # 0046d481
    shl eax, 0x4                                 # 0046d485
    mov ecx, dword ptr [edx + eax + field_4]     # 0046d488
    add ecx, dword ptr [0x58318a]                # 0046d48c
    movsx edx, word ptr [ebp - local_c]          # 0046d492
    imul edx, edx, 0xa0                          # 0046d496
    mov eax, dword ptr [ebp - local_30]          # 0046d49c
    lea edx, [eax + edx + field_3860]            # 0046d49f
    movsx eax, word ptr [ebp - local_14]         # 0046d4a6
    shl eax, 0x4                                 # 0046d4aa
    mov dword ptr [edx + eax + field_4], ecx     # 0046d4ad
    movsx ecx, word ptr [ebp - local_c]          # 0046d4b1
    imul ecx, ecx, 0xa0                          # 0046d4b5
    mov edx, dword ptr [ebp - local_30]          # 0046d4bb
    lea eax, [edx + ecx + field_3860]            # 0046d4be
    movsx ecx, word ptr [ebp - local_14]         # 0046d4c5
    shl ecx, 0x4                                 # 0046d4c9
    movsx edx, word ptr [ebp - local_28]         # 0046d4cc
    mov eax, dword ptr [eax + ecx + field_4]     # 0046d4d0
    {load} add eax, edx                          # 0046d4d4
    movsx ecx, word ptr [ebp - local_c]          # 0046d4d6
    imul ecx, ecx, 0xa0                          # 0046d4da
    mov edx, dword ptr [ebp - local_30]          # 0046d4e0
    lea ecx, [edx + ecx + field_3860]            # 0046d4e3
    movsx edx, word ptr [ebp - local_14]         # 0046d4ea
    shl edx, 0x4                                 # 0046d4ee
    mov dword ptr [ecx + edx + field_c], eax     # 0046d4f1
    movsx eax, word ptr [ebp - local_c]          # 0046d4f5
    imul eax, eax, 0xa0                          # 0046d4f9
    mov ecx, dword ptr [ebp - local_30]          # 0046d4ff
    lea edx, [ecx + eax + field_3220]            # 0046d502
    movsx eax, word ptr [ebp - local_14]         # 0046d509
    shl eax, 0x4                                 # 0046d50d
    mov ecx, dword ptr [edx + eax]               # 0046d510
    add ecx, dword ptr [0x583186]                # 0046d513
    movsx edx, word ptr [ebp - local_c]          # 0046d519
    imul edx, edx, 0xa0                          # 0046d51d
    mov eax, dword ptr [ebp - local_30]          # 0046d523
    lea edx, [eax + edx + field_3860]            # 0046d526
    movsx eax, word ptr [ebp - local_14]         # 0046d52d
    shl eax, 0x4                                 # 0046d531
    mov dword ptr [edx + eax], ecx               # 0046d534
    movsx ecx, word ptr [ebp - local_c]          # 0046d537
    imul ecx, ecx, 0xa0                          # 0046d53b
    mov edx, dword ptr [ebp - local_30]          # 0046d541
    lea eax, [edx + ecx + field_3860]            # 0046d544
    movsx ecx, word ptr [ebp - local_14]         # 0046d54b
    shl ecx, 0x4                                 # 0046d54f
    movsx edx, word ptr [ebp - local_4]          # 0046d552
    mov eax, dword ptr [eax + ecx]               # 0046d556
    {load} add eax, edx                          # 0046d559
    movsx ecx, word ptr [ebp - local_c]          # 0046d55b
    imul ecx, ecx, 0xa0                          # 0046d55f
    mov edx, dword ptr [ebp - local_30]          # 0046d565
    lea ecx, [edx + ecx + field_3860]            # 0046d568
    movsx edx, word ptr [ebp - local_14]         # 0046d56f
    shl edx, 0x4                                 # 0046d573
    mov dword ptr [ecx + edx + field_8], eax     # 0046d576
    movsx eax, word ptr [ebp - local_c]          # 0046d57a
    imul eax, eax, 0xa0                          # 0046d57e
    mov ecx, dword ptr [ebp - local_30]          # 0046d584
    lea ecx, [ecx + eax + field_3220]            # 0046d587
    movsx esi, word ptr [ebp - local_14]         # 0046d58e
    shl esi, 0x4                                 # 0046d592
    mov edx, dword ptr [ebp - local_10]          # 0046d595
    movsx eax, word ptr [edx + field_5d]         # 0046d598
    cdq                                          # 0046d59c
    {load} sub eax, edx                          # 0046d59d
    sar eax                                      # 0046d59f
    mov ecx, dword ptr [ecx + esi + field_4]     # 0046d5a1
    {load} sub ecx, eax                          # 0046d5a5
    movsx edx, word ptr [ebp - local_c]          # 0046d5a7
    imul edx, edx, 0x140                         # 0046d5ab
    mov eax, dword ptr [ebp - local_30]          # 0046d5b1
    lea edx, [eax + edx + field_636a]            # 0046d5b4
    movsx eax, word ptr [ebp - local_14]         # 0046d5bb
    shl eax, 0x4                                 # 0046d5bf
    mov dword ptr [edx + eax + field_4], ecx     # 0046d5c2
    movsx ecx, word ptr [ebp - local_c]          # 0046d5c6
    imul ecx, ecx, 0xa0                          # 0046d5ca
    mov edx, dword ptr [ebp - local_30]          # 0046d5d0
    lea ecx, [edx + ecx + field_3220]            # 0046d5d3
    movsx esi, word ptr [ebp - local_14]         # 0046d5da
    shl esi, 0x4                                 # 0046d5de
    mov edx, dword ptr [ebp - local_10]          # 0046d5e1
    movsx eax, word ptr [edx + field_5d]         # 0046d5e4
    cdq                                          # 0046d5e8
    {load} sub eax, edx                          # 0046d5e9
    sar eax                                      # 0046d5eb
    mov ecx, dword ptr [ecx + esi + field_c]     # 0046d5ed
    {load} add ecx, eax                          # 0046d5f1
    movsx edx, word ptr [ebp - local_c]          # 0046d5f3
    imul edx, edx, 0x140                         # 0046d5f7
    mov eax, dword ptr [ebp - local_30]          # 0046d5fd
    lea edx, [eax + edx + field_636a]            # 0046d600
    movsx eax, word ptr [ebp - local_14]         # 0046d607
    shl eax, 0x4                                 # 0046d60b
    mov dword ptr [edx + eax + field_c], ecx     # 0046d60e
    movsx ecx, word ptr [ebp - local_c]          # 0046d612
    imul ecx, ecx, 0xa0                          # 0046d616
    mov edx, dword ptr [ebp - local_30]          # 0046d61c
    lea ecx, [edx + ecx + field_3220]            # 0046d61f
    movsx esi, word ptr [ebp - local_14]         # 0046d626
    shl esi, 0x4                                 # 0046d62a
    mov edx, dword ptr [ebp - local_10]          # 0046d62d
    movsx eax, word ptr [edx + field_5f]         # 0046d630
    cdq                                          # 0046d634
    {load} sub eax, edx                          # 0046d635
    sar eax                                      # 0046d637
    mov ecx, dword ptr [ecx + esi]               # 0046d639
    {load} sub ecx, eax                          # 0046d63c
    movsx edx, word ptr [ebp - local_c]          # 0046d63e
    imul edx, edx, 0x140                         # 0046d642
    mov eax, dword ptr [ebp - local_30]          # 0046d648
    lea edx, [eax + edx + field_636a]            # 0046d64b
    movsx eax, word ptr [ebp - local_14]         # 0046d652
    shl eax, 0x4                                 # 0046d656
    mov dword ptr [edx + eax], ecx               # 0046d659
    movsx ecx, word ptr [ebp - local_c]          # 0046d65c
    imul ecx, ecx, 0xa0                          # 0046d660
    mov edx, dword ptr [ebp - local_30]          # 0046d666
    lea ecx, [edx + ecx + field_3220]            # 0046d669
    movsx esi, word ptr [ebp - local_14]         # 0046d670
    shl esi, 0x4                                 # 0046d674
    mov edx, dword ptr [ebp - local_10]          # 0046d677
    movsx eax, word ptr [edx + field_5f]         # 0046d67a
    cdq                                          # 0046d67e
    {load} sub eax, edx                          # 0046d67f
    sar eax                                      # 0046d681
    mov ecx, dword ptr [ecx + esi + field_8]     # 0046d683
    {load} add ecx, eax                          # 0046d687
    movsx edx, word ptr [ebp - local_c]          # 0046d689
    imul edx, edx, 0x140                         # 0046d68d
    mov eax, dword ptr [ebp - local_30]          # 0046d693
    lea edx, [eax + edx + field_636a]            # 0046d696
    movsx eax, word ptr [ebp - local_14]         # 0046d69d
    shl eax, 0x4                                 # 0046d6a1
    mov dword ptr [edx + eax + field_8], ecx     # 0046d6a4
    jmp.d32 L_0046d350                           # 0046d6a8
L_0046d6ad:
    # block 0x0046d6ad: entered by jge at 0x0046d369, 1 instruction(s), ends with backward jump to 0x0046d329
    jmp.d32 L_0046d329                           # 0046d6ad
L_0046d6b2:
    # block 0x0046d6b2: entered by jge at 0x0046d342, 12 instruction(s), ends with forward jump to 0x0046d6f2
    mov ecx, dword ptr [ebp - local_10]          # 0046d6b2
    mov edx, dword ptr [ebp - local_10]          # 0046d6b5
    mov eax, dword ptr [ecx + field_2f1]         # 0046d6b8
    sub eax, dword ptr [edx + field_2e9]         # 0046d6be
    mov word ptr [ebp - local_20], ax            # 0046d6c4
    mov ecx, dword ptr [ebp - local_10]          # 0046d6c8
    mov edx, dword ptr [ebp - local_10]          # 0046d6cb
    mov eax, dword ptr [ecx + field_2f5]         # 0046d6ce
    sub eax, dword ptr [edx + field_2ed]         # 0046d6d4
    mov word ptr [ebp - local_18], ax            # 0046d6da
    mov word ptr [ebp - local_c], 0x0            # 0046d6de
    jmp.d8 L_0046d6f2                            # 0046d6e4
L_0046d6e6:
    # block 0x0046d6e6: entered by jmp at 0x0046d912, 3 instruction(s), falls into the block at 0x0046d6f2
    mov cx, word ptr [ebp - local_c]             # 0046d6e6
    add cx, 0x1                                  # 0046d6ea
    mov word ptr [ebp - local_c], cx             # 0046d6ee
L_0046d6f2:
    # block 0x0046d6f2: entered by jmp at 0x0046d6e4, 5 instruction(s), ends with jge to 0x0046d917 (forward)
    movsx edx, word ptr [ebp - local_c]          # 0046d6f2
    mov eax, dword ptr [ebp - local_10]          # 0046d6f6
    movsx ecx, word ptr [eax + field_4b]         # 0046d6f9
    {load} cmp edx, ecx                          # 0046d6fd
    jge.d32 L_0046d917                           # 0046d6ff
    # block 0x0046d705: entered by fall-through of jge at 0x0046d6ff, 2 instruction(s), ends with forward jump to 0x0046d719
    mov word ptr [ebp - local_14], 0x0           # 0046d705
    jmp.d8 L_0046d719                            # 0046d70b
L_0046d70d:
    # block 0x0046d70d: entered by jmp at 0x0046d90d, 3 instruction(s), falls into the block at 0x0046d719
    mov dx, word ptr [ebp - local_14]            # 0046d70d
    add dx, 0x1                                  # 0046d711
    mov word ptr [ebp - local_14], dx            # 0046d715
L_0046d719:
    # block 0x0046d719: entered by jmp at 0x0046d70b, 5 instruction(s), ends with jge to 0x0046d912 (forward)
    movsx eax, word ptr [ebp - local_14]         # 0046d719
    mov ecx, dword ptr [ebp - local_10]          # 0046d71d
    movsx edx, word ptr [ecx + field_4d]         # 0046d720
    {load} cmp eax, edx                          # 0046d724
    jge.d32 L_0046d912                           # 0046d726
    # block 0x0046d72c: entered by fall-through of jge at 0x0046d726, 127 instruction(s), ends with backward jump to 0x0046d70d
    mov eax, dword ptr [ebp - local_10]          # 0046d72c
    movsx ecx, word ptr [eax + field_63]         # 0046d72f
    movsx edx, word ptr [ebp - local_c]          # 0046d733
    mov eax, dword ptr [ebp - local_10]          # 0046d737
    movsx eax, word ptr [eax + field_65]         # 0046d73a
    movsx esi, word ptr [ebp - local_18]         # 0046d73e
    {load} add eax, esi                          # 0046d742
    imul edx, eax                                # 0046d744
    {load} add ecx, edx                          # 0046d747
    movsx edx, word ptr [ebp - local_c]          # 0046d749
    shl edx, 0x5                                 # 0046d74d
    mov eax, dword ptr [ebp - local_30]          # 0046d750
    lea edx, [eax + edx + field_3ea0]            # 0046d753
    movsx eax, word ptr [ebp - local_14]         # 0046d75a
    shl eax, 0x4                                 # 0046d75e
    mov dword ptr [edx + eax + field_4], ecx     # 0046d761
    movsx ecx, word ptr [ebp - local_c]          # 0046d765
    shl ecx, 0x5                                 # 0046d769
    mov edx, dword ptr [ebp - local_30]          # 0046d76c
    lea eax, [edx + ecx + field_3ea0]            # 0046d76f
    movsx ecx, word ptr [ebp - local_14]         # 0046d776
    shl ecx, 0x4                                 # 0046d77a
    movsx edx, word ptr [ebp - local_18]         # 0046d77d
    mov eax, dword ptr [eax + ecx + field_4]     # 0046d781
    {load} add eax, edx                          # 0046d785
    movsx ecx, word ptr [ebp - local_c]          # 0046d787
    shl ecx, 0x5                                 # 0046d78b
    mov edx, dword ptr [ebp - local_30]          # 0046d78e
    lea ecx, [edx + ecx + field_3ea0]            # 0046d791
    movsx edx, word ptr [ebp - local_14]         # 0046d798
    shl edx, 0x4                                 # 0046d79c
    mov dword ptr [ecx + edx + field_c], eax     # 0046d79f
    mov eax, dword ptr [ebp - local_10]          # 0046d7a3
    movsx ecx, word ptr [eax + field_61]         # 0046d7a6
    movsx edx, word ptr [ebp - local_14]         # 0046d7aa
    mov eax, dword ptr [ebp - local_10]          # 0046d7ae
    movsx eax, word ptr [eax + field_67]         # 0046d7b1
    movsx esi, word ptr [ebp - local_20]         # 0046d7b5
    {load} add eax, esi                          # 0046d7b9
    imul edx, eax                                # 0046d7bb
    {load} add ecx, edx                          # 0046d7be
    movsx edx, word ptr [ebp - local_c]          # 0046d7c0
    shl edx, 0x5                                 # 0046d7c4
    mov eax, dword ptr [ebp - local_30]          # 0046d7c7
    lea edx, [eax + edx + field_3ea0]            # 0046d7ca
    movsx eax, word ptr [ebp - local_14]         # 0046d7d1
    shl eax, 0x4                                 # 0046d7d5
    mov dword ptr [edx + eax], ecx               # 0046d7d8
    movsx ecx, word ptr [ebp - local_c]          # 0046d7db
    shl ecx, 0x5                                 # 0046d7df
    mov edx, dword ptr [ebp - local_30]          # 0046d7e2
    lea eax, [edx + ecx + field_3ea0]            # 0046d7e5
    movsx ecx, word ptr [ebp - local_14]         # 0046d7ec
    shl ecx, 0x4                                 # 0046d7f0
    movsx edx, word ptr [ebp - local_20]         # 0046d7f3
    mov eax, dword ptr [eax + ecx]               # 0046d7f7
    {load} add eax, edx                          # 0046d7fa
    movsx ecx, word ptr [ebp - local_c]          # 0046d7fc
    shl ecx, 0x5                                 # 0046d800
    mov edx, dword ptr [ebp - local_30]          # 0046d803
    lea ecx, [edx + ecx + field_3ea0]            # 0046d806
    movsx edx, word ptr [ebp - local_14]         # 0046d80d
    shl edx, 0x4                                 # 0046d811
    mov dword ptr [ecx + edx + field_8], eax     # 0046d814
    movsx eax, word ptr [ebp - local_c]          # 0046d818
    shl eax, 0x5                                 # 0046d81c
    mov ecx, dword ptr [ebp - local_30]          # 0046d81f
    lea edx, [ecx + eax + field_3ea0]            # 0046d822
    movsx eax, word ptr [ebp - local_14]         # 0046d829
    shl eax, 0x4                                 # 0046d82d
    mov ecx, dword ptr [edx + eax + field_4]     # 0046d830
    add ecx, dword ptr [0x58318a]                # 0046d834
    movsx edx, word ptr [ebp - local_c]          # 0046d83a
    shl edx, 0x5                                 # 0046d83e
    mov eax, dword ptr [ebp - local_30]          # 0046d841
    lea edx, [eax + edx + field_43a0]            # 0046d844
    movsx eax, word ptr [ebp - local_14]         # 0046d84b
    shl eax, 0x4                                 # 0046d84f
    mov dword ptr [edx + eax + field_4], ecx     # 0046d852
    movsx ecx, word ptr [ebp - local_c]          # 0046d856
    shl ecx, 0x5                                 # 0046d85a
    mov edx, dword ptr [ebp - local_30]          # 0046d85d
    lea eax, [edx + ecx + field_43a0]            # 0046d860
    movsx ecx, word ptr [ebp - local_14]         # 0046d867
    shl ecx, 0x4                                 # 0046d86b
    movsx edx, word ptr [ebp - local_18]         # 0046d86e
    mov eax, dword ptr [eax + ecx + field_4]     # 0046d872
    {load} add eax, edx                          # 0046d876
    movsx ecx, word ptr [ebp - local_c]          # 0046d878
    shl ecx, 0x5                                 # 0046d87c
    mov edx, dword ptr [ebp - local_30]          # 0046d87f
    lea ecx, [edx + ecx + field_43a0]            # 0046d882
    movsx edx, word ptr [ebp - local_14]         # 0046d889
    shl edx, 0x4                                 # 0046d88d
    mov dword ptr [ecx + edx + field_c], eax     # 0046d890
    movsx eax, word ptr [ebp - local_c]          # 0046d894
    shl eax, 0x5                                 # 0046d898
    mov ecx, dword ptr [ebp - local_30]          # 0046d89b
    lea edx, [ecx + eax + field_3ea0]            # 0046d89e
    movsx eax, word ptr [ebp - local_14]         # 0046d8a5
    shl eax, 0x4                                 # 0046d8a9
    mov ecx, dword ptr [edx + eax]               # 0046d8ac
    add ecx, dword ptr [0x583186]                # 0046d8af
    movsx edx, word ptr [ebp - local_c]          # 0046d8b5
    shl edx, 0x5                                 # 0046d8b9
    mov eax, dword ptr [ebp - local_30]          # 0046d8bc
    lea edx, [eax + edx + field_43a0]            # 0046d8bf
    movsx eax, word ptr [ebp - local_14]         # 0046d8c6
    shl eax, 0x4                                 # 0046d8ca
    mov dword ptr [edx + eax], ecx               # 0046d8cd
    movsx ecx, word ptr [ebp - local_c]          # 0046d8d0
    shl ecx, 0x5                                 # 0046d8d4
    mov edx, dword ptr [ebp - local_30]          # 0046d8d7
    lea eax, [edx + ecx + field_43a0]            # 0046d8da
    movsx ecx, word ptr [ebp - local_14]         # 0046d8e1
    shl ecx, 0x4                                 # 0046d8e5
    movsx edx, word ptr [ebp - local_20]         # 0046d8e8
    mov eax, dword ptr [eax + ecx]               # 0046d8ec
    {load} add eax, edx                          # 0046d8ef
    movsx ecx, word ptr [ebp - local_c]          # 0046d8f1
    shl ecx, 0x5                                 # 0046d8f5
    mov edx, dword ptr [ebp - local_30]          # 0046d8f8
    lea ecx, [edx + ecx + field_43a0]            # 0046d8fb
    movsx edx, word ptr [ebp - local_14]         # 0046d902
    shl edx, 0x4                                 # 0046d906
    mov dword ptr [ecx + edx + field_8], eax     # 0046d909
    jmp.d32 L_0046d70d                           # 0046d90d
L_0046d912:
    # block 0x0046d912: entered by jge at 0x0046d726, 1 instruction(s), ends with backward jump to 0x0046d6e6
    jmp.d32 L_0046d6e6                           # 0046d912
L_0046d917:
    # block 0x0046d917: entered by jge at 0x0046d6ff, 78 instruction(s), calls FUN_004d39f9, ends with jne to 0x0046da7b (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046d917
    mov ecx, dword ptr [ebp - local_10]          # 0046d91a
    mov edx, dword ptr [eax + field_71]          # 0046d91d
    sub edx, dword ptr [ecx + field_69]          # 0046d920
    mov eax, dword ptr [ebp - local_30]          # 0046d923
    mov word ptr [eax + field_816a], dx          # 0046d926
    mov ecx, dword ptr [ebp - local_10]          # 0046d92d
    mov edx, dword ptr [ebp - local_10]          # 0046d930
    mov eax, dword ptr [ecx + field_75]          # 0046d933
    sub eax, dword ptr [edx + field_6d]          # 0046d936
    mov ecx, dword ptr [ebp - local_30]          # 0046d939
    mov word ptr [ecx + field_816c], ax          # 0046d93c
    mov edx, dword ptr [ebp - local_30]          # 0046d943
    movsx eax, word ptr [edx + field_816a]       # 0046d946
    sar eax                                      # 0046d94d
    mov ecx, dword ptr [ebp - local_30]          # 0046d94f
    mov word ptr [ecx + field_816e], ax          # 0046d952
    mov edx, dword ptr [ebp - local_30]          # 0046d959
    movsx eax, word ptr [edx + field_816c]       # 0046d95c
    sar eax                                      # 0046d963
    mov ecx, dword ptr [ebp - local_30]          # 0046d965
    mov word ptr [ecx + field_8170], ax          # 0046d968
    call FUN_004d39f9                            # 0046d96f
    mov edx, dword ptr [ebp - local_30]          # 0046d974
    mov word ptr [edx + field_1c], ax            # 0046d977
    mov eax, dword ptr [ebp - local_30]          # 0046d97b
    movsx ecx, word ptr [eax + field_1c]         # 0046d97e
    imul ecx, ecx, 0x4a                          # 0046d982
    mov dword ptr [ecx + 0x5d1591], 0xa          # 0046d985
    mov edx, dword ptr [ebp - local_30]          # 0046d98f
    movsx eax, word ptr [edx + field_1c]         # 0046d992
    imul eax, eax, 0x4a                          # 0046d996
    mov dword ptr [eax + 0x5d1595], 0x46deb0     # 0046d999
    mov ecx, dword ptr [ebp - local_30]          # 0046d9a3
    movsx edx, word ptr [ecx + field_1c]         # 0046d9a6
    imul edx, edx, 0x4a                          # 0046d9aa
    mov dword ptr [edx + 0x5d1599], 0x0          # 0046d9ad
    mov eax, dword ptr [ebp - local_30]          # 0046d9b7
    movsx ecx, word ptr [eax + field_1c]         # 0046d9ba
    imul ecx, ecx, 0x4a                          # 0046d9be
    mov dword ptr [ecx + 0x5d159d], 0x0          # 0046d9c1
    mov edx, dword ptr [ebp - local_30]          # 0046d9cb
    movsx eax, word ptr [edx + field_1c]         # 0046d9ce
    imul eax, eax, 0x4a                          # 0046d9d2
    mov dword ptr [eax + 0x5d15a1], 0x0          # 0046d9d5
    mov ecx, dword ptr [ebp - local_30]          # 0046d9df
    movsx edx, word ptr [ecx + field_1c]         # 0046d9e2
    imul edx, edx, 0x4a                          # 0046d9e6
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0046d9e9
    mov eax, dword ptr [ebp - local_30]          # 0046d9f3
    movsx ecx, word ptr [eax + field_1c]         # 0046d9f6
    imul ecx, ecx, 0x4a                          # 0046d9fa
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 0046d9fd
    mov edx, dword ptr [ebp - local_30]          # 0046da07
    movsx eax, word ptr [edx + field_1c]         # 0046da0a
    imul eax, eax, 0x4a                          # 0046da0e
    mov word ptr [eax + 0x5d15ad], 0x0           # 0046da11
    mov edi, 0x54bd18                            # 0046da1a
    mov ecx, dword ptr [ebp - local_30]          # 0046da1f
    movsx edx, word ptr [ecx + field_1c]         # 0046da22
    imul edx, edx, 0x4a                          # 0046da26
    add edx, 0x5d15b3                            # 0046da29
    or ecx, -0x1                                 # 0046da2f
    {load} xor eax, eax                          # 0046da32
    repne scasb al, byte ptr es:[edi]            # 0046da34
    not ecx                                      # 0046da36
    {load} sub edi, ecx                          # 0046da38
    {load} mov esi, edi                          # 0046da3a
    {load} mov eax, ecx                          # 0046da3c
    {load} mov edi, edx                          # 0046da3e
    shr ecx, 0x2                                 # 0046da40
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046da43
    {load} mov ecx, eax                          # 0046da45
    and ecx, 0x3                                 # 0046da47
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0046da4a
    mov ecx, dword ptr [ebp - local_30]          # 0046da4c
    cmp dword ptr [ecx + field_4a40], 0x0        # 0046da4f
    jne.d8 L_0046da7b                            # 0046da56
    # block 0x0046da58: entered by fall-through of jne at 0x0046da56, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0046da7b
    push 0x54bd34                                # 0046da58
    push 0x6                                     # 0046da5d
    mov edx, dword ptr [ebp - local_10]          # 0046da5f
    push edx                                     # 0046da62
    push 0x54bd60                                # 0046da63
    mov ecx, 0x5cf659                            # 0046da68
    call FUN_004c2790                            # 0046da6d
    mov ecx, dword ptr [ebp - local_30]          # 0046da72
    mov dword ptr [ecx + field_4a40], eax        # 0046da75
L_0046da7b:
    # block 0x0046da7b: entered by jne at 0x0046da56, 3 instruction(s), ends with jne to 0x0046daad (forward)
    mov edx, dword ptr [ebp - local_30]          # 0046da7b
    cmp dword ptr [edx + field_4a44], 0x0        # 0046da7e
    jne.d8 L_0046daad                            # 0046da85
    # block 0x0046da87: entered by fall-through of jne at 0x0046da85, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x0046daad
    push 0x54bd68                                # 0046da87
    push 0x6                                     # 0046da8c
    mov eax, dword ptr [ebp - local_10]          # 0046da8e
    add eax, 0x21                                # 0046da91
    push eax                                     # 0046da94
    push 0x54bd88                                # 0046da95
    mov ecx, 0x5cf659                            # 0046da9a
    call FUN_004c2790                            # 0046da9f
    mov ecx, dword ptr [ebp - local_30]          # 0046daa4
    mov dword ptr [ecx + field_4a44], eax        # 0046daa7
L_0046daad:
    # block 0x0046daad: entered by jne at 0x0046da85, 13 instruction(s), ends with je to 0x0046daf3 (forward)
    mov edx, dword ptr [ebp - local_30]          # 0046daad
    movsx eax, word ptr [edx + field_1c]         # 0046dab0
    imul eax, eax, 0x4a                          # 0046dab4
    mov ecx, dword ptr [ebp - local_30]          # 0046dab7
    mov edx, dword ptr [ecx + field_4a40]        # 0046daba
    mov dword ptr [eax + 0x5d1599], edx          # 0046dac0
    mov edi, 0x54bd90                            # 0046dac6
    mov esi, dword ptr [ebp - local_10]          # 0046dacb
    add esi, 0x60c                               # 0046dace
    mov ecx, 0x9                                 # 0046dad4
    {load} xor eax, eax                          # 0046dad9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046dadb
    je.d8 L_0046daf3                             # 0046dadd
    # block 0x0046dadf: entered by fall-through of je at 0x0046dadd, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046daf3
    mov ecx, dword ptr [ebp - local_10]          # 0046dadf
    add ecx, 0x60c                               # 0046dae2
    push ecx                                     # 0046dae8
    mov ecx, 0x5c3a67                            # 0046dae9
    call FUN_004fb77a                            # 0046daee
L_0046daf3:
    # block 0x0046daf3: entered by je at 0x0046dadd, 7 instruction(s), ends with je to 0x0046db1f (forward)
    mov edi, 0x54bd9c                            # 0046daf3
    mov esi, dword ptr [ebp - local_10]          # 0046daf8
    add esi, 0x63d                               # 0046dafb
    mov ecx, 0x9                                 # 0046db01
    {load} xor edx, edx                          # 0046db06
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046db08
    je.d8 L_0046db1f                             # 0046db0a
    # block 0x0046db0c: entered by fall-through of je at 0x0046db0a, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046db1f
    mov eax, dword ptr [ebp - local_10]          # 0046db0c
    add eax, 0x63d                               # 0046db0f
    push eax                                     # 0046db14
    mov ecx, 0x5c3a67                            # 0046db15
    call FUN_004fb77a                            # 0046db1a
L_0046db1f:
    # block 0x0046db1f: entered by je at 0x0046db0a, 13 instruction(s), calls FUN_0046b75b, ends with forward jump to 0x0046de98
    mov ecx, dword ptr [ebp - local_30]          # 0046db1f
    call FUN_0046b75b                            # 0046db22
    mov ecx, dword ptr [ebp - local_30]          # 0046db27
    mov byte ptr [ecx + field_4a59], 0x0         # 0046db2a
    mov edx, dword ptr [ebp - local_30]          # 0046db31
    mov byte ptr [edx + field_4a54], 0x0         # 0046db34
    mov eax, dword ptr [ebp - local_30]          # 0046db3b
    mov dword ptr [eax + field_4a55], 0x0        # 0046db3e
    mov ecx, dword ptr [ebp - local_30]          # 0046db48
    movsx edx, word ptr [ecx + field_1e]         # 0046db4b
    imul edx, edx, 0x8d                          # 0046db4f
    mov dword ptr [edx + 0x5bb632], 0x1          # 0046db55
    jmp.d32 L_0046de98                           # 0046db5f
L_0046db64:
    # block 0x0046db64: entered by je at 0x0046cddb, 5 instruction(s), ends with je to 0x0046dbea (forward)
    mov eax, dword ptr [ebp - local_30]          # 0046db64
    mov ecx, dword ptr [eax + field_4a55]        # 0046db67
    mov dword ptr [ebp - local_38], ecx          # 0046db6d
    cmp dword ptr [ebp - local_38], 0x1          # 0046db70
    je.d8 L_0046dbea                             # 0046db74
    # block 0x0046db76: entered by fall-through of je at 0x0046db74, 2 instruction(s), ends with je to 0x0046db81 (forward)
    cmp dword ptr [ebp - local_38], 0x2          # 0046db76
    je.d8 L_0046db81                             # 0046db7a
    # block 0x0046db7c: entered by fall-through of je at 0x0046db7a, 1 instruction(s), ends with forward jump to 0x0046dc33
    jmp.d32 L_0046dc33                           # 0046db7c
L_0046db81:
    # block 0x0046db81: entered by je at 0x0046db7a, 7 instruction(s), ends with je to 0x0046dbd1 (forward)
    mov edi, 0x54bda8                            # 0046db81
    mov esi, dword ptr [ebp - local_10]          # 0046db86
    add esi, 0x687                               # 0046db89
    mov ecx, 0x9                                 # 0046db8f
    {load} xor edx, edx                          # 0046db94
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046db96
    je.d8 L_0046dbd1                             # 0046db98
    # block 0x0046db9a: entered by fall-through of je at 0x0046db98, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0046dbe8
    mov eax, dword ptr [ebp - local_10]          # 0046db9a
    add eax, 0x687                               # 0046db9d
    push eax                                     # 0046dba2
    mov ecx, 0x5c3a67                            # 0046dba3
    call FUN_004fb77a                            # 0046dba8
    mov ecx, dword ptr [ebp - local_10]          # 0046dbad
    mov dx, word ptr [ecx + field_6a8]           # 0046dbb0
    push edx                                     # 0046dbb7
    mov ecx, 0x5c3a67                            # 0046dbb8
    call FUN_004fb2e3                            # 0046dbbd
    mov eax, dword ptr [ebp - local_30]          # 0046dbc2
    mov dword ptr [eax + field_4a55], 0x1        # 0046dbc5
    jmp.d8 L_0046dbe8                            # 0046dbcf
L_0046dbd1:
    # block 0x0046dbd1: entered by je at 0x0046db98, 4 instruction(s), falls into the block at 0x0046dbe8
    mov ecx, dword ptr [ebp - local_30]          # 0046dbd1
    movsx edx, word ptr [ecx + field_1e]         # 0046dbd4
    imul edx, edx, 0x8d                          # 0046dbd8
    mov dword ptr [edx + 0x5bb632], 0x2          # 0046dbde
L_0046dbe8:
    # block 0x0046dbe8: entered by jmp at 0x0046dbcf, 1 instruction(s), ends with forward jump to 0x0046dc33
    jmp.d8 L_0046dc33                            # 0046dbe8
L_0046dbea:
    # block 0x0046dbea: entered by je at 0x0046db74, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0046dc33 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046dbea
    movsx ecx, word ptr [eax + field_6a8]        # 0046dbed
    mov dword ptr [ebp - local_2c], ecx          # 0046dbf4
    mov edx, dword ptr [ebp - local_2c]          # 0046dbf7
    push edx                                     # 0046dbfa
    mov ecx, 0x5cf1eb                            # 0046dbfb
    call FUN_004f6334                            # 0046dc00
    test eax, eax                                # 0046dc05
    jne.d8 L_0046dc33                            # 0046dc07
    # block 0x0046dc09: entered by fall-through of jne at 0x0046dc07, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x0046dc33
    mov eax, dword ptr [ebp - local_10]          # 0046dc09
    add eax, 0x687                               # 0046dc0c
    push eax                                     # 0046dc11
    mov ecx, 0x5c3a67                            # 0046dc12
    call FUN_004fba69                            # 0046dc17
    mov ecx, dword ptr [ebp - local_30]          # 0046dc1c
    movsx edx, word ptr [ecx + field_1e]         # 0046dc1f
    imul edx, edx, 0x8d                          # 0046dc23
    mov dword ptr [edx + 0x5bb632], 0x2          # 0046dc29
L_0046dc33:
    # block 0x0046dc33: entered by jmp at 0x0046db7c; jmp at 0x0046dbe8; jne at 0x0046dc07, 1 instruction(s), ends with forward jump to 0x0046de98
    jmp.d32 L_0046de98                           # 0046dc33
L_0046dc38:
    # block 0x0046dc38: entered by je at 0x0046cde5, 8 instruction(s), ends with je to 0x0046dc6f (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0046dc38
    mov edi, 0x54bdb4                            # 0046dc42
    mov esi, dword ptr [ebp - local_10]          # 0046dc47
    add esi, 0x60c                               # 0046dc4a
    mov ecx, 0x9                                 # 0046dc50
    {load} xor eax, eax                          # 0046dc55
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046dc57
    je.d8 L_0046dc6f                             # 0046dc59
    # block 0x0046dc5b: entered by fall-through of je at 0x0046dc59, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0046dc6f
    mov ecx, dword ptr [ebp - local_10]          # 0046dc5b
    add ecx, 0x60c                               # 0046dc5e
    push ecx                                     # 0046dc64
    mov ecx, 0x5c3a67                            # 0046dc65
    call FUN_004fba69                            # 0046dc6a
L_0046dc6f:
    # block 0x0046dc6f: entered by je at 0x0046dc59, 7 instruction(s), ends with je to 0x0046dc9b (forward)
    mov edi, 0x54bdc0                            # 0046dc6f
    mov esi, dword ptr [ebp - local_10]          # 0046dc74
    add esi, 0x63d                               # 0046dc77
    mov ecx, 0x9                                 # 0046dc7d
    {load} xor edx, edx                          # 0046dc82
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046dc84
    je.d8 L_0046dc9b                             # 0046dc86
    # block 0x0046dc88: entered by fall-through of je at 0x0046dc86, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x0046dc9b
    mov eax, dword ptr [ebp - local_10]          # 0046dc88
    add eax, 0x63d                               # 0046dc8b
    push eax                                     # 0046dc90
    mov ecx, 0x5c3a67                            # 0046dc91
    call FUN_004fba69                            # 0046dc96
L_0046dc9b:
    # block 0x0046dc9b: entered by je at 0x0046dc86, 5 instruction(s), ends with je to 0x0046dd90 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 0046dc9b
    {load} xor edx, edx                          # 0046dc9e
    mov dl, byte ptr [ecx + field_4a54]          # 0046dca0
    test edx, edx                                # 0046dca6
    je.d32 L_0046dd90                            # 0046dca8
    # block 0x0046dcae: entered by fall-through of je at 0x0046dca8, 4 instruction(s), ends with je to 0x0046dd60 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046dcae
    movsx ecx, word ptr [eax + field_6b8]        # 0046dcb1
    cmp ecx, 0x270f                              # 0046dcb8
    je.d32 L_0046dd60                            # 0046dcbe
    # block 0x0046dcc4: entered by fall-through of je at 0x0046dcbe, 25 instruction(s), ends with jne to 0x0046dd4c (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046dcc4
    movsx eax, word ptr [edx + field_6b8]        # 0046dcc7
    mov dword ptr [0x5bb57b], eax                # 0046dcce
    mov ecx, dword ptr [ebp - local_10]          # 0046dcd3
    mov dx, word ptr [ecx + field_6ba]           # 0046dcd6
    mov word ptr [0x5bb599], dx                  # 0046dcdd
    mov eax, dword ptr [ebp - local_10]          # 0046dce4
    mov cx, word ptr [eax + field_6bc]           # 0046dce7
    mov word ptr [0x5bb595], cx                  # 0046dcee
    mov edx, dword ptr [ebp - local_10]          # 0046dcf5
    mov ax, word ptr [edx + field_6be]           # 0046dcf8
    mov word ptr [0x5c39ff], ax                  # 0046dcff
    mov ecx, dword ptr [ebp - local_10]          # 0046dd05
    mov edx, dword ptr [ecx + field_6c0]         # 0046dd08
    mov dword ptr [0x5bb59b], edx                # 0046dd0e
    mov eax, dword ptr [ebp - local_10]          # 0046dd14
    mov ecx, dword ptr [eax + field_6c4]         # 0046dd17
    mov dword ptr [0x5bb59f], ecx                # 0046dd1d
    mov edx, dword ptr [ebp - local_10]          # 0046dd23
    mov eax, dword ptr [edx + field_6c8]         # 0046dd26
    mov dword ptr [0x5bb5a3], eax                # 0046dd2c
    mov ecx, dword ptr [ebp - local_10]          # 0046dd31
    movsx edx, word ptr [ecx + field_6cc]        # 0046dd34
    cmp edx, 0x1                                 # 0046dd3b
    jne.d8 L_0046dd4c                            # 0046dd3e
    # block 0x0046dd40: entered by fall-through of jne at 0x0046dd3e, 2 instruction(s), ends with forward jump to 0x0046dd56
    mov dword ptr [0x5bb1ca], 0x0                # 0046dd40
    jmp.d8 L_0046dd56                            # 0046dd4a
L_0046dd4c:
    # block 0x0046dd4c: entered by jne at 0x0046dd3e, 1 instruction(s), falls into the block at 0x0046dd56
    mov dword ptr [0x5bb1ca], 0x1                # 0046dd4c
L_0046dd56:
    # block 0x0046dd56: entered by jmp at 0x0046dd4a, 1 instruction(s), falls into the block at 0x0046dd60
    mov dword ptr [0x583999], 0x4                # 0046dd56
L_0046dd60:
    # block 0x0046dd60: entered by je at 0x0046dcbe, 4 instruction(s), ends with je to 0x0046dd8b (forward)
    mov eax, dword ptr [ebp - local_10]          # 0046dd60
    movsx ecx, word ptr [eax + field_6ce]        # 0046dd63
    cmp ecx, -0x1                                # 0046dd6a
    je.d8 L_0046dd8b                             # 0046dd6d
    # block 0x0046dd6f: entered by fall-through of je at 0x0046dd6d, 6 instruction(s), falls into the block at 0x0046dd8b
    mov edx, dword ptr [ebp - local_10]          # 0046dd6f
    {load} xor eax, eax                          # 0046dd72
    mov al, byte ptr [edx + field_6d0]           # 0046dd74
    mov ecx, dword ptr [ebp - local_10]          # 0046dd7a
    movsx edx, word ptr [ecx + field_6ce]        # 0046dd7d
    mov dword ptr [4*edx + 0x585801], eax        # 0046dd84
L_0046dd8b:
    # block 0x0046dd8b: entered by je at 0x0046dd6d, 1 instruction(s), ends with forward jump to 0x0046de80
    jmp.d32 L_0046de80                           # 0046dd8b
L_0046dd90:
    # block 0x0046dd90: entered by je at 0x0046dca8, 5 instruction(s), ends with je to 0x0046de80 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0046dd90
    {load} xor ecx, ecx                          # 0046dd93
    mov cl, byte ptr [eax + field_4a59]          # 0046dd95
    test ecx, ecx                                # 0046dd9b
    je.d32 L_0046de80                            # 0046dd9d
    # block 0x0046dda3: entered by fall-through of je at 0x0046dd9d, 4 instruction(s), ends with je to 0x0046de55 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046dda3
    movsx eax, word ptr [edx + field_66e]        # 0046dda6
    cmp eax, 0x270f                              # 0046ddad
    je.d32 L_0046de55                            # 0046ddb2
    # block 0x0046ddb8: entered by fall-through of je at 0x0046ddb2, 25 instruction(s), ends with jne to 0x0046de41 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0046ddb8
    movsx edx, word ptr [ecx + field_66e]        # 0046ddbb
    mov dword ptr [0x5bb57b], edx                # 0046ddc2
    mov eax, dword ptr [ebp - local_10]          # 0046ddc8
    mov cx, word ptr [eax + field_670]           # 0046ddcb
    mov word ptr [0x5bb599], cx                  # 0046ddd2
    mov edx, dword ptr [ebp - local_10]          # 0046ddd9
    mov ax, word ptr [edx + field_672]           # 0046dddc
    mov word ptr [0x5bb595], ax                  # 0046dde3
    mov ecx, dword ptr [ebp - local_10]          # 0046dde9
    mov dx, word ptr [ecx + field_674]           # 0046ddec
    mov word ptr [0x5c39ff], dx                  # 0046ddf3
    mov eax, dword ptr [ebp - local_10]          # 0046ddfa
    mov ecx, dword ptr [eax + field_676]         # 0046ddfd
    mov dword ptr [0x5bb59b], ecx                # 0046de03
    mov edx, dword ptr [ebp - local_10]          # 0046de09
    mov eax, dword ptr [edx + field_67a]         # 0046de0c
    mov dword ptr [0x5bb59f], eax                # 0046de12
    mov ecx, dword ptr [ebp - local_10]          # 0046de17
    mov edx, dword ptr [ecx + field_67e]         # 0046de1a
    mov dword ptr [0x5bb5a3], edx                # 0046de20
    mov eax, dword ptr [ebp - local_10]          # 0046de26
    movsx ecx, word ptr [eax + field_682]        # 0046de29
    cmp ecx, 0x1                                 # 0046de30
    jne.d8 L_0046de41                            # 0046de33
    # block 0x0046de35: entered by fall-through of jne at 0x0046de33, 2 instruction(s), ends with forward jump to 0x0046de4b
    mov dword ptr [0x5bb1ca], 0x0                # 0046de35
    jmp.d8 L_0046de4b                            # 0046de3f
L_0046de41:
    # block 0x0046de41: entered by jne at 0x0046de33, 1 instruction(s), falls into the block at 0x0046de4b
    mov dword ptr [0x5bb1ca], 0x1                # 0046de41
L_0046de4b:
    # block 0x0046de4b: entered by jmp at 0x0046de3f, 1 instruction(s), falls into the block at 0x0046de55
    mov dword ptr [0x583999], 0x4                # 0046de4b
L_0046de55:
    # block 0x0046de55: entered by je at 0x0046ddb2, 4 instruction(s), ends with je to 0x0046de80 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046de55
    movsx eax, word ptr [edx + field_684]        # 0046de58
    cmp eax, -0x1                                # 0046de5f
    je.d8 L_0046de80                             # 0046de62
    # block 0x0046de64: entered by fall-through of je at 0x0046de62, 6 instruction(s), falls into the block at 0x0046de80
    mov ecx, dword ptr [ebp - local_10]          # 0046de64
    {load} xor edx, edx                          # 0046de67
    mov dl, byte ptr [ecx + field_686]           # 0046de69
    mov eax, dword ptr [ebp - local_10]          # 0046de6f
    movsx ecx, word ptr [eax + field_684]        # 0046de72
    mov dword ptr [4*ecx + 0x585801], edx        # 0046de79
L_0046de80:
    # block 0x0046de80: entered by jmp at 0x0046dd8b; je at 0x0046dd9d; je at 0x0046de62, 7 instruction(s), calls FUN_0042ba3a, FUN_0046b67f, falls into the block at 0x0046de98
    mov edx, dword ptr [ebp - local_30]          # 0046de80
    mov ax, word ptr [edx + field_1e]            # 0046de83
    push eax                                     # 0046de87
    call FUN_0042ba3a                            # 0046de88
    add esp, 0x4                                 # 0046de8d
    mov ecx, dword ptr [ebp - local_30]          # 0046de90
    call FUN_0046b67f                            # 0046de93
L_0046de98:
    # block 0x0046de98: entered by jmp at 0x0046cdeb; jmp at 0x0046db5f; jmp at 0x0046dc33, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0046de98
    pop esi                                      # 0046de99
    {load} mov esp, ebp                          # 0046de9a
    pop ebp                                      # 0046de9c
    ret 0x4                                      # 0046de9d

