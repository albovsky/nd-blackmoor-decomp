# FUN_0050d6cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d6cf
# extent:       0x0050d6cf-0x0050d6f7 (40 code bytes)
# span:         0x0050d6cf-0x0050d6f7 (code 40, tables 0, padding 0)
# sha256:       5a4f9c5bb9d056c746b72ba79a5839600386e39e53f47cc259ba0410c1d7b626
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d6cf
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      calls FUN_005118b3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005118b3, .text + (0x005118b3 - 0x401000)

.org 0x0050d6cf - 0x401000
.globl FUN_0050d6cf
FUN_0050d6cf:
    # block 0x0050d6cf: entry, 2 instruction(s), ends with jle to 0x0050d6e6 (forward)
    cmp dword ptr [0x56840c], 0x1                # 0050d6cf
    jle.d8 L_0050d6e6                            # 0050d6d6
    # block 0x0050d6d8: entered by fall-through of jle at 0x0050d6d6, 6 instruction(s), calls FUN_005118b3, ends with ret
    push 0x4                                     # 0050d6d8
    push dword ptr [esp + stk_8]                 # 0050d6da
    call FUN_005118b3                            # 0050d6de
    pop ecx                                      # 0050d6e3
    pop ecx                                      # 0050d6e4
    ret                                          # 0050d6e5
L_0050d6e6:
    # block 0x0050d6e6: entered by jle at 0x0050d6d6, 5 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050d6e6
    mov ecx, dword ptr [0x568200]                # 0050d6ea
    mov al, byte ptr [ecx + 2*eax]               # 0050d6f0
    and eax, 0x4                                 # 0050d6f3
    ret                                          # 0050d6f6

