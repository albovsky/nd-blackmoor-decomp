# FUN_004a9f27
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9f27
# extent:       0x004a9f27-0x004a9f63 (60 code bytes)
# span:         0x004a9f27-0x004a9f63 (code 60, tables 0, padding 0)
# sha256:       95a5fdf9ded6b017efa2a6365b3f952e7feac5c6171d030fe063b20e59703a56
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a9f27_reset_fields
# naming:       native port src/original_methods_fl32b.c:m4a9f27_reset_fields (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Straight-line reset: words +0x21/+0x29 = 0xffff, dword +0x1d = 0, bytes +0x45..+0x47 = 0; returns this. Every instruction executed; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_21, field_45; [ecx + n] field_29, field_46; [edx + n] field_1d, field_47
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32b.c:m4a9f27_reset_fields (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1d, 0x1d  # offset +0x1d
.equ field_21, 0x21  # offset +0x21
.equ field_29, 0x29  # offset +0x29
.equ field_45, 0x45  # offset +0x45
.equ field_46, 0x46  # offset +0x46
.equ field_47, 0x47  # offset +0x47

# --- external targets -----------------------------------------------

.org 0x004a9f27 - 0x401000
.globl FUN_004a9f27
FUN_004a9f27:
    # block 0x004a9f27: entry, 19 instruction(s), ends with ret
    push ebp                                     # 004a9f27
    {load} mov ebp, esp                          # 004a9f28
    push ecx                                     # 004a9f2a
    mov dword ptr [ebp - local_4], ecx           # 004a9f2b
    mov eax, dword ptr [ebp - local_4]           # 004a9f2e
    mov word ptr [eax + field_21], 0xffff        # 004a9f31
    mov ecx, dword ptr [ebp - local_4]           # 004a9f37
    mov word ptr [ecx + field_29], 0xffff        # 004a9f3a
    mov edx, dword ptr [ebp - local_4]           # 004a9f40
    mov dword ptr [edx + field_1d], 0x0          # 004a9f43
    mov eax, dword ptr [ebp - local_4]           # 004a9f4a
    mov byte ptr [eax + field_45], 0x0           # 004a9f4d
    mov ecx, dword ptr [ebp - local_4]           # 004a9f51
    mov byte ptr [ecx + field_46], 0x0           # 004a9f54
    mov edx, dword ptr [ebp - local_4]           # 004a9f58
    mov byte ptr [edx + field_47], 0x0           # 004a9f5b
    {load} mov esp, ebp                          # 004a9f5f
    pop ebp                                      # 004a9f61
    ret                                          # 004a9f62

