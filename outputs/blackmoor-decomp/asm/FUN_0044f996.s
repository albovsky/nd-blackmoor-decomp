# FUN_0044f996
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044f996
# extent:       0x0044f996-0x0044fa8e (248 code bytes)
# span:         0x0044f996-0x0044fa8e (code 248, tables 0, padding 0)
# sha256:       7914f778617504af34d55e5823314ca88dd156f3db70c05dc053c0ff148b2b5e
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44f996_lifted
# naming:       native port src/original_methods_fl40.c:m44f996_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 6 seeds; oracle: 72/72 instructions executed, 14/14 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_c, field_2a0; [ecx + n] field_414, field_4dc, field_51c; [edx + n] field_4, field_2a0, field_2a4, field_414, field_4dc, field_51c
# callees:      calls FUN_004c2dfb, FUN_0051dc6c, FUN_00454065, FUN_004d3992, FUN_0044f68b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44f996_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 72 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_414, 0x414  # offset +0x414
.equ field_4dc, 0x4dc  # offset +0x4dc
.equ field_51c, 0x51c  # offset +0x51c

# --- external targets -----------------------------------------------
.set FUN_0044f68b, .text + (0x0044f68b - 0x401000)
.set FUN_00454065, .text + (0x00454065 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0044f996 - 0x401000
.globl FUN_0044f996
FUN_0044f996:
    # block 0x0044f996: entry, 7 instruction(s), ends with je to 0x0044f9b9 (forward)
    push ebp                                     # 0044f996
    {load} mov ebp, esp                          # 0044f997
    sub esp, 0xc                                 # 0044f999
    mov dword ptr [ebp - local_c], ecx           # 0044f99c
    mov eax, dword ptr [ebp - local_c]           # 0044f99f
    cmp dword ptr [eax + field_c], 0x0           # 0044f9a2
    je.d8 L_0044f9b9                             # 0044f9a6
    # block 0x0044f9a8: entered by fall-through of je at 0x0044f9a6, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0044f9b9
    mov ecx, dword ptr [ebp - local_c]           # 0044f9a8
    add ecx, 0xc                                 # 0044f9ab
    push ecx                                     # 0044f9ae
    mov ecx, 0x5cf659                            # 0044f9af
    call FUN_004c2dfb                            # 0044f9b4
L_0044f9b9:
    # block 0x0044f9b9: entered by je at 0x0044f9a6, 3 instruction(s), ends with je to 0x0044f9d8 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0044f9b9
    cmp dword ptr [edx + field_2a4], 0x0         # 0044f9bc
    je.d8 L_0044f9d8                             # 0044f9c3
    # block 0x0044f9c5: entered by fall-through of je at 0x0044f9c3, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0044f9d8
    mov eax, dword ptr [ebp - local_c]           # 0044f9c5
    add eax, 0x2a4                               # 0044f9c8
    push eax                                     # 0044f9cd
    mov ecx, 0x5cf659                            # 0044f9ce
    call FUN_004c2dfb                            # 0044f9d3
L_0044f9d8:
    # block 0x0044f9d8: entered by je at 0x0044f9c3, 3 instruction(s), ends with je to 0x0044f9fc (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044f9d8
    cmp dword ptr [ecx + field_51c], 0x0         # 0044f9db
    je.d8 L_0044f9fc                             # 0044f9e2
    # block 0x0044f9e4: entered by fall-through of je at 0x0044f9e2, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044f9fc
    mov edx, dword ptr [ebp - local_c]           # 0044f9e4
    mov eax, dword ptr [edx + field_51c]         # 0044f9e7
    mov dword ptr [ebp - local_4], eax           # 0044f9ed
    mov ecx, dword ptr [ebp - local_4]           # 0044f9f0
    push ecx                                     # 0044f9f3
    call FUN_0051dc6c                            # 0044f9f4
    add esp, 0x4                                 # 0044f9f9
L_0044f9fc:
    # block 0x0044f9fc: entered by je at 0x0044f9e2, 3 instruction(s), ends with je to 0x0044fa20 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0044f9fc
    cmp dword ptr [edx + field_2a0], 0x0         # 0044f9ff
    je.d8 L_0044fa20                             # 0044fa06
    # block 0x0044fa08: entered by fall-through of je at 0x0044fa06, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044fa20
    mov eax, dword ptr [ebp - local_c]           # 0044fa08
    mov ecx, dword ptr [eax + field_2a0]         # 0044fa0b
    mov dword ptr [ebp - local_8], ecx           # 0044fa11
    mov edx, dword ptr [ebp - local_8]           # 0044fa14
    push edx                                     # 0044fa17
    call FUN_0051dc6c                            # 0044fa18
    add esp, 0x4                                 # 0044fa1d
L_0044fa20:
    # block 0x0044fa20: entered by je at 0x0044fa06, 6 instruction(s), calls FUN_00454065, ends with je to 0x0044fa44 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044fa20
    call FUN_00454065                            # 0044fa23
    mov eax, dword ptr [ebp - local_c]           # 0044fa28
    movsx ecx, word ptr [eax + field_4]          # 0044fa2b
    cmp ecx, -0x1                                # 0044fa2f
    je.d8 L_0044fa44                             # 0044fa32
    # block 0x0044fa34: entered by fall-through of je at 0x0044fa32, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0044fa44
    mov edx, dword ptr [ebp - local_c]           # 0044fa34
    mov ax, word ptr [edx + field_4]             # 0044fa37
    push eax                                     # 0044fa3b
    call FUN_004d3992                            # 0044fa3c
    add esp, 0x4                                 # 0044fa41
L_0044fa44:
    # block 0x0044fa44: entered by je at 0x0044fa32, 3 instruction(s), ends with je to 0x0044fa63 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044fa44
    cmp dword ptr [ecx + field_4dc], -0x1        # 0044fa47
    je.d8 L_0044fa63                             # 0044fa4e
    # block 0x0044fa50: entered by fall-through of je at 0x0044fa4e, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0044fa63
    mov edx, dword ptr [ebp - local_c]           # 0044fa50
    mov ax, word ptr [edx + field_4dc]           # 0044fa53
    push eax                                     # 0044fa5a
    call FUN_004d3992                            # 0044fa5b
    add esp, 0x4                                 # 0044fa60
L_0044fa63:
    # block 0x0044fa63: entered by je at 0x0044fa4e, 3 instruction(s), ends with je to 0x0044fa82 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0044fa63
    cmp dword ptr [ecx + field_414], -0x1        # 0044fa66
    je.d8 L_0044fa82                             # 0044fa6d
    # block 0x0044fa6f: entered by fall-through of je at 0x0044fa6d, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0044fa82
    mov edx, dword ptr [ebp - local_c]           # 0044fa6f
    mov ax, word ptr [edx + field_414]           # 0044fa72
    push eax                                     # 0044fa79
    call FUN_004d3992                            # 0044fa7a
    add esp, 0x4                                 # 0044fa7f
L_0044fa82:
    # block 0x0044fa82: entered by je at 0x0044fa6d, 5 instruction(s), calls FUN_0044f68b, ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0044fa82
    call FUN_0044f68b                            # 0044fa85
    {load} mov esp, ebp                          # 0044fa8a
    pop ebp                                      # 0044fa8c
    ret                                          # 0044fa8d

