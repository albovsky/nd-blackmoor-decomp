# FUN_004045a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004045a2
# extent:       0x004045a2-0x00404646 (164 code bytes)
# span:         0x004045a2-0x00404646 (code 164, tables 0, padding 0)
# sha256:       540115de4751c1243029db9d651c423dbf01fff9feffea9bf70d5fb17ab9e21e
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4045a2_read_time_setting
# naming:       native port src/original_methods_fl38c.c:m4045a2_read_time_setting (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    String via 0x51d5b2 (this+0x30c), 0x50cb1b result to entry field 0x5e56be; field 0x5e56b2 = h*3600000+m*60000+s*1000, then 0x4033db(this). 39/39 instructions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38c.c:m4045a2_read_time_setting (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x004045a2 - 0x401000
.globl FUN_004045a2
FUN_004045a2:
    # block 0x004045a2: entry, 39 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 004045a2
    {load} mov ebp, esp                          # 004045a3
    sub esp, 0x18                                # 004045a5
    mov dword ptr [ebp - local_18], ecx          # 004045a8
    push 0x13                                    # 004045ab
    lea eax, [ebp - local_14]                    # 004045ad
    push eax                                     # 004045b0
    mov ecx, dword ptr [ebp - local_18]          # 004045b1
    add ecx, 0x30c                               # 004045b4
    call FUN_0051d5b2                            # 004045ba
    lea ecx, [ebp - local_14]                    # 004045bf
    push ecx                                     # 004045c2
    call FUN_0050cb1b                            # 004045c3
    add esp, 0x4                                 # 004045c8
    mov edx, dword ptr [0x5c3a63]                # 004045cb
    imul edx, edx, 0x106                         # 004045d1
    mov dword ptr [edx + 0x5e56be], eax          # 004045d7
    mov eax, dword ptr [0x5c3a63]                # 004045dd
    imul eax, eax, 0x106                         # 004045e2
    mov ecx, dword ptr [eax + 0x5e56be]          # 004045e8
    imul ecx, ecx, 0x36ee80                      # 004045ee
    mov edx, dword ptr [0x5c3a63]                # 004045f4
    imul edx, edx, 0x106                         # 004045fa
    mov eax, dword ptr [edx + 0x5e56ba]          # 00404600
    imul eax, eax, 0xea60                        # 00404606
    {load} add ecx, eax                          # 0040460c
    mov edx, dword ptr [0x5c3a63]                # 0040460e
    imul edx, edx, 0x106                         # 00404614
    mov eax, dword ptr [edx + 0x5e56b6]          # 0040461a
    imul eax, eax, 0x3e8                         # 00404620
    {load} add ecx, eax                          # 00404626
    mov edx, dword ptr [0x5c3a63]                # 00404628
    imul edx, edx, 0x106                         # 0040462e
    mov dword ptr [edx + 0x5e56b2], ecx          # 00404634
    mov ecx, dword ptr [ebp - local_18]          # 0040463a
    call FUN_004033db                            # 0040463d
    {load} mov esp, ebp                          # 00404642
    pop ebp                                      # 00404644
    ret                                          # 00404645

