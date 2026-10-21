# FUN_00456dab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456dab
# extent:       0x00456dab-0x00456dc8 (29 code bytes)
# span:         0x00456dab-0x00456dc8 (code 29, tables 0, padding 0)
# sha256:       1f5e0c801c606f30f1d1d97e9b3555d162d124c4cda05bc4cbd055794a6d360e
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m456dab_set_two_words
# naming:       native port src/original_methods_fl36e.c:m456dab_set_two_words (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the word 0x0 at 0x5957c1 and 0x0 at 0x5957c3. No branch; all 9 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m456dab_set_two_words (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00456dab - 0x401000
.globl FUN_00456dab
FUN_00456dab:
    # block 0x00456dab: entry, 9 instruction(s), ends with ret
    push ebp                                     # 00456dab
    {load} mov ebp, esp                          # 00456dac
    push ecx                                     # 00456dae
    mov dword ptr [ebp - local_4], ecx           # 00456daf
    mov word ptr [0x5957c1], 0x0                 # 00456db2
    mov word ptr [0x5957c3], 0x0                 # 00456dbb
    {load} mov esp, ebp                          # 00456dc4
    pop ebp                                      # 00456dc6
    ret                                          # 00456dc7

