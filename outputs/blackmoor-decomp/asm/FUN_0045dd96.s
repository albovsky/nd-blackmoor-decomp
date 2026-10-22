# FUN_0045dd96
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045dd96
# extent:       0x0045dd96-0x0045ddd0 (58 code bytes)
# span:         0x0045dd96-0x0045ddd0 (code 58, tables 0, padding 0)
# sha256:       0019c8e05fe878d017f1c3a9e7ebfcec30e3eaede89f13a80a491583934cac1c
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_card_puzzle_slot_invalidate
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_f6_runtime.h:206 says "0x45dd96 / 0x5d15a5: entry +0x14 := 1 (redraw request)."
# name-note:    Slot invalidate: marks the entry dirty as a redraw request.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_321; [ecx + n] field_1c; [edx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_f6_runtime.h:f6_invalidate (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_321, 0x321  # offset +0x321

# --- external targets -----------------------------------------------

.org 0x0045dd96 - 0x401000
.globl FUN_0045dd96
FUN_0045dd96:
    # block 0x0045dd96: entry, 9 instruction(s), ends with je to 0x0045ddcc (forward)
    push ebp                                     # 0045dd96
    {load} mov ebp, esp                          # 0045dd97
    push ecx                                     # 0045dd99
    mov dword ptr [ebp - local_4], ecx           # 0045dd9a
    mov eax, dword ptr [ebp - local_4]           # 0045dd9d
    {load} xor ecx, ecx                          # 0045dda0
    mov cl, byte ptr [eax + field_321]           # 0045dda2
    test ecx, ecx                                # 0045dda8
    je.d8 L_0045ddcc                             # 0045ddaa
    # block 0x0045ddac: entered by fall-through of je at 0x0045ddaa, 4 instruction(s), ends with je to 0x0045ddcc (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045ddac
    movsx eax, word ptr [edx + field_1c]         # 0045ddaf
    cmp eax, -0x1                                # 0045ddb3
    je.d8 L_0045ddcc                             # 0045ddb6
    # block 0x0045ddb8: entered by fall-through of je at 0x0045ddb6, 4 instruction(s), falls into the block at 0x0045ddcc
    mov ecx, dword ptr [ebp - local_4]           # 0045ddb8
    movsx edx, word ptr [ecx + field_1c]         # 0045ddbb
    imul edx, edx, 0x4a                          # 0045ddbf
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0045ddc2
L_0045ddcc:
    # block 0x0045ddcc: entered by je at 0x0045ddaa; je at 0x0045ddb6, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045ddcc
    pop ebp                                      # 0045ddce
    ret                                          # 0045ddcf

