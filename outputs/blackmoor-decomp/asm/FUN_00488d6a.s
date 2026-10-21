# FUN_00488d6a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00488d6a
# extent:       0x00488d6a-0x00488d89 (31 code bytes)
# span:         0x00488d6a-0x00488d89 (code 31, tables 0, padding 0)
# sha256:       c358cbc04f7310d574672e55dd46c89f53bf372d59d2a83ee2acfa99cd22459d
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m488d6a_destruct_base_set_vtable
# naming:       native port src/original_methods_fl36e.c:m488d6a_destruct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), then stores 0x52d850u at [this], returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m488d6a_destruct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00488d6a - 0x401000
.globl FUN_00488d6a
FUN_00488d6a:
    # block 0x00488d6a: entry, 12 instruction(s), calls FUN_0051d716, ends with ret
    push ebp                                     # 00488d6a
    {load} mov ebp, esp                          # 00488d6b
    push ecx                                     # 00488d6d
    mov dword ptr [ebp - local_4], ecx           # 00488d6e
    mov ecx, dword ptr [ebp - local_4]           # 00488d71
    call FUN_0051d716                            # 00488d74
    mov eax, dword ptr [ebp - local_4]           # 00488d79
    mov dword ptr [eax], 0x52d850                # 00488d7c
    mov eax, dword ptr [ebp - local_4]           # 00488d82
    {load} mov esp, ebp                          # 00488d85
    pop ebp                                      # 00488d87
    ret                                          # 00488d88

