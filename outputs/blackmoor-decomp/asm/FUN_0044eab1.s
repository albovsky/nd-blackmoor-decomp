# FUN_0044eab1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044eab1
# extent:       0x0044eab1-0x0044ecaf (510 code bytes)
# span:         0x0044eab1-0x0044ecaf (code 510, tables 0, padding 0)
# sha256:       ef70d31c4c608225926ef52c6a220e188f1c870cd6dbd0cc19153fe4e534b7e5
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044eab1
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_25, field_2d, field_69, field_6b, field_71, field_75, field_265; [ecx + n] field_1e, field_39, field_61, field_65, field_6d, field_ed, field_f1, field_f5, field_f9, field_25d, field_261; [edx + n] field_31, field_35, field_5d, field_79, field_259
# callees:      calls FUN_0044ecaf
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 146 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_25, 0x25  # offset +0x25
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_5d, 0x5d  # offset +0x5d
.equ field_61, 0x61  # offset +0x61
.equ field_65, 0x65  # offset +0x65
.equ field_69, 0x69  # offset +0x69
.equ field_6b, 0x6b  # offset +0x6b
.equ field_6d, 0x6d  # offset +0x6d
.equ field_71, 0x71  # offset +0x71
.equ field_75, 0x75  # offset +0x75
.equ field_79, 0x79  # offset +0x79
.equ field_ed, 0xed  # offset +0xed
.equ field_f1, 0xf1  # offset +0xf1
.equ field_f5, 0xf5  # offset +0xf5
.equ field_f9, 0xf9  # offset +0xf9
.equ field_259, 0x259  # offset +0x259
.equ field_25d, 0x25d  # offset +0x25d
.equ field_261, 0x261  # offset +0x261
.equ field_265, 0x265  # offset +0x265

# --- external targets -----------------------------------------------
.set FUN_0044ecaf, .text + (0x0044ecaf - 0x401000)

.org 0x0044eab1 - 0x401000
.globl FUN_0044eab1
FUN_0044eab1:
    # block 0x0044eab1: entry, 7 instruction(s), ends with je to 0x0044eca7 (forward)
    push ebp                                     # 0044eab1
    {load} mov ebp, esp                          # 0044eab2
    sub esp, 0xc                                 # 0044eab4
    mov dword ptr [ebp - local_c], ecx           # 0044eab7
    mov eax, dword ptr [ebp - local_c]           # 0044eaba
    cmp dword ptr [eax + field_6b], 0x0          # 0044eabd
    je.d32 L_0044eca7                            # 0044eac1
    # block 0x0044eac7: entered by fall-through of je at 0x0044eac1, 7 instruction(s), ends with forward jump to 0x0044eaf1
    mov ecx, dword ptr [ebp - local_c]           # 0044eac7
    movsx edx, word ptr [ecx + field_1e]         # 0044eaca
    imul edx, edx, 0x8d                          # 0044eace
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0044ead4
    mov dword ptr [ebp - local_8], eax           # 0044eada
    mov word ptr [ebp - local_4], 0x0            # 0044eadd
    jmp.d8 L_0044eaf1                            # 0044eae3
L_0044eae5:
    # block 0x0044eae5: entered by jmp at 0x0044eb78, 3 instruction(s), falls into the block at 0x0044eaf1
    mov cx, word ptr [ebp - local_4]             # 0044eae5
    add cx, 0x1                                  # 0044eae9
    mov word ptr [ebp - local_4], cx             # 0044eaed
