# FUN_004ab3dc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab3dc
# extent:       0x004ab3dc-0x004ab425 (73 code bytes)
# span:         0x004ab3dc-0x004ab425 (code 73, tables 0, padding 0)
# sha256:       53bcf916d1f76bb8dfd935355618f0be2616cf6c42e0b5fe4936868a9d64387d
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ab3dc_release_entry
# naming:       native port src/original_methods_fl39a.c:m4ab3dc_release_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    When dword [self+0x20] != 0 calls 0x4c2dfb(0x5cf659, self+0x20); when the signed word [self+0x1c] != -1 calls 0x4d3992(word); then returns 0x4ab3a7(self). Both jumps taken both ways; all 27 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004ab3a7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4ab3dc_release_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_004ab3a7, .text + (0x004ab3a7 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004ab3dc - 0x401000
.globl FUN_004ab3dc
FUN_004ab3dc:
    # block 0x004ab3dc: entry, 7 instruction(s), ends with je to 0x004ab3fd (forward)
    push ebp                                     # 004ab3dc
    {load} mov ebp, esp                          # 004ab3dd
    push ecx                                     # 004ab3df
    mov dword ptr [ebp - local_4], ecx           # 004ab3e0
    mov eax, dword ptr [ebp - local_4]           # 004ab3e3
    cmp dword ptr [eax + field_20], 0x0          # 004ab3e6
    je.d8 L_004ab3fd                             # 004ab3ea
    # block 0x004ab3ec: entered by fall-through of je at 0x004ab3ea, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004ab3fd
    mov ecx, dword ptr [ebp - local_4]           # 004ab3ec
    add ecx, 0x20                                # 004ab3ef
    push ecx                                     # 004ab3f2
    mov ecx, 0x5cf659                            # 004ab3f3
    call FUN_004c2dfb                            # 004ab3f8
L_004ab3fd:
    # block 0x004ab3fd: entered by je at 0x004ab3ea, 4 instruction(s), ends with je to 0x004ab419 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ab3fd
    movsx eax, word ptr [edx + field_1c]         # 004ab400
    cmp eax, -0x1                                # 004ab404
    je.d8 L_004ab419                             # 004ab407
    # block 0x004ab409: entered by fall-through of je at 0x004ab407, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004ab419
    mov ecx, dword ptr [ebp - local_4]           # 004ab409
    mov dx, word ptr [ecx + field_1c]            # 004ab40c
    push edx                                     # 004ab410
    call FUN_004d3992                            # 004ab411
    add esp, 0x4                                 # 004ab416
L_004ab419:
    # block 0x004ab419: entered by je at 0x004ab407, 5 instruction(s), calls FUN_004ab3a7, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004ab419
    call FUN_004ab3a7                            # 004ab41c
    {load} mov esp, ebp                          # 004ab421
    pop ebp                                      # 004ab423
    ret                                          # 004ab424

