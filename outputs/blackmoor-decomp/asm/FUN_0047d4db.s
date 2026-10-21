# FUN_0047d4db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d4db
# extent:       0x0047d4db-0x0047d4f7 (28 code bytes)
# span:         0x0047d4db-0x0047d4f7 (code 28, tables 0, padding 0)
# sha256:       40a4e71377a8fa8c1e3a3020e9e3e079e140c26ca8967b7030c5f9596dc21f68
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47d4db_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m47d4db_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52d5a8u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m47d4db_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0047d4db - 0x401000
.globl FUN_0047d4db
FUN_0047d4db:
    # block 0x0047d4db: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0047d4db
    {load} mov ebp, esp                          # 0047d4dc
    push ecx                                     # 0047d4de
    mov dword ptr [ebp - local_4], ecx           # 0047d4df
    mov eax, dword ptr [ebp - local_4]           # 0047d4e2
    mov dword ptr [eax], 0x52d5a8                # 0047d4e5
    mov ecx, dword ptr [ebp - local_4]           # 0047d4eb
    call FUN_0051d730                            # 0047d4ee
    {load} mov esp, ebp                          # 0047d4f3
    pop ebp                                      # 0047d4f5
    ret                                          # 0047d4f6

