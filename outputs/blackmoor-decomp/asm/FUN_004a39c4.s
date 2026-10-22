# FUN_004a39c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a39c4
# extent:       0x004a39c4-0x004a3a33 (111 code bytes)
# span:         0x004a39c4-0x004a3a33 (code 111, tables 0, padding 0)
# sha256:       1067b8e5c1516a07eb198418fd4b85704aff0f3e93d4e8c65bb5ffa08cc1f510
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a39c4_lifted
# naming:       native port src/original_methods_fl39d.c:m4a39c4_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_210, field_216, field_25c; [ecx + n] field_212, field_258, field_260; [edx + n] field_214, field_272
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4a39c4_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_210, 0x210  # offset +0x210
.equ field_212, 0x212  # offset +0x212
.equ field_214, 0x214  # offset +0x214
.equ field_216, 0x216  # offset +0x216
.equ field_258, 0x258  # offset +0x258
.equ field_25c, 0x25c  # offset +0x25c
.equ field_260, 0x260  # offset +0x260
.equ field_272, 0x272  # offset +0x272

# --- external targets -----------------------------------------------

.org 0x004a39c4 - 0x401000
.globl FUN_004a39c4
FUN_004a39c4:
    # block 0x004a39c4: entry, 23 instruction(s), ends with ret
    push ebp                                     # 004a39c4
    {load} mov ebp, esp                          # 004a39c5
    push ecx                                     # 004a39c7
    mov dword ptr [ebp - local_4], ecx           # 004a39c8
    mov eax, dword ptr [ebp - local_4]           # 004a39cb
    mov dword ptr [eax + field_25c], 0x0         # 004a39ce
    mov ecx, dword ptr [ebp - local_4]           # 004a39d8
    mov dword ptr [ecx + field_258], 0x0         # 004a39db
    mov edx, dword ptr [ebp - local_4]           # 004a39e5
    mov dword ptr [edx + field_272], 0x0         # 004a39e8
    mov eax, dword ptr [ebp - local_4]           # 004a39f2
    mov word ptr [eax + field_210], 0xffff       # 004a39f5
    mov ecx, dword ptr [ebp - local_4]           # 004a39fe
    mov word ptr [ecx + field_212], 0xffff       # 004a3a01
    mov edx, dword ptr [ebp - local_4]           # 004a3a0a
    mov word ptr [edx + field_214], 0xffff       # 004a3a0d
    mov eax, dword ptr [ebp - local_4]           # 004a3a16
    mov word ptr [eax + field_216], 0xffff       # 004a3a19
    mov ecx, dword ptr [ebp - local_4]           # 004a3a22
    mov dword ptr [ecx + field_260], 0x0         # 004a3a25
    {load} mov esp, ebp                          # 004a3a2f
    pop ebp                                      # 004a3a31
    ret                                          # 004a3a32

