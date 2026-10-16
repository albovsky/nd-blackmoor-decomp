# FUN_0040b053
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b053
# extent:       0x0040b053-0x0040b0a5 (82 code bytes)
# span:         0x0040b053-0x0040b0a5 (code 82, tables 0, padding 0)
# sha256:       4bcf69dbc6273dd0e58e8af2d562597bd7f30092f652349537410abfe64bd8fe
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040b053
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

.org 0x0040b053 - 0x401000
.globl FUN_0040b053
FUN_0040b053:
    # block 0x0040b053: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040b097 (forward)
    push ebp                                     # 0040b053
    {load} mov ebp, esp                          # 0040b054
    sub esp, 0x18                                # 0040b056
    push esi                                     # 0040b059
    push edi                                     # 0040b05a
    mov dword ptr [ebp - local_18], ecx          # 0040b05b
    push 0x13                                    # 0040b05e
    lea eax, [ebp - local_14]                    # 0040b060
    push eax                                     # 0040b063
    mov ecx, dword ptr [ebp - local_18]          # 0040b064
    add ecx, 0x8cc                               # 0040b067
    call FUN_0051d5b2                            # 0040b06d
    mov edi, 0x53ecdc                            # 0040b072
    lea esi, [ebp - local_14]                    # 0040b077
    mov ecx, 0x4                                 # 0040b07a
    {load} xor edx, edx                          # 0040b07f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040b081
    je.d8 L_0040b097                             # 0040b083
    # block 0x0040b085: entered by fall-through of je at 0x0040b083, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040b097
    lea eax, [ebp - local_14]                    # 0040b085
    push eax                                     # 0040b088
    call FUN_0050ccec                            # 0040b089
    add esp, 0x4                                 # 0040b08e
    fstp dword ptr [0x5ec31e]                    # 0040b091
L_0040b097:
    # block 0x0040b097: entered by je at 0x0040b083, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040b097
    call FUN_004090ab                            # 0040b09a
    pop edi                                      # 0040b09f
    pop esi                                      # 0040b0a0
    {load} mov esp, ebp                          # 0040b0a1
    pop ebp                                      # 0040b0a3
    ret                                          # 0040b0a4

