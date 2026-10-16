# FUN_00520bd7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520bd7
# extent:       0x00520bd7-0x00520c13 (60 code bytes)
# span:         0x00520bd7-0x00520c13 (code 60, tables 0, padding 0)
# sha256:       620dffc69f92521e8f3116d26f981cdb7bbd518772bd51d1a904dbd8a6562b35
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520bd7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8; [esp + n] stk_10
# callees:      calls GDI32.dll!GetStockObject, FUN_00520fbf; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00520fbf, .text + (0x00520fbf - 0x401000)

.org 0x00520bd7 - 0x401000
.globl FUN_00520bd7
FUN_00520bd7:
    # block 0x00520bd7: entry, 12 instruction(s), calls GDI32.dll!GetStockObject, ends with je to 0x00520bfc (forward)
    push ebx                                     # 00520bd7
    push esi                                     # 00520bd8
    push edi                                     # 00520bd9
    {load} mov esi, ecx                          # 00520bda
    push dword ptr [esp + stk_10]                # 00520bdc
    call dword ptr [0x52a0ac]                    # 00520be0
    mov ecx, dword ptr [esi + field_4]           # 00520be6
    mov edi, dword ptr [0x52a070]                # 00520be9
    {load} mov ebx, eax                          # 00520bef
    {load} xor eax, eax                          # 00520bf1
    cmp ecx, dword ptr [esi + field_8]           # 00520bf3
    je.d8 L_00520bfc                             # 00520bf6
    # block 0x00520bf8: entered by fall-through of je at 0x00520bf6, 3 instruction(s), calls indirect edi, falls into the block at 0x00520bfc
    push ebx                                     # 00520bf8
    push ecx                                     # 00520bf9
    call edi                                     # 00520bfa
L_00520bfc:
    # block 0x00520bfc: entered by je at 0x00520bf6, 3 instruction(s), ends with je to 0x00520c07 (forward)
    mov esi, dword ptr [esi + field_8]           # 00520bfc
    test esi, esi                                # 00520bff
    je.d8 L_00520c07                             # 00520c01
    # block 0x00520c03: entered by fall-through of je at 0x00520c01, 3 instruction(s), calls indirect edi, falls into the block at 0x00520c07
    push ebx                                     # 00520c03
    push esi                                     # 00520c04
    call edi                                     # 00520c05
L_00520c07:
    # block 0x00520c07: entered by je at 0x00520c01, 6 instruction(s), calls FUN_00520fbf, ends with ret 0x4
    push eax                                     # 00520c07
    call FUN_00520fbf                            # 00520c08
    pop edi                                      # 00520c0d
    pop esi                                      # 00520c0e
    pop ebx                                      # 00520c0f
    ret 0x4                                      # 00520c10

