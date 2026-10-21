# FUN_004075c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004075c9
# extent:       0x004075c9-0x00407610 (71 code bytes)
# span:         0x004075c9-0x00407610 (code 71, tables 0, padding 0)
# sha256:       f03ee1d2c0ecaef6345734f937eaba101afb39430b670aea3db3327682bbece3
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4075c9_toggle_5e35d6
# naming:       native port src/original_methods_fl37.c:m4075c9_toggle_5e35d6 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35d6; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x33 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m4075c9_toggle_5e35d6 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004075c9 - 0x401000
.globl FUN_004075c9
FUN_004075c9:
    # block 0x004075c9: entry, 6 instruction(s), ends with jne to 0x004075e5 (forward)
    push ebp                                     # 004075c9
    {load} mov ebp, esp                          # 004075ca
    push ecx                                     # 004075cc
    mov dword ptr [ebp - local_4], ecx           # 004075cd
    cmp dword ptr [0x5e35d6], 0x1                # 004075d0
    jne.d8 L_004075e5                            # 004075d7
    # block 0x004075d9: entered by fall-through of jne at 0x004075d7, 2 instruction(s), ends with forward jump to 0x00407604
    mov dword ptr [0x5e35d6], 0x0                # 004075d9
    jmp.d8 L_00407604                            # 004075e3
L_004075e5:
    # block 0x004075e5: entered by jne at 0x004075d7, 4 instruction(s), ends with jne to 0x00407604 (forward)
    mov dword ptr [0x5e35d6], 0x1                # 004075e5
    movsx eax, word ptr [0x5e335e]               # 004075ef
    cmp eax, 0x33                                # 004075f6
    jne.d8 L_00407604                            # 004075f9
    # block 0x004075fb: entered by fall-through of jne at 0x004075f9, 1 instruction(s), falls into the block at 0x00407604
    mov word ptr [0x5e335e], 0xffff              # 004075fb
L_00407604:
    # block 0x00407604: entered by jmp at 0x004075e3; jne at 0x004075f9, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407604
    call FUN_00404be1                            # 00407607
    {load} mov esp, ebp                          # 0040760c
    pop ebp                                      # 0040760e
    ret                                          # 0040760f

