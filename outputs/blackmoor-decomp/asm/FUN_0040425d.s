# FUN_0040425d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040425d
# extent:       0x0040425d-0x00404298 (59 code bytes)
# span:         0x0040425d-0x00404298 (code 59, tables 0, padding 0)
# sha256:       cfc14f42f433645b9c52e9548402ef00349916271a1711f5147d148690cc5725
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40425d_read_text_cc
# naming:       native port src/original_methods_fl32a.c:m40425d_read_text_cc (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Reads the text of the field at self+0xcc through 0x51d5b2 into a local buffer, converts it with 0x50cb1b, stores the low word at 0x5ec33e, then calls 0x4033db; straight line, all executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32a.c:m40425d_read_text_cc (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040425d - 0x401000
.globl FUN_0040425d
FUN_0040425d:
    # block 0x0040425d: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 0040425d
    {load} mov ebp, esp                          # 0040425e
    sub esp, 0x18                                # 00404260
    mov dword ptr [ebp - local_18], ecx          # 00404263
    push 0x13                                    # 00404266
    lea eax, [ebp - local_14]                    # 00404268
    push eax                                     # 0040426b
    mov ecx, dword ptr [ebp - local_18]          # 0040426c
    add ecx, 0xcc                                # 0040426f
    call FUN_0051d5b2                            # 00404275
    lea ecx, [ebp - local_14]                    # 0040427a
    push ecx                                     # 0040427d
    call FUN_0050cb1b                            # 0040427e
    add esp, 0x4                                 # 00404283
    mov word ptr [0x5ec33e], ax                  # 00404286
    mov ecx, dword ptr [ebp - local_18]          # 0040428c
    call FUN_004033db                            # 0040428f
    {load} mov esp, ebp                          # 00404294
    pop ebp                                      # 00404296
    ret                                          # 00404297

