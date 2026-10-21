# FUN_0040734a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040734a
# extent:       0x0040734a-0x00407391 (71 code bytes)
# span:         0x0040734a-0x00407391 (code 71, tables 0, padding 0)
# sha256:       09d6de6378cb8ae80f8a8d17560f0cf46f1acaeeef6f8792978de426254929f5
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40734a_toggle_5e35b2
# naming:       native port src/original_methods_fl37.c:m40734a_toggle_5e35b2 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35b2; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x2a becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m40734a_toggle_5e35b2 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x0040734a - 0x401000
.globl FUN_0040734a
FUN_0040734a:
    # block 0x0040734a: entry, 6 instruction(s), ends with jne to 0x00407366 (forward)
    push ebp                                     # 0040734a
    {load} mov ebp, esp                          # 0040734b
    push ecx                                     # 0040734d
    mov dword ptr [ebp - local_4], ecx           # 0040734e
    cmp dword ptr [0x5e35b2], 0x1                # 00407351
    jne.d8 L_00407366                            # 00407358
    # block 0x0040735a: entered by fall-through of jne at 0x00407358, 2 instruction(s), ends with forward jump to 0x00407385
    mov dword ptr [0x5e35b2], 0x0                # 0040735a
    jmp.d8 L_00407385                            # 00407364
L_00407366:
    # block 0x00407366: entered by jne at 0x00407358, 4 instruction(s), ends with jne to 0x00407385 (forward)
    mov dword ptr [0x5e35b2], 0x1                # 00407366
    movsx eax, word ptr [0x5e335e]               # 00407370
    cmp eax, 0x2a                                # 00407377
    jne.d8 L_00407385                            # 0040737a
    # block 0x0040737c: entered by fall-through of jne at 0x0040737a, 1 instruction(s), falls into the block at 0x00407385
    mov word ptr [0x5e335e], 0xffff              # 0040737c
L_00407385:
    # block 0x00407385: entered by jmp at 0x00407364; jne at 0x0040737a, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407385
    call FUN_00404be1                            # 00407388
    {load} mov esp, ebp                          # 0040738d
    pop ebp                                      # 0040738f
    ret                                          # 00407390

