# FUN_004f8a17
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8a17
# extent:       0x004f8a17-0x004f8a66 (79 code bytes)
# span:         0x004f8a17-0x004f8a66 (code 79, tables 0, padding 0)
# sha256:       566eba8bb4c2b66750f0bb915f2d832f77c77d5167210856e7c6d2efcbea4fd9
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f8a17_lifted
# naming:       native port src/original_methods_fl39d.c:m4f8a17_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_260, field_26c; [ecx + n] field_258, field_264; [edx + n] field_25c, field_268
# callees:      calls FUN_004f88de
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4f8a17_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_258, 0x258  # offset +0x258
.equ field_25c, 0x25c  # offset +0x25c
.equ field_260, 0x260  # offset +0x260
.equ field_264, 0x264  # offset +0x264
.equ field_268, 0x268  # offset +0x268
.equ field_26c, 0x26c  # offset +0x26c

# --- external targets -----------------------------------------------
.set FUN_004f88de, .text + (0x004f88de - 0x401000)

.org 0x004f8a17 - 0x401000
.globl FUN_004f8a17
FUN_004f8a17:
    # block 0x004f8a17: entry, 27 instruction(s), calls FUN_004f88de, ends with ret
    push ebp                                     # 004f8a17
    {load} mov ebp, esp                          # 004f8a18
    push ecx                                     # 004f8a1a
    mov dword ptr [ebp - local_4], ecx           # 004f8a1b
    mov eax, dword ptr [ebp - local_4]           # 004f8a1e
    mov ecx, dword ptr [eax + field_26c]         # 004f8a21
    push ecx                                     # 004f8a27
    mov edx, dword ptr [ebp - local_4]           # 004f8a28
    mov eax, dword ptr [edx + field_268]         # 004f8a2b
    push eax                                     # 004f8a31
    mov ecx, dword ptr [ebp - local_4]           # 004f8a32
    mov edx, dword ptr [ecx + field_264]         # 004f8a35
    push edx                                     # 004f8a3b
    mov eax, dword ptr [ebp - local_4]           # 004f8a3c
    mov ecx, dword ptr [eax + field_260]         # 004f8a3f
    push ecx                                     # 004f8a45
    mov edx, dword ptr [ebp - local_4]           # 004f8a46
    mov eax, dword ptr [edx + field_25c]         # 004f8a49
    push eax                                     # 004f8a4f
    mov ecx, dword ptr [ebp - local_4]           # 004f8a50
    mov edx, dword ptr [ecx + field_258]         # 004f8a53
    push edx                                     # 004f8a59
    mov ecx, dword ptr [ebp - local_4]           # 004f8a5a
    call FUN_004f88de                            # 004f8a5d
    {load} mov esp, ebp                          # 004f8a62
    pop ebp                                      # 004f8a64
    ret                                          # 004f8a65

