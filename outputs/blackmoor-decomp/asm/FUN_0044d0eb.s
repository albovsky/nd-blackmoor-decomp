# FUN_0044d0eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d0eb
# extent:       0x0044d0eb-0x0044d107 (28 code bytes)
# span:         0x0044d0eb-0x0044d107 (code 28, tables 0, padding 0)
# sha256:       bdc19d837ba30461413a9736e35e374e4acc6bfa0555901584b8ac2789ac52e7
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44d0eb_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m44d0eb_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cc38u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m44d0eb_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0044d0eb - 0x401000
.globl FUN_0044d0eb
FUN_0044d0eb:
    # block 0x0044d0eb: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0044d0eb
    {load} mov ebp, esp                          # 0044d0ec
    push ecx                                     # 0044d0ee
    mov dword ptr [ebp - local_4], ecx           # 0044d0ef
    mov eax, dword ptr [ebp - local_4]           # 0044d0f2
    mov dword ptr [eax], 0x52cc38                # 0044d0f5
    mov ecx, dword ptr [ebp - local_4]           # 0044d0fb
    call FUN_0051d730                            # 0044d0fe
    {load} mov esp, ebp                          # 0044d103
    pop ebp                                      # 0044d105
    ret                                          # 0044d106

