# FUN_0040769e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040769e
# extent:       0x0040769e-0x004076e5 (71 code bytes)
# span:         0x0040769e-0x004076e5 (code 71, tables 0, padding 0)
# sha256:       a2fdf1a2360884fdac3fd105261be332ecb05aac2cc3667301e67337651b4240
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40769e_toggle_5e35e2
# naming:       native port src/original_methods_fl37.c:m40769e_toggle_5e35e2 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35e2; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x36 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m40769e_toggle_5e35e2 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x0040769e - 0x401000
.globl FUN_0040769e
FUN_0040769e:
    # block 0x0040769e: entry, 6 instruction(s), ends with jne to 0x004076ba (forward)
    push ebp                                     # 0040769e
    {load} mov ebp, esp                          # 0040769f
    push ecx                                     # 004076a1
    mov dword ptr [ebp - local_4], ecx           # 004076a2
    cmp dword ptr [0x5e35e2], 0x1                # 004076a5
    jne.d8 L_004076ba                            # 004076ac
    # block 0x004076ae: entered by fall-through of jne at 0x004076ac, 2 instruction(s), ends with forward jump to 0x004076d9
    mov dword ptr [0x5e35e2], 0x0                # 004076ae
    jmp.d8 L_004076d9                            # 004076b8
L_004076ba:
    # block 0x004076ba: entered by jne at 0x004076ac, 4 instruction(s), ends with jne to 0x004076d9 (forward)
    mov dword ptr [0x5e35e2], 0x1                # 004076ba
    movsx eax, word ptr [0x5e335e]               # 004076c4
    cmp eax, 0x36                                # 004076cb
    jne.d8 L_004076d9                            # 004076ce
    # block 0x004076d0: entered by fall-through of jne at 0x004076ce, 1 instruction(s), falls into the block at 0x004076d9
    mov word ptr [0x5e335e], 0xffff              # 004076d0
L_004076d9:
    # block 0x004076d9: entered by jmp at 0x004076b8; jne at 0x004076ce, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004076d9
    call FUN_00404be1                            # 004076dc
    {load} mov esp, ebp                          # 004076e1
    pop ebp                                      # 004076e3
    ret                                          # 004076e4

