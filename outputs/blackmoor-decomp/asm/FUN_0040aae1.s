# FUN_0040aae1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040aae1
# extent:       0x0040aae1-0x0040ab33 (82 code bytes)
# span:         0x0040aae1-0x0040ab33 (code 82, tables 0, padding 0)
# sha256:       0c53491f89a570a2de4236ec900a906810ebfa707a08b5a3f8a8a0393a865e52
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040aae1
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

.org 0x0040aae1 - 0x401000
.globl FUN_0040aae1
FUN_0040aae1:
    # block 0x0040aae1: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040ab25 (forward)
    push ebp                                     # 0040aae1
    {load} mov ebp, esp                          # 0040aae2
    sub esp, 0x18                                # 0040aae4
    push esi                                     # 0040aae7
    push edi                                     # 0040aae8
    mov dword ptr [ebp - local_18], ecx          # 0040aae9
    push 0x13                                    # 0040aaec
    lea eax, [ebp - local_14]                    # 0040aaee
    push eax                                     # 0040aaf1
    mov ecx, dword ptr [ebp - local_18]          # 0040aaf2
    add ecx, 0x48c                               # 0040aaf5
    call FUN_0051d5b2                            # 0040aafb
    mov edi, 0x53ec98                            # 0040ab00
    lea esi, [ebp - local_14]                    # 0040ab05
    mov ecx, 0x4                                 # 0040ab08
    {load} xor edx, edx                          # 0040ab0d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040ab0f
    je.d8 L_0040ab25                             # 0040ab11
    # block 0x0040ab13: entered by fall-through of je at 0x0040ab11, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040ab25
    lea eax, [ebp - local_14]                    # 0040ab13
    push eax                                     # 0040ab16
    call FUN_0050cb1b                            # 0040ab17
    add esp, 0x4                                 # 0040ab1c
    mov word ptr [0x5ec2f6], ax                  # 0040ab1f
L_0040ab25:
    # block 0x0040ab25: entered by je at 0x0040ab11, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040ab25
    call FUN_004090ab                            # 0040ab28
    pop edi                                      # 0040ab2d
    pop esi                                      # 0040ab2e
    {load} mov esp, ebp                          # 0040ab2f
    pop ebp                                      # 0040ab31
    ret                                          # 0040ab32

