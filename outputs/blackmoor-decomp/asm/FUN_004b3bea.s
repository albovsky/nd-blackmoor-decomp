# FUN_004b3bea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3bea
# extent:       0x004b3bea-0x004b3c3e (84 code bytes)
# span:         0x004b3bea-0x004b3c3e (code 84, tables 0, padding 0)
# sha256:       b532ea18739abf490d406d4d3dc2990a11ed4372c1db4bef30166d7d106461c5
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b3bea_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m4b3bea_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52e098u at [this], calls 0x4b3c5a(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004b3c5a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4b3bea_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004b3c5a, .text + (0x004b3c5a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004b3bea - 0x401000
.globl FUN_004b3bea
FUN_004b3bea:
    # block 0x004b3bea: entry, 23 instruction(s), calls FUN_0051d716, FUN_004b3c5a, ends with ret
    push ebp                                     # 004b3bea
    {load} mov ebp, esp                          # 004b3beb
    push -0x1                                    # 004b3bed
    push 0x52871d                                # 004b3bef
    mov eax, dword ptr fs:[0x0]                  # 004b3bf4
    push eax                                     # 004b3bfa
    mov dword ptr fs:[0x0], esp                  # 004b3bfb
    push ecx                                     # 004b3c02
    mov dword ptr [ebp - local_10], ecx          # 004b3c03
    mov ecx, dword ptr [ebp - local_10]          # 004b3c06
    call FUN_0051d716                            # 004b3c09
    mov dword ptr [ebp - local_4], 0x0           # 004b3c0e
    mov eax, dword ptr [ebp - local_10]          # 004b3c15
    mov dword ptr [eax], 0x52e098                # 004b3c18
    mov ecx, dword ptr [ebp - local_10]          # 004b3c1e
    call FUN_004b3c5a                            # 004b3c21
    mov dword ptr [ebp - local_4], 0xffffffff    # 004b3c26
    mov eax, dword ptr [ebp - local_10]          # 004b3c2d
    mov ecx, dword ptr [ebp - local_c]           # 004b3c30
    mov dword ptr fs:[0x0], ecx                  # 004b3c33
    {load} mov esp, ebp                          # 004b3c3a
    pop ebp                                      # 004b3c3c
    ret                                          # 004b3c3d

