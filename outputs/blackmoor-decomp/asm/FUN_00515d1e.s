# FUN_00515d1e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515d1e
# extent:       0x00515d1e-0x00515d2b (13 code bytes)
# span:         0x00515d1e-0x00515d30 (code 13, tables 0, padding 5)
# sha256:       9e9831ee8d77c4162ea99ce40bf182127f15d119f344c0b2e805d685fc8bf024
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00515cc7 (+0x57)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515d1e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!SetUnhandledExceptionFilter
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00515d1e - 0x401000
.globl FUN_00515d1e
FUN_00515d1e:
    # block 0x00515d1e: entry, 3 instruction(s), calls KERNEL32.dll!SetUnhandledExceptionFilter, ends with ret
    push dword ptr [0x63cc50]                    # 00515d1e
    call dword ptr [0x52a1a8]                    # 00515d24
    ret                                          # 00515d2a

# --- data items (not part of the function) -------------------------
.org 0x00515d2b - 0x401000
PAD_00515d2b:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

