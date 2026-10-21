# FUN_00406d30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406d30
# extent:       0x00406d30-0x00406d77 (71 code bytes)
# span:         0x00406d30-0x00406d77 (code 71, tables 0, padding 0)
# sha256:       42c1d03a5988774f2e48cdf74a5a895e179b506f73eca6ddded95c88f8155bbe
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406d30_toggle_5e355a
# naming:       native port src/original_methods_fl37.c:m406d30_toggle_5e355a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e355a; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x14 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406d30_toggle_5e355a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406d30 - 0x401000
.globl FUN_00406d30
FUN_00406d30:
    # block 0x00406d30: entry, 6 instruction(s), ends with jne to 0x00406d4c (forward)
    push ebp                                     # 00406d30
    {load} mov ebp, esp                          # 00406d31
    push ecx                                     # 00406d33
    mov dword ptr [ebp - local_4], ecx           # 00406d34
    cmp dword ptr [0x5e355a], 0x1                # 00406d37
    jne.d8 L_00406d4c                            # 00406d3e
    # block 0x00406d40: entered by fall-through of jne at 0x00406d3e, 2 instruction(s), ends with forward jump to 0x00406d6b
    mov dword ptr [0x5e355a], 0x0                # 00406d40
    jmp.d8 L_00406d6b                            # 00406d4a
L_00406d4c:
    # block 0x00406d4c: entered by jne at 0x00406d3e, 4 instruction(s), ends with jne to 0x00406d6b (forward)
    mov dword ptr [0x5e355a], 0x1                # 00406d4c
    movsx eax, word ptr [0x5e335e]               # 00406d56
    cmp eax, 0x14                                # 00406d5d
    jne.d8 L_00406d6b                            # 00406d60
    # block 0x00406d62: entered by fall-through of jne at 0x00406d60, 1 instruction(s), falls into the block at 0x00406d6b
    mov word ptr [0x5e335e], 0xffff              # 00406d62
L_00406d6b:
    # block 0x00406d6b: entered by jmp at 0x00406d4a; jne at 0x00406d60, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406d6b
    call FUN_00404be1                            # 00406d6e
    {load} mov esp, ebp                          # 00406d73
    pop ebp                                      # 00406d75
    ret                                          # 00406d76

