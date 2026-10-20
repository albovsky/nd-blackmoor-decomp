# FUN_00414947
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414947
# extent:       0x00414947-0x00414c6d (806 code bytes)
# span:         0x00414947-0x00414c6d (code 806, tables 0, padding 0)
# sha256:       1adac407bc2dc2fc8da84913f7fad53e858def5411d5f028e230a96dbc1e4245
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         action1b_step
# naming:       native port src/action_family_1b_runtime.c:action1b_step (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with action1b_step (phases 0/1/2, first-match scan). Native: decoded row view passed in; +0x1c/+0x20/+0x24 scratch stores not modelled; NULL args refused.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_a, field_1c, field_20; [ecx + n] field_6, field_e, field_1c, field_1e, field_20, field_24; [edx + n] field_2, field_6, field_8, field_a, field_c, field_e, field_10, field_12, field_14, field_18, field_1c, field_20 and 1 more
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_1b_runtime.c:action1b_step (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 196 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x00414947 - 0x401000
.globl FUN_00414947
FUN_00414947:
    # block 0x00414947: entry, 25 instruction(s), ends with je to 0x004149b2 (forward)
    push ebp                                     # 00414947
    {load} mov ebp, esp                          # 00414948
    sub esp, 0x14                                # 0041494a
    mov dword ptr [ebp - local_10], ecx          # 0041494d
    movsx eax, word ptr [ebp + arg_8]            # 00414950
    imul eax, eax, 0x8d                          # 00414954
    mov ecx, dword ptr [ebp - local_10]          # 0041495a
    mov edx, dword ptr [eax + 0x5bb5e5]          # 0041495d
    mov dword ptr [ecx + field_1c], edx          # 00414963
    mov eax, dword ptr [ebp - local_10]          # 00414966
    mov ecx, dword ptr [eax + field_1c]          # 00414969
    mov edx, dword ptr [ebp - local_10]          # 0041496c
    mov eax, dword ptr [ecx + field_1e]          # 0041496f
    mov dword ptr [edx + field_24], eax          # 00414972
    mov ecx, dword ptr [ebp - local_10]          # 00414975
    mov edx, dword ptr [ecx + field_1c]          # 00414978
    mov eax, dword ptr [ebp - local_10]          # 0041497b
    mov ecx, dword ptr [edx + field_2]           # 0041497e
    mov dword ptr [eax + field_20], ecx          # 00414981
    movsx edx, word ptr [ebp + arg_8]            # 00414984
    imul edx, edx, 0x8d                          # 00414988
    mov eax, dword ptr [edx + 0x5bb632]          # 0041498e
    mov dword ptr [ebp - local_14], eax          # 00414994
    cmp dword ptr [ebp - local_14], 0x0          # 00414997
    je.d8 L_004149b2                             # 0041499b
    # block 0x0041499d: entered by fall-through of je at 0x0041499b, 2 instruction(s), ends with je to 0x004149d0 (forward)
    cmp dword ptr [ebp - local_14], 0x1          # 0041499d
    je.d8 L_004149d0                             # 004149a1
    # block 0x004149a3: entered by fall-through of je at 0x004149a1, 2 instruction(s), ends with je to 0x00414ada (forward)
    cmp dword ptr [ebp - local_14], 0x2          # 004149a3
    je.d32 L_00414ada                            # 004149a7
    # block 0x004149ad: entered by fall-through of je at 0x004149a7, 1 instruction(s), ends with forward jump to 0x00414c67
    jmp.d32 L_00414c67                           # 004149ad
L_004149b2:
    # block 0x004149b2: entered by je at 0x0041499b, 4 instruction(s), falls into the block at 0x004149d0
    mov dword ptr [0x5bb1ca], 0x1                # 004149b2
    movsx ecx, word ptr [ebp + arg_8]            # 004149bc
    imul ecx, ecx, 0x8d                          # 004149c0
    mov dword ptr [ecx + 0x5bb632], 0x1          # 004149c6
L_004149d0:
    # block 0x004149d0: entered by je at 0x004149a1, 5 instruction(s), ends with forward jump to 0x004149f8
    movsx edx, word ptr [ebp + arg_8]            # 004149d0
    imul edx, edx, 0x8d                          # 004149d4
    mov dword ptr [edx + 0x5bb626], 0x0          # 004149da
    mov word ptr [ebp - local_c], 0x0            # 004149e4
    jmp.d8 L_004149f8                            # 004149ea
L_004149ec:
    # block 0x004149ec: entered by jmp at 0x00414ad0, 3 instruction(s), falls into the block at 0x004149f8
    mov ax, word ptr [ebp - local_c]             # 004149ec
    .insn 0x66, 0x05, 0x0001{:u16}               # 004149f0
    mov word ptr [ebp - local_c], ax             # 004149f4
L_004149f8:
    # block 0x004149f8: entered by jmp at 0x004149ea, 6 instruction(s), ends with jge to 0x00414ad5 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004149f8
    mov edx, dword ptr [ebp - local_10]          # 004149fc
    mov eax, dword ptr [edx + field_1c]          # 004149ff
    movsx edx, word ptr [eax + field_1c]         # 00414a02
    {load} cmp ecx, edx                          # 00414a06
    jge.d32 L_00414ad5                           # 00414a08
    # block 0x00414a0e: entered by fall-through of jge at 0x00414a08, 8 instruction(s), ends with jne to 0x00414ad0 (forward)
    movsx eax, word ptr [ebp - local_c]          # 00414a0e
    imul eax, eax, 0x12                          # 00414a12
    mov ecx, dword ptr [ebp - local_10]          # 00414a15
    mov edx, dword ptr [ecx + field_24]          # 00414a18
    movsx eax, word ptr [edx + eax]              # 00414a1b
    movsx ecx, word ptr [0x5bb50b]               # 00414a1f
    {load} cmp eax, ecx                          # 00414a26
    jne.d32 L_00414ad0                           # 00414a28
    # block 0x00414a2e: entered by fall-through of jne at 0x00414a28, 36 instruction(s), ends with forward jump to 0x00414ad5
    movsx edx, word ptr [ebp + arg_8]            # 00414a2e
    imul edx, edx, 0x8d                          # 00414a32
    mov dword ptr [edx + 0x5bb626], 0x1          # 00414a38
    movsx eax, word ptr [ebp - local_c]          # 00414a42
    imul eax, eax, 0x12                          # 00414a46
    mov ecx, dword ptr [ebp - local_10]          # 00414a49
    mov edx, dword ptr [ecx + field_24]          # 00414a4c
    movsx ecx, word ptr [ebp + arg_8]            # 00414a4f
    imul ecx, ecx, 0x8d                          # 00414a53
    mov dx, word ptr [edx + eax + field_2]       # 00414a59
    mov word ptr [ecx + 0x5bb62a], dx            # 00414a5e
    movsx eax, word ptr [ebp - local_c]          # 00414a65
    imul eax, eax, 0x12                          # 00414a69
    mov ecx, dword ptr [ebp - local_10]          # 00414a6c
    mov edx, dword ptr [ecx + field_24]          # 00414a6f
    movsx ecx, word ptr [ebp + arg_8]            # 00414a72
    imul ecx, ecx, 0x8d                          # 00414a76
    mov dx, word ptr [edx + eax + field_6]       # 00414a7c
    mov word ptr [ecx + 0x5bb62c], dx            # 00414a81
    movsx eax, word ptr [ebp - local_c]          # 00414a88
    imul eax, eax, 0x12                          # 00414a8c
    mov ecx, dword ptr [ebp - local_10]          # 00414a8f
    mov edx, dword ptr [ecx + field_24]          # 00414a92
    movsx ecx, word ptr [ebp + arg_8]            # 00414a95
    imul ecx, ecx, 0x8d                          # 00414a99
    mov dx, word ptr [edx + eax + field_a]       # 00414a9f
    mov word ptr [ecx + 0x5bb62e], dx            # 00414aa4
    movsx eax, word ptr [ebp - local_c]          # 00414aab
    imul eax, eax, 0x12                          # 00414aaf
    mov ecx, dword ptr [ebp - local_10]          # 00414ab2
    mov edx, dword ptr [ecx + field_24]          # 00414ab5
    movsx ecx, word ptr [ebp + arg_8]            # 00414ab8
    imul ecx, ecx, 0x8d                          # 00414abc
    mov dx, word ptr [edx + eax + field_e]       # 00414ac2
    mov word ptr [ecx + 0x5bb630], dx            # 00414ac7
    jmp.d8 L_00414ad5                            # 00414ace
L_00414ad0:
    # block 0x00414ad0: entered by jne at 0x00414a28, 1 instruction(s), ends with backward jump to 0x004149ec
    jmp.d32 L_004149ec                           # 00414ad0
L_00414ad5:
    # block 0x00414ad5: entered by jge at 0x00414a08; jmp at 0x00414ace, 1 instruction(s), ends with forward jump to 0x00414c67
    jmp.d32 L_00414c67                           # 00414ad5
L_00414ada:
    # block 0x00414ada: entered by je at 0x004149a7, 6 instruction(s), ends with forward jump to 0x00414b06
    movsx eax, word ptr [ebp + arg_8]            # 00414ada
    imul eax, eax, 0x8d                          # 00414ade
    mov byte ptr [eax + 0x5bb625], 0x1           # 00414ae4
    mov dword ptr [ebp - local_4], 0x0           # 00414aeb
    mov word ptr [ebp - local_8], 0x0            # 00414af2
    jmp.d8 L_00414b06                            # 00414af8
L_00414afa:
    # block 0x00414afa: entered by jmp at 0x00414be9, 3 instruction(s), falls into the block at 0x00414b06
    mov cx, word ptr [ebp - local_8]             # 00414afa
    add cx, 0x1                                  # 00414afe
    mov word ptr [ebp - local_8], cx             # 00414b02
L_00414b06:
    # block 0x00414b06: entered by jmp at 0x00414af8, 6 instruction(s), ends with jge to 0x00414bee (forward)
    movsx edx, word ptr [ebp - local_8]          # 00414b06
    mov eax, dword ptr [ebp - local_10]          # 00414b0a
    mov ecx, dword ptr [eax + field_1c]          # 00414b0d
    movsx eax, word ptr [ecx]                    # 00414b10
    {load} cmp edx, eax                          # 00414b13
    jge.d32 L_00414bee                           # 00414b15
    # block 0x00414b1b: entered by fall-through of jge at 0x00414b15, 8 instruction(s), ends with jne to 0x00414be9 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 00414b1b
    imul ecx, ecx, 0x16                          # 00414b1f
    mov edx, dword ptr [ebp - local_10]          # 00414b22
    mov eax, dword ptr [edx + field_20]          # 00414b25
    movsx ecx, word ptr [eax + ecx]              # 00414b28
    movsx edx, word ptr [0x583a29]               # 00414b2c
    {load} cmp ecx, edx                          # 00414b33
    jne.d32 L_00414be9                           # 00414b35
    # block 0x00414b3b: entered by fall-through of jne at 0x00414b35, 44 instruction(s), ends with forward jump to 0x00414bee
    movsx eax, word ptr [ebp - local_8]          # 00414b3b
    imul eax, eax, 0x16                          # 00414b3f
    mov ecx, dword ptr [ebp - local_10]          # 00414b42
    mov edx, dword ptr [ecx + field_20]          # 00414b45
    movsx eax, word ptr [edx + eax + field_2]    # 00414b48
    mov dword ptr [0x5bb57b], eax                # 00414b4d
    movsx ecx, word ptr [ebp - local_8]          # 00414b52
    imul ecx, ecx, 0x16                          # 00414b56
    mov edx, dword ptr [ebp - local_10]          # 00414b59
    mov eax, dword ptr [edx + field_20]          # 00414b5c
    mov cx, word ptr [eax + ecx + field_4]       # 00414b5f
    mov word ptr [0x5bb599], cx                  # 00414b64
    movsx edx, word ptr [ebp - local_8]          # 00414b6b
    imul edx, edx, 0x16                          # 00414b6f
    mov eax, dword ptr [ebp - local_10]          # 00414b72
    mov ecx, dword ptr [eax + field_20]          # 00414b75
    mov dx, word ptr [ecx + edx + field_6]       # 00414b78
    mov word ptr [0x5bb595], dx                  # 00414b7d
    movsx eax, word ptr [ebp - local_8]          # 00414b84
    imul eax, eax, 0x16                          # 00414b88
    mov ecx, dword ptr [ebp - local_10]          # 00414b8b
    mov edx, dword ptr [ecx + field_20]          # 00414b8e
    mov ax, word ptr [edx + eax + field_8]       # 00414b91
    mov word ptr [0x5c39ff], ax                  # 00414b96
    movsx ecx, word ptr [ebp - local_8]          # 00414b9c
    imul ecx, ecx, 0x16                          # 00414ba0
    mov edx, dword ptr [ebp - local_10]          # 00414ba3
    mov eax, dword ptr [edx + field_20]          # 00414ba6
    mov ecx, dword ptr [eax + ecx + field_a]     # 00414ba9
    mov dword ptr [0x5bb59b], ecx                # 00414bad
    movsx edx, word ptr [ebp - local_8]          # 00414bb3
    imul edx, edx, 0x16                          # 00414bb7
    mov eax, dword ptr [ebp - local_10]          # 00414bba
    mov ecx, dword ptr [eax + field_20]          # 00414bbd
    mov edx, dword ptr [ecx + edx + field_e]     # 00414bc0
    mov dword ptr [0x5bb59f], edx                # 00414bc4
    movsx eax, word ptr [ebp - local_8]          # 00414bca
    imul eax, eax, 0x16                          # 00414bce
    mov ecx, dword ptr [ebp - local_10]          # 00414bd1
    mov edx, dword ptr [ecx + field_20]          # 00414bd4
    mov eax, dword ptr [edx + eax + field_12]    # 00414bd7
    mov dword ptr [0x5bb5a3], eax                # 00414bdb
    mov dword ptr [ebp - local_4], 0x1           # 00414be0
    jmp.d8 L_00414bee                            # 00414be7
L_00414be9:
    # block 0x00414be9: entered by jne at 0x00414b35, 1 instruction(s), ends with backward jump to 0x00414afa
    jmp.d32 L_00414afa                           # 00414be9
L_00414bee:
    # block 0x00414bee: entered by jge at 0x00414b15; jmp at 0x00414be7, 2 instruction(s), ends with jne to 0x00414c5d (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00414bee
    jne.d8 L_00414c5d                            # 00414bf2
    # block 0x00414bf4: entered by fall-through of jne at 0x00414bf2, 28 instruction(s), falls into the block at 0x00414c5d
    mov ecx, dword ptr [ebp - local_10]          # 00414bf4
    mov edx, dword ptr [ecx + field_1c]          # 00414bf7
    movsx eax, word ptr [edx + field_8]          # 00414bfa
    mov dword ptr [0x5bb57b], eax                # 00414bfe
    mov ecx, dword ptr [ebp - local_10]          # 00414c03
    mov edx, dword ptr [ecx + field_1c]          # 00414c06
    mov ax, word ptr [edx + field_a]             # 00414c09
    mov word ptr [0x5bb599], ax                  # 00414c0d
    mov ecx, dword ptr [ebp - local_10]          # 00414c13
    mov edx, dword ptr [ecx + field_1c]          # 00414c16
    mov ax, word ptr [edx + field_c]             # 00414c19
    mov word ptr [0x5bb595], ax                  # 00414c1d
    mov ecx, dword ptr [ebp - local_10]          # 00414c23
    mov edx, dword ptr [ecx + field_1c]          # 00414c26
    mov ax, word ptr [edx + field_e]             # 00414c29
    mov word ptr [0x5c39ff], ax                  # 00414c2d
    mov ecx, dword ptr [ebp - local_10]          # 00414c33
    mov edx, dword ptr [ecx + field_1c]          # 00414c36
    mov eax, dword ptr [edx + field_10]          # 00414c39
    mov dword ptr [0x5bb59b], eax                # 00414c3c
    mov ecx, dword ptr [ebp - local_10]          # 00414c41
    mov edx, dword ptr [ecx + field_1c]          # 00414c44
    mov eax, dword ptr [edx + field_14]          # 00414c47
    mov dword ptr [0x5bb59f], eax                # 00414c4a
    mov ecx, dword ptr [ebp - local_10]          # 00414c4f
    mov edx, dword ptr [ecx + field_1c]          # 00414c52
    mov eax, dword ptr [edx + field_18]          # 00414c55
    mov dword ptr [0x5bb5a3], eax                # 00414c58
L_00414c5d:
    # block 0x00414c5d: entered by jne at 0x00414bf2, 1 instruction(s), falls into the block at 0x00414c67
    mov dword ptr [0x583999], 0x4                # 00414c5d
L_00414c67:
    # block 0x00414c67: entered by jmp at 0x004149ad; jmp at 0x00414ad5, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00414c67
    pop ebp                                      # 00414c69
    ret 0x4                                      # 00414c6a

