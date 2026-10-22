# FUN_004ba22e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ba22e
# extent:       0x004ba22e-0x004ba262 (52 code bytes)
# span:         0x004ba22e-0x004ba262 (code 52, tables 0, padding 0)
# sha256:       5d6eb6d80538ac710273f0ea5da01df852d9ad55a434804824f12f48a32cde92
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ba22e_mark_entry
# naming:       native port src/original_methods_fl39a.c:m4ba22e_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when dword [self+0x34] is 0 or the signed word [self+0x4] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_34; [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4ba22e_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------

.org 0x004ba22e - 0x401000
.globl FUN_004ba22e
FUN_004ba22e:
    # block 0x004ba22e: entry, 7 instruction(s), ends with je to 0x004ba25e (forward)
    push ebp                                     # 004ba22e
    {load} mov ebp, esp                          # 004ba22f
    push ecx                                     # 004ba231
    mov dword ptr [ebp - local_4], ecx           # 004ba232
    mov eax, dword ptr [ebp - local_4]           # 004ba235
    cmp dword ptr [eax + field_34], 0x0          # 004ba238
    je.d8 L_004ba25e                             # 004ba23c
    # block 0x004ba23e: entered by fall-through of je at 0x004ba23c, 4 instruction(s), ends with je to 0x004ba25e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ba23e
    movsx edx, word ptr [ecx + field_4]          # 004ba241
    cmp edx, -0x1                                # 004ba245
    je.d8 L_004ba25e                             # 004ba248
    # block 0x004ba24a: entered by fall-through of je at 0x004ba248, 4 instruction(s), falls into the block at 0x004ba25e
    mov eax, dword ptr [ebp - local_4]           # 004ba24a
    movsx ecx, word ptr [eax + field_4]          # 004ba24d
    imul ecx, ecx, 0x4a                          # 004ba251
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004ba254
L_004ba25e:
    # block 0x004ba25e: entered by je at 0x004ba23c; je at 0x004ba248, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ba25e
    pop ebp                                      # 004ba260
    ret                                          # 004ba261

