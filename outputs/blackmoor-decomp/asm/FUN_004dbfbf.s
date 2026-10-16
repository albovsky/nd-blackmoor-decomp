# FUN_004dbfbf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dbfbf
# extent:       0x004dbfbf-0x004dc043 (132 code bytes)
# span:         0x004dbfbf-0x004dc043 (code 132, tables 0, padding 0)
# sha256:       c27fdf4c1c974ff1118c3d93c972bed60e7660800593534307f894fae91deb58
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dbfbf
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4a, field_ee, field_f6, field_102; [ecx + n] field_1c, field_fa, field_106; [edx + n] field_46, field_f2, field_fe
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_46, 0x46  # offset +0x46
.equ field_4a, 0x4a  # offset +0x4a
.equ field_ee, 0xee  # offset +0xee
.equ field_f2, 0xf2  # offset +0xf2
.equ field_f6, 0xf6  # offset +0xf6
.equ field_fa, 0xfa  # offset +0xfa
.equ field_fe, 0xfe  # offset +0xfe
.equ field_102, 0x102  # offset +0x102
.equ field_106, 0x106  # offset +0x106

# --- external targets -----------------------------------------------

.org 0x004dbfbf - 0x401000
.globl FUN_004dbfbf
FUN_004dbfbf:
    # block 0x004dbfbf: entry, 27 instruction(s), ends with ret
    push ebp                                     # 004dbfbf
    {load} mov ebp, esp                          # 004dbfc0
    push ecx                                     # 004dbfc2
    mov dword ptr [ebp - local_4], ecx           # 004dbfc3
    mov eax, dword ptr [ebp - local_4]           # 004dbfc6
    mov dword ptr [eax + field_ee], 0x637fd7     # 004dbfc9
    mov ecx, dword ptr [ebp - local_4]           # 004dbfd3
    mov dword ptr [ecx + field_1c], 0x0          # 004dbfd6
    mov edx, dword ptr [ebp - local_4]           # 004dbfdd
    mov dword ptr [edx + field_46], 0x0          # 004dbfe0
    mov eax, dword ptr [ebp - local_4]           # 004dbfe7
    mov dword ptr [eax + field_4a], 0x0          # 004dbfea
    mov ecx, dword ptr [ebp - local_4]           # 004dbff1
    mov dword ptr [ecx + field_106], 0x0         # 004dbff4
    mov edx, dword ptr [ebp - local_4]           # 004dbffe
    mov dword ptr [edx + field_f2], 0x1          # 004dc001
    mov eax, dword ptr [ebp - local_4]           # 004dc00b
    mov dword ptr [eax + field_f6], 0x0          # 004dc00e
    mov ecx, dword ptr [ebp - local_4]           # 004dc018
    mov dword ptr [ecx + field_fa], 0x0          # 004dc01b
    mov edx, dword ptr [ebp - local_4]           # 004dc025
    mov dword ptr [edx + field_fe], 0x0          # 004dc028
    mov eax, dword ptr [ebp - local_4]           # 004dc032
    mov dword ptr [eax + field_102], 0x0         # 004dc035
    {load} mov esp, ebp                          # 004dc03f
    pop ebp                                      # 004dc041
    ret                                          # 004dc042

