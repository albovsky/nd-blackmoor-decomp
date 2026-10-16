# FUN_0050eaa2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050eaa2
# extent:       0x0050eaa2-0x0050eace (44 code bytes)
# span:         0x0050eaa2-0x0050eace (code 44, tables 0, padding 0)
# sha256:       0d107976ffdb35c84dc999ec703b8d8dedb5ab2531c486d4ee88014c0b583e9f
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050eaa2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      calls FUN_0050eace, FUN_00515a64
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050eace, .text + (0x0050eace - 0x401000)
.set FUN_00515a64, .text + (0x00515a64 - 0x401000)

.org 0x0050eaa2 - 0x401000
.globl FUN_0050eaa2
FUN_0050eaa2:
    # block 0x0050eaa2: entry, 2 instruction(s), ends with ja to 0x0050eacb (forward)
    cmp dword ptr [esp + stk_4], -0x20           # 0050eaa2
    ja.d8 L_0050eacb                             # 0050eaa7
L_0050eaa9:
    # block 0x0050eaa9: entered by jne at 0x0050eac9; fall-through of ja at 0x0050eaa7, 5 instruction(s), calls FUN_0050eace, ends with jne to 0x0050eacd (forward)
    push dword ptr [esp + stk_4]                 # 0050eaa9
    call FUN_0050eace                            # 0050eaad
    test eax, eax                                # 0050eab2
    pop ecx                                      # 0050eab4
    jne.d8 L_0050eacd                            # 0050eab5
    # block 0x0050eab7: entered by fall-through of jne at 0x0050eab5, 2 instruction(s), ends with je to 0x0050eacd (forward)
    cmp dword ptr [esp + stk_8], eax             # 0050eab7
    je.d8 L_0050eacd                             # 0050eabb
    # block 0x0050eabd: entered by fall-through of je at 0x0050eabb, 5 instruction(s), calls FUN_00515a64, ends with jne to 0x0050eaa9 (backward)
    push dword ptr [esp + stk_4]                 # 0050eabd
    call FUN_00515a64                            # 0050eac1
    test eax, eax                                # 0050eac6
    pop ecx                                      # 0050eac8
    jne.d8 L_0050eaa9                            # 0050eac9
L_0050eacb:
    # block 0x0050eacb: entered by ja at 0x0050eaa7; fall-through of jne at 0x0050eac9, 1 instruction(s), falls into the block at 0x0050eacd
    {load} xor eax, eax                          # 0050eacb
L_0050eacd:
    # block 0x0050eacd: entered by jne at 0x0050eab5; je at 0x0050eabb, 1 instruction(s), ends with ret
    ret                                          # 0050eacd