L_0044eaf1:
    # block 0x0044eaf1: entered by jmp at 0x0044eae3, 5 instruction(s), ends with jge to 0x0044eb7d (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044eaf1
    mov eax, dword ptr [ebp - local_8]           # 0044eaf5
    movsx ecx, word ptr [eax + field_25]         # 0044eaf8
    {load} cmp edx, ecx                          # 0044eafc
    jge.d8 L_0044eb7d                            # 0044eafe
    # block 0x0044eb00: entered by fall-through of jge at 0x0044eafe, 6 instruction(s), ends with jl to 0x0044eb78 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044eb00
    movsx eax, word ptr [ebp - local_4]          # 0044eb04
    shl eax, 0x4                                 # 0044eb08
    mov ecx, dword ptr [ebp - local_8]           # 0044eb0b
    cmp edx, dword ptr [ecx + eax + field_f1]    # 0044eb0e
    jl.d8 L_0044eb78                             # 0044eb15
    # block 0x0044eb17: entered by fall-through of jl at 0x0044eb15, 6 instruction(s), ends with jg to 0x0044eb78 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044eb17
    movsx eax, word ptr [ebp - local_4]          # 0044eb1b
    shl eax, 0x4                                 # 0044eb1f
    mov ecx, dword ptr [ebp - local_8]           # 0044eb22
    cmp edx, dword ptr [ecx + eax + field_f9]    # 0044eb25
    jg.d8 L_0044eb78                             # 0044eb2c
    # block 0x0044eb2e: entered by fall-through of jg at 0x0044eb2c, 6 instruction(s), ends with jl to 0x0044eb78 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044eb2e
    movsx eax, word ptr [ebp - local_4]          # 0044eb32
    shl eax, 0x4                                 # 0044eb36
    mov ecx, dword ptr [ebp - local_8]           # 0044eb39
    cmp edx, dword ptr [ecx + eax + field_ed]    # 0044eb3c
    jl.d8 L_0044eb78                             # 0044eb43
    # block 0x0044eb45: entered by fall-through of jl at 0x0044eb43, 6 instruction(s), ends with jg to 0x0044eb78 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044eb45
    movsx eax, word ptr [ebp - local_4]          # 0044eb49
    shl eax, 0x4                                 # 0044eb4d
    mov ecx, dword ptr [ebp - local_8]           # 0044eb50
    cmp edx, dword ptr [ecx + eax + field_f5]    # 0044eb53
    jg.d8 L_0044eb78                             # 0044eb5a
    # block 0x0044eb5c: entered by fall-through of jg at 0x0044eb5a, 7 instruction(s), calls FUN_0044ecaf, ends with forward jump to 0x0044eca9
    mov dx, word ptr [ebp - local_4]             # 0044eb5c
    push edx                                     # 0044eb60
    push 0x2785                                  # 0044eb61
    mov ecx, dword ptr [ebp - local_c]           # 0044eb66
    call FUN_0044ecaf                            # 0044eb69
    mov eax, 0x1                                 # 0044eb6e
    jmp.d32 L_0044eca9                           # 0044eb73
L_0044eb78:
    # block 0x0044eb78: entered by jl at 0x0044eb15; jg at 0x0044eb2c; jl at 0x0044eb43; jg at 0x0044eb5a, 1 instruction(s), ends with backward jump to 0x0044eae5
    jmp.d32 L_0044eae5                           # 0044eb78
L_0044eb7d:
    # block 0x0044eb7d: entered by jge at 0x0044eafe, 4 instruction(s), ends with jl to 0x0044ebc6 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0044eb7d
    mov ecx, dword ptr [ebp - local_8]           # 0044eb81
    cmp eax, dword ptr [ecx + field_61]          # 0044eb84
    jl.d8 L_0044ebc6                             # 0044eb87
    # block 0x0044eb89: entered by fall-through of jl at 0x0044eb87, 4 instruction(s), ends with jg to 0x0044ebc6 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044eb89
    mov eax, dword ptr [ebp - local_8]           # 0044eb8d
    cmp edx, dword ptr [eax + field_69]          # 0044eb90
    jg.d8 L_0044ebc6                             # 0044eb93
    # block 0x0044eb95: entered by fall-through of jg at 0x0044eb93, 4 instruction(s), ends with jl to 0x0044ebc6 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044eb95
    mov edx, dword ptr [ebp - local_8]           # 0044eb99
    cmp ecx, dword ptr [edx + field_5d]          # 0044eb9c
    jl.d8 L_0044ebc6                             # 0044eb9f
    # block 0x0044eba1: entered by fall-through of jl at 0x0044eb9f, 4 instruction(s), ends with jg to 0x0044ebc6 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044eba1
    mov ecx, dword ptr [ebp - local_8]           # 0044eba5
    cmp eax, dword ptr [ecx + field_65]          # 0044eba8
    jg.d8 L_0044ebc6                             # 0044ebab
    # block 0x0044ebad: entered by fall-through of jg at 0x0044ebab, 6 instruction(s), calls FUN_0044ecaf, ends with forward jump to 0x0044eca9
    push 0x0                                     # 0044ebad
    push 0x2786                                  # 0044ebaf
    mov ecx, dword ptr [ebp - local_c]           # 0044ebb4
    call FUN_0044ecaf                            # 0044ebb7
    mov eax, 0x1                                 # 0044ebbc
    jmp.d32 L_0044eca9                           # 0044ebc1
