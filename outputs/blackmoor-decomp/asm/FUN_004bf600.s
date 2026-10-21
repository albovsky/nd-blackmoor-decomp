# FUN_004bf600
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf600
# extent:       0x004bf600-0x004bf61f (31 code bytes)
# span:         0x004bf600-0x004bf61f (code 31, tables 0, padding 0)
# sha256:       0bc2992bc59f6c9e1a502a908956cf04c358c7e08d44fe20cb5955686317c92b
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf600_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m4bf600_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e214u at [this], calls 0x4bf63b(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004bf63b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4bf600_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004bf63b, .text + (0x004bf63b - 0x401000)

.org 0x004bf600 - 0x401000
.globl FUN_004bf600
FUN_004bf600:
    # block 0x004bf600: entry, 12 instruction(s), calls FUN_004bf63b, ends with ret
    push ebp                                     # 004bf600
    {load} mov ebp, esp                          # 004bf601
    push ecx                                     # 004bf603
    mov dword ptr [ebp - local_4], ecx           # 004bf604
    mov eax, dword ptr [ebp - local_4]           # 004bf607
    mov dword ptr [eax], 0x52e214                # 004bf60a
    mov ecx, dword ptr [ebp - local_4]           # 004bf610
    call FUN_004bf63b                            # 004bf613
    mov eax, dword ptr [ebp - local_4]           # 004bf618
    {load} mov esp, ebp                          # 004bf61b
    pop ebp                                      # 004bf61d
    ret                                          # 004bf61e

