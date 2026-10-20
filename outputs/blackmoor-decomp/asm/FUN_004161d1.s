# FUN_004161d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004161d1
# extent:       0x004161d1-0x0041632b (346 code bytes)
# span:         0x004161d1-0x0041632b (code 346, tables 0, padding 0)
# sha256:       9b1dc6ed8fb242f085b8bcbd693dbcaf5c70425e7cab3adc9b92ece2203a55eb
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4161d1_alloc_buffers
# naming:       native port src/original_methods_fl27b.c:m4161d1_alloc_buffers (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4161d1_alloc_buffers: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_172, field_17e, field_184, field_1c8; [ecx + n] field_17a, field_1c8; [edx + n] field_17a, field_182, field_1c8
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27b.c:m4161d1_alloc_buffers (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 86 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ field_172, 0x172  # offset +0x172
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_182, 0x182  # offset +0x182
.equ field_184, 0x184  # offset +0x184
.equ field_1c8, 0x1c8  # offset +0x1c8

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004161d1 - 0x401000
.globl FUN_004161d1
FUN_004161d1:
    # block 0x004161d1: entry, 9 instruction(s), ends with je to 0x004161f7 (forward)
    push ebp                                     # 004161d1
    {load} mov ebp, esp                          # 004161d2
    sub esp, 0x14                                # 004161d4
    mov dword ptr [ebp - local_10], ecx          # 004161d7
    mov eax, dword ptr [ebp + arg_8]             # 004161da
    mov ecx, dword ptr [eax + field_172]         # 004161dd
    mov dword ptr [ebp - local_14], ecx          # 004161e3
    cmp dword ptr [ebp - local_14], 0x0          # 004161e6
    je.d8 L_004161f7                             # 004161ea
    # block 0x004161ec: entered by fall-through of je at 0x004161ea, 2 instruction(s), ends with je to 0x00416257 (forward)
    cmp dword ptr [ebp - local_14], 0x1          # 004161ec
    je.d8 L_00416257                             # 004161f0
    # block 0x004161f2: entered by fall-through of je at 0x004161f0, 1 instruction(s), ends with forward jump to 0x0041630d
    jmp.d32 L_0041630d                           # 004161f2
L_004161f7:
    # block 0x004161f7: entered by je at 0x004161ea, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x00416252 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004161f7
    mov eax, dword ptr [edx + field_1c8]         # 004161fa
    push eax                                     # 00416200
    call FUN_0051dc43                            # 00416201
    add esp, 0x4                                 # 00416206
    mov dword ptr [ebp - local_4], eax           # 00416209
    mov ecx, dword ptr [ebp + arg_8]             # 0041620c
    mov edx, dword ptr [ebp - local_4]           # 0041620f
    mov dword ptr [ecx + field_17a], edx         # 00416212
    cmp dword ptr [ebp - local_4], 0x0           # 00416218
    jne.d8 L_00416252                            # 0041621c
    # block 0x0041621e: entered by fall-through of jne at 0x0041621c, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00416252
    push 0x541e7c                                # 0041621e
    push 0x63888b                                # 00416223
    call FUN_0050ca3e                            # 00416228
    add esp, 0x8                                 # 0041622d
    push 0x0                                     # 00416230
    push 0x0                                     # 00416232
    push 0x63888b                                # 00416234
    call FUN_0052139c                            # 00416239
    mov dword ptr [0x63a58a], 0x4                # 0041623e
    mov ecx, 0x5cf659                            # 00416248
    call FUN_004c97b4                            # 0041624d
L_00416252:
    # block 0x00416252: entered by jne at 0x0041621c, 1 instruction(s), ends with forward jump to 0x0041630d
    jmp.d32 L_0041630d                           # 00416252
L_00416257:
    # block 0x00416257: entered by je at 0x004161f0, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x004162b2 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00416257
    mov ecx, dword ptr [eax + field_1c8]         # 0041625a
    push ecx                                     # 00416260
    call FUN_0051dc43                            # 00416261
    add esp, 0x4                                 # 00416266
    mov dword ptr [ebp - local_8], eax           # 00416269
    mov edx, dword ptr [ebp + arg_8]             # 0041626c
    mov eax, dword ptr [ebp - local_8]           # 0041626f
    mov dword ptr [edx + field_17a], eax         # 00416272
    cmp dword ptr [ebp - local_8], 0x0           # 00416278
    jne.d8 L_004162b2                            # 0041627c
    # block 0x0041627e: entered by fall-through of jne at 0x0041627c, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x004162b2
    push 0x541ed4                                # 0041627e
    push 0x63888b                                # 00416283
    call FUN_0050ca3e                            # 00416288
    add esp, 0x8                                 # 0041628d
    push 0x0                                     # 00416290
    push 0x0                                     # 00416292
    push 0x63888b                                # 00416294
    call FUN_0052139c                            # 00416299
    mov dword ptr [0x63a58a], 0x4                # 0041629e
    mov ecx, 0x5cf659                            # 004162a8
    call FUN_004c97b4                            # 004162ad
L_004162b2:
    # block 0x004162b2: entered by jne at 0x0041627c, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041630d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004162b2
    mov edx, dword ptr [ecx + field_1c8]         # 004162b5
    push edx                                     # 004162bb
    call FUN_0051dc43                            # 004162bc
    add esp, 0x4                                 # 004162c1
    mov dword ptr [ebp - local_c], eax           # 004162c4
    mov eax, dword ptr [ebp + arg_8]             # 004162c7
    mov ecx, dword ptr [ebp - local_c]           # 004162ca
    mov dword ptr [eax + field_17e], ecx         # 004162cd
    cmp dword ptr [ebp - local_c], 0x0           # 004162d3
    jne.d8 L_0041630d                            # 004162d7
    # block 0x004162d9: entered by fall-through of jne at 0x004162d7, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0041630d
    push 0x541f2c                                # 004162d9
    push 0x63888b                                # 004162de
    call FUN_0050ca3e                            # 004162e3
    add esp, 0x8                                 # 004162e8
    push 0x0                                     # 004162eb
    push 0x0                                     # 004162ed
    push 0x63888b                                # 004162ef
    call FUN_0052139c                            # 004162f4
    mov dword ptr [0x63a58a], 0x4                # 004162f9
    mov ecx, 0x5cf659                            # 00416303
    call FUN_004c97b4                            # 00416308
L_0041630d:
    # block 0x0041630d: entered by jmp at 0x004161f2; jmp at 0x00416252; jne at 0x004162d7, 7 instruction(s), ends with ret 0x4
    mov edx, dword ptr [ebp + arg_8]             # 0041630d
    mov word ptr [edx + field_182], 0x0          # 00416310
    mov eax, dword ptr [ebp + arg_8]             # 00416319
    mov word ptr [eax + field_184], 0x0          # 0041631c
    {load} mov esp, ebp                          # 00416325
    pop ebp                                      # 00416327
    ret 0x4                                      # 00416328

