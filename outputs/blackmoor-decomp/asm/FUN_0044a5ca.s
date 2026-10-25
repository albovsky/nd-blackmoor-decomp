# FUN_0044a5ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a5ca
# extent:       0x0044a5ca-0x0044a696 (204 code bytes)
# span:         0x0044a5ca-0x0044a696 (code 204, tables 0, padding 0)
# sha256:       aeb0f7f528752163703cd706862ddf9aa9123cd6389e9fb9c2ed60092cc068df
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044a5ca
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_c, local_10, local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d8e0, FUN_0051e7ba
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44a5ca_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 64 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x0044a5ca - 0x401000
.globl FUN_0044a5ca
FUN_0044a5ca:
    # block 0x0044a5ca: entry, 18 instruction(s), ends with ja to 0x0044a653 (forward)
    push ebp                                     # 0044a5ca
    {load} mov ebp, esp                          # 0044a5cb
    push -0x1                                    # 0044a5cd
    push 0x527f5f                                # 0044a5cf
    mov eax, dword ptr fs:[0x0]                  # 0044a5d4
    push eax                                     # 0044a5da
    mov dword ptr fs:[0x0], esp                  # 0044a5db
    sub esp, 0x8                                 # 0044a5e2
    push edi                                     # 0044a5e5
    mov dword ptr [ebp - local_4], 0x0           # 0044a5e6
    mov edi, dword ptr [ebp + arg_8]             # 0044a5ed
    or ecx, -0x1                                 # 0044a5f0
    {load} xor eax, eax                          # 0044a5f3
    repne scasb al, byte ptr es:[edi]            # 0044a5f5
    not ecx                                      # 0044a5f7
    add ecx, -0x1                                # 0044a5f9
    cmp ecx, 0x3                                 # 0044a5fc
    ja.d8 L_0044a653                             # 0044a5ff
    # block 0x0044a601: entered by fall-through of ja at 0x0044a5ff, 8 instruction(s), ends with je to 0x0044a653 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0044a601
    or ecx, -0x1                                 # 0044a604
    {load} xor eax, eax                          # 0044a607
    repne scasb al, byte ptr es:[edi]            # 0044a609
    not ecx                                      # 0044a60b
    add ecx, -0x1                                # 0044a60d
    test ecx, ecx                                # 0044a610
    je.d8 L_0044a653                             # 0044a612
    # block 0x0044a614: entered by fall-through of je at 0x0044a612, 7 instruction(s), calls FUN_0050d8e0, ends with jne to 0x0044a653 (forward)
    push 0x548b00                                # 0044a614
    mov eax, dword ptr [ebp + arg_8]             # 0044a619
    push eax                                     # 0044a61c
    call FUN_0050d8e0                            # 0044a61d
    add esp, 0x8                                 # 0044a622
    test eax, eax                                # 0044a625
    jne.d8 L_0044a653                            # 0044a627
    # block 0x0044a629: entered by fall-through of jne at 0x0044a627, 7 instruction(s), calls FUN_0050d8e0, ends with jne to 0x0044a653 (forward)
    push 0x548b04                                # 0044a629
    mov ecx, dword ptr [ebp + arg_8]             # 0044a62e
    push ecx                                     # 0044a631
    call FUN_0050d8e0                            # 0044a632
    add esp, 0x8                                 # 0044a637
    test eax, eax                                # 0044a63a
    jne.d8 L_0044a653                            # 0044a63c
    # block 0x0044a63e: entered by fall-through of jne at 0x0044a63c, 7 instruction(s), calls FUN_0050d8e0, ends with je to 0x0044a66e (forward)
    push 0x548b08                                # 0044a63e
    mov edx, dword ptr [ebp + arg_8]             # 0044a643
    push edx                                     # 0044a646
    call FUN_0050d8e0                            # 0044a647
    add esp, 0x8                                 # 0044a64c
    test eax, eax                                # 0044a64f
    je.d8 L_0044a66e                             # 0044a651
L_0044a653:
    # block 0x0044a653: entered by ja at 0x0044a5ff; je at 0x0044a612; jne at 0x0044a627; jne at 0x0044a63c; more, 6 instruction(s), calls FUN_0051e7ba, ends with forward jump to 0x0044a687
    mov dword ptr [ebp - local_10], 0x0          # 0044a653
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044a65a
    lea ecx, [ebp + arg_8]                       # 0044a661
    call FUN_0051e7ba                            # 0044a664
    mov eax, dword ptr [ebp - local_10]          # 0044a669
    jmp.d8 L_0044a687                            # 0044a66c
L_0044a66e:
    # block 0x0044a66e: entered by je at 0x0044a651, 5 instruction(s), calls FUN_0051e7ba, falls into the block at 0x0044a687
    mov dword ptr [ebp - local_14], 0x1          # 0044a66e
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044a675
    lea ecx, [ebp + arg_8]                       # 0044a67c
    call FUN_0051e7ba                            # 0044a67f
    mov eax, dword ptr [ebp - local_14]          # 0044a684
L_0044a687:
    # block 0x0044a687: entered by jmp at 0x0044a66c, 6 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0044a687
    mov dword ptr fs:[0x0], ecx                  # 0044a68a
    pop edi                                      # 0044a691
    {load} mov esp, ebp                          # 0044a692
    pop ebp                                      # 0044a694
    ret                                          # 0044a695

