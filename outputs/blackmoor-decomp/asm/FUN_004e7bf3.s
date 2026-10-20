# FUN_004e7bf3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7bf3
# extent:       0x004e7bf3-0x004e7c72 (127 code bytes)
# span:         0x004e7bf3-0x004e7c72 (code 127, tables 0, padding 0)
# sha256:       5fbce2fd569dcb623fc311abd29a4ff9f7de9b68b5829e3e4b53854f3b39ce67
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7bf3_close_slots
# naming:       native port src/original_methods_fl18.c:m4e7bf3_close_slots (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4e7bf3_close_slots. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 127 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_822e; [ecx + n] field_7012, field_7654, field_822e; [edx + n] field_822e
# callees:      calls FUN_004e1d34, FUN_004e7ba7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl18.c:m4e7bf3_close_slots (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 33 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_7012, 0x7012  # offset +0x7012
.equ field_7654, 0x7654  # offset +0x7654
.equ field_822e, 0x822e  # offset +0x822e

# --- external targets -----------------------------------------------
.set FUN_004e1d34, .text + (0x004e1d34 - 0x401000)
.set FUN_004e7ba7, .text + (0x004e7ba7 - 0x401000)

.org 0x004e7bf3 - 0x401000
.globl FUN_004e7bf3
FUN_004e7bf3:
    # block 0x004e7bf3: entry, 7 instruction(s), ends with forward jump to 0x004e7c1e
    push ebp                                     # 004e7bf3
    {load} mov ebp, esp                          # 004e7bf4
    push ecx                                     # 004e7bf6
    mov dword ptr [ebp - local_4], ecx           # 004e7bf7
    mov eax, dword ptr [ebp - local_4]           # 004e7bfa
    mov dword ptr [eax + field_822e], 0x0        # 004e7bfd
    jmp.d8 L_004e7c1e                            # 004e7c07
L_004e7c09:
    # block 0x004e7c09: entered by jmp at 0x004e7c64, 5 instruction(s), falls into the block at 0x004e7c1e
    mov ecx, dword ptr [ebp - local_4]           # 004e7c09
    mov edx, dword ptr [ecx + field_822e]        # 004e7c0c
    add edx, 0x1                                 # 004e7c12
    mov eax, dword ptr [ebp - local_4]           # 004e7c15
    mov dword ptr [eax + field_822e], edx        # 004e7c18
L_004e7c1e:
    # block 0x004e7c1e: entered by jmp at 0x004e7c07, 3 instruction(s), ends with jge to 0x004e7c66 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e7c1e
    cmp dword ptr [ecx + field_822e], 0x6        # 004e7c21
    jge.d8 L_004e7c66                            # 004e7c28
    # block 0x004e7c2a: entered by fall-through of jge at 0x004e7c28, 6 instruction(s), ends with je to 0x004e7c64 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e7c2a
    mov eax, dword ptr [edx + field_822e]        # 004e7c2d
    imul eax, eax, 0xf7                          # 004e7c33
    mov ecx, dword ptr [ebp - local_4]           # 004e7c39
    cmp dword ptr [ecx + eax + field_7012], 0x0  # 004e7c3c
    je.d8 L_004e7c64                             # 004e7c44
    # block 0x004e7c46: entered by fall-through of je at 0x004e7c44, 6 instruction(s), calls FUN_004e1d34, falls into the block at 0x004e7c64
    mov edx, dword ptr [ebp - local_4]           # 004e7c46
    mov eax, dword ptr [edx + field_822e]        # 004e7c49
    imul eax, eax, 0x18f                         # 004e7c4f
    mov ecx, dword ptr [ebp - local_4]           # 004e7c55
    lea ecx, [ecx + eax + field_7654]            # 004e7c58
    call FUN_004e1d34                            # 004e7c5f
L_004e7c64:
    # block 0x004e7c64: entered by je at 0x004e7c44, 1 instruction(s), ends with backward jump to 0x004e7c09
    jmp.d8 L_004e7c09                            # 004e7c64
L_004e7c66:
    # block 0x004e7c66: entered by jge at 0x004e7c28, 5 instruction(s), calls FUN_004e7ba7, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004e7c66
    call FUN_004e7ba7                            # 004e7c69
    {load} mov esp, ebp                          # 004e7c6e
    pop ebp                                      # 004e7c70
    ret                                          # 004e7c71

