# FUN_00407ac7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407ac7
# extent:       0x00407ac7-0x00407b0e (71 code bytes)
# span:         0x00407ac7-0x00407b10 (code 71, tables 0, padding 2)
# sha256:       d801331c3049d793b0f25f8f8bf2774caaa630f03d7716522f3358fa985ded0e
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407ac7_toggle_5e361e
# naming:       native port src/original_methods_fl37.c:m407ac7_toggle_5e361e (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e361e; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x45 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m407ac7_toggle_5e361e (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407ac7 - 0x401000
.globl FUN_00407ac7
FUN_00407ac7:
    # block 0x00407ac7: entry, 6 instruction(s), ends with jne to 0x00407ae3 (forward)
    push ebp                                     # 00407ac7
    {load} mov ebp, esp                          # 00407ac8
    push ecx                                     # 00407aca
    mov dword ptr [ebp - local_4], ecx           # 00407acb
    cmp dword ptr [0x5e361e], 0x1                # 00407ace
    jne.d8 L_00407ae3                            # 00407ad5
    # block 0x00407ad7: entered by fall-through of jne at 0x00407ad5, 2 instruction(s), ends with forward jump to 0x00407b02
    mov dword ptr [0x5e361e], 0x0                # 00407ad7
    jmp.d8 L_00407b02                            # 00407ae1
L_00407ae3:
    # block 0x00407ae3: entered by jne at 0x00407ad5, 4 instruction(s), ends with jne to 0x00407b02 (forward)
    mov dword ptr [0x5e361e], 0x1                # 00407ae3
    movsx eax, word ptr [0x5e335e]               # 00407aed
    cmp eax, 0x45                                # 00407af4
    jne.d8 L_00407b02                            # 00407af7
    # block 0x00407af9: entered by fall-through of jne at 0x00407af7, 1 instruction(s), falls into the block at 0x00407b02
    mov word ptr [0x5e335e], 0xffff              # 00407af9
L_00407b02:
    # block 0x00407b02: entered by jmp at 0x00407ae1; jne at 0x00407af7, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407b02
    call FUN_00404be1                            # 00407b05
    {load} mov esp, ebp                          # 00407b0a
    pop ebp                                      # 00407b0c
    ret                                          # 00407b0d

# --- data items (not part of the function) -------------------------
.org 0x00407b0e - 0x401000
PAD_00407b0e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

