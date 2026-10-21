# FUN_004044fe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004044fe
# extent:       0x004044fe-0x004045a2 (164 code bytes)
# span:         0x004044fe-0x004045a2 (code 164, tables 0, padding 0)
# sha256:       eba1a2bd007cc2bd8e0ed535b06efee090bceff8978abd425c84761f3aa04ca4
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4044fe_read_time_setting
# naming:       native port src/original_methods_fl38c.c:m4044fe_read_time_setting (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    String via 0x51d5b2 (this+0x28c), 0x50cb1b result to entry field 0x5e56a2; field 0x5e569e = h*3600000+m*60000+s*1000, then 0x4033db(this). 39/39 instructions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38c.c:m4044fe_read_time_setting (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x004044fe - 0x401000
.globl FUN_004044fe
FUN_004044fe:
    # block 0x004044fe: entry, 39 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 004044fe
    {load} mov ebp, esp                          # 004044ff
    sub esp, 0x18                                # 00404501
    mov dword ptr [ebp - local_18], ecx          # 00404504
    push 0x13                                    # 00404507
    lea eax, [ebp - local_14]                    # 00404509
    push eax                                     # 0040450c
    mov ecx, dword ptr [ebp - local_18]          # 0040450d
    add ecx, 0x28c                               # 00404510
    call FUN_0051d5b2                            # 00404516
    lea ecx, [ebp - local_14]                    # 0040451b
    push ecx                                     # 0040451e
    call FUN_0050cb1b                            # 0040451f
    add esp, 0x4                                 # 00404524
    mov edx, dword ptr [0x5c3a63]                # 00404527
    imul edx, edx, 0x106                         # 0040452d
    mov dword ptr [edx + 0x5e56a2], eax          # 00404533
    mov eax, dword ptr [0x5c3a63]                # 00404539
    imul eax, eax, 0x106                         # 0040453e
    mov ecx, dword ptr [eax + 0x5e56aa]          # 00404544
    imul ecx, ecx, 0x36ee80                      # 0040454a
    mov edx, dword ptr [0x5c3a63]                # 00404550
    imul edx, edx, 0x106                         # 00404556
    mov eax, dword ptr [edx + 0x5e56a6]          # 0040455c
    imul eax, eax, 0xea60                        # 00404562
    {load} add ecx, eax                          # 00404568
    mov edx, dword ptr [0x5c3a63]                # 0040456a
    imul edx, edx, 0x106                         # 00404570
    mov eax, dword ptr [edx + 0x5e56a2]          # 00404576
    imul eax, eax, 0x3e8                         # 0040457c
    {load} add ecx, eax                          # 00404582
    mov edx, dword ptr [0x5c3a63]                # 00404584
    imul edx, edx, 0x106                         # 0040458a
    mov dword ptr [edx + 0x5e569e], ecx          # 00404590
    mov ecx, dword ptr [ebp - local_18]          # 00404596
    call FUN_004033db                            # 00404599
    {load} mov esp, ebp                          # 0040459e
    pop ebp                                      # 004045a0
    ret                                          # 004045a1

