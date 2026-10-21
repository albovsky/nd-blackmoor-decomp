# FUN_0040741f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040741f
# extent:       0x0040741f-0x00407466 (71 code bytes)
# span:         0x0040741f-0x00407466 (code 71, tables 0, padding 0)
# sha256:       6191cf13f1b614796aa4957d635f13f67dc3d4425347c5d57f8c3531137fc7bb
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40741f_toggle_5e35be
# naming:       native port src/original_methods_fl37.c:m40741f_toggle_5e35be (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35be; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x2d becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m40741f_toggle_5e35be (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x0040741f - 0x401000
.globl FUN_0040741f
FUN_0040741f:
    # block 0x0040741f: entry, 6 instruction(s), ends with jne to 0x0040743b (forward)
    push ebp                                     # 0040741f
    {load} mov ebp, esp                          # 00407420
    push ecx                                     # 00407422
    mov dword ptr [ebp - local_4], ecx           # 00407423
    cmp dword ptr [0x5e35be], 0x1                # 00407426
    jne.d8 L_0040743b                            # 0040742d
    # block 0x0040742f: entered by fall-through of jne at 0x0040742d, 2 instruction(s), ends with forward jump to 0x0040745a
    mov dword ptr [0x5e35be], 0x0                # 0040742f
    jmp.d8 L_0040745a                            # 00407439
L_0040743b:
    # block 0x0040743b: entered by jne at 0x0040742d, 4 instruction(s), ends with jne to 0x0040745a (forward)
    mov dword ptr [0x5e35be], 0x1                # 0040743b
    movsx eax, word ptr [0x5e335e]               # 00407445
    cmp eax, 0x2d                                # 0040744c
    jne.d8 L_0040745a                            # 0040744f
    # block 0x00407451: entered by fall-through of jne at 0x0040744f, 1 instruction(s), falls into the block at 0x0040745a
    mov word ptr [0x5e335e], 0xffff              # 00407451
L_0040745a:
    # block 0x0040745a: entered by jmp at 0x00407439; jne at 0x0040744f, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0040745a
    call FUN_00404be1                            # 0040745d
    {load} mov esp, ebp                          # 00407462
    pop ebp                                      # 00407464
    ret                                          # 00407465

