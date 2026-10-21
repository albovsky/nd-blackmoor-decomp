# FUN_00457f5e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457f5e
# extent:       0x00457f5e-0x00457f7a (28 code bytes)
# span:         0x00457f5e-0x00457f7a (code 28, tables 0, padding 0)
# sha256:       a4e8254dd8e556b2047811bc5a34ce7f3dedd6553453d009e8d3f482177737a2
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m457f5e_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m457f5e_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52ce60u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m457f5e_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00457f5e - 0x401000
.globl FUN_00457f5e
FUN_00457f5e:
    # block 0x00457f5e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00457f5e
    {load} mov ebp, esp                          # 00457f5f
    push ecx                                     # 00457f61
    mov dword ptr [ebp - local_4], ecx           # 00457f62
    mov eax, dword ptr [ebp - local_4]           # 00457f65
    mov dword ptr [eax], 0x52ce60                # 00457f68
    mov ecx, dword ptr [ebp - local_4]           # 00457f6e
    call FUN_0051d730                            # 00457f71
    {load} mov esp, ebp                          # 00457f76
    pop ebp                                      # 00457f78
    ret                                          # 00457f79

