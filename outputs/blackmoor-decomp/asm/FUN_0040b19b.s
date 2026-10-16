# FUN_0040b19b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b19b
# extent:       0x0040b19b-0x0040b1ed (82 code bytes)
# span:         0x0040b19b-0x0040b1ed (code 82, tables 0, padding 0)
# sha256:       3c1fb9c064d63443e4cb466afcfb065311bb9c00243cee39655ac3e7d7a47a99
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040b19b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050ccec, FUN_004090ab
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
.set FUN_0050ccec, .text + (0x0050ccec - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x0040b19b - 0x401000
.globl FUN_0040b19b
FUN_0040b19b:
    # block 0x0040b19b: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040b1df (forward)
    push ebp                                     # 0040b19b
    {load} mov ebp, esp                          # 0040b19c
    sub esp, 0x18                                # 0040b19e
    push esi                                     # 0040b1a1
    push edi                                     # 0040b1a2
    mov dword ptr [ebp - local_18], ecx          # 0040b1a3
    push 0x13                                    # 0040b1a6
    lea eax, [ebp - local_14]                    # 0040b1a8
    push eax                                     # 0040b1ab
    mov ecx, dword ptr [ebp - local_18]          # 0040b1ac
    add ecx, 0x9cc                               # 0040b1af
    call FUN_0051d5b2                            # 0040b1b5
    mov edi, 0x53ecec                            # 0040b1ba
    lea esi, [ebp - local_14]                    # 0040b1bf
    mov ecx, 0x4                                 # 0040b1c2
    {load} xor edx, edx                          # 0040b1c7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040b1c9
    je.d8 L_0040b1df                             # 0040b1cb
    # block 0x0040b1cd: entered by fall-through of je at 0x0040b1cb, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040b1df
    lea eax, [ebp - local_14]                    # 0040b1cd
    push eax                                     # 0040b1d0
    call FUN_0050ccec                            # 0040b1d1
    add esp, 0x4                                 # 0040b1d6
    fstp dword ptr [0x5ec32e]                    # 0040b1d9
L_0040b1df:
    # block 0x0040b1df: entered by je at 0x0040b1cb, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040b1df
    call FUN_004090ab                            # 0040b1e2
    pop edi                                      # 0040b1e7
    pop esi                                      # 0040b1e8
    {load} mov esp, ebp                          # 0040b1e9
    pop ebp                                      # 0040b1eb
    ret                                          # 0040b1ec

