# FUN_0041195c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041195c
# extent:       0x0041195c-0x00411a22 (198 code bytes)
# span:         0x0041195c-0x00411a22 (code 198, tables 0, padding 0)
# sha256:       2c7b24f37fadddcff942811934986ee9f9af2e8065d2aeebe3cbba64a5650333
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041195c
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

.org 0x0041195c - 0x401000
.globl FUN_0041195c
FUN_0041195c:
    # block 0x0041195c: entry, 16 instruction(s), calls FUN_0051dc43, ends with jne to 0x004119d1 (forward)
    push ebp                                     # 0041195c
    {load} mov ebp, esp                          # 0041195d
    sub esp, 0x8                                 # 0041195f
    push esi                                     # 00411962
    push edi                                     # 00411963
    mov dword ptr [ebp - local_8], ecx           # 00411964
    push 0x1ec                                   # 00411967
    call FUN_0051dc43                            # 0041196c
    add esp, 0x4                                 # 00411971
    mov dword ptr [ebp - local_4], eax           # 00411974
    movsx eax, word ptr [0x5c39e3]               # 00411977
    imul eax, eax, 0x8d                          # 0041197e
    mov ecx, dword ptr [ebp - local_4]           # 00411984
    mov dword ptr [eax + 0x5bb5e5], ecx          # 00411987
    cmp dword ptr [ebp - local_4], 0x0           # 0041198d
    jne.d8 L_004119d1                            # 00411991
    # block 0x00411993: entered by fall-through of jne at 0x00411991, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004119d1
    movsx edx, word ptr [0x5c39e3]               # 00411993
    push edx                                     # 0041199a
    mov eax, dword ptr [0x5bb57b]                # 0041199b
    push eax                                     # 004119a0
    push 0x541384                                # 004119a1
    push 0x63888b                                # 004119a6
    call FUN_0050ca3e                            # 004119ab
    add esp, 0x10                                # 004119b0
    push 0x63888b                                # 004119b3
    push 0x5413b0                                # 004119b8
    mov ecx, 0x583979                            # 004119bd
    call FUN_0042639d                            # 004119c2
    mov ecx, 0x5cf659                            # 004119c7
    call FUN_004c97b4                            # 004119cc
L_004119d1:
    # block 0x004119d1: entered by jne at 0x00411991, 19 instruction(s), ends with je to 0x00411a1a (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004119d1
    mov esi, dword ptr [ecx]                     # 004119d4
    mov edx, dword ptr [ebp + arg_8]             # 004119d6
    mov edi, dword ptr [edx]                     # 004119d9
    mov ecx, 0x7b                                # 004119db
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004119e0
    mov eax, dword ptr [ebp + arg_10]            # 004119e2
    mov ecx, dword ptr [eax]                     # 004119e5
    add ecx, 0x1ec                               # 004119e7
    mov edx, dword ptr [ebp + arg_10]            # 004119ed
    mov dword ptr [edx], ecx                     # 004119f0
    mov eax, dword ptr [ebp + arg_c]             # 004119f2
    mov ecx, dword ptr [eax]                     # 004119f5
    add ecx, 0x1ec                               # 004119f7
    mov edx, dword ptr [ebp + arg_c]             # 004119fd
    mov dword ptr [edx], ecx                     # 00411a00
    movsx eax, word ptr [0x63a4cd]               # 00411a02
    test eax, eax                                # 00411a09
    je.d8 L_00411a1a                             # 00411a0b
    # block 0x00411a0d: entered by fall-through of je at 0x00411a0b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00411a1a
    push 0x5413cc                                # 00411a0d
    call FUN_0044a2b7                            # 00411a12
    add esp, 0x4                                 # 00411a17
L_00411a1a:
    # block 0x00411a1a: entered by je at 0x00411a0b, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00411a1a
    pop esi                                      # 00411a1b
    {load} mov esp, ebp                          # 00411a1c
    pop ebp                                      # 00411a1e
    ret 0xc                                      # 00411a1f

