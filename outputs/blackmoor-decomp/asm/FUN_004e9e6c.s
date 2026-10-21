# FUN_004e9e6c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e9e6c
# extent:       0x004e9e6c-0x004e9e84 (24 code bytes)
# span:         0x004e9e6c-0x004e9e84 (code 24, tables 0, padding 0)
# sha256:       ef65636eac48823d17e074ce0e2a72e2a3b5cda7ffc7b442e03f6997551d45fd
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e9e6c_set_field_const
# naming:       native port src/original_methods_fl36e.c:m4e9e6c_set_field_const (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x0u at [this + 0x8256], returns this. No branch; all 9 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8256
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4e9e6c_set_field_const (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8256, 0x8256  # offset +0x8256

# --- external targets -----------------------------------------------

.org 0x004e9e6c - 0x401000
.globl FUN_004e9e6c
FUN_004e9e6c:
    # block 0x004e9e6c: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004e9e6c
    {load} mov ebp, esp                          # 004e9e6d
    push ecx                                     # 004e9e6f
    mov dword ptr [ebp - local_4], ecx           # 004e9e70
    mov eax, dword ptr [ebp - local_4]           # 004e9e73
    mov dword ptr [eax + field_8256], 0x0        # 004e9e76
    {load} mov esp, ebp                          # 004e9e80
    pop ebp                                      # 004e9e82
    ret                                          # 004e9e83

