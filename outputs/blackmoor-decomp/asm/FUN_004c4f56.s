# FUN_004c4f56
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c4f56
# extent:       0x004c4f56-0x004c500c (182 code bytes)
# span:         0x004c4f56-0x004c500c (code 182, tables 0, padding 0)
# sha256:       4a6b2cd3774ea87b4469d22de4aeda774a31373f256ca3e69f3fc89311a6ee67
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c4f56
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_60, local_68, local_6c
# fields:       [eax + n] field_c, field_14
# callees:      calls FUN_004c4dc3, FUN_004c88c7, FUN_0042639d, FUN_004c952f; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_60, 0x60  # offset -0x60
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c4dc3, .text + (0x004c4dc3 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)

.org 0x004c4f56 - 0x401000
.globl FUN_004c4f56
FUN_004c4f56:
    # block 0x004c4f56: entry, 11 instruction(s), falls into the block at 0x004c4f7a
    push ebp                                     # 004c4f56
    {load} mov ebp, esp                          # 004c4f57
    sub esp, 0x6c                                # 004c4f59
    push edi                                     # 004c4f5c
    mov dword ptr [ebp - local_6c], ecx          # 004c4f5d
    mov ecx, 0x19                                # 004c4f60
    {load} xor eax, eax                          # 004c4f65
    lea edi, [ebp - local_68]                    # 004c4f67
    rep stosd dword ptr es:[edi], eax            # 004c4f6a
    mov dword ptr [ebp - local_68], 0x64         # 004c4f6c
    mov dword ptr [ebp - local_60], 0xcc0020     # 004c4f73
L_004c4f7a:
    # block 0x004c4f7a: entered by jmp at 0x004c4fe9, 3 instruction(s), ends with je to 0x004c4feb (forward)
    mov eax, 0x1                                 # 004c4f7a
    test eax, eax                                # 004c4f7f
    je.d8 L_004c4feb                             # 004c4f81
    # block 0x004c4f83: entered by fall-through of je at 0x004c4f81, 17 instruction(s), calls indirect dword ptr [eax + 0x14], ends with jne to 0x004c4faf (forward)
    lea ecx, [ebp - local_68]                    # 004c4f83
    push ecx                                     # 004c4f86
    push 0x28000                                 # 004c4f87
    mov edx, dword ptr [ebp + arg_10]            # 004c4f8c
    push edx                                     # 004c4f8f
    mov eax, dword ptr [ebp + arg_8]             # 004c4f90
    push eax                                     # 004c4f93
    mov ecx, dword ptr [ebp + arg_14]            # 004c4f94
    push ecx                                     # 004c4f97
    mov edx, dword ptr [ebp + arg_c]             # 004c4f98
    mov eax, dword ptr [edx]                     # 004c4f9b
    mov ecx, dword ptr [ebp + arg_c]             # 004c4f9d
    push ecx                                     # 004c4fa0
    call dword ptr [eax + field_14]              # 004c4fa1
    mov dword ptr [ebp - local_4], eax           # 004c4fa4
    cmp dword ptr [ebp - local_4], 0x0           # 004c4fa7
    jne.d8 L_004c4faf                            # 004c4fab
    # block 0x004c4fad: entered by fall-through of jne at 0x004c4fab, 1 instruction(s), ends with forward jump to 0x004c4feb
    jmp.d8 L_004c4feb                            # 004c4fad
L_004c4faf:
    # block 0x004c4faf: entered by jne at 0x004c4fab, 2 instruction(s), ends with jne to 0x004c4fc2 (forward)
    cmp dword ptr [ebp - local_4], 0x887601c2    # 004c4faf
    jne.d8 L_004c4fc2                            # 004c4fb6
    # block 0x004c4fb8: entered by fall-through of jne at 0x004c4fb6, 3 instruction(s), calls FUN_004c4dc3, ends with forward jump to 0x004c4fe9
    mov ecx, dword ptr [ebp - local_6c]          # 004c4fb8
    call FUN_004c4dc3                            # 004c4fbb
    jmp.d8 L_004c4fe9                            # 004c4fc0
L_004c4fc2:
    # block 0x004c4fc2: entered by jne at 0x004c4fb6, 2 instruction(s), ends with je to 0x004c4fe9 (forward)
    cmp dword ptr [ebp - local_4], 0x8876021c    # 004c4fc2
    je.d8 L_004c4fe9                             # 004c4fc9
    # block 0x004c4fcb: entered by fall-through of je at 0x004c4fc9, 9 instruction(s), calls FUN_004c88c7, FUN_0042639d, ends with forward jump to 0x004c4feb
    mov edx, dword ptr [ebp - local_4]           # 004c4fcb
    push edx                                     # 004c4fce
    mov ecx, dword ptr [ebp - local_6c]          # 004c4fcf
    call FUN_004c88c7                            # 004c4fd2
    push eax                                     # 004c4fd7
    push 0x554768                                # 004c4fd8
    mov ecx, 0x583979                            # 004c4fdd
    call FUN_0042639d                            # 004c4fe2
    jmp.d8 L_004c4feb                            # 004c4fe7
L_004c4fe9:
    # block 0x004c4fe9: entered by jmp at 0x004c4fc0; je at 0x004c4fc9, 1 instruction(s), ends with backward jump to 0x004c4f7a
    jmp.d8 L_004c4f7a                            # 004c4fe9
L_004c4feb:
    # block 0x004c4feb: entered by je at 0x004c4f81; jmp at 0x004c4fad; jmp at 0x004c4fe7, 4 instruction(s), ends with jne to 0x004c5002 (forward)
    mov eax, dword ptr [ebp - local_6c]          # 004c4feb
    mov ecx, dword ptr [ebp + arg_c]             # 004c4fee
    cmp ecx, dword ptr [eax + field_c]           # 004c4ff1
    jne.d8 L_004c5002                            # 004c4ff4
    # block 0x004c4ff6: entered by fall-through of jne at 0x004c4ff4, 4 instruction(s), calls FUN_004c952f, falls into the block at 0x004c5002
    mov edx, dword ptr [ebp + arg_14]            # 004c4ff6
    push edx                                     # 004c4ff9
    mov ecx, dword ptr [ebp - local_6c]          # 004c4ffa
    call FUN_004c952f                            # 004c4ffd
L_004c5002:
    # block 0x004c5002: entered by jne at 0x004c4ff4, 5 instruction(s), ends with ret 0x14
    mov eax, dword ptr [ebp - local_4]           # 004c5002
    pop edi                                      # 004c5005
    {load} mov esp, ebp                          # 004c5006
    pop ebp                                      # 004c5008
    ret 0x14                                     # 004c5009

