# FUN_004fb086
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb086
# extent:       0x004fb086-0x004fb0bf (57 code bytes)
# span:         0x004fb086-0x004fb0bf (code 57, tables 0, padding 0)
# sha256:       fbaf77f9304585a1b55666025266d0335e911247f1509a6559c61de67b7ab78b
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fb086_lifted
# naming:       native port src/original_methods_fl41.c:m4fb086_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 1 seeds; oracle: 20/20 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fb0bf
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4fb086_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004fb0bf, .text + (0x004fb0bf - 0x401000)

.org 0x004fb086 - 0x401000
.globl FUN_004fb086
FUN_004fb086:
    # block 0x004fb086: entry, 6 instruction(s), ends with forward jump to 0x004fb0a3
    push ebp                                     # 004fb086
    {load} mov ebp, esp                          # 004fb087
    sub esp, 0x8                                 # 004fb089
    mov dword ptr [ebp - local_8], ecx           # 004fb08c
    mov word ptr [ebp - local_4], 0x0            # 004fb08f
    jmp.d8 L_004fb0a3                            # 004fb095
L_004fb097:
    # block 0x004fb097: entered by jmp at 0x004fb0b9, 3 instruction(s), falls into the block at 0x004fb0a3
    mov ax, word ptr [ebp - local_4]             # 004fb097
    .insn 0x66, 0x05, 0x0001{:u16}               # 004fb09b
    mov word ptr [ebp - local_4], ax             # 004fb09f
L_004fb0a3:
    # block 0x004fb0a3: entered by jmp at 0x004fb095, 3 instruction(s), ends with jge to 0x004fb0bb (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004fb0a3
    cmp ecx, 0xe                                 # 004fb0a7
    jge.d8 L_004fb0bb                            # 004fb0aa
    # block 0x004fb0ac: entered by fall-through of jge at 0x004fb0aa, 5 instruction(s), calls FUN_004fb0bf, ends with backward jump to 0x004fb097
    mov dx, word ptr [ebp - local_4]             # 004fb0ac
    push edx                                     # 004fb0b0
    mov ecx, dword ptr [ebp - local_8]           # 004fb0b1
    call FUN_004fb0bf                            # 004fb0b4
    jmp.d8 L_004fb097                            # 004fb0b9
L_004fb0bb:
    # block 0x004fb0bb: entered by jge at 0x004fb0aa, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004fb0bb
    pop ebp                                      # 004fb0bd
    ret                                          # 004fb0be

