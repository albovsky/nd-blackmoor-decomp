# FUN_004a7ddc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7ddc
# extent:       0x004a7ddc-0x004a7df9 (29 code bytes)
# span:         0x004a7ddc-0x004a7df9 (code 29, tables 0, padding 0)
# sha256:       bab53a9b77dbc45669c8f9e409de8e083babf3258bd5f5cd86b644a43886b391
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a7ddc_set_two_words
# naming:       native port src/original_methods_fl36e.c:m4a7ddc_set_two_words (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the word 0x0 at 0x5a110b and 0x270f at 0x5a110d. No branch; all 9 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4a7ddc_set_two_words (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004a7ddc - 0x401000
.globl FUN_004a7ddc
FUN_004a7ddc:
    # block 0x004a7ddc: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004a7ddc
    {load} mov ebp, esp                          # 004a7ddd
    push ecx                                     # 004a7ddf
    mov dword ptr [ebp - local_4], ecx           # 004a7de0
    mov word ptr [0x5a110b], 0x0                 # 004a7de3
    mov word ptr [0x5a110d], 0x270f              # 004a7dec
    {load} mov esp, ebp                          # 004a7df5
    pop ebp                                      # 004a7df7
    ret                                          # 004a7df8

