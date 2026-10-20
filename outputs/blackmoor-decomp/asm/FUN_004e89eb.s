# FUN_004e89eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e89eb
# extent:       0x004e89eb-0x004e8bb4 (457 code bytes)
# span:         0x004e89eb-0x004e8bb4 (code 457, tables 0, padding 0)
# sha256:       d927adb53cfce7f4dc899bdc23cd5c9ee9ade4a9bd470d46a6e0034e8e0003ff
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e89eb_layout_slots
# naming:       native port src/original_methods_fl19a.c:m4e89eb_layout_slots (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4e89eb_layout_slots. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 457 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_764c, field_822e, field_823e, field_8242, field_824a, field_minus_1; [ecx + n] field_7012, field_764c, field_822e, field_823a, field_8246, field_minus_1; [edx + n] field_7654, field_822e, field_823a, field_823e, field_8242, field_8246, field_824e
# callees:      calls FUN_004ee2a9, FUN_004e22fd, FUN_004e8bb4
# track-n:      outputs/blackmoor-decomp/src/inventory_view_runtime.h:inventory_view_cursor_choice (function ledger class native_oracle_verified; also inventory_view_hover; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 103 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ field_7012, 0x7012  # offset +0x7012
.equ field_764c, 0x764c  # offset +0x764c
.equ field_7654, 0x7654  # offset +0x7654
.equ field_822e, 0x822e  # offset +0x822e
.equ field_823a, 0x823a  # offset +0x823a
.equ field_823e, 0x823e  # offset +0x823e
.equ field_8242, 0x8242  # offset +0x8242
.equ field_8246, 0x8246  # offset +0x8246
.equ field_824a, 0x824a  # offset +0x824a
.equ field_824e, 0x824e  # offset +0x824e

# --- external targets -----------------------------------------------
.set FUN_004e22fd, .text + (0x004e22fd - 0x401000)
.set FUN_004e8bb4, .text + (0x004e8bb4 - 0x401000)
.set FUN_004ee2a9, .text + (0x004ee2a9 - 0x401000)

.org 0x004e89eb - 0x401000
.globl FUN_004e89eb
FUN_004e89eb:
    # block 0x004e89eb: entry, 7 instruction(s), ends with je to 0x004e8a0f (forward)
    push ebp                                     # 004e89eb
    {load} mov ebp, esp                          # 004e89ec
    push ecx                                     # 004e89ee
    mov dword ptr [ebp - local_4], ecx           # 004e89ef
    mov eax, dword ptr [ebp - local_4]           # 004e89f2
    cmp dword ptr [eax + field_764c], 0x2        # 004e89f5
    je.d8 L_004e8a0f                             # 004e89fc
    # block 0x004e89fe: entered by fall-through of je at 0x004e89fc, 3 instruction(s), ends with je to 0x004e8a0f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e89fe
    cmp dword ptr [ecx + field_764c], 0x3        # 004e8a01
    je.d8 L_004e8a0f                             # 004e8a08
    # block 0x004e8a0a: entered by fall-through of je at 0x004e8a08, 1 instruction(s), ends with forward jump to 0x004e8bb0
    jmp.d32 L_004e8bb0                           # 004e8a0a
L_004e8a0f:
    # block 0x004e8a0f: entered by je at 0x004e89fc; je at 0x004e8a08, 4 instruction(s), calls FUN_004ee2a9, ends with je to 0x004e8a20 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e8a0f
    call FUN_004ee2a9                            # 004e8a12
    test eax, eax                                # 004e8a17
    je.d8 L_004e8a20                             # 004e8a19
    # block 0x004e8a1b: entered by fall-through of je at 0x004e8a19, 1 instruction(s), ends with forward jump to 0x004e8bb0
    jmp.d32 L_004e8bb0                           # 004e8a1b
