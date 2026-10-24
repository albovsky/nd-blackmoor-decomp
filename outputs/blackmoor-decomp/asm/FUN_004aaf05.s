# FUN_004aaf05
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004aaf05
# extent:       0x004aaf05-0x004ab289 (900 code bytes)
# span:         0x004aaf05-0x004ab290 (code 900, tables 0, padding 7)
# sha256:       deffe50460172c1a743f3b8ddae331691efb0cc9b983b3159e2f2f84f4c07163
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4aaf05_lifted
# naming:       native port src/original_methods_fl41.c:m4aaf05_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 8 seeds; oracle: 198/198 instructions, 12/12 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_f7, field_f9, field_245; [ecx + n] field_109, field_10d, field_111, field_115, field_245, field_249, field_24d, field_251; [edx + n] field_109, field_10d, field_111, field_115, field_235, field_245, field_249, field_24d, field_251
# callees:      calls FUN_004c5d4b, FUN_004c5377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4aaf05_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 198 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_f7, 0xf7  # offset +0xf7
.equ field_f9, 0xf9  # offset +0xf9
.equ field_109, 0x109  # offset +0x109
.equ field_10d, 0x10d  # offset +0x10d
.equ field_111, 0x111  # offset +0x111
.equ field_115, 0x115  # offset +0x115
.equ field_235, 0x235  # offset +0x235
.equ field_245, 0x245  # offset +0x245
.equ field_249, 0x249  # offset +0x249
.equ field_24d, 0x24d  # offset +0x24d
.equ field_251, 0x251  # offset +0x251

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004aaf05 - 0x401000
.globl FUN_004aaf05
FUN_004aaf05:
    # block 0x004aaf05: entry, 11 instruction(s), ends with je to 0x004ab285 (forward)
    push ebp                                     # 004aaf05
    {load} mov ebp, esp                          # 004aaf06
    sub esp, 0x18                                # 004aaf08
    movsx eax, word ptr [0x630a55]               # 004aaf0b
    imul eax, eax, 0x8d                          # 004aaf12
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004aaf18
    mov dword ptr [ebp - local_18], ecx          # 004aaf1e
    {load} xor edx, edx                          # 004aaf21
    mov dl, byte ptr [0x630a50]                  # 004aaf23
    test edx, edx                                # 004aaf29
    je.d32 L_004ab285                            # 004aaf2b
    # block 0x004aaf31: entered by fall-through of je at 0x004aaf2b, 2 instruction(s), ends with jne to 0x004ab001 (forward)
    cmp dword ptr [0x630a59], 0x2                # 004aaf31
    jne.d32 L_004ab001                           # 004aaf38
    # block 0x004aaf3e: entered by fall-through of jne at 0x004aaf38, 40 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004ab001
    movsx eax, word ptr [0x630a76]               # 004aaf3e
    imul eax, eax, 0x15c                         # 004aaf45
    mov ecx, dword ptr [ebp - local_18]          # 004aaf4b
    mov edx, dword ptr [ecx + eax + field_249]   # 004aaf4e
    add edx, dword ptr [0x58318a]                # 004aaf55
    mov dword ptr [ebp - local_10], edx          # 004aaf5b
    movsx eax, word ptr [0x630a76]               # 004aaf5e
    imul eax, eax, 0x15c                         # 004aaf65
    mov ecx, dword ptr [ebp - local_18]          # 004aaf6b
    mov edx, dword ptr [ecx + eax + field_251]   # 004aaf6e
    add edx, dword ptr [0x58318a]                # 004aaf75
    mov dword ptr [ebp - local_8], edx           # 004aaf7b
    movsx eax, word ptr [0x630a76]               # 004aaf7e
    imul eax, eax, 0x15c                         # 004aaf85
    mov ecx, dword ptr [ebp - local_18]          # 004aaf8b
    mov edx, dword ptr [ecx + eax + field_245]   # 004aaf8e
    add edx, dword ptr [0x583186]                # 004aaf95
    mov dword ptr [ebp - local_14], edx          # 004aaf9b
    movsx eax, word ptr [0x630a76]               # 004aaf9e
    imul eax, eax, 0x15c                         # 004aafa5
    mov ecx, dword ptr [ebp - local_18]          # 004aafab
    mov edx, dword ptr [ecx + eax + field_24d]   # 004aafae
    add edx, dword ptr [0x583186]                # 004aafb5
    mov dword ptr [ebp - local_c], edx           # 004aafbb
    push 0x550ed8                                # 004aafbe
    lea eax, [ebp - local_14]                    # 004aafc3
    push eax                                     # 004aafc6
    movsx ecx, word ptr [0x630a76]               # 004aafc7
    imul ecx, ecx, 0x15c                         # 004aafce
    mov edx, dword ptr [ebp - local_18]          # 004aafd4
    lea eax, [edx + ecx + field_235]             # 004aafd7
    push eax                                     # 004aafde
    mov ecx, dword ptr [0x5cf665]                # 004aafdf
    push ecx                                     # 004aafe5
    movsx edx, word ptr [0x630a5d]               # 004aafe6
    imul edx, edx, 0x4a                          # 004aafed
    mov eax, dword ptr [edx + 0x5d1599]          # 004aaff0
    push eax                                     # 004aaff6
    mov ecx, 0x5cf659                            # 004aaff7
    call FUN_004c5d4b                            # 004aaffc
