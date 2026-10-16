# FUN_00515e1e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515e1e
# extent:       0x00515e1e-0x00515f67 (329 code bytes)
# span:         0x00515e1e-0x00515f67 (code 329, tables 0, padding 0)
# sha256:       ca0d6566efecc97b0fa435e0829f91a24054f5d64f24b488007ee3c5e80885c8
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515e1e
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       7 ebp-relative slot(s): local_4, local_10, local_18, local_1c, local_20, local_24, local_34
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetStringTypeW, KERNEL32.dll!GetStringTypeA, KERNEL32.dll!MultiByteToWideChar, FUN_0050c920, FUN_0050f920
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 123 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         unreachable_code_entry:0x00515f17
# note:         unreachable_code_entry:0x00515f1b
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
.equ local_34, 0x34  # offset -0x34
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)

.org 0x00515e1e - 0x401000
.globl FUN_00515e1e
FUN_00515e1e:
    # block 0x00515e1e: entry, 17 instruction(s), ends with jne to 0x00515e8d (forward)
    push ebp                                     # 00515e1e
    {load} mov ebp, esp                          # 00515e1f
    push -0x1                                    # 00515e21
    push 0x530928                                # 00515e23
    push 0x511930                                # 00515e28
    mov eax, dword ptr fs:[0x0]                  # 00515e2d
    push eax                                     # 00515e33
    mov dword ptr fs:[0x0], esp                  # 00515e34
    sub esp, 0x18                                # 00515e3b
    push ebx                                     # 00515e3e
    push esi                                     # 00515e3f
    push edi                                     # 00515e40
    mov dword ptr [ebp - local_18], esp          # 00515e41
    mov eax, dword ptr [0x63cc54]                # 00515e44
    {load} xor ebx, ebx                          # 00515e49
    {load} cmp eax, ebx                          # 00515e4b
    jne.d8 L_00515e8d                            # 00515e4d
    # block 0x00515e4f: entered by fall-through of jne at 0x00515e4d, 10 instruction(s), calls KERNEL32.dll!GetStringTypeW, ends with je to 0x00515e6b (forward)
    lea eax, [ebp - local_1c]                    # 00515e4f
    push eax                                     # 00515e52
    push 0x1                                     # 00515e53
    pop esi                                      # 00515e55
    push esi                                     # 00515e56
    push 0x5304f4                                # 00515e57
    push esi                                     # 00515e5c
    call dword ptr [0x52a1b0]                    # 00515e5d
    test eax, eax                                # 00515e63
    je.d8 L_00515e6b                             # 00515e65
    # block 0x00515e67: entered by fall-through of je at 0x00515e65, 2 instruction(s), ends with forward jump to 0x00515e88
    {load} mov eax, esi                          # 00515e67
    jmp.d8 L_00515e88                            # 00515e69
L_00515e6b:
    # block 0x00515e6b: entered by je at 0x00515e65, 9 instruction(s), calls KERNEL32.dll!GetStringTypeA, ends with je to 0x00515f53 (forward)
    lea eax, [ebp - local_1c]                    # 00515e6b
    push eax                                     # 00515e6e
    push esi                                     # 00515e6f
    push 0x5304f0                                # 00515e70
    push esi                                     # 00515e75
    push ebx                                     # 00515e76
    call dword ptr [0x52a1ac]                    # 00515e77
    test eax, eax                                # 00515e7d
    je.d32 L_00515f53                            # 00515e7f
    # block 0x00515e85: entered by fall-through of je at 0x00515e7f, 2 instruction(s), falls into the block at 0x00515e88
    push 0x2                                     # 00515e85
    pop eax                                      # 00515e87
L_00515e88:
    # block 0x00515e88: entered by jmp at 0x00515e69, 1 instruction(s), falls into the block at 0x00515e8d
    mov dword ptr [0x63cc54], eax                # 00515e88
L_00515e8d:
    # block 0x00515e8d: entered by jne at 0x00515e4d, 2 instruction(s), ends with jne to 0x00515eb6 (forward)
    cmp eax, 0x2                                 # 00515e8d
    jne.d8 L_00515eb6                            # 00515e90
    # block 0x00515e92: entered by fall-through of jne at 0x00515e90, 3 instruction(s), ends with jne to 0x00515e9e (forward)
    mov eax, dword ptr [ebp + arg_1c]            # 00515e92
    {load} cmp eax, ebx                          # 00515e95
    jne.d8 L_00515e9e                            # 00515e97
    # block 0x00515e99: entered by fall-through of jne at 0x00515e97, 1 instruction(s), falls into the block at 0x00515e9e
    mov eax, dword ptr [0x63cb1c]                # 00515e99
L_00515e9e:
    # block 0x00515e9e: entered by jne at 0x00515e97, 7 instruction(s), calls KERNEL32.dll!GetStringTypeA, ends with forward jump to 0x00515f55
    push dword ptr [ebp + arg_14]                # 00515e9e
    push dword ptr [ebp + arg_10]                # 00515ea1
    push dword ptr [ebp + arg_c]                 # 00515ea4
    push dword ptr [ebp + arg_8]                 # 00515ea7
    push eax                                     # 00515eaa
    call dword ptr [0x52a1ac]                    # 00515eab
    jmp.d32 L_00515f55                           # 00515eb1
