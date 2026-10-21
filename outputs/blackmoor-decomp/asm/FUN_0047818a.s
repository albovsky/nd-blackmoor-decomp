# FUN_0047818a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047818a
# extent:       0x0047818a-0x004781de (84 code bytes)
# span:         0x0047818a-0x004781de (code 84, tables 0, padding 0)
# sha256:       a2161f9d5ceca8adfcfecc07366baa6528dd0a5d1b3b3b8911e7e48f23f4a8f2
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47818a_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m47818a_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52d518u at [this], calls 0x4781fa(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004781fa
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m47818a_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004781fa, .text + (0x004781fa - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0047818a - 0x401000
.globl FUN_0047818a
FUN_0047818a:
    # block 0x0047818a: entry, 23 instruction(s), calls FUN_0051d716, FUN_004781fa, ends with ret
    push ebp                                     # 0047818a
    {load} mov ebp, esp                          # 0047818b
    push -0x1                                    # 0047818d
    push 0x52830d                                # 0047818f
    mov eax, dword ptr fs:[0x0]                  # 00478194
    push eax                                     # 0047819a
    mov dword ptr fs:[0x0], esp                  # 0047819b
    push ecx                                     # 004781a2
    mov dword ptr [ebp - local_10], ecx          # 004781a3
    mov ecx, dword ptr [ebp - local_10]          # 004781a6
    call FUN_0051d716                            # 004781a9
    mov dword ptr [ebp - local_4], 0x0           # 004781ae
    mov eax, dword ptr [ebp - local_10]          # 004781b5
    mov dword ptr [eax], 0x52d518                # 004781b8
    mov ecx, dword ptr [ebp - local_10]          # 004781be
    call FUN_004781fa                            # 004781c1
    mov dword ptr [ebp - local_4], 0xffffffff    # 004781c6
    mov eax, dword ptr [ebp - local_10]          # 004781cd
    mov ecx, dword ptr [ebp - local_c]           # 004781d0
    mov dword ptr fs:[0x0], ecx                  # 004781d3
    {load} mov esp, ebp                          # 004781da
    pop ebp                                      # 004781dc
    ret                                          # 004781dd

