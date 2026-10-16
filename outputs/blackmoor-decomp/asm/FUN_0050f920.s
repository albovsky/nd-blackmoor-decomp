# FUN_0050f920
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f920
# extent:       0x0050f920-0x0050f978 (88 code bytes)
# span:         0x0050f920-0x0050f978 (code 88, tables 0, padding 0)
# sha256:       2af9ec6db955aa74b3de79ebe2752b3fa148e02935ac40304eb9ffc13ccf0d2c
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f920
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050f920 - 0x401000
.globl FUN_0050f920
FUN_0050f920:
    # block 0x0050f920: entry, 4 instruction(s), ends with je to 0x0050f973 (forward)
    mov edx, dword ptr [esp + stk_c]             # 0050f920
    mov ecx, dword ptr [esp + stk_4]             # 0050f924
    test edx, edx                                # 0050f928
    je.d8 L_0050f973                             # 0050f92a
    # block 0x0050f92c: entered by fall-through of je at 0x0050f92a, 6 instruction(s), ends with jb to 0x0050f967 (forward)
    {load} xor eax, eax                          # 0050f92c
    mov al, byte ptr [esp + stk_8]               # 0050f92e
    push edi                                     # 0050f932
    {load} mov edi, ecx                          # 0050f933
    cmp edx, 0x4                                 # 0050f935
    jb.d8 L_0050f967                             # 0050f938
    # block 0x0050f93a: entered by fall-through of jb at 0x0050f938, 3 instruction(s), ends with je to 0x0050f949 (forward)
    neg ecx                                      # 0050f93a
    and ecx, 0x3                                 # 0050f93c
    je.d8 L_0050f949                             # 0050f93f
    # block 0x0050f941: entered by fall-through of je at 0x0050f93f, 1 instruction(s), falls into the block at 0x0050f943
    {load} sub edx, ecx                          # 0050f941
L_0050f943:
    # block 0x0050f943: entered by jne at 0x0050f947, 4 instruction(s), ends with jne to 0x0050f943 (backward)
    mov byte ptr [edi], al                       # 0050f943
    inc edi                                      # 0050f945
    dec ecx                                      # 0050f946
    jne.d8 L_0050f943                            # 0050f947
L_0050f949:
    # block 0x0050f949: entered by je at 0x0050f93f; fall-through of jne at 0x0050f947, 10 instruction(s), ends with je to 0x0050f967 (forward)
    {load} mov ecx, eax                          # 0050f949
    shl eax, 0x8                                 # 0050f94b
    {load} add eax, ecx                          # 0050f94e
    {load} mov ecx, eax                          # 0050f950
    shl eax, 0x10                                # 0050f952
    {load} add eax, ecx                          # 0050f955
    {load} mov ecx, edx                          # 0050f957
    and edx, 0x3                                 # 0050f959
    shr ecx, 0x2                                 # 0050f95c
    je.d8 L_0050f967                             # 0050f95f
    # block 0x0050f961: entered by fall-through of je at 0x0050f95f, 3 instruction(s), ends with je to 0x0050f96d (forward)
    rep stosd dword ptr es:[edi], eax            # 0050f961
    test edx, edx                                # 0050f963
    je.d8 L_0050f96d                             # 0050f965
L_0050f967:
    # block 0x0050f967: entered by jb at 0x0050f938; je at 0x0050f95f; jne at 0x0050f96b; fall-through of je at 0x0050f965, 4 instruction(s), ends with jne to 0x0050f967 (backward)
    mov byte ptr [edi], al                       # 0050f967
    inc edi                                      # 0050f969
    dec edx                                      # 0050f96a
    jne.d8 L_0050f967                            # 0050f96b
L_0050f96d:
    # block 0x0050f96d: entered by je at 0x0050f965; fall-through of jne at 0x0050f96b, 3 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_8]             # 0050f96d
    pop edi                                      # 0050f971
    ret                                          # 0050f972
L_0050f973:
    # block 0x0050f973: entered by je at 0x0050f92a, 2 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050f973
    ret                                          # 0050f977

