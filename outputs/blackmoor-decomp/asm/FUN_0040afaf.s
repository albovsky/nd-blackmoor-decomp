# FUN_0040afaf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040afaf
# extent:       0x0040afaf-0x0040b001 (82 code bytes)
# span:         0x0040afaf-0x0040b001 (code 82, tables 0, padding 0)
# sha256:       04c6247bebbe4acf535ea18c89c39b4147dc3eec6e3542e7a2a1e647e9bf7308
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040afaf
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050ccec, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40afaf_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
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

.org 0x0040afaf - 0x401000
.globl FUN_0040afaf
FUN_0040afaf:
    # block 0x0040afaf: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040aff3 (forward)
    push ebp                                     # 0040afaf
    {load} mov ebp, esp                          # 0040afb0
    sub esp, 0x18                                # 0040afb2
    push esi                                     # 0040afb5
    push edi                                     # 0040afb6
    mov dword ptr [ebp - local_18], ecx          # 0040afb7
    push 0x13                                    # 0040afba
    lea eax, [ebp - local_14]                    # 0040afbc
    push eax                                     # 0040afbf
    mov ecx, dword ptr [ebp - local_18]          # 0040afc0
    add ecx, 0x84c                               # 0040afc3
    call FUN_0051d5b2                            # 0040afc9
    mov edi, 0x53ecd4                            # 0040afce
    lea esi, [ebp - local_14]                    # 0040afd3
    mov ecx, 0x4                                 # 0040afd6
    {load} xor edx, edx                          # 0040afdb
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040afdd
    je.d8 L_0040aff3                             # 0040afdf
    # block 0x0040afe1: entered by fall-through of je at 0x0040afdf, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040aff3
    lea eax, [ebp - local_14]                    # 0040afe1
    push eax                                     # 0040afe4
    call FUN_0050ccec                            # 0040afe5
    add esp, 0x4                                 # 0040afea
    fstp dword ptr [0x5ec316]                    # 0040afed
L_0040aff3:
    # block 0x0040aff3: entered by je at 0x0040afdf, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040aff3
    call FUN_004090ab                            # 0040aff6
    pop edi                                      # 0040affb
    pop esi                                      # 0040affc
    {load} mov esp, ebp                          # 0040affd
    pop ebp                                      # 0040afff
    ret                                          # 0040b000

