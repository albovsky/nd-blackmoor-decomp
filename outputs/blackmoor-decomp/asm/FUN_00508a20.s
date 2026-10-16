# FUN_00508a20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508a20
# extent:       0x00508a20-0x00508bb5 (405 code bytes)
# span:         0x00508a20-0x00508bc0 (code 405, tables 0, padding 11)
# sha256:       2aecdba11d4dcc286bb9f45c5191e36d886d4b988d06652835ffccb32173b23e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00508720 (+0x300)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508a20
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_4, field_8, field_14; [ecx + n] field_14; [edi + n] field_minus_1; [esi + n] field_8, field_10, field_1c; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_28, stk_2c, stk_34, stk_38, stk_3c, stk_40
# callees:      calls FUN_004fee30, FUN_005030a0, FUN_005038e0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 139 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40

# --- external targets -----------------------------------------------
.set FUN_004fee30, .text + (0x004fee30 - 0x401000)
.set FUN_005030a0, .text + (0x005030a0 - 0x401000)
.set FUN_005038e0, .text + (0x005038e0 - 0x401000)

.org 0x00508a20 - 0x401000
.globl FUN_00508a20
FUN_00508a20:
    # block 0x00508a20: entry, 32 instruction(s), calls FUN_004fee30, ends with jle to 0x00508a80 (forward)
    sub esp, 0x14                                # 00508a20
    push ebx                                     # 00508a23
    push ebp                                     # 00508a24
    push esi                                     # 00508a25
    mov esi, dword ptr [esp + stk_28]            # 00508a26
    push edi                                     # 00508a2a
    mov eax, dword ptr [esi + field_10]          # 00508a2b
    mov ebx, dword ptr [esi]                     # 00508a2e
    mov ecx, dword ptr [eax]                     # 00508a30
    mov eax, dword ptr [ebx + field_4]           # 00508a32
    mov edi, dword ptr [ebx]                     # 00508a35
    mov ebp, dword ptr [ebx + field_8]           # 00508a37
    {load} sub eax, edi                          # 00508a3a
    mov dword ptr [esp + stk_1c], ecx            # 00508a3c
    cdq                                          # 00508a40
    idiv ebp                                     # 00508a41
    {load} mov edi, eax                          # 00508a43
    mov dword ptr [esp + stk_18], edi            # 00508a45
    lea eax, [edi + ecx - field_minus_1]         # 00508a49
    cdq                                          # 00508a4d
    idiv ecx                                     # 00508a4e
    mov ecx, dword ptr [esp + stk_28]            # 00508a50
    shl eax, 0x2                                 # 00508a54
    push eax                                     # 00508a57
    push ecx                                     # 00508a58
    call FUN_004fee30                            # 00508a59
    mov ecx, dword ptr [esp + stk_40]            # 00508a5e
    mov dword ptr [esp + stk_28], eax            # 00508a62
    add esp, 0x8                                 # 00508a66
    {load} xor eax, eax                          # 00508a69
    test ecx, ecx                                # 00508a6b
    jle.d8 L_00508a80                            # 00508a6d
    # block 0x00508a6f: entered by fall-through of jle at 0x00508a6d, 1 instruction(s), falls into the block at 0x00508a73
    mov edx, dword ptr [esp + stk_34]            # 00508a6f
L_00508a73:
    # block 0x00508a73: entered by jl at 0x00508a7e, 2 instruction(s), ends with jne to 0x00508a80 (forward)
    cmp dword ptr [edx], 0x0                     # 00508a73
    jne.d8 L_00508a80                            # 00508a76
    # block 0x00508a78: entered by fall-through of jne at 0x00508a76, 4 instruction(s), ends with jl to 0x00508a73 (backward)
    inc eax                                      # 00508a78
    add edx, 0x4                                 # 00508a79
    {load} cmp eax, ecx                          # 00508a7c
    jl.d8 L_00508a73                             # 00508a7e
L_00508a80:
    # block 0x00508a80: entered by jle at 0x00508a6d; jne at 0x00508a76; fall-through of jl at 0x00508a7e, 2 instruction(s), ends with je to 0x00508bab (forward)
    {load} cmp eax, ecx                          # 00508a80
    je.d32 L_00508bab                            # 00508a82
    # block 0x00508a88: entered by fall-through of je at 0x00508a82, 4 instruction(s), ends with jle to 0x00508bab (forward)
    mov eax, dword ptr [esi + field_8]           # 00508a88
    mov dword ptr [esp + stk_10], 0x0            # 00508a8b
    test eax, eax                                # 00508a93
    jle.d32 L_00508bab                           # 00508a95
