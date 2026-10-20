# FUN_004b5d17
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5d17
# extent:       0x004b5d17-0x004b6097 (896 code bytes)
# span:         0x004b5d17-0x004b6097 (code 896, tables 0, padding 0)
# sha256:       e117e759992c878ceac68d51b408bd7c1cdc673925c349a406aafa96ae8bb92a
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_turning_puzzle_pointer_hit_test
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_d1_runtime.h:22 says "0x4b5d17 pointer hit test"
# name-note:    Pointer hit test of the 0xd1 Turning Puzzle, run from the 0x4f0059 cascade.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_24, field_47, field_4b, field_4f, field_53, field_225, field_38f; [ecx + n] field_1e, field_21, field_252, field_39b; [edx + n] field_21, field_24, field_147, field_14b, field_14f, field_153, field_224, field_22c, field_232, field_254, field_393, field_397
# callees:      calls FUN_004b6355, FUN_004b6097
# track-n:      outputs/blackmoor-decomp/src/action_family_d1_runtime.h:d1_pointer_move (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 246 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_47, 0x47  # offset +0x47
.equ field_4b, 0x4b  # offset +0x4b
.equ field_4f, 0x4f  # offset +0x4f
.equ field_53, 0x53  # offset +0x53
.equ field_147, 0x147  # offset +0x147
.equ field_14b, 0x14b  # offset +0x14b
.equ field_14f, 0x14f  # offset +0x14f
.equ field_153, 0x153  # offset +0x153
.equ field_224, 0x224  # offset +0x224
.equ field_225, 0x225  # offset +0x225
.equ field_22c, 0x22c  # offset +0x22c
.equ field_232, 0x232  # offset +0x232
.equ field_252, 0x252  # offset +0x252
.equ field_254, 0x254  # offset +0x254
.equ field_38f, 0x38f  # offset +0x38f
.equ field_393, 0x393  # offset +0x393
.equ field_397, 0x397  # offset +0x397
.equ field_39b, 0x39b  # offset +0x39b

# --- external targets -----------------------------------------------
.set FUN_004b6097, .text + (0x004b6097 - 0x401000)
.set FUN_004b6355, .text + (0x004b6355 - 0x401000)

.org 0x004b5d17 - 0x401000
.globl FUN_004b5d17
FUN_004b5d17:
    # block 0x004b5d17: entry, 7 instruction(s), ends with je to 0x004b608f (forward)
    push ebp                                     # 004b5d17
    {load} mov ebp, esp                          # 004b5d18
    sub esp, 0xc                                 # 004b5d1a
    mov dword ptr [ebp - local_c], ecx           # 004b5d1d
    mov eax, dword ptr [ebp - local_c]           # 004b5d20
    cmp dword ptr [eax + field_225], 0x0         # 004b5d23
    je.d32 L_004b608f                            # 004b5d2a
    # block 0x004b5d30: entered by fall-through of je at 0x004b5d2a, 10 instruction(s), ends with je to 0x004b5eb1 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b5d30
    movsx edx, word ptr [ecx + field_1e]         # 004b5d33
    imul edx, edx, 0x8d                          # 004b5d37
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004b5d3d
    mov dword ptr [ebp - local_8], eax           # 004b5d43
    mov ecx, dword ptr [ebp - local_c]           # 004b5d46
    mov word ptr [ecx + field_252], 0xffff       # 004b5d49
    mov edx, 0x1                                 # 004b5d52
    test edx, edx                                # 004b5d57
    je.d32 L_004b5eb1                            # 004b5d59
    # block 0x004b5d5f: entered by fall-through of je at 0x004b5d59, 2 instruction(s), ends with forward jump to 0x004b5d71
    mov dword ptr [ebp - local_4], 0x0           # 004b5d5f
    jmp.d8 L_004b5d71                            # 004b5d66
L_004b5d68:
    # block 0x004b5d68: entered by jmp at 0x004b5e10, 3 instruction(s), falls into the block at 0x004b5d71
    mov eax, dword ptr [ebp - local_4]           # 004b5d68
    add eax, 0x1                                 # 004b5d6b
    mov dword ptr [ebp - local_4], eax           # 004b5d6e
