# FUN_0040af5d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040af5d
# extent:       0x0040af5d-0x0040afaf (82 code bytes)
# span:         0x0040af5d-0x0040afaf (code 82, tables 0, padding 0)
# sha256:       0ed5425cc472025e8d7642a9dd3a374a727d7db9f921411a88b4f02904d6ccde
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040af5d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050ccec, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40af5d_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
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

.org 0x0040af5d - 0x401000
.globl FUN_0040af5d
FUN_0040af5d:
    # block 0x0040af5d: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040afa1 (forward)
    push ebp                                     # 0040af5d
    {load} mov ebp, esp                          # 0040af5e
    sub esp, 0x18                                # 0040af60
    push esi                                     # 0040af63
    push edi                                     # 0040af64
    mov dword ptr [ebp - local_18], ecx          # 0040af65
    push 0x13                                    # 0040af68
    lea eax, [ebp - local_14]                    # 0040af6a
    push eax                                     # 0040af6d
    mov ecx, dword ptr [ebp - local_18]          # 0040af6e
    add ecx, 0x80c                               # 0040af71
    call FUN_0051d5b2                            # 0040af77
    mov edi, 0x53ecd0                            # 0040af7c
    lea esi, [ebp - local_14]                    # 0040af81
    mov ecx, 0x4                                 # 0040af84
    {load} xor edx, edx                          # 0040af89
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040af8b
    je.d8 L_0040afa1                             # 0040af8d
    # block 0x0040af8f: entered by fall-through of je at 0x0040af8d, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040afa1
    lea eax, [ebp - local_14]                    # 0040af8f
    push eax                                     # 0040af92
    call FUN_0050ccec                            # 0040af93
    add esp, 0x4                                 # 0040af98
    fstp dword ptr [0x5ec312]                    # 0040af9b
L_0040afa1:
    # block 0x0040afa1: entered by je at 0x0040af8d, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040afa1
    call FUN_004090ab                            # 0040afa4
    pop edi                                      # 0040afa9
    pop esi                                      # 0040afaa
    {load} mov esp, ebp                          # 0040afab
    pop ebp                                      # 0040afad
    ret                                          # 0040afae

