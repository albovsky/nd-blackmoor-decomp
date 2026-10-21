# FUN_004e1c83
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1c83
# extent:       0x004e1c83-0x004e1c9f (28 code bytes)
# span:         0x004e1c83-0x004e1c9f (code 28, tables 0, padding 0)
# sha256:       89034013d0406390f5935fd4662ad8da32de56beb8af728a69f5c5f4c6d23b97
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e1c83_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4e1c83_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e4e8u at [this], returns 0x4e1d34(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e1d34
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4e1c83_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e1d34, .text + (0x004e1d34 - 0x401000)

.org 0x004e1c83 - 0x401000
.globl FUN_004e1c83
FUN_004e1c83:
    # block 0x004e1c83: entry, 11 instruction(s), calls FUN_004e1d34, ends with ret
    push ebp                                     # 004e1c83
    {load} mov ebp, esp                          # 004e1c84
    push ecx                                     # 004e1c86
    mov dword ptr [ebp - local_4], ecx           # 004e1c87
    mov eax, dword ptr [ebp - local_4]           # 004e1c8a
    mov dword ptr [eax], 0x52e4e8                # 004e1c8d
    mov ecx, dword ptr [ebp - local_4]           # 004e1c93
    call FUN_004e1d34                            # 004e1c96
    {load} mov esp, ebp                          # 004e1c9b
    pop ebp                                      # 004e1c9d
    ret                                          # 004e1c9e

