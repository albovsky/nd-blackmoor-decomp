# FUN_004a0d73
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a0d73
# extent:       0x004a0d73-0x004a0ec3 (336 code bytes)
# span:         0x004a0d73-0x004a0ec3 (code 336, tables 0, padding 0)
# sha256:       c64e61ce08152de3531d88c71a5e30d2d0b484919ed890398c00d38ff2e3d7ca
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raycast_level_map_validator
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a0d73.c.txt, not original source) refers to the data labelled s_CRayCastLevelBuilder__ValidateMa_00550080, s_CRayCastLevelBuilder__ValidateMa_005500e4
# name-note:    CRayCastLevelBuilder::ValidateMap: scans all cells and reports an error and aborts when a cell is 1 or a layer value is -1.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_1c, field_20
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 94 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004a0d73 - 0x401000
.globl FUN_004a0d73
FUN_004a0d73:
    # block 0x004a0d73: entry, 6 instruction(s), ends with forward jump to 0x004a0d8e
    push ebp                                     # 004a0d73
    {load} mov ebp, esp                          # 004a0d74
    sub esp, 0xc                                 # 004a0d76
    mov dword ptr [ebp - local_c], ecx           # 004a0d79
    mov dword ptr [ebp - local_4], 0x0           # 004a0d7c
    jmp.d8 L_004a0d8e                            # 004a0d83
L_004a0d85:
    # block 0x004a0d85: entered by jmp at 0x004a0eba, 3 instruction(s), falls into the block at 0x004a0d8e
    mov eax, dword ptr [ebp - local_4]           # 004a0d85
    add eax, 0x1                                 # 004a0d88
    mov dword ptr [ebp - local_4], eax           # 004a0d8b
L_004a0d8e:
    # block 0x004a0d8e: entered by jmp at 0x004a0d83, 4 instruction(s), ends with jge to 0x004a0ebf (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004a0d8e
    mov edx, dword ptr [ebp - local_4]           # 004a0d91
    cmp edx, dword ptr [ecx + field_20]          # 004a0d94
    jge.d32 L_004a0ebf                           # 004a0d97
    # block 0x004a0d9d: entered by fall-through of jge at 0x004a0d97, 2 instruction(s), ends with forward jump to 0x004a0daf
    mov dword ptr [ebp - local_8], 0x0           # 004a0d9d
    jmp.d8 L_004a0daf                            # 004a0da4
L_004a0da6:
    # block 0x004a0da6: entered by jmp at 0x004a0eb5, 3 instruction(s), falls into the block at 0x004a0daf
    mov eax, dword ptr [ebp - local_8]           # 004a0da6
    add eax, 0x1                                 # 004a0da9
    mov dword ptr [ebp - local_8], eax           # 004a0dac
L_004a0daf:
    # block 0x004a0daf: entered by jmp at 0x004a0da4, 4 instruction(s), ends with jge to 0x004a0eba (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004a0daf
    mov edx, dword ptr [ebp - local_8]           # 004a0db2
    cmp edx, dword ptr [ecx + field_1c]          # 004a0db5
    jge.d32 L_004a0eba                           # 004a0db8
    # block 0x004a0dbe: entered by fall-through of jge at 0x004a0db8, 7 instruction(s), ends with jne to 0x004a0e0b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a0dbe
    imul eax, eax, 0xa6                          # 004a0dc1
    mov ecx, dword ptr [0x6329e1]                # 004a0dc7
    lea edx, [ecx + 4*eax]                       # 004a0dcd
    mov eax, dword ptr [ebp - local_8]           # 004a0dd0
    cmp dword ptr [edx + 4*eax], 0x1             # 004a0dd3
    jne.d8 L_004a0e0b                            # 004a0dd7
    # block 0x004a0dd9: entered by fall-through of jne at 0x004a0dd7, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004a0e0b
    mov ecx, dword ptr [ebp - local_8]           # 004a0dd9
    push ecx                                     # 004a0ddc
    mov edx, dword ptr [ebp - local_4]           # 004a0ddd
    push edx                                     # 004a0de0
    push 0x550080                                # 004a0de1
    push 0x63888b                                # 004a0de6
    call FUN_0050ca3e                            # 004a0deb
    add esp, 0x10                                # 004a0df0
    push 0x0                                     # 004a0df3
    push 0x0                                     # 004a0df5
    push 0x63888b                                # 004a0df7
    call FUN_0052139c                            # 004a0dfc
    mov ecx, 0x5cf659                            # 004a0e01
    call FUN_004c97b4                            # 004a0e06
