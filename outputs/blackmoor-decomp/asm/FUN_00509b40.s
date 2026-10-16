# FUN_00509b40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00509b40
# extent:       0x00509b40-0x00509d6c (556 code bytes)
# span:         0x00509b40-0x00509d70 (code 556, tables 0, padding 4)
# sha256:       0b4d6d8cd89f7e54fa00b1cb61db74e20cf82f0aec774cfd03ee984c6b532ceb
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00509b40
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_448, field_44c, field_450, field_458; [edx + n] field_448, field_44c, field_458; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38, stk_3c and 2 more
# callees:      calls FUN_00509910
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 197 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ field_448, 0x448  # offset +0x448
.equ field_44c, 0x44c  # offset +0x44c
.equ field_450, 0x450  # offset +0x450
.equ field_458, 0x458  # offset +0x458

# --- external targets -----------------------------------------------
.set FUN_00509910, .text + (0x00509910 - 0x401000)

.org 0x00509b40 - 0x401000
.globl FUN_00509b40
FUN_00509b40:
    # block 0x00509b40: entry, 23 instruction(s), ends with jge to 0x00509b78 (forward)
    sub esp, 0x18                                # 00509b40
    mov ecx, dword ptr [esp + stk_28]            # 00509b43
    push ebx                                     # 00509b47
    push ebp                                     # 00509b48
    push esi                                     # 00509b49
    mov esi, dword ptr [esp + stk_30]            # 00509b4a
    mov ebp, dword ptr [esp + stk_28]            # 00509b4e
    {load} sub ecx, esi                          # 00509b52
    push edi                                     # 00509b54
    {load} mov eax, ecx                          # 00509b55
    mov edi, dword ptr [esp + stk_30]            # 00509b57
    cdq                                          # 00509b5b
    {load} mov ebx, eax                          # 00509b5c
    {load} mov eax, ecx                          # 00509b5e
    {load} xor ebx, edx                          # 00509b60
    {load} sub edi, ebp                          # 00509b62
    {load} sub ebx, edx                          # 00509b64
    mov dword ptr [esp + stk_18], edi            # 00509b66
    cdq                                          # 00509b6a
    idiv edi                                     # 00509b6b
    test ecx, ecx                                # 00509b6d
    mov dword ptr [esp + stk_20], eax            # 00509b6f
    jge.d8 L_00509b78                            # 00509b73
    # block 0x00509b75: entered by fall-through of jge at 0x00509b73, 2 instruction(s), ends with forward jump to 0x00509b79
    dec eax                                      # 00509b75
    jmp.d8 L_00509b79                            # 00509b76
L_00509b78:
    # block 0x00509b78: entered by jge at 0x00509b73, 1 instruction(s), falls into the block at 0x00509b79
    inc eax                                      # 00509b78
