# FUN_004069dc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004069dc
# extent:       0x004069dc-0x00406a23 (71 code bytes)
# span:         0x004069dc-0x00406a23 (code 71, tables 0, padding 0)
# sha256:       94152def9d734c38d1eb1a9a4166311e32ccdb7c300d14714e5cce92692d7a0b
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4069dc_toggle_5e352a
# naming:       native port src/original_methods_fl34b.c:m4069dc_toggle_5e352a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e352a; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x8 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34b.c:m4069dc_toggle_5e352a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004069dc - 0x401000
.globl FUN_004069dc
FUN_004069dc:
    # block 0x004069dc: entry, 6 instruction(s), ends with jne to 0x004069f8 (forward)
    push ebp                                     # 004069dc
    {load} mov ebp, esp                          # 004069dd
    push ecx                                     # 004069df
    mov dword ptr [ebp - local_4], ecx           # 004069e0
    cmp dword ptr [0x5e352a], 0x1                # 004069e3
    jne.d8 L_004069f8                            # 004069ea
    # block 0x004069ec: entered by fall-through of jne at 0x004069ea, 2 instruction(s), ends with forward jump to 0x00406a17
    mov dword ptr [0x5e352a], 0x0                # 004069ec
    jmp.d8 L_00406a17                            # 004069f6
L_004069f8:
    # block 0x004069f8: entered by jne at 0x004069ea, 4 instruction(s), ends with jne to 0x00406a17 (forward)
    mov dword ptr [0x5e352a], 0x1                # 004069f8
    movsx eax, word ptr [0x5e335e]               # 00406a02
    cmp eax, 0x8                                 # 00406a09
    jne.d8 L_00406a17                            # 00406a0c
    # block 0x00406a0e: entered by fall-through of jne at 0x00406a0c, 1 instruction(s), falls into the block at 0x00406a17
    mov word ptr [0x5e335e], 0xffff              # 00406a0e
L_00406a17:
    # block 0x00406a17: entered by jmp at 0x004069f6; jne at 0x00406a0c, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406a17
    call FUN_00404be1                            # 00406a1a
    {load} mov esp, ebp                          # 00406a1f
    pop ebp                                      # 00406a21
    ret                                          # 00406a22

