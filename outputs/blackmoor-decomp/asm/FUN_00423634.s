# FUN_00423634
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423634
# extent:       0x00423634-0x004236d6 (162 code bytes)
# span:         0x00423634-0x004236d6 (code 162, tables 0, padding 0)
# sha256:       d451802ac1e99b801895e660a434556ff06694840c2fc7be04f916805b9fefa0
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_dependency_branch_creator
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/423634.c.txt, not original source) refers to the data labelled s_CDependency__CreateAndInitBranch_0054455c, s_CDependency__CreateAndInitBranch_005445a4
# name-note:    CDependency::CreateAndInitBranch: allocates and zeroes a 0x1c-byte branch node, with error messages if one exists already or allocation fails.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_0051dc43, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m423634_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 52 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00423634 - 0x401000
.globl FUN_00423634
FUN_00423634:
    # block 0x00423634: entry, 8 instruction(s), ends with je to 0x0042365a (forward)
    push ebp                                     # 00423634
    {load} mov ebp, esp                          # 00423635
    sub esp, 0x8                                 # 00423637
    push edi                                     # 0042363a
    mov dword ptr [ebp - local_8], ecx           # 0042363b
    mov eax, dword ptr [ebp + arg_8]             # 0042363e
    cmp dword ptr [eax], 0x0                     # 00423641
    je.d8 L_0042365a                             # 00423644
    # block 0x00423646: entered by fall-through of je at 0x00423644, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004236cd
    push 0x54455c                                # 00423646
    push 0x63888b                                # 0042364b
    call FUN_0050ca3e                            # 00423650
    add esp, 0x8                                 # 00423655
    jmp.d8 L_004236cd                            # 00423658
L_0042365a:
    # block 0x0042365a: entered by je at 0x00423644, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x00423689 (forward)
    push 0x1c                                    # 0042365a
    call FUN_0051dc43                            # 0042365c
    add esp, 0x4                                 # 00423661
    mov dword ptr [ebp - local_4], eax           # 00423664
    mov ecx, dword ptr [ebp + arg_8]             # 00423667
    mov edx, dword ptr [ebp - local_4]           # 0042366a
    mov dword ptr [ecx], edx                     # 0042366d
    cmp dword ptr [ebp - local_4], 0x0           # 0042366f
    jne.d8 L_00423689                            # 00423673
    # block 0x00423675: entered by fall-through of jne at 0x00423673, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004236cb
    push 0x5445a4                                # 00423675
    push 0x63888b                                # 0042367a
    call FUN_0050ca3e                            # 0042367f
    add esp, 0x8                                 # 00423684
    jmp.d8 L_004236cb                            # 00423687
L_00423689:
    # block 0x00423689: entered by jne at 0x00423673, 6 instruction(s), ends with forward jump to 0x004236cf
    mov ecx, 0x7                                 # 00423689
    {load} xor eax, eax                          # 0042368e
    mov edx, dword ptr [ebp + arg_8]             # 00423690
    mov edi, dword ptr [edx]                     # 00423693
    rep stosd dword ptr es:[edi], eax            # 00423695
    jmp.d8 L_004236cf                            # 00423697
L_00423699:
    # block 0x00423699: entered by jmp at 0x004236cb; jmp at 0x004236cd, 7 instruction(s), calls FUN_0052139c, ends with je to 0x004236bf (forward)
    push 0x0                                     # 00423699
    push 0x0                                     # 0042369b
    push 0x63888b                                # 0042369d
    call FUN_0052139c                            # 004236a2
    movsx eax, word ptr [0x63a4cd]               # 004236a7
    test eax, eax                                # 004236ae
    je.d8 L_004236bf                             # 004236b0
    # block 0x004236b2: entered by fall-through of je at 0x004236b0, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004236bf
    push 0x63888b                                # 004236b2
    call FUN_0044a2b7                            # 004236b7
    add esp, 0x4                                 # 004236bc
L_004236bf:
    # block 0x004236bf: entered by je at 0x004236b0, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004236cf
    mov ecx, 0x5cf659                            # 004236bf
    call FUN_004c97b4                            # 004236c4
    jmp.d8 L_004236cf                            # 004236c9
L_004236cb:
    # block 0x004236cb: entered by jmp at 0x00423687, 1 instruction(s), ends with backward jump to 0x00423699
    jmp.d8 L_00423699                            # 004236cb
L_004236cd:
    # block 0x004236cd: entered by jmp at 0x00423658, 1 instruction(s), ends with backward jump to 0x00423699
    jmp.d8 L_00423699                            # 004236cd
L_004236cf:
    # block 0x004236cf: entered by jmp at 0x00423697; jmp at 0x004236c9, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 004236cf
    {load} mov esp, ebp                          # 004236d0
    pop ebp                                      # 004236d2
    ret 0x4                                      # 004236d3

