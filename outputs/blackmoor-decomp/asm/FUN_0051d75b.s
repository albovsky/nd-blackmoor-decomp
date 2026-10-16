# FUN_0051d75b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d75b
# extent:       0x0051d75b-0x0051d862 (263 code bytes)
# span:         0x0051d75b-0x0051d862 (code 263, tables 0, padding 0)
# sha256:       976548ac6b39a220c6bd604afb6daa0da267f74a2976fc01227dccbfde76203b
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d75b
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_14, arg_18, arg_1c, arg_20; ret 0x1c (callee pops 28 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4; [esi + n] field_1c
# callees:      none direct; 10 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 107 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------

.org 0x0051d75b - 0x401000
.globl FUN_0051d75b
FUN_0051d75b:
    # block 0x0051d75b: entry, 9 instruction(s), ends with je to 0x0051d77a (forward)
    push ebp                                     # 0051d75b
    {load} mov ebp, esp                          # 0051d75c
    mov eax, dword ptr [ebp + arg_20]            # 0051d75e
    push ebx                                     # 0051d761
    push esi                                     # 0051d762
    push 0x1                                     # 0051d763
    test eax, eax                                # 0051d765
    pop ebx                                      # 0051d767
    je.d8 L_0051d77a                             # 0051d768
    # block 0x0051d76a: entered by fall-through of je at 0x0051d768, 5 instruction(s), ends with forward jump to 0x0051d85a
    mov ecx, dword ptr [ebp + arg_8]             # 0051d76a
    mov dword ptr [eax], ecx                     # 0051d76d
    mov ecx, dword ptr [ebp + arg_14]            # 0051d76f
    mov dword ptr [eax + field_4], ecx           # 0051d772
    jmp.d32 L_0051d85a                           # 0051d775
L_0051d77a:
    # block 0x0051d77a: entered by je at 0x0051d768, 3 instruction(s), ends with ja to 0x0051d7f3 (forward)
    mov eax, dword ptr [ebp + arg_1c]            # 0051d77a
    cmp eax, 0x28                                # 0051d77d
    ja.d8 L_0051d7f3                             # 0051d780
    # block 0x0051d782: entered by fall-through of ja at 0x0051d780, 1 instruction(s), ends with je to 0x0051d7e0 (forward)
    je.d8 L_0051d7e0                             # 0051d782
    # block 0x0051d784: entered by fall-through of je at 0x0051d782, 3 instruction(s), ends with je to 0x0051d7db (forward)
    dec eax                                      # 0051d784
    dec eax                                      # 0051d785
    je.d8 L_0051d7db                             # 0051d786
    # block 0x0051d788: entered by fall-through of je at 0x0051d786, 2 instruction(s), ends with je to 0x0051d7d3 (forward)
    sub eax, 0xa                                 # 0051d788
    je.d8 L_0051d7d3                             # 0051d78b
    # block 0x0051d78d: entered by fall-through of je at 0x0051d78b, 2 instruction(s), ends with je to 0x0051d7ce (forward)
    dec eax                                      # 0051d78d
    je.d8 L_0051d7ce                             # 0051d78e
    # block 0x0051d790: entered by fall-through of je at 0x0051d78e, 2 instruction(s), ends with je to 0x0051d7c3 (forward)
    sub eax, 0x16                                # 0051d790
    je.d8 L_0051d7c3                             # 0051d793
    # block 0x0051d795: entered by fall-through of je at 0x0051d793, 2 instruction(s), ends with je to 0x0051d7b0 (forward)
    sub eax, 0x3                                 # 0051d795
    je.d8 L_0051d7b0                             # 0051d798
    # block 0x0051d79a: entered by fall-through of je at 0x0051d798, 2 instruction(s), ends with jne to 0x0051d806 (forward)
    dec eax                                      # 0051d79a
    jne.d8 L_0051d806                            # 0051d79b
    # block 0x0051d79d: entered by fall-through of jne at 0x0051d79b, 6 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with forward jump to 0x0051d858
    mov eax, dword ptr [ebp + arg_18]            # 0051d79d
    mov ecx, dword ptr [ebp + arg_8]             # 0051d7a0
    push dword ptr [eax]                         # 0051d7a3
    push dword ptr [eax + field_4]               # 0051d7a5
    call dword ptr [ebp + arg_14]                # 0051d7a8
    jmp.d32 L_0051d858                           # 0051d7ab
L_0051d7b0:
    # block 0x0051d7b0: entered by je at 0x0051d798, 6 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with forward jump to 0x0051d85a
    mov eax, dword ptr [ebp + arg_18]            # 0051d7b0
    mov ecx, dword ptr [ebp + arg_8]             # 0051d7b3
    push dword ptr [eax]                         # 0051d7b6
    push dword ptr [eax + field_4]               # 0051d7b8
    call dword ptr [ebp + arg_14]                # 0051d7bb
    jmp.d32 L_0051d85a                           # 0051d7be
L_0051d7c3:
    # block 0x0051d7c3: entered by je at 0x0051d793, 3 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with forward jump to 0x0051d858
    mov ecx, dword ptr [ebp + arg_8]             # 0051d7c3
    call dword ptr [ebp + arg_14]                # 0051d7c6
    jmp.d32 L_0051d858                           # 0051d7c9
L_0051d7ce:
    # block 0x0051d7ce: entered by je at 0x0051d78e, 2 instruction(s), ends with forward jump to 0x0051d818
    push dword ptr [ebp + arg_c]                 # 0051d7ce
    jmp.d8 L_0051d818                            # 0051d7d1
L_0051d7d3:
    # block 0x0051d7d3: entered by je at 0x0051d78b, 3 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with forward jump to 0x0051d85a
    mov ecx, dword ptr [ebp + arg_8]             # 0051d7d3
    call dword ptr [ebp + arg_14]                # 0051d7d6
    jmp.d8 L_0051d85a                            # 0051d7d9
L_0051d7db:
    # block 0x0051d7db: entered by je at 0x0051d786, 2 instruction(s), ends with forward jump to 0x0051d80d
    push dword ptr [ebp + arg_c]                 # 0051d7db
    jmp.d8 L_0051d80d                            # 0051d7de
L_0051d7e0:
    # block 0x0051d7e0: entered by je at 0x0051d782, 7 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with forward jump to 0x0051d85a
    mov eax, dword ptr [ebp + arg_18]            # 0051d7e0
    mov ecx, dword ptr [ebp + arg_8]             # 0051d7e3
    push dword ptr [eax]                         # 0051d7e6
    push dword ptr [eax + field_4]               # 0051d7e8
    push dword ptr [ebp + arg_c]                 # 0051d7eb
    call dword ptr [ebp + arg_14]                # 0051d7ee
    jmp.d8 L_0051d85a                            # 0051d7f1
L_0051d7f3:
    # block 0x0051d7f3: entered by ja at 0x0051d780, 2 instruction(s), ends with je to 0x0051d847 (forward)
    sub eax, 0x29                                # 0051d7f3
    je.d8 L_0051d847                             # 0051d7f6
    # block 0x0051d7f8: entered by fall-through of je at 0x0051d7f6, 2 instruction(s), ends with je to 0x0051d83b (forward)
    sub eax, 0x3                                 # 0051d7f8
    je.d8 L_0051d83b                             # 0051d7fb
    # block 0x0051d7fd: entered by fall-through of je at 0x0051d7fb, 2 instruction(s), ends with je to 0x0051d820 (forward)
    dec eax                                      # 0051d7fd
    je.d8 L_0051d820                             # 0051d7fe
    # block 0x0051d800: entered by fall-through of je at 0x0051d7fe, 2 instruction(s), ends with je to 0x0051d815 (forward)
    dec eax                                      # 0051d800
    je.d8 L_0051d815                             # 0051d801
    # block 0x0051d803: entered by fall-through of je at 0x0051d801, 2 instruction(s), ends with je to 0x0051d80a (forward)
    dec eax                                      # 0051d803
    je.d8 L_0051d80a                             # 0051d804
L_0051d806:
    # block 0x0051d806: entered by jne at 0x0051d79b; fall-through of je at 0x0051d804, 2 instruction(s), ends with forward jump to 0x0051d85c
    {load} xor eax, eax                          # 0051d806
    jmp.d8 L_0051d85c                            # 0051d808
L_0051d80a:
    # block 0x0051d80a: entered by je at 0x0051d804, 1 instruction(s), falls into the block at 0x0051d80d
    push dword ptr [ebp + arg_18]                # 0051d80a
L_0051d80d:
    # block 0x0051d80d: entered by jmp at 0x0051d7de, 3 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with forward jump to 0x0051d858
    mov ecx, dword ptr [ebp + arg_8]             # 0051d80d
    call dword ptr [ebp + arg_14]                # 0051d810
    jmp.d8 L_0051d858                            # 0051d813
L_0051d815:
    # block 0x0051d815: entered by je at 0x0051d801, 1 instruction(s), falls into the block at 0x0051d818
    push dword ptr [ebp + arg_18]                # 0051d815
L_0051d818:
    # block 0x0051d818: entered by jmp at 0x0051d7d1, 3 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with forward jump to 0x0051d85a
    mov ecx, dword ptr [ebp + arg_8]             # 0051d818
    call dword ptr [ebp + arg_14]                # 0051d81b
    jmp.d8 L_0051d85a                            # 0051d81e
L_0051d820:
    # block 0x0051d820: entered by je at 0x0051d7fe, 5 instruction(s), calls indirect dword ptr [ebp + 0x14], falls into the block at 0x0051d82d
    push dword ptr [ebp + arg_c]                 # 0051d820
    mov esi, dword ptr [ebp + arg_18]            # 0051d823
    mov ecx, dword ptr [ebp + arg_8]             # 0051d826
    push esi                                     # 0051d829
    call dword ptr [ebp + arg_14]                # 0051d82a
L_0051d82d:
    # block 0x0051d82d: entered by jmp at 0x0051d845, 5 instruction(s), ends with forward jump to 0x0051d85a
    {load} xor ebx, ebx                          # 0051d82d
    cmp dword ptr [esi + field_1c], ebx          # 0051d82f
    sete bl                                      # 0051d832
    and dword ptr [esi + field_1c], 0x0          # 0051d835
    jmp.d8 L_0051d85a                            # 0051d839
L_0051d83b:
    # block 0x0051d83b: entered by je at 0x0051d7fb, 5 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with backward jump to 0x0051d82d
    mov esi, dword ptr [ebp + arg_18]            # 0051d83b
    mov ecx, dword ptr [ebp + arg_8]             # 0051d83e
    push esi                                     # 0051d841
    call dword ptr [ebp + arg_14]                # 0051d842
    jmp.d8 L_0051d82d                            # 0051d845
L_0051d847:
    # block 0x0051d847: entered by je at 0x0051d7f6, 6 instruction(s), calls indirect dword ptr [ebp + 0x14], falls into the block at 0x0051d858
    mov eax, dword ptr [ebp + arg_18]            # 0051d847
    mov ecx, dword ptr [ebp + arg_8]             # 0051d84a
    push dword ptr [eax]                         # 0051d84d
    push dword ptr [eax + field_4]               # 0051d84f
    push dword ptr [ebp + arg_c]                 # 0051d852
    call dword ptr [ebp + arg_14]                # 0051d855
L_0051d858:
    # block 0x0051d858: entered by jmp at 0x0051d7ab; jmp at 0x0051d7c9; jmp at 0x0051d813, 1 instruction(s), falls into the block at 0x0051d85a
    {load} mov ebx, eax                          # 0051d858
L_0051d85a:
    # block 0x0051d85a: entered by jmp at 0x0051d775; jmp at 0x0051d7be; jmp at 0x0051d7d9; jmp at 0x0051d7f1; more, 1 instruction(s), falls into the block at 0x0051d85c
    {load} mov eax, ebx                          # 0051d85a
L_0051d85c:
    # block 0x0051d85c: entered by jmp at 0x0051d808, 4 instruction(s), ends with ret 0x1c
    pop esi                                      # 0051d85c
    pop ebx                                      # 0051d85d
    pop ebp                                      # 0051d85e
    ret 0x1c                                     # 0051d85f

