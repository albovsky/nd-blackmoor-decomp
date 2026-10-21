# FUN_00414cb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414cb0
# extent:       0x00414cb0-0x00414ccf (31 code bytes)
# span:         0x00414cb0-0x00414ccf (code 31, tables 0, padding 0)
# sha256:       b214eab3d5038045e00ff3d1ff68f7370a876d5cc965ba0186f20349249c112a
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m414cb0_destruct_base_set_vtable
# naming:       native port src/original_methods_fl36e.c:m414cb0_destruct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), then stores 0x52c540u at [this], returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m414cb0_destruct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00414cb0 - 0x401000
.globl FUN_00414cb0
FUN_00414cb0:
    # block 0x00414cb0: entry, 12 instruction(s), calls FUN_0051d716, ends with ret
    push ebp                                     # 00414cb0
    {load} mov ebp, esp                          # 00414cb1
    push ecx                                     # 00414cb3
    mov dword ptr [ebp - local_4], ecx           # 00414cb4
    mov ecx, dword ptr [ebp - local_4]           # 00414cb7
    call FUN_0051d716                            # 00414cba
    mov eax, dword ptr [ebp - local_4]           # 00414cbf
    mov dword ptr [eax], 0x52c540                # 00414cc2
    mov eax, dword ptr [ebp - local_4]           # 00414cc8
    {load} mov esp, ebp                          # 00414ccb
    pop ebp                                      # 00414ccd
    ret                                          # 00414cce

