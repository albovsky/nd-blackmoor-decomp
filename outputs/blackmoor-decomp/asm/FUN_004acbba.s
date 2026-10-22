# FUN_004acbba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004acbba
# extent:       0x004acbba-0x004acbf1 (55 code bytes)
# span:         0x004acbba-0x004acbf1 (code 55, tables 0, padding 0)
# sha256:       48cbdec8026310373f3e645b1d573b0e918bafcb03f604b80dbe69fc9984c0c3
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4acbba_mark_entry
# naming:       native port src/original_methods_fl39a.c:m4acbba_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when dword [self+0xc1b] is 0 or the signed word [self+0x1c] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_c1b; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4acbba_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_c1b, 0xc1b  # offset +0xc1b

# --- external targets -----------------------------------------------

.org 0x004acbba - 0x401000
.globl FUN_004acbba
FUN_004acbba:
    # block 0x004acbba: entry, 7 instruction(s), ends with je to 0x004acbed (forward)
    push ebp                                     # 004acbba
    {load} mov ebp, esp                          # 004acbbb
    push ecx                                     # 004acbbd
    mov dword ptr [ebp - local_4], ecx           # 004acbbe
    mov eax, dword ptr [ebp - local_4]           # 004acbc1
    cmp dword ptr [eax + field_c1b], 0x0         # 004acbc4
    je.d8 L_004acbed                             # 004acbcb
    # block 0x004acbcd: entered by fall-through of je at 0x004acbcb, 4 instruction(s), ends with je to 0x004acbed (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004acbcd
    movsx edx, word ptr [ecx + field_1c]         # 004acbd0
    cmp edx, -0x1                                # 004acbd4
    je.d8 L_004acbed                             # 004acbd7
    # block 0x004acbd9: entered by fall-through of je at 0x004acbd7, 4 instruction(s), falls into the block at 0x004acbed
    mov eax, dword ptr [ebp - local_4]           # 004acbd9
    movsx ecx, word ptr [eax + field_1c]         # 004acbdc
    imul ecx, ecx, 0x4a                          # 004acbe0
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004acbe3
L_004acbed:
    # block 0x004acbed: entered by je at 0x004acbcb; je at 0x004acbd7, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004acbed
    pop ebp                                      # 004acbef
    ret                                          # 004acbf0

