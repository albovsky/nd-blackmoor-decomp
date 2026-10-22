# FUN_004e37bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e37bd
# extent:       0x004e37bd-0x004e37f8 (59 code bytes)
# span:         0x004e37bd-0x004e37f8 (code 59, tables 0, padding 0)
# sha256:       fec1a6b1ae871fcc79a35305187f9c1ceb5cc9ed451a858a8de50026a8c631ca
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e37bd_call_three_zero
# naming:       native port src/original_methods_fl39c.c:m4e37bd_call_three_zero (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4e2940 three times with this = self+0x3d5d, self+0x3eec, self+0x4399 and argument 0 and returns the eax of the third. No jumps; all 19 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e2940
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4e37bd_call_three_zero (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)

.org 0x004e37bd - 0x401000
.globl FUN_004e37bd
FUN_004e37bd:
    # block 0x004e37bd: entry, 19 instruction(s), calls FUN_004e2940, ends with ret
    push ebp                                     # 004e37bd
    {load} mov ebp, esp                          # 004e37be
    push ecx                                     # 004e37c0
    mov dword ptr [ebp - local_4], ecx           # 004e37c1
    push 0x0                                     # 004e37c4
    mov ecx, dword ptr [ebp - local_4]           # 004e37c6
    add ecx, 0x3d5d                              # 004e37c9
    call FUN_004e2940                            # 004e37cf
    push 0x0                                     # 004e37d4
    mov ecx, dword ptr [ebp - local_4]           # 004e37d6
    add ecx, 0x3eec                              # 004e37d9
    call FUN_004e2940                            # 004e37df
    push 0x0                                     # 004e37e4
    mov ecx, dword ptr [ebp - local_4]           # 004e37e6
    add ecx, 0x4399                              # 004e37e9
    call FUN_004e2940                            # 004e37ef
    {load} mov esp, ebp                          # 004e37f4
    pop ebp                                      # 004e37f6
    ret                                          # 004e37f7

