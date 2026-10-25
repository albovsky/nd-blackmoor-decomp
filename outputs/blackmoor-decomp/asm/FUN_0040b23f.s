# FUN_0040b23f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b23f
# extent:       0x0040b23f-0x0040b291 (82 code bytes)
# span:         0x0040b23f-0x0040b2a0 (code 82, tables 0, padding 15)
# sha256:       fb5568cafd6ca842efa5530f281a1926d803260561b9e8a340ee39515cccaf53
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40b23f_lifted
# naming:       native port src/original_methods_fl40.c:m40b23f_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 3 seeds; oracle 30/30 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050ccec, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40b23f_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040b23f - 0x401000
.globl FUN_0040b23f
FUN_0040b23f:
    # block 0x0040b23f: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040b283 (forward)
    push ebp                                     # 0040b23f
    {load} mov ebp, esp                          # 0040b240
    sub esp, 0x18                                # 0040b242
    push esi                                     # 0040b245
    push edi                                     # 0040b246
    mov dword ptr [ebp - local_18], ecx          # 0040b247
    push 0x13                                    # 0040b24a
    lea eax, [ebp - local_14]                    # 0040b24c
    push eax                                     # 0040b24f
    mov ecx, dword ptr [ebp - local_18]          # 0040b250
    add ecx, 0xa4c                               # 0040b253
    call FUN_0051d5b2                            # 0040b259
    mov edi, 0x53ecf4                            # 0040b25e
    lea esi, [ebp - local_14]                    # 0040b263
    mov ecx, 0x4                                 # 0040b266
    {load} xor edx, edx                          # 0040b26b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040b26d
    je.d8 L_0040b283                             # 0040b26f
    # block 0x0040b271: entered by fall-through of je at 0x0040b26f, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040b283
    lea eax, [ebp - local_14]                    # 0040b271
    push eax                                     # 0040b274
    call FUN_0050ccec                            # 0040b275
    add esp, 0x4                                 # 0040b27a
    fstp dword ptr [0x5ec336]                    # 0040b27d
L_0040b283:
    # block 0x0040b283: entered by je at 0x0040b26f, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040b283
    call FUN_004090ab                            # 0040b286
    pop edi                                      # 0040b28b
    pop esi                                      # 0040b28c
    {load} mov esp, ebp                          # 0040b28d
    pop ebp                                      # 0040b28f
    ret                                          # 0040b290

# --- data items (not part of the function) -------------------------
.org 0x0040b291 - 0x401000
PAD_0040b291:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

