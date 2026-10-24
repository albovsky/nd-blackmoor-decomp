# FUN_004f572b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f572b
# extent:       0x004f572b-0x004f57e3 (184 code bytes)
# span:         0x004f572b-0x004f57e3 (code 184, tables 0, padding 0)
# sha256:       8d3e40005efc62cb720f958244f331966d60f930cc4ef78c6afdbf6feca43b2e
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f572b_lifted
# naming:       native port src/original_methods_fl41.c:m4f572b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 12 seeds; oracle: 47/47 instructions, 8/8 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_162, field_18a, field_19a; [ecx + n] field_18e, field_3ce; [edx + n] field_3ce
# callees:      calls FUN_004f8157, FUN_004f57e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4f572b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 47 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_162, 0x162  # offset +0x162
.equ field_18a, 0x18a  # offset +0x18a
.equ field_18e, 0x18e  # offset +0x18e
.equ field_19a, 0x19a  # offset +0x19a
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f57e3, .text + (0x004f57e3 - 0x401000)
.set FUN_004f8157, .text + (0x004f8157 - 0x401000)

.org 0x004f572b - 0x401000
.globl FUN_004f572b
FUN_004f572b:
    # block 0x004f572b: entry, 6 instruction(s), ends with forward jump to 0x004f5746
    push ebp                                     # 004f572b
    {load} mov ebp, esp                          # 004f572c
    sub esp, 0x8                                 # 004f572e
    mov dword ptr [ebp - local_8], ecx           # 004f5731
    mov dword ptr [ebp - local_4], 0x0           # 004f5734
    jmp.d8 L_004f5746                            # 004f573b
L_004f573d:
    # block 0x004f573d: entered by jmp at 0x004f57d5, 3 instruction(s), falls into the block at 0x004f5746
    mov eax, dword ptr [ebp - local_4]           # 004f573d
    add eax, 0x1                                 # 004f5740
    mov dword ptr [ebp - local_4], eax           # 004f5743
L_004f5746:
    # block 0x004f5746: entered by jmp at 0x004f573b, 2 instruction(s), ends with jge to 0x004f57da (forward)
    cmp dword ptr [ebp - local_4], 0x20          # 004f5746
    jge.d32 L_004f57da                           # 004f574a
    # block 0x004f5750: entered by fall-through of jge at 0x004f574a, 6 instruction(s), ends with je to 0x004f57d5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f5750
    imul ecx, ecx, 0x5bb                         # 004f5753
    mov edx, dword ptr [ebp - local_8]           # 004f5759
    mov eax, dword ptr [edx + field_3ce]         # 004f575c
    cmp dword ptr [eax + ecx + field_162], 0x0   # 004f5762
    je.d8 L_004f57d5                             # 004f576a
    # block 0x004f576c: entered by fall-through of je at 0x004f576a, 6 instruction(s), ends with jne to 0x004f57d5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f576c
    imul ecx, ecx, 0x5bb                         # 004f576f
    mov edx, dword ptr [ebp - local_8]           # 004f5775
    mov eax, dword ptr [edx + field_3ce]         # 004f5778
    cmp dword ptr [eax + ecx + field_19a], -0x1  # 004f577e
    jne.d8 L_004f57d5                            # 004f5786
    # block 0x004f5788: entered by fall-through of jne at 0x004f5786, 6 instruction(s), ends with je to 0x004f57d5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f5788
    imul ecx, ecx, 0x5bb                         # 004f578b
    mov edx, dword ptr [ebp - local_8]           # 004f5791
    mov eax, dword ptr [edx + field_3ce]         # 004f5794
    cmp dword ptr [eax + ecx + field_18a], 0x0   # 004f579a
    je.d8 L_004f57d5                             # 004f57a2
    # block 0x004f57a4: entered by fall-through of je at 0x004f57a2, 13 instruction(s), calls FUN_004f8157, FUN_004f57e3, falls into the block at 0x004f57d5
    mov ecx, dword ptr [ebp - local_4]           # 004f57a4
    push ecx                                     # 004f57a7
    mov ecx, dword ptr [ebp - local_8]           # 004f57a8
    call FUN_004f8157                            # 004f57ab
    mov edx, dword ptr [ebp - local_4]           # 004f57b0
    imul edx, edx, 0x5bb                         # 004f57b3
    mov ecx, dword ptr [ebp - local_8]           # 004f57b9
    mov ecx, dword ptr [ecx + field_3ce]         # 004f57bc
    mov dword ptr [ecx + edx + field_18e], eax   # 004f57c2
    mov edx, dword ptr [ebp - local_4]           # 004f57c9
    push edx                                     # 004f57cc
    mov ecx, dword ptr [ebp - local_8]           # 004f57cd
    call FUN_004f57e3                            # 004f57d0
L_004f57d5:
    # block 0x004f57d5: entered by je at 0x004f576a; jne at 0x004f5786; je at 0x004f57a2, 1 instruction(s), ends with backward jump to 0x004f573d
    jmp.d32 L_004f573d                           # 004f57d5
L_004f57da:
    # block 0x004f57da: entered by jge at 0x004f574a, 4 instruction(s), ends with ret
    mov eax, 0x1                                 # 004f57da
    {load} mov esp, ebp                          # 004f57df
    pop ebp                                      # 004f57e1
    ret                                          # 004f57e2

