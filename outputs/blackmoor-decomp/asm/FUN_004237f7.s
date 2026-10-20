# FUN_004237f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004237f7
# extent:       0x004237f7-0x00423876 (127 code bytes)
# span:         0x004237f7-0x00423876 (code 127, tables 0, padding 0)
# sha256:       f1e73a6a1eb4b55fedf041b25dba6f7dc181325dcabe7c9fb0d959479692a084
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4237f7_new_block
# naming:       native port src/original_methods_fl28a.c:m4237f7_new_block (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4237f7_new_block: the oracle runs every instruction of 0x4237f7..0x423876 and both jump directions, comparing ordered host calls and memory. See tasks/fl28a-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28a.c:fatal_tail (function ledger class native_oracle_verified; also m4237f7_new_block, new_block; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 41 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004237f7 - 0x401000
.globl FUN_004237f7
FUN_004237f7:
    # block 0x004237f7: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x0042382e (forward)
    push ebp                                     # 004237f7
    {load} mov ebp, esp                          # 004237f8
    sub esp, 0xc                                 # 004237fa
    push edi                                     # 004237fd
    mov dword ptr [ebp - local_c], ecx           # 004237fe
    push 0x4c                                    # 00423801
    call FUN_0051dc43                            # 00423803
    add esp, 0x4                                 # 00423808
    mov dword ptr [ebp - local_8], eax           # 0042380b
    mov eax, dword ptr [ebp - local_8]           # 0042380e
    mov dword ptr [ebp - local_4], eax           # 00423811
    cmp dword ptr [ebp - local_4], 0x0           # 00423814
    jne.d8 L_0042382e                            # 00423818
    # block 0x0042381a: entered by fall-through of jne at 0x00423818, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x0042386f
    push 0x5446e0                                # 0042381a
    push 0x63888b                                # 0042381f
    call FUN_0050ca3e                            # 00423824
    add esp, 0x8                                 # 00423829
    jmp.d8 L_0042386f                            # 0042382c
L_0042382e:
    # block 0x0042382e: entered by jne at 0x00423818, 6 instruction(s), ends with forward jump to 0x00423871
    mov ecx, 0x13                                # 0042382e
    {load} xor eax, eax                          # 00423833
    mov edi, dword ptr [ebp - local_4]           # 00423835
    rep stosd dword ptr es:[edi], eax            # 00423838
    mov eax, dword ptr [ebp - local_4]           # 0042383a
    jmp.d8 L_00423871                            # 0042383d
L_0042383f:
    # block 0x0042383f: entered by jmp at 0x0042386f, 7 instruction(s), calls FUN_0052139c, ends with je to 0x00423865 (forward)
    push 0x0                                     # 0042383f
    push 0x0                                     # 00423841
    push 0x63888b                                # 00423843
    call FUN_0052139c                            # 00423848
    movsx ecx, word ptr [0x63a4cd]               # 0042384d
    test ecx, ecx                                # 00423854
    je.d8 L_00423865                             # 00423856
    # block 0x00423858: entered by fall-through of je at 0x00423856, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00423865
    push 0x63888b                                # 00423858
    call FUN_0044a2b7                            # 0042385d
    add esp, 0x4                                 # 00423862
L_00423865:
    # block 0x00423865: entered by je at 0x00423856, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x0042386f
    mov ecx, 0x5cf659                            # 00423865
    call FUN_004c97b4                            # 0042386a
L_0042386f:
    # block 0x0042386f: entered by jmp at 0x0042382c, 1 instruction(s), ends with backward jump to 0x0042383f
    jmp.d8 L_0042383f                            # 0042386f
L_00423871:
    # block 0x00423871: entered by jmp at 0x0042383d, 4 instruction(s), ends with ret
    pop edi                                      # 00423871
    {load} mov esp, ebp                          # 00423872
    pop ebp                                      # 00423874
    ret                                          # 00423875

