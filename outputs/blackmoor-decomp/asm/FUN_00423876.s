# FUN_00423876
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423876
# extent:       0x00423876-0x00423a30 (442 code bytes)
# span:         0x00423876-0x00423a30 (code 442, tables 0, padding 0)
# sha256:       68ca5942ca89ab5f3a641c4d6fa7bde6c54a50b9ae8ae518b9af4ced25969e3e
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m423876_unwind_chain
# naming:       native port src/original_methods_fl30c.c:m423876_unwind_chain (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Recursive node chain release (callees 0x423aae/0x423a30/0x4234dd/0x4235fd), c+4 cleared, optional free; endless-loop node types rejected natively. See fl30c-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_8, field_48; [ecx + n] field_34, field_44; [edx + n] field_4, field_c, field_44
# callees:      calls FUN_0050ca3e, FUN_00423aae, FUN_00423a30, FUN_004234dd, FUN_00423876, FUN_004235fd, FUN_0051dc6c, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30c.c:m423876_unwind_chain (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 132 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_34, 0x34  # offset +0x34
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48

# --- external targets -----------------------------------------------
.set FUN_004234dd, .text + (0x004234dd - 0x401000)
.set FUN_004235fd, .text + (0x004235fd - 0x401000)
.set FUN_00423a30, .text + (0x00423a30 - 0x401000)
.set FUN_00423aae, .text + (0x00423aae - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00423876 - 0x401000
.globl FUN_00423876
FUN_00423876:
L_00423876:
    # block 0x00423876: entry, 7 instruction(s), ends with jne to 0x0042389e (forward)
    push ebp                                     # 00423876
    {load} mov ebp, esp                          # 00423877
    sub esp, 0x1c                                # 00423879
    mov dword ptr [ebp - local_1c], ecx          # 0042387c
    mov eax, dword ptr [ebp + arg_8]             # 0042387f
    cmp dword ptr [eax], 0x0                     # 00423882
    jne.d8 L_0042389e                            # 00423885
    # block 0x00423887: entered by fall-through of jne at 0x00423885, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00423a28
    push 0x544730                                # 00423887
    push 0x63888b                                # 0042388c
    call FUN_0050ca3e                            # 00423891
    add esp, 0x8                                 # 00423896
    jmp.d32 L_00423a28                           # 00423899
L_0042389e:
    # block 0x0042389e: entered by jne at 0x00423885, 8 instruction(s), calls FUN_00423aae, ends with jne to 0x004238ba (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0042389e
    mov edx, dword ptr [ecx]                     # 004238a1
    push edx                                     # 004238a3
    mov ecx, dword ptr [ebp - local_1c]          # 004238a4
    call FUN_00423aae                            # 004238a7
    mov dword ptr [ebp - local_14], eax          # 004238ac
    cmp dword ptr [ebp - local_14], 0x0          # 004238af
    jne.d8 L_004238ba                            # 004238b3
    # block 0x004238b5: entered by fall-through of jne at 0x004238b3, 1 instruction(s), ends with forward jump to 0x00423a2a
    jmp.d32 L_00423a2a                           # 004238b5
L_004238ba:
    # block 0x004238ba: entered by jne at 0x004238b3, 1 instruction(s), falls into the block at 0x004238c1
    mov dword ptr [ebp - local_8], 0x0           # 004238ba
L_004238c1:
    # block 0x004238c1: entered by jmp at 0x004239c8, 2 instruction(s), ends with jne to 0x004239cd (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004238c1
    jne.d32 L_004239cd                           # 004238c5
    # block 0x004238cb: entered by fall-through of jne at 0x004238c5, 3 instruction(s), ends with je to 0x004238e4 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004238cb
    cmp dword ptr [eax], 0x2                     # 004238ce
    je.d8 L_004238e4                             # 004238d1
    # block 0x004238d3: entered by fall-through of je at 0x004238d1, 3 instruction(s), ends with jne to 0x0042392a (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004238d3
    cmp dword ptr [ecx], 0x1                     # 004238d6
    jne.d8 L_0042392a                            # 004238d9
    # block 0x004238db: entered by fall-through of jne at 0x004238d9, 3 instruction(s), ends with jne to 0x0042392a (forward)
    mov edx, dword ptr [ebp - local_14]          # 004238db
    cmp dword ptr [edx + field_44], 0x0          # 004238de
    jne.d8 L_0042392a                            # 004238e2
L_004238e4:
    # block 0x004238e4: entered by je at 0x004238d1; fall-through of jne at 0x004238e2, 7 instruction(s), ends with jne to 0x00423919 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004238e4
    mov dword ptr [ebp - local_10], eax          # 004238e7
    mov ecx, dword ptr [ebp - local_14]          # 004238ea
    mov edx, dword ptr [ecx + field_34]          # 004238ed
    mov dword ptr [ebp - local_14], edx          # 004238f0
    cmp dword ptr [ebp - local_14], 0x0          # 004238f3
    jne.d8 L_00423919                            # 004238f7
    # block 0x004238f9: entered by fall-through of jne at 0x004238f7, 6 instruction(s), ends with je to 0x00423919 (forward)
    mov dword ptr [ebp - local_8], 0x1           # 004238f9
    mov eax, dword ptr [ebp - local_10]          # 00423900
    mov ecx, dword ptr [eax + field_48]          # 00423903
    mov dword ptr [ebp - local_c], ecx           # 00423906
    cmp dword ptr [ebp - local_c], 0x0           # 00423909
    je.d8 L_00423919                             # 0042390d
    # block 0x0042390f: entered by fall-through of je at 0x0042390d, 2 instruction(s), falls into the block at 0x00423919
    mov edx, dword ptr [ebp - local_c]           # 0042390f
    mov dword ptr [edx + field_4], 0x0           # 00423912
L_00423919:
    # block 0x00423919: entered by jne at 0x004238f7; je at 0x0042390d, 5 instruction(s), calls FUN_00423a30, ends with forward jump to 0x004239c8
    lea eax, [ebp - local_10]                    # 00423919
    push eax                                     # 0042391c
    mov ecx, dword ptr [ebp - local_1c]          # 0042391d
    call FUN_00423a30                            # 00423920
    jmp.d32 L_004239c8                           # 00423925
L_0042392a:
    # block 0x0042392a: entered by jne at 0x004238d9; jne at 0x004238e2, 3 instruction(s), ends with jne to 0x004239c8 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 0042392a
    cmp dword ptr [ecx], 0x1                     # 0042392d
    jne.d32 L_004239c8                           # 00423930
    # block 0x00423936: entered by fall-through of jne at 0x00423930, 3 instruction(s), ends with je to 0x004239c8 (forward)
    mov edx, dword ptr [ebp - local_14]          # 00423936
    cmp dword ptr [edx + field_44], 0x0          # 00423939
    je.d32 L_004239c8                            # 0042393d
    # block 0x00423943: entered by fall-through of je at 0x0042393d, 17 instruction(s), calls FUN_004234dd, FUN_00423876, FUN_004235fd, ends with je to 0x004239b4 (forward)
    mov eax, dword ptr [ebp - local_14]          # 00423943
    push eax                                     # 00423946
    mov ecx, dword ptr [ebp + arg_8]             # 00423947
    push ecx                                     # 0042394a
    mov ecx, dword ptr [ebp - local_1c]          # 0042394b
    call FUN_004234dd                            # 0042394e
    push 0x1                                     # 00423953
    mov edx, dword ptr [ebp - local_14]          # 00423955
    add edx, 0x44                                # 00423958
    push edx                                     # 0042395b
    mov ecx, dword ptr [ebp - local_1c]          # 0042395c
    call L_00423876                              # 0042395f
    mov ecx, dword ptr [ebp - local_1c]          # 00423964
    call FUN_004235fd                            # 00423967
    mov dword ptr [ebp - local_4], eax           # 0042396c
    cmp dword ptr [ebp - local_4], 0x0           # 0042396f
    je.d8 L_004239b4                             # 00423973
    # block 0x00423975: entered by fall-through of je at 0x00423973, 10 instruction(s), ends with je to 0x004239b2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00423975
    mov ecx, dword ptr [eax + field_8]           # 00423978
    mov dword ptr [ebp - local_14], ecx          # 0042397b
    mov edx, dword ptr [ebp - local_4]           # 0042397e
    mov eax, dword ptr [edx + field_4]           # 00423981
    mov dword ptr [ebp + arg_8], eax             # 00423984
    mov dword ptr [ebp - local_8], 0x0           # 00423987
    mov ecx, dword ptr [ebp - local_14]          # 0042398e
    cmp dword ptr [ecx + field_44], 0x0          # 00423991
    je.d8 L_004239b2                             # 00423995
    # block 0x00423997: entered by fall-through of je at 0x00423995, 8 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00423a26
    mov edx, dword ptr [ebp - local_14]          # 00423997
    mov eax, dword ptr [edx + field_c]           # 0042399a
    push eax                                     # 0042399d
    push 0x544770                                # 0042399e
    push 0x63888b                                # 004239a3
    call FUN_0050ca3e                            # 004239a8
    add esp, 0xc                                 # 004239ad
    jmp.d8 L_00423a26                            # 004239b0
L_004239b2:
    # block 0x004239b2: entered by je at 0x00423995, 1 instruction(s), ends with forward jump to 0x004239c8
    jmp.d8 L_004239c8                            # 004239b2
L_004239b4:
    # block 0x004239b4: entered by je at 0x00423973, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x00423a24
    push 0x5447e0                                # 004239b4
    push 0x63888b                                # 004239b9
    call FUN_0050ca3e                            # 004239be
    add esp, 0x8                                 # 004239c3
    jmp.d8 L_00423a24                            # 004239c6
L_004239c8:
    # block 0x004239c8: entered by jmp at 0x00423925; jne at 0x00423930; je at 0x0042393d; jmp at 0x004239b2, 1 instruction(s), ends with backward jump to 0x004238c1
    jmp.d32 L_004238c1                           # 004239c8
L_004239cd:
    # block 0x004239cd: entered by jne at 0x004238c5, 2 instruction(s), ends with je to 0x004239f0 (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004239cd
    je.d8 L_004239f0                             # 004239d1
    # block 0x004239d3: entered by fall-through of je at 0x004239d1, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004239f0
    mov ecx, dword ptr [ebp + arg_8]             # 004239d3
    mov edx, dword ptr [ecx]                     # 004239d6
    mov dword ptr [ebp - local_18], edx          # 004239d8
    mov eax, dword ptr [ebp - local_18]          # 004239db
    push eax                                     # 004239de
    call FUN_0051dc6c                            # 004239df
    add esp, 0x4                                 # 004239e4
    mov ecx, dword ptr [ebp + arg_8]             # 004239e7
    mov dword ptr [ecx], 0x0                     # 004239ea
L_004239f0:
    # block 0x004239f0: entered by je at 0x004239d1, 1 instruction(s), ends with forward jump to 0x00423a2a
    jmp.d8 L_00423a2a                            # 004239f0
L_004239f2:
    # block 0x004239f2: entered by jmp at 0x00423a24; jmp at 0x00423a26; jmp at 0x00423a28, 7 instruction(s), calls FUN_0052139c, ends with je to 0x00423a18 (forward)
    push 0x0                                     # 004239f2
    push 0x0                                     # 004239f4
    push 0x63888b                                # 004239f6
    call FUN_0052139c                            # 004239fb
    movsx edx, word ptr [0x63a4cd]               # 00423a00
    test edx, edx                                # 00423a07
    je.d8 L_00423a18                             # 00423a09
    # block 0x00423a0b: entered by fall-through of je at 0x00423a09, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00423a18
    push 0x63888b                                # 00423a0b
    call FUN_0044a2b7                            # 00423a10
    add esp, 0x4                                 # 00423a15
L_00423a18:
    # block 0x00423a18: entered by je at 0x00423a09, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00423a2a
    mov ecx, 0x5cf659                            # 00423a18
    call FUN_004c97b4                            # 00423a1d
    jmp.d8 L_00423a2a                            # 00423a22
L_00423a24:
    # block 0x00423a24: entered by jmp at 0x004239c6, 1 instruction(s), ends with backward jump to 0x004239f2
    jmp.d8 L_004239f2                            # 00423a24
L_00423a26:
    # block 0x00423a26: entered by jmp at 0x004239b0, 1 instruction(s), ends with backward jump to 0x004239f2
    jmp.d8 L_004239f2                            # 00423a26
L_00423a28:
    # block 0x00423a28: entered by jmp at 0x00423899, 1 instruction(s), ends with backward jump to 0x004239f2
    jmp.d8 L_004239f2                            # 00423a28
L_00423a2a:
    # block 0x00423a2a: entered by jmp at 0x004238b5; jmp at 0x004239f0; jmp at 0x00423a22, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00423a2a
    pop ebp                                      # 00423a2c
    ret 0x8                                      # 00423a2d

