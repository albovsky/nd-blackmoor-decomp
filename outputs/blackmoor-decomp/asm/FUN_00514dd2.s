# FUN_00514dd2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514dd2
# extent:       0x00514dd2-0x00514f25 (339 code bytes)
# span:         0x00514dd2-0x00514f25 (code 339, tables 0, padding 0)
# sha256:       f6c0a913f62d987f52458b0fb4e19522822dd967e4533fbb60155992ca72685b
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514dd2
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_a0, local_1a4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetModuleFileNameA, FUN_005128b0, FUN_00511f30, FUN_0050d960, FUN_005128c0, FUN_00518910, KERNEL32.dll!GetStdHandle, KERNEL32.dll!WriteFile
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 100 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_a0, 0xa0  # offset -0xa0
.equ local_1a4, 0x1a4  # offset -0x1a4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050d960, .text + (0x0050d960 - 0x401000)
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)
.set FUN_005128c0, .text + (0x005128c0 - 0x401000)
.set FUN_00518910, .text + (0x00518910 - 0x401000)

.org 0x00514dd2 - 0x401000
.globl FUN_00514dd2
FUN_00514dd2:
    # block 0x00514dd2: entry, 6 instruction(s), falls into the block at 0x00514de5
    push ebp                                     # 00514dd2
    {load} mov ebp, esp                          # 00514dd3
    sub esp, 0x1a4                               # 00514dd5
    mov edx, dword ptr [ebp + arg_8]             # 00514ddb
    {load} xor ecx, ecx                          # 00514dde
    mov eax, 0x568ae8                            # 00514de0
L_00514de5:
    # block 0x00514de5: entered by jl at 0x00514df2, 2 instruction(s), ends with je to 0x00514df4 (forward)
    cmp edx, dword ptr [eax]                     # 00514de5
    je.d8 L_00514df4                             # 00514de7
    # block 0x00514de9: entered by fall-through of je at 0x00514de7, 4 instruction(s), ends with jl to 0x00514de5 (backward)
    add eax, 0x8                                 # 00514de9
    inc ecx                                      # 00514dec
    cmp eax, 0x568b78                            # 00514ded
    jl.d8 L_00514de5                             # 00514df2
L_00514df4:
    # block 0x00514df4: entered by je at 0x00514de7; fall-through of jl at 0x00514df2, 5 instruction(s), ends with jne to 0x00514f22 (forward)
    push esi                                     # 00514df4
    {load} mov esi, ecx                          # 00514df5
    shl esi, 0x3                                 # 00514df7
    cmp edx, dword ptr [esi + 0x568ae8]          # 00514dfa
    jne.d32 L_00514f22                           # 00514e00
    # block 0x00514e06: entered by fall-through of jne at 0x00514e00, 3 instruction(s), ends with je to 0x00514efc (forward)
    mov eax, dword ptr [0x63ca70]                # 00514e06
    cmp eax, 0x1                                 # 00514e0b
    je.d32 L_00514efc                            # 00514e0e
    # block 0x00514e14: entered by fall-through of je at 0x00514e0e, 2 instruction(s), ends with jne to 0x00514e25 (forward)
    test eax, eax                                # 00514e14
    jne.d8 L_00514e25                            # 00514e16
    # block 0x00514e18: entered by fall-through of jne at 0x00514e16, 2 instruction(s), ends with je to 0x00514efc (forward)
    cmp dword ptr [0x567e80], 0x1                # 00514e18
    je.d32 L_00514efc                            # 00514e1f
L_00514e25:
    # block 0x00514e25: entered by jne at 0x00514e16; fall-through of je at 0x00514e1f, 2 instruction(s), ends with je to 0x00514f22 (forward)
    cmp edx, 0xfc                                # 00514e25
    je.d32 L_00514f22                            # 00514e2b
    # block 0x00514e31: entered by fall-through of je at 0x00514e2b, 7 instruction(s), calls KERNEL32.dll!GetModuleFileNameA, ends with jne to 0x00514e5c (forward)
    lea eax, [ebp - local_1a4]                   # 00514e31
    push 0x104                                   # 00514e37
    push eax                                     # 00514e3c
    push 0x0                                     # 00514e3d
    call dword ptr [0x52a28c]                    # 00514e3f
    test eax, eax                                # 00514e45
    jne.d8 L_00514e5c                            # 00514e47
    # block 0x00514e49: entered by fall-through of jne at 0x00514e47, 6 instruction(s), calls FUN_005128b0, falls into the block at 0x00514e5c
    lea eax, [ebp - local_1a4]                   # 00514e49
    push 0x530910                                # 00514e4f
    push eax                                     # 00514e54
    call FUN_005128b0                            # 00514e55
    pop ecx                                      # 00514e5a
    pop ecx                                      # 00514e5b
