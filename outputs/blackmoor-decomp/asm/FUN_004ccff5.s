# FUN_004ccff5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccff5
# extent:       0x004ccff5-0x004cd218 (547 code bytes)
# span:         0x004ccff5-0x004cd218 (code 547, tables 0, padding 0)
# sha256:       d13fc6618bc3d11776da086eb8beff6fb9dd861eee513d084bb60a5cc237d822
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ccff5_free_piece
# naming:       native port src/original_methods_fl19a.c:m4ccff5_free_piece (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4ccff5_free_piece. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 547 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_222, field_226, field_22a, field_23e; [ecx + n] field_23, field_31, field_222, field_226, field_22a, field_23e; [edx + n] field_31, field_226, field_23e
# callees:      calls FUN_0051dc6c, FUN_00423b51
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl19a.c:m4ccff5_free_piece (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 121 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_23, 0x23  # offset +0x23
.equ field_31, 0x31  # offset +0x31
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_22a, 0x22a  # offset +0x22a
.equ field_23e, 0x23e  # offset +0x23e

# --- external targets -----------------------------------------------
.set FUN_00423b51, .text + (0x00423b51 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004ccff5 - 0x401000
.globl FUN_004ccff5
FUN_004ccff5:
    # block 0x004ccff5: entry, 7 instruction(s), ends with je to 0x004cd214 (forward)
    push ebp                                     # 004ccff5
    {load} mov ebp, esp                          # 004ccff6
    sub esp, 0x18                                # 004ccff8
    mov dword ptr [ebp - local_18], ecx          # 004ccffb
    mov eax, dword ptr [ebp - local_18]          # 004ccffe
    cmp dword ptr [eax + field_23e], -0x1        # 004cd001
    je.d32 L_004cd214                            # 004cd008
    # block 0x004cd00e: entered by fall-through of je at 0x004cd008, 3 instruction(s), ends with je to 0x004cd0b8 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004cd00e
    cmp dword ptr [ecx + field_226], 0x0         # 004cd011
    je.d32 L_004cd0b8                            # 004cd018
    # block 0x004cd01e: entered by fall-through of je at 0x004cd018, 2 instruction(s), ends with forward jump to 0x004cd030
    mov dword ptr [ebp - local_4], 0x0           # 004cd01e
    jmp.d8 L_004cd030                            # 004cd025
L_004cd027:
    # block 0x004cd027: entered by jmp at 0x004cd091, 3 instruction(s), falls into the block at 0x004cd030
    mov edx, dword ptr [ebp - local_4]           # 004cd027
    add edx, 0x1                                 # 004cd02a
    mov dword ptr [ebp - local_4], edx           # 004cd02d
L_004cd030:
    # block 0x004cd030: entered by jmp at 0x004cd025, 5 instruction(s), ends with jge to 0x004cd093 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004cd030
    mov ecx, dword ptr [eax + field_222]         # 004cd033
    movsx edx, word ptr [ecx + field_23]         # 004cd039
    cmp dword ptr [ebp - local_4], edx           # 004cd03d
    jge.d8 L_004cd093                            # 004cd040
    # block 0x004cd042: entered by fall-through of jge at 0x004cd040, 6 instruction(s), ends with je to 0x004cd091 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cd042
    imul eax, eax, 0x35                          # 004cd045
    mov ecx, dword ptr [ebp - local_18]          # 004cd048
    mov edx, dword ptr [ecx + field_226]         # 004cd04b
    cmp dword ptr [edx + eax + field_31], 0x0    # 004cd051
    je.d8 L_004cd091                             # 004cd056
    # block 0x004cd058: entered by fall-through of je at 0x004cd056, 15 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004cd091
    mov eax, dword ptr [ebp - local_4]           # 004cd058
    imul eax, eax, 0x35                          # 004cd05b
    mov ecx, dword ptr [ebp - local_18]          # 004cd05e
    mov edx, dword ptr [ecx + field_226]         # 004cd061
    mov eax, dword ptr [edx + eax + field_31]    # 004cd067
    mov dword ptr [ebp - local_8], eax           # 004cd06b
    mov ecx, dword ptr [ebp - local_8]           # 004cd06e
    push ecx                                     # 004cd071
    call FUN_0051dc6c                            # 004cd072
    add esp, 0x4                                 # 004cd077
    mov edx, dword ptr [ebp - local_4]           # 004cd07a
    imul edx, edx, 0x35                          # 004cd07d
    mov eax, dword ptr [ebp - local_18]          # 004cd080
    mov ecx, dword ptr [eax + field_226]         # 004cd083
    mov dword ptr [ecx + edx + field_31], 0x0    # 004cd089
L_004cd091:
    # block 0x004cd091: entered by je at 0x004cd056, 1 instruction(s), ends with backward jump to 0x004cd027
    jmp.d8 L_004cd027                            # 004cd091
L_004cd093:
    # block 0x004cd093: entered by jge at 0x004cd040, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004cd0b8
    mov edx, dword ptr [ebp - local_18]          # 004cd093
    mov eax, dword ptr [edx + field_226]         # 004cd096
    mov dword ptr [ebp - local_c], eax           # 004cd09c
    mov ecx, dword ptr [ebp - local_c]           # 004cd09f
    push ecx                                     # 004cd0a2
    call FUN_0051dc6c                            # 004cd0a3
    add esp, 0x4                                 # 004cd0a8
    mov edx, dword ptr [ebp - local_18]          # 004cd0ab
    mov dword ptr [edx + field_226], 0x0         # 004cd0ae
L_004cd0b8:
    # block 0x004cd0b8: entered by je at 0x004cd018, 3 instruction(s), ends with je to 0x004cd0e9 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004cd0b8
    cmp dword ptr [eax + field_22a], 0x0         # 004cd0bb
    je.d8 L_004cd0e9                             # 004cd0c2
    # block 0x004cd0c4: entered by fall-through of je at 0x004cd0c2, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004cd0e9
    mov ecx, dword ptr [ebp - local_18]          # 004cd0c4
    mov edx, dword ptr [ecx + field_22a]         # 004cd0c7
    mov dword ptr [ebp - local_10], edx          # 004cd0cd
    mov eax, dword ptr [ebp - local_10]          # 004cd0d0
    push eax                                     # 004cd0d3
    call FUN_0051dc6c                            # 004cd0d4
    add esp, 0x4                                 # 004cd0d9
    mov ecx, dword ptr [ebp - local_18]          # 004cd0dc
    mov dword ptr [ecx + field_22a], 0x0         # 004cd0df
L_004cd0e9:
    # block 0x004cd0e9: entered by je at 0x004cd0c2, 5 instruction(s), ends with je to 0x004cd13e (forward)
    mov edx, dword ptr [ebp - local_18]          # 004cd0e9
    mov eax, dword ptr [edx + field_23e]         # 004cd0ec
    imul eax, eax, 0x8d                          # 004cd0f2
    cmp dword ptr [eax + 0x5bb5e5], 0x0          # 004cd0f8
    je.d8 L_004cd13e                             # 004cd0ff
    # block 0x004cd101: entered by fall-through of je at 0x004cd0ff, 13 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004cd13e
    mov ecx, dword ptr [ebp - local_18]          # 004cd101
    mov edx, dword ptr [ecx + field_23e]         # 004cd104
    imul edx, edx, 0x8d                          # 004cd10a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004cd110
    mov dword ptr [ebp - local_14], eax          # 004cd116
    mov ecx, dword ptr [ebp - local_14]          # 004cd119
    push ecx                                     # 004cd11c
    call FUN_0051dc6c                            # 004cd11d
    add esp, 0x4                                 # 004cd122
    mov edx, dword ptr [ebp - local_18]          # 004cd125
    mov eax, dword ptr [edx + field_23e]         # 004cd128
    imul eax, eax, 0x8d                          # 004cd12e
    mov dword ptr [eax + 0x5bb5e5], 0x0          # 004cd134
L_004cd13e:
    # block 0x004cd13e: entered by je at 0x004cd0ff, 37 instruction(s), calls FUN_00423b51, falls into the block at 0x004cd214
    mov ecx, dword ptr [ebp - local_18]          # 004cd13e
    mov dword ptr [ecx + field_222], 0x0         # 004cd141
    mov edx, dword ptr [ebp - local_18]          # 004cd14b
    mov eax, dword ptr [edx + field_23e]         # 004cd14e
    imul eax, eax, 0x8d                          # 004cd154
    mov byte ptr [eax + 0x5bb5e3], 0x0           # 004cd15a
    mov ecx, dword ptr [ebp - local_18]          # 004cd161
    mov edx, dword ptr [ecx + field_23e]         # 004cd164
    imul edx, edx, 0x8d                          # 004cd16a
    mov byte ptr [edx + 0x5bb625], 0x0           # 004cd170
    mov eax, dword ptr [ebp - local_18]          # 004cd177
    mov ecx, dword ptr [eax + field_23e]         # 004cd17a
    imul ecx, ecx, 0x8d                          # 004cd180
    mov dword ptr [ecx + 0x5bb626], 0x0          # 004cd186
    mov edx, dword ptr [ebp - local_18]          # 004cd190
    mov eax, dword ptr [edx + field_23e]         # 004cd193
    imul eax, eax, 0x8d                          # 004cd199
    mov dword ptr [eax + 0x5bb632], 0x0          # 004cd19f
    mov ecx, dword ptr [ebp - local_18]          # 004cd1a9
    mov edx, dword ptr [ecx + field_23e]         # 004cd1ac
    imul edx, edx, 0x8d                          # 004cd1b2
    mov word ptr [edx + 0x5bb636], 0xffff        # 004cd1b8
    mov eax, dword ptr [ebp - local_18]          # 004cd1c1
    mov ecx, dword ptr [eax + field_23e]         # 004cd1c4
    imul ecx, ecx, 0x8d                          # 004cd1ca
    mov dword ptr [ecx + 0x5bb638], 0x1          # 004cd1d0
    mov edx, dword ptr [ebp - local_18]          # 004cd1da
    mov eax, dword ptr [edx + field_23e]         # 004cd1dd
    imul eax, eax, 0x8d                          # 004cd1e3
    mov dword ptr [eax + 0x5bb63c], 0x0          # 004cd1e9
    mov ecx, dword ptr [ebp - local_18]          # 004cd1f3
    mov edx, dword ptr [ecx + field_23e]         # 004cd1f6
    push edx                                     # 004cd1fc
    mov ecx, 0x63786d                            # 004cd1fd
    call FUN_00423b51                            # 004cd202
    mov eax, dword ptr [ebp - local_18]          # 004cd207
    mov dword ptr [eax + field_23e], 0xffffffff  # 004cd20a
L_004cd214:
    # block 0x004cd214: entered by je at 0x004cd008, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cd214
    pop ebp                                      # 004cd216
    ret                                          # 004cd217

