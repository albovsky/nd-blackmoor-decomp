# FUN_004e1c9f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1c9f
# extent:       0x004e1c9f-0x004e1d34 (149 code bytes)
# span:         0x004e1c9f-0x004e1d34 (code 149, tables 0, padding 0)
# sha256:       f23a7c6ae989827bf47940fb5d37166111e34288ef123f45b371e8fe13aa61f3
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e1c9f_lifted
# naming:       native port src/original_methods_fl39d.c:m4e1c9f_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_18, field_28, field_177, field_187; [ecx + n] field_1c, field_17b, field_183, field_18b; [edx + n] field_14, field_20, field_24, field_17f
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e1c9f_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_177, 0x177  # offset +0x177
.equ field_17b, 0x17b  # offset +0x17b
.equ field_17f, 0x17f  # offset +0x17f
.equ field_183, 0x183  # offset +0x183
.equ field_187, 0x187  # offset +0x187
.equ field_18b, 0x18b  # offset +0x18b

# --- external targets -----------------------------------------------

.org 0x004e1c9f - 0x401000
.globl FUN_004e1c9f
FUN_004e1c9f:
    # block 0x004e1c9f: entry, 31 instruction(s), ends with ret
    push ebp                                     # 004e1c9f
    {load} mov ebp, esp                          # 004e1ca0
    push ecx                                     # 004e1ca2
    mov dword ptr [ebp - local_4], ecx           # 004e1ca3
    mov eax, dword ptr [ebp - local_4]           # 004e1ca6
    mov dword ptr [eax + field_177], 0x0         # 004e1ca9
    mov ecx, dword ptr [ebp - local_4]           # 004e1cb3
    mov dword ptr [ecx + field_17b], 0x0         # 004e1cb6
    mov edx, dword ptr [ebp - local_4]           # 004e1cc0
    mov dword ptr [edx + field_24], 0x0          # 004e1cc3
    mov eax, dword ptr [ebp - local_4]           # 004e1cca
    mov dword ptr [eax + field_28], 0x0          # 004e1ccd
    mov ecx, dword ptr [ebp - local_4]           # 004e1cd4
    mov dword ptr [ecx + field_183], 0x0         # 004e1cd7
    mov edx, dword ptr [ebp - local_4]           # 004e1ce1
    mov dword ptr [edx + field_17f], 0x0         # 004e1ce4
    mov eax, dword ptr [ebp - local_4]           # 004e1cee
    mov dword ptr [eax + field_187], 0x0         # 004e1cf1
    mov ecx, dword ptr [ebp - local_4]           # 004e1cfb
    mov dword ptr [ecx + field_18b], 0x0         # 004e1cfe
    mov edx, dword ptr [ebp - local_4]           # 004e1d08
    mov dword ptr [edx + field_14], 0x0          # 004e1d0b
    mov eax, dword ptr [ebp - local_4]           # 004e1d12
    mov dword ptr [eax + field_18], 0x0          # 004e1d15
    mov ecx, dword ptr [ebp - local_4]           # 004e1d1c
    mov dword ptr [ecx + field_1c], 0x0          # 004e1d1f
    mov edx, dword ptr [ebp - local_4]           # 004e1d26
    mov dword ptr [edx + field_20], 0x0          # 004e1d29
    {load} mov esp, ebp                          # 004e1d30
    pop ebp                                      # 004e1d32
    ret                                          # 004e1d33