L_004b5d71:
    # block 0x004b5d71: entered by jmp at 0x004b5d66, 4 instruction(s), ends with jge to 0x004b5e15 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b5d71
    movsx edx, word ptr [ecx + field_21]         # 004b5d74
    cmp dword ptr [ebp - local_4], edx           # 004b5d78
    jge.d32 L_004b5e15                           # 004b5d7b
    # block 0x004b5d81: entered by fall-through of jge at 0x004b5d7b, 3 instruction(s), ends with je to 0x004b5e10 (forward)
    mov eax, 0x1                                 # 004b5d81
    test eax, eax                                # 004b5d86
    je.d32 L_004b5e10                            # 004b5d88
    # block 0x004b5d8e: entered by fall-through of je at 0x004b5d88, 5 instruction(s), ends with jne to 0x004b5dce (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b5d8e
    mov edx, dword ptr [ebp - local_c]           # 004b5d91
    movsx eax, word ptr [edx + 2*ecx + field_232] # 004b5d94
    test eax, eax                                # 004b5d9c
    jne.d8 L_004b5dce                            # 004b5d9e
    # block 0x004b5da0: entered by fall-through of jne at 0x004b5d9e, 15 instruction(s), calls FUN_004b6355, ends with forward jump to 0x004b5e06
    mov ecx, dword ptr [ebp - local_4]           # 004b5da0
    shl ecx, 0x4                                 # 004b5da3
    mov edx, dword ptr [ebp - local_c]           # 004b5da6
    lea eax, [edx + ecx + field_24]              # 004b5da9
    push eax                                     # 004b5dad
    push 0x0                                     # 004b5dae
    mov ecx, dword ptr [ebp - local_4]           # 004b5db0
    mov edx, dword ptr [ebp - local_c]           # 004b5db3
    mov ax, word ptr [edx + 2*ecx + field_254]   # 004b5db6
    push eax                                     # 004b5dbe
    mov cx, word ptr [ebp - local_4]             # 004b5dbf
    push ecx                                     # 004b5dc3
    mov ecx, dword ptr [ebp - local_c]           # 004b5dc4
    call FUN_004b6355                            # 004b5dc7
    jmp.d8 L_004b5e06                            # 004b5dcc
L_004b5dce:
    # block 0x004b5dce: entered by jne at 0x004b5d9e, 17 instruction(s), calls FUN_004b6355, falls into the block at 0x004b5e06
    mov edx, dword ptr [ebp - local_4]           # 004b5dce
    shl edx, 0x4                                 # 004b5dd1
    mov eax, dword ptr [ebp - local_c]           # 004b5dd4
    lea ecx, [eax + edx + field_24]              # 004b5dd7
    push ecx                                     # 004b5ddb
    mov edx, dword ptr [ebp - local_c]           # 004b5ddc
    movsx eax, word ptr [edx + field_22c]        # 004b5ddf
    sub eax, 0x1                                 # 004b5de6
    push eax                                     # 004b5de9
    mov ecx, dword ptr [ebp - local_4]           # 004b5dea
    mov edx, dword ptr [ebp - local_c]           # 004b5ded
    mov ax, word ptr [edx + 2*ecx + field_254]   # 004b5df0
    push eax                                     # 004b5df8
    mov cx, word ptr [ebp - local_4]             # 004b5df9
    push ecx                                     # 004b5dfd
    mov ecx, dword ptr [ebp - local_c]           # 004b5dfe
    call FUN_004b6355                            # 004b5e01
L_004b5e06:
    # block 0x004b5e06: entered by jmp at 0x004b5dcc, 2 instruction(s), falls into the block at 0x004b5e10
    mov edx, dword ptr [ebp - local_c]           # 004b5e06
    mov byte ptr [edx + field_224], 0x1          # 004b5e09
L_004b5e10:
    # block 0x004b5e10: entered by je at 0x004b5d88, 1 instruction(s), ends with backward jump to 0x004b5d68
    jmp.d32 L_004b5d68                           # 004b5e10
