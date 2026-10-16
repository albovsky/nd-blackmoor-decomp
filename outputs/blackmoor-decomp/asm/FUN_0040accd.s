# FUN_0040accd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040accd
# extent:       0x0040accd-0x0040ad1f (82 code bytes)
# span:         0x0040accd-0x0040ad1f (code 82, tables 0, padding 0)
# sha256:       ed5a6050b3b2df97f47ede43e4ce28bbef778700f7d3aee606df6d7cd910901c
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040accd
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004090ab, .text + (0x004090ab - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x0040accd - 0x401000
.globl FUN_0040accd
FUN_0040accd:
    # block 0x0040accd: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040ad11 (forward)
    push ebp                                     # 0040accd
    {load} mov ebp, esp                          # 0040acce
    sub esp, 0x18                                # 0040acd0
    push esi                                     # 0040acd3
    push edi                                     # 0040acd4
    mov dword ptr [ebp - local_18], ecx          # 0040acd5
    push 0x13                                    # 0040acd8
    lea eax, [ebp - local_14]                    # 0040acda
    push eax                                     # 0040acdd
    mov ecx, dword ptr [ebp - local_18]          # 0040acde
    add ecx, 0x60c                               # 0040ace1
    call FUN_0051d5b2                            # 0040ace7
    mov edi, 0x53ecb0                            # 0040acec
    lea esi, [ebp - local_14]                    # 0040acf1
    mov ecx, 0x4                                 # 0040acf4
    {load} xor edx, edx                          # 0040acf9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040acfb
    je.d8 L_0040ad11                             # 0040acfd
    # block 0x0040acff: entered by fall-through of je at 0x0040acfd, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040ad11
    lea eax, [ebp - local_14]                    # 0040acff
    push eax                                     # 0040ad02
    call FUN_0050cb1b                            # 0040ad03
    add esp, 0x4                                 # 0040ad08
    mov word ptr [0x5ec302], ax                  # 0040ad0b
L_0040ad11:
    # block 0x0040ad11: entered by je at 0x0040acfd, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040ad11
    call FUN_004090ab                            # 0040ad14
    pop edi                                      # 0040ad19
    pop esi                                      # 0040ad1a
    {load} mov esp, ebp                          # 0040ad1b
    pop ebp                                      # 0040ad1d
    ret                                          # 0040ad1e

