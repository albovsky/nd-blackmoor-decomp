# FUN_004e3691
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e3691
# extent:       0x004e3691-0x004e36fc (107 code bytes)
# span:         0x004e3691-0x004e36fc (code 107, tables 0, padding 0)
# sha256:       a560f4626e4846253c5d51f26c041fc682581bb76fbc1be51ed05887a0f2184c
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e3691_lifted
# naming:       native port src/original_methods_fl39d.c:m4e3691_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e2940
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e3691_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)

.org 0x004e3691 - 0x401000
.globl FUN_004e3691
FUN_004e3691:
    # block 0x004e3691: entry, 31 instruction(s), calls FUN_004e2940, ends with ret
    push ebp                                     # 004e3691
    {load} mov ebp, esp                          # 004e3692
    push ecx                                     # 004e3694
    mov dword ptr [ebp - local_4], ecx           # 004e3695
    push 0x0                                     # 004e3698
    mov ecx, dword ptr [ebp - local_4]           # 004e369a
    add ecx, 0x3592                              # 004e369d
    call FUN_004e2940                            # 004e36a3
    push 0x0                                     # 004e36a8
    mov ecx, dword ptr [ebp - local_4]           # 004e36aa
    add ecx, 0x3721                              # 004e36ad
    call FUN_004e2940                            # 004e36b3
    push 0x0                                     # 004e36b8
    mov ecx, dword ptr [ebp - local_4]           # 004e36ba
    add ecx, 0x38b0                              # 004e36bd
    call FUN_004e2940                            # 004e36c3
    push 0x0                                     # 004e36c8
    mov ecx, dword ptr [ebp - local_4]           # 004e36ca
    add ecx, 0x2f56                              # 004e36cd
    call FUN_004e2940                            # 004e36d3
    push 0x0                                     # 004e36d8
    mov ecx, dword ptr [ebp - local_4]           # 004e36da
    add ecx, 0x30e5                              # 004e36dd
    call FUN_004e2940                            # 004e36e3
    push 0x4                                     # 004e36e8
    mov ecx, dword ptr [ebp - local_4]           # 004e36ea
    add ecx, 0x3403                              # 004e36ed
    call FUN_004e2940                            # 004e36f3
    {load} mov esp, ebp                          # 004e36f8
    pop ebp                                      # 004e36fa
    ret                                          # 004e36fb

