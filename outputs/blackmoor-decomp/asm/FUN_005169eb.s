# FUN_005169eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005169eb
# extent:       0x005169eb-0x00516a34 (73 code bytes)
# span:         0x005169eb-0x00516a34 (code 73, tables 0, padding 0)
# sha256:       c0e877dc38f6ba3e2eababe0e7fad89787070a0998208e8bad17c5a60453809b
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005169eb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x005169eb - 0x401000
.globl FUN_005169eb
FUN_005169eb:
    # block 0x005169eb: entry, 19 instruction(s), ends with jne to 0x00516a30 (forward)
    mov eax, dword ptr [esp + stk_8]             # 005169eb
    push esi                                     # 005169ef
    push 0x20                                    # 005169f0
    cdq                                          # 005169f2
    pop ecx                                      # 005169f3
    idiv ecx                                     # 005169f4
    push 0x1f                                    # 005169f6
    {load} mov esi, eax                          # 005169f8
    mov eax, dword ptr [esp + stk_10]            # 005169fa
    cdq                                          # 005169fe
    idiv ecx                                     # 005169ff
    pop ecx                                      # 00516a01
    mov eax, dword ptr [esp + stk_8]             # 00516a02
    {load} sub ecx, edx                          # 00516a06
    or edx, -0x1                                 # 00516a08
    shl edx, cl                                  # 00516a0b
    not edx                                      # 00516a0d
    test dword ptr [eax + 4*esi], edx            # 00516a0f
    jne.d8 L_00516a30                            # 00516a12
    # block 0x00516a14: entered by fall-through of jne at 0x00516a12, 3 instruction(s), ends with jge to 0x00516a2b (forward)
    inc esi                                      # 00516a14
    cmp esi, 0x3                                 # 00516a15
    jge.d8 L_00516a2b                            # 00516a18
    # block 0x00516a1a: entered by fall-through of jge at 0x00516a18, 1 instruction(s), falls into the block at 0x00516a1d
    lea eax, [eax + 4*esi]                       # 00516a1a
L_00516a1d:
    # block 0x00516a1d: entered by jl at 0x00516a29, 2 instruction(s), ends with jne to 0x00516a30 (forward)
    cmp dword ptr [eax], 0x0                     # 00516a1d
    jne.d8 L_00516a30                            # 00516a20
    # block 0x00516a22: entered by fall-through of jne at 0x00516a20, 4 instruction(s), ends with jl to 0x00516a1d (backward)
    inc esi                                      # 00516a22
    add eax, 0x4                                 # 00516a23
    cmp esi, 0x3                                 # 00516a26
    jl.d8 L_00516a1d                             # 00516a29
L_00516a2b:
    # block 0x00516a2b: entered by jge at 0x00516a18; fall-through of jl at 0x00516a29, 4 instruction(s), ends with ret
    push 0x1                                     # 00516a2b
    pop eax                                      # 00516a2d
    pop esi                                      # 00516a2e
    ret                                          # 00516a2f
L_00516a30:
    # block 0x00516a30: entered by jne at 0x00516a12; jne at 0x00516a20, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 00516a30
    pop esi                                      # 00516a32
    ret                                          # 00516a33

