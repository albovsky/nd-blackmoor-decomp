# FUN_0047b767
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b767
# extent:       0x0047b767-0x0047ba79 (786 code bytes)
# span:         0x0047b767-0x0047ba79 (code 786, tables 0, padding 0)
# sha256:       e2df303508d373e984d967cd26e887c7e6eb19474fef272948505d9893957d20
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047b767
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_6, field_14, field_1c, field_20, field_34, field_27c, field_280, field_290, field_294, field_2b4; [ecx + n] field_8, field_c, field_10, field_14, field_1c, field_20, field_24, field_28, field_2c, field_290, field_294, field_2b4 and 1 more; [edx + n] field_4, field_6, field_8, field_c, field_14, field_1c, field_34, field_38, field_27c, field_28c, field_290, field_294 and 1 more
# callees:      calls FUN_004fb2e3, FUN_0047d02d, FUN_0047badf, FUN_0047cd90, FUN_00427a40, FUN_0047ce6f, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 197 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_27c, 0x27c  # offset +0x27c
.equ field_280, 0x280  # offset +0x280
.equ field_28c, 0x28c  # offset +0x28c
.equ field_290, 0x290  # offset +0x290
.equ field_294, 0x294  # offset +0x294
.equ field_2b4, 0x2b4  # offset +0x2b4
.equ field_331, 0x331  # offset +0x331

