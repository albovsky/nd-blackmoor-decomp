# FUN_0045807c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045807c
# extent:       0x0045807c-0x00458137 (187 code bytes)
# span:         0x0045807c-0x00458137 (code 187, tables 0, padding 0)
# sha256:       592ee287304fafb6167aee77c3fca2b6db27980254b0cd016e505be6679986a5
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045807c
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x0045807c - 0x401000
.globl FUN_0045807c
FUN_0045807c:
    # block 0x0045807c: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004580e3 (forward)
    push ebp                                     # 0045807c
    {load} mov ebp, esp                          # 0045807d
    sub esp, 0x8                                 # 0045807f
    push esi                                     # 00458082
    push edi                                     # 00458083
    mov dword ptr [ebp - local_8], ecx           # 00458084
    push 0x663                                   # 00458087
    call FUN_0051dc43                            # 0045808c
    add esp, 0x4                                 # 00458091
    mov dword ptr [ebp - local_4], eax           # 00458094
    mov eax, dword ptr [ebp + arg_8]             # 00458097
    mov ecx, dword ptr [ebp - local_4]           # 0045809a
    mov dword ptr [eax], ecx                     # 0045809d
    cmp dword ptr [ebp - local_4], 0x0           # 0045809f
    jne.d8 L_004580e3                            # 004580a3
    # block 0x004580a5: entered by fall-through of jne at 0x004580a3, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004580e3
    movsx edx, word ptr [0x5c39e3]               # 004580a5
    push edx                                     # 004580ac
    mov eax, dword ptr [0x5bb57b]                # 004580ad
    push eax                                     # 004580b2
    push 0x54a578                                # 004580b3
    push 0x63888b                                # 004580b8
    call FUN_0050ca3e                            # 004580bd
    add esp, 0x10                                # 004580c2
    push 0x63888b                                # 004580c5
    push 0x54a5a4                                # 004580ca
    mov ecx, 0x583979                            # 004580cf
    call FUN_0042639d                            # 004580d4
    mov ecx, 0x5cf659                            # 004580d9
    call FUN_004c97b4                            # 004580de
L_004580e3:
    # block 0x004580e3: entered by jne at 0x004580a3, 21 instruction(s), ends with je to 0x0045812f (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004580e3
    mov esi, dword ptr [ecx]                     # 004580e6
    mov edx, dword ptr [ebp + arg_8]             # 004580e8
    mov edi, dword ptr [edx]                     # 004580eb
    mov ecx, 0x198                               # 004580ed
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004580f2
    movsw word ptr es:[edi], word ptr [esi]      # 004580f4
    movsb byte ptr es:[edi], byte ptr [esi]      # 004580f6
    mov eax, dword ptr [ebp + arg_10]            # 004580f7
    mov ecx, dword ptr [eax]                     # 004580fa
    add ecx, 0x663                               # 004580fc
    mov edx, dword ptr [ebp + arg_10]            # 00458102
    mov dword ptr [edx], ecx                     # 00458105
    mov eax, dword ptr [ebp + arg_c]             # 00458107
    mov ecx, dword ptr [eax]                     # 0045810a
    add ecx, 0x663                               # 0045810c
    mov edx, dword ptr [ebp + arg_c]             # 00458112
    mov dword ptr [edx], ecx                     # 00458115
    movsx eax, word ptr [0x63a4cd]               # 00458117
    test eax, eax                                # 0045811e
    je.d8 L_0045812f                             # 00458120
    # block 0x00458122: entered by fall-through of je at 0x00458120, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0045812f
    push 0x54a5c0                                # 00458122
    call FUN_0044a2b7                            # 00458127
    add esp, 0x4                                 # 0045812c
L_0045812f:
    # block 0x0045812f: entered by je at 0x00458120, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0045812f
    pop esi                                      # 00458130
    {load} mov esp, ebp                          # 00458131
    pop ebp                                      # 00458133
    ret 0xc                                      # 00458134

