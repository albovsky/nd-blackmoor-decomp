# FUN_004455b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004455b8
# extent:       0x004455b8-0x004456e1 (297 code bytes)
# span:         0x004455b8-0x004456e1 (code 297, tables 0, padding 0)
# sha256:       b885a0e5d6591615fe3f525e3179f88a3c4c36551c85d0a8df367723e8e30eed
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4455b8_lifted
# naming:       native port src/original_methods_fl40.c:m4455b8_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 6 seeds; oracle: 75/75 instructions executed, 6/6 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       15 ebp-relative slot(s): local_4, local_9, local_a, local_c, local_10, local_14, local_18, local_1a, local_1c, local_1e, local_20, local_42 and 3 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50, FUN_0043f210, FUN_0041fd08
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4455b8_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 75 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_9, 0x9  # offset -0x9
.equ local_a, 0xa  # offset -0xa
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_1e, 0x1e  # offset -0x1e
.equ local_20, 0x20  # offset -0x20
.equ local_42, 0x42  # offset -0x42
.equ local_1d2, 0x1d2  # offset -0x1d2
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ local_1dc, 0x1dc  # offset -0x1dc

# --- external targets -----------------------------------------------
.set FUN_0041fd08, .text + (0x0041fd08 - 0x401000)
.set FUN_0043f210, .text + (0x0043f210 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004455b8 - 0x401000
.globl FUN_004455b8
FUN_004455b8:
    # block 0x004455b8: entry, 38 instruction(s), calls FUN_0050cd50, FUN_0043f210, ends with je to 0x0044564e (forward)
    push ebp                                     # 004455b8
    {load} mov ebp, esp                          # 004455b9
    sub esp, 0x1dc                               # 004455bb
    push esi                                     # 004455c1
    push edi                                     # 004455c2
    call FUN_0050cd50                            # 004455c3
    cdq                                          # 004455c8
    mov ecx, 0x3                                 # 004455c9
    idiv ecx                                     # 004455ce
    mov word ptr [ebp - local_4], dx             # 004455d0
    push 0x5481b8                                # 004455d4
    push 0x63a82c                                # 004455d9
    lea edx, [ebp - local_1d2]                   # 004455de
    push edx                                     # 004455e4
    call FUN_0043f210                            # 004455e5
    add esp, 0xc                                 # 004455ea
    mov edi, 0x5481c0                            # 004455ed
    lea edx, [ebp - local_42]                    # 004455f2
    or ecx, -0x1                                 # 004455f5
    {load} xor eax, eax                          # 004455f8
    repne scasb al, byte ptr es:[edi]            # 004455fa
    not ecx                                      # 004455fc
    {load} sub edi, ecx                          # 004455fe
    {load} mov esi, edi                          # 00445600
    {load} mov eax, ecx                          # 00445602
    {load} mov edi, edx                          # 00445604
    shr ecx, 0x2                                 # 00445606
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00445609
    {load} mov ecx, eax                          # 0044560b
    and ecx, 0x3                                 # 0044560d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00445610
    mov dword ptr [ebp - local_18], 0x0          # 00445612
    mov dword ptr [ebp - local_14], 0x0          # 00445619
    mov dword ptr [ebp - local_10], 0x1          # 00445620
    movsx ecx, word ptr [ebp - local_4]          # 00445627
    mov dword ptr [ebp - local_1dc], ecx         # 0044562b
    cmp dword ptr [ebp - local_1dc], 0x0         # 00445631
    je.d8 L_0044564e                             # 00445638
    # block 0x0044563a: entered by fall-through of je at 0x00445638, 2 instruction(s), ends with je to 0x00445678 (forward)
    cmp dword ptr [ebp - local_1dc], 0x1         # 0044563a
    je.d8 L_00445678                             # 00445641
    # block 0x00445643: entered by fall-through of je at 0x00445641, 2 instruction(s), ends with je to 0x004456a2 (forward)
    cmp dword ptr [ebp - local_1dc], 0x2         # 00445643
    je.d8 L_004456a2                             # 0044564a
    # block 0x0044564c: entered by fall-through of je at 0x0044564a, 1 instruction(s), ends with forward jump to 0x004456ca
    jmp.d8 L_004456ca                            # 0044564c
L_0044564e:
    # block 0x0044564e: entered by je at 0x00445638, 8 instruction(s), ends with forward jump to 0x004456ca
    mov word ptr [ebp - local_20], 0x4a6         # 0044564e
    mov word ptr [ebp - local_1e], 0x0           # 00445654
    mov word ptr [ebp - local_1c], 0x0           # 0044565a
    mov word ptr [ebp - local_1a], 0x1           # 00445660
    mov word ptr [ebp - local_c], 0xffff         # 00445666
    mov byte ptr [ebp - local_a], 0x0            # 0044566c
    mov word ptr [ebp - local_9], 0x2            # 00445670
    jmp.d8 L_004456ca                            # 00445676
L_00445678:
    # block 0x00445678: entered by je at 0x00445641, 8 instruction(s), ends with forward jump to 0x004456ca
    mov word ptr [ebp - local_20], 0x4a7         # 00445678
    mov word ptr [ebp - local_1e], 0x0           # 0044567e
    mov word ptr [ebp - local_1c], 0x0           # 00445684
    mov word ptr [ebp - local_1a], 0x1           # 0044568a
    mov word ptr [ebp - local_c], 0xffff         # 00445690
    mov byte ptr [ebp - local_a], 0x0            # 00445696
    mov word ptr [ebp - local_9], 0x2            # 0044569a
    jmp.d8 L_004456ca                            # 004456a0
L_004456a2:
    # block 0x004456a2: entered by je at 0x0044564a, 7 instruction(s), falls into the block at 0x004456ca
    mov word ptr [ebp - local_20], 0x4a8         # 004456a2
    mov word ptr [ebp - local_1e], 0x0           # 004456a8
    mov word ptr [ebp - local_1c], 0x0           # 004456ae
    mov word ptr [ebp - local_1a], 0x1           # 004456b4
    mov word ptr [ebp - local_c], 0xffff         # 004456ba
    mov byte ptr [ebp - local_a], 0x0            # 004456c0
    mov word ptr [ebp - local_9], 0x2            # 004456c4
L_004456ca:
    # block 0x004456ca: entered by jmp at 0x0044564c; jmp at 0x00445676; jmp at 0x004456a0, 9 instruction(s), calls FUN_0041fd08, ends with ret
    lea edx, [ebp - local_1d8]                   # 004456ca
    push edx                                     # 004456d0
    mov ecx, 0x6177e8                            # 004456d1
    call FUN_0041fd08                            # 004456d6
    pop edi                                      # 004456db
    pop esi                                      # 004456dc
    {load} mov esp, ebp                          # 004456dd
    pop ebp                                      # 004456df
    ret                                          # 004456e0

