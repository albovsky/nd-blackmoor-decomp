# FUN_005167a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005167a0
# extent:       0x005167a0-0x00516808 (104 code bytes)
# span:         0x005167a0-0x00516810 (code 104, tables 0, padding 8)
# sha256:       84d17e172ff5e6bce23b7837cc15439649f685d00b3cdff9cc07cae79a0a88f2
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005167a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c, stk_10, stk_14, stk_18
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x005167a0 - 0x401000
.globl FUN_005167a0
FUN_005167a0:
    # block 0x005167a0: entry, 5 instruction(s), ends with jne to 0x005167c2 (forward)
    push ebx                                     # 005167a0
    push esi                                     # 005167a1
    mov eax, dword ptr [esp + stk_18]            # 005167a2
    {load} or eax, eax                           # 005167a6
    jne.d8 L_005167c2                            # 005167a8
    # block 0x005167aa: entered by fall-through of jne at 0x005167a8, 9 instruction(s), ends with forward jump to 0x00516803
    mov ecx, dword ptr [esp + stk_14]            # 005167aa
    mov eax, dword ptr [esp + stk_10]            # 005167ae
    {load} xor edx, edx                          # 005167b2
    div ecx                                      # 005167b4
    {load} mov ebx, eax                          # 005167b6
    mov eax, dword ptr [esp + stk_c]             # 005167b8
    div ecx                                      # 005167bc
    {load} mov edx, ebx                          # 005167be
    jmp.d8 L_00516803                            # 005167c0
L_005167c2:
    # block 0x005167c2: entered by jne at 0x005167a8, 4 instruction(s), falls into the block at 0x005167d0
    {load} mov ecx, eax                          # 005167c2
    mov ebx, dword ptr [esp + stk_14]            # 005167c4
    mov edx, dword ptr [esp + stk_10]            # 005167c8
    mov eax, dword ptr [esp + stk_c]             # 005167cc
L_005167d0:
    # block 0x005167d0: entered by jne at 0x005167da, 6 instruction(s), ends with jne to 0x005167d0 (backward)
    shr ecx                                      # 005167d0
    rcr ebx                                      # 005167d2
    shr edx                                      # 005167d4
    rcr eax                                      # 005167d6
    {load} or ecx, ecx                           # 005167d8
    jne.d8 L_005167d0                            # 005167da
    # block 0x005167dc: entered by fall-through of jne at 0x005167da, 8 instruction(s), ends with jb to 0x005167fe (forward)
    div ebx                                      # 005167dc
    {load} mov esi, eax                          # 005167de
    mul dword ptr [esp + stk_18]                 # 005167e0
    {load} mov ecx, eax                          # 005167e4
    mov eax, dword ptr [esp + stk_14]            # 005167e6
    mul esi                                      # 005167ea
    {load} add edx, ecx                          # 005167ec
    jb.d8 L_005167fe                             # 005167ee
    # block 0x005167f0: entered by fall-through of jb at 0x005167ee, 2 instruction(s), ends with ja to 0x005167fe (forward)
    cmp edx, dword ptr [esp + stk_10]            # 005167f0
    ja.d8 L_005167fe                             # 005167f4
    # block 0x005167f6: entered by fall-through of ja at 0x005167f4, 1 instruction(s), ends with jb to 0x005167ff (forward)
    jb.d8 L_005167ff                             # 005167f6
    # block 0x005167f8: entered by fall-through of jb at 0x005167f6, 2 instruction(s), ends with jbe to 0x005167ff (forward)
    cmp eax, dword ptr [esp + stk_c]             # 005167f8
    jbe.d8 L_005167ff                            # 005167fc
L_005167fe:
    # block 0x005167fe: entered by jb at 0x005167ee; ja at 0x005167f4; fall-through of jbe at 0x005167fc, 1 instruction(s), falls into the block at 0x005167ff
    dec esi                                      # 005167fe
L_005167ff:
    # block 0x005167ff: entered by jb at 0x005167f6; jbe at 0x005167fc, 2 instruction(s), falls into the block at 0x00516803
    {load} xor edx, edx                          # 005167ff
    {load} mov eax, esi                          # 00516801
L_00516803:
    # block 0x00516803: entered by jmp at 0x005167c0, 3 instruction(s), ends with ret 0x10
    pop esi                                      # 00516803
    pop ebx                                      # 00516804
    ret 0x10                                     # 00516805

# --- data items (not part of the function) -------------------------
.org 0x00516808 - 0x401000
PAD_00516808:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

