# FUN_0040abd7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040abd7
# extent:       0x0040abd7-0x0040ac29 (82 code bytes)
# span:         0x0040abd7-0x0040ac29 (code 82, tables 0, padding 0)
# sha256:       81cc91c9a62078da7bd873dfbdf26eb821238b68c31ba828827b3333a86d1294
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040abd7
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

.org 0x0040abd7 - 0x401000
.globl FUN_0040abd7
FUN_0040abd7:
    # block 0x0040abd7: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040ac1b (forward)
    push ebp                                     # 0040abd7
    {load} mov ebp, esp                          # 0040abd8
    sub esp, 0x18                                # 0040abda
    push esi                                     # 0040abdd
    push edi                                     # 0040abde
    mov dword ptr [ebp - local_18], ecx          # 0040abdf
    push 0x13                                    # 0040abe2
    lea eax, [ebp - local_14]                    # 0040abe4
    push eax                                     # 0040abe7
    mov ecx, dword ptr [ebp - local_18]          # 0040abe8
    add ecx, 0x54c                               # 0040abeb
    call FUN_0051d5b2                            # 0040abf1
    mov edi, 0x53eca4                            # 0040abf6
    lea esi, [ebp - local_14]                    # 0040abfb
    mov ecx, 0x4                                 # 0040abfe
    {load} xor edx, edx                          # 0040ac03
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040ac05
    je.d8 L_0040ac1b                             # 0040ac07
    # block 0x0040ac09: entered by fall-through of je at 0x0040ac07, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040ac1b
    lea eax, [ebp - local_14]                    # 0040ac09
    push eax                                     # 0040ac0c
    call FUN_0050cb1b                            # 0040ac0d
    add esp, 0x4                                 # 0040ac12
    mov word ptr [0x5ec2fc], ax                  # 0040ac15
L_0040ac1b:
    # block 0x0040ac1b: entered by je at 0x0040ac07, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040ac1b
    call FUN_004090ab                            # 0040ac1e
    pop edi                                      # 0040ac23
    pop esi                                      # 0040ac24
    {load} mov esp, ebp                          # 0040ac25
    pop ebp                                      # 0040ac27
    ret                                          # 0040ac28

