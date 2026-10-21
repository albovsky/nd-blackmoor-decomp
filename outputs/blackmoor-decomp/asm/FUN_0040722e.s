# FUN_0040722e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040722e
# extent:       0x0040722e-0x00407275 (71 code bytes)
# span:         0x0040722e-0x00407275 (code 71, tables 0, padding 0)
# sha256:       0f5f51c1be3667255204822185b80e1a981236f7dd7958a8e1e160cb54794190
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40722e_toggle_5e35a2
# naming:       native port src/original_methods_fl37.c:m40722e_toggle_5e35a2 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35a2; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x26 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m40722e_toggle_5e35a2 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x0040722e - 0x401000
.globl FUN_0040722e
FUN_0040722e:
    # block 0x0040722e: entry, 6 instruction(s), ends with jne to 0x0040724a (forward)
    push ebp                                     # 0040722e
    {load} mov ebp, esp                          # 0040722f
    push ecx                                     # 00407231
    mov dword ptr [ebp - local_4], ecx           # 00407232
    cmp dword ptr [0x5e35a2], 0x1                # 00407235
    jne.d8 L_0040724a                            # 0040723c
    # block 0x0040723e: entered by fall-through of jne at 0x0040723c, 2 instruction(s), ends with forward jump to 0x00407269
    mov dword ptr [0x5e35a2], 0x0                # 0040723e
    jmp.d8 L_00407269                            # 00407248
L_0040724a:
    # block 0x0040724a: entered by jne at 0x0040723c, 4 instruction(s), ends with jne to 0x00407269 (forward)
    mov dword ptr [0x5e35a2], 0x1                # 0040724a
    movsx eax, word ptr [0x5e335e]               # 00407254
    cmp eax, 0x26                                # 0040725b
    jne.d8 L_00407269                            # 0040725e
    # block 0x00407260: entered by fall-through of jne at 0x0040725e, 1 instruction(s), falls into the block at 0x00407269
    mov word ptr [0x5e335e], 0xffff              # 00407260
L_00407269:
    # block 0x00407269: entered by jmp at 0x00407248; jne at 0x0040725e, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407269
    call FUN_00404be1                            # 0040726c
    {load} mov esp, ebp                          # 00407271
    pop ebp                                      # 00407273
    ret                                          # 00407274