L_00508a9b:
    # block 0x00508a9b: entered by jl at 0x00508ba5; fall-through of jle at 0x00508a95, 3 instruction(s), ends with jle to 0x00508b97 (forward)
    test edi, edi                                # 00508a9b
    mov dword ptr [esp + stk_34], 0x0            # 00508a9d
    jle.d32 L_00508b97                           # 00508aa5
    # block 0x00508aab: entered by fall-through of jle at 0x00508aa5, 2 instruction(s), falls into the block at 0x00508ab3
    mov edx, dword ptr [esp + stk_20]            # 00508aab
    mov dword ptr [esp + stk_14], edx            # 00508aaf
L_00508ab3:
    # block 0x00508ab3: entered by jl at 0x00508b8f, 3 instruction(s), ends with jne to 0x00508aec (forward)
    mov eax, dword ptr [esp + stk_10]            # 00508ab3
    test eax, eax                                # 00508ab7
    jne.d8 L_00508aec                            # 00508ab9
    # block 0x00508abb: entered by fall-through of jne at 0x00508ab9, 9 instruction(s), calls FUN_005030a0, ends with je to 0x00508bab (forward)
    mov eax, dword ptr [esp + stk_28]            # 00508abb
    mov ecx, dword ptr [esi + field_10]          # 00508abf
    add eax, 0x4                                 # 00508ac2
    push eax                                     # 00508ac5
    push ecx                                     # 00508ac6
    call FUN_005030a0                            # 00508ac7
    add esp, 0x8                                 # 00508acc
    cmp eax, -0x1                                # 00508acf
    je.d32 L_00508bab                            # 00508ad2
    # block 0x00508ad8: entered by fall-through of je at 0x00508ad2, 6 instruction(s), ends with je to 0x00508bab (forward)
    mov edx, dword ptr [esi + field_1c]          # 00508ad8
    mov ecx, dword ptr [esp + stk_14]            # 00508adb
    mov eax, dword ptr [edx + 4*eax]             # 00508adf
    test eax, eax                                # 00508ae2
    mov dword ptr [ecx], eax                     # 00508ae4
    je.d32 L_00508bab                            # 00508ae6
L_00508aec:
    # block 0x00508aec: entered by jne at 0x00508ab9; fall-through of je at 0x00508ae6, 4 instruction(s), ends with jle to 0x00508b7a (forward)
    mov eax, dword ptr [esp + stk_1c]            # 00508aec
    {load} xor edi, edi                          # 00508af0
    test eax, eax                                # 00508af2
    jle.d32 L_00508b7a                           # 00508af4
    # block 0x00508afa: entered by fall-through of jle at 0x00508af4, 2 instruction(s), falls into the block at 0x00508b01
    mov esi, dword ptr [esp + stk_34]            # 00508afa
    imul esi, ebp                                # 00508afe
