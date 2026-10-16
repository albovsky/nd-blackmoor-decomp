# FUN_005129a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005129a0
# extent:       0x005129a0-0x00512bc4 (548 code bytes)
# span:         0x005129a0-0x00512bc4 (code 548, tables 0, padding 0)
# sha256:       84fbe87c547808c4253f85d699fce79330ae06feec8bff92d60f531667581e6a
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005129a0
# arguments:    9 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_d, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       8 ebp-relative slot(s): local_4, local_10, local_18, local_1c, local_20, local_24, local_28, local_38
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!LCMapStringW, KERNEL32.dll!LCMapStringA, FUN_00512bc4, KERNEL32.dll!MultiByteToWideChar, FUN_0050c920, KERNEL32.dll!WideCharToMultiByte
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 193 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         unreachable_code_entry:0x00512ab0
# note:         unreachable_code_entry:0x00512b64
# note:         unreachable_code_entry:0x00512ab4
# note:         unreachable_code_entry:0x00512b68
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_38, 0x38  # offset -0x38
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_d, 0xd  # offset +0xd
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_00512bc4, .text + (0x00512bc4 - 0x401000)

.org 0x005129a0 - 0x401000
.globl FUN_005129a0
FUN_005129a0:
    # block 0x005129a0: entry, 16 instruction(s), ends with jne to 0x00512a16 (forward)
    push ebp                                     # 005129a0
    {load} mov ebp, esp                          # 005129a1
    push -0x1                                    # 005129a3
    push 0x5304f8                                # 005129a5
    push 0x511930                                # 005129aa
    mov eax, dword ptr fs:[0x0]                  # 005129af
    push eax                                     # 005129b5
    mov dword ptr fs:[0x0], esp                  # 005129b6
    sub esp, 0x1c                                # 005129bd
    push ebx                                     # 005129c0
    push esi                                     # 005129c1
    push edi                                     # 005129c2
    mov dword ptr [ebp - local_18], esp          # 005129c3
    {load} xor edi, edi                          # 005129c6
    cmp dword ptr [0x63caa0], edi                # 005129c8
    jne.d8 L_00512a16                            # 005129ce
    # block 0x005129d0: entered by fall-through of jne at 0x005129ce, 12 instruction(s), calls KERNEL32.dll!LCMapStringW, ends with je to 0x005129f4 (forward)
    push edi                                     # 005129d0
    push edi                                     # 005129d1
    push 0x1                                     # 005129d2
    pop ebx                                      # 005129d4
    push ebx                                     # 005129d5
    push 0x5304f4                                # 005129d6
    mov esi, 0x100                               # 005129db
    push esi                                     # 005129e0
    push edi                                     # 005129e1
    call dword ptr [0x52a170]                    # 005129e2
    test eax, eax                                # 005129e8
    je.d8 L_005129f4                             # 005129ea
    # block 0x005129ec: entered by fall-through of je at 0x005129ea, 2 instruction(s), ends with forward jump to 0x00512a16
    mov dword ptr [0x63caa0], ebx                # 005129ec
    jmp.d8 L_00512a16                            # 005129f2
L_005129f4:
    # block 0x005129f4: entered by je at 0x005129ea, 9 instruction(s), calls KERNEL32.dll!LCMapStringA, ends with je to 0x00512b2e (forward)
    push edi                                     # 005129f4
    push edi                                     # 005129f5
    push ebx                                     # 005129f6
    push 0x5304f0                                # 005129f7
    push esi                                     # 005129fc
    push edi                                     # 005129fd
    call dword ptr [0x52a16c]                    # 005129fe
    test eax, eax                                # 00512a04
    je.d32 L_00512b2e                            # 00512a06
    # block 0x00512a0c: entered by fall-through of je at 0x00512a06, 1 instruction(s), falls into the block at 0x00512a16
    mov dword ptr [0x63caa0], 0x2                # 00512a0c
L_00512a16:
    # block 0x00512a16: entered by jne at 0x005129ce; jmp at 0x005129f2, 2 instruction(s), ends with jle to 0x00512a2b (forward)
    cmp dword ptr [ebp + arg_14], edi            # 00512a16
    jle.d8 L_00512a2b                            # 00512a19
    # block 0x00512a1b: entered by fall-through of jle at 0x00512a19, 6 instruction(s), calls FUN_00512bc4, falls into the block at 0x00512a2b
    push dword ptr [ebp + arg_14]                # 00512a1b
    push dword ptr [ebp + arg_10]                # 00512a1e
    call FUN_00512bc4                            # 00512a21
    pop ecx                                      # 00512a26
    pop ecx                                      # 00512a27
    mov dword ptr [ebp + arg_14], eax            # 00512a28
