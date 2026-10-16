# FUN_0051e87a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e87a
# extent:       0x0051e87a-0x0051e8a7 (45 code bytes)
# span:         0x0051e87a-0x0051e8a7 (code 45, tables 0, padding 0)
# sha256:       8afb9fd34e19765d2596e3b555d7d98c4f7979fde02c75c3021737723e76354c
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e87a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_8; [esp + n] stk_c, stk_14
# callees:      calls FUN_0051e791, FUN_0050fa90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051e791, .text + (0x0051e791 - 0x401000)

.org 0x0051e87a - 0x401000
.globl FUN_0051e87a
FUN_0051e87a:
    # block 0x0051e87a: entry, 18 instruction(s), calls FUN_0051e791, FUN_0050fa90, ends with ret 0x8
    push esi                                     # 0051e87a
    push edi                                     # 0051e87b
    mov edi, dword ptr [esp + stk_c]             # 0051e87c
    {load} mov esi, ecx                          # 0051e880
    push edi                                     # 0051e882
    call FUN_0051e791                            # 0051e883
    push edi                                     # 0051e888
    push dword ptr [esp + stk_14]                # 0051e889
    push dword ptr [esi]                         # 0051e88d
    call FUN_0050fa90                            # 0051e88f
    mov eax, dword ptr [esi]                     # 0051e894
    add esp, 0xc                                 # 0051e896
    mov dword ptr [eax - field_minus_8], edi     # 0051e899
    mov eax, dword ptr [esi]                     # 0051e89c
    and byte ptr [eax + edi], 0x0                # 0051e89e
    pop edi                                      # 0051e8a2
    pop esi                                      # 0051e8a3
    ret 0x8                                      # 0051e8a4