L_00508b01:
    # block 0x00508b01: entered by jl at 0x00508b74, 4 instruction(s), ends with jge to 0x00508b76 (forward)
    mov edx, dword ptr [esp + stk_18]            # 00508b01
    mov eax, dword ptr [esp + stk_34]            # 00508b05
    {load} cmp eax, edx                          # 00508b09
    jge.d8 L_00508b76                            # 00508b0b
    # block 0x00508b0d: entered by fall-through of jge at 0x00508b0b, 8 instruction(s), ends with je to 0x00508b62 (forward)
    mov eax, dword ptr [esp + stk_14]            # 00508b0d
    mov edx, 0x1                                 # 00508b11
    mov ecx, dword ptr [eax]                     # 00508b16
    mov eax, dword ptr [ecx + 4*edi]             # 00508b18
    mov ecx, dword ptr [esp + stk_10]            # 00508b1b
    shl edx, cl                                  # 00508b1f
    test dword ptr [ebx + 4*eax + field_14], edx # 00508b21
    je.d8 L_00508b62                             # 00508b25
    # block 0x00508b27: entered by fall-through of je at 0x00508b25, 7 instruction(s), ends with je to 0x00508b62 (forward)
    mov ecx, dword ptr [esp + stk_2c]            # 00508b27
    mov edx, dword ptr [ecx + field_14]          # 00508b2b
    mov ecx, dword ptr [esp + stk_10]            # 00508b2e
    mov eax, dword ptr [edx + 4*eax]             # 00508b32
    mov eax, dword ptr [eax + 4*ecx]             # 00508b35
    test eax, eax                                # 00508b38
    je.d8 L_00508b62                             # 00508b3a
    # block 0x00508b3c: entered by fall-through of je at 0x00508b3a, 16 instruction(s), calls FUN_005038e0, ends with je to 0x00508bab (forward)
    mov edx, dword ptr [esp + stk_28]            # 00508b3c
    mov ecx, dword ptr [esp + stk_38]            # 00508b40
    add edx, 0x4                                 # 00508b44
    push ebp                                     # 00508b47
    push edx                                     # 00508b48
    mov edx, dword ptr [ebx]                     # 00508b49
    push ecx                                     # 00508b4b
    mov ecx, dword ptr [esp + stk_3c]            # 00508b4c
    {load} add edx, esi                          # 00508b50
    push edx                                     # 00508b52
    push ecx                                     # 00508b53
    push eax                                     # 00508b54
    call FUN_005038e0                            # 00508b55
    add esp, 0x18                                # 00508b5a
    cmp eax, -0x1                                # 00508b5d
    je.d8 L_00508bab                             # 00508b60
L_00508b62:
    # block 0x00508b62: entered by je at 0x00508b25; je at 0x00508b3a; fall-through of je at 0x00508b60, 8 instruction(s), ends with jl to 0x00508b01 (backward)
    mov edx, dword ptr [esp + stk_34]            # 00508b62
    mov eax, dword ptr [esp + stk_1c]            # 00508b66
    inc edi                                      # 00508b6a
    inc edx                                      # 00508b6b
    {load} add esi, ebp                          # 00508b6c
    {load} cmp edi, eax                          # 00508b6e
    mov dword ptr [esp + stk_34], edx            # 00508b70
    jl.d8 L_00508b01                             # 00508b74
L_00508b76:
    # block 0x00508b76: entered by jge at 0x00508b0b; fall-through of jl at 0x00508b74, 1 instruction(s), falls into the block at 0x00508b7a
    mov esi, dword ptr [esp + stk_2c]            # 00508b76
L_00508b7a:
    # block 0x00508b7a: entered by jle at 0x00508af4, 7 instruction(s), ends with jl to 0x00508ab3 (backward)
    mov ecx, dword ptr [esp + stk_14]            # 00508b7a
    mov edx, dword ptr [esp + stk_18]            # 00508b7e
    mov eax, dword ptr [esp + stk_34]            # 00508b82
    add ecx, 0x4                                 # 00508b86
    {load} cmp eax, edx                          # 00508b89
    mov dword ptr [esp + stk_14], ecx            # 00508b8b
    jl.d32 L_00508ab3                            # 00508b8f
    # block 0x00508b95: entered by fall-through of jl at 0x00508b8f, 1 instruction(s), falls into the block at 0x00508b97
    {load} mov edi, edx                          # 00508b95
L_00508b97:
    # block 0x00508b97: entered by jle at 0x00508aa5, 6 instruction(s), ends with jl to 0x00508a9b (backward)
    mov eax, dword ptr [esp + stk_10]            # 00508b97
    mov ecx, dword ptr [esi + field_8]           # 00508b9b
    inc eax                                      # 00508b9e
    {load} cmp eax, ecx                          # 00508b9f
    mov dword ptr [esp + stk_10], eax            # 00508ba1
    jl.d32 L_00508a9b                            # 00508ba5
L_00508bab:
    # block 0x00508bab: entered by je at 0x00508a82; jle at 0x00508a95; je at 0x00508ad2; je at 0x00508ae6; more, 7 instruction(s), ends with ret
    pop edi                                      # 00508bab
    pop esi                                      # 00508bac
    pop ebp                                      # 00508bad
    {load} xor eax, eax                          # 00508bae
    pop ebx                                      # 00508bb0
    add esp, 0x14                                # 00508bb1
    ret                                          # 00508bb4

# --- data items (not part of the function) -------------------------
.org 0x00508bb5 - 0x401000
PAD_00508bb5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

