# FUN_004bf63b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf63b
# extent:       0x004bf63b-0x004bf773 (312 code bytes)
# span:         0x004bf63b-0x004bf773 (code 312, tables 0, padding 0)
# sha256:       e977aa9020e987efa29aa94800d8b733a91f286497a0b16f625a1da840eb6951
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf63b_lifted
# naming:       native port src/original_methods_fl39d.c:m4bf63b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2d, field_55, field_182, field_18c, field_1d6, field_21a, field_23c, field_240; [ecx + n] field_29, field_31, field_17a, field_186, field_21e, field_226, field_244, field_246; [edx + n] field_35, field_17e, field_18a, field_18e, field_216, field_222, field_22a, field_24a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4bf63b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 56 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_55, 0x55  # offset +0x55
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_182, 0x182  # offset +0x182
.equ field_186, 0x186  # offset +0x186
.equ field_18a, 0x18a  # offset +0x18a
.equ field_18c, 0x18c  # offset +0x18c
.equ field_18e, 0x18e  # offset +0x18e
.equ field_1d6, 0x1d6  # offset +0x1d6
.equ field_216, 0x216  # offset +0x216
.equ field_21a, 0x21a  # offset +0x21a
.equ field_21e, 0x21e  # offset +0x21e
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_22a, 0x22a  # offset +0x22a
.equ field_23c, 0x23c  # offset +0x23c
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244
.equ field_246, 0x246  # offset +0x246
.equ field_24a, 0x24a  # offset +0x24a

# --- external targets -----------------------------------------------

.org 0x004bf63b - 0x401000
.globl FUN_004bf63b
FUN_004bf63b:
    # block 0x004bf63b: entry, 56 instruction(s), ends with ret
    push ebp                                     # 004bf63b
    {load} mov ebp, esp                          # 004bf63c
    push ecx                                     # 004bf63e
    mov dword ptr [ebp - local_4], ecx           # 004bf63f
    mov eax, dword ptr [ebp - local_4]           # 004bf642
    mov dword ptr [eax + field_23c], 0x0         # 004bf645
    mov ecx, dword ptr [ebp - local_4]           # 004bf64f
    mov dword ptr [ecx + field_246], 0x0         # 004bf652
    mov edx, dword ptr [ebp - local_4]           # 004bf65c
    mov dword ptr [edx + field_216], 0x0         # 004bf65f
    mov eax, dword ptr [ebp - local_4]           # 004bf669
    mov dword ptr [eax + field_21a], 0x0         # 004bf66c
    mov ecx, dword ptr [ebp - local_4]           # 004bf676
    mov dword ptr [ecx + field_21e], 0x0         # 004bf679
    mov edx, dword ptr [ebp - local_4]           # 004bf683
    mov dword ptr [edx + field_222], 0x0         # 004bf686
    mov eax, dword ptr [ebp - local_4]           # 004bf690
    mov dword ptr [eax + field_1d6], 0x0         # 004bf693
    mov ecx, dword ptr [ebp - local_4]           # 004bf69d
    mov dword ptr [ecx + field_226], 0x0         # 004bf6a0
    mov edx, dword ptr [ebp - local_4]           # 004bf6aa
    mov dword ptr [edx + field_22a], 0x0         # 004bf6ad
    mov eax, dword ptr [ebp - local_4]           # 004bf6b7
    mov byte ptr [eax + field_55], 0x0           # 004bf6ba
    mov ecx, dword ptr [ebp - local_4]           # 004bf6be
    mov dword ptr [ecx + field_29], 0x0          # 004bf6c1
    mov edx, dword ptr [ebp - local_4]           # 004bf6c8
    mov dword ptr [edx + field_35], 0x0          # 004bf6cb
    mov eax, dword ptr [ebp - local_4]           # 004bf6d2
    mov dword ptr [eax + field_2d], 0x0          # 004bf6d5
    mov ecx, dword ptr [ebp - local_4]           # 004bf6dc
    mov dword ptr [ecx + field_31], 0x0          # 004bf6df
    mov edx, dword ptr [ebp - local_4]           # 004bf6e6
    mov dword ptr [edx + field_18e], 0x0         # 004bf6e9
    mov eax, dword ptr [ebp - local_4]           # 004bf6f3
    mov dword ptr [eax + field_182], 0x0         # 004bf6f6
    mov ecx, dword ptr [ebp - local_4]           # 004bf700
    mov dword ptr [ecx + field_186], 0x0         # 004bf703
    mov edx, dword ptr [ebp - local_4]           # 004bf70d
    mov word ptr [edx + field_18a], 0x0          # 004bf710
    mov eax, dword ptr [ebp - local_4]           # 004bf719
    mov word ptr [eax + field_18c], 0x0          # 004bf71c
    mov ecx, dword ptr [ebp - local_4]           # 004bf725
    mov dword ptr [ecx + field_17a], 0x1         # 004bf728
    mov edx, dword ptr [ebp - local_4]           # 004bf732
    mov dword ptr [edx + field_17e], 0x0         # 004bf735
    mov dword ptr [0x5d19fb], 0x0                # 004bf73f
    mov eax, dword ptr [ebp - local_4]           # 004bf749
    mov dword ptr [eax + field_240], 0x0         # 004bf74c
    mov ecx, dword ptr [ebp - local_4]           # 004bf756
    mov word ptr [ecx + field_244], 0xffff       # 004bf759
    mov edx, dword ptr [ebp - local_4]           # 004bf762
    mov dword ptr [edx + field_24a], 0x0         # 004bf765
    {load} mov esp, ebp                          # 004bf76f
    pop ebp                                      # 004bf771
    ret                                          # 004bf772

