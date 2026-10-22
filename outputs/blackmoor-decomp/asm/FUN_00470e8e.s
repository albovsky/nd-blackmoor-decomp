# FUN_00470e8e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470e8e
# extent:       0x00470e8e-0x00470ffe (368 code bytes)
# span:         0x00470e8e-0x00470ffe (code 368, tables 0, padding 0)
# sha256:       2d502443029c67090104ee671a84b4486f49236215fcffb5e6b4a2214f89e60b
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00470e8e
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m470e8e_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 106 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00470e8e - 0x401000
.globl FUN_00470e8e
FUN_00470e8e:
    # block 0x00470e8e: entry, 8 instruction(s), ends with jne to 0x00470f4e (forward)
    push ebp                                     # 00470e8e
    {load} mov ebp, esp                          # 00470e8f
    sub esp, 0xc                                 # 00470e91
    push esi                                     # 00470e94
    push edi                                     # 00470e95
    mov dword ptr [ebp - local_c], ecx           # 00470e96
    cmp dword ptr [ebp + arg_14], 0x0            # 00470e99
    jne.d32 L_00470f4e                           # 00470e9d
    # block 0x00470ea3: entered by fall-through of jne at 0x00470e9d, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x00470eff (forward)
    push 0x6c5                                   # 00470ea3
    call FUN_0051dc43                            # 00470ea8
    add esp, 0x4                                 # 00470ead
    mov dword ptr [ebp - local_4], eax           # 00470eb0
    mov eax, dword ptr [ebp + arg_8]             # 00470eb3
    mov ecx, dword ptr [ebp - local_4]           # 00470eb6
    mov dword ptr [eax], ecx                     # 00470eb9
    cmp dword ptr [ebp - local_4], 0x0           # 00470ebb
    jne.d8 L_00470eff                            # 00470ebf
    # block 0x00470ec1: entered by fall-through of jne at 0x00470ebf, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00470eff
    movsx edx, word ptr [0x5c39e3]               # 00470ec1
    push edx                                     # 00470ec8
    mov eax, dword ptr [0x5bb57b]                # 00470ec9
    push eax                                     # 00470ece
    push 0x54c388                                # 00470ecf
    push 0x63888b                                # 00470ed4
    call FUN_0050ca3e                            # 00470ed9
    add esp, 0x10                                # 00470ede
    push 0x63888b                                # 00470ee1
    push 0x54c3b4                                # 00470ee6
    mov ecx, 0x583979                            # 00470eeb
    call FUN_0042639d                            # 00470ef0
    mov ecx, 0x5cf659                            # 00470ef5
    call FUN_004c97b4                            # 00470efa
L_00470eff:
    # block 0x00470eff: entered by jne at 0x00470ebf, 20 instruction(s), ends with je to 0x00470f49 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00470eff
    mov esi, dword ptr [ecx]                     # 00470f02
    mov edx, dword ptr [ebp + arg_8]             # 00470f04
    mov edi, dword ptr [edx]                     # 00470f07
    mov ecx, 0x1b1                               # 00470f09
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00470f0e
    movsb byte ptr es:[edi], byte ptr [esi]      # 00470f10
    mov eax, dword ptr [ebp + arg_10]            # 00470f11
    mov ecx, dword ptr [eax]                     # 00470f14
    add ecx, 0x6c5                               # 00470f16
    mov edx, dword ptr [ebp + arg_10]            # 00470f1c
    mov dword ptr [edx], ecx                     # 00470f1f
    mov eax, dword ptr [ebp + arg_c]             # 00470f21
    mov ecx, dword ptr [eax]                     # 00470f24
    add ecx, 0x6c5                               # 00470f26
    mov edx, dword ptr [ebp + arg_c]             # 00470f2c
    mov dword ptr [edx], ecx                     # 00470f2f
    movsx eax, word ptr [0x63a4cd]               # 00470f31
    test eax, eax                                # 00470f38
    je.d8 L_00470f49                             # 00470f3a
    # block 0x00470f3c: entered by fall-through of je at 0x00470f3a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00470f49
    push 0x54c3d0                                # 00470f3c
    call FUN_0044a2b7                            # 00470f41
    add esp, 0x4                                 # 00470f46
