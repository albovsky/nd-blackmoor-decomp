# FUN_00406bcd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406bcd
# extent:       0x00406bcd-0x00406c14 (71 code bytes)
# span:         0x00406bcd-0x00406c14 (code 71, tables 0, padding 0)
# sha256:       21a4da378b9b9bf699a48f5153059371cc26d5200f7996a9483bb42e667f81d3
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m406bcd_toggle_5e3546
# naming:       native port src/original_methods_fl37.c:m406bcd_toggle_5e3546 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e3546; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0xf becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m406bcd_toggle_5e3546 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406bcd - 0x401000
.globl FUN_00406bcd
FUN_00406bcd:
    # block 0x00406bcd: entry, 6 instruction(s), ends with jne to 0x00406be9 (forward)
    push ebp                                     # 00406bcd
    {load} mov ebp, esp                          # 00406bce
    push ecx                                     # 00406bd0
    mov dword ptr [ebp - local_4], ecx           # 00406bd1
    cmp dword ptr [0x5e3546], 0x1                # 00406bd4
    jne.d8 L_00406be9                            # 00406bdb
    # block 0x00406bdd: entered by fall-through of jne at 0x00406bdb, 2 instruction(s), ends with forward jump to 0x00406c08
    mov dword ptr [0x5e3546], 0x0                # 00406bdd
    jmp.d8 L_00406c08                            # 00406be7
L_00406be9:
    # block 0x00406be9: entered by jne at 0x00406bdb, 4 instruction(s), ends with jne to 0x00406c08 (forward)
    mov dword ptr [0x5e3546], 0x1                # 00406be9
    movsx eax, word ptr [0x5e335e]               # 00406bf3
    cmp eax, 0xf                                 # 00406bfa
    jne.d8 L_00406c08                            # 00406bfd
    # block 0x00406bff: entered by fall-through of jne at 0x00406bfd, 1 instruction(s), falls into the block at 0x00406c08
    mov word ptr [0x5e335e], 0xffff              # 00406bff
L_00406c08:
    # block 0x00406c08: entered by jmp at 0x00406be7; jne at 0x00406bfd, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406c08
    call FUN_00404be1                            # 00406c0b
    {load} mov esp, ebp                          # 00406c10
    pop ebp                                      # 00406c12
    ret                                          # 00406c13

