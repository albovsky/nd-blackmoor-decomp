# FUN_00447e27
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447e27
# extent:       0x00447e27-0x00447e46 (31 code bytes)
# span:         0x00447e27-0x00447e46 (code 31, tables 0, padding 0)
# sha256:       69bfe285090ca137ad8e75beafd0a56b42abbc018074c921e0d66f5393b5f1df
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m447e27_destruct_base_set_vtable
# naming:       native port src/original_methods_fl36e.c:m447e27_destruct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), then stores 0x52cb08u at [this], returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m447e27_destruct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00447e27 - 0x401000
.globl FUN_00447e27
FUN_00447e27:
    # block 0x00447e27: entry, 12 instruction(s), calls FUN_0051d716, ends with ret
    push ebp                                     # 00447e27
    {load} mov ebp, esp                          # 00447e28
    push ecx                                     # 00447e2a
    mov dword ptr [ebp - local_4], ecx           # 00447e2b
    mov ecx, dword ptr [ebp - local_4]           # 00447e2e
    call FUN_0051d716                            # 00447e31
    mov eax, dword ptr [ebp - local_4]           # 00447e36
    mov dword ptr [eax], 0x52cb08                # 00447e39
    mov eax, dword ptr [ebp - local_4]           # 00447e3f
    {load} mov esp, ebp                          # 00447e42
    pop ebp                                      # 00447e44
    ret                                          # 00447e45

