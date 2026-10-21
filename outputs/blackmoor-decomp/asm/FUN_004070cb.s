# FUN_004070cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004070cb
# extent:       0x004070cb-0x00407112 (71 code bytes)
# span:         0x004070cb-0x00407112 (code 71, tables 0, padding 0)
# sha256:       7df5c297a004c98c3ba968a1d83aa4aba871b5ea8e22c2b30f1bf1e90b8ca81f
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4070cb_toggle_5e358e
# naming:       native port src/original_methods_fl37.c:m4070cb_toggle_5e358e (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e358e; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x21 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m4070cb_toggle_5e358e (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x004070cb - 0x401000
.globl FUN_004070cb
FUN_004070cb:
    # block 0x004070cb: entry, 6 instruction(s), ends with jne to 0x004070e7 (forward)
    push ebp                                     # 004070cb
    {load} mov ebp, esp                          # 004070cc
    push ecx                                     # 004070ce
    mov dword ptr [ebp - local_4], ecx           # 004070cf
    cmp dword ptr [0x5e358e], 0x1                # 004070d2
    jne.d8 L_004070e7                            # 004070d9
    # block 0x004070db: entered by fall-through of jne at 0x004070d9, 2 instruction(s), ends with forward jump to 0x00407106
    mov dword ptr [0x5e358e], 0x0                # 004070db
    jmp.d8 L_00407106                            # 004070e5
L_004070e7:
    # block 0x004070e7: entered by jne at 0x004070d9, 4 instruction(s), ends with jne to 0x00407106 (forward)
    mov dword ptr [0x5e358e], 0x1                # 004070e7
    movsx eax, word ptr [0x5e335e]               # 004070f1
    cmp eax, 0x21                                # 004070f8
    jne.d8 L_00407106                            # 004070fb
    # block 0x004070fd: entered by fall-through of jne at 0x004070fb, 1 instruction(s), falls into the block at 0x00407106
    mov word ptr [0x5e335e], 0xffff              # 004070fd
L_00407106:
    # block 0x00407106: entered by jmp at 0x004070e5; jne at 0x004070fb, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407106
    call FUN_00404be1                            # 00407109
    {load} mov esp, ebp                          # 0040710e
    pop ebp                                      # 00407110
    ret                                          # 00407111

