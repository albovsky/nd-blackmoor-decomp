# FUN_00511850
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511850
# extent:       0x00511850-0x00511888 (56 code bytes)
# span:         0x00511850-0x00511888 (code 56, tables 0, padding 0)
# sha256:       9bfcb6c87e82e7113264f86175a304743888349564947d1146fe8ecdccf6f9ee
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511850
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c, stk_10, stk_1c
# callees:      calls FUN_005117ea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_005117ea, .text + (0x005117ea - 0x401000)

.org 0x00511850 - 0x401000
.globl FUN_00511850
FUN_00511850:
    # block 0x00511850: entry, 8 instruction(s), ends with jle to 0x00511884 (forward)
    push ebx                                     # 00511850
    mov ebx, dword ptr [esp + stk_c]             # 00511851
    {load} mov eax, ebx                          # 00511855
    dec ebx                                      # 00511857
    push esi                                     # 00511858
    push edi                                     # 00511859
    test eax, eax                                # 0051185a
    jle.d8 L_00511884                            # 0051185c
    # block 0x0051185e: entered by fall-through of jle at 0x0051185c, 2 instruction(s), falls into the block at 0x00511866
    mov edi, dword ptr [esp + stk_1c]            # 0051185e
    mov esi, dword ptr [esp + stk_10]            # 00511862
L_00511866:
    # block 0x00511866: entered by jg at 0x00511882, 9 instruction(s), calls FUN_005117ea, ends with je to 0x00511884 (forward)
    movsx eax, byte ptr [esi]                    # 00511866
    push edi                                     # 00511869
    inc esi                                      # 0051186a
    push dword ptr [esp + stk_1c]                # 0051186b
    push eax                                     # 0051186f
    call FUN_005117ea                            # 00511870
    add esp, 0xc                                 # 00511875
    cmp dword ptr [edi], -0x1                    # 00511878
    je.d8 L_00511884                             # 0051187b
    # block 0x0051187d: entered by fall-through of je at 0x0051187b, 4 instruction(s), ends with jg to 0x00511866 (backward)
    {load} mov eax, ebx                          # 0051187d
    dec ebx                                      # 0051187f
    test eax, eax                                # 00511880
    jg.d8 L_00511866                             # 00511882
L_00511884:
    # block 0x00511884: entered by jle at 0x0051185c; je at 0x0051187b; fall-through of jg at 0x00511882, 4 instruction(s), ends with ret
    pop edi                                      # 00511884
    pop esi                                      # 00511885
    pop ebx                                      # 00511886
    ret                                          # 00511887

