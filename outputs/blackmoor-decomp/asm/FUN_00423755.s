# FUN_00423755
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423755
# extent:       0x00423755-0x004237f7 (162 code bytes)
# span:         0x00423755-0x004237f7 (code 162, tables 0, padding 0)
# sha256:       6a99d828f22ade56521984414dd375fb42c9795d862f377dd8cd09d107ea7ffa
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00423755
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_0051dc43, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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

.org 0x00423755 - 0x401000
.globl FUN_00423755
FUN_00423755:
    # block 0x00423755: entry, 8 instruction(s), ends with je to 0x0042377b (forward)
    push ebp                                     # 00423755
    {load} mov ebp, esp                          # 00423756
    sub esp, 0x8                                 # 00423758
    push edi                                     # 0042375b
    mov dword ptr [ebp - local_8], ecx           # 0042375c
    mov eax, dword ptr [ebp + arg_8]             # 0042375f
    cmp dword ptr [eax], 0x0                     # 00423762
    je.d8 L_0042377b                             # 00423765
    # block 0x00423767: entered by fall-through of je at 0x00423765, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004237ee
    push 0x54464c                                # 00423767
    push 0x63888b                                # 0042376c
    call FUN_0050ca3e                            # 00423771
    add esp, 0x8                                 # 00423776
    jmp.d8 L_004237ee                            # 00423779
L_0042377b:
    # block 0x0042377b: entered by je at 0x00423765, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x004237aa (forward)
    push 0x4c                                    # 0042377b
    call FUN_0051dc43                            # 0042377d
    add esp, 0x4                                 # 00423782
    mov dword ptr [ebp - local_4], eax           # 00423785
    mov ecx, dword ptr [ebp + arg_8]             # 00423788
    mov edx, dword ptr [ebp - local_4]           # 0042378b
    mov dword ptr [ecx], edx                     # 0042378e
    cmp dword ptr [ebp - local_4], 0x0           # 00423790
    jne.d8 L_004237aa                            # 00423794
    # block 0x00423796: entered by fall-through of jne at 0x00423794, 5 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004237ec
    push 0x544690                                # 00423796
    push 0x63888b                                # 0042379b
    call FUN_0050ca3e                            # 004237a0
    add esp, 0x8                                 # 004237a5
    jmp.d8 L_004237ec                            # 004237a8
L_004237aa:
    # block 0x004237aa: entered by jne at 0x00423794, 6 instruction(s), ends with forward jump to 0x004237f0
    mov ecx, 0x13                                # 004237aa
    {load} xor eax, eax                          # 004237af
    mov edx, dword ptr [ebp + arg_8]             # 004237b1
    mov edi, dword ptr [edx]                     # 004237b4
    rep stosd dword ptr es:[edi], eax            # 004237b6
    jmp.d8 L_004237f0                            # 004237b8
L_004237ba:
    # block 0x004237ba: entered by jmp at 0x004237ec; jmp at 0x004237ee, 7 instruction(s), calls FUN_0052139c, ends with je to 0x004237e0 (forward)
    push 0x0                                     # 004237ba
    push 0x0                                     # 004237bc
    push 0x63888b                                # 004237be
    call FUN_0052139c                            # 004237c3
    movsx eax, word ptr [0x63a4cd]               # 004237c8
    test eax, eax                                # 004237cf
    je.d8 L_004237e0                             # 004237d1
    # block 0x004237d3: entered by fall-through of je at 0x004237d1, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004237e0
    push 0x63888b                                # 004237d3
    call FUN_0044a2b7                            # 004237d8
    add esp, 0x4                                 # 004237dd
L_004237e0:
    # block 0x004237e0: entered by je at 0x004237d1, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004237f0
    mov ecx, 0x5cf659                            # 004237e0
    call FUN_004c97b4                            # 004237e5
    jmp.d8 L_004237f0                            # 004237ea
L_004237ec:
    # block 0x004237ec: entered by jmp at 0x004237a8, 1 instruction(s), ends with backward jump to 0x004237ba
    jmp.d8 L_004237ba                            # 004237ec
L_004237ee:
    # block 0x004237ee: entered by jmp at 0x00423779, 1 instruction(s), ends with backward jump to 0x004237ba
    jmp.d8 L_004237ba                            # 004237ee
L_004237f0:
    # block 0x004237f0: entered by jmp at 0x004237b8; jmp at 0x004237ea, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 004237f0
    {load} mov esp, ebp                          # 004237f1
    pop ebp                                      # 004237f3
    ret 0x4                                      # 004237f4

