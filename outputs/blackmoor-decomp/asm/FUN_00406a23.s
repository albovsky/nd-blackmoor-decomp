# FUN_00406a23
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406a23
# extent:       0x00406a23-0x00406a6a (71 code bytes)
# span:         0x00406a23-0x00406a6a (code 71, tables 0, padding 0)
# sha256:       26c8c9e9a6d21862f0d215ab450f81133d23b36a5b8ef9293055d3c34f920ae4
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406a23_toggle_5e352e
# naming:       native port src/original_methods_fl34b.c:m406a23_toggle_5e352e (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e352e; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x9 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34b.c:m406a23_toggle_5e352e (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406a23 - 0x401000
.globl FUN_00406a23
FUN_00406a23:
    # block 0x00406a23: entry, 6 instruction(s), ends with jne to 0x00406a3f (forward)
    push ebp                                     # 00406a23
    {load} mov ebp, esp                          # 00406a24
    push ecx                                     # 00406a26
    mov dword ptr [ebp - local_4], ecx           # 00406a27
    cmp dword ptr [0x5e352e], 0x1                # 00406a2a
    jne.d8 L_00406a3f                            # 00406a31
    # block 0x00406a33: entered by fall-through of jne at 0x00406a31, 2 instruction(s), ends with forward jump to 0x00406a5e
    mov dword ptr [0x5e352e], 0x0                # 00406a33
    jmp.d8 L_00406a5e                            # 00406a3d
L_00406a3f:
    # block 0x00406a3f: entered by jne at 0x00406a31, 4 instruction(s), ends with jne to 0x00406a5e (forward)
    mov dword ptr [0x5e352e], 0x1                # 00406a3f
    movsx eax, word ptr [0x5e335e]               # 00406a49
    cmp eax, 0x9                                 # 00406a50
    jne.d8 L_00406a5e                            # 00406a53
    # block 0x00406a55: entered by fall-through of jne at 0x00406a53, 1 instruction(s), falls into the block at 0x00406a5e
    mov word ptr [0x5e335e], 0xffff              # 00406a55
L_00406a5e:
    # block 0x00406a5e: entered by jmp at 0x00406a3d; jne at 0x00406a53, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406a5e
    call FUN_00404be1                            # 00406a61
    {load} mov esp, ebp                          # 00406a66
    pop ebp                                      # 00406a68
    ret                                          # 00406a69

