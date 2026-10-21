# FUN_00407303
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407303
# extent:       0x00407303-0x0040734a (71 code bytes)
# span:         0x00407303-0x0040734a (code 71, tables 0, padding 0)
# sha256:       0a480393c63cfb0e61742cc577b4c68f4c25a56023469ff2dc8b9cd85bf84783
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407303_toggle_5e35ae
# naming:       native port src/original_methods_fl37.c:m407303_toggle_5e35ae (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the flag at 0x5e35ae; when it was not 1 it becomes 1 and the word 0x5e335e equal to 0x29 becomes 0xffff; then calls 0x404be1; all 18 instructions run, all four jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl37.c:m407303_toggle_5e35ae (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407303 - 0x401000
.globl FUN_00407303
FUN_00407303:
    # block 0x00407303: entry, 6 instruction(s), ends with jne to 0x0040731f (forward)
    push ebp                                     # 00407303
    {load} mov ebp, esp                          # 00407304
    push ecx                                     # 00407306
    mov dword ptr [ebp - local_4], ecx           # 00407307
    cmp dword ptr [0x5e35ae], 0x1                # 0040730a
    jne.d8 L_0040731f                            # 00407311
    # block 0x00407313: entered by fall-through of jne at 0x00407311, 2 instruction(s), ends with forward jump to 0x0040733e
    mov dword ptr [0x5e35ae], 0x0                # 00407313
    jmp.d8 L_0040733e                            # 0040731d
L_0040731f:
    # block 0x0040731f: entered by jne at 0x00407311, 4 instruction(s), ends with jne to 0x0040733e (forward)
    mov dword ptr [0x5e35ae], 0x1                # 0040731f
    movsx eax, word ptr [0x5e335e]               # 00407329
    cmp eax, 0x29                                # 00407330
    jne.d8 L_0040733e                            # 00407333
    # block 0x00407335: entered by fall-through of jne at 0x00407333, 1 instruction(s), falls into the block at 0x0040733e
    mov word ptr [0x5e335e], 0xffff              # 00407335
L_0040733e:
    # block 0x0040733e: entered by jmp at 0x0040731d; jne at 0x00407333, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0040733e
    call FUN_00404be1                            # 00407341
    {load} mov esp, ebp                          # 00407346
    pop ebp                                      # 00407348
    ret                                          # 00407349

