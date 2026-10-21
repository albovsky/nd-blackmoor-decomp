# FUN_004e40fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e40fb
# extent:       0x004e40fb-0x004e4114 (25 code bytes)
# span:         0x004e40fb-0x004e4114 (code 25, tables 0, padding 0)
# sha256:       5f8477627903ce622ff9b66d9796ea0aaed80ebbecb40d56b77c295de4ec5256
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e40fb_forward_call_arg
# naming:       native port src/original_methods_fl36e.c:m4e40fb_forward_call_arg (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns 0x4edfaf(this, its one argument). No branch; all 11 instructions run. Nothing else is read or written.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004edfaf
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4e40fb_forward_call_arg (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004edfaf, .text + (0x004edfaf - 0x401000)

.org 0x004e40fb - 0x401000
.globl FUN_004e40fb
FUN_004e40fb:
    # block 0x004e40fb: entry, 11 instruction(s), calls FUN_004edfaf, ends with ret 0x4
    push ebp                                     # 004e40fb
    {load} mov ebp, esp                          # 004e40fc
    push ecx                                     # 004e40fe
    mov dword ptr [ebp - local_4], ecx           # 004e40ff
    mov eax, dword ptr [ebp + arg_8]             # 004e4102
    push eax                                     # 004e4105
    mov ecx, dword ptr [ebp - local_4]           # 004e4106
    call FUN_004edfaf                            # 004e4109
    {load} mov esp, ebp                          # 004e410e
    pop ebp                                      # 004e4110
    ret 0x4                                      # 004e4111

