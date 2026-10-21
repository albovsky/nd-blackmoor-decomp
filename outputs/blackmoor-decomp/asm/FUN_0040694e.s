# FUN_0040694e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040694e
# extent:       0x0040694e-0x00406995 (71 code bytes)
# span:         0x0040694e-0x00406995 (code 71, tables 0, padding 0)
# sha256:       4db6f25d74cca4731f644c44eb9a31ed1aad5173f1c25a217a6683447bb84292
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40694e_toggle_5e3522
# naming:       native port src/original_methods_fl34b.c:m40694e_toggle_5e3522 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3522; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x6 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34b.c:m40694e_toggle_5e3522 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x0040694e - 0x401000
.globl FUN_0040694e
FUN_0040694e:
    # block 0x0040694e: entry, 6 instruction(s), ends with jne to 0x0040696a (forward)
    push ebp                                     # 0040694e
    {load} mov ebp, esp                          # 0040694f
    push ecx                                     # 00406951
    mov dword ptr [ebp - local_4], ecx           # 00406952
    cmp dword ptr [0x5e3522], 0x1                # 00406955
    jne.d8 L_0040696a                            # 0040695c
    # block 0x0040695e: entered by fall-through of jne at 0x0040695c, 2 instruction(s), ends with forward jump to 0x00406989
    mov dword ptr [0x5e3522], 0x0                # 0040695e
    jmp.d8 L_00406989                            # 00406968
L_0040696a:
    # block 0x0040696a: entered by jne at 0x0040695c, 4 instruction(s), ends with jne to 0x00406989 (forward)
    mov dword ptr [0x5e3522], 0x1                # 0040696a
    movsx eax, word ptr [0x5e335e]               # 00406974
    cmp eax, 0x6                                 # 0040697b
    jne.d8 L_00406989                            # 0040697e
    # block 0x00406980: entered by fall-through of jne at 0x0040697e, 1 instruction(s), falls into the block at 0x00406989
    mov word ptr [0x5e335e], 0xffff              # 00406980
L_00406989:
    # block 0x00406989: entered by jmp at 0x00406968; jne at 0x0040697e, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406989
    call FUN_00404be1                            # 0040698c
    {load} mov esp, ebp                          # 00406991
    pop ebp                                      # 00406993
    ret                                          # 00406994

