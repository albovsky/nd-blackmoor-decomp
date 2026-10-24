# FUN_0040b0a5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b0a5
# extent:       0x0040b0a5-0x0040b0f7 (82 code bytes)
# span:         0x0040b0a5-0x0040b0f7 (code 82, tables 0, padding 0)
# sha256:       f63499cf8f239e7085aaa500ee7bcd93003685357ea42cef6fd74ba38487be9f
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040b0a5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050ccec, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40b0a5_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
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

.org 0x0040b0a5 - 0x401000
.globl FUN_0040b0a5
FUN_0040b0a5:
    # block 0x0040b0a5: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040b0e9 (forward)
    push ebp                                     # 0040b0a5
    {load} mov ebp, esp                          # 0040b0a6
    sub esp, 0x18                                # 0040b0a8
    push esi                                     # 0040b0ab
    push edi                                     # 0040b0ac
    mov dword ptr [ebp - local_18], ecx          # 0040b0ad
    push 0x13                                    # 0040b0b0
    lea eax, [ebp - local_14]                    # 0040b0b2
    push eax                                     # 0040b0b5
    mov ecx, dword ptr [ebp - local_18]          # 0040b0b6
    add ecx, 0x90c                               # 0040b0b9
    call FUN_0051d5b2                            # 0040b0bf
    mov edi, 0x53ece0                            # 0040b0c4
    lea esi, [ebp - local_14]                    # 0040b0c9
    mov ecx, 0x4                                 # 0040b0cc
    {load} xor edx, edx                          # 0040b0d1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040b0d3
    je.d8 L_0040b0e9                             # 0040b0d5
    # block 0x0040b0d7: entered by fall-through of je at 0x0040b0d5, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040b0e9
    lea eax, [ebp - local_14]                    # 0040b0d7
    push eax                                     # 0040b0da
    call FUN_0050ccec                            # 0040b0db
    add esp, 0x4                                 # 0040b0e0
    fstp dword ptr [0x5ec322]                    # 0040b0e3
L_0040b0e9:
    # block 0x0040b0e9: entered by je at 0x0040b0d5, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040b0e9
    call FUN_004090ab                            # 0040b0ec
    pop edi                                      # 0040b0f1
    pop esi                                      # 0040b0f2
    {load} mov esp, ebp                          # 0040b0f3
    pop ebp                                      # 0040b0f5
    ret                                          # 0040b0f6

