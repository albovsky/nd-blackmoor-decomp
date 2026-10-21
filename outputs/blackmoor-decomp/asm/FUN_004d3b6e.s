# FUN_004d3b6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3b6e
# extent:       0x004d3b6e-0x004d3b8a (28 code bytes)
# span:         0x004d3b6e-0x004d3b8a (code 28, tables 0, padding 0)
# sha256:       ad8937bc43f73cc41b6098586b10310fc353105c46bad63a24868110ccb8bdea
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3b6e_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4d3b6e_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e310u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4d3b6e_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004d3b6e - 0x401000
.globl FUN_004d3b6e
FUN_004d3b6e:
    # block 0x004d3b6e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004d3b6e
    {load} mov ebp, esp                          # 004d3b6f
    push ecx                                     # 004d3b71
    mov dword ptr [ebp - local_4], ecx           # 004d3b72
    mov eax, dword ptr [ebp - local_4]           # 004d3b75
    mov dword ptr [eax], 0x52e310                # 004d3b78
    mov ecx, dword ptr [ebp - local_4]           # 004d3b7e
    call FUN_0051d730                            # 004d3b81
    {load} mov esp, ebp                          # 004d3b86
    pop ebp                                      # 004d3b88
    ret                                          # 004d3b89

