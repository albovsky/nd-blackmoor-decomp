# FUN_0049c5f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c5f0
# extent:       0x0049c5f0-0x0049c68a (154 code bytes)
# span:         0x0049c5f0-0x0049c68a (code 154, tables 0, padding 0)
# sha256:       4c3a82abe77f671faf27d80c57f75d352c94cd25f77372429b7506dd1120dcd0
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49c5f0_zero_fields11
# naming:       native port src/original_methods_fl39e.c:m49c5f0_zero_fields11 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 11 immediates into the object (dword +0xde0, dword +0xdec, dword +0xde4, dword +0xe30, dword +0xe34, dword +0xe38, dword +0xe3c, dword +0xe40, dword +0xe44, dword +0xe48. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_de0, field_e30, field_e3c, field_e48; [ecx + n] field_dec, field_e18, field_e34, field_e40; [edx + n] field_de4, field_e38, field_e44
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m49c5f0_zero_fields11 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_de0, 0xde0  # offset +0xde0
.equ field_de4, 0xde4  # offset +0xde4
.equ field_dec, 0xdec  # offset +0xdec
.equ field_e18, 0xe18  # offset +0xe18
.equ field_e30, 0xe30  # offset +0xe30
.equ field_e34, 0xe34  # offset +0xe34
.equ field_e38, 0xe38  # offset +0xe38
.equ field_e3c, 0xe3c  # offset +0xe3c
.equ field_e40, 0xe40  # offset +0xe40
.equ field_e44, 0xe44  # offset +0xe44
.equ field_e48, 0xe48  # offset +0xe48

# --- external targets -----------------------------------------------

.org 0x0049c5f0 - 0x401000
.globl FUN_0049c5f0
FUN_0049c5f0:
    # block 0x0049c5f0: entry, 29 instruction(s), ends with ret
    push ebp                                     # 0049c5f0
    {load} mov ebp, esp                          # 0049c5f1
    push ecx                                     # 0049c5f3
    mov dword ptr [ebp - local_4], ecx           # 0049c5f4
    mov eax, dword ptr [ebp - local_4]           # 0049c5f7
    mov dword ptr [eax + field_de0], 0x0         # 0049c5fa
    mov ecx, dword ptr [ebp - local_4]           # 0049c604
    mov dword ptr [ecx + field_dec], 0x0         # 0049c607
    mov edx, dword ptr [ebp - local_4]           # 0049c611
    mov dword ptr [edx + field_de4], 0x0         # 0049c614
    mov eax, dword ptr [ebp - local_4]           # 0049c61e
    mov dword ptr [eax + field_e30], 0x0         # 0049c621
    mov ecx, dword ptr [ebp - local_4]           # 0049c62b
    mov dword ptr [ecx + field_e34], 0x0         # 0049c62e
    mov edx, dword ptr [ebp - local_4]           # 0049c638
    mov dword ptr [edx + field_e38], 0x0         # 0049c63b
    mov eax, dword ptr [ebp - local_4]           # 0049c645
    mov dword ptr [eax + field_e3c], 0x0         # 0049c648
    mov ecx, dword ptr [ebp - local_4]           # 0049c652
    mov dword ptr [ecx + field_e40], 0x0         # 0049c655
    mov edx, dword ptr [ebp - local_4]           # 0049c65f
    mov dword ptr [edx + field_e44], 0x0         # 0049c662
    mov eax, dword ptr [ebp - local_4]           # 0049c66c
    mov dword ptr [eax + field_e48], 0x0         # 0049c66f
    mov ecx, dword ptr [ebp - local_4]           # 0049c679
    mov dword ptr [ecx + field_e18], 0x0         # 0049c67c
    {load} mov esp, ebp                          # 0049c686
    pop ebp                                      # 0049c688
    ret                                          # 0049c689

