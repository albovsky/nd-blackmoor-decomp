# FUN_0044afb7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044afb7
# extent:       0x0044afb7-0x0044afd6 (31 code bytes)
# span:         0x0044afb7-0x0044afd6 (code 31, tables 0, padding 0)
# sha256:       786fd8095a3ab0c84e03e5a5b0e34be632c997f61870cebe2ef305a0cc7f341c
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44afb7_destruct_base_set_vtable
# naming:       native port src/original_methods_fl36e.c:m44afb7_destruct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), then stores 0x52cb98u at [this], returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m44afb7_destruct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0044afb7 - 0x401000
.globl FUN_0044afb7
FUN_0044afb7:
    # block 0x0044afb7: entry, 12 instruction(s), calls FUN_0051d716, ends with ret
    push ebp                                     # 0044afb7
    {load} mov ebp, esp                          # 0044afb8
    push ecx                                     # 0044afba
    mov dword ptr [ebp - local_4], ecx           # 0044afbb
    mov ecx, dword ptr [ebp - local_4]           # 0044afbe
    call FUN_0051d716                            # 0044afc1
    mov eax, dword ptr [ebp - local_4]           # 0044afc6
    mov dword ptr [eax], 0x52cb98                # 0044afc9
    mov eax, dword ptr [ebp - local_4]           # 0044afcf
    {load} mov esp, ebp                          # 0044afd2
    pop ebp                                      # 0044afd4
    ret                                          # 0044afd5

