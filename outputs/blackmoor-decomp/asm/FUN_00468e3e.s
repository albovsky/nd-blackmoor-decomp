# FUN_00468e3e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468e3e
# extent:       0x00468e3e-0x00468e5a (28 code bytes)
# span:         0x00468e3e-0x00468e5a (code 28, tables 0, padding 0)
# sha256:       f38aa4ca73c3a37106d84d1f4c48f3088c4008e73093c90fd0df49e75fca1001
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m468e3e_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m468e3e_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52d220u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m468e3e_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00468e3e - 0x401000
.globl FUN_00468e3e
FUN_00468e3e:
    # block 0x00468e3e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00468e3e
    {load} mov ebp, esp                          # 00468e3f
    push ecx                                     # 00468e41
    mov dword ptr [ebp - local_4], ecx           # 00468e42
    mov eax, dword ptr [ebp - local_4]           # 00468e45
    mov dword ptr [eax], 0x52d220                # 00468e48
    mov ecx, dword ptr [ebp - local_4]           # 00468e4e
    call FUN_0051d730                            # 00468e51
    {load} mov esp, ebp                          # 00468e56
    pop ebp                                      # 00468e58
    ret                                          # 00468e59

