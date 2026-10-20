# FUN_0047d640
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d640
# extent:       0x0047d640-0x0047d677 (55 code bytes)
# span:         0x0047d640-0x0047d677 (code 55, tables 0, padding 0)
# sha256:       f75314f967435c4dd7d572ed3b8ae278c98b79cd41d37eb19fb0133c8d2bad32
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_d9_puzzle_slot_invalidate
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_d9_runtime.h:118 says "0x47d640: entry +0x14 := 1 (redraw request)."
# name-note:    Slot invalidate: sets entry +0x14 := 1 as a redraw request.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_57; [ecx + n] field_23; [edx + n] field_23
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d9_runtime.h:d9_invalidate (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_23, 0x23  # offset +0x23
.equ field_57, 0x57  # offset +0x57

# --- external targets -----------------------------------------------

.org 0x0047d640 - 0x401000
.globl FUN_0047d640
FUN_0047d640:
    # block 0x0047d640: entry, 9 instruction(s), ends with je to 0x0047d673 (forward)
    push ebp                                     # 0047d640
    {load} mov ebp, esp                          # 0047d641
    push ecx                                     # 0047d643
    mov dword ptr [ebp - local_4], ecx           # 0047d644
    mov eax, dword ptr [ebp - local_4]           # 0047d647
    {load} xor ecx, ecx                          # 0047d64a
    mov cl, byte ptr [eax + field_57]            # 0047d64c
    test ecx, ecx                                # 0047d64f
    je.d8 L_0047d673                             # 0047d651
    # block 0x0047d653: entered by fall-through of je at 0x0047d651, 4 instruction(s), ends with je to 0x0047d673 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047d653
    movsx eax, word ptr [edx + field_23]         # 0047d656
    cmp eax, -0x1                                # 0047d65a
    je.d8 L_0047d673                             # 0047d65d
    # block 0x0047d65f: entered by fall-through of je at 0x0047d65d, 4 instruction(s), falls into the block at 0x0047d673
    mov ecx, dword ptr [ebp - local_4]           # 0047d65f
    movsx edx, word ptr [ecx + field_23]         # 0047d662
    imul edx, edx, 0x4a                          # 0047d666
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0047d669
L_0047d673:
    # block 0x0047d673: entered by je at 0x0047d651; je at 0x0047d65d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047d673
    pop ebp                                      # 0047d675
    ret                                          # 0047d676

