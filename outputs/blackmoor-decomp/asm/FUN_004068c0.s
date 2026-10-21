# FUN_004068c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004068c0
# extent:       0x004068c0-0x00406907 (71 code bytes)
# span:         0x004068c0-0x00406907 (code 71, tables 0, padding 0)
# sha256:       7a8ba8400576e43eb99b6998d16bf58d5c2ee83c16497a342628c5ae34018f4e
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4068c0_toggle_5e351a
# naming:       native port src/original_methods_fl34b.c:m4068c0_toggle_5e351a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e351a; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x4 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34b.c:m4068c0_toggle_5e351a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004068c0 - 0x401000
.globl FUN_004068c0
FUN_004068c0:
    # block 0x004068c0: entry, 6 instruction(s), ends with jne to 0x004068dc (forward)
    push ebp                                     # 004068c0
    {load} mov ebp, esp                          # 004068c1
    push ecx                                     # 004068c3
    mov dword ptr [ebp - local_4], ecx           # 004068c4
    cmp dword ptr [0x5e351a], 0x1                # 004068c7
    jne.d8 L_004068dc                            # 004068ce
    # block 0x004068d0: entered by fall-through of jne at 0x004068ce, 2 instruction(s), ends with forward jump to 0x004068fb
    mov dword ptr [0x5e351a], 0x0                # 004068d0
    jmp.d8 L_004068fb                            # 004068da
L_004068dc:
    # block 0x004068dc: entered by jne at 0x004068ce, 4 instruction(s), ends with jne to 0x004068fb (forward)
    mov dword ptr [0x5e351a], 0x1                # 004068dc
    movsx eax, word ptr [0x5e335e]               # 004068e6
    cmp eax, 0x4                                 # 004068ed
    jne.d8 L_004068fb                            # 004068f0
    # block 0x004068f2: entered by fall-through of jne at 0x004068f0, 1 instruction(s), falls into the block at 0x004068fb
    mov word ptr [0x5e335e], 0xffff              # 004068f2
L_004068fb:
    # block 0x004068fb: entered by jmp at 0x004068da; jne at 0x004068f0, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004068fb
    call FUN_00404be1                            # 004068fe
    {load} mov esp, ebp                          # 00406903
    pop ebp                                      # 00406905
    ret                                          # 00406906