L_004ab001:
    # block 0x004ab001: entered by jne at 0x004aaf38, 2 instruction(s), ends with forward jump to 0x004ab015
    mov word ptr [ebp - local_4], 0x0            # 004ab001
    jmp.d8 L_004ab015                            # 004ab007
L_004ab009:
    # block 0x004ab009: entered by jmp at 0x004ab1b2, 3 instruction(s), falls into the block at 0x004ab015
    mov cx, word ptr [ebp - local_4]             # 004ab009
    add cx, 0x1                                  # 004ab00d
    mov word ptr [ebp - local_4], cx             # 004ab011
L_004ab015:
    # block 0x004ab015: entered by jmp at 0x004ab007, 5 instruction(s), ends with jge to 0x004ab1b7 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004ab015
    mov eax, dword ptr [ebp - local_18]          # 004ab019
    movsx ecx, word ptr [eax + field_f7]         # 004ab01c
    {load} cmp edx, ecx                          # 004ab023
    jge.d32 L_004ab1b7                           # 004ab025
    # block 0x004ab02b: entered by fall-through of jge at 0x004ab025, 5 instruction(s), ends with je to 0x004ab0f8 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004ab02b
    {load} xor eax, eax                          # 004ab02f
    mov al, byte ptr [edx + 0x630a60]            # 004ab031
    test eax, eax                                # 004ab037
    je.d32 L_004ab0f8                            # 004ab039
    # block 0x004ab03f: entered by fall-through of je at 0x004ab039, 41 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004ab1b2
    movsx ecx, word ptr [ebp - local_4]          # 004ab03f
    imul ecx, ecx, 0x15c                         # 004ab043
    mov edx, dword ptr [ebp - local_18]          # 004ab049
    mov eax, dword ptr [edx + ecx + field_10d]   # 004ab04c
    add eax, dword ptr [0x58318a]                # 004ab053
    mov dword ptr [ebp - local_10], eax          # 004ab059
    movsx ecx, word ptr [ebp - local_4]          # 004ab05c
    imul ecx, ecx, 0x15c                         # 004ab060
    mov edx, dword ptr [ebp - local_18]          # 004ab066
    mov eax, dword ptr [edx + ecx + field_115]   # 004ab069
    add eax, dword ptr [0x58318a]                # 004ab070
    mov dword ptr [ebp - local_8], eax           # 004ab076
    movsx ecx, word ptr [ebp - local_4]          # 004ab079
    imul ecx, ecx, 0x15c                         # 004ab07d
    mov edx, dword ptr [ebp - local_18]          # 004ab083
    mov eax, dword ptr [edx + ecx + field_109]   # 004ab086
    add eax, dword ptr [0x583186]                # 004ab08d
    mov dword ptr [ebp - local_14], eax          # 004ab093
    movsx ecx, word ptr [ebp - local_4]          # 004ab096
    imul ecx, ecx, 0x15c                         # 004ab09a
    mov edx, dword ptr [ebp - local_18]          # 004ab0a0
    mov eax, dword ptr [edx + ecx + field_111]   # 004ab0a3
    add eax, dword ptr [0x583186]                # 004ab0aa
    mov dword ptr [ebp - local_c], eax           # 004ab0b0
    push 0x550eec                                # 004ab0b3
    lea ecx, [ebp - local_14]                    # 004ab0b8
    push ecx                                     # 004ab0bb
    movsx edx, word ptr [ebp - local_4]          # 004ab0bc
    imul edx, edx, 0x15c                         # 004ab0c0
    mov eax, dword ptr [ebp - local_18]          # 004ab0c6
    lea ecx, [eax + edx + field_f9]              # 004ab0c9
    push ecx                                     # 004ab0d0
    mov edx, dword ptr [0x5cf665]                # 004ab0d1
    push edx                                     # 004ab0d7
    movsx eax, word ptr [0x630a5d]               # 004ab0d8
    imul eax, eax, 0x4a                          # 004ab0df
    mov ecx, dword ptr [eax + 0x5d1599]          # 004ab0e2
    push ecx                                     # 004ab0e8
    mov ecx, 0x5cf659                            # 004ab0e9
    call FUN_004c5d4b                            # 004ab0ee
    jmp.d32 L_004ab1b2                           # 004ab0f3
