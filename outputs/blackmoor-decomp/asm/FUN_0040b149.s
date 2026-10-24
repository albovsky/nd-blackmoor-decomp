# FUN_0040b149
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b149
# extent:       0x0040b149-0x0040b19b (82 code bytes)
# span:         0x0040b149-0x0040b19b (code 82, tables 0, padding 0)
# sha256:       8242c1671a6fc2ba551c7ce0178906ada6ae5a3e9c9bcca2792c61b3a63a68dd
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040b149
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050ccec, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40b149_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004090ab, .text + (0x004090ab - 0x401000)
.set FUN_0050ccec, .text + (0x0050ccec - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x0040b149 - 0x401000
.globl FUN_0040b149
FUN_0040b149:
    # block 0x0040b149: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040b18d (forward)
    push ebp                                     # 0040b149
    {load} mov ebp, esp                          # 0040b14a
    sub esp, 0x18                                # 0040b14c
    push esi                                     # 0040b14f
    push edi                                     # 0040b150
    mov dword ptr [ebp - local_18], ecx          # 0040b151
    push 0x13                                    # 0040b154
    lea eax, [ebp - local_14]                    # 0040b156
    push eax                                     # 0040b159
    mov ecx, dword ptr [ebp - local_18]          # 0040b15a
    add ecx, 0x98c                               # 0040b15d
    call FUN_0051d5b2                            # 0040b163
    mov edi, 0x53ece8                            # 0040b168
    lea esi, [ebp - local_14]                    # 0040b16d
    mov ecx, 0x4                                 # 0040b170
    {load} xor edx, edx                          # 0040b175
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040b177
    je.d8 L_0040b18d                             # 0040b179
    # block 0x0040b17b: entered by fall-through of je at 0x0040b179, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040b18d
    lea eax, [ebp - local_14]                    # 0040b17b
    push eax                                     # 0040b17e
    call FUN_0050ccec                            # 0040b17f
    add esp, 0x4                                 # 0040b184
    fstp dword ptr [0x5ec32a]                    # 0040b187
L_0040b18d:
    # block 0x0040b18d: entered by je at 0x0040b179, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040b18d
    call FUN_004090ab                            # 0040b190
    pop edi                                      # 0040b195
    pop esi                                      # 0040b196
    {load} mov esp, ebp                          # 0040b197
    pop ebp                                      # 0040b199
    ret                                          # 0040b19a

