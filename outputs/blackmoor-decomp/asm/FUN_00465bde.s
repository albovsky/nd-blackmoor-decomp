# FUN_00465bde
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465bde
# extent:       0x00465bde-0x00465c99 (187 code bytes)
# span:         0x00465bde-0x00465c99 (code 187, tables 0, padding 0)
# sha256:       2e0008f81be4f23ef95679f22a151f3f68e18df15be72a5a25c9b6e6ec9ded8e
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m465bde_clone_record
# naming:       native port src/original_methods_fl38b.c:m465bde_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x55f) stored at *out; copies 0x55f bytes (movsw+movsb) from *in2 and advances *adv and *in2 by it; p == 0 ends in 0x4c97b4 (returns; post-call null copy not modelled). 58/58 instructions, both jne/je ways.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38b.c:m465bde_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x00465bde - 0x401000
.globl FUN_00465bde
FUN_00465bde:
    # block 0x00465bde: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00465c45 (forward)
    push ebp                                     # 00465bde
    {load} mov ebp, esp                          # 00465bdf
    sub esp, 0x8                                 # 00465be1
    push esi                                     # 00465be4
    push edi                                     # 00465be5
    mov dword ptr [ebp - local_8], ecx           # 00465be6
    push 0x55f                                   # 00465be9
    call FUN_0051dc43                            # 00465bee
    add esp, 0x4                                 # 00465bf3
    mov dword ptr [ebp - local_4], eax           # 00465bf6
    mov eax, dword ptr [ebp + arg_8]             # 00465bf9
    mov ecx, dword ptr [ebp - local_4]           # 00465bfc
    mov dword ptr [eax], ecx                     # 00465bff
    cmp dword ptr [ebp - local_4], 0x0           # 00465c01
    jne.d8 L_00465c45                            # 00465c05
    # block 0x00465c07: entered by fall-through of jne at 0x00465c05, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00465c45
    movsx edx, word ptr [0x5c39e3]               # 00465c07
    push edx                                     # 00465c0e
    mov eax, dword ptr [0x5bb57b]                # 00465c0f
    push eax                                     # 00465c14
    push 0x54b4d0                                # 00465c15
    push 0x63888b                                # 00465c1a
    call FUN_0050ca3e                            # 00465c1f
    add esp, 0x10                                # 00465c24
    push 0x63888b                                # 00465c27
    push 0x54b4fc                                # 00465c2c
    mov ecx, 0x583979                            # 00465c31
    call FUN_0042639d                            # 00465c36
    mov ecx, 0x5cf659                            # 00465c3b
    call FUN_004c97b4                            # 00465c40
L_00465c45:
    # block 0x00465c45: entered by jne at 0x00465c05, 21 instruction(s), ends with je to 0x00465c91 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00465c45
    mov esi, dword ptr [ecx]                     # 00465c48
    mov edx, dword ptr [ebp + arg_8]             # 00465c4a
    mov edi, dword ptr [edx]                     # 00465c4d
    mov ecx, 0x157                               # 00465c4f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00465c54
    movsw word ptr es:[edi], word ptr [esi]      # 00465c56
    movsb byte ptr es:[edi], byte ptr [esi]      # 00465c58
    mov eax, dword ptr [ebp + arg_10]            # 00465c59
    mov ecx, dword ptr [eax]                     # 00465c5c
    add ecx, 0x55f                               # 00465c5e
    mov edx, dword ptr [ebp + arg_10]            # 00465c64
    mov dword ptr [edx], ecx                     # 00465c67
    mov eax, dword ptr [ebp + arg_c]             # 00465c69
    mov ecx, dword ptr [eax]                     # 00465c6c
    add ecx, 0x55f                               # 00465c6e
    mov edx, dword ptr [ebp + arg_c]             # 00465c74
    mov dword ptr [edx], ecx                     # 00465c77
    movsx eax, word ptr [0x63a4cd]               # 00465c79
    test eax, eax                                # 00465c80
    je.d8 L_00465c91                             # 00465c82
    # block 0x00465c84: entered by fall-through of je at 0x00465c82, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00465c91
    push 0x54b518                                # 00465c84
    call FUN_0044a2b7                            # 00465c89
    add esp, 0x4                                 # 00465c8e
L_00465c91:
    # block 0x00465c91: entered by je at 0x00465c82, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00465c91
    pop esi                                      # 00465c92
    {load} mov esp, ebp                          # 00465c93
    pop ebp                                      # 00465c95
    ret 0xc                                      # 00465c96

