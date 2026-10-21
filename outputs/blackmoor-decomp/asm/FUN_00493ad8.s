# FUN_00493ad8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00493ad8
# extent:       0x00493ad8-0x00493af0 (24 code bytes)
# span:         0x00493ad8-0x00493af0 (code 24, tables 0, padding 0)
# sha256:       03e26348ef3d0afca22e2e546b99eef99801dd2cc0bdd2255b8385542dcd38d9
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m493ad8_set_field_const
# naming:       native port src/original_methods_fl36e.c:m493ad8_set_field_const (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x1u at [this + 0x200b], returns this. No branch; all 9 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_200b
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m493ad8_set_field_const (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_200b, 0x200b  # offset +0x200b

# --- external targets -----------------------------------------------

.org 0x00493ad8 - 0x401000
.globl FUN_00493ad8
FUN_00493ad8:
    # block 0x00493ad8: entry, 9 instruction(s), ends with ret
    push ebp                                     # 00493ad8
    {load} mov ebp, esp                          # 00493ad9
    push ecx                                     # 00493adb
    mov dword ptr [ebp - local_4], ecx           # 00493adc
    mov eax, dword ptr [ebp - local_4]           # 00493adf
    mov dword ptr [eax + field_200b], 0x1        # 00493ae2
    {load} mov esp, ebp                          # 00493aec
    pop ebp                                      # 00493aee
    ret                                          # 00493aef

