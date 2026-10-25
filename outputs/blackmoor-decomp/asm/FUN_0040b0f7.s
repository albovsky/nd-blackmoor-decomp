# FUN_0040b0f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b0f7
# extent:       0x0040b0f7-0x0040b149 (82 code bytes)
# span:         0x0040b0f7-0x0040b149 (code 82, tables 0, padding 0)
# sha256:       910bc86620734e9442c79c83960acce386f3c082fdaa1af5d55fe90dbec4a2aa
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40b0f7_lifted
# naming:       native port src/original_methods_fl40.c:m40b0f7_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 3 seeds; oracle 30/30 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050ccec, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40b0f7_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x0040b0f7 - 0x401000
.globl FUN_0040b0f7
FUN_0040b0f7:
    # block 0x0040b0f7: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040b13b (forward)
    push ebp                                     # 0040b0f7
    {load} mov ebp, esp                          # 0040b0f8
    sub esp, 0x18                                # 0040b0fa
    push esi                                     # 0040b0fd
    push edi                                     # 0040b0fe
    mov dword ptr [ebp - local_18], ecx          # 0040b0ff
    push 0x13                                    # 0040b102
    lea eax, [ebp - local_14]                    # 0040b104
    push eax                                     # 0040b107
    mov ecx, dword ptr [ebp - local_18]          # 0040b108
    add ecx, 0x94c                               # 0040b10b
    call FUN_0051d5b2                            # 0040b111
    mov edi, 0x53ece4                            # 0040b116
    lea esi, [ebp - local_14]                    # 0040b11b
    mov ecx, 0x4                                 # 0040b11e
    {load} xor edx, edx                          # 0040b123
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040b125
    je.d8 L_0040b13b                             # 0040b127
    # block 0x0040b129: entered by fall-through of je at 0x0040b127, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040b13b
    lea eax, [ebp - local_14]                    # 0040b129
    push eax                                     # 0040b12c
    call FUN_0050ccec                            # 0040b12d
    add esp, 0x4                                 # 0040b132
    fstp dword ptr [0x5ec326]                    # 0040b135
L_0040b13b:
    # block 0x0040b13b: entered by je at 0x0040b127, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040b13b
    call FUN_004090ab                            # 0040b13e
    pop edi                                      # 0040b143
    pop esi                                      # 0040b144
    {load} mov esp, ebp                          # 0040b145
    pop ebp                                      # 0040b147
    ret                                          # 0040b148

