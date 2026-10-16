# FUN_0050f978
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f978
# extent:       0x0050f978-0x0050f997 (31 code bytes)
# span:         0x0050f978-0x0050f997 (code 31, tables 0, padding 0)
# sha256:       7f8b0849af9dd6f8eaa8c1e19d51a2bbb461b2c4c14fa3f213efa88cd3a7fc95
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f978
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050f978 - 0x401000
.globl FUN_0050f978
FUN_0050f978:
    # block 0x0050f978: entry, 10 instruction(s), ends with ret
    push -0x1                                    # 0050f978
    push eax                                     # 0050f97a
    mov eax, dword ptr fs:[0x0]                  # 0050f97b
    push eax                                     # 0050f981
    mov eax, dword ptr [esp + stk_c]             # 0050f982
    mov dword ptr fs:[0x0], esp                  # 0050f986
    mov dword ptr [esp + stk_c], ebp             # 0050f98d
    lea ebp, [esp + stk_c]                       # 0050f991
    push eax                                     # 0050f995
    ret                                          # 0050f996

