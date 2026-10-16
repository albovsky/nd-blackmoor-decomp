# FUN_004048da
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004048da
# extent:       0x004048da-0x0040492f (85 code bytes)
# span:         0x004048da-0x0040492f (code 85, tables 0, padding 0)
# sha256:       10a0145792bd5e7d15ddd017c10fe0a31ffb97689be8ed54d477cc5684727cae
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004048da
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004033db
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)

.org 0x004048da - 0x401000
.globl FUN_004048da
FUN_004048da:
    # block 0x004048da: entry, 8 instruction(s), ends with je to 0x0040490d (forward)
    push ebp                                     # 004048da
    {load} mov ebp, esp                          # 004048db
    push ecx                                     # 004048dd
    mov dword ptr [ebp - local_4], ecx           # 004048de
    mov eax, dword ptr [0x5c3a63]                # 004048e1
    imul eax, eax, 0x106                         # 004048e6
    cmp dword ptr [eax + 0x5e56ae], 0x0          # 004048ec
    je.d8 L_0040490d                             # 004048f3
    # block 0x004048f5: entered by fall-through of je at 0x004048f3, 4 instruction(s), ends with forward jump to 0x00404923
    mov ecx, dword ptr [0x5c3a63]                # 004048f5
    imul ecx, ecx, 0x106                         # 004048fb
    mov dword ptr [ecx + 0x5e56ae], 0x0          # 00404901
    jmp.d8 L_00404923                            # 0040490b
L_0040490d:
    # block 0x0040490d: entered by je at 0x004048f3, 3 instruction(s), falls into the block at 0x00404923
    mov edx, dword ptr [0x5c3a63]                # 0040490d
    imul edx, edx, 0x106                         # 00404913
    mov dword ptr [edx + 0x5e56ae], 0x1          # 00404919
L_00404923:
    # block 0x00404923: entered by jmp at 0x0040490b, 5 instruction(s), calls FUN_004033db, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00404923
    call FUN_004033db                            # 00404926
    {load} mov esp, ebp                          # 0040492b
    pop ebp                                      # 0040492d
    ret                                          # 0040492e

