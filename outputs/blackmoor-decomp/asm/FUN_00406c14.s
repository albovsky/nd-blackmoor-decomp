# FUN_00406c14
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406c14
# extent:       0x00406c14-0x00406c5b (71 code bytes)
# span:         0x00406c14-0x00406c5b (code 71, tables 0, padding 0)
# sha256:       cd4dad786d2891a86969847c2a28ff1b62bfec53548ea5da55029dcd23700bf6
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406c14_toggle_5e354a
# naming:       native port src/original_methods_fl37.c:m406c14_toggle_5e354a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e354a; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x10 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406c14_toggle_5e354a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406c14 - 0x401000
.globl FUN_00406c14
FUN_00406c14:
    # block 0x00406c14: entry, 6 instruction(s), ends with jne to 0x00406c30 (forward)
    push ebp                                     # 00406c14
    {load} mov ebp, esp                          # 00406c15
    push ecx                                     # 00406c17
    mov dword ptr [ebp - local_4], ecx           # 00406c18
    cmp dword ptr [0x5e354a], 0x1                # 00406c1b
    jne.d8 L_00406c30                            # 00406c22
    # block 0x00406c24: entered by fall-through of jne at 0x00406c22, 2 instruction(s), ends with forward jump to 0x00406c4f
    mov dword ptr [0x5e354a], 0x0                # 00406c24
    jmp.d8 L_00406c4f                            # 00406c2e
L_00406c30:
    # block 0x00406c30: entered by jne at 0x00406c22, 4 instruction(s), ends with jne to 0x00406c4f (forward)
    mov dword ptr [0x5e354a], 0x1                # 00406c30
    movsx eax, word ptr [0x5e335e]               # 00406c3a
    cmp eax, 0x10                                # 00406c41
    jne.d8 L_00406c4f                            # 00406c44
    # block 0x00406c46: entered by fall-through of jne at 0x00406c44, 1 instruction(s), falls into the block at 0x00406c4f
    mov word ptr [0x5e335e], 0xffff              # 00406c46
L_00406c4f:
    # block 0x00406c4f: entered by jmp at 0x00406c2e; jne at 0x00406c44, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406c4f
    call FUN_00404be1                            # 00406c52
    {load} mov esp, ebp                          # 00406c57
    pop ebp                                      # 00406c59
    ret                                          # 00406c5a

