# FUN_004ae452
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ae452
# extent:       0x004ae452-0x004ae495 (67 code bytes)
# span:         0x004ae452-0x004ae495 (code 67, tables 0, padding 0)
# sha256:       a00da8d93d80868d2425bcf7b57c1a794493e16e952f8516522f61c58fb64edd
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ae452_copy_sub_dword
# naming:       native port src/original_methods_fl39e.c:m4ae452_copy_sub_dword (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Finds the sub-record rec = self+idx*0xc7+0x6e, sub = rec + byte[rec+0x26]*0x28 + 0x27 and copies dword [sub+0x4] to [sub+0x8]; pops 4 bytes. Byte indexes up to 0xff (zero-extended). No jumps; all 23 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_26; [ecx + n] field_8, field_6e; [edx + n] field_4, field_27
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4ae452_copy_sub_dword (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_6e, 0x6e  # offset +0x6e

# --- external targets -----------------------------------------------

.org 0x004ae452 - 0x401000
.globl FUN_004ae452
FUN_004ae452:
    # block 0x004ae452: entry, 23 instruction(s), ends with ret 0x4
    push ebp                                     # 004ae452
    {load} mov ebp, esp                          # 004ae453
    sub esp, 0xc                                 # 004ae455
    mov dword ptr [ebp - local_c], ecx           # 004ae458
    mov eax, dword ptr [ebp + arg_8]             # 004ae45b
    imul eax, eax, 0xc7                          # 004ae45e
    mov ecx, dword ptr [ebp - local_c]           # 004ae464
    lea edx, [ecx + eax + field_6e]              # 004ae467
    mov dword ptr [ebp - local_8], edx           # 004ae46b
    mov eax, dword ptr [ebp - local_8]           # 004ae46e
    {load} xor ecx, ecx                          # 004ae471
    mov cl, byte ptr [eax + field_26]            # 004ae473
    imul ecx, ecx, 0x28                          # 004ae476
    mov edx, dword ptr [ebp - local_8]           # 004ae479
    lea eax, [edx + ecx + field_27]              # 004ae47c
    mov dword ptr [ebp - local_4], eax           # 004ae480
    mov ecx, dword ptr [ebp - local_4]           # 004ae483
    mov edx, dword ptr [ebp - local_4]           # 004ae486
    mov eax, dword ptr [edx + field_4]           # 004ae489
    mov dword ptr [ecx + field_8], eax           # 004ae48c
    {load} mov esp, ebp                          # 004ae48f
    pop ebp                                      # 004ae491
    ret 0x4                                      # 004ae492

