# FUN_0048e28a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e28a
# extent:       0x0048e28a-0x0048e2f5 (107 code bytes)
# span:         0x0048e28a-0x0048e2f5 (code 107, tables 0, padding 0)
# sha256:       0bb2c5caf82e0b6cfb08399789d7e81e5b1c4b6eca06dc97cde5006d1911d2a1
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48e28a_lifted
# naming:       native port src/original_methods_fl39d.c:m48e28a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_451, field_45c; [ecx + n] field_1c, field_45a, field_45d; [edx + n] field_3fe, field_45b, field_462
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m48e28a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 25 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_3fe, 0x3fe  # offset +0x3fe
.equ field_451, 0x451  # offset +0x451
.equ field_45a, 0x45a  # offset +0x45a
.equ field_45b, 0x45b  # offset +0x45b
.equ field_45c, 0x45c  # offset +0x45c
.equ field_45d, 0x45d  # offset +0x45d
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------

.org 0x0048e28a - 0x401000
.globl FUN_0048e28a
FUN_0048e28a:
    # block 0x0048e28a: entry, 25 instruction(s), ends with ret
    push ebp                                     # 0048e28a
    {load} mov ebp, esp                          # 0048e28b
    push ecx                                     # 0048e28d
    mov dword ptr [ebp - local_4], ecx           # 0048e28e
    mov eax, dword ptr [ebp - local_4]           # 0048e291
    mov word ptr [eax + field_1e], 0xffff        # 0048e294
    mov ecx, dword ptr [ebp - local_4]           # 0048e29a
    mov word ptr [ecx + field_1c], 0xffff        # 0048e29d
    mov edx, dword ptr [ebp - local_4]           # 0048e2a3
    mov dword ptr [edx + field_462], 0x0         # 0048e2a6
    mov eax, dword ptr [ebp - local_4]           # 0048e2b0
    mov byte ptr [eax + field_451], 0x0          # 0048e2b3
    mov ecx, dword ptr [ebp - local_4]           # 0048e2ba
    mov byte ptr [ecx + field_45a], 0x0          # 0048e2bd
    mov edx, dword ptr [ebp - local_4]           # 0048e2c4
    mov byte ptr [edx + field_45b], 0x0          # 0048e2c7
    mov eax, dword ptr [ebp - local_4]           # 0048e2ce
    mov byte ptr [eax + field_45c], 0x0          # 0048e2d1
    mov ecx, dword ptr [ebp - local_4]           # 0048e2d8
    mov dword ptr [ecx + field_45d], 0x0         # 0048e2db
    mov edx, dword ptr [ebp - local_4]           # 0048e2e5
    mov word ptr [edx + field_3fe], 0x0          # 0048e2e8
    {load} mov esp, ebp                          # 0048e2f1
    pop ebp                                      # 0048e2f3
    ret                                          # 0048e2f4