L_0044ebc6:
    # block 0x0044ebc6: entered by jl at 0x0044eb87; jg at 0x0044eb93; jl at 0x0044eb9f; jg at 0x0044ebab, 4 instruction(s), ends with jl to 0x0044ec0f (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044ebc6
    mov eax, dword ptr [ebp - local_8]           # 0044ebca
    cmp edx, dword ptr [eax + field_71]          # 0044ebcd
    jl.d8 L_0044ec0f                             # 0044ebd0
    # block 0x0044ebd2: entered by fall-through of jl at 0x0044ebd0, 4 instruction(s), ends with jg to 0x0044ec0f (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044ebd2
    mov edx, dword ptr [ebp - local_8]           # 0044ebd6
    cmp ecx, dword ptr [edx + field_79]          # 0044ebd9
    jg.d8 L_0044ec0f                             # 0044ebdc
    # block 0x0044ebde: entered by fall-through of jg at 0x0044ebdc, 4 instruction(s), ends with jl to 0x0044ec0f (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044ebde
    mov ecx, dword ptr [ebp - local_8]           # 0044ebe2
    cmp eax, dword ptr [ecx + field_6d]          # 0044ebe5
    jl.d8 L_0044ec0f                             # 0044ebe8
    # block 0x0044ebea: entered by fall-through of jl at 0x0044ebe8, 4 instruction(s), ends with jg to 0x0044ec0f (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044ebea
    mov eax, dword ptr [ebp - local_8]           # 0044ebee
    cmp edx, dword ptr [eax + field_75]          # 0044ebf1
    jg.d8 L_0044ec0f                             # 0044ebf4
    # block 0x0044ebf6: entered by fall-through of jg at 0x0044ebf4, 6 instruction(s), calls FUN_0044ecaf, ends with forward jump to 0x0044eca9
    push 0x1                                     # 0044ebf6
    push 0x2786                                  # 0044ebf8
    mov ecx, dword ptr [ebp - local_c]           # 0044ebfd
    call FUN_0044ecaf                            # 0044ec00
    mov eax, 0x1                                 # 0044ec05
    jmp.d32 L_0044eca9                           # 0044ec0a
