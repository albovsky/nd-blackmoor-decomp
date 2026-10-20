# FUN_004e8dc8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e8dc8
# extent:       0x004e8dc8-0x004e8e78 (176 code bytes)
# span:         0x004e8dc8-0x004e8e78 (code 176, tables 0, padding 0)
# sha256:       f2866a0b62bc712f0e56fb52269899eb0289e03719f527243ef83d6898766cfe
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e8dc8_check_slots
# naming:       native port src/original_methods_fl18.c:m4e8dc8_check_slots (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4e8dc8_check_slots. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 176 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_7012, field_764c, field_7654, field_822e; [ecx + n] field_764c, field_822e; [edx + n] field_822e
# callees:      calls FUN_004ee517, FUN_004e26fc, FUN_004e8e78
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:inventory_view_pointer_event (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 48 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_7012, 0x7012  # offset +0x7012
.equ field_764c, 0x764c  # offset +0x764c
.equ field_7654, 0x7654  # offset +0x7654
.equ field_822e, 0x822e  # offset +0x822e

# --- external targets -----------------------------------------------
.set FUN_004e26fc, .text + (0x004e26fc - 0x401000)
.set FUN_004e8e78, .text + (0x004e8e78 - 0x401000)
.set FUN_004ee517, .text + (0x004ee517 - 0x401000)

.org 0x004e8dc8 - 0x401000
.globl FUN_004e8dc8
FUN_004e8dc8:
    # block 0x004e8dc8: entry, 7 instruction(s), ends with je to 0x004e8dec (forward)
    push ebp                                     # 004e8dc8
    {load} mov ebp, esp                          # 004e8dc9
    push ecx                                     # 004e8dcb
    mov dword ptr [ebp - local_4], ecx           # 004e8dcc
    mov eax, dword ptr [ebp - local_4]           # 004e8dcf
    cmp dword ptr [eax + field_764c], 0x2        # 004e8dd2
    je.d8 L_004e8dec                             # 004e8dd9
    # block 0x004e8ddb: entered by fall-through of je at 0x004e8dd9, 3 instruction(s), ends with je to 0x004e8dec (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e8ddb
    cmp dword ptr [ecx + field_764c], 0x3        # 004e8dde
    je.d8 L_004e8dec                             # 004e8de5
    # block 0x004e8de7: entered by fall-through of je at 0x004e8de5, 1 instruction(s), ends with forward jump to 0x004e8e74
    jmp.d32 L_004e8e74                           # 004e8de7
L_004e8dec:
    # block 0x004e8dec: entered by je at 0x004e8dd9; je at 0x004e8de5, 4 instruction(s), calls FUN_004ee517, ends with je to 0x004e8dfa (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e8dec
    call FUN_004ee517                            # 004e8def
    test eax, eax                                # 004e8df4
    je.d8 L_004e8dfa                             # 004e8df6
    # block 0x004e8df8: entered by fall-through of je at 0x004e8df6, 1 instruction(s), ends with forward jump to 0x004e8e74
    jmp.d8 L_004e8e74                            # 004e8df8
L_004e8dfa:
    # block 0x004e8dfa: entered by je at 0x004e8df6, 3 instruction(s), ends with forward jump to 0x004e8e1e
    mov edx, dword ptr [ebp - local_4]           # 004e8dfa
    mov dword ptr [edx + field_822e], 0x0        # 004e8dfd
    jmp.d8 L_004e8e1e                            # 004e8e07
L_004e8e09:
    # block 0x004e8e09: entered by jmp at 0x004e8e6a, 5 instruction(s), falls into the block at 0x004e8e1e
    mov eax, dword ptr [ebp - local_4]           # 004e8e09
    mov ecx, dword ptr [eax + field_822e]        # 004e8e0c
    add ecx, 0x1                                 # 004e8e12
    mov edx, dword ptr [ebp - local_4]           # 004e8e15
    mov dword ptr [edx + field_822e], ecx        # 004e8e18
L_004e8e1e:
    # block 0x004e8e1e: entered by jmp at 0x004e8e07, 3 instruction(s), ends with jge to 0x004e8e6c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e8e1e
    cmp dword ptr [eax + field_822e], 0x6        # 004e8e21
    jge.d8 L_004e8e6c                            # 004e8e28
    # block 0x004e8e2a: entered by fall-through of jge at 0x004e8e28, 6 instruction(s), ends with je to 0x004e8e6a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e8e2a
    mov edx, dword ptr [ecx + field_822e]        # 004e8e2d
    imul edx, edx, 0xf7                          # 004e8e33
    mov eax, dword ptr [ebp - local_4]           # 004e8e39
    cmp dword ptr [eax + edx + field_7012], 0x0  # 004e8e3c
    je.d8 L_004e8e6a                             # 004e8e44
    # block 0x004e8e46: entered by fall-through of je at 0x004e8e44, 8 instruction(s), calls FUN_004e26fc, ends with je to 0x004e8e6a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e8e46
    mov edx, dword ptr [ecx + field_822e]        # 004e8e49
    imul edx, edx, 0x18f                         # 004e8e4f
    mov eax, dword ptr [ebp - local_4]           # 004e8e55
    lea ecx, [eax + edx + field_7654]            # 004e8e58
    call FUN_004e26fc                            # 004e8e5f
    test eax, eax                                # 004e8e64
    je.d8 L_004e8e6a                             # 004e8e66
    # block 0x004e8e68: entered by fall-through of je at 0x004e8e66, 1 instruction(s), ends with forward jump to 0x004e8e74
    jmp.d8 L_004e8e74                            # 004e8e68
L_004e8e6a:
    # block 0x004e8e6a: entered by je at 0x004e8e44; je at 0x004e8e66, 1 instruction(s), ends with backward jump to 0x004e8e09
    jmp.d8 L_004e8e09                            # 004e8e6a
L_004e8e6c:
    # block 0x004e8e6c: entered by jge at 0x004e8e28, 2 instruction(s), calls FUN_004e8e78, falls into the block at 0x004e8e74
    mov ecx, dword ptr [ebp - local_4]           # 004e8e6c
    call FUN_004e8e78                            # 004e8e6f
L_004e8e74:
    # block 0x004e8e74: entered by jmp at 0x004e8de7; jmp at 0x004e8df8; jmp at 0x004e8e68, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e8e74
    pop ebp                                      # 004e8e76
    ret                                          # 004e8e77

