# FUN_004072bc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004072bc
# extent:       0x004072bc-0x00407303 (71 code bytes)
# span:         0x004072bc-0x00407303 (code 71, tables 0, padding 0)
# sha256:       f25b8cea4c41bb53d6c15a6e58b0adf4bca5c1d76b588e79ed64a2d10bb021a5
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4072bc_toggle_5e35aa
# naming:       native port src/original_methods_fl37.c:m4072bc_toggle_5e35aa (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35aa; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x28 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m4072bc_toggle_5e35aa (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004072bc - 0x401000
.globl FUN_004072bc
FUN_004072bc:
    # block 0x004072bc: entry, 6 instruction(s), ends with jne to 0x004072d8 (forward)
    push ebp                                     # 004072bc
    {load} mov ebp, esp                          # 004072bd
    push ecx                                     # 004072bf
    mov dword ptr [ebp - local_4], ecx           # 004072c0
    cmp dword ptr [0x5e35aa], 0x1                # 004072c3
    jne.d8 L_004072d8                            # 004072ca
    # block 0x004072cc: entered by fall-through of jne at 0x004072ca, 2 instruction(s), ends with forward jump to 0x004072f7
    mov dword ptr [0x5e35aa], 0x0                # 004072cc
    jmp.d8 L_004072f7                            # 004072d6
L_004072d8:
    # block 0x004072d8: entered by jne at 0x004072ca, 4 instruction(s), ends with jne to 0x004072f7 (forward)
    mov dword ptr [0x5e35aa], 0x1                # 004072d8
    movsx eax, word ptr [0x5e335e]               # 004072e2
    cmp eax, 0x28                                # 004072e9
    jne.d8 L_004072f7                            # 004072ec
    # block 0x004072ee: entered by fall-through of jne at 0x004072ec, 1 instruction(s), falls into the block at 0x004072f7
    mov word ptr [0x5e335e], 0xffff              # 004072ee
L_004072f7:
    # block 0x004072f7: entered by jmp at 0x004072d6; jne at 0x004072ec, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004072f7
    call FUN_00404be1                            # 004072fa
    {load} mov esp, ebp                          # 004072ff
    pop ebp                                      # 00407301
    ret                                          # 00407302

