# FUN_004ee980
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee980
# extent:       0x004ee980-0x004ee99f (31 code bytes)
# span:         0x004ee980-0x004ee99f (code 31, tables 0, padding 0)
# sha256:       26b093df710c3d881e3a9cc75b77ba120a92ea10e734d2f3c84dd29186ef9468
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ee980_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m4ee980_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e500u at [this], calls 0x4ee9bb(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee9bb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4ee980_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004ee9bb, .text + (0x004ee9bb - 0x401000)

.org 0x004ee980 - 0x401000
.globl FUN_004ee980
FUN_004ee980:
    # block 0x004ee980: entry, 12 instruction(s), calls FUN_004ee9bb, ends with ret
    push ebp                                     # 004ee980
    {load} mov ebp, esp                          # 004ee981
    push ecx                                     # 004ee983
    mov dword ptr [ebp - local_4], ecx           # 004ee984
    mov eax, dword ptr [ebp - local_4]           # 004ee987
    mov dword ptr [eax], 0x52e500                # 004ee98a
    mov ecx, dword ptr [ebp - local_4]           # 004ee990
    call FUN_004ee9bb                            # 004ee993
    mov eax, dword ptr [ebp - local_4]           # 004ee998
    {load} mov esp, ebp                          # 004ee99b
    pop ebp                                      # 004ee99d
    ret                                          # 004ee99e

