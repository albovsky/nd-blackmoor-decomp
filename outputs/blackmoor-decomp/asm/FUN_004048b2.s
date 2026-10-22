# FUN_004048b2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004048b2
# extent:       0x004048b2-0x004048da (40 code bytes)
# span:         0x004048b2-0x004048da (code 40, tables 0, padding 0)
# sha256:       939abd067e7073f889f0849d6582380121f40f936f6ccf16a73ae447abe96d01
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004048b2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4048b2_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)

.org 0x004048b2 - 0x401000
.globl FUN_004048b2
FUN_004048b2:
    # block 0x004048b2: entry, 12 instruction(s), calls FUN_004033db, ends with ret
    push ebp                                     # 004048b2
    {load} mov ebp, esp                          # 004048b3
    push ecx                                     # 004048b5
    mov dword ptr [ebp - local_4], ecx           # 004048b6
    mov eax, dword ptr [0x5c3a63]                # 004048b9
    imul eax, eax, 0x106                         # 004048be
    mov dword ptr [eax + 0x5e569a], 0x6          # 004048c4
    mov ecx, dword ptr [ebp - local_4]           # 004048ce
    call FUN_004033db                            # 004048d1
    {load} mov esp, ebp                          # 004048d6
    pop ebp                                      # 004048d8
    ret                                          # 004048d9

