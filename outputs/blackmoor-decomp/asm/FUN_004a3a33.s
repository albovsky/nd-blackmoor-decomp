# FUN_004a3a33
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a3a33
# extent:       0x004a3a33-0x004a3aec (185 code bytes)
# span:         0x004a3a33-0x004a3aec (code 185, tables 0, padding 0)
# sha256:       70a831dfb2773a02d26029c51b8810cdedecbea1a79af8dd73d739e10b5e0790
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a3a33
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004a3a33 - 0x401000
.globl FUN_004a3a33
FUN_004a3a33:
    # block 0x004a3a33: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004a3a9a (forward)
    push ebp                                     # 004a3a33
    {load} mov ebp, esp                          # 004a3a34
    sub esp, 0x8                                 # 004a3a36
    push esi                                     # 004a3a39
    push edi                                     # 004a3a3a
    mov dword ptr [ebp - local_8], ecx           # 004a3a3b
    push 0x6c1                                   # 004a3a3e
    call FUN_0051dc43                            # 004a3a43
    add esp, 0x4                                 # 004a3a48
    mov dword ptr [ebp - local_4], eax           # 004a3a4b
    mov eax, dword ptr [ebp + arg_8]             # 004a3a4e
    mov ecx, dword ptr [ebp - local_4]           # 004a3a51
    mov dword ptr [eax], ecx                     # 004a3a54
    cmp dword ptr [ebp - local_4], 0x0           # 004a3a56
    jne.d8 L_004a3a9a                            # 004a3a5a
    # block 0x004a3a5c: entered by fall-through of jne at 0x004a3a5a, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004a3a9a
    movsx edx, word ptr [0x5c39e3]               # 004a3a5c
    push edx                                     # 004a3a63
    mov eax, dword ptr [0x5bb57b]                # 004a3a64
    push eax                                     # 004a3a69
    push 0x5504f0                                # 004a3a6a
    push 0x63888b                                # 004a3a6f
    call FUN_0050ca3e                            # 004a3a74
    add esp, 0x10                                # 004a3a79
    push 0x63888b                                # 004a3a7c
    push 0x55051c                                # 004a3a81
    mov ecx, 0x583979                            # 004a3a86
    call FUN_0042639d                            # 004a3a8b
    mov ecx, 0x5cf659                            # 004a3a90
    call FUN_004c97b4                            # 004a3a95
L_004a3a9a:
    # block 0x004a3a9a: entered by jne at 0x004a3a5a, 20 instruction(s), ends with je to 0x004a3ae4 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004a3a9a
    mov esi, dword ptr [ecx]                     # 004a3a9d
    mov edx, dword ptr [ebp + arg_8]             # 004a3a9f
    mov edi, dword ptr [edx]                     # 004a3aa2
    mov ecx, 0x1b0                               # 004a3aa4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a3aa9
    movsb byte ptr es:[edi], byte ptr [esi]      # 004a3aab
    mov eax, dword ptr [ebp + arg_10]            # 004a3aac
    mov ecx, dword ptr [eax]                     # 004a3aaf
    add ecx, 0x6c1                               # 004a3ab1
    mov edx, dword ptr [ebp + arg_10]            # 004a3ab7
    mov dword ptr [edx], ecx                     # 004a3aba
    mov eax, dword ptr [ebp + arg_c]             # 004a3abc
    mov ecx, dword ptr [eax]                     # 004a3abf
    add ecx, 0x6c1                               # 004a3ac1
    mov edx, dword ptr [ebp + arg_c]             # 004a3ac7
    mov dword ptr [edx], ecx                     # 004a3aca
    movsx eax, word ptr [0x63a4cd]               # 004a3acc
    test eax, eax                                # 004a3ad3
    je.d8 L_004a3ae4                             # 004a3ad5
    # block 0x004a3ad7: entered by fall-through of je at 0x004a3ad5, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004a3ae4
    push 0x550538                                # 004a3ad7
    call FUN_0044a2b7                            # 004a3adc
    add esp, 0x4                                 # 004a3ae1
L_004a3ae4:
    # block 0x004a3ae4: entered by je at 0x004a3ad5, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004a3ae4
    pop esi                                      # 004a3ae5
    {load} mov esp, ebp                          # 004a3ae6
    pop ebp                                      # 004a3ae8
    ret 0xc                                      # 004a3ae9

