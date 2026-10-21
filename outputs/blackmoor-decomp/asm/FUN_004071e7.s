# FUN_004071e7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004071e7
# extent:       0x004071e7-0x0040722e (71 code bytes)
# span:         0x004071e7-0x0040722e (code 71, tables 0, padding 0)
# sha256:       9045f2ac5cc73fdf1f1497c27eae76d886bedaaacefedc33ed76d0e53551be6d
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4071e7_toggle_5e359e
# naming:       native port src/original_methods_fl37.c:m4071e7_toggle_5e359e (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e359e; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x25 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m4071e7_toggle_5e359e (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004071e7 - 0x401000
.globl FUN_004071e7
FUN_004071e7:
    # block 0x004071e7: entry, 6 instruction(s), ends with jne to 0x00407203 (forward)
    push ebp                                     # 004071e7
    {load} mov ebp, esp                          # 004071e8
    push ecx                                     # 004071ea
    mov dword ptr [ebp - local_4], ecx           # 004071eb
    cmp dword ptr [0x5e359e], 0x1                # 004071ee
    jne.d8 L_00407203                            # 004071f5
    # block 0x004071f7: entered by fall-through of jne at 0x004071f5, 2 instruction(s), ends with forward jump to 0x00407222
    mov dword ptr [0x5e359e], 0x0                # 004071f7
    jmp.d8 L_00407222                            # 00407201
L_00407203:
    # block 0x00407203: entered by jne at 0x004071f5, 4 instruction(s), ends with jne to 0x00407222 (forward)
    mov dword ptr [0x5e359e], 0x1                # 00407203
    movsx eax, word ptr [0x5e335e]               # 0040720d
    cmp eax, 0x25                                # 00407214
    jne.d8 L_00407222                            # 00407217
    # block 0x00407219: entered by fall-through of jne at 0x00407217, 1 instruction(s), falls into the block at 0x00407222
    mov word ptr [0x5e335e], 0xffff              # 00407219
L_00407222:
    # block 0x00407222: entered by jmp at 0x00407201; jne at 0x00407217, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407222
    call FUN_00404be1                            # 00407225
    {load} mov esp, ebp                          # 0040722a
    pop ebp                                      # 0040722c
    ret                                          # 0040722d

