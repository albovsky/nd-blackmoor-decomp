# FUN_00457fc2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457fc2
# extent:       0x00457fc2-0x00458015 (83 code bytes)
# span:         0x00457fc2-0x00458015 (code 83, tables 0, padding 0)
# sha256:       868d049c3c84250eacc312aa8945f853458e55f5217c2496b791adbf5a4c2ce1
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m457fc2_release_surface_clear_call_tail
# naming:       native port src/original_methods_fl38a.c:m457fc2_release_surface_clear_call_tail (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    As the release rows, and stores 0 at [this+0x1c] after the 0x4c2dfb call; tail 0x457f7a(this). 28/28 instructions, 4/4 branch directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_24; [edx + n] field_1c, field_24
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00457f7a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m457fc2_release_surface_clear_call_tail (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_00457f7a, .text + (0x00457f7a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00457fc2 - 0x401000
.globl FUN_00457fc2
FUN_00457fc2:
    # block 0x00457fc2: entry, 7 instruction(s), ends with je to 0x00457fed (forward)
    push ebp                                     # 00457fc2
    {load} mov ebp, esp                          # 00457fc3
    push ecx                                     # 00457fc5
    mov dword ptr [ebp - local_4], ecx           # 00457fc6
    mov eax, dword ptr [ebp - local_4]           # 00457fc9
    cmp dword ptr [eax + field_1c], 0x0          # 00457fcc
    je.d8 L_00457fed                             # 00457fd0
    # block 0x00457fd2: entered by fall-through of je at 0x00457fd0, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00457fed
    mov ecx, dword ptr [ebp - local_4]           # 00457fd2
    add ecx, 0x1c                                # 00457fd5
    push ecx                                     # 00457fd8
    mov ecx, 0x5cf659                            # 00457fd9
    call FUN_004c2dfb                            # 00457fde
    mov edx, dword ptr [ebp - local_4]           # 00457fe3
    mov dword ptr [edx + field_1c], 0x0          # 00457fe6
L_00457fed:
    # block 0x00457fed: entered by je at 0x00457fd0, 4 instruction(s), ends with je to 0x00458009 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00457fed
    movsx ecx, word ptr [eax + field_24]         # 00457ff0
    cmp ecx, -0x1                                # 00457ff4
    je.d8 L_00458009                             # 00457ff7
    # block 0x00457ff9: entered by fall-through of je at 0x00457ff7, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00458009
    mov edx, dword ptr [ebp - local_4]           # 00457ff9
    mov ax, word ptr [edx + field_24]            # 00457ffc
    push eax                                     # 00458000
    call FUN_004d3992                            # 00458001
    add esp, 0x4                                 # 00458006
L_00458009:
    # block 0x00458009: entered by je at 0x00457ff7, 5 instruction(s), calls FUN_00457f7a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00458009
    call FUN_00457f7a                            # 0045800c
    {load} mov esp, ebp                          # 00458011
    pop ebp                                      # 00458013
    ret                                          # 00458014

