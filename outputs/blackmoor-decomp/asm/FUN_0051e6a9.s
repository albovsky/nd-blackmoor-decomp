# FUN_0051e6a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e6a9
# extent:       0x0051e6a9-0x0051e6f1 (72 code bytes)
# span:         0x0051e6a9-0x0051e6f1 (code 72, tables 0, padding 0)
# sha256:       3964ae0b57abc958f6cb0c0a01271290e36e34b58d172443b9bbb6cdbaae93e9
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e6a9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_8
# callees:      calls FUN_0050c604, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050c604, .text + (0x0050c604 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0051e6a9 - 0x401000
.globl FUN_0051e6a9
FUN_0051e6a9:
    # block 0x0051e6a9: entry, 3 instruction(s), ends with jne to 0x0051e6bd (forward)
    mov eax, dword ptr [ecx + field_8]           # 0051e6a9
    cmp eax, 0x40                                # 0051e6ac
    jne.d8 L_0051e6bd                            # 0051e6af
    # block 0x0051e6b1: entered by fall-through of jne at 0x0051e6af, 2 instruction(s), falls into the block at 0x0051e6b7
    push ecx                                     # 0051e6b1
    mov ecx, 0x63c3f0                            # 0051e6b2
L_0051e6b7:
    # block 0x0051e6b7: entered by jmp at 0x0051e6ca; jmp at 0x0051e6d9; jmp at 0x0051e6e8, 2 instruction(s), calls FUN_0050c604, ends with ret
    call FUN_0050c604                            # 0051e6b7
    ret                                          # 0051e6bc
L_0051e6bd:
    # block 0x0051e6bd: entered by jne at 0x0051e6af, 2 instruction(s), ends with jne to 0x0051e6cc (forward)
    cmp eax, 0x80                                # 0051e6bd
    jne.d8 L_0051e6cc                            # 0051e6c2
    # block 0x0051e6c4: entered by fall-through of jne at 0x0051e6c2, 3 instruction(s), ends with backward jump to 0x0051e6b7
    push ecx                                     # 0051e6c4
    mov ecx, 0x63c3c8                            # 0051e6c5
    jmp.d8 L_0051e6b7                            # 0051e6ca
L_0051e6cc:
    # block 0x0051e6cc: entered by jne at 0x0051e6c2, 2 instruction(s), ends with jne to 0x0051e6db (forward)
    cmp eax, 0x100                               # 0051e6cc
    jne.d8 L_0051e6db                            # 0051e6d1
    # block 0x0051e6d3: entered by fall-through of jne at 0x0051e6d1, 3 instruction(s), ends with backward jump to 0x0051e6b7
    push ecx                                     # 0051e6d3
    mov ecx, 0x63c3a0                            # 0051e6d4
    jmp.d8 L_0051e6b7                            # 0051e6d9
L_0051e6db:
    # block 0x0051e6db: entered by jne at 0x0051e6d1, 3 instruction(s), ends with jne to 0x0051e6ea (forward)
    cmp eax, 0x200                               # 0051e6db
    push ecx                                     # 0051e6e0
    jne.d8 L_0051e6ea                            # 0051e6e1
    # block 0x0051e6e3: entered by fall-through of jne at 0x0051e6e1, 2 instruction(s), ends with backward jump to 0x0051e6b7
    mov ecx, 0x63c378                            # 0051e6e3
    jmp.d8 L_0051e6b7                            # 0051e6e8
L_0051e6ea:
    # block 0x0051e6ea: entered by jne at 0x0051e6e1, 3 instruction(s), calls FUN_0051dc6c, ends with ret
    call FUN_0051dc6c                            # 0051e6ea
    pop ecx                                      # 0051e6ef
    ret                                          # 0051e6f0

