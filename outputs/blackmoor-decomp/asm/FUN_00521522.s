# FUN_00521522
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521522
# extent:       0x00521522-0x00521581 (95 code bytes)
# span:         0x00521522-0x00521581 (code 95, tables 0, padding 0)
# sha256:       e8e95221a0ae34e501067b84cbdf72cd895f41dd996ab5d70da9a97fd89f5522
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521522
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_a0, field_a4; [esp + n] stk_c
# callees:      calls FUN_00525ffa, USER32.dll!SetCursor, FUN_0052606a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00521581
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_a0, 0xa0  # offset +0xa0
.equ field_a4, 0xa4  # offset +0xa4

# --- external targets -----------------------------------------------
.set FUN_00525ffa, .text + (0x00525ffa - 0x401000)
.set FUN_0052606a, .text + (0x0052606a - 0x401000)

.org 0x00521522 - 0x401000
.globl FUN_00521522
FUN_00521522:
    # block 0x00521522: entry, 10 instruction(s), calls FUN_00525ffa, ends with jle to 0x00521562 (forward)
    push esi                                     # 00521522
    push edi                                     # 00521523
    {load} mov esi, ecx                          # 00521524
    push 0x2                                     # 00521526
    call FUN_00525ffa                            # 00521528
    mov edi, dword ptr [esp + stk_c]             # 0052152d
    add dword ptr [esi + field_a0], edi          # 00521531
    mov eax, dword ptr [esi + field_a0]          # 00521537
    test eax, eax                                # 0052153d
    jle.d8 L_00521562                            # 0052153f
    # block 0x00521541: entered by fall-through of jle at 0x0052153f, 4 instruction(s), calls USER32.dll!SetCursor, ends with jle to 0x00521575 (forward)
    push dword ptr [0x63c784]                    # 00521541
    call dword ptr [0x52a474]                    # 00521547
    test edi, edi                                # 0052154d
    jle.d8 L_00521575                            # 0052154f
    # block 0x00521551: entered by fall-through of jle at 0x0052154f, 2 instruction(s), ends with jne to 0x00521575 (forward)
    cmp dword ptr [esi + field_a0], 0x1          # 00521551
    jne.d8 L_00521575                            # 00521558
    # block 0x0052155a: entered by fall-through of jne at 0x00521558, 2 instruction(s), ends with forward jump to 0x00521575
    mov dword ptr [esi + field_a4], eax          # 0052155a
    jmp.d8 L_00521575                            # 00521560
L_00521562:
    # block 0x00521562: entered by jle at 0x0052153f, 3 instruction(s), calls USER32.dll!SetCursor, falls into the block at 0x00521575
    push dword ptr [esi + field_a4]              # 00521562
    and dword ptr [esi + field_a0], 0x0          # 00521568
    call dword ptr [0x52a474]                    # 0052156f
L_00521575:
    # block 0x00521575: entered by jle at 0x0052154f; jne at 0x00521558; jmp at 0x00521560, 5 instruction(s), calls FUN_0052606a, ends with ret 0x4
    push 0x2                                     # 00521575
    call FUN_0052606a                            # 00521577
    pop edi                                      # 0052157c
    pop esi                                      # 0052157d
    ret 0x4                                      # 0052157e

