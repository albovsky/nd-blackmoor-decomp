# FUN_0040ae67
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040ae67
# extent:       0x0040ae67-0x0040aeb9 (82 code bytes)
# span:         0x0040ae67-0x0040aeb9 (code 82, tables 0, padding 0)
# sha256:       2243a7fd2d38454f13da0cca97811000bccc34e55dbae6ac0b8d8b0dcd5227db
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040ae67
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

.org 0x0040ae67 - 0x401000
.globl FUN_0040ae67
FUN_0040ae67:
    # block 0x0040ae67: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040aeab (forward)
    push ebp                                     # 0040ae67
    {load} mov ebp, esp                          # 0040ae68
    sub esp, 0x18                                # 0040ae6a
    push esi                                     # 0040ae6d
    push edi                                     # 0040ae6e
    mov dword ptr [ebp - local_18], ecx          # 0040ae6f
    push 0x13                                    # 0040ae72
    lea eax, [ebp - local_14]                    # 0040ae74
    push eax                                     # 0040ae77
    mov ecx, dword ptr [ebp - local_18]          # 0040ae78
    add ecx, 0x74c                               # 0040ae7b
    call FUN_0051d5b2                            # 0040ae81
    mov edi, 0x53ecc4                            # 0040ae86
    lea esi, [ebp - local_14]                    # 0040ae8b
    mov ecx, 0x4                                 # 0040ae8e
    {load} xor edx, edx                          # 0040ae93
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040ae95
    je.d8 L_0040aeab                             # 0040ae97
    # block 0x0040ae99: entered by fall-through of je at 0x0040ae97, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040aeab
    lea eax, [ebp - local_14]                    # 0040ae99
    push eax                                     # 0040ae9c
    call FUN_0050cb1b                            # 0040ae9d
    add esp, 0x4                                 # 0040aea2
    mov word ptr [0x5ec30c], ax                  # 0040aea5
L_0040aeab:
    # block 0x0040aeab: entered by je at 0x0040ae97, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040aeab
    call FUN_004090ab                            # 0040aeae
    pop edi                                      # 0040aeb3
    pop esi                                      # 0040aeb4
    {load} mov esp, ebp                          # 0040aeb5
    pop ebp                                      # 0040aeb7
    ret                                          # 0040aeb8

