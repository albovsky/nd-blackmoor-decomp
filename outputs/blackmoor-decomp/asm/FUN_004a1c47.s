# FUN_004a1c47
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1c47
# extent:       0x004a1c47-0x004a1cb1 (106 code bytes)
# span:         0x004a1c47-0x004a1cb1 (code 106, tables 0, padding 0)
# sha256:       35fd5439a2dde4b332f7f95f4e01f0e638fa357530722d18feb83a17b8fe635b
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a1c47_init_fields11
# naming:       native port src/original_methods_fl39e.c:m4a1c47_init_fields11 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 11 immediates into the object (word +0x1e, word +0x1c, dword +0x60, byte +0x4b, byte +0x58, byte +0x59, byte +0x5a, dword +0x20, dword +0x24, dword +0x5b. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_4b, field_5a, field_5b; [ecx + n] field_1c, field_20, field_49, field_58; [edx + n] field_24, field_59, field_60
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4a1c47_init_fields11 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_49, 0x49  # offset +0x49
.equ field_4b, 0x4b  # offset +0x4b
.equ field_58, 0x58  # offset +0x58
.equ field_59, 0x59  # offset +0x59
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5b, 0x5b  # offset +0x5b
.equ field_60, 0x60  # offset +0x60

# --- external targets -----------------------------------------------

.org 0x004a1c47 - 0x401000
.globl FUN_004a1c47
FUN_004a1c47:
    # block 0x004a1c47: entry, 29 instruction(s), ends with ret
    push ebp                                     # 004a1c47
    {load} mov ebp, esp                          # 004a1c48
    push ecx                                     # 004a1c4a
    mov dword ptr [ebp - local_4], ecx           # 004a1c4b
    mov eax, dword ptr [ebp - local_4]           # 004a1c4e
    mov word ptr [eax + field_1e], 0xffff        # 004a1c51
    mov ecx, dword ptr [ebp - local_4]           # 004a1c57
    mov word ptr [ecx + field_1c], 0xffff        # 004a1c5a
    mov edx, dword ptr [ebp - local_4]           # 004a1c60
    mov dword ptr [edx + field_60], 0x0          # 004a1c63
    mov eax, dword ptr [ebp - local_4]           # 004a1c6a
    mov byte ptr [eax + field_4b], 0x0           # 004a1c6d
    mov ecx, dword ptr [ebp - local_4]           # 004a1c71
    mov byte ptr [ecx + field_58], 0x0           # 004a1c74
    mov edx, dword ptr [ebp - local_4]           # 004a1c78
    mov byte ptr [edx + field_59], 0x0           # 004a1c7b
    mov eax, dword ptr [ebp - local_4]           # 004a1c7f
    mov byte ptr [eax + field_5a], 0x0           # 004a1c82
    mov ecx, dword ptr [ebp - local_4]           # 004a1c86
    mov dword ptr [ecx + field_20], 0x0          # 004a1c89
    mov edx, dword ptr [ebp - local_4]           # 004a1c90
    mov dword ptr [edx + field_24], 0x0          # 004a1c93
    mov eax, dword ptr [ebp - local_4]           # 004a1c9a
    mov dword ptr [eax + field_5b], 0x0          # 004a1c9d
    mov ecx, dword ptr [ebp - local_4]           # 004a1ca4
    mov word ptr [ecx + field_49], 0xffff        # 004a1ca7
    {load} mov esp, ebp                          # 004a1cad
    pop ebp                                      # 004a1caf
    ret                                          # 004a1cb0

