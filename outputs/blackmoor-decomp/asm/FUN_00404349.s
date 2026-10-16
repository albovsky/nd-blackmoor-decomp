# FUN_00404349
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404349
# extent:       0x00404349-0x00404384 (59 code bytes)
# span:         0x00404349-0x00404384 (code 59, tables 0, padding 0)
# sha256:       38a20db0b00f4c28467f768e83bcb78024a290ee00a3f8413105a021aaf53f6c
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00404349
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x00404349 - 0x401000
.globl FUN_00404349
FUN_00404349:
    # block 0x00404349: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 00404349
    {load} mov ebp, esp                          # 0040434a
    sub esp, 0x18                                # 0040434c
    mov dword ptr [ebp - local_18], ecx          # 0040434f
    push 0x13                                    # 00404352
    lea eax, [ebp - local_14]                    # 00404354
    push eax                                     # 00404357
    mov ecx, dword ptr [ebp - local_18]          # 00404358
    add ecx, 0x14c                               # 0040435b
    call FUN_0051d5b2                            # 00404361
    lea ecx, [ebp - local_14]                    # 00404366
    push ecx                                     # 00404369
    call FUN_0050cb1b                            # 0040436a
    add esp, 0x4                                 # 0040436f
    mov word ptr [0x5e5684], ax                  # 00404372
    mov ecx, dword ptr [ebp - local_18]          # 00404378
    call FUN_004033db                            # 0040437b
    {load} mov esp, ebp                          # 00404380
    pop ebp                                      # 00404382
    ret                                          # 00404383

