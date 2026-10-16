# FUN_00523f7d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523f7d
# extent:       0x00523f7d-0x00523fb1 (52 code bytes)
# span:         0x00523f7d-0x00523fb1 (code 52, tables 0, padding 0)
# sha256:       383bf3f061ea628e79762100ed9f3c0fd34bd7a2deab00b37bb46fdaea9eec95
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00523ef2 (+0x8b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523f7d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8; [ecx + n] field_70; [edi + n] field_1c; [esp + n] stk_4, stk_c
# callees:      calls USER32.dll!GetDlgCtrlID
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00523fb1
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------

.org 0x00523f7d - 0x401000
.globl FUN_00523f7d
FUN_00523f7d:
    # block 0x00523f7d: entry, 4 instruction(s), ends with je to 0x00523faa (forward)
    cmp dword ptr [esp + stk_4], 0x0             # 00523f7d
    push esi                                     # 00523f82
    push edi                                     # 00523f83
    je.d8 L_00523faa                             # 00523f84
    # block 0x00523f86: entered by fall-through of je at 0x00523f84, 1 instruction(s), falls into the block at 0x00523f89
    mov esi, dword ptr [ecx + field_70]          # 00523f86
L_00523f89:
    # block 0x00523f89: entered by jne at 0x00523fa4, 2 instruction(s), ends with je to 0x00523faa (forward)
    test esi, esi                                # 00523f89
    je.d8 L_00523faa                             # 00523f8b
    # block 0x00523f8d: entered by fall-through of je at 0x00523f8b, 8 instruction(s), calls USER32.dll!GetDlgCtrlID, ends with jne to 0x00523f89 (backward)
    {load} mov eax, esi                          # 00523f8d
    mov esi, dword ptr [esi]                     # 00523f8f
    mov edi, dword ptr [eax + field_8]           # 00523f91
    push dword ptr [edi + field_1c]              # 00523f94
    call dword ptr [0x52a40c]                    # 00523f97
    movzx eax, ax                                # 00523f9d
    cmp eax, dword ptr [esp + stk_c]             # 00523fa0
    jne.d8 L_00523f89                            # 00523fa4
    # block 0x00523fa6: entered by fall-through of jne at 0x00523fa4, 2 instruction(s), ends with forward jump to 0x00523fac
    {load} mov eax, edi                          # 00523fa6
    jmp.d8 L_00523fac                            # 00523fa8
L_00523faa:
    # block 0x00523faa: entered by je at 0x00523f84; je at 0x00523f8b, 1 instruction(s), falls into the block at 0x00523fac
    {load} xor eax, eax                          # 00523faa
L_00523fac:
    # block 0x00523fac: entered by jmp at 0x00523fa8, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 00523fac
    pop esi                                      # 00523fad
    ret 0x4                                      # 00523fae

