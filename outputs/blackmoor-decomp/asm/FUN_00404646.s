# FUN_00404646
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404646
# extent:       0x00404646-0x004046ea (164 code bytes)
# span:         0x00404646-0x004046ea (code 164, tables 0, padding 0)
# sha256:       903a9563a9ec00fdb07ed79bd00f6737da2c7ee1ab671b579a49c5f4e5a396b2
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m404646_read_time_setting
# naming:       native port src/original_methods_fl38c.c:m404646_read_time_setting (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    String via 0x51d5b2 (this+0x2cc), 0x50cb1b result to entry field 0x5e56ba; field 0x5e56b2 = h*3600000+m*60000+s*1000, then 0x4033db(this). 39/39 instructions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38c.c:m404646_read_time_setting (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x00404646 - 0x401000
.globl FUN_00404646
FUN_00404646:
    # block 0x00404646: entry, 39 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 00404646
    {load} mov ebp, esp                          # 00404647
    sub esp, 0x18                                # 00404649
    mov dword ptr [ebp - local_18], ecx          # 0040464c
    push 0x13                                    # 0040464f
    lea eax, [ebp - local_14]                    # 00404651
    push eax                                     # 00404654
    mov ecx, dword ptr [ebp - local_18]          # 00404655
    add ecx, 0x2cc                               # 00404658
    call FUN_0051d5b2                            # 0040465e
    lea ecx, [ebp - local_14]                    # 00404663
    push ecx                                     # 00404666
    call FUN_0050cb1b                            # 00404667
    add esp, 0x4                                 # 0040466c
    mov edx, dword ptr [0x5c3a63]                # 0040466f
    imul edx, edx, 0x106                         # 00404675
    mov dword ptr [edx + 0x5e56ba], eax          # 0040467b
    mov eax, dword ptr [0x5c3a63]                # 00404681
    imul eax, eax, 0x106                         # 00404686
    mov ecx, dword ptr [eax + 0x5e56be]          # 0040468c
    imul ecx, ecx, 0x36ee80                      # 00404692
    mov edx, dword ptr [0x5c3a63]                # 00404698
    imul edx, edx, 0x106                         # 0040469e
    mov eax, dword ptr [edx + 0x5e56ba]          # 004046a4
    imul eax, eax, 0xea60                        # 004046aa
    {load} add ecx, eax                          # 004046b0
    mov edx, dword ptr [0x5c3a63]                # 004046b2
    imul edx, edx, 0x106                         # 004046b8
    mov eax, dword ptr [edx + 0x5e56b6]          # 004046be
    imul eax, eax, 0x3e8                         # 004046c4
    {load} add ecx, eax                          # 004046ca
    mov edx, dword ptr [0x5c3a63]                # 004046cc
    imul edx, edx, 0x106                         # 004046d2
    mov dword ptr [edx + 0x5e56b2], ecx          # 004046d8
    mov ecx, dword ptr [ebp - local_18]          # 004046de
    call FUN_004033db                            # 004046e1
    {load} mov esp, ebp                          # 004046e6
    pop ebp                                      # 004046e8
    ret                                          # 004046e9