L_004b5e15:
    # block 0x004b5e15: entered by jge at 0x004b5d7b, 2 instruction(s), ends with forward jump to 0x004b5e27
    mov dword ptr [ebp - local_4], 0x0           # 004b5e15
    jmp.d8 L_004b5e27                            # 004b5e1c
L_004b5e1e:
    # block 0x004b5e1e: entered by jmp at 0x004b5ea7, 3 instruction(s), falls into the block at 0x004b5e27
    mov eax, dword ptr [ebp - local_4]           # 004b5e1e
    add eax, 0x1                                 # 004b5e21
    mov dword ptr [ebp - local_4], eax           # 004b5e24
L_004b5e27:
    # block 0x004b5e27: entered by jmp at 0x004b5e1c, 4 instruction(s), ends with jge to 0x004b5eac (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b5e27
    movsx edx, word ptr [ecx + field_21]         # 004b5e2a
    cmp dword ptr [ebp - local_4], edx           # 004b5e2e
    jge.d8 L_004b5eac                            # 004b5e31
    # block 0x004b5e33: entered by fall-through of jge at 0x004b5e31, 6 instruction(s), ends with jl to 0x004b5ea7 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b5e33
    mov ecx, dword ptr [ebp - local_4]           # 004b5e37
    shl ecx, 0x4                                 # 004b5e3a
    mov edx, dword ptr [ebp - local_8]           # 004b5e3d
    cmp eax, dword ptr [edx + ecx + field_14b]   # 004b5e40
    jl.d8 L_004b5ea7                             # 004b5e47
    # block 0x004b5e49: entered by fall-through of jl at 0x004b5e47, 6 instruction(s), ends with jg to 0x004b5ea7 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b5e49
    mov ecx, dword ptr [ebp - local_4]           # 004b5e4d
    shl ecx, 0x4                                 # 004b5e50
    mov edx, dword ptr [ebp - local_8]           # 004b5e53
    cmp eax, dword ptr [edx + ecx + field_153]   # 004b5e56
    jg.d8 L_004b5ea7                             # 004b5e5d
    # block 0x004b5e5f: entered by fall-through of jg at 0x004b5e5d, 6 instruction(s), ends with jl to 0x004b5ea7 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b5e5f
    mov ecx, dword ptr [ebp - local_4]           # 004b5e63
    shl ecx, 0x4                                 # 004b5e66
    mov edx, dword ptr [ebp - local_8]           # 004b5e69
    cmp eax, dword ptr [edx + ecx + field_147]   # 004b5e6c
    jl.d8 L_004b5ea7                             # 004b5e73
    # block 0x004b5e75: entered by fall-through of jl at 0x004b5e73, 6 instruction(s), ends with jg to 0x004b5ea7 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b5e75
    mov ecx, dword ptr [ebp - local_4]           # 004b5e79
    shl ecx, 0x4                                 # 004b5e7c
    mov edx, dword ptr [ebp - local_8]           # 004b5e7f
    cmp eax, dword ptr [edx + ecx + field_14f]   # 004b5e82
    jg.d8 L_004b5ea7                             # 004b5e89
    # block 0x004b5e8b: entered by fall-through of jg at 0x004b5e89, 7 instruction(s), calls FUN_004b6097, ends with forward jump to 0x004b6091
    mov ax, word ptr [ebp - local_4]             # 004b5e8b
    push eax                                     # 004b5e8f
    push 0x276c                                  # 004b5e90
    mov ecx, dword ptr [ebp - local_c]           # 004b5e95
    call FUN_004b6097                            # 004b5e98
    mov eax, 0x1                                 # 004b5e9d
    jmp.d32 L_004b6091                           # 004b5ea2
L_004b5ea7:
    # block 0x004b5ea7: entered by jl at 0x004b5e47; jg at 0x004b5e5d; jl at 0x004b5e73; jg at 0x004b5e89, 1 instruction(s), ends with backward jump to 0x004b5e1e
    jmp.d32 L_004b5e1e                           # 004b5ea7
