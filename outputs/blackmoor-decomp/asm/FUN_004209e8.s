# FUN_004209e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004209e8
# extent:       0x004209e8-0x00420b9e (438 code bytes)
# span:         0x004209e8-0x00420b9e (code 438, tables 0, padding 0)
# sha256:       bec0cbec20f6d2a627290a5503cf8250ce3edb6aa0e6bb1901b2de836a0df7a7
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4209e8_run_small_entries
# naming:       native port src/original_methods_fl28b.c:m4209e8_run_small_entries (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Runs the 10-byte entries of a record: the 0x420737 gate, kind 1 (debug trace and the dword table store) and kind 2 (two callees by the byte), kind other; every instruction and jump direction covered. See tasks/fl28b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_6, field_7, field_7a1; [ecx + n] field_2, field_7, field_9, field_79f, field_7a1; [edx + n] field_7, field_9, field_7a1
# callees:      calls FUN_00420737, FUN_0050ca3e, FUN_0044a2b7, FUN_004e9e84, FUN_004ea06c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28b.c:m4209e8_run_small_entries (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 119 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_2, 0x2  # offset +0x2
.equ field_6, 0x6  # offset +0x6
.equ field_7, 0x7  # offset +0x7
.equ arg_8, 0x8  # offset +0x8
.equ field_9, 0x9  # offset +0x9
.equ field_79f, 0x79f  # offset +0x79f
.equ field_7a1, 0x7a1  # offset +0x7a1

