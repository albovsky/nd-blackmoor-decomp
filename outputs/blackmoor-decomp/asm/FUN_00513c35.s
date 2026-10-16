# FUN_00513c35
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513c35
# extent:       0x00513c35-0x00513c4c (23 code bytes)
# span:         0x00513c35-0x00513c4c (code 23, tables 0, padding 0)
# sha256:       e6ec999d45c3c78e22ed722d9cdd003ca3e8685d7954a7d030915df1e55eb902
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513c35
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_6
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_6, 0x6  # offset +0x6

# --- external targets -----------------------------------------------

.org 0x00513c35 - 0x401000
.globl FUN_00513c35
FUN_00513c35:
    # block 0x00513c35: entry, 6 instruction(s), ends with ret
    mov edx, dword ptr [esp + stk_4]             # 00513c35
    and edx, 0x300                               # 00513c39
    or edx, 0x7f                                 # 00513c3f
    mov word ptr [esp + stk_6], dx               # 00513c42
    fldcw word ptr [esp + stk_6]                 # 00513c47
    ret                                          # 00513c4b

