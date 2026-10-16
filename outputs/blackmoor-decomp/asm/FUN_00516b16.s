# FUN_00516b16
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516b16
# extent:       0x00516b16-0x00516b31 (27 code bytes)
# span:         0x00516b16-0x00516b31 (code 27, tables 0, padding 0)
# sha256:       5c6287e9a29c103f5ab080193bcc8739fd6f6374d68ac591c9b666d73913d8c2
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516b16
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00516b16 - 0x401000
.globl FUN_00516b16
FUN_00516b16:
    # block 0x00516b16: entry, 6 instruction(s), falls into the block at 0x00516b24
    mov eax, dword ptr [esp + stk_8]             # 00516b16
    mov ecx, dword ptr [esp + stk_4]             # 00516b1a
    push esi                                     # 00516b1e
    push 0x3                                     # 00516b1f
    {load} sub ecx, eax                          # 00516b21
    pop edx                                      # 00516b23
L_00516b24:
    # block 0x00516b24: entered by jne at 0x00516b2d, 5 instruction(s), ends with jne to 0x00516b24 (backward)
    mov esi, dword ptr [eax]                     # 00516b24
    mov dword ptr [ecx + eax], esi               # 00516b26
    add eax, 0x4                                 # 00516b29
    dec edx                                      # 00516b2c
    jne.d8 L_00516b24                            # 00516b2d
    # block 0x00516b2f: entered by fall-through of jne at 0x00516b2d, 2 instruction(s), ends with ret
    pop esi                                      # 00516b2f
    ret                                          # 00516b30

