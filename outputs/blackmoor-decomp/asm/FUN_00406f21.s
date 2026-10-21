# FUN_00406f21
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406f21
# extent:       0x00406f21-0x00406f68 (71 code bytes)
# span:         0x00406f21-0x00406f68 (code 71, tables 0, padding 0)
# sha256:       d77365a760dc8ca5ef19a11bee35081250b0fbbd8c9949531507188a248fd83b
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406f21_toggle_5e3576
# naming:       native port src/original_methods_fl37.c:m406f21_toggle_5e3576 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3576; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x1b becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406f21_toggle_5e3576 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406f21 - 0x401000
.globl FUN_00406f21
FUN_00406f21:
    # block 0x00406f21: entry, 6 instruction(s), ends with jne to 0x00406f3d (forward)
    push ebp                                     # 00406f21
    {load} mov ebp, esp                          # 00406f22
    push ecx                                     # 00406f24
    mov dword ptr [ebp - local_4], ecx           # 00406f25
    cmp dword ptr [0x5e3576], 0x1                # 00406f28
    jne.d8 L_00406f3d                            # 00406f2f
    # block 0x00406f31: entered by fall-through of jne at 0x00406f2f, 2 instruction(s), ends with forward jump to 0x00406f5c
    mov dword ptr [0x5e3576], 0x0                # 00406f31
    jmp.d8 L_00406f5c                            # 00406f3b
L_00406f3d:
    # block 0x00406f3d: entered by jne at 0x00406f2f, 4 instruction(s), ends with jne to 0x00406f5c (forward)
    mov dword ptr [0x5e3576], 0x1                # 00406f3d
    movsx eax, word ptr [0x5e335e]               # 00406f47
    cmp eax, 0x1b                                # 00406f4e
    jne.d8 L_00406f5c                            # 00406f51
    # block 0x00406f53: entered by fall-through of jne at 0x00406f51, 1 instruction(s), falls into the block at 0x00406f5c
    mov word ptr [0x5e335e], 0xffff              # 00406f53
L_00406f5c:
    # block 0x00406f5c: entered by jmp at 0x00406f3b; jne at 0x00406f51, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406f5c
    call FUN_00404be1                            # 00406f5f
    {load} mov esp, ebp                          # 00406f64
    pop ebp                                      # 00406f66
    ret                                          # 00406f67

