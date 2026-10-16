# FUN_00516dd7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516dd7
# extent:       0x00516dd7-0x00516e4e (119 code bytes)
# span:         0x00516dd7-0x00516e4e (code 119, tables 0, padding 0)
# sha256:       cd2a33c3555976a74ccb756a2f305909d8d13aeda772dd5ce49decf8ea3ad56f
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516dd7
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [edx + n] field_4, field_c; [esi + n] field_1
# callees:      calls FUN_00511f30, FUN_0050ed50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050ed50, .text + (0x0050ed50 - 0x401000)
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)

.org 0x00516dd7 - 0x401000
.globl FUN_00516dd7
FUN_00516dd7:
    # block 0x00516dd7: entry, 14 instruction(s), ends with jle to 0x00516e14 (forward)
    push ebp                                     # 00516dd7
    {load} mov ebp, esp                          # 00516dd8
    mov edx, dword ptr [ebp + arg_10]            # 00516dda
    push ebx                                     # 00516ddd
    mov ebx, dword ptr [ebp + arg_c]             # 00516dde
    push esi                                     # 00516de1
    mov esi, dword ptr [ebp + arg_8]             # 00516de2
    mov ecx, dword ptr [edx + field_c]           # 00516de5
    push edi                                     # 00516de8
    lea edi, [esi + field_1]                     # 00516de9
    mov byte ptr [esi], 0x30                     # 00516dec
    test ebx, ebx                                # 00516def
    {load} mov eax, edi                          # 00516df1
    jle.d8 L_00516e14                            # 00516df3
    # block 0x00516df5: entered by fall-through of jle at 0x00516df3, 2 instruction(s), falls into the block at 0x00516dfa
    mov dword ptr [ebp + arg_8], ebx             # 00516df5
    {load} xor ebx, ebx                          # 00516df8
L_00516dfa:
    # block 0x00516dfa: entered by jne at 0x00516e0f, 3 instruction(s), ends with je to 0x00516e06 (forward)
    mov dl, byte ptr [ecx]                       # 00516dfa
    test dl, dl                                  # 00516dfc
    je.d8 L_00516e06                             # 00516dfe
    # block 0x00516e00: entered by fall-through of je at 0x00516dfe, 3 instruction(s), ends with forward jump to 0x00516e09
    movsx edx, dl                                # 00516e00
    inc ecx                                      # 00516e03
    jmp.d8 L_00516e09                            # 00516e04
L_00516e06:
    # block 0x00516e06: entered by je at 0x00516dfe, 2 instruction(s), falls into the block at 0x00516e09
    push 0x30                                    # 00516e06
    pop edx                                      # 00516e08
L_00516e09:
    # block 0x00516e09: entered by jmp at 0x00516e04, 4 instruction(s), ends with jne to 0x00516dfa (backward)
    mov byte ptr [eax], dl                       # 00516e09
    inc eax                                      # 00516e0b
    dec dword ptr [ebp + arg_8]                  # 00516e0c
    jne.d8 L_00516dfa                            # 00516e0f
    # block 0x00516e11: entered by fall-through of jne at 0x00516e0f, 1 instruction(s), falls into the block at 0x00516e14
    mov edx, dword ptr [ebp + arg_10]            # 00516e11
L_00516e14:
    # block 0x00516e14: entered by jle at 0x00516df3, 3 instruction(s), ends with jl to 0x00516e2d (forward)
    and byte ptr [eax], 0x0                      # 00516e14
    test ebx, ebx                                # 00516e17
    jl.d8 L_00516e2d                             # 00516e19
    # block 0x00516e1b: entered by fall-through of jl at 0x00516e19, 2 instruction(s), ends with jl to 0x00516e2d (forward)
    cmp byte ptr [ecx], 0x35                     # 00516e1b
    jl.d8 L_00516e2d                             # 00516e1e
L_00516e20:
    # block 0x00516e20: entered by jmp at 0x00516e29; fall-through of jl at 0x00516e1e, 3 instruction(s), ends with jne to 0x00516e2b (forward)
    dec eax                                      # 00516e20
    cmp byte ptr [eax], 0x39                     # 00516e21
    jne.d8 L_00516e2b                            # 00516e24
    # block 0x00516e26: entered by fall-through of jne at 0x00516e24, 2 instruction(s), ends with backward jump to 0x00516e20
    mov byte ptr [eax], 0x30                     # 00516e26
    jmp.d8 L_00516e20                            # 00516e29
L_00516e2b:
    # block 0x00516e2b: entered by jne at 0x00516e24, 1 instruction(s), falls into the block at 0x00516e2d
    inc byte ptr [eax]                           # 00516e2b
L_00516e2d:
    # block 0x00516e2d: entered by jl at 0x00516e19; jl at 0x00516e1e, 2 instruction(s), ends with jne to 0x00516e37 (forward)
    cmp byte ptr [esi], 0x31                     # 00516e2d
    jne.d8 L_00516e37                            # 00516e30
    # block 0x00516e32: entered by fall-through of jne at 0x00516e30, 2 instruction(s), ends with forward jump to 0x00516e49
    inc dword ptr [edx + field_4]                # 00516e32
    jmp.d8 L_00516e49                            # 00516e35
L_00516e37:
    # block 0x00516e37: entered by jne at 0x00516e30, 8 instruction(s), calls FUN_00511f30, FUN_0050ed50, falls into the block at 0x00516e49
    push edi                                     # 00516e37
    call FUN_00511f30                            # 00516e38
    inc eax                                      # 00516e3d
    push eax                                     # 00516e3e
    push edi                                     # 00516e3f
    push esi                                     # 00516e40
    call FUN_0050ed50                            # 00516e41
    add esp, 0x10                                # 00516e46
L_00516e49:
    # block 0x00516e49: entered by jmp at 0x00516e35, 5 instruction(s), ends with ret
    pop edi                                      # 00516e49
    pop esi                                      # 00516e4a
    pop ebx                                      # 00516e4b
    pop ebp                                      # 00516e4c
    ret                                          # 00516e4d