L_004b5eac:
    # block 0x004b5eac: entered by jge at 0x004b5e31, 1 instruction(s), ends with forward jump to 0x004b603d
    jmp.d32 L_004b603d                           # 004b5eac
L_004b5eb1:
    # block 0x004b5eb1: entered by je at 0x004b5d59, 2 instruction(s), ends with forward jump to 0x004b5ec3
    mov dword ptr [ebp - local_4], 0x0           # 004b5eb1
    jmp.d8 L_004b5ec3                            # 004b5eb8
L_004b5eba:
    # block 0x004b5eba: entered by jmp at 0x004b6038, 3 instruction(s), falls into the block at 0x004b5ec3
    mov ecx, dword ptr [ebp - local_4]           # 004b5eba
    add ecx, 0x1                                 # 004b5ebd
    mov dword ptr [ebp - local_4], ecx           # 004b5ec0
L_004b5ec3:
    # block 0x004b5ec3: entered by jmp at 0x004b5eb8, 4 instruction(s), ends with jge to 0x004b603d (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b5ec3
    movsx eax, word ptr [edx + field_21]         # 004b5ec6
    cmp dword ptr [ebp - local_4], eax           # 004b5eca
    jge.d32 L_004b603d                           # 004b5ecd
    # block 0x004b5ed3: entered by fall-through of jge at 0x004b5ecd, 6 instruction(s), ends with jl to 0x004b5fc7 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004b5ed3
    mov edx, dword ptr [ebp - local_4]           # 004b5ed7
    shl edx, 0x4                                 # 004b5eda
    mov eax, dword ptr [ebp - local_8]           # 004b5edd
    cmp ecx, dword ptr [eax + edx + field_4b]    # 004b5ee0
    jl.d32 L_004b5fc7                            # 004b5ee4
    # block 0x004b5eea: entered by fall-through of jl at 0x004b5ee4, 6 instruction(s), ends with jg to 0x004b5fc7 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004b5eea
    mov edx, dword ptr [ebp - local_4]           # 004b5eee
    shl edx, 0x4                                 # 004b5ef1
    mov eax, dword ptr [ebp - local_8]           # 004b5ef4
    cmp ecx, dword ptr [eax + edx + field_53]    # 004b5ef7
    jg.d32 L_004b5fc7                            # 004b5efb
    # block 0x004b5f01: entered by fall-through of jg at 0x004b5efb, 6 instruction(s), ends with jl to 0x004b5fc7 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004b5f01
    mov edx, dword ptr [ebp - local_4]           # 004b5f05
    shl edx, 0x4                                 # 004b5f08
    mov eax, dword ptr [ebp - local_8]           # 004b5f0b
    cmp ecx, dword ptr [eax + edx + field_47]    # 004b5f0e
    jl.d32 L_004b5fc7                            # 004b5f12
    # block 0x004b5f18: entered by fall-through of jl at 0x004b5f12, 6 instruction(s), ends with jg to 0x004b5fc7 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004b5f18
    mov edx, dword ptr [ebp - local_4]           # 004b5f1c
    shl edx, 0x4                                 # 004b5f1f
    mov eax, dword ptr [ebp - local_8]           # 004b5f22
    cmp ecx, dword ptr [eax + edx + field_4f]    # 004b5f25
    jg.d32 L_004b5fc7                            # 004b5f29
    # block 0x004b5f2f: entered by fall-through of jg at 0x004b5f29, 5 instruction(s), ends with je to 0x004b5fc7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b5f2f
    mov edx, dword ptr [ebp - local_c]           # 004b5f32
    movsx eax, word ptr [edx + 2*ecx + field_254] # 004b5f35
    test eax, eax                                # 004b5f3d
    je.d32 L_004b5fc7                            # 004b5f3f
    # block 0x004b5f45: entered by fall-through of je at 0x004b5f3f, 5 instruction(s), ends with jne to 0x004b5f85 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b5f45
    mov edx, dword ptr [ebp - local_c]           # 004b5f48
    movsx eax, word ptr [edx + 2*ecx + field_232] # 004b5f4b
    test eax, eax                                # 004b5f53
    jne.d8 L_004b5f85                            # 004b5f55
    # block 0x004b5f57: entered by fall-through of jne at 0x004b5f55, 15 instruction(s), calls FUN_004b6355, ends with forward jump to 0x004b5fbd
    mov ecx, dword ptr [ebp - local_4]           # 004b5f57
    shl ecx, 0x4                                 # 004b5f5a
    mov edx, dword ptr [ebp - local_c]           # 004b5f5d
    lea eax, [edx + ecx + field_24]              # 004b5f60
    push eax                                     # 004b5f64
    push 0x0                                     # 004b5f65
    mov ecx, dword ptr [ebp - local_4]           # 004b5f67
    mov edx, dword ptr [ebp - local_c]           # 004b5f6a
    mov ax, word ptr [edx + 2*ecx + field_254]   # 004b5f6d
    push eax                                     # 004b5f75
    mov cx, word ptr [ebp - local_4]             # 004b5f76
    push ecx                                     # 004b5f7a
    mov ecx, dword ptr [ebp - local_c]           # 004b5f7b
    call FUN_004b6355                            # 004b5f7e
    jmp.d8 L_004b5fbd                            # 004b5f83
