# FUN_004541a6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004541a6
# extent:       0x004541a6-0x004541cf (41 code bytes)
# span:         0x004541a6-0x004541cf (code 41, tables 0, padding 0)
# sha256:       282558fe08a7192e63a15d2b89a1d37008d8b124190843e5014db88e1529986d
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4541a6_lifted
# naming:       native port src/original_methods_fl40.c:m4541a6_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 4 seeds; oracle 16/16 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4541a6_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004541a6 - 0x401000
.globl FUN_004541a6
FUN_004541a6:
    # block 0x004541a6: entry, 6 instruction(s), ends with jne to 0x004541b7 (forward)
    push ebp                                     # 004541a6
    {load} mov ebp, esp                          # 004541a7
    sub esp, 0x8                                 # 004541a9
    mov dword ptr [ebp - local_8], ecx           # 004541ac
    cmp dword ptr [ebp + arg_8], 0x0             # 004541af
    jne.d8 L_004541b7                            # 004541b3
    # block 0x004541b5: entered by fall-through of jne at 0x004541b3, 1 instruction(s), ends with forward jump to 0x004541c9
    jmp.d8 L_004541c9                            # 004541b5
L_004541b7:
    # block 0x004541b7: entered by jne at 0x004541b3, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004541c9
    mov eax, dword ptr [ebp + arg_8]             # 004541b7
    mov dword ptr [ebp - local_4], eax           # 004541ba
    mov ecx, dword ptr [ebp - local_4]           # 004541bd
    push ecx                                     # 004541c0
    call FUN_0051dc6c                            # 004541c1
    add esp, 0x4                                 # 004541c6
L_004541c9:
    # block 0x004541c9: entered by jmp at 0x004541b5, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004541c9
    pop ebp                                      # 004541cb
    ret 0x4                                      # 004541cc

