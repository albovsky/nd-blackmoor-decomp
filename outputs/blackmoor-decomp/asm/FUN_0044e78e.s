# FUN_0044e78e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e78e
# extent:       0x0044e78e-0x0044e7d7 (73 code bytes)
# span:         0x0044e78e-0x0044e7d7 (code 73, tables 0, padding 0)
# sha256:       85d97ab5863917ec06b3d062e64bd9dc14042884b44d685aabbaaf817bf12abf
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44e78e_release_entry
# naming:       native port src/original_methods_fl32c.c:m44e78e_release_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Releases an entry: calls 0x4c2dfb with the address of field +0x20 when it is set, 0x4d3992 with the word +0x1c unless it is -1 (read again), then 0x44e767; 26/26 executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0044e767
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32c.c:m44e78e_release_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0044e767, .text + (0x0044e767 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0044e78e - 0x401000
.globl FUN_0044e78e
FUN_0044e78e:
    # block 0x0044e78e: entry, 7 instruction(s), ends with je to 0x0044e7af (forward)
    push ebp                                     # 0044e78e
    {load} mov ebp, esp                          # 0044e78f
    push ecx                                     # 0044e791
    mov dword ptr [ebp - local_4], ecx           # 0044e792
    mov eax, dword ptr [ebp - local_4]           # 0044e795
    cmp dword ptr [eax + field_20], 0x0          # 0044e798
    je.d8 L_0044e7af                             # 0044e79c
    # block 0x0044e79e: entered by fall-through of je at 0x0044e79c, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0044e7af
    mov ecx, dword ptr [ebp - local_4]           # 0044e79e
    add ecx, 0x20                                # 0044e7a1
    push ecx                                     # 0044e7a4
    mov ecx, 0x5cf659                            # 0044e7a5
    call FUN_004c2dfb                            # 0044e7aa
L_0044e7af:
    # block 0x0044e7af: entered by je at 0x0044e79c, 4 instruction(s), ends with je to 0x0044e7cb (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044e7af
    movsx eax, word ptr [edx + field_1c]         # 0044e7b2
    cmp eax, -0x1                                # 0044e7b6
    je.d8 L_0044e7cb                             # 0044e7b9
    # block 0x0044e7bb: entered by fall-through of je at 0x0044e7b9, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0044e7cb
    mov ecx, dword ptr [ebp - local_4]           # 0044e7bb
    mov dx, word ptr [ecx + field_1c]            # 0044e7be
    push edx                                     # 0044e7c2
    call FUN_004d3992                            # 0044e7c3
    add esp, 0x4                                 # 0044e7c8
L_0044e7cb:
    # block 0x0044e7cb: entered by je at 0x0044e7b9, 5 instruction(s), calls FUN_0044e767, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0044e7cb
    call FUN_0044e767                            # 0044e7ce
    {load} mov esp, ebp                          # 0044e7d3
    pop ebp                                      # 0044e7d5
    ret                                          # 0044e7d6