L_004e8a20:
    # block 0x004e8a20: entered by je at 0x004e8a19, 55 instruction(s), ends with forward jump to 0x004e8b4a
    mov edx, dword ptr [0x5b44f0]                # 004e8a20
    shl edx, 0x4                                 # 004e8a26
    mov eax, dword ptr [0x5b44f4]                # 004e8a29
    mov ecx, dword ptr [0x583102]                # 004e8a2e
    add ecx, dword ptr [edx + 8*eax + 0x5b30cc]  # 004e8a34
    mov edx, dword ptr [ebp - local_4]           # 004e8a3b
    mov dword ptr [edx + field_823a], ecx        # 004e8a3e
    mov eax, dword ptr [0x5b44f0]                # 004e8a44
    shl eax, 0x4                                 # 004e8a49
    mov ecx, dword ptr [0x5b44f4]                # 004e8a4c
    mov edx, dword ptr [0x583106]                # 004e8a52
    add edx, dword ptr [eax + 8*ecx + 0x5b30d0]  # 004e8a58
    mov eax, dword ptr [ebp - local_4]           # 004e8a5f
    mov dword ptr [eax + field_823e], edx        # 004e8a62
    mov ecx, dword ptr [ebp - local_4]           # 004e8a68
    mov edx, dword ptr [ecx + field_823a]        # 004e8a6b
    mov dword ptr [0x5c3a5b], edx                # 004e8a71
    mov eax, dword ptr [ebp - local_4]           # 004e8a77
    mov ecx, dword ptr [eax + field_823e]        # 004e8a7a
    mov dword ptr [0x5c3a5f], ecx                # 004e8a80
    mov edx, dword ptr [0x5b44f0]                # 004e8a86
    shl edx, 0x4                                 # 004e8a8c
    mov eax, dword ptr [0x5b44f4]                # 004e8a8f
    mov ecx, dword ptr [0x583102]                # 004e8a94
    add ecx, dword ptr [edx + 8*eax + 0x5b3e40]  # 004e8a9a
    mov edx, dword ptr [ebp - local_4]           # 004e8aa1
    mov dword ptr [edx + field_8242], ecx        # 004e8aa4
    mov eax, dword ptr [0x5b44f4]                # 004e8aaa
    shl eax, 0x2                                 # 004e8aaf
    mov ecx, dword ptr [0x5b44f0]                # 004e8ab2
    movsx edx, word ptr [eax + 8*ecx + 0x5b3ae8] # 004e8ab8
    mov eax, dword ptr [ebp - local_4]           # 004e8ac0
    mov ecx, dword ptr [eax + field_8242]        # 004e8ac3
    lea edx, [ecx + edx - field_minus_1]         # 004e8ac9
    mov eax, dword ptr [ebp - local_4]           # 004e8acd
    mov dword ptr [eax + field_824a], edx        # 004e8ad0
    mov ecx, dword ptr [0x5b44f0]                # 004e8ad6
    shl ecx, 0x4                                 # 004e8adc
    mov edx, dword ptr [0x5b44f4]                # 004e8adf
    mov eax, dword ptr [0x583106]                # 004e8ae5
    add eax, dword ptr [ecx + 8*edx + 0x5b3e44]  # 004e8aea
    mov ecx, dword ptr [ebp - local_4]           # 004e8af1
    mov dword ptr [ecx + field_8246], eax        # 004e8af4
    mov edx, dword ptr [0x5b44f4]                # 004e8afa
    shl edx, 0x2                                 # 004e8b00
    mov eax, dword ptr [0x5b44f0]                # 004e8b03
    movsx ecx, word ptr [edx + 8*eax + 0x5b3aea] # 004e8b08
    mov edx, dword ptr [ebp - local_4]           # 004e8b10
    mov eax, dword ptr [edx + field_8246]        # 004e8b13
    lea ecx, [eax + ecx - field_minus_1]         # 004e8b19
    mov edx, dword ptr [ebp - local_4]           # 004e8b1d
    mov dword ptr [edx + field_824e], ecx        # 004e8b20
    mov eax, dword ptr [ebp - local_4]           # 004e8b26
    mov dword ptr [eax + field_822e], 0x0        # 004e8b29
    jmp.d8 L_004e8b4a                            # 004e8b33
L_004e8b35:
    # block 0x004e8b35: entered by jmp at 0x004e8ba6, 5 instruction(s), falls into the block at 0x004e8b4a
    mov ecx, dword ptr [ebp - local_4]           # 004e8b35
    mov edx, dword ptr [ecx + field_822e]        # 004e8b38
    add edx, 0x1                                 # 004e8b3e
    mov eax, dword ptr [ebp - local_4]           # 004e8b41
    mov dword ptr [eax + field_822e], edx        # 004e8b44
L_004e8b4a:
    # block 0x004e8b4a: entered by jmp at 0x004e8b33, 3 instruction(s), ends with jge to 0x004e8ba8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e8b4a
    cmp dword ptr [ecx + field_822e], 0x6        # 004e8b4d
    jge.d8 L_004e8ba8                            # 004e8b54
    # block 0x004e8b56: entered by fall-through of jge at 0x004e8b54, 6 instruction(s), ends with je to 0x004e8ba6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e8b56
    mov eax, dword ptr [edx + field_822e]        # 004e8b59
    imul eax, eax, 0xf7                          # 004e8b5f
    mov ecx, dword ptr [ebp - local_4]           # 004e8b65
    cmp dword ptr [ecx + eax + field_7012], 0x0  # 004e8b68
    je.d8 L_004e8ba6                             # 004e8b70
    # block 0x004e8b72: entered by fall-through of je at 0x004e8b70, 12 instruction(s), calls FUN_004e22fd, falls into the block at 0x004e8ba6
    mov edx, dword ptr [ebp - local_4]           # 004e8b72
    mov ax, word ptr [edx + field_823e]          # 004e8b75
    push eax                                     # 004e8b7c
    mov ecx, dword ptr [ebp - local_4]           # 004e8b7d
    mov dx, word ptr [ecx + field_823a]          # 004e8b80
    push edx                                     # 004e8b87
    mov eax, dword ptr [ebp - local_4]           # 004e8b88
    mov ecx, dword ptr [eax + field_822e]        # 004e8b8b
    imul ecx, ecx, 0x18f                         # 004e8b91
    mov edx, dword ptr [ebp - local_4]           # 004e8b97
    lea ecx, [edx + ecx + field_7654]            # 004e8b9a
    call FUN_004e22fd                            # 004e8ba1
L_004e8ba6:
    # block 0x004e8ba6: entered by je at 0x004e8b70, 1 instruction(s), ends with backward jump to 0x004e8b35
    jmp.d8 L_004e8b35                            # 004e8ba6
L_004e8ba8:
    # block 0x004e8ba8: entered by jge at 0x004e8b54, 2 instruction(s), calls FUN_004e8bb4, falls into the block at 0x004e8bb0
    mov ecx, dword ptr [ebp - local_4]           # 004e8ba8
    call FUN_004e8bb4                            # 004e8bab
L_004e8bb0:
    # block 0x004e8bb0: entered by jmp at 0x004e8a0a; jmp at 0x004e8a1b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e8bb0
    pop ebp                                      # 004e8bb2
    ret                                          # 004e8bb3

