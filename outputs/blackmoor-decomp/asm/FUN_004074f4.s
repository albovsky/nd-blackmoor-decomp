# FUN_004074f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004074f4
# extent:       0x004074f4-0x0040753b (71 code bytes)
# span:         0x004074f4-0x0040753b (code 71, tables 0, padding 0)
# sha256:       25f94bf406317f69ede10f8e5940784539793580ae2cf40b4f041a87bcd93ec3
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4074f4_toggle_5e35ca
# naming:       native port src/original_methods_fl37.c:m4074f4_toggle_5e35ca (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35ca; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x30 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m4074f4_toggle_5e35ca (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004074f4 - 0x401000
.globl FUN_004074f4
FUN_004074f4:
    # block 0x004074f4: entry, 6 instruction(s), ends with jne to 0x00407510 (forward)
    push ebp                                     # 004074f4
    {load} mov ebp, esp                          # 004074f5
    push ecx                                     # 004074f7
    mov dword ptr [ebp - local_4], ecx           # 004074f8
    cmp dword ptr [0x5e35ca], 0x1                # 004074fb
    jne.d8 L_00407510                            # 00407502
    # block 0x00407504: entered by fall-through of jne at 0x00407502, 2 instruction(s), ends with forward jump to 0x0040752f
    mov dword ptr [0x5e35ca], 0x0                # 00407504
    jmp.d8 L_0040752f                            # 0040750e
L_00407510:
    # block 0x00407510: entered by jne at 0x00407502, 4 instruction(s), ends with jne to 0x0040752f (forward)
    mov dword ptr [0x5e35ca], 0x1                # 00407510
    movsx eax, word ptr [0x5e335e]               # 0040751a
    cmp eax, 0x30                                # 00407521
    jne.d8 L_0040752f                            # 00407524
    # block 0x00407526: entered by fall-through of jne at 0x00407524, 1 instruction(s), falls into the block at 0x0040752f
    mov word ptr [0x5e335e], 0xffff              # 00407526
L_0040752f:
    # block 0x0040752f: entered by jmp at 0x0040750e; jne at 0x00407524, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0040752f
    call FUN_00404be1                            # 00407532
    {load} mov esp, ebp                          # 00407537
    pop ebp                                      # 00407539
    ret                                          # 0040753a

