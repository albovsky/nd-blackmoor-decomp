# FUN_00459c10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459c10
# extent:       0x00459c10-0x00459cc9 (185 code bytes)
# span:         0x00459c10-0x00459cc9 (code 185, tables 0, padding 0)
# sha256:       5df4cad667ac00378a044405ecfda6bf61771d96d2561254078a3992db3803ba
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00459c10
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

.org 0x00459c10 - 0x401000
.globl FUN_00459c10
FUN_00459c10:
    # block 0x00459c10: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00459c77 (forward)
    push ebp                                     # 00459c10
    {load} mov ebp, esp                          # 00459c11
    sub esp, 0x8                                 # 00459c13
    push esi                                     # 00459c16
    push edi                                     # 00459c17
    mov dword ptr [ebp - local_8], ecx           # 00459c18
    push 0x2b1                                   # 00459c1b
    call FUN_0051dc43                            # 00459c20
    add esp, 0x4                                 # 00459c25
    mov dword ptr [ebp - local_4], eax           # 00459c28
    mov eax, dword ptr [ebp + arg_8]             # 00459c2b
    mov ecx, dword ptr [ebp - local_4]           # 00459c2e
    mov dword ptr [eax], ecx                     # 00459c31
    cmp dword ptr [ebp - local_4], 0x0           # 00459c33
    jne.d8 L_00459c77                            # 00459c37
    # block 0x00459c39: entered by fall-through of jne at 0x00459c37, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00459c77
    movsx edx, word ptr [0x5c39e3]               # 00459c39
    push edx                                     # 00459c40
    mov eax, dword ptr [0x5bb57b]                # 00459c41
    push eax                                     # 00459c46
    push 0x54a74c                                # 00459c47
    push 0x63888b                                # 00459c4c
    call FUN_0050ca3e                            # 00459c51
    add esp, 0x10                                # 00459c56
    push 0x63888b                                # 00459c59
    push 0x54a778                                # 00459c5e
    mov ecx, 0x583979                            # 00459c63
    call FUN_0042639d                            # 00459c68
    mov ecx, 0x5cf659                            # 00459c6d
    call FUN_004c97b4                            # 00459c72
L_00459c77:
    # block 0x00459c77: entered by jne at 0x00459c37, 20 instruction(s), ends with je to 0x00459cc1 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00459c77
    mov esi, dword ptr [ecx]                     # 00459c7a
    mov edx, dword ptr [ebp + arg_8]             # 00459c7c
    mov edi, dword ptr [edx]                     # 00459c7f
    mov ecx, 0xac                                # 00459c81
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00459c86
    movsb byte ptr es:[edi], byte ptr [esi]      # 00459c88
    mov eax, dword ptr [ebp + arg_10]            # 00459c89
    mov ecx, dword ptr [eax]                     # 00459c8c
    add ecx, 0x2b1                               # 00459c8e
    mov edx, dword ptr [ebp + arg_10]            # 00459c94
    mov dword ptr [edx], ecx                     # 00459c97
    mov eax, dword ptr [ebp + arg_c]             # 00459c99
    mov ecx, dword ptr [eax]                     # 00459c9c
    add ecx, 0x2b1                               # 00459c9e
    mov edx, dword ptr [ebp + arg_c]             # 00459ca4
    mov dword ptr [edx], ecx                     # 00459ca7
    movsx eax, word ptr [0x63a4cd]               # 00459ca9
    test eax, eax                                # 00459cb0
    je.d8 L_00459cc1                             # 00459cb2
    # block 0x00459cb4: entered by fall-through of je at 0x00459cb2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00459cc1
    push 0x54a794                                # 00459cb4
    call FUN_0044a2b7                            # 00459cb9
    add esp, 0x4                                 # 00459cbe
L_00459cc1:
    # block 0x00459cc1: entered by je at 0x00459cb2, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00459cc1
    pop esi                                      # 00459cc2
    {load} mov esp, ebp                          # 00459cc3
    pop ebp                                      # 00459cc5
    ret 0xc                                      # 00459cc6

