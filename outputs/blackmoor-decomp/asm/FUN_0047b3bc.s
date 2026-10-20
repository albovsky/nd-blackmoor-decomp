# FUN_0047b3bc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b3bc
# extent:       0x0047b3bc-0x0047b3f0 (52 code bytes)
# span:         0x0047b3bc-0x0047b3f0 (code 52, tables 0, padding 0)
# sha256:       2c8d56328e575f15aac4243482ee8f3e66e3e96ef0c061f2e9216ec1e3b98d9b
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47b3bc_mark_entry
# naming:       native port src/original_methods_fl31a.c:m47b3bc_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Sets the dword of record [word self+4] at 0x5d15a5 (stride 0x4a) to 1 when [self+0x24] is non-zero and the signed word is not -1; every instruction and both directions executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_24; [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31a.c:m47b3bc_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x0047b3bc - 0x401000
.globl FUN_0047b3bc
FUN_0047b3bc:
    # block 0x0047b3bc: entry, 7 instruction(s), ends with je to 0x0047b3ec (forward)
    push ebp                                     # 0047b3bc
    {load} mov ebp, esp                          # 0047b3bd
    push ecx                                     # 0047b3bf
    mov dword ptr [ebp - local_4], ecx           # 0047b3c0
    mov eax, dword ptr [ebp - local_4]           # 0047b3c3
    cmp dword ptr [eax + field_24], 0x0          # 0047b3c6
    je.d8 L_0047b3ec                             # 0047b3ca
    # block 0x0047b3cc: entered by fall-through of je at 0x0047b3ca, 4 instruction(s), ends with je to 0x0047b3ec (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047b3cc
    movsx edx, word ptr [ecx + field_4]          # 0047b3cf
    cmp edx, -0x1                                # 0047b3d3
    je.d8 L_0047b3ec                             # 0047b3d6
    # block 0x0047b3d8: entered by fall-through of je at 0x0047b3d6, 4 instruction(s), falls into the block at 0x0047b3ec
    mov eax, dword ptr [ebp - local_4]           # 0047b3d8
    movsx ecx, word ptr [eax + field_4]          # 0047b3db
    imul ecx, ecx, 0x4a                          # 0047b3df
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0047b3e2
L_0047b3ec:
    # block 0x0047b3ec: entered by je at 0x0047b3ca; je at 0x0047b3d6, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047b3ec
    pop ebp                                      # 0047b3ee
    ret                                          # 0047b3ef

