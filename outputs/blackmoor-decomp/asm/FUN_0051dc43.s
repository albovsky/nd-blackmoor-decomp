# FUN_0051dc43
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dc43
# extent:       0x0051dc43-0x0051dc6c (41 code bytes)
# span:         0x0051dc43-0x0051dc6c (code 41, tables 0, padding 0)
# sha256:       8742f4f439c971b352ccd935acdc8594c7089cc53f734b3c519564515cfd75a2
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dc43
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_0050ea90; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x0051dc43 - 0x401000
.globl FUN_0051dc43
FUN_0051dc43:
    # block 0x0051dc43: entry, 3 instruction(s), falls into the block at 0x0051dc49
    push esi                                     # 0051dc43
    push edi                                     # 0051dc44
    mov edi, dword ptr [esp + stk_c]             # 0051dc45
L_0051dc49:
    # block 0x0051dc49: entered by jne at 0x0051dc65, 6 instruction(s), calls FUN_0050ea90, ends with jne to 0x0051dc67 (forward)
    push edi                                     # 0051dc49
    call FUN_0050ea90                            # 0051dc4a
    {load} mov esi, eax                          # 0051dc4f
    pop ecx                                      # 0051dc51
    test esi, esi                                # 0051dc52
    jne.d8 L_0051dc67                            # 0051dc54
    # block 0x0051dc56: entered by fall-through of jne at 0x0051dc54, 3 instruction(s), ends with je to 0x0051dc67 (forward)
    mov eax, dword ptr [0x567944]                # 0051dc56
    test eax, eax                                # 0051dc5b
    je.d8 L_0051dc67                             # 0051dc5d
    # block 0x0051dc5f: entered by fall-through of je at 0x0051dc5d, 5 instruction(s), calls indirect eax, ends with jne to 0x0051dc49 (backward)
    push edi                                     # 0051dc5f
    call eax                                     # 0051dc60
    test eax, eax                                # 0051dc62
    pop ecx                                      # 0051dc64
    jne.d8 L_0051dc49                            # 0051dc65
L_0051dc67:
    # block 0x0051dc67: entered by jne at 0x0051dc54; je at 0x0051dc5d; fall-through of jne at 0x0051dc65, 4 instruction(s), ends with ret
    {load} mov eax, esi                          # 0051dc67
    pop edi                                      # 0051dc69
    pop esi                                      # 0051dc6a
    ret                                          # 0051dc6b

