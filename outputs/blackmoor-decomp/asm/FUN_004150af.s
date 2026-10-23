# FUN_004150af
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004150af
# extent:       0x004150af-0x00415113 (100 code bytes)
# span:         0x004150af-0x00415113 (code 100, tables 0, padding 0)
# sha256:       c07a8ced2770c3b93fe08966bb9d3b128aa9f0aa67270c16eb0e87eaed34baf4
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4150af_lifted
# naming:       native port src/original_methods_fl40.c:m4150af_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 3 seeds; oracle 29/29 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_3d; [edx + n] field_35
# callees:      calls FUN_0051dc43, FUN_00415011, FUN_0042639d, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4150af_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_35, 0x35  # offset +0x35
.equ field_3d, 0x3d  # offset +0x3d

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004150af - 0x401000
.globl FUN_004150af
FUN_004150af:
    # block 0x004150af: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041510d (forward)
    push ebp                                     # 004150af
    {load} mov ebp, esp                          # 004150b0
    sub esp, 0x8                                 # 004150b2
    mov dword ptr [ebp - local_8], ecx           # 004150b5
    mov eax, dword ptr [ebp + arg_8]             # 004150b8
    mov ecx, dword ptr [eax + field_3d]          # 004150bb
    push ecx                                     # 004150be
    call FUN_0051dc43                            # 004150bf
    add esp, 0x4                                 # 004150c4
    mov dword ptr [ebp - local_4], eax           # 004150c7
    mov edx, dword ptr [ebp + arg_8]             # 004150ca
    mov eax, dword ptr [ebp - local_4]           # 004150cd
    mov dword ptr [edx + field_35], eax          # 004150d0
    cmp dword ptr [ebp - local_4], 0x0           # 004150d3
    jne.d8 L_0041510d                            # 004150d7
    # block 0x004150d9: entered by fall-through of jne at 0x004150d7, 11 instruction(s), calls FUN_00415011, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0041510d
    mov ecx, dword ptr [ebp + arg_8]             # 004150d9
    push ecx                                     # 004150dc
    mov ecx, dword ptr [ebp - local_8]           # 004150dd
    call FUN_00415011                            # 004150e0
    push 0x541a08                                # 004150e5
    push 0x541a3c                                # 004150ea
    mov ecx, 0x583979                            # 004150ef
    call FUN_0042639d                            # 004150f4
    mov dword ptr [0x63a58a], 0x4                # 004150f9
    mov ecx, 0x5cf659                            # 00415103
    call FUN_004c97b4                            # 00415108
L_0041510d:
    # block 0x0041510d: entered by jne at 0x004150d7, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0041510d
    pop ebp                                      # 0041510f
    ret 0x4                                      # 00415110