L_004ab0f8:
    # block 0x004ab0f8: entered by je at 0x004ab039, 4 instruction(s), ends with je to 0x004ab1b2 (forward)
    {load} xor edx, edx                          # 004ab0f8
    mov dl, byte ptr [0x630a78]                  # 004ab0fa
    test edx, edx                                # 004ab100
    je.d32 L_004ab1b2                            # 004ab102
    # block 0x004ab108: entered by fall-through of je at 0x004ab102, 38 instruction(s), calls FUN_004c5377, falls into the block at 0x004ab1b2
    movsx eax, word ptr [ebp - local_4]          # 004ab108
    imul eax, eax, 0x15c                         # 004ab10c
    mov ecx, dword ptr [ebp - local_18]          # 004ab112
    mov edx, dword ptr [ecx + eax + field_10d]   # 004ab115
    add edx, dword ptr [0x58318a]                # 004ab11c
    mov dword ptr [ebp - local_10], edx          # 004ab122
    movsx eax, word ptr [ebp - local_4]          # 004ab125
    imul eax, eax, 0x15c                         # 004ab129
    mov ecx, dword ptr [ebp - local_18]          # 004ab12f
    mov edx, dword ptr [ecx + eax + field_115]   # 004ab132
    add edx, dword ptr [0x58318a]                # 004ab139
    mov dword ptr [ebp - local_8], edx           # 004ab13f
    movsx eax, word ptr [ebp - local_4]          # 004ab142
    imul eax, eax, 0x15c                         # 004ab146
    mov ecx, dword ptr [ebp - local_18]          # 004ab14c
    mov edx, dword ptr [ecx + eax + field_109]   # 004ab14f
    add edx, dword ptr [0x583186]                # 004ab156
    mov dword ptr [ebp - local_14], edx          # 004ab15c
    movsx eax, word ptr [ebp - local_4]          # 004ab15f
    imul eax, eax, 0x15c                         # 004ab163
    mov ecx, dword ptr [ebp - local_18]          # 004ab169
    mov edx, dword ptr [ecx + eax + field_111]   # 004ab16c
    add edx, dword ptr [0x583186]                # 004ab173
    mov dword ptr [ebp - local_c], edx           # 004ab179
    push 0x550f00                                # 004ab17c
    lea eax, [ebp - local_14]                    # 004ab181
    push eax                                     # 004ab184
    movsx ecx, word ptr [ebp - local_4]          # 004ab185
    imul ecx, ecx, 0x15c                         # 004ab189
    mov edx, dword ptr [ebp - local_18]          # 004ab18f
    lea eax, [edx + ecx + field_109]             # 004ab192
    push eax                                     # 004ab199
    mov ecx, dword ptr [0x5cf665]                # 004ab19a
    push ecx                                     # 004ab1a0
    mov edx, dword ptr [0x5d15e3]                # 004ab1a1
    push edx                                     # 004ab1a7
    mov ecx, 0x5cf659                            # 004ab1a8
    call FUN_004c5377                            # 004ab1ad
