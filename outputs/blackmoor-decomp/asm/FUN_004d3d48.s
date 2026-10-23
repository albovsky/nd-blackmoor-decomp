# FUN_004d3d48
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3d48
# extent:       0x004d3d48-0x004d3d97 (79 code bytes)
# span:         0x004d3d48-0x004d3da7 (code 79, tables 16, padding 0)
# sha256:       405c762419f0a29e7a062a94e0fc5a624016cda393bb7dd6f4075ac2a2c4d8fd
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3d48_lifted
# naming:       native port src/original_methods_fl41.c:m4d3d48_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 7 seeds; oracle: 25/25 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_462
# callees:      calls FUN_004d3da7, FUN_004d3eba, FUN_004d3fa9, FUN_004d3ffe
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d3d48_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 25 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------
.set FUN_004d3da7, .text + (0x004d3da7 - 0x401000)
.set FUN_004d3eba, .text + (0x004d3eba - 0x401000)
.set FUN_004d3fa9, .text + (0x004d3fa9 - 0x401000)
.set FUN_004d3ffe, .text + (0x004d3ffe - 0x401000)

.org 0x004d3d48 - 0x401000
.globl FUN_004d3d48
FUN_004d3d48:
    # block 0x004d3d48: entry, 9 instruction(s), ends with ja to 0x004d3d93 (forward)
    push ebp                                     # 004d3d48
    {load} mov ebp, esp                          # 004d3d49
    sub esp, 0x8                                 # 004d3d4b
    mov dword ptr [ebp - local_4], ecx           # 004d3d4e
    mov eax, dword ptr [ebp - local_4]           # 004d3d51
    mov ecx, dword ptr [eax + field_462]         # 004d3d54
    mov dword ptr [ebp - local_8], ecx           # 004d3d5a
    cmp dword ptr [ebp - local_8], 0x3           # 004d3d5d
    ja.d8 L_004d3d93                             # 004d3d61
    # block 0x004d3d63: entered by fall-through of ja at 0x004d3d61, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4d3d97]
    mov edx, dword ptr [ebp - local_8]           # 004d3d63
    jmp dword ptr [4*edx + SWTAB_004d3d97_VA]    # 004d3d66
L_004d3d6d:
    # block 0x004d3d6d: entered by switch case, 3 instruction(s), calls FUN_004d3da7, ends with forward jump to 0x004d3d93
    mov ecx, dword ptr [ebp - local_4]           # 004d3d6d
    call FUN_004d3da7                            # 004d3d70
    jmp.d8 L_004d3d93                            # 004d3d75
L_004d3d77:
    # block 0x004d3d77: entered by switch case, 3 instruction(s), calls FUN_004d3eba, ends with forward jump to 0x004d3d93
    mov ecx, dword ptr [ebp - local_4]           # 004d3d77
    call FUN_004d3eba                            # 004d3d7a
    jmp.d8 L_004d3d93                            # 004d3d7f
L_004d3d81:
    # block 0x004d3d81: entered by switch case, 3 instruction(s), calls FUN_004d3fa9, ends with forward jump to 0x004d3d93
    mov ecx, dword ptr [ebp - local_4]           # 004d3d81
    call FUN_004d3fa9                            # 004d3d84
    jmp.d8 L_004d3d93                            # 004d3d89
L_004d3d8b:
    # block 0x004d3d8b: entered by switch case, 2 instruction(s), calls FUN_004d3ffe, falls into the block at 0x004d3d93
    mov ecx, dword ptr [ebp - local_4]           # 004d3d8b
    call FUN_004d3ffe                            # 004d3d8e
L_004d3d93:
    # block 0x004d3d93: entered by ja at 0x004d3d61; jmp at 0x004d3d75; jmp at 0x004d3d7f; jmp at 0x004d3d89, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d3d93
    pop ebp                                      # 004d3d95
    ret                                          # 004d3d96

# --- data items (not part of the function) -------------------------
.org 0x004d3d97 - 0x401000
SWTAB_004d3d97:  # 4 case address(es)
    .long L_004d3d6d - .text + 0x401000
    .long L_004d3d77 - .text + 0x401000
    .long L_004d3d81 - .text + 0x401000
    .long L_004d3d8b - .text + 0x401000
.set SWTAB_004d3d97_VA, SWTAB_004d3d97 - .text + 0x401000

