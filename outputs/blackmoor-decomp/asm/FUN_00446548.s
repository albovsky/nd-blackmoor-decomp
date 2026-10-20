# FUN_00446548
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446548
# extent:       0x00446548-0x0044655e (22 code bytes)
# span:         0x00446548-0x0044655e (code 22, tables 0, padding 0)
# sha256:       0162bfa67fc7ddc9bf8205692f7e8481acd5ff09c30b047fd1070242dabbef1c
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         std_enable_clock
# naming:       native port src/score_time_display.c:std_enable_clock (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with std_enable_clock (stores the argument into +8 and nothing else). Field-per-offset model.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/score_time_display.c:std_enable_clock (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00446548 - 0x401000
.globl FUN_00446548
FUN_00446548:
    # block 0x00446548: entry, 10 instruction(s), ends with ret 0x4
    push ebp                                     # 00446548
    {load} mov ebp, esp                          # 00446549
    push ecx                                     # 0044654b
    mov dword ptr [ebp - local_4], ecx           # 0044654c
    mov eax, dword ptr [ebp - local_4]           # 0044654f
    mov ecx, dword ptr [ebp + arg_8]             # 00446552
    mov dword ptr [eax + field_8], ecx           # 00446555
    {load} mov esp, ebp                          # 00446558
    pop ebp                                      # 0044655a
    ret 0x4                                      # 0044655b