L_00509b79:
    # block 0x00509b79: entered by jmp at 0x00509b76, 29 instruction(s), calls FUN_00509910, ends with jne to 0x00509c26 (forward)
    mov dword ptr [esp + stk_1c], eax            # 00509b79
    mov eax, dword ptr [esp + stk_3c]            # 00509b7d
    mov dword ptr [esp + stk_38], esi            # 00509b81
    mov dword ptr [esp + stk_10], 0x0            # 00509b85
    lea edi, [eax + 4*ebp]                       # 00509b8d
    push edi                                     # 00509b90
    call FUN_00509910                            # 00509b91
    {load} mov ecx, eax                          # 00509b96
    mov eax, dword ptr [esp + stk_24]            # 00509b98
    imul eax, dword ptr [esp + stk_1c]           # 00509b9c
    cdq                                          # 00509ba1
    {load} xor eax, edx                          # 00509ba2
    mov dword ptr [esp + stk_18], ecx            # 00509ba4
    {load} sub eax, edx                          # 00509ba8
    mov edx, dword ptr [esp + stk_44]            # 00509baa
    {load} sub esi, ecx                          # 00509bae
    mov ecx, dword ptr [esp + stk_48]            # 00509bb0
    fld dword ptr [edx + 4*ebp]                  # 00509bb4
    fadd dword ptr [ecx + field_458]             # 00509bb7
    {load} sub ebx, eax                          # 00509bbd
    add esp, 0x4                                 # 00509bbf
    mov dword ptr [esp + stk_24], ebx            # 00509bc2
    {load} mov ebx, esi                          # 00509bc6
    fcomp dword ptr [edi]                        # 00509bc8
    imul ebx, esi                                # 00509bca
    fnstsw ax                                    # 00509bcd
    test ah, 0x1                                 # 00509bcf
    mov dword ptr [esp + stk_2c], 0x1            # 00509bd2
    jne.d8 L_00509c26                            # 00509bda
    # block 0x00509bdc: entered by fall-through of jne at 0x00509bda, 8 instruction(s), ends with je to 0x00509c06 (forward)
    fild dword ptr [esp + stk_34]                # 00509bdc
    fild dword ptr [esp + stk_14]                # 00509be0
    fld st(1)                                    # 00509be4
    fadd dword ptr [ecx + field_448]             # 00509be6
    fcomp st(1)                                  # 00509bec
    fnstsw ax                                    # 00509bee
    test ah, 0x1                                 # 00509bf0
    je.d8 L_00509c06                             # 00509bf3
L_00509bf5:
    # block 0x00509bf5: entered by jne at 0x00509cca; fall-through of je at 0x00509bf3, 9 instruction(s), ends with ret
    pop edi                                      # 00509bf5
    pop esi                                      # 00509bf6
    fstp st(0)                                   # 00509bf7
    pop ebp                                      # 00509bf9
    mov eax, 0x1                                 # 00509bfa
    fstp st(0)                                   # 00509bff
    pop ebx                                      # 00509c01
    add esp, 0x18                                # 00509c02
    ret                                          # 00509c05
L_00509c06:
    # block 0x00509c06: entered by je at 0x00509bf3, 7 instruction(s), ends with jne to 0x00509c26 (forward)
    fxch st(1)                                   # 00509c06
    fsub dword ptr [ecx + field_44c]             # 00509c08
    fcomp st(1)                                  # 00509c0e
    fnstsw ax                                    # 00509c10
    test ah, 0x41                                # 00509c12
    fstp st(0)                                   # 00509c15
    jne.d8 L_00509c26                            # 00509c17
    # block 0x00509c19: entered by fall-through of jne at 0x00509c17, 7 instruction(s), ends with ret
    pop edi                                      # 00509c19
    pop esi                                      # 00509c1a
    pop ebp                                      # 00509c1b
    mov eax, 0x1                                 # 00509c1c
    pop ebx                                      # 00509c21
    add esp, 0x18                                # 00509c22
    ret                                          # 00509c25
L_00509c26:
    # block 0x00509c26: entered by jne at 0x00509bda; jne at 0x00509c17, 4 instruction(s), ends with jge to 0x00509cf7 (forward)
    mov eax, dword ptr [esp + stk_30]            # 00509c26
    inc ebp                                      # 00509c2a
    {load} cmp ebp, eax                          # 00509c2b
    jge.d32 L_00509cf7                           # 00509c2d
    # block 0x00509c33: entered by fall-through of jge at 0x00509c2d, 4 instruction(s), falls into the block at 0x00509c3e
    mov eax, dword ptr [esp + stk_3c]            # 00509c33
    {load} mov edi, edx                          # 00509c37
    {load} sub edi, eax                          # 00509c39
    lea esi, [eax + 4*ebp]                       # 00509c3b
