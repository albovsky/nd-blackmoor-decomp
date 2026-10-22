# FUN_004e37f8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e37f8
# extent:       0x004e37f8-0x004e3833 (59 code bytes)
# span:         0x004e37f8-0x004e3833 (code 59, tables 0, padding 0)
# sha256:       62b13d42195a6b68d961265f4432f2674a6062a375f499591d644889727f3096
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e37f8_call_three_zero
# naming:       native port src/original_methods_fl39c.c:m4e37f8_call_three_zero (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4e2940 three times with this = self+0x3d5d, self+0x3eec, self+0x4399 and argument 0 and returns the eax of the third. No jumps; all 19 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e2940
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4e37f8_call_three_zero (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)

.org 0x004e37f8 - 0x401000
.globl FUN_004e37f8
FUN_004e37f8:
    # block 0x004e37f8: entry, 19 instruction(s), calls FUN_004e2940, ends with ret
    push ebp                                     # 004e37f8
    {load} mov ebp, esp                          # 004e37f9
    push ecx                                     # 004e37fb
    mov dword ptr [ebp - local_4], ecx           # 004e37fc
    push 0x0                                     # 004e37ff
    mov ecx, dword ptr [ebp - local_4]           # 004e3801
    add ecx, 0x3d5d                              # 004e3804
    call FUN_004e2940                            # 004e380a
    push 0x0                                     # 004e380f
    mov ecx, dword ptr [ebp - local_4]           # 004e3811
    add ecx, 0x3eec                              # 004e3814
    call FUN_004e2940                            # 004e381a
    push 0x0                                     # 004e381f
    mov ecx, dword ptr [ebp - local_4]           # 004e3821
    add ecx, 0x4399                              # 004e3824
    call FUN_004e2940                            # 004e382a
    {load} mov esp, ebp                          # 004e382f
    pop ebp                                      # 004e3831
    ret                                          # 004e3832

