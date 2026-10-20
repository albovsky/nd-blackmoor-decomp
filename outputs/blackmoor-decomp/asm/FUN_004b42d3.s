# FUN_004b42d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b42d3
# extent:       0x004b42d3-0x004b450f (572 code bytes)
# span:         0x004b42d3-0x004b450f (code 572, tables 0, padding 0)
# sha256:       6bedbe07f7f003f5efd3b2bd11a5ffe14c8b9a3aa74c7a6508b186548ca042ba
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b42d3_hit_test
# naming:       native port src/original_methods_fl26a.c:m4b42d3_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4b42d3_hit_test. Oracle window runs all 129 instructions of the 572 bytes, 22/22 jcc directions, the rectangle copy, three rows and the tail rectangle behind the word [+0x750]. See tasks/fl26a-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_728, field_758, field_75a, field_76e, field_89e; [ecx + n] field_e9, field_ed, field_f1, field_f5, field_728, field_75c, field_75e, field_762, field_766, field_76a, field_8aa; [edx + n] field_4, field_8, field_c, field_728, field_750, field_75a, field_75c, field_8a2, field_8a6
# callees:      calls FUN_004b3f98, FUN_004b450f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl26a.c:m4b42d3_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 129 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_e9, 0xe9  # offset +0xe9
.equ field_ed, 0xed  # offset +0xed
.equ field_f1, 0xf1  # offset +0xf1
.equ field_f5, 0xf5  # offset +0xf5
.equ field_728, 0x728  # offset +0x728
.equ field_750, 0x750  # offset +0x750
.equ field_758, 0x758  # offset +0x758
.equ field_75a, 0x75a  # offset +0x75a
.equ field_75c, 0x75c  # offset +0x75c
.equ field_75e, 0x75e  # offset +0x75e
.equ field_762, 0x762  # offset +0x762
.equ field_766, 0x766  # offset +0x766
.equ field_76a, 0x76a  # offset +0x76a
.equ field_76e, 0x76e  # offset +0x76e
.equ field_89e, 0x89e  # offset +0x89e
.equ field_8a2, 0x8a2  # offset +0x8a2
.equ field_8a6, 0x8a6  # offset +0x8a6
.equ field_8aa, 0x8aa  # offset +0x8aa

# --- external targets -----------------------------------------------
.set FUN_004b3f98, .text + (0x004b3f98 - 0x401000)
.set FUN_004b450f, .text + (0x004b450f - 0x401000)

.org 0x004b42d3 - 0x401000
.globl FUN_004b42d3
FUN_004b42d3:
    # block 0x004b42d3: entry, 7 instruction(s), ends with je to 0x004b4507 (forward)
    push ebp                                     # 004b42d3
    {load} mov ebp, esp                          # 004b42d4
    sub esp, 0x8                                 # 004b42d6
    mov dword ptr [ebp - local_8], ecx           # 004b42d9
    mov eax, dword ptr [ebp - local_8]           # 004b42dc
    cmp dword ptr [eax + field_76e], 0x0         # 004b42df
    je.d32 L_004b4507                            # 004b42e6
    # block 0x004b42ec: entered by fall-through of je at 0x004b42e6, 26 instruction(s), calls FUN_004b3f98, ends with forward jump to 0x004b4367
    mov ecx, dword ptr [ebp - local_8]           # 004b42ec
    mov word ptr [ecx + field_75c], 0xffff       # 004b42ef
    mov edx, dword ptr [ebp - local_8]           # 004b42f8
    mov word ptr [edx + field_75a], 0xffff       # 004b42fb
    mov eax, dword ptr [ebp - local_8]           # 004b4304
    mov word ptr [eax + field_758], 0xffff       # 004b4307
    mov ecx, dword ptr [ebp - local_8]           # 004b4310
    mov edx, dword ptr [ebp + arg_10]            # 004b4313
    mov eax, dword ptr [edx + field_4]           # 004b4316
    mov dword ptr [ecx + field_762], eax         # 004b4319
    mov ecx, dword ptr [ebp - local_8]           # 004b431f
    mov edx, dword ptr [ebp + arg_10]            # 004b4322
    mov eax, dword ptr [edx + field_c]           # 004b4325
    mov dword ptr [ecx + field_76a], eax         # 004b4328
    mov ecx, dword ptr [ebp - local_8]           # 004b432e
    mov edx, dword ptr [ebp + arg_10]            # 004b4331
    mov eax, dword ptr [edx]                     # 004b4334
    mov dword ptr [ecx + field_75e], eax         # 004b4336
    mov ecx, dword ptr [ebp - local_8]           # 004b433c
    mov edx, dword ptr [ebp + arg_10]            # 004b433f
    mov eax, dword ptr [edx + field_8]           # 004b4342
    mov dword ptr [ecx + field_766], eax         # 004b4345
    mov ecx, dword ptr [ebp - local_8]           # 004b434b
    call FUN_004b3f98                            # 004b434e
    mov word ptr [ebp - local_4], 0x0            # 004b4353
    jmp.d8 L_004b4367                            # 004b4359
