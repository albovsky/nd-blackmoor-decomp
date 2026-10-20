# FUN_0045b5bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b5bb
# extent:       0x0045b5bb-0x0045b7a8 (493 code bytes)
# span:         0x0045b5bb-0x0045b7a8 (code 493, tables 0, padding 0)
# sha256:       f33181868dd2e9e169753aa6d13aefb5d4231e3215356d5bd0fc589f00728284
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45b5bb_pointer_move
# naming:       native port src/original_methods_fl19b.c:m45b5bb_pointer_move (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m45b5bb_pointer_move. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 493 bytes.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_ba, field_166, field_31d, field_321, field_329, field_33d, field_b8a; [ecx + n] field_28, field_349, field_b82, field_b86; [edx + n] field_1e, field_27, field_ba, field_325, field_32d, field_331, field_335, field_339, field_341, field_345, field_b7e
# callees:      calls FUN_0045b7a8
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl19b.c:m45b5bb_pointer_move (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 137 instruction(s), 22 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_27, 0x27  # offset +0x27
.equ field_28, 0x28  # offset +0x28
.equ field_ba, 0xba  # offset +0xba
.equ field_166, 0x166  # offset +0x166
.equ field_31d, 0x31d  # offset +0x31d
.equ field_321, 0x321  # offset +0x321
.equ field_325, 0x325  # offset +0x325
.equ field_329, 0x329  # offset +0x329
.equ field_32d, 0x32d  # offset +0x32d
.equ field_331, 0x331  # offset +0x331
.equ field_335, 0x335  # offset +0x335
.equ field_339, 0x339  # offset +0x339
.equ field_33d, 0x33d  # offset +0x33d
.equ field_341, 0x341  # offset +0x341
.equ field_345, 0x345  # offset +0x345
.equ field_349, 0x349  # offset +0x349
.equ field_b7e, 0xb7e  # offset +0xb7e
.equ field_b82, 0xb82  # offset +0xb82
.equ field_b86, 0xb86  # offset +0xb86
.equ field_b8a, 0xb8a  # offset +0xb8a

# --- external targets -----------------------------------------------
.set FUN_0045b7a8, .text + (0x0045b7a8 - 0x401000)

.org 0x0045b5bb - 0x401000
.globl FUN_0045b5bb
FUN_0045b5bb:
    # block 0x0045b5bb: entry, 7 instruction(s), ends with je to 0x0045b7a0 (forward)
    push ebp                                     # 0045b5bb
    {load} mov ebp, esp                          # 0045b5bc
    sub esp, 0x8                                 # 0045b5be
    mov dword ptr [ebp - local_8], ecx           # 0045b5c1
    mov eax, dword ptr [ebp - local_8]           # 0045b5c4
    cmp dword ptr [eax + field_166], 0x0         # 0045b5c7
    je.d32 L_0045b7a0                            # 0045b5ce
    # block 0x0045b5d4: entered by fall-through of je at 0x0045b5ce, 3 instruction(s), ends with jne to 0x0045b7a0 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0045b5d4
    cmp dword ptr [ecx + field_28], 0x0          # 0045b5d7
    jne.d32 L_0045b7a0                           # 0045b5db
    # block 0x0045b5e1: entered by fall-through of jne at 0x0045b5db, 10 instruction(s), ends with jne to 0x0045b616 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0045b5e1
    movsx eax, word ptr [edx + field_1e]         # 0045b5e4
    imul eax, eax, 0x8d                          # 0045b5e8
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045b5ee
    mov dword ptr [ebp - local_4], ecx           # 0045b5f4
    mov edx, dword ptr [ebp - local_4]           # 0045b5f7
    {load} xor eax, eax                          # 0045b5fa
    mov al, byte ptr [edx + field_27]            # 0045b5fc
    test eax, eax                                # 0045b5ff
    jne.d8 L_0045b616                            # 0045b601
    # block 0x0045b603: entered by fall-through of jne at 0x0045b601, 3 instruction(s), ends with jl to 0x0045b616 (forward)
    movsx ecx, word ptr [0x6247ee]               # 0045b603
    cmp ecx, 0x2                                 # 0045b60a
    jl.d8 L_0045b616                             # 0045b60d
    # block 0x0045b60f: entered by fall-through of jl at 0x0045b60d, 2 instruction(s), ends with forward jump to 0x0045b7a2
    {load} xor eax, eax                          # 0045b60f
    jmp.d32 L_0045b7a2                           # 0045b611
L_0045b616:
    # block 0x0045b616: entered by jne at 0x0045b601; jl at 0x0045b60d, 6 instruction(s), ends with jl to 0x0045b675 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0045b616
    mov eax, dword ptr [ebp - local_4]           # 0045b61a
    mov ecx, dword ptr [eax + field_321]         # 0045b61d
    sub ecx, 0x5                                 # 0045b623
    {load} cmp edx, ecx                          # 0045b626
    jl.d8 L_0045b675                             # 0045b628
    # block 0x0045b62a: entered by fall-through of jl at 0x0045b628, 6 instruction(s), ends with jg to 0x0045b675 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0045b62a
    mov eax, dword ptr [ebp - local_4]           # 0045b62e
    mov ecx, dword ptr [eax + field_329]         # 0045b631
    add ecx, 0x5                                 # 0045b637
    {load} cmp edx, ecx                          # 0045b63a
    jg.d8 L_0045b675                             # 0045b63c
    # block 0x0045b63e: entered by fall-through of jg at 0x0045b63c, 4 instruction(s), ends with jl to 0x0045b675 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0045b63e
    mov eax, dword ptr [ebp - local_4]           # 0045b642
    cmp edx, dword ptr [eax + field_31d]         # 0045b645
    jl.d8 L_0045b675                             # 0045b64b
    # block 0x0045b64d: entered by fall-through of jl at 0x0045b64b, 4 instruction(s), ends with jg to 0x0045b675 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0045b64d
    mov edx, dword ptr [ebp - local_4]           # 0045b651
    cmp ecx, dword ptr [edx + field_325]         # 0045b654
    jg.d8 L_0045b675                             # 0045b65a
    # block 0x0045b65c: entered by fall-through of jg at 0x0045b65a, 6 instruction(s), calls FUN_0045b7a8, ends with forward jump to 0x0045b7a2
    push 0x0                                     # 0045b65c
    push 0x27ba                                  # 0045b65e
    mov ecx, dword ptr [ebp - local_8]           # 0045b663
    call FUN_0045b7a8                            # 0045b666
    mov eax, 0x1                                 # 0045b66b
    jmp.d32 L_0045b7a2                           # 0045b670
L_0045b675:
    # block 0x0045b675: entered by jl at 0x0045b628; jg at 0x0045b63c; jl at 0x0045b64b; jg at 0x0045b65a, 4 instruction(s), ends with je to 0x0045b693 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0045b675
    movsx ecx, word ptr [eax + field_ba]         # 0045b678
    cmp ecx, 0x1                                 # 0045b67f
    je.d8 L_0045b693                             # 0045b682
    # block 0x0045b684: entered by fall-through of je at 0x0045b682, 4 instruction(s), ends with jne to 0x0045b6fc (forward)
    mov edx, dword ptr [ebp - local_8]           # 0045b684
    movsx eax, word ptr [edx + field_ba]         # 0045b687
    cmp eax, 0x3                                 # 0045b68e
    jne.d8 L_0045b6fc                            # 0045b691
L_0045b693:
    # block 0x0045b693: entered by je at 0x0045b682; fall-through of jne at 0x0045b691, 6 instruction(s), ends with jl to 0x0045b6fc (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0045b693
    mov edx, dword ptr [ebp - local_4]           # 0045b697
    mov eax, dword ptr [edx + field_331]         # 0045b69a
    add eax, 0x5                                 # 0045b6a0
    {load} cmp ecx, eax                          # 0045b6a3
    jl.d8 L_0045b6fc                             # 0045b6a5
    # block 0x0045b6a7: entered by fall-through of jl at 0x0045b6a5, 6 instruction(s), ends with jg to 0x0045b6fc (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0045b6a7
    mov edx, dword ptr [ebp - local_4]           # 0045b6ab
    mov eax, dword ptr [edx + field_339]         # 0045b6ae
    add eax, 0x5                                 # 0045b6b4
    {load} cmp ecx, eax                          # 0045b6b7
    jg.d8 L_0045b6fc                             # 0045b6b9
    # block 0x0045b6bb: entered by fall-through of jg at 0x0045b6b9, 6 instruction(s), ends with jl to 0x0045b6fc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0045b6bb
    mov edx, dword ptr [ebp - local_4]           # 0045b6bf
    mov eax, dword ptr [edx + field_32d]         # 0045b6c2
    add eax, 0xa                                 # 0045b6c8
    {load} cmp ecx, eax                          # 0045b6cb
    jl.d8 L_0045b6fc                             # 0045b6cd
    # block 0x0045b6cf: entered by fall-through of jl at 0x0045b6cd, 6 instruction(s), ends with jg to 0x0045b6fc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0045b6cf
    mov edx, dword ptr [ebp - local_4]           # 0045b6d3
    mov eax, dword ptr [edx + field_335]         # 0045b6d6
    sub eax, 0xa                                 # 0045b6dc
    {load} cmp ecx, eax                          # 0045b6df
    jg.d8 L_0045b6fc                             # 0045b6e1
    # block 0x0045b6e3: entered by fall-through of jg at 0x0045b6e1, 6 instruction(s), calls FUN_0045b7a8, ends with forward jump to 0x0045b7a2
    push 0x1                                     # 0045b6e3
    push 0x27ba                                  # 0045b6e5
    mov ecx, dword ptr [ebp - local_8]           # 0045b6ea
    call FUN_0045b7a8                            # 0045b6ed
    mov eax, 0x1                                 # 0045b6f2
    jmp.d32 L_0045b7a2                           # 0045b6f7
L_0045b6fc:
    # block 0x0045b6fc: entered by jne at 0x0045b691; jl at 0x0045b6a5; jg at 0x0045b6b9; jl at 0x0045b6cd; jg at 0x0045b6e1, 4 instruction(s), ends with jl to 0x0045b74e (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0045b6fc
    mov edx, dword ptr [ebp - local_4]           # 0045b700
    cmp ecx, dword ptr [edx + field_341]         # 0045b703
    jl.d8 L_0045b74e                             # 0045b709
    # block 0x0045b70b: entered by fall-through of jl at 0x0045b709, 4 instruction(s), ends with jg to 0x0045b74e (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0045b70b
    mov ecx, dword ptr [ebp - local_4]           # 0045b70f
    cmp eax, dword ptr [ecx + field_349]         # 0045b712
    jg.d8 L_0045b74e                             # 0045b718
    # block 0x0045b71a: entered by fall-through of jg at 0x0045b718, 4 instruction(s), ends with jl to 0x0045b74e (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0045b71a
    mov eax, dword ptr [ebp - local_4]           # 0045b71e
    cmp edx, dword ptr [eax + field_33d]         # 0045b721
    jl.d8 L_0045b74e                             # 0045b727
    # block 0x0045b729: entered by fall-through of jl at 0x0045b727, 4 instruction(s), ends with jg to 0x0045b74e (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0045b729
    mov edx, dword ptr [ebp - local_4]           # 0045b72d
    cmp ecx, dword ptr [edx + field_345]         # 0045b730
    jg.d8 L_0045b74e                             # 0045b736
    # block 0x0045b738: entered by fall-through of jg at 0x0045b736, 6 instruction(s), calls FUN_0045b7a8, ends with forward jump to 0x0045b7a2
    push 0x2                                     # 0045b738
    push 0x27ba                                  # 0045b73a
    mov ecx, dword ptr [ebp - local_8]           # 0045b73f
    call FUN_0045b7a8                            # 0045b742
    mov eax, 0x1                                 # 0045b747
    jmp.d8 L_0045b7a2                            # 0045b74c
L_0045b74e:
    # block 0x0045b74e: entered by jl at 0x0045b709; jg at 0x0045b718; jl at 0x0045b727; jg at 0x0045b736, 4 instruction(s), ends with jl to 0x0045b7a0 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0045b74e
    mov ecx, dword ptr [ebp - local_4]           # 0045b752
    cmp eax, dword ptr [ecx + field_b82]         # 0045b755
    jl.d8 L_0045b7a0                             # 0045b75b
    # block 0x0045b75d: entered by fall-through of jl at 0x0045b75b, 4 instruction(s), ends with jg to 0x0045b7a0 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0045b75d
    mov eax, dword ptr [ebp - local_4]           # 0045b761
    cmp edx, dword ptr [eax + field_b8a]         # 0045b764
    jg.d8 L_0045b7a0                             # 0045b76a
    # block 0x0045b76c: entered by fall-through of jg at 0x0045b76a, 4 instruction(s), ends with jl to 0x0045b7a0 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0045b76c
    mov edx, dword ptr [ebp - local_4]           # 0045b770
    cmp ecx, dword ptr [edx + field_b7e]         # 0045b773
    jl.d8 L_0045b7a0                             # 0045b779
    # block 0x0045b77b: entered by fall-through of jl at 0x0045b779, 4 instruction(s), ends with jg to 0x0045b7a0 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0045b77b
    mov ecx, dword ptr [ebp - local_4]           # 0045b77f
    cmp eax, dword ptr [ecx + field_b86]         # 0045b782
    jg.d8 L_0045b7a0                             # 0045b788
    # block 0x0045b78a: entered by fall-through of jg at 0x0045b788, 6 instruction(s), calls FUN_0045b7a8, ends with forward jump to 0x0045b7a2
    push 0x0                                     # 0045b78a
    push 0x27bb                                  # 0045b78c
    mov ecx, dword ptr [ebp - local_8]           # 0045b791
    call FUN_0045b7a8                            # 0045b794
    mov eax, 0x1                                 # 0045b799
    jmp.d8 L_0045b7a2                            # 0045b79e
L_0045b7a0:
    # block 0x0045b7a0: entered by je at 0x0045b5ce; jne at 0x0045b5db; jl at 0x0045b75b; jg at 0x0045b76a; more, 1 instruction(s), falls into the block at 0x0045b7a2
    {load} xor eax, eax                          # 0045b7a0
L_0045b7a2:
    # block 0x0045b7a2: entered by jmp at 0x0045b611; jmp at 0x0045b670; jmp at 0x0045b6f7; jmp at 0x0045b74c; more, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0045b7a2
    pop ebp                                      # 0045b7a4
    ret 0x8                                      # 0045b7a5