L_00512a2b:
    # block 0x00512a2b: entered by jle at 0x00512a19, 3 instruction(s), ends with jne to 0x00512a52 (forward)
    mov eax, dword ptr [0x63caa0]                # 00512a2b
    cmp eax, 0x2                                 # 00512a30
    jne.d8 L_00512a52                            # 00512a33
    # block 0x00512a35: entered by fall-through of jne at 0x00512a33, 8 instruction(s), calls KERNEL32.dll!LCMapStringA, ends with forward jump to 0x00512b30
    push dword ptr [ebp + arg_1c]                # 00512a35
    push dword ptr [ebp + arg_18]                # 00512a38
    push dword ptr [ebp + arg_14]                # 00512a3b
    push dword ptr [ebp + arg_10]                # 00512a3e
    push dword ptr [ebp + arg_c]                 # 00512a41
    push dword ptr [ebp + arg_8]                 # 00512a44
    call dword ptr [0x52a16c]                    # 00512a47
    jmp.d32 L_00512b30                           # 00512a4d
L_00512a52:
    # block 0x00512a52: entered by jne at 0x00512a33, 2 instruction(s), ends with jne to 0x00512b2e (forward)
    cmp eax, 0x1                                 # 00512a52
    jne.d32 L_00512b2e                           # 00512a55
    # block 0x00512a5b: entered by fall-through of jne at 0x00512a55, 2 instruction(s), ends with jne to 0x00512a68 (forward)
    cmp dword ptr [ebp + arg_20], edi            # 00512a5b
    jne.d8 L_00512a68                            # 00512a5e
    # block 0x00512a60: entered by fall-through of jne at 0x00512a5e, 2 instruction(s), falls into the block at 0x00512a68
    mov eax, dword ptr [0x63cb2c]                # 00512a60
    mov dword ptr [ebp + arg_20], eax            # 00512a65
L_00512a68:
    # block 0x00512a68: entered by jne at 0x00512a5e, 16 instruction(s), calls KERNEL32.dll!MultiByteToWideChar, ends with je to 0x00512b2e (forward)
    push edi                                     # 00512a68
    push edi                                     # 00512a69
    push dword ptr [ebp + arg_14]                # 00512a6a
    push dword ptr [ebp + arg_10]                # 00512a6d
    mov eax, dword ptr [ebp + arg_24]            # 00512a70
    neg eax                                      # 00512a73
    {load} sbb eax, eax                          # 00512a75
    and eax, 0x8                                 # 00512a77
    inc eax                                      # 00512a7a
    push eax                                     # 00512a7b
    push dword ptr [ebp + arg_20]                # 00512a7c
    call dword ptr [0x52a1f0]                    # 00512a7f
    {load} mov ebx, eax                          # 00512a85
    mov dword ptr [ebp - local_1c], ebx          # 00512a87
    {load} cmp ebx, edi                          # 00512a8a
    je.d32 L_00512b2e                            # 00512a8c
    # block 0x00512a92: entered by fall-through of je at 0x00512a8c, 10 instruction(s), calls FUN_0050c920, ends with forward jump to 0x00512ac3
    mov dword ptr [ebp - local_4], edi           # 00512a92
    lea eax, [ebx + ebx]                         # 00512a95
    add eax, 0x3                                 # 00512a98
    and al, -0x4                                 # 00512a9b
    call FUN_0050c920                            # 00512a9d
    mov dword ptr [ebp - local_18], esp          # 00512aa2
    {load} mov eax, esp                          # 00512aa5
    mov dword ptr [ebp - local_24], eax          # 00512aa7
    or dword ptr [ebp - local_4], -0x1           # 00512aaa
    jmp.d8 L_00512ac3                            # 00512aae
    # block 0x00512ab0: entered by follows jmp at 0x00512aae, 3 instruction(s), ends with ret
    push 0x1                                     # 00512ab0
    pop eax                                      # 00512ab2
    ret                                          # 00512ab3
    # block 0x00512ab4: entered by follows ret at 0x00512ab3, 5 instruction(s), falls into the block at 0x00512ac3
    mov esp, dword ptr [ebp - local_18]          # 00512ab4
    {load} xor edi, edi                          # 00512ab7
    mov dword ptr [ebp - local_24], edi          # 00512ab9
    or dword ptr [ebp - local_4], -0x1           # 00512abc
    mov ebx, dword ptr [ebp - local_1c]          # 00512ac0
