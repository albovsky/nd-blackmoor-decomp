# FUN_0048d914
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d914
# extent:       0x0048d914-0x0048deb3 (1439 code bytes)
# span:         0x0048d914-0x0048dec7 (code 1439, tables 20, padding 0)
# sha256:       419c9644e2a18bc30bb475c29e1bf8418b0ac08c559f2706cff52e7d7c66c4c2
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48d914_step_scene
# naming:       native port src/original_methods_fl21a.c:m48d914_step_scene (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m48d914_step_scene. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on 300 random fixtures, every instruction reached. Oracle window runs all 1459 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_e, field_1c, field_24, field_26, field_2b, field_33, field_37, field_746, field_74c and 7 more; [ecx + n] field_1c, field_1e, field_20, field_24, field_26, field_2f, field_38, field_39, field_746, field_74a, field_752, field_75c and 5 more; [edx + n] field_1c, field_25, field_2f, field_37, field_38, field_39, field_748, field_74e, field_75a, field_75c, field_75f, field_792 and 3 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, KERNEL32.dll!GetTickCount, FUN_004fba69, FUN_0048d89e, FUN_004fb77a, FUN_004fb2e3, FUN_004f6334, FUN_0042ba3a, FUN_0048d09c
# track-n:      outputs/blackmoor-decomp/src/action_family_d0_runtime.h:d0_step (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 338 instruction(s), 19 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_26, 0x26  # offset +0x26
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2f, 0x2f  # offset +0x2f
.equ field_33, 0x33  # offset +0x33
.equ field_37, 0x37  # offset +0x37
.equ field_38, 0x38  # offset +0x38
.equ field_39, 0x39  # offset +0x39
.equ field_746, 0x746  # offset +0x746
.equ field_748, 0x748  # offset +0x748
.equ field_74a, 0x74a  # offset +0x74a
.equ field_74c, 0x74c  # offset +0x74c
.equ field_74e, 0x74e  # offset +0x74e
.equ field_752, 0x752  # offset +0x752
.equ field_756, 0x756  # offset +0x756
.equ field_75a, 0x75a  # offset +0x75a
.equ field_75c, 0x75c  # offset +0x75c
.equ field_75e, 0x75e  # offset +0x75e
.equ field_75f, 0x75f  # offset +0x75f
.equ field_782, 0x782  # offset +0x782
.equ field_792, 0x792  # offset +0x792
.equ field_794, 0x794  # offset +0x794
.equ field_796, 0x796  # offset +0x796
.equ field_798, 0x798  # offset +0x798
.equ field_79a, 0x79a  # offset +0x79a
.equ field_79e, 0x79e  # offset +0x79e
.equ field_7a2, 0x7a2  # offset +0x7a2
.equ field_7a6, 0x7a6  # offset +0x7a6
.equ field_7a8, 0x7a8  # offset +0x7a8
.equ field_7aa, 0x7aa  # offset +0x7aa

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0048d09c, .text + (0x0048d09c - 0x401000)
.set FUN_0048d89e, .text + (0x0048d89e - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x0048d914 - 0x401000
.globl FUN_0048d914
FUN_0048d914:
    # block 0x0048d914: entry, 16 instruction(s), ends with je to 0x0048d964 (forward)
    push ebp                                     # 0048d914
    {load} mov ebp, esp                          # 0048d915
    sub esp, 0x14                                # 0048d917
    push esi                                     # 0048d91a
    push edi                                     # 0048d91b
    mov dword ptr [ebp - local_c], ecx           # 0048d91c
    movsx eax, word ptr [ebp + arg_8]            # 0048d91f
    imul eax, eax, 0x8d                          # 0048d923
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048d929
    mov dword ptr [ebp - local_4], ecx           # 0048d92f
    movsx edx, word ptr [ebp + arg_8]            # 0048d932
    imul edx, edx, 0x8d                          # 0048d936
    mov eax, dword ptr [edx + 0x5bb632]          # 0048d93c
    mov dword ptr [ebp - local_10], eax          # 0048d942
    cmp dword ptr [ebp - local_10], 0x0          # 0048d945
    je.d8 L_0048d964                             # 0048d949
    # block 0x0048d94b: entered by fall-through of je at 0x0048d949, 2 instruction(s), ends with je to 0x0048db41 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 0048d94b
    je.d32 L_0048db41                            # 0048d94f
    # block 0x0048d955: entered by fall-through of je at 0x0048d94f, 2 instruction(s), ends with je to 0x0048dca9 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 0048d955
    je.d32 L_0048dca9                            # 0048d959
    # block 0x0048d95f: entered by fall-through of je at 0x0048d959, 1 instruction(s), ends with forward jump to 0x0048deab
    jmp.d32 L_0048deab                           # 0048d95f
L_0048d964:
    # block 0x0048d964: entered by je at 0x0048d949, 34 instruction(s), calls FUN_004e8d96, ends with jne to 0x0048d9f3 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048d964
    mov dx, word ptr [ebp + arg_8]               # 0048d967
    mov word ptr [ecx + field_1e], dx            # 0048d96b
    mov eax, dword ptr [ebp - local_c]           # 0048d96f
    mov dword ptr [eax + field_33], 0x1          # 0048d972
    mov ecx, dword ptr [ebp - local_c]           # 0048d979
    mov byte ptr [ecx + field_26], 0x0           # 0048d97c
    mov edx, dword ptr [ebp - local_c]           # 0048d980
    mov byte ptr [edx + field_25], 0x0           # 0048d983
    mov eax, dword ptr [ebp - local_c]           # 0048d987
    mov byte ptr [eax + field_24], 0x0           # 0048d98a
    mov ecx, dword ptr [ebp - local_c]           # 0048d98e
    mov dword ptr [ecx + field_20], 0x0          # 0048d991
    mov dword ptr [0x5bb1ca], 0x1                # 0048d998
    mov ecx, 0x571442                            # 0048d9a2
    call FUN_004e8d96                            # 0048d9a7
    {load} xor edx, edx                          # 0048d9ac
    mov eax, dword ptr [ebp - local_c]           # 0048d9ae
    add eax, 0x3d                                # 0048d9b1
    mov dword ptr [eax], edx                     # 0048d9b4
    mov dword ptr [eax + field_4], edx           # 0048d9b6
    mov dword ptr [eax + field_8], edx           # 0048d9b9
    mov word ptr [eax + field_c], dx             # 0048d9bc
    mov byte ptr [eax + field_e], dl             # 0048d9c0
    mov ecx, dword ptr [ebp - local_c]           # 0048d9c3
    mov byte ptr [ecx + field_38], 0x0           # 0048d9c6
    mov edx, dword ptr [ebp - local_c]           # 0048d9ca
    mov byte ptr [edx + field_37], 0x0           # 0048d9cd
    mov edi, 0x63a8ac                            # 0048d9d1
    mov esi, dword ptr [ebp - local_4]           # 0048d9d6
    mov ecx, 0x1                                 # 0048d9d9
    {load} xor eax, eax                          # 0048d9de
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048d9e0
    jne.d8 L_0048d9f3                            # 0048d9e2
    # block 0x0048d9e4: entered by fall-through of jne at 0x0048d9e2, 3 instruction(s), ends with forward jump to 0x0048db1b
    mov ecx, dword ptr [ebp - local_c]           # 0048d9e4
    mov dword ptr [ecx + field_2f], 0x0          # 0048d9e7
    jmp.d32 L_0048db1b                           # 0048d9ee
L_0048d9f3:
    # block 0x0048d9f3: entered by jne at 0x0048d9e2, 59 instruction(s), calls FUN_004d39f9, ends with jne to 0x0048db05 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048d9f3
    mov dword ptr [edx + field_2f], 0x1          # 0048d9f6
    call FUN_004d39f9                            # 0048d9fd
    mov ecx, dword ptr [ebp - local_c]           # 0048da02
    mov word ptr [ecx + field_1c], ax            # 0048da05
    mov edx, dword ptr [ebp - local_c]           # 0048da09
    movsx eax, word ptr [edx + field_1c]         # 0048da0c
    imul eax, eax, 0x4a                          # 0048da10
    mov dword ptr [eax + 0x5d1591], 0xa          # 0048da13
    mov ecx, dword ptr [ebp - local_c]           # 0048da1d
    movsx edx, word ptr [ecx + field_1c]         # 0048da20
    imul edx, edx, 0x4a                          # 0048da24
    mov dword ptr [edx + 0x5d1595], 0x48ded7     # 0048da27
    mov eax, dword ptr [ebp - local_c]           # 0048da31
    movsx ecx, word ptr [eax + field_1c]         # 0048da34
    imul ecx, ecx, 0x4a                          # 0048da38
    mov dword ptr [ecx + 0x5d1599], 0x0          # 0048da3b
    mov edx, dword ptr [ebp - local_c]           # 0048da45
    movsx eax, word ptr [edx + field_1c]         # 0048da48
    imul eax, eax, 0x4a                          # 0048da4c
    mov dword ptr [eax + 0x5d159d], 0x0          # 0048da4f
    mov ecx, dword ptr [ebp - local_c]           # 0048da59
    movsx edx, word ptr [ecx + field_1c]         # 0048da5c
    imul edx, edx, 0x4a                          # 0048da60
    mov dword ptr [edx + 0x5d15a1], 0x0          # 0048da63
    mov eax, dword ptr [ebp - local_c]           # 0048da6d
    movsx ecx, word ptr [eax + field_1c]         # 0048da70
    imul ecx, ecx, 0x4a                          # 0048da74
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0048da77
    mov edx, dword ptr [ebp - local_c]           # 0048da81
    movsx eax, word ptr [edx + field_1c]         # 0048da84
    imul eax, eax, 0x4a                          # 0048da88
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0048da8b
    mov ecx, dword ptr [ebp - local_c]           # 0048da95
    movsx edx, word ptr [ecx + field_1c]         # 0048da98
    imul edx, edx, 0x4a                          # 0048da9c
    mov word ptr [edx + 0x5d15ad], 0x0           # 0048da9f
    mov edi, 0x54e89c                            # 0048daa8
    mov eax, dword ptr [ebp - local_c]           # 0048daad
    movsx ecx, word ptr [eax + field_1c]         # 0048dab0
    imul ecx, ecx, 0x4a                          # 0048dab4
    add ecx, 0x5d15b3                            # 0048dab7
    {load} mov edx, ecx                          # 0048dabd
    or ecx, -0x1                                 # 0048dabf
    {load} xor eax, eax                          # 0048dac2
    repne scasb al, byte ptr es:[edi]            # 0048dac4
    not ecx                                      # 0048dac6
    {load} sub edi, ecx                          # 0048dac8
    {load} mov esi, edi                          # 0048daca
    {load} mov eax, ecx                          # 0048dacc
    {load} mov edi, edx                          # 0048dace
    shr ecx, 0x2                                 # 0048dad0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048dad3
    {load} mov ecx, eax                          # 0048dad5
    and ecx, 0x3                                 # 0048dad7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048dada
    mov ecx, dword ptr [ebp - local_c]           # 0048dadc
    cmp dword ptr [ecx + field_20], 0x0          # 0048dadf
    jne.d8 L_0048db05                            # 0048dae3
    # block 0x0048dae5: entered by fall-through of jne at 0x0048dae3, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x0048db05
    push 0x54e8b4                                # 0048dae5
    push 0x6                                     # 0048daea
    mov edx, dword ptr [ebp - local_4]           # 0048daec
    push edx                                     # 0048daef
    push 0x54e8cc                                # 0048daf0
    mov ecx, 0x5cf659                            # 0048daf5
    call FUN_004c2790                            # 0048dafa
    mov ecx, dword ptr [ebp - local_c]           # 0048daff
    mov dword ptr [ecx + field_20], eax          # 0048db02
L_0048db05:
    # block 0x0048db05: entered by jne at 0x0048dae3, 6 instruction(s), falls into the block at 0x0048db1b
    mov edx, dword ptr [ebp - local_c]           # 0048db05
    movsx eax, word ptr [edx + field_1c]         # 0048db08
    imul eax, eax, 0x4a                          # 0048db0c
    mov ecx, dword ptr [ebp - local_c]           # 0048db0f
    mov edx, dword ptr [ecx + field_20]          # 0048db12
    mov dword ptr [eax + 0x5d1599], edx          # 0048db15
L_0048db1b:
    # block 0x0048db1b: entered by jmp at 0x0048d9ee, 7 instruction(s), ends with forward jump to 0x0048deab
    mov eax, dword ptr [ebp - local_c]           # 0048db1b
    mov dword ptr [eax + field_2b], 0x1          # 0048db1e
    mov ecx, dword ptr [ebp - local_c]           # 0048db25
    movsx edx, word ptr [ecx + field_1e]         # 0048db28
    imul edx, edx, 0x8d                          # 0048db2c
    mov dword ptr [edx + 0x5bb632], 0x1          # 0048db32
    jmp.d32 L_0048deab                           # 0048db3c
L_0048db41:
    # block 0x0048db41: entered by je at 0x0048d94f, 5 instruction(s), ends with ja to 0x0048dca4 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048db41
    mov ecx, dword ptr [eax + field_2b]          # 0048db44
    mov dword ptr [ebp - local_14], ecx          # 0048db47
    cmp dword ptr [ebp - local_14], 0x4          # 0048db4a
    ja.d32 L_0048dca4                            # 0048db4e
    # block 0x0048db54: entered by fall-through of ja at 0x0048db4e, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x48deb3]
    mov edx, dword ptr [ebp - local_14]          # 0048db54
    jmp dword ptr [4*edx + SWTAB_0048deb3_VA]    # 0048db57
L_0048db5e:
    # block 0x0048db5e: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0048db9f (forward)
    call dword ptr [0x52a23c]                    # 0048db5e
    mov ecx, dword ptr [ebp - local_c]           # 0048db64
    cmp eax, dword ptr [ecx + field_39]          # 0048db67
    jb.d8 L_0048db9f                             # 0048db6a
    # block 0x0048db6c: entered by fall-through of jb at 0x0048db6a, 13 instruction(s), calls FUN_004fba69, falls into the block at 0x0048db9f
    mov edx, dword ptr [ebp - local_4]           # 0048db6c
    add edx, 0x715                               # 0048db6f
    push edx                                     # 0048db75
    mov ecx, 0x5c3a67                            # 0048db76
    call FUN_004fba69                            # 0048db7b
    mov eax, dword ptr [ebp - local_c]           # 0048db80
    mov dword ptr [eax + field_2b], 0x1          # 0048db83
    mov ecx, dword ptr [ebp - local_c]           # 0048db8a
    mov byte ptr [ecx + field_24], 0x1           # 0048db8d
    mov edx, dword ptr [ebp - local_c]           # 0048db91
    mov byte ptr [edx + field_25], 0x1           # 0048db94
    mov eax, dword ptr [ebp - local_c]           # 0048db98
    mov byte ptr [eax + field_26], 0x0           # 0048db9b
L_0048db9f:
    # block 0x0048db9f: entered by jb at 0x0048db6a, 1 instruction(s), ends with forward jump to 0x0048dca4
    jmp.d32 L_0048dca4                           # 0048db9f
L_0048dba4:
    # block 0x0048dba4: entered by switch case, 3 instruction(s), ends with jne to 0x0048dbb5 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048dba4
    cmp dword ptr [ecx + field_2f], 0x0          # 0048dba7
    jne.d8 L_0048dbb5                            # 0048dbab
    # block 0x0048dbad: entered by fall-through of jne at 0x0048dbab, 2 instruction(s), calls FUN_0048d89e, falls into the block at 0x0048dbb5
    mov ecx, dword ptr [ebp - local_c]           # 0048dbad
    call FUN_0048d89e                            # 0048dbb0
L_0048dbb5:
    # block 0x0048dbb5: entered by jne at 0x0048dbab, 1 instruction(s), ends with forward jump to 0x0048dca4
    jmp.d32 L_0048dca4                           # 0048dbb5
L_0048dbba:
    # block 0x0048dbba: entered by switch case, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0048dca4
    call dword ptr [0x52a23c]                    # 0048dbba
    mov edx, dword ptr [ebp - local_4]           # 0048dbc0
    movsx ecx, word ptr [edx + field_75f]        # 0048dbc3
    imul ecx, ecx, 0x3e8                         # 0048dbca
    {load} add eax, ecx                          # 0048dbd0
    mov edx, dword ptr [ebp - local_c]           # 0048dbd2
    mov dword ptr [edx + field_39], eax          # 0048dbd5
    mov eax, dword ptr [ebp - local_c]           # 0048dbd8
    mov dword ptr [eax + field_2b], 0x3          # 0048dbdb
    jmp.d32 L_0048dca4                           # 0048dbe2
L_0048dbe7:
    # block 0x0048dbe7: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x0048dc59 (forward)
    call dword ptr [0x52a23c]                    # 0048dbe7
    mov ecx, dword ptr [ebp - local_c]           # 0048dbed
    cmp eax, dword ptr [ecx + field_39]          # 0048dbf0
    jb.d8 L_0048dc59                             # 0048dbf3
    # block 0x0048dbf5: entered by fall-through of jb at 0x0048dbf3, 7 instruction(s), ends with je to 0x0048dc42 (forward)
    mov edi, 0x54e8d4                            # 0048dbf5
    mov esi, dword ptr [ebp - local_4]           # 0048dbfa
    add esi, 0x761                               # 0048dbfd
    mov ecx, 0x9                                 # 0048dc03
    {load} xor edx, edx                          # 0048dc08
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048dc0a
    je.d8 L_0048dc42                             # 0048dc0c
    # block 0x0048dc0e: entered by fall-through of je at 0x0048dc0c, 13 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x0048dc59
    mov eax, dword ptr [ebp - local_4]           # 0048dc0e
    add eax, 0x761                               # 0048dc11
    push eax                                     # 0048dc16
    mov ecx, 0x5c3a67                            # 0048dc17
    call FUN_004fb77a                            # 0048dc1c
    mov ecx, dword ptr [ebp - local_4]           # 0048dc21
    mov dx, word ptr [ecx + field_782]           # 0048dc24
    push edx                                     # 0048dc2b
    mov ecx, 0x5c3a67                            # 0048dc2c
    call FUN_004fb2e3                            # 0048dc31
    mov eax, dword ptr [ebp - local_c]           # 0048dc36
    mov dword ptr [eax + field_2b], 0x4          # 0048dc39
    jmp.d8 L_0048dc59                            # 0048dc40
L_0048dc42:
    # block 0x0048dc42: entered by je at 0x0048dc0c, 4 instruction(s), falls into the block at 0x0048dc59
    mov ecx, dword ptr [ebp - local_c]           # 0048dc42
    movsx edx, word ptr [ecx + field_1e]         # 0048dc45
    imul edx, edx, 0x8d                          # 0048dc49
    mov dword ptr [edx + 0x5bb632], 0x2          # 0048dc4f
L_0048dc59:
    # block 0x0048dc59: entered by jb at 0x0048dbf3; jmp at 0x0048dc40, 1 instruction(s), ends with forward jump to 0x0048dca4
    jmp.d8 L_0048dca4                            # 0048dc59
L_0048dc5b:
    # block 0x0048dc5b: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0048dca4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048dc5b
    movsx ecx, word ptr [eax + field_782]        # 0048dc5e
    mov dword ptr [ebp - local_8], ecx           # 0048dc65
    mov edx, dword ptr [ebp - local_8]           # 0048dc68
    push edx                                     # 0048dc6b
    mov ecx, 0x5cf1eb                            # 0048dc6c
    call FUN_004f6334                            # 0048dc71
    test eax, eax                                # 0048dc76
    jne.d8 L_0048dca4                            # 0048dc78
    # block 0x0048dc7a: entered by fall-through of jne at 0x0048dc78, 9 instruction(s), calls FUN_004fba69, falls into the block at 0x0048dca4
    mov eax, dword ptr [ebp - local_4]           # 0048dc7a
    add eax, 0x761                               # 0048dc7d
    push eax                                     # 0048dc82
    mov ecx, 0x5c3a67                            # 0048dc83
    call FUN_004fba69                            # 0048dc88
    mov ecx, dword ptr [ebp - local_c]           # 0048dc8d
    movsx edx, word ptr [ecx + field_1e]         # 0048dc90
    imul edx, edx, 0x8d                          # 0048dc94
    mov dword ptr [edx + 0x5bb632], 0x2          # 0048dc9a
L_0048dca4:
    # block 0x0048dca4: entered by ja at 0x0048db4e; jmp at 0x0048db9f; jmp at 0x0048dbb5; jmp at 0x0048dbe2; more, 1 instruction(s), ends with forward jump to 0x0048deab
    jmp.d32 L_0048deab                           # 0048dca4
L_0048dca9:
    # block 0x0048dca9: entered by je at 0x0048d959, 6 instruction(s), ends with je to 0x0048dda5 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0048dca9
    mov eax, dword ptr [ebp - local_c]           # 0048dcb3
    {load} xor ecx, ecx                          # 0048dcb6
    mov cl, byte ptr [eax + field_37]            # 0048dcb8
    test ecx, ecx                                # 0048dcbb
    je.d32 L_0048dda5                            # 0048dcbd
    # block 0x0048dcc3: entered by fall-through of je at 0x0048dcbd, 4 instruction(s), ends with je to 0x0048dd75 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048dcc3
    movsx eax, word ptr [edx + field_792]        # 0048dcc6
    cmp eax, 0x270f                              # 0048dccd
    je.d32 L_0048dd75                            # 0048dcd2
    # block 0x0048dcd8: entered by fall-through of je at 0x0048dcd2, 25 instruction(s), ends with jne to 0x0048dd61 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048dcd8
    movsx edx, word ptr [ecx + field_792]        # 0048dcdb
    mov dword ptr [0x5bb57b], edx                # 0048dce2
    mov eax, dword ptr [ebp - local_4]           # 0048dce8
    mov cx, word ptr [eax + field_794]           # 0048dceb
    mov word ptr [0x5bb599], cx                  # 0048dcf2
    mov edx, dword ptr [ebp - local_4]           # 0048dcf9
    mov ax, word ptr [edx + field_796]           # 0048dcfc
    mov word ptr [0x5bb595], ax                  # 0048dd03
    mov ecx, dword ptr [ebp - local_4]           # 0048dd09
    mov dx, word ptr [ecx + field_798]           # 0048dd0c
    mov word ptr [0x5c39ff], dx                  # 0048dd13
    mov eax, dword ptr [ebp - local_4]           # 0048dd1a
    mov ecx, dword ptr [eax + field_79a]         # 0048dd1d
    mov dword ptr [0x5bb59b], ecx                # 0048dd23
    mov edx, dword ptr [ebp - local_4]           # 0048dd29
    mov eax, dword ptr [edx + field_79e]         # 0048dd2c
    mov dword ptr [0x5bb59f], eax                # 0048dd32
    mov ecx, dword ptr [ebp - local_4]           # 0048dd37
    mov edx, dword ptr [ecx + field_7a2]         # 0048dd3a
    mov dword ptr [0x5bb5a3], edx                # 0048dd40
    mov eax, dword ptr [ebp - local_4]           # 0048dd46
    movsx ecx, word ptr [eax + field_7a6]        # 0048dd49
    cmp ecx, 0x1                                 # 0048dd50
    jne.d8 L_0048dd61                            # 0048dd53
    # block 0x0048dd55: entered by fall-through of jne at 0x0048dd53, 2 instruction(s), ends with forward jump to 0x0048dd6b
    mov dword ptr [0x5bb1ca], 0x0                # 0048dd55
    jmp.d8 L_0048dd6b                            # 0048dd5f
L_0048dd61:
    # block 0x0048dd61: entered by jne at 0x0048dd53, 1 instruction(s), falls into the block at 0x0048dd6b
    mov dword ptr [0x5bb1ca], 0x1                # 0048dd61
L_0048dd6b:
    # block 0x0048dd6b: entered by jmp at 0x0048dd5f, 1 instruction(s), falls into the block at 0x0048dd75
    mov dword ptr [0x583999], 0x4                # 0048dd6b
L_0048dd75:
    # block 0x0048dd75: entered by je at 0x0048dcd2, 4 instruction(s), ends with je to 0x0048dda0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048dd75
    movsx eax, word ptr [edx + field_7a8]        # 0048dd78
    cmp eax, -0x1                                # 0048dd7f
    je.d8 L_0048dda0                             # 0048dd82
    # block 0x0048dd84: entered by fall-through of je at 0x0048dd82, 6 instruction(s), falls into the block at 0x0048dda0
    mov ecx, dword ptr [ebp - local_4]           # 0048dd84
    {load} xor edx, edx                          # 0048dd87
    mov dl, byte ptr [ecx + field_7aa]           # 0048dd89
    mov eax, dword ptr [ebp - local_4]           # 0048dd8f
    movsx ecx, word ptr [eax + field_7a8]        # 0048dd92
    mov dword ptr [4*ecx + 0x585801], edx        # 0048dd99
L_0048dda0:
    # block 0x0048dda0: entered by je at 0x0048dd82, 1 instruction(s), ends with forward jump to 0x0048de93
    jmp.d32 L_0048de93                           # 0048dda0
L_0048dda5:
    # block 0x0048dda5: entered by je at 0x0048dcbd, 5 instruction(s), ends with je to 0x0048de93 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048dda5
    {load} xor eax, eax                          # 0048dda8
    mov al, byte ptr [edx + field_38]            # 0048ddaa
    test eax, eax                                # 0048ddad
    je.d32 L_0048de93                            # 0048ddaf
    # block 0x0048ddb5: entered by fall-through of je at 0x0048ddaf, 4 instruction(s), ends with je to 0x0048de68 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048ddb5
    movsx edx, word ptr [ecx + field_746]        # 0048ddb8
    cmp edx, 0x270f                              # 0048ddbf
    je.d32 L_0048de68                            # 0048ddc5
    # block 0x0048ddcb: entered by fall-through of je at 0x0048ddc5, 25 instruction(s), ends with jne to 0x0048de54 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048ddcb
    movsx ecx, word ptr [eax + field_746]        # 0048ddce
    mov dword ptr [0x5bb57b], ecx                # 0048ddd5
    mov edx, dword ptr [ebp - local_4]           # 0048dddb
    mov ax, word ptr [edx + field_748]           # 0048ddde
    mov word ptr [0x5bb599], ax                  # 0048dde5
    mov ecx, dword ptr [ebp - local_4]           # 0048ddeb
    mov dx, word ptr [ecx + field_74a]           # 0048ddee
    mov word ptr [0x5bb595], dx                  # 0048ddf5
    mov eax, dword ptr [ebp - local_4]           # 0048ddfc
    mov cx, word ptr [eax + field_74c]           # 0048ddff
    mov word ptr [0x5c39ff], cx                  # 0048de06
    mov edx, dword ptr [ebp - local_4]           # 0048de0d
    mov eax, dword ptr [edx + field_74e]         # 0048de10
    mov dword ptr [0x5bb59b], eax                # 0048de16
    mov ecx, dword ptr [ebp - local_4]           # 0048de1b
    mov edx, dword ptr [ecx + field_752]         # 0048de1e
    mov dword ptr [0x5bb59f], edx                # 0048de24
    mov eax, dword ptr [ebp - local_4]           # 0048de2a
    mov ecx, dword ptr [eax + field_756]         # 0048de2d
    mov dword ptr [0x5bb5a3], ecx                # 0048de33
    mov edx, dword ptr [ebp - local_4]           # 0048de39
    movsx eax, word ptr [edx + field_75a]        # 0048de3c
    cmp eax, 0x1                                 # 0048de43
    jne.d8 L_0048de54                            # 0048de46
    # block 0x0048de48: entered by fall-through of jne at 0x0048de46, 2 instruction(s), ends with forward jump to 0x0048de5e
    mov dword ptr [0x5bb1ca], 0x0                # 0048de48
    jmp.d8 L_0048de5e                            # 0048de52
L_0048de54:
    # block 0x0048de54: entered by jne at 0x0048de46, 1 instruction(s), falls into the block at 0x0048de5e
    mov dword ptr [0x5bb1ca], 0x1                # 0048de54
L_0048de5e:
    # block 0x0048de5e: entered by jmp at 0x0048de52, 1 instruction(s), falls into the block at 0x0048de68
    mov dword ptr [0x583999], 0x4                # 0048de5e
L_0048de68:
    # block 0x0048de68: entered by je at 0x0048ddc5, 4 instruction(s), ends with je to 0x0048de93 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048de68
    movsx edx, word ptr [ecx + field_75c]        # 0048de6b
    cmp edx, -0x1                                # 0048de72
    je.d8 L_0048de93                             # 0048de75
    # block 0x0048de77: entered by fall-through of je at 0x0048de75, 6 instruction(s), falls into the block at 0x0048de93
    mov eax, dword ptr [ebp - local_4]           # 0048de77
    {load} xor ecx, ecx                          # 0048de7a
    mov cl, byte ptr [eax + field_75e]           # 0048de7c
    mov edx, dword ptr [ebp - local_4]           # 0048de82
    movsx eax, word ptr [edx + field_75c]        # 0048de85
    mov dword ptr [4*eax + 0x585801], ecx        # 0048de8c
L_0048de93:
    # block 0x0048de93: entered by jmp at 0x0048dda0; je at 0x0048ddaf; je at 0x0048de75, 7 instruction(s), calls FUN_0042ba3a, FUN_0048d09c, falls into the block at 0x0048deab
    mov ecx, dword ptr [ebp - local_c]           # 0048de93
    mov dx, word ptr [ecx + field_1e]            # 0048de96
    push edx                                     # 0048de9a
    call FUN_0042ba3a                            # 0048de9b
    add esp, 0x4                                 # 0048dea0
    mov ecx, dword ptr [ebp - local_c]           # 0048dea3
    call FUN_0048d09c                            # 0048dea6
L_0048deab:
    # block 0x0048deab: entered by jmp at 0x0048d95f; jmp at 0x0048db3c; jmp at 0x0048dca4, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0048deab
    pop esi                                      # 0048deac
    {load} mov esp, ebp                          # 0048dead
    pop ebp                                      # 0048deaf
    ret 0x4                                      # 0048deb0

# --- data items (not part of the function) -------------------------
.org 0x0048deb3 - 0x401000
SWTAB_0048deb3:  # 5 case address(es)
    .long L_0048db5e - .text + 0x401000
    .long L_0048dba4 - .text + 0x401000
    .long L_0048dbba - .text + 0x401000
    .long L_0048dbe7 - .text + 0x401000
    .long L_0048dc5b - .text + 0x401000
.set SWTAB_0048deb3_VA, SWTAB_0048deb3 - .text + 0x401000

