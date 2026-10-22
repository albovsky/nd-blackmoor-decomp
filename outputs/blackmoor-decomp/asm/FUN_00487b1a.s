# FUN_00487b1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487b1a
# extent:       0x00487b1a-0x00487b4f (53 code bytes)
# span:         0x00487b1a-0x00487b4f (code 53, tables 0, padding 0)
# sha256:       099f1f1c967b8f8c9a4fc425fb272fb47ae85190e4ee89f507921967aa2b37dd
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m487b1a_init_fields5
# naming:       native port src/original_methods_fl39e.c:m487b1a_init_fields5 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 5 immediates into the object (word +0x1e, word +0x1c, dword +0x71, byte +0x75, byte +0x70) with the widths of the original, in order; nothing else is written, nothing is called. No jumps; all 17 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_75; [ecx + n] field_1c, field_70; [edx + n] field_71
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m487b1a_init_fields5 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_70, 0x70  # offset +0x70
.equ field_71, 0x71  # offset +0x71
.equ field_75, 0x75  # offset +0x75

# --- external targets -----------------------------------------------

.org 0x00487b1a - 0x401000
.globl FUN_00487b1a
FUN_00487b1a:
    # block 0x00487b1a: entry, 17 instruction(s), ends with ret
    push ebp                                     # 00487b1a
    {load} mov ebp, esp                          # 00487b1b
    push ecx                                     # 00487b1d
    mov dword ptr [ebp - local_4], ecx           # 00487b1e
    mov eax, dword ptr [ebp - local_4]           # 00487b21
    mov word ptr [eax + field_1e], 0xffff        # 00487b24
    mov ecx, dword ptr [ebp - local_4]           # 00487b2a
    mov word ptr [ecx + field_1c], 0xffff        # 00487b2d
    mov edx, dword ptr [ebp - local_4]           # 00487b33
    mov dword ptr [edx + field_71], 0x0          # 00487b36
    mov eax, dword ptr [ebp - local_4]           # 00487b3d
    mov byte ptr [eax + field_75], 0x0           # 00487b40
    mov ecx, dword ptr [ebp - local_4]           # 00487b44
    mov byte ptr [ecx + field_70], 0x0           # 00487b47
    {load} mov esp, ebp                          # 00487b4b
    pop ebp                                      # 00487b4d
    ret                                          # 00487b4e