L_00509c3e:
    # block 0x00509c3e: entered by jl at 0x00509ced, 7 instruction(s), ends with jl to 0x00509c66 (forward)
    mov eax, dword ptr [esp + stk_10]            # 00509c3e
    mov ecx, dword ptr [esp + stk_24]            # 00509c42
    {load} add eax, ecx                          # 00509c46
    mov ecx, dword ptr [esp + stk_18]            # 00509c48
    {load} cmp eax, ecx                          # 00509c4c
    mov dword ptr [esp + stk_10], eax            # 00509c4e
    jl.d8 L_00509c66                             # 00509c52
    # block 0x00509c54: entered by fall-through of jl at 0x00509c52, 6 instruction(s), ends with forward jump to 0x00509c70
    {load} sub eax, ecx                          # 00509c54
    mov ecx, dword ptr [esp + stk_1c]            # 00509c56
    mov dword ptr [esp + stk_10], eax            # 00509c5a
    mov eax, dword ptr [esp + stk_38]            # 00509c5e
    {load} add eax, ecx                          # 00509c62
    jmp.d8 L_00509c70                            # 00509c64
L_00509c66:
    # block 0x00509c66: entered by jl at 0x00509c52, 3 instruction(s), falls into the block at 0x00509c70
    mov edx, dword ptr [esp + stk_20]            # 00509c66
    mov eax, dword ptr [esp + stk_38]            # 00509c6a
    {load} add eax, edx                          # 00509c6e
L_00509c70:
    # block 0x00509c70: entered by jmp at 0x00509c64, 21 instruction(s), calls FUN_00509910, ends with jne to 0x00509ce3 (forward)
    push esi                                     # 00509c70
    mov dword ptr [esp + stk_3c], eax            # 00509c71
    call FUN_00509910                            # 00509c75
    {load} mov ecx, eax                          # 00509c7a
    mov eax, dword ptr [esp + stk_3c]            # 00509c7c
    {load} sub eax, ecx                          # 00509c80
    add esp, 0x4                                 # 00509c82
    {load} mov edx, eax                          # 00509c85
    mov dword ptr [esp + stk_14], ecx            # 00509c87
    imul edx, eax                                # 00509c8b
    fld dword ptr [edi + esi]                    # 00509c8e
    {load} add ebx, edx                          # 00509c91
    mov edx, dword ptr [esp + stk_44]            # 00509c93
    mov eax, dword ptr [esp + stk_2c]            # 00509c97
    fadd dword ptr [edx + field_458]             # 00509c9b
    inc eax                                      # 00509ca1
    mov dword ptr [esp + stk_2c], eax            # 00509ca2
    fcomp dword ptr [esi]                        # 00509ca6
    fnstsw ax                                    # 00509ca8
    test ah, 0x1                                 # 00509caa
    jne.d8 L_00509ce3                            # 00509cad
    # block 0x00509caf: entered by fall-through of jne at 0x00509cad, 2 instruction(s), ends with je to 0x00509ce3 (forward)
    test ecx, ecx                                # 00509caf
    je.d8 L_00509ce3                             # 00509cb1
    # block 0x00509cb3: entered by fall-through of je at 0x00509cb1, 8 instruction(s), ends with jne to 0x00509bf5 (backward)
    fild dword ptr [esp + stk_38]                # 00509cb3
    fild dword ptr [esp + stk_14]                # 00509cb7
    fld st(1)                                    # 00509cbb
    fadd dword ptr [edx + field_448]             # 00509cbd
    fcomp st(1)                                  # 00509cc3
    fnstsw ax                                    # 00509cc5
    test ah, 0x1                                 # 00509cc7
    jne.d32 L_00509bf5                           # 00509cca
    # block 0x00509cd0: entered by fall-through of jne at 0x00509cca, 7 instruction(s), ends with je to 0x00509d55 (forward)
    fxch st(1)                                   # 00509cd0
    fsub dword ptr [edx + field_44c]             # 00509cd2
    fcomp st(1)                                  # 00509cd8
    fnstsw ax                                    # 00509cda
    test ah, 0x41                                # 00509cdc
    fstp st(0)                                   # 00509cdf
    je.d8 L_00509d55                             # 00509ce1
