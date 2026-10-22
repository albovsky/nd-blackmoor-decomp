# FUN_00493af0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00493af0
# extent:       0x00493af0-0x00493b2e (62 code bytes)
# span:         0x00493af0-0x00493b2e (code 62, tables 0, padding 0)
# sha256:       463b5fc3c7dbdd9af53712f3ab4d36516787ba0f446a1ea934c0b1d05c9e84f5
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m493af0_lifted
# naming:       native port src/original_methods_fl39d.c:m493af0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_200b; [ecx + n] field_2003; [edx + n] field_2007
# callees:      calls FUN_004dae66, FUN_004dae77
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m493af0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2003, 0x2003  # offset +0x2003
.equ field_2007, 0x2007  # offset +0x2007
.equ field_200b, 0x200b  # offset +0x200b

# --- external targets -----------------------------------------------
.set FUN_004dae66, .text + (0x004dae66 - 0x401000)
.set FUN_004dae77, .text + (0x004dae77 - 0x401000)

.org 0x00493af0 - 0x401000
.globl FUN_00493af0
FUN_00493af0:
    # block 0x00493af0: entry, 17 instruction(s), calls FUN_004dae66, FUN_004dae77, ends with ret
    push ebp                                     # 00493af0
    {load} mov ebp, esp                          # 00493af1
    push ecx                                     # 00493af3
    mov dword ptr [ebp - local_4], ecx           # 00493af4
    mov eax, dword ptr [ebp - local_4]           # 00493af7
    mov dword ptr [eax + field_200b], 0x0        # 00493afa
    mov ecx, 0x5830a6                            # 00493b04
    call FUN_004dae66                            # 00493b09
    mov ecx, dword ptr [ebp - local_4]           # 00493b0e
    mov dword ptr [ecx + field_2003], eax        # 00493b11
    mov ecx, 0x5830a6                            # 00493b17
    call FUN_004dae77                            # 00493b1c
    mov edx, dword ptr [ebp - local_4]           # 00493b21
    mov dword ptr [edx + field_2007], eax        # 00493b24
    {load} mov esp, ebp                          # 00493b2a
    pop ebp                                      # 00493b2c
    ret                                          # 00493b2d