L_00514e5c:
    # block 0x00514e5c: entered by jne at 0x00514e47, 9 instruction(s), calls FUN_00511f30, ends with jbe to 0x00514e9f (forward)
    lea eax, [ebp - local_1a4]                   # 00514e5c
    push edi                                     # 00514e62
    push eax                                     # 00514e63
    lea edi, [ebp - local_1a4]                   # 00514e64
    call FUN_00511f30                            # 00514e6a
    inc eax                                      # 00514e6f
    pop ecx                                      # 00514e70
    cmp eax, 0x3c                                # 00514e71
    jbe.d8 L_00514e9f                            # 00514e74
    # block 0x00514e76: entered by fall-through of jbe at 0x00514e74, 12 instruction(s), calls FUN_00511f30, FUN_0050d960, falls into the block at 0x00514e9f
    lea eax, [ebp - local_1a4]                   # 00514e76
    push eax                                     # 00514e7c
    call FUN_00511f30                            # 00514e7d
    {load} mov edi, eax                          # 00514e82
    lea eax, [ebp - local_1a4]                   # 00514e84
    sub eax, 0x3b                                # 00514e8a
    push 0x3                                     # 00514e8d
    {load} add edi, eax                          # 00514e8f
    push 0x53090c                                # 00514e91
    push edi                                     # 00514e96
    call FUN_0050d960                            # 00514e97
    add esp, 0x10                                # 00514e9c
L_00514e9f:
    # block 0x00514e9f: entered by jbe at 0x00514e74, 24 instruction(s), calls FUN_005128b0, FUN_005128c0, FUN_00518910, ends with forward jump to 0x00514f22
    lea eax, [ebp - local_a0]                    # 00514e9f
    push 0x5308f0                                # 00514ea5
    push eax                                     # 00514eaa
    call FUN_005128b0                            # 00514eab
    lea eax, [ebp - local_a0]                    # 00514eb0
    push edi                                     # 00514eb6
    push eax                                     # 00514eb7
    call FUN_005128c0                            # 00514eb8
    lea eax, [ebp - local_a0]                    # 00514ebd
    push 0x5308ec                                # 00514ec3
    push eax                                     # 00514ec8
    call FUN_005128c0                            # 00514ec9
    push dword ptr [esi + 0x568aec]              # 00514ece
    lea eax, [ebp - local_a0]                    # 00514ed4
    push eax                                     # 00514eda
    call FUN_005128c0                            # 00514edb
    push 0x12010                                 # 00514ee0
    lea eax, [ebp - local_a0]                    # 00514ee5
    push 0x5308c4                                # 00514eeb
    push eax                                     # 00514ef0
    call FUN_00518910                            # 00514ef1
    add esp, 0x2c                                # 00514ef6
    pop edi                                      # 00514ef9
    jmp.d8 L_00514f22                            # 00514efa
L_00514efc:
    # block 0x00514efc: entered by je at 0x00514e0e; je at 0x00514e1f, 13 instruction(s), calls FUN_00511f30, KERNEL32.dll!GetStdHandle, KERNEL32.dll!WriteFile, falls into the block at 0x00514f22
    lea eax, [ebp + arg_8]                       # 00514efc
    lea esi, [esi + 0x568aec]                    # 00514eff
    push 0x0                                     # 00514f05
    push eax                                     # 00514f07
    push dword ptr [esi]                         # 00514f08
    call FUN_00511f30                            # 00514f0a
    pop ecx                                      # 00514f0f
    push eax                                     # 00514f10
    push dword ptr [esi]                         # 00514f11
    push -0xc                                    # 00514f13
    call dword ptr [0x52a178]                    # 00514f15
    push eax                                     # 00514f1b
    call dword ptr [0x52a100]                    # 00514f1c
L_00514f22:
    # block 0x00514f22: entered by jne at 0x00514e00; je at 0x00514e2b; jmp at 0x00514efa, 3 instruction(s), ends with ret
    pop esi                                      # 00514f22
    leave                                        # 00514f23
    ret                                          # 00514f24

