# FUN_004cc946
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cc946
# extent:       0x004cc946-0x004cc962 (28 code bytes)
# span:         0x004cc946-0x004cc962 (code 28, tables 0, padding 0)
# sha256:       a9087f748a35e5e6baa97be07c8305f86e2c29f5dafb8664490e8ed25fdb4d38
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cc946_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4cc946_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e278u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4cc946_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004cc946 - 0x401000
.globl FUN_004cc946
FUN_004cc946:
    # block 0x004cc946: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004cc946
    {load} mov ebp, esp                          # 004cc947
    push ecx                                     # 004cc949
    mov dword ptr [ebp - local_4], ecx           # 004cc94a
    mov eax, dword ptr [ebp - local_4]           # 004cc94d
    mov dword ptr [eax], 0x52e278                # 004cc950
    mov ecx, dword ptr [ebp - local_4]           # 004cc956
    call FUN_0051d730                            # 004cc959
    {load} mov esp, ebp                          # 004cc95e
    pop ebp                                      # 004cc960
    ret                                          # 004cc961

