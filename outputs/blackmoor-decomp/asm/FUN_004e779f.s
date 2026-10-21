# FUN_004e779f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e779f
# extent:       0x004e779f-0x004e77b8 (25 code bytes)
# span:         0x004e779f-0x004e77b8 (code 25, tables 0, padding 0)
# sha256:       1de009c7b6d4d3f916b4a4189817b05f29953fb629cddc9a29ec72aff28ab0bc
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e779f_forward_call_arg
# naming:       native port src/original_methods_fl36e.c:m4e779f_forward_call_arg (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns 0x4ee0d4(this, its one argument). No branch; all 11 instructions run. Nothing else is read or written.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee0d4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4e779f_forward_call_arg (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ee0d4, .text + (0x004ee0d4 - 0x401000)

.org 0x004e779f - 0x401000
.globl FUN_004e779f
FUN_004e779f:
    # block 0x004e779f: entry, 11 instruction(s), calls FUN_004ee0d4, ends with ret 0x4
    push ebp                                     # 004e779f
    {load} mov ebp, esp                          # 004e77a0
    push ecx                                     # 004e77a2
    mov dword ptr [ebp - local_4], ecx           # 004e77a3
    mov eax, dword ptr [ebp + arg_8]             # 004e77a6
    push eax                                     # 004e77a9
    mov ecx, dword ptr [ebp - local_4]           # 004e77aa
    call FUN_004ee0d4                            # 004e77ad
    {load} mov esp, ebp                          # 004e77b2
    pop ebp                                      # 004e77b4
    ret 0x4                                      # 004e77b5

