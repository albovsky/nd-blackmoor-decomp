# FUN_004d3bef
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3bef
# extent:       0x004d3bef-0x004d3c1d (46 code bytes)
# span:         0x004d3bef-0x004d3c1d (code 46, tables 0, padding 0)
# sha256:       54b97b80d61bcb1486bec09c9d41dbe49dfc88290912d0b1b612b18ad77bfe29
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3bef_reset_flags
# naming:       native port src/original_methods_fl24a.c:m4d3bef_reset_flags (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4d3bef_reset_flags (clears [+0x462], sets [+0x1c] on the byte at 0x61c6ae). Direct, Unicorn differential and oracle: every instruction reached. See tasks/fl24a-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_462; [edx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24a.c:m4d3bef_reset_flags (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------

.org 0x004d3bef - 0x401000
.globl FUN_004d3bef
FUN_004d3bef:
    # block 0x004d3bef: entry, 10 instruction(s), ends with je to 0x004d3c19 (forward)
    push ebp                                     # 004d3bef
    {load} mov ebp, esp                          # 004d3bf0
    push ecx                                     # 004d3bf2
    mov dword ptr [ebp - local_4], ecx           # 004d3bf3
    mov eax, dword ptr [ebp - local_4]           # 004d3bf6
    mov dword ptr [eax + field_462], 0x0         # 004d3bf9
    {load} xor ecx, ecx                          # 004d3c03
    mov cl, byte ptr [0x61c6ae]                  # 004d3c05
    test ecx, ecx                                # 004d3c0b
    je.d8 L_004d3c19                             # 004d3c0d
    # block 0x004d3c0f: entered by fall-through of je at 0x004d3c0d, 2 instruction(s), falls into the block at 0x004d3c19
    mov edx, dword ptr [ebp - local_4]           # 004d3c0f
    mov dword ptr [edx + field_1c], 0x1          # 004d3c12
L_004d3c19:
    # block 0x004d3c19: entered by je at 0x004d3c0d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d3c19
    pop ebp                                      # 004d3c1b
    ret                                          # 004d3c1c

