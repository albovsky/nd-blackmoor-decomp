# FUN_004c3efb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c3efb
# extent:       0x004c3efb-0x004c4067 (364 code bytes)
# span:         0x004c3efb-0x004c4067 (code 364, tables 0, padding 0)
# sha256:       955a8b7cc6f876d0a2d990524f3e5424b92a382dc3f41d8ec02f8552725d5312
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c3efb_lock_surface
# naming:       native port src/original_methods_fl29a.c:m4c3efb_lock_surface (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Surface lock with retry loop around the vtable entry at +0x64 (lost and busy codes, error report); every instruction executed, two jump directions impossible by construction are allowlisted. See tasks/fl29a-handoff.md.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_1c; [ecx + n] field_4, field_8, field_c, field_1c, field_20, field_42; [edx + n] field_4, field_14, field_18, field_1a, field_24, field_64
# callees:      calls FUN_004c4dc3, FUN_004c88c7, FUN_0050ca3e, FUN_004264e8; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl29a.c:m4c3efb_lock_surface (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 120 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ arg_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_42, 0x42  # offset +0x42
.equ field_64, 0x64  # offset +0x64

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c4dc3, .text + (0x004c4dc3 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c3efb - 0x401000
.globl FUN_004c3efb
FUN_004c3efb:
    # block 0x004c3efb: entry, 10 instruction(s), ends with jne to 0x004c3fd7 (forward)
    push ebp                                     # 004c3efb
    {load} mov ebp, esp                          # 004c3efc
    sub esp, 0x8                                 # 004c3efe
    push esi                                     # 004c3f01
    push edi                                     # 004c3f02
    mov dword ptr [ebp - local_8], ecx           # 004c3f03
    mov eax, dword ptr [ebp - local_8]           # 004c3f06
    mov ecx, dword ptr [ebp + arg_8]             # 004c3f09
    cmp ecx, dword ptr [eax + field_c]           # 004c3f0c
    jne.d32 L_004c3fd7                           # 004c3f0f
    # block 0x004c3f15: entered by fall-through of jne at 0x004c3f0f, 2 instruction(s), ends with je to 0x004c3f21 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c3f15
    je.d8 L_004c3f21                             # 004c3f19
    # block 0x004c3f1b: entered by fall-through of je at 0x004c3f19, 2 instruction(s), ends with jne to 0x004c3f49 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c3f1b
    jne.d8 L_004c3f49                            # 004c3f1f
L_004c3f21:
    # block 0x004c3f21: entered by je at 0x004c3f19; fall-through of jne at 0x004c3f1f, 13 instruction(s), ends with forward jump to 0x004c3f9e
    mov edx, dword ptr [ebp + arg_10]            # 004c3f21
    mov eax, dword ptr [ebp - local_8]           # 004c3f24
    mov ecx, dword ptr [eax + field_14]          # 004c3f27
    mov dword ptr [edx + field_24], ecx          # 004c3f2a
    mov edx, dword ptr [ebp - local_8]           # 004c3f2d
    movsx eax, word ptr [edx + field_1a]         # 004c3f30
    mov ecx, dword ptr [ebp + arg_10]            # 004c3f34
    mov dword ptr [ecx + field_8], eax           # 004c3f37
    mov edx, dword ptr [ebp - local_8]           # 004c3f3a
    movsx eax, word ptr [edx + field_18]         # 004c3f3d
    mov ecx, dword ptr [ebp + arg_10]            # 004c3f41
    mov dword ptr [ecx + field_c], eax           # 004c3f44
    jmp.d8 L_004c3f9e                            # 004c3f47
L_004c3f49:
    # block 0x004c3f49: entered by jne at 0x004c3f1f, 29 instruction(s), falls into the block at 0x004c3f9e
    mov edx, dword ptr [ebp + arg_c]             # 004c3f49
    mov eax, dword ptr [ebp - local_8]           # 004c3f4c
    mov ecx, dword ptr [edx + field_4]           # 004c3f4f
    imul ecx, dword ptr [eax + field_1c]         # 004c3f52
    mov edx, dword ptr [ebp - local_8]           # 004c3f56
    mov eax, dword ptr [edx + field_14]          # 004c3f59
    {load} add eax, ecx                          # 004c3f5c
    mov ecx, dword ptr [ebp - local_8]           # 004c3f5e
    movsx edx, word ptr [ecx + field_20]         # 004c3f61
    mov ecx, dword ptr [ebp + arg_c]             # 004c3f65
    mov ecx, dword ptr [ecx]                     # 004c3f68
    imul ecx, edx                                # 004c3f6a
    {load} add eax, ecx                          # 004c3f6d
    mov edx, dword ptr [ebp + arg_10]            # 004c3f6f
    mov dword ptr [edx + field_24], eax          # 004c3f72
    mov eax, dword ptr [ebp + arg_c]             # 004c3f75
    mov ecx, dword ptr [ebp + arg_c]             # 004c3f78
    mov edx, dword ptr [eax + field_c]           # 004c3f7b
    sub edx, dword ptr [ecx + field_4]           # 004c3f7e
    add edx, 0x1                                 # 004c3f81
    mov eax, dword ptr [ebp + arg_10]            # 004c3f84
    mov dword ptr [eax + field_8], edx           # 004c3f87
    mov ecx, dword ptr [ebp + arg_c]             # 004c3f8a
    mov edx, dword ptr [ebp + arg_c]             # 004c3f8d
    mov eax, dword ptr [ecx + field_8]           # 004c3f90
    sub eax, dword ptr [edx]                     # 004c3f93
    add eax, 0x1                                 # 004c3f95
    mov ecx, dword ptr [ebp + arg_10]            # 004c3f98
    mov dword ptr [ecx + field_c], eax           # 004c3f9b
L_004c3f9e:
    # block 0x004c3f9e: entered by jmp at 0x004c3f47, 17 instruction(s), ends with forward jump to 0x004c405f
    mov edx, dword ptr [ebp + arg_10]            # 004c3f9e
    mov dword ptr [edx], 0x6c                    # 004c3fa1
    mov eax, dword ptr [ebp + arg_10]            # 004c3fa7
    mov ecx, dword ptr [ebp - local_8]           # 004c3faa
    mov edx, dword ptr [ecx + field_42]          # 004c3fad
    mov dword ptr [eax + field_4], edx           # 004c3fb0
    mov eax, dword ptr [ebp + arg_10]            # 004c3fb3
    mov ecx, dword ptr [ebp - local_8]           # 004c3fb6
    mov edx, dword ptr [ecx + field_1c]          # 004c3fb9
    mov dword ptr [eax + field_10], edx          # 004c3fbc
    mov esi, dword ptr [ebp - local_8]           # 004c3fbf
    add esi, 0x22                                # 004c3fc2
    mov edi, dword ptr [ebp + arg_10]            # 004c3fc5
    add edi, 0x48                                # 004c3fc8
    mov ecx, 0x8                                 # 004c3fcb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c3fd0
    jmp.d32 L_004c405f                           # 004c3fd2
L_004c3fd7:
    # block 0x004c3fd7: entered by jne at 0x004c3f0f, 2 instruction(s), falls into the block at 0x004c3fe0
    mov eax, dword ptr [ebp + arg_10]            # 004c3fd7
    mov dword ptr [eax], 0x6c                    # 004c3fda
L_004c3fe0:
    # block 0x004c3fe0: entered by jmp at 0x004c405d, 3 instruction(s), ends with je to 0x004c405f (forward)
    mov ecx, 0x1                                 # 004c3fe0
    test ecx, ecx                                # 004c3fe5
    je.d8 L_004c405f                             # 004c3fe7
    # block 0x004c3fe9: entered by fall-through of je at 0x004c3fe7, 14 instruction(s), calls indirect dword ptr [edx + 0x64], ends with jne to 0x004c400f (forward)
    push 0x0                                     # 004c3fe9
    push 0x800                                   # 004c3feb
    mov edx, dword ptr [ebp + arg_10]            # 004c3ff0
    push edx                                     # 004c3ff3
    mov eax, dword ptr [ebp + arg_c]             # 004c3ff4
    push eax                                     # 004c3ff7
    mov ecx, dword ptr [ebp + arg_8]             # 004c3ff8
    mov edx, dword ptr [ecx]                     # 004c3ffb
    mov eax, dword ptr [ebp + arg_8]             # 004c3ffd
    push eax                                     # 004c4000
    call dword ptr [edx + field_64]              # 004c4001
    mov dword ptr [ebp - local_4], eax           # 004c4004
    cmp dword ptr [ebp - local_4], 0x0           # 004c4007
    jne.d8 L_004c400f                            # 004c400b
    # block 0x004c400d: entered by fall-through of jne at 0x004c400b, 1 instruction(s), ends with forward jump to 0x004c405f
    jmp.d8 L_004c405f                            # 004c400d
L_004c400f:
    # block 0x004c400f: entered by jne at 0x004c400b, 2 instruction(s), ends with jne to 0x004c4022 (forward)
    cmp dword ptr [ebp - local_4], 0x887601c2    # 004c400f
    jne.d8 L_004c4022                            # 004c4016
    # block 0x004c4018: entered by fall-through of jne at 0x004c4016, 3 instruction(s), calls FUN_004c4dc3, ends with forward jump to 0x004c405d
    mov ecx, dword ptr [ebp - local_8]           # 004c4018
    call FUN_004c4dc3                            # 004c401b
    jmp.d8 L_004c405d                            # 004c4020
L_004c4022:
    # block 0x004c4022: entered by jne at 0x004c4016, 2 instruction(s), ends with je to 0x004c405d (forward)
    cmp dword ptr [ebp - local_4], 0x8876021c    # 004c4022
    je.d8 L_004c405d                             # 004c4029
    # block 0x004c402b: entered by fall-through of je at 0x004c4029, 14 instruction(s), calls FUN_004c88c7, FUN_0050ca3e, FUN_004264e8, falls into the block at 0x004c405d
    mov ecx, dword ptr [ebp - local_4]           # 004c402b
    push ecx                                     # 004c402e
    mov ecx, dword ptr [ebp - local_8]           # 004c402f
    call FUN_004c88c7                            # 004c4032
    push eax                                     # 004c4037
    mov edx, dword ptr [ebp + arg_14]            # 004c4038
    push edx                                     # 004c403b
    push 0x554368                                # 004c403c
    push 0x63888b                                # 004c4041
    call FUN_0050ca3e                            # 004c4046
    add esp, 0x10                                # 004c404b
    push 0x63888b                                # 004c404e
    mov ecx, 0x583979                            # 004c4053
    call FUN_004264e8                            # 004c4058
L_004c405d:
    # block 0x004c405d: entered by jmp at 0x004c4020; je at 0x004c4029, 1 instruction(s), ends with backward jump to 0x004c3fe0
    jmp.d8 L_004c3fe0                            # 004c405d
L_004c405f:
    # block 0x004c405f: entered by jmp at 0x004c3fd2; je at 0x004c3fe7; jmp at 0x004c400d, 5 instruction(s), ends with ret 0x10
    pop edi                                      # 004c405f
    pop esi                                      # 004c4060
    {load} mov esp, ebp                          # 004c4061
    pop ebp                                      # 004c4063
    ret 0x10                                     # 004c4064

