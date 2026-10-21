# FUN_004b9e00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b9e00
# extent:       0x004b9e00-0x004b9e1f (31 code bytes)
# span:         0x004b9e00-0x004b9e1f (code 31, tables 0, padding 0)
# sha256:       d7bd5bae3ba816fc61cdcc15cb28fe64c49e6ce684420fa431aeb7581fcb016c
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b9e00_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m4b9e00_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e200u at [this], calls 0x4b9e3b(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004b9e3b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4b9e00_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004b9e3b, .text + (0x004b9e3b - 0x401000)

.org 0x004b9e00 - 0x401000
.globl FUN_004b9e00
FUN_004b9e00:
    # block 0x004b9e00: entry, 12 instruction(s), calls FUN_004b9e3b, ends with ret
    push ebp                                     # 004b9e00
    {load} mov ebp, esp                          # 004b9e01
    push ecx                                     # 004b9e03
    mov dword ptr [ebp - local_4], ecx           # 004b9e04
    mov eax, dword ptr [ebp - local_4]           # 004b9e07
    mov dword ptr [eax], 0x52e200                # 004b9e0a
    mov ecx, dword ptr [ebp - local_4]           # 004b9e10
    call FUN_004b9e3b                            # 004b9e13
    mov eax, dword ptr [ebp - local_4]           # 004b9e18
    {load} mov esp, ebp                          # 004b9e1b
    pop ebp                                      # 004b9e1d
    ret                                          # 004b9e1e

