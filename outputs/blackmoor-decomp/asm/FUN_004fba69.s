# FUN_004fba69
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fba69
# extent:       0x004fba69-0x004fba86 (29 code bytes)
# span:         0x004fba69-0x004fba86 (code 29, tables 0, padding 0)
# sha256:       1b43a3f31f3008e22293f89e0e702167dee2cd34edf390865c770777edc60e2d
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fba69_forward_word
# naming:       native port src/original_methods_fl17.c:m4fba69_forward_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4fba69_forward_word; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 29 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_21
# callees:      calls FUN_004fc808
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m4fba69_forward_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21

# --- external targets -----------------------------------------------
.set FUN_004fc808, .text + (0x004fc808 - 0x401000)

.org 0x004fba69 - 0x401000
.globl FUN_004fba69
FUN_004fba69:
    # block 0x004fba69: entry, 12 instruction(s), calls FUN_004fc808, ends with ret 0x4
    push ebp                                     # 004fba69
    {load} mov ebp, esp                          # 004fba6a
    push ecx                                     # 004fba6c
    mov dword ptr [ebp - local_4], ecx           # 004fba6d
    mov eax, dword ptr [ebp + arg_8]             # 004fba70
    mov cx, word ptr [eax + field_21]            # 004fba73
    push ecx                                     # 004fba77
    mov ecx, dword ptr [ebp - local_4]           # 004fba78
    call FUN_004fc808                            # 004fba7b
    {load} mov esp, ebp                          # 004fba80
    pop ebp                                      # 004fba82
    ret 0x4                                      # 004fba83

