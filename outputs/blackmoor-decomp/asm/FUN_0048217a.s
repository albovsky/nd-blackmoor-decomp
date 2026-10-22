# FUN_0048217a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048217a
# extent:       0x0048217a-0x004821ab (49 code bytes)
# span:         0x0048217a-0x004821ab (code 49, tables 0, padding 0)
# sha256:       15acc6e7579e88f0a83ebeaea1df2f51a3e2334bd1cd43a2e8073b79e48ab3e1
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48217a_lifted
# naming:       native port src/original_methods_fl39d.c:m48217a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_a8; [ecx + n] field_1c; [edx + n] field_20
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m48217a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_a8, 0xa8  # offset +0xa8

# --- external targets -----------------------------------------------

.org 0x0048217a - 0x401000
.globl FUN_0048217a
FUN_0048217a:
    # block 0x0048217a: entry, 15 instruction(s), ends with ret
    push ebp                                     # 0048217a
    {load} mov ebp, esp                          # 0048217b
    push ecx                                     # 0048217d
    mov dword ptr [ebp - local_4], ecx           # 0048217e
    mov eax, dword ptr [ebp - local_4]           # 00482181
    mov word ptr [eax + field_1e], 0xffff        # 00482184
    mov ecx, dword ptr [ebp - local_4]           # 0048218a
    mov word ptr [ecx + field_1c], 0xffff        # 0048218d
    mov edx, dword ptr [ebp - local_4]           # 00482193
    mov dword ptr [edx + field_20], 0x0          # 00482196
    mov eax, dword ptr [ebp - local_4]           # 0048219d
    mov byte ptr [eax + field_a8], 0x0           # 004821a0
    {load} mov esp, ebp                          # 004821a7
    pop ebp                                      # 004821a9
    ret                                          # 004821aa