# --- external targets -----------------------------------------------
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0047badf, .text + (0x0047badf - 0x401000)
.set FUN_0047cd90, .text + (0x0047cd90 - 0x401000)
.set FUN_0047ce6f, .text + (0x0047ce6f - 0x401000)
.set FUN_0047d02d, .text + (0x0047d02d - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0047b767 - 0x401000
.globl FUN_0047b767
FUN_0047b767:
    # block 0x0047b767: entry, 13 instruction(s), ends with je to 0x0047ba75 (forward)
    push ebp                                     # 0047b767
    {load} mov ebp, esp                          # 0047b768
    sub esp, 0xc                                 # 0047b76a
    mov dword ptr [ebp - local_4], ecx           # 0047b76d
    mov eax, dword ptr [ebp - local_4]           # 0047b770
    movsx ecx, word ptr [eax + field_6]          # 0047b773
    imul ecx, ecx, 0x8d                          # 0047b777
    mov edx, dword ptr [ebp - local_4]           # 0047b77d
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 0047b780
    mov dword ptr [edx + field_c], eax           # 0047b786
    mov ecx, dword ptr [ebp - local_4]           # 0047b789
    cmp dword ptr [ecx + field_24], 0x0          # 0047b78c
    je.d32 L_0047ba75                            # 0047b790
    # block 0x0047b796: entered by fall-through of je at 0x0047b790, 5 instruction(s), ends with jne to 0x0047ba75 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047b796
    movsx eax, word ptr [edx + field_6]          # 0047b799
    imul eax, eax, 0x8d                          # 0047b79d
    cmp dword ptr [eax + 0x5bb632], 0x1          # 0047b7a3
    jne.d32 L_0047ba75                           # 0047b7aa
    # block 0x0047b7b0: entered by fall-through of jne at 0x0047b7aa, 3 instruction(s), ends with jne to 0x0047ba75 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047b7b0
    cmp dword ptr [ecx + field_10], 0x0          # 0047b7b3
    jne.d32 L_0047ba75                           # 0047b7b7
    # block 0x0047b7bd: entered by fall-through of jne at 0x0047b7b7, 2 instruction(s), ends with je to 0x0047b7d9 (forward)
    cmp dword ptr [0x5c39e5], 0x2768             # 0047b7bd
    je.d8 L_0047b7d9                             # 0047b7c7
    # block 0x0047b7c9: entered by fall-through of je at 0x0047b7c7, 2 instruction(s), ends with jne to 0x0047ba75 (forward)
    cmp dword ptr [0x5c39e5], 0x2769             # 0047b7c9
    jne.d32 L_0047ba75                           # 0047b7d3
L_0047b7d9:
    # block 0x0047b7d9: entered by je at 0x0047b7c7; fall-through of jne at 0x0047b7d3, 2 instruction(s), ends with jne to 0x0047b808 (forward)
    cmp dword ptr [0x5c39e5], 0x2768             # 0047b7d9
    jne.d8 L_0047b808                            # 0047b7e3
    # block 0x0047b7e5: entered by fall-through of jne at 0x0047b7e3, 8 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x0047ba75
    mov edx, dword ptr [ebp - local_4]           # 0047b7e5
    mov eax, dword ptr [ebp - local_4]           # 0047b7e8
    mov ecx, dword ptr [eax + field_27c]         # 0047b7eb
    mov dword ptr [edx + field_28c], ecx         # 0047b7f1
    push 0x17                                    # 0047b7f7
    mov ecx, 0x5c3a67                            # 0047b7f9
    call FUN_004fb2e3                            # 0047b7fe
    jmp.d32 L_0047ba75                           # 0047b803
L_0047b808:
    # block 0x0047b808: entered by jne at 0x0047b7e3, 2 instruction(s), ends with jne to 0x0047ba75 (forward)
    cmp dword ptr [0x5c39e5], 0x2769             # 0047b808
    jne.d32 L_0047ba75                           # 0047b812
    # block 0x0047b818: entered by fall-through of jne at 0x0047b812, 15 instruction(s), ends with jne to 0x0047ba75 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047b818
    mov eax, dword ptr [ebp - local_4]           # 0047b81b
    mov ecx, dword ptr [edx + field_28c]         # 0047b81e
    imul ecx, dword ptr [eax + field_280]        # 0047b824
    mov edx, dword ptr [ebp - local_4]           # 0047b82b
    add ecx, dword ptr [edx + field_27c]         # 0047b82e
    mov eax, dword ptr [ebp - local_4]           # 0047b834
    mov dword ptr [eax + field_2b4], ecx         # 0047b837
    mov ecx, dword ptr [ebp - local_4]           # 0047b83d
    mov edx, dword ptr [ecx + field_2b4]         # 0047b840
    imul edx, edx, 0xc                           # 0047b846
    mov eax, dword ptr [ebp - local_4]           # 0047b849
    mov ecx, dword ptr [eax + field_14]          # 0047b84c
    cmp dword ptr [ecx + edx + field_8], 0x0     # 0047b84f
    jne.d32 L_0047ba75                           # 0047b854
    # block 0x0047b85a: entered by fall-through of jne at 0x0047b854, 7 instruction(s), ends with jne to 0x0047ba75 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047b85a
    mov eax, dword ptr [edx + field_2b4]         # 0047b85d
    imul eax, eax, 0xc                           # 0047b863
    mov ecx, dword ptr [ebp - local_4]           # 0047b866
    mov edx, dword ptr [ecx + field_14]          # 0047b869
    cmp dword ptr [edx + eax + field_4], 0x0     # 0047b86c
    jne.d32 L_0047ba75                           # 0047b871
    # block 0x0047b877: entered by fall-through of jne at 0x0047b871, 3 instruction(s), ends with je to 0x0047b88d (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047b877
    cmp dword ptr [eax + field_1c], 0x0          # 0047b87a
    je.d8 L_0047b88d                             # 0047b87e
    # block 0x0047b880: entered by fall-through of je at 0x0047b87e, 3 instruction(s), ends with jne to 0x0047ba75 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047b880
    cmp dword ptr [ecx + field_20], 0x0          # 0047b883
    jne.d32 L_0047ba75                           # 0047b887
L_0047b88d:
    # block 0x0047b88d: entered by je at 0x0047b87e; fall-through of jne at 0x0047b887, 3 instruction(s), ends with jne to 0x0047ba75 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047b88d
    cmp dword ptr [edx + field_34], 0x0          # 0047b890
    jne.d32 L_0047ba75                           # 0047b894
    # block 0x0047b89a: entered by fall-through of jne at 0x0047b894, 9 instruction(s), ends with jne to 0x0047b8f1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047b89a
    mov ecx, dword ptr [eax + field_2b4]         # 0047b89d
    imul ecx, ecx, 0xc                           # 0047b8a3
    mov edx, dword ptr [ebp - local_4]           # 0047b8a6
    mov eax, dword ptr [edx + field_14]          # 0047b8a9
    mov dword ptr [eax + ecx + field_4], 0x1     # 0047b8ac
    mov ecx, dword ptr [ebp - local_4]           # 0047b8b4
    cmp dword ptr [ecx + field_1c], 0x0          # 0047b8b7
    jne.d8 L_0047b8f1                            # 0047b8bb
    # block 0x0047b8bd: entered by fall-through of jne at 0x0047b8bb, 15 instruction(s), calls FUN_0047d02d, ends with forward jump to 0x0047ba75
    mov edx, dword ptr [ebp - local_4]           # 0047b8bd
    mov eax, dword ptr [edx + field_2b4]         # 0047b8c0
    imul eax, eax, 0xc                           # 0047b8c6
    mov ecx, dword ptr [ebp - local_4]           # 0047b8c9
    mov edx, dword ptr [ecx + field_14]          # 0047b8cc
    {load} add edx, eax                          # 0047b8cf
    mov eax, dword ptr [ebp - local_4]           # 0047b8d1
    mov dword ptr [eax + field_1c], edx          # 0047b8d4
    mov ecx, dword ptr [ebp - local_4]           # 0047b8d7
    mov edx, dword ptr [ecx + field_c]           # 0047b8da
    add edx, 0x35c                               # 0047b8dd
    push edx                                     # 0047b8e3
    mov ecx, dword ptr [ebp - local_4]           # 0047b8e4
    call FUN_0047d02d                            # 0047b8e7
    jmp.d32 L_0047ba75                           # 0047b8ec
L_0047b8f1:
    # block 0x0047b8f1: entered by jne at 0x0047b8bb, 3 instruction(s), ends with jne to 0x0047ba75 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0047b8f1
    cmp dword ptr [eax + field_20], 0x0          # 0047b8f4
    jne.d32 L_0047ba75                           # 0047b8f8
    # block 0x0047b8fe: entered by fall-through of jne at 0x0047b8f8, 21 instruction(s), calls FUN_0047d02d, ends with jne to 0x0047b9ef (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047b8fe
    mov edx, dword ptr [ecx + field_c]           # 0047b901
    add edx, 0x412                               # 0047b904
    push edx                                     # 0047b90a
    mov ecx, dword ptr [ebp - local_4]           # 0047b90b
    call FUN_0047d02d                            # 0047b90e
    mov eax, dword ptr [ebp - local_4]           # 0047b913
    mov ecx, dword ptr [eax + field_2b4]         # 0047b916
    imul ecx, ecx, 0xc                           # 0047b91c
    mov edx, dword ptr [ebp - local_4]           # 0047b91f
    mov eax, dword ptr [edx + field_14]          # 0047b922
    {load} add eax, ecx                          # 0047b925
    mov ecx, dword ptr [ebp - local_4]           # 0047b927
    mov dword ptr [ecx + field_20], eax          # 0047b92a
    mov edx, dword ptr [ebp - local_4]           # 0047b92d
    mov eax, dword ptr [edx + field_1c]          # 0047b930
    mov ecx, dword ptr [ebp - local_4]           # 0047b933
    mov edx, dword ptr [ecx + field_20]          # 0047b936
    mov eax, dword ptr [eax]                     # 0047b939
    cmp eax, dword ptr [edx]                     # 0047b93b
    jne.d32 L_0047b9ef                           # 0047b93d
    # block 0x0047b943: entered by fall-through of jne at 0x0047b93d, 25 instruction(s), calls FUN_0047badf, ends with jne to 0x0047b9b4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047b943
    mov edx, dword ptr [ecx + field_290]         # 0047b946
    add edx, 0x1                                 # 0047b94c
    mov eax, dword ptr [ebp - local_4]           # 0047b94f
    mov dword ptr [eax + field_290], edx         # 0047b952
    mov ecx, dword ptr [ebp - local_4]           # 0047b958
    mov edx, dword ptr [ecx + field_294]         # 0047b95b
    add edx, 0x1                                 # 0047b961
    mov eax, dword ptr [ebp - local_4]           # 0047b964
    mov dword ptr [eax + field_294], edx         # 0047b967
    mov ecx, dword ptr [ebp - local_4]           # 0047b96d
    mov edx, dword ptr [ecx + field_1c]          # 0047b970
    mov dword ptr [edx + field_8], 0x1           # 0047b973
    mov eax, dword ptr [ebp - local_4]           # 0047b97a
    mov ecx, dword ptr [eax + field_20]          # 0047b97d
    mov dword ptr [ecx + field_8], 0x1           # 0047b980
    mov edx, dword ptr [ebp - local_4]           # 0047b987
    mov dword ptr [edx + field_1c], 0x0          # 0047b98a
    mov eax, dword ptr [ebp - local_4]           # 0047b991
    mov dword ptr [eax + field_20], 0x0          # 0047b994
    mov ecx, dword ptr [ebp - local_4]           # 0047b99b
    call FUN_0047badf                            # 0047b99e
    mov ecx, dword ptr [ebp - local_4]           # 0047b9a3
    cmp dword ptr [ecx + field_28], 0x0          # 0047b9a6
    jne.d8 L_0047b9b4                            # 0047b9aa
    # block 0x0047b9ac: entered by fall-through of jne at 0x0047b9aa, 2 instruction(s), calls FUN_0047cd90, falls into the block at 0x0047b9b4
    mov ecx, dword ptr [ebp - local_4]           # 0047b9ac
    call FUN_0047cd90                            # 0047b9af
L_0047b9b4:
    # block 0x0047b9b4: entered by jne at 0x0047b9aa, 3 instruction(s), ends with je to 0x0047b9c6 (forward)
    mov edx, 0x1                                 # 0047b9b4
    test edx, edx                                # 0047b9b9
    je.d8 L_0047b9c6                             # 0047b9bb
    # block 0x0047b9bd: entered by fall-through of je at 0x0047b9bb, 2 instruction(s), ends with forward jump to 0x0047b9ea
    mov dword ptr [ebp - local_8], 0x0           # 0047b9bd
    jmp.d8 L_0047b9ea                            # 0047b9c4
L_0047b9c6:
    # block 0x0047b9c6: entered by je at 0x0047b9bb, 10 instruction(s), calls FUN_00427a40, falls into the block at 0x0047b9ea
    mov eax, dword ptr [ebp - local_4]           # 0047b9c6
    mov ecx, dword ptr [eax + field_294]         # 0047b9c9
    push ecx                                     # 0047b9cf
    mov edx, dword ptr [ebp - local_4]           # 0047b9d0
    mov eax, dword ptr [edx + field_290]         # 0047b9d3
    push eax                                     # 0047b9d9
    push 0x54ce4c                                # 0047b9da
    call FUN_00427a40                            # 0047b9df
    add esp, 0xc                                 # 0047b9e4
    mov dword ptr [ebp - local_8], eax           # 0047b9e7
L_0047b9ea:
    # block 0x0047b9ea: entered by jmp at 0x0047b9c4, 1 instruction(s), ends with forward jump to 0x0047ba75
    jmp.d32 L_0047ba75                           # 0047b9ea
L_0047b9ef:
    # block 0x0047b9ef: entered by jne at 0x0047b93d, 10 instruction(s), calls FUN_0047badf, ends with jne to 0x0047ba1d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047b9ef
    mov edx, dword ptr [ecx + field_294]         # 0047b9f2
    add edx, 0x1                                 # 0047b9f8
    mov eax, dword ptr [ebp - local_4]           # 0047b9fb
    mov dword ptr [eax + field_294], edx         # 0047b9fe
    mov ecx, dword ptr [ebp - local_4]           # 0047ba04
    call FUN_0047badf                            # 0047ba07
    mov ecx, dword ptr [ebp - local_4]           # 0047ba0c
    cmp dword ptr [ecx + field_2c], 0x0          # 0047ba0f
    jne.d8 L_0047ba1d                            # 0047ba13
    # block 0x0047ba15: entered by fall-through of jne at 0x0047ba13, 2 instruction(s), calls FUN_0047ce6f, falls into the block at 0x0047ba1d
    mov ecx, dword ptr [ebp - local_4]           # 0047ba15
    call FUN_0047ce6f                            # 0047ba18
L_0047ba1d:
    # block 0x0047ba1d: entered by jne at 0x0047ba13, 11 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x0047ba51 (forward)
    call dword ptr [0x52a23c]                    # 0047ba1d
    mov edx, dword ptr [ebp - local_4]           # 0047ba23
    mov ecx, dword ptr [edx + field_c]           # 0047ba26
    add eax, dword ptr [ecx + field_331]         # 0047ba29
    mov edx, dword ptr [ebp - local_4]           # 0047ba2f
    mov dword ptr [edx + field_38], eax          # 0047ba32
    mov eax, dword ptr [ebp - local_4]           # 0047ba35
    mov dword ptr [eax + field_34], 0x1          # 0047ba38
    mov ecx, 0x1                                 # 0047ba3f
    test ecx, ecx                                # 0047ba44
    je.d8 L_0047ba51                             # 0047ba46
    # block 0x0047ba48: entered by fall-through of je at 0x0047ba46, 2 instruction(s), ends with forward jump to 0x0047ba75
    mov dword ptr [ebp - local_c], 0x0           # 0047ba48
    jmp.d8 L_0047ba75                            # 0047ba4f
L_0047ba51:
    # block 0x0047ba51: entered by je at 0x0047ba46, 10 instruction(s), calls FUN_00427a40, falls into the block at 0x0047ba75
    mov edx, dword ptr [ebp - local_4]           # 0047ba51
    mov eax, dword ptr [edx + field_294]         # 0047ba54
    push eax                                     # 0047ba5a
    mov ecx, dword ptr [ebp - local_4]           # 0047ba5b
    mov edx, dword ptr [ecx + field_290]         # 0047ba5e
    push edx                                     # 0047ba64
    push 0x54ce88                                # 0047ba65
    call FUN_00427a40                            # 0047ba6a
    add esp, 0xc                                 # 0047ba6f
    mov dword ptr [ebp - local_c], eax           # 0047ba72
L_0047ba75:
    # block 0x0047ba75: entered by je at 0x0047b790; jne at 0x0047b7aa; jne at 0x0047b7b7; jne at 0x0047b7d3; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047ba75
    pop ebp                                      # 0047ba77
    ret                                          # 0047ba78