L_004a0e0b:
    # block 0x004a0e0b: entered by jne at 0x004a0dd7, 9 instruction(s), ends with jne to 0x004a0e60 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a0e0b
    imul eax, eax, 0xa6                          # 004a0e0e
    mov ecx, dword ptr [0x6329e5]                # 004a0e14
    lea edx, [ecx + 2*eax]                       # 004a0e1a
    mov eax, dword ptr [ebp - local_8]           # 004a0e1d
    {load} xor ecx, ecx                          # 004a0e20
    mov cx, word ptr [edx + 2*eax]               # 004a0e22
    cmp ecx, 0xffff                              # 004a0e26
    jne.d8 L_004a0e60                            # 004a0e2c
    # block 0x004a0e2e: entered by fall-through of jne at 0x004a0e2c, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004a0e60
    mov edx, dword ptr [ebp - local_8]           # 004a0e2e
    push edx                                     # 004a0e31
    mov eax, dword ptr [ebp - local_4]           # 004a0e32
    push eax                                     # 004a0e35
    push 0x5500e4                                # 004a0e36
    push 0x63888b                                # 004a0e3b
    call FUN_0050ca3e                            # 004a0e40
    add esp, 0x10                                # 004a0e45
    push 0x0                                     # 004a0e48
    push 0x0                                     # 004a0e4a
    push 0x63888b                                # 004a0e4c
    call FUN_0052139c                            # 004a0e51
    mov ecx, 0x5cf659                            # 004a0e56
    call FUN_004c97b4                            # 004a0e5b
L_004a0e60:
    # block 0x004a0e60: entered by jne at 0x004a0e2c, 9 instruction(s), ends with jne to 0x004a0eb5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a0e60
    imul ecx, ecx, 0xa6                          # 004a0e63
    mov edx, dword ptr [0x6329e9]                # 004a0e69
    lea eax, [edx + 2*ecx]                       # 004a0e6f
    mov ecx, dword ptr [ebp - local_8]           # 004a0e72
    {load} xor edx, edx                          # 004a0e75
    mov dx, word ptr [eax + 2*ecx]               # 004a0e77
    cmp edx, 0xffff                              # 004a0e7b
    jne.d8 L_004a0eb5                            # 004a0e81
    # block 0x004a0e83: entered by fall-through of jne at 0x004a0e81, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004a0eb5
    mov eax, dword ptr [ebp - local_8]           # 004a0e83
    push eax                                     # 004a0e86
    mov ecx, dword ptr [ebp - local_4]           # 004a0e87
    push ecx                                     # 004a0e8a
    push 0x550148                                # 004a0e8b
    push 0x63888b                                # 004a0e90
    call FUN_0050ca3e                            # 004a0e95
    add esp, 0x10                                # 004a0e9a
    push 0x0                                     # 004a0e9d
    push 0x0                                     # 004a0e9f
    push 0x63888b                                # 004a0ea1
    call FUN_0052139c                            # 004a0ea6
    mov ecx, 0x5cf659                            # 004a0eab
    call FUN_004c97b4                            # 004a0eb0
L_004a0eb5:
    # block 0x004a0eb5: entered by jne at 0x004a0e81, 1 instruction(s), ends with backward jump to 0x004a0da6
    jmp.d32 L_004a0da6                           # 004a0eb5
L_004a0eba:
    # block 0x004a0eba: entered by jge at 0x004a0db8, 1 instruction(s), ends with backward jump to 0x004a0d85
    jmp.d32 L_004a0d85                           # 004a0eba
L_004a0ebf:
    # block 0x004a0ebf: entered by jge at 0x004a0d97, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a0ebf
    pop ebp                                      # 004a0ec1
    ret                                          # 004a0ec2

