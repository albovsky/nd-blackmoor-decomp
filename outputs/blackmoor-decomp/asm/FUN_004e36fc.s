# FUN_004e36fc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e36fc
# extent:       0x004e36fc-0x004e3772 (118 code bytes)
# span:         0x004e36fc-0x004e3772 (code 118, tables 0, padding 0)
# sha256:       7443377cd45ff8bebd04bda45e3bf1e5b2fc3cc13c245f5d2cd4cc33ee641ee9
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e36fc
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e2940
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)

.org 0x004e36fc - 0x401000
.globl FUN_004e36fc
FUN_004e36fc:
    # block 0x004e36fc: entry, 6 instruction(s), ends with je to 0x004e372e (forward)
    push ebp                                     # 004e36fc
    {load} mov ebp, esp                          # 004e36fd
    push ecx                                     # 004e36ff
    mov dword ptr [ebp - local_4], ecx           # 004e3700
    cmp dword ptr [0x5a1e58], 0x0                # 004e3703
    je.d8 L_004e372e                             # 004e370a
    # block 0x004e370c: entered by fall-through of je at 0x004e370a, 9 instruction(s), calls FUN_004e2940, ends with forward jump to 0x004e376e
    push 0x0                                     # 004e370c
    mov ecx, dword ptr [ebp - local_4]           # 004e370e
    add ecx, 0x3592                              # 004e3711
    call FUN_004e2940                            # 004e3717
    push 0x0                                     # 004e371c
    mov ecx, dword ptr [ebp - local_4]           # 004e371e
    add ecx, 0x3a3f                              # 004e3721
    call FUN_004e2940                            # 004e3727
    jmp.d8 L_004e376e                            # 004e372c
L_004e372e:
    # block 0x004e372e: entered by je at 0x004e370a, 16 instruction(s), calls FUN_004e2940, falls into the block at 0x004e376e
    push 0x0                                     # 004e372e
    mov ecx, dword ptr [ebp - local_4]           # 004e3730
    add ecx, 0x3592                              # 004e3733
    call FUN_004e2940                            # 004e3739
    push 0x0                                     # 004e373e
    mov ecx, dword ptr [ebp - local_4]           # 004e3740
    add ecx, 0x3a3f                              # 004e3743
    call FUN_004e2940                            # 004e3749
    push 0x0                                     # 004e374e
    mov ecx, dword ptr [ebp - local_4]           # 004e3750
    add ecx, 0x3bce                              # 004e3753
    call FUN_004e2940                            # 004e3759
    push 0x0                                     # 004e375e
    mov ecx, dword ptr [ebp - local_4]           # 004e3760
    add ecx, 0x3274                              # 004e3763
    call FUN_004e2940                            # 004e3769
L_004e376e:
    # block 0x004e376e: entered by jmp at 0x004e372c, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e376e
    pop ebp                                      # 004e3770
    ret                                          # 004e3771

