# FUN_00422fe0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00422fe0
# extent:       0x00422fe0-0x00422ff9 (25 code bytes)
# span:         0x00422fe0-0x00423000 (code 25, tables 0, padding 7)
# sha256:       36e1150ee4c30c0e38688dc94d1572b11006e77aa089d75b9807374922959c1b
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m422fe0_lifted
# naming:       native port src/original_methods_fl40.c:m422fe0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 11/11 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m422fe0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00422fe0 - 0x401000
.globl FUN_00422fe0
FUN_00422fe0:
    # block 0x00422fe0: entry, 11 instruction(s), ends with ret
    push ebp                                     # 00422fe0
    {load} mov ebp, esp                          # 00422fe1
    push ecx                                     # 00422fe3
    mov dword ptr [ebp - local_4], ecx           # 00422fe4
    mov eax, dword ptr [ebp - local_4]           # 00422fe7
    mov ecx, dword ptr [0x5679b0]                # 00422fea
    mov dword ptr [eax], ecx                     # 00422ff0
    mov eax, dword ptr [ebp - local_4]           # 00422ff2
    {load} mov esp, ebp                          # 00422ff5
    pop ebp                                      # 00422ff7
    ret                                          # 00422ff8

# --- data items (not part of the function) -------------------------
.org 0x00422ff9 - 0x401000
PAD_00422ff9:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

