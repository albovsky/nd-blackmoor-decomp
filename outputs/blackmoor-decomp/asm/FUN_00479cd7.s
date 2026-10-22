# FUN_00479cd7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00479cd7
# extent:       0x00479cd7-0x00479d98 (193 code bytes)
# span:         0x00479cd7-0x00479d98 (code 193, tables 0, padding 0)
# sha256:       0dc2bf919f14ac93075dc906002f3e51828c8353adc26695cdb87e8d8f3eb76d
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00479cd7
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_4, field_1586, field_158a; [edx + n] field_4, field_8, field_c, field_158, field_15c, field_1c0
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m478e7b_lifted (function ledger class candidate_port; also m479cd7_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 54 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_14, 0x14  # offset +0x14
.equ field_1e, 0x1e  # offset +0x1e
.equ field_158, 0x158  # offset +0x158
.equ field_15c, 0x15c  # offset +0x15c
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1586, 0x1586  # offset +0x1586
.equ field_158a, 0x158a  # offset +0x158a

# --- external targets -----------------------------------------------

.org 0x00479cd7 - 0x401000
.globl FUN_00479cd7
FUN_00479cd7:
    # block 0x00479cd7: entry, 54 instruction(s), ends with ret 0x10
    push ebp                                     # 00479cd7
    {load} mov ebp, esp                          # 00479cd8
    sub esp, 0x8                                 # 00479cda
    mov dword ptr [ebp - local_8], ecx           # 00479cdd
    mov eax, dword ptr [ebp - local_8]           # 00479ce0
    movsx ecx, word ptr [eax + field_1e]         # 00479ce3
    imul ecx, ecx, 0x8d                          # 00479ce7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00479ced
    mov dword ptr [ebp - local_4], edx           # 00479cf3
    movsx eax, word ptr [ebp + arg_c]            # 00479cf6
    mov ecx, dword ptr [ebp - local_8]           # 00479cfa
    imul eax, dword ptr [ecx + field_1586]       # 00479cfd
    mov edx, dword ptr [ebp - local_4]           # 00479d04
    mov ecx, dword ptr [edx + field_158]         # 00479d07
    {load} add ecx, eax                          # 00479d0d
    mov edx, dword ptr [ebp - local_4]           # 00479d0f
    movsx eax, word ptr [edx + field_1c0]        # 00479d12
    movsx edx, word ptr [ebp + arg_c]            # 00479d19
    imul eax, edx                                # 00479d1d
    mov edx, dword ptr [0x583186]                # 00479d20
    {load} add edx, ecx                          # 00479d26
    {load} add eax, edx                          # 00479d28
    mov ecx, dword ptr [ebp + arg_14]            # 00479d2a
    mov dword ptr [ecx], eax                     # 00479d2d
    mov edx, dword ptr [ebp + arg_14]            # 00479d2f
    mov eax, dword ptr [edx]                     # 00479d32
    mov ecx, dword ptr [ebp - local_8]           # 00479d34
    add eax, dword ptr [ecx + field_1586]        # 00479d37
    mov edx, dword ptr [ebp + arg_14]            # 00479d3d
    mov dword ptr [edx + field_8], eax           # 00479d40
    movsx eax, word ptr [ebp + arg_8]            # 00479d43
    mov ecx, dword ptr [ebp - local_8]           # 00479d47
    imul eax, dword ptr [ecx + field_158a]       # 00479d4a
    mov edx, dword ptr [ebp - local_4]           # 00479d51
    mov ecx, dword ptr [edx + field_15c]         # 00479d54
    {load} add ecx, eax                          # 00479d5a
    mov edx, dword ptr [ebp - local_4]           # 00479d5c
    movsx eax, word ptr [edx + field_1c0]        # 00479d5f
    movsx edx, word ptr [ebp + arg_8]            # 00479d66
    imul eax, edx                                # 00479d6a
    mov edx, dword ptr [0x58318a]                # 00479d6d
    {load} add edx, ecx                          # 00479d73
    {load} add eax, edx                          # 00479d75
    mov ecx, dword ptr [ebp + arg_14]            # 00479d77
    mov dword ptr [ecx + field_4], eax           # 00479d7a
    mov edx, dword ptr [ebp + arg_14]            # 00479d7d
    mov eax, dword ptr [edx + field_4]           # 00479d80
    mov ecx, dword ptr [ebp - local_8]           # 00479d83
    add eax, dword ptr [ecx + field_158a]        # 00479d86
    mov edx, dword ptr [ebp + arg_14]            # 00479d8c
    mov dword ptr [edx + field_c], eax           # 00479d8f
    {load} mov esp, ebp                          # 00479d92
    pop ebp                                      # 00479d94
    ret 0x10                                     # 00479d95