L_004b5f85:
    # block 0x004b5f85: entered by jne at 0x004b5f55, 17 instruction(s), calls FUN_004b6355, falls into the block at 0x004b5fbd
    mov edx, dword ptr [ebp - local_4]           # 004b5f85
    shl edx, 0x4                                 # 004b5f88
    mov eax, dword ptr [ebp - local_c]           # 004b5f8b
    lea ecx, [eax + edx + field_24]              # 004b5f8e
    push ecx                                     # 004b5f92
    mov edx, dword ptr [ebp - local_c]           # 004b5f93
    movsx eax, word ptr [edx + field_22c]        # 004b5f96
    sub eax, 0x1                                 # 004b5f9d
    push eax                                     # 004b5fa0
    mov ecx, dword ptr [ebp - local_4]           # 004b5fa1
    mov edx, dword ptr [ebp - local_c]           # 004b5fa4
    mov ax, word ptr [edx + 2*ecx + field_254]   # 004b5fa7
    push eax                                     # 004b5faf
    mov cx, word ptr [ebp - local_4]             # 004b5fb0
    push ecx                                     # 004b5fb4
    mov ecx, dword ptr [ebp - local_c]           # 004b5fb5
    call FUN_004b6355                            # 004b5fb8
L_004b5fbd:
    # block 0x004b5fbd: entered by jmp at 0x004b5f83, 2 instruction(s), falls into the block at 0x004b5fc7
    mov edx, dword ptr [ebp - local_c]           # 004b5fbd
    mov byte ptr [edx + field_224], 0x1          # 004b5fc0
L_004b5fc7:
    # block 0x004b5fc7: entered by jl at 0x004b5ee4; jg at 0x004b5efb; jl at 0x004b5f12; jg at 0x004b5f29; je at 0x004b5f3f, 6 instruction(s), ends with jl to 0x004b6038 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b5fc7
    mov ecx, dword ptr [ebp - local_4]           # 004b5fcb
    shl ecx, 0x4                                 # 004b5fce
    mov edx, dword ptr [ebp - local_8]           # 004b5fd1
    cmp eax, dword ptr [edx + ecx + field_14b]   # 004b5fd4
    jl.d8 L_004b6038                             # 004b5fdb
    # block 0x004b5fdd: entered by fall-through of jl at 0x004b5fdb, 6 instruction(s), ends with jg to 0x004b6038 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b5fdd
    mov ecx, dword ptr [ebp - local_4]           # 004b5fe1
    shl ecx, 0x4                                 # 004b5fe4
    mov edx, dword ptr [ebp - local_8]           # 004b5fe7
    cmp eax, dword ptr [edx + ecx + field_153]   # 004b5fea
    jg.d8 L_004b6038                             # 004b5ff1
    # block 0x004b5ff3: entered by fall-through of jg at 0x004b5ff1, 6 instruction(s), ends with jl to 0x004b6038 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b5ff3
    mov ecx, dword ptr [ebp - local_4]           # 004b5ff7
    shl ecx, 0x4                                 # 004b5ffa
    mov edx, dword ptr [ebp - local_8]           # 004b5ffd
    cmp eax, dword ptr [edx + ecx + field_147]   # 004b6000
    jl.d8 L_004b6038                             # 004b6007
    # block 0x004b6009: entered by fall-through of jl at 0x004b6007, 6 instruction(s), ends with jg to 0x004b6038 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b6009
    mov ecx, dword ptr [ebp - local_4]           # 004b600d
    shl ecx, 0x4                                 # 004b6010
    mov edx, dword ptr [ebp - local_8]           # 004b6013
    cmp eax, dword ptr [edx + ecx + field_14f]   # 004b6016
    jg.d8 L_004b6038                             # 004b601d
    # block 0x004b601f: entered by fall-through of jg at 0x004b601d, 7 instruction(s), calls FUN_004b6097, ends with forward jump to 0x004b6091
    mov ax, word ptr [ebp - local_4]             # 004b601f
    push eax                                     # 004b6023
    push 0x276c                                  # 004b6024
    mov ecx, dword ptr [ebp - local_c]           # 004b6029
    call FUN_004b6097                            # 004b602c
    mov eax, 0x1                                 # 004b6031
    jmp.d8 L_004b6091                            # 004b6036
