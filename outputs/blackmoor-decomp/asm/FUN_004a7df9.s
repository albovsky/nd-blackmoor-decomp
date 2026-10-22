# FUN_004a7df9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7df9
# extent:       0x004a7df9-0x004a7e50 (87 code bytes)
# span:         0x004a7df9-0x004a7e50 (code 87, tables 0, padding 0)
# sha256:       7d09e74a92ab1a552e7a168038f9d8cbd8ee14e3b8d4a961385fe9421fd9494b
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a7df9_lifted
# naming:       native port src/original_methods_fl39d.c:m4a7df9_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_e0e, field_e5a; [ecx + n] field_e0c, field_e56; [edx + n] field_e5e, field_e76
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4a7df9_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_e0c, 0xe0c  # offset +0xe0c
.equ field_e0e, 0xe0e  # offset +0xe0e
.equ field_e56, 0xe56  # offset +0xe56
.equ field_e5a, 0xe5a  # offset +0xe5a
.equ field_e5e, 0xe5e  # offset +0xe5e
.equ field_e76, 0xe76  # offset +0xe76

# --- external targets -----------------------------------------------

.org 0x004a7df9 - 0x401000
.globl FUN_004a7df9
FUN_004a7df9:
    # block 0x004a7df9: entry, 19 instruction(s), ends with ret
    push ebp                                     # 004a7df9
    {load} mov ebp, esp                          # 004a7dfa
    push ecx                                     # 004a7dfc
    mov dword ptr [ebp - local_4], ecx           # 004a7dfd
    mov eax, dword ptr [ebp - local_4]           # 004a7e00
    mov dword ptr [eax + field_e5a], 0x0         # 004a7e03
    mov ecx, dword ptr [ebp - local_4]           # 004a7e0d
    mov dword ptr [ecx + field_e56], 0x0         # 004a7e10
    mov edx, dword ptr [ebp - local_4]           # 004a7e1a
    mov dword ptr [edx + field_e76], 0x0         # 004a7e1d
    mov eax, dword ptr [ebp - local_4]           # 004a7e27
    mov word ptr [eax + field_e0e], 0xffff       # 004a7e2a
    mov ecx, dword ptr [ebp - local_4]           # 004a7e33
    mov word ptr [ecx + field_e0c], 0xffff       # 004a7e36
    mov edx, dword ptr [ebp - local_4]           # 004a7e3f
    mov dword ptr [edx + field_e5e], 0x0         # 004a7e42
    {load} mov esp, ebp                          # 004a7e4c
    pop ebp                                      # 004a7e4e
    ret                                          # 004a7e4f

