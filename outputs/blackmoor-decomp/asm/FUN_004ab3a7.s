# FUN_004ab3a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab3a7
# extent:       0x004ab3a7-0x004ab3dc (53 code bytes)
# span:         0x004ab3a7-0x004ab3dc (code 53, tables 0, padding 0)
# sha256:       9024100c308e0859930de8020faaf797a7a6c0106799a80dcba7d0d1a76f9f96
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ab3a7_init_fields5
# naming:       native port src/original_methods_fl39e.c:m4ab3a7_init_fields5 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 5 immediates into the object (word +0x1e, word +0x1c, dword +0x54, byte +0x58, byte +0x59) with the widths of the original, in order; nothing else is written, nothing is called. No jumps; all 17 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_58; [ecx + n] field_1c, field_59; [edx + n] field_54
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4ab3a7_init_fields5 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_59, 0x59  # offset +0x59

# --- external targets -----------------------------------------------

.org 0x004ab3a7 - 0x401000
.globl FUN_004ab3a7
FUN_004ab3a7:
    # block 0x004ab3a7: entry, 17 instruction(s), ends with ret
    push ebp                                     # 004ab3a7
    {load} mov ebp, esp                          # 004ab3a8
    push ecx                                     # 004ab3aa
    mov dword ptr [ebp - local_4], ecx           # 004ab3ab
    mov eax, dword ptr [ebp - local_4]           # 004ab3ae
    mov word ptr [eax + field_1e], 0xffff        # 004ab3b1
    mov ecx, dword ptr [ebp - local_4]           # 004ab3b7
    mov word ptr [ecx + field_1c], 0xffff        # 004ab3ba
    mov edx, dword ptr [ebp - local_4]           # 004ab3c0
    mov dword ptr [edx + field_54], 0x0          # 004ab3c3
    mov eax, dword ptr [ebp - local_4]           # 004ab3ca
    mov byte ptr [eax + field_58], 0x0           # 004ab3cd
    mov ecx, dword ptr [ebp - local_4]           # 004ab3d1
    mov byte ptr [ecx + field_59], 0x0           # 004ab3d4
    {load} mov esp, ebp                          # 004ab3d8
    pop ebp                                      # 004ab3da
    ret                                          # 004ab3db

