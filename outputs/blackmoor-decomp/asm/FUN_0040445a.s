# FUN_0040445a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040445a
# extent:       0x0040445a-0x004044fe (164 code bytes)
# span:         0x0040445a-0x004044fe (code 164, tables 0, padding 0)
# sha256:       e2df9cf42517aabe58c4f11c0789c78d8952feaffa55fa85bd3f37defe32d759
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040445a
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

.org 0x0040445a - 0x401000
.globl FUN_0040445a
FUN_0040445a:
    # block 0x0040445a: entry, 39 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 0040445a
    {load} mov ebp, esp                          # 0040445b
    sub esp, 0x18                                # 0040445d
    mov dword ptr [ebp - local_18], ecx          # 00404460
    push 0x13                                    # 00404463
    lea eax, [ebp - local_14]                    # 00404465
    push eax                                     # 00404468
    mov ecx, dword ptr [ebp - local_18]          # 00404469
    add ecx, 0x20c                               # 0040446c
    call FUN_0051d5b2                            # 00404472
    lea ecx, [ebp - local_14]                    # 00404477
    push ecx                                     # 0040447a
    call FUN_0050cb1b                            # 0040447b
    add esp, 0x4                                 # 00404480
    mov edx, dword ptr [0x5c3a63]                # 00404483
    imul edx, edx, 0x106                         # 00404489
    mov dword ptr [edx + 0x5e56a6], eax          # 0040448f
    mov eax, dword ptr [0x5c3a63]                # 00404495
    imul eax, eax, 0x106                         # 0040449a
    mov ecx, dword ptr [eax + 0x5e56aa]          # 004044a0
    imul ecx, ecx, 0x36ee80                      # 004044a6
    mov edx, dword ptr [0x5c3a63]                # 004044ac
    imul edx, edx, 0x106                         # 004044b2
    mov eax, dword ptr [edx + 0x5e56a6]          # 004044b8
    imul eax, eax, 0xea60                        # 004044be
    {load} add ecx, eax                          # 004044c4
    mov edx, dword ptr [0x5c3a63]                # 004044c6
    imul edx, edx, 0x106                         # 004044cc
    mov eax, dword ptr [edx + 0x5e56a2]          # 004044d2
    imul eax, eax, 0x3e8                         # 004044d8
    {load} add ecx, eax                          # 004044de
    mov edx, dword ptr [0x5c3a63]                # 004044e0
    imul edx, edx, 0x106                         # 004044e6
    mov dword ptr [edx + 0x5e569e], ecx          # 004044ec
    mov ecx, dword ptr [ebp - local_18]          # 004044f2
    call FUN_004033db                            # 004044f5
    {load} mov esp, ebp                          # 004044fa
    pop ebp                                      # 004044fc
    ret                                          # 004044fd

