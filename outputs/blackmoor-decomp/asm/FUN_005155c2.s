# FUN_005155c2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005155c2
# extent:       0x005155c2-0x00515673 (177 code bytes)
# span:         0x005155c2-0x00515673 (code 177, tables 0, padding 0)
# sha256:       b1e9d620345dd1c72abb8fefd999e809e44c1a33bf3f571c630577c4cbdd9aba
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005155c2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_50; [esi + n] field_4, field_8, field_c, field_10
# callees:      calls KERNEL32.dll!HeapReAlloc, KERNEL32.dll!HeapAlloc, KERNEL32.dll!VirtualAlloc, KERNEL32.dll!HeapFree
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 53 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------

.org 0x005155c2 - 0x401000
.globl FUN_005155c2
FUN_005155c2:
    # block 0x005155c2: entry, 7 instruction(s), ends with jne to 0x00515605 (forward)
    mov eax, dword ptr [0x63cdd0]                # 005155c2
    mov ecx, dword ptr [0x63cdc0]                # 005155c7
    push esi                                     # 005155cd
    push edi                                     # 005155ce
    {load} xor edi, edi                          # 005155cf
    {load} cmp eax, ecx                          # 005155d1
    jne.d8 L_00515605                            # 005155d3
    # block 0x005155d5: entered by fall-through of jne at 0x005155d3, 9 instruction(s), calls KERNEL32.dll!HeapReAlloc, ends with je to 0x00515655 (forward)
    lea eax, [ecx + 4*ecx + field_50]            # 005155d5
    shl eax, 0x2                                 # 005155d9
    push eax                                     # 005155dc
    push dword ptr [0x63cdd4]                    # 005155dd
    push edi                                     # 005155e3
    push dword ptr [0x63cdd8]                    # 005155e4
    call dword ptr [0x52a154]                    # 005155ea
    {load} cmp eax, edi                          # 005155f0
    je.d8 L_00515655                             # 005155f2
    # block 0x005155f4: entered by fall-through of je at 0x005155f2, 3 instruction(s), falls into the block at 0x00515605
    add dword ptr [0x63cdc0], 0x10               # 005155f4
    mov dword ptr [0x63cdd4], eax                # 005155fb
    mov eax, dword ptr [0x63cdd0]                # 00515600
L_00515605:
    # block 0x00515605: entered by jne at 0x005155d3, 10 instruction(s), calls KERNEL32.dll!HeapAlloc, ends with je to 0x00515655 (forward)
    mov ecx, dword ptr [0x63cdd4]                # 00515605
    push 0x41c4                                  # 0051560b
    push 0x8                                     # 00515610
    lea eax, [eax + 4*eax]                       # 00515612
    push dword ptr [0x63cdd8]                    # 00515615
    lea esi, [ecx + 4*eax]                       # 0051561b
    call dword ptr [0x52a150]                    # 0051561e
    {load} cmp eax, edi                          # 00515624
    mov dword ptr [esi + field_10], eax          # 00515626
    je.d8 L_00515655                             # 00515629
    # block 0x0051562b: entered by fall-through of je at 0x00515629, 8 instruction(s), calls KERNEL32.dll!VirtualAlloc, ends with jne to 0x00515659 (forward)
    push 0x4                                     # 0051562b
    push 0x2000                                  # 0051562d
    push 0x100000                                # 00515632
    push edi                                     # 00515637
    call dword ptr [0x52a1a0]                    # 00515638
    {load} cmp eax, edi                          # 0051563e
    mov dword ptr [esi + field_c], eax           # 00515640
    jne.d8 L_00515659                            # 00515643
    # block 0x00515645: entered by fall-through of jne at 0x00515643, 4 instruction(s), calls KERNEL32.dll!HeapFree, falls into the block at 0x00515655
    push dword ptr [esi + field_10]              # 00515645
    push edi                                     # 00515648
    push dword ptr [0x63cdd8]                    # 00515649
    call dword ptr [0x52a14c]                    # 0051564f
L_00515655:
    # block 0x00515655: entered by je at 0x005155f2; je at 0x00515629, 2 instruction(s), ends with forward jump to 0x00515670
    {load} xor eax, eax                          # 00515655
    jmp.d8 L_00515670                            # 00515657
L_00515659:
    # block 0x00515659: entered by jne at 0x00515643, 7 instruction(s), falls into the block at 0x00515670
    or dword ptr [esi + field_8], -0x1           # 00515659
    mov dword ptr [esi], edi                     # 0051565d
    mov dword ptr [esi + field_4], edi           # 0051565f
    inc dword ptr [0x63cdd0]                     # 00515662
    mov eax, dword ptr [esi + field_10]          # 00515668
    or dword ptr [eax], -0x1                     # 0051566b
    {load} mov eax, esi                          # 0051566e
L_00515670:
    # block 0x00515670: entered by jmp at 0x00515657, 3 instruction(s), ends with ret
    pop edi                                      # 00515670
    pop esi                                      # 00515671
    ret                                          # 00515672

