# FUN_00458dce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00458dce
# extent:       0x00458dce-0x00458e55 (135 code bytes)
# span:         0x00458dce-0x00458e55 (code 135, tables 0, padding 0)
# sha256:       647bdae6ec81cc597f15318314728a7c2fcf3b3de0b1a55425a901380b763e74
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m458dce_lifted
# naming:       native port src/original_methods_fl40.c:m458dce_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 7 seeds; oracle 37/37 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_26, field_f1; [ecx + n] field_f1, field_4c5; [edx + n] field_21
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m458dce_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_21, 0x21  # offset +0x21
.equ field_26, 0x26  # offset +0x26
.equ field_f1, 0xf1  # offset +0xf1
.equ field_4c5, 0x4c5  # offset +0x4c5

# --- external targets -----------------------------------------------

.org 0x00458dce - 0x401000
.globl FUN_00458dce
FUN_00458dce:
    # block 0x00458dce: entry, 13 instruction(s), ends with forward jump to 0x00458e0b
    push ebp                                     # 00458dce
    {load} mov ebp, esp                          # 00458dcf
    sub esp, 0xc                                 # 00458dd1
    mov dword ptr [ebp - local_c], ecx           # 00458dd4
    mov eax, dword ptr [ebp - local_c]           # 00458dd7
    movsx ecx, word ptr [eax + field_26]         # 00458dda
    imul ecx, ecx, 0x8d                          # 00458dde
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00458de4
    mov dword ptr [ebp - local_8], edx           # 00458dea
    mov eax, dword ptr [ebp - local_c]           # 00458ded
    mov word ptr [eax + field_f1], 0x0           # 00458df0
    mov dword ptr [ebp - local_4], 0x0           # 00458df9
    jmp.d8 L_00458e0b                            # 00458e00
L_00458e02:
    # block 0x00458e02: entered by jmp at 0x00458e4f, 3 instruction(s), falls into the block at 0x00458e0b
    mov ecx, dword ptr [ebp - local_4]           # 00458e02
    add ecx, 0x1                                 # 00458e05
    mov dword ptr [ebp - local_4], ecx           # 00458e08
L_00458e0b:
    # block 0x00458e0b: entered by jmp at 0x00458e00, 4 instruction(s), ends with jge to 0x00458e51 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00458e0b
    movsx eax, word ptr [edx + field_21]         # 00458e0e
    cmp dword ptr [ebp - local_4], eax           # 00458e12
    jge.d8 L_00458e51                            # 00458e15
    # block 0x00458e17: entered by fall-through of jge at 0x00458e15, 8 instruction(s), ends with je to 0x00458e4f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00458e17
    movsx edx, word ptr [2*ecx + 0x5a4bd6]       # 00458e1a
    add edx, 0x1                                 # 00458e22
    mov eax, dword ptr [ebp - local_4]           # 00458e25
    mov ecx, dword ptr [ebp - local_8]           # 00458e28
    movsx eax, word ptr [ecx + 2*eax + field_4c5] # 00458e2b
    {load} cmp edx, eax                          # 00458e33
    je.d8 L_00458e4f                             # 00458e35
    # block 0x00458e37: entered by fall-through of je at 0x00458e35, 5 instruction(s), falls into the block at 0x00458e4f
    mov ecx, dword ptr [ebp - local_c]           # 00458e37
    mov dx, word ptr [ecx + field_f1]            # 00458e3a
    add dx, 0x1                                  # 00458e41
    mov eax, dword ptr [ebp - local_c]           # 00458e45
    mov word ptr [eax + field_f1], dx            # 00458e48
L_00458e4f:
    # block 0x00458e4f: entered by je at 0x00458e35, 1 instruction(s), ends with backward jump to 0x00458e02
    jmp.d8 L_00458e02                            # 00458e4f
L_00458e51:
    # block 0x00458e51: entered by jge at 0x00458e15, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00458e51
    pop ebp                                      # 00458e53
    ret                                          # 00458e54

