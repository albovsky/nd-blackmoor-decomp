# FUN_005079f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005079f0
# extent:       0x005079f0-0x00507bc4 (468 code bytes)
# span:         0x005079f0-0x00507bd0 (code 468, tables 0, padding 12)
# sha256:       55941ced1ad283228b674f1392baab58538ee5470d59bf666d0cd12bcb3260a9
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00507890 (+0x160)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005079f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_c, field_10; [ebp + n] field_b20; [ecx + n] field_1c; [edx + n] field_114, field_minus_4; [esi + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_34
# callees:      calls FUN_0050e97e, FUN_0050a440, FUN_0050f440, FUN_0050e19e, FUN_0050ce04, FUN_0050ea90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 159 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00507bd0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_34, 0x34  # offset +0x34
.equ field_114, 0x114  # offset +0x114
.equ field_b20, 0xb20  # offset +0xb20

# --- external targets -----------------------------------------------
.set FUN_0050a440, .text + (0x0050a440 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_0050f440, .text + (0x0050f440 - 0x401000)

.org 0x005079f0 - 0x401000
.globl FUN_005079f0
FUN_005079f0:
    # block 0x005079f0: entry, 38 instruction(s), calls FUN_0050e97e, ends with jle to 0x00507b0f (forward)
    sub esp, 0x10                                # 005079f0
    push ebx                                     # 005079f3
    push ebp                                     # 005079f4
    push esi                                     # 005079f5
    push edi                                     # 005079f6
    push 0x2c                                    # 005079f7
    push 0x1                                     # 005079f9
    call FUN_0050e97e                            # 005079fb
    {load} mov esi, eax                          # 00507a00
    mov eax, dword ptr [esp + stk_2c]            # 00507a02
    {load} xor edi, edi                          # 00507a06
    push 0x4                                     # 00507a08
    mov ecx, dword ptr [eax + field_4]           # 00507a0a
    mov eax, dword ptr [esp + stk_34]            # 00507a0d
    mov dword ptr [esp + stk_20], edi            # 00507a11
    mov dword ptr [esp + stk_24], edi            # 00507a15
    mov ebp, dword ptr [ecx + field_1c]          # 00507a19
    mov dword ptr [esi], eax                     # 00507a1c
    mov edx, dword ptr [eax + field_c]           # 00507a1e
    mov dword ptr [esi + field_4], edx           # 00507a21
    mov ecx, dword ptr [ebp + field_b20]         # 00507a24
    mov dword ptr [esi + field_c], ecx           # 00507a2a
    mov eax, dword ptr [eax + field_10]          # 00507a2d
    mov ecx, dword ptr [ebp + field_b20]         # 00507a30
    lea edx, [eax + 4*eax]                       # 00507a36
    lea eax, [eax + 2*edx]                       # 00507a39
    mov edx, dword ptr [esi + field_4]           # 00507a3c
    push edx                                     # 00507a3f
    lea eax, [ecx + 4*eax]                       # 00507a40
    mov dword ptr [esi + field_10], eax          # 00507a43
    mov ebx, dword ptr [eax]                     # 00507a46
    mov dword ptr [esp + stk_20], ebx            # 00507a48
    call FUN_0050e97e                            # 00507a4c
    mov dword ptr [esi + field_14], eax          # 00507a51
    mov eax, dword ptr [esi + field_4]           # 00507a54
    add esp, 0x10                                # 00507a57
    test eax, eax                                # 00507a5a
    jle.d32 L_00507b0f                           # 00507a5c
    # block 0x00507a62: entered by fall-through of jle at 0x00507a5c, 3 instruction(s), falls into the block at 0x00507a6d
    mov eax, dword ptr [esp + stk_28]            # 00507a62
    add eax, 0x14                                # 00507a66
    mov dword ptr [esp + stk_24], eax            # 00507a69
L_00507a6d:
    # block 0x00507a6d: entered by jl at 0x00507b05, 9 instruction(s), calls FUN_0050a440, ends with je to 0x00507af4 (forward)
    mov ecx, dword ptr [esp + stk_24]            # 00507a6d
    mov edx, dword ptr [ecx]                     # 00507a71
    push edx                                     # 00507a73
    call FUN_0050a440                            # 00507a74
    {load} mov ebx, eax                          # 00507a79
    add esp, 0x4                                 # 00507a7b
    test ebx, ebx                                # 00507a7e
    mov dword ptr [esp + stk_1c], ebx            # 00507a80
    je.d8 L_00507af4                             # 00507a84
    # block 0x00507a86: entered by fall-through of je at 0x00507a84, 2 instruction(s), ends with jle to 0x00507a90 (forward)
    cmp ebx, dword ptr [esp + stk_18]            # 00507a86
    jle.d8 L_00507a90                            # 00507a8a
    # block 0x00507a8c: entered by fall-through of jle at 0x00507a8a, 1 instruction(s), falls into the block at 0x00507a90
    mov dword ptr [esp + stk_18], ebx            # 00507a8c
L_00507a90:
    # block 0x00507a90: entered by jle at 0x00507a8a, 9 instruction(s), calls FUN_0050e97e, ends with jle to 0x00507af4 (forward)
    push 0x4                                     # 00507a90
    push ebx                                     # 00507a92
    call FUN_0050e97e                            # 00507a93
    mov ecx, dword ptr [esi + field_14]          # 00507a98
    add esp, 0x8                                 # 00507a9b
    mov dword ptr [ecx + 4*edi], eax             # 00507a9e
    {load} xor ecx, ecx                          # 00507aa1
    test ebx, ebx                                # 00507aa3
    jle.d8 L_00507af4                            # 00507aa5
    # block 0x00507aa7: entered by fall-through of jle at 0x00507aa5, 3 instruction(s), falls into the block at 0x00507ab6
    mov edx, dword ptr [esp + stk_28]            # 00507aa7
    mov eax, dword ptr [esp + stk_14]            # 00507aab
    lea edx, [edx + 4*eax + field_114]           # 00507aaf
L_00507ab6:
    # block 0x00507ab6: entered by jl at 0x00507af2, 5 instruction(s), ends with je to 0x00507aeb (forward)
    mov ebx, dword ptr [esp + stk_24]            # 00507ab6
    mov eax, 0x1                                 # 00507aba
    shl eax, cl                                  # 00507abf
    test dword ptr [ebx], eax                    # 00507ac1
    je.d8 L_00507aeb                             # 00507ac3
    # block 0x00507ac5: entered by fall-through of je at 0x00507ac3, 12 instruction(s), falls into the block at 0x00507aeb
    mov eax, dword ptr [edx]                     # 00507ac5
    lea ebx, [eax + 4*eax]                       # 00507ac7
    lea eax, [eax + 2*ebx]                       # 00507aca
    mov ebx, dword ptr [ebp + field_b20]         # 00507acd
    lea eax, [ebx + 4*eax]                       # 00507ad3
    mov ebx, dword ptr [esi + field_14]          # 00507ad6
    mov ebx, dword ptr [ebx + 4*edi]             # 00507ad9
    mov dword ptr [ebx + 4*ecx], eax             # 00507adc
    mov ebx, dword ptr [esp + stk_14]            # 00507adf
    inc ebx                                      # 00507ae3
    add edx, 0x4                                 # 00507ae4
    mov dword ptr [esp + stk_14], ebx            # 00507ae7
L_00507aeb:
    # block 0x00507aeb: entered by je at 0x00507ac3, 4 instruction(s), ends with jl to 0x00507ab6 (backward)
    mov eax, dword ptr [esp + stk_1c]            # 00507aeb
    inc ecx                                      # 00507aef
    {load} cmp ecx, eax                          # 00507af0
    jl.d8 L_00507ab6                             # 00507af2
L_00507af4:
    # block 0x00507af4: entered by je at 0x00507a84; jle at 0x00507aa5; fall-through of jl at 0x00507af2, 7 instruction(s), ends with jl to 0x00507a6d (backward)
    mov ecx, dword ptr [esp + stk_24]            # 00507af4
    mov eax, dword ptr [esi + field_4]           # 00507af8
    inc edi                                      # 00507afb
    add ecx, 0x4                                 # 00507afc
    {load} cmp edi, eax                          # 00507aff
    mov dword ptr [esp + stk_24], ecx            # 00507b01
    jl.d32 L_00507a6d                            # 00507b05
    # block 0x00507b0b: entered by fall-through of jl at 0x00507b05, 1 instruction(s), falls into the block at 0x00507b0f
    mov ebx, dword ptr [esp + stk_10]            # 00507b0b
L_00507b0f:
    # block 0x00507b0f: entered by jle at 0x00507a5c, 20 instruction(s), calls FUN_0050f440, FUN_0050e19e, FUN_0050ce04, FUN_0050ea90, ends with jle to 0x00507bba (forward)
    fild dword ptr [esi + field_4]               # 00507b0f
    fild dword ptr [esp + stk_10]                # 00507b12
    call FUN_0050f440                            # 00507b16
    fadd qword ptr [0x52cac0]                    # 00507b1b
    sub esp, 0x8                                 # 00507b21
    fstp qword ptr [esp]                         # 00507b24
    call FUN_0050e19e                            # 00507b27
    call FUN_0050ce04                            # 00507b2c
    mov ecx, dword ptr [esp + stk_20]            # 00507b31
    lea edx, [4*eax]                             # 00507b35
    push edx                                     # 00507b3c
    mov dword ptr [esi + field_18], eax          # 00507b3d
    mov dword ptr [esi + field_8], ecx           # 00507b40
    call FUN_0050ea90                            # 00507b43
    mov dword ptr [esi + field_1c], eax          # 00507b48
    mov eax, dword ptr [esi + field_18]          # 00507b4b
    add esp, 0xc                                 # 00507b4e
    {load} xor ebp, ebp                          # 00507b51
    test eax, eax                                # 00507b53
    jle.d8 L_00507bba                            # 00507b55
L_00507b57:
    # block 0x00507b57: entered by jl at 0x00507bb8; fall-through of jle at 0x00507b55, 13 instruction(s), calls FUN_0050ea90, ends with jle to 0x00507bb2 (forward)
    cdq                                          # 00507b57
    idiv dword ptr [esi + field_4]               # 00507b58
    mov dword ptr [esp + stk_28], ebp            # 00507b5b
    {load} mov edi, eax                          # 00507b5f
    lea eax, [4*ebx]                             # 00507b61
    push eax                                     # 00507b68
    call FUN_0050ea90                            # 00507b69
    mov ecx, dword ptr [esi + field_1c]          # 00507b6e
    add esp, 0x4                                 # 00507b71
    mov dword ptr [ecx + 4*ebp], eax             # 00507b74
    {load} xor ecx, ecx                          # 00507b77
    test ebx, ebx                                # 00507b79
    jle.d8 L_00507bb2                            # 00507b7b
L_00507b7d:
    # block 0x00507b7d: entered by jl at 0x00507bae; fall-through of jle at 0x00507b7b, 20 instruction(s), ends with jl to 0x00507b7d (backward)
    mov eax, dword ptr [esp + stk_28]            # 00507b7d
    cdq                                          # 00507b81
    idiv edi                                     # 00507b82
    {load} mov ebx, eax                          # 00507b84
    mov eax, dword ptr [esp + stk_28]            # 00507b86
    {load} mov edx, ebx                          # 00507b8a
    imul edx, edi                                # 00507b8c
    {load} sub eax, edx                          # 00507b8f
    mov dword ptr [esp + stk_28], eax            # 00507b91
    {load} mov eax, edi                          # 00507b95
    cdq                                          # 00507b97
    idiv dword ptr [esi + field_4]               # 00507b98
    inc ecx                                      # 00507b9b
    {load} mov edi, eax                          # 00507b9c
    mov eax, dword ptr [esi + field_1c]          # 00507b9e
    mov edx, dword ptr [eax + 4*ebp]             # 00507ba1
    mov eax, dword ptr [esp + stk_10]            # 00507ba4
    {load} cmp ecx, eax                          # 00507ba8
    mov dword ptr [edx + 4*ecx - field_minus_4], ebx # 00507baa
    jl.d8 L_00507b7d                             # 00507bae
    # block 0x00507bb0: entered by fall-through of jl at 0x00507bae, 1 instruction(s), falls into the block at 0x00507bb2
    {load} mov ebx, eax                          # 00507bb0
L_00507bb2:
    # block 0x00507bb2: entered by jle at 0x00507b7b, 4 instruction(s), ends with jl to 0x00507b57 (backward)
    mov eax, dword ptr [esi + field_18]          # 00507bb2
    inc ebp                                      # 00507bb5
    {load} cmp ebp, eax                          # 00507bb6
    jl.d8 L_00507b57                             # 00507bb8
L_00507bba:
    # block 0x00507bba: entered by jle at 0x00507b55; fall-through of jl at 0x00507bb8, 7 instruction(s), ends with ret
    {load} mov eax, esi                          # 00507bba
    pop edi                                      # 00507bbc
    pop esi                                      # 00507bbd
    pop ebp                                      # 00507bbe
    pop ebx                                      # 00507bbf
    add esp, 0x10                                # 00507bc0
    ret                                          # 00507bc3

# --- data items (not part of the function) -------------------------
.org 0x00507bc4 - 0x401000
PAD_00507bc4:  # 12 byte(s) of nop padding
    .fill 12, 1, 0x90

