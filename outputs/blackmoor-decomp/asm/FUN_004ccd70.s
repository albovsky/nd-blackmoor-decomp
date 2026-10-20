# FUN_004ccd70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccd70
# extent:       0x004ccd70-0x004ccd8f (31 code bytes)
# span:         0x004ccd70-0x004ccd8f (code 31, tables 0, padding 0)
# sha256:       dcd7315a2881ed560167442793bce884fb1ed75ca93b4c91f2e9f64e241aa1c0
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ccd70_construct
# naming:       native port src/original_methods_fl16.c:m4ccd70_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4ccd70_construct (vtable pointer 0x52e2d0 stored, 0x4ccdab called via the Fl16Host callback, returns this).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ccdab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4ccd70_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004ccdab, .text + (0x004ccdab - 0x401000)

.org 0x004ccd70 - 0x401000
.globl FUN_004ccd70
FUN_004ccd70:
    # block 0x004ccd70: entry, 12 instruction(s), calls FUN_004ccdab, ends with ret
    push ebp                                     # 004ccd70
    {load} mov ebp, esp                          # 004ccd71
    push ecx                                     # 004ccd73
    mov dword ptr [ebp - local_4], ecx           # 004ccd74
    mov eax, dword ptr [ebp - local_4]           # 004ccd77
    mov dword ptr [eax], 0x52e2d0                # 004ccd7a
    mov ecx, dword ptr [ebp - local_4]           # 004ccd80
    call FUN_004ccdab                            # 004ccd83
    mov eax, dword ptr [ebp - local_4]           # 004ccd88
    {load} mov esp, ebp                          # 004ccd8b
    pop ebp                                      # 004ccd8d
    ret                                          # 004ccd8e

