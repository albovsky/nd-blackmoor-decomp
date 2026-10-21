# FUN_004079f2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004079f2
# extent:       0x004079f2-0x00407a39 (71 code bytes)
# span:         0x004079f2-0x00407a39 (code 71, tables 0, padding 0)
# sha256:       a90c424075b121e25eec0599763efeb30ba57dcce03192d9709154b1cb77a8ba
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4079f2_toggle_5e3612
# naming:       native port src/original_methods_fl37.c:m4079f2_toggle_5e3612 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3612; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x42 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m4079f2_toggle_5e3612 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004079f2 - 0x401000
.globl FUN_004079f2
FUN_004079f2:
    # block 0x004079f2: entry, 6 instruction(s), ends with jne to 0x00407a0e (forward)
    push ebp                                     # 004079f2
    {load} mov ebp, esp                          # 004079f3
    push ecx                                     # 004079f5
    mov dword ptr [ebp - local_4], ecx           # 004079f6
    cmp dword ptr [0x5e3612], 0x1                # 004079f9
    jne.d8 L_00407a0e                            # 00407a00
    # block 0x00407a02: entered by fall-through of jne at 0x00407a00, 2 instruction(s), ends with forward jump to 0x00407a2d
    mov dword ptr [0x5e3612], 0x0                # 00407a02
    jmp.d8 L_00407a2d                            # 00407a0c
L_00407a0e:
    # block 0x00407a0e: entered by jne at 0x00407a00, 4 instruction(s), ends with jne to 0x00407a2d (forward)
    mov dword ptr [0x5e3612], 0x1                # 00407a0e
    movsx eax, word ptr [0x5e335e]               # 00407a18
    cmp eax, 0x42                                # 00407a1f
    jne.d8 L_00407a2d                            # 00407a22
    # block 0x00407a24: entered by fall-through of jne at 0x00407a22, 1 instruction(s), falls into the block at 0x00407a2d
    mov word ptr [0x5e335e], 0xffff              # 00407a24
L_00407a2d:
    # block 0x00407a2d: entered by jmp at 0x00407a0c; jne at 0x00407a22, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407a2d
    call FUN_00404be1                            # 00407a30
    {load} mov esp, ebp                          # 00407a35
    pop ebp                                      # 00407a37
    ret                                          # 00407a38

