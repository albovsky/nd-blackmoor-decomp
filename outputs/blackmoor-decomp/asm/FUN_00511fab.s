# FUN_00511fab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511fab
# extent:       0x00511fab-0x00512018 (109 code bytes)
# span:         0x00511fab-0x00512018 (code 109, tables 0, padding 0)
# sha256:       00aee92f65c1482f855c34e23670bd4498450a68364600bb273e60909ca13d5d
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511fab
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_minus_1; [esi + n] field_minus_1; [esp + n] stk_c, stk_10
# callees:      calls FUN_00512c18, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00512018
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x00511fab - 0x401000
.globl FUN_00511fab
FUN_00511fab:
    # block 0x00511fab: entry, 5 instruction(s), ends with jb to 0x00511fbb (forward)
    push esi                                     # 00511fab
    push edi                                     # 00511fac
    mov edi, dword ptr [esp + stk_10]            # 00511fad
    cmp dword ptr [esp + stk_c], edi             # 00511fb1
    jb.d8 L_00511fbb                             # 00511fb5
    # block 0x00511fb7: entered by fall-through of jb at 0x00511fb5, 2 instruction(s), ends with forward jump to 0x00512015
    {load} xor eax, eax                          # 00511fb7
    jmp.d8 L_00512015                            # 00511fb9
L_00511fbb:
    # block 0x00511fbb: entered by jb at 0x00511fb5, 2 instruction(s), ends with jne to 0x00511fc9 (forward)
    cmp dword ptr [0x63df1c], 0x0                # 00511fbb
    jne.d8 L_00511fc9                            # 00511fc2
    # block 0x00511fc4: entered by fall-through of jne at 0x00511fc2, 2 instruction(s), ends with forward jump to 0x00512015
    lea eax, [edi - field_minus_1]               # 00511fc4
    jmp.d8 L_00512015                            # 00511fc7
L_00511fc9:
    # block 0x00511fc9: entered by jne at 0x00511fc2, 7 instruction(s), calls FUN_00512c18, ends with je to 0x00511fee (forward)
    push 0x19                                    # 00511fc9
    call FUN_00512c18                            # 00511fcb
    movzx eax, byte ptr [edi - field_minus_1]    # 00511fd0
    lea esi, [edi - field_minus_1]               # 00511fd4
    pop ecx                                      # 00511fd7
    test byte ptr [eax + 0x63e021], 0x4          # 00511fd8
    je.d8 L_00511fee                             # 00511fdf
    # block 0x00511fe1: entered by fall-through of je at 0x00511fdf, 5 instruction(s), calls FUN_00512c79, ends with forward jump to 0x00512015
    push 0x19                                    # 00511fe1
    call FUN_00512c79                            # 00511fe3
    pop ecx                                      # 00511fe8
    lea eax, [esi - field_minus_1]               # 00511fe9
    jmp.d8 L_00512015                            # 00511fec
L_00511fee:
    # block 0x00511fee: entered by je at 0x00511fdf; jne at 0x00511fff, 3 instruction(s), ends with ja to 0x00512001 (forward)
    dec esi                                      # 00511fee
    cmp dword ptr [esp + stk_c], esi             # 00511fef
    ja.d8 L_00512001                             # 00511ff3
    # block 0x00511ff5: entered by fall-through of ja at 0x00511ff3, 3 instruction(s), ends with jne to 0x00511fee (backward)
    movzx eax, byte ptr [esi]                    # 00511ff5
    test byte ptr [eax + 0x63e021], 0x4          # 00511ff8
    jne.d8 L_00511fee                            # 00511fff
L_00512001:
    # block 0x00512001: entered by ja at 0x00511ff3; fall-through of jne at 0x00511fff, 9 instruction(s), calls FUN_00512c79, falls into the block at 0x00512015
    push 0x19                                    # 00512001
    call FUN_00512c79                            # 00512003
    pop ecx                                      # 00512008
    {load} mov eax, edi                          # 00512009
    {load} mov ecx, edi                          # 0051200b
    {load} sub ecx, esi                          # 0051200d
    and ecx, 0x1                                 # 0051200f
    {load} sub eax, ecx                          # 00512012
    dec eax                                      # 00512014
L_00512015:
    # block 0x00512015: entered by jmp at 0x00511fb9; jmp at 0x00511fc7; jmp at 0x00511fec, 3 instruction(s), ends with ret
    pop edi                                      # 00512015
    pop esi                                      # 00512016
    ret                                          # 00512017

