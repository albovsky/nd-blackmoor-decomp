# FUN_0051e8f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e8f7
# extent:       0x0051e8f7-0x0051e91e (39 code bytes)
# span:         0x0051e8f7-0x0051e91e (code 39, tables 0, padding 0)
# sha256:       1a58b637c6bdff828f63903bfdc67b5a1a25af62a7f3821847be9f4b7dfbd498
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e8f7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls KERNEL32.dll!lstrlenA, FUN_0051e87a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051e87a, .text + (0x0051e87a - 0x401000)

.org 0x0051e8f7 - 0x401000
.globl FUN_0051e8f7
FUN_0051e8f7:
    # block 0x0051e8f7: entry, 6 instruction(s), ends with jne to 0x0051e907 (forward)
    push esi                                     # 0051e8f7
    push edi                                     # 0051e8f8
    mov edi, dword ptr [esp + stk_c]             # 0051e8f9
    {load} mov esi, ecx                          # 0051e8fd
    test edi, edi                                # 0051e8ff
    jne.d8 L_0051e907                            # 0051e901
    # block 0x0051e903: entered by fall-through of jne at 0x0051e901, 2 instruction(s), ends with forward jump to 0x0051e90e
    {load} xor eax, eax                          # 0051e903
    jmp.d8 L_0051e90e                            # 0051e905
L_0051e907:
    # block 0x0051e907: entered by jne at 0x0051e901, 2 instruction(s), calls KERNEL32.dll!lstrlenA, falls into the block at 0x0051e90e
    push edi                                     # 0051e907
    call dword ptr [0x52a1f8]                    # 0051e908
L_0051e90e:
    # block 0x0051e90e: entered by jmp at 0x0051e905, 8 instruction(s), calls FUN_0051e87a, ends with ret 0x4
    push edi                                     # 0051e90e
    push eax                                     # 0051e90f
    {load} mov ecx, esi                          # 0051e910
    call FUN_0051e87a                            # 0051e912
    {load} mov eax, esi                          # 0051e917
    pop edi                                      # 0051e919
    pop esi                                      # 0051e91a
    ret 0x4                                      # 0051e91b

