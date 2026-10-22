# FUN_0049c68a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c68a
# extent:       0x0049c68a-0x0049c889 (511 code bytes)
# span:         0x0049c68a-0x0049c889 (code 511, tables 0, padding 0)
# sha256:       03839be7b3c0caf9334a49a1aaf35b8f173bb54695992beea5e3184420139dd2
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49c68a_lifted
# naming:       native port src/original_methods_fl39d.c:m49c68a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (26 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_de0, field_de4, field_e30, field_e34, field_e3c, field_e40, field_e48; [ecx + n] field_de0, field_dec, field_e30, field_e38, field_e3c, field_e44, field_e48; [edx + n] field_de4, field_dec, field_e34, field_e38, field_e40, field_e44
# callees:      calls FUN_0051dc6c, FUN_0049c5f0
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m49c68a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 129 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ field_de0, 0xde0  # offset +0xde0
.equ field_de4, 0xde4  # offset +0xde4
.equ field_dec, 0xdec  # offset +0xdec
.equ field_e30, 0xe30  # offset +0xe30
.equ field_e34, 0xe34  # offset +0xe34
.equ field_e38, 0xe38  # offset +0xe38
.equ field_e3c, 0xe3c  # offset +0xe3c
.equ field_e40, 0xe40  # offset +0xe40
.equ field_e44, 0xe44  # offset +0xe44
.equ field_e48, 0xe48  # offset +0xe48

