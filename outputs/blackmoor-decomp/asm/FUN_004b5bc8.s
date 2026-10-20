# FUN_004b5bc8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5bc8
# extent:       0x004b5bc8-0x004b5c11 (73 code bytes)
# span:         0x004b5bc8-0x004b5c11 (code 73, tables 0, padding 0)
# sha256:       5b3869359ee352e569fe26b92f70979cacdca293644d889def2f8456c387d1b9
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b5bc8_begin_scene
# naming:       native port src/original_methods_fl17.c:m4b5bc8_begin_scene (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4b5bc8_begin_scene; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 73 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004b5b8a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m4b5bc8_begin_scene (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_004b5b8a, .text + (0x004b5b8a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004b5bc8 - 0x401000
.globl FUN_004b5bc8
FUN_004b5bc8:
    # block 0x004b5bc8: entry, 7 instruction(s), ends with je to 0x004b5be9 (forward)
    push ebp                                     # 004b5bc8
    {load} mov ebp, esp                          # 004b5bc9
    push ecx                                     # 004b5bcb
    mov dword ptr [ebp - local_4], ecx           # 004b5bcc
    mov eax, dword ptr [ebp - local_4]           # 004b5bcf
    cmp dword ptr [eax + field_20], 0x0          # 004b5bd2
    je.d8 L_004b5be9                             # 004b5bd6
    # block 0x004b5bd8: entered by fall-through of je at 0x004b5bd6, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004b5be9
    mov ecx, dword ptr [ebp - local_4]           # 004b5bd8
    add ecx, 0x20                                # 004b5bdb
    push ecx                                     # 004b5bde
    mov ecx, 0x5cf659                            # 004b5bdf
    call FUN_004c2dfb                            # 004b5be4
L_004b5be9:
    # block 0x004b5be9: entered by je at 0x004b5bd6, 4 instruction(s), ends with je to 0x004b5c05 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b5be9
    movsx eax, word ptr [edx + field_1c]         # 004b5bec
    cmp eax, -0x1                                # 004b5bf0
    je.d8 L_004b5c05                             # 004b5bf3
    # block 0x004b5bf5: entered by fall-through of je at 0x004b5bf3, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004b5c05
    mov ecx, dword ptr [ebp - local_4]           # 004b5bf5
    mov dx, word ptr [ecx + field_1c]            # 004b5bf8
    push edx                                     # 004b5bfc
    call FUN_004d3992                            # 004b5bfd
    add esp, 0x4                                 # 004b5c02
L_004b5c05:
    # block 0x004b5c05: entered by je at 0x004b5bf3, 5 instruction(s), calls FUN_004b5b8a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004b5c05
    call FUN_004b5b8a                            # 004b5c08
    {load} mov esp, ebp                          # 004b5c0d
    pop ebp                                      # 004b5c0f
    ret                                          # 004b5c10

