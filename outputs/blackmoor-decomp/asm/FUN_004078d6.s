# FUN_004078d6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004078d6
# extent:       0x004078d6-0x0040791d (71 code bytes)
# span:         0x004078d6-0x0040791d (code 71, tables 0, padding 0)
# sha256:       790bd89508d0c309499546aa8a907b6fd918aab671373aa124d75ed114840eb9
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4078d6_toggle_5e3602
# naming:       native port src/original_methods_fl37.c:m4078d6_toggle_5e3602 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3602; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x3e becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m4078d6_toggle_5e3602 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004078d6 - 0x401000
.globl FUN_004078d6
FUN_004078d6:
    # block 0x004078d6: entry, 6 instruction(s), ends with jne to 0x004078f2 (forward)
    push ebp                                     # 004078d6
    {load} mov ebp, esp                          # 004078d7
    push ecx                                     # 004078d9
    mov dword ptr [ebp - local_4], ecx           # 004078da
    cmp dword ptr [0x5e3602], 0x1                # 004078dd
    jne.d8 L_004078f2                            # 004078e4
    # block 0x004078e6: entered by fall-through of jne at 0x004078e4, 2 instruction(s), ends with forward jump to 0x00407911
    mov dword ptr [0x5e3602], 0x0                # 004078e6
    jmp.d8 L_00407911                            # 004078f0
L_004078f2:
    # block 0x004078f2: entered by jne at 0x004078e4, 4 instruction(s), ends with jne to 0x00407911 (forward)
    mov dword ptr [0x5e3602], 0x1                # 004078f2
    movsx eax, word ptr [0x5e335e]               # 004078fc
    cmp eax, 0x3e                                # 00407903
    jne.d8 L_00407911                            # 00407906
    # block 0x00407908: entered by fall-through of jne at 0x00407906, 1 instruction(s), falls into the block at 0x00407911
    mov word ptr [0x5e335e], 0xffff              # 00407908
L_00407911:
    # block 0x00407911: entered by jmp at 0x004078f0; jne at 0x00407906, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407911
    call FUN_00404be1                            # 00407914
    {load} mov esp, ebp                          # 00407919
    pop ebp                                      # 0040791b
    ret                                          # 0040791c

