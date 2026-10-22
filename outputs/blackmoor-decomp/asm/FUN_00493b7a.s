# FUN_00493b7a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00493b7a
# extent:       0x00493b7a-0x00493c34 (186 code bytes)
# span:         0x00493b7a-0x00493c34 (code 186, tables 0, padding 0)
# sha256:       788c0c4cd8a7c2d289fffa4ebb82a6db9ba4768873985871d36239893e1d3314
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m493b7a_clone_record
# naming:       native port src/original_methods_fl39b.c:m493b7a_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0xc6 bytes with 0x51dc43, stores the block to [p0], reports a null block (0x50ca3e, 0x42639d, 0x4c97b4), otherwise copies 0xc6 bytes (rep movsd, movsw) from [p1] to [p0]. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39b.c:m493b7a_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x00493b7a - 0x401000
.globl FUN_00493b7a
FUN_00493b7a:
    # block 0x00493b7a: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00493be1 (forward)
    push ebp                                     # 00493b7a
    {load} mov ebp, esp                          # 00493b7b
    sub esp, 0x8                                 # 00493b7d
    push esi                                     # 00493b80
    push edi                                     # 00493b81
    mov dword ptr [ebp - local_8], ecx           # 00493b82
    push 0xc6                                    # 00493b85
    call FUN_0051dc43                            # 00493b8a
    add esp, 0x4                                 # 00493b8f
    mov dword ptr [ebp - local_4], eax           # 00493b92
    mov eax, dword ptr [ebp + arg_8]             # 00493b95
    mov ecx, dword ptr [ebp - local_4]           # 00493b98
    mov dword ptr [eax], ecx                     # 00493b9b
    cmp dword ptr [ebp - local_4], 0x0           # 00493b9d
    jne.d8 L_00493be1                            # 00493ba1
    # block 0x00493ba3: entered by fall-through of jne at 0x00493ba1, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00493be1
    movsx edx, word ptr [0x5c39e3]               # 00493ba3
    push edx                                     # 00493baa
    mov eax, dword ptr [0x5bb57b]                # 00493bab
    push eax                                     # 00493bb0
    push 0x54f784                                # 00493bb1
    push 0x63888b                                # 00493bb6
    call FUN_0050ca3e                            # 00493bbb
    add esp, 0x10                                # 00493bc0
    push 0x63888b                                # 00493bc3
    push 0x54f7b0                                # 00493bc8
    mov ecx, 0x583979                            # 00493bcd
    call FUN_0042639d                            # 00493bd2
    mov ecx, 0x5cf659                            # 00493bd7
    call FUN_004c97b4                            # 00493bdc
L_00493be1:
    # block 0x00493be1: entered by jne at 0x00493ba1, 20 instruction(s), ends with je to 0x00493c2c (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00493be1
    mov esi, dword ptr [ecx]                     # 00493be4
    mov edx, dword ptr [ebp + arg_8]             # 00493be6
    mov edi, dword ptr [edx]                     # 00493be9
    mov ecx, 0x31                                # 00493beb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00493bf0
    movsw word ptr es:[edi], word ptr [esi]      # 00493bf2
    mov eax, dword ptr [ebp + arg_10]            # 00493bf4
    mov ecx, dword ptr [eax]                     # 00493bf7
    add ecx, 0xc6                                # 00493bf9
    mov edx, dword ptr [ebp + arg_10]            # 00493bff
    mov dword ptr [edx], ecx                     # 00493c02
    mov eax, dword ptr [ebp + arg_c]             # 00493c04
    mov ecx, dword ptr [eax]                     # 00493c07
    add ecx, 0xc6                                # 00493c09
    mov edx, dword ptr [ebp + arg_c]             # 00493c0f
    mov dword ptr [edx], ecx                     # 00493c12
    movsx eax, word ptr [0x63a4cd]               # 00493c14
    test eax, eax                                # 00493c1b
    je.d8 L_00493c2c                             # 00493c1d
    # block 0x00493c1f: entered by fall-through of je at 0x00493c1d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00493c2c
    push 0x54f7cc                                # 00493c1f
    call FUN_0044a2b7                            # 00493c24
    add esp, 0x4                                 # 00493c29
L_00493c2c:
    # block 0x00493c2c: entered by je at 0x00493c1d, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00493c2c
    pop esi                                      # 00493c2d
    {load} mov esp, ebp                          # 00493c2e
    pop ebp                                      # 00493c30
    ret 0xc                                      # 00493c31