# --- external targets -----------------------------------------------
.set FUN_00420737, .text + (0x00420737 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004e9e84, .text + (0x004e9e84 - 0x401000)
.set FUN_004ea06c, .text + (0x004ea06c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004209e8 - 0x401000
.globl FUN_004209e8
FUN_004209e8:
    # block 0x004209e8: entry, 10 instruction(s), ends with forward jump to 0x00420a18
    push ebp                                     # 004209e8
    {load} mov ebp, esp                          # 004209e9
    sub esp, 0x10                                # 004209eb
    mov dword ptr [ebp - local_c], ecx           # 004209ee
    movsx eax, word ptr [ebp + arg_8]            # 004209f1
    imul eax, eax, 0x8d                          # 004209f5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004209fb
    mov dword ptr [ebp - local_8], ecx           # 00420a01
    mov word ptr [ebp - local_4], 0x0            # 00420a04
    jmp.d8 L_00420a18                            # 00420a0a
L_00420a0c:
    # block 0x00420a0c: entered by jmp at 0x00420b93, 3 instruction(s), falls into the block at 0x00420a18
    mov dx, word ptr [ebp - local_4]             # 00420a0c
    add dx, 0x1                                  # 00420a10
    mov word ptr [ebp - local_4], dx             # 00420a14
L_00420a18:
    # block 0x00420a18: entered by jmp at 0x00420a0a, 5 instruction(s), ends with jge to 0x00420b98 (forward)
    movsx eax, word ptr [ebp - local_4]          # 00420a18
    mov ecx, dword ptr [ebp - local_8]           # 00420a1c
    movsx edx, word ptr [ecx + field_79f]        # 00420a1f
    {load} cmp eax, edx                          # 00420a26
    jge.d32 L_00420b98                           # 00420a28
    # block 0x00420a2e: entered by fall-through of jge at 0x00420a28, 20 instruction(s), calls FUN_00420737, ends with je to 0x00420b93 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00420a2e
    add eax, 0x7c0                               # 00420a31
    push eax                                     # 00420a36
    movsx ecx, word ptr [ebp - local_4]          # 00420a37
    imul ecx, ecx, 0xa                           # 00420a3b
    mov edx, dword ptr [ebp - local_8]           # 00420a3e
    mov eax, dword ptr [edx + field_7a1]         # 00420a41
    mov cx, word ptr [eax + ecx]                 # 00420a47
    push ecx                                     # 00420a4b
    movsx edx, word ptr [ebp - local_4]          # 00420a4c
    imul edx, edx, 0xa                           # 00420a50
    mov eax, dword ptr [ebp - local_8]           # 00420a53
    mov ecx, dword ptr [eax + field_7a1]         # 00420a56
    mov edx, dword ptr [ecx + edx + field_2]     # 00420a5c
    push edx                                     # 00420a60
    mov ecx, dword ptr [ebp - local_c]           # 00420a61
    call FUN_00420737                            # 00420a64
    movsx eax, ax                                # 00420a69
    test eax, eax                                # 00420a6c
    je.d32 L_00420b93                            # 00420a6e
    # block 0x00420a74: entered by fall-through of je at 0x00420a6e, 8 instruction(s), ends with je to 0x00420aa0 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00420a74
    imul ecx, ecx, 0xa                           # 00420a78
    mov edx, dword ptr [ebp - local_8]           # 00420a7b
    mov eax, dword ptr [edx + field_7a1]         # 00420a7e
    mov cl, byte ptr [eax + ecx + field_6]       # 00420a84
    mov byte ptr [ebp - local_10], cl            # 00420a88
    cmp byte ptr [ebp - local_10], 0x1           # 00420a8b
    je.d8 L_00420aa0                             # 00420a8f
    # block 0x00420a91: entered by fall-through of je at 0x00420a8f, 2 instruction(s), ends with je to 0x00420b34 (forward)
    cmp byte ptr [ebp - local_10], 0x2           # 00420a91
    je.d32 L_00420b34                            # 00420a95
    # block 0x00420a9b: entered by fall-through of je at 0x00420a95, 1 instruction(s), ends with forward jump to 0x00420b93
    jmp.d32 L_00420b93                           # 00420a9b
L_00420aa0:
    # block 0x00420aa0: entered by je at 0x00420a8f, 3 instruction(s), ends with je to 0x00420b00 (forward)
    movsx edx, word ptr [0x63a4cd]               # 00420aa0
    test edx, edx                                # 00420aa7
    je.d8 L_00420b00                             # 00420aa9
    # block 0x00420aab: entered by fall-through of je at 0x00420aa9, 24 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00420b00
    movsx eax, word ptr [ebp - local_4]          # 00420aab
    imul eax, eax, 0xa                           # 00420aaf
    mov ecx, dword ptr [ebp - local_8]           # 00420ab2
    mov edx, dword ptr [ecx + field_7a1]         # 00420ab5
    {load} xor ecx, ecx                          # 00420abb
    mov cl, byte ptr [edx + eax + field_9]       # 00420abd
    push ecx                                     # 00420ac1
    movsx edx, word ptr [ebp - local_4]          # 00420ac2
    imul edx, edx, 0xa                           # 00420ac6
    mov eax, dword ptr [ebp - local_8]           # 00420ac9
    mov ecx, dword ptr [eax + field_7a1]         # 00420acc
    movsx edx, word ptr [ecx + edx + field_7]    # 00420ad2
    push edx                                     # 00420ad7
    push 0x543b34                                # 00420ad8
    mov eax, dword ptr [ebp - local_c]           # 00420add
    add eax, 0x1fd1                              # 00420ae0
    push eax                                     # 00420ae5
    call FUN_0050ca3e                            # 00420ae6
    add esp, 0x10                                # 00420aeb
    mov ecx, dword ptr [ebp - local_c]           # 00420aee
    add ecx, 0x1fd1                              # 00420af1
    push ecx                                     # 00420af7
    call FUN_0044a2b7                            # 00420af8
    add esp, 0x4                                 # 00420afd
L_00420b00:
    # block 0x00420b00: entered by je at 0x00420aa9, 13 instruction(s), ends with forward jump to 0x00420b93
    movsx edx, word ptr [ebp - local_4]          # 00420b00
    imul edx, edx, 0xa                           # 00420b04
    mov eax, dword ptr [ebp - local_8]           # 00420b07
    mov ecx, dword ptr [eax + field_7a1]         # 00420b0a
    {load} xor eax, eax                          # 00420b10
    mov al, byte ptr [ecx + edx + field_9]       # 00420b12
    movsx ecx, word ptr [ebp - local_4]          # 00420b16
    imul ecx, ecx, 0xa                           # 00420b1a
    mov edx, dword ptr [ebp - local_8]           # 00420b1d
    mov edx, dword ptr [edx + field_7a1]         # 00420b20
    movsx ecx, word ptr [edx + ecx + field_7]    # 00420b26
    mov dword ptr [4*ecx + 0x585801], eax        # 00420b2b
    jmp.d8 L_00420b93                            # 00420b32
L_00420b34:
    # block 0x00420b34: entered by je at 0x00420a95, 8 instruction(s), ends with jne to 0x00420b73 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00420b34
    imul edx, edx, 0xa                           # 00420b38
    mov eax, dword ptr [ebp - local_8]           # 00420b3b
    mov ecx, dword ptr [eax + field_7a1]         # 00420b3e
    {load} xor eax, eax                          # 00420b44
    mov al, byte ptr [ecx + edx + field_9]       # 00420b46
    cmp eax, 0x1                                 # 00420b4a
    jne.d8 L_00420b73                            # 00420b4d
    # block 0x00420b4f: entered by fall-through of jne at 0x00420b4d, 10 instruction(s), calls FUN_004e9e84, ends with forward jump to 0x00420b93
    push 0x1                                     # 00420b4f
    movsx ecx, word ptr [ebp - local_4]          # 00420b51
    imul ecx, ecx, 0xa                           # 00420b55
    mov edx, dword ptr [ebp - local_8]           # 00420b58
    mov eax, dword ptr [edx + field_7a1]         # 00420b5b
    mov cx, word ptr [eax + ecx + field_7]       # 00420b61
    push ecx                                     # 00420b66
    mov ecx, 0x571442                            # 00420b67
    call FUN_004e9e84                            # 00420b6c
    jmp.d8 L_00420b93                            # 00420b71
L_00420b73:
    # block 0x00420b73: entered by jne at 0x00420b4d, 8 instruction(s), calls FUN_004ea06c, falls into the block at 0x00420b93
    movsx edx, word ptr [ebp - local_4]          # 00420b73
    imul edx, edx, 0xa                           # 00420b77
    mov eax, dword ptr [ebp - local_8]           # 00420b7a
    mov ecx, dword ptr [eax + field_7a1]         # 00420b7d
    mov dx, word ptr [ecx + edx + field_7]       # 00420b83
    push edx                                     # 00420b88
    mov ecx, 0x571442                            # 00420b89
    call FUN_004ea06c                            # 00420b8e
L_00420b93:
    # block 0x00420b93: entered by je at 0x00420a6e; jmp at 0x00420a9b; jmp at 0x00420b32; jmp at 0x00420b71, 1 instruction(s), ends with backward jump to 0x00420a0c
    jmp.d32 L_00420a0c                           # 00420b93
L_00420b98:
    # block 0x00420b98: entered by jge at 0x00420a28, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00420b98
    pop ebp                                      # 00420b9a
    ret 0x4                                      # 00420b9b

