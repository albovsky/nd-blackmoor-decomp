# FUN_0040492f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040492f
# extent:       0x0040492f-0x0040496a (59 code bytes)
# span:         0x0040492f-0x0040496a (code 59, tables 0, padding 0)
# sha256:       5ba1964de143d1d911639f062681149497630421e8c4e87758a033e05e5f12cf
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040492f
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

.org 0x0040492f - 0x401000
.globl FUN_0040492f
FUN_0040492f:
    # block 0x0040492f: entry, 20 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 0040492f
    {load} mov ebp, esp                          # 00404930
    sub esp, 0x18                                # 00404932
    mov dword ptr [ebp - local_18], ecx          # 00404935
    push 0x13                                    # 00404938
    lea eax, [ebp - local_14]                    # 0040493a
    push eax                                     # 0040493d
    mov ecx, dword ptr [ebp - local_18]          # 0040493e
    add ecx, 0x38c                               # 00404941
    call FUN_0051d5b2                            # 00404947
    lea ecx, [ebp - local_14]                    # 0040494c
    push ecx                                     # 0040494f
    call FUN_0050cb1b                            # 00404950
    add esp, 0x4                                 # 00404955
    mov word ptr [0x5ec33a], ax                  # 00404958
    mov ecx, dword ptr [ebp - local_18]          # 0040495e
    call FUN_004033db                            # 00404961
    {load} mov esp, ebp                          # 00404966
    pop ebp                                      # 00404968
    ret                                          # 00404969

