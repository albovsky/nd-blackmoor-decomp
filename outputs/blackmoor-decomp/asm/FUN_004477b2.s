# FUN_004477b2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004477b2
# extent:       0x004477b2-0x004477d1 (31 code bytes)
# span:         0x004477b2-0x004477d1 (code 31, tables 0, padding 0)
# sha256:       04767f5d87ad380a7f26541f100925a9cacb359e6174e3a1169364e395cc8939
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         effect_clear_busy
# naming:       native port src/session_exit.c:effect_clear_busy (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the note is the acceptance note, a statement about the native port
# name-note:    Extracted from stage 3 of session_exit_controller here: clears effect busy (+0x1c). The session_exit controller step runs stage 3 against the original and compares all cells, 0 mismatches.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c; [ecx + n] field_49
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/session_exit.c:effect_clear_busy (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_49, 0x49  # offset +0x49

# --- external targets -----------------------------------------------

.org 0x004477b2 - 0x401000
.globl FUN_004477b2
FUN_004477b2:
    # block 0x004477b2: entry, 13 instruction(s), ends with ret
    push ebp                                     # 004477b2
    {load} mov ebp, esp                          # 004477b3
    sub esp, 0x8                                 # 004477b5
    mov dword ptr [ebp - local_4], ecx           # 004477b8
    mov eax, dword ptr [ebp - local_4]           # 004477bb
    mov byte ptr [eax + field_1c], 0x0           # 004477be
    mov ecx, dword ptr [ebp - local_4]           # 004477c2
    {load} xor edx, edx                          # 004477c5
    mov dl, byte ptr [ecx + field_49]            # 004477c7
    mov dword ptr [ebp - local_8], edx           # 004477ca
    {load} mov esp, ebp                          # 004477cd
    pop ebp                                      # 004477cf
    ret                                          # 004477d0

