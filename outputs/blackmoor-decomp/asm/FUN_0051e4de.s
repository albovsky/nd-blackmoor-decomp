# FUN_0051e4de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e4de
# extent:       0x0051e4de-0x0051e51c (62 code bytes)
# span:         0x0051e4de-0x0051e51c (code 62, tables 0, padding 0)
# sha256:       515b058192a7df989a94caed1fbef9dcf1f3dc055b67361cd2ca9b550d351384
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e4de
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_20000; [ecx + n] field_3c; [edx + n] field_98; [esp + n] stk_c
# callees:      calls FUN_00525371; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051e51c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ field_3c, 0x3c  # offset +0x3c
.equ field_98, 0x98  # offset +0x98
.equ field_20000, 0x20000  # offset +0x20000

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051e4de - 0x401000
.globl FUN_0051e4de
FUN_0051e4de:
    # block 0x0051e4de: entry, 4 instruction(s), ends with jne to 0x0051e4f8 (forward)
    push esi                                     # 0051e4de
    mov esi, dword ptr [esp + stk_c]             # 0051e4df
    test esi, esi                                # 0051e4e3
    jne.d8 L_0051e4f8                            # 0051e4e5
    # block 0x0051e4e7: entered by fall-through of jne at 0x0051e4e5, 3 instruction(s), ends with je to 0x0051e516 (forward)
    mov eax, dword ptr [ecx + field_3c]          # 0051e4e7
    test eax, eax                                # 0051e4ea
    je.d8 L_0051e516                             # 0051e4ec
    # block 0x0051e4ee: entered by fall-through of je at 0x0051e4ec, 3 instruction(s), ends with je to 0x0051e516 (forward)
    lea esi, [eax + field_20000]                 # 0051e4ee
    test esi, esi                                # 0051e4f4
    je.d8 L_0051e516                             # 0051e4f6
L_0051e4f8:
    # block 0x0051e4f8: entered by jne at 0x0051e4e5; fall-through of je at 0x0051e4f6, 4 instruction(s), calls FUN_00525371, ends with je to 0x0051e511 (forward)
    call FUN_00525371                            # 0051e4f8
    mov eax, dword ptr [eax + field_4]           # 0051e4fd
    test eax, eax                                # 0051e500
    je.d8 L_0051e511                             # 0051e502
    # block 0x0051e504: entered by fall-through of je at 0x0051e502, 5 instruction(s), calls indirect dword ptr [edx + 0x98], falls into the block at 0x0051e511
    mov edx, dword ptr [eax]                     # 0051e504
    push 0x1                                     # 0051e506
    push esi                                     # 0051e508
    {load} mov ecx, eax                          # 0051e509
    call dword ptr [edx + field_98]              # 0051e50b
L_0051e511:
    # block 0x0051e511: entered by je at 0x0051e502, 3 instruction(s), ends with forward jump to 0x0051e518
    push 0x1                                     # 0051e511
    pop eax                                      # 0051e513
    jmp.d8 L_0051e518                            # 0051e514
L_0051e516:
    # block 0x0051e516: entered by je at 0x0051e4ec; je at 0x0051e4f6, 1 instruction(s), falls into the block at 0x0051e518
    {load} xor eax, eax                          # 0051e516
L_0051e518:
    # block 0x0051e518: entered by jmp at 0x0051e514, 2 instruction(s), ends with ret 0x8
    pop esi                                      # 0051e518
    ret 0x8                                      # 0051e519

