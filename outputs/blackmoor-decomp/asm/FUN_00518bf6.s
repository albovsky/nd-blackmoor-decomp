# FUN_00518bf6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518bf6
# extent:       0x00518bf6-0x00518c54 (94 code bytes)
# span:         0x00518bf6-0x00518c54 (code 94, tables 0, padding 0)
# sha256:       030db63175797538237224cc3e40c4f096609dad22b499b67e3bce650f5b8789
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         ___add_12
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4, field_8; [esi + n] field_4, field_8; [esp + n] stk_8, stk_10
# callees:      calls FUN_00518bd5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00518bd5, .text + (0x00518bd5 - 0x401000)

.org 0x00518bf6 - 0x401000
.globl FUN_00518bf6
FUN_00518bf6:
    # block 0x00518bf6: entry, 11 instruction(s), calls FUN_00518bd5, ends with je to 0x00518c28 (forward)
    push esi                                     # 00518bf6
    mov esi, dword ptr [esp + stk_8]             # 00518bf7
    push edi                                     # 00518bfb
    mov edi, dword ptr [esp + stk_10]            # 00518bfc
    push esi                                     # 00518c00
    push dword ptr [edi]                         # 00518c01
    push dword ptr [esi]                         # 00518c03
    call FUN_00518bd5                            # 00518c05
    add esp, 0xc                                 # 00518c0a
    test eax, eax                                # 00518c0d
    je.d8 L_00518c28                             # 00518c0f
    # block 0x00518c11: entered by fall-through of je at 0x00518c0f, 8 instruction(s), calls FUN_00518bd5, ends with je to 0x00518c28 (forward)
    lea eax, [esi + field_4]                     # 00518c11
    push eax                                     # 00518c14
    push 0x1                                     # 00518c15
    push dword ptr [eax]                         # 00518c17
    call FUN_00518bd5                            # 00518c19
    add esp, 0xc                                 # 00518c1e
    test eax, eax                                # 00518c21
    je.d8 L_00518c28                             # 00518c23
    # block 0x00518c25: entered by fall-through of je at 0x00518c23, 1 instruction(s), falls into the block at 0x00518c28
    inc dword ptr [esi + field_8]                # 00518c25
L_00518c28:
    # block 0x00518c28: entered by je at 0x00518c0f; je at 0x00518c23, 8 instruction(s), calls FUN_00518bd5, ends with je to 0x00518c40 (forward)
    lea eax, [esi + field_4]                     # 00518c28
    push eax                                     # 00518c2b
    push dword ptr [edi + field_4]               # 00518c2c
    push dword ptr [eax]                         # 00518c2f
    call FUN_00518bd5                            # 00518c31
    add esp, 0xc                                 # 00518c36
    test eax, eax                                # 00518c39
    je.d8 L_00518c40                             # 00518c3b
    # block 0x00518c3d: entered by fall-through of je at 0x00518c3b, 1 instruction(s), falls into the block at 0x00518c40
    inc dword ptr [esi + field_8]                # 00518c3d
L_00518c40:
    # block 0x00518c40: entered by je at 0x00518c3b, 9 instruction(s), calls FUN_00518bd5, ends with ret
    lea eax, [esi + field_8]                     # 00518c40
    push eax                                     # 00518c43
    push dword ptr [edi + field_8]               # 00518c44
    push dword ptr [eax]                         # 00518c47
    call FUN_00518bd5                            # 00518c49
    add esp, 0xc                                 # 00518c4e
    pop edi                                      # 00518c51
    pop esi                                      # 00518c52
    ret                                          # 00518c53

