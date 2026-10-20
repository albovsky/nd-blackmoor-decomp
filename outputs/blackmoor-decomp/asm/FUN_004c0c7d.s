# FUN_004c0c7d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0c7d
# extent:       0x004c0c7d-0x004c0d3f (194 code bytes)
# span:         0x004c0c7d-0x004c0d3f (code 194, tables 0, padding 0)
# sha256:       cff40d965b12bab1174db0a316a544be07cefd1bdebf645b9465f38334c53837
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c0c7d_movie_thread
# naming:       native port src/original_methods_fl27a.c:m4c0c7d_movie_thread (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4c0c7d_movie_thread: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_172, field_1cc; [ecx + n] field_1cc
# callees:      calls FUN_0044c479, FUN_0041546f, FUN_004156ea, FUN_0044c4ab, KERNEL32.dll!Sleep, FUN_0051ec84
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27a.c:m4c0c7d_movie_thread (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 55 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_172, 0x172  # offset +0x172
.equ field_1cc, 0x1cc  # offset +0x1cc

# --- external targets -----------------------------------------------
.set FUN_0041546f, .text + (0x0041546f - 0x401000)
.set FUN_004156ea, .text + (0x004156ea - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_0051ec84, .text + (0x0051ec84 - 0x401000)

.org 0x004c0c7d - 0x401000
.globl FUN_004c0c7d
FUN_004c0c7d:
    # block 0x004c0c7d: entry, 6 instruction(s), falls into the block at 0x004c0c90
    push ebp                                     # 004c0c7d
    {load} mov ebp, esp                          # 004c0c7e
    sub esp, 0xc                                 # 004c0c80
    mov eax, dword ptr [ebp + arg_8]             # 004c0c83
    mov dword ptr [ebp - local_8], eax           # 004c0c86
    mov dword ptr [ebp - local_4], 0x637fd7      # 004c0c89
L_004c0c90:
    # block 0x004c0c90: entered by jmp at 0x004c0d2d, 3 instruction(s), ends with je to 0x004c0d32 (forward)
    mov ecx, 0x1                                 # 004c0c90
    test ecx, ecx                                # 004c0c95
    je.d32 L_004c0d32                            # 004c0c97
    # block 0x004c0c9d: entered by fall-through of je at 0x004c0c97, 3 instruction(s), ends with je to 0x004c0caa (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c0c9d
    cmp dword ptr [edx], 0x0                     # 004c0ca0
    je.d8 L_004c0caa                             # 004c0ca3
    # block 0x004c0ca5: entered by fall-through of je at 0x004c0ca3, 1 instruction(s), ends with forward jump to 0x004c0d32
    jmp.d32 L_004c0d32                           # 004c0ca5
L_004c0caa:
    # block 0x004c0caa: entered by je at 0x004c0ca3, 4 instruction(s), ends with je to 0x004c0cbd (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c0caa
    movsx ecx, word ptr [eax + field_1cc]        # 004c0cad
    test ecx, ecx                                # 004c0cb4
    je.d8 L_004c0cbd                             # 004c0cb6
    # block 0x004c0cb8: entered by fall-through of je at 0x004c0cb6, 1 instruction(s), ends with forward jump to 0x004c0d3d
    jmp.d32 L_004c0d3d                           # 004c0cb8
L_004c0cbd:
    # block 0x004c0cbd: entered by je at 0x004c0cb6, 6 instruction(s), calls FUN_0044c479, ends with jne to 0x004c0cd4 (forward)
    push 0x637fd3                                # 004c0cbd
    call FUN_0044c479                            # 004c0cc2
    add esp, 0x4                                 # 004c0cc7
    movsx edx, ax                                # 004c0cca
    cmp edx, 0x2                                 # 004c0ccd
    jne.d8 L_004c0cd4                            # 004c0cd0
    # block 0x004c0cd2: entered by fall-through of jne at 0x004c0cd0, 1 instruction(s), ends with forward jump to 0x004c0d3b
    jmp.d8 L_004c0d3b                            # 004c0cd2
L_004c0cd4:
    # block 0x004c0cd4: entered by jne at 0x004c0cd0, 5 instruction(s), ends with je to 0x004c0cee (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c0cd4
    mov ecx, dword ptr [eax + field_172]         # 004c0cd7
    mov dword ptr [ebp - local_c], ecx           # 004c0cdd
    cmp dword ptr [ebp - local_c], 0x0           # 004c0ce0
    je.d8 L_004c0cee                             # 004c0ce4
    # block 0x004c0ce6: entered by fall-through of je at 0x004c0ce4, 2 instruction(s), ends with je to 0x004c0cfe (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 004c0ce6
    je.d8 L_004c0cfe                             # 004c0cea
    # block 0x004c0cec: entered by fall-through of je at 0x004c0cea, 1 instruction(s), ends with forward jump to 0x004c0d0c
    jmp.d8 L_004c0d0c                            # 004c0cec
L_004c0cee:
    # block 0x004c0cee: entered by je at 0x004c0ce4, 5 instruction(s), calls FUN_0041546f, ends with forward jump to 0x004c0d0c
    mov edx, dword ptr [ebp - local_4]           # 004c0cee
    push edx                                     # 004c0cf1
    mov ecx, 0x5e2dbe                            # 004c0cf2
    call FUN_0041546f                            # 004c0cf7
    jmp.d8 L_004c0d0c                            # 004c0cfc
L_004c0cfe:
    # block 0x004c0cfe: entered by je at 0x004c0cea, 4 instruction(s), calls FUN_004156ea, falls into the block at 0x004c0d0c
    mov eax, dword ptr [ebp - local_4]           # 004c0cfe
    push eax                                     # 004c0d01
    mov ecx, 0x5e2dbe                            # 004c0d02
    call FUN_004156ea                            # 004c0d07
L_004c0d0c:
    # block 0x004c0d0c: entered by jmp at 0x004c0cec; jmp at 0x004c0cfc, 5 instruction(s), calls FUN_0044c4ab, falls into the block at 0x004c0d25
    push 0x637fd3                                # 004c0d0c
    call FUN_0044c4ab                            # 004c0d11
    add esp, 0x4                                 # 004c0d16
    mov ecx, dword ptr [ebp - local_4]           # 004c0d19
    mov word ptr [ecx + field_1cc], 0x1          # 004c0d1c
L_004c0d25:
    # block 0x004c0d25: entered by jmp at 0x004c0d3b; jmp at 0x004c0d3d, 3 instruction(s), calls KERNEL32.dll!Sleep, ends with backward jump to 0x004c0c90
    push 0x1                                     # 004c0d25
    call dword ptr [0x52a2b0]                    # 004c0d27
    jmp.d32 L_004c0c90                           # 004c0d2d
L_004c0d32:
    # block 0x004c0d32: entered by je at 0x004c0c97; jmp at 0x004c0ca5, 3 instruction(s), calls FUN_0051ec84, falls into the block at 0x004c0d3b
    push 0x1                                     # 004c0d32
    push 0x0                                     # 004c0d34
    call FUN_0051ec84                            # 004c0d36
L_004c0d3b:
    # block 0x004c0d3b: entered by jmp at 0x004c0cd2, 1 instruction(s), ends with backward jump to 0x004c0d25
    jmp.d8 L_004c0d25                            # 004c0d3b
L_004c0d3d:
    # block 0x004c0d3d: entered by jmp at 0x004c0cb8, 1 instruction(s), ends with backward jump to 0x004c0d25
    jmp.d8 L_004c0d25                            # 004c0d3d

