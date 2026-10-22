# FUN_004cca42
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cca42
# extent:       0x004cca42-0x004cca6f (45 code bytes)
# span:         0x004cca42-0x004cca6f (code 45, tables 0, padding 0)
# sha256:       0bc7b40a688dfee769bc6b38271ab0d712917b6cb1074534c7c569ed7b5428b9
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cca42_forward_struct
# naming:       native port src/original_methods_fl39e.c:m4cca42_forward_struct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4cca0e(this = self, a, the three dwords of the record argument [0], [4], [8]) and returns its eax; pops 8 bytes. No jumps; all 20 instructions run.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8; [edx + n] field_4
# callees:      calls FUN_004cca0e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4cca42_forward_struct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_004cca0e, .text + (0x004cca0e - 0x401000)

.org 0x004cca42 - 0x401000
.globl FUN_004cca42
FUN_004cca42:
    # block 0x004cca42: entry, 20 instruction(s), calls FUN_004cca0e, ends with ret 0x8
    push ebp                                     # 004cca42
    {load} mov ebp, esp                          # 004cca43
    push ecx                                     # 004cca45
    mov dword ptr [ebp - local_4], ecx           # 004cca46
    mov eax, dword ptr [ebp + arg_c]             # 004cca49
    mov ecx, dword ptr [eax + field_8]           # 004cca4c
    push ecx                                     # 004cca4f
    mov edx, dword ptr [ebp + arg_c]             # 004cca50
    mov eax, dword ptr [edx + field_4]           # 004cca53
    push eax                                     # 004cca56
    mov ecx, dword ptr [ebp + arg_c]             # 004cca57
    mov edx, dword ptr [ecx]                     # 004cca5a
    push edx                                     # 004cca5c
    mov eax, dword ptr [ebp + arg_8]             # 004cca5d
    push eax                                     # 004cca60
    mov ecx, dword ptr [ebp - local_4]           # 004cca61
    call FUN_004cca0e                            # 004cca64
    {load} mov esp, ebp                          # 004cca69
    pop ebp                                      # 004cca6b
    ret 0x8                                      # 004cca6c

