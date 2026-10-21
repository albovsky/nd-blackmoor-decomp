# FUN_004e89d2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e89d2
# extent:       0x004e89d2-0x004e89eb (25 code bytes)
# span:         0x004e89d2-0x004e89eb (code 25, tables 0, padding 0)
# sha256:       81656fdbb5fa120edcb0057a591c10b63354bc821e7a4e3b603447c9216cf1fc
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e89d2_forward_call_arg
# naming:       native port src/original_methods_fl36e.c:m4e89d2_forward_call_arg (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns 0x4ee0d4(this, its one argument). No branch; all 11 instructions run. Nothing else is read or written.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee0d4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4e89d2_forward_call_arg (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ee0d4, .text + (0x004ee0d4 - 0x401000)

.org 0x004e89d2 - 0x401000
.globl FUN_004e89d2
FUN_004e89d2:
    # block 0x004e89d2: entry, 11 instruction(s), calls FUN_004ee0d4, ends with ret 0x4
    push ebp                                     # 004e89d2
    {load} mov ebp, esp                          # 004e89d3
    push ecx                                     # 004e89d5
    mov dword ptr [ebp - local_4], ecx           # 004e89d6
    mov eax, dword ptr [ebp + arg_8]             # 004e89d9
    push eax                                     # 004e89dc
    mov ecx, dword ptr [ebp - local_4]           # 004e89dd
    call FUN_004ee0d4                            # 004e89e0
    {load} mov esp, ebp                          # 004e89e5
    pop ebp                                      # 004e89e7
    ret 0x4                                      # 004e89e8

