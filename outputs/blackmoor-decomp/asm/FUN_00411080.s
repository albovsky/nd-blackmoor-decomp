# FUN_00411080
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00411080
# extent:       0x00411080-0x004110d7 (87 code bytes)
# span:         0x00411080-0x004110d7 (code 87, tables 0, padding 0)
# sha256:       f997014f4d15fede94b701d2c3d128896d99424a578bc21b6454d8380cb745f2
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m411080_lifted
# naming:       native port src/original_methods_fl40.c:m411080_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 24/24 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00423097, FUN_004110f6
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m411080_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004110f6, .text + (0x004110f6 - 0x401000)
.set FUN_00423097, .text + (0x00423097 - 0x401000)

.org 0x00411080 - 0x401000
.globl FUN_00411080
FUN_00411080:
    # block 0x00411080: entry, 24 instruction(s), calls FUN_00423097, FUN_004110f6, ends with ret
    push ebp                                     # 00411080
    {load} mov ebp, esp                          # 00411081
    push -0x1                                    # 00411083
    push 0x52725c                                # 00411085
    mov eax, dword ptr fs:[0x0]                  # 0041108a
    push eax                                     # 00411090
    mov dword ptr fs:[0x0], esp                  # 00411091
    push ecx                                     # 00411098
    mov dword ptr [ebp - local_10], ecx          # 00411099
    mov ecx, dword ptr [ebp - local_10]          # 0041109c
    add ecx, 0x2a                                # 0041109f
    call FUN_00423097                            # 004110a2
    mov dword ptr [ebp - local_4], 0x0           # 004110a7
    mov eax, dword ptr [ebp - local_10]          # 004110ae
    mov dword ptr [eax], 0x52c4b0                # 004110b1
    mov ecx, dword ptr [ebp - local_10]          # 004110b7
    call FUN_004110f6                            # 004110ba
    mov dword ptr [ebp - local_4], 0xffffffff    # 004110bf
    mov eax, dword ptr [ebp - local_10]          # 004110c6
    mov ecx, dword ptr [ebp - local_c]           # 004110c9
    mov dword ptr fs:[0x0], ecx                  # 004110cc
    {load} mov esp, ebp                          # 004110d3
    pop ebp                                      # 004110d5
    ret                                          # 004110d6