L_00512ac3:
    # block 0x00512ac3: entered by jmp at 0x00512aae, 2 instruction(s), ends with je to 0x00512b2e (forward)
    cmp dword ptr [ebp - local_24], edi          # 00512ac3
    je.d8 L_00512b2e                             # 00512ac6
    # block 0x00512ac8: entered by fall-through of je at 0x00512ac6, 9 instruction(s), calls KERNEL32.dll!MultiByteToWideChar, ends with je to 0x00512b2e (forward)
    push ebx                                     # 00512ac8
    push dword ptr [ebp - local_24]              # 00512ac9
    push dword ptr [ebp + arg_14]                # 00512acc
    push dword ptr [ebp + arg_10]                # 00512acf
    push 0x1                                     # 00512ad2
    push dword ptr [ebp + arg_20]                # 00512ad4
    call dword ptr [0x52a1f0]                    # 00512ad7
    test eax, eax                                # 00512add
    je.d8 L_00512b2e                             # 00512adf
    # block 0x00512ae1: entered by fall-through of je at 0x00512adf, 11 instruction(s), calls KERNEL32.dll!LCMapStringW, ends with je to 0x00512b2e (forward)
    push edi                                     # 00512ae1
    push edi                                     # 00512ae2
    push ebx                                     # 00512ae3
    push dword ptr [ebp - local_24]              # 00512ae4
    push dword ptr [ebp + arg_c]                 # 00512ae7
    push dword ptr [ebp + arg_8]                 # 00512aea
    call dword ptr [0x52a170]                    # 00512aed
    {load} mov esi, eax                          # 00512af3
    mov dword ptr [ebp - local_28], esi          # 00512af5
    {load} cmp esi, edi                          # 00512af8
    je.d8 L_00512b2e                             # 00512afa
    # block 0x00512afc: entered by fall-through of je at 0x00512afa, 2 instruction(s), ends with je to 0x00512b42 (forward)
    test byte ptr [ebp + arg_d], 0x4             # 00512afc
    je.d8 L_00512b42                             # 00512b00
    # block 0x00512b02: entered by fall-through of je at 0x00512b00, 2 instruction(s), ends with je to 0x00512bbd (forward)
    cmp dword ptr [ebp + arg_1c], edi            # 00512b02
    je.d32 L_00512bbd                            # 00512b05
    # block 0x00512b0b: entered by fall-through of je at 0x00512b05, 2 instruction(s), ends with jg to 0x00512b2e (forward)
    cmp esi, dword ptr [ebp + arg_1c]            # 00512b0b
    jg.d8 L_00512b2e                             # 00512b0e
    # block 0x00512b10: entered by fall-through of jg at 0x00512b0e, 9 instruction(s), calls KERNEL32.dll!LCMapStringW, ends with jne to 0x00512bbd (forward)
    push dword ptr [ebp + arg_1c]                # 00512b10
    push dword ptr [ebp + arg_18]                # 00512b13
    push ebx                                     # 00512b16
    push dword ptr [ebp - local_24]              # 00512b17
    push dword ptr [ebp + arg_c]                 # 00512b1a
    push dword ptr [ebp + arg_8]                 # 00512b1d
    call dword ptr [0x52a170]                    # 00512b20
    test eax, eax                                # 00512b26
    jne.d32 L_00512bbd                           # 00512b28
L_00512b2e:
    # block 0x00512b2e: entered by je at 0x00512a06; jne at 0x00512a55; je at 0x00512a8c; je at 0x00512ac6; more, 1 instruction(s), falls into the block at 0x00512b30
    {load} xor eax, eax                          # 00512b2e
L_00512b30:
    # block 0x00512b30: entered by jmp at 0x00512a4d; jmp at 0x00512bbf, 8 instruction(s), ends with ret
    lea esp, [ebp - local_38]                    # 00512b30
    mov ecx, dword ptr [ebp - local_10]          # 00512b33
    mov dword ptr fs:[0x0], ecx                  # 00512b36
    pop edi                                      # 00512b3d
    pop esi                                      # 00512b3e
    pop ebx                                      # 00512b3f
    leave                                        # 00512b40
    ret                                          # 00512b41
