# FUN_004781fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004781fa
# extent:       0x004781fa-0x0047823e (68 code bytes)
# span:         0x004781fa-0x0047823e (code 68, tables 0, padding 0)
# sha256:       39add3d2ff0d4db161889dd29b52b1feb2fe73f0ca151ddd1bc2f2031a24fe08
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4781fa_reset_fields
# naming:       native port src/original_methods_fl32b.c:m4781fa_reset_fields (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Straight-line reset: words +0x1e/+0x1c = 0xffff, dwords +0x157a, +0x157e, +0x1576 = 0; returns this. Every instruction executed; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_157e; [ecx + n] field_1c, field_1576; [edx + n] field_157a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32b.c:m4781fa_reset_fields (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1576, 0x1576  # offset +0x1576
.equ field_157a, 0x157a  # offset +0x157a
.equ field_157e, 0x157e  # offset +0x157e

# --- external targets -----------------------------------------------

.org 0x004781fa - 0x401000
.globl FUN_004781fa
FUN_004781fa:
    # block 0x004781fa: entry, 17 instruction(s), ends with ret
    push ebp                                     # 004781fa
    {load} mov ebp, esp                          # 004781fb
    push ecx                                     # 004781fd
    mov dword ptr [ebp - local_4], ecx           # 004781fe
    mov eax, dword ptr [ebp - local_4]           # 00478201
    mov word ptr [eax + field_1e], 0xffff        # 00478204
    mov ecx, dword ptr [ebp - local_4]           # 0047820a
    mov word ptr [ecx + field_1c], 0xffff        # 0047820d
    mov edx, dword ptr [ebp - local_4]           # 00478213
    mov dword ptr [edx + field_157a], 0x0        # 00478216
    mov eax, dword ptr [ebp - local_4]           # 00478220
    mov dword ptr [eax + field_157e], 0x0        # 00478223
    mov ecx, dword ptr [ebp - local_4]           # 0047822d
    mov dword ptr [ecx + field_1576], 0x0        # 00478230
    {load} mov esp, ebp                          # 0047823a
    pop ebp                                      # 0047823c
    ret                                          # 0047823d

