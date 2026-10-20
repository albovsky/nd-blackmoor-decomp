# FUN_00524186
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524186
# extent:       0x00524186-0x005241ca (68 code bytes)
# span:         0x00524186-0x005241ca (code 68, tables 0, padding 0)
# sha256:       7644d81d5d23064af0ac2a0e259c1cdd2583ee865aaeff2bb7427d02410c1674
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CFrameWnd::OnUpdateFrameTitle
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c, field_68, field_bc; [esi + n] field_68; [esp + n] stk_8
# callees:      calls FUN_0051d526, FUN_005241ca; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_68, 0x68  # offset +0x68
.equ field_bc, 0xbc  # offset +0xbc

# --- external targets -----------------------------------------------
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_005241ca, .text + (0x005241ca - 0x401000)

.org 0x00524186 - 0x401000
.globl FUN_00524186
FUN_00524186:
    # block 0x00524186: entry, 5 instruction(s), calls FUN_0051d526, ends with je to 0x005241c6 (forward)
    push esi                                     # 00524186
    {load} mov esi, ecx                          # 00524187
    call FUN_0051d526                            # 00524189
    test ah, -0x80                               # 0052418e
    je.d8 L_005241c6                             # 00524191
    # block 0x00524193: entered by fall-through of je at 0x00524191, 3 instruction(s), ends with je to 0x005241a3 (forward)
    mov ecx, dword ptr [esi + field_68]          # 00524193
    test ecx, ecx                                # 00524196
    je.d8 L_005241a3                             # 00524198
    # block 0x0052419a: entered by fall-through of je at 0x00524198, 4 instruction(s), calls indirect dword ptr [eax + 0x68], ends with jne to 0x005241c6 (forward)
    mov eax, dword ptr [ecx]                     # 0052419a
    call dword ptr [eax + field_68]              # 0052419c
    test eax, eax                                # 0052419f
    jne.d8 L_005241c6                            # 005241a1
L_005241a3:
    # block 0x005241a3: entered by je at 0x00524198; fall-through of jne at 0x005241a1, 5 instruction(s), calls indirect dword ptr [eax + 0xbc], ends with je to 0x005241bd (forward)
    mov eax, dword ptr [esi]                     # 005241a3
    {load} mov ecx, esi                          # 005241a5
    call dword ptr [eax + field_bc]              # 005241a7
    cmp dword ptr [esp + stk_8], 0x0             # 005241ad
    je.d8 L_005241bd                             # 005241b2
    # block 0x005241b4: entered by fall-through of je at 0x005241b2, 2 instruction(s), ends with je to 0x005241bd (forward)
    test eax, eax                                # 005241b4
    je.d8 L_005241bd                             # 005241b6
    # block 0x005241b8: entered by fall-through of je at 0x005241b6, 2 instruction(s), ends with forward jump to 0x005241bf
    push dword ptr [eax + field_1c]              # 005241b8
    jmp.d8 L_005241bf                            # 005241bb
L_005241bd:
    # block 0x005241bd: entered by je at 0x005241b2; je at 0x005241b6, 1 instruction(s), falls into the block at 0x005241bf
    push 0x0                                     # 005241bd
L_005241bf:
    # block 0x005241bf: entered by jmp at 0x005241bb, 2 instruction(s), calls FUN_005241ca, falls into the block at 0x005241c6
    {load} mov ecx, esi                          # 005241bf
    call FUN_005241ca                            # 005241c1
L_005241c6:
    # block 0x005241c6: entered by je at 0x00524191; jne at 0x005241a1, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 005241c6
    ret 0x4                                      # 005241c7

