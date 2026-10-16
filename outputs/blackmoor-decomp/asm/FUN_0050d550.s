# FUN_0050d550
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d550
# extent:       0x0050d550-0x0050d651 (257 code bytes)
# span:         0x0050d550-0x0050d651 (code 257, tables 0, padding 0)
# sha256:       cafadc514ad4eb4dcd888e5f9f642abe6ae84185be75fa295358cc4dee747dc2
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d550
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_8
# callees:      calls FUN_00512c18, FUN_00512f53, FUN_00512c79
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.h:convo3f_text_equal (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 106 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00512f53, .text + (0x00512f53 - 0x401000)

.org 0x0050d550 - 0x401000
.globl FUN_0050d550
FUN_0050d550:
    # block 0x0050d550: entry, 8 instruction(s), ends with je to 0x0050d64a (forward)
    push ebp                                     # 0050d550
    {load} mov ebp, esp                          # 0050d551
    push edi                                     # 0050d553
    push esi                                     # 0050d554
    push ebx                                     # 0050d555
    mov ecx, dword ptr [ebp + arg_10]            # 0050d556
    {load} or ecx, ecx                           # 0050d559
    je.d32 L_0050d64a                            # 0050d55b
    # block 0x0050d561: entered by fall-through of je at 0x0050d55b, 5 instruction(s), ends with jne to 0x0050d5c1 (forward)
    mov esi, dword ptr [ebp + arg_8]             # 0050d561
    mov edi, dword ptr [ebp + arg_c]             # 0050d564
    lea eax, [0x63cb14]                          # 0050d567
    cmp dword ptr [eax + field_8], 0x0           # 0050d56d
    jne.d8 L_0050d5c1                            # 0050d571
    # block 0x0050d573: entered by fall-through of jne at 0x0050d571, 4 instruction(s), falls into the block at 0x0050d57c
    mov bh, 0x41                                 # 0050d573
    mov bl, 0x5a                                 # 0050d575
    mov dh, 0x20                                 # 0050d577
    {disp8} lea ecx, [ecx]                       # 0050d579
L_0050d57c:
    # block 0x0050d57c: entered by jne at 0x0050d5a3, 4 instruction(s), ends with je to 0x0050d5a5 (forward)
    mov ah, byte ptr [esi]                       # 0050d57c
    {load} or ah, ah                             # 0050d57e
    mov al, byte ptr [edi]                       # 0050d580
    je.d8 L_0050d5a5                             # 0050d582
    # block 0x0050d584: entered by fall-through of je at 0x0050d582, 2 instruction(s), ends with je to 0x0050d5a5 (forward)
    {load} or al, al                             # 0050d584
    je.d8 L_0050d5a5                             # 0050d586
    # block 0x0050d588: entered by fall-through of je at 0x0050d586, 4 instruction(s), ends with jb to 0x0050d594 (forward)
    inc esi                                      # 0050d588
    inc edi                                      # 0050d589
    {store} cmp ah, bh                           # 0050d58a
    jb.d8 L_0050d594                             # 0050d58c
    # block 0x0050d58e: entered by fall-through of jb at 0x0050d58c, 2 instruction(s), ends with ja to 0x0050d594 (forward)
    {store} cmp ah, bl                           # 0050d58e
    ja.d8 L_0050d594                             # 0050d590
    # block 0x0050d592: entered by fall-through of ja at 0x0050d590, 1 instruction(s), falls into the block at 0x0050d594
    {load} add ah, dh                            # 0050d592
L_0050d594:
    # block 0x0050d594: entered by jb at 0x0050d58c; ja at 0x0050d590, 2 instruction(s), ends with jb to 0x0050d59e (forward)
    {store} cmp al, bh                           # 0050d594
    jb.d8 L_0050d59e                             # 0050d596
    # block 0x0050d598: entered by fall-through of jb at 0x0050d596, 2 instruction(s), ends with ja to 0x0050d59e (forward)
    {store} cmp al, bl                           # 0050d598
    ja.d8 L_0050d59e                             # 0050d59a
    # block 0x0050d59c: entered by fall-through of ja at 0x0050d59a, 1 instruction(s), falls into the block at 0x0050d59e
    {load} add al, dh                            # 0050d59c
L_0050d59e:
    # block 0x0050d59e: entered by jb at 0x0050d596; ja at 0x0050d59a, 2 instruction(s), ends with jne to 0x0050d5af (forward)
    {store} cmp ah, al                           # 0050d59e
    jne.d8 L_0050d5af                            # 0050d5a0
    # block 0x0050d5a2: entered by fall-through of jne at 0x0050d5a0, 2 instruction(s), ends with jne to 0x0050d57c (backward)
    dec ecx                                      # 0050d5a2
    jne.d8 L_0050d57c                            # 0050d5a3
L_0050d5a5:
    # block 0x0050d5a5: entered by je at 0x0050d582; je at 0x0050d586; fall-through of jne at 0x0050d5a3, 3 instruction(s), ends with je to 0x0050d64a (forward)
    {load} xor ecx, ecx                          # 0050d5a5
    {store} cmp ah, al                           # 0050d5a7
    je.d32 L_0050d64a                            # 0050d5a9
L_0050d5af:
    # block 0x0050d5af: entered by jne at 0x0050d5a0; fall-through of je at 0x0050d5a9, 2 instruction(s), ends with jb to 0x0050d64a (forward)
    mov ecx, 0xffffffff                          # 0050d5af
    jb.d32 L_0050d64a                            # 0050d5b4
    # block 0x0050d5ba: entered by fall-through of jb at 0x0050d5b4, 2 instruction(s), ends with forward jump to 0x0050d64a
    neg ecx                                      # 0050d5ba
    jmp.d32 L_0050d64a                           # 0050d5bc
L_0050d5c1:
    # block 0x0050d5c1: entered by jne at 0x0050d571, 4 instruction(s), ends with jg to 0x0050d5d5 (forward)
    lock                                         # 0050d5c1
    inc dword ptr [0x63cee8]                     # 0050d5c2
    cmp dword ptr [0x63cee4], 0x0                # 0050d5c8
    jg.d8 L_0050d5d5                             # 0050d5cf
    # block 0x0050d5d1: entered by fall-through of jg at 0x0050d5cf, 2 instruction(s), ends with forward jump to 0x0050d5ee
    push 0x0                                     # 0050d5d1
    jmp.d8 L_0050d5ee                            # 0050d5d3
L_0050d5d5:
    # block 0x0050d5d5: entered by jg at 0x0050d5cf, 7 instruction(s), calls FUN_00512c18, falls into the block at 0x0050d5ee
    lock                                         # 0050d5d5
    dec dword ptr [0x63cee8]                     # 0050d5d6
    {load} mov ebx, ecx                          # 0050d5dc
    push 0x13                                    # 0050d5de
    call FUN_00512c18                            # 0050d5e0
    mov dword ptr [esp], 0x1                     # 0050d5e5
    {load} mov ecx, ebx                          # 0050d5ec
L_0050d5ee:
    # block 0x0050d5ee: entered by jmp at 0x0050d5d3, 3 instruction(s), falls into the block at 0x0050d5f4
    {load} xor eax, eax                          # 0050d5ee
    {load} xor ebx, ebx                          # 0050d5f0
    {load} mov edi, edi                          # 0050d5f2
L_0050d5f4:
    # block 0x0050d5f4: entered by jne at 0x0050d61d, 4 instruction(s), ends with je to 0x0050d61f (forward)
    mov al, byte ptr [esi]                       # 0050d5f4
    {load} or eax, eax                           # 0050d5f6
    mov bl, byte ptr [edi]                       # 0050d5f8
    je.d8 L_0050d61f                             # 0050d5fa
    # block 0x0050d5fc: entered by fall-through of je at 0x0050d5fa, 2 instruction(s), ends with je to 0x0050d61f (forward)
    {load} or ebx, ebx                           # 0050d5fc
    je.d8 L_0050d61f                             # 0050d5fe
    # block 0x0050d600: entered by fall-through of je at 0x0050d5fe, 13 instruction(s), calls FUN_00512f53, ends with jne to 0x0050d625 (forward)
    inc esi                                      # 0050d600
    inc edi                                      # 0050d601
    push ecx                                     # 0050d602
    push eax                                     # 0050d603
    push ebx                                     # 0050d604
    call FUN_00512f53                            # 0050d605
    {load} mov ebx, eax                          # 0050d60a
    add esp, 0x4                                 # 0050d60c
    call FUN_00512f53                            # 0050d60f
    add esp, 0x4                                 # 0050d614
    pop ecx                                      # 0050d617
    {load} cmp eax, ebx                          # 0050d618
    jne.d8 L_0050d625                            # 0050d61a
    # block 0x0050d61c: entered by fall-through of jne at 0x0050d61a, 2 instruction(s), ends with jne to 0x0050d5f4 (backward)
    dec ecx                                      # 0050d61c
    jne.d8 L_0050d5f4                            # 0050d61d
L_0050d61f:
    # block 0x0050d61f: entered by je at 0x0050d5fa; je at 0x0050d5fe; fall-through of jne at 0x0050d61d, 3 instruction(s), ends with je to 0x0050d62e (forward)
    {load} xor ecx, ecx                          # 0050d61f
    {load} cmp eax, ebx                          # 0050d621
    je.d8 L_0050d62e                             # 0050d623
L_0050d625:
    # block 0x0050d625: entered by jne at 0x0050d61a; fall-through of je at 0x0050d623, 2 instruction(s), ends with jb to 0x0050d62e (forward)
    mov ecx, 0xffffffff                          # 0050d625
    jb.d8 L_0050d62e                             # 0050d62a
    # block 0x0050d62c: entered by fall-through of jb at 0x0050d62a, 1 instruction(s), falls into the block at 0x0050d62e
    neg ecx                                      # 0050d62c
L_0050d62e:
    # block 0x0050d62e: entered by je at 0x0050d623; jb at 0x0050d62a, 3 instruction(s), ends with jne to 0x0050d63c (forward)
    pop eax                                      # 0050d62e
    {load} or eax, eax                           # 0050d62f
    jne.d8 L_0050d63c                            # 0050d631
    # block 0x0050d633: entered by fall-through of jne at 0x0050d631, 3 instruction(s), ends with forward jump to 0x0050d64a
    lock                                         # 0050d633
    dec dword ptr [0x63cee8]                     # 0050d634
    jmp.d8 L_0050d64a                            # 0050d63a
L_0050d63c:
    # block 0x0050d63c: entered by jne at 0x0050d631, 5 instruction(s), calls FUN_00512c79, falls into the block at 0x0050d64a
    {load} mov ebx, ecx                          # 0050d63c
    push 0x13                                    # 0050d63e
    call FUN_00512c79                            # 0050d640
    add esp, 0x4                                 # 0050d645
    {load} mov ecx, ebx                          # 0050d648
L_0050d64a:
    # block 0x0050d64a: entered by je at 0x0050d55b; je at 0x0050d5a9; jb at 0x0050d5b4; jmp at 0x0050d5bc; jmp at 0x0050d63a, 6 instruction(s), ends with ret
    {load} mov eax, ecx                          # 0050d64a
    pop ebx                                      # 0050d64c
    pop esi                                      # 0050d64d
    pop edi                                      # 0050d64e
    leave                                        # 0050d64f
    ret                                          # 0050d650

