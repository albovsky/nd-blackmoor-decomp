# FUN_0051c7cc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c7cc
# extent:       0x0051c7cc-0x0051c81f (83 code bytes)
# span:         0x0051c7cc-0x0051c81f (code 83, tables 0, padding 0)
# sha256:       dd5b67d8398ef8c175b6ec7b7016dce03933ed255330fa2a1e8f5e0d5b66e831
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c7cc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14, field_1c; [esi + n] field_24
# callees:      calls FUN_00525371, FUN_00525bd1, FUN_0051ec6f, FUN_0051c8ce; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_0051c8ce, .text + (0x0051c8ce - 0x401000)
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525bd1, .text + (0x00525bd1 - 0x401000)

.org 0x0051c7cc - 0x401000
.globl FUN_0051c7cc
FUN_0051c7cc:
    # block 0x0051c7cc: entry, 6 instruction(s), calls FUN_00525371, ends with jne to 0x0051c808 (forward)
    push esi                                     # 0051c7cc
    push edi                                     # 0051c7cd
    {load} mov edi, ecx                          # 0051c7ce
    call FUN_00525371                            # 0051c7d0
    cmp byte ptr [eax + field_14], 0x0           # 0051c7d5
    jne.d8 L_0051c808                            # 0051c7d9
    # block 0x0051c7db: entered by fall-through of jne at 0x0051c7d9, 7 instruction(s), calls FUN_00525bd1, FUN_0051ec6f, ends with je to 0x0051c808 (forward)
    push 0x5249d1                                # 0051c7db
    mov ecx, 0x63c740                            # 0051c7e0
    call FUN_00525bd1                            # 0051c7e5
    {load} mov esi, eax                          # 0051c7ea
    call FUN_0051ec6f                            # 0051c7ec
    test eax, eax                                # 0051c7f1
    je.d8 L_0051c808                             # 0051c7f3
    # block 0x0051c7f5: entered by fall-through of je at 0x0051c7f3, 3 instruction(s), calls FUN_0051ec6f, ends with jne to 0x0051c808 (forward)
    call FUN_0051ec6f                            # 0051c7f5
    cmp dword ptr [eax + field_1c], edi          # 0051c7fa
    jne.d8 L_0051c808                            # 0051c7fd
    # block 0x0051c7ff: entered by fall-through of jne at 0x0051c7fd, 3 instruction(s), ends with je to 0x0051c808 (forward)
    mov eax, dword ptr [esi + field_24]          # 0051c7ff
    test eax, eax                                # 0051c802
    je.d8 L_0051c808                             # 0051c804
    # block 0x0051c806: entered by fall-through of je at 0x0051c804, 1 instruction(s), calls indirect eax, falls into the block at 0x0051c808
    call eax                                     # 0051c806
L_0051c808:
    # block 0x0051c808: entered by jne at 0x0051c7d9; je at 0x0051c7f3; jne at 0x0051c7fd; je at 0x0051c804, 8 instruction(s), calls FUN_0051c8ce, ends with ret 0x8
    and dword ptr [0x63aa2c], 0x0                # 0051c808
    push 0x0                                     # 0051c80f
    push 0x0                                     # 0051c811
    {load} mov ecx, edi                          # 0051c813
    call FUN_0051c8ce                            # 0051c815
    pop edi                                      # 0051c81a
    pop esi                                      # 0051c81b
    ret 0x8                                      # 0051c81c

