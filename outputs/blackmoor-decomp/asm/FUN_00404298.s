# FUN_00404298
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404298
# extent:       0x00404298-0x004042d3 (59 code bytes)
# span:         0x00404298-0x004042d3 (code 59, tables 0, padding 0)
# sha256:       9751a1622a11ef6caf78592a491d60a9f09d9a614fca41e6f9ec5ca654372d5a
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m404298_read_text_10c
# naming:       native port src/original_methods_fl32a.c:m404298_read_text_10c (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Same as 0x40425d for the field at self+0x10c and the word at 0x5ec340: text through 0x51d5b2, convert with 0x50cb1b, store the low word, call 0x4033db; straight line, all executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32a.c:m404298_read_text_10c (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x00404298 - 0x401000
.globl FUN_00404298
FUN_00404298:
    # block 0x00404298: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 00404298
    {load} mov ebp, esp                          # 00404299
    sub esp, 0x18                                # 0040429b
    mov dword ptr [ebp - local_18], ecx          # 0040429e
    push 0x13                                    # 004042a1
    lea eax, [ebp - local_14]                    # 004042a3
    push eax                                     # 004042a6
    mov ecx, dword ptr [ebp - local_18]          # 004042a7
    add ecx, 0x10c                               # 004042aa
    call FUN_0051d5b2                            # 004042b0
    lea ecx, [ebp - local_14]                    # 004042b5
    push ecx                                     # 004042b8
    call FUN_0050cb1b                            # 004042b9
    add esp, 0x4                                 # 004042be
    mov word ptr [0x5ec340], ax                  # 004042c1
    mov ecx, dword ptr [ebp - local_18]          # 004042c7
    call FUN_004033db                            # 004042ca
    {load} mov esp, ebp                          # 004042cf
    pop ebp                                      # 004042d1
    ret                                          # 004042d2

