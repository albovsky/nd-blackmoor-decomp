# FUN_0048e393
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e393
# extent:       0x0048e393-0x0048e3ca (55 code bytes)
# span:         0x0048e393-0x0048e3ca (code 55, tables 0, padding 0)
# sha256:       67a563b4b662122e58ccde9ac4b71801f4f298e0a7617d2cde5053f54d419d50
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48e393_mark_entry
# naming:       native port src/original_methods_fl39a.c:m48e393_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when dword [self+0x462] is 0 or the signed word [self+0x1c] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_462; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m48e393_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------

.org 0x0048e393 - 0x401000
.globl FUN_0048e393
FUN_0048e393:
    # block 0x0048e393: entry, 7 instruction(s), ends with je to 0x0048e3c6 (forward)
    push ebp                                     # 0048e393
    {load} mov ebp, esp                          # 0048e394
    push ecx                                     # 0048e396
    mov dword ptr [ebp - local_4], ecx           # 0048e397
    mov eax, dword ptr [ebp - local_4]           # 0048e39a
    cmp dword ptr [eax + field_462], 0x0         # 0048e39d
    je.d8 L_0048e3c6                             # 0048e3a4
    # block 0x0048e3a6: entered by fall-through of je at 0x0048e3a4, 4 instruction(s), ends with je to 0x0048e3c6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048e3a6
    movsx edx, word ptr [ecx + field_1c]         # 0048e3a9
    cmp edx, -0x1                                # 0048e3ad
    je.d8 L_0048e3c6                             # 0048e3b0
    # block 0x0048e3b2: entered by fall-through of je at 0x0048e3b0, 4 instruction(s), falls into the block at 0x0048e3c6
    mov eax, dword ptr [ebp - local_4]           # 0048e3b2
    movsx ecx, word ptr [eax + field_1c]         # 0048e3b5
    imul ecx, ecx, 0x4a                          # 0048e3b9
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0048e3bc
L_0048e3c6:
    # block 0x0048e3c6: entered by je at 0x0048e3a4; je at 0x0048e3b0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048e3c6
    pop ebp                                      # 0048e3c8
    ret                                          # 0048e3c9

