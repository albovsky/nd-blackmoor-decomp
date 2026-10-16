# FUN_00516b3d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516b3d
# extent:       0x00516b3d-0x00516b58 (27 code bytes)
# span:         0x00516b3d-0x00516b58 (code 27, tables 0, padding 0)
# sha256:       a214c05d48cb4d502b4cc292b6a8d0b30366c4f093402c47bfaef868334c4302
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516b3d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00516b3d - 0x401000
.globl FUN_00516b3d
FUN_00516b3d:
    # block 0x00516b3d: entry, 2 instruction(s), falls into the block at 0x00516b43
    mov eax, dword ptr [esp + stk_4]             # 00516b3d
    {load} xor ecx, ecx                          # 00516b41
L_00516b43:
    # block 0x00516b43: entered by jl at 0x00516b4f, 2 instruction(s), ends with jne to 0x00516b55 (forward)
    cmp dword ptr [eax], 0x0                     # 00516b43
    jne.d8 L_00516b55                            # 00516b46
    # block 0x00516b48: entered by fall-through of jne at 0x00516b46, 4 instruction(s), ends with jl to 0x00516b43 (backward)
    inc ecx                                      # 00516b48
    add eax, 0x4                                 # 00516b49
    cmp ecx, 0x3                                 # 00516b4c
    jl.d8 L_00516b43                             # 00516b4f
    # block 0x00516b51: entered by fall-through of jl at 0x00516b4f, 3 instruction(s), ends with ret
    push 0x1                                     # 00516b51
    pop eax                                      # 00516b53
    ret                                          # 00516b54
L_00516b55:
    # block 0x00516b55: entered by jne at 0x00516b46, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00516b55
    ret                                          # 00516b57

