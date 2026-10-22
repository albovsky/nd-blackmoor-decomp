# FUN_00404201
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404201
# extent:       0x00404201-0x0040425d (92 code bytes)
# span:         0x00404201-0x0040425d (code 92, tables 0, padding 0)
# sha256:       041025ca5beb34a4f737174f19dc011b2c8a36cbaa0d4b5a2bb3dc9308b17a8d
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m404201_lifted
# naming:       native port src/original_methods_fl40.c:m404201_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 5 seeds; oracle 27/27 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_14, local_18, local_1c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m404201_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x00404201 - 0x401000
.globl FUN_00404201
FUN_00404201:
    # block 0x00404201: entry, 19 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, ends with je to 0x00404246 (forward)
    push ebp                                     # 00404201
    {load} mov ebp, esp                          # 00404202
    sub esp, 0x1c                                # 00404204
    mov dword ptr [ebp - local_1c], ecx          # 00404207
    push 0x13                                    # 0040420a
    lea eax, [ebp - local_14]                    # 0040420c
    push eax                                     # 0040420f
    mov ecx, dword ptr [ebp - local_1c]          # 00404210
    add ecx, 0x8c                                # 00404213
    call FUN_0051d5b2                            # 00404219
    lea ecx, [ebp - local_14]                    # 0040421e
    push ecx                                     # 00404221
    call FUN_0050cb1b                            # 00404222
    add esp, 0x4                                 # 00404227
    mov word ptr [ebp - local_18], ax            # 0040422a
    movsx edx, word ptr [ebp - local_18]         # 0040422e
    movsx eax, word ptr [0x5ec33c]               # 00404232
    {load} cmp edx, eax                          # 00404239
    je.d8 L_00404246                             # 0040423b
    # block 0x0040423d: entered by fall-through of je at 0x0040423b, 1 instruction(s), falls into the block at 0x00404246
    mov word ptr [0x5ec33e], 0x0                 # 0040423d
L_00404246:
    # block 0x00404246: entered by je at 0x0040423b, 7 instruction(s), calls FUN_004033db, ends with ret
    mov cx, word ptr [ebp - local_18]            # 00404246
    mov word ptr [0x5ec33c], cx                  # 0040424a
    mov ecx, dword ptr [ebp - local_1c]          # 00404251
    call FUN_004033db                            # 00404254
    {load} mov esp, ebp                          # 00404259
    pop ebp                                      # 0040425b
    ret                                          # 0040425c