L_00470f49:
    # block 0x00470f49: entered by je at 0x00470f3a, 1 instruction(s), ends with forward jump to 0x00470ff6
    jmp.d32 L_00470ff6                           # 00470f49
L_00470f4e:
    # block 0x00470f4e: entered by jne at 0x00470e9d, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x00470fab (forward)
    push 0x126                                   # 00470f4e
    call FUN_0051dc43                            # 00470f53
    add esp, 0x4                                 # 00470f58
    mov dword ptr [ebp - local_8], eax           # 00470f5b
    mov ecx, dword ptr [ebp + arg_8]             # 00470f5e
    mov edx, dword ptr [ebp - local_8]           # 00470f61
    mov dword ptr [ecx], edx                     # 00470f64
    cmp dword ptr [ebp - local_8], 0x0           # 00470f66
    jne.d8 L_00470fab                            # 00470f6a
    # block 0x00470f6c: entered by fall-through of jne at 0x00470f6a, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00470fab
    movsx eax, word ptr [0x5c39e3]               # 00470f6c
    push eax                                     # 00470f73
    mov ecx, dword ptr [0x5bb57b]                # 00470f74
    push ecx                                     # 00470f7a
    push 0x54c400                                # 00470f7b
    push 0x63888b                                # 00470f80
    call FUN_0050ca3e                            # 00470f85
    add esp, 0x10                                # 00470f8a
    push 0x63888b                                # 00470f8d
    push 0x54c42c                                # 00470f92
    mov ecx, 0x583979                            # 00470f97
    call FUN_0042639d                            # 00470f9c
    mov ecx, 0x5cf659                            # 00470fa1
    call FUN_004c97b4                            # 00470fa6
L_00470fab:
    # block 0x00470fab: entered by jne at 0x00470f6a, 20 instruction(s), ends with je to 0x00470ff6 (forward)
    mov edx, dword ptr [ebp + arg_c]             # 00470fab
    mov esi, dword ptr [edx]                     # 00470fae
    mov eax, dword ptr [ebp + arg_8]             # 00470fb0
    mov edi, dword ptr [eax]                     # 00470fb3
    mov ecx, 0x49                                # 00470fb5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00470fba
    movsw word ptr es:[edi], word ptr [esi]      # 00470fbc
    mov ecx, dword ptr [ebp + arg_10]            # 00470fbe
    mov edx, dword ptr [ecx]                     # 00470fc1
    add edx, 0x126                               # 00470fc3
    mov eax, dword ptr [ebp + arg_10]            # 00470fc9
    mov dword ptr [eax], edx                     # 00470fcc
    mov ecx, dword ptr [ebp + arg_c]             # 00470fce
    mov edx, dword ptr [ecx]                     # 00470fd1
    add edx, 0x126                               # 00470fd3
    mov eax, dword ptr [ebp + arg_c]             # 00470fd9
    mov dword ptr [eax], edx                     # 00470fdc
    movsx ecx, word ptr [0x63a4cd]               # 00470fde
    test ecx, ecx                                # 00470fe5
    je.d8 L_00470ff6                             # 00470fe7
    # block 0x00470fe9: entered by fall-through of je at 0x00470fe7, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00470ff6
    push 0x54c448                                # 00470fe9
    call FUN_0044a2b7                            # 00470fee
    add esp, 0x4                                 # 00470ff3
L_00470ff6:
    # block 0x00470ff6: entered by jmp at 0x00470f49; je at 0x00470fe7, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 00470ff6
    pop esi                                      # 00470ff7
    {load} mov esp, ebp                          # 00470ff8
    pop ebp                                      # 00470ffa
    ret 0x10                                     # 00470ffb

