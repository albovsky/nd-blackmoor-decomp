# FUN_00470a73
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470a73
# extent:       0x00470a73-0x00470c52 (479 code bytes)
# span:         0x00470a73-0x00470c60 (code 479, tables 0, padding 14)
# sha256:       f2bda6893951dfbf575b63210b3e6d2f18ebdd9658a10882096394704a07109e
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m470a73_lifted
# naming:       native port src/original_methods_fl40.c:m470a73_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 6 seeds; oracle: 130/130 instructions executed, 8/8 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_20, local_24
# fields:       [eax + n] field_33c; [ecx + n] field_21; [edx + n] field_1bc
# callees:      calls FUN_0046e9c0, FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m470a73_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 130 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_21, 0x21  # offset +0x21
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_33c, 0x33c  # offset +0x33c

# --- external targets -----------------------------------------------
.set FUN_0046e9c0, .text + (0x0046e9c0 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x00470a73 - 0x401000
.globl FUN_00470a73
FUN_00470a73:
    # block 0x00470a73: entry, 15 instruction(s), ends with je to 0x00470b68 (forward)
    push ebp                                     # 00470a73
    {load} mov ebp, esp                          # 00470a74
    sub esp, 0x24                                # 00470a76
    movsx eax, word ptr [0x624c48]               # 00470a79
    imul eax, eax, 0x8d                          # 00470a80
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00470a86
    mov dword ptr [ebp - local_10], ecx          # 00470a8c
    mov edx, dword ptr [ebp - local_10]          # 00470a8f
    add edx, 0x51c                               # 00470a92
    mov dword ptr [ebp - local_24], edx          # 00470a98
    mov eax, dword ptr [ebp - local_10]          # 00470a9b
    add eax, 0x23c                               # 00470a9e
    mov dword ptr [ebp - local_8], eax           # 00470aa3
    cmp dword ptr [0x624c52], 0x0                # 00470aa6
    je.d32 L_00470b68                            # 00470aad
    # block 0x00470ab3: entered by fall-through of je at 0x00470aad, 4 instruction(s), ends with je to 0x00470b19 (forward)
    mov cx, word ptr [0x624c56]                  # 00470ab3
    mov word ptr [ebp - local_4], cx             # 00470aba
    cmp dword ptr [0x624c5c], 0x0                # 00470abe
    je.d8 L_00470b19                             # 00470ac5
    # block 0x00470ac7: entered by fall-through of je at 0x00470ac5, 25 instruction(s), calls FUN_0046e9c0, FUN_004c5377, ends with forward jump to 0x00470b68
    push 0x54c310                                # 00470ac7
    lea edx, [ebp - local_20]                    # 00470acc
    push edx                                     # 00470acf
    movsx eax, word ptr [ebp - local_4]          # 00470ad0
    shl eax, 0x4                                 # 00470ad4
    mov ecx, dword ptr [ebp - local_8]           # 00470ad7
    {load} add ecx, eax                          # 00470ada
    push ecx                                     # 00470adc
    mov ecx, 0x624c2a                            # 00470add
    call FUN_0046e9c0                            # 00470ae2
    push eax                                     # 00470ae7
    movsx edx, word ptr [ebp - local_4]          # 00470ae8
    shl edx, 0x4                                 # 00470aec
    mov eax, dword ptr [ebp - local_24]          # 00470aef
    {load} add eax, edx                          # 00470af2
    push eax                                     # 00470af4
    mov ecx, dword ptr [0x5cf665]                # 00470af5
    push ecx                                     # 00470afb
    movsx edx, word ptr [0x624c46]               # 00470afc
    imul edx, edx, 0x4a                          # 00470b03
    mov eax, dword ptr [edx + 0x5d1599]          # 00470b06
    push eax                                     # 00470b0c
    mov ecx, 0x5cf659                            # 00470b0d
    call FUN_004c5377                            # 00470b12
    jmp.d8 L_00470b68                            # 00470b17
L_00470b19:
    # block 0x00470b19: entered by je at 0x00470ac5, 23 instruction(s), calls FUN_0046e9c0, FUN_004c5377, falls into the block at 0x00470b68
    push 0x54c328                                # 00470b19
    lea ecx, [ebp - local_20]                    # 00470b1e
    push ecx                                     # 00470b21
    movsx edx, word ptr [ebp - local_4]          # 00470b22
    shl edx, 0x4                                 # 00470b26
    mov eax, dword ptr [ebp - local_8]           # 00470b29
    {load} add eax, edx                          # 00470b2c
    push eax                                     # 00470b2e
    mov ecx, 0x624c2a                            # 00470b2f
    call FUN_0046e9c0                            # 00470b34
    push eax                                     # 00470b39
    movsx ecx, word ptr [ebp - local_4]          # 00470b3a
    shl ecx, 0x4                                 # 00470b3e
    mov edx, dword ptr [ebp - local_8]           # 00470b41
    {load} add edx, ecx                          # 00470b44
    push edx                                     # 00470b46
    mov eax, dword ptr [0x5cf665]                # 00470b47
    push eax                                     # 00470b4c
    mov ecx, dword ptr [0x5d15e3]                # 00470b4d
    push ecx                                     # 00470b53
    mov ecx, 0x5cf659                            # 00470b54
    call FUN_004c5377                            # 00470b59
    mov dword ptr [0x624c52], 0x0                # 00470b5e
L_00470b68:
    # block 0x00470b68: entered by je at 0x00470aad; jmp at 0x00470b17, 2 instruction(s), ends with forward jump to 0x00470b7c
    mov word ptr [ebp - local_c], 0x0            # 00470b68
    jmp.d8 L_00470b7c                            # 00470b6e
L_00470b70:
    # block 0x00470b70: entered by jmp at 0x00470bed, 3 instruction(s), falls into the block at 0x00470b7c
    mov dx, word ptr [ebp - local_c]             # 00470b70
    add dx, 0x1                                  # 00470b74
    mov word ptr [ebp - local_c], dx             # 00470b78
L_00470b7c:
    # block 0x00470b7c: entered by jmp at 0x00470b6e, 5 instruction(s), ends with jge to 0x00470bef (forward)
    movsx eax, word ptr [ebp - local_c]          # 00470b7c
    mov ecx, dword ptr [ebp - local_10]          # 00470b80
    movsx edx, word ptr [ecx + field_21]         # 00470b83
    {load} cmp eax, edx                          # 00470b87
    jge.d8 L_00470bef                            # 00470b89
    # block 0x00470b8b: entered by fall-through of jge at 0x00470b89, 26 instruction(s), calls FUN_0046e9c0, FUN_004c5377, ends with backward jump to 0x00470b70
    push 0x54c344                                # 00470b8b
    lea eax, [ebp - local_20]                    # 00470b90
    push eax                                     # 00470b93
    movsx ecx, word ptr [ebp - local_c]          # 00470b94
    shl ecx, 0x4                                 # 00470b98
    mov edx, dword ptr [ebp - local_10]          # 00470b9b
    lea eax, [edx + ecx + field_1bc]             # 00470b9e
    push eax                                     # 00470ba5
    mov ecx, 0x624c2a                            # 00470ba6
    call FUN_0046e9c0                            # 00470bab
    push eax                                     # 00470bb0
    movsx ecx, word ptr [ebp - local_c]          # 00470bb1
    movsx edx, word ptr [2*ecx + 0x624c60]       # 00470bb5
    shl edx, 0x4                                 # 00470bbd
    mov eax, dword ptr [ebp - local_10]          # 00470bc0
    lea ecx, [eax + edx + field_33c]             # 00470bc3
    push ecx                                     # 00470bca
    mov edx, dword ptr [0x5cf665]                # 00470bcb
    push edx                                     # 00470bd1
    movsx eax, word ptr [0x624c46]               # 00470bd2
    imul eax, eax, 0x4a                          # 00470bd9
    mov ecx, dword ptr [eax + 0x5d1599]          # 00470bdc
    push ecx                                     # 00470be2
    mov ecx, 0x5cf659                            # 00470be3
    call FUN_004c5377                            # 00470be8
    jmp.d8 L_00470b70                            # 00470bed
L_00470bef:
    # block 0x00470bef: entered by jge at 0x00470b89, 4 instruction(s), ends with jne to 0x00470c4e (forward)
    movsx edx, word ptr [0x624c48]               # 00470bef
    imul edx, edx, 0x8d                          # 00470bf6
    cmp dword ptr [edx + 0x5bb632], 0x2          # 00470bfc
    jne.d8 L_00470c4e                            # 00470c03
    # block 0x00470c05: entered by fall-through of jne at 0x00470c03, 20 instruction(s), calls FUN_0046e9c0, FUN_004c5377, falls into the block at 0x00470c4e
    push 0x54c360                                # 00470c05
    lea eax, [ebp - local_20]                    # 00470c0a
    push eax                                     # 00470c0d
    mov ecx, dword ptr [ebp - local_10]          # 00470c0e
    add ecx, 0xf23                               # 00470c11
    push ecx                                     # 00470c17
    mov ecx, 0x624c2a                            # 00470c18
    call FUN_0046e9c0                            # 00470c1d
    push eax                                     # 00470c22
    mov edx, dword ptr [ebp - local_10]          # 00470c23
    add edx, 0xf33                               # 00470c26
    push edx                                     # 00470c2c
    mov eax, dword ptr [0x5cf665]                # 00470c2d
    push eax                                     # 00470c32
    movsx ecx, word ptr [0x624c46]               # 00470c33
    imul ecx, ecx, 0x4a                          # 00470c3a
    mov edx, dword ptr [ecx + 0x5d1599]          # 00470c3d
    push edx                                     # 00470c43
    mov ecx, 0x5cf659                            # 00470c44
    call FUN_004c5377                            # 00470c49
L_00470c4e:
    # block 0x00470c4e: entered by jne at 0x00470c03, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00470c4e
    pop ebp                                      # 00470c50
    ret                                          # 00470c51

# --- data items (not part of the function) -------------------------
.org 0x00470c52 - 0x401000
PAD_00470c52:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

