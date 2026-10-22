# FUN_004b7272
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7272
# extent:       0x004b7272-0x004b72a9 (55 code bytes)
# span:         0x004b7272-0x004b72a9 (code 55, tables 0, padding 0)
# sha256:       3cf1d03d384bbd4abe5693bac3a90b8a7bc547024a2021e4b734a2b0f24f3a52
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b7272_mark_entry
# naming:       native port src/original_methods_fl39a.c:m4b7272_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when byte [self+0x35] is 0 or the signed word [self+0x2f] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_35; [ecx + n] field_2f; [edx + n] field_2f
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4b7272_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2f, 0x2f  # offset +0x2f
.equ field_35, 0x35  # offset +0x35

# --- external targets -----------------------------------------------

.org 0x004b7272 - 0x401000
.globl FUN_004b7272
FUN_004b7272:
    # block 0x004b7272: entry, 9 instruction(s), ends with je to 0x004b72a5 (forward)
    push ebp                                     # 004b7272
    {load} mov ebp, esp                          # 004b7273
    push ecx                                     # 004b7275
    mov dword ptr [ebp - local_4], ecx           # 004b7276
    mov eax, dword ptr [ebp - local_4]           # 004b7279
    {load} xor ecx, ecx                          # 004b727c
    mov cl, byte ptr [eax + field_35]            # 004b727e
    test ecx, ecx                                # 004b7281
    je.d8 L_004b72a5                             # 004b7283
    # block 0x004b7285: entered by fall-through of je at 0x004b7283, 4 instruction(s), ends with je to 0x004b72a5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b7285
    movsx eax, word ptr [edx + field_2f]         # 004b7288
    cmp eax, -0x1                                # 004b728c
    je.d8 L_004b72a5                             # 004b728f
    # block 0x004b7291: entered by fall-through of je at 0x004b728f, 4 instruction(s), falls into the block at 0x004b72a5
    mov ecx, dword ptr [ebp - local_4]           # 004b7291
    movsx edx, word ptr [ecx + field_2f]         # 004b7294
    imul edx, edx, 0x4a                          # 004b7298
    mov dword ptr [edx + 0x5d15a5], 0x1          # 004b729b
L_004b72a5:
    # block 0x004b72a5: entered by je at 0x004b7283; je at 0x004b728f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b72a5
    pop ebp                                      # 004b72a7
    ret                                          # 004b72a8

