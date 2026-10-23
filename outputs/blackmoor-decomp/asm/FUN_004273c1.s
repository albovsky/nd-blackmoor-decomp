# FUN_004273c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004273c1
# extent:       0x004273c1-0x004273ee (45 code bytes)
# span:         0x004273c1-0x004273f0 (code 45, tables 0, padding 2)
# sha256:       d104e91f9d027db0a32a8d75df5660c427f6a8541d57a0fb4531259cb6942ea7
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4273c1_lifted
# naming:       native port src/original_methods_fl40.c:m4273c1_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 2 seeds; oracle 15/15 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_4ae84
# callees:      calls FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4273c1_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4ae84, 0x4ae84  # offset +0x4ae84

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x004273c1 - 0x401000
.globl FUN_004273c1
FUN_004273c1:
    # block 0x004273c1: entry, 8 instruction(s), ends with je to 0x004273ea (forward)
    push ebp                                     # 004273c1
    {load} mov ebp, esp                          # 004273c2
    push ecx                                     # 004273c4
    mov dword ptr [ebp - local_4], ecx           # 004273c5
    {load} xor eax, eax                          # 004273c8
    mov al, byte ptr [0x58320c]                  # 004273ca
    test eax, eax                                # 004273cf
    je.d8 L_004273ea                             # 004273d1
    # block 0x004273d3: entered by fall-through of je at 0x004273d1, 4 instruction(s), calls FUN_004c97b4, falls into the block at 0x004273ea
    mov ecx, dword ptr [ebp - local_4]           # 004273d3
    mov dword ptr [ecx + field_4ae84], 0x1       # 004273d6
    mov ecx, 0x5cf659                            # 004273e0
    call FUN_004c97b4                            # 004273e5
L_004273ea:
    # block 0x004273ea: entered by je at 0x004273d1, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004273ea
    pop ebp                                      # 004273ec
    ret                                          # 004273ed

# --- data items (not part of the function) -------------------------
.org 0x004273ee - 0x401000
PAD_004273ee:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

