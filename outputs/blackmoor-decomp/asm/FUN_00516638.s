# FUN_00516638
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516638
# extent:       0x00516638-0x00516650 (24 code bytes)
# span:         0x00516638-0x00516650 (code 24, tables 0, padding 0)
# sha256:       d883fc51d1757d66f736be45cfa063089fb8d453bd7541b320c1a6447b0b6a31
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_IsBadCodePtr
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists KERNEL32.dll!IsBadCodePtr as the only import of the 24-byte function and no callee
# name-note:    A 24-byte leaf function with no direct callee whose only external call is KERNEL32.dll!IsBadCodePtr
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls KERNEL32.dll!IsBadCodePtr
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00516638 - 0x401000
.globl FUN_00516638
FUN_00516638:
    # block 0x00516638: entry, 7 instruction(s), calls KERNEL32.dll!IsBadCodePtr, ends with je to 0x0051664c (forward)
    push esi                                     # 00516638
    push 0x1                                     # 00516639
    pop esi                                      # 0051663b
    push dword ptr [esp + stk_8]                 # 0051663c
    call dword ptr [0x52a1b8]                    # 00516640
    test eax, eax                                # 00516646
    je.d8 L_0051664c                             # 00516648
    # block 0x0051664a: entered by fall-through of je at 0x00516648, 1 instruction(s), falls into the block at 0x0051664c
    {load} xor esi, esi                          # 0051664a
L_0051664c:
    # block 0x0051664c: entered by je at 0x00516648, 3 instruction(s), ends with ret
    {load} mov eax, esi                          # 0051664c
    pop esi                                      # 0051664e
    ret                                          # 0051664f

