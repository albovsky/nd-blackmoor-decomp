# FUN_005199bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005199bd
# extent:       0x005199bd-0x00519a24 (103 code bytes)
# span:         0x005199bd-0x00519a24 (code 103, tables 0, padding 0)
# sha256:       beaabe2d28d603a727c17126b5ea52f18a52289183c9ebba6749d6122dd2f55a
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005199bd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4; [esp + n] stk_8; [scaled index + n] field_4
# callees:      calls FUN_0050ea90, FUN_0050e8ed, FUN_0050ffb2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00519a24
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_0050ffb2, .text + (0x0050ffb2 - 0x401000)

.org 0x005199bd - 0x401000
.globl FUN_005199bd
FUN_005199bd:
    # block 0x005199bd: entry, 5 instruction(s), ends with jne to 0x005199cc (forward)
    push edi                                     # 005199bd
    mov edi, dword ptr [esp + stk_8]             # 005199be
    {load} xor ecx, ecx                          # 005199c2
    test edi, edi                                # 005199c4
    jne.d8 L_005199cc                            # 005199c6
    # block 0x005199c8: entered by fall-through of jne at 0x005199c6, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 005199c8
    pop edi                                      # 005199ca
    ret                                          # 005199cb
L_005199cc:
    # block 0x005199cc: entered by jne at 0x005199c6, 3 instruction(s), ends with je to 0x005199de (forward)
    cmp dword ptr [edi], 0x0                     # 005199cc
    lea eax, [edi + field_4]                     # 005199cf
    je.d8 L_005199de                             # 005199d2
L_005199d4:
    # block 0x005199d4: entered by jne at 0x005199dc; fall-through of je at 0x005199d2, 5 instruction(s), ends with jne to 0x005199d4 (backward)
    mov edx, dword ptr [eax]                     # 005199d4
    inc ecx                                      # 005199d6
    add eax, 0x4                                 # 005199d7
    test edx, edx                                # 005199da
    jne.d8 L_005199d4                            # 005199dc
L_005199de:
    # block 0x005199de: entered by je at 0x005199d2; fall-through of jne at 0x005199dc, 11 instruction(s), calls FUN_0050ea90, ends with jne to 0x005199ff (forward)
    push ebx                                     # 005199de
    push ebp                                     # 005199df
    lea eax, [4*ecx + field_4]                   # 005199e0
    push esi                                     # 005199e7
    push eax                                     # 005199e8
    call FUN_0050ea90                            # 005199e9
    {load} mov esi, eax                          # 005199ee
    pop ecx                                      # 005199f0
    test esi, esi                                # 005199f1
    {load} mov ebp, esi                          # 005199f3
    jne.d8 L_005199ff                            # 005199f5
    # block 0x005199f7: entered by fall-through of jne at 0x005199f5, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x005199ff
    push 0x9                                     # 005199f7
    call FUN_0050e8ed                            # 005199f9
    pop ecx                                      # 005199fe
L_005199ff:
    # block 0x005199ff: entered by jne at 0x005199f5, 2 instruction(s), falls into the block at 0x00519a03
    mov eax, dword ptr [edi]                     # 005199ff
    {load} mov ebx, edi                          # 00519a01
L_00519a03:
    # block 0x00519a03: entered by jmp at 0x00519a18, 2 instruction(s), ends with je to 0x00519a1a (forward)
    test eax, eax                                # 00519a03
    je.d8 L_00519a1a                             # 00519a05
    # block 0x00519a07: entered by fall-through of je at 0x00519a05, 8 instruction(s), calls FUN_0050ffb2, ends with backward jump to 0x00519a03
    push eax                                     # 00519a07
    add ebx, 0x4                                 # 00519a08
    call FUN_0050ffb2                            # 00519a0b
    mov dword ptr [esi], eax                     # 00519a10
    mov eax, dword ptr [ebx]                     # 00519a12
    pop ecx                                      # 00519a14
    add esi, 0x4                                 # 00519a15
    jmp.d8 L_00519a03                            # 00519a18
L_00519a1a:
    # block 0x00519a1a: entered by je at 0x00519a05, 7 instruction(s), ends with ret
    and dword ptr [esi], 0x0                     # 00519a1a
    {load} mov eax, ebp                          # 00519a1d
    pop esi                                      # 00519a1f
    pop ebp                                      # 00519a20
    pop ebx                                      # 00519a21
    pop edi                                      # 00519a22
    ret                                          # 00519a23

