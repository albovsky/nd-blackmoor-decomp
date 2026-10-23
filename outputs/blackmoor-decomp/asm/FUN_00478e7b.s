# FUN_00478e7b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00478e7b
# extent:       0x00478e7b-0x00478f91 (278 code bytes)
# span:         0x00478e7b-0x00478f91 (code 278, tables 0, padding 0)
# sha256:       c050c1de352249bc4f06b8ce0c432e37374e50c7f28c263ad8ce01f8f943e545
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00478e7b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_ac, field_ae, field_1594; [ecx + n] field_25, field_ac, field_b0, field_b2, field_1546; [edx + n] field_158e, field_1590, field_1592; [esi + n] field_b0, field_b2
# callees:      calls FUN_00479cd7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m478915_lifted (function ledger class candidate_port; also m478e7b_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 73 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_25, 0x25  # offset +0x25
.equ field_ac, 0xac  # offset +0xac
.equ field_ae, 0xae  # offset +0xae
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2
.equ field_1546, 0x1546  # offset +0x1546
.equ field_158e, 0x158e  # offset +0x158e
.equ field_1590, 0x1590  # offset +0x1590
.equ field_1592, 0x1592  # offset +0x1592
.equ field_1594, 0x1594  # offset +0x1594

# --- external targets -----------------------------------------------
.set FUN_00479cd7, .text + (0x00479cd7 - 0x401000)

.org 0x00478e7b - 0x401000
.globl FUN_00478e7b
FUN_00478e7b:
    # block 0x00478e7b: entry, 32 instruction(s), calls FUN_00479cd7, ends with forward jump to 0x00478f00
    push ebp                                     # 00478e7b
    {load} mov ebp, esp                          # 00478e7c
    sub esp, 0xc                                 # 00478e7e
    push esi                                     # 00478e81
    mov dword ptr [ebp - local_c], ecx           # 00478e82
    mov eax, dword ptr [ebp - local_c]           # 00478e85
    movsx ecx, word ptr [eax + field_1e]         # 00478e88
    imul ecx, ecx, 0x8d                          # 00478e8c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00478e92
    mov dword ptr [ebp - local_8], edx           # 00478e98
    mov eax, dword ptr [ebp - local_c]           # 00478e9b
    add eax, 0x1536                              # 00478e9e
    push eax                                     # 00478ea3
    push 0x0                                     # 00478ea4
    mov ecx, dword ptr [ebp - local_8]           # 00478ea6
    mov dx, word ptr [ecx + field_ac]            # 00478ea9
    push edx                                     # 00478eb0
    mov eax, dword ptr [ebp - local_8]           # 00478eb1
    mov cx, word ptr [eax + field_ae]            # 00478eb4
    push ecx                                     # 00478ebb
    mov ecx, dword ptr [ebp - local_c]           # 00478ebc
    call FUN_00479cd7                            # 00478ebf
    mov edx, dword ptr [ebp - local_c]           # 00478ec4
    mov eax, dword ptr [ebp - local_8]           # 00478ec7
    mov cx, word ptr [eax + field_ac]            # 00478eca
    mov word ptr [edx + field_158e], cx          # 00478ed1
    mov edx, dword ptr [ebp - local_c]           # 00478ed8
    mov eax, dword ptr [ebp - local_8]           # 00478edb
    mov cx, word ptr [eax + field_ae]            # 00478ede
    mov word ptr [edx + field_1590], cx          # 00478ee5
    mov word ptr [ebp - local_4], 0x0            # 00478eec
    jmp.d8 L_00478f00                            # 00478ef2
L_00478ef4:
    # block 0x00478ef4: entered by jmp at 0x00478f87, 3 instruction(s), falls into the block at 0x00478f00
    mov dx, word ptr [ebp - local_4]             # 00478ef4
    add dx, 0x1                                  # 00478ef8
    mov word ptr [ebp - local_4], dx             # 00478efc
L_00478f00:
    # block 0x00478f00: entered by jmp at 0x00478ef2, 5 instruction(s), ends with jge to 0x00478f8c (forward)
    movsx eax, word ptr [ebp - local_4]          # 00478f00
    mov ecx, dword ptr [ebp - local_8]           # 00478f04
    movsx edx, word ptr [ecx + field_25]         # 00478f07
    {load} cmp eax, edx                          # 00478f0b
    jge.d8 L_00478f8c                            # 00478f0d
    # block 0x00478f0f: entered by fall-through of jge at 0x00478f0d, 29 instruction(s), calls FUN_00479cd7, ends with backward jump to 0x00478ef4
    movsx eax, word ptr [ebp - local_4]          # 00478f0f
    shl eax, 0x4                                 # 00478f13
    mov ecx, dword ptr [ebp - local_c]           # 00478f16
    lea edx, [ecx + eax + field_1546]            # 00478f19
    push edx                                     # 00478f20
    push 0x0                                     # 00478f21
    movsx eax, word ptr [ebp - local_4]          # 00478f23
    mov ecx, dword ptr [ebp - local_8]           # 00478f27
    mov dx, word ptr [ecx + 4*eax + field_b0]    # 00478f2a
    push edx                                     # 00478f32
    movsx eax, word ptr [ebp - local_4]          # 00478f33
    mov ecx, dword ptr [ebp - local_8]           # 00478f37
    mov dx, word ptr [ecx + 4*eax + field_b2]    # 00478f3a
    push edx                                     # 00478f42
    mov ecx, dword ptr [ebp - local_c]           # 00478f43
    call FUN_00479cd7                            # 00478f46
    movsx eax, word ptr [ebp - local_4]          # 00478f4b
    movsx ecx, word ptr [ebp - local_4]          # 00478f4f
    mov edx, dword ptr [ebp - local_c]           # 00478f53
    mov esi, dword ptr [ebp - local_8]           # 00478f56
    mov ax, word ptr [esi + 4*eax + field_b0]    # 00478f59
    mov word ptr [edx + 4*ecx + field_1592], ax  # 00478f61
    movsx ecx, word ptr [ebp - local_4]          # 00478f69
    movsx edx, word ptr [ebp - local_4]          # 00478f6d
    mov eax, dword ptr [ebp - local_c]           # 00478f71
    mov esi, dword ptr [ebp - local_8]           # 00478f74
    mov cx, word ptr [esi + 4*ecx + field_b2]    # 00478f77
    mov word ptr [eax + 4*edx + field_1594], cx  # 00478f7f
    jmp.d32 L_00478ef4                           # 00478f87
L_00478f8c:
    # block 0x00478f8c: entered by jge at 0x00478f0d, 4 instruction(s), ends with ret
    pop esi                                      # 00478f8c
    {load} mov esp, ebp                          # 00478f8d
    pop ebp                                      # 00478f8f
    ret                                          # 00478f90

