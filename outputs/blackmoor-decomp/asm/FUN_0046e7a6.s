# FUN_0046e7a6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e7a6
# extent:       0x0046e7a6-0x0046e7ef (73 code bytes)
# span:         0x0046e7a6-0x0046e7ef (code 73, tables 0, padding 0)
# sha256:       32e2f000eac7dc8fcf06542a615b7b90b59b3aab16293832adac15722d95f70a
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46e7a6_release_surface_call_tail
# naming:       native port src/original_methods_fl38a.c:m46e7a6_release_surface_call_tail (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4c2dfb(this+0x20) if dword [this+0x20] is set, 0x4d3992(word [this+0x1c]) if not -1, then 0x46e6c1(this). 26/26 instructions, 4/4 branch directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0046e6c1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m46e7a6_release_surface_call_tail (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0046e6c1, .text + (0x0046e6c1 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0046e7a6 - 0x401000
.globl FUN_0046e7a6
FUN_0046e7a6:
    # block 0x0046e7a6: entry, 7 instruction(s), ends with je to 0x0046e7c7 (forward)
    push ebp                                     # 0046e7a6
    {load} mov ebp, esp                          # 0046e7a7
    push ecx                                     # 0046e7a9
    mov dword ptr [ebp - local_4], ecx           # 0046e7aa
    mov eax, dword ptr [ebp - local_4]           # 0046e7ad
    cmp dword ptr [eax + field_20], 0x0          # 0046e7b0
    je.d8 L_0046e7c7                             # 0046e7b4
    # block 0x0046e7b6: entered by fall-through of je at 0x0046e7b4, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0046e7c7
    mov ecx, dword ptr [ebp - local_4]           # 0046e7b6
    add ecx, 0x20                                # 0046e7b9
    push ecx                                     # 0046e7bc
    mov ecx, 0x5cf659                            # 0046e7bd
    call FUN_004c2dfb                            # 0046e7c2
L_0046e7c7:
    # block 0x0046e7c7: entered by je at 0x0046e7b4, 4 instruction(s), ends with je to 0x0046e7e3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046e7c7
    movsx eax, word ptr [edx + field_1c]         # 0046e7ca
    cmp eax, -0x1                                # 0046e7ce
    je.d8 L_0046e7e3                             # 0046e7d1
    # block 0x0046e7d3: entered by fall-through of je at 0x0046e7d1, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0046e7e3
    mov ecx, dword ptr [ebp - local_4]           # 0046e7d3
    mov dx, word ptr [ecx + field_1c]            # 0046e7d6
    push edx                                     # 0046e7da
    call FUN_004d3992                            # 0046e7db
    add esp, 0x4                                 # 0046e7e0
L_0046e7e3:
    # block 0x0046e7e3: entered by je at 0x0046e7d1, 5 instruction(s), calls FUN_0046e6c1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0046e7e3
    call FUN_0046e6c1                            # 0046e7e6
    {load} mov esp, ebp                          # 0046e7eb
    pop ebp                                      # 0046e7ed
    ret                                          # 0046e7ee

