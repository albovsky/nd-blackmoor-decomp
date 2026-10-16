# FUN_00525dac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525dac
# extent:       0x00525dac-0x00525dce (34 code bytes)
# span:         0x00525dac-0x00525dce (code 34, tables 0, padding 0)
# sha256:       c806a7e2272e4d47c1fdb4ffc7f876442893482f0934f10fef8591d0bbe074b6
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525dac
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00525dac - 0x401000
.globl FUN_00525dac
FUN_00525dac:
    # block 0x00525dac: entry, 11 instruction(s), calls indirect esi, ends with ret
    push esi                                     # 00525dac
    mov esi, dword ptr [0x52a498]                # 00525dad
    push 0x2                                     # 00525db3
    call esi                                     # 00525db5
    push 0x3                                     # 00525db7
    mov dword ptr [0x63c748], eax                # 00525db9
    call esi                                     # 00525dbe
    and dword ptr [0x63c7b0], 0x0                # 00525dc0
    mov dword ptr [0x63c74c], eax                # 00525dc7
    pop esi                                      # 00525dcc
    ret                                          # 00525dcd

