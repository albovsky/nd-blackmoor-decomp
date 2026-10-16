# FUN_005086e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005086e0
# extent:       0x005086e0-0x0050871f (63 code bytes)
# span:         0x005086e0-0x00508720 (code 63, tables 0, padding 1)
# sha256:       0aa8e7ae0c5832a6b8355f705999e8c5f0337d7debc2217a9da96cd9dfba33a7
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005086e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c, stk_10, stk_14, stk_18
# callees:      calls FUN_00508720
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00508720, .text + (0x00508720 - 0x401000)

.org 0x005086e0 - 0x401000
.globl FUN_005086e0
FUN_005086e0:
    # block 0x005086e0: entry, 5 instruction(s), ends with jle to 0x0050871b (forward)
    push esi                                     # 005086e0
    mov esi, dword ptr [esp + stk_18]            # 005086e1
    {load} xor edx, edx                          # 005086e5
    test esi, esi                                # 005086e7
    jle.d8 L_0050871b                            # 005086e9
    # block 0x005086eb: entered by fall-through of jle at 0x005086e9, 2 instruction(s), falls into the block at 0x005086f1
    mov eax, dword ptr [esp + stk_14]            # 005086eb
    {load} mov ecx, esi                          # 005086ef
L_005086f1:
    # block 0x005086f1: entered by jne at 0x005086fb, 2 instruction(s), ends with je to 0x005086f7 (forward)
    cmp dword ptr [eax], 0x0                     # 005086f1
    je.d8 L_005086f7                             # 005086f4
    # block 0x005086f6: entered by fall-through of je at 0x005086f4, 1 instruction(s), falls into the block at 0x005086f7
    inc edx                                      # 005086f6
L_005086f7:
    # block 0x005086f7: entered by je at 0x005086f4, 3 instruction(s), ends with jne to 0x005086f1 (backward)
    add eax, 0x4                                 # 005086f7
    dec ecx                                      # 005086fa
    jne.d8 L_005086f1                            # 005086fb
    # block 0x005086fd: entered by fall-through of jne at 0x005086fb, 2 instruction(s), ends with je to 0x0050871b (forward)
    test edx, edx                                # 005086fd
    je.d8 L_0050871b                             # 005086ff
    # block 0x00508701: entered by fall-through of je at 0x005086ff, 11 instruction(s), calls FUN_00508720, ends with ret
    mov eax, dword ptr [esp + stk_10]            # 00508701
    mov ecx, dword ptr [esp + stk_c]             # 00508705
    mov edx, dword ptr [esp + stk_8]             # 00508709
    push esi                                     # 0050870d
    push eax                                     # 0050870e
    push ecx                                     # 0050870f
    push edx                                     # 00508710
    call FUN_00508720                            # 00508711
    add esp, 0x10                                # 00508716
    pop esi                                      # 00508719
    ret                                          # 0050871a
L_0050871b:
    # block 0x0050871b: entered by jle at 0x005086e9; je at 0x005086ff, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050871b
    pop esi                                      # 0050871d
    ret                                          # 0050871e

# --- data items (not part of the function) -------------------------
.org 0x0050871f - 0x401000
PAD_0050871f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