L_004b435b:
    # block 0x004b435b: entered by jmp at 0x004b4457, 3 instruction(s), falls into the block at 0x004b4367
    mov cx, word ptr [ebp - local_4]             # 004b435b
    add cx, 0x1                                  # 004b435f
    mov word ptr [ebp - local_4], cx             # 004b4363
L_004b4367:
    # block 0x004b4367: entered by jmp at 0x004b4359, 3 instruction(s), ends with jge to 0x004b445c (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b4367
    cmp edx, 0x3                                 # 004b436b
    jge.d32 L_004b445c                           # 004b436e
    # block 0x004b4374: entered by fall-through of jge at 0x004b436e, 9 instruction(s), ends with jl to 0x004b4457 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b4374
    mov ecx, dword ptr [ebp - local_8]           # 004b4378
    movsx edx, word ptr [ecx + field_728]        # 004b437b
    imul edx, edx, 0x8d                          # 004b4382
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004b4388
    movsx edx, word ptr [ebp - local_4]          # 004b438e
    shl edx, 0x4                                 # 004b4392
    cmp eax, dword ptr [ecx + edx + field_ed]    # 004b4395
    jl.d32 L_004b4457                            # 004b439c
    # block 0x004b43a2: entered by fall-through of jl at 0x004b439c, 9 instruction(s), ends with jg to 0x004b4457 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b43a2
    mov ecx, dword ptr [ebp - local_8]           # 004b43a6
    movsx edx, word ptr [ecx + field_728]        # 004b43a9
    imul edx, edx, 0x8d                          # 004b43b0
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004b43b6
    movsx edx, word ptr [ebp - local_4]          # 004b43bc
    shl edx, 0x4                                 # 004b43c0
    cmp eax, dword ptr [ecx + edx + field_f5]    # 004b43c3
    jg.d32 L_004b4457                            # 004b43ca
    # block 0x004b43d0: entered by fall-through of jg at 0x004b43ca, 9 instruction(s), ends with jl to 0x004b4457 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b43d0
    mov ecx, dword ptr [ebp - local_8]           # 004b43d4
    movsx edx, word ptr [ecx + field_728]        # 004b43d7
    imul edx, edx, 0x8d                          # 004b43de
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004b43e4
    movsx edx, word ptr [ebp - local_4]          # 004b43ea
    shl edx, 0x4                                 # 004b43ee
    cmp eax, dword ptr [ecx + edx + field_e9]    # 004b43f1
    jl.d8 L_004b4457                             # 004b43f8
    # block 0x004b43fa: entered by fall-through of jl at 0x004b43f8, 9 instruction(s), ends with jg to 0x004b4457 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b43fa
    mov ecx, dword ptr [ebp - local_8]           # 004b43fe
    movsx edx, word ptr [ecx + field_728]        # 004b4401
    imul edx, edx, 0x8d                          # 004b4408
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004b440e
    movsx edx, word ptr [ebp - local_4]          # 004b4414
    shl edx, 0x4                                 # 004b4418
    cmp eax, dword ptr [ecx + edx + field_f1]    # 004b441b
    jg.d8 L_004b4457                             # 004b4422
    # block 0x004b4424: entered by fall-through of jg at 0x004b4422, 12 instruction(s), calls FUN_004b450f, ends with forward jump to 0x004b4509
    mov eax, dword ptr [ebp - local_8]           # 004b4424
    mov cx, word ptr [ebp + arg_8]               # 004b4427
    mov word ptr [eax + field_75a], cx           # 004b442b
    mov edx, dword ptr [ebp - local_8]           # 004b4432
    mov ax, word ptr [ebp + arg_c]               # 004b4435
    mov word ptr [edx + field_75c], ax           # 004b4439
    mov cx, word ptr [ebp - local_4]             # 004b4440
    push ecx                                     # 004b4444
    mov ecx, dword ptr [ebp - local_8]           # 004b4445
    call FUN_004b450f                            # 004b4448
    mov eax, 0x1                                 # 004b444d
    jmp.d32 L_004b4509                           # 004b4452
