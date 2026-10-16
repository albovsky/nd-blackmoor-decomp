# FUN_004e9e84
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e9e84
# extent:       0x004e9e84-0x004ea06c (488 code bytes)
# span:         0x004e9e84-0x004ea06c (code 488, tables 0, padding 0)
# sha256:       2474b155759c56581a8aa3345ba306834fe612ce2eaaa47db2052e61f046e932
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e9e84
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_764c, field_822e, field_828a; [ecx + n] field_7010, field_764c, field_822e, field_828a; [edx + n] field_822e, field_828a, field_828c
# callees:      calls FUN_004fb2e3, FUN_004e812f, FUN_004e0559
# track-n:      outputs/blackmoor-decomp/src/action_family_78_runtime.c:action78_add_item (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 120 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_7010, 0x7010  # offset +0x7010
.equ field_764c, 0x764c  # offset +0x764c
.equ field_822e, 0x822e  # offset +0x822e
.equ field_828a, 0x828a  # offset +0x828a
.equ field_828c, 0x828c  # offset +0x828c

# --- external targets -----------------------------------------------
.set FUN_004e0559, .text + (0x004e0559 - 0x401000)
.set FUN_004e812f, .text + (0x004e812f - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004e9e84 - 0x401000
.globl FUN_004e9e84
FUN_004e9e84:
    # block 0x004e9e84: entry, 9 instruction(s), ends with forward jump to 0x004e9eb1
    push ebp                                     # 004e9e84
    {load} mov ebp, esp                          # 004e9e85
    push ecx                                     # 004e9e87
    push esi                                     # 004e9e88
    push edi                                     # 004e9e89
    mov dword ptr [ebp - local_4], ecx           # 004e9e8a
    mov eax, dword ptr [ebp - local_4]           # 004e9e8d
    mov dword ptr [eax + field_822e], 0x0        # 004e9e90
    jmp.d8 L_004e9eb1                            # 004e9e9a
L_004e9e9c:
    # block 0x004e9e9c: entered by jmp at 0x004e9ee1, 5 instruction(s), falls into the block at 0x004e9eb1
    mov ecx, dword ptr [ebp - local_4]           # 004e9e9c
    mov edx, dword ptr [ecx + field_822e]        # 004e9e9f
    add edx, 0x1                                 # 004e9ea5
    mov eax, dword ptr [ebp - local_4]           # 004e9ea8
    mov dword ptr [eax + field_822e], edx        # 004e9eab
L_004e9eb1:
    # block 0x004e9eb1: entered by jmp at 0x004e9e9a, 4 instruction(s), ends with jge to 0x004e9ee3 (forward)
    movsx ecx, word ptr [0x583a2b]               # 004e9eb1
    mov edx, dword ptr [ebp - local_4]           # 004e9eb8
    cmp dword ptr [edx + field_822e], ecx        # 004e9ebb
    jge.d8 L_004e9ee3                            # 004e9ec1
    # block 0x004e9ec3: entered by fall-through of jge at 0x004e9ec1, 6 instruction(s), ends with jne to 0x004e9ee1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e9ec3
    mov ecx, dword ptr [eax + field_822e]        # 004e9ec6
    movsx edx, word ptr [2*ecx + 0x583a31]       # 004e9ecc
    movsx eax, word ptr [ebp + arg_8]            # 004e9ed4
    {load} cmp edx, eax                          # 004e9ed8
    jne.d8 L_004e9ee1                            # 004e9eda
    # block 0x004e9edc: entered by fall-through of jne at 0x004e9eda, 1 instruction(s), ends with forward jump to 0x004ea064
    jmp.d32 L_004ea064                           # 004e9edc
L_004e9ee1:
    # block 0x004e9ee1: entered by jne at 0x004e9eda, 1 instruction(s), ends with backward jump to 0x004e9e9c
    jmp.d8 L_004e9e9c                            # 004e9ee1
L_004e9ee3:
    # block 0x004e9ee3: entered by jge at 0x004e9ec1, 2 instruction(s), ends with je to 0x004e9ef5 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004e9ee3
    je.d8 L_004e9ef5                             # 004e9ee7
    # block 0x004e9ee9: entered by fall-through of je at 0x004e9ee7, 3 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004e9ef5
    push 0x17                                    # 004e9ee9
    mov ecx, 0x5c3a67                            # 004e9eeb
    call FUN_004fb2e3                            # 004e9ef0
L_004e9ef5:
    # block 0x004e9ef5: entered by je at 0x004e9ee7, 5 instruction(s), ends with je to 0x004e9f89 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e9ef5
    {load} xor edx, edx                          # 004e9ef8
    mov dl, byte ptr [ecx + field_7010]          # 004e9efa
    test edx, edx                                # 004e9f00
    je.d32 L_004e9f89                            # 004e9f02
    # block 0x004e9f08: entered by fall-through of je at 0x004e9f02, 3 instruction(s), ends with jne to 0x004e9f89 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e9f08
    cmp dword ptr [eax + field_764c], 0x2        # 004e9f0b
    jne.d8 L_004e9f89                            # 004e9f12
    # block 0x004e9f14: entered by fall-through of jne at 0x004e9f12, 3 instruction(s), ends with forward jump to 0x004e9f38
    mov ecx, dword ptr [ebp - local_4]           # 004e9f14
    mov dword ptr [ecx + field_822e], 0x0        # 004e9f17
    jmp.d8 L_004e9f38                            # 004e9f21
L_004e9f23:
    # block 0x004e9f23: entered by jmp at 0x004e9f6f, 5 instruction(s), falls into the block at 0x004e9f38
    mov edx, dword ptr [ebp - local_4]           # 004e9f23
    mov eax, dword ptr [edx + field_822e]        # 004e9f26
    add eax, 0x1                                 # 004e9f2c
    mov ecx, dword ptr [ebp - local_4]           # 004e9f2f
    mov dword ptr [ecx + field_822e], eax        # 004e9f32
L_004e9f38:
    # block 0x004e9f38: entered by jmp at 0x004e9f21, 4 instruction(s), ends with jge to 0x004e9f71 (forward)
    movsx edx, word ptr [0x583a2b]               # 004e9f38
    mov eax, dword ptr [ebp - local_4]           # 004e9f3f
    cmp dword ptr [eax + field_822e], edx        # 004e9f42
    jge.d8 L_004e9f71                            # 004e9f48
    # block 0x004e9f4a: entered by fall-through of jge at 0x004e9f48, 8 instruction(s), ends with backward jump to 0x004e9f23
    mov ecx, dword ptr [ebp - local_4]           # 004e9f4a
    mov edx, dword ptr [ecx + field_822e]        # 004e9f4d
    mov eax, dword ptr [ebp - local_4]           # 004e9f53
    mov ecx, dword ptr [eax + field_822e]        # 004e9f56
    mov eax, dword ptr [ebp - local_4]           # 004e9f5c
    mov dx, word ptr [2*edx + 0x583a31]          # 004e9f5f
    mov word ptr [eax + 2*ecx + field_828a], dx  # 004e9f67
    jmp.d8 L_004e9f23                            # 004e9f6f
L_004e9f71:
    # block 0x004e9f71: entered by jge at 0x004e9f48, 5 instruction(s), ends with forward jump to 0x004e9ff4
    movsx eax, word ptr [0x583a2b]               # 004e9f71
    mov ecx, dword ptr [ebp - local_4]           # 004e9f78
    mov dx, word ptr [ebp + arg_8]               # 004e9f7b
    mov word ptr [ecx + 2*eax + field_828a], dx  # 004e9f7f
    jmp.d8 L_004e9ff4                            # 004e9f87
L_004e9f89:
    # block 0x004e9f89: entered by je at 0x004e9f02; jne at 0x004e9f12, 3 instruction(s), ends with forward jump to 0x004e9fad
    mov eax, dword ptr [ebp - local_4]           # 004e9f89
    mov dword ptr [eax + field_822e], 0x0        # 004e9f8c
    jmp.d8 L_004e9fad                            # 004e9f96
L_004e9f98:
    # block 0x004e9f98: entered by jmp at 0x004e9fe4, 5 instruction(s), falls into the block at 0x004e9fad
    mov ecx, dword ptr [ebp - local_4]           # 004e9f98
    mov edx, dword ptr [ecx + field_822e]        # 004e9f9b
    add edx, 0x1                                 # 004e9fa1
    mov eax, dword ptr [ebp - local_4]           # 004e9fa4
    mov dword ptr [eax + field_822e], edx        # 004e9fa7
L_004e9fad:
    # block 0x004e9fad: entered by jmp at 0x004e9f96, 4 instruction(s), ends with jge to 0x004e9fe6 (forward)
    movsx ecx, word ptr [0x583a2b]               # 004e9fad
    mov edx, dword ptr [ebp - local_4]           # 004e9fb4
    cmp dword ptr [edx + field_822e], ecx        # 004e9fb7
    jge.d8 L_004e9fe6                            # 004e9fbd
    # block 0x004e9fbf: entered by fall-through of jge at 0x004e9fbd, 8 instruction(s), ends with backward jump to 0x004e9f98
    mov eax, dword ptr [ebp - local_4]           # 004e9fbf
    mov ecx, dword ptr [eax + field_822e]        # 004e9fc2
    mov edx, dword ptr [ebp - local_4]           # 004e9fc8
    mov eax, dword ptr [edx + field_822e]        # 004e9fcb
    mov edx, dword ptr [ebp - local_4]           # 004e9fd1
    mov cx, word ptr [2*ecx + 0x583a31]          # 004e9fd4
    mov word ptr [edx + 2*eax + field_828c], cx  # 004e9fdc
    jmp.d8 L_004e9f98                            # 004e9fe4
L_004e9fe6:
    # block 0x004e9fe6: entered by jge at 0x004e9fbd, 3 instruction(s), falls into the block at 0x004e9ff4
    mov edx, dword ptr [ebp - local_4]           # 004e9fe6
    mov ax, word ptr [ebp + arg_8]               # 004e9fe9
    mov word ptr [edx + field_828a], ax          # 004e9fed
L_004e9ff4:
    # block 0x004e9ff4: entered by jmp at 0x004e9f87, 21 instruction(s), calls FUN_004e812f, ends with je to 0x004ea064 (forward)
    mov cx, word ptr [0x583a2b]                  # 004e9ff4
    add cx, 0x1                                  # 004e9ffb
    mov word ptr [0x583a2b], cx                  # 004e9fff
    movsx ecx, word ptr [0x583a2b]               # 004ea006
    shl ecx                                      # 004ea00d
    mov esi, dword ptr [ebp - local_4]           # 004ea00f
    add esi, 0x828a                              # 004ea012
    mov edi, 0x583a31                            # 004ea018
    {load} mov edx, ecx                          # 004ea01d
    shr ecx, 0x2                                 # 004ea01f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ea022
    {load} mov ecx, edx                          # 004ea024
    and ecx, 0x3                                 # 004ea026
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ea029
    movsx eax, word ptr [ebp + arg_8]            # 004ea02b
    mov dword ptr [4*eax + 0x583bd5], 0x1        # 004ea02f
    mov ecx, dword ptr [ebp - local_4]           # 004ea03a
    call FUN_004e812f                            # 004ea03d
    mov ecx, dword ptr [ebp - local_4]           # 004ea042
    cmp dword ptr [ecx + field_764c], 0x2        # 004ea045
    je.d8 L_004ea064                             # 004ea04c
    # block 0x004ea04e: entered by fall-through of je at 0x004ea04c, 2 instruction(s), ends with je to 0x004ea064 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004ea04e
    je.d8 L_004ea064                             # 004ea052
    # block 0x004ea054: entered by fall-through of je at 0x004ea052, 5 instruction(s), calls FUN_004e0559, falls into the block at 0x004ea064
    push 0x0                                     # 004ea054
    push 0x1                                     # 004ea056
    push 0x1                                     # 004ea058
    mov ecx, 0x570508                            # 004ea05a
    call FUN_004e0559                            # 004ea05f
L_004ea064:
    # block 0x004ea064: entered by jmp at 0x004e9edc; je at 0x004ea04c; je at 0x004ea052, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004ea064
    pop esi                                      # 004ea065
    {load} mov esp, ebp                          # 004ea066
    pop ebp                                      # 004ea068
    ret 0x8                                      # 004ea069

