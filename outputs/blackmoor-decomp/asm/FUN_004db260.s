# FUN_004db260
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db260
# extent:       0x004db260-0x004db27f (31 code bytes)
# span:         0x004db260-0x004db27f (code 31, tables 0, padding 0)
# sha256:       f14a544092941a11d0bf1ca6cf1d00fe78a69d44786831ac69249cc902fc047e
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4db260_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m4db260_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e458u at [this], calls 0x4db29b(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004db29b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4db260_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004db29b, .text + (0x004db29b - 0x401000)

.org 0x004db260 - 0x401000
.globl FUN_004db260
FUN_004db260:
    # block 0x004db260: entry, 12 instruction(s), calls FUN_004db29b, ends with ret
    push ebp                                     # 004db260
    {load} mov ebp, esp                          # 004db261
    push ecx                                     # 004db263
    mov dword ptr [ebp - local_4], ecx           # 004db264
    mov eax, dword ptr [ebp - local_4]           # 004db267
    mov dword ptr [eax], 0x52e458                # 004db26a
    mov ecx, dword ptr [ebp - local_4]           # 004db270
    call FUN_004db29b                            # 004db273
    mov eax, dword ptr [ebp - local_4]           # 004db278
    {load} mov esp, ebp                          # 004db27b
    pop ebp                                      # 004db27d
    ret                                          # 004db27e