L_00509ce3:
    # block 0x00509ce3: entered by jne at 0x00509cad; je at 0x00509cb1; fall-through of je at 0x00509ce1, 5 instruction(s), ends with jl to 0x00509c3e (backward)
    mov eax, dword ptr [esp + stk_30]            # 00509ce3
    inc ebp                                      # 00509ce7
    add esi, 0x4                                 # 00509ce8
    {load} cmp ebp, eax                          # 00509ceb
    jl.d32 L_00509c3e                            # 00509ced
    # block 0x00509cf3: entered by fall-through of jl at 0x00509ced, 1 instruction(s), falls into the block at 0x00509cf7
    mov ecx, dword ptr [esp + stk_44]            # 00509cf3
L_00509cf7:
    # block 0x00509cf7: entered by jge at 0x00509c2d, 11 instruction(s), ends with je to 0x00509d62 (forward)
    fld dword ptr [ecx + field_448]              # 00509cf7
    fild dword ptr [esp + stk_2c]                # 00509cfd
    fstp dword ptr [esp + stk_30]                # 00509d01
    fld st(0)                                    # 00509d05
    fmul st, st(1)                               # 00509d07
    fdiv dword ptr [esp + stk_30]                # 00509d09
    fcomp dword ptr [ecx + field_450]            # 00509d0d
    fnstsw ax                                    # 00509d13
    test ah, 0x41                                # 00509d15
    fstp st(0)                                   # 00509d18
    je.d8 L_00509d62                             # 00509d1a
    # block 0x00509d1c: entered by fall-through of je at 0x00509d1a, 9 instruction(s), ends with je to 0x00509d62 (forward)
    fld dword ptr [ecx + field_44c]              # 00509d1c
    fld st(0)                                    # 00509d22
    fmul st, st(1)                               # 00509d24
    fdiv dword ptr [esp + stk_30]                # 00509d26
    fcomp dword ptr [ecx + field_450]            # 00509d2a
    fnstsw ax                                    # 00509d30
    test ah, 0x41                                # 00509d32
    fstp st(0)                                   # 00509d35
    je.d8 L_00509d62                             # 00509d37
    # block 0x00509d39: entered by fall-through of je at 0x00509d37, 9 instruction(s), ends with jne to 0x00509d62 (forward)
    {load} mov eax, ebx                          # 00509d39
    cdq                                          # 00509d3b
    idiv dword ptr [esp + stk_2c]                # 00509d3c
    mov dword ptr [esp + stk_30], eax            # 00509d40
    fild dword ptr [esp + stk_30]                # 00509d44
    fcomp dword ptr [ecx + field_450]            # 00509d48
    fnstsw ax                                    # 00509d4e
    test ah, 0x41                                # 00509d50
    jne.d8 L_00509d62                            # 00509d53
L_00509d55:
    # block 0x00509d55: entered by je at 0x00509ce1; fall-through of jne at 0x00509d53, 7 instruction(s), ends with ret
    pop edi                                      # 00509d55
    pop esi                                      # 00509d56
    pop ebp                                      # 00509d57
    mov eax, 0x1                                 # 00509d58
    pop ebx                                      # 00509d5d
    add esp, 0x18                                # 00509d5e
    ret                                          # 00509d61
L_00509d62:
    # block 0x00509d62: entered by je at 0x00509d1a; je at 0x00509d37; jne at 0x00509d53, 7 instruction(s), ends with ret
    pop edi                                      # 00509d62
    pop esi                                      # 00509d63
    pop ebp                                      # 00509d64
    {load} xor eax, eax                          # 00509d65
    pop ebx                                      # 00509d67
    add esp, 0x18                                # 00509d68
    ret                                          # 00509d6b

# --- data items (not part of the function) -------------------------
.org 0x00509d6c - 0x401000
PAD_00509d6c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

