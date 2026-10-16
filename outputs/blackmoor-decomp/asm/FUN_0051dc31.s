# FUN_0051dc31
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dc31
# extent:       0x0051dc31-0x0051dc43 (18 code bytes)
# span:         0x0051dc31-0x0051dc43 (code 18, tables 0, padding 0)
# sha256:       713603dfdda009cda35fa4759109eff642aa285d4b4601e067d065945ce0e76d
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dc31
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0051dc31 - 0x401000
.globl FUN_0051dc31
FUN_0051dc31:
    # block 0x0051dc31: entry, 4 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [esp + stk_4]             # 0051dc31
    mov eax, dword ptr [0x567944]                # 0051dc35
    mov dword ptr [0x567944], ecx                # 0051dc3a
    ret 0x4                                      # 0051dc40