# --- external targets -----------------------------------------------
.set FUN_0049c5f0, .text + (0x0049c5f0 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0049c68a - 0x401000
.globl FUN_0049c68a
FUN_0049c68a:
    # block 0x0049c68a: entry, 7 instruction(s), ends with je to 0x0049c6c4 (forward)
    push ebp                                     # 0049c68a
    {load} mov ebp, esp                          # 0049c68b
    sub esp, 0x2c                                # 0049c68d
    mov dword ptr [ebp - local_2c], ecx          # 0049c690
    mov eax, dword ptr [ebp - local_2c]          # 0049c693
    cmp dword ptr [eax + field_de0], 0x0         # 0049c696
    je.d8 L_0049c6c4                             # 0049c69d
    # block 0x0049c69f: entered by fall-through of je at 0x0049c69d, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c6c4
    mov ecx, dword ptr [ebp - local_2c]          # 0049c69f
    mov edx, dword ptr [ecx + field_de0]         # 0049c6a2
    mov dword ptr [ebp - local_4], edx           # 0049c6a8
    mov eax, dword ptr [ebp - local_4]           # 0049c6ab
    push eax                                     # 0049c6ae
    call FUN_0051dc6c                            # 0049c6af
    add esp, 0x4                                 # 0049c6b4
    mov ecx, dword ptr [ebp - local_2c]          # 0049c6b7
    mov dword ptr [ecx + field_de0], 0x0         # 0049c6ba
L_0049c6c4:
    # block 0x0049c6c4: entered by je at 0x0049c69d, 3 instruction(s), ends with je to 0x0049c6f5 (forward)
    mov edx, dword ptr [ebp - local_2c]          # 0049c6c4
    cmp dword ptr [edx + field_de4], 0x0         # 0049c6c7
    je.d8 L_0049c6f5                             # 0049c6ce
    # block 0x0049c6d0: entered by fall-through of je at 0x0049c6ce, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c6f5
    mov eax, dword ptr [ebp - local_2c]          # 0049c6d0
    mov ecx, dword ptr [eax + field_de4]         # 0049c6d3
    mov dword ptr [ebp - local_8], ecx           # 0049c6d9
    mov edx, dword ptr [ebp - local_8]           # 0049c6dc
    push edx                                     # 0049c6df
    call FUN_0051dc6c                            # 0049c6e0
    add esp, 0x4                                 # 0049c6e5
    mov eax, dword ptr [ebp - local_2c]          # 0049c6e8
    mov dword ptr [eax + field_de4], 0x0         # 0049c6eb
L_0049c6f5:
    # block 0x0049c6f5: entered by je at 0x0049c6ce, 3 instruction(s), ends with je to 0x0049c726 (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 0049c6f5
    cmp dword ptr [ecx + field_dec], 0x0         # 0049c6f8
    je.d8 L_0049c726                             # 0049c6ff
    # block 0x0049c701: entered by fall-through of je at 0x0049c6ff, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c726
    mov edx, dword ptr [ebp - local_2c]          # 0049c701
    mov eax, dword ptr [edx + field_dec]         # 0049c704
    mov dword ptr [ebp - local_c], eax           # 0049c70a
    mov ecx, dword ptr [ebp - local_c]           # 0049c70d
    push ecx                                     # 0049c710
    call FUN_0051dc6c                            # 0049c711
    add esp, 0x4                                 # 0049c716
    mov edx, dword ptr [ebp - local_2c]          # 0049c719
    mov dword ptr [edx + field_dec], 0x0         # 0049c71c
L_0049c726:
    # block 0x0049c726: entered by je at 0x0049c6ff, 3 instruction(s), ends with je to 0x0049c757 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 0049c726
    cmp dword ptr [eax + field_e30], 0x0         # 0049c729
    je.d8 L_0049c757                             # 0049c730
    # block 0x0049c732: entered by fall-through of je at 0x0049c730, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c757
    mov ecx, dword ptr [ebp - local_2c]          # 0049c732
    mov edx, dword ptr [ecx + field_e30]         # 0049c735
    mov dword ptr [ebp - local_10], edx          # 0049c73b
    mov eax, dword ptr [ebp - local_10]          # 0049c73e
    push eax                                     # 0049c741
    call FUN_0051dc6c                            # 0049c742
    add esp, 0x4                                 # 0049c747
    mov ecx, dword ptr [ebp - local_2c]          # 0049c74a
    mov dword ptr [ecx + field_e30], 0x0         # 0049c74d
L_0049c757:
    # block 0x0049c757: entered by je at 0x0049c730, 3 instruction(s), ends with je to 0x0049c788 (forward)
    mov edx, dword ptr [ebp - local_2c]          # 0049c757
    cmp dword ptr [edx + field_e34], 0x0         # 0049c75a
    je.d8 L_0049c788                             # 0049c761
    # block 0x0049c763: entered by fall-through of je at 0x0049c761, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c788
    mov eax, dword ptr [ebp - local_2c]          # 0049c763
    mov ecx, dword ptr [eax + field_e34]         # 0049c766
    mov dword ptr [ebp - local_14], ecx          # 0049c76c
    mov edx, dword ptr [ebp - local_14]          # 0049c76f
    push edx                                     # 0049c772
    call FUN_0051dc6c                            # 0049c773
    add esp, 0x4                                 # 0049c778
    mov eax, dword ptr [ebp - local_2c]          # 0049c77b
    mov dword ptr [eax + field_e34], 0x0         # 0049c77e
L_0049c788:
    # block 0x0049c788: entered by je at 0x0049c761, 3 instruction(s), ends with je to 0x0049c7b9 (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 0049c788
    cmp dword ptr [ecx + field_e38], 0x0         # 0049c78b
    je.d8 L_0049c7b9                             # 0049c792
    # block 0x0049c794: entered by fall-through of je at 0x0049c792, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c7b9
    mov edx, dword ptr [ebp - local_2c]          # 0049c794
    mov eax, dword ptr [edx + field_e38]         # 0049c797
    mov dword ptr [ebp - local_18], eax          # 0049c79d
    mov ecx, dword ptr [ebp - local_18]          # 0049c7a0
    push ecx                                     # 0049c7a3
    call FUN_0051dc6c                            # 0049c7a4
    add esp, 0x4                                 # 0049c7a9
    mov edx, dword ptr [ebp - local_2c]          # 0049c7ac
    mov dword ptr [edx + field_e38], 0x0         # 0049c7af
L_0049c7b9:
    # block 0x0049c7b9: entered by je at 0x0049c792, 3 instruction(s), ends with je to 0x0049c7ea (forward)
    mov eax, dword ptr [ebp - local_2c]          # 0049c7b9
    cmp dword ptr [eax + field_e3c], 0x0         # 0049c7bc
    je.d8 L_0049c7ea                             # 0049c7c3
    # block 0x0049c7c5: entered by fall-through of je at 0x0049c7c3, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c7ea
    mov ecx, dword ptr [ebp - local_2c]          # 0049c7c5
    mov edx, dword ptr [ecx + field_e3c]         # 0049c7c8
    mov dword ptr [ebp - local_1c], edx          # 0049c7ce
    mov eax, dword ptr [ebp - local_1c]          # 0049c7d1
    push eax                                     # 0049c7d4
    call FUN_0051dc6c                            # 0049c7d5
    add esp, 0x4                                 # 0049c7da
    mov ecx, dword ptr [ebp - local_2c]          # 0049c7dd
    mov dword ptr [ecx + field_e3c], 0x0         # 0049c7e0
L_0049c7ea:
    # block 0x0049c7ea: entered by je at 0x0049c7c3, 3 instruction(s), ends with je to 0x0049c81b (forward)
    mov edx, dword ptr [ebp - local_2c]          # 0049c7ea
    cmp dword ptr [edx + field_e40], 0x0         # 0049c7ed
    je.d8 L_0049c81b                             # 0049c7f4
    # block 0x0049c7f6: entered by fall-through of je at 0x0049c7f4, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c81b
    mov eax, dword ptr [ebp - local_2c]          # 0049c7f6
    mov ecx, dword ptr [eax + field_e40]         # 0049c7f9
    mov dword ptr [ebp - local_20], ecx          # 0049c7ff
    mov edx, dword ptr [ebp - local_20]          # 0049c802
    push edx                                     # 0049c805
    call FUN_0051dc6c                            # 0049c806
    add esp, 0x4                                 # 0049c80b
    mov eax, dword ptr [ebp - local_2c]          # 0049c80e
    mov dword ptr [eax + field_e40], 0x0         # 0049c811
L_0049c81b:
    # block 0x0049c81b: entered by je at 0x0049c7f4, 3 instruction(s), ends with je to 0x0049c84c (forward)
    mov ecx, dword ptr [ebp - local_2c]          # 0049c81b
    cmp dword ptr [ecx + field_e44], 0x0         # 0049c81e
    je.d8 L_0049c84c                             # 0049c825
    # block 0x0049c827: entered by fall-through of je at 0x0049c825, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c84c
    mov edx, dword ptr [ebp - local_2c]          # 0049c827
    mov eax, dword ptr [edx + field_e44]         # 0049c82a
    mov dword ptr [ebp - local_24], eax          # 0049c830
    mov ecx, dword ptr [ebp - local_24]          # 0049c833
    push ecx                                     # 0049c836
    call FUN_0051dc6c                            # 0049c837
    add esp, 0x4                                 # 0049c83c
    mov edx, dword ptr [ebp - local_2c]          # 0049c83f
    mov dword ptr [edx + field_e44], 0x0         # 0049c842
L_0049c84c:
    # block 0x0049c84c: entered by je at 0x0049c825, 3 instruction(s), ends with je to 0x0049c87d (forward)
    mov eax, dword ptr [ebp - local_2c]          # 0049c84c
    cmp dword ptr [eax + field_e48], 0x0         # 0049c84f
    je.d8 L_0049c87d                             # 0049c856
    # block 0x0049c858: entered by fall-through of je at 0x0049c856, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c87d
    mov ecx, dword ptr [ebp - local_2c]          # 0049c858
    mov edx, dword ptr [ecx + field_e48]         # 0049c85b
    mov dword ptr [ebp - local_28], edx          # 0049c861
    mov eax, dword ptr [ebp - local_28]          # 0049c864
    push eax                                     # 0049c867
    call FUN_0051dc6c                            # 0049c868
    add esp, 0x4                                 # 0049c86d
    mov ecx, dword ptr [ebp - local_2c]          # 0049c870
    mov dword ptr [ecx + field_e48], 0x0         # 0049c873
L_0049c87d:
    # block 0x0049c87d: entered by je at 0x0049c856, 5 instruction(s), calls FUN_0049c5f0, ends with ret
    mov ecx, dword ptr [ebp - local_2c]          # 0049c87d
    call FUN_0049c5f0                            # 0049c880
    {load} mov esp, ebp                          # 0049c885
    pop ebp                                      # 0049c887
    ret                                          # 0049c888

