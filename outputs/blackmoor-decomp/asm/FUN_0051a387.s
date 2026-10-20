# FUN_0051a387
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a387
# extent:       0x0051a387-0x0051a3b0 (41 code bytes)
# span:         0x0051a387-0x0051a3b0 (code 41, tables 0, padding 0)
# sha256:       d103721650bb4484ffbeb4d1cef622676dff4c4fe98ecbe40929d8ff0c71d3a0
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         AddTail
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8; [esi + n] field_4, field_8; [esp + n] stk_8
# callees:      calls FUN_0051a316
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051a316, .text + (0x0051a316 - 0x401000)

.org 0x0051a387 - 0x401000
.globl FUN_0051a387
FUN_0051a387:
    # block 0x0051a387: entry, 10 instruction(s), calls FUN_0051a316, ends with je to 0x0051a3a6 (forward)
    push esi                                     # 0051a387
    {load} mov esi, ecx                          # 0051a388
    push 0x0                                     # 0051a38a
    push dword ptr [esi + field_8]               # 0051a38c
    call FUN_0051a316                            # 0051a38f
    mov ecx, dword ptr [esp + stk_8]             # 0051a394
    mov dword ptr [eax + field_8], ecx           # 0051a398
    mov ecx, dword ptr [esi + field_8]           # 0051a39b
    test ecx, ecx                                # 0051a39e
    je.d8 L_0051a3a6                             # 0051a3a0
    # block 0x0051a3a2: entered by fall-through of je at 0x0051a3a0, 2 instruction(s), ends with forward jump to 0x0051a3a9
    mov dword ptr [ecx], eax                     # 0051a3a2
    jmp.d8 L_0051a3a9                            # 0051a3a4
L_0051a3a6:
    # block 0x0051a3a6: entered by je at 0x0051a3a0, 1 instruction(s), falls into the block at 0x0051a3a9
    mov dword ptr [esi + field_4], eax           # 0051a3a6
L_0051a3a9:
    # block 0x0051a3a9: entered by jmp at 0x0051a3a4, 3 instruction(s), ends with ret 0x4
    mov dword ptr [esi + field_8], eax           # 0051a3a9
    pop esi                                      # 0051a3ac
    ret 0x4                                      # 0051a3ad

