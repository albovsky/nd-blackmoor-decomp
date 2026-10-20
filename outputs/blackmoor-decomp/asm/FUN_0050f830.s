# FUN_0050f830
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f830
# extent:       0x0050f830-0x0050f8d5 (165 code bytes)
# span:         0x0050f830-0x0050f8d5 (code 165, tables 0, padding 0)
# sha256:       0e6910ad40067aac7452d3a10910565b2cbdfb4f6232aabd05738c34e4c87b70
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         _memchr
# naming:       Ghidra name from function-index.json (not re-derived here); note is the ledger reason (host_libc_standard_contract, function-ledger-overrides.json not_needed_entries)
# name-note:    returns pointer to first byte equal to value within count bytes or NULL; word-at-a-time scan, no side effects
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_minus_1, field_minus_2, field_minus_3, field_minus_4; [esp + n] stk_8, stk_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 76 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_2, 0x2  # offset -0x2
.equ field_minus_3, 0x3  # offset -0x3
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050f830 - 0x401000
.globl FUN_0050f830
FUN_0050f830:
    # block 0x0050f830: entry, 4 instruction(s), ends with je to 0x0050f883 (forward)
    mov eax, dword ptr [esp + stk_c]             # 0050f830
    push ebx                                     # 0050f834
    test eax, eax                                # 0050f835
    je.d8 L_0050f883                             # 0050f837
    # block 0x0050f839: entered by fall-through of je at 0x0050f837, 5 instruction(s), ends with je to 0x0050f85d (forward)
    mov edx, dword ptr [esp + stk_8]             # 0050f839
    {load} xor ebx, ebx                          # 0050f83d
    mov bl, byte ptr [esp + stk_c]               # 0050f83f
    test edx, 0x3                                # 0050f843
    je.d8 L_0050f85d                             # 0050f849
L_0050f84b:
    # block 0x0050f84b: entered by jne at 0x0050f85b; fall-through of je at 0x0050f849, 4 instruction(s), ends with je to 0x0050f8be (forward)
    mov cl, byte ptr [edx]                       # 0050f84b
    inc edx                                      # 0050f84d
    {load} xor cl, bl                            # 0050f84e
    je.d8 L_0050f8be                             # 0050f850
    # block 0x0050f852: entered by fall-through of je at 0x0050f850, 2 instruction(s), ends with je to 0x0050f883 (forward)
    dec eax                                      # 0050f852
    je.d8 L_0050f883                             # 0050f853
    # block 0x0050f855: entered by fall-through of je at 0x0050f853, 2 instruction(s), ends with jne to 0x0050f84b (backward)
    test edx, 0x3                                # 0050f855
    jne.d8 L_0050f84b                            # 0050f85b
L_0050f85d:
    # block 0x0050f85d: entered by je at 0x0050f849; fall-through of jne at 0x0050f85b, 2 instruction(s), ends with jb to 0x0050f874 (forward)
    sub eax, 0x4                                 # 0050f85d
    jb.d8 L_0050f874                             # 0050f860
    # block 0x0050f862: entered by fall-through of jb at 0x0050f860, 8 instruction(s), ends with forward jump to 0x0050f88a
    push edi                                     # 0050f862
    {load} mov edi, ebx                          # 0050f863
    shl ebx, 0x8                                 # 0050f865
    {load} add ebx, edi                          # 0050f868
    {load} mov edi, ebx                          # 0050f86a
    shl ebx, 0x10                                # 0050f86c
    {load} add ebx, edi                          # 0050f86f
    jmp.d8 L_0050f88a                            # 0050f871
L_0050f873:
    # block 0x0050f873: entered by jb at 0x0050f888, 1 instruction(s), falls into the block at 0x0050f874
    pop edi                                      # 0050f873
L_0050f874:
    # block 0x0050f874: entered by jb at 0x0050f860, 2 instruction(s), ends with je to 0x0050f883 (forward)
    add eax, 0x4                                 # 0050f874
    je.d8 L_0050f883                             # 0050f877
L_0050f879:
    # block 0x0050f879: entered by jne at 0x0050f881; fall-through of je at 0x0050f877, 4 instruction(s), ends with je to 0x0050f8be (forward)
    mov cl, byte ptr [edx]                       # 0050f879
    inc edx                                      # 0050f87b
    {load} xor cl, bl                            # 0050f87c
    je.d8 L_0050f8be                             # 0050f87e
    # block 0x0050f880: entered by fall-through of je at 0x0050f87e, 2 instruction(s), ends with jne to 0x0050f879 (backward)
    dec eax                                      # 0050f880
    jne.d8 L_0050f879                            # 0050f881