L_004b6038:
    # block 0x004b6038: entered by jl at 0x004b5fdb; jg at 0x004b5ff1; jl at 0x004b6007; jg at 0x004b601d, 1 instruction(s), ends with backward jump to 0x004b5eba
    jmp.d32 L_004b5eba                           # 004b6038
L_004b603d:
    # block 0x004b603d: entered by jmp at 0x004b5eac; jge at 0x004b5ecd, 4 instruction(s), ends with jl to 0x004b608f (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004b603d
    mov edx, dword ptr [ebp - local_8]           # 004b6041
    cmp ecx, dword ptr [edx + field_393]         # 004b6044
    jl.d8 L_004b608f                             # 004b604a
    # block 0x004b604c: entered by fall-through of jl at 0x004b604a, 4 instruction(s), ends with jg to 0x004b608f (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b604c
    mov ecx, dword ptr [ebp - local_8]           # 004b6050
    cmp eax, dword ptr [ecx + field_39b]         # 004b6053
    jg.d8 L_004b608f                             # 004b6059
    # block 0x004b605b: entered by fall-through of jg at 0x004b6059, 4 instruction(s), ends with jl to 0x004b608f (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004b605b
    mov eax, dword ptr [ebp - local_8]           # 004b605f
    cmp edx, dword ptr [eax + field_38f]         # 004b6062
    jl.d8 L_004b608f                             # 004b6068
    # block 0x004b606a: entered by fall-through of jl at 0x004b6068, 4 instruction(s), ends with jg to 0x004b608f (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004b606a
    mov edx, dword ptr [ebp - local_8]           # 004b606e
    cmp ecx, dword ptr [edx + field_397]         # 004b6071
    jg.d8 L_004b608f                             # 004b6077
    # block 0x004b6079: entered by fall-through of jg at 0x004b6077, 6 instruction(s), calls FUN_004b6097, ends with forward jump to 0x004b6091
    push 0x0                                     # 004b6079
    push 0x276d                                  # 004b607b
    mov ecx, dword ptr [ebp - local_c]           # 004b6080
    call FUN_004b6097                            # 004b6083
    mov eax, 0x1                                 # 004b6088
    jmp.d8 L_004b6091                            # 004b608d
L_004b608f:
    # block 0x004b608f: entered by je at 0x004b5d2a; jl at 0x004b604a; jg at 0x004b6059; jl at 0x004b6068; jg at 0x004b6077, 1 instruction(s), falls into the block at 0x004b6091
    {load} xor eax, eax                          # 004b608f
L_004b6091:
    # block 0x004b6091: entered by jmp at 0x004b5ea2; jmp at 0x004b6036; jmp at 0x004b608d, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004b6091
    pop ebp                                      # 004b6093
    ret 0x8                                      # 004b6094

