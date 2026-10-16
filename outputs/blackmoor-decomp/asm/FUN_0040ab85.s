# FUN_0040ab85
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040ab85
# extent:       0x0040ab85-0x0040abd7 (82 code bytes)
# span:         0x0040ab85-0x0040abd7 (code 82, tables 0, padding 0)
# sha256:       eb81ed53e03273f373d46f956d4c96cadf5800772e94ff8b97c45db0ec975ad8
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040ab85
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

.org 0x0040ab85 - 0x401000
.globl FUN_0040ab85
FUN_0040ab85:
    # block 0x0040ab85: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040abc9 (forward)
    push ebp                                     # 0040ab85
    {load} mov ebp, esp                          # 0040ab86
    sub esp, 0x18                                # 0040ab88
    push esi                                     # 0040ab8b
    push edi                                     # 0040ab8c
    mov dword ptr [ebp - local_18], ecx          # 0040ab8d
    push 0x13                                    # 0040ab90
    lea eax, [ebp - local_14]                    # 0040ab92
    push eax                                     # 0040ab95
    mov ecx, dword ptr [ebp - local_18]          # 0040ab96
    add ecx, 0x50c                               # 0040ab99
    call FUN_0051d5b2                            # 0040ab9f
    mov edi, 0x53eca0                            # 0040aba4
    lea esi, [ebp - local_14]                    # 0040aba9
    mov ecx, 0x4                                 # 0040abac
    {load} xor edx, edx                          # 0040abb1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040abb3
    je.d8 L_0040abc9                             # 0040abb5
    # block 0x0040abb7: entered by fall-through of je at 0x0040abb5, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040abc9
    lea eax, [ebp - local_14]                    # 0040abb7
    push eax                                     # 0040abba
    call FUN_0050cb1b                            # 0040abbb
    add esp, 0x4                                 # 0040abc0
    mov word ptr [0x5ec2fa], ax                  # 0040abc3
L_0040abc9:
    # block 0x0040abc9: entered by je at 0x0040abb5, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040abc9
    call FUN_004090ab                            # 0040abcc
    pop edi                                      # 0040abd1
    pop esi                                      # 0040abd2
    {load} mov esp, ebp                          # 0040abd3
    pop ebp                                      # 0040abd5
    ret                                          # 0040abd6

