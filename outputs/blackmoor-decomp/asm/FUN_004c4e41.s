# FUN_004c4e41
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c4e41
# extent:       0x004c4e41-0x004c4f56 (277 code bytes)
# span:         0x004c4e41-0x004c4f56 (code 277, tables 0, padding 0)
# sha256:       8f3f7de5c88af58ec8002424060daed21953e196f2bc4658f596039c7127bf79
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c4e41
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_60, local_68, local_6c
# fields:       [eax + n] field_c, field_14; [ecx + n] field_4, field_8; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_004c4dc3, FUN_0050ca3e, FUN_004c88c7, FUN_0042639d, FUN_004c97b4, FUN_004c952f; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 95 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_60, 0x60  # offset -0x60
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c4dc3, .text + (0x004c4dc3 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c4e41 - 0x401000
.globl FUN_004c4e41
FUN_004c4e41:
    # block 0x004c4e41: entry, 11 instruction(s), falls into the block at 0x004c4e65
    push ebp                                     # 004c4e41
    {load} mov ebp, esp                          # 004c4e42
    sub esp, 0x6c                                # 004c4e44
    push edi                                     # 004c4e47
    mov dword ptr [ebp - local_6c], ecx          # 004c4e48
    mov ecx, 0x19                                # 004c4e4b
    {load} xor eax, eax                          # 004c4e50
    lea edi, [ebp - local_68]                    # 004c4e52
    rep stosd dword ptr es:[edi], eax            # 004c4e55
    mov dword ptr [ebp - local_68], 0x64         # 004c4e57
    mov dword ptr [ebp - local_60], 0xcc0020     # 004c4e5e
L_004c4e65:
    # block 0x004c4e65: entered by jmp at 0x004c4f33, 3 instruction(s), ends with je to 0x004c4f38 (forward)
    mov eax, 0x1                                 # 004c4e65
    test eax, eax                                # 004c4e6a
    je.d32 L_004c4f38                            # 004c4e6c
    # block 0x004c4e72: entered by fall-through of je at 0x004c4e6c, 17 instruction(s), calls indirect dword ptr [eax + 0x14], ends with jne to 0x004c4ea1 (forward)
    lea ecx, [ebp - local_68]                    # 004c4e72
    push ecx                                     # 004c4e75
    push 0x28000                                 # 004c4e76
    mov edx, dword ptr [ebp + arg_10]            # 004c4e7b
    push edx                                     # 004c4e7e
    mov eax, dword ptr [ebp + arg_8]             # 004c4e7f
    push eax                                     # 004c4e82
    mov ecx, dword ptr [ebp + arg_14]            # 004c4e83
    push ecx                                     # 004c4e86
    mov edx, dword ptr [ebp + arg_c]             # 004c4e87
    mov eax, dword ptr [edx]                     # 004c4e8a
    mov ecx, dword ptr [ebp + arg_c]             # 004c4e8c
    push ecx                                     # 004c4e8f
    call dword ptr [eax + field_14]              # 004c4e90
    mov dword ptr [ebp - local_4], eax           # 004c4e93
    cmp dword ptr [ebp - local_4], 0x0           # 004c4e96
    jne.d8 L_004c4ea1                            # 004c4e9a
    # block 0x004c4e9c: entered by fall-through of jne at 0x004c4e9a, 1 instruction(s), ends with forward jump to 0x004c4f38
    jmp.d32 L_004c4f38                           # 004c4e9c
L_004c4ea1:
    # block 0x004c4ea1: entered by jne at 0x004c4e9a, 2 instruction(s), ends with jne to 0x004c4eb4 (forward)
    cmp dword ptr [ebp - local_4], 0x887601c2    # 004c4ea1
    jne.d8 L_004c4eb4                            # 004c4ea8
    # block 0x004c4eaa: entered by fall-through of jne at 0x004c4ea8, 3 instruction(s), calls FUN_004c4dc3, ends with forward jump to 0x004c4f33
    mov ecx, dword ptr [ebp - local_6c]          # 004c4eaa
    call FUN_004c4dc3                            # 004c4ead
    jmp.d8 L_004c4f33                            # 004c4eb2
L_004c4eb4:
    # block 0x004c4eb4: entered by jne at 0x004c4ea8, 2 instruction(s), ends with je to 0x004c4f33 (forward)
    cmp dword ptr [ebp - local_4], 0x8876021c    # 004c4eb4
    je.d8 L_004c4f33                             # 004c4ebb
    # block 0x004c4ebd: entered by fall-through of je at 0x004c4ebb, 43 instruction(s), calls FUN_0050ca3e, FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c4f4f
    mov edx, dword ptr [ebp + arg_14]            # 004c4ebd
    mov eax, dword ptr [edx + field_8]           # 004c4ec0
    push eax                                     # 004c4ec3
    mov ecx, dword ptr [ebp + arg_14]            # 004c4ec4
    mov edx, dword ptr [ecx]                     # 004c4ec7
    push edx                                     # 004c4ec9
    mov eax, dword ptr [ebp + arg_14]            # 004c4eca
    mov ecx, dword ptr [eax + field_c]           # 004c4ecd
    push ecx                                     # 004c4ed0
    mov edx, dword ptr [ebp + arg_14]            # 004c4ed1
    mov eax, dword ptr [edx + field_4]           # 004c4ed4
    push eax                                     # 004c4ed7
    mov ecx, dword ptr [ebp + arg_10]            # 004c4ed8
    mov edx, dword ptr [ecx + field_8]           # 004c4edb
    push edx                                     # 004c4ede
    mov eax, dword ptr [ebp + arg_10]            # 004c4edf
    mov ecx, dword ptr [eax]                     # 004c4ee2
    push ecx                                     # 004c4ee4
    mov edx, dword ptr [ebp + arg_10]            # 004c4ee5
    mov eax, dword ptr [edx + field_c]           # 004c4ee8
    push eax                                     # 004c4eeb
    mov ecx, dword ptr [ebp + arg_10]            # 004c4eec
    mov edx, dword ptr [ecx + field_4]           # 004c4eef
    push edx                                     # 004c4ef2
    mov eax, dword ptr [ebp + arg_18]            # 004c4ef3
    push eax                                     # 004c4ef6
    mov ecx, dword ptr [ebp - local_4]           # 004c4ef7
    push ecx                                     # 004c4efa
    push 0x5546e4                                # 004c4efb
    push 0x63888b                                # 004c4f00
    call FUN_0050ca3e                            # 004c4f05
    add esp, 0x30                                # 004c4f0a
    mov edx, dword ptr [ebp - local_4]           # 004c4f0d
    push edx                                     # 004c4f10
    mov ecx, dword ptr [ebp - local_6c]          # 004c4f11
    call FUN_004c88c7                            # 004c4f14
    push eax                                     # 004c4f19
    push 0x554750                                # 004c4f1a
    mov ecx, 0x583979                            # 004c4f1f
    call FUN_0042639d                            # 004c4f24
    mov ecx, dword ptr [ebp - local_6c]          # 004c4f29
    call FUN_004c97b4                            # 004c4f2c
    jmp.d8 L_004c4f4f                            # 004c4f31
L_004c4f33:
    # block 0x004c4f33: entered by jmp at 0x004c4eb2; je at 0x004c4ebb, 1 instruction(s), ends with backward jump to 0x004c4e65
    jmp.d32 L_004c4e65                           # 004c4f33
L_004c4f38:
    # block 0x004c4f38: entered by je at 0x004c4e6c; jmp at 0x004c4e9c, 4 instruction(s), ends with jne to 0x004c4f4f (forward)
    mov eax, dword ptr [ebp - local_6c]          # 004c4f38
    mov ecx, dword ptr [ebp + arg_c]             # 004c4f3b
    cmp ecx, dword ptr [eax + field_c]           # 004c4f3e
    jne.d8 L_004c4f4f                            # 004c4f41
    # block 0x004c4f43: entered by fall-through of jne at 0x004c4f41, 4 instruction(s), calls FUN_004c952f, falls into the block at 0x004c4f4f
    mov edx, dword ptr [ebp + arg_14]            # 004c4f43
    push edx                                     # 004c4f46
    mov ecx, dword ptr [ebp - local_6c]          # 004c4f47
    call FUN_004c952f                            # 004c4f4a
L_004c4f4f:
    # block 0x004c4f4f: entered by jmp at 0x004c4f31; jne at 0x004c4f41, 4 instruction(s), ends with ret 0x14
    pop edi                                      # 004c4f4f
    {load} mov esp, ebp                          # 004c4f50
    pop ebp                                      # 004c4f52
    ret 0x14                                     # 004c4f53

