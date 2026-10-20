# FUN_0045b568
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b568
# extent:       0x0045b568-0x0045b5bb (83 code bytes)
# span:         0x0045b568-0x0045b5bb (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45b568_shift_rect
# naming:       native port src/original_methods_fl16.c:m45b568_shift_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m45b568_shift_rect. Direct test plus a differential test against the original bytes (Unicorn), every original instruction reached. Oracle window runs all 83 bytes. Two rectangle copies shift.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m45b568_shift_rect (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0045b568 - 0x401000
.globl FUN_0045b568
FUN_0045b568:
    # block 0x0045b568: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 0045b568
    {load} mov ebp, esp                          # 0045b569
    push ecx                                     # 0045b56b
    mov dword ptr [ebp - local_4], ecx           # 0045b56c
    mov eax, dword ptr [ebp + arg_8]             # 0045b56f
    mov ecx, dword ptr [eax + field_4]           # 0045b572
    add ecx, dword ptr [0x58318a]                # 0045b575
    mov edx, dword ptr [ebp + arg_c]             # 0045b57b
    mov dword ptr [edx + field_4], ecx           # 0045b57e
    mov eax, dword ptr [ebp + arg_8]             # 0045b581
    mov ecx, dword ptr [eax + field_c]           # 0045b584
    add ecx, dword ptr [0x58318a]                # 0045b587
    mov edx, dword ptr [ebp + arg_c]             # 0045b58d
    mov dword ptr [edx + field_c], ecx           # 0045b590
    mov eax, dword ptr [ebp + arg_8]             # 0045b593
    mov ecx, dword ptr [eax]                     # 0045b596
    add ecx, dword ptr [0x583186]                # 0045b598
    mov edx, dword ptr [ebp + arg_c]             # 0045b59e
    mov dword ptr [edx], ecx                     # 0045b5a1
    mov eax, dword ptr [ebp + arg_8]             # 0045b5a3
    mov ecx, dword ptr [eax + field_8]           # 0045b5a6
    add ecx, dword ptr [0x583186]                # 0045b5a9
    mov edx, dword ptr [ebp + arg_c]             # 0045b5af
    mov dword ptr [edx + field_8], ecx           # 0045b5b2
    {load} mov esp, ebp                          # 0045b5b5
    pop ebp                                      # 0045b5b7
    ret 0x8                                      # 0045b5b8

