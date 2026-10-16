# FUN_00516600
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516600
# extent:       0x00516600-0x0051661c (28 code bytes)
# span:         0x00516600-0x0051661c (code 28, tables 0, padding 0)
# sha256:       58baaeeaae4e3603dc03c993bbe0757791bb2acbfda43cf6e85728a93151e537
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516600
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls KERNEL32.dll!IsBadReadPtr
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00516600 - 0x401000
.globl FUN_00516600
FUN_00516600:
    # block 0x00516600: entry, 8 instruction(s), calls KERNEL32.dll!IsBadReadPtr, ends with je to 0x00516618 (forward)
    push esi                                     # 00516600
    push 0x1                                     # 00516601
    pop esi                                      # 00516603
    push dword ptr [esp + stk_c]                 # 00516604
    push dword ptr [esp + stk_c]                 # 00516608
    call dword ptr [0x52a1b4]                    # 0051660c
    test eax, eax                                # 00516612
    je.d8 L_00516618                             # 00516614
    # block 0x00516616: entered by fall-through of je at 0x00516614, 1 instruction(s), falls into the block at 0x00516618
    {load} xor esi, esi                          # 00516616
L_00516618:
    # block 0x00516618: entered by je at 0x00516614, 3 instruction(s), ends with ret
    {load} mov eax, esi                          # 00516618
    pop esi                                      # 0051661a
    ret                                          # 0051661b

