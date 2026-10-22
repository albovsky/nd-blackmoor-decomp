# FUN_004e7a10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7a10
# extent:       0x004e7a10-0x004e7a3d (45 code bytes)
# span:         0x004e7a10-0x004e7a40 (code 45, tables 0, padding 3)
# sha256:       1352b487b9c672863171cac9d543c9f372aa27b2191e7236bca1dd37f191f47d
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7a10_call_unless_01
# naming:       native port src/original_methods_fl39e.c:m4e7a10_call_unless_01 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4ee86f(self) unless the dword [self+0x991] is 0 or 1. Values 0, 1, 2, 0x100, 0x101, sign bit and all ones covered; both jumps taken both ways; all 16 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_991; [ecx + n] field_991
# callees:      calls FUN_004ee86f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4e7a10_call_unless_01 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004ee86f, .text + (0x004ee86f - 0x401000)

.org 0x004e7a10 - 0x401000
.globl FUN_004e7a10
FUN_004e7a10:
    # block 0x004e7a10: entry, 7 instruction(s), ends with je to 0x004e7a2f (forward)
    push ebp                                     # 004e7a10
    {load} mov ebp, esp                          # 004e7a11
    push ecx                                     # 004e7a13
    mov dword ptr [ebp - local_4], ecx           # 004e7a14
    mov eax, dword ptr [ebp - local_4]           # 004e7a17
    cmp dword ptr [eax + field_991], 0x0         # 004e7a1a
    je.d8 L_004e7a2f                             # 004e7a21
    # block 0x004e7a23: entered by fall-through of je at 0x004e7a21, 3 instruction(s), ends with jne to 0x004e7a31 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e7a23
    cmp dword ptr [ecx + field_991], 0x1         # 004e7a26
    jne.d8 L_004e7a31                            # 004e7a2d
L_004e7a2f:
    # block 0x004e7a2f: entered by je at 0x004e7a21; fall-through of jne at 0x004e7a2d, 1 instruction(s), ends with forward jump to 0x004e7a39
    jmp.d8 L_004e7a39                            # 004e7a2f
L_004e7a31:
    # block 0x004e7a31: entered by jne at 0x004e7a2d, 2 instruction(s), calls FUN_004ee86f, falls into the block at 0x004e7a39
    mov ecx, dword ptr [ebp - local_4]           # 004e7a31
    call FUN_004ee86f                            # 004e7a34
L_004e7a39:
    # block 0x004e7a39: entered by jmp at 0x004e7a2f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e7a39
    pop ebp                                      # 004e7a3b
    ret                                          # 004e7a3c

# --- data items (not part of the function) -------------------------
.org 0x004e7a3d - 0x401000
PAD_004e7a3d:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

