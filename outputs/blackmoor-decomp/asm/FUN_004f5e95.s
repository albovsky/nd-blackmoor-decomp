# FUN_004f5e95
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f5e95
# extent:       0x004f5e95-0x004f5f69 (212 code bytes)
# span:         0x004f5e95-0x004f5f69 (code 212, tables 0, padding 0)
# sha256:       114a8e31236cb37840f8b90846478e99b2aa0e06b2ae0f239727b3f443b1f4fd
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f5e95
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2c, field_3ca; [ecx + n] field_4, field_18; [edx + n] field_50, field_3ca
# callees:      none direct; 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 79 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18
.equ field_2c, 0x2c  # offset +0x2c
.equ field_50, 0x50  # offset +0x50
.equ field_3ca, 0x3ca  # offset +0x3ca

# --- external targets -----------------------------------------------

.org 0x004f5e95 - 0x401000
.globl FUN_004f5e95
FUN_004f5e95:
    # block 0x004f5e95: entry, 37 instruction(s), calls indirect dword ptr [eax + 0x2c], ends with jne to 0x004f5f4e (forward)
    push ebp                                     # 004f5e95
    {load} mov ebp, esp                          # 004f5e96
    push ecx                                     # 004f5e98
    mov dword ptr [ebp - local_4], ecx           # 004f5e99
    mov eax, dword ptr [ebp - local_4]           # 004f5e9c
    mov dword ptr [eax + field_3ca], 0x0         # 004f5e9f
    mov ecx, dword ptr [ebp + arg_c]             # 004f5ea9
    mov edx, dword ptr [ecx + field_18]          # 004f5eac
    push edx                                     # 004f5eaf
    mov eax, dword ptr [ebp + arg_c]             # 004f5eb0
    add eax, 0x14                                # 004f5eb3
    push eax                                     # 004f5eb6
    mov ecx, dword ptr [ebp + arg_c]             # 004f5eb7
    add ecx, 0x10                                # 004f5eba
    push ecx                                     # 004f5ebd
    mov edx, dword ptr [ebp + arg_c]             # 004f5ebe
    add edx, 0xc                                 # 004f5ec1
    push edx                                     # 004f5ec4
    mov eax, dword ptr [ebp + arg_c]             # 004f5ec5
    add eax, 0x8                                 # 004f5ec8
    push eax                                     # 004f5ecb
    mov ecx, dword ptr [ebp + arg_c]             # 004f5ecc
    mov edx, dword ptr [ecx + field_4]           # 004f5ecf
    push edx                                     # 004f5ed2
    mov eax, dword ptr [ebp + arg_c]             # 004f5ed3
    mov ecx, dword ptr [eax]                     # 004f5ed6
    push ecx                                     # 004f5ed8
    mov edx, dword ptr [ebp + arg_8]             # 004f5ed9
    mov eax, dword ptr [edx]                     # 004f5edc
    mov ecx, dword ptr [ebp + arg_8]             # 004f5ede
    push ecx                                     # 004f5ee1
    call dword ptr [eax + field_2c]              # 004f5ee2
    mov edx, dword ptr [ebp - local_4]           # 004f5ee5
    mov dword ptr [edx + field_3ca], eax         # 004f5ee8
    mov eax, dword ptr [ebp - local_4]           # 004f5eee
    cmp dword ptr [eax + field_3ca], 0x88780096  # 004f5ef1
    jne.d8 L_004f5f4e                            # 004f5efb
    # block 0x004f5efd: entered by fall-through of jne at 0x004f5efb, 33 instruction(s), calls indirect dword ptr [edx + 0x50], indirect dword ptr [eax + 0x2c], falls into the block at 0x004f5f4e
    mov ecx, dword ptr [ebp + arg_8]             # 004f5efd
    mov edx, dword ptr [ecx]                     # 004f5f00
    mov eax, dword ptr [ebp + arg_8]             # 004f5f02
    push eax                                     # 004f5f05
    call dword ptr [edx + field_50]              # 004f5f06
    mov ecx, dword ptr [ebp + arg_c]             # 004f5f09
    mov edx, dword ptr [ecx + field_18]          # 004f5f0c
    push edx                                     # 004f5f0f
    mov eax, dword ptr [ebp + arg_c]             # 004f5f10
    add eax, 0x14                                # 004f5f13
    push eax                                     # 004f5f16
    mov ecx, dword ptr [ebp + arg_c]             # 004f5f17
    add ecx, 0x10                                # 004f5f1a
    push ecx                                     # 004f5f1d
    mov edx, dword ptr [ebp + arg_c]             # 004f5f1e
    add edx, 0xc                                 # 004f5f21
    push edx                                     # 004f5f24
    mov eax, dword ptr [ebp + arg_c]             # 004f5f25
    add eax, 0x8                                 # 004f5f28
    push eax                                     # 004f5f2b
    mov ecx, dword ptr [ebp + arg_c]             # 004f5f2c
    mov edx, dword ptr [ecx + field_4]           # 004f5f2f
    push edx                                     # 004f5f32
    mov eax, dword ptr [ebp + arg_c]             # 004f5f33
    mov ecx, dword ptr [eax]                     # 004f5f36
    push ecx                                     # 004f5f38
    mov edx, dword ptr [ebp + arg_8]             # 004f5f39
    mov eax, dword ptr [edx]                     # 004f5f3c
    mov ecx, dword ptr [ebp + arg_8]             # 004f5f3e
    push ecx                                     # 004f5f41
    call dword ptr [eax + field_2c]              # 004f5f42
    mov edx, dword ptr [ebp - local_4]           # 004f5f45
    mov dword ptr [edx + field_3ca], eax         # 004f5f48
L_004f5f4e:
    # block 0x004f5f4e: entered by jne at 0x004f5efb, 3 instruction(s), ends with jne to 0x004f5f61 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f5f4e
    cmp dword ptr [eax + field_3ca], 0x0         # 004f5f51
    jne.d8 L_004f5f61                            # 004f5f58
    # block 0x004f5f5a: entered by fall-through of jne at 0x004f5f58, 2 instruction(s), ends with forward jump to 0x004f5f63
    mov eax, 0x1                                 # 004f5f5a
    jmp.d8 L_004f5f63                            # 004f5f5f
L_004f5f61:
    # block 0x004f5f61: entered by jne at 0x004f5f58, 1 instruction(s), falls into the block at 0x004f5f63
    {load} xor eax, eax                          # 004f5f61
L_004f5f63:
    # block 0x004f5f63: entered by jmp at 0x004f5f5f, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f5f63
    pop ebp                                      # 004f5f65
    ret 0x8                                      # 004f5f66

