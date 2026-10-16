# FUN_00525367
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525367
# extent:       0x00525367-0x00525371 (10 code bytes)
# span:         0x00525367-0x00525371 (code 10, tables 0, padding 0)
# sha256:       90411439be68012d08aca4b9605745bee1ff6079ee4fdb20a8862ead43bd63b1
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052535b (+0xc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525367
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump LOC_00524fe2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set LOC_00524fe2, .text + (0x00524fe2 - 0x401000)

.org 0x00525367 - 0x401000
.globl FUN_00525367
FUN_00525367:
    # block 0x00525367: entry, 2 instruction(s), ends with backward jump to 0x00524fe2
    mov ecx, 0x63c440                            # 00525367
    jmp.d32 LOC_00524fe2                         # 0052536c

