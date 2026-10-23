# FUN_004e2b99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2b99
# extent:       0x004e2b99-0x004e2ca8 (271 code bytes)
# span:         0x004e2b99-0x004e2cb0 (code 271, tables 0, padding 8)
# sha256:       8be99cbae32911990edbc59a14bfa2b5c880fafa242362a40bc78a8343285f7b
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e2b99
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_24, field_30, field_127, field_177; [ecx + n] field_28, field_30, field_34; [edx + n] field_24, field_30, field_34, field_127, field_133, field_177; [esi + n] field_12b
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 85 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_127, 0x127  # offset +0x127
.equ field_12b, 0x12b  # offset +0x12b
.equ field_133, 0x133  # offset +0x133
.equ field_177, 0x177  # offset +0x177

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004e2b99 - 0x401000
.globl FUN_004e2b99
FUN_004e2b99:
    # block 0x004e2b99: entry, 8 instruction(s), ends with jne to 0x004e2baf (forward)
    push ebp                                     # 004e2b99
    {load} mov ebp, esp                          # 004e2b9a
    push ecx                                     # 004e2b9c
    push esi                                     # 004e2b9d
    mov dword ptr [ebp - local_4], ecx           # 004e2b9e
    mov eax, dword ptr [ebp - local_4]           # 004e2ba1
    cmp dword ptr [eax + field_30], 0x4          # 004e2ba4
    jne.d8 L_004e2baf                            # 004e2ba8
    # block 0x004e2baa: entered by fall-through of jne at 0x004e2ba8, 1 instruction(s), ends with forward jump to 0x004e2ca3
    jmp.d32 L_004e2ca3                           # 004e2baa
L_004e2baf:
    # block 0x004e2baf: entered by jne at 0x004e2ba8, 3 instruction(s), ends with je to 0x004e2bc4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e2baf
    cmp dword ptr [ecx + field_34], 0x1          # 004e2bb2
    je.d8 L_004e2bc4                             # 004e2bb6
    # block 0x004e2bb8: entered by fall-through of je at 0x004e2bb6, 3 instruction(s), ends with je to 0x004e2bfe (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e2bb8
    cmp dword ptr [edx + field_177], 0x0         # 004e2bbb
    je.d8 L_004e2bfe                             # 004e2bc2
L_004e2bc4:
    # block 0x004e2bc4: entered by je at 0x004e2bb6; fall-through of je at 0x004e2bc2, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x004e2bfe
    mov eax, dword ptr [ebp - local_4]           # 004e2bc4
    mov dword ptr [eax + field_177], 0x0         # 004e2bc7
    push 0x55bfb8                                # 004e2bd1
    mov ecx, dword ptr [ebp - local_4]           # 004e2bd6
    add ecx, 0x4                                 # 004e2bd9
    push ecx                                     # 004e2bdc
    mov edx, dword ptr [ebp - local_4]           # 004e2bdd
    add edx, 0xbe                                # 004e2be0
    push edx                                     # 004e2be6
    mov eax, dword ptr [0x5cf665]                # 004e2be7
    push eax                                     # 004e2bec
    mov ecx, dword ptr [ebp - local_4]           # 004e2bed
    mov edx, dword ptr [ecx + field_28]          # 004e2bf0
    push edx                                     # 004e2bf3
    mov ecx, 0x5cf659                            # 004e2bf4
    call FUN_004c5377                            # 004e2bf9
L_004e2bfe:
    # block 0x004e2bfe: entered by je at 0x004e2bc2, 12 instruction(s), ends with je to 0x004e2ca3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e2bfe
    mov ecx, dword ptr [eax + field_30]          # 004e2c01
    shl ecx, 0x4                                 # 004e2c04
    mov edx, dword ptr [ebp - local_4]           # 004e2c07
    mov eax, dword ptr [edx + field_30]          # 004e2c0a
    shl eax, 0x4                                 # 004e2c0d
    mov edx, dword ptr [ebp - local_4]           # 004e2c10
    mov esi, dword ptr [ebp - local_4]           # 004e2c13
    mov ecx, dword ptr [edx + ecx + field_133]   # 004e2c16
    sub ecx, dword ptr [esi + eax + field_12b]   # 004e2c1d
    test ecx, ecx                                # 004e2c24
    je.d8 L_004e2ca3                             # 004e2c26
    # block 0x004e2c28: entered by fall-through of je at 0x004e2c26, 3 instruction(s), ends with jne to 0x004e2c6b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e2c28
    cmp dword ptr [edx + field_34], 0x1          # 004e2c2b
    jne.d8 L_004e2c6b                            # 004e2c2f
    # block 0x004e2c31: entered by fall-through of jne at 0x004e2c2f, 18 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004e2ca3
    push 0x55bfcc                                # 004e2c31
    mov eax, dword ptr [ebp - local_4]           # 004e2c36
    add eax, 0x4                                 # 004e2c39
    push eax                                     # 004e2c3c
    mov ecx, dword ptr [ebp - local_4]           # 004e2c3d
    mov edx, dword ptr [ecx + field_30]          # 004e2c40
    shl edx, 0x4                                 # 004e2c43
    mov eax, dword ptr [ebp - local_4]           # 004e2c46
    lea ecx, [eax + edx + field_127]             # 004e2c49
    push ecx                                     # 004e2c50
    mov edx, dword ptr [0x5cf665]                # 004e2c51
    push edx                                     # 004e2c57
    mov eax, dword ptr [ebp - local_4]           # 004e2c58
    mov ecx, dword ptr [eax + field_24]          # 004e2c5b
    push ecx                                     # 004e2c5e
    mov ecx, 0x5cf659                            # 004e2c5f
    call FUN_004c5d4b                            # 004e2c64
    jmp.d8 L_004e2ca3                            # 004e2c69
L_004e2c6b:
    # block 0x004e2c6b: entered by jne at 0x004e2c2f, 17 instruction(s), calls FUN_004c5377, falls into the block at 0x004e2ca3
    push 0x55bfec                                # 004e2c6b
    mov edx, dword ptr [ebp - local_4]           # 004e2c70
    add edx, 0x4                                 # 004e2c73
    push edx                                     # 004e2c76
    mov eax, dword ptr [ebp - local_4]           # 004e2c77
    mov ecx, dword ptr [eax + field_30]          # 004e2c7a
    shl ecx, 0x4                                 # 004e2c7d
    mov edx, dword ptr [ebp - local_4]           # 004e2c80
    lea eax, [edx + ecx + field_127]             # 004e2c83
    push eax                                     # 004e2c8a
    mov ecx, dword ptr [0x5cf665]                # 004e2c8b
    push ecx                                     # 004e2c91
    mov edx, dword ptr [ebp - local_4]           # 004e2c92
    mov eax, dword ptr [edx + field_24]          # 004e2c95
    push eax                                     # 004e2c98
    mov ecx, 0x5cf659                            # 004e2c99
    call FUN_004c5377                            # 004e2c9e
L_004e2ca3:
    # block 0x004e2ca3: entered by jmp at 0x004e2baa; je at 0x004e2c26; jmp at 0x004e2c69, 4 instruction(s), ends with ret
    pop esi                                      # 004e2ca3
    {load} mov esp, ebp                          # 004e2ca4
    pop ebp                                      # 004e2ca6
    ret                                          # 004e2ca7

# --- data items (not part of the function) -------------------------
.org 0x004e2ca8 - 0x401000
PAD_004e2ca8:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

