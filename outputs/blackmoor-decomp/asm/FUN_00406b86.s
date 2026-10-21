# FUN_00406b86
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406b86
# extent:       0x00406b86-0x00406bcd (71 code bytes)
# span:         0x00406b86-0x00406bcd (code 71, tables 0, padding 0)
# sha256:       8501977ff4ef36bd0549c6b87914f5072df5b98b9455a3dcabb16f28573a9db0
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406b86_toggle_5e3542
# naming:       native port src/original_methods_fl37.c:m406b86_toggle_5e3542 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3542; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0xe becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406b86_toggle_5e3542 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406b86 - 0x401000
.globl FUN_00406b86
FUN_00406b86:
    # block 0x00406b86: entry, 6 instruction(s), ends with jne to 0x00406ba2 (forward)
    push ebp                                     # 00406b86
    {load} mov ebp, esp                          # 00406b87
    push ecx                                     # 00406b89
    mov dword ptr [ebp - local_4], ecx           # 00406b8a
    cmp dword ptr [0x5e3542], 0x1                # 00406b8d
    jne.d8 L_00406ba2                            # 00406b94
    # block 0x00406b96: entered by fall-through of jne at 0x00406b94, 2 instruction(s), ends with forward jump to 0x00406bc1
    mov dword ptr [0x5e3542], 0x0                # 00406b96
    jmp.d8 L_00406bc1                            # 00406ba0
L_00406ba2:
    # block 0x00406ba2: entered by jne at 0x00406b94, 4 instruction(s), ends with jne to 0x00406bc1 (forward)
    mov dword ptr [0x5e3542], 0x1                # 00406ba2
    movsx eax, word ptr [0x5e335e]               # 00406bac
    cmp eax, 0xe                                 # 00406bb3
    jne.d8 L_00406bc1                            # 00406bb6
    # block 0x00406bb8: entered by fall-through of jne at 0x00406bb6, 1 instruction(s), falls into the block at 0x00406bc1
    mov word ptr [0x5e335e], 0xffff              # 00406bb8
L_00406bc1:
    # block 0x00406bc1: entered by jmp at 0x00406ba0; jne at 0x00406bb6, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406bc1
    call FUN_00404be1                            # 00406bc4
    {load} mov esp, ebp                          # 00406bc9
    pop ebp                                      # 00406bcb
    ret                                          # 00406bcc

