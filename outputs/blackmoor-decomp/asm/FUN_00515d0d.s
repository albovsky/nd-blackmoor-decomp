# FUN_00515d0d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515d0d
# extent:       0x00515d0d-0x00515d1e (17 code bytes)
# span:         0x00515d0d-0x00515d1e (code 17, tables 0, padding 0)
# sha256:       a705ecfbdfd4362c08581489f6e839f4aedc93276df73d8b292aad8b60f621c9
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00515cc7 (+0x46)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515d0d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!SetUnhandledExceptionFilter
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00515d1e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00515d0d - 0x401000
.globl FUN_00515d0d
FUN_00515d0d:
    # block 0x00515d0d: entry, 4 instruction(s), calls KERNEL32.dll!SetUnhandledExceptionFilter, ends with ret
    push 0x515cc7                                # 00515d0d
    call dword ptr [0x52a1a8]                    # 00515d12
    mov dword ptr [0x63cc50], eax                # 00515d18
    ret                                          # 00515d1d

