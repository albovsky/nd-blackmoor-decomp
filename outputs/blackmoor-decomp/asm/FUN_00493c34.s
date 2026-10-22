# FUN_00493c34
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00493c34
# extent:       0x00493c34-0x00493ca3 (111 code bytes)
# span:         0x00493c34-0x00493ca3 (code 111, tables 0, padding 0)
# sha256:       80b279c71bb7c60260c2452d6ccc9a1f280a4e28bbe7a2850d2f9a1c0c18d376
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m493c34_lifted
# naming:       native port src/original_methods_fl39d.c:m493c34_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1ef7, field_1eff; [ecx + n] field_1efb, field_1f03, field_1f07, field_1f0b, field_47d1; [edx + n] field_1ef7, field_1efb, field_47d1
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m493c34_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1ef7, 0x1ef7  # offset +0x1ef7
.equ field_1efb, 0x1efb  # offset +0x1efb
.equ field_1eff, 0x1eff  # offset +0x1eff
.equ field_1f03, 0x1f03  # offset +0x1f03
.equ field_1f07, 0x1f07  # offset +0x1f07
.equ field_1f0b, 0x1f0b  # offset +0x1f0b
.equ field_47d1, 0x47d1  # offset +0x47d1

# --- external targets -----------------------------------------------

.org 0x00493c34 - 0x401000
.globl FUN_00493c34
FUN_00493c34:
    # block 0x00493c34: entry, 31 instruction(s), ends with ret
    push ebp                                     # 00493c34
    {load} mov ebp, esp                          # 00493c35
    push ecx                                     # 00493c37
    mov dword ptr [ebp - local_4], ecx           # 00493c38
    mov eax, dword ptr [ebp - local_4]           # 00493c3b
    mov ecx, dword ptr [ebp - local_4]           # 00493c3e
    mov edx, dword ptr [eax + field_1ef7]        # 00493c41
    mov ecx, dword ptr [ecx + field_47d1]        # 00493c47
    sar edx, cl                                  # 00493c4d
    mov eax, dword ptr [ebp - local_4]           # 00493c4f
    mov dword ptr [eax + field_1eff], edx        # 00493c52
    mov ecx, dword ptr [ebp - local_4]           # 00493c58
    mov edx, dword ptr [ebp - local_4]           # 00493c5b
    mov eax, dword ptr [ecx + field_1efb]        # 00493c5e
    mov ecx, dword ptr [edx + field_47d1]        # 00493c64
    sar eax, cl                                  # 00493c6a
    mov ecx, dword ptr [ebp - local_4]           # 00493c6c
    mov dword ptr [ecx + field_1f03], eax        # 00493c6f
    mov edx, dword ptr [ebp - local_4]           # 00493c75
    mov eax, dword ptr [edx + field_1ef7]        # 00493c78
    and eax, 0x7f                                # 00493c7e
    mov ecx, dword ptr [ebp - local_4]           # 00493c81
    mov dword ptr [ecx + field_1f07], eax        # 00493c84
    mov edx, dword ptr [ebp - local_4]           # 00493c8a
    mov eax, dword ptr [edx + field_1efb]        # 00493c8d
    and eax, 0x7f                                # 00493c93
    mov ecx, dword ptr [ebp - local_4]           # 00493c96
    mov dword ptr [ecx + field_1f0b], eax        # 00493c99
    {load} mov esp, ebp                          # 00493c9f
    pop ebp                                      # 00493ca1
    ret                                          # 00493ca2

