# FUN_0048cc70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048cc70
# extent:       0x0048cc70-0x0048cf43 (723 code bytes)
# span:         0x0048cc70-0x0048cf50 (code 723, tables 0, padding 13)
# sha256:       54e43fedfd922358cc31763136c4c9cd5d7ce445c8e567fd9bdc53eba6a3f8ce
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48cc70_draw_slots
# naming:       native port src/original_methods_fl20b.c:m48cc70_draw_slots (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m48cc70_draw_slots. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 723 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_54, field_58, field_5c, field_60, field_64, field_b4, field_f4; [ecx + n] field_70, field_74, field_78, field_7c, field_80; [edx + n] field_42, field_68, field_6c
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20b.c:m48cc70_draw_slots (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 201 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ field_42, 0x42  # offset +0x42
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_b4, 0xb4  # offset +0xb4
.equ field_f4, 0xf4  # offset +0xf4

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x0048cc70 - 0x401000
.globl FUN_0048cc70
FUN_0048cc70:
    # block 0x0048cc70: entry, 14 instruction(s), ends with je to 0x0048cf3f (forward)
    push ebp                                     # 0048cc70
    {load} mov ebp, esp                          # 0048cc71
    sub esp, 0x2c                                # 0048cc73
    movsx eax, word ptr [0x6246ac]               # 0048cc76
    imul eax, eax, 0x8d                          # 0048cc7d
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048cc83
    mov dword ptr [ebp - local_2c], ecx          # 0048cc89
    mov edx, dword ptr [ebp - local_2c]          # 0048cc8c
    mov al, byte ptr [edx + field_42]            # 0048cc8f
    mov byte ptr [ebp - local_4], al             # 0048cc92
    {load} xor ecx, ecx                          # 0048cc95
    mov cl, byte ptr [0x6246a3]                  # 0048cc97
    test ecx, ecx                                # 0048cc9d
    je.d32 L_0048cf3f                            # 0048cc9f
    # block 0x0048cca5: entered by fall-through of je at 0x0048cc9f, 40 instruction(s), ends with jne to 0x0048cd90 (forward)
    movsx edx, word ptr [0x6246c9]               # 0048cca5
    mov eax, dword ptr [ebp - local_2c]          # 0048ccac
    mov ecx, dword ptr [eax + field_58]          # 0048ccaf
    {load} add ecx, edx                          # 0048ccb2
    mov dword ptr [ebp - local_10], ecx          # 0048ccb4
    movsx edx, word ptr [0x6246c9]               # 0048ccb7
    mov eax, dword ptr [ebp - local_2c]          # 0048ccbe
    mov ecx, dword ptr [eax + field_60]          # 0048ccc1
    {load} add ecx, edx                          # 0048ccc4
    mov dword ptr [ebp - local_8], ecx           # 0048ccc6
    movsx edx, word ptr [0x6246c7]               # 0048ccc9
    mov eax, dword ptr [ebp - local_2c]          # 0048ccd0
    mov ecx, dword ptr [eax + field_54]          # 0048ccd3
    {load} add ecx, edx                          # 0048ccd6
    mov dword ptr [ebp - local_14], ecx          # 0048ccd8
    movsx edx, word ptr [0x6246c7]               # 0048ccdb
    mov eax, dword ptr [ebp - local_2c]          # 0048cce2
    mov ecx, dword ptr [eax + field_5c]          # 0048cce5
    {load} add ecx, edx                          # 0048cce8
    mov dword ptr [ebp - local_c], ecx           # 0048ccea
    mov edx, dword ptr [ebp - local_2c]          # 0048cced
    mov eax, dword ptr [edx + field_68]          # 0048ccf0
    add eax, dword ptr [0x58318a]                # 0048ccf3
    mov dword ptr [ebp - local_24], eax          # 0048ccf9
    mov ecx, dword ptr [ebp - local_2c]          # 0048ccfc
    mov edx, dword ptr [ecx + field_70]          # 0048ccff
    add edx, dword ptr [0x58318a]                # 0048cd02
    mov dword ptr [ebp - local_1c], edx          # 0048cd08
    mov eax, dword ptr [ebp - local_2c]          # 0048cd0b
    mov ecx, dword ptr [eax + field_64]          # 0048cd0e
    add ecx, dword ptr [0x583186]                # 0048cd11
    mov dword ptr [ebp - local_28], ecx          # 0048cd17
    mov edx, dword ptr [ebp - local_2c]          # 0048cd1a
    mov eax, dword ptr [edx + field_6c]          # 0048cd1d
    add eax, dword ptr [0x583186]                # 0048cd20
    mov dword ptr [ebp - local_20], eax          # 0048cd26
    mov ecx, dword ptr [ebp - local_4]           # 0048cd29
    and ecx, 0xff                                # 0048cd2c
    cmp ecx, 0x2                                 # 0048cd32
    jne.d8 L_0048cd90                            # 0048cd35
    # block 0x0048cd37: entered by fall-through of jne at 0x0048cd35, 26 instruction(s), calls FUN_004c5377, FUN_004c5d4b, ends with forward jump to 0x0048cdbf
    push 0x54e760                                # 0048cd37
    lea edx, [ebp - local_28]                    # 0048cd3c
    push edx                                     # 0048cd3f
    mov eax, dword ptr [ebp - local_2c]          # 0048cd40
    add eax, 0x64                                # 0048cd43
    push eax                                     # 0048cd46
    mov ecx, dword ptr [0x5cf665]                # 0048cd47
    push ecx                                     # 0048cd4d
    mov edx, dword ptr [0x5d15e3]                # 0048cd4e
    push edx                                     # 0048cd54
    mov ecx, 0x5cf659                            # 0048cd55
    call FUN_004c5377                            # 0048cd5a
    push 0x54e778                                # 0048cd5f
    lea eax, [ebp - local_28]                    # 0048cd64
    push eax                                     # 0048cd67
    lea ecx, [ebp - local_14]                    # 0048cd68
    push ecx                                     # 0048cd6b
    mov edx, dword ptr [0x5cf665]                # 0048cd6c
    push edx                                     # 0048cd72
    movsx eax, word ptr [0x6246b4]               # 0048cd73
    imul eax, eax, 0x4a                          # 0048cd7a
    mov ecx, dword ptr [eax + 0x5d1599]          # 0048cd7d
    push ecx                                     # 0048cd83
    mov ecx, 0x5cf659                            # 0048cd84
    call FUN_004c5d4b                            # 0048cd89
    jmp.d8 L_0048cdbf                            # 0048cd8e
L_0048cd90:
    # block 0x0048cd90: entered by jne at 0x0048cd35, 13 instruction(s), calls FUN_004c5377, falls into the block at 0x0048cdbf
    push 0x54e794                                # 0048cd90
    lea edx, [ebp - local_28]                    # 0048cd95
    push edx                                     # 0048cd98
    lea eax, [ebp - local_14]                    # 0048cd99
    push eax                                     # 0048cd9c
    mov ecx, dword ptr [0x5cf665]                # 0048cd9d
    push ecx                                     # 0048cda3
    movsx edx, word ptr [0x6246b4]               # 0048cda4
    imul edx, edx, 0x4a                          # 0048cdab
    mov eax, dword ptr [edx + 0x5d1599]          # 0048cdae
    push eax                                     # 0048cdb4
    mov ecx, 0x5cf659                            # 0048cdb5
    call FUN_004c5377                            # 0048cdba
L_0048cdbf:
    # block 0x0048cdbf: entered by jmp at 0x0048cd8e, 2 instruction(s), ends with forward jump to 0x0048cdd3
    mov word ptr [ebp - local_18], 0x0           # 0048cdbf
    jmp.d8 L_0048cdd3                            # 0048cdc5
L_0048cdc7:
    # block 0x0048cdc7: entered by jmp at 0x0048cf3a, 3 instruction(s), falls into the block at 0x0048cdd3
    mov cx, word ptr [ebp - local_18]            # 0048cdc7
    add cx, 0x1                                  # 0048cdcb
    mov word ptr [ebp - local_18], cx            # 0048cdcf
L_0048cdd3:
    # block 0x0048cdd3: entered by jmp at 0x0048cdc5, 3 instruction(s), ends with jge to 0x0048cf3f (forward)
    movsx edx, word ptr [ebp - local_18]         # 0048cdd3
    cmp edx, 0x4                                 # 0048cdd7
    jge.d32 L_0048cf3f                           # 0048cdda
    # block 0x0048cde0: entered by fall-through of jge at 0x0048cdda, 29 instruction(s), ends with je to 0x0048cea1 (forward)
    movsx eax, word ptr [ebp - local_18]         # 0048cde0
    shl eax, 0x4                                 # 0048cde4
    mov ecx, dword ptr [ebp - local_2c]          # 0048cde7
    mov edx, dword ptr [ecx + eax + field_78]    # 0048cdea
    add edx, dword ptr [0x58318a]                # 0048cdee
    mov dword ptr [ebp - local_24], edx          # 0048cdf4
    movsx eax, word ptr [ebp - local_18]         # 0048cdf7
    shl eax, 0x4                                 # 0048cdfb
    mov ecx, dword ptr [ebp - local_2c]          # 0048cdfe
    mov edx, dword ptr [ecx + eax + field_80]    # 0048ce01
    add edx, dword ptr [0x58318a]                # 0048ce08
    mov dword ptr [ebp - local_1c], edx          # 0048ce0e
    movsx eax, word ptr [ebp - local_18]         # 0048ce11
    shl eax, 0x4                                 # 0048ce15
    mov ecx, dword ptr [ebp - local_2c]          # 0048ce18
    mov edx, dword ptr [ecx + eax + field_74]    # 0048ce1b
    add edx, dword ptr [0x583186]                # 0048ce1f
    mov dword ptr [ebp - local_28], edx          # 0048ce25
    movsx eax, word ptr [ebp - local_18]         # 0048ce28
    shl eax, 0x4                                 # 0048ce2c
    mov ecx, dword ptr [ebp - local_2c]          # 0048ce2f
    mov edx, dword ptr [ecx + eax + field_7c]    # 0048ce32
    add edx, dword ptr [0x583186]                # 0048ce36
    mov dword ptr [ebp - local_20], edx          # 0048ce3c
    movsx eax, word ptr [ebp - local_18]         # 0048ce3f
    {load} xor ecx, ecx                          # 0048ce43
    mov cl, byte ptr [eax + 0x6246be]            # 0048ce45
    test ecx, ecx                                # 0048ce4b
    je.d8 L_0048cea1                             # 0048ce4d
    # block 0x0048ce4f: entered by fall-through of je at 0x0048ce4d, 5 instruction(s), ends with jne to 0x0048cea1 (forward)
    movsx edx, word ptr [ebp - local_18]         # 0048ce4f
    {load} xor eax, eax                          # 0048ce53
    mov al, byte ptr [edx + 0x6246ba]            # 0048ce55
    test eax, eax                                # 0048ce5b
    jne.d8 L_0048cea1                            # 0048ce5d
    # block 0x0048ce5f: entered by fall-through of jne at 0x0048ce5d, 17 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0048cf3a
    push 0x54e7b0                                # 0048ce5f
    lea ecx, [ebp - local_28]                    # 0048ce64
    push ecx                                     # 0048ce67
    movsx edx, word ptr [ebp - local_18]         # 0048ce68
    shl edx, 0x4                                 # 0048ce6c
    mov eax, dword ptr [ebp - local_2c]          # 0048ce6f
    lea ecx, [eax + edx + field_f4]              # 0048ce72
    push ecx                                     # 0048ce79
    mov edx, dword ptr [0x5cf665]                # 0048ce7a
    push edx                                     # 0048ce80
    movsx eax, word ptr [0x6246b6]               # 0048ce81
    imul eax, eax, 0x4a                          # 0048ce88
    mov ecx, dword ptr [eax + 0x5d1599]          # 0048ce8b
    push ecx                                     # 0048ce91
    mov ecx, 0x5cf659                            # 0048ce92
    call FUN_004c5d4b                            # 0048ce97
    jmp.d32 L_0048cf3a                           # 0048ce9c
L_0048cea1:
    # block 0x0048cea1: entered by je at 0x0048ce4d; jne at 0x0048ce5d, 4 instruction(s), ends with je to 0x0048cf0b (forward)
    {load} xor edx, edx                          # 0048cea1
    mov dl, byte ptr [0x6246c6]                  # 0048cea3
    test edx, edx                                # 0048cea9
    je.d8 L_0048cf0b                             # 0048ceab
    # block 0x0048cead: entered by fall-through of je at 0x0048ceab, 5 instruction(s), ends with je to 0x0048cf0b (forward)
    movsx eax, word ptr [ebp - local_18]         # 0048cead
    {load} xor ecx, ecx                          # 0048ceb1
    mov cl, byte ptr [eax + 0x6246c2]            # 0048ceb3
    test ecx, ecx                                # 0048ceb9
    je.d8 L_0048cf0b                             # 0048cebb
    # block 0x0048cebd: entered by fall-through of je at 0x0048cebb, 5 instruction(s), ends with jne to 0x0048cf0b (forward)
    movsx edx, word ptr [ebp - local_18]         # 0048cebd
    {load} xor eax, eax                          # 0048cec1
    mov al, byte ptr [0x6246a2]                  # 0048cec3
    {load} cmp edx, eax                          # 0048cec8
    jne.d8 L_0048cf0b                            # 0048ceca
    # block 0x0048cecc: entered by fall-through of jne at 0x0048ceca, 17 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x0048cf3a
    push 0x54e7cc                                # 0048cecc
    lea ecx, [ebp - local_28]                    # 0048ced1
    push ecx                                     # 0048ced4
    movsx edx, word ptr [ebp - local_18]         # 0048ced5
    shl edx, 0x4                                 # 0048ced9
    mov eax, dword ptr [ebp - local_2c]          # 0048cedc
    lea ecx, [eax + edx + field_b4]              # 0048cedf
    push ecx                                     # 0048cee6
    mov edx, dword ptr [0x5cf665]                # 0048cee7
    push edx                                     # 0048ceed
    movsx eax, word ptr [0x6246b6]               # 0048ceee
    imul eax, eax, 0x4a                          # 0048cef5
    mov ecx, dword ptr [eax + 0x5d1599]          # 0048cef8
    push ecx                                     # 0048cefe
    mov ecx, 0x5cf659                            # 0048ceff
    call FUN_004c5d4b                            # 0048cf04
    jmp.d8 L_0048cf3a                            # 0048cf09
L_0048cf0b:
    # block 0x0048cf0b: entered by je at 0x0048ceab; je at 0x0048cebb; jne at 0x0048ceca, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x0048cf3a
    push 0x54e7e4                                # 0048cf0b
    lea edx, [ebp - local_28]                    # 0048cf10
    push edx                                     # 0048cf13
    movsx eax, word ptr [ebp - local_18]         # 0048cf14
    shl eax, 0x4                                 # 0048cf18
    mov ecx, dword ptr [ebp - local_2c]          # 0048cf1b
    lea edx, [ecx + eax + field_74]              # 0048cf1e
    push edx                                     # 0048cf22
    mov eax, dword ptr [0x5cf665]                # 0048cf23
    push eax                                     # 0048cf28
    mov ecx, dword ptr [0x5d15e3]                # 0048cf29
    push ecx                                     # 0048cf2f
    mov ecx, 0x5cf659                            # 0048cf30
    call FUN_004c5377                            # 0048cf35
L_0048cf3a:
    # block 0x0048cf3a: entered by jmp at 0x0048ce9c; jmp at 0x0048cf09, 1 instruction(s), ends with backward jump to 0x0048cdc7
    jmp.d32 L_0048cdc7                           # 0048cf3a
L_0048cf3f:
    # block 0x0048cf3f: entered by je at 0x0048cc9f; jge at 0x0048cdda, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048cf3f
    pop ebp                                      # 0048cf41
    ret                                          # 0048cf42

# --- data items (not part of the function) -------------------------
.org 0x0048cf43 - 0x401000
PAD_0048cf43:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

