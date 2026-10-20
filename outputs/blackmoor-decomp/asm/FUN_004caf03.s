# FUN_004caf03
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004caf03
# extent:       0x004caf03-0x004caf8a (135 code bytes)
# span:         0x004caf03-0x004caf8a (code 135, tables 0, padding 0)
# sha256:       da7c5a1a9b60e66942a4da5ec532edbbe9196f4b15895f6e625629d6e9ecbc26
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4caf03_reset
# naming:       native port src/original_methods_fl20a.c:m4caf03_reset (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4caf03_reset. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 135 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_e, field_12, field_16, field_14a; [ecx + n] field_8, field_1a, field_154, field_15c; [edx + n] field_c, field_14e, field_158
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20a.c:m4caf03_reset (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_14a, 0x14a  # offset +0x14a
.equ field_14e, 0x14e  # offset +0x14e
.equ field_154, 0x154  # offset +0x154
.equ field_158, 0x158  # offset +0x158
.equ field_15c, 0x15c  # offset +0x15c

# --- external targets -----------------------------------------------

.org 0x004caf03 - 0x401000
.globl FUN_004caf03
FUN_004caf03:
    # block 0x004caf03: entry, 29 instruction(s), ends with ret
    push ebp                                     # 004caf03
    {load} mov ebp, esp                          # 004caf04
    push ecx                                     # 004caf06
    mov dword ptr [ebp - local_4], ecx           # 004caf07
    mov eax, dword ptr [ebp - local_4]           # 004caf0a
    mov dword ptr [eax + field_16], 0x0          # 004caf0d
    mov ecx, dword ptr [ebp - local_4]           # 004caf14
    mov dword ptr [ecx + field_1a], 0x0          # 004caf17
    mov edx, dword ptr [ebp - local_4]           # 004caf1e
    mov word ptr [edx + field_c], 0xffff         # 004caf21
    mov eax, dword ptr [ebp - local_4]           # 004caf27
    mov dword ptr [eax + field_e], 0x0           # 004caf2a
    mov ecx, dword ptr [ebp - local_4]           # 004caf31
    mov dword ptr [ecx + field_8], 0x0           # 004caf34
    mov edx, dword ptr [ebp - local_4]           # 004caf3b
    mov dword ptr [edx + field_14e], 0x0         # 004caf3e
    mov eax, dword ptr [ebp - local_4]           # 004caf48
    mov dword ptr [eax + field_12], 0x0          # 004caf4b
    mov ecx, dword ptr [ebp - local_4]           # 004caf52
    mov dword ptr [ecx + field_154], 0x0         # 004caf55
    mov edx, dword ptr [ebp - local_4]           # 004caf5f
    mov dword ptr [edx + field_158], 0x0         # 004caf62
    mov eax, dword ptr [ebp - local_4]           # 004caf6c
    mov dword ptr [eax + field_14a], 0xffffffff  # 004caf6f
    mov ecx, dword ptr [ebp - local_4]           # 004caf79
    mov dword ptr [ecx + field_15c], 0x0         # 004caf7c
    {load} mov esp, ebp                          # 004caf86
    pop ebp                                      # 004caf88
    ret                                          # 004caf89

