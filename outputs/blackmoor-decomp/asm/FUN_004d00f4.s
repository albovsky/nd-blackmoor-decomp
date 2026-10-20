# FUN_004d00f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d00f4
# extent:       0x004d00f4-0x004d0275 (385 code bytes)
# span:         0x004d00f4-0x004d0275 (code 385, tables 0, padding 0)
# sha256:       c063634fd3c2ddf91dacb91b59c78fc1e1ac237fbae64da04036fcfe6befa16d
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d00f4_draw_list
# naming:       native port src/original_methods_fl19b.c:m4d00f4_draw_list (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4d00f4_draw_list. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 385 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_21, field_123; [ecx + n] field_127, field_12b; [edx + n] field_23, field_12f
# callees:      calls FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl19b.c:m4d00f4_draw_list (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 89 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_123, 0x123  # offset +0x123
.equ field_127, 0x127  # offset +0x127
.equ field_12b, 0x12b  # offset +0x12b
.equ field_12f, 0x12f  # offset +0x12f

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004d00f4 - 0x401000
.globl FUN_004d00f4
FUN_004d00f4:
    # block 0x004d00f4: entry, 5 instruction(s), ends with forward jump to 0x004d010e
    push ebp                                     # 004d00f4
    {load} mov ebp, esp                          # 004d00f5
    sub esp, 0x14                                # 004d00f7
    mov word ptr [ebp - local_4], 0x0            # 004d00fa
    jmp.d8 L_004d010e                            # 004d0100
L_004d0102:
    # block 0x004d0102: entered by jmp at 0x004d026c, 3 instruction(s), falls into the block at 0x004d010e
    mov ax, word ptr [ebp - local_4]             # 004d0102
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d0106
    mov word ptr [ebp - local_4], ax             # 004d010a
L_004d010e:
    # block 0x004d010e: entered by jmp at 0x004d0100, 7 instruction(s), ends with jge to 0x004d0271 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004d010e
    movsx edx, word ptr [0x5b5159]               # 004d0112
    imul edx, edx, 0x8d                          # 004d0119
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d011f
    movsx edx, word ptr [eax + field_21]         # 004d0125
    {load} cmp ecx, edx                          # 004d0129
    jge.d32 L_004d0271                           # 004d012b
    # block 0x004d0131: entered by fall-through of jge at 0x004d012b, 37 instruction(s), ends with je to 0x004d022a (forward)
    movsx eax, word ptr [0x5b5159]               # 004d0131
    imul eax, eax, 0x8d                          # 004d0138
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d013e
    movsx edx, word ptr [ebp - local_4]          # 004d0144
    shl edx, 0x4                                 # 004d0148
    mov eax, dword ptr [ecx + edx + field_127]   # 004d014b
    add eax, dword ptr [0x58318a]                # 004d0152
    mov dword ptr [ebp - local_10], eax          # 004d0158
    movsx ecx, word ptr [0x5b5159]               # 004d015b
    imul ecx, ecx, 0x8d                          # 004d0162
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004d0168
    movsx eax, word ptr [ebp - local_4]          # 004d016e
    shl eax, 0x4                                 # 004d0172
    mov ecx, dword ptr [edx + eax + field_12f]   # 004d0175
    add ecx, dword ptr [0x58318a]                # 004d017c
    mov dword ptr [ebp - local_8], ecx           # 004d0182
    movsx edx, word ptr [0x5b5159]               # 004d0185
    imul edx, edx, 0x8d                          # 004d018c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0192
    movsx ecx, word ptr [ebp - local_4]          # 004d0198
    shl ecx, 0x4                                 # 004d019c
    mov edx, dword ptr [eax + ecx + field_123]   # 004d019f
    add edx, dword ptr [0x583186]                # 004d01a6
    mov dword ptr [ebp - local_14], edx          # 004d01ac
    movsx eax, word ptr [0x5b5159]               # 004d01af
    imul eax, eax, 0x8d                          # 004d01b6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d01bc
    movsx edx, word ptr [ebp - local_4]          # 004d01c2
    shl edx, 0x4                                 # 004d01c6
    mov eax, dword ptr [ecx + edx + field_12b]   # 004d01c9
    add eax, dword ptr [0x583186]                # 004d01d0
    mov dword ptr [ebp - local_c], eax           # 004d01d6
    movsx ecx, word ptr [ebp - local_4]          # 004d01d9
    {load} xor edx, edx                          # 004d01dd
    mov dl, byte ptr [ecx + 0x5b5128]            # 004d01df
    test edx, edx                                # 004d01e5
    je.d8 L_004d022a                             # 004d01e7
    # block 0x004d01e9: entered by fall-through of je at 0x004d01e7, 17 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d026c
    push 0x559f30                                # 004d01e9
    lea eax, [ebp - local_14]                    # 004d01ee
    push eax                                     # 004d01f1
    movsx ecx, word ptr [0x5b5159]               # 004d01f2
    imul ecx, ecx, 0x8d                          # 004d01f9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004d01ff
    movsx eax, word ptr [ebp - local_4]          # 004d0205
    shl eax, 0x4                                 # 004d0209
    lea ecx, [edx + eax + field_23]              # 004d020c
    push ecx                                     # 004d0210
    mov edx, dword ptr [0x5cf665]                # 004d0211
    push edx                                     # 004d0217
    mov eax, dword ptr [0x5d1a83]                # 004d0218
    push eax                                     # 004d021d
    mov ecx, 0x5cf659                            # 004d021e
    call FUN_004c5377                            # 004d0223
    jmp.d8 L_004d026c                            # 004d0228
L_004d022a:
    # block 0x004d022a: entered by je at 0x004d01e7, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x004d026c
    push 0x559f4c                                # 004d022a
    lea ecx, [ebp - local_14]                    # 004d022f
    push ecx                                     # 004d0232
    movsx edx, word ptr [0x5b5159]               # 004d0233
    imul edx, edx, 0x8d                          # 004d023a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0240
    movsx ecx, word ptr [ebp - local_4]          # 004d0246
    shl ecx, 0x4                                 # 004d024a
    lea edx, [eax + ecx + field_123]             # 004d024d
    push edx                                     # 004d0254
    mov eax, dword ptr [0x5cf665]                # 004d0255
    push eax                                     # 004d025a
    mov ecx, dword ptr [0x5d15e3]                # 004d025b
    push ecx                                     # 004d0261
    mov ecx, 0x5cf659                            # 004d0262
    call FUN_004c5377                            # 004d0267
L_004d026c:
    # block 0x004d026c: entered by jmp at 0x004d0228, 1 instruction(s), ends with backward jump to 0x004d0102
    jmp.d32 L_004d0102                           # 004d026c
L_004d0271:
    # block 0x004d0271: entered by jge at 0x004d012b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d0271
    pop ebp                                      # 004d0273
    ret                                          # 004d0274

