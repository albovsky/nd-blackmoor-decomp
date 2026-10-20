# FUN_0051661c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051661c
# extent:       0x0051661c-0x00516638 (28 code bytes)
# span:         0x0051661c-0x00516638 (code 28, tables 0, padding 0)
# sha256:       d6571d527e55e3dc128d978ceb1c42730340f13feb6c2a009f7c38860d01e291
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_only_call_IsBadWritePtr
# naming:       INFERRED (lower confidence, not verified): function-xrefs.json lists KERNEL32.dll!IsBadWritePtr as the only import of the 28-byte function and no callee
# name-note:    A 28-byte leaf function with no direct callee whose only external call is KERNEL32.dll!IsBadWritePtr
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls KERNEL32.dll!IsBadWritePtr
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0051661c - 0x401000
.globl FUN_0051661c
FUN_0051661c:
    # block 0x0051661c: entry, 8 instruction(s), calls KERNEL32.dll!IsBadWritePtr, ends with je to 0x00516634 (forward)
    push esi                                     # 0051661c
    push 0x1                                     # 0051661d
    pop esi                                      # 0051661f
    push dword ptr [esp + stk_c]                 # 00516620
    push dword ptr [esp + stk_c]                 # 00516624
    call dword ptr [0x52a1a4]                    # 00516628
    test eax, eax                                # 0051662e
    je.d8 L_00516634                             # 00516630
    # block 0x00516632: entered by fall-through of je at 0x00516630, 1 instruction(s), falls into the block at 0x00516634
    {load} xor esi, esi                          # 00516632
L_00516634:
    # block 0x00516634: entered by je at 0x00516630, 3 instruction(s), ends with ret
    {load} mov eax, esi                          # 00516634
    pop esi                                      # 00516636
    ret                                          # 00516637