L_00512b42:
    # block 0x00512b42: entered by je at 0x00512b00, 10 instruction(s), calls FUN_0050c920, ends with forward jump to 0x00512b76
    mov dword ptr [ebp - local_4], 0x1           # 00512b42
    lea eax, [esi + esi]                         # 00512b49
    add eax, 0x3                                 # 00512b4c
    and al, -0x4                                 # 00512b4f
    call FUN_0050c920                            # 00512b51
    mov dword ptr [ebp - local_18], esp          # 00512b56
    {load} mov ebx, esp                          # 00512b59
    mov dword ptr [ebp - local_20], ebx          # 00512b5b
    or dword ptr [ebp - local_4], -0x1           # 00512b5e
    jmp.d8 L_00512b76                            # 00512b62
    # block 0x00512b64: entered by follows jmp at 0x00512b62, 3 instruction(s), ends with ret
    push 0x1                                     # 00512b64
    pop eax                                      # 00512b66
    ret                                          # 00512b67
    # block 0x00512b68: entered by follows ret at 0x00512b67, 5 instruction(s), falls into the block at 0x00512b76
    mov esp, dword ptr [ebp - local_18]          # 00512b68
    {load} xor edi, edi                          # 00512b6b
    {load} xor ebx, ebx                          # 00512b6d
    or dword ptr [ebp - local_4], -0x1           # 00512b6f
    mov esi, dword ptr [ebp - local_28]          # 00512b73
L_00512b76:
    # block 0x00512b76: entered by jmp at 0x00512b62, 2 instruction(s), ends with je to 0x00512b2e (backward)
    {load} cmp ebx, edi                          # 00512b76
    je.d8 L_00512b2e                             # 00512b78
    # block 0x00512b7a: entered by fall-through of je at 0x00512b78, 9 instruction(s), calls KERNEL32.dll!LCMapStringW, ends with je to 0x00512b2e (backward)
    push esi                                     # 00512b7a
    push ebx                                     # 00512b7b
    push dword ptr [ebp - local_1c]              # 00512b7c
    push dword ptr [ebp - local_24]              # 00512b7f
    push dword ptr [ebp + arg_c]                 # 00512b82
    push dword ptr [ebp + arg_8]                 # 00512b85
    call dword ptr [0x52a170]                    # 00512b88
    test eax, eax                                # 00512b8e
    je.d8 L_00512b2e                             # 00512b90
    # block 0x00512b92: entered by fall-through of je at 0x00512b90, 4 instruction(s), ends with jne to 0x00512b9d (forward)
    cmp dword ptr [ebp + arg_1c], edi            # 00512b92
    push edi                                     # 00512b95
    push edi                                     # 00512b96
    jne.d8 L_00512b9d                            # 00512b97
    # block 0x00512b99: entered by fall-through of jne at 0x00512b97, 3 instruction(s), ends with forward jump to 0x00512ba3
    push edi                                     # 00512b99
    push edi                                     # 00512b9a
    jmp.d8 L_00512ba3                            # 00512b9b
L_00512b9d:
    # block 0x00512b9d: entered by jne at 0x00512b97, 2 instruction(s), falls into the block at 0x00512ba3
    push dword ptr [ebp + arg_1c]                # 00512b9d
    push dword ptr [ebp + arg_18]                # 00512ba0
L_00512ba3:
    # block 0x00512ba3: entered by jmp at 0x00512b9b, 8 instruction(s), calls KERNEL32.dll!WideCharToMultiByte, ends with je to 0x00512b2e (backward)
    push esi                                     # 00512ba3
    push ebx                                     # 00512ba4
    push 0x220                                   # 00512ba5
    push dword ptr [ebp + arg_20]                # 00512baa
    call dword ptr [0x52a1f4]                    # 00512bad
    {load} mov esi, eax                          # 00512bb3
    {load} cmp esi, edi                          # 00512bb5
    je.d32 L_00512b2e                            # 00512bb7
L_00512bbd:
    # block 0x00512bbd: entered by je at 0x00512b05; jne at 0x00512b28; fall-through of je at 0x00512bb7, 2 instruction(s), ends with backward jump to 0x00512b30
    {load} mov eax, esi                          # 00512bbd
    jmp.d32 L_00512b30                           # 00512bbf

