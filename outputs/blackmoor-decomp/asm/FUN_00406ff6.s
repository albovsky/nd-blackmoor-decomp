# FUN_00406ff6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406ff6
# extent:       0x00406ff6-0x0040703d (71 code bytes)
# span:         0x00406ff6-0x0040703d (code 71, tables 0, padding 0)
# sha256:       7cbc243fad395df6e94eaec1f7bd52f716eaf84f5319bc5a02e54f4b64f7d16d
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406ff6_toggle_5e3582
# naming:       native port src/original_methods_fl37.c:m406ff6_toggle_5e3582 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3582; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x1e becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406ff6_toggle_5e3582 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406ff6 - 0x401000
.globl FUN_00406ff6
FUN_00406ff6:
    # block 0x00406ff6: entry, 6 instruction(s), ends with jne to 0x00407012 (forward)
    push ebp                                     # 00406ff6
    {load} mov ebp, esp                          # 00406ff7
    push ecx                                     # 00406ff9
    mov dword ptr [ebp - local_4], ecx           # 00406ffa
    cmp dword ptr [0x5e3582], 0x1                # 00406ffd
    jne.d8 L_00407012                            # 00407004
    # block 0x00407006: entered by fall-through of jne at 0x00407004, 2 instruction(s), ends with forward jump to 0x00407031
    mov dword ptr [0x5e3582], 0x0                # 00407006
    jmp.d8 L_00407031                            # 00407010
L_00407012:
    # block 0x00407012: entered by jne at 0x00407004, 4 instruction(s), ends with jne to 0x00407031 (forward)
    mov dword ptr [0x5e3582], 0x1                # 00407012
    movsx eax, word ptr [0x5e335e]               # 0040701c
    cmp eax, 0x1e                                # 00407023
    jne.d8 L_00407031                            # 00407026
    # block 0x00407028: entered by fall-through of jne at 0x00407026, 1 instruction(s), falls into the block at 0x00407031
    mov word ptr [0x5e335e], 0xffff              # 00407028
L_00407031:
    # block 0x00407031: entered by jmp at 0x00407010; jne at 0x00407026, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407031
    call FUN_00404be1                            # 00407034
    {load} mov esp, ebp                          # 00407039
    pop ebp                                      # 0040703b
    ret                                          # 0040703c

