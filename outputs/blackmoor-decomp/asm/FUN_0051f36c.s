# FUN_0051f36c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f36c
# extent:       0x0051f36c-0x0051f3ac (64 code bytes)
# span:         0x0051f36c-0x0051f3ac (code 64, tables 0, padding 0)
# sha256:       a9a284418208931a8a0f5625c3d8d0f9fe6b18632148faa50280c5075bf8d973
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f36c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_58; [esi + n] field_30, field_34
# callees:      calls USER32.dll!GetMessageA, USER32.dll!TranslateMessage, USER32.dll!DispatchMessageA; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051f3ac
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_58, 0x58  # offset +0x58

# --- external targets -----------------------------------------------

.org 0x0051f36c - 0x401000
.globl FUN_0051f36c
FUN_0051f36c:
    # block 0x0051f36c: entry, 12 instruction(s), calls USER32.dll!GetMessageA, ends with je to 0x0051f3a9 (forward)
    push esi                                     # 0051f36c
    {load} mov esi, ecx                          # 0051f36d
    {load} xor eax, eax                          # 0051f36f
    push edi                                     # 0051f371
    push eax                                     # 0051f372
    lea edi, [esi + field_30]                    # 0051f373
    push eax                                     # 0051f376
    push eax                                     # 0051f377
    push edi                                     # 0051f378
    call dword ptr [0x52a36c]                    # 0051f379
    test eax, eax                                # 0051f37f
    je.d8 L_0051f3a9                             # 0051f381
    # block 0x0051f383: entered by fall-through of je at 0x0051f381, 2 instruction(s), ends with je to 0x0051f3a6 (forward)
    cmp dword ptr [esi + field_34], 0x36a        # 0051f383
    je.d8 L_0051f3a6                             # 0051f38a
    # block 0x0051f38c: entered by fall-through of je at 0x0051f38a, 6 instruction(s), calls indirect dword ptr [eax + 0x58], ends with jne to 0x0051f3a6 (forward)
    mov eax, dword ptr [esi]                     # 0051f38c
    push edi                                     # 0051f38e
    {load} mov ecx, esi                          # 0051f38f
    call dword ptr [eax + field_58]              # 0051f391
    test eax, eax                                # 0051f394
    jne.d8 L_0051f3a6                            # 0051f396
    # block 0x0051f398: entered by fall-through of jne at 0x0051f396, 4 instruction(s), calls USER32.dll!TranslateMessage, USER32.dll!DispatchMessageA, falls into the block at 0x0051f3a6
    push edi                                     # 0051f398
    call dword ptr [0x52a368]                    # 0051f399
    push edi                                     # 0051f39f
    call dword ptr [0x52a30c]                    # 0051f3a0
L_0051f3a6:
    # block 0x0051f3a6: entered by je at 0x0051f38a; jne at 0x0051f396, 2 instruction(s), falls into the block at 0x0051f3a9
    push 0x1                                     # 0051f3a6
    pop eax                                      # 0051f3a8
L_0051f3a9:
    # block 0x0051f3a9: entered by je at 0x0051f381, 3 instruction(s), ends with ret
    pop edi                                      # 0051f3a9
    pop esi                                      # 0051f3aa
    ret                                          # 0051f3ab

