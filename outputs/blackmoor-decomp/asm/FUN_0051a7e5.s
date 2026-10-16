# FUN_0051a7e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a7e5
# extent:       0x0051a7e5-0x0051a801 (28 code bytes)
# span:         0x0051a7e5-0x0051a801 (code 28, tables 0, padding 0)
# sha256:       7f035def03fee4411698ef17680ac58d48b601d5a90dc2b89583163afa9e4069
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a7e5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0051b257, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0051a7e5 - 0x401000
.globl FUN_0051a7e5
FUN_0051a7e5:
    # block 0x0051a7e5: entry, 5 instruction(s), calls FUN_0051b257, ends with je to 0x0051a7fb (forward)
    push esi                                     # 0051a7e5
    {load} mov esi, ecx                          # 0051a7e6
    call FUN_0051b257                            # 0051a7e8
    test byte ptr [esp + stk_8], 0x1             # 0051a7ed
    je.d8 L_0051a7fb                             # 0051a7f2
    # block 0x0051a7f4: entered by fall-through of je at 0x0051a7f2, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0051a7fb
    push esi                                     # 0051a7f4
    call FUN_0051dc6c                            # 0051a7f5
    pop ecx                                      # 0051a7fa
L_0051a7fb:
    # block 0x0051a7fb: entered by je at 0x0051a7f2, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0051a7fb
    pop esi                                      # 0051a7fd
    ret 0x4                                      # 0051a7fe

