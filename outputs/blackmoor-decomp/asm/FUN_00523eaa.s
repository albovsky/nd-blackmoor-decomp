# FUN_00523eaa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523eaa
# extent:       0x00523eaa-0x00523edb (49 code bytes)
# span:         0x00523eaa-0x00523edb (code 49, tables 0, padding 0)
# sha256:       094a75426a45c92c4f7e78d7a0e2fcb57305f96b2d2f711c745d00a40812020b
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523eaa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_90, field_94; [esp + n] stk_8, stk_c
# callees:      calls FUN_0051c962, FUN_00523edb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94

# --- external targets -----------------------------------------------
.set FUN_0051c962, .text + (0x0051c962 - 0x401000)
.set FUN_00523edb, .text + (0x00523edb - 0x401000)

.org 0x00523eaa - 0x401000
.globl FUN_00523eaa
FUN_00523eaa:
    # block 0x00523eaa: entry, 7 instruction(s), calls FUN_0051c962, ends with jne to 0x00523ed7 (forward)
    push esi                                     # 00523eaa
    {load} mov esi, ecx                          # 00523eab
    push dword ptr [esp + stk_c]                 # 00523ead
    push dword ptr [esp + stk_c]                 # 00523eb1
    call FUN_0051c962                            # 00523eb5
    cmp dword ptr [esp + stk_8], 0x2             # 00523eba
    jne.d8 L_00523ed7                            # 00523ebf
    # block 0x00523ec1: entered by fall-through of jne at 0x00523ebf, 3 instruction(s), ends with je to 0x00523ed7 (forward)
    mov eax, dword ptr [esi + field_90]          # 00523ec1
    cmp eax, dword ptr [esi + field_94]          # 00523ec7
    je.d8 L_00523ed7                             # 00523ecd
    # block 0x00523ecf: entered by fall-through of je at 0x00523ecd, 3 instruction(s), calls FUN_00523edb, falls into the block at 0x00523ed7
    push eax                                     # 00523ecf
    {load} mov ecx, esi                          # 00523ed0
    call FUN_00523edb                            # 00523ed2
L_00523ed7:
    # block 0x00523ed7: entered by jne at 0x00523ebf; je at 0x00523ecd, 2 instruction(s), ends with ret 0x8
    pop esi                                      # 00523ed7
    ret 0x8                                      # 00523ed8

