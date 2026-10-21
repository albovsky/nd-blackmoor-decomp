# FUN_00407848
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407848
# extent:       0x00407848-0x0040788f (71 code bytes)
# span:         0x00407848-0x0040788f (code 71, tables 0, padding 0)
# sha256:       579eb0a0b14b5ac8977f6d92808e1feaa54711118ce4d07ff00f45d5e9af51bb
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407848_toggle_5e35fa
# naming:       native port src/original_methods_fl37.c:m407848_toggle_5e35fa (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35fa; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x3c becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m407848_toggle_5e35fa (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407848 - 0x401000
.globl FUN_00407848
FUN_00407848:
    # block 0x00407848: entry, 6 instruction(s), ends with jne to 0x00407864 (forward)
    push ebp                                     # 00407848
    {load} mov ebp, esp                          # 00407849
    push ecx                                     # 0040784b
    mov dword ptr [ebp - local_4], ecx           # 0040784c
    cmp dword ptr [0x5e35fa], 0x1                # 0040784f
    jne.d8 L_00407864                            # 00407856
    # block 0x00407858: entered by fall-through of jne at 0x00407856, 2 instruction(s), ends with forward jump to 0x00407883
    mov dword ptr [0x5e35fa], 0x0                # 00407858
    jmp.d8 L_00407883                            # 00407862
L_00407864:
    # block 0x00407864: entered by jne at 0x00407856, 4 instruction(s), ends with jne to 0x00407883 (forward)
    mov dword ptr [0x5e35fa], 0x1                # 00407864
    movsx eax, word ptr [0x5e335e]               # 0040786e
    cmp eax, 0x3c                                # 00407875
    jne.d8 L_00407883                            # 00407878
    # block 0x0040787a: entered by fall-through of jne at 0x00407878, 1 instruction(s), falls into the block at 0x00407883
    mov word ptr [0x5e335e], 0xffff              # 0040787a
L_00407883:
    # block 0x00407883: entered by jmp at 0x00407862; jne at 0x00407878, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407883
    call FUN_00404be1                            # 00407886
    {load} mov esp, ebp                          # 0040788b
    pop ebp                                      # 0040788d
    ret                                          # 0040788e

