# FUN_0051abe4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051abe4
# extent:       0x0051abe4-0x0051ac0b (39 code bytes)
# span:         0x0051abe4-0x0051ac0b (code 39, tables 0, padding 0)
# sha256:       4dc173aa26b08a869a7005fcf3c5876dfc941f2067895fb9a1117de708825065
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051abe4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_0051ab72, FUN_0051f805, FUN_0051d6ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051ab72, .text + (0x0051ab72 - 0x401000)
.set FUN_0051d6ba, .text + (0x0051d6ba - 0x401000)
.set FUN_0051f805, .text + (0x0051f805 - 0x401000)

.org 0x0051abe4 - 0x401000
.globl FUN_0051abe4
FUN_0051abe4:
    # block 0x0051abe4: entry, 16 instruction(s), calls FUN_0051ab72, FUN_0051f805, FUN_0051d6ba, ends with ret 0x4
    push esi                                     # 0051abe4
    push edi                                     # 0051abe5
    push 0x1                                     # 0051abe6
    call FUN_0051ab72                            # 0051abe8
    {load} mov esi, eax                          # 0051abed
    push dword ptr [esp + stk_c]                 # 0051abef
    {load} mov ecx, esi                          # 0051abf3
    call FUN_0051f805                            # 0051abf5
    {load} mov edi, eax                          # 0051abfa
    push esi                                     # 0051abfc
    {load} mov ecx, edi                          # 0051abfd
    call FUN_0051d6ba                            # 0051abff
    {load} mov eax, edi                          # 0051ac04
    pop edi                                      # 0051ac06
    pop esi                                      # 0051ac07
    ret 0x4                                      # 0051ac08

