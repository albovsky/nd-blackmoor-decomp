# FUN_004043b6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004043b6
# extent:       0x004043b6-0x0040445a (164 code bytes)
# span:         0x004043b6-0x0040445a (code 164, tables 0, padding 0)
# sha256:       bf658dc3ebacf478fbd53b7fd7877741d551b4584d2b9361a67cd86e73c6a0df
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004043b6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x004043b6 - 0x401000
.globl FUN_004043b6
FUN_004043b6:
    # block 0x004043b6: entry, 39 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 004043b6
    {load} mov ebp, esp                          # 004043b7
    sub esp, 0x18                                # 004043b9
    mov dword ptr [ebp - local_18], ecx          # 004043bc
    push 0x13                                    # 004043bf
    lea eax, [ebp - local_14]                    # 004043c1
    push eax                                     # 004043c4
    mov ecx, dword ptr [ebp - local_18]          # 004043c5
    add ecx, 0x24c                               # 004043c8
    call FUN_0051d5b2                            # 004043ce
    lea ecx, [ebp - local_14]                    # 004043d3
    push ecx                                     # 004043d6
    call FUN_0050cb1b                            # 004043d7
    add esp, 0x4                                 # 004043dc
    mov edx, dword ptr [0x5c3a63]                # 004043df
    imul edx, edx, 0x106                         # 004043e5
    mov dword ptr [edx + 0x5e56aa], eax          # 004043eb
    mov eax, dword ptr [0x5c3a63]                # 004043f1
    imul eax, eax, 0x106                         # 004043f6
    mov ecx, dword ptr [eax + 0x5e56aa]          # 004043fc
    imul ecx, ecx, 0x36ee80                      # 00404402
    mov edx, dword ptr [0x5c3a63]                # 00404408
    imul edx, edx, 0x106                         # 0040440e
    mov eax, dword ptr [edx + 0x5e56a6]          # 00404414
    imul eax, eax, 0xea60                        # 0040441a
    {load} add ecx, eax                          # 00404420
    mov edx, dword ptr [0x5c3a63]                # 00404422
    imul edx, edx, 0x106                         # 00404428
    mov eax, dword ptr [edx + 0x5e56a2]          # 0040442e
    imul eax, eax, 0x3e8                         # 00404434
    {load} add ecx, eax                          # 0040443a
    mov edx, dword ptr [0x5c3a63]                # 0040443c
    imul edx, edx, 0x106                         # 00404442
    mov dword ptr [edx + 0x5e569e], ecx          # 00404448
    mov ecx, dword ptr [ebp - local_18]          # 0040444e
    call FUN_004033db                            # 00404451
    {load} mov esp, ebp                          # 00404456
    pop ebp                                      # 00404458
    ret                                          # 00404459

