# FUN_0043e776
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043e776
# extent:       0x0043e776-0x0043e8b8 (322 code bytes)
# span:         0x0043e776-0x0043e8b8 (code 322, tables 0, padding 0)
# sha256:       9d7861411890d24908a703b878eb7d43b0de3d27f028c3bcfa4a5aae82df30e8
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043e776
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc6c, FUN_00423b51, FUN_004234b5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43e776_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 70 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004234b5, .text + (0x004234b5 - 0x401000)
.set FUN_00423b51, .text + (0x00423b51 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0043e776 - 0x401000
.globl FUN_0043e776
FUN_0043e776:
    # block 0x0043e776: entry, 5 instruction(s), ends with forward jump to 0x0043e78e
    push ebp                                     # 0043e776
    {load} mov ebp, esp                          # 0043e777
    sub esp, 0x10                                # 0043e779
    mov dword ptr [ebp - local_8], 0x0           # 0043e77c
    jmp.d8 L_0043e78e                            # 0043e783
L_0043e785:
    # block 0x0043e785: entered by jmp at 0x0043e8a5, 3 instruction(s), falls into the block at 0x0043e78e
    mov eax, dword ptr [ebp - local_8]           # 0043e785
    add eax, 0x1                                 # 0043e788
    mov dword ptr [ebp - local_8], eax           # 0043e78b
L_0043e78e:
    # block 0x0043e78e: entered by jmp at 0x0043e783, 3 instruction(s), ends with jge to 0x0043e8aa (forward)
    movsx ecx, word ptr [0x5c39e3]               # 0043e78e
    cmp dword ptr [ebp - local_8], ecx           # 0043e795
    jge.d32 L_0043e8aa                           # 0043e798
    # block 0x0043e79e: entered by fall-through of jge at 0x0043e798, 7 instruction(s), ends with je to 0x0043e7c5 (forward)
    mov dword ptr [ebp - local_4], 0x0           # 0043e79e
    mov edx, dword ptr [ebp - local_8]           # 0043e7a5
    imul edx, edx, 0x8d                          # 0043e7a8
    mov al, byte ptr [edx + 0x5bb5e3]            # 0043e7ae
    mov byte ptr [ebp - local_10], al            # 0043e7b4
    cmp byte ptr [ebp - local_10], 0x20          # 0043e7b7
    je.d8 L_0043e7c5                             # 0043e7bb
    # block 0x0043e7bd: entered by fall-through of je at 0x0043e7bb, 2 instruction(s), ends with je to 0x0043e7c5 (forward)
    cmp byte ptr [ebp - local_10], 0x47          # 0043e7bd
    je.d8 L_0043e7c5                             # 0043e7c1
    # block 0x0043e7c3: entered by fall-through of je at 0x0043e7c1, 1 instruction(s), ends with forward jump to 0x0043e80f
    jmp.d8 L_0043e80f                            # 0043e7c3
L_0043e7c5:
    # block 0x0043e7c5: entered by je at 0x0043e7bb; je at 0x0043e7c1, 4 instruction(s), ends with je to 0x0043e808 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0043e7c5
    imul ecx, ecx, 0x8d                          # 0043e7c8
    cmp dword ptr [ecx + 0x5bb5e5], 0x0          # 0043e7ce
    je.d8 L_0043e808                             # 0043e7d5
    # block 0x0043e7d7: entered by fall-through of je at 0x0043e7d5, 11 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0043e808
    mov edx, dword ptr [ebp - local_8]           # 0043e7d7
    imul edx, edx, 0x8d                          # 0043e7da
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0043e7e0
    mov dword ptr [ebp - local_c], eax           # 0043e7e6
    mov ecx, dword ptr [ebp - local_c]           # 0043e7e9
    push ecx                                     # 0043e7ec
    call FUN_0051dc6c                            # 0043e7ed
    add esp, 0x4                                 # 0043e7f2
    mov edx, dword ptr [ebp - local_8]           # 0043e7f5
    imul edx, edx, 0x8d                          # 0043e7f8
    mov dword ptr [edx + 0x5bb5e5], 0x0          # 0043e7fe
L_0043e808:
    # block 0x0043e808: entered by je at 0x0043e7d5, 1 instruction(s), falls into the block at 0x0043e80f
    mov dword ptr [ebp - local_4], 0x1           # 0043e808
L_0043e80f:
    # block 0x0043e80f: entered by jmp at 0x0043e7c3, 2 instruction(s), ends with je to 0x0043e8a5 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0043e80f
    je.d32 L_0043e8a5                            # 0043e813
    # block 0x0043e819: entered by fall-through of je at 0x0043e813, 25 instruction(s), calls FUN_00423b51, falls into the block at 0x0043e8a5
    mov eax, dword ptr [ebp - local_8]           # 0043e819
    imul eax, eax, 0x8d                          # 0043e81c
    mov byte ptr [eax + 0x5bb5e3], 0x0           # 0043e822
    mov ecx, dword ptr [ebp - local_8]           # 0043e829
    imul ecx, ecx, 0x8d                          # 0043e82c
    mov byte ptr [ecx + 0x5bb625], 0x0           # 0043e832
    mov edx, dword ptr [ebp - local_8]           # 0043e839
    imul edx, edx, 0x8d                          # 0043e83c
    mov dword ptr [edx + 0x5bb626], 0x0          # 0043e842
    mov eax, dword ptr [ebp - local_8]           # 0043e84c
    imul eax, eax, 0x8d                          # 0043e84f
    mov dword ptr [eax + 0x5bb632], 0x0          # 0043e855
    mov ecx, dword ptr [ebp - local_8]           # 0043e85f
    imul ecx, ecx, 0x8d                          # 0043e862
    mov word ptr [ecx + 0x5bb636], 0xffff        # 0043e868
    mov edx, dword ptr [ebp - local_8]           # 0043e871
    imul edx, edx, 0x8d                          # 0043e874
    mov dword ptr [edx + 0x5bb638], 0x1          # 0043e87a
    mov eax, dword ptr [ebp - local_8]           # 0043e884
    imul eax, eax, 0x8d                          # 0043e887
    mov dword ptr [eax + 0x5bb63c], 0x0          # 0043e88d
    mov ecx, dword ptr [ebp - local_8]           # 0043e897
    push ecx                                     # 0043e89a
    mov ecx, 0x63786d                            # 0043e89b
    call FUN_00423b51                            # 0043e8a0
L_0043e8a5:
    # block 0x0043e8a5: entered by je at 0x0043e813, 1 instruction(s), ends with backward jump to 0x0043e785
    jmp.d32 L_0043e785                           # 0043e8a5
L_0043e8aa:
    # block 0x0043e8aa: entered by jge at 0x0043e798, 5 instruction(s), calls FUN_004234b5, ends with ret
    mov ecx, 0x63786d                            # 0043e8aa
    call FUN_004234b5                            # 0043e8af
    {load} mov esp, ebp                          # 0043e8b4
    pop ebp                                      # 0043e8b6
    ret                                          # 0043e8b7

