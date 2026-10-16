# FUN_004c47e6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c47e6
# extent:       0x004c47e6-0x004c4888 (162 code bytes)
# span:         0x004c47e6-0x004c4888 (code 162, tables 0, padding 0)
# sha256:       8250d52027a2778d46dc332d9b58b0eaef9520c40b9babe470669e9b365273a7
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c47e6
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_18, local_68, local_6c
# fields:       [ecx + n] field_14
# callees:      calls FUN_004c4dc3, FUN_004c88c7, FUN_0042639d, FUN_004c97b4; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 54 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_18, 0x18  # offset -0x18
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c4dc3, .text + (0x004c4dc3 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x004c47e6 - 0x401000
.globl FUN_004c47e6
FUN_004c47e6:
    # block 0x004c47e6: entry, 13 instruction(s), falls into the block at 0x004c480e
    push ebp                                     # 004c47e6
    {load} mov ebp, esp                          # 004c47e7
    sub esp, 0x6c                                # 004c47e9
    push edi                                     # 004c47ec
    mov dword ptr [ebp - local_6c], ecx          # 004c47ed
    mov ecx, 0x19                                # 004c47f0
    {load} xor eax, eax                          # 004c47f5
    lea edi, [ebp - local_68]                    # 004c47f7
    rep stosd dword ptr es:[edi], eax            # 004c47fa
    mov dword ptr [ebp - local_68], 0x64         # 004c47fc
    mov eax, dword ptr [ebp + arg_c]             # 004c4803
    and eax, 0xffff                              # 004c4806
    mov dword ptr [ebp - local_18], eax          # 004c480b
L_004c480e:
    # block 0x004c480e: entered by jmp at 0x004c487f, 3 instruction(s), ends with je to 0x004c4881 (forward)
    mov ecx, 0x1                                 # 004c480e
    test ecx, ecx                                # 004c4813
    je.d8 L_004c4881                             # 004c4815
    # block 0x004c4817: entered by fall-through of je at 0x004c4815, 14 instruction(s), calls indirect dword ptr [ecx + 0x14], ends with jne to 0x004c483d (forward)
    lea edx, [ebp - local_68]                    # 004c4817
    push edx                                     # 004c481a
    push 0x1000400                               # 004c481b
    push 0x0                                     # 004c4820
    push 0x0                                     # 004c4822
    push 0x0                                     # 004c4824
    mov eax, dword ptr [ebp + arg_8]             # 004c4826
    mov ecx, dword ptr [eax]                     # 004c4829
    mov edx, dword ptr [ebp + arg_8]             # 004c482b
    push edx                                     # 004c482e
    call dword ptr [ecx + field_14]              # 004c482f
    mov dword ptr [ebp - local_4], eax           # 004c4832
    cmp dword ptr [ebp - local_4], 0x0           # 004c4835
    jne.d8 L_004c483d                            # 004c4839
    # block 0x004c483b: entered by fall-through of jne at 0x004c4839, 1 instruction(s), ends with forward jump to 0x004c4881
    jmp.d8 L_004c4881                            # 004c483b
L_004c483d:
    # block 0x004c483d: entered by jne at 0x004c4839, 2 instruction(s), ends with jne to 0x004c4850 (forward)
    cmp dword ptr [ebp - local_4], 0x887601c2    # 004c483d
    jne.d8 L_004c4850                            # 004c4844
    # block 0x004c4846: entered by fall-through of jne at 0x004c4844, 3 instruction(s), calls FUN_004c4dc3, ends with forward jump to 0x004c487f
    mov ecx, dword ptr [ebp - local_6c]          # 004c4846
    call FUN_004c4dc3                            # 004c4849
    jmp.d8 L_004c487f                            # 004c484e
L_004c4850:
    # block 0x004c4850: entered by jne at 0x004c4844, 2 instruction(s), ends with je to 0x004c487f (forward)
    cmp dword ptr [ebp - local_4], 0x8876021c    # 004c4850
    je.d8 L_004c487f                             # 004c4857
    # block 0x004c4859: entered by fall-through of je at 0x004c4857, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c4881
    mov eax, dword ptr [ebp - local_4]           # 004c4859
    push eax                                     # 004c485c
    mov ecx, dword ptr [ebp - local_6c]          # 004c485d
    call FUN_004c88c7                            # 004c4860
    push eax                                     # 004c4865
    push 0x5545bc                                # 004c4866
    mov ecx, 0x583979                            # 004c486b
    call FUN_0042639d                            # 004c4870
    mov ecx, dword ptr [ebp - local_6c]          # 004c4875
    call FUN_004c97b4                            # 004c4878
    jmp.d8 L_004c4881                            # 004c487d
L_004c487f:
    # block 0x004c487f: entered by jmp at 0x004c484e; je at 0x004c4857, 1 instruction(s), ends with backward jump to 0x004c480e
    jmp.d8 L_004c480e                            # 004c487f
L_004c4881:
    # block 0x004c4881: entered by je at 0x004c4815; jmp at 0x004c483b; jmp at 0x004c487d, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 004c4881
    {load} mov esp, ebp                          # 004c4882
    pop ebp                                      # 004c4884
    ret 0x8                                      # 004c4885

