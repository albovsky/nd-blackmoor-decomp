# FUN_004b3d4d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3d4d
# extent:       0x004b3d4d-0x004b3da2 (85 code bytes)
# span:         0x004b3d4d-0x004b3da2 (code 85, tables 0, padding 0)
# sha256:       4171a57eb8e0ceace1f47d23b6297c37ed5f7064bdd0177cb3ca506a80d5cbcc
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b3d4d_release_entry
# naming:       native port src/original_methods_fl39a.c:m4b3d4d_release_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    When dword [self+0x754] != 0 calls 0x4c2dfb(0x5cf659, self+0x754); when the signed word [self+0x726] != -1 calls 0x4d3992(word); then returns 0x4b3c5a(self). Both jumps taken both ways; all 27 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_754; [ecx + n] field_726; [edx + n] field_726
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004b3c5a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4b3d4d_release_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_726, 0x726  # offset +0x726
.equ field_754, 0x754  # offset +0x754

# --- external targets -----------------------------------------------
.set FUN_004b3c5a, .text + (0x004b3c5a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004b3d4d - 0x401000
.globl FUN_004b3d4d
FUN_004b3d4d:
    # block 0x004b3d4d: entry, 7 instruction(s), ends with je to 0x004b3d74 (forward)
    push ebp                                     # 004b3d4d
    {load} mov ebp, esp                          # 004b3d4e
    push ecx                                     # 004b3d50
    mov dword ptr [ebp - local_4], ecx           # 004b3d51
    mov eax, dword ptr [ebp - local_4]           # 004b3d54
    cmp dword ptr [eax + field_754], 0x0         # 004b3d57
    je.d8 L_004b3d74                             # 004b3d5e
    # block 0x004b3d60: entered by fall-through of je at 0x004b3d5e, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004b3d74
    mov ecx, dword ptr [ebp - local_4]           # 004b3d60
    add ecx, 0x754                               # 004b3d63
    push ecx                                     # 004b3d69
    mov ecx, 0x5cf659                            # 004b3d6a
    call FUN_004c2dfb                            # 004b3d6f
L_004b3d74:
    # block 0x004b3d74: entered by je at 0x004b3d5e, 4 instruction(s), ends with je to 0x004b3d96 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b3d74
    movsx eax, word ptr [edx + field_726]        # 004b3d77
    cmp eax, -0x1                                # 004b3d7e
    je.d8 L_004b3d96                             # 004b3d81
    # block 0x004b3d83: entered by fall-through of je at 0x004b3d81, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004b3d96
    mov ecx, dword ptr [ebp - local_4]           # 004b3d83
    mov dx, word ptr [ecx + field_726]           # 004b3d86
    push edx                                     # 004b3d8d
    call FUN_004d3992                            # 004b3d8e
    add esp, 0x4                                 # 004b3d93
L_004b3d96:
    # block 0x004b3d96: entered by je at 0x004b3d81, 5 instruction(s), calls FUN_004b3c5a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004b3d96
    call FUN_004b3c5a                            # 004b3d99
    {load} mov esp, ebp                          # 004b3d9e
    pop ebp                                      # 004b3da0
    ret                                          # 004b3da1

