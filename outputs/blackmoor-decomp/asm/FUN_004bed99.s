# FUN_004bed99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bed99
# extent:       0x004bed99-0x004bedb5 (28 code bytes)
# span:         0x004bed99-0x004bedb5 (code 28, tables 0, padding 0)
# sha256:       0e4a602310ba0178392f924d603fd1597e4fc5e658c615330dfc7d26656b9f70
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bed99_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4bed99_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e210u at [this], returns 0x4bede7(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004bede7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4bed99_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004bede7, .text + (0x004bede7 - 0x401000)

.org 0x004bed99 - 0x401000
.globl FUN_004bed99
FUN_004bed99:
    # block 0x004bed99: entry, 11 instruction(s), calls FUN_004bede7, ends with ret
    push ebp                                     # 004bed99
    {load} mov ebp, esp                          # 004bed9a
    push ecx                                     # 004bed9c
    mov dword ptr [ebp - local_4], ecx           # 004bed9d
    mov eax, dword ptr [ebp - local_4]           # 004beda0
    mov dword ptr [eax], 0x52e210                # 004beda3
    mov ecx, dword ptr [ebp - local_4]           # 004beda9
    call FUN_004bede7                            # 004bedac
    {load} mov esp, ebp                          # 004bedb1
    pop ebp                                      # 004bedb3
    ret                                          # 004bedb4

