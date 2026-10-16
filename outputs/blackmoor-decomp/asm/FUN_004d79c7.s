# FUN_004d79c7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d79c7
# extent:       0x004d79c7-0x004d7a15 (78 code bytes)
# span:         0x004d79c7-0x004d7a15 (code 78, tables 0, padding 0)
# sha256:       c61082b11946c6c1ffcb691f1720e0e65d8e17b81145807abc628ce1affc1806
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d79c7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2b4; [edx + n] field_2b6
# callees:      calls FUN_004c92c5, FUN_0043dbd5, FUN_004dad60
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2b4, 0x2b4  # offset +0x2b4
.equ field_2b6, 0x2b6  # offset +0x2b6

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)

.org 0x004d79c7 - 0x401000
.globl FUN_004d79c7
FUN_004d79c7:
    # block 0x004d79c7: entry, 21 instruction(s), calls FUN_004c92c5, FUN_0043dbd5, FUN_004dad60, ends with ret
    push ebp                                     # 004d79c7
    {load} mov ebp, esp                          # 004d79c8
    push ecx                                     # 004d79ca
    mov dword ptr [ebp - local_4], ecx           # 004d79cb
    mov dword ptr [0x5d2ecb], 0x0                # 004d79ce
    mov eax, dword ptr [ebp - local_4]           # 004d79d8
    mov cx, word ptr [eax + field_2b4]           # 004d79db
    push ecx                                     # 004d79e2
    mov ecx, 0x5cf659                            # 004d79e3
    call FUN_004c92c5                            # 004d79e8
    mov edx, dword ptr [ebp - local_4]           # 004d79ed
    mov ax, word ptr [edx + field_2b6]           # 004d79f0
    push eax                                     # 004d79f7
    mov ecx, 0x5cf659                            # 004d79f8
    call FUN_004c92c5                            # 004d79fd
    call FUN_0043dbd5                            # 004d7a02
    mov ecx, 0x5830a6                            # 004d7a07
    call FUN_004dad60                            # 004d7a0c
    {load} mov esp, ebp                          # 004d7a11
    pop ebp                                      # 004d7a13
    ret                                          # 004d7a14

