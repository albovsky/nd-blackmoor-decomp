# FUN_0041a102
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a102
# extent:       0x0041a102-0x0041a140 (62 code bytes)
# span:         0x0041a102-0x0041a140 (code 62, tables 0, padding 0)
# sha256:       ba787db2e307b06b61248e40626ba0e5e04053331bbb09de76fd74507034b7f0
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41a102_lifted
# naming:       native port src/original_methods_fl40.c:m41a102_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 4 seeds; oracle 22/22 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d0a9, FUN_0050cee4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41a102_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)

.org 0x0041a102 - 0x401000
.globl FUN_0041a102
FUN_0041a102:
    # block 0x0041a102: entry, 12 instruction(s), calls FUN_0050d0a9, ends with jne to 0x0041a12a (forward)
    push ebp                                     # 0041a102
    {load} mov ebp, esp                          # 0041a103
    sub esp, 0x8                                 # 0041a105
    mov dword ptr [ebp - local_8], ecx           # 0041a108
    push 0x543148                                # 0041a10b
    mov eax, dword ptr [ebp + arg_8]             # 0041a110
    push eax                                     # 0041a113
    call FUN_0050d0a9                            # 0041a114
    add esp, 0x8                                 # 0041a119
    mov dword ptr [ebp - local_4], eax           # 0041a11c
    cmp dword ptr [ebp - local_4], 0x0           # 0041a11f
    jne.d8 L_0041a12a                            # 0041a123
    # block 0x0041a125: entered by fall-through of jne at 0x0041a123, 2 instruction(s), ends with forward jump to 0x0041a13a
    {load} xor ax, ax                            # 0041a125
    jmp.d8 L_0041a13a                            # 0041a128
L_0041a12a:
    # block 0x0041a12a: entered by jne at 0x0041a123, 5 instruction(s), calls FUN_0050cee4, falls into the block at 0x0041a13a
    mov ecx, dword ptr [ebp - local_4]           # 0041a12a
    push ecx                                     # 0041a12d
    call FUN_0050cee4                            # 0041a12e
    add esp, 0x4                                 # 0041a133
    mov ax, 0x1                                  # 0041a136
L_0041a13a:
    # block 0x0041a13a: entered by jmp at 0x0041a128, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0041a13a
    pop ebp                                      # 0041a13c
    ret 0x4                                      # 0041a13d

