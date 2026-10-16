# FUN_004e9cdf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e9cdf
# extent:       0x004e9cdf-0x004e9d8f (176 code bytes)
# span:         0x004e9cdf-0x004e9d8f (code 176, tables 0, padding 0)
# sha256:       1ec2c3c15de7e79487e13bfd314cd78f118ae43bd043f778e89f9036c35ebb29
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e9cdf
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_4; [edx + n] field_4
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 54 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004e9cdf - 0x401000
.globl FUN_004e9cdf
FUN_004e9cdf:
    # block 0x004e9cdf: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x004e9d41 (forward)
    push ebp                                     # 004e9cdf
    {load} mov ebp, esp                          # 004e9ce0
    sub esp, 0x8                                 # 004e9ce2
    mov dword ptr [ebp - local_8], ecx           # 004e9ce5
    push 0x6                                     # 004e9ce8
    call FUN_0051dc43                            # 004e9cea
    add esp, 0x4                                 # 004e9cef
    mov dword ptr [ebp - local_4], eax           # 004e9cf2
    mov eax, dword ptr [ebp + arg_8]             # 004e9cf5
    mov ecx, dword ptr [ebp - local_4]           # 004e9cf8
    mov dword ptr [eax], ecx                     # 004e9cfb
    cmp dword ptr [ebp - local_4], 0x0           # 004e9cfd
    jne.d8 L_004e9d41                            # 004e9d01
    # block 0x004e9d03: entered by fall-through of jne at 0x004e9d01, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004e9d41
    movsx edx, word ptr [0x5c39e3]               # 004e9d03
    push edx                                     # 004e9d0a
    mov eax, dword ptr [0x5bb57b]                # 004e9d0b
    push eax                                     # 004e9d10
    push 0x55c9b4                                # 004e9d11
    push 0x63888b                                # 004e9d16
    call FUN_0050ca3e                            # 004e9d1b
    add esp, 0x10                                # 004e9d20
    push 0x63888b                                # 004e9d23
    push 0x55c9e0                                # 004e9d28
    mov ecx, 0x583979                            # 004e9d2d
    call FUN_0042639d                            # 004e9d32
    mov ecx, 0x5cf659                            # 004e9d37
    call FUN_004c97b4                            # 004e9d3c
L_004e9d41:
    # block 0x004e9d41: entered by jne at 0x004e9d01, 21 instruction(s), ends with je to 0x004e9d89 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004e9d41
    mov edx, dword ptr [ecx]                     # 004e9d44
    mov eax, dword ptr [ebp + arg_8]             # 004e9d46
    mov ecx, dword ptr [eax]                     # 004e9d49
    mov eax, dword ptr [edx]                     # 004e9d4b
    mov dword ptr [ecx], eax                     # 004e9d4d
    mov dx, word ptr [edx + field_4]             # 004e9d4f
    mov word ptr [ecx + field_4], dx             # 004e9d53
    mov eax, dword ptr [ebp + arg_10]            # 004e9d57
    mov ecx, dword ptr [eax]                     # 004e9d5a
    add ecx, 0x6                                 # 004e9d5c
    mov edx, dword ptr [ebp + arg_10]            # 004e9d5f
    mov dword ptr [edx], ecx                     # 004e9d62
    mov eax, dword ptr [ebp + arg_c]             # 004e9d64
    mov ecx, dword ptr [eax]                     # 004e9d67
    add ecx, 0x6                                 # 004e9d69
    mov edx, dword ptr [ebp + arg_c]             # 004e9d6c
    mov dword ptr [edx], ecx                     # 004e9d6f
    movsx eax, word ptr [0x63a4cd]               # 004e9d71
    test eax, eax                                # 004e9d78
    je.d8 L_004e9d89                             # 004e9d7a
    # block 0x004e9d7c: entered by fall-through of je at 0x004e9d7a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e9d89
    push 0x55c9fc                                # 004e9d7c
    call FUN_0044a2b7                            # 004e9d81
    add esp, 0x4                                 # 004e9d86
L_004e9d89:
    # block 0x004e9d89: entered by je at 0x004e9d7a, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004e9d89
    pop ebp                                      # 004e9d8b
    ret 0xc                                      # 004e9d8c

