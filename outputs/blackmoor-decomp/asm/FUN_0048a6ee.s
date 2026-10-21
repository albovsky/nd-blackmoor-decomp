# FUN_0048a6ee
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a6ee
# extent:       0x0048a6ee-0x0048a70a (28 code bytes)
# span:         0x0048a6ee-0x0048a70a (code 28, tables 0, padding 0)
# sha256:       467555593e577a4bba24711a6e5eeff5419cad064c6f130d9875a0a9ca0444b4
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48a6ee_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m48a6ee_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52d8d8u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m48a6ee_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0048a6ee - 0x401000
.globl FUN_0048a6ee
FUN_0048a6ee:
    # block 0x0048a6ee: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0048a6ee
    {load} mov ebp, esp                          # 0048a6ef
    push ecx                                     # 0048a6f1
    mov dword ptr [ebp - local_4], ecx           # 0048a6f2
    mov eax, dword ptr [ebp - local_4]           # 0048a6f5
    mov dword ptr [eax], 0x52d8d8                # 0048a6f8
    mov ecx, dword ptr [ebp - local_4]           # 0048a6fe
    call FUN_0051d730                            # 0048a701
    {load} mov esp, ebp                          # 0048a706
    pop ebp                                      # 0048a708
    ret                                          # 0048a709

