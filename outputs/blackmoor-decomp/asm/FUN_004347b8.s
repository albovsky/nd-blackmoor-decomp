# FUN_004347b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004347b8
# extent:       0x004347b8-0x00434814 (92 code bytes)
# span:         0x004347b8-0x00434814 (code 92, tables 0, padding 0)
# sha256:       3b5fdf9a79b6041001de33ca7f5bbc7e829fdfbd9562385e3961cfd5c2e7ce2e
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4347b8_read_be32
# naming:       native port src/original_methods_fl16.c:m4347b8_read_be32 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4347b8_read_be32. Direct test plus a differential test against the original bytes (Unicorn), every original instruction reached. Oracle window runs all 92 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [edx + n] field_1, field_2, field_3
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4347b8_read_be32 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004347b8 - 0x401000
.globl FUN_004347b8
FUN_004347b8:
    # block 0x004347b8: entry, 34 instruction(s), ends with ret 0x4
    push ebp                                     # 004347b8
    {load} mov ebp, esp                          # 004347b9
    sub esp, 0x8                                 # 004347bb
    mov dword ptr [ebp - local_8], ecx           # 004347be
    mov dword ptr [ebp - local_4], 0x0           # 004347c1
    mov eax, dword ptr [ebp + arg_8]             # 004347c8
    {load} xor ecx, ecx                          # 004347cb
    mov cl, byte ptr [eax]                       # 004347cd
    shl ecx, 0x18                                # 004347cf
    mov dword ptr [ebp - local_4], ecx           # 004347d2
    mov edx, dword ptr [ebp + arg_8]             # 004347d5
    {load} xor eax, eax                          # 004347d8
    mov al, byte ptr [edx + field_1]             # 004347da
    shl eax, 0x10                                # 004347dd
    mov ecx, dword ptr [ebp - local_4]           # 004347e0
    {load} or ecx, eax                           # 004347e3
    mov dword ptr [ebp - local_4], ecx           # 004347e5
    mov edx, dword ptr [ebp + arg_8]             # 004347e8
    {load} xor eax, eax                          # 004347eb
    mov al, byte ptr [edx + field_2]             # 004347ed
    shl eax, 0x8                                 # 004347f0
    mov ecx, dword ptr [ebp - local_4]           # 004347f3
    {load} or ecx, eax                           # 004347f6
    mov dword ptr [ebp - local_4], ecx           # 004347f8
    mov edx, dword ptr [ebp + arg_8]             # 004347fb
    {load} xor eax, eax                          # 004347fe
    mov al, byte ptr [edx + field_3]             # 00434800
    mov ecx, dword ptr [ebp - local_4]           # 00434803
    {load} or ecx, eax                           # 00434806
    mov dword ptr [ebp - local_4], ecx           # 00434808
    mov eax, dword ptr [ebp - local_4]           # 0043480b
    {load} mov esp, ebp                          # 0043480e
    pop ebp                                      # 00434810
    ret 0x4                                      # 00434811

