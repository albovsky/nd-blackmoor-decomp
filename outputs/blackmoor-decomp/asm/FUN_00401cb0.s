# FUN_00401cb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401cb0
# extent:       0x00401cb0-0x00401cda (42 code bytes)
# span:         0x00401cb0-0x00401cda (code 42, tables 0, padding 0)
# sha256:       2f45ff56ab3b43e5a317c3659bc502605707e2c02fbc353e49daf2f13c157a4a
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401cb0_lifted
# naming:       native port src/original_methods_fl40.c:m401cb0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 15/15 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e08b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m401cb0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e08b, .text + (0x0051e08b - 0x401000)

.org 0x00401cb0 - 0x401000
.globl FUN_00401cb0
FUN_00401cb0:
    # block 0x00401cb0: entry, 15 instruction(s), calls FUN_0051e08b, ends with ret 0x4
    push ebp                                     # 00401cb0
    {load} mov ebp, esp                          # 00401cb1
    push ecx                                     # 00401cb3
    mov dword ptr [ebp - local_4], ecx           # 00401cb4
    mov eax, dword ptr [ebp + arg_8]             # 00401cb7
    push eax                                     # 00401cba
    push 0xa1                                    # 00401cbb
    mov ecx, dword ptr [ebp - local_4]           # 00401cc0
    call FUN_0051e08b                            # 00401cc3
    mov ecx, dword ptr [ebp - local_4]           # 00401cc8
    mov dword ptr [ecx], 0x52aec0                # 00401ccb
    mov eax, dword ptr [ebp - local_4]           # 00401cd1
    {load} mov esp, ebp                          # 00401cd4
    pop ebp                                      # 00401cd6
    ret 0x4                                      # 00401cd7

