# FUN_004bf773
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf773
# extent:       0x004bf773-0x004bf8a7 (308 code bytes)
# span:         0x004bf773-0x004bf8a7 (code 308, tables 0, padding 0)
# sha256:       b188addc3169e5c437f751302769aaba7a26d9cd8cc3af0148b30236bc03b73f
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf773_release_player
# naming:       native port src/original_methods_fl27b.c:m4bf773_release_player (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4bf773_release_player: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1d6, field_222; [ecx + n] field_1d6; [edx + n] field_4
# callees:      calls FUN_0044c479, FUN_00449a94, FUN_0044c4ab, FUN_0044a2b7, FUN_00415011, FUN_004c2dfb, FUN_0041632b, FUN_004bedfa; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27b.c:m4bf773_release_player (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 85 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_1d6, 0x1d6  # offset +0x1d6
.equ field_222, 0x222  # offset +0x222

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_0041632b, .text + (0x0041632b - 0x401000)
.set FUN_00449a94, .text + (0x00449a94 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_004bedfa, .text + (0x004bedfa - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x004bf773 - 0x401000
.globl FUN_004bf773
FUN_004bf773:
    # block 0x004bf773: entry, 7 instruction(s), ends with je to 0x004bf805 (forward)
    push ebp                                     # 004bf773
    {load} mov ebp, esp                          # 004bf774
    sub esp, 0x10                                # 004bf776
    mov dword ptr [ebp - local_c], ecx           # 004bf779
    mov eax, dword ptr [ebp - local_c]           # 004bf77c
    cmp dword ptr [eax + field_1d6], 0x0         # 004bf77f
    je.d8 L_004bf805                             # 004bf786
    # block 0x004bf788: entered by fall-through of je at 0x004bf786, 17 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x004bf7d8 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004bf788
    add ecx, 0x4                                 # 004bf78b
    push ecx                                     # 004bf78e
    call FUN_0044c479                            # 004bf78f
    add esp, 0x4                                 # 004bf794
    mov edx, dword ptr [ebp - local_c]           # 004bf797
    mov dword ptr [edx + field_4], 0x2           # 004bf79a
    mov eax, dword ptr [ebp - local_c]           # 004bf7a1
    mov ecx, dword ptr [eax + field_1d6]         # 004bf7a4
    call FUN_00449a94                            # 004bf7aa
    mov ecx, dword ptr [ebp - local_c]           # 004bf7af
    mov edx, dword ptr [ecx + field_1d6]         # 004bf7b2
    mov dword ptr [ebp - local_8], edx           # 004bf7b8
    mov eax, dword ptr [ebp - local_8]           # 004bf7bb
    mov dword ptr [ebp - local_4], eax           # 004bf7be
    cmp dword ptr [ebp - local_4], 0x0           # 004bf7c1
    je.d8 L_004bf7d8                             # 004bf7c5
    # block 0x004bf7c7: entered by fall-through of je at 0x004bf7c5, 7 instruction(s), calls indirect dword ptr [edx], ends with forward jump to 0x004bf7df
    push 0x1                                     # 004bf7c7
    mov ecx, dword ptr [ebp - local_4]           # 004bf7c9
    mov edx, dword ptr [ecx]                     # 004bf7cc
    mov ecx, dword ptr [ebp - local_4]           # 004bf7ce
    call dword ptr [edx]                         # 004bf7d1
    mov dword ptr [ebp - local_10], eax          # 004bf7d3
    jmp.d8 L_004bf7df                            # 004bf7d6
L_004bf7d8:
    # block 0x004bf7d8: entered by je at 0x004bf7c5, 1 instruction(s), falls into the block at 0x004bf7df
    mov dword ptr [ebp - local_10], 0x0          # 004bf7d8
L_004bf7df:
    # block 0x004bf7df: entered by jmp at 0x004bf7d6, 9 instruction(s), calls FUN_0044c4ab, falls into the block at 0x004bf805
    mov eax, dword ptr [ebp - local_c]           # 004bf7df
    mov dword ptr [eax + field_1d6], 0x0         # 004bf7e2
    mov ecx, dword ptr [ebp - local_c]           # 004bf7ec
    add ecx, 0x4                                 # 004bf7ef
    push ecx                                     # 004bf7f2
    call FUN_0044c4ab                            # 004bf7f3
    add esp, 0x4                                 # 004bf7f8
    mov edx, dword ptr [ebp - local_c]           # 004bf7fb
    mov dword ptr [edx + field_4], 0x0           # 004bf7fe
L_004bf805:
    # block 0x004bf805: entered by je at 0x004bf786, 3 instruction(s), ends with je to 0x004bf81d (forward)
    movsx eax, word ptr [0x63a4cd]               # 004bf805
    test eax, eax                                # 004bf80c
    je.d8 L_004bf81d                             # 004bf80e
    # block 0x004bf810: entered by fall-through of je at 0x004bf80e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004bf81d
    push 0x5525dc                                # 004bf810
    call FUN_0044a2b7                            # 004bf815
    add esp, 0x4                                 # 004bf81a
L_004bf81d:
    # block 0x004bf81d: entered by je at 0x004bf80e, 8 instruction(s), calls FUN_00415011, ends with je to 0x004bf846 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004bf81d
    add ecx, 0x8                                 # 004bf820
    push ecx                                     # 004bf823
    mov ecx, 0x5e2dbe                            # 004bf824
    call FUN_00415011                            # 004bf829
    movsx edx, word ptr [0x63a4cd]               # 004bf82e
    test edx, edx                                # 004bf835
    je.d8 L_004bf846                             # 004bf837
    # block 0x004bf839: entered by fall-through of je at 0x004bf837, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004bf846
    push 0x552620                                # 004bf839
    call FUN_0044a2b7                            # 004bf83e
    add esp, 0x4                                 # 004bf843
L_004bf846:
    # block 0x004bf846: entered by je at 0x004bf837, 3 instruction(s), ends with je to 0x004bf866 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004bf846
    cmp dword ptr [eax + field_222], 0x0         # 004bf849
    je.d8 L_004bf866                             # 004bf850
    # block 0x004bf852: entered by fall-through of je at 0x004bf850, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004bf866
    mov ecx, dword ptr [ebp - local_c]           # 004bf852
    add ecx, 0x222                               # 004bf855
    push ecx                                     # 004bf85b
    mov ecx, 0x5cf659                            # 004bf85c
    call FUN_004c2dfb                            # 004bf861
L_004bf866:
    # block 0x004bf866: entered by je at 0x004bf850, 3 instruction(s), ends with je to 0x004bf87e (forward)
    movsx edx, word ptr [0x63a4cd]               # 004bf866
    test edx, edx                                # 004bf86d
    je.d8 L_004bf87e                             # 004bf86f
    # block 0x004bf871: entered by fall-through of je at 0x004bf86f, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004bf87e
    push 0x552664                                # 004bf871
    call FUN_0044a2b7                            # 004bf876
    add esp, 0x4                                 # 004bf87b
L_004bf87e:
    # block 0x004bf87e: entered by je at 0x004bf86f, 13 instruction(s), calls FUN_0041632b, FUN_004bedfa, ends with ret
    mov eax, dword ptr [ebp - local_c]           # 004bf87e
    add eax, 0x8                                 # 004bf881
    push eax                                     # 004bf884
    mov ecx, 0x5e2dbe                            # 004bf885
    call FUN_0041632b                            # 004bf88a
    mov ecx, dword ptr [ebp - local_c]           # 004bf88f
    add ecx, 0x18e                               # 004bf892
    push ecx                                     # 004bf898
    mov ecx, 0x6201f9                            # 004bf899
    call FUN_004bedfa                            # 004bf89e
    {load} mov esp, ebp                          # 004bf8a3
    pop ebp                                      # 004bf8a5
    ret                                          # 004bf8a6

