# FUN_00516810
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516810
# extent:       0x00516810-0x00516885 (117 code bytes)
# span:         0x00516810-0x00516885 (code 117, tables 0, padding 0)
# sha256:       e85ca4198a284fa33b4141d18479ff2edfded90a25e35567ac9d55bd2bccb611
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __aullrem
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c, stk_10, stk_14
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x00516810 - 0x401000
.globl FUN_00516810
FUN_00516810:
    # block 0x00516810: entry, 4 instruction(s), ends with jne to 0x00516831 (forward)
    push ebx                                     # 00516810
    mov eax, dword ptr [esp + stk_14]            # 00516811
    {load} or eax, eax                           # 00516815
    jne.d8 L_00516831                            # 00516817
    # block 0x00516819: entered by fall-through of jne at 0x00516817, 9 instruction(s), ends with forward jump to 0x00516881
    mov ecx, dword ptr [esp + stk_10]            # 00516819
    mov eax, dword ptr [esp + stk_c]             # 0051681d
    {load} xor edx, edx                          # 00516821
    div ecx                                      # 00516823
    mov eax, dword ptr [esp + stk_8]             # 00516825
    div ecx                                      # 00516829
    {load} mov eax, edx                          # 0051682b
    {load} xor edx, edx                          # 0051682d
    jmp.d8 L_00516881                            # 0051682f
L_00516831:
    # block 0x00516831: entered by jne at 0x00516817, 4 instruction(s), falls into the block at 0x0051683f
    {load} mov ecx, eax                          # 00516831
    mov ebx, dword ptr [esp + stk_10]            # 00516833
    mov edx, dword ptr [esp + stk_c]             # 00516837
    mov eax, dword ptr [esp + stk_8]             # 0051683b
L_0051683f:
    # block 0x0051683f: entered by jne at 0x00516849, 6 instruction(s), ends with jne to 0x0051683f (backward)
    shr ecx                                      # 0051683f
    rcr ebx                                      # 00516841
    shr edx                                      # 00516843
    rcr eax                                      # 00516845
    {load} or ecx, ecx                           # 00516847
    jne.d8 L_0051683f                            # 00516849
    # block 0x0051684b: entered by fall-through of jne at 0x00516849, 7 instruction(s), ends with jb to 0x0051686a (forward)
    div ebx                                      # 0051684b
    {load} mov ecx, eax                          # 0051684d
    mul dword ptr [esp + stk_14]                 # 0051684f
    xchg eax, ecx                                # 00516853
    mul dword ptr [esp + stk_10]                 # 00516854
    {load} add edx, ecx                          # 00516858
    jb.d8 L_0051686a                             # 0051685a
    # block 0x0051685c: entered by fall-through of jb at 0x0051685a, 2 instruction(s), ends with ja to 0x0051686a (forward)
    cmp edx, dword ptr [esp + stk_c]             # 0051685c
    ja.d8 L_0051686a                             # 00516860
    # block 0x00516862: entered by fall-through of ja at 0x00516860, 1 instruction(s), ends with jb to 0x00516872 (forward)
    jb.d8 L_00516872                             # 00516862
    # block 0x00516864: entered by fall-through of jb at 0x00516862, 2 instruction(s), ends with jbe to 0x00516872 (forward)
    cmp eax, dword ptr [esp + stk_8]             # 00516864
    jbe.d8 L_00516872                            # 00516868
L_0051686a:
    # block 0x0051686a: entered by jb at 0x0051685a; ja at 0x00516860; fall-through of jbe at 0x00516868, 2 instruction(s), falls into the block at 0x00516872
    sub eax, dword ptr [esp + stk_10]            # 0051686a
    sbb edx, dword ptr [esp + stk_14]            # 0051686e
L_00516872:
    # block 0x00516872: entered by jb at 0x00516862; jbe at 0x00516868, 5 instruction(s), falls into the block at 0x00516881
    sub eax, dword ptr [esp + stk_8]             # 00516872
    sbb edx, dword ptr [esp + stk_c]             # 00516876
    neg edx                                      # 0051687a
    neg eax                                      # 0051687c
    sbb edx, 0x0                                 # 0051687e
L_00516881:
    # block 0x00516881: entered by jmp at 0x0051682f, 2 instruction(s), ends with ret 0x10
    pop ebx                                      # 00516881
    ret 0x10                                     # 00516882

