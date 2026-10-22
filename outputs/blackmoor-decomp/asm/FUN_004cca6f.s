# FUN_004cca6f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cca6f
# extent:       0x004cca6f-0x004cca9c (45 code bytes)
# span:         0x004cca6f-0x004cca9c (code 45, tables 0, padding 0)
# sha256:       df6e38c5c831671f95f0c5f535a696ce6c89aedf35fb943008fca912d76800db
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cca6f_forward_struct
# naming:       native port src/original_methods_fl39e.c:m4cca6f_forward_struct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4cca9c(this = self, a, the three dwords of the record argument [0], [4], [8]) and returns its eax; pops 8 bytes. No jumps; all 20 instructions run.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8; [edx + n] field_4
# callees:      calls FUN_004cca9c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4cca6f_forward_struct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004cca9c, .text + (0x004cca9c - 0x401000)

.org 0x004cca6f - 0x401000
.globl FUN_004cca6f
FUN_004cca6f:
    # block 0x004cca6f: entry, 20 instruction(s), calls FUN_004cca9c, ends with ret 0x8
    push ebp                                     # 004cca6f
    {load} mov ebp, esp                          # 004cca70
    push ecx                                     # 004cca72
    mov dword ptr [ebp - local_4], ecx           # 004cca73
    mov eax, dword ptr [ebp + arg_c]             # 004cca76
    mov ecx, dword ptr [eax + field_8]           # 004cca79
    push ecx                                     # 004cca7c
    mov edx, dword ptr [ebp + arg_c]             # 004cca7d
    mov eax, dword ptr [edx + field_4]           # 004cca80
    push eax                                     # 004cca83
    mov ecx, dword ptr [ebp + arg_c]             # 004cca84
    mov edx, dword ptr [ecx]                     # 004cca87
    push edx                                     # 004cca89
    mov eax, dword ptr [ebp + arg_8]             # 004cca8a
    push eax                                     # 004cca8d
    mov ecx, dword ptr [ebp - local_4]           # 004cca8e
    call FUN_004cca9c                            # 004cca91
    {load} mov esp, ebp                          # 004cca96
    pop ebp                                      # 004cca98
    ret 0x8                                      # 004cca99

