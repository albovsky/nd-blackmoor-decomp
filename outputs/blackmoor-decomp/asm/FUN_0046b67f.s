# FUN_0046b67f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b67f
# extent:       0x0046b67f-0x0046b707 (136 code bytes)
# span:         0x0046b67f-0x0046b707 (code 136, tables 0, padding 0)
# sha256:       482464ae3c5272148ae183205ab3e4ddda89027922e631099475e9af6ab6a609
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46b67f_lifted
# naming:       native port src/original_methods_fl40.c:m46b67f_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 38/38 instructions executed, 6/6 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_4a40; [ecx + n] field_4a40; [edx + n] field_1c, field_4a44
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0046b58a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46b67f_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_4a40, 0x4a40  # offset +0x4a40
.equ field_4a44, 0x4a44  # offset +0x4a44

# --- external targets -----------------------------------------------
.set FUN_0046b58a, .text + (0x0046b58a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0046b67f - 0x401000
.globl FUN_0046b67f
FUN_0046b67f:
    # block 0x0046b67f: entry, 7 instruction(s), ends with je to 0x0046b6a6 (forward)
    push ebp                                     # 0046b67f
    {load} mov ebp, esp                          # 0046b680
    push ecx                                     # 0046b682
    mov dword ptr [ebp - local_4], ecx           # 0046b683
    mov eax, dword ptr [ebp - local_4]           # 0046b686
    cmp dword ptr [eax + field_4a40], 0x0        # 0046b689
    je.d8 L_0046b6a6                             # 0046b690
    # block 0x0046b692: entered by fall-through of je at 0x0046b690, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0046b6a6
    mov ecx, dword ptr [ebp - local_4]           # 0046b692
    add ecx, 0x4a40                              # 0046b695
    push ecx                                     # 0046b69b
    mov ecx, 0x5cf659                            # 0046b69c
    call FUN_004c2dfb                            # 0046b6a1
L_0046b6a6:
    # block 0x0046b6a6: entered by je at 0x0046b690, 3 instruction(s), ends with je to 0x0046b6c5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046b6a6
    cmp dword ptr [edx + field_4a44], 0x0        # 0046b6a9
    je.d8 L_0046b6c5                             # 0046b6b0
    # block 0x0046b6b2: entered by fall-through of je at 0x0046b6b0, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0046b6c5
    mov eax, dword ptr [ebp - local_4]           # 0046b6b2
    add eax, 0x4a44                              # 0046b6b5
    push eax                                     # 0046b6ba
    mov ecx, 0x5cf659                            # 0046b6bb
    call FUN_004c2dfb                            # 0046b6c0
L_0046b6c5:
    # block 0x0046b6c5: entered by je at 0x0046b6b0, 8 instruction(s), ends with je to 0x0046b6fb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046b6c5
    mov dword ptr [ecx + field_4a40], 0x0        # 0046b6c8
    mov edx, dword ptr [ebp - local_4]           # 0046b6d2
    mov dword ptr [edx + field_4a44], 0x0        # 0046b6d5
    mov eax, dword ptr [ebp - local_4]           # 0046b6df
    movsx ecx, word ptr [eax + field_1c]         # 0046b6e2
    cmp ecx, -0x1                                # 0046b6e6
    je.d8 L_0046b6fb                             # 0046b6e9
    # block 0x0046b6eb: entered by fall-through of je at 0x0046b6e9, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0046b6fb
    mov edx, dword ptr [ebp - local_4]           # 0046b6eb
    mov ax, word ptr [edx + field_1c]            # 0046b6ee
    push eax                                     # 0046b6f2
    call FUN_004d3992                            # 0046b6f3
    add esp, 0x4                                 # 0046b6f8
L_0046b6fb:
    # block 0x0046b6fb: entered by je at 0x0046b6e9, 5 instruction(s), calls FUN_0046b58a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0046b6fb
    call FUN_0046b58a                            # 0046b6fe
    {load} mov esp, ebp                          # 0046b703
    pop ebp                                      # 0046b705
    ret                                          # 0046b706

