# FUN_00521ed5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521ed5
# extent:       0x00521ed5-0x00521ef1 (28 code bytes)
# span:         0x00521ed5-0x00521ef1 (code 28, tables 0, padding 0)
# sha256:       cdf05f0760125cdf644b054f80e0167c522ff3b27192ec92d573dfb7fbd2f2b7
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521ed5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00521fa5, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_00521fa5, .text + (0x00521fa5 - 0x401000)

.org 0x00521ed5 - 0x401000
.globl FUN_00521ed5
FUN_00521ed5:
    # block 0x00521ed5: entry, 5 instruction(s), calls FUN_00521fa5, ends with je to 0x00521eeb (forward)
    push esi                                     # 00521ed5
    {load} mov esi, ecx                          # 00521ed6
    call FUN_00521fa5                            # 00521ed8
    test byte ptr [esp + stk_8], 0x1             # 00521edd
    je.d8 L_00521eeb                             # 00521ee2
    # block 0x00521ee4: entered by fall-through of je at 0x00521ee2, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00521eeb
    push esi                                     # 00521ee4
    call FUN_0051dc6c                            # 00521ee5
    pop ecx                                      # 00521eea
L_00521eeb:
    # block 0x00521eeb: entered by je at 0x00521ee2, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00521eeb
    pop esi                                      # 00521eed
    ret 0x4                                      # 00521eee

