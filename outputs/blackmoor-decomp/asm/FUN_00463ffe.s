# FUN_00463ffe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00463ffe
# extent:       0x00463ffe-0x0046401a (28 code bytes)
# span:         0x00463ffe-0x0046401a (code 28, tables 0, padding 0)
# sha256:       29c6cae67d79ab0c5967856590e9006530d4c2ca7efc711b1d91c6b47f84f5a4
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m463ffe_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m463ffe_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52d108u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m463ffe_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00463ffe - 0x401000
.globl FUN_00463ffe
FUN_00463ffe:
    # block 0x00463ffe: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00463ffe
    {load} mov ebp, esp                          # 00463fff
    push ecx                                     # 00464001
    mov dword ptr [ebp - local_4], ecx           # 00464002
    mov eax, dword ptr [ebp - local_4]           # 00464005
    mov dword ptr [eax], 0x52d108                # 00464008
    mov ecx, dword ptr [ebp - local_4]           # 0046400e
    call FUN_0051d730                            # 00464011
    {load} mov esp, ebp                          # 00464016
    pop ebp                                      # 00464018
    ret                                          # 00464019

