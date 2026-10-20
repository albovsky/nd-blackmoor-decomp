# FUN_0051ec84
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ec84
# extent:       0x0051ec84-0x0051ecc9 (69 code bytes)
# span:         0x0051ec84-0x0051ecc9 (code 69, tables 0, padding 0)
# sha256:       71f20dc27f4dda69916bab66d8d3bad4b85817271ee4e199c05350484f8b7f14
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         AfxEndThread
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_78; [edi + n] field_4; [esi + n] field_54; [esp + n] stk_c, stk_10
# callees:      calls FUN_00525397, FUN_0051ed28, FUN_0050ff80; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_54, 0x54  # offset +0x54
.equ field_78, 0x78  # offset +0x78

# --- external targets -----------------------------------------------
.set FUN_0050ff80, .text + (0x0050ff80 - 0x401000)
.set FUN_0051ed28, .text + (0x0051ed28 - 0x401000)
.set FUN_00525397, .text + (0x00525397 - 0x401000)

.org 0x0051ec84 - 0x401000
.globl FUN_0051ec84
FUN_0051ec84:
    # block 0x0051ec84: entry, 7 instruction(s), calls FUN_00525397, ends with je to 0x0051ecb3 (forward)
    push esi                                     # 0051ec84
    push edi                                     # 0051ec85
    call FUN_00525397                            # 0051ec86
    {load} mov edi, eax                          # 0051ec8b
    mov esi, dword ptr [edi + field_4]           # 0051ec8d
    test esi, esi                                # 0051ec90
    je.d8 L_0051ecb3                             # 0051ec92
    # block 0x0051ec94: entered by fall-through of je at 0x0051ec92, 3 instruction(s), ends with je to 0x0051eca1 (forward)
    mov eax, dword ptr [esi + field_54]          # 0051ec94
    test eax, eax                                # 0051ec97
    je.d8 L_0051eca1                             # 0051ec99
    # block 0x0051ec9b: entered by fall-through of je at 0x0051ec99, 3 instruction(s), calls indirect eax, falls into the block at 0x0051eca1
    push 0x0                                     # 0051ec9b
    push 0x1                                     # 0051ec9d
    call eax                                     # 0051ec9f
L_0051eca1:
    # block 0x0051eca1: entered by je at 0x0051ec99, 2 instruction(s), ends with je to 0x0051ecaf (forward)
    cmp dword ptr [esp + stk_10], 0x0            # 0051eca1
    je.d8 L_0051ecaf                             # 0051eca6
    # block 0x0051eca8: entered by fall-through of je at 0x0051eca6, 3 instruction(s), calls indirect dword ptr [eax + 0x78], falls into the block at 0x0051ecaf
    mov eax, dword ptr [esi]                     # 0051eca8
    {load} mov ecx, esi                          # 0051ecaa
    call dword ptr [eax + field_78]              # 0051ecac
L_0051ecaf:
    # block 0x0051ecaf: entered by je at 0x0051eca6, 1 instruction(s), falls into the block at 0x0051ecb3
    and dword ptr [edi + field_4], 0x0           # 0051ecaf
L_0051ecb3:
    # block 0x0051ecb3: entered by je at 0x0051ec92, 8 instruction(s), calls FUN_0051ed28, FUN_0050ff80, ends with ret 0x8
    push 0x0                                     # 0051ecb3
    call FUN_0051ed28                            # 0051ecb5
    push dword ptr [esp + stk_c]                 # 0051ecba
    call FUN_0050ff80                            # 0051ecbe
    pop ecx                                      # 0051ecc3
    pop edi                                      # 0051ecc4
    pop esi                                      # 0051ecc5
    ret 0x8                                      # 0051ecc6

