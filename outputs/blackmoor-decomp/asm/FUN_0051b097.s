# FUN_0051b097
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b097
# extent:       0x0051b097-0x0051b0e3 (76 code bytes)
# span:         0x0051b097-0x0051b0e3 (code 76, tables 0, padding 0)
# sha256:       7a30dd6aef273ac76104b6f2ca5e17e8fa71f83745577cded2a0c809792e97aa
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b097
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_14, field_2c; [esp + n] stk_c
# callees:      calls FUN_00525b0f, KERNEL32.dll!GetCurrentThreadId, USER32.dll!SetWindowsHookExA, FUN_00519cc0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051b097 - 0x401000
.globl FUN_0051b097
FUN_0051b097:
    # block 0x0051b097: entry, 9 instruction(s), calls FUN_00525b0f, ends with je to 0x0051b0de (forward)
    push esi                                     # 0051b097
    push edi                                     # 0051b098
    push 0x52496c                                # 0051b099
    mov ecx, 0x63c444                            # 0051b09e
    call FUN_00525b0f                            # 0051b0a3
    {load} mov esi, eax                          # 0051b0a8
    mov edi, dword ptr [esp + stk_c]             # 0051b0aa
    cmp dword ptr [esi + field_14], edi          # 0051b0ae
    je.d8 L_0051b0de                             # 0051b0b1
    # block 0x0051b0b3: entered by fall-through of je at 0x0051b0b1, 2 instruction(s), ends with jne to 0x0051b0db (forward)
    cmp dword ptr [esi + field_2c], 0x0          # 0051b0b3
    jne.d8 L_0051b0db                            # 0051b0b7
    # block 0x0051b0b9: entered by fall-through of jne at 0x0051b0b7, 9 instruction(s), calls KERNEL32.dll!GetCurrentThreadId, USER32.dll!SetWindowsHookExA, ends with jne to 0x0051b0db (forward)
    call dword ptr [0x52a2a0]                    # 0051b0b9
    push eax                                     # 0051b0bf
    push 0x0                                     # 0051b0c0
    push 0x51aea1                                # 0051b0c2
    push 0x5                                     # 0051b0c7
    call dword ptr [0x52a41c]                    # 0051b0c9
    test eax, eax                                # 0051b0cf
    mov dword ptr [esi + field_2c], eax          # 0051b0d1
    jne.d8 L_0051b0db                            # 0051b0d4
    # block 0x0051b0d6: entered by fall-through of jne at 0x0051b0d4, 1 instruction(s), calls FUN_00519cc0, falls into the block at 0x0051b0db
    call FUN_00519cc0                            # 0051b0d6
L_0051b0db:
    # block 0x0051b0db: entered by jne at 0x0051b0b7; jne at 0x0051b0d4, 1 instruction(s), falls into the block at 0x0051b0de
    mov dword ptr [esi + field_14], edi          # 0051b0db
L_0051b0de:
    # block 0x0051b0de: entered by je at 0x0051b0b1, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0051b0de
    pop esi                                      # 0051b0df
    ret 0x4                                      # 0051b0e0