L_0050f883:
    # block 0x0050f883: entered by je at 0x0050f837; je at 0x0050f853; je at 0x0050f877; fall-through of jne at 0x0050f881, 2 instruction(s), ends with ret
    pop ebx                                      # 0050f883
    ret                                          # 0050f884
L_0050f885:
    # block 0x0050f885: entered by je at 0x0050f8a3; jmp at 0x0050f8bb, 2 instruction(s), ends with jb to 0x0050f873 (backward)
    sub eax, 0x4                                 # 0050f885
    jb.d8 L_0050f873                             # 0050f888
L_0050f88a:
    # block 0x0050f88a: entered by jmp at 0x0050f871; fall-through of jb at 0x0050f888, 9 instruction(s), ends with je to 0x0050f885 (backward)
    mov ecx, dword ptr [edx]                     # 0050f88a
    {load} xor ecx, ebx                          # 0050f88c
    mov edi, 0x7efefeff                          # 0050f88e
    {load} add edi, ecx                          # 0050f893
    xor ecx, -0x1                                # 0050f895
    {load} xor ecx, edi                          # 0050f898
    add edx, 0x4                                 # 0050f89a
    and ecx, 0x81010100                          # 0050f89d
    je.d8 L_0050f885                             # 0050f8a3
    # block 0x0050f8a5: entered by fall-through of je at 0x0050f8a3, 3 instruction(s), ends with je to 0x0050f8cf (forward)
    mov ecx, dword ptr [edx - field_minus_4]     # 0050f8a5
    {load} xor cl, bl                            # 0050f8a8
    je.d8 L_0050f8cf                             # 0050f8aa
    # block 0x0050f8ac: entered by fall-through of je at 0x0050f8aa, 2 instruction(s), ends with je to 0x0050f8c9 (forward)
    {load} xor ch, bl                            # 0050f8ac
    je.d8 L_0050f8c9                             # 0050f8ae
    # block 0x0050f8b0: entered by fall-through of je at 0x0050f8ae, 3 instruction(s), ends with je to 0x0050f8c3 (forward)
    shr ecx, 0x10                                # 0050f8b0
    {load} xor cl, bl                            # 0050f8b3
    je.d8 L_0050f8c3                             # 0050f8b5
    # block 0x0050f8b7: entered by fall-through of je at 0x0050f8b5, 2 instruction(s), ends with je to 0x0050f8bd (forward)
    {load} xor ch, bl                            # 0050f8b7
    je.d8 L_0050f8bd                             # 0050f8b9
    # block 0x0050f8bb: entered by fall-through of je at 0x0050f8b9, 1 instruction(s), ends with backward jump to 0x0050f885
    jmp.d8 L_0050f885                            # 0050f8bb
L_0050f8bd:
    # block 0x0050f8bd: entered by je at 0x0050f8b9, 1 instruction(s), falls into the block at 0x0050f8be
    pop edi                                      # 0050f8bd
L_0050f8be:
    # block 0x0050f8be: entered by je at 0x0050f850; je at 0x0050f87e, 3 instruction(s), ends with ret
    lea eax, [edx - field_minus_1]               # 0050f8be
    pop ebx                                      # 0050f8c1
    ret                                          # 0050f8c2
L_0050f8c3:
    # block 0x0050f8c3: entered by je at 0x0050f8b5, 4 instruction(s), ends with ret
    lea eax, [edx - field_minus_2]               # 0050f8c3
    pop edi                                      # 0050f8c6
    pop ebx                                      # 0050f8c7
    ret                                          # 0050f8c8
L_0050f8c9:
    # block 0x0050f8c9: entered by je at 0x0050f8ae, 4 instruction(s), ends with ret
    lea eax, [edx - field_minus_3]               # 0050f8c9
    pop edi                                      # 0050f8cc
    pop ebx                                      # 0050f8cd
    ret                                          # 0050f8ce
L_0050f8cf:
    # block 0x0050f8cf: entered by je at 0x0050f8aa, 4 instruction(s), ends with ret
    lea eax, [edx - field_minus_4]               # 0050f8cf
    pop edi                                      # 0050f8d2
    pop ebx                                      # 0050f8d3
    ret                                          # 0050f8d4

