# FUN_0051e791
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e791
# extent:       0x0051e791-0x0051e7ba (41 code bytes)
# span:         0x0051e791-0x0051e7ba (code 41, tables 0, padding 0)
# sha256:       de3794ee0f9ea7ae09d334758d0630c0a08295b128a5193aef66bf6a9718c4f8
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e791
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4, field_minus_c; [esp + n] stk_c
# callees:      calls FUN_0051e6f1, FUN_0051e627
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051e627, .text + (0x0051e627 - 0x401000)
.set FUN_0051e6f1, .text + (0x0051e6f1 - 0x401000)

.org 0x0051e791 - 0x401000
.globl FUN_0051e791
FUN_0051e791:
    # block 0x0051e791: entry, 7 instruction(s), ends with jg to 0x0051e7a6 (forward)
    push esi                                     # 0051e791
    {load} mov esi, ecx                          # 0051e792
    push edi                                     # 0051e794
    mov edi, dword ptr [esp + stk_c]             # 0051e795
    mov eax, dword ptr [esi]                     # 0051e799
    cmp dword ptr [eax - field_minus_c], 0x1     # 0051e79b
    jg.d8 L_0051e7a6                             # 0051e79f
    # block 0x0051e7a1: entered by fall-through of jg at 0x0051e79f, 2 instruction(s), ends with jle to 0x0051e7b5 (forward)
    cmp edi, dword ptr [eax - field_minus_4]     # 0051e7a1
    jle.d8 L_0051e7b5                            # 0051e7a4
L_0051e7a6:
    # block 0x0051e7a6: entered by jg at 0x0051e79f; fall-through of jle at 0x0051e7a4, 5 instruction(s), calls FUN_0051e6f1, FUN_0051e627, falls into the block at 0x0051e7b5
    {load} mov ecx, esi                          # 0051e7a6
    call FUN_0051e6f1                            # 0051e7a8
    push edi                                     # 0051e7ad
    {load} mov ecx, esi                          # 0051e7ae
    call FUN_0051e627                            # 0051e7b0
L_0051e7b5:
    # block 0x0051e7b5: entered by jle at 0x0051e7a4, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0051e7b5
    pop esi                                      # 0051e7b6
    ret 0x4                                      # 0051e7b7

