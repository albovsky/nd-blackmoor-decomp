# FUN_004ebd6c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ebd6c
# extent:       0x004ebd6c-0x004ebd85 (25 code bytes)
# span:         0x004ebd6c-0x004ebd85 (code 25, tables 0, padding 0)
# sha256:       2189de89ad184d4c51f22dec4f6778d934d184b4947c446de6eb158f02ce3e2d
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ebd6c_forward_call_arg
# naming:       native port src/original_methods_fl36e.c:m4ebd6c_forward_call_arg (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns 0x4ee0d4(this, its one argument). No branch; all 11 instructions run. Nothing else is read or written.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee0d4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4ebd6c_forward_call_arg (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ee0d4, .text + (0x004ee0d4 - 0x401000)

.org 0x004ebd6c - 0x401000
.globl FUN_004ebd6c
FUN_004ebd6c:
    # block 0x004ebd6c: entry, 11 instruction(s), calls FUN_004ee0d4, ends with ret 0x4
    push ebp                                     # 004ebd6c
    {load} mov ebp, esp                          # 004ebd6d
    push ecx                                     # 004ebd6f
    mov dword ptr [ebp - local_4], ecx           # 004ebd70
    mov eax, dword ptr [ebp + arg_8]             # 004ebd73
    push eax                                     # 004ebd76
    mov ecx, dword ptr [ebp - local_4]           # 004ebd77
    call FUN_004ee0d4                            # 004ebd7a
    {load} mov esp, ebp                          # 004ebd7f
    pop ebp                                      # 004ebd81
    ret 0x4                                      # 004ebd82

