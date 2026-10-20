# FUN_004fc05d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fc05d
# extent:       0x004fc05d-0x004fc077 (26 code bytes)
# span:         0x004fc05d-0x004fc077 (code 26, tables 0, padding 0)
# sha256:       c90db88a405811d764095d1f181edbaf75b462bb6031b8f2a92facff7071c7e4
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fc05d_forward_global
# naming:       native port src/original_methods_fl17.c:m4fc05d_forward_global (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4fc05d_forward_global; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 26 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fc808
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:reset_fresh_scene_audio (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004fc808, .text + (0x004fc808 - 0x401000)

.org 0x004fc05d - 0x401000
.globl FUN_004fc05d
FUN_004fc05d:
    # block 0x004fc05d: entry, 11 instruction(s), calls FUN_004fc808, ends with ret
    push ebp                                     # 004fc05d
    {load} mov ebp, esp                          # 004fc05e
    push ecx                                     # 004fc060
    mov dword ptr [ebp - local_4], ecx           # 004fc061
    mov ax, word ptr [0x5b451f]                  # 004fc064
    push eax                                     # 004fc06a
    mov ecx, dword ptr [ebp - local_4]           # 004fc06b
    call FUN_004fc808                            # 004fc06e
    {load} mov esp, ebp                          # 004fc073
    pop ebp                                      # 004fc075
    ret                                          # 004fc076

