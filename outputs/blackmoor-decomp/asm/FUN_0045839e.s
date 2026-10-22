# FUN_0045839e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045839e
# extent:       0x0045839e-0x0045841e (128 code bytes)
# span:         0x0045839e-0x0045841e (code 128, tables 0, padding 0)
# sha256:       c0811b7c3bb9f77613091211b173508ed8cd66398721e84e42b037bc0e968afd
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45839e_lifted
# naming:       native port src/original_methods_fl40.c:m45839e_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 7 seeds; oracle: 50/50 instructions executed, 16/16 conditional-jump directions taken, callees as recording stubs.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m45839e_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 50 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0045839e - 0x401000
.globl FUN_0045839e
FUN_0045839e:
    # block 0x0045839e: entry, 9 instruction(s), ends with jge to 0x004583be (forward)
    push ebp                                     # 0045839e
    {load} mov ebp, esp                          # 0045839f
    push ecx                                     # 004583a1
    mov dword ptr [ebp - local_4], ecx           # 004583a2
    mov eax, dword ptr [ebp + arg_8]             # 004583a5
    mov ecx, dword ptr [ebp + arg_c]             # 004583a8
    mov edx, dword ptr [eax]                     # 004583ab
    cmp edx, dword ptr [ecx]                     # 004583ad
    jge.d8 L_004583be                            # 004583af
    # block 0x004583b1: entered by fall-through of jge at 0x004583af, 5 instruction(s), ends with jge to 0x004583d7 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004583b1
    mov ecx, dword ptr [ebp + arg_c]             # 004583b4
    mov edx, dword ptr [eax + field_8]           # 004583b7
    cmp edx, dword ptr [ecx]                     # 004583ba
    jge.d8 L_004583d7                            # 004583bc
L_004583be:
    # block 0x004583be: entered by jge at 0x004583af; fall-through of jge at 0x004583bc, 5 instruction(s), ends with jl to 0x00458416 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004583be
    mov ecx, dword ptr [ebp + arg_c]             # 004583c1
    mov edx, dword ptr [eax]                     # 004583c4
    cmp edx, dword ptr [ecx]                     # 004583c6
    jl.d8 L_00458416                             # 004583c8
    # block 0x004583ca: entered by fall-through of jl at 0x004583c8, 5 instruction(s), ends with jg to 0x00458416 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004583ca
    mov ecx, dword ptr [ebp + arg_c]             # 004583cd
    mov edx, dword ptr [eax]                     # 004583d0
    cmp edx, dword ptr [ecx + field_8]           # 004583d2
    jg.d8 L_00458416                             # 004583d5
L_004583d7:
    # block 0x004583d7: entered by jge at 0x004583bc; fall-through of jg at 0x004583d5, 5 instruction(s), ends with jge to 0x004583f3 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004583d7
    mov ecx, dword ptr [ebp + arg_c]             # 004583da
    mov edx, dword ptr [eax + field_4]           # 004583dd
    cmp edx, dword ptr [ecx + field_4]           # 004583e0
    jge.d8 L_004583f3                            # 004583e3
    # block 0x004583e5: entered by fall-through of jge at 0x004583e3, 5 instruction(s), ends with jge to 0x0045840f (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004583e5
    mov ecx, dword ptr [ebp + arg_c]             # 004583e8
    mov edx, dword ptr [eax + field_c]           # 004583eb
    cmp edx, dword ptr [ecx + field_4]           # 004583ee
    jge.d8 L_0045840f                            # 004583f1
L_004583f3:
    # block 0x004583f3: entered by jge at 0x004583e3; fall-through of jge at 0x004583f1, 5 instruction(s), ends with jl to 0x00458416 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004583f3
    mov ecx, dword ptr [ebp + arg_c]             # 004583f6
    mov edx, dword ptr [eax + field_4]           # 004583f9
    cmp edx, dword ptr [ecx + field_4]           # 004583fc
    jl.d8 L_00458416                             # 004583ff
    # block 0x00458401: entered by fall-through of jl at 0x004583ff, 5 instruction(s), ends with jg to 0x00458416 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00458401
    mov ecx, dword ptr [ebp + arg_c]             # 00458404
    mov edx, dword ptr [eax + field_4]           # 00458407
    cmp edx, dword ptr [ecx + field_c]           # 0045840a
    jg.d8 L_00458416                             # 0045840d
L_0045840f:
    # block 0x0045840f: entered by jge at 0x004583f1; fall-through of jg at 0x0045840d, 2 instruction(s), ends with forward jump to 0x00458418
    mov eax, 0x1                                 # 0045840f
    jmp.d8 L_00458418                            # 00458414
L_00458416:
    # block 0x00458416: entered by jl at 0x004583c8; jg at 0x004583d5; jl at 0x004583ff; jg at 0x0045840d, 1 instruction(s), falls into the block at 0x00458418
    {load} xor eax, eax                          # 00458416
L_00458418:
    # block 0x00458418: entered by jmp at 0x00458414, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00458418
    pop ebp                                      # 0045841a
    ret 0x8                                      # 0045841b

