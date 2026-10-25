# FUN_0040b001
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b001
# extent:       0x0040b001-0x0040b053 (82 code bytes)
# span:         0x0040b001-0x0040b053 (code 82, tables 0, padding 0)
# sha256:       651f09395cf90e8283d79e31d52845331882e2c43893042e5e5d8692dcee7329
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040b001
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

.org 0x0040b001 - 0x401000
.globl FUN_0040b001
FUN_0040b001:
    # block 0x0040b001: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040b045 (forward)
    push ebp                                     # 0040b001
    {load} mov ebp, esp                          # 0040b002
    sub esp, 0x18                                # 0040b004
    push esi                                     # 0040b007
    push edi                                     # 0040b008
    mov dword ptr [ebp - local_18], ecx          # 0040b009
    push 0x13                                    # 0040b00c
    lea eax, [ebp - local_14]                    # 0040b00e
    push eax                                     # 0040b011
    mov ecx, dword ptr [ebp - local_18]          # 0040b012
    add ecx, 0x88c                               # 0040b015
    call FUN_0051d5b2                            # 0040b01b
    mov edi, 0x53ecd8                            # 0040b020
    lea esi, [ebp - local_14]                    # 0040b025
    mov ecx, 0x4                                 # 0040b028
    {load} xor edx, edx                          # 0040b02d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040b02f
    je.d8 L_0040b045                             # 0040b031
    # block 0x0040b033: entered by fall-through of je at 0x0040b031, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040b045
    lea eax, [ebp - local_14]                    # 0040b033
    push eax                                     # 0040b036
    call FUN_0050ccec                            # 0040b037
    add esp, 0x4                                 # 0040b03c
    fstp dword ptr [0x5ec31a]                    # 0040b03f
L_0040b045:
    # block 0x0040b045: entered by je at 0x0040b031, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040b045
    call FUN_004090ab                            # 0040b048
    pop edi                                      # 0040b04d
    pop esi                                      # 0040b04e
    {load} mov esp, ebp                          # 0040b04f
    pop ebp                                      # 0040b051
    ret                                          # 0040b052

