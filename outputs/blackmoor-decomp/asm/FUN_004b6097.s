# FUN_004b6097
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b6097
# extent:       0x004b6097-0x004b617a (227 code bytes)
# span:         0x004b6097-0x004b617a (code 227, tables 0, padding 0)
# sha256:       a0063d1bb7d74e0545e449d4f3adee69828fe57c639d3cb36ac47c9e55edd4d0
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b6097
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edx + n] field_252
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_252, 0x252  # offset +0x252

# --- external targets -----------------------------------------------

.org 0x004b6097 - 0x401000
.globl FUN_004b6097
FUN_004b6097:
    # block 0x004b6097: entry, 7 instruction(s), ends with jne to 0x004b6109 (forward)
    push ebp                                     # 004b6097
    {load} mov ebp, esp                          # 004b6098
    push ecx                                     # 004b609a
    mov dword ptr [ebp - local_4], ecx           # 004b609b
    movsx eax, word ptr [ebp + arg_8]            # 004b609e
    cmp eax, 0x276d                              # 004b60a2
    jne.d8 L_004b6109                            # 004b60a7
    # block 0x004b60a9: entered by fall-through of jne at 0x004b60a7, 15 instruction(s), ends with forward jump to 0x004b6174
    mov dword ptr [0x5b44f0], 0x9                # 004b60a9
    mov dword ptr [0x5b44f4], 0x1                # 004b60b3
    mov ecx, dword ptr [0x5d0377]                # 004b60bd
    mov dword ptr [0x5d162d], ecx                # 004b60c3
    mov edx, dword ptr [0x5b44f0]                # 004b60c9
    shl edx, 0x5                                 # 004b60cf
    mov eax, dword ptr [0x5b44f4]                # 004b60d2
    shl eax, 0x4                                 # 004b60d7
    lea ecx, [edx + eax + 0x5b160c]              # 004b60da
    mov dword ptr [0x5d1631], ecx                # 004b60e1
    mov dword ptr [0x5d1639], 0x1                # 004b60e7
    mov dword ptr [0x5c39e5], 0x276d             # 004b60f1
    mov edx, dword ptr [ebp - local_4]           # 004b60fb
    mov word ptr [edx + field_252], 0xffff       # 004b60fe
    jmp.d8 L_004b6174                            # 004b6107
L_004b6109:
    # block 0x004b6109: entered by jne at 0x004b60a7, 3 instruction(s), ends with jne to 0x004b6174 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004b6109
    cmp eax, 0x276c                              # 004b610d
    jne.d8 L_004b6174                            # 004b6112
    # block 0x004b6114: entered by fall-through of jne at 0x004b6112, 15 instruction(s), falls into the block at 0x004b6174
    mov dword ptr [0x5b44f0], 0x12               # 004b6114
    mov dword ptr [0x5b44f4], 0x1                # 004b611e
    mov ecx, dword ptr [0x5d0377]                # 004b6128
    mov dword ptr [0x5d162d], ecx                # 004b612e
    mov edx, dword ptr [0x5b44f0]                # 004b6134
    shl edx, 0x5                                 # 004b613a
    mov eax, dword ptr [0x5b44f4]                # 004b613d
    shl eax, 0x4                                 # 004b6142
    lea ecx, [edx + eax + 0x5b160c]              # 004b6145
    mov dword ptr [0x5d1631], ecx                # 004b614c
    mov dword ptr [0x5d1639], 0x1                # 004b6152
    mov dword ptr [0x5c39e5], 0x276c             # 004b615c
    mov edx, dword ptr [ebp - local_4]           # 004b6166
    mov ax, word ptr [ebp + arg_c]               # 004b6169
    mov word ptr [edx + field_252], ax           # 004b616d
L_004b6174:
    # block 0x004b6174: entered by jmp at 0x004b6107; jne at 0x004b6112, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004b6174
    pop ebp                                      # 004b6176
    ret 0x8                                      # 004b6177

