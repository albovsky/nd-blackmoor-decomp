# FUN_004e2967
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2967
# extent:       0x004e2967-0x004e2978 (17 code bytes)
# span:         0x004e2967-0x004e2978 (code 17, tables 0, padding 0)
# sha256:       50280e79a334d4137f45bc9c9261880111fa5dd554b479b92d4c60c9f3a97d6f
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e2967_get_field
# naming:       native port src/original_methods_fl36e.c:m4e2967_get_field (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the dword at [this + 0x7a]. No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_7a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4e2967_get_field (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_7a, 0x7a  # offset +0x7a

# --- external targets -----------------------------------------------

.org 0x004e2967 - 0x401000
.globl FUN_004e2967
FUN_004e2967:
    # block 0x004e2967: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004e2967
    {load} mov ebp, esp                          # 004e2968
    push ecx                                     # 004e296a
    mov dword ptr [ebp - local_4], ecx           # 004e296b
    mov eax, dword ptr [ebp - local_4]           # 004e296e
    mov eax, dword ptr [eax + field_7a]          # 004e2971
    {load} mov esp, ebp                          # 004e2974
    pop ebp                                      # 004e2976
    ret                                          # 004e2977

