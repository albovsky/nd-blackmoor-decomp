# FUN_00447d80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447d80
# extent:       0x00447d80-0x00447dae (46 code bytes)
# span:         0x00447d80-0x00447db0 (code 46, tables 0, padding 2)
# sha256:       2a7ae83a2a97557736b9b757aee9dba6d2e2e77e69e7efebf1ea9f8a2c1141ef
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m447d80_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m447d80_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x447d2f(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00447d2f, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m447d80_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00447d2f, .text + (0x00447d2f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00447d80 - 0x401000
.globl FUN_00447d80
FUN_00447d80:
    # block 0x00447d80: entry, 10 instruction(s), calls FUN_00447d2f, ends with je to 0x00447da5 (forward)
    push ebp                                     # 00447d80
    {load} mov ebp, esp                          # 00447d81
    push ecx                                     # 00447d83
    mov dword ptr [ebp - local_4], ecx           # 00447d84
    mov ecx, dword ptr [ebp - local_4]           # 00447d87
    call FUN_00447d2f                            # 00447d8a
    mov eax, dword ptr [ebp + arg_8]             # 00447d8f
    and eax, 0x1                                 # 00447d92
    test eax, eax                                # 00447d95
    je.d8 L_00447da5                             # 00447d97
    # block 0x00447d99: entered by fall-through of je at 0x00447d97, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00447da5
    mov ecx, dword ptr [ebp - local_4]           # 00447d99
    push ecx                                     # 00447d9c
    call FUN_0051dc6c                            # 00447d9d
    add esp, 0x4                                 # 00447da2
L_00447da5:
    # block 0x00447da5: entered by je at 0x00447d97, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00447da5
    {load} mov esp, ebp                          # 00447da8
    pop ebp                                      # 00447daa
    ret 0x4                                      # 00447dab

# --- data items (not part of the function) -------------------------
.org 0x00447dae - 0x401000
PAD_00447dae:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