L_00515eb6:
    # block 0x00515eb6: entered by jne at 0x00515e90, 2 instruction(s), ends with jne to 0x00515f53 (forward)
    cmp eax, 0x1                                 # 00515eb6
    jne.d32 L_00515f53                           # 00515eb9
    # block 0x00515ebf: entered by fall-through of jne at 0x00515eb9, 2 instruction(s), ends with jne to 0x00515ecc (forward)
    cmp dword ptr [ebp + arg_18], ebx            # 00515ebf
    jne.d8 L_00515ecc                            # 00515ec2
    # block 0x00515ec4: entered by fall-through of jne at 0x00515ec2, 2 instruction(s), falls into the block at 0x00515ecc
    mov eax, dword ptr [0x63cb2c]                # 00515ec4
    mov dword ptr [ebp + arg_18], eax            # 00515ec9
L_00515ecc:
    # block 0x00515ecc: entered by jne at 0x00515ec2, 15 instruction(s), calls KERNEL32.dll!MultiByteToWideChar, ends with je to 0x00515f53 (forward)
    push ebx                                     # 00515ecc
    push ebx                                     # 00515ecd
    push dword ptr [ebp + arg_10]                # 00515ece
    push dword ptr [ebp + arg_c]                 # 00515ed1
    mov eax, dword ptr [ebp + arg_20]            # 00515ed4
    neg eax                                      # 00515ed7
    {load} sbb eax, eax                          # 00515ed9
    and eax, 0x8                                 # 00515edb
    inc eax                                      # 00515ede
    push eax                                     # 00515edf
    push dword ptr [ebp + arg_18]                # 00515ee0
    call dword ptr [0x52a1f0]                    # 00515ee3
    mov dword ptr [ebp - local_20], eax          # 00515ee9
    {load} cmp eax, ebx                          # 00515eec
    je.d8 L_00515f53                             # 00515eee
    # block 0x00515ef0: entered by fall-through of je at 0x00515eee, 15 instruction(s), calls FUN_0050c920, FUN_0050f920, ends with forward jump to 0x00515f22
    mov dword ptr [ebp - local_4], ebx           # 00515ef0
    lea edi, [eax + eax]                         # 00515ef3
    {load} mov eax, edi                          # 00515ef6
    add eax, 0x3                                 # 00515ef8
    and al, -0x4                                 # 00515efb
    call FUN_0050c920                            # 00515efd
    mov dword ptr [ebp - local_18], esp          # 00515f02
    {load} mov esi, esp                          # 00515f05
    mov dword ptr [ebp - local_24], esi          # 00515f07
    push edi                                     # 00515f0a
    push ebx                                     # 00515f0b
    push esi                                     # 00515f0c
    call FUN_0050f920                            # 00515f0d
    add esp, 0xc                                 # 00515f12
    jmp.d8 L_00515f22                            # 00515f15
    # block 0x00515f17: entered by follows jmp at 0x00515f15, 3 instruction(s), ends with ret
    push 0x1                                     # 00515f17
    pop eax                                      # 00515f19
    ret                                          # 00515f1a
    # block 0x00515f1b: entered by follows ret at 0x00515f1a, 3 instruction(s), falls into the block at 0x00515f22
    mov esp, dword ptr [ebp - local_18]          # 00515f1b
    {load} xor ebx, ebx                          # 00515f1e
    {load} xor esi, esi                          # 00515f20
L_00515f22:
    # block 0x00515f22: entered by jmp at 0x00515f15, 3 instruction(s), ends with je to 0x00515f53 (forward)
    or dword ptr [ebp - local_4], -0x1           # 00515f22
    {load} cmp esi, ebx                          # 00515f26
    je.d8 L_00515f53                             # 00515f28
    # block 0x00515f2a: entered by fall-through of je at 0x00515f28, 9 instruction(s), calls KERNEL32.dll!MultiByteToWideChar, ends with je to 0x00515f53 (forward)
    push dword ptr [ebp - local_20]              # 00515f2a
    push esi                                     # 00515f2d
    push dword ptr [ebp + arg_10]                # 00515f2e
    push dword ptr [ebp + arg_c]                 # 00515f31
    push 0x1                                     # 00515f34
    push dword ptr [ebp + arg_18]                # 00515f36
    call dword ptr [0x52a1f0]                    # 00515f39
    {load} cmp eax, ebx                          # 00515f3f
    je.d8 L_00515f53                             # 00515f41
    # block 0x00515f43: entered by fall-through of je at 0x00515f41, 6 instruction(s), calls KERNEL32.dll!GetStringTypeW, ends with forward jump to 0x00515f55
    push dword ptr [ebp + arg_14]                # 00515f43
    push eax                                     # 00515f46
    push esi                                     # 00515f47
    push dword ptr [ebp + arg_8]                 # 00515f48
    call dword ptr [0x52a1b0]                    # 00515f4b
    jmp.d8 L_00515f55                            # 00515f51
L_00515f53:
    # block 0x00515f53: entered by je at 0x00515e7f; jne at 0x00515eb9; je at 0x00515eee; je at 0x00515f28; je at 0x00515f41, 1 instruction(s), falls into the block at 0x00515f55
    {load} xor eax, eax                          # 00515f53
L_00515f55:
    # block 0x00515f55: entered by jmp at 0x00515eb1; jmp at 0x00515f51, 8 instruction(s), ends with ret
    lea esp, [ebp - local_34]                    # 00515f55
    mov ecx, dword ptr [ebp - local_10]          # 00515f58
    mov dword ptr fs:[0x0], ecx                  # 00515f5b
    pop edi                                      # 00515f62
    pop esi                                      # 00515f63
    pop ebx                                      # 00515f64
    leave                                        # 00515f65
    ret                                          # 00515f66