L_004b4457:
    # block 0x004b4457: entered by jl at 0x004b439c; jg at 0x004b43ca; jl at 0x004b43f8; jg at 0x004b4422, 1 instruction(s), ends with backward jump to 0x004b435b
    jmp.d32 L_004b435b                           # 004b4457
L_004b445c:
    # block 0x004b445c: entered by jge at 0x004b436e, 4 instruction(s), ends with jne to 0x004b4507 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b445c
    movsx eax, word ptr [edx + field_750]        # 004b445f
    test eax, eax                                # 004b4466
    jne.d32 L_004b4507                           # 004b4468
    # block 0x004b446e: entered by fall-through of jne at 0x004b4468, 7 instruction(s), ends with jl to 0x004b4507 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004b446e
    mov edx, dword ptr [ebp - local_8]           # 004b4472
    movsx eax, word ptr [edx + field_728]        # 004b4475
    imul eax, eax, 0x8d                          # 004b447c
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004b4482
    cmp ecx, dword ptr [edx + field_8a2]         # 004b4488
    jl.d8 L_004b4507                             # 004b448e
    # block 0x004b4490: entered by fall-through of jl at 0x004b448e, 7 instruction(s), ends with jg to 0x004b4507 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004b4490
    mov ecx, dword ptr [ebp - local_8]           # 004b4494
    movsx edx, word ptr [ecx + field_728]        # 004b4497
    imul edx, edx, 0x8d                          # 004b449e
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004b44a4
    cmp eax, dword ptr [ecx + field_8aa]         # 004b44aa
    jg.d8 L_004b4507                             # 004b44b0
    # block 0x004b44b2: entered by fall-through of jg at 0x004b44b0, 7 instruction(s), ends with jl to 0x004b4507 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004b44b2
    mov eax, dword ptr [ebp - local_8]           # 004b44b6
    movsx ecx, word ptr [eax + field_728]        # 004b44b9
    imul ecx, ecx, 0x8d                          # 004b44c0
    mov eax, dword ptr [ecx + 0x5bb5e5]          # 004b44c6
    cmp edx, dword ptr [eax + field_89e]         # 004b44cc
    jl.d8 L_004b4507                             # 004b44d2
    # block 0x004b44d4: entered by fall-through of jl at 0x004b44d2, 7 instruction(s), ends with jg to 0x004b4507 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004b44d4
    mov edx, dword ptr [ebp - local_8]           # 004b44d8
    movsx eax, word ptr [edx + field_728]        # 004b44db
    imul eax, eax, 0x8d                          # 004b44e2
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004b44e8
    cmp ecx, dword ptr [edx + field_8a6]         # 004b44ee
    jg.d8 L_004b4507                             # 004b44f4
    # block 0x004b44f6: entered by fall-through of jg at 0x004b44f4, 5 instruction(s), calls FUN_004b450f, ends with forward jump to 0x004b4509
    push 0x64                                    # 004b44f6
    mov ecx, dword ptr [ebp - local_8]           # 004b44f8
    call FUN_004b450f                            # 004b44fb
    mov eax, 0x1                                 # 004b4500
    jmp.d8 L_004b4509                            # 004b4505
L_004b4507:
    # block 0x004b4507: entered by je at 0x004b42e6; jne at 0x004b4468; jl at 0x004b448e; jg at 0x004b44b0; more, 1 instruction(s), falls into the block at 0x004b4509
    {load} xor eax, eax                          # 004b4507
L_004b4509:
    # block 0x004b4509: entered by jmp at 0x004b4452; jmp at 0x004b4505, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004b4509
    pop ebp                                      # 004b450b
    ret 0xc                                      # 004b450c