L_0044ec0f:
    # block 0x0044ec0f: entered by jl at 0x0044ebd0; jg at 0x0044ebdc; jl at 0x0044ebe8; jg at 0x0044ebf4, 4 instruction(s), ends with jl to 0x0044ec55 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0044ec0f
    mov edx, dword ptr [ebp - local_8]           # 0044ec13
    cmp ecx, dword ptr [edx + field_31]          # 0044ec16
    jl.d8 L_0044ec55                             # 0044ec19
    # block 0x0044ec1b: entered by fall-through of jl at 0x0044ec19, 4 instruction(s), ends with jg to 0x0044ec55 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0044ec1b
    mov ecx, dword ptr [ebp - local_8]           # 0044ec1f
    cmp eax, dword ptr [ecx + field_39]          # 0044ec22
    jg.d8 L_0044ec55                             # 0044ec25
    # block 0x0044ec27: entered by fall-through of jg at 0x0044ec25, 4 instruction(s), ends with jl to 0x0044ec55 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0044ec27
    mov eax, dword ptr [ebp - local_8]           # 0044ec2b
    cmp edx, dword ptr [eax + field_2d]          # 0044ec2e
    jl.d8 L_0044ec55                             # 0044ec31
    # block 0x0044ec33: entered by fall-through of jl at 0x0044ec31, 4 instruction(s), ends with jg to 0x0044ec55 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044ec33
    mov edx, dword ptr [ebp - local_8]           # 0044ec37
    cmp ecx, dword ptr [edx + field_35]          # 0044ec3a
    jg.d8 L_0044ec55                             # 0044ec3d
    # block 0x0044ec3f: entered by fall-through of jg at 0x0044ec3d, 6 instruction(s), calls FUN_0044ecaf, ends with forward jump to 0x0044eca9
    push 0x2                                     # 0044ec3f
    push 0x2786                                  # 0044ec41
    mov ecx, dword ptr [ebp - local_c]           # 0044ec46
    call FUN_0044ecaf                            # 0044ec49
    mov eax, 0x1                                 # 0044ec4e
    jmp.d8 L_0044eca9                            # 0044ec53
L_0044ec55:
    # block 0x0044ec55: entered by jl at 0x0044ec19; jg at 0x0044ec25; jl at 0x0044ec31; jg at 0x0044ec3d, 4 instruction(s), ends with jl to 0x0044eca7 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0044ec55
    mov ecx, dword ptr [ebp - local_8]           # 0044ec59
    cmp eax, dword ptr [ecx + field_25d]         # 0044ec5c
    jl.d8 L_0044eca7                             # 0044ec62
    # block 0x0044ec64: entered by fall-through of jl at 0x0044ec62, 4 instruction(s), ends with jg to 0x0044eca7 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0044ec64
    mov eax, dword ptr [ebp - local_8]           # 0044ec68
    cmp edx, dword ptr [eax + field_265]         # 0044ec6b
    jg.d8 L_0044eca7                             # 0044ec71
    # block 0x0044ec73: entered by fall-through of jg at 0x0044ec71, 4 instruction(s), ends with jl to 0x0044eca7 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0044ec73
    mov edx, dword ptr [ebp - local_8]           # 0044ec77
    cmp ecx, dword ptr [edx + field_259]         # 0044ec7a
    jl.d8 L_0044eca7                             # 0044ec80
    # block 0x0044ec82: entered by fall-through of jl at 0x0044ec80, 4 instruction(s), ends with jg to 0x0044eca7 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0044ec82
    mov ecx, dword ptr [ebp - local_8]           # 0044ec86
    cmp eax, dword ptr [ecx + field_261]         # 0044ec89
    jg.d8 L_0044eca7                             # 0044ec8f
    # block 0x0044ec91: entered by fall-through of jg at 0x0044ec8f, 6 instruction(s), calls FUN_0044ecaf, ends with forward jump to 0x0044eca9
    push 0x0                                     # 0044ec91
    push 0x2787                                  # 0044ec93
    mov ecx, dword ptr [ebp - local_c]           # 0044ec98
    call FUN_0044ecaf                            # 0044ec9b
    mov eax, 0x1                                 # 0044eca0
    jmp.d8 L_0044eca9                            # 0044eca5
L_0044eca7:
    # block 0x0044eca7: entered by je at 0x0044eac1; jl at 0x0044ec62; jg at 0x0044ec71; jl at 0x0044ec80; jg at 0x0044ec8f, 1 instruction(s), falls into the block at 0x0044eca9
    {load} xor eax, eax                          # 0044eca7
L_0044eca9:
    # block 0x0044eca9: entered by jmp at 0x0044eb73; jmp at 0x0044ebc1; jmp at 0x0044ec0a; jmp at 0x0044ec53; more, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0044eca9
    pop ebp                                      # 0044ecab
    ret 0x8                                      # 0044ecac

