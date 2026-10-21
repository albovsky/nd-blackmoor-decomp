# FUN_004080fc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004080fc
# extent:       0x004080fc-0x0040812e (50 code bytes)
# span:         0x004080fc-0x0040812e (code 50, tables 0, padding 0)
# sha256:       cdcec65936625ccb0e586c7eca3ecb91cccd96f213d14301c71691a330e0ffc8
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4080fc_toggle_5ec28c
# naming:       native port src/original_methods_fl35b.c:m4080fc_toggle_5ec28c (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the signed 16-bit word at 0x5ec28c (non-zero becomes 0, zero becomes 1), then returns 0x407ca7(self). je taken both ways; all 15 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl35b.c:m4080fc_toggle_5ec28c (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00407ca7, .text + (0x00407ca7 - 0x401000)

.org 0x004080fc - 0x401000
.globl FUN_004080fc
FUN_004080fc:
    # block 0x004080fc: entry, 7 instruction(s), ends with je to 0x00408119 (forward)
    push ebp                                     # 004080fc
    {load} mov ebp, esp                          # 004080fd
    push ecx                                     # 004080ff
    mov dword ptr [ebp - local_4], ecx           # 00408100
    movsx eax, word ptr [0x5ec28c]               # 00408103
    test eax, eax                                # 0040810a
    je.d8 L_00408119                             # 0040810c
    # block 0x0040810e: entered by fall-through of je at 0x0040810c, 2 instruction(s), ends with forward jump to 0x00408122
    mov word ptr [0x5ec28c], 0x0                 # 0040810e
    jmp.d8 L_00408122                            # 00408117
L_00408119:
    # block 0x00408119: entered by je at 0x0040810c, 1 instruction(s), falls into the block at 0x00408122
    mov word ptr [0x5ec28c], 0x1                 # 00408119
L_00408122:
    # block 0x00408122: entered by jmp at 0x00408117, 5 instruction(s), calls FUN_00407ca7, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00408122
    call FUN_00407ca7                            # 00408125
    {load} mov esp, ebp                          # 0040812a
    pop ebp                                      # 0040812c
    ret                                          # 0040812d