L_004ab1b2:
    # block 0x004ab1b2: entered by jmp at 0x004ab0f3; je at 0x004ab102, 1 instruction(s), ends with backward jump to 0x004ab009
    jmp.d32 L_004ab009                           # 004ab1b2
L_004ab1b7:
    # block 0x004ab1b7: entered by jge at 0x004ab025, 5 instruction(s), ends with je to 0x004ab285 (forward)
    mov byte ptr [0x630a78], 0x0                 # 004ab1b7
    {load} xor eax, eax                          # 004ab1be
    mov al, byte ptr [0x630a5f]                  # 004ab1c0
    test eax, eax                                # 004ab1c5
    je.d32 L_004ab285                            # 004ab1c7
    # block 0x004ab1cd: entered by fall-through of je at 0x004ab1c7, 38 instruction(s), calls FUN_004c5377, falls into the block at 0x004ab285
    movsx ecx, word ptr [0x630a76]               # 004ab1cd
    imul ecx, ecx, 0x15c                         # 004ab1d4
    mov edx, dword ptr [ebp - local_18]          # 004ab1da
    mov eax, dword ptr [edx + ecx + field_249]   # 004ab1dd
    add eax, dword ptr [0x58318a]                # 004ab1e4
    mov dword ptr [ebp - local_10], eax          # 004ab1ea
    movsx ecx, word ptr [0x630a76]               # 004ab1ed
    imul ecx, ecx, 0x15c                         # 004ab1f4
    mov edx, dword ptr [ebp - local_18]          # 004ab1fa
    mov eax, dword ptr [edx + ecx + field_251]   # 004ab1fd
    add eax, dword ptr [0x58318a]                # 004ab204
    mov dword ptr [ebp - local_8], eax           # 004ab20a
    movsx ecx, word ptr [0x630a76]               # 004ab20d
    imul ecx, ecx, 0x15c                         # 004ab214
    mov edx, dword ptr [ebp - local_18]          # 004ab21a
    mov eax, dword ptr [edx + ecx + field_245]   # 004ab21d
    add eax, dword ptr [0x583186]                # 004ab224
    mov dword ptr [ebp - local_14], eax          # 004ab22a
    movsx ecx, word ptr [0x630a76]               # 004ab22d
    imul ecx, ecx, 0x15c                         # 004ab234
    mov edx, dword ptr [ebp - local_18]          # 004ab23a
    mov eax, dword ptr [edx + ecx + field_24d]   # 004ab23d
    add eax, dword ptr [0x583186]                # 004ab244
    mov dword ptr [ebp - local_c], eax           # 004ab24a
    push 0x550f18                                # 004ab24d
    lea ecx, [ebp - local_14]                    # 004ab252
    push ecx                                     # 004ab255
    movsx edx, word ptr [0x630a76]               # 004ab256
    imul edx, edx, 0x15c                         # 004ab25d
    mov eax, dword ptr [ebp - local_18]          # 004ab263
    lea ecx, [eax + edx + field_245]             # 004ab266
    push ecx                                     # 004ab26d
    mov edx, dword ptr [0x5cf665]                # 004ab26e
    push edx                                     # 004ab274
    mov eax, dword ptr [0x5d15e3]                # 004ab275
    push eax                                     # 004ab27a
    mov ecx, 0x5cf659                            # 004ab27b
    call FUN_004c5377                            # 004ab280
L_004ab285:
    # block 0x004ab285: entered by je at 0x004aaf2b; je at 0x004ab1c7, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ab285
    pop ebp                                      # 004ab287
    ret                                          # 004ab288

# --- data items (not part of the function) -------------------------
.org 0x004ab289 - 0x401000
PAD_004ab289:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

