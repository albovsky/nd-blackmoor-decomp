# FUN_00525697
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525697
# extent:       0x00525697-0x005256dd (70 code bytes)
# span:         0x00525697-0x005256dd (code 70, tables 0, padding 0)
# sha256:       e0bd8948eda9bc599c95e7a6e9269fcea73d1de01c1267c8d969174ac1115967
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525697
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00525697 - 0x401000
.globl FUN_00525697
FUN_00525697:
    # block 0x00525697: entry, 3 instruction(s), ends with jne to 0x005256a1 (forward)
    mov edx, dword ptr [ecx]                     # 00525697
    test edx, edx                                # 00525699
    jne.d8 L_005256a1                            # 0052569b
    # block 0x0052569d: entered by fall-through of jne at 0x0052569b, 2 instruction(s), ends with forward jump to 0x005256da
    {load} xor eax, eax                          # 0052569d
    jmp.d8 L_005256da                            # 0052569f
L_005256a1:
    # block 0x005256a1: entered by jne at 0x0052569b, 5 instruction(s), ends with jne to 0x005256b6 (forward)
    push esi                                     # 005256a1
    mov esi, dword ptr [esp + stk_8]             # 005256a2
    {load} xor eax, eax                          # 005256a6
    {load} cmp edx, esi                          # 005256a8
    jne.d8 L_005256b6                            # 005256aa
    # block 0x005256ac: entered by fall-through of jne at 0x005256aa, 4 instruction(s), ends with forward jump to 0x005256d6
    mov eax, dword ptr [ecx + field_4]           # 005256ac
    mov eax, dword ptr [eax + esi]               # 005256af
    mov dword ptr [ecx], eax                     # 005256b2
    jmp.d8 L_005256d6                            # 005256b4
L_005256b6:
    # block 0x005256b6: entered by jne at 0x005256aa, 2 instruction(s), ends with je to 0x005256d9 (forward)
    test edx, edx                                # 005256b6
    je.d8 L_005256d9                             # 005256b8
    # block 0x005256ba: entered by fall-through of je at 0x005256b8, 2 instruction(s), falls into the block at 0x005256be
    mov ecx, dword ptr [ecx + field_4]           # 005256ba
    push edi                                     # 005256bd
L_005256be:
    # block 0x005256be: entered by jne at 0x005256c9, 3 instruction(s), ends with je to 0x005256cb (forward)
    mov edi, dword ptr [ecx + edx]               # 005256be
    {load} cmp edi, esi                          # 005256c1
    je.d8 L_005256cb                             # 005256c3
    # block 0x005256c5: entered by fall-through of je at 0x005256c3, 3 instruction(s), ends with jne to 0x005256be (backward)
    {load} mov edx, edi                          # 005256c5
    test edx, edx                                # 005256c7
    jne.d8 L_005256be                            # 005256c9
L_005256cb:
    # block 0x005256cb: entered by je at 0x005256c3; fall-through of jne at 0x005256c9, 3 instruction(s), ends with je to 0x005256d9 (forward)
    test edx, edx                                # 005256cb
    pop edi                                      # 005256cd
    je.d8 L_005256d9                             # 005256ce
    # block 0x005256d0: entered by fall-through of je at 0x005256ce, 2 instruction(s), falls into the block at 0x005256d6
    mov eax, dword ptr [ecx + esi]               # 005256d0
    mov dword ptr [ecx + edx], eax               # 005256d3
L_005256d6:
    # block 0x005256d6: entered by jmp at 0x005256b4, 2 instruction(s), falls into the block at 0x005256d9
    push 0x1                                     # 005256d6
    pop eax                                      # 005256d8
L_005256d9:
    # block 0x005256d9: entered by je at 0x005256b8; je at 0x005256ce, 1 instruction(s), falls into the block at 0x005256da
    pop esi                                      # 005256d9
L_005256da:
    # block 0x005256da: entered by jmp at 0x0052569f, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 005256da

