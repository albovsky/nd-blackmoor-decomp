# FUN_004d52b9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d52b9
# extent:       0x004d52b9-0x004d5316 (93 code bytes)
# span:         0x004d52b9-0x004d5316 (code 93, tables 0, padding 0)
# sha256:       24e94d18d7f999d8c3285bfc4cc720847636292c71a0818acad9c4014fbbfd6e
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d52b9_init_record
# naming:       native port src/original_methods_fl39f.c:m4d52b9_init_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Straight-line initialiser in the order of the original: zero 0x80 bytes at [this+0x4] (rep stosd), then zero 0x10 bytes at [this+0x84] (rep stosd), then zero 0x10 bytes at [this+0x94]. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4d52b9_init_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x004d52b9 - 0x401000
.globl FUN_004d52b9
FUN_004d52b9:
    # block 0x004d52b9: entry, 35 instruction(s), ends with ret
    push ebp                                     # 004d52b9
    {load} mov ebp, esp                          # 004d52ba
    push ecx                                     # 004d52bc
    push edi                                     # 004d52bd
    mov dword ptr [ebp - local_4], ecx           # 004d52be
    mov ecx, 0x20                                # 004d52c1
    {load} xor eax, eax                          # 004d52c6
    mov edi, dword ptr [ebp - local_4]           # 004d52c8
    add edi, 0x4                                 # 004d52cb
    rep stosd dword ptr es:[edi], eax            # 004d52ce
    {load} xor eax, eax                          # 004d52d0
    mov ecx, dword ptr [ebp - local_4]           # 004d52d2
    add ecx, 0x84                                # 004d52d5
    mov dword ptr [ecx], eax                     # 004d52db
    mov dword ptr [ecx + field_4], eax           # 004d52dd
    mov dword ptr [ecx + field_8], eax           # 004d52e0
    mov dword ptr [ecx + field_c], eax           # 004d52e3
    {load} xor edx, edx                          # 004d52e6
    mov eax, dword ptr [ebp - local_4]           # 004d52e8
    add eax, 0x94                                # 004d52eb
    mov dword ptr [eax], edx                     # 004d52f0
    mov dword ptr [eax + field_4], edx           # 004d52f2
    mov dword ptr [eax + field_8], edx           # 004d52f5
    mov dword ptr [eax + field_c], edx           # 004d52f8
    {load} xor ecx, ecx                          # 004d52fb
    mov edx, dword ptr [ebp - local_4]           # 004d52fd
    add edx, 0xa4                                # 004d5300
    mov dword ptr [edx], ecx                     # 004d5306
    mov dword ptr [edx + field_4], ecx           # 004d5308
    mov dword ptr [edx + field_8], ecx           # 004d530b
    mov dword ptr [edx + field_c], ecx           # 004d530e
    pop edi                                      # 004d5311
    {load} mov esp, ebp                          # 004d5312
    pop ebp                                      # 004d5314
    ret                                          # 004d5315

