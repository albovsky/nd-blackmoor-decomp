# FUN_0040b1ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b1ed
# extent:       0x0040b1ed-0x0040b23f (82 code bytes)
# span:         0x0040b1ed-0x0040b23f (code 82, tables 0, padding 0)
# sha256:       b04efb7448ec73d0ec0f4d23a4dc4bca813c1c3e7cd75410e2dbfec4a01ef5b4
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40b1ed_lifted
# naming:       native port src/original_methods_fl40.c:m40b1ed_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 3 seeds; oracle 30/30 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050ccec, FUN_004090ab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40b1ed_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x0040b1ed - 0x401000
.globl FUN_0040b1ed
FUN_0040b1ed:
    # block 0x0040b1ed: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040b231 (forward)
    push ebp                                     # 0040b1ed
    {load} mov ebp, esp                          # 0040b1ee
    sub esp, 0x18                                # 0040b1f0
    push esi                                     # 0040b1f3
    push edi                                     # 0040b1f4
    mov dword ptr [ebp - local_18], ecx          # 0040b1f5
    push 0x13                                    # 0040b1f8
    lea eax, [ebp - local_14]                    # 0040b1fa
    push eax                                     # 0040b1fd
    mov ecx, dword ptr [ebp - local_18]          # 0040b1fe
    add ecx, 0xa0c                               # 0040b201
    call FUN_0051d5b2                            # 0040b207
    mov edi, 0x53ecf0                            # 0040b20c
    lea esi, [ebp - local_14]                    # 0040b211
    mov ecx, 0x4                                 # 0040b214
    {load} xor edx, edx                          # 0040b219
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040b21b
    je.d8 L_0040b231                             # 0040b21d
    # block 0x0040b21f: entered by fall-through of je at 0x0040b21d, 5 instruction(s), calls FUN_0050ccec, falls into the block at 0x0040b231
    lea eax, [ebp - local_14]                    # 0040b21f
    push eax                                     # 0040b222
    call FUN_0050ccec                            # 0040b223
    add esp, 0x4                                 # 0040b228
    fstp dword ptr [0x5ec332]                    # 0040b22b
L_0040b231:
    # block 0x0040b231: entered by je at 0x0040b21d, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040b231
    call FUN_004090ab                            # 0040b234
    pop edi                                      # 0040b239
    pop esi                                      # 0040b23a
    {load} mov esp, ebp                          # 0040b23b
    pop ebp                                      # 0040b23d
    ret                                          # 0040b23e

