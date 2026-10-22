# FUN_004eda7c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eda7c
# extent:       0x004eda7c-0x004edae5 (105 code bytes)
# span:         0x004eda7c-0x004edae5 (code 105, tables 0, padding 0)
# sha256:       7dce12e80b688eb3f50d9cc83d32ef44b112d3cd47f980388ab1702ee3b730b3
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4eda7c_destroy_subobjects
# naming:       native port src/original_methods_fl39e.c:m4eda7c_destroy_subobjects (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the dword 0x52e4fcu at [this], calls 0x4edb97(this), 0x4ee99f(this+0x4b7) and returns 0x4e1c83(this+0x31c); the SEH frame is not modelled. No jumps; all 27 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004edb97, FUN_004ee99f, FUN_004e1c83
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4eda7c_destroy_subobjects (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e1c83, .text + (0x004e1c83 - 0x401000)
.set FUN_004edb97, .text + (0x004edb97 - 0x401000)
.set FUN_004ee99f, .text + (0x004ee99f - 0x401000)

.org 0x004eda7c - 0x401000
.globl FUN_004eda7c
FUN_004eda7c:
    # block 0x004eda7c: entry, 27 instruction(s), calls FUN_004edb97, FUN_004ee99f, FUN_004e1c83, ends with ret
    push ebp                                     # 004eda7c
    {load} mov ebp, esp                          # 004eda7d
    push -0x1                                    # 004eda7f
    push 0x528b36                                # 004eda81
    mov eax, dword ptr fs:[0x0]                  # 004eda86
    push eax                                     # 004eda8c
    mov dword ptr fs:[0x0], esp                  # 004eda8d
    push ecx                                     # 004eda94
    mov dword ptr [ebp - local_10], ecx          # 004eda95
    mov eax, dword ptr [ebp - local_10]          # 004eda98
    mov dword ptr [eax], 0x52e4fc                # 004eda9b
    mov dword ptr [ebp - local_4], 0x1           # 004edaa1
    mov ecx, dword ptr [ebp - local_10]          # 004edaa8
    call FUN_004edb97                            # 004edaab
    mov byte ptr [ebp - local_4], 0x0            # 004edab0
    mov ecx, dword ptr [ebp - local_10]          # 004edab4
    add ecx, 0x4b7                               # 004edab7
    call FUN_004ee99f                            # 004edabd
    mov dword ptr [ebp - local_4], 0xffffffff    # 004edac2
    mov ecx, dword ptr [ebp - local_10]          # 004edac9
    add ecx, 0x31c                               # 004edacc
    call FUN_004e1c83                            # 004edad2
    mov ecx, dword ptr [ebp - local_c]           # 004edad7
    mov dword ptr fs:[0x0], ecx                  # 004edada
    {load} mov esp, ebp                          # 004edae1
    pop ebp                                      # 004edae3
    ret                                          # 004edae4

