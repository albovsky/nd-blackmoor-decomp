# FUN_0051eaec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051eaec
# extent:       0x0051eaec-0x0051eb0c (32 code bytes)
# span:         0x0051eaec-0x0051eb0c (code 32, tables 0, padding 0)
# sha256:       75e17a9393ee979dcef851ea2a71530dad6a3bfc6dbf271a12d7ec77a42d5149
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051eaec
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_8; [esp + n] stk_c
# callees:      calls FUN_0051ea75
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)

.org 0x0051eaec - 0x401000
.globl FUN_0051eaec
FUN_0051eaec:
    # block 0x0051eaec: entry, 14 instruction(s), calls FUN_0051ea75, ends with ret 0x4
    push esi                                     # 0051eaec
    push edi                                     # 0051eaed
    mov edi, dword ptr [esp + stk_c]             # 0051eaee
    {load} mov esi, ecx                          # 0051eaf2
    push edi                                     # 0051eaf4
    call FUN_0051ea75                            # 0051eaf5
    mov eax, dword ptr [esi]                     # 0051eafa
    mov dword ptr [eax - field_minus_8], edi     # 0051eafc
    mov eax, dword ptr [esi]                     # 0051eaff
    and byte ptr [eax + edi], 0x0                # 0051eb01
    mov eax, dword ptr [esi]                     # 0051eb05
    pop edi                                      # 0051eb07
    pop esi                                      # 0051eb08
    ret 0x4                                      # 0051eb09

