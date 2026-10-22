# FUN_00467608
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467608
# extent:       0x00467608-0x00467651 (73 code bytes)
# span:         0x00467608-0x00467651 (code 73, tables 0, padding 0)
# sha256:       126c9c35f960b62d41236e3206eac60ce064aa6af40e8f8d782261a08fc8db7f
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m467608_lifted
# naming:       native port src/original_methods_fl40.c:m467608_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 26/26 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [ecx + n] field_10; [edx + n] field_10
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00467513
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m467608_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00467513, .text + (0x00467513 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00467608 - 0x401000
.globl FUN_00467608
FUN_00467608:
    # block 0x00467608: entry, 7 instruction(s), ends with je to 0x00467629 (forward)
    push ebp                                     # 00467608
    {load} mov ebp, esp                          # 00467609
    push ecx                                     # 0046760b
    mov dword ptr [ebp - local_4], ecx           # 0046760c
    mov eax, dword ptr [ebp - local_4]           # 0046760f
    cmp dword ptr [eax + field_4], 0x0           # 00467612
    je.d8 L_00467629                             # 00467616
    # block 0x00467618: entered by fall-through of je at 0x00467616, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00467629
    mov ecx, dword ptr [ebp - local_4]           # 00467618
    add ecx, 0x4                                 # 0046761b
    push ecx                                     # 0046761e
    mov ecx, 0x5cf659                            # 0046761f
    call FUN_004c2dfb                            # 00467624
L_00467629:
    # block 0x00467629: entered by je at 0x00467616, 4 instruction(s), ends with je to 0x00467645 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467629
    movsx eax, word ptr [edx + field_10]         # 0046762c
    cmp eax, -0x1                                # 00467630
    je.d8 L_00467645                             # 00467633
    # block 0x00467635: entered by fall-through of je at 0x00467633, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00467645
    mov ecx, dword ptr [ebp - local_4]           # 00467635
    mov dx, word ptr [ecx + field_10]            # 00467638
    push edx                                     # 0046763c
    call FUN_004d3992                            # 0046763d
    add esp, 0x4                                 # 00467642
L_00467645:
    # block 0x00467645: entered by je at 0x00467633, 5 instruction(s), calls FUN_00467513, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00467645
    call FUN_00467513                            # 00467648
    {load} mov esp, ebp                          # 0046764d
    pop ebp                                      # 0046764f
    ret                                          # 00467650

