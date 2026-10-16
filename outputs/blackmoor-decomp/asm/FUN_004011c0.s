# FUN_004011c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004011c0
# extent:       0x004011c0-0x004011f7 (55 code bytes)
# span:         0x004011c0-0x004011f7 (code 55, tables 0, padding 0)
# sha256:       bcd41a8b4cc9ef3a36023b8c1053cc6d0578e7a63605fd3c1faeeebb12d12a99
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004011c0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004011f7, FUN_00401249, FUN_004013cc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004011f7, .text + (0x004011f7 - 0x401000)
.set FUN_00401249, .text + (0x00401249 - 0x401000)
.set FUN_004013cc, .text + (0x004013cc - 0x401000)

.org 0x004011c0 - 0x401000
.globl FUN_004011c0
FUN_004011c0:
    # block 0x004011c0: entry, 7 instruction(s), ends with je to 0x004011e0 (forward)
    push ebp                                     # 004011c0
    {load} mov ebp, esp                          # 004011c1
    push ecx                                     # 004011c3
    mov eax, dword ptr [0x5839ad]                # 004011c4
    mov dword ptr [ebp - local_4], eax           # 004011c9
    cmp dword ptr [ebp - local_4], 0x0           # 004011cc
    je.d8 L_004011e0                             # 004011d0
    # block 0x004011d2: entered by fall-through of je at 0x004011d0, 2 instruction(s), ends with je to 0x004011e7 (forward)
    cmp dword ptr [ebp - local_4], 0x1           # 004011d2
    je.d8 L_004011e7                             # 004011d6
    # block 0x004011d8: entered by fall-through of je at 0x004011d6, 2 instruction(s), ends with je to 0x004011ee (forward)
    cmp dword ptr [ebp - local_4], 0x2           # 004011d8
    je.d8 L_004011ee                             # 004011dc
    # block 0x004011de: entered by fall-through of je at 0x004011dc, 1 instruction(s), ends with forward jump to 0x004011f3
    jmp.d8 L_004011f3                            # 004011de
L_004011e0:
    # block 0x004011e0: entered by je at 0x004011d0, 2 instruction(s), calls FUN_004011f7, ends with forward jump to 0x004011f3
    call FUN_004011f7                            # 004011e0
    jmp.d8 L_004011f3                            # 004011e5
L_004011e7:
    # block 0x004011e7: entered by je at 0x004011d6, 2 instruction(s), calls FUN_00401249, ends with forward jump to 0x004011f3
    call FUN_00401249                            # 004011e7
    jmp.d8 L_004011f3                            # 004011ec
L_004011ee:
    # block 0x004011ee: entered by je at 0x004011dc, 1 instruction(s), calls FUN_004013cc, falls into the block at 0x004011f3
    call FUN_004013cc                            # 004011ee
L_004011f3:
    # block 0x004011f3: entered by jmp at 0x004011de; jmp at 0x004011e5; jmp at 0x004011ec, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004011f3
    pop ebp                                      # 004011f5
    ret                                          # 004011f6

