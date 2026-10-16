# FUN_0051a8b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a8b0
# extent:       0x0051a8b0-0x0051a8d3 (35 code bytes)
# span:         0x0051a8b0-0x0051a8d3 (code 35, tables 0, padding 0)
# sha256:       6a3d5df2bccf947cbfb22d62df9cf9195cce75dc2d247e4ce2b7eabbfe6145d0
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a8b0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1c; [esp + n] stk_8, stk_c, stk_10
# callees:      calls USER32.dll!GetWindowRect, FUN_0051d526
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)

.org 0x0051a8b0 - 0x401000
.globl FUN_0051a8b0
FUN_0051a8b0:
    # block 0x0051a8b0: entry, 11 instruction(s), calls USER32.dll!GetWindowRect, FUN_0051d526, ends with ret 0xc
    push esi                                     # 0051a8b0
    mov esi, dword ptr [esp + stk_8]             # 0051a8b1
    push dword ptr [esp + stk_c]                 # 0051a8b5
    push dword ptr [esi + field_1c]              # 0051a8b9
    call dword ptr [0x52a46c]                    # 0051a8bc
    {load} mov ecx, esi                          # 0051a8c2
    call FUN_0051d526                            # 0051a8c4
    mov ecx, dword ptr [esp + stk_10]            # 0051a8c9
    pop esi                                      # 0051a8cd
    mov dword ptr [ecx], eax                     # 0051a8ce
    ret 0xc                                      # 0051a8d0

